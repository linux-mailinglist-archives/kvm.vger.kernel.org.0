Return-Path: <kvm+bounces-65059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDC6C99D70
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 03:19:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BB353A3F31
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 02:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF50524336D;
	Tue,  2 Dec 2025 02:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LCStkiuC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917F919C546
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 02:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764641959; cv=none; b=Y72b7ZM3/iUGuwUUiftraSCaZM7rwQV5tA6arwZDXalIIRQW+i6AzyDzjEZ3lxhqhZD/loNf+V2N+ElUK22tJJL/GYuC/fyQEb3sZQAuwxYwagbwuwACz5wPViIOXuT7jma1KKXir06D93ji7RrfoY0IzWNbZCZz5FZ51C/uw8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764641959; c=relaxed/simple;
	bh=CoJ2MgT1AKrZFDeQ2tBrscbUaYOlGToL/G2+5TnmDnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=frKLgf3XYAWnkymDvRnY3zK1D46sbdM9X40ZVvUzSdNUZUpcZHQbZAuPoSFApnwGyMdk0dLx7dbyj4nLbTpQoGRP/vJvGArhoDvOAGznlI3kvXHQA0yM3OqKV2F3/nLRJnWOmvrujG9b421PUKTPDNlgRjdytZD27JDzgKT9qQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LCStkiuC; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34585428e33so5092874a91.3
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 18:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764641957; x=1765246757; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J40049ECp9EZo5Szfc/96hdgeTH7ctBvy/Y6Hl2uFnM=;
        b=LCStkiuC+f++1jQ33xJe/RBkrHGZ77xP7o/RSSrDf5NtCDx1sSkVNXUX6yp8V9COTc
         jTqo46pfnDgtwV2mSpNpweP6amYDix4MxUeui8CgvvRPufezgw6AzFYIuCbMNT5FvYSq
         PxqFhA2VIxA6Pampr3NOrXpHRMSOeU2yddXMvdCCwo32WXVPvCcVNjaa9JUnqVrx+uFJ
         fM6f1jufgep2oLC8aYngugKH+ioIiW/198LsTDLPtvcm7iiA64j70S8zaM9GfsBJ7GLf
         RgJiEcVJTNRglVDa1BmSn+F635uPVPbHbwUwaF31L8x3eZDHTMUOZvubaD4lIWDGgwv1
         nPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764641957; x=1765246757;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J40049ECp9EZo5Szfc/96hdgeTH7ctBvy/Y6Hl2uFnM=;
        b=u5zh8mNjOfLxSCBCHoD7ihrkwQ1K8wWdmFizNrn+c0GWmGaaCKFxI923x9WPvhyp6b
         dmBkJ9FN3kTiejeTPhQNyL0pF35VIKWlMhoPBGXyf+4yVUF4PoPO+ubaLATtfX1FYXQ5
         r087FZrmwcSQrAgNkQbFGK55jhGf8Dxb0wEgfbJ5kdkvaQT9yxOvjCmNTgX5A7brGh4U
         PF6+MT563uiGhyeNgQHIhqFNQjLhAlJfgLuneaUUYpwHiEYVk3Z1AJjjyXNWIgrKC+jN
         RcqmKfJEQHx3PVgq5HIt0G7H49xpiK6ddb2q8g3tcQm45r9ey6psIGAlxVI6+X9aynRz
         a3zQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnSnQTzC624+BUq5+g+be2JtR9rd8ArJ9jDfCPtw6C8DjrdRN/tP0IU47v3mH6gwpWFFk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2XnGBfgaH8tzwnEiZmvUOHDKDGCQIByWXKYO97QZ2kcDBTBXw
	i1eGpUzPZVDXkiftxWfI3ZYRD9NPmAquq9HYhn8foxn2iBKFZ+CXxCeS
