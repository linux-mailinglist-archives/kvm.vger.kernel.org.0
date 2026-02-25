Return-Path: <kvm+bounces-71800-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDuvAM+hnmlPWgQAu9opvQ
	(envelope-from <kvm+bounces-71800-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:16:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DDB6193282
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:16:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BBF4B3017DE7
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4C42F745C;
	Wed, 25 Feb 2026 07:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W5EutY1o";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DM12WGpj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC0C22F177
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 07:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772003786; cv=none; b=jMfi0k+F0hgbYeXxofP1CmnfZEpu3Wb+VT1r+75h1/Oe8U405OBI5UQgzWDHKZyOnyTRTIVzD/MzOqMQmYnVEkzasVpVVANfwOvNnT2ZynMvg/BoWDHjVuFs+WQoaG00rbnwlOoYAhsI17BLrkjl78VPAtfAxrOBQ6KxTPDnBbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772003786; c=relaxed/simple;
	bh=xGXEyXsSQzRmxM8FtMy3STvmc4DMp9BHLwqRTciX6BE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Fo/0ggDaSFurCu2KlvzTWGJSdmjFpYPpQLjUuyk2VzZTeQ/mgvpsGOmzeGYLL0+zc2MspoUYrLhSPlL5WsLVOniCJZAJl9PUhPgjxivbngJA3U5hgwhSg7YYYHEX3O1qngGBPZxUoop7pU9e0jPMyVkA5pguLANDnpFX8tcRpT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W5EutY1o; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DM12WGpj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772003784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qL6dea3nPOVHlv2oBcUsVZrWZwNNBBgQt3IQvJSqORw=;
	b=W5EutY1o0Xw2DKHzrU3GtvbN50aVCikTMLFtp2qQ1nw+N93gBeScg5Z8Xg05gdbZrMpRGA
	l61wl9/Hf68qhJSM+qhfUewhr4SL7qXolgGz11HZp9li/4fPYHZKnUSchVyZOKo0M/4S2J
	L+dHI4IxEwSlMdC9+HVjaeYcISsqTFY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-iwAi-AMyO9-9p0IXXaV5OA-1; Wed, 25 Feb 2026 02:16:22 -0500
X-MC-Unique: iwAi-AMyO9-9p0IXXaV5OA-1
X-Mimecast-MFC-AGG-ID: iwAi-AMyO9-9p0IXXaV5OA_1772003782
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-483101623e9so55807665e9.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 23:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772003781; x=1772608581; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qL6dea3nPOVHlv2oBcUsVZrWZwNNBBgQt3IQvJSqORw=;
        b=DM12WGpj8Hn7aiGhCErv5EF0exxH1H2hOonPPXWFfZDgZivjr3MjRVHxgaileJYgXH
         Ruzju+xElcBuztlzRHBfCc8uQK4pzwQUgt5eH9iyFiqJclZvxVvg6aqtak4qB9Xa0pic
         6iw4KbdAtcy2hgNFxoyzAxMumTWe21G5+6uy4hLsC+SdKRYA3kn9lMyL6FBge9ytlYwu
         PWySsMhj1/uQ9xEdgeairTpKqIcAk7lC450aORSPLe9ylIlHd4xB3dcCI0A9WzUNXcJ3
         CCsePp7ldWqqhqtqmbFtDSAyOGjOKw3N0aNFHzTMztAkZE/sKFnEk7Q8t1ki7ysUiK/n
         Iajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772003781; x=1772608581;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qL6dea3nPOVHlv2oBcUsVZrWZwNNBBgQt3IQvJSqORw=;
        b=Vtab0LFRvKNp5hptCQipGxWfzL9bBPQVz4fq6IJfovqBTBScc2ty/6bPjspEkidHhj
         HgFyC6QUvFr8MIHjPZ4APCmyR71Vp9AoSMIlaNKL2SqPTYTtA8sFvhqqwjT0U6aYRtRv
         mxF1nIDD/Ppog1hMCiUH5BQ+FhKiXN5pS7MsGbtYmZicmgTrl5bak35QWQVUeATLb6M9
         ZsNph6O2XCb59H1o6v/J3P1VsQGhBe9UEOjPrg/GSjMz0hBXW18jYFn/AjTYj07BRO68
         eflY9mGlqt9zu73p+4eilfhBC5m2qrhtMaaTEFUAipdxeduDpV4mdTeAMoYIgLBIdn63
         hxXg==
X-Forwarded-Encrypted: i=1; AJvYcCXcaRRowluCQP0uq8zj0iJ9RQGAWxGiBtbwOY/CiGrJ9tMOVNBpfmhmx+1V6/gcR3VwzqY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqQMYrxi8XHzy/PcXFezZSy3WFmc25AC7POzSbcnRNC4HVWN0A
	U4SjAlRirKvl/XZUZ8OP81i8RqVBeZYsBl9VG2KumtTtFvVvXwEAMIMNRKrTXIKMK2It5wyr0jY
	y5lVqpw2szlOJRskto/ST+mNjwJgnNm+fK1AA5vp2/6X3+iK6gHTV6w==
X-Gm-Gg: ATEYQzxCQyRsYXwc70t6Ff3x2tuU5tQmrHpv6qRySG8PLVwDtmmmNetxqfLnrwc6Gfh
	i7wwwJ0cOOd3yYItArWXNP9COutL6xQb21xLKKRocD502r+3FrBWO2azUlzG5nKIF+lkQZPvGHB
	4O1i1LU6z8yTOMbnA2DUwZ2vJ+mN/MjySdtuPy7LCQcbmnObVdSBTEa9JPT68d/zP5AlmO+MgLD
	Wb6fCwI5dVd4gyH5DtfTy3Z6+CPnkSPCqXQGMSTZZnO5Q/PTGx5i+f+9xbRuuuxdXl2SVKArRUm
	LFX0+ayOo7Ervk55wWq6SitK5zy4BuwwdGc1QBXKcriri20nzuTuORvzA4C3PBH4tQhbtNpkLH6
	eCFjHP1ciu5uQux9FWla0LiuMSktbvkRqTt0D4sbCnH+isYiGlo3AgU5A39OFSOia2vl3SbY=
X-Received: by 2002:a05:600c:8708:b0:477:7c7d:d9b2 with SMTP id 5b1f17b1804b1-483a963d62amr213324445e9.32.1772003781523;
        Tue, 24 Feb 2026 23:16:21 -0800 (PST)
X-Received: by 2002:a05:600c:8708:b0:477:7c7d:d9b2 with SMTP id 5b1f17b1804b1-483a963d62amr213324075e9.32.1772003781071;
        Tue, 24 Feb 2026 23:16:21 -0800 (PST)
Received: from rh (p200300f6af25cc00b2a92b19386de96f.dip0.t-ipconnect.de. [2003:f6:af25:cc00:b2a9:2b19:386d:e96f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd732eb1sm50579945e9.12.2026.02.24.23.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 23:16:20 -0800 (PST)
Date: Wed, 25 Feb 2026 08:16:19 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: qemu-devel@nongnu.org, eric.auger@redhat.com, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev, pbonzini@redhat.com, qemu-arm@nongnu.org
Subject: Re: [PATCH v6 1/1] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <CAFEAcA8O2UEKToJ+zXA6=vvgkRyPKrPwtfHnti7yyGgCGwoJeA@mail.gmail.com>
Message-ID: <0616fe7f-96b8-251e-dc0f-9e15ec8298ba@redhat.com>
References: <20260220115656.4831-1-sebott@redhat.com> <20260220115656.4831-2-sebott@redhat.com> <CAFEAcA8O2UEKToJ+zXA6=vvgkRyPKrPwtfHnti7yyGgCGwoJeA@mail.gmail.com>
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
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71800-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sebott@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9DDB6193282
X-Rspamd-Action: no action



On Tue, 24 Feb 2026, Peter Maydell wrote:

> On Fri, 20 Feb 2026 at 11:57, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Provide a kvm specific vcpu property to override the default
>> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>
>> Note: in order to support PSCI v0.1 we need to drop vcpu
>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Tested-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>> ---
>>  docs/system/arm/cpu-features.rst | 11 ++++++++
>>  target/arm/cpu.c                 |  8 +++++-
>>  target/arm/kvm.c                 | 48 ++++++++++++++++++++++++++++++--
>>  3 files changed, 64 insertions(+), 3 deletions(-)
>>
>> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
>> index 3db1f19401..ce19ae6a04 100644
>> --- a/docs/system/arm/cpu-features.rst
>> +++ b/docs/system/arm/cpu-features.rst
>> @@ -204,6 +204,17 @@ the list of KVM VCPU features and their descriptions.
>>    the guest scheduler behavior and/or be exposed to the guest
>>    userspace.
>>
>> +``kvm-psci-version``
>> +  Set the Power State Coordination Interface (PSCI) firmware ABI version
>> +  that KVM provides to the guest. By default KVM will use the newest
>> +  version that it knows about (which is PSCI v1.3 in Linux v6.13).
>> +
>> +  You only need to set this if you want to be able to migrate this
>> +  VM to a host machine running an older kernel that does not
>> +  recognize the PSCI version that this host's kernel defaults to.
>> +
>> +  Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3.
>> +
>>  TCG VCPU Features
>>  =================
>>
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index 10f8280eef..60f391651d 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -1144,7 +1144,13 @@ static void arm_cpu_initfn(Object *obj)
>>       * picky DTB consumer will also provide a helpful error message.
>>       */
>>      cpu->dtb_compatible = "qemu,unknown";
>> -    cpu->psci_version = QEMU_PSCI_VERSION_0_1; /* By default assume PSCI v0.1 */
>> +    if (!kvm_enabled()) {
>> +        /* By default KVM will use the newest PSCI version that it knows about.
>> +         * This can be changed using the kvm-psci-version property.
>> +         * For others assume PSCI v0.1 by default.
>> +         */
>> +        cpu->psci_version = QEMU_PSCI_VERSION_0_1;
>> +    }
>>      cpu->kvm_target = QEMU_KVM_ARM_TARGET_NONE;
>>
>>      if (tcg_enabled() || hvf_enabled()) {
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index ded582e0da..5453460965 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -485,6 +485,28 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>>  }
>>
>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +
>> +    return g_strdup_printf("%d.%d",
>> +                           (int) PSCI_VERSION_MAJOR(cpu->psci_version),
>> +                           (int) PSCI_VERSION_MINOR(cpu->psci_version));
>> +}
>> +
>> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    uint16_t maj, min;
>> +
>> +    if (sscanf(value, "%hd.%hd", &maj, &min) != 2) {
>
> %hd is a signed value, so this will accept "-3.-5" I think ?
> Probably we want %hu.

Ugh, right.

> (If you agree I can just make this fix locally, no need for you to respin.)

That'd be great, Thanks!

Sebastian


