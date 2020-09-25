Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556F5278B0E
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 16:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgIYOjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 10:39:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47014 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728802AbgIYOjE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 10:39:04 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601044743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Lt1j6BM1xEtBjnoIfN9ATzwZj+difO86HoNV3rPN9XU=;
        b=YfJ9lAO7+xP9mIX7LYUr1WY9+E8ebuIViPVZmkwY5QfPbAs0hJpmb199uhmV5tr4Yr1yQv
        emSvRp10FlJaNCrnYGShW2K2tq3fEP3ZmlDL/fIq8BFCkVgQgHJWJSrjDpxgoiIx2SxppG
        Vq2yXROmmUYwanMIS7dfSqPLByhC6NQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-0dB5dzNsP6CZXW2-u3PkHA-1; Fri, 25 Sep 2020 10:39:01 -0400
X-MC-Unique: 0dB5dzNsP6CZXW2-u3PkHA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27B231017DE4
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:39:00 +0000 (UTC)
Received: from thuth.com (ovpn-112-251.ams2.redhat.com [10.36.112.251])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 661C26198B;
        Fri, 25 Sep 2020 14:38:54 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH] configure: Add a check for the bash version
Date:   Fri, 25 Sep 2020 16:38:52 +0200
Message-Id: <20200925143852.227908-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our scripts do not work with older versions of the bash, like the
default Bash 3 from macOS (e.g. we use the "|&" operator which has
been introduced in Bash 4.0). Add a check to make sure that we use
at least version 4 to avoid that the users run into problems later.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 configure | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/configure b/configure
index f930543..39b63ae 100755
--- a/configure
+++ b/configure
@@ -1,5 +1,10 @@
 #!/usr/bin/env bash
 
+if [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ] ; then
+    echo "Error: Bash version 4 or newer is required for the kvm-unit-tests"
+    exit 1
+fi
+
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
-- 
2.18.2

