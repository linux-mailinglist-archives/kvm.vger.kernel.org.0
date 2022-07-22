Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639D157E937
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 23:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiGVVxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 17:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiGVVx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 17:53:29 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111D31D0F2
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 14:53:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gq7so5431349pjb.1
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 14:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S6pM7yq1RIWZUFHWp5NyUGItu7YK/wHkNLpEwhm+gAs=;
        b=O07SrDsgEl+d/zKWLQMPBDEQDAo000CkkqHcsCh8q6CnYytQaWOyxCuR4OABimqADE
         ZJh/qWp7hAviJfgSt7PY/gCqpAivj+ssWdsJcC0EXloN6a7PwaJonMKBY31DahKEbAzz
         VgWgyU9Phyj2LJYws/AUXivfUIwEXGHghIFW8olizGLVP12tsa7Ui8GAB1zeu7ivwOwR
         xHsE2j2I4uRs/i07TQqJgjxW4eU9ViZhd3o8XHGGi2etQkEYYlUMTEeH+llNmAGZ3bFS
         SNvo9TYqZJBWQk0zQE/2I+JsU2gGQYNcB3UgKpBj9ESKXvC7KOyvIRJSRg5mWsRp1XEX
         n5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S6pM7yq1RIWZUFHWp5NyUGItu7YK/wHkNLpEwhm+gAs=;
        b=SIJx67puQpw4P3OVb/WMwFxBOFsp2cpjLNZuylKoq57wiJhBYv/HRn3WeKzz6kQahv
         +bMryVHyinZCCIlqwdrE6zVevF4ifFqWFYOt5c/b55ihttZA2LRbyKXr1WAncH/uQAI/
         xmS1rfPx2Wo4Fg6MRDiFRqtGbeMnVG0a5c6BfRKPrejBv4FCY6Ng9U0bgRf3wtLLPoYw
         qSY1oXZ1OgJi302b7wUFilEXRmu475Vnv4wcSciR+TtBJGmGKLX4QnhbfVKKTLcmHBsX
         3FtDGff/Zp44g6tbT7oAKOcrDAMin25mEFMy9nJgw9mUWGY74xLWlxlNcJ81CEZuRtuq
         vcrw==
X-Gm-Message-State: AJIora/XYG4qizdz447Tk2MFyVhXtUfg3rvF14cBqfZkIBzZ3chU8w+Y
        AWrEK3624RkcymKwV+v83A/clw==
X-Google-Smtp-Source: AGRyM1upi8J2h0f0cG4koEjNdjH06Hz8MmGxVW5TEAAOvhqiSLHzlrP8Oo0RFjbVT0YxDTSrMenNeA==
X-Received: by 2002:a17:90a:7aca:b0:1f1:ff59:fe7e with SMTP id b10-20020a17090a7aca00b001f1ff59fe7emr1808995pjl.11.1658526805227;
        Fri, 22 Jul 2022 14:53:25 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id d92-20020a17090a6f6500b001f2474a6683sm2095240pjk.38.2022.07.22.14.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 14:53:24 -0700 (PDT)
Date:   Fri, 22 Jul 2022 14:53:20 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <YtscUOUGKra3LpsK@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-4-ricarkol@google.com>
 <87edyhz68i.wl-maz@kernel.org>
 <Yte/YXWYSikyQcqh@google.com>
 <875yjsyv67.wl-maz@kernel.org>
 <Ythw1UT1wFHbY/jN@google.com>
 <Ythy8XXN2rFytXdr@google.com>
 <871quezill.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871quezill.wl-maz@kernel.org>
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

On Thu, Jul 21, 2022 at 02:43:50PM +0100, Marc Zyngier wrote:
> On Wed, 20 Jul 2022 22:26:09 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Wed, Jul 20, 2022 at 02:17:09PM -0700, Ricardo Koller wrote:
> > > On Wed, Jul 20, 2022 at 10:45:20AM +0100, Marc Zyngier wrote:
> > > > On Wed, 20 Jul 2022 09:40:01 +0100,
> > > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > > 
> > > > > On Tue, Jul 19, 2022 at 12:34:05PM +0100, Marc Zyngier wrote:
> > > > > > On Mon, 18 Jul 2022 16:49:10 +0100,
> > > > > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > > > > 
> > > > > > > A chained event overflowing on the low counter can set the overflow flag
> > > > > > > in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> > > > > > > Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> > > > > > > (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> > > > > > > overflow.
> > > > > > 
> > > > > > Isn't this indicative of a bug in the KVM emulation? To be honest, the
> > > > > > pseudocode looks odd. It says:
> > > > > > 
> > > > > > <quote>
> > > > > > 	if old_value<64:ovflw> != new_value<64:ovflw> then
> > > > > > 	    PMOVSSET_EL0<idx> = '1';
> > > > > > 	    PMOVSCLR_EL0<idx> = '1';
> > > > > > </quote>
> > > > > > 
> > > > > > which I find remarkably ambiguous. Is this setting and clearing the
> > > > > > overflow bit? Or setting it in the single register that backs the two
> > > > > > accessors in whatever way it can?
> > > > > > 
> > > > > > If it is the second interpretation that is correct, then KVM
> > > > > > definitely needs fixing
> > > > > 
> > > > > I think it's the second, as those two "= '1'" apply to the non-chained
> > > > > counters case as well, which should definitely set the bit in PMOVSSET.
> > > > > 
> > > > > > (though this looks pretty involved for
> > > > > > anything that isn't a SWINC event).
> > > > > 
> > > > > Ah, I see, there's a pretty convenient kvm_pmu_software_increment() for
> > > > > SWINC, but a non-SWINC event is implemented as a single 64-bit perf
> > > > > event.
> > > > 
> > > > Indeed. Which means we need to de-optimise chained counters to being
> > > > 32bit events, which is pretty annoying (for rapidly firing events, the
> > > > interrupt rate is going to be significantly higher).
> > > > 
> > > > I guess we should also investigate the support for FEAT_PMUv3p5 and
> > > > native 64bit counters. Someone is bound to build it at some point.
> > > 
> > > The kernel perf event is implementing 64-bit counters using chained
> > > counters. I assume this is already firing an interrupt for the low
> > > counter overflow; we might need to just hook into that, investigating...
> 
> We probably only enable the overflow interrupt on the odd counter, and
> not the even one (which is why you request chained counters the first
> place).
> 
> And perf wouldn't call us back anyway, as we described the counter as
> 64bit.
> 
> > Additionally, given that the kernel is already emulating 64-bit
> > counters, can KVM just expose FEAT_PMUv3p5? Assuming all the other new
> > features can be emulated.
> 
> This is what I suggested above. Although it can only happen on a
> system that already supports FEAT_PMU3p4, as PMMIR_EL1 is not defined
> before that (and FEAT_PMU3p5 implies 3p4).
> 
> It also remains that we need to *properly* emulate chained counters,
> which means not handling them as 64bit counters in perf, but as a
> 32bit counter and a carry (exactly like the pseudocode does).
> 

Got it, thanks.

Which brings me to what to do with this test. Should it be fixed for
bare-metal by ignoring the PMOVSSET check? or should it actually check
for PMOVSSET=1 and fail on KVM until KVM gets fixed?

Thanks,
Ricardo

> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
