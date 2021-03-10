Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8D53349B0
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 22:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhCJVOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 16:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbhCJVN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 16:13:59 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5E0C061574
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 13:13:59 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d8so9109151plg.10
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 13:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kAXMqxdxdneWktNp5H67SJO5q7mXClNQldO77UatuMM=;
        b=JMi1ZJRd3xHeYXZB52qu1XGvcIRoIVcM96RSTrU4DQg+c3jwejgLhkpKQWBOIWwujC
         1Zk1YhNZFbY6/ft8doAGhhJ2kJyr+mB5NQiiIKaoMUhF0xKKATP6rgwDmXwZtvYZdiRZ
         /D1UDNW+VdFUqyEFyaTj2F2oSKF5jFIesVrtCJeKtz9UQ+Ig4xQJV4MSofP8DNR9qQKQ
         I2cfYqjgWnzvrafQ8wTjC2KKqC4oZCy7C3ZuCLhZsitQ2C5Rg0K3KUhPpEDbWp/kghQh
         XizeeaISFSU8hzCWqJZZ5EOx2tlkX6Ib+EctWag9rgzC+dKzL38yGJdhtcT7SdHhOB65
         NdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kAXMqxdxdneWktNp5H67SJO5q7mXClNQldO77UatuMM=;
        b=QBMXLjNvWS3aVrNKmyeUEjWAXfbyEZX6uAt3Yh9IWdAD7Oe1XhEiS4O9NaAK1q6dR/
         BM+mjf+knCFROQBtfR8Be35KEbbQo+CpG2MenDz6kYi23aqoJYVDaOHl+Jhng7EKmr/F
         HCVZK9OO04uCasek1+RsiF3uNdUVX8KeBCvDBawbEiZR6Z4t6jvUm6ZvDljGCSDRk7LV
         IuH6E4/yy2TTv49FrTlwVIo3E8h1e7tjXZ0tsM91ZLF1vATEFx8L928glLR5q7S23jgw
         KOuueTj56gy846/MFINnwLWd/mGL1swL7kRO0o8u5LIQalLLe3nqw6VATamImGzrykVj
         oudA==
X-Gm-Message-State: AOAM533hlx3j0a5LZNfI6erM589l7pFcmc5af3v9qlwCNf9VEMnkiZks
        hoxZBRXnp3VaqzweBdrsZIUdmw==
X-Google-Smtp-Source: ABdhPJyH62glBEwklUAhJ9Knc5yX1P0ERojERB5UvOQmfV5bJhw/HVriZa6AQuZHQ9BY6xyA099ahw==
X-Received: by 2002:a17:902:e906:b029:e5:c6d2:7dd0 with SMTP id k6-20020a170902e906b02900e5c6d27dd0mr4759310pld.12.1615410838821;
        Wed, 10 Mar 2021 13:13:58 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
        by smtp.gmail.com with ESMTPSA id u17sm364023pgl.80.2021.03.10.13.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 13:13:58 -0800 (PST)
Date:   Wed, 10 Mar 2021 13:13:52 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Skip !MMU-present SPTEs when removing SP
 in exclusive mode
Message-ID: <YEk2kBRUriFlCM62@google.com>
References: <20210310003029.1250571-1-seanjc@google.com>
 <07cf7833-c74a-9ae0-6895-d74708b97f68@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07cf7833-c74a-9ae0-6895-d74708b97f68@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021, Paolo Bonzini wrote:
> On 10/03/21 01:30, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 50ef757c5586..f0c99fa04ef2 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -323,7 +323,18 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt,
> >   				cpu_relax();
> >   			}
> >   		} else {
> > +			/*
> > +			 * If the SPTE is not MMU-present, there is no backing
> > +			 * page associated with the SPTE and so no side effects
> > +			 * that need to be recorded, and exclusive ownership of
> > +			 * mmu_lock ensures the SPTE can't be made present.
> > +			 * Note, zapping MMIO SPTEs is also unnecessary as they
> > +			 * are guarded by the memslots generation, not by being
> > +			 * unreachable.
> > +			 */
> >   			old_child_spte = READ_ONCE(*sptep);
> > +			if (!is_shadow_present_pte(old_child_spte))
> > +				continue;
> >   			/*
> >   			 * Marking the SPTE as a removed SPTE is not
> 
> Ben, do you plan to make this path take mmu_lock for read?  If so, this
> wouldn't be too useful IIUC.

I can see kvm_mmu_zap_all_fast()->kvm_tdp_mmu_zap_all() moving to a shared-mode
flow, but I don't think we'll ever want to move away from exclusive-mode zapping
for kvm_arch_flush_shadow_all()->kvm_mmu_zap_all()->kvm_tdp_mmu_zap_all().  In
that case, the VM is dead or dying; freeing memory should be done as quickly as
possible.
