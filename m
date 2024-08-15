Return-Path: <kvm+bounces-24290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF9A953735
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A5DB1F231FA
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D821B29DA;
	Thu, 15 Aug 2024 15:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RlLxuOWk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25231AD404
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723735628; cv=none; b=vD4yt+909t10PO5Xlvk5BQhKyQYlciAqHwnxtR9JMrBIy2xDlwP+2npKAGxAhdXuXOvFOwWhhtP508xAZWSGiQbXkEQuZKmapTtop0XtKN0QgSuwLrqMzO0DkQ6PGj3WoRFFD6PIt2ZPCqaDSG9SPmrQRooWthtMU5gl/SDKxbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723735628; c=relaxed/simple;
	bh=YrN919Y9FqfBu2j4YDADgXBSZu5lpdL2jamR2Kx+XL4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eAaQNoLHKfKUGLh2aRQr6KHOkDwVkQe0mqE2xNfiMlLw7hVIiUDJ7AVATAj4OlXZbqatYRGYKzm9GVrVHbGqprMyi3crQHnukSMMUEMqnQkQfy2nhkiAX+DWgXcsrHkOkoXznLEVqXuSTX9MBYHX/QRycv+/GE/SNhb3vyAXg+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RlLxuOWk; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-45029af1408so146991cf.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 08:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723735625; x=1724340425; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QuG/Fq+SUnmijXT2ckmF7Z9R3PkF5WWWhbgjfHeCC5w=;
        b=RlLxuOWkmfdGAkF0anzUJu1MrV3hBVFIgrq5/JrhJWhaqH5hxFRDWs44e1bNGYkA1x
         XR3LrC5gZj8ktl4mX2MPrLtevYrMJA+8hupYayjgidioLAYb9eSRNzQ243PMFhiOXiqk
         544rfdhAA8uMR2TNj+/hMau/UMIG987v++Jh8R8IcvpF07sL0lZFKtkHXis/3tpAB+L/
         FaMdAtYB4BAKRPaVg/jwS1/rLU76JfCn4KNDvzz6GO2SkiVdSNwA26upOo7u59XGPcFY
         iQ3ie4ReIxYf0SH60ZF+AZZcS1bRhNdjPvR8q6giCkqqJW2iHjWJUsy9WPvq+qMyX5bS
         jG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723735625; x=1724340425;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QuG/Fq+SUnmijXT2ckmF7Z9R3PkF5WWWhbgjfHeCC5w=;
        b=r8anL7MRbCHTBlqCLa7JvXQXL3XEOtG5BMQfs2fw0eNYY6YCMMwsi16B5zGaT0Xv0t
         TPc2jO3+f7eHboRAInsuLFo1lLXEeyTqpwrSKWR9siM+KhkiwS8z1FcQlCkIglSdrJvu
         IUNw9pRP84Yp+N9LvWye/qxqfnoHtQ/Sbfz9Aw4ps/q6XuE4s1qBwJA6ChJTA14dQorL
         l1yVIsTedvce1qXps8UU09OSjsAw8ueNKR6PTpCHIaP/TFFCRxHovhOJ3xP/Yzwoa+SG
         MkCv/kvxdRvn8tYYZcnBRMnGyG4d/xiPeWcDzMDZO6og367jMlOCgqCU7rOJv9DT2glt
         Rksw==
X-Gm-Message-State: AOJu0YzGPMTN6pF5pBwqPb0jP6z46EoJAsI2qn3dB07J4DcDdQcFRtwu
	xvl48UlnccHTwOCw790XNse+Zq4qxNUzb6/wDxpJsCYF1b4VgNa9kMbAl+5scyJBU4XuACXb3nv
	6hp1+XMwJgKNjgKGkzJdKWIrfz2joT8920YL0
X-Google-Smtp-Source: AGHT+IGqAKs5o3SKpbfI8KiCwDi/1K3gWyKMIYhJAnAMqS8PSUlO/BbbQPkewXD5rKsl5LRrBm7EX7s+aKPZsTFVZmM=
X-Received: by 2002:a05:622a:1801:b0:44f:9db1:7fca with SMTP id
 d75a77b69052e-45368a516ecmr1669241cf.28.1723735625107; Thu, 15 Aug 2024
 08:27:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809183802.3572177-1-coltonlewis@google.com> <20240809183802.3572177-3-coltonlewis@google.com>
