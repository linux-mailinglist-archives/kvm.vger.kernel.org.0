Return-Path: <kvm+bounces-54504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA43B222A0
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 11:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0E7E68192E
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 09:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3352E63F;
	Tue, 12 Aug 2025 09:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8UgrXqI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A3B1FF61E
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 09:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754989964; cv=none; b=KWSPZz6MD3hDaLgczujxBRvPcgpwWn+XADrlqbwz9/eNnStz8rQ++TK0Mwim7tUJVMA+/qDWFGbPdYJIrBx35ramlpOaAhdZh7QHITE0aNI+yhjbkIU13LeJlRnqe6O+EH0NKDvHKrLl3aEWrO8b2An3HwavFo85yyCn+FuyRXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754989964; c=relaxed/simple;
	bh=idmEHSyqEvAb7I7rRWbwHWZfBkOEzieiGVxVneIRnpg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GKaq//ORh98wtfliWfXwy5ZIFx1L/OVKTRSK1Pixt4Er9VmxrRglXk9yhdKJm2L+h/HS54dvYj1BQFa1XQJHu67NgZu2+YK9pQ6DMPOy3x2wDuOKeQStPZN4V90+EmkrmYh6+mcmF6F/dxehxqRHzlwWqNgFwvDJrgeVptB0v8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8UgrXqI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754989961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wL7oMuxzuq77ZJtUvDZifXFtmHYOVxGq8Ts3DyGKcJ8=;
	b=D8UgrXqIOumAZO2U3I3PHPu5R9hHalwS97UYnkugqG0R8KzH9iA198tJs18mbl/JVB9TwM
	fEoJgBDim2HOQFvxXZzKpY7bUxcb8YGM72eU7Plglkjuzwy9ZO5pzCimWwLBBps6w/Ds1m
	4WmTclkd8i+cXbN4yGUtcv/Z+ykP+78=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-CvFAT5kQMcmvSzRHF-icHw-1; Tue,
 12 Aug 2025 05:12:37 -0400
X-MC-Unique: CvFAT5kQMcmvSzRHF-icHw-1
X-Mimecast-MFC-AGG-ID: CvFAT5kQMcmvSzRHF-icHw_1754989956
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A85BF1800371;
	Tue, 12 Aug 2025 09:12:35 +0000 (UTC)
Received: from localhost (dhcp-192-236.str.redhat.com [10.33.192.236])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C4901800291;
	Tue, 12 Aug 2025 09:12:34 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver
 Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, Will
 Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 4/5] KVM: arm64: Expose FEAT_RASv1p1 in a canonical
 manner
In-Reply-To: <874iugtfib.wl-maz@kernel.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250806165615.1513164-1-maz@kernel.org>
 <20250806165615.1513164-5-maz@kernel.org>
 <20250807125531.GB2351327@e124191.cambridge.arm.com>
 <874iugtfib.wl-maz@kernel.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 12 Aug 2025 11:12:31 +0200
Message-ID: <878qjogayo.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Sat, Aug 09 2025, Marc Zyngier <maz@kernel.org> wrote:

> On Thu, 07 Aug 2025 13:55:31 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
>> 
>> On Wed, Aug 06, 2025 at 05:56:14PM +0100, Marc Zyngier wrote:
>> > If we have RASv1p1 on the host, advertise it to the guest in the
>> > "canonical way", by setting ID_AA64PFR0_EL1 to V1P1, rather than
>> > the convoluted RAS+RAS_frac method.
>> > 
>> > Note that this also advertises FEAT_DoubleFault, which doesn't
>> > affect the guest at all, as only EL3 is concerned by this.
>> > 
>> > Signed-off-by: Marc Zyngier <maz@kernel.org>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 12 ++++++++++++
>> >  1 file changed, 12 insertions(+)
>> > 
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index 1b4114790024e..66e5a733e9628 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -1800,6 +1800,18 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>> >  	if (!vcpu_has_sve(vcpu))
>> >  		val &= ~ID_AA64PFR0_EL1_SVE_MASK;
>> >  
>> > +	/*
>> > +	 * Describe RASv1p1 in a canonical way -- ID_AA64PFR1_EL1.RAS_frac
>> > +	 * is cleared separately. Note that by advertising RASv1p1 here, we
>> 
>> Where is it cleared? __kvm_read_sanitised_id_reg() is where I would have
>> expected to see it:
>> 
>>     case SYS_ID_AA64PFR1_EL1:
>
> [...]
>
> Ah crap, it is the nested code that we get rid of it, nowhere else.
> Which means that non-nested VMs have already observed RAS_frac. What a
> mess. Then RAS_frac must be exposed as writable.
>
> The question is whether we want to allow migration between one flavour
> of RASv1p1 and the other.

I guess that boils down to which kind of observable changes we want to
allow: bit-for-bit register contents, or only features? If only feature
stability is needed, then a cross-flavour migration would be fine; OTOH,
we do not know how a guest deduces feature availability, and it might
check for one flavour, but not the other (which is mostly a problem if
it re-checks during the lifetime.)

Only looking at strictly matching register contents would probably be
easier to implement for the VMM (well, it looks easier for QEMU :)


