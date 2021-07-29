Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14273DAE00
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 23:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhG2VFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 17:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhG2VFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 17:05:05 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4E0C061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 14:05:01 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e21so8459466pla.5
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 14:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EP+r5M4uIgFrLN0QnuC7exccoFAbiw7t8szAQCZZaGQ=;
        b=h3JM1kXRoW/gjzhelVo2I6e/iUmHeSC4qExI7VE7vgAzNvkZvW0HAoH8Voq+JsaYjh
         8YdbjaME/e11D+Y62dAyOTs1RL8dZFEgwCe6ALp0f/8RzI+OV0gomvjRnuXdh9GYcAEJ
         hQuWwaYzxvJQdvzgcntZ5bUirAZ+YnM1lM2B0ixdZzwZovwCJV1VEphcda3tDUfTIehT
         rb17AOxCs3e0ltFXwVRVyh8Oo30mZfqoHn95XhhKz16i5y13oCRWyT79RV8q3Z57YvWP
         aAM16XeCTv4VRmJlmQBXJyZ3x26W++Z+p4B1cxHoLD8eE/G91yVSzkj3kqmXi6rkMtEf
         G2Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EP+r5M4uIgFrLN0QnuC7exccoFAbiw7t8szAQCZZaGQ=;
        b=cI3/tKlGdyQw00O2Px3CrzG5Codtcdq2tUyXme3UZSo58gk6Yorbqj43PtFac819o/
         c4fqzf4jVZAYU5uVk9QKY0rKro5Y4sSQe5dnFsbVzmgIO2ljVT22GEZRubZs2V574cal
         11/atMpampy8Zer5YAw0YtzyHAiR4ZO6CHF/DVKv/ZtwKg+6ZqdXUArLBVmo8livZB6l
         8D5hufZYVSz6gZ2ELOt2A73DKbyOH0fFfwWL+vLrH/W+CDwUwPZjOIm7XhjKjfmPMRj9
         lIT8jzyH7D+y42bFm3tdYPr5sCehIm7vJnRoE4sH+UpQab8oy+/a+SkfPWCRmlOMsJJZ
         7kLg==
X-Gm-Message-State: AOAM531A+SsYZ+vYSq3wCDuGd0SHeRJTwthns58YLi35z7KpLKkiqjs5
        msxFdrflxnCBskvEOM+67Im0Fw==
X-Google-Smtp-Source: ABdhPJz3RzAgV9k+AtcJXBCANsAyZSnhKfxFWzA1ZCPYLjrvjhCsRLZQHYCkyF9W6ffnXU4L92TSJQ==
X-Received: by 2002:a65:5bc6:: with SMTP id o6mr5507306pgr.2.1627592700695;
        Thu, 29 Jul 2021 14:05:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v206sm4702868pfc.67.2021.07.29.14.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 14:05:00 -0700 (PDT)
Date:   Thu, 29 Jul 2021 21:04:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: A question of TDP unloading.
Message-ID: <YQMX+Cvo8GKCo3Zt@google.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <YQGj8gj7fpWDdLg5@google.com>
 <20210729032200.qqb4mlctgplzq6bb@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729032200.qqb4mlctgplzq6bb@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021, Yu Zhang wrote:
> On Wed, Jul 28, 2021 at 06:37:38PM +0000, Sean Christopherson wrote:
> > On Wed, Jul 28, 2021, Yu Zhang wrote:
> In the caller, force_tdp_unload was set to false for CR0/CR4/EFER changes. For SMM and
> cpuid updates, it is set to true.
> 
> With this change, I can successfully boot a VM(and of course, number of unloadings is
> greatly reduced). But access test case in kvm-unit-test hangs, after CR4.SMEP is flipped.
> I'm trying to figure out why...

Hrm, I'll look into when I get around to making this into a proper patch.

Note, there's at least once bug, as is_root_usable() will compare the full role
against a root shadow page's modified role.  A common helper to derive the page
role for a direct/TDP page from an existing mmu_role is likely the way to go, as
kvm_tdp_mmu_get_vcpu_root_hpa() would want the same functionality.

> > I'll put this on my todo list, I've been looking for an excuse to update the
> > cr0/cr4/efer flows anyways :-).  If it works, the changes should be relatively
> > minor, if it works...
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a8cdfd8d45c4..700664fe163e 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2077,8 +2077,20 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >         role = vcpu->arch.mmu->mmu_role.base;
> >         role.level = level;
> >         role.direct = direct;
> > -       if (role.direct)
> > +       if (role.direct) {
> >                 role.gpte_is_8_bytes = true;
> > +
> > +               /*
> > +                * Guest PTE permissions do not impact SPTE permissions for
> > +                * direct MMUs.  Either there are no guest PTEs (CR0.PG=0) or
> > +                * guest PTE permissions are enforced by the CPU (TDP enabled).
> > +                */
> > +               WARN_ON_ONCE(access != ACC_ALL);
> > +               role.efer_nx = 0;
> > +               role.cr0_wp = 0;
> > +               role.smep_andnot_wp = 0;
> > +               role.smap_andnot_wp = 0;
> > +       }
> 
> How about we do this in kvm_calc_mmu_role_common()? :-)

No, because the role in struct kvm_mmu does need the correct bits, even for TDP,
as the role is used to detect whether or not the context needs to be re-initialized,
e.g. it would get a false negative on a cr0_wp change, not go through
update_permission_bitmask(), and use the wrong page permissions when walking the
guest page tables.
