Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1AB57BF8A
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 23:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiGTV0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 17:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGTV0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 17:26:15 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488B922B36
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:26:14 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 17so7250094pfy.0
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HCY796BMJ2oxk4qGgRmjBRC8Xu8JftRftOsx1tYR+B0=;
        b=XDvCGfbA1C8gkVaIGW/X8rxKS3oy3mMldq/gc3wMQyZyXK+URjRMofgHodqHsrdr9C
         tCe/niRyj2oX4geF4nHQjazu2BPPuOU1PcFfbRLJ2410NGhDchKOX1CYPKh/QeuIl7CO
         vZcke62x4v9g1UDW8BOmQz6Zu/uq2MorjqLfU85HP4NBiVnNbA4LWM3k2xht1HTaXzcr
         AEkOkwqz6i7qqLSPcDF5Z6V4mPIR2k8my4SuxHFRjof88vOan0rS25HMVbwM+exgs5E9
         J0Dl5fN7n38nfxUHgSLwA/ZWenlHg+6+PFgs30H48MLSskG66egw7dR+CQ6hF9D2adyh
         RDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HCY796BMJ2oxk4qGgRmjBRC8Xu8JftRftOsx1tYR+B0=;
        b=sHxlrK2CRKpCapzKhCOHuBhj4jqzc5MIyAg13dHpz9tpzNS+5eW8d3GMWlT2iXJSq/
         RkrVJ1g4DTN6iX1ZDEbF1mExRb3gdnuYmVu6yUaHWdQJCVc6+QTUG8b6YXisjJ/XhkiG
         TNEGxUV3C+kRqxm9rZmuTzV9aMzQGaVcOStnsrMXlCZU0YHXl76ZEczQ9FYWtvtqAMGB
         hyShxeSqHZNiv1yteviZeggqynuWbZnppfpAqMK5JMpFRx2FE1/AwyjpR+M4Rf5VFSfD
         SA0PnWbY5Zg3QDTI8SGVukGCFArQFE2H4+rR5SK+6IHSSyWL2L/1Ej5qTS7QZxIkhsv/
         XA4g==
X-Gm-Message-State: AJIora/9a/XvG/0aUc+LHVqNbN8lIo3V7nV4dP4H0yrJTtI3Xdzhg/Rx
        hS2EcPUsRvaMpqr/0ZUEW26MYg==
X-Google-Smtp-Source: AGRyM1u2Toix/4MkWUmJIpxn45NOXxn1ehVFBWt9jErGZXNwxhmyu+pJbUt1b9EMJDEd/3TGpw9dwQ==
X-Received: by 2002:a05:6a02:30d:b0:412:9de2:eb48 with SMTP id bn13-20020a056a02030d00b004129de2eb48mr34567838pgb.47.1658352373632;
        Wed, 20 Jul 2022 14:26:13 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902ec8f00b0016b8746132esm30750plg.105.2022.07.20.14.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 14:26:12 -0700 (PDT)
Date:   Wed, 20 Jul 2022 14:26:09 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <Ythy8XXN2rFytXdr@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-4-ricarkol@google.com>
 <87edyhz68i.wl-maz@kernel.org>
 <Yte/YXWYSikyQcqh@google.com>
 <875yjsyv67.wl-maz@kernel.org>
 <Ythw1UT1wFHbY/jN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ythw1UT1wFHbY/jN@google.com>
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

On Wed, Jul 20, 2022 at 02:17:09PM -0700, Ricardo Koller wrote:
> On Wed, Jul 20, 2022 at 10:45:20AM +0100, Marc Zyngier wrote:
> > On Wed, 20 Jul 2022 09:40:01 +0100,
> > Ricardo Koller <ricarkol@google.com> wrote:
> > > 
> > > On Tue, Jul 19, 2022 at 12:34:05PM +0100, Marc Zyngier wrote:
> > > > On Mon, 18 Jul 2022 16:49:10 +0100,
> > > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > > 
> > > > > A chained event overflowing on the low counter can set the overflow flag
> > > > > in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> > > > > Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> > > > > (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> > > > > overflow.
> > > > 
> > > > Isn't this indicative of a bug in the KVM emulation? To be honest, the
> > > > pseudocode looks odd. It says:
> > > > 
> > > > <quote>
> > > > 	if old_value<64:ovflw> != new_value<64:ovflw> then
> > > > 	    PMOVSSET_EL0<idx> = '1';
> > > > 	    PMOVSCLR_EL0<idx> = '1';
> > > > </quote>
> > > > 
> > > > which I find remarkably ambiguous. Is this setting and clearing the
> > > > overflow bit? Or setting it in the single register that backs the two
> > > > accessors in whatever way it can?
> > > > 
> > > > If it is the second interpretation that is correct, then KVM
> > > > definitely needs fixing
> > > 
> > > I think it's the second, as those two "= '1'" apply to the non-chained
> > > counters case as well, which should definitely set the bit in PMOVSSET.
> > > 
> > > > (though this looks pretty involved for
> > > > anything that isn't a SWINC event).
> > > 
> > > Ah, I see, there's a pretty convenient kvm_pmu_software_increment() for
> > > SWINC, but a non-SWINC event is implemented as a single 64-bit perf
> > > event.
> > 
> > Indeed. Which means we need to de-optimise chained counters to being
> > 32bit events, which is pretty annoying (for rapidly firing events, the
> > interrupt rate is going to be significantly higher).
> > 
> > I guess we should also investigate the support for FEAT_PMUv3p5 and
> > native 64bit counters. Someone is bound to build it at some point.
> 
> The kernel perf event is implementing 64-bit counters using chained
> counters. I assume this is already firing an interrupt for the low
> counter overflow; we might need to just hook into that, investigating...
> 

Additionally, given that the kernel is already emulating 64-bit
counters, can KVM just expose FEAT_PMUv3p5? Assuming all the other new
features can be emulated.

Thanks,
Ricardo

> > 
> > Thanks,
> > 
> > 	M.
> > 
> > -- 
> > Without deviation from the norm, progress is not possible.
