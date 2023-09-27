Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2D07AF9BA
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjI0Eww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjI0EwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:52:05 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5321893DD
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 21:15:50 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-65afac36b2cso35578006d6.3
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 21:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695788149; x=1696392949; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tkv6RH836AiVyE8U+fPrgGzD8gItVvyQvbnTdDUNizc=;
        b=PQ3MK2VlDpFY9wmkzKLlJzEsBV8HlELuOqWJcqAHfm4SNACFZQkk8GR3RJdqk71nPI
         l0CtXF9kxrwT01YMxfsEBuucdEZZ5rw/F0x3ORJ7dmcUMk5VYRDoh6jKfGXkvdqn47R7
         92T/Dz+YKoG5vTr94zz2Wzda1NH+KvULa5YwWdKbIRfDVStZX/VkgVGPcXJ0IlYNi2c2
         wzvAPXl52LK9T8Rj5dY/pg4GH45+XrNtGr9nt34l2PYBDeh3UlBhtiVPefDNCgPRKhsa
         BvrQKU4DjrhFtAYP0QoEJUxF1ADM9gw6xPWYVPi/+LhcVhIHJKX8c19X1xkN+pq1TURm
         gtFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695788149; x=1696392949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tkv6RH836AiVyE8U+fPrgGzD8gItVvyQvbnTdDUNizc=;
        b=JJTOhRNco97UZev3HlQCpbtbE43bTdfCAIVnoJiurRIk8SXUskBum2+0HjiPqUdSMB
         DZ747Mtqi9ZS+akp+n9SZrLwY5KFFV/3ze/+8FxTYJ8XaUMdNtd8jFA3hpMQd7lYKHbb
         OykSm2FfRnQMz0h+9I88Lwd3MtUJ4r+3xbpXIf13RYb9MFjem1agxQ2t9dnQC4+kLTqH
         smC2UCYQYZs2OqfQF4bfSA62V8omUpczj9QWyvokHVzPX7KIvPmZ8DtpI7Q/mAxVYFAo
         E5X91nehUtjOjGK+i4/mMV2uD04BiXVKlfufmcuc0AUbY03MXKGg+mpOpdMzHDoiqar6
         no+Q==
X-Gm-Message-State: AOJu0YwyJpi8NTjvLrNt0qgiV77NXNO4LAw3k5Z14/rjYDt5K/zBwix6
        5duubaI6fd4XMomUHQhBJtPiUuB3tQL9grf0VAAZHg==
X-Google-Smtp-Source: AGHT+IHTRmOFQIYgqFNoFMqkmUHAZx80L22kfyxbt0Cn8/pCdUz5YBi/DFLPHqot9xxyIU3l3RPUE/OxY1gIaKmif4o=
X-Received: by 2002:a0c:f5c7:0:b0:656:2146:ee6a with SMTP id
 q7-20020a0cf5c7000000b006562146ee6amr765453qvm.58.1695788149198; Tue, 26 Sep
 2023 21:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230927040939.342643-1-mizhang@google.com>
In-Reply-To: <20230927040939.342643-1-mizhang@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 26 Sep 2023 21:15:12 -0700
Message-ID: <CAL715WJM2hMyMvNYZAcd4cSpDQ6XPFsNhtR2dsi7W=ySfy=CFw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Move kvm_check_request(KVM_REQ_NMI) after kvm_check_request(KVM_REQ_NMI)
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>, Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ah, typo in the subject: The 2nd KVM_REQ_NMI should be KVM_REQ_PMI.
Sorry about that.

On Tue, Sep 26, 2023 at 9:09=E2=80=AFPM Mingwei Zhang <mizhang@google.com> =
wrote:
>
> Move kvm_check_request(KVM_REQ_NMI) after kvm_check_request(KVM_REQ_NMI).
> When vPMU is active use, processing each KVM_REQ_PMI will generate a
> KVM_REQ_NMI. Existing control flow after KVM_REQ_PMI finished will fail t=
he
> guest enter, jump to kvm_x86_cancel_injection(), and re-enter
> vcpu_enter_guest(), this wasted lot of cycles and increase the overhead f=
or
> vPMU as well as the virtualization.
>
> So move the code snippet of kvm_check_request(KVM_REQ_NMI) to make KVM
> runloop more efficient with vPMU.
>
> To evaluate the effectiveness of this change, we launch a 8-vcpu QEMU VM =
on
> an Intel SPR CPU. In the VM, we run perf with all 48 events Intel vtune
> uses. In addition, we use SPEC2017 benchmark programs as the workload wit=
h
> the setup of using single core, single thread.
>
> At the host level, we probe the invocations to vmx_cancel_injection() wit=
h
> the following command:
>
>     $ perf probe -a vmx_cancel_injection
>     $ perf stat -a -e probe:vmx_cancel_injection -I 10000 # per 10 second=
s
>
> The following is the result that we collected at beginning of the spec201=
7
> benchmark run (so mostly for 500.perlbench_r in spec2017). Kindly forgive
> the incompleteness.
>
> On kernel without the change:
>     10.010018010              14254      probe:vmx_cancel_injection
>     20.037646388              15207      probe:vmx_cancel_injection
>     30.078739816              15261      probe:vmx_cancel_injection
>     40.114033258              15085      probe:vmx_cancel_injection
>     50.149297460              15112      probe:vmx_cancel_injection
>     60.185103088              15104      probe:vmx_cancel_injection
>
> On kernel with the change:
>     10.003595390                 40      probe:vmx_cancel_injection
>     20.017855682                 31      probe:vmx_cancel_injection
>     30.028355883                 34      probe:vmx_cancel_injection
>     40.038686298                 31      probe:vmx_cancel_injection
>     50.048795162                 20      probe:vmx_cancel_injection
>     60.069057747                 19      probe:vmx_cancel_injection
>
> From the above, it is clear that we save 1500 invocations per vcpu per
> second to vmx_cancel_injection() for workloads like perlbench.
>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 42a4e8f5e89a..302b6f8ddfb1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10580,12 +10580,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vc=
pu)
>                 if (kvm_check_request(KVM_REQ_SMI, vcpu))
>                         process_smi(vcpu);
>  #endif
> -               if (kvm_check_request(KVM_REQ_NMI, vcpu))
> -                       process_nmi(vcpu);
>                 if (kvm_check_request(KVM_REQ_PMU, vcpu))
>                         kvm_pmu_handle_event(vcpu);
>                 if (kvm_check_request(KVM_REQ_PMI, vcpu))
>                         kvm_pmu_deliver_pmi(vcpu);
> +               if (kvm_check_request(KVM_REQ_NMI, vcpu))
> +                       process_nmi(vcpu);
>                 if (kvm_check_request(KVM_REQ_IOAPIC_EOI_EXIT, vcpu)) {
>                         BUG_ON(vcpu->arch.pending_ioapic_eoi > 255);
>                         if (test_bit(vcpu->arch.pending_ioapic_eoi,
>
> base-commit: 73554b29bd70546c1a9efc9c160641ef1b849358
> --
> 2.42.0.515.g380fc7ccd1-goog
>