In-Reply-To: <20240809183802.3572177-3-coltonlewis@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 15 Aug 2024 08:26:51 -0700
Message-ID: <CAJHc60yHZiRAwc7Ew_P1TOc=ueEL-+D-j6UZvqya4ra9ZXLREw@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] KVM: arm64: selftests: Add arch_timer_edge_cases selftest
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "delay.h"
nit: Are we using any of the functions from delay.h?

> +#include "arch_timer.h"
> +#include "gic.h"
> +#include "vgic.h"
> +
> +const uint64_t CVAL_MAX = ~0ULL;
> +/* tval is a signed 32-bit int. */
> +const int32_t TVAL_MAX = INT_MAX;
> +const int32_t TVAL_MIN = INT_MIN;
nit: To be super clear, use INT32_{MIN|MAX}

> +
> +/* After how much time we say there is no IRQ. */
> +const uint32_t TIMEOUT_NO_IRQ_US = 50000;
> +
> +/* A nice counter value to use as the starting one for most tests. */
> +const uint64_t DEF_CNT = (CVAL_MAX / 2);
> +
> +/* Number of runs. */
> +const uint32_t NR_TEST_ITERS_DEF = 5;
> +
> +/* Default wait test time in ms. */
> +const uint32_t WAIT_TEST_MS = 10;
> +
> +/* Default "long" wait test time in ms. */
> +const uint32_t LONG_WAIT_TEST_MS = 100;
> +
Define all the above variables as 'static const'.

> +static int vtimer_irq, ptimer_irq;
> +
> +enum sync_cmd {
> +       SET_COUNTER_VALUE = 100001,
nit: Any specific reason to start with this value?

> +       USERSPACE_USLEEP,
> +       USERSPACE_SCHED_YIELD,
> +       USERSPACE_MIGRATE_SELF,
> +       NO_USERSPACE_CMD,
> +};

