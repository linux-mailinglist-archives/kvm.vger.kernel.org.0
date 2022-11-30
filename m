Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF0663E578
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiK3XbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiK3Xav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:30:51 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF3F9839A
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:21:21 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id k5so209581pjo.5
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oOrPD6CB7rqzyj1SaEV3kuD/IhDMhOZPI51nCiB/NGg=;
        b=ZRW2ZUTv1n147KoQiZQIoZW74j4A7EtjIYOcRFO0rF0DPUCmy6VUy2g0JuJ1nS/0PG
         bPSRbTqLAdAfhndt51DMfOPkb6sHyNfjGeyL8kdbar+k+xIpBX4SiQnfKVs3jxbhY30i
         fE+0B93J3f1zH3nafXrLqY7rdRuq0maSuVI9QpeW8enceqQk351ZWU6NHH/BazdCHb+E
         L5o+TvbdnPsX9MioomkdsvtUqYHZQq6KqAvnuPAuThxGPwZ++G4eWoki6stkyg4QcWza
         6l0SCQXCBclmuJYQ9VytxAYkOvwHCR0J4TrW1rGbFwPNrD/IzVnCsAgUxIa0vHOndA6A
         NTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOrPD6CB7rqzyj1SaEV3kuD/IhDMhOZPI51nCiB/NGg=;
        b=393na+N4boAWqHQs0MyUEjqu1Z3KgNEp9qBqffrkONj0/gAiUC+Bbf5xvUII0KFX02
         NNoCoZSoy63aifUmimEvAaV01Zt8qpeUeGxewP1wjws33EDBLm1EJrM7NUuoCecI4pOf
         Q/lKykuJRyQIW4SgNxHCmAI+AS7nvibWGV7LQ77JMsbLJwwMmugbze4l04jwUo8OwpUI
         OCe7Xv/RBjz+arieE1UuJhZvjBq+hlOwERrOO7bVWdpiCDcFXpuVmT2BaCRMFg4NNQ3G
         4j53NOPFdgFepWWdCWL628Ln+vrMGG5FxQyF7QhKxk375ISjumDuJLHywrEfVm/2KFzn
         8Stg==
X-Gm-Message-State: ANoB5pk9uvGa2ZNyfjCZtaIB0N2uqvUeDz8Dxo4qsQ1gIDcrbGu6fv+T
        zoPF3U3crf+Cf9deQOAu/pQbCA==
X-Google-Smtp-Source: AA0mqf7MFNPbEgt6osld/lAYA9wa6vF/JYI716/qDYMZhDxdPiOnFjxOBihEjXxstiNyC9WOq9G0Fg==
X-Received: by 2002:a17:90a:d24e:b0:218:b478:f44f with SMTP id o14-20020a17090ad24e00b00218b478f44fmr46173649pjw.232.1669850480496;
        Wed, 30 Nov 2022 15:21:20 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id o13-20020a17090a0a0d00b0021896fa945asm3637054pjo.15.2022.11.30.15.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 15:21:20 -0800 (PST)
Date:   Wed, 30 Nov 2022 15:21:16 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4flbAiRyGgpDvnJ@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
 <Y4Zw/J3srTsZ57P7@google.com>
 <Y4Z2aWVEnluy+d3+@google.com>
 <Y4awiKLuKORZmU2z@google.com>
 <87pmd4ua2q.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmd4ua2q.wl-maz@kernel.org>
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

On Wed, Nov 30, 2022 at 08:21:17AM +0000, Marc Zyngier wrote:
> On Wed, 30 Nov 2022 01:23:20 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Tue, Nov 29, 2022 at 09:15:21PM +0000, Oliver Upton wrote:
> > > Hi Ricardo,
> > > 
> > > Thanks for having a look.
> > > 
> > > On Tue, Nov 29, 2022 at 12:52:12PM -0800, Ricardo Koller wrote:
> > > > On Tue, Nov 29, 2022 at 07:19:44PM +0000, Oliver Upton wrote:
> > > 
> > > [...]
> > > 
> > > > > +	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> > > > > +				       &pte, NULL, 0);
> > > > > +	if (!ret)
> > > > > +		dsb(ishst);
> > > > 
> > > > At the moment, the only reason for stage2_update_leaf_attrs() to not
> > > > update the PTE is if it's not valid:
> > > > 
> > > > 	if (!kvm_pte_valid(pte))
> > > > 			return 0;
> > > > 
> > > > I guess you could check that as well:
> > > > 
> > > > +	if (!ret || kvm_pte_valid(pte))
> > > > +		dsb(ishst);
> > > 
> > > Thanks for catching this.
> > > 
> > > Instead of pivoting on the returned PTE value, how about we return
> > > -EAGAIN from the early return in stage2_attr_walker()? It would better
> > > match the pattern used elsewhere in the pgtable code.
> > 
> > That works, although I would use another return code (e.g., EINVAL)? as
> > that's not exactly a "try again" type of error.
> 
> EINVAL usually is an indication of something that went horribly wrong.
> 
> But is that really a failure mode? Here, failing to update the PTE
> should not be considered a failure, but just a benign race: access
> fault being taken on a CPU and the page being evicted on another (not
> unlikely, as the page was marked old before).

I see, I agree, what you describe not look like a failure.

> 
> And if I'm correct above, this is definitely a "try again" situation:
> you probably won't take the same type of fault the second time though.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
