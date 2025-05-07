Return-Path: <kvm+bounces-45758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 329E9AAE8E9
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 20:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 752BC168E2A
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 18:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A455C28D832;
	Wed,  7 May 2025 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e+GKT1ap"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38581E1DF6
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 18:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746641971; cv=none; b=MOmPKkyC9D9fbkRSSZwlqQt87DWUyMlDCet0JfRPecqRN5n4EoDHSKrJ/XVaLFT+xEcGSt7nVb5LIqlpwuBtGplEfSwo9R0eBy+PYRPXGWPmzsVpxK+Q9VqStFLtTONCmfX/yTl7aJYZdwEF0l0Q9F6kW5LeY0/K1LtyHTH3bcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746641971; c=relaxed/simple;
	bh=OgHrWq4xLDulgcrrBBiptq/JSvgZJjDMx4jTGBTNveI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W6SGU0AiH1WC9TzAPMzXBnPYBBNIE/uMvL3ZaAod1w61O0q0snt5hWfljfiHOe2bhvGYTIb551qDlok9EBCUtlkw7EvMWSyee8Z/k/7kWANGb71VUQ+5qUt3hhFkPGT/CMtQnk0JJ98RHuJ54YUnWswfqFUibfAK4mScKUJcWP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e+GKT1ap; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso1497a12.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 11:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746641968; x=1747246768; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6RWkibYvTDos/q8cARoD72Lyukyk0pL7dyIDsIbmwk=;
        b=e+GKT1apYgNwDOljGWYWH28EHsU627fvUaDvFj6Sk8i7TVgueXcAfLU7DI3vKvmVVU
         suTYibfQJ8BV9CF7OBje4saBtWX5CR26u4UCeNKmA2om3vCZ7qiI6eAKbDRi4DgEM4Hy
         ch5yWN4jSlGXrWpE/8WKfhlVWRMRuhKO2+LBrzLy/nxpDLSWlkh/z7t5WwO9m8JQvh/g
         GPpd+YUFaTlgqmR2jmswNc01uc41INt9/m1CkQSpaZ773C1UhjtJKxtPp2ZVht6EJPCs
         VYjwasxeRS8qvo2enG8B5Iq1RClTrS6/Nxz00BX4z+Uut+BV71BrLy7KVptTJzBOtz0L
         E3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746641968; x=1747246768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y6RWkibYvTDos/q8cARoD72Lyukyk0pL7dyIDsIbmwk=;
        b=i21BFxnHkTT6tLxJGdWmuHk6/iZuZ7usSmPfTky/RCGk9UcZ7yotbEp5WIkR1+Htgc
         BksHqqpju0XmXZ3WC3HHWHteYlc2iJSp4Rucra77xBScRnPoD6GTBheRoMZ4VWZWH/AM
         nYyPu9f/a3/I2LLwuDNu/QQ7o6/C4TgWZ7GKl+kGhoDlio4Pgi96WVyS0yc+kLaqmHsM
         +4+ONcu5r3S42w/DIb8ujXBeY3oPmOPo/fK+dsJQfxbuC8XEfRuBrdQYg/1RpiaR+COx
         pz6smIeeSvIZI5amPV4UeXW2RJKQPiyVxTJqVhFgikaNAJsKN33vgm+3sXx5y3AaZIcz
         vVaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOVUSjQtWzrsuQ2AUHFWdeW3M2mOfyN8o4yxYd6KLOFP4w5bCTLt8ok+BwIbF8stx6uM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW9/i2OC0K8zS/4rT+ywFtm3ISoReERkAYVAWxCUBnZIwOh+6B
	BMkrPaa0HzYZUg6dLHVaEBJ4EyZxW7yBHZK7ETvhO5PYvYibbofopPnwq6JbHnJ5MXWlMj7ZwIl
	mL5CSHbMPHoeG0rHYLicNi77HcNWdOVr/mq8M
X-Gm-Gg: ASbGncuh0llOukXs4GXJ30wraoQEGYEy5f6uxqxpt5RoWybe6zEBkwtW4ZVWcN2Qy8D
	pvA9wWLn5QYgetIpgvLmKQ37V/Ya38G86NT+d1kxfroYIbK6YefCDD3ViqHvli5dOoFlottqiSa
	Jru4+5C67REMAWYRGDY1RnXg==