> +static void guest_irq_handler(struct ex_regs *regs)
> +{
> +       unsigned int intid = gic_get_and_ack_irq();
> +       enum arch_timer timer;
> +       uint64_t cnt, cval;
> +       uint32_t ctl;
> +       bool timer_condition, istatus;
> +
> +       if (intid == IAR_SPURIOUS) {
> +               atomic_inc(&shared_data.spurious);
Any reason why we are accounting for the spurious interrupts? I don't
see the test reading this anywhere.

> +               goto out;
> +       }
> +
> +       if (intid == ptimer_irq)
> +               timer = PHYSICAL;
> +       else if (intid == vtimer_irq)
> +               timer = VIRTUAL;
> +       else
> +               goto out;
> +
> +       ctl = timer_get_ctl(timer);
> +       cval = timer_get_cval(timer);
> +       cnt = timer_get_cntct(timer);
> +       timer_condition = cnt >= cval;
> +       istatus = (ctl & CTL_ISTATUS) && (ctl & CTL_ENABLE);
> +       GUEST_ASSERT_EQ(timer_condition, istatus);
What if both are false? I think checking these independently would be
a better way to go, even in terms of readability.

> +
> +       /* Disable and mask the timer. */
> +       timer_set_ctl(timer, CTL_IMASK);
> +
> +       atomic_inc(&shared_data.handled);
> +
> +out:
> +       gic_set_eoi(intid);
> +}
> +
> +static void set_cval_irq(enum arch_timer timer, uint64_t cval_cycles,
> +                        uint32_t ctl)
> +{
> +       atomic_set(&shared_data.handled, 0);
> +       atomic_set(&shared_data.spurious, 0);
> +       timer_set_cval(timer, cval_cycles);
> +       timer_set_ctl(timer, ctl);
> +}
> +
> +static void set_tval_irq(enum arch_timer timer, uint64_t tval_cycles,
> +                        uint32_t ctl)
> +{
> +       atomic_set(&shared_data.handled, 0);
> +       atomic_set(&shared_data.spurious, 0);
> +       timer_set_tval(timer, tval_cycles);
> +       timer_set_ctl(timer, ctl);
Maybe it's a good idea to set the ctl before the tval/cval. This is
just to avoid narrow races such as, when an IRQ is not needed but,
programming the tval/cval could generate an IRQ before we get a chance
to set ctl. The comment applies to the order in set_cval_irq() as
well.

> +
> +/*
> + * Should be called with IRQs masked.
nit: It might be easy to miss this. Can we add a safety check? Same
goes for other wait_* functions.

> +static void test_xval_check_no_irq(enum arch_timer timer, uint64_t xval,
> +                                  uint64_t usec, enum timer_view timer_view,
> +                                  sleep_method_t guest_sleep)
> +{
> +       local_irq_disable();
> +
> +       set_xval_irq(timer, xval, CTL_ENABLE | CTL_IMASK, timer_view);
> +       guest_sleep(timer, usec);
> +
> +       local_irq_enable();
> +       isb();
> +
> +       /* Assume success (no IRQ) after waiting usec microseconds */
> +       assert_irqs_handled(0);
The test cases calling into this expect no IRQ for the given
conditions. However, since you set CTL_IMASK above, we wouldn't be
getting an IRQ regardless of the fact that the timer condition is met
(erroneously) or not. Should we leave it unmasked and/or check
CTL_ISTATUS?

> +/* Test masking/unmasking a timer using the timer mask (not the IRQ mask). */
> +static void test_timer_control_mask_then_unmask(enum arch_timer timer)
> +{
> +       reset_timer_state(timer, DEF_CNT);
> +       set_tval_irq(timer, -1, CTL_ENABLE | CTL_IMASK);
> +
> +       /* Unmask the timer, and then get an IRQ. */
> +       local_irq_disable();
> +       timer_set_ctl(timer, CTL_ENABLE);
> +       wait_for_non_spurious_irq();
Do you want to loop through @irq_wait_method array like other test
routines or is there a specific reason to call only
wait_for_non_spurious_irq()?

> +
> +       assert_irqs_handled(1);
> +       local_irq_enable();
> +}
> +
> +/* Check that timer control masks actually mask a timer being fired. */
> +static void test_timer_control_masks(enum arch_timer timer)
> +{
> +       reset_timer_state(timer, DEF_CNT);
> +
> +       /* Local IRQs are not masked at this point. */
> +
> +       set_tval_irq(timer, -1, CTL_ENABLE | CTL_IMASK);
> +
> +       /* Assume no IRQ after waiting TIMEOUT_NO_IRQ_US microseconds */
> +       sleep_poll(timer, TIMEOUT_NO_IRQ_US);
Again, do we want to loop through @sleep_method array like other routines?

> +static void test_reprogram_timers(enum arch_timer timer)
> +{
> +       int i;
> +       uint64_t base_wait = test_args.wait_ms;
> +
> +       for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
> +               /*
> +                * Ensure reprogramming works whether going from a
> +                * longer time to a shorter or vice versa.
> +                */
> +               test_reprogramming_timer(timer, irq_wait_method[i], 2 * base_wait,
> +                                        base_wait);
> +               test_reprogramming_timer(timer, irq_wait_method[i], base_wait,
> +                                        2 * base_wait);
> +       }
> +
> +       for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
> +               test_reprogramming_timer_with_timeout(timer, sleep_method[i],
> +                                                     2 * base_wait, base_wait);
> +               test_reprogramming_timer_with_timeout(timer, sleep_method[i],
> +                                                     base_wait, 2 * base_wait);
Apart from the timeout part, is there anything else that's different
from the above (non-timeout) ones that I might be missing? If not,
would just having the timeout one give the coverage that we are
looking for?

> +       }
> +}
> +
> +static void test_basic_functionality(enum arch_timer timer)
> +{
> +       int32_t tval = (int32_t) msec_to_cycles(test_args.wait_ms);
> +       uint64_t cval;
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
> +               irq_wait_method_t wm = irq_wait_method[i];
> +
> +               cval = DEF_CNT + msec_to_cycles(test_args.wait_ms);
> +
nit: Similar to @tval, since the @cval variable doesn't change over
the course of the loop, may be set it outside?

> +               test_timer_cval(timer, cval, wm, true, DEF_CNT);
> +               test_timer_tval(timer, tval, wm, true, DEF_CNT);
> +       }
> +}
> +

