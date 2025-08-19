Return-Path: <kvm+bounces-54985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E605B2C5CF
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 15:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 655001BA1DEC
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 13:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE839335BA3;
	Tue, 19 Aug 2025 13:35:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F7305049;
	Tue, 19 Aug 2025 13:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755610505; cv=none; b=Fy18/uTO8Z/GJX74I9G3osggGsI0JoYdekwSA2P239mq/thiVwEsZ3+kk72YoPfFiAVj3tzePNkwMLDIt7mJtzZVDufHGHVlZdBLx6NQVr6RKloy5VjOpWsi3qi7uK9yl8/BCDrmZnbNjb2VfPUHRzt16QtXbgKikJuVsrhiVsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755610505; c=relaxed/simple;
	bh=wMsQp1X9ja9Cq7F1/2VTIGIn5RVWYokby0lQwsJsI58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WHS5/l0sPk4afjbjLjl+dYaiyA1WxmGfVHFPGm+7PsxaA03mY4egEU/TeBYkHP00oVwxQWT5z1fkK1NNSSeVxiYhi1QYkiI6mvSE41Jg3swAdz1PEcyzZxLr+GZdFsZxlcNqoR54Zg64wJ/3gP9ybdyxdYKHfayGNynJ3OtUk/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1uoMUN-00000001Off-2Mdz;
	Tue, 19 Aug 2025 15:34:59 +0200
Message-ID: <7cfe68c2-a84a-4416-a9ca-3bf5225190a1@maciej.szmigiero.name>
Date: Tue, 19 Aug 2025 15:34:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [EARLY RFC] KVM: SVM: Enable AVIC by default from Zen 4
To: Naveen N Rao <naveen@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: mlevitsk@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Vasant Hegde <vasant.hegde@amd.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <20250626145122.2228258-1-naveen@kernel.org>
 <66bab47847aa378216c39f46e072d1b2039c3e0e.camel@redhat.com>
 <aF2VCQyeXULVEl7b@google.com>
 <4ae9c25e0ef8ce3fdd993a9b396183f3953c3de7.camel@redhat.com>
 <bp7gjrbq2xzgirehv6emtst2kywjgmcee5ktvpiooffhl36stx@bemru6qqrnsf>
 <aGxWkVu5qnWkZxqz@google.com>
 <3xpfs5m5q6o74z5lx3aujdqub6ref2yypwcbz55ec5iefyqoy7@42g5nbgom637>
Content-Language: en-US, pl-PL
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; keydata=
 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
Disposition-Notification-To: "Maciej S. Szmigiero"
 <mail@maciej.szmigiero.name>
In-Reply-To: <3xpfs5m5q6o74z5lx3aujdqub6ref2yypwcbz55ec5iefyqoy7@42g5nbgom637>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: mhej@vps-ovh.mhejs.net

On 18.07.2025 10:19, Naveen N Rao wrote:
> On Mon, Jul 07, 2025 at 04:21:53PM -0700, Sean Christopherson wrote:
>> On Fri, Jun 27, 2025, Naveen N Rao wrote:
>>>> Back when I implemented this, I just wanted to be a bit safer, a bit more explicit that
>>>> this uses an undocumented feature.
>>>>
>>>> It doesn't matter much though.
>>>>
>>>>>
>>>>> I don't see any reason to do major surgery, just give "avic" auto -1/0/1 behavior:
>>>
>>> I am wary of breaking existing users/deployments on Zen4/Zen5 enabling
>>> AVIC by specifying avic=on, or avic=true today. That's primarily the
>>> reason I chose not to change 'avic' into an integer. Also, post module
>>> load, sysfs reports the value for 'avic' as a 'Y' or 'N' today. So if
>>> there are scripts relying on that, those will break if we change 'avic'
>>> into an integer.
>>
>> That's easy enough to handle, e.g. see nx_huge_pages_ops for a very similar case
>> where KVM has "auto" behavior (and a "never" case too), but otherwise treats the
>> param like a bool.
> 
> Nice! Looks like I can re-use existing callbacks for this too:
>      static const struct kernel_param_ops avic_ops = {
> 	    .flags = KERNEL_PARAM_OPS_FL_NOARG,
> 	    .set = param_set_bint,
> 	    .get = param_get_bool,
>      };
> 
>      /* enable/disable AVIC (-1 = auto) */
>      int avic = -1;
>      module_param_cb(avic, &avic_ops, &avic, 0444);
>      __MODULE_PARM_TYPE(avic, "bool");
> 
>>
>>> For Zen1/Zen2, as I mentioned, it is unlikely that anyone today is
>>> enabling AVIC and expecting it to work since the workaround is only just
>>> hitting upstream. So, I'm hoping requiring force_avic=1 should be ok
>>> with the taint removed.
>>
>> But if that's the motivation, changing the semantics of force_avic doesn't make
>> any sense.  Once the workaround lands, the only reason for force_avic to exist
>> is to allow forcing KVM to enable AVIC even when it's not supported.
> 
> Indeed.
> 
>>
>>> Longer term, once we get wider testing with the workaround on Zen1/Zen2,
>>> we can consider relaxing the need for force_avic, at which point AVIC
>>> can be default enabled
>>
>> I don't see why the default value for "avic" needs to be tied to force_avic.
>> If we're not confident that AVIC is 100% functional and a net positive for the
>> vast majority of setups/workloads on Zen1/Zen2, then simply leave "avic" off by
>> default for those CPUs.  If we ever want to enable AVIC by default across the
>> board, we can simply change the default value of "avic".
>>
>> But to be honest, I don't see any reason to bother trying to enable AVIC by default
>> for Zen1/Zen2.  There's a very real risk that doing so would regress existing users
>> that have been running setups for ~6 years, and we can't fudge around AVIC being
>> hidden on Zen3 (and the IOMMU not supporting it at all), i.e. enabling AVIC by
>> default only for Zen4+ provides a cleaner story for end users.
> 
> Works for me. I completely agree with that.

Some Zen3 platforms (at least Ryzen SKUs) *do* enumerate AVIC in CPUID:

> $ cat /proc/cpuinfo | grep -E '(model[[:space:]]{2,})|family|step' | head -n3
> cpu family      : 25
> model           : 33
> stepping        : 2
>> $   cat /proc/cpuinfo | grep avic | head -n1
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb
> rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid extd_apicid
> aperfmperf rapl pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 x2apic movbe
> popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy
> abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt tce topoext perfctr_core
> perfctr_nb bpext perfctr_llc mwaitx cpb cat_l3 cdp_l3 hw_pstate ssbd mba ibrs
> ibpb stibp vmmcall fsgsbase bmi1 avx2 smep bmi2 erms invpcid cqm rdt_a rdseed
> adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 xsaves cqm_llc
> cqm_occup_llc cqm_mbm_total cqm_mbm_local user_shstk clzero irperf xsaveerptr
> rdpru wbnoinvd arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid
> decodeassists pausefilter pfthreshold               -> avic <-
> v_vmsave_vmload vgif v_spec_ctrl umip pku ospke vaes vpclmulqdq rdpid overflow_recov
> succor smca fsrm debug_swap
>
> $ cat /sys/module/kvm_amd/parameters/force_avic
> N
>
> $ dmesg | grep AVIC
> kvm_amd: AVIC enabled

As you can see, currently AVIC works there even without force_avic=1 so why
now hide it behind that parameter if errata #1235 is supposedly not present
on Zen3?

Also, this platform is apparently confident enough that the AVIC silicon is
working correctly there to expose it in CPUID - maybe because that's CPU
stepping 2 instead of the initial 0?
> Thanks,
> Naveen

Thanks,
Maciej


