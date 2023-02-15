Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF88E6987FB
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 23:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjBOWgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 17:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBOWgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 17:36:41 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3C830295
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 14:36:35 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4bdeb1bbeafso297817b3.4
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 14:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MIQXENS2+4sMRi90b513aA2Q153GZQ5k/QlHWLrBT2A=;
        b=ZYNMMFGaenxLALBL2wkoeLLWcRxUq1y7auD4MvNvGfv7MW/Zzc/6OHVvmxXZRo37Ts
         8/VwxU1tz7UOrJDGnVVvI9umeMJ8Mrwf4dkYFiLWNbBJJn2StxZrQIbSnrz91gyzZYYX
         uOyl7AUZuu1wbDe2EHq/mdEBIDBLp/2mfczeovyZsREMzhd2TkaxmVpMygdx0JcoRJuC
         xD++nMj3f6cIhIUyh2bjcr+O3TbIvzS7aLGXeMYY0WcmhH3cm/voZhTh1tK+Rqc9MD0U
         1EA4n4R9MpBLmY7RjZvdOFeVHRRjPNO/C+va5TZ5TJdYdKgR6y0xE6zSfNfGgM8S0/se
         +AFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MIQXENS2+4sMRi90b513aA2Q153GZQ5k/QlHWLrBT2A=;
        b=7r5fPWc1NtTnNr1Q91nDJ2uFXHm2SEHMkNwzQsUgyg33R9Hoyui/PmieJtMHEiiqIZ
         OZKKd9qKhm19puPyz4u4Jhkippo2hMAZ0GIaflFLUhLoqtGMbgIxqF+TY+BKrIttYpq1
         EhjCz9klVanbvJDrwfEeRfGJDAoGsRe6px4iW5u2JDC35zMUa+4JQa5QahY1nm2EtZTS
         ghTb0YzX76CQkxAAwFdsMsrCkH41npjF7MUBneYAyoUIbh7jz3TJ4Yqg9mVoxWxuEmGJ
         b588/g+kwhs+ndhjTyYqerrfYTwtdf9Y3nI+k39UgCCcpjekp0KL71bL8GYulwjavQy+
         watQ==
X-Gm-Message-State: AO0yUKWpE+ckm5monELhbTmwdddxyjHDljC4/xDKvqMoMm2Q9b4SAZV2
        2qZ71bizFxDfAlzavyV7bZHR2/hR6vg=
X-Google-Smtp-Source: AK7set9tYoNoI6QJwihu1gK/MM6fk7qfD/5z/sIGddBwvpoJr9Je1x7HajVcrjAMbO/AaomTOeaybmdzZf4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:dc41:0:b0:52e:cebf:a440 with SMTP id
 f62-20020a0ddc41000000b0052ecebfa440mr444390ywe.242.1676500595047; Wed, 15
 Feb 2023 14:36:35 -0800 (PST)
Date:   Wed, 15 Feb 2023 14:36:33 -0800
In-Reply-To: <4f0d03de-4372-2472-ef59-e80bb3aa7703@gmail.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com> <20230210003148.2646712-6-seanjc@google.com>
 <4f0d03de-4372-2472-ef59-e80bb3aa7703@gmail.com>
Message-ID: <Y+1ecVEQhgEGIqMy@google.com>
Subject: Re: [PATCH v2 05/21] KVM: x86: Disallow writes to immutable feature
 MSRs after KVM_RUN
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023, Like Xu wrote:
> On 10/2/2023 8:31 am, Sean Christopherson wrote:
> > @@ -2168,6 +2187,23 @@ static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
> >   static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
> >   {
> > +	u64 val;
> > +
> > +	/*
> > +	 * Disallow writes to immutable feature MSRs after KVM_RUN.  KVM does
> > +	 * not support modifying the guest vCPU model on the fly, e.g. changing
> > +	 * the nVMX capabilities while L2 is running is nonsensical.  Ignore
> > +	 * writes of the same value, e.g. to allow userspace to blindly stuff
> > +	 * all MSRs when emulating RESET.
> > +	 */
> > +	if (vcpu->arch.last_vmentry_cpu != -1 &&
> 
> Three concerns on my mind (to help you think more if any):
> - why not using kvm->created_vcpus;

Because this is a vCPU scoped ioctl().

> - how about different vcpu models of the same guest have different
> feature_msr values;

KVM shouldn't care.  If KVM does care, then that's a completely orthogonal bug
that needs to be fixed separately.

> (although they are not altered after the first run, cases (selftests) may be
> needed to
> show that it is dangerous for KVM);
> 
> - the relative time to set "vcpu->arch.last_vmentry_cpu = vcpu->cpu" is
> still too late,
> since part of the guest code (an attack window) has already been executed on first
> run of kvm_x86_vcpu_run() which may run for a long time;

Again, this is a vCPU scoped ioctl.  The task doing KVM_RUN holds vcpu->mutex so
there is no race.