> +
> +static void test_timers_sanity_checks(enum arch_timer timer)
> +{
> +       timers_sanity_checks(timer, false);
> +       /* Check how KVM saves/restores these edge-case values. */
> +       timers_sanity_checks(timer, true);
> +}
> +
> +static void test_set_cnt_after_tval_max(enum arch_timer timer, irq_wait_method_t wm)
> +{
> +       local_irq_disable();
> +       reset_timer_state(timer, DEF_CNT);
> +
> +       set_cval_irq(timer,
> +                    (uint64_t) TVAL_MAX +
> +                    msec_to_cycles(test_args.wait_ms) / 2, CTL_ENABLE);
> +
> +       set_counter(timer, TVAL_MAX);
> +       wm();
> +
> +       assert_irqs_handled(1);
When I first read this, I was thinking, "how will this assert pass if
the IRQs are disabled?". But then, I looked into wm() and saw that we
enable the IRQs there. Can we make this part easily readable or at
least add appropriate comments? The comment applies to
test_timer_xval(), test_set_cnt_after_xval(), and any other places
where this approach is taken,

> +       local_irq_enable();
> +}
> +
> +/* Test timers set for: cval = now + TVAL_MAX + wait_ms / 2 */
> +static void test_timers_above_tval_max(enum arch_timer timer)
> +{
> +       uint64_t cval;
> +       int i;
> +
> +       /*
> +        * Test that the system is not implementing cval in terms of
> +        * tval.  If that was the case, setting a cval to "cval = now
> +        * + TVAL_MAX + wait_ms" would wrap to "cval = now +
wait_ms / 2? Also, why /2? Is there a significance?

> +        * wait_ms / 2", and the timer would fire immediately. Test that it
> +        * doesn't.
> +        */
> +       for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
> +               reset_timer_state(timer, DEF_CNT);
> +               cval =
> +                   timer_get_cntct(timer) + TVAL_MAX +
> +                   msec_to_cycles(test_args.wait_ms) / 2;
> +               test_cval_no_irq(timer, cval,
> +                                msecs_to_usecs(test_args.wait_ms) / 2 +
> +                                TIMEOUT_NO_IRQ_US, sleep_method[i]);
> +       }
> +
> +       for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
> +               /* Get the IRQ by moving the counter forward. */
> +               test_set_cnt_after_tval_max(timer, irq_wait_method[i]);
> +       }
> +}
> +
> +/*
> + * Template function to be used by the test_move_counter_ahead_* tests.  It
> + * sets the counter to cnt_1, the [c|t]val, the counter to cnt_2, and
> + * then waits for an IRQ.
> + */
> +static void test_set_cnt_after_xval(enum arch_timer timer, uint64_t cnt_1,
> +                                   uint64_t xval, uint64_t cnt_2,
> +                                   irq_wait_method_t wm, enum timer_view tv)
> +{
> +       local_irq_disable();
> +
> +       set_counter(timer, cnt_1);
> +       timer_set_ctl(timer, CTL_IMASK);
Is the expectation that with cnt_1 programmed, we should not be seeing
an IRQ? If that's the case, should we unmask the interrupts and
assert_irqs_handled(0) and/or check CTL_ISTATUS?

> +
> +       set_xval_irq(timer, xval, CTL_ENABLE, tv);
> +       set_counter(timer, cnt_2);
> +       wm();
> +
> +       assert_irqs_handled(1);
> +       local_irq_enable();
> +}
> +
> +/*
> + * Template function to be used by the test_move_counter_ahead_* tests.  It
> + * sets the counter to cnt_1, the [c|t]val, the counter to cnt_2, and
> + * then waits for an IRQ.
"waits for an IRQ to not show up"?

> + */
> +static void test_set_cnt_after_xval_no_irq(enum arch_timer timer,
> +                                          uint64_t cnt_1, uint64_t xval,
> +                                          uint64_t cnt_2,
> +                                          sleep_method_t guest_sleep,
> +                                          enum timer_view tv)
> +{
> +       local_irq_disable();
> +
> +       set_counter(timer, cnt_1);
> +       timer_set_ctl(timer, CTL_IMASK);
> +
> +       set_xval_irq(timer, xval, CTL_ENABLE, tv);
> +       set_counter(timer, cnt_2);
> +       guest_sleep(timer, TIMEOUT_NO_IRQ_US);
> +
> +       local_irq_enable();
> +       isb();
> +
> +       /* Assume no IRQ after waiting TIMEOUT_NO_IRQ_US microseconds */
> +       assert_irqs_handled(0);
> +       timer_set_ctl(timer, CTL_IMASK);
> +}
> +

