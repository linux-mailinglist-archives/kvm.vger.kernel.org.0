Return-Path: <kvm+bounces-71348-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAgCG8/plmn4qwIAu9opvQ
	(envelope-from <kvm+bounces-71348-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:45:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C7AAF15DF45
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:45:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DA797301B73C
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 10:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7B029994B;
	Thu, 19 Feb 2026 10:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a3TVLUNm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E2B63CB
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 10:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771497927; cv=none; b=WscdbhrxwBBvFmgi9hNpeN7wvwtOLWOmX5J6JhubFO2Eu1pgfubDnXUEkUi28MOHehyyOG6HLYHDv7emzpe/FnC0luHjbnp5wTtCPH80uDdhy5MO0SRz/v0vF+L82BSTFhzUGm96GYIloVlbBYguJmac2TWexTHJVwLUHo0k/SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771497927; c=relaxed/simple;
	bh=096tnhc2fzRLQq0rIuOt2turMCkyDUEG4Odzb/XJvNo=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WAVDuejEV/cKsqDeKq5TruYu/QHZdS447zsjYA8iT8Mh/O3IUJ0kUre8OQWHgFNL4B9wmheh3DbK1gacjosyTsrVUUFLMzMeg2ilF1+VDxMcKn2BcRKnjSrBU4CbwUYa1X+M+XwEOx/LVMrMv8p6aWRNjysHUHgMKw/kuVa1YXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a3TVLUNm; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b8f97c626aaso106029266b.2
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 02:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771497924; x=1772102724; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QeTdzGAJRlToFPZ2jrpBRauFpaCxe61uQC+bv+dMi6E=;
        b=a3TVLUNmyhy4lpQ5PtaIWqys5DY82zaUQ5IJe6r0qYG6ESz6r5L2uZBynsFeid77sv
         779pblsws326+wr7VDEauEchPtwBiXPCIELOXsdmadlM/HIH9edSZTHvw/AYSfVwAPof
         dDuy7+WllORccAgtlVrktyqwcKCN0PvXI2q4bxwksxdaxG/67g/Ar2aUyCQCXa81keo+
         CjRFETT/ORhJClxHpobaql7dDj4sYYtOX07yib1TeJwT1GGm270kXmpp3pCpdVFmyAy2
         iPoCpNSShmpLfPdqHwQjQbHsKxN10ortN7CPJd8kgM6ZefyZQym/9V3LAOv/KsZz/CTB
         h3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771497924; x=1772102724;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QeTdzGAJRlToFPZ2jrpBRauFpaCxe61uQC+bv+dMi6E=;
        b=OfRyqp7qQgn4nul8GMBiZpVp8aPu/3pJrcdYV6/+C3Tdaz8iSJeK9kPxvX9jO9rXr9
         B62cDsMCqWo/7JarnTmoe+XbI+mY95R5QiqOyDcc/IZVCrex/7xgC36jgiposjTKNqRZ
         8LMBydq7vMSFBwbmaudW5zQyQm98GJe+HjnDczywwSws8iEDWNj2QvKCkVAP8ffCfFKq
         qDQ9HxAcfz3CSG8LJ9Iw4kMjKOww0yvsVjI8kNB9bQ6dkrGGPcCLpnp9tn4MoHJMHYb+
         TWTesUgGmQDmor7Zfq5Sf8+pQ3wmTZ3DMoXtd4ygk+B8WUPVnyg+p10LUympvlxPgley
         xtdA==
X-Forwarded-Encrypted: i=1; AJvYcCX0e7zJ3DXIyS9iQq5vZ6U0y/ij31hc81dlRiTM+UDvPQ7rVGqW9V1uSCP1375AqdmBVBo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWVHuyMByeLhVxjOZC/nzLuQFYpf6MKSIAk0ASx4HSVXofFVdd
	M0tnsb2lvOa0c79hl/atsecUXsd96HU7NFKgYxbker8k3XXzucNE0FWg
X-Gm-Gg: AZuq6aLTqeVUFQV/A554/NyMtMGLSUMRanbLma/eSMCzv6xxvkq4b+9AzRWuwNBLZLo
	ll7tr5tfHrC2c9R5qJF2AWEipEqEcqBPps/rNIKFcipyjZce7FMUMl+QlQRWT98TgkZDnA0k1RE
	Ct9ncIT74nPagdkQDkjP/tkklmFHyIhgLoG+8SX55ZF2jFVUAn9R3iDwwhkBMgfzbs8fs5jGqF1
	vCfpMFghe0qfzkOe55Pm2/BWyU3NMftzhYzt8kLf+tq2gEOzh6tHeJTMJIdY77u+xB+IzEJ9luF
	cmFrOv4uZ8WKbUtxqCPTeEQHt6XoU1iN852Fj/aQm8OcueyT5iT2/tbbIzD//QRYMHLWRFnP8xA
	3OhUcjTrIaJk8sAMPZUcXBb32wDutkrJLcYcnqvpWIWh5g4BwCLDYttrFJdU9lgCoSqOd9hKLwU
	WC15ZxyRDkcSz5PjsZXJRzCM/aKNEn
X-Received: by 2002:a17:907:3e20:b0:b8f:abff:9ce7 with SMTP id a640c23a62f3a-b904dc6918bmr158508666b.32.1771497924100;
        Thu, 19 Feb 2026 02:45:24 -0800 (PST)
Received: from [10.24.66.212] ([15.248.2.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fc735d69esm551810766b.6.2026.02.19.02.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 02:45:23 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <bb43a79b-9ca9-49c4-ae88-f71991c97a58@xen.org>
Date: Thu, 19 Feb 2026 10:45:22 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 27/34] kvm/xen-emu: re-initialize capabilities during
 confidential guest reset
To: Ani Sinha <anisinha@redhat.com>, Paul Durrant <xadimgnik@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org,
 qemu-devel <qemu-devel@nongnu.org>
References: <20260218114233.266178-1-anisinha@redhat.com>
 <20260218114233.266178-28-anisinha@redhat.com>
 <3b4b7b7b-7fcd-46ce-bdcb-cd1a30cf5276@xen.org>
 <793B549F-F866-4BF5-ABAF-A0537BA8713B@redhat.com>
Content-Language: en-US
In-Reply-To: <793B549F-F866-4BF5-ABAF-A0537BA8713B@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71348-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[redhat.com,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xadimgnik@gmail.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C7AAF15DF45
X-Rspamd-Action: no action

On 19/02/2026 10:31, Ani Sinha wrote:
> 
> 
>> On 19 Feb 2026, at 3:09 PM, Paul Durrant <xadimgnik@gmail.com> wrote:
>>
>> On 18/02/2026 11:42, Ani Sinha wrote:
>>> On confidential guests KVM virtual machine file descriptor changes as a
>>> part of the guest reset process. Xen capabilities needs to be re-initialized in
>>> KVM against the new file descriptor.
>>> Signed-off-by: Ani Sinha <anisinha@redhat.com>
>>> ---
>>>   target/i386/kvm/xen-emu.c | 50 +++++++++++++++++++++++++++++++++++++--
>>>   1 file changed, 48 insertions(+), 2 deletions(-)
>>> diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
>>> index 52de019834..69527145eb 100644
>>> --- a/target/i386/kvm/xen-emu.c
>>> +++ b/target/i386/kvm/xen-emu.c
>>> @@ -44,9 +44,12 @@
>>>     #include "xen-compat.h"
>>>   +NotifierWithReturn xen_vmfd_change_notifier;
>>> +static bool hyperv_enabled;
>>>   static void xen_vcpu_singleshot_timer_event(void *opaque);
>>>   static void xen_vcpu_periodic_timer_event(void *opaque);
>>>   static int vcpuop_stop_singleshot_timer(CPUState *cs);
>>> +static int do_initialize_xen_caps(KVMState *s, uint32_t hypercall_msr);
>>>     #ifdef TARGET_X86_64
>>>   #define hypercall_compat32(longmode) (!(longmode))
>>> @@ -54,6 +57,30 @@ static int vcpuop_stop_singleshot_timer(CPUState *cs);
>>>   #define hypercall_compat32(longmode) (false)
>>>   #endif
>>>   +static int xen_handle_vmfd_change(NotifierWithReturn *n,
>>> +                                  void *data, Error** errp)
>>> +{
>>> +    int ret;
>>> +
>>> +    /* we are not interested in pre vmfd change notification */
>>> +    if (((VmfdChangeNotifier *)data)->pre) {
>>> +        return 0;
>>> +    }
>>> +
>>> +    ret = do_initialize_xen_caps(kvm_state, XEN_HYPERCALL_MSR);
>>> +    if (ret < 0) {
>>> +        return ret;
>>> +    }
>>> +
>>> +    if (hyperv_enabled) {
>>> +        ret = do_initialize_xen_caps(kvm_state, XEN_HYPERCALL_MSR_HYPERV);
>>> +        if (ret < 0) {
>>> +            return ret;
>>> +        }
>>> +    }
>>> +    return 0;
>>
>> This seems odd. Why use the hyperv_enabled boolean, rather than simply the msr value, since when hyperv_enabled is set you will be calling do_initialize_xen_caps() twice.
> 
> I am not sure of enabling capabilities for Xen. I assumed we need to call kvm_xen_init() twice, once normally with XEN_HYPERCALL_MSR and if hyper is enabled, again with XEN_HYPERCALL_MSR_HYPERV. Is that not the case? Is it one or the other but not both? It seems kvm_arch_init() calls kvm_xen_init() once with XEN_HYPERCALL_MSR and another time vcpu_arch_init() calls it again if hyperv is enabled with XEN_HYPERCALL_MSR_HYPERV .

Yes, it has to be assumed that XEN_HYPERCALL_MSR is correct until 
Hyper-V supported is enabled, which comes later, at which point the MSR 
is changed. So you only need save the latest MSR value and use that in 
xen_handle_vmfd_change().

> 
>>
>>> +}
>>> +
>>>   static bool kvm_gva_to_gpa(CPUState *cs, uint64_t gva, uint64_t *gpa,
>>>                              size_t *len, bool is_write)
>>>   {
>>> @@ -111,15 +138,16 @@ static inline int kvm_copy_to_gva(CPUState *cs, uint64_t gva, void *buf,
>>>       return kvm_gva_rw(cs, gva, buf, sz, true);
>>>   }
>>>   -int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
>>> +static int do_initialize_xen_caps(KVMState *s, uint32_t hypercall_msr)
>>>   {
>>> +    int xen_caps, ret;
>>>       const int required_caps = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
>>>           KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL | KVM_XEN_HVM_CONFIG_SHARED_INFO;
>>> +
>>
>> Gratuitous whitespace change.
>>
>>>       struct kvm_xen_hvm_config cfg = {
>>>           .msr = hypercall_msr,
>>>           .flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
>>>       };
>>> -    int xen_caps, ret;
>>>         xen_caps = kvm_check_extension(s, KVM_CAP_XEN_HVM);
>>>       if (required_caps & ~xen_caps) {
>>> @@ -143,6 +171,21 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
>>>                        strerror(-ret));
>>>           return ret;
>>>       }
>>> +    return xen_caps;
>>> +}
>>> +
>>> +int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
>>> +{
>>> +    int xen_caps;
>>> +
>>> +    xen_caps = do_initialize_xen_caps(s, hypercall_msr);
>>> +    if (xen_caps < 0) {
>>> +        return xen_caps;
>>> +    }
>>> +
>>
>> Clearly here the code would be simpler here if you just saved the value of hypercall_msr which you have used in the call above.
>>
>>> +    if (!hyperv_enabled && (hypercall_msr == XEN_HYPERCALL_MSR_HYPERV)) {
>>> +        hyperv_enabled = true;
>>> +    }
>>>         /* If called a second time, don't repeat the rest of the setup. */
>>>       if (s->xen_caps) {
>>> @@ -185,6 +228,9 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
>>>       xen_primary_console_reset();
>>>       xen_xenstore_reset();
>>>   +    xen_vmfd_change_notifier.notify = xen_handle_vmfd_change;
>>> +    kvm_vmfd_add_change_notifier(&xen_vmfd_change_notifier);
>>> +
>>>       return 0;
>>>   }
> 
> 


