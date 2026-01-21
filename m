Return-Path: <kvm+bounces-68761-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YJp4CkUtcWmcfAAAu9opvQ
	(envelope-from <kvm+bounces-68761-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 20:47:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C6ADE5C7D6
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 20:47:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 473986ADEBA
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 18:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD933644A3;
	Wed, 21 Jan 2026 18:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PKaNLIrL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jho8CDq+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CE530F7F8
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 18:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019238; cv=none; b=WzcdKvj/sQzqmXknEQQcgxmwqpEpHnMGHxPd8W1Sd+Fgil0nL0YNYvk75IxwF3p/kfqu5WK54GLLQrunJlRaWnrc2IBqWXmsshddrMRh2e0rVlqiD3Xpp1wJSsrJvFqxi3KXeR+pV32mhSnnaooT8DSb+ztABoPz3f/Snrf9hbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019238; c=relaxed/simple;
	bh=C28c/EW5CuQsoDdUsx8dGqG9K8fs0K81D2a2muNH+l8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rPaER4NXpy/KFLW8CfB9J8ljzOcepIPdKlZHlFFyMnCuHXmGintt6hB3yIp6RzlpMju2lBFFjKUtIOqXUiYpv4C9tNuKz1wuid85Hg2XwB8dGe+aH11qjZtSlAngMd8h31lqAkc3SUM16vFWm2zQ0vKvzuvORCGW0VaKAL9vn1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PKaNLIrL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jho8CDq+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769019235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ynpg/cJ+vd3nqyV8BLe/SIqtaIrKy7cylnYrcUttxQg=;
	b=PKaNLIrLnItiqRK8XHE4OKV/+0CovEskO/8FrTFXxXs3XpiaNJXm4jJ/1WB4kXbfIxit7n
	NYxP15wQl389Ccl5iDnTa7WUnPlf+2E+IdwnKL/6G7zFyii5PtUQ7C7oM2EeMw/wCxH6Aq
	0LgTg+PZrkZCaOaJTm2gqe6LKVkuYrY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-dMbnOZvfOh2c-OfcW-ZJFg-1; Wed, 21 Jan 2026 13:13:52 -0500
X-MC-Unique: dMbnOZvfOh2c-OfcW-ZJFg-1
X-Mimecast-MFC-AGG-ID: dMbnOZvfOh2c-OfcW-ZJFg_1769019231
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4325b81081aso83804f8f.3
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 10:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769019231; x=1769624031; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ynpg/cJ+vd3nqyV8BLe/SIqtaIrKy7cylnYrcUttxQg=;
        b=jho8CDq+PeZcjS/nSY9XrSc5iVXaebdV6mQPtnJrFRnrhgOAuMr/arUsuVWGO0o8By
         byNQas67i5oic58YInoEFtrbi2kmBT4AxIGatxkC3SswNwwe7DuOgrj+hfkmJOYvUtfY
         SdZUk+UNQAnZ5U8bQHx5GGf0I9mxO5aR1174tUJNECQQZJmC53I5YDrN0eyYNtEKQVaY
         R8XDBY3Q3PrDmQ6pDU2zlEWltNy9HZJ/x4uwD0NBhivdTs6cepzJnJbLDaHiTRXNA2LJ
         EEuLMDP+A4nL8mZ9G7hIEsGkHj97o+ijCR0EdbXDgni5C3oZmjqYTjziZGUBBtLpuxKY
         L4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769019231; x=1769624031;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ynpg/cJ+vd3nqyV8BLe/SIqtaIrKy7cylnYrcUttxQg=;
        b=qMAfcavT1pYtHLWwdNVLX0/m5P1ZsqrVccjvX+5zzRwHjbaLxpmD6zl1atMUst53Gf
         ZG80g2nBQ7rwsjHGK+Q473/sPD4WmyHXlyhyu4sSeMAqPaSScogk/d4ROCZ6ouHygrMY
         ZBTxlCJKmksfDlCJqYyccQTjg3+BPfdO1uItpJmiyqYpMmAQ4/B5pXEfgZ2hLWHfUnUS
         omZsDeFB8ZL6ZKQdJhDoC73kXGLpz1wXMEqHV3ypxuHI2jXk+sQdvHscMDPLbl9ZzPsp
         RHhwce34IQL4E5jQpjNPSAiuBKewtmsl98mmKPITAOY9gOzArq5usPeJE76Ex95fraYM
         vHXg==
X-Forwarded-Encrypted: i=1; AJvYcCXcGI1d7h1GqNFEbfJcNvsjb0RJ30jOAVeYV2H6R5R0E9TjcsYMuBj0ZDvkfqYirUVdob0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9B6IsYPa0tI7f+QO8SngWK2Z607OvCCuMs/F3bUiHTTLZIQEj
	9uz9fuwtCj8aDJj6gzW2NdUy25SSw66W1XYPe7yVwuXYuT+LGlNmBm/84/yW1fCabjgeSzXVRYn
	XVshnvzS4WQQkFbtilSk8SqFFYV6CaB9K2MfVFBdQi6wjs9X+1ANzyw==
X-Gm-Gg: AZuq6aIx3CJl+yEbGwSxrFnd3OBrRdL2yfk59GXafpXTvROet/kXBSx8HemadmkWNeg
	JaNxfS7uu5HxUX+e3Jouncbl1FQzTjAhqyyjVA/eyni0t8kaWSd8oobpqGLl0JQlV/WPn4A7ZuO
	LRgcgT8ND7ufTDaCoNLm5/mr8oS3m4+HP0YKfkCLOFcr1zTKX/kH8Cqumq0iO6DeOYRSNSlTygQ
	G4b3r/SRHOxtZs+S7ucy6kWVhtq4vgEU5PqjUUZK/BBw/bpxqnwZAoxD/NAmJyKBXkB4TT7sHAG
	XvDTK4ZNPRoBuGWc17l6r2W5JfPgZd+GLd8w5G58H2ApGxGJZH1ISMes68+eFV1FR8aj56PyyGI
	RHiYzo2NxlXdWJWXsBtVWYUSl3BPDrsZnuySbEI3zdR4QXBXCpGufsKj4AwIVce+32Tf1yOkcZB
	wxAgOoYfsYEWDP2w==
X-Received: by 2002:a5d:4688:0:b0:435:95c9:6891 with SMTP id ffacd0b85a97d-43595c96bcamr7351141f8f.42.1769019231263;
        Wed, 21 Jan 2026 10:13:51 -0800 (PST)
X-Received: by 2002:a5d:4688:0:b0:435:95c9:6891 with SMTP id ffacd0b85a97d-43595c96bcamr7351114f8f.42.1769019230831;
        Wed, 21 Jan 2026 10:13:50 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-43569921da2sm38550536f8f.1.2026.01.21.10.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 10:13:49 -0800 (PST)
Message-ID: <5bea843b-dec8-4f15-bb7c-1d0550542034@redhat.com>
Date: Wed, 21 Jan 2026 19:13:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: possible deadlock due to irq_set_thread_affinity() calling into
 the scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock
 across IRTE updates in IOMMU)
