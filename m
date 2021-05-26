Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3203916BA
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 13:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhEZL4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 07:56:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233999AbhEZLz3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 07:55:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622030036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J4tfG3Iivr0UDU/243VjSMS2UCgnXJX6AdyOu5WgiuE=;
        b=PepEzagc5d/caNfCIpX6LBJRnxCa8SdMosTmSQd//fELCvLn3hEykomlWJqanA9nf2qpx/
        VvDI0qQg+62iHaRR8jL0iIuDfdB73Bk6Vbs6GER1ODysGLyz324ZgMoCQ60dqr4DXIE27A
        NesIC523jnkUO/tEasKGL/UNNdqv9H4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-4jeLMr9HOaa-s6j9-fi3-g-1; Wed, 26 May 2021 07:53:54 -0400
X-MC-Unique: 4jeLMr9HOaa-s6j9-fi3-g-1
Received: by mail-ej1-f70.google.com with SMTP id p18-20020a1709067852b02903dab2a3e1easo302378ejm.17
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 04:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J4tfG3Iivr0UDU/243VjSMS2UCgnXJX6AdyOu5WgiuE=;
        b=iDHnwtr6kXL39cKb8EhbPt5Lw5pb9KKGvwHAgcqH9EKdQRzPJwo24tGYxufxiE9XVu
         B/2MQ0FwmJctIhgulmMDKwZHfyY3+k9qjVeGbp7ZxBVO4sHMRafLpAjEjRh1w2LO5CmL
         phbpPt0kebZBlIz1LAdN4krEp+k3gTpEf7iVpLNmYAqnEz/zxhvSkitWvO3r8sZ3El+O
         uTu3ajpoiCtHdHq+iuMWEmf4GVBMobZ0QiVBNN5peYIQWALbPENGPdY37qkXPILPqFNh
         UDkohM9bLdjhKZsJu7VfEWQs0dfL4yXKS5Enh1A2YLRKxFeNmWJH2Xgx9hTe1+M/iW25
         3xBg==
X-Gm-Message-State: AOAM5328fA7rwQPeb1/KDsgGIueZQEdKI8+/icOXjI+VsC9bcaJS4NMH
        fhLi/yoSWU1J+gSdXT3RU/h8suGLNw4E3eTrDV5wUuV1Fd9Zx/e1xTG2X5ReM8Iz1585wZ9uCxi
        2SgrfxQamLzQy
X-Received: by 2002:a17:906:e0d5:: with SMTP id gl21mr33494695ejb.93.1622030033142;
        Wed, 26 May 2021 04:53:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxt8+d1iX+DqR1qPCPmxp6q8NikFchjRljNvew5YHy3SdlULrSNFp6cnmOS2D/UnyGUZ2Y1FA==
X-Received: by 2002:a17:906:e0d5:: with SMTP id gl21mr33494666ejb.93.1622030032758;
        Wed, 26 May 2021 04:53:52 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id n24sm12465472edv.51.2021.05.26.04.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 04:53:52 -0700 (PDT)
Date:   Wed, 26 May 2021 13:53:50 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: Re: [PATCH v2 5/5] KVM: arm64: selftests: get-reg-list: Split base
 and pmu registers
Message-ID: <20210526115350.t72q34km2wyxtmpn@gator.home>
References: <20210519140726.892632-1-drjones@redhat.com>
 <20210519140726.892632-6-drjones@redhat.com>
 <YK1ZcqgyLFSDH14+@google.com>
 <87zgwhvq7r.wl-maz@kernel.org>
 <20210526093211.loppoo42twel6inw@gator.home>
 <87y2c1vm1m.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2c1vm1m.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 11:15:01AM +0100, Marc Zyngier wrote:
