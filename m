Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050FF57BF7D
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 23:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiGTVRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 17:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiGTVRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 17:17:18 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9253543E4F
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:17:14 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q43-20020a17090a17ae00b001f1f67e053cso3443440pja.4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tQHyBpRSTCYBnbK0Fk3s8ggzdCtx/PSGX/g/RqDYeCY=;
        b=fGWF+358TslHXlxBmpEYiwgEzF5sORn15yu/rsarTVfNc7KeRD5pY93dFBpzQjDizT
         wbRGNgYa4gD4dngtKRr8cDciJquwlW55cR7IsqGZXcrorfhiwf/8j9j3sNQLn2oiVUAY
         A6vn/BvNjBJypZaK+WiSXefLIOOBhxakvq9Gl7zE8I3aHeGCbR/8s6HXd6KA8qZ+Nen1
         CRrLbMguE4G8Nmhw+QUsW17FAoDrN8VN7mCywerEDf8jjHmpfOdtdZiMfmsa61twNlFU
         Sp5TLU6N6TC5uRcPDRJClm6l4aFLNqnLS8qFNsBAC2J9cdEWL3GSosp/TvNyzgDRa2Kq
         B0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tQHyBpRSTCYBnbK0Fk3s8ggzdCtx/PSGX/g/RqDYeCY=;
        b=MNcW34TIqWrwIsBYi/i2Y6rytN1bcbhwdcLeyLrGdzqF3UGGPj3R7NrJQTuJFvWT1G
         45yiHGig8IEgRqIauOrJZFLQZ7qjBvXtM3yM+oCJph0tdY5BzBZOPQClyCKK0Qxd3rpZ
         wv/TmE7vfB9NXBY+pPVR9n00CBu0oAz9Ak+3XG66qV4cJh1f952qrRUJQTdweUHITjFK
         0i3Fd/kq9wBWZJxFs66LjYc2olH6CrDkd38lT5UxCe5eF0oFDvvtkprexLGnwn3432P8
         JoIzOd4M2lIwFW3XvONPj0misGCiX7SlHdbSnDYCLnw/v85kNIx7Xwew+t7Ol77tO0Zr
         qP0Q==
X-Gm-Message-State: AJIora+z7yqLyTKrhUCeh8Kj1bHm18vCL7oz8qcAc3yKIEOcNiHyE9ge
        GQ6PdlKqzlGY3FqslmT5a0HGFw==
X-Google-Smtp-Source: AGRyM1vDHPOlYpgyqZYYJMzbqy0L7voAhL5Adrluh21PEp9U4e1Rn3MopGX0XhMrQ293NsnS71mTdg==
X-Received: by 2002:a17:902:efc4:b0:16d:20ea:44f4 with SMTP id ja4-20020a170902efc400b0016d20ea44f4mr4954173plb.113.1658351833935;
        Wed, 20 Jul 2022 14:17:13 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id l1-20020a63f301000000b00415320bc31dsm12379320pgh.32.2022.07.20.14.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 14:17:12 -0700 (PDT)
Date:   Wed, 20 Jul 2022 14:17:09 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <Ythw1UT1wFHbY/jN@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-4-ricarkol@google.com>
 <87edyhz68i.wl-maz@kernel.org>
 <Yte/YXWYSikyQcqh@google.com>
 <875yjsyv67.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yjsyv67.wl-maz@kernel.org>
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

On Wed, Jul 20, 2022 at 10:45:20AM +0100, Marc Zyngier wrote:
> On Wed, 20 Jul 2022 09:40:01 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Tue, Jul 19, 2022 at 12:34:05PM +0100, Marc Zyngier wrote:
> > > On Mon, 18 Jul 2022 16:49:10 +0100,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > 
> > > > A chained event overflowing on the low counter can set the overflow flag
> > > > in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> > > > Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> > > > (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> > > > overflow.
> > > 
> > > Isn't this indicative of a bug in the KVM emulation? To be honest, the
> > > pseudocode looks odd. It says:
> > > 
> > > <quote>
> > > 	if old_value<64:ovflw> != new_value<64:ovflw> then
> > > 	    PMOVSSET_EL0<idx> = '1';
> > > 	    PMOVSCLR_EL0<idx> = '1';
> > > </quote>
> > > 
> > > which I find remarkably ambiguous. Is this setting and clearing the
> > > overflow bit? Or setting it in the single register that backs the two
> > > accessors in whatever way it can?
> > > 
> > > If it is the second interpretation that is correct, then KVM
> > > definitely needs fixing
> > 
> > I think it's the second, as those two "= '1'" apply to the non-chained
> > counters case as well, which should definitely set the bit in PMOVSSET.
> > 
> > > (though this looks pretty involved for
> > > anything that isn't a SWINC event).
> > 
> > Ah, I see, there's a pretty convenient kvm_pmu_software_increment() for
> > SWINC, but a non-SWINC event is implemented as a single 64-bit perf
> > event.
> 
> Indeed. Which means we need to de-optimise chained counters to being
> 32bit events, which is pretty annoying (for rapidly firing events, the
> interrupt rate is going to be significantly higher).
> 
> I guess we should also investigate the support for FEAT_PMUv3p5 and
> native 64bit counters. Someone is bound to build it at some point.

The kernel perf event is implementing 64-bit counters using chained
counters. I assume this is already firing an interrupt for the low
counter overflow; we might need to just hook into that, investigating...

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
