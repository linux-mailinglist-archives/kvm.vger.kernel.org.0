Return-Path: <kvm+bounces-54885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A1DB2A1AB
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 14:35:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE5C63B886F
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 12:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E6B3218BF;
	Mon, 18 Aug 2025 12:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aFTzij4S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F193218B2
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 12:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755520488; cv=none; b=Q7492UurG/EOHd/0u0kSNJJJ5LPKKDmDSKAIncA9svz266r1czVltwe2bLOLnAithFtanJQLi4vN4hR8LlHA9WGjHJJKmReOvBDiRi0z+mCyonq4Er5dPwlWOhr1MsIToC6lIRvxDsy2qbwuoiw8iS5y45WD19MuctuyoSsavZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755520488; c=relaxed/simple;
	bh=CsqqFY/KyVL4iMP69eCQHKjzRmrWeTN2heXKVEyMx7Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iVBe2EKegRQbGcFxKxobk5si5QRXHBFiFL2Vc0tkFdlUH7QigqEibmnhYc++OyzKvQR2WT/dVK1rpuHdGEPwoKAQIdUr0cE7LNkdQN6+7UjU0LyyiSa1zS4edKHFwiop4dYHwyUIHZTVMsdsheOOHsyo5E9/1QRbfxHORiec9eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aFTzij4S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755520485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TKSbrH5oIB8ZU6dcjcUhgYlEM8QpHDUCs4pxg5b6zjQ=;
	b=aFTzij4S8xjxii5yJpjNPr7E5DLRcmIupCuJ14zPq1uG8OEN+A39jmUPCZHJvjcuvOoMb/
	9LEy1yDO9Ak+1Mfv4Kkv44zjU0q81E1Hv9Kd01yUlgtS7Yr3cwkAl7xzwkCXUV3/9h2DvT
	leYsQZz8aSA2OxM2TmBW8IX15Uzu310=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-5nVzAZqgOrG93_CCd2sXUg-1; Mon,
 18 Aug 2025 08:34:42 -0400
X-MC-Unique: 5nVzAZqgOrG93_CCd2sXUg-1
X-Mimecast-MFC-AGG-ID: 5nVzAZqgOrG93_CCd2sXUg_1755520480
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD1971956079;
	Mon, 18 Aug 2025 12:34:39 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CEBA30001A5;
	Mon, 18 Aug 2025 12:34:38 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui
 Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 2/6] KVM: arm64: Handle RASv1p1 registers
In-Reply-To: <20250817202158.395078-3-maz@kernel.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250817202158.395078-1-maz@kernel.org>
 <20250817202158.395078-3-maz@kernel.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 18 Aug 2025 14:34:35 +0200
Message-ID: <87wm70erl0.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Sun, Aug 17 2025, Marc Zyngier <maz@kernel.org> wrote:

> FEAT_RASv1p1 system registeres are not handled at all so far.

s/registeres/registers/

> KVM will give an embarassed warning on the console and inject
> an UNDEF, despite RASv1p1 being exposed to the guest on suitable HW.
>
> Handle these registers similarly to FEAT_RAS, with the added fun
> that there are *two* way to indicate the presence of FEAT_RASv1p1.
>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


