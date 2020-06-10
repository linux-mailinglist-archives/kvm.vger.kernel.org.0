Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE051F5658
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 15:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbgFJN7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 09:59:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24314 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729600AbgFJN7D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 09:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591797542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MKG8WBRAmuO518GhaaF1JZ9zycOOCQixu10amJRUFHs=;
        b=NIlVESOlwiz13EHZssJna35PVo5CJBRPnLruuVlYdvDrypuC1PQra4D1K/T00HOgQrl6z2
        N338ghH/XeRkvgQTLDjjv1o1yAbUTdEQMXsgZeifApBFBRPgGU7rc3qcaOh05tKFwf4T91
        w8QpqtC9ltWXBBySKPK9k/e3IPmNREU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-A4pI4z7xPcSiLi8q9z48vQ-1; Wed, 10 Jun 2020 09:59:00 -0400
X-MC-Unique: A4pI4z7xPcSiLi8q9z48vQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2733835B74;
        Wed, 10 Jun 2020 13:58:59 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 861805C1BD;
        Wed, 10 Jun 2020 13:58:55 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: selftests: Don't probe KVM_CAP_HYPERV_ENLIGHTENED_VMCS when nested VMX is unsupported
Date:   Wed, 10 Jun 2020 15:58:47 +0200
Message-Id: <20200610135847.754289-3-vkuznets@redhat.com>
In-Reply-To: <20200610135847.754289-1-vkuznets@redhat.com>
References: <20200610135847.754289-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_HYPERV_ENLIGHTENED_VMCS will be reported as supported even when
nested VMX is not, fix evmcs_test/hyperv_cpuid tests to check for both.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/evmcs_test.c   | 5 +++--
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index e6e62e5e75b2..757928199f19 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -94,9 +94,10 @@ int main(int argc, char *argv[])
 
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
-	if (!kvm_check_cap(KVM_CAP_NESTED_STATE) ||
+	if (!nested_vmx_supported() ||
+	    !kvm_check_cap(KVM_CAP_NESTED_STATE) ||
 	    !kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
-		print_skip("capabilities not available");
+		print_skip("Enlightened VMCS is unsupported");
 		exit(KSFT_SKIP);
 	}
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 4a7967cca281..745b708c2d3b 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -170,7 +170,8 @@ int main(int argc, char *argv[])
 		case 1:
 			break;
 		case 2:
-			if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
+			if (!nested_vmx_supported() ||
+			    !kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
 				print_skip("Enlightened VMCS is unsupported");
 				continue;
 			}
-- 
2.25.4

