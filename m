Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399624A63D4
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 19:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbiBASa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 13:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbiBASa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 13:30:27 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4D0C061714;
        Tue,  1 Feb 2022 10:30:26 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id r7so13403516wmq.5;
        Tue, 01 Feb 2022 10:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Jm8BXyrfEZYc6+12yNeq6/HE2c+1ykfSUn6L7kkAGNc=;
        b=kba2yhGKR008LSm2zIRBWihztOVyxS1jpNzGWAUoCJay5eQRO7+iYOcABLRPMPtBmH
         WOBTy6NpsTxS9oTyNy/zAOjW/FO/Mh0JZFMAa7nPp0QGXMPLO59ovrsVLVb6vy0nWfwi
         irPPGDWY4TTZaOSzgZdJsJxIgo363FbWQLL7B4yKfHuS66r7uAAiOcNN1oUCORiFU7fT
         quO9sw17p18/6T4NRsISB9nVeScFuQgDsRXDcEpSqI/MmS7ox5gX8ovf1qYAZUnUVYEI
         YmPhmuvS46vw2Jpe6aqSy9qsoiHjUH9Hi3f95BlMznXPaEYhcNfJ5DLqrekFcjTwugha
         2gWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Jm8BXyrfEZYc6+12yNeq6/HE2c+1ykfSUn6L7kkAGNc=;
        b=mkSGZxB6wk+Xrix2XowjvHi4Qw00LIN4V534HudBA1oKTKH59Bh1qiAPS5iGYMEXlk
         vGWnHe3YMs+2v1ZdHM4olJKXFD/p6hIuaLAE5tdG+LKe8rRUl/A46KlWo1v6rIH+AHT9
         AJuqDC8LhGHlIGz0P1DxJYrY7JNPKw/7E3yUgltyqLtyHzdMBz9iY0sm0q6ichh780Mp
         Jzj/VRF9Uy6NJTrThLISE6osCItp2US4ia5i/ZjGFeBA6Xz+N16eMfuW8gzYMX4aCKtQ
         949lXn5fbYUtqGZLuEThrWmUSHZqlLY0cZTKsgKAo5kse7J9Mg5TGz6HE5t6MXvbAslQ
         ydVQ==
X-Gm-Message-State: AOAM532r0nFqy1WDA9TXUjmgr3K89idaX4OSvD5Vzd8XaBeWowMIzayf
        WyQBeAASVpUNJeppLX2D13s=
X-Google-Smtp-Source: ABdhPJyE5/RPRLYHIpK88MfiP/ehaCuXpmDBMFR7kByf7iHxYHR0rjEQkuskK/WR7/4VuefAhM/ABA==
X-Received: by 2002:a7b:cbd9:: with SMTP id n25mr2938176wmi.141.1643740225043;
        Tue, 01 Feb 2022 10:30:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 44sm15238098wrm.103.2022.02.01.10.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 10:30:24 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <66bcd1bf-0df4-8f02-9c0d-f71cecef71f4@redhat.com>
Date:   Tue, 1 Feb 2022 19:30:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/5] KVM: SVM: nSVM: Implement Enlightened MSR-Bitmap for
 Hyper-V-on-KVM and fix it for KVM-on-Hyper-V
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
References: <20211220152139.418372-1-vkuznets@redhat.com>
 <35f06589-d300-c356-dc17-2c021ac97281@redhat.com> <87sft2bqup.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87sft2bqup.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/22 15:31, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 12/20/21 16:21, Vitaly Kuznetsov wrote:
>>> Enlightened MSR-Bitmap feature implements a PV protocol for L0 and L1
>>> hypervisors to collaborate and skip unneeded updates to MSR-Bitmap.
>>> KVM implements the feature for KVM-on-Hyper-V but it seems there was
>>> a flaw in the implementation and the feature may not be fully functional.
>>> PATCHes 1-2 fix the problem. The rest of the series implements the same
>>> feature for Hyper-V-on-KVM.
>>>
>>> Vitaly Kuznetsov (5):
>>>     KVM: SVM: Drop stale comment from
>>>       svm_hv_vmcb_dirty_nested_enlightenments()
>>>     KVM: SVM: hyper-v: Enable Enlightened MSR-Bitmap support for real
>>>     KVM: nSVM: Track whether changes in L0 require MSR bitmap for L2 to be
>>>       rebuilt
>>>     KVM: x86: Make kvm_hv_hypercall_enabled() static inline
>>>     KVM: nSVM: Implement Enlightened MSR-Bitmap feature
>>>
>>>    arch/x86/kvm/hyperv.c           | 12 +--------
>>>    arch/x86/kvm/hyperv.h           |  6 ++++-
>>>    arch/x86/kvm/svm/nested.c       | 47 ++++++++++++++++++++++++++++-----
>>>    arch/x86/kvm/svm/svm.c          |  3 ++-
>>>    arch/x86/kvm/svm/svm.h          | 16 +++++++----
>>>    arch/x86/kvm/svm/svm_onhyperv.h | 12 +++------
>>>    6 files changed, 63 insertions(+), 33 deletions(-)
>>>
>>
>> Queued 3-5 now, but it would be nice to have some testcases.

Hmm, it fails to compile with CONFIG_HYPERV disabled, and a trivial
#if also fails due to an unused goto label.  Does this look good to you?

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e3759a79d39a..a2b5267b3e73 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -173,9 +173,16 @@ void recalc_intercepts(struct vcpu_svm *svm)
   */
  static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
  {
+	int i;
+
+	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
+		return true;
+
+	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
+
+#if IS_ENABLED(CONFIG_HYPERV)
  	struct hv_enlightenments *hve =
  		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
-	int i;
  
  	/*
  	 * MSR bitmap update can be skipped when:
@@ -185,10 +192,8 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
  	    kvm_hv_hypercall_enabled(&svm->vcpu) &&
  	    hve->hv_enlightenments_control.msr_bitmap &&
  	    (svm->nested.ctl.clean & VMCB_HV_NESTED_ENLIGHTENMENTS))
-		goto set_msrpm_base_pa;
-
-	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
  		return true;
+#endif
  
  	for (i = 0; i < MSRPM_OFFSETS; i++) {
  		u32 value, p;
@@ -213,10 +216,6 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
  	}
  
  	svm->nested.force_msr_bitmap_recalc = false;
-
-set_msrpm_base_pa:
-	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
-
  	return true;
  }
  


Thanks,

Paolo
