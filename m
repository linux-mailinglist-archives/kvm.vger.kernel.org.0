Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECE84040AB
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 23:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhIHVvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 17:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhIHVv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 17:51:29 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF24C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 14:50:21 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q68so4014047pga.9
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 14:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mpyy4auQpAVXPHkb/Qt9jfSIDOOiq0JFvfG5mQuouHk=;
        b=A2IVXrHWAam/jbYtd09fnokjevxMx7ZpbOvIT68k4TqNRvIh/8wukp0MGqbRJy+a5n
         BFC6hV4Ld87OIsLiIJ447d4fFHTDeMekke1ahzsmqcjhlubjLr4vdb6rFQ2jZ1DqUpxR
         0zYlu3UzQD9S7PiO3sY2pwgW6ZJPS7cidIhj45+ELubarexN1oSf8QCMLuEAJ8zpDBs5
         QFLoXDdj/JIE2J56GwPPsBxU/GQtetWPnmL9Y9i70xe3kzV+5CQFS686bp52iH4zpivK
         61MDJsx3oOLTOWtt71s5L+Sswup0lwv30hTeazg9+u4E72AsSgQsBScRdXLqAoK6L8aP
         SuDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mpyy4auQpAVXPHkb/Qt9jfSIDOOiq0JFvfG5mQuouHk=;
        b=l6abd/wkvoP52Z2IqjFW0tqhvh2J9ApDyyIuudQ4MXYLWOtP2jfwvGtSZUriiyQll+
         bbF4IyxVsgukpFloJzCmB/myuk7bknYBk6lkUWyGrA4KW0Gc30aIIcXqvJdb03/1Fd/R
         C4eixzbPbbixpLecX3enpKD3q60FwBNVN6AEeuUQOljRyRKw4eJCaVCvBmVhjMau2hW/
         7fQWqj6sV5g/ir7En0RjVplkhV86WVX5PFUzbr1UNu2tc7B5XE8lzEXIY5QnxTa2vg5/
         PsM9+TSiWx87YnOyNVFTZRS3PH7B0NrswxNja7Un4u+Fn79g+Z+HroW/aM3nlbxXaSnt
         u9WA==
X-Gm-Message-State: AOAM531kWR7r3yHP6Gi+9OGSBKu4JpBCNP/1nCLp1plMA5yYhL80SOJ8
        Yov/XOQHBCFF+o6Wcy4Y76zGwg==
X-Google-Smtp-Source: ABdhPJzRyUcE2S9uzNLkmd1EozoX+VZL0gSRHBDl1S+xIMkCCLxFIXjwGIL8REirGCUlmuZlSiZe7Q==
X-Received: by 2002:a63:374f:: with SMTP id g15mr284346pgn.2.1631137820471;
        Wed, 08 Sep 2021 14:50:20 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h13sm134675pgf.14.2021.09.08.14.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 14:50:19 -0700 (PDT)
Date:   Wed, 8 Sep 2021 14:50:16 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, Paolo Bonzini <pbonzini@redhat.com>,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
Message-ID: <YTkwGHdBcy7v/mSA@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <YTkr1c7S0wPRv6hH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTkr1c7S0wPRv6hH@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 08, 2021 at 09:32:05PM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Wed, Sep 08, 2021 at 02:03:19PM -0700, Ricardo Koller wrote:
> > Extend vgic_v3_check_base() to verify that the redistributor regions
> > don't go above the VM-specified IPA size (phys_size). This can happen
> > when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
> > 
> >   base + size > phys_size AND base < phys_size
> > 
> > vgic_v3_check_base() is used to check the redist regions bases when
> > setting them (with the vcpus added so far) and when attempting the first
> > vcpu-run.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 66004f61cd83..5afd9f6f68f6 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >  			rdreg->base)
> >  			return false;
> 
> Can we drop this check in favor of explicitly comparing rdreg->base with
> kvm_phys_size()? I believe that would be more readable.
>

You mean the integer overflow check above? in that case, I would prefer
to leave it, if you don't mind. It seems that this type of check is used
in some other places in KVM (like kvm_assign_ioeventfd and
vgic_v3_alloc_redist_region).

> > +
> > +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> > +			kvm_phys_size(kvm))
> > +			return false;
> >  	}
> >  
> >  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
> 
> --
> Thanks,
> Oliver
