Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113E9568EA7
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 18:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiGFQJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 12:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiGFQJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 12:09:20 -0400
Received: from sender-of-o53.zoho.in (sender-of-o53.zoho.in [103.117.158.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AE91C11B
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 09:09:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1657123709; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=bCxlYm4suJNYv2M6uYFNxMsQhk6/POSg1cOB0ESuKrpLYl/bsscV9je5cQa52b5y6xHuNgJ04dBNyn6hfNstRXNQJAhjIzJcd9cmkgalnX9J3Xb0mjYpCIh18VVzFLo4PKEOQOnWcWknUEelnH1xPt1p92MR7VVEJOETVrtqFfM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1657123709; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=6Y8LK1qS5agG+TVmUp1luDaM68CD3qpjUAGeZA+LQoU=; 
        b=Wa+cWnm2J/iRf5W9Nou6payIME4QqF/wBOJroXpRTz8dSdwZBU1tkOlmaQYuo2Q2TVKZcT3j1HAXYFWFfHeXIcie6xkATGLdj7STCTm+YPRSShiDzn5J7w9r25J6pXlyzlPm9Zy/mykP7rrmmSzX+OAYbweWnj8fAJlwNkxm5q0=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1657123709;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=6Y8LK1qS5agG+TVmUp1luDaM68CD3qpjUAGeZA+LQoU=;
        b=Zhy5ck3uHv62JGoBQ7kz3xnp4hoSmuOcq6EGW3X5B6s5/Nd4jGxTieVO6oXH8qSG
        4BehLqF8TOARGOPMXn0MkCVNT312SQjOw1F693mGkVPXNOkXuf//aiUpvewCvkQo2H4
        uMmsNQzioiJv9yrKvea5wUoh4l3j8sXHTCJiiMTo=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1657123698370505.12292601010483; Wed, 6 Jul 2022 21:38:18 +0530 (IST)
Date:   Wed, 06 Jul 2022 21:38:18 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Jue Wang" <juew@google.com>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Xiaoyao Li" <xiaoyao.li@intel.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "David Matlack" <dmatlack@google.com>,
        "Tony Luck" <tony.luck@intel.com>, "kvm" <kvm@vger.kernel.org>,
        "Jiaqi Yan" <jiaqiyan@google.com>
Message-ID: <181d444f6af.29bf72881043891.3933915344389495767@siddh.me>
In-Reply-To: <20220706145957.32156-2-juew@google.com>
References: <20220706145957.32156-1-juew@google.com> <20220706145957.32156-2-juew@google.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: Fix access to vcpu->arch.apic when the
 irqchip is not in kernel
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 06 Jul 2022 20:29:57 +0530  Jue Wang <juew@google.com> wrote
> Fix an access to vcpu->arch.apic when KVM_X86_SETUP_MCE is called
> without KVM_CREATE_IRQCHIP called or KVM_CAP_SPLIT_IRQCHIP is
> enabled.
> 
> Reported-by: https://syzkaller.appspot.com/bug?id=10b9b238e087a6c9bef2cc48bee2375f58fabbfc
> 
> Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/kvm/x86.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 

The syzkaller dashboard says to use the following line:
Reported-by: syzbot+8cdad6430c24f396f158@syzkaller.appspotmail.com


Tested-by: Siddh Raman Pant <code@siddh.me>

Thanks,
Siddh

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4322a1365f74..5913f90ec3f2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4820,8 +4820,9 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>          if (mcg_cap & MCG_CMCI_P)
>              vcpu->arch.mci_ctl2_banks[bank] = 0;
>      }
> -    vcpu->arch.apic->nr_lvt_entries =
> -        KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
> +    if (lapic_in_kernel(vcpu))
> +        vcpu->arch.apic->nr_lvt_entries =
> +            KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
>  
>      static_call(kvm_x86_setup_mce)(vcpu);
>  out:
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 
> 
