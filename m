Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D874A7D8B73
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 00:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344937AbjJZWKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 18:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjJZWKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 18:10:37 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCDCD43
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 15:10:34 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1cc1e1e74beso927325ad.1
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 15:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698358233; x=1698963033; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I5wM/epRywLe5dHcashfDe4S7wcN1rZtdeLcCE6dR1g=;
        b=c/L5yYFJ/notIbO5PoAx6TA8smGqIWFXuA83aQTghXdT+3/pQb94jRl297f438MLqf
         uSt2J1M71X2cSSjZhWBJUrIZbhUdxxirfuXoTkdHv2GLHrhu/jvPbKJYPssSuHs8edvH
         1ndmMZI98Ewmq5nkbKTOgqoo3mNRrt5DeuXJhLR2WTtLHhtlqwSmtgHAjBRPKTjdRK/n
         GZQqGRKyNlXtTEcNlcw0r4KK+h7GM9Vs3Mbcnh54qmNAlL9tKIBBBGfYeEPXfPQp0GWQ
         ZmE5DzLaPn1NE4Kd5uc0bSNWq4ljm8ehYMYXuv9DGDdrzAs81ORM6bMqkGvsyjKaFuv4
         QKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698358233; x=1698963033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5wM/epRywLe5dHcashfDe4S7wcN1rZtdeLcCE6dR1g=;
        b=L+y3y6J6R1sKW3jqR50LsxrvV+z1x5jSG0qqEV0rkQhWyqy97+lin9nqXXlwH+5Z8O
         P5YGyuf3QISe7G8Cfpt7mc9MMiCpjBLZ01rJILxjgAUE3ATMRhDqtfS01BBAtbMqWAZA
         yFtrPTLgpIXvGobDuowE+WmW9D34aepPFkKoLVFvtDnhcZOURaE4qgS+L0akG8apDEev
         iaIhtIpcLfBYxmE+qsa0NuiHCoFqLBaf9hoBasYnVmMiAfVj6TthtOqv7TO8VInoJriD
         63LbugygEdxI2SgjJnZyQG7/BldUdhm2SJQL3POGtjcd3LzdWL/cgdaWRfrsaJ0Rp59+
         MWHg==
X-Gm-Message-State: AOJu0Yxy/R1/8vcmqUfi/JTZy/mjLT5ekOr1RzMjV91uKNT+dCB5BQQ+
        DYO63sxsgFLwfwKGbrctXwDnIg==
X-Google-Smtp-Source: AGHT+IHZTN/a6e20FO9L44mYA7tHChn18FscSLtrpd5fiHhIsxzNrEN4kRgO2FsM5/0rX9zbczHEWQ==
X-Received: by 2002:a17:903:4343:b0:1ca:e7f9:a487 with SMTP id lo3-20020a170903434300b001cae7f9a487mr808668plb.3.1698358233124;
        Thu, 26 Oct 2023 15:10:33 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id ja6-20020a170902efc600b001bbd1562e75sm174356plb.55.2023.10.26.15.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 15:10:32 -0700 (PDT)
Date:   Thu, 26 Oct 2023 22:10:28 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Subject: Re: [PATCH v5 08/13] KVM: selftests: Test Intel PMU architectural
 events on gp counters
Message-ID: <ZTrj1CRKLOVbcytz@google.com>
References: <20231024002633.2540714-1-seanjc@google.com>
 <20231024002633.2540714-9-seanjc@google.com>
 <ZTrOYztylSn7jNIE@google.com>
 <ZTrR638_KyKOwLIz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTrR638_KyKOwLIz@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023, Sean Christopherson wrote:
> On Thu, Oct 26, 2023, Mingwei Zhang wrote:
> > > +static bool pmu_is_intel_event_stable(uint8_t idx)
> > > +{
> > > +	switch (idx) {
> > > +	case INTEL_ARCH_CPU_CYCLES:
> > > +	case INTEL_ARCH_INSTRUCTIONS_RETIRED:
> > > +	case INTEL_ARCH_REFERENCE_CYCLES:
> > > +	case INTEL_ARCH_BRANCHES_RETIRED:
> > > +		return true;
> > > +	default:
> > > +		return false;
> > > +	}
> > > +}
> > 
> > Brief explanation on why other events are not stable please. Since there
> > are only a few architecture events, maybe listing all of them with
> > explanation in comments would work better.
> 
> Heh, I've already rewritten this logic to make 
> 
> 
> > > +
> > > +static void guest_measure_pmu_v1(struct kvm_x86_pmu_feature event,
> > > +				 uint32_t counter_msr, uint32_t nr_gp_counters)
> > > +{
> > > +	uint8_t idx = event.f.bit;
> > > +	unsigned int i;
> > > +
> > > +	for (i = 0; i < nr_gp_counters; i++) {
> > > +		wrmsr(counter_msr + i, 0);
> > > +		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
> > > +		      ARCH_PERFMON_EVENTSEL_ENABLE | intel_pmu_arch_events[idx]);
> > > +		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
> > 
> > Some comment might be needed for readability. Abuptly inserting inline
> > assembly code in C destroys the readability.
> > 
> > I wonder do we need add 'clobber' here for the above line, since it
> > takes away ecx?
> 
> It's already there.  You can't directly clobber a register that is used as an
> input constraint.  The workaround is to make the register both an input and an
> output, hense the "+c" in the outputs section instead of just "c" in the inputs
> section.  The extra bit of cleverness is to use an intermediate anonymous variable
> so that NUM_BRANCHES can effectively be passed in (#defines won't work as output
> constraints).
> 
> > Also, I wonder if we need to disable IRQ here? This code might be
> > intercepted and resumed. If so, then the test will get a different
> > number?
> 
> This is guest code, disabling IRQs is pointless.  There are no guest virtual IRQs,
> guarding aginst host IRQs is impossible, unnecessary, and actualy undesirable,
> i.e. the guest vPMU shouldn't be counting host instructions and whatnot.
> 
> > > +
> > > +		if (pmu_is_intel_event_stable(idx))
> > > +			GUEST_ASSERT_EQ(this_pmu_has(event), !!_rdpmc(i));
> > 
> > Okay, just the counter value is non-zero means we pass the test ?!
> 
> FWIW, I've updated 
> 
> > hmm, I wonder other than IRQ stuff, what else may affect the result? NMI
> > watchdog or what?
> 
> This is the beauty of selftests.  There _so_ simple that there are very few
> surprises.  E.g. there are no events of any kind unless the test explicitly
> generates them.  The downside is that doing anything complex in selftests requires
> writing a fair bit of code.

Understood, so we could support precise matching.
>
> > > +
> > > +		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
> > > +		      !ARCH_PERFMON_EVENTSEL_ENABLE |
> > > +		      intel_pmu_arch_events[idx]);
> > > +		wrmsr(counter_msr + i, 0);
> > > +		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
> > ditto for readability. Please consider using a macro to avoid repeated
> > explanation.
> 
> Heh, already did this too.  Though I'm not entirely sure it's more readable.  It's
> definitely more precise and featured :-)
> 
Oh dear, this is challenging to my rusty inline assembly skills :)

> #define GUEST_MEASURE_EVENT(_msr, _value, clflush, FEP)				\
> do {										\
> 	__asm__ __volatile__("wrmsr\n\t"					\
> 			     clflush "\n\t"					\
> 			     "mfence\n\t"					\
> 			     "1: mov $" __stringify(NUM_BRANCHES) ", %%ecx\n\t"	\
> 			     FEP "loop .\n\t"					\
> 			     FEP "mov %%edi, %%ecx\n\t"				\
> 			     FEP "xor %%eax, %%eax\n\t"				\
> 			     FEP "xor %%edx, %%edx\n\t"				\
> 			     "wrmsr\n\t"					\
> 			     : "+c"((int){_msr})				\
isn't it NUM_BRANCHES?
> 			     : "a"((uint32_t)_value), "d"(_value >> 32),	\
> 			       "D"(_msr)					\
> 	);									\
> } while (0)
>

do we need this label '1:' in the above code? It does not seems to be
used anywhere within the code.

why is clflush needed here?
> 
> > > +int main(int argc, char *argv[])
> > > +{
> > > +	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> > > +
> > > +	TEST_REQUIRE(host_cpu_is_intel);
> > > +	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
> > > +	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
> > > +	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
> > 
> > hmm, this means we cannot run this in nested if X86_FEATURE_PDCM is
> > missing. It only affects full-width counter, right?
> 
> Ah, yeah, good call.  It won't be too much trouble to have the test play nice
> with !PDCM.