X-Gm-Gg: ASbGncsR2sdMqKXaWi7weI3+RX4D+K91dUEcmkSImqXQ6Yy7lj2jtgPvlaImL8ckHtD
	0tYtsgWVM5MSAW41lCcyhuu0UzUeBSaPYZlCBHZ4et+CdwVsoS5RA1IXU0qPyRkdyl+DeuAAkLj
	hgEukKIDhJE3xpmz7odHrBq8iiP6/v5/lLeZau0DSJ/AVh1xRACu5lnSChA0yFOEPWZT9dUnPwy
	zExgwlchhl5GVXiDJoIGTHISsWYYry2pJjb96NrxmmaYTXYtUHhE2463OGV2feLvJ2jKbyXHXXm
	5YzX7CTCkQgjIAuSQvqe8KSrJb3vu3tz20AZ2Sr5GPxruVWQX1z5mZVb7b5hTS+Sy+mlA7lx4oD
	9XI9sbhXR3y/oc0RsldpH3PkFbZ9Y887aD7Ds6e96Uh3uPt1f+Wpr26BBdSzpiQFFdzdWSs0U5K
	2PLOS4OPRIxb5CqrNgd9yThg0kKecaYcICIQSGH4Xe8Q==
X-Google-Smtp-Source: AGHT+IGSeaBTQcJ2hC4QIfRYpvJZNCbx0Xgr8wLjlXTJUhLEGDPxhUTvKHAfzSLeqHHMXp9vOPNT9Q==
X-Received: by 2002:a17:90b:28c7:b0:340:bfcd:6af8 with SMTP id 98e67ed59e1d1-34733e2ce02mr38565775a91.4.1764641956618;
        Mon, 01 Dec 2025 18:19:16 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34909468b8csm121662a91.2.2025.12.01.18.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 18:19:16 -0800 (PST)
Message-ID: <2082c244-2e8e-48b3-8b8e-59b25f5ff1b4@gmail.com>
Date: Tue, 2 Dec 2025 10:19:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/pmu: Do not accidentally create BTS events
To: Fernand Sieber <sieberf@amazon.com>
Cc: =?UTF-8?Q?Jan_H=2E_Sch=C3=B6nherr?= <jschoenh@amazon.de>, x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, dwmw@amazon.co.uk,
 hborghor@amazon.de, nh-open-source@amazon.com, abusse@amazon.de,
 nsaenz@amazon.com, seanjc@google.com, pbonzini@redhat.com
References: <20251201142359.344741-1-sieberf@amazon.com>
Content-Language: en-US
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20251201142359.344741-1-sieberf@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/1/25 10:23 PM, Fernand Sieber wrote:
> From: Jan H. Schönherr <jschoenh@amazon.de>
> 
> It is possible to degrade host performance by manipulating performance
> counters from a VM and tricking the host hypervisor to enable branch
> tracing. When the guest programs a CPU to track branch instructions and
> deliver an interrupt after exactly one branch instruction, the value one
> is handled by the host KVM/perf subsystems and treated incorrectly as a
> special value to enable the branch trace store (BTS) subsystem. It

Based on my observations of PMU users, this is treated as a feature (using
PMC paths to trigger the BTS: generating a sampling for each branch already
makes it functionally and implementation-wise identical to BTS), and it
undoubtedly harms performance (just like other trace-based PMU facilities).

[*] perf record -e branches:u -c 1 -d ls

