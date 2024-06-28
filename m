Return-Path: <kvm+bounces-20700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4C091C94E
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:51:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C0BD28229D
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D342782485;
	Fri, 28 Jun 2024 22:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qb5Ac7+X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911B5374F6
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 22:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719615056; cv=none; b=LSavXYK0FLh95zzUEvqUsBrjwMMPvXlunvREtxgjtT77fBvivzrg+pQWQc5bwyg9JgZUju3872UULzrG8Tz25gnFNcPiKmnSUsNVWTXn7wpp0uX8tFJk3pmzLEf0d/n/4+DJKQGgYuRyh/yXUsv+jascW5ruBcCjR0ikBH75T/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719615056; c=relaxed/simple;
	bh=jy93R+AfsRqMAGlNONjXHx3MTwYmbc0o5Y+QyO4nU/E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TbBu+WWxxWTVIHCn1rNe1JQo2x7O4mI/zdckrn0RJt5NOIAn3NfoszSd8Pjg65++WcMde9uPuS1JRjJD5Q7NBgN0eqVL6pWb6zLCd7R6p4K0sPFZYJkYIzjto/hGfDjOqCK8Xdc3q1eQ/ezk8CRQea8d8ikM+UzyXHVCTTo7cKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qb5Ac7+X; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02bb41247dso1853464276.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 15:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719615053; x=1720219853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bu4QFZ07Tx/IOVEaQ53Qnu94rStFQkBj6hOEerB+McQ=;
        b=qb5Ac7+XumS+Qxp9YK3Mu4zbYPCTOqrs1VxUfIs1ysp57H7t9qeCI59K7LIUTraBN1
         KdduSod7m8qMmrt8lgYz5o3AZwR5UKEVutzD9Oxzx8c5H5WtkvMTmj6dDUfelBEZ4B/e
         F7QgcoMnYTpm/JWahRHtkqMjhvVoxGTLPCc+9ugvwIDX1FbO0ra6vHPm/c0R4P22e3zs
         g0YjsZo2ESpysVMTl5dq7sy7RRn4lYw2PSuNszaPn/LCGc1nMywGBj8uEP8JrJBJ0Ps0
         wz1ZEcKQr2Mob8p9u8uCnh10woOg2o1Axox7vpKRfjLX3/RqKMpddvVnn1OrK9ZnqbqG
         2lCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719615053; x=1720219853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bu4QFZ07Tx/IOVEaQ53Qnu94rStFQkBj6hOEerB+McQ=;
        b=w0viq72xgsHtLtNp5/XJ+HiLJiaRuF5t3kERyg6PgEtDVReN/XASNSEaJ2uXM2cxeX
         c2OZ3q8TCrfwaASJA9aKON98dirnI939Hvy11uYGEqMEHH3RrgTOuB9de8aRUfnzsOio
         FbcSctvbOoja19fqE9YARjnDKRfQjrc2K66akKCdVLlWZwRrQQwQ5KnvMT+oU/5APUem
         gDfy3s86C0Q1z7cfQ+tD1vtp5t35r2HYqy2PaJUNO1JQmtzF86Aa5BUAtXWqVChhAIRb
         I+8uDNXCugRKtn2hYFj0j7QRS1RATiwGki6yGnmCFYxv0saLqRMP4gnpjO572QGMZeeX
         COVg==
X-Forwarded-Encrypted: i=1; AJvYcCWvzWoFEsfJdpMAT9BOdjMgpL00O4Pb8SyiN0U0Mc8sHUfwMQq06A9StKVe60dL+shuqfkRtO0f+X1ITM9EIYpF2reT
X-Gm-Message-State: AOJu0YxByxsJgThgW2jpVfU8mLBres0JRuLl8svlyepbAfVryeiaJpSc
	J1ReIbwS2rkfzj/fVwDt4GutJZ/4rOBlJCGnN7wDJ3Kk+5A/OedLgsVEecLuw1cU2DCq9cJW1JA
	Q3w==
X-Google-Smtp-Source: AGHT+IF/h7suUpPHaE6SsxKCTMo0m7O49IXDLR+c+LZnvsQxH+QhzdDpJWmE+hfpq58JCkdgFZQmcKv7iBg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1109:b0:e03:3683:e67f with SMTP id
 3f1490d57ef6-e033683e751mr15350276.5.1719615053446; Fri, 28 Jun 2024 15:50:53
 -0700 (PDT)
Date: Fri, 28 Jun 2024 15:50:51 -0700
In-Reply-To: <2fccf35715b5ba8aec5e5708d86ad7015b8d74e6.1718214999.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1718214999.git.reinette.chatre@intel.com> <2fccf35715b5ba8aec5e5708d86ad7015b8d74e6.1718214999.git.reinette.chatre@intel.com>
Message-ID: <Zn8-S-QFSzm8du90@google.com>
Subject: Re: [PATCH V9 2/2] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
From: Sean Christopherson <seanjc@google.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, pbonzini@redhat.com, erdemaktas@google.com, 
	vkuznets@redhat.com, vannapurve@google.com, jmattson@google.com, 
	mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, yuan.yao@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 12, 2024, Reinette Chatre wrote:
