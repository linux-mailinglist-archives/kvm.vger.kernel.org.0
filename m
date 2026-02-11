Return-Path: <kvm+bounces-70866-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sKsYGLSojGkvsAAAu9opvQ
	(envelope-from <kvm+bounces-70866-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:05:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C65125EF0
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BC68D30252A7
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D993382D9;
	Wed, 11 Feb 2026 16:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVQus8uq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GzunaSLw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F438331235
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 16:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770825872; cv=none; b=ooBt4upD5IitEmGklbaMKsjeajo3EJ2t4yeBalNKczalii2HdXUQZzvOxfa25dZ8JtpgqPHBwJWvTFlkd7xKzClGg3ofGIQp6p0YuM64UwrKB5OpTpD0hL+gLS53YfwN/xJXj0KE9VATMUDDb2XblTqCe/zEy40kkAqtSJhFiQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770825872; c=relaxed/simple;
	bh=EUVf2wna+dYhtI7Ucp0MB7m/uxN4DU5He2QHJ0gJeQQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lcM694wiOPEFMu0f6qFoX4fMJ7onY5Y1HOgOH9KP/Y5Tr6RQDTZkIQyTTjMKHEwzcBpGIHHuXdFFMQV8Lzgr6GDriB4+wKM+leRIpluqjUiHp1hOXS4mEPAQw9+nxM+vAWLusNUI8kZI+241oXIeLaWxAsTa3szevKw77ziSeo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FVQus8uq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GzunaSLw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770825870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5KpC7yaqnmPgfObvDWEmIArdNjIVjuTr6fFxuFr8Hdk=;
	b=FVQus8uqgehpxXP2IYKnvBMGDF4XTCcAP8/TKS2qmaaNsAqxKjJys3OxMYn8GQfGduQ4wj
	uDZn/u7SCVer1Ld4BOfHT5oAr4uVOgeQadZjULcrzblRFtcS45OdIaAcRX+xyANAw7a5ZM
	qFH6Wl0Jn2UKWr1x/BEQXIv0BNoaGFU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-rxEltJ8DNXq06-k38Y5DEQ-1; Wed, 11 Feb 2026 11:04:28 -0500
X-MC-Unique: rxEltJ8DNXq06-k38Y5DEQ-1
X-Mimecast-MFC-AGG-ID: rxEltJ8DNXq06-k38Y5DEQ_1770825868
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48079ae1001so51838185e9.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 08:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770825868; x=1771430668; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5KpC7yaqnmPgfObvDWEmIArdNjIVjuTr6fFxuFr8Hdk=;
        b=GzunaSLwtTYqCG7VoWNyB4JQEc2lujcR22RiJ8n0tTXnWNHOTNdVLzCMAhN0pyocvn
         obqAVyBAK/6q23B1ZPgRm2Xv5NvxpK/ol9+WPnJum6X9LBG2oRlhNBiMwO/TVQhO5Rpx
         nFGBTuBCJ3THJi9dhmNs/+A/PaikgPJWn4Z/ba3f+Av+JII5UJtgwCDKpDYg4ai1o83z
         d9876teQ7WGXNOUeVMB8icbdwZBxnCX+NDMjRZ5HFhEfFQjOedsdhCdCEXErrVBafsnw
         Rv2ss2+8+rdfwx2YSFlzQf2mP4Pf33wAXzgkzhDRMzcxNGvU4aoUx46RfcHj0nIsY1ke
         7MfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770825868; x=1771430668;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5KpC7yaqnmPgfObvDWEmIArdNjIVjuTr6fFxuFr8Hdk=;
        b=aD/v3t6JZlkyQ3stBfCqR2NS6PJHl/fCJdpUl0GAovu315caAgLGaV3wz3XkO8kGqN
         ptIqJ25Gx2/QpeXyc9975opA3wNcA7I8gO34uXt0GceIpqKQkoZ6Jqiy8iRrd6YB1pYX
         vlovEebo5O8lGQ11TqLRgF1B/AJXw8jIhVDIHjqFgNKv38QH4+X2f7UMtjnSRFhUAsJ5
         FDI1qvjjBYolfVsR6ehQMNpuxa8epn9TNC9Tgy3GVXWW1QswCIyh4wE04hxZYHH+Aibb
         tuO61bC+lqlM/eEqVVWlz/ZgT3wB2qUIaptd4Wqyb4kDPsDbkpp3qcCbg/OcXrNMFJzl
         uo5g==
X-Forwarded-Encrypted: i=1; AJvYcCWslUTGrlVA/Fjp3YwwsW3sKRnGoNe9Q0JLRPux/EM81pH+OHFfVMVwu3HgaubBcTNdKnA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwV99IAXanoglosYgWrxrERKQ+gDcncyl2CbXscO/1/Sb5FiY3v
	exRCkGsobRW80BrE32YIgMv/dH/9a442zGkw9o+beN+jFjsVz6dTN6oDt7KTU/ERvHdthwUMfgY
	f4MjHU290K18nJhkJvJZD4ycLJlhpa2v8MFm7VnQrfyTOqAiYQ7vNpw==
X-Gm-Gg: AZuq6aKwtViQ2tQHIOmnA3xMfwBnmo/hKY1W5CTcWSAgonc/1fsp26Olmnvm1H2oBr4
	KzmJts/Q9LtyRG4i6wla7OGEoaaPF0jQeqsCpEKawPROrE/AmyvbAjwiFpZWTZt0TmAjg0KmQ/1
	H3UM+h2qzyFK1XQe1GKG89oFcyqjSV6/9FcL+168xUSIN6baPtwBrvdaPFc/4uprthvpnMzl6j6
	R0UNcOS4nNmMyNBnn47ppDv8Jr86uyoEcn/xIfgsQXroUV99JeoX/0Rqf8YlKHq8LZCeq2TYVys
	Z1iYCreqg6IUZpM5l7Y7Ci3IPlPmA9m1TQswDy098DY7istMNlvh1RV5tTXlIX828VZDLSMoVqy
	kg3ueA2OTnZm/Zvw61uAvN4Tb2ytgAHBH1Dx31LZbFx5QT724JBbzUvK7qLdFmk5DeSrHKLo=
X-Received: by 2002:a05:600c:46d0:b0:45d:f81d:eae7 with SMTP id 5b1f17b1804b1-4835b96ec32mr36898635e9.28.1770825867322;
        Wed, 11 Feb 2026 08:04:27 -0800 (PST)
X-Received: by 2002:a05:600c:46d0:b0:45d:f81d:eae7 with SMTP id 5b1f17b1804b1-4835b96ec32mr36897035e9.28.1770825865304;
        Wed, 11 Feb 2026 08:04:25 -0800 (PST)
Received: from rh (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835d92267bsm70932155e9.0.2026.02.11.08.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 08:04:24 -0800 (PST)
Date: Wed, 11 Feb 2026 17:04:23 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
    qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <CAFEAcA-A+zW=QFdCY7z==+Z=xXfhJvPeyHhbG_MpEmpkQfrmaw@mail.gmail.com>
Message-ID: <4e9470d5-ef3e-cf5c-4117-fb589d56323c@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com> <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com> <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com>
 <CAFEAcA-A+zW=QFdCY7z==+Z=xXfhJvPeyHhbG_MpEmpkQfrmaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70866-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sebott@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D0C65125EF0
X-Rspamd-Action: no action

On Wed, 11 Feb 2026, Peter Maydell wrote:
> On Wed, 11 Feb 2026 at 15:37, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Hi Peter,
>>
>> On Fri, 6 Feb 2026, Peter Maydell wrote:
>>> On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:
>
>>>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>>>> +{
>>>> +    ARMCPU *cpu = ARM_CPU(obj);
>>>> +    const struct psci_version *ver;
>>>> +
>>>> +    for (ver = psci_versions; ver->number != -1; ver++) {
>> [...]
>>>> +        if (ver->number == cpu->psci_version)
>>>> +            return g_strdup(ver->str);
>>>> +    }
>>>> +
>>>> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
>>>
>>> Is this ever possible?
>>
>> Hm, not sure actually - what if there's a new kernel/qemu implementing
>> psci version 1.4 and then you migrate to a qemu that doesn't know about
>> 1.4?
>
> Oh, I see -- we're reporting back cpu->psci_version here, which
> indeed could be the value set by KVM. I misread and assumed
> this was just reading back the field that the setter sets,
> which is kvm_prop_psci_version (and which I think will only
> be set via the setter and so isn't ever a value the setter
> doesn't know about).
>
> That does flag up a bug in this patch, though: if I set
> a QOM property via the setter function and then read its
> value via the getter function I ought to get back what
> I just wrote.
>

Meaning this should be something like below?

static char *kvm_get_psci_version(Object *obj, Error **errp)
{
     ARMCPU *cpu = ARM_CPU(obj);

     return g_strdup_printf("%d.%d",
 	(int) PSCI_VERSION_MAJOR(cpu->kvm_prop_psci_version),
 	(int) PSCI_VERSION_MINOR(cpu->kvm_prop_psci_version));
}


