Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CB8562A9B
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 06:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiGAElI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 00:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGAElH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 00:41:07 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC2B60513
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 21:41:06 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id k25so1252196vso.6
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 21:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LgtIJLhIlObEf1prge4Y6yPa4LwrycdDF8GNVdUS6O4=;
        b=Bg/NLdtV+LwV8ZZi7pbMf0ofCXdMwliaiJXQHtH5+dLa72SzhXmu3/9Y+l1Yz+lTaM
         mT4G7oavD1J3NQ3TlLFZ4NqTUFg39pkNd7T3YZQIlpPj+sO3uq1zH7d8xSCtm91Frzcs
         /BAaiQh5a7WmugYUqHvj+jD0Z8A0HKxwE0j8OfTaZF6fvKXkt5HQD6C2rH1wSno22aXf
         Dj/YMKBALtU4F1dvPibeKUu8PF8RSG0UFZfMPAJ/tbQzfT4S66Sr85cKeJvPiTjyd9Jd
         bTR2dbrObzzViZJ/Xd+9eIIdVkwhiB9dU6i5QHX6Bx8wgHDtPyc0qrr3+jWD2mEZ/j0p
         KC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LgtIJLhIlObEf1prge4Y6yPa4LwrycdDF8GNVdUS6O4=;
        b=aeYmjxQ8iCREg5MXLXk+nN8Ppu+65lSzP5UB/zJrfdWwln1QlctWJD28naLj61nxEG
         seVTMY0OgCxIFXsxy1brQE6Gg03u8NL2BxVDBPAz3z16J5LnVW0taA3AFtjsuAeQZWA6
         zpWjpRDkhJ0lkpjT2PNxKplKgNGr9XCMrX5Cc2yPBwgL/a7thSWqi1CVaaAedIzx1M+w
         sU8EKQ27jR/3jV1Tr4KIeaKsz1LB7wtjA3WfuOSZlJ3p8awxZ937mQcc/kjA3N5VnOCR
         pH4OIfUfOdCuYvUTMOC6eXgzn+p6uC67FDHppkNHz7mox2k3W+6MEVjRgQsco0XuWyb8
         p4NQ==
X-Gm-Message-State: AJIora+kbYgIJREPslT8zrUJRNiUdC3c+XSSU0eNMZZ4aLN2peBqd44G
        FPcMu165rHJ7SQdUVT4boYqoAPTF0tsaqYVjEJqrJA==
X-Google-Smtp-Source: AGRyM1uT5bcbSSc6gZfVz1EffEzzssL2tqzBwZDhkBA8i//7HyWRA+8T6iIR7bMEr5y3QMrZvFHXrvxQraSB5sqV2fk=
X-Received: by 2002:a05:6102:3548:b0:354:34a1:e8f1 with SMTP id
 e8-20020a056102354800b0035434a1e8f1mr10021492vss.53.1656650465658; Thu, 30
 Jun 2022 21:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220610171134.772566-1-juew@google.com> <20220610171134.772566-5-juew@google.com>
 <958774eb-90df-34e9-e025-959c3eb60614@intel.com>
In-Reply-To: <958774eb-90df-34e9-e025-959c3eb60614@intel.com>
From:   Jue Wang <juew@google.com>
Date:   Thu, 30 Jun 2022 21:40:54 -0700
Message-ID: <CAPcxDJ6PJGfZ6pZZQ074OZujLKz2GPeYZ5Bgyrh_YRGqZ-7dsA@mail.gmail.com>
Subject: Re: [PATCH v5 4/8] KVM: x86: Add Corrected Machine Check Interrupt
 (CMCI) emulation to lapic.
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
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
Good catch.

Paolo / Sean, should another patch be sent to fix this or do you
recommend some other means to address the nr_lvt_entries
initialization issue that Xiaoyao pointed out?

Thanks a lot,
-Jue
>
> >
> >       static_call(kvm_x86_setup_mce)(vcpu);
> >   out:
>