> +/*
> + * Pick 25MHz for APIC bus frequency. Different enough from the default 1GHz.
> + * User can override via command line.
> + */
> +static uint64_t apic_hz = 25 * 1000 * 1000;
> +
> +/*
> + * Delay in msec that guest uses to determine APIC bus frequency.
> + * User can override via command line.
> + */
> +static unsigned long delay_ms = 100;

There's no need for these to be global, it's easy enough to pass them as params
to apic_guest_code().  Making is_x2apic is wortwhile as it cuts down on the noise,
but for these, I think it's better to keep them local.

> +
> +/*
> + * Possible TDCR values with matching divide count. Used to modify APIC
> + * timer frequency.
> + */
> +static struct {
> +	uint32_t tdcr;
> +	uint32_t divide_count;

These can/should all be const.

> +} tdcrs[] = {
> +	{0x0, 2},
> +	{0x1, 4},
> +	{0x2, 8},
> +	{0x3, 16},
> +	{0x8, 32},
> +	{0x9, 64},
> +	{0xa, 128},
> +	{0xb, 1},
> +};
> +
> +/* true if x2APIC test is running, false if xAPIC test is running. */
> +static bool is_x2apic;
> +
> +static void apic_enable(void)
> +{
> +	if (is_x2apic)
> +		x2apic_enable();
> +	else
> +		xapic_enable();
> +}
> +
> +static uint32_t apic_read_reg(unsigned int reg)
> +{
> +	return is_x2apic ? x2apic_read_reg(reg) : xapic_read_reg(reg);
> +}
> +
> +static void apic_write_reg(unsigned int reg, uint32_t val)
> +{
> +	if (is_x2apic)
> +		x2apic_write_reg(reg, val);
> +	else
> +		xapic_write_reg(reg, val);
> +}
> +
> +static void apic_guest_code(void)
> +{
> +	uint64_t tsc_hz = (uint64_t)tsc_khz * 1000;
> +	const uint32_t tmict = ~0u;
> +	uint64_t tsc0, tsc1, freq;
> +	uint32_t tmcct;
> +	int i;
> +
> +	apic_enable();
> +
> +	/*
> +	 * Setup one-shot timer.  The vector does not matter because the
> +	 * interrupt should not fire.
> +	 */
> +	apic_write_reg(APIC_LVTT, APIC_LVT_TIMER_ONESHOT | APIC_LVT_MASKED);
> +
> +	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
> +
> +		apic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
> +		apic_write_reg(APIC_TMICT, tmict);
> +
> +		tsc0 = rdtsc();
> +		udelay(delay_ms * 1000);
> +		tmcct = apic_read_reg(APIC_TMCCT);
> +		tsc1 = rdtsc();
> +
> +		/*
> +		 * Stop the timer _after_ reading the current, final count, as
> +		 * writing the initial counter also modifies the current count.
> +		 */
> +		apic_write_reg(APIC_TMICT, 0);
> +
> +		freq = (tmict - tmcct) * tdcrs[i].divide_count * tsc_hz / (tsc1 - tsc0);
> +		/* Check if measured frequency is within 1% of configured frequency. */

1% is likely too aggressive, i.e. we'll get false failures due to host activity.
On our systems, even a single pr_warn() in the timer path causes failure.  For
now, I think 5% is good enough, e.g. it'll catch cases where KVM is waaay off.
If we want to do better (or that's still too tight), then we can add a '-t <tolerance'
param or something.

> +		GUEST_ASSERT(freq < apic_hz * 101 / 100);
> +		GUEST_ASSERT(freq > apic_hz * 99 / 100);

Combine these into a single assert, and print the params, i.e. don't rely on the
line number to figure out what's up.

		__GUEST_ASSERT(freq < apic_hz * 105 / 100 && freq > apic_hz * 95 / 100,
			       "Frequency = %lu (wanted %lu - %lu), bus = %lu, div = %u, tsc = %lu",
			       freq, apic_hz * 95 / 100, apic_hz * 105 / 100,
			       apic_hz, tdcrs[i].divide_count, tsc_hz);

> +int main(int argc, char *argv[])
> +{
> +	int opt;
> +
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
> +
> +	while ((opt = getopt(argc, argv, "d:f:h")) != -1) {
> +		switch (opt) {
> +		case 'f':
> +			apic_hz = atol(optarg);
> +			break;
> +		case 'd':
> +			delay_ms = atol(optarg);
> +			break;
> +		case 'h':
> +			help(argv[0]);
> +			exit(0);
> +		default:
> +			help(argv[0]);
> +			exit(1);

Heh, selftests are anything but consistent, but this should be exit(KSFT_SKIP)
for both.

> +		}
> +	}
> +
> +	run_apic_bus_clock_test(false);
> +	run_apic_bus_clock_test(true);
> +}
> -- 
> 2.34.1
> 

