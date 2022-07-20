Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289F657B32B
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 10:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiGTIoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 04:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiGTIoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 04:44:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A8B4664DC
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 01:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658306641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qECqlsehCmLLfQXQZF/PgRoF4ORK4DIuQmugTBfeSYs=;
        b=SFrcRiCyn2nZ6xfWtwE+03anRqepeoqZsOIsolpTbu5+bHnRCUmHj8cUM2i1icgOMKc9T0
        JTXYmC8BYGU0SNRK5SOPggMqFqM68lfPhUAbTUKGSNVfyLo2NS/YZYygSWzGaaw5/wNhcU
        GG6ZFiv9LqkeIlxUnk3uf361nxA70SY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-F1UrX0yNOXq49lp0Ym_gMg-1; Wed, 20 Jul 2022 04:43:59 -0400
X-MC-Unique: F1UrX0yNOXq49lp0Ym_gMg-1
Received: by mail-qt1-f200.google.com with SMTP id q21-20020ac84115000000b0031bf60d9b35so11681370qtl.4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 01:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qECqlsehCmLLfQXQZF/PgRoF4ORK4DIuQmugTBfeSYs=;
        b=4zKH8ijdRsy5goLfqJb3Bu35RD7u6/vwVQbzWDMYhKzuzu+A2LBUh4C71731Q2/8VI
         OPgZeCBIV6S6R9inW10oaGhtkwiRpDe50LaM+I62TYSW5pBCGe0H46EpuQTVvhz6LiWB
         GkdCERljfls9rmhgCaAsq4yEtXumijB5QAfOLqcBf+J5lO05aYZioPeHF4EdsSo20JhG
         8a3fWo0TS2ApVO5Z5578P0Wpv7ANsxdGwSnoaoAxZ+DzFN9g2H1fCGfhE702vx+7eJUZ
         sQxyBD916BvDJ3XSIkWb2xxgZhohZyYRvIfOAY21rORekzsAisxVTFjfCWoyiyeZlIrl
         RpUA==
X-Gm-Message-State: AJIora8xR+ttvTNwCaRnPqiowfv4d/F7kMeE3lMRmVhOXBoLxD6dRlXh
        Z+bGVZmvAZRQIorcKKbDjkL61qihAE0yb0VWTKiMLJVgHtHxHcp+tIizHycn6dO5oJt5EVHLB16
        4YbHa4AFJu9CA
X-Received: by 2002:ac8:5a08:0:b0:31e:fcc6:cbf3 with SMTP id n8-20020ac85a08000000b0031efcc6cbf3mr5627238qta.158.1658306639481;
        Wed, 20 Jul 2022 01:43:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1unliXYGlJ0PnQQ1w+j+lWuj4ngbiiEP0Nhu86nMpULaf+7XlQOvAIygv6L3z3qYRlac1Ib7w==
X-Received: by 2002:ac8:5a08:0:b0:31e:fcc6:cbf3 with SMTP id n8-20020ac85a08000000b0031efcc6cbf3mr5627229qta.158.1658306639235;
        Wed, 20 Jul 2022 01:43:59 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id f12-20020a05620a280c00b006b5e3bf0eb8sm10168451qkp.19.2022.07.20.01.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 01:43:58 -0700 (PDT)
Message-ID: <7458497a8694ba0fbabee28eabf557e6e4406fbe.camel@redhat.com>
Subject: Re: [PATCH] KVM: nSVM: Pull CS.Base from actual VMCB12 for soft
 int/ex re-injection
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 20 Jul 2022 11:43:55 +0300
In-Reply-To: <4caa0f67589ae3c22c311ee0e6139496902f2edc.1658159083.git.maciej.szmigiero@oracle.com>
References: <4caa0f67589ae3c22c311ee0e6139496902f2edc.1658159083.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-18 at 17:47 +0200, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> enter_svm_guest_mode() first calls nested_vmcb02_prepare_control() to copy
> control fields from VMCB12 to the current VMCB, then
> nested_vmcb02_prepare_save() to perform a similar copy of the save area.
> 
> This means that nested_vmcb02_prepare_control() still runs with the
> previous save area values in the current VMCB so it shouldn't take the L2
> guest CS.Base from this area.
> 
> Explicitly pull CS.Base from the actual VMCB12 instead in
> enter_svm_guest_mode().
> 
> Granted, having a non-zero CS.Base is a very rare thing (and even
> impossible in 64-bit mode), having it change between nested VMRUNs is
> probably even rarer, but if it happens it would create a really subtle bug
> so it's better to fix it upfront.
> 
> Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  arch/x86/kvm/svm/nested.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index adf4120b05d90..23252ab821941 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -639,7 +639,8 @@ static bool is_evtinj_nmi(u32 evtinj)
>  }
>  
>  static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> -                                         unsigned long vmcb12_rip)
> +                                         unsigned long vmcb12_rip,
> +                                         unsigned long vmcb12_csbase)

Honestly I don't like that nested_vmcb02_prepare_control starts to grow its parameter list,
because it kind of defeats the purpose of vmcb12 cache we added back then.

I think that it is better to add csbase/rip to vmcb_save_area_cached,
but I am not 100% sure. What do you think?

Best regards,
	Maxim Levitsky


>  {
>         u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
>         u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
> @@ -711,7 +712,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>         svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
>         if (is_evtinj_soft(vmcb02->control.event_inj)) {
>                 svm->soft_int_injected = true;
> -               svm->soft_int_csbase = svm->vmcb->save.cs.base;
> +               svm->soft_int_csbase = vmcb12_csbase;
>                 svm->soft_int_old_rip = vmcb12_rip;
>                 if (svm->nrips_enabled)
>                         svm->soft_int_next_rip = svm->nested.ctl.next_rip;
> @@ -800,7 +801,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>         nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
>  
>         svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -       nested_vmcb02_prepare_control(svm, vmcb12->save.rip);
> +       nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
>         nested_vmcb02_prepare_save(svm, vmcb12);
>  
>         ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
> @@ -1663,7 +1664,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>         nested_copy_vmcb_control_to_cache(svm, ctl);
>  
>         svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -       nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip);
> +       nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
>  
>         /*
>          * While the nested guest CR3 is already checked and set by
> 


