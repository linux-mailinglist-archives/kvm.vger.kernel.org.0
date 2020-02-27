Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCA217289E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 20:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgB0TaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 14:30:14 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:44860 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbgB0TaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 14:30:13 -0500
Received: by mail-vs1-f67.google.com with SMTP id p6so376124vsj.11
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 11:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OGP2GYUfRtgo7RRpY4S9TgOhmufaENbcYOsEoqwQtQk=;
        b=IDmxdg9vhWg7nNVDjJAQX9oZMUtJh+UnTIfDe5/WrwJaTn/NLqQHmCmZa1yY2WiI+t
         xgqgPbqCPY8f+D1cscw0pITPQsvvL500u52kDVwo5/prytf1M7Y8H2cFKZd/HLdI7shb
         n3PeLbnNTcTEW2WWa2uuO+OZRz2Y4TbsVi7AEp2BHGDNAsysrj941ueRpiou/qXxNApb
         Brme32xKMSxxjlRISgmEVc9ANltBr6YhDCDHF5NCS0+u/4i6W7AX8sxqSSOhG88GuTsa
         y2Pb/LCnllmniDJTg5LxDwnXYUZKybKaRrURQfnK531RcS3icfgZDfBYs6c55a8ZedG7
         miZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OGP2GYUfRtgo7RRpY4S9TgOhmufaENbcYOsEoqwQtQk=;
        b=SXVh3aopb3gJb+HA0br3RxJ4Y+qJsNRuK6lE5W0t9NNQ4kPI083zcTS2zHd7miTrbI
         4hLhku8Jkk2MLk6dOgwGP1O3LlLfQTZRptCnZjfEBzaJFtRWg/2aixkiJpLJJrDXYLc5
         UFpy4wm0vg/BnO38C/7BE33+aAMn85J0ZHCzhkebkmskYO9rJDDGTJ6rku6zuHpjXSCV
         VJFkmx9CKvFGh5vrYgMdZHzIlRJDIowDJIQov4p6gHv0xAGdlkSf1Vhcoyz28qxY7Tuj
         /zNCBvAtEVd0XsEkVeEW/mllRRUIrni8ziO9Adf01wpUwi/jFnJ93rowBjALsqDVbGwl
         1baQ==
X-Gm-Message-State: ANhLgQ2e3tQ86OTmrZVtXKGQomnzuuYhxE9Z7iUJqwWUsm0CUlbf0SQN
        c204GpZ3F6XdU1P9M+fpkjYx9mOlVGikfdb70fBQ+g==
X-Google-Smtp-Source: ADFU+vt2xe+yvmRwIdYwZ30bG5odphSdTakAwOaM+v3j5GhmwqZ89pGl2tR5Ne+o2eNFXVsbUmDXnaM0npZHXAi9jhs=
X-Received: by 2002:a05:6102:677:: with SMTP id z23mr571919vsf.202.1582831812647;
 Thu, 27 Feb 2020 11:30:12 -0800 (PST)
MIME-Version: 1.0
References: <20200227172306.21426-1-mgamal@redhat.com> <20200227172306.21426-2-mgamal@redhat.com>
In-Reply-To: <20200227172306.21426-2-mgamal@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 27 Feb 2020 11:30:01 -0800
Message-ID: <CANgfPd8X_Vv7eL6ict_TBzbg6_Q5Oa9FLh_0bCWjsGSGxB6xdw@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: x86: Add function to inject guest page fault
 with reserved bits set
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        Jim Mattson <jmattson@google.com>, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 27, 2020 at 9:23 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 14 ++++++++++++++
>  arch/x86/kvm/x86.h |  1 +
>  2 files changed, 15 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 359fcd395132..434c55a8b719 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10494,6 +10494,20 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
>
> +void kvm_inject_rsvd_bits_pf(struct kvm_vcpu *vcpu, gpa_t gpa)
> +{
> +       struct x86_exception fault;
> +
> +       fault.vector = PF_VECTOR;
> +       fault.error_code_valid = true;
> +       fault.error_code = PFERR_RSVD_MASK;
> +       fault.nested_page_fault = false;
> +       fault.address = gpa;
> +
> +       kvm_inject_page_fault(vcpu, &fault);
> +}
> +EXPORT_SYMBOL_GPL(kvm_inject_rsvd_bits_pf);
> +

There are calls to kvm_mmu_page_fault in arch/x86/kvm/mmu/mmu.c that
don't get the check and injected page fault in the later patches in
this series. Is the check not needed in those cases?

>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 3624665acee4..7d8ab28a6983 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -276,6 +276,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
>  bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
>                                           int page_num);
>  bool kvm_vector_hashing_enabled(void);
> +void kvm_inject_rsvd_bits_pf(struct kvm_vcpu *vcpu, gpa_t gpa);
>  int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>                             int emulation_type, void *insn, int insn_len);
>  enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
> --
> 2.21.1
>
