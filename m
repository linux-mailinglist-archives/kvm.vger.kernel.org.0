Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816DF11404A
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 12:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbfLELqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 06:46:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25280 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729017AbfLELqG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Dec 2019 06:46:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575546364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=brfZ3p50zIdamnJ/W/WXUy+dYL7Eu1xgZlHRzKOlYxA=;
        b=Gu//v4VEC4yRlIN4a0fmXT+7W/C3B+PtvNOk64xaYFBeBlUa41caOl68r4s1x9In90O/Pn
        EtuxODwjUdbG72pP9E5KUok8S9KzN2wLwRC23ju6FvoMn2ZV0Oj6g4pG1fZytP7AIfTKHF
        stDi9U8iumEql3nkyAI1q/vXGApSlj8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-44Co00RmNz6j7SCjqeTHwA-1; Thu, 05 Dec 2019 06:46:00 -0500
Received: by mail-wr1-f69.google.com with SMTP id u12so1414307wrt.15
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 03:46:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=brfZ3p50zIdamnJ/W/WXUy+dYL7Eu1xgZlHRzKOlYxA=;
        b=opTbzoAyTr28E3Y0mvVvzE51Lt79iHRBPT8X7vKKrTivGJdFFUceScSmqrl/k5p7lF
         Occnpvs2cjMxmu5bVVXlgSYdNLA3KmOFGosUMRDHBtL3Sd5Q485xaNsHkvqHpLeMd6XZ
         MwAxAK++r9HnBUAkqkVvzf/KgQr9Vq6EctYOLINczOvx9C4IoDKZ73HLDRSEuGIyXZX3
         UYpqNZpEAJTxFwQ+lasIWhIROhSqWGOYfFG2+FwN5UgwLe7GO0p+G5wDk1d9f/fLF6sl
         avk/Z2Ljt43Nwg89jHO9YNNvgOgM3C5Rb9aa0/5tU644MZO/7RlHOA6zD+Ay1lM1/452
         YbXg==
X-Gm-Message-State: APjAAAV8PQNVTReiOZmwlSxpk/UR4DACiiPh/ICTBphpSG5n6F2epB5F
        rHc0CQ0J4+gucZirhewm0WFyzPy8xlkROaPzSpzwzKRDC4NrHq4zaQ7fvDFCA7/AwVJwqpEYvlm
        cK28r7PoNtaMo
X-Received: by 2002:a05:600c:2150:: with SMTP id v16mr4352598wml.156.1575546359843;
        Thu, 05 Dec 2019 03:45:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwhRAsh6ngjB5xE95s4DSTmRr59zIQF4ZIHs4bxPO/zhd6D4TXtfqIp84FdKUOMo1pySojIQw==
X-Received: by 2002:a05:600c:2150:: with SMTP id v16mr4352579wml.156.1575546359566;
        Thu, 05 Dec 2019 03:45:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:541f:a977:4b60:6802? ([2001:b07:6468:f312:541f:a977:4b60:6802])
        by smtp.gmail.com with ESMTPSA id t8sm11951791wrp.69.2019.12.05.03.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 03:45:58 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS
 field
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>
References: <20191204214027.85958-1-jmattson@google.com>
Message-ID: <b9067562-bbba-7904-84f0-593f90577fca@redhat.com>
Date:   Thu, 5 Dec 2019 12:45:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191204214027.85958-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: 44Co00RmNz6j7SCjqeTHwA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/19 22:40, Jim Mattson wrote:
> According to the SDM, a VMWRITE in VMX non-root operation with an
> invalid VMCS-link pointer results in VMfailInvalid before the validity
> of the VMCS field in the secondary source operand is checked.
> 
> Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 if running L2")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)

As Vitaly pointed out, the test must be split in two, like this:

---------------- 8< -----------------------
From 3b9d87060e800ffae2bd19da94ede05018066c87 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 5 Dec 2019 12:39:07 +0100
Subject: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field

According to the SDM, a VMWRITE in VMX non-root operation with an
invalid VMCS-link pointer results in VMfailInvalid before the validity
of the VMCS field in the secondary source operand is checked.

While cleaning up handle_vmwrite, make the code of handle_vmread look
the same, too.

Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 if running L2")
Signed-off-by: Jim Mattson <jmattson@google.com>
Cc: Liran Alon <liran.alon@oracle.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4aea7d304beb..c080a879b95d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4767,14 +4767,13 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	if (to_vmx(vcpu)->nested.current_vmptr == -1ull)
 		return nested_vmx_failInvalid(vcpu);

-	if (!is_guest_mode(vcpu))
-		vmcs12 = get_vmcs12(vcpu);
-	else {
+	vmcs12 = get_vmcs12(vcpu);
+	if (is_guest_mode(vcpu)) {
 		/*
 		 * When vmcs->vmcs_link_pointer is -1ull, any VMREAD
 		 * to shadowed-field sets the ALU flags for VMfailInvalid.
 		 */
-		if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
+		if (vmcs12->vmcs_link_pointer == -1ull)
 			return nested_vmx_failInvalid(vcpu);
 		vmcs12 = get_shadow_vmcs12(vcpu);
 	}
@@ -4878,8 +4877,19 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		}
 	}

+	vmcs12 = get_vmcs12(vcpu);
+	if (is_guest_mode(vcpu)) {
+		/*
+		 * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
+		 * to shadowed-field sets the ALU flags for VMfailInvalid.
+		 */
+		if (vmcs12->vmcs_link_pointer == -1ull)
+			return nested_vmx_failInvalid(vcpu);
+		vmcs12 = get_shadow_vmcs12(vcpu);
+	}

 	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+
 	/*
 	 * If the vCPU supports "VMWRITE to any supported field in the
 	 * VMCS," then the "read-only" fields are actually read/write.
@@ -4889,24 +4899,12 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);

-	if (!is_guest_mode(vcpu)) {
-		vmcs12 = get_vmcs12(vcpu);
-
-		/*
-		 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
-		 * vmcs12, else we may crush a field or consume a stale value.
-		 */
-		if (!is_shadow_field_rw(field))
-			copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
-	} else {
-		/*
-		 * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
-		 * to shadowed-field sets the ALU flags for VMfailInvalid.
-		 */
-		if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
-			return nested_vmx_failInvalid(vcpu);
-		vmcs12 = get_shadow_vmcs12(vcpu);
-	}
+	/*
+	 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
+	 * vmcs12, else we may crush a field or consume a stale value.
+	 */
+	if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field))
+		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);

 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)


... and also, do you have a matching kvm-unit-tests patch?

Thanks,

Paolo