X-Google-Smtp-Source: AGHT+IEf+G7T5D3uQzkvIA/W55itfVcAmrLpH3EUnAX7l4ayNtrku4NOk+UP8hPgrNXjTaPfArXR0/ooSR9qAjnc/Ew=
X-Received: by 2002:a05:6402:7c2:b0:5fa:af3b:337b with SMTP id
 4fb4d7f45d1cf-5fc4c1f2801mr2925a12.7.1746641967413; Wed, 07 May 2025 11:19:27
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250321221444.2449974-1-jmattson@google.com> <20250321221444.2449974-3-jmattson@google.com>
 <aBAqzZOiCCYWgOrM@google.com>
In-Reply-To: <aBAqzZOiCCYWgOrM@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 7 May 2025 11:19:15 -0700
X-Gm-Features: ATxdqUHHSEPnh5rNXSyppCmjkYfGd-fa3GqzOZRvOlCWraBySvK8zDgRFCC2Ays
Message-ID: <CALMp9eS5hqD-F8k=4YOGFedOWjgc=rDvqP+98gOrn9ne68NNpA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 6:26=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Mar 21, 2025, Jim Mattson wrote:
> > +#include <fcntl.h>
> > +#include <limits.h>
> > +#include <pthread.h>
> > +#include <sched.h>
> > +#include <stdbool.h>
> > +#include <stdio.h>
> > +#include <stdint.h>
> > +#include <unistd.h>
> > +#include <asm/msr-index.h>
> > +
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "test_util.h"
> > +
> > +#define NUM_ITERATIONS 100
> > +
> > +static void pin_thread(int cpu)
> > +{
> > +     cpu_set_t cpuset;
> > +     int rc;
> > +
> > +     CPU_ZERO(&cpuset);
> > +     CPU_SET(cpu, &cpuset);
> > +
> > +     rc =3D pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cp=
uset);
> > +     TEST_ASSERT(rc =3D=3D 0, "%s: Can't set thread affinity", __func_=
_);
>
> Heh, you copy-pasted this from hardware_disable_test.c, didn't you?  :-)

Probably.

> Would it make sense to turn this into a generic API that takes care of th=
e entire
> sched_getcpu() =3D> pthread_setaffinity_np()?  E.g. kvm_pin_task_to_curre=
nt_cpu().
> I suspect there are other (potential) tests that don't care about what CP=
U they
> run on, so long as the test is pinned.

Sure.

> > +}
> > +
> > +static int open_dev_msr(int cpu)
> > +{
> > +     char path[PATH_MAX];
> > +     int msr_fd;
> > +
> > +     snprintf(path, sizeof(path), "/dev/cpu/%d/msr", cpu);
> > +     msr_fd =3D open(path, O_RDONLY);
> > +     __TEST_REQUIRE(msr_fd >=3D 0, "Can't open %s for read", path);
>
> Please use open_path_or_exit().

TIL.

> Hmm, and I'm planning on posting a small series to add a variant that tak=
es an
> ENOENT message, and spits out a (hopefully) helpful message for the EACCE=
S case.
> It would be nice to have this one spit out something like "Is msk.ko load=
ed?",
> but I would say don't worry about trying to coordinate anything.  Worst c=
ase
> scenario we can add a help message when the dust settles.
>
> > +     return msr_fd;
> > +}
> > +
> > +static uint64_t read_dev_msr(int msr_fd, uint32_t msr)
> > +{
> > +     uint64_t data;
> > +     ssize_t rc;
> > +
> > +     rc =3D pread(msr_fd, &data, sizeof(data), msr);
> > +     TEST_ASSERT(rc =3D=3D sizeof(data), "Read of MSR 0x%x failed", ms=
r);
> > +
> > +     return data;
> > +}
> > +
> > +static void guest_code(void)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; i < NUM_ITERATIONS; i++) {
> > +             uint64_t aperf =3D rdmsr(MSR_IA32_APERF);
> > +             uint64_t mperf =3D rdmsr(MSR_IA32_MPERF);
> > +
> > +             GUEST_SYNC2(aperf, mperf);
>
> Does the test generate multiple RDMSR per MSR if you do:
>
>                 GUEST_SYNC2(rdmsr(MSR_IA32_APERF), rdmsr(MSR_IA32_MPERF))=
;
>
> If the code generation comes out

I'll have to check.

>
> > +     }
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +static bool kvm_can_disable_aperfmperf_exits(struct kvm_vm *vm)
> > +{
> > +     int flags =3D vm_check_cap(vm, KVM_CAP_X86_DISABLE_EXITS);
> > +
> > +     return flags & KVM_X86_DISABLE_EXITS_APERFMPERF;
> > +}
>
> Please don't add one-off helpers like this, especially when they're the c=
ondition
> for TEST_REQUIRE().  I *want* the gory details if the test is skipped, so=
 that I
