Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C2E28E36F
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 17:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgJNPnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 11:43:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726954AbgJNPnE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 11:43:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602690183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Tt3lce95cbC+mW0urx5sc6gHao7nV9e5qYYhDPu3nuY=;
        b=CBp4B1EX+qDNV2BNpUtQLy1cqEfagoNQ5MYGcWe6CVdSQBIBXoVJuCvziYH9UUKA/6wSUW
        i4KGiiNs9I8Ks+2sOgDoNiYWoNq9GiiIdr34DLE/MLzX6yyahl3GEMT7Tv349gabJnM65E
        67uZzPqz2RVtR26WpcyxGXc9bszKB9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-m7za7t61M726hxser23Faw-1; Wed, 14 Oct 2020 11:43:01 -0400
X-MC-Unique: m7za7t61M726hxser23Faw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90396801FDD
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 15:43:00 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D52C1002C00;
        Wed, 14 Oct 2020 15:42:58 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests] runtime.bash: skip test when checked file doesn't exist
Date:   Wed, 14 Oct 2020 17:42:58 +0200
Message-Id: <20201014154258.2437510-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, we have the following check condition in x86/unittests.cfg:

check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y

the check, however, passes successfully on AMD because the checked file
is just missing. This doesn't sound right, reverse the check: fail
if the content of the file doesn't match the expectation or if the
file is not there.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 scripts/runtime.bash | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 3121c1ffdae8..f94c094de03b 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -118,7 +118,10 @@ function run()
     for check_param in "${check[@]}"; do
         path=${check_param%%=*}
         value=${check_param#*=}
-        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
+	if [ -z "$path" ]; then
+            continue
+	fi
+        if [ ! -f "$path" ] || [ "$(cat $path)" != "$value" ]; then
             print_result "SKIP" $testname "" "$path not equal to $value"
             return 2
         fi
-- 
2.25.4