> should not be possible to enable BTS from a guest. When BTS is enabled,
> it leads to general host performance degradation to both VMs and host.
> 
> Perf considers the combination of PERF_COUNT_HW_BRANCH_INSTRUCTIONS with
> a sample_period of 1 a special case and handles this as a BTS event (see
> intel_pmu_has_bts_period()) -- a deviation from the usual semantic,
> where the sample_period represents the amount of branch instructions to
> encounter before the overflow handler is invoked.
> 
> Nothing prevents a guest from programming its vPMU with the above
> settings (count branch, interrupt after one branch), which causes KVM to
> erroneously instruct perf to create a BTS event within
> pmc_reprogram_counter(), which does not have the desired semantics.
> 
> The guest could also do more benign actions and request an interrupt
> after a more reasonable number of branch instructions via its vPMU. In
> that case counting works initially. However, KVM occasionally pauses and
> resumes the created performance counters. If the remaining amount of
> branch instructions until interrupt has reached 1 exactly,
> pmc_resume_counter() fails to resume the counter and a BTS event is
> created instead with its incorrect semantics.
> 
> Fix this behavior by not passing the special value "1" as sample_period
> to perf. Instead, perform the same quirk that happens later in
> x86_perf_event_set_period() anyway, when the performance counter is
> transferred to the actual PMU: bump the sample_period to 2.
> 
> Testing:
>  From guest:
> `./wrmsr -p 12 0x186 0x1100c4`
> `./wrmsr -p 12 0xc1 0xffffffffffff`
> `./wrmsr -p 12 0x186 0x5100c4`
> 
> This sequence sets up branch instruction counting, initializes the counter
> to overflow after one event (0xffffffffffff), and then enables edge
> detection (bit 18) for branch events.
> 
> ./wrmsr -p 12 0x186 0x1100c4
>      Writes to IA32_PERFEVTSEL0 (0x186)
>      Value 0x1100c4 breaks down as:
>          Event = 0xC4 (Branch instructions)
>          Bits 16-17: 0x1 (User mode only)
>          Bit 22: 1 (Enable counter)
> 
> ./wrmsr -p 12 0xc1 0xffffffffffff
>      Writes to IA32_PMC0 (0xC1)
>      Sets counter to maximum value (0xffffffffffff)
>      This effectively sets up the counter to overflow on the next branch
> 
> ./wrmsr -p 12 0x186 0x5100c4
>      Updates IA32_PERFEVTSEL0 again
>      Similar to first command but adds bit 18 (0x4 to 0x5)
>      Enables edge detection (bit 18)
> 
> These MSR writes are trapped by the hypervisor in KVM and forwarded to
> the perf subsystem to create corresponding monitoring events.
> 
> It is possible to repro this problem in a more realistic guest scenario:
> 
> `perf record -e branches:u -c 2 -a &`
> `perf record -e branches:u -c 2 -a &`

In this reproduction case, is there any unexpected memory corruption
(related to unallocated BTS buffer) ?

> 
> This presumably triggers the issue by KVM pausing and resuming the
> performance counter at the wrong moment, when its value is about to
> overflow.
> 
> Signed-off-by: Jan H. Schönherr <jschoenh@amazon.de>
> Signed-off-by: Fernand Sieber <sieberf@amazon.com>
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Hendrik Borghorst <hborghor@amazon.de>
> Link: https://lore.kernel.org/r/20251124100220.238177-1-sieberf@amazon.com
> ---
>   arch/x86/kvm/pmu.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 487ad19a236e..547512028e24 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -225,6 +225,19 @@ static u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
>   {
>   	u64 sample_period = (-counter_value) & pmc_bitmask(pmc);
>   
> +	/*
> +	 * A sample_period of 1 might get mistaken by perf for a BTS event, see
> +	 * intel_pmu_has_bts_period(). This would prevent re-arming the counter
> +	 * via pmc_resume_counter(), followed by the accidental creation of an
> +	 * actual BTS event, which we do not want.
> +	 *
> +	 * Avoid this by bumping the sampling period. Note, that we do not lose
> +	 * any precision, because the same quirk happens later anyway (for
> +	 * different reasons) in x86_perf_event_set_period().
> +	 */
> +	if (sample_period == 1)
> +		sample_period = 2;

Even without PERF_COUNT_HW_BRANCH_INSTRUCTIONS event check ?

> +
>   	if (!sample_period)
>   		sample_period = pmc_bitmask(pmc) + 1;
>   	return sample_period;


