Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DAD563855
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 18:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiGAQx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 12:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiGAQx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 12:53:56 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13133150C
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 09:53:55 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id s4so1055841uad.0
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 09:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x3YveiUa+36Z55JnZO2m9qZ79ODycX7P9iG5OvJQB8g=;
        b=r0guqK4+dKdZqeuCOGuFRXKZO7GfPqfjKP1LPuIdp4Cl10GGtvFusOXtX+zjtetkuH
         yK2OTEnys2ydHR0Vf0syfS3zrsjosq1BajTDTt3q5vJSKjqRJZsXfdRZt+iKaGrsU+FA
         90spq90ncamvrbpu28hOeZucmpAIYSNL0d3CIbNj4RvcZ+EWeg6236i95jnI6lGwq0uH
         /SLP2dSJJUdgMeHvV5apW/lqg77CuvYDY63AyGqB6tfnFf+32fVff663W1ymI3rfm7Wc
         pQqAxUSCbl4xQuP9lgS9eX46CxjCiGfJi3RTrDpN2SfIuYkLWU9aQH8LKlSdNZD9v5K2
         V8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x3YveiUa+36Z55JnZO2m9qZ79ODycX7P9iG5OvJQB8g=;
        b=uy49/3aG4G4gxQn0u9wVMqym6v+uNVJhj/bIPAgS+0n1/zbNgSxmWbDJS0GmUMw7DM
         wgtltXEY4sBSRm7Ve/sfltp6mpfhuGlhq6pnDeor89QBzosSk45QR7LZ8GQqrKBQvMNM
         kvuPcqjDNInVMc8xKvjhamHEioMDZL0nBf/kGQEyBbJSnM5dOXV4DHUWU9Qudu1MeNvN
         bOXU367vHMQvS40Xn7i47eVFdugY/Hh7idp+XjmttE6Z2R9MoSm7ucm6WKdB0SmR0epU
         V+PHKaSDz/Q0jjjAh7APsrDmWEl/zDiYsANWAqK62t/YI+GgeHz8/6R1pYN3CmEhIzYC
         kwBg==
X-Gm-Message-State: AJIora9hbt6yk6YoIhIbONuEE84hi0ONOeidovFIiD7lK1hY7FKknkuj
        og8OghjCjVgXXhlqTJHReuXbVJNRCKILKuUIKpLE9g==
X-Google-Smtp-Source: AGRyM1urLyGLtTlCnodkvBbFUrtC60Q9FDfrlHgelcBwgKf1TovXLYqVHS4xszy2IpFA6RMuZSKjJ3hry7yXe+2r4lc=
X-Received: by 2002:ab0:2c09:0:b0:379:a983:96fe with SMTP id
 l9-20020ab02c09000000b00379a98396femr9315840uar.102.1656694434865; Fri, 01
 Jul 2022 09:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220610171134.772566-1-juew@google.com> <20220610171134.772566-5-juew@google.com>
 <958774eb-90df-34e9-e025-959c3eb60614@intel.com>
In-Reply-To: <958774eb-90df-34e9-e025-959c3eb60614@intel.com>
From:   Jue Wang <juew@google.com>
Date:   Fri, 1 Jul 2022 09:53:43 -0700
Message-ID: <CAPcxDJ7X93n2uhuCTieRqPe5O5fYRThWPOF+3J7vZyPvmYboGA@mail.gmail.com>
Subject: Re: [PATCH v5 4/8] KVM: x86: Add Corrected Machine Check Interrupt
 (CMCI) emulation to lapic.
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I have sent out two patches to address this bug and an #GP reported by
syzkaller.

https://lore.kernel.org/kvm/20220701165045.4074471-1-juew@google.com/

Thanks again for the review and reporting of this issue!

Best regards,
-Jue

On Thu, Jun 30, 2022 at 7:07 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 6/11/2022 1:11 AM, Jue Wang wrote:
> ...
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4790f0d7d40b..a08693808729 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4772,6 +4772,8 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
> >       /* Init IA32_MCi_CTL to all 1s */
> >       for (bank = 0; bank < bank_num; bank++)
> >               vcpu->arch.mce_banks[bank*4] = ~(u64)0;
> > +     vcpu->arch.apic->nr_lvt_entries =
> > +             KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
>
> vcpu->arch.apic->nr_lvt_entries needs to be initialized as
> KVM_APIC_MAX_NR_LVT_ENTREIS - 1 when creating lapic.
>
> What if userspace doesn't call KVM_X86_SETUP_MCE at all?
>
> >
> >       static_call(kvm_x86_setup_mce)(vcpu);
> >   out:
>