To: Thomas Gleixner <tglx@kernel.org>, Ankit Soni <Ankit.Soni@amd.com>,
 Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 David Matlack <dmatlack@google.com>, Naveen Rao <Naveen.Rao@amd.com>,
 Crystal Wood <crwood@redhat.com>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
 <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com> <874iovu742.ffs@tglx>
 <87pl7jsrdg.ffs@tglx>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
In-Reply-To: <87pl7jsrdg.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.46 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	FREEMAIL_CC(0.00)[linux.dev,8bytes.org,infradead.org,linux.intel.com,lists.infradead.org,lists.linux.dev,vger.kernel.org,amd.com,redhat.com,oracle.com,gmail.com,google.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-68761-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: C6ADE5C7D6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Sorry, not sure how the previous email ended up encrypted.

On 1/8/26 22:53, Thomas Gleixner wrote:
> On Thu, Jan 08 2026 at 22:28, Thomas Gleixner wrote:
>> On Mon, Dec 22 2025 at 15:09, Paolo Bonzini wrote:
>>> Of the three, the most sketchy is (a); notably, __setup_irq() calls
>>> wake_up_process outside desc->lock.  Therefore I'd like so much to treat
>>> it as a kernel/irq/ bug; and the simplest (perhaps too simple...) fix is
>>
>> It's not more sketchy than VIRT assuming that it can do what it wants
>> under rq->lock. 🙂
>
> And just for the record, that's not the only place in the irq core which
> has that lock chain.
>
> irq_set_affinity_locked()       // invoked with desc::lock held
>     if (desc->affinity_notify)
>        schedule_work()           // Ends up taking rq::lock
>
> and that's the case since cd7eab44e994 ("genirq: Add IRQ affinity
> notifiers"), which was added 15 years ago.
>
> Are you still claiming that this is a kernel/irq bug?

Not really, I did say I'd like to treat it as a kernel/irq bug...
but certainly didn't have hopes high enough to "claim" that.
I do think that it's ugly to have locks that are internal,
non-leaf and held around callbacks; but people smarter than
me have thought about it and you can't call it a bug anyway.

For x86/AMD we have a way to fix it, so that part is not a problem.

For the call(*) to irq_set_affinity() in arch/arm64/kvm/'s
vgic_v4_load() I think it can be solved as well.
kvm_make_request(KVM_REQ_RELOAD_GICv4) will delay vgic_v4_load()
to a safe spot, so just cache the previous smp_processor_id() and,
if it is different, do the kvm_make_request() and return instead
of calling irq_set_affinity().

vgic_v3_load() is the only place that calls it from the preempt
notifier, so this behavior can be tied to a "bool delay_set_affinity"
argument to vgic_v4_load() or placed in a different function.

Marc/Oliver, does that sound doable?

Paolo

(*) kvm_sched_in() preempt notifier -> kvm_arch_vcpu_load() ->
     kvm_vgic_load() -> vgic_v3_load() -> vgic_v4_load()