> On Wed, 26 May 2021 10:32:11 +0100,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > On Wed, May 26, 2021 at 09:44:56AM +0100, Marc Zyngier wrote:
> > > On Tue, 25 May 2021 21:09:22 +0100,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > 
> > > > On Wed, May 19, 2021 at 04:07:26PM +0200, Andrew Jones wrote:
> > > > > Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
> > > > > userspace when not available") the get-reg-list* tests have been
> > > > > failing with
> > > > > 
> > > > >   ...
> > > > >   ... There are 74 missing registers.
> > > > >   The following lines are missing registers:
> > > > >   ...
> > > > > 
> > > > > where the 74 missing registers are all PMU registers. This isn't a
> > > > > bug in KVM that the selftest found, even though it's true that a
> > > > > KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
> > > > > flag, but still expecting the PMU registers to be in the reg-list,
> > > > > would suddenly no longer have their expectations met. In that case,
> > > > > the expectations were wrong, though, so that KVM userspace needs to
> > > > > be fixed, and so does this selftest. The fix for this selftest is to
> > > > > pull the PMU registers out of the base register sublist into their
> > > > > own sublist and then create new, pmu-enabled vcpu configs which can
> > > > > be tested.
> > > > > 
> > > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > > > ---
> > > > >  .../selftests/kvm/aarch64/get-reg-list.c      | 46 +++++++++++++++----
> > > > >  1 file changed, 38 insertions(+), 8 deletions(-)
> > > > > 
> > > > > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > > > index dc06a28bfb74..78d8949bddbd 100644
> > > > > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > > > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > > > @@ -47,6 +47,7 @@ struct reg_sublist {
> > > > >  struct vcpu_config {
> > > > >  	const char *name;
> > > > >  	bool sve;
> > > > > +	bool pmu;
> > > > >  	struct reg_sublist sublists[];
> > > > >  };
> > > > 
> > > > I think it's possible that the number of sublists keeps increasing: it
> > > > would be very nice/useful if KVM allowed enabling/disabling more
> > > > features from userspace (besides SVE, PMU etc).
> > > 
> > > [tangential semi-rant]
> > > 
> > > While this is a very noble goal, it also doubles the validation space
> > > each time you add an option. Given how little testing gets done
> > > relative to the diversity of features and implementations, that's a
> > > *big* problem.
> > 
> > It's my hope that this test, especially now after its refactoring, will
> > allow us to test all configurations easily and therefore frequently.
> > 
> > > 
> > > I'm not against it for big ticket items that result in a substantial
> > > amount of state to be context-switched (SVE, NV). However, doing that
> > > for more discrete features would require a radical change in the way
> > > we develop, review and test KVM/arm64.
> > >
> > 
> > I'm not sure I understand how we should change the development and
> > review processes.
> 
> I'm worried that the current ratio of development vs review vs testing
> is simply not right. We have a huge reviewing deficit, and we end-up
> merging buggy code. Some of the features we simply cannot test. It was
> OK up to 3 years ago, but I'm not sure it is sustainable anymore.
> 
> So making more and more things optional seems to go further in the
> direction of an uncontrolled bitrot.

I guess the optional CPU features are just going to keep on coming. And,
while more reviewers would help, there will never be enough. I think the
only solution is to get more CI.

> 
> > As for testing, with simple tests like this one,
> > we can actually achieve exhaustive configuration testing fast, at
> > least with respect to checking for expected registers and checking
> > that we can get/set_one_reg on them. If we were to try and setup
> > QEMU migration tests for all the possible configurations, then it
> > would take way too long.
> 
> I'm not worried about this get/set thing. I'm worried about the full
> end-to-end migration, which hardly anyone tests in anger, with all the
> variability of the architecture and options.

It does get tested downstream, but certain configurations will likely
be neglected. For example, we've rarely, if ever, tested with the PMU
disabled. Also, testing downstream is a bit late. It'd be better if
tests were running on upstream branches, before even being merged to
master.

As for testing migration of devices other than the CPU, we do have
some QEMU unit tests for that which gate merger to QEMU master.

Anyway, while unit tests like this one may seem too simple to be useful,
assuming the tests mimic key parts of the fully integrated function, and
are run frequently, then they may catch regressions sooner, even during
development. The less frequently run integrated tests which happen later,
and with limited configs, may then be sufficient.

BTW, kvm-unit-tests can also test migrations. The VM configs are limited,
but CPU feature combinations could be tested thoroughly without too
much difficulty. That would at least include QEMU in the integration
testing, but unless we modify the tests to migrate between hosts with
different kernel versions (it's nice to try and support older -> newer),
then we're not testing the same type of thing that we're testing here with
this test.

Thanks,
drew

