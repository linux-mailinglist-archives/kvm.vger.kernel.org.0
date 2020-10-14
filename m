Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A35328E71C
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 21:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390404AbgJNTOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 15:14:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390300AbgJNTOx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 15:14:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602702892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T9Sg9MTR1XJhoLcvn5MHOoH5SVTTj5ED5zTQGoQfNaQ=;
        b=QRtX5wNxHNiIRaWJtCV7p4vi2Zz3YuddvAwOqhBWezcOOMJ7JZ9sTcxTsT0k65n6r5WZG3
        o0H3kfbahEF/ICJAnh5Cr8cTUx+r1Nq8yKvXjpN+PoQfkia/UPOCPngQlOdIE45ddvKxCu
        dKtCm3lAf0OLMLa0/okS00E41b/4Vu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-90yb94V0ODuiQMM6vw97bg-1; Wed, 14 Oct 2020 15:14:50 -0400
X-MC-Unique: 90yb94V0ODuiQMM6vw97bg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11A11E9000
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 19:14:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0AAE75131;
        Wed, 14 Oct 2020 19:14:48 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: [PATCH kvm-unit-tests 2/3] scripts: Save rematch before calling out of for_each_unittest
Date:   Wed, 14 Oct 2020 21:14:43 +0200
Message-Id: <20201014191444.136782-3-drjones@redhat.com>
In-Reply-To: <20201014191444.136782-1-drjones@redhat.com>
References: <20201014191444.136782-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we don't save BASH_REMATCH before calling another function,
and that other function also uses [[...]], then we'll lose the
test.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 scripts/common.bash | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index a6044b7c6c35..7b983f7d6dd6 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -13,15 +13,17 @@ function for_each_unittest()
 	local check
 	local accel
 	local timeout
+	local rematch
 
 	exec {fd}<"$unittests"
 
 	while read -r -u $fd line; do
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
+			rematch=${BASH_REMATCH[1]}
 			if [ -n "${testname}" ]; then
 				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 			fi
-			testname=${BASH_REMATCH[1]}
+			testname=$rematch
 			smp=1
 			kernel=""
 			opts=""
-- 
2.26.2