> +static void test_timers_in_the_past(enum arch_timer timer)
> +{
> +       int32_t tval = -1 * (int32_t) msec_to_cycles(test_args.wait_ms);
> +       uint64_t cval;
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
> +               irq_wait_method_t wm = irq_wait_method[i];
> +
> +               /* set a timer wait_ms the past. */
> +               cval = DEF_CNT - msec_to_cycles(test_args.wait_ms);
> +               test_timer_cval(timer, cval, wm, true, DEF_CNT);
> +               test_timer_tval(timer, tval, wm, true, DEF_CNT);
> +
> +               /* Set a timer to counter=0 (in the past) */
> +               test_timer_cval(timer, 0, wm, true, DEF_CNT);
> +
> +               /* Set a time for tval=0 (now) */
> +               test_timer_tval(timer, 0, wm, true, DEF_CNT);
> +
> +               /* Set a timer to as far in the past as possible */
> +               test_timer_tval(timer, TVAL_MIN, wm, true, DEF_CNT);
Is this part of the test any different from the above call,
test_timer_tval(timer, tval, wm, true, DEF_CNT)? I'm guessing both
would wrap around and meet the timer condition, with the only
difference of 'when'.

> +       }
> +
> +       /*
> +        * Set the counter to wait_ms, and a tval to -wait_ms. There should be no
> +        * timer as that tval means cval=CVAL_MAX-wait_ms.
> +        */
> +       for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
> +               sleep_method_t sm = sleep_method[i];
> +
> +               set_counter(timer, msec_to_cycles(test_args.wait_ms));
> +               test_tval_no_irq(timer, tval, TIMEOUT_NO_IRQ_US, sm);
> +       }
I'm not sure if I understand what we are trying to test here. Do you
mind re-framing the comment for better clarity?

> +}
> +
> +static void test_long_timer_delays(enum arch_timer timer)
> +{
> +       int32_t tval = (int32_t) msec_to_cycles(test_args.long_wait_ms);
> +       uint64_t cval;
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
> +               irq_wait_method_t wm = irq_wait_method[i];
> +
> +               cval = DEF_CNT + msec_to_cycles(test_args.long_wait_ms);
nit: Maybe set this outside the loop?

> +               test_timer_cval(timer, cval, wm, true, DEF_CNT);
> +               test_timer_tval(timer, tval, wm, true, DEF_CNT);
> +       }
> +}
> +

Thank you.
Raghavendra



