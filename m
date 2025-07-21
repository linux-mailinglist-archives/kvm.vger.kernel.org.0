Return-Path: <kvm+bounces-52977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D8ECB0C4F1
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 15:12:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF0F7188468F
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 13:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD342D6621;
	Mon, 21 Jul 2025 13:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtFSjcy7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A787F2D5C61
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 13:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103552; cv=none; b=XXxJYIMn/S6Wm3u7L+2BXKJoK0TU/NmPI4TyExjG4GHl4fl3Mvy1de+ss5LVb7rg1Kk4lU64mZtfSHJEhRLdKoj9BumjtWL+sk3ioSX1PmAZUr+eCwPAky/2Nm/q1nF7V+qs9E6iwU9TxL9A4vX2A7AEVv+H06Yu8znTbUxYoOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103552; c=relaxed/simple;
	bh=3nC713tAk8DTKDjaltrkzVufTB+8rPOtqlC2a9k6VPk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cv9XrpD9xBH7HEdpXSgOg9LbBfjWQLKwF9daX7ci6ga/Tzl41OmwYTW2EXNDSCiKnwBjHUrGeAcGimv062Jbm/2+p/vyF/qccF51/j9HNcmspwNWgfQRsVlREeffO16Ya3Xg0vNZWgdU5VT4OpXZShuiVGKfSV3N9fmqjn8G9Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WtFSjcy7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753103549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/xaAjesXdXLCll4p8FaZte1EmjouFeib6o8XWb0yKk0=;
	b=WtFSjcy7yPONJXnq76rE9+FO5NdBHW7jrZGft+H77O+zXBIVV8KnGtv4Skb+xyqA9cVRzA
	/7GUDMzVEXAOi/BgGC7TIyGnCC5GF1J2UcuvH5jJXfzvZ0AENIkYMTt27dregAtUp0jEkO
	cRovHbvO3o7ABWGZirArTZZaQ1TWx2Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-e4NUjj3YNnqAnP1qIXKlpw-1; Mon,
 21 Jul 2025 09:12:26 -0400
X-MC-Unique: e4NUjj3YNnqAnP1qIXKlpw-1
X-Mimecast-MFC-AGG-ID: e4NUjj3YNnqAnP1qIXKlpw_1753103544
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8E4A18009F8;
	Mon, 21 Jul 2025 13:12:23 +0000 (UTC)
Received: from localhost (pixel-6a.str.redhat.com [10.33.192.205])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F35019560B3;
	Mon, 21 Jul 2025 13:12:22 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui
 Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: Re: [PATCH 6/7] KVM: arm64: Expose FEAT_RASv1p1 in a canonical manner
In-Reply-To: <86o6td8zzq.wl-maz@kernel.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250721101955.535159-1-maz@kernel.org>
 <20250721101955.535159-7-maz@kernel.org> <87seip67xz.fsf@redhat.com>
 <86o6td8zzq.wl-maz@kernel.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 21 Jul 2025 15:12:19 +0200
Message-ID: <87pldt6630.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Jul 21 2025, Marc Zyngier <maz@kernel.org> wrote:

> On Mon, 21 Jul 2025 13:32:08 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
>> 
>> On Mon, Jul 21 2025, Marc Zyngier <maz@kernel.org> wrote:
>> 
>> > If we have RASv1p1 on the host, advertise it to the guest in the
>> > "canonical way", by setting ID_AA64PFR0_EL1 to V1P1, rather than
>> > the convoluted RAS+RAS_frac method.
>> 
>> Don't the two methods have slightly different semantics with RAS == V1P1
>> possibly implying FEAT_DoubleFault, and RAS+RAS_frac not?
>
> Ah, that's an interesting point -- I definitely had glanced over that.
>
> But I'm not sure a guest can actually distinguish between these two
> configurations, given that FEAT_DoubleFault is essentially an EL3
> feature (as indicated in the RAS == V1P1 section, and further
> confirmed in R_GRJVN), making it invisible to the guest.
>
> FEAT_DoubleFault2 is, on the contrary, totally visible from the guest,
> and independent of EL3.
>
> Does this make sense to you?

It does; but it might make sense to add a comment explaining that.

Userspace should hopefully be able to just map everything to RAS == V1P1
and be done with it.