> don't have to go look at the source code to figure out what's missing.
>
> And it's literally more code.

Okay.

> > +
> > +int main(int argc, char *argv[])
> > +{
> > +     uint64_t host_aperf_before, host_mperf_before;
> > +     int cpu =3D sched_getcpu();
> > +     struct kvm_vcpu *vcpu;
> > +     struct kvm_vm *vm;
> > +     int msr_fd;
> > +     int i;
> > +
> > +     pin_thread(cpu);
> > +
> > +     msr_fd =3D open_dev_msr(cpu);
> > +
> > +     /*
> > +      * This test requires a non-standard VM initialization, because
> > +      * KVM_ENABLE_CAP cannot be used on a VM file descriptor after
> > +      * a VCPU has been created.
>
> Hrm, we should really sort this out.  Every test that needs to enable a c=
apability
> is having to copy+paste this pattern.  I don't love the idea of expanding
> __vm_create_with_one_vcpu(), but there's gotta be a solution that isn't h=
orrible,
> and anything is better than endly copy paste.

This is all your fault, I believe. But, I'll see what I can do.

> > +      */
> > +     vm =3D vm_create(1);
> > +
> > +     TEST_REQUIRE(kvm_can_disable_aperfmperf_exits(vm));
>
>         TEST_REQUIRE(vm_check_cap(vm, KVM_CAP_X86_DISABLE_EXITS) &
>                      KVM_X86_DISABLE_EXITS_APERFMPERF);
> > +
> > +     vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
> > +                   KVM_X86_DISABLE_EXITS_APERFMPERF);
> > +
> > +     vcpu =3D vm_vcpu_add(vm, 0, guest_code);
> > +
> > +     host_aperf_before =3D read_dev_msr(msr_fd, MSR_IA32_APERF);
> > +     host_mperf_before =3D read_dev_msr(msr_fd, MSR_IA32_MPERF);
> > +
> > +     for (i =3D 0; i < NUM_ITERATIONS; i++) {
> > +             uint64_t host_aperf_after, host_mperf_after;
> > +             uint64_t guest_aperf, guest_mperf;
> > +             struct ucall uc;
> > +
> > +             vcpu_run(vcpu);
> > +             TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> > +
> > +             switch (get_ucall(vcpu, &uc)) {
> > +             case UCALL_DONE:
> > +                     break;
> > +             case UCALL_ABORT:
> > +                     REPORT_GUEST_ASSERT(uc);
> > +             case UCALL_SYNC:
> > +                     guest_aperf =3D uc.args[0];
> > +                     guest_mperf =3D uc.args[1];
> > +
> > +                     host_aperf_after =3D read_dev_msr(msr_fd, MSR_IA3=
2_APERF);
> > +                     host_mperf_after =3D read_dev_msr(msr_fd, MSR_IA3=
2_MPERF);
> > +
> > +                     TEST_ASSERT(host_aperf_before < guest_aperf,
> > +                                 "APERF: host_before (%lu) >=3D guest =
(%lu)",
> > +                                 host_aperf_before, guest_aperf);
>
> Honest question, is decimal really better than hex for these?

They are just numbers, so any base should be fine. I guess it depends
on which base you're most comfortable with. I could add a command-line
parameter.

> > +                     TEST_ASSERT(guest_aperf < host_aperf_after,
> > +                                 "APERF: guest (%lu) >=3D host_after (=
%lu)",
> > +                                 guest_aperf, host_aperf_after);
> > +                     TEST_ASSERT(host_mperf_before < guest_mperf,
> > +                                 "MPERF: host_before (%lu) >=3D guest =
(%lu)",
> > +                                 host_mperf_before, guest_mperf);
> > +                     TEST_ASSERT(guest_mperf < host_mperf_after,
> > +                                 "MPERF: guest (%lu) >=3D host_after (=
%lu)",
> > +                                 guest_mperf, host_mperf_after);
> > +
> > +                     host_aperf_before =3D host_aperf_after;
> > +                     host_mperf_before =3D host_mperf_after;
> > +
> > +                     break;
> > +             }
> > +     }
> > +
> > +     TEST_ASSERT_EQ(i, NUM_ITERATIONS);
>
> Why?

I think this was leftover from a version where it was possible to
break out of the loop early. I'll get rid of it.

V4 this week, I hope.

