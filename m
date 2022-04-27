Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0B9511E8E
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244434AbiD0R6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 13:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiD0R6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 13:58:10 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EA0FBE9A
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 10:54:59 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id bo5so2206075pfb.4
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 10:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MT32fDJjlSBzqa3QKuJ5nhMxgjthrXwBcbluFoTXiG8=;
        b=XrlZ0sC0DN1ViPQWIG+U1AYra+oQuWHZkOZa7i5jc3k++0oqDF0bxhJqZ7tVFcmarW
         6cJKqw2Q4vHIV6xRS2XNlsL859y9bSmxd1a1FPkc/wAFtBLNmF5MrhZXdovor6LdsEJk
         aYvOQM6rNaQIOXwonX+Ei9B6kNXnQxvQqeAwziq6/D92gSLXNnC4L+piFYKCw/UqE851
         HZ3KGyFTaRQeZYdCviIedcXzT3s/P5/bmRRZYuJ3XRjDMxjhHfVSDr5Ir6Dzz+/+P1J3
         2NtMoL+3dshT0GKulhTWOGITsveQVRxoKDuu4t+2qeULzydJSHhCFlUWNjmHb6SAi56N
         co9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MT32fDJjlSBzqa3QKuJ5nhMxgjthrXwBcbluFoTXiG8=;
        b=r/5qSDQhtsgo8mzB+O9NtYKLx1pSpIPf7KiVb9sZbXw88LtgOW5L3XdtfS4ACYidkg
         rAW0Jq6V6Wfk7ckYkYthpt6PsF6CVEPtnF+NUXwLfZ0gVFT17ISIe919YfCIT09YoX7E
         tIaB3TYXryCTjJneXxDfRAt/Tv5+iXW2uC3JZ5iuDR/ecmjeYJ5Az7klvrwtdgzJPZBR
         RBPWMqZhmweOpLfaIvAWjZ5PoQN8uKb9eiGDHvJl93tfkTu6y5+E/omEXUMbvjb0hLtF
         a08M78WTKN97AKqapj+ultMxWBLDXkiX/y8KZP1BBj25MkTf8EFIuyDkud/NohwkDgCn
         f1xA==
X-Gm-Message-State: AOAM530FtnjImOquIEXdmkBYk0UKAyNmaBnlXpKZK+1ETC6cXC4AANXW
        K36C1x+igKpIeOH+07yRx5SFfes39gHZvw==
X-Google-Smtp-Source: ABdhPJz5Dn0oFvNCe+SmriYc4GHgZrKoad23n7swbCCTGMvsAmMooBVrKAFcuF4wUp3NnwokJpfCOQ==
X-Received: by 2002:a63:4c0f:0:b0:39d:b7f6:fdb9 with SMTP id z15-20020a634c0f000000b0039db7f6fdb9mr25257993pga.601.1651082098525;
        Wed, 27 Apr 2022 10:54:58 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id f16-20020aa78b10000000b0050a81508653sm19375044pfd.198.2022.04.27.10.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 10:54:57 -0700 (PDT)
Date:   Wed, 27 Apr 2022 10:54:54 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, andre.przywara@arm.com, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, pshier@google.com
Subject: Re: [PATCH 1/4] KVM: arm64: vgic: Check that new ITEs could be saved
 in guest memory
Message-ID: <YmmDbtOUHMbcg2nV@google.com>
References: <20220425185534.57011-1-ricarkol@google.com>
 <20220425185534.57011-2-ricarkol@google.com>
 <871qxkcws3.wl-maz@kernel.org>
 <Ymgb8+dOEs03GvAX@google.com>
 <8735hzague.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735hzague.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 06:34:49PM +0100, Marc Zyngier wrote:
> On Tue, 26 Apr 2022 17:21:07 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Tue, Apr 26, 2022 at 05:07:40AM +0100, Marc Zyngier wrote:
> > > On Mon, 25 Apr 2022 19:55:31 +0100,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > 
> > > > A command that adds an entry into an ITS table that is not in guest
> > > > memory should fail, as any command should be treated as if it was
> > > > actually saving entries in guest memory (KVM doesn't until saving).
> > > > Add the corresponding check for the ITT when adding ITEs.
> > > > 
> > > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > > ---
> > > >  arch/arm64/kvm/vgic/vgic-its.c | 34 ++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 34 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > > > index 2e13402be3bd..d7c1a3a01af4 100644
> > > > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > > > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > > > @@ -976,6 +976,37 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
> > > >  	return ret;
> > > >  }
> > > >  
> > > > +/*
> > > > + * Check whether an event ID can be stored in the corresponding Interrupt
> > > > + * Translation Table, which starts at device->itt_addr.
> > > > + */
> > > > +static bool vgic_its_check_ite(struct vgic_its *its, struct its_device *device,
> > > > +		u32 event_id)
> > > > +{
> > > > +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> > > > +	int ite_esz = abi->ite_esz;
> > > > +	gpa_t gpa;
> > > > +	gfn_t gfn;
> > > > +	int idx;
> > > > +	bool ret;
> > > > +
> > > > +	/* max table size is: BIT_ULL(device->num_eventid_bits) * ite_esz */
> > > > +	if (event_id >= BIT_ULL(device->num_eventid_bits))
> > > > +		return false;
> > > 
> > > We have already checked this condition, it seems.
> > > 
> > > > +
> > > > +	gpa = device->itt_addr + event_id * ite_esz;
> > > > +	gfn = gpa >> PAGE_SHIFT;
> > > > +
> > > > +	idx = srcu_read_lock(&its->dev->kvm->srcu);
> > > > +	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
> > > > +	srcu_read_unlock(&its->dev->kvm->srcu, idx);
> > > > +	return ret;
> > > 
> > > Why should we care? If the guest doesn't give us the memory that is
> > > required, that's its problem.
> > 
> > The issue is that if the guest does that, then the pause will fail and
> > we won't be able to migrate the VM. This series objective is to help
> > with failed migrations due to the ITS. This commit tries to do it by
> > avoiding them.
> 
> But the guest is buggy, isn't it? No memory, no cookie! ;-)
> 
> I understand that you want save/restore to be predictable even when
> the guest is too crap for words. I think clarifying this in your
> commit message would help.
> 
> > > The only architectural requirement is
> > > that the EID fits into the device table. There is no guarantee that
> > > the ITS will actually write to the memory.
> > 
> > If I understand it correctly, failing the command in this case would
> > also be architectural (right?). If the ITS tries to write the new
> > entry into memory immediately, then the command would fail. This
> > proposed check is just making this assumption.
> 
> Neither behaviour is architectural (they are both allowed, but none
> is required). Not providing the memory, however, is unpredictable.
> 
> I'm OK with your approach because it makes things consistent (we fail
> early rather than late). But the commit message doesn't really reflect
> that (it sort of hints to it, but not in a clear way).
> 

Sounds good, will do that, thanks.

> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
