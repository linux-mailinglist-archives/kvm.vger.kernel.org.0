Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB65244CE06
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 00:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbhKJXwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 18:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbhKJXwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 18:52:44 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8529DC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 15:49:56 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id h2so4143438ili.11
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 15:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3MGQph/Z9WoRyVfqL+556HAUG2iGxUtw9Bgst+PEKgs=;
        b=b1QfPiuoqB3cMdbfOoHfXZ9BQX+TRuDwV8p1coJLgStoQy0+ZFC+DS05y+TMTq041M
         0uUAiJqWTyYDi25qJSYP13zZ+6sosYn+aika+A/QrR+02Z7yuCuOPlCTHkkt0Zm0u0Pe
         RGgL135xif+erKk6ILrGPd8T55ppk/8BqFTowa5AvLoKq8u1Nz8SNjtYaFrmmRqW5zzM
         srr0/YedPxztwHFpzLd0OsvBb2FJm8837tcLG72W3pkSYsHCS8K2Fu1dJc/K8czZBSXW
         dBugD3b3wTiz/3ft/gAQXd2p9pKO4WGOf9PKwW06jWLjhcZat08gbDR5nn5Pt1Vz4zrJ
         GY9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3MGQph/Z9WoRyVfqL+556HAUG2iGxUtw9Bgst+PEKgs=;
        b=6lE2B5SDO94q6AQ5KRzhlafAAbl6kmVvifDEUTTHj81iegve/RR0nHoRhO9XbAcflZ
         ze032Grw3ZXyqd2Dtiz/E4hXP3GoHPMgH4H/j3n19lcbbM8Oj5is4RKuIDVy+RSKjOZb
         tcrzoMKniVVLGj463dZV5PlrtFlIm1YVxOkahGgvRnZ6eggEE4QsWEeuNozr0PJFLl6x
         LretV2JyP24OQ27+qwlHJwtUe8hB9ZlyQqZcYql0JIzKRd7aC5hEgsAv5W8kCXtJdtwo
         ybTX+jtOB+ScZzc/lkE8BmvC5kGhw/vVkoMLbza9EUOWHkoGg8XEtI30h9Fner28nO0J
         auOA==
X-Gm-Message-State: AOAM5307NvyRYCJNWUN6GvSpwtOhNyRKj8I8oR9hEk39XM0UVGBLptIi
        fWD5b4ADLbm6Cb5s4KDC6+Chd5kiXuPlDVQWCNz2gg==
X-Google-Smtp-Source: ABdhPJx2fbhg7NXM7GAmsiVfClUjuYAJaTbZDQ20OJSvQl3H1sQHeegwJw2ERdD7pMnhXwYblG7RNRyXKPEEMqK9LqE=
X-Received: by 2002:a05:6e02:1809:: with SMTP id a9mr1712736ilv.203.1636588195845;
 Wed, 10 Nov 2021 15:49:55 -0800 (PST)
MIME-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com> <20211110223010.1392399-12-bgardon@google.com>
 <80407e4a-36e1-e606-ed9f-74429f850e77@redhat.com>
In-Reply-To: <80407e4a-36e1-e606-ed9f-74429f850e77@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Nov 2021 15:49:44 -0800
Message-ID: <CANgfPd8hzDU+v52t9Kr=b48utC1p_j3yJ8gHzo-uifAxHbh-eQ@mail.gmail.com>
Subject: Re: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of make_spte
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021 at 2:45 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/10/21 23:30, Ben Gardon wrote:
> > -     WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),
> > +     WARN_ONCE(is_rsvd_spte(shadow_zero_check, spte, level),
> >                 "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
> > -               get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
> > +               get_rsvd_bits(shadow_zero_check, spte, level));
>
> Hmm, there is a deeper issue here, in that when using EPT/NPT (on either
> the legacy aka shadow or the TDP MMU) large parts of vcpu->arch.mmu are
> really the same for all vCPUs.  The only thing that varies is those
> parts that actually depend on the guest's paging mode---the extended
> role, the reserved bits, etc.  Those are needed by the emulator, but
> don't really belong in vcpu->arch.mmu when EPT/NPT is in use.
>
> I wonder if there's room for splitting kvm_mmu in two parts, such as
> kvm_mmu and kvm_guest_paging_context, and possibly change the walk_mmu
> pointer into a pointer to kvm_guest_paging_context.  This way the
> EPT/NPT MMU (again either shadow or TDP) can be moved to kvm->arch.  It
> should simplify this series and also David's work on eager page splitting.
>
> I'm not asking you to do this, of course, but perhaps I can trigger
> Sean's itch to refactor stuff. :)
>
> Paolo
>

I think that's a great idea. I'm frequently confused as to why the
struct kvm_mmu is a per-vcpu construct as opposed to being VM-global.
Moving part of the struct to be a member for struct kvm would also
open the door to formalizing the MMU interface a little better and
perhaps even reveal more MMU code that can be consolidated across
architectures.
