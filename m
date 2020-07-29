Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF16231E73
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 14:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgG2MVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 08:21:02 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:58596 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726391AbgG2MVB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jul 2020 08:21:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596025260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d6W1T974VZvK5aHdyDKfm8iT0P3+yUruO/0hQztff7w=;
        b=OULqUF8WQ+jBXyTFiyqDCBvQPyHTde9J5Lk6aOUxznUqwGmfyDJkRPu5c//BgneRKkAaYZ
        pHk0QTrPZyBHi03s10yLnaGdSMvmarIY8Ko8ZmfpbCyvotZm80ey8MfBiMYf/GLBHcXbzS
        t/r9+VNUlQWdf6BNQeKRqQaSvEhk9c0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-cRE70jTrMRK5Kmx68k4g6A-1; Wed, 29 Jul 2020 08:20:58 -0400
X-MC-Unique: cRE70jTrMRK5Kmx68k4g6A-1
Received: by mail-ed1-f72.google.com with SMTP id t30so5755406edi.12
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 05:20:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=d6W1T974VZvK5aHdyDKfm8iT0P3+yUruO/0hQztff7w=;
        b=BmEE4Sd2htAgO13/1uxVWM3YMygBgUMcfm3OXNBP0JjslVwMpYmtS88qvoNTPlDj/a
         XTECKsWHRHy1m8UxgXn3ozTHvUVmpzm09mK78lzb1+HoRRWIH6ThEammSTHIRMSvNRqv
         lh9QzReufbMEbNQh57zhH3pxQx/o9wC2RbLO4EX+nW9Um0fefIjXYuUS2EnzSeYeaijM
         FQ/osRBHNrG+Vl4CU6DK9bKMHv9b6+0PM31L/gLxHmqgy0gE3QkfgoFeluQHVXfcdwlZ
         hPFDpPR4Kp6orpnTqPGxFjGB0iFSf75Q8WFaRusC9S0xOUr2JyPflNPVNrBpD+PTC+4F
         P6eQ==
X-Gm-Message-State: AOAM530jaYn9sonOHsv/IVaeY4nhsQFJp9SB2zoJgBIjtLZ8yMJF9+JP
        y/Zx9ksP7yix1zjTig19zuMZrgRZ2Z53RPrl6Fdeuec+iiN12R1YKyusYs35pS2oezx8mIElyjg
        OPPKMwGnIh8Tn
X-Received: by 2002:a05:6402:2031:: with SMTP id ay17mr4496489edb.46.1596025257232;
        Wed, 29 Jul 2020 05:20:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyO5SyrFRx4z+lvlosTAQpCNz7fTshwRKVxOkDbzVCw5cgeIqEa4f1i3ysB4XP6Rnyox74DtQ==
X-Received: by 2002:a05:6402:2031:: with SMTP id ay17mr4496471edb.46.1596025257037;
        Wed, 29 Jul 2020 05:20:57 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o7sm1655137edq.53.2020.07.29.05.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 05:20:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 3/3] KVM: SVM: Fix disable pause loop exit/pause filtering capability on SVM
In-Reply-To: <1595929506-9203-3-git-send-email-wanpengli@tencent.com>
References: <1595929506-9203-1-git-send-email-wanpengli@tencent.com> <1595929506-9203-3-git-send-email-wanpengli@tencent.com>
Date:   Wed, 29 Jul 2020 14:20:54 +0200
Message-ID: <87k0ymldg9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Commit 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM) drops
> disable pause loop exit/pause filtering capability completely, I guess it
> is a merge fault by Radim since disable vmexits capabilities and pause
> loop exit for SVM patchsets are merged at the same time. This patch
> reintroduces the disable pause loop exit/pause filtering capability
> support.
>
> We can observe 2.9% hackbench improvement for a 92 vCPUs guest on AMD 
> Rome Server.
>
> Reported-by: Haiwei Li <lihaiwei@tencent.com>
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Fixes: 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/svm/svm.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c0da4dd..c20f127 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1090,7 +1090,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>  	svm->nested.vmcb = 0;
>  	svm->vcpu.arch.hflags = 0;
>  
> -	if (pause_filter_count) {
> +	if (pause_filter_count && !kvm_pause_in_guest(svm->vcpu.kvm)) {
>  		control->pause_filter_count = pause_filter_count;
>  		if (pause_filter_thresh)
>  			control->pause_filter_thresh = pause_filter_thresh;
> @@ -2693,7 +2693,7 @@ static int pause_interception(struct vcpu_svm *svm)
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  	bool in_kernel = (svm_get_cpl(vcpu) == 0);
>  
> -	if (pause_filter_thresh)
> +	if (!kvm_pause_in_guest(vcpu->kvm))
>  		grow_ple_window(vcpu);
>  
>  	kvm_vcpu_on_spin(vcpu, in_kernel);
> @@ -3780,7 +3780,7 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  
>  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  {
> -	if (pause_filter_thresh)
> +	if (!kvm_pause_in_guest(vcpu->kvm))
>  		shrink_ple_window(vcpu);
>  }
>  
> @@ -3958,6 +3958,9 @@ static void svm_vm_destroy(struct kvm *kvm)
>  
>  static int svm_vm_init(struct kvm *kvm)
>  {
> +	if (!pause_filter_thresh)
> +		kvm->arch.pause_in_guest = true;

Would it make sense to do

        if (!pause_filter_count || !pause_filter_thresh)
		kvm->arch.pause_in_guest = true;

here and simplify the condition in init_vmcb()?

> +
>  	if (avic) {
>  		int ret = avic_vm_init(kvm);
>  		if (ret)

-- 
Vitaly

