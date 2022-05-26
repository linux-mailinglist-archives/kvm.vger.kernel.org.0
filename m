Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F00534C04
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 10:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiEZIxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 04:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbiEZIxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 04:53:12 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99230C3D28;
        Thu, 26 May 2022 01:53:11 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id y141so1770767ybe.13;
        Thu, 26 May 2022 01:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+NW67VtdRcZQ9Q2m5VakCrqBBwHKOENKxBYUs8sQ/yQ=;
        b=Yrv1E+jB0uDVSsEI4SYF2D5OnGbc7IeA3DTCV5ZBpbhfdY9NLr8uQMr8raFjP6EAZ+
         0i9SBhH2Un+uWOgoooUOHmp9P4wq0LtiE4yjA5KJujQayYaaNc+qeq+5d0TiJXwPYUfR
         wvjQkt0hbO68HJBKGD+8OctEtZvgezcqam0uHOFrEhIZa+JJUas7pDVE3Kb/IZeAoh8M
         AL1WbCTjXcLS8FXRysvNNp3gTOzuoN73Fi2rmzaWFEcAbN4ckzn6cZ2BJv9/nAbujvJ2
         oJzCoYGNlf2r82VZT9HGuYsQYe5GiHGnf6zcgEDfp2tM8/U/O7GDTADlQ23sIRMAQ2E7
         y9Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+NW67VtdRcZQ9Q2m5VakCrqBBwHKOENKxBYUs8sQ/yQ=;
        b=Sj5y+Ckcu+QyCYK5IUn6CE49NSDyVdy3P02BHvsZ23Ju5nWlxEheLAWbD7tXO7d7Qf
         lNqa9RGLzyxzrPZ+MgMupx7y3j4OPZIX7EgSTyU0Ek6kmM0+1cgfd/L1cvrtuEduDb9N
         6a2lfAFfsSZuM/eKXApI5m7o+S0U26XYBPZr1+PNO7HoyRBqoOyzz+LJBDnS+ZGVTarT
         0RWli5yBrqM6zHgjJzINxvA5pep6dw8aC+0XEPmiwuWUdXPg4MTZ3/HTUwXws53IQx2Z
         iQ02gWqGiXi3lXYgQ4omctO1/DszuLJH7nPVh62Q6puV+rKIZYpxQmeHJ4UC7NfDtKU1
         v1KQ==
X-Gm-Message-State: AOAM533HO7tmGIJQm7IbLUYapoW6g/thX8IdZ3ci3bXg4S3ni6iZXdxB
        SkxE3KMXQrkLyOYSnnNCbtkKk4iZtcAMDKg7mns=
X-Google-Smtp-Source: ABdhPJzNOyiJtihGftn/TLilOutjHqIOaGo4Zf/aO1amcxWp0qbGniRPVoLnPeDenWoYts6kVzYA/Wg8KGlGLGib/tI=
X-Received: by 2002:a25:ba10:0:b0:656:e295:9aca with SMTP id
 t16-20020a25ba10000000b00656e2959acamr2187310ybg.458.1653555190813; Thu, 26
 May 2022 01:53:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-7-jiangshanlai@gmail.com> <YoPT6petoQUnF4vB@google.com>
In-Reply-To: <YoPT6petoQUnF4vB@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 26 May 2022 16:52:59 +0800
Message-ID: <CAJhGHyAK7zNQ+XKjGJThtQwmhKAVVNa2+=PgOOOaWfgNg0YA-g@mail.gmail.com>
Subject: Re: [PATCH V2 6/7] KVM: X86/MMU: Allocate mmu->pae_root for PAE
 paging on-demand
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello

Thank you for the review.

On Wed, May 18, 2022 at 12:57 AM David Matlack <dmatlack@google.com> wrote:

> >
> > -static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> > +static void __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>
> vcpu is now unused.

Removed in V3.

>
> >  {
> > -     struct page *page;
> >       int i;
> >
> >       mmu->root.hpa = INVALID_PAGE;
> >       mmu->root.pgd = 0;
> >       for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> >               mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
>
> optional: Consider open-coding this directly in kvm_mmu_create() and
> drop __kvm_mmu_create().

__kvm_mmu_create() is kept, and I don't want to duplicate this code.


> >  }
> >
> >  int kvm_mmu_create(struct kvm_vcpu *vcpu)
>
> kvm_mmu_create() could return void now too.

Did in v3.

Thanks
Lai