>
> +
> +static void test_vm_create(struct kvm_vm **vm, struct kvm_vcpu **vcpu,
> +                          enum arch_timer timer)
> +{
> +       *vm = vm_create_with_one_vcpu(vcpu, guest_code);
> +       TEST_ASSERT(*vm, "Failed to create the test VM\n");
> +
> +       vm_init_descriptor_tables(*vm);
> +       vm_install_exception_handler(*vm, VECTOR_IRQ_CURRENT,
> +                                    guest_irq_handler);
> +
> +       vcpu_init_descriptor_tables(*vcpu);
> +       vcpu_args_set(*vcpu, 1, timer);
> +
> +       test_init_timer_irq(*vm, *vcpu);
> +       vgic_v3_setup(*vm, 1, 64);
> +       sync_global_to_guest(*vm, test_args);
> +}
> +
> +static void test_print_help(char *name)
> +{
> +       pr_info("Usage: %s [-h] [-b] [-i iterations] [-l long_wait_ms] [-p] [-v]\n"
> +               , name);
> +       pr_info("\t-i: Number of iterations (default: %u)\n",
> +               NR_TEST_ITERS_DEF);
> +       pr_info("\t-b: Test both physical and virtual timers (default: true)\n");
> +       pr_info("\t-l: Delta (in ms) used for long wait time test (default: %u)\n",
> +            LONG_WAIT_TEST_MS);
> +       pr_info("\t-l: Delta (in ms) used for wait times (default: %u)\n",
> +               WAIT_TEST_MS);
> +       pr_info("\t-p: Test physical timer (default: true)\n");
> +       pr_info("\t-v: Test virtual timer (default: true)\n");
> +       pr_info("\t-h: Print this help message\n");
> +}
> +
> +static bool parse_args(int argc, char *argv[])
> +{
> +       int opt;
> +
> +       while ((opt = getopt(argc, argv, "bhi:l:pvw:")) != -1) {
> +               switch (opt) {
> +               case 'b':
> +                       test_args.test_physical = true;
> +                       test_args.test_virtual = true;
> +                       break;
> +               case 'i':
> +                       test_args.iterations =
> +                           atoi_positive("Number of iterations", optarg);
> +                       break;
> +               case 'l':
> +                       test_args.long_wait_ms =
> +                           atoi_positive("Long wait time", optarg);
> +                       break;
> +               case 'p':
> +                       test_args.test_physical = true;
> +                       test_args.test_virtual = false;
> +                       break;
> +               case 'v':
> +                       test_args.test_virtual = true;
> +                       test_args.test_physical = false;
> +                       break;
> +               case 'w':
> +                       test_args.wait_ms = atoi_positive("Wait time", optarg);
> +                       break;
> +               case 'h':
> +               default:
> +                       goto err;
> +               }
> +       }
> +
> +       return true;
> +
> + err:
> +       test_print_help(argv[0]);
> +       return false;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       struct kvm_vcpu *vcpu;
> +       struct kvm_vm *vm;
> +
> +       /* Tell stdout not to buffer its content */
> +       setbuf(stdout, NULL);
> +
> +       if (!parse_args(argc, argv))
> +               exit(KSFT_SKIP);
> +
> +       if (test_args.test_virtual) {
> +               test_vm_create(&vm, &vcpu, VIRTUAL);
> +               test_run(vm, vcpu);
> +               kvm_vm_free(vm);
> +       }
> +
> +       if (test_args.test_physical) {
> +               test_vm_create(&vm, &vcpu, PHYSICAL);
> +               test_run(vm, vcpu);
> +               kvm_vm_free(vm);
> +       }
> +
> +       return 0;
> +}
> diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> index b3e97525cb55..bf461de34785 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> @@ -79,7 +79,7 @@ static inline uint64_t timer_get_cval(enum arch_timer timer)
>         return 0;
>  }
>
> -static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
> +static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
>  {
>         switch (timer) {
>         case VIRTUAL:
> @@ -95,6 +95,22 @@ static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
>         isb();
>  }
>
> +static inline int32_t timer_get_tval(enum arch_timer timer)
> +{
> +       isb();
> +       switch (timer) {
> +       case VIRTUAL:
> +               return read_sysreg(cntv_tval_el0);
> +       case PHYSICAL:
> +               return read_sysreg(cntp_tval_el0);
> +       default:
> +               GUEST_FAIL("Could not get timer %d\n", timer);
> +       }
> +
> +       /* We should not reach here */
> +       return 0;
> +}
> +
>  static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
>  {
>         switch (timer) {
> --
> 2.46.0.76.ge559c4bf1a-goog
>

