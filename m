Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBE728EEA3
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 10:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbgJOIiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 04:38:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729723AbgJOIiP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 04:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602751094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6jK4Ei2H315PjcLRzKj4JaFTscxNE7NtNEtqf0KEIlI=;
        b=ZfmC8ovoxEbxquSK2CqF0s+xhiaeoKO0KatslQ+uA4o6cXxT2rNvROyMQgxsHb1bYNXwlZ
        uTeuNgccgDjteM529AEdLj3CIJofcCyn5wJrVvz4xiIns1VgR1UsDcn2ghWl5Mq3ioGVKj
        /lbfT30jTrQcYLFR6PRpVdCwQ2scHJA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-qUiGZwBFMqSPwE5eBB0Jvg-1; Thu, 15 Oct 2020 04:38:13 -0400
X-MC-Unique: qUiGZwBFMqSPwE5eBB0Jvg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 008E864082
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 08:38:12 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B3255D9CD;
        Thu, 15 Oct 2020 08:38:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: [PATCH v2 kvm-unit-tests] runtime.bash: skip test when checked file doesn't exist
Date:   Thu, 15 Oct 2020 10:38:08 +0200
Message-Id: <20201015083808.2488268-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
Changes since v1:
- tabs -> spaces [Thomas]
---
 scripts/runtime.bash | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 3121c1ffdae8..99d242d5cf8c 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -118,7 +118,10 @@ function run()
     for check_param in "${check[@]}"; do
         path=${check_param%%=*}
         value=${check_param#*=}
-        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
+        if [ -z "$path" ]; then
+            continue
+        fi
+        if [ ! -f "$path" ] || [ "$(cat $path)" != "$value" ]; then
             print_result "SKIP" $testname "" "$path not equal to $value"
             return 2
         fi
-- 
2.25.4

