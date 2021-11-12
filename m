Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1663544E77D
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 14:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhKLNkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 08:40:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231436AbhKLNkl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 08:40:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636724271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YU5hfpJqAc3Pn3MPWNMlEEHUbhpJegaxPbnsaOM3Lug=;
        b=XskL8DJJscVNG+etvHNhlAJy5TAuBO9tt8YEkDWpCiZtJiXoqCA0mXNL7ZoCQ6K3aSR2cP
        ceTCqetcYVgyKazOi1W9DQGp8fKVeG+2rQm3Brq0wfKv7cM4NeqBYtyv35qwUqTdID8xCa
        b12J0rQb010d0zV34xt73xvsDKKDHPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-P0JlMuxEM86-9VV5HAQXwg-1; Fri, 12 Nov 2021 08:37:47 -0500
X-MC-Unique: P0JlMuxEM86-9VV5HAQXwg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6519420E4;
        Fri, 12 Nov 2021 13:37:46 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.194.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CEB660862;
        Fri, 12 Nov 2021 13:37:44 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, marcorr@google.com,
        zxwang42@gmail.com
Subject: [PATCH kvm-unit-tests 2/2] runtime: Use find_word with groups
Date:   Fri, 12 Nov 2021 14:37:39 +0100
Message-Id: <20211112133739.103327-3-drjones@redhat.com>
In-Reply-To: <20211112133739.103327-1-drjones@redhat.com>
References: <20211112133739.103327-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Groups are space separated, so we can remove the 'grep -w', which has
caused problems in the past with testnames, see b373304853a0
("scripts: Fix the check whether testname is in the only_tests list")
and use find_word.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 scripts/runtime.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 132389c7dd59..4deb41ca251c 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -132,7 +132,7 @@ function run()
     }
 
     cmdline=$(get_cmdline $kernel)
-    if grep -qw "migration" <<<$groups ; then
+    if find_word "migration" "$groups"; then
         cmdline="MIGRATION=yes $cmdline"
     fi
     if [ "$verbose" = "yes" ]; then
-- 
2.31.1

