Return-Path: <kvm+bounces-54886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 08FFFB2A1BB
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 14:38:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94EDC7B310A
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 12:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7C221D3E4;
	Mon, 18 Aug 2025 12:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i0bad5VD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADD73218B7
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 12:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755520663; cv=none; b=peWaihmg77x2tRFDLY6rd0TQqGv/S/GeKT3AlZnyxuTkE1A1vmRALz4hhkDOqZGGodTJ55HcOlLn+DivKyW6cZ1ey4topQT7zms5zlRngEd1QHuBjXpDrRWYL82h1BybmbocUnT+w3GEYkQ6CZD2U/48/+QDfFz7s9mnn2mHcxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755520663; c=relaxed/simple;
	bh=vMg4Ou+izBv48m1C4+7AACR/UcTqtZSOITCf5JH+1yU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=D/1TEjW7n2dtwNZaCelWSpOIq59qXIXMnE+7jubDfZYpLcThqg/0mCnDecDqXiRoK7GduDeQDqucZ0MMMyBw43oyveIlln8pQWBUzqGnSQRXtiy7qcHUANVezDX4RtFp1lLvAYqnA2mVaKoIJP58tR3ilt887hgRYjhfXgFYi88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i0bad5VD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755520661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2qOgp7MVZuSP0Gl2TjLKxdK/FGouEDQU4SdWnp2yrQ=;
	b=i0bad5VDK/HHBN+K75ljU9sAjhN8RbVFFEUFaQp4P5K+jf/kMVZHX0oNmWHcW4VZ6vgu3x
	7WojeqO6Zdb665bdgkNC4Gp1Pns823uRWWJhJW6fQx44HcP1WaiPrS10f7M+FR4ZkGZPM7
	IYRFH6wz/dsr59KwHkxEW+EFRI4GpIA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-183-Mz0j3rQXOCSl0HAgxQ7KoQ-1; Mon,
 18 Aug 2025 08:37:37 -0400
X-MC-Unique: Mz0j3rQXOCSl0HAgxQ7KoQ-1
X-Mimecast-MFC-AGG-ID: Mz0j3rQXOCSl0HAgxQ7KoQ_1755520655
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFBEA1955D6A;
	Mon, 18 Aug 2025 12:37:34 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73BC71955F24;
	Mon, 18 Aug 2025 12:37:33 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui
 Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable
In-Reply-To: <20250817202158.395078-5-maz@kernel.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250817202158.395078-1-maz@kernel.org>
 <20250817202158.395078-5-maz@kernel.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 18 Aug 2025 14:37:30 +0200
Message-ID: <87tt24erg5.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Sun, Aug 17 2025, Marc Zyngier <maz@kernel.org> wrote:

> Make ID_AA64PFR0_EL1.RAS writable so that we can restore a VM from
> a system without RAS to a RAS-equipped machine (or disable RAS
> in the guest).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 1 -
>  1 file changed, 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


