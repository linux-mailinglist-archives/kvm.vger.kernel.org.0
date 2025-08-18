Return-Path: <kvm+bounces-54887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21890B2A229
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 14:51:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C27D171D9E
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 12:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7553C261B99;
	Mon, 18 Aug 2025 12:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VObhgNVe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A893218CC
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 12:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521013; cv=none; b=PG2TxOwN3GO4Ibv7RmZhmG8+93h7IC0dRWAkjjMB8+WqlHY2a6nKz00hhLkvkMJxibgFDTJj+OxPeW2CP6urxxi9DNL4yN935j2NneJ8E0+2E/+QixQcqU7pnfhz6ApHePsWDeXVYB7yIa/X2g3+NHqo0MRhrNuGrjRhbBaALMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521013; c=relaxed/simple;
	bh=UoFbnyFvfPxzfPjOHLENhynrj2VLfZxA3E1ngLe0d8g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QOPqNocjlGkLpK4dpdyfX+rXnENbX0ksyBChSatd+ZSu32u2PX1PaB/LbYWuki+zLCkz+Bf9TANJdhUO7nAZEVo9LJsZFibjcQK0ExHFTuhSIPLU543Uixf68xttFtwIY6CFnlKLKWjuGIfbEW7a0jLcx3RyNlS5tfOOC11GN1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VObhgNVe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755521011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UfD/fwdmMc+K9+orU4dkDu1zrfBl3Mp+6M5GCLVQ2LA=;
	b=VObhgNVe2fH9cKT9spSIjK4Ny/6Hp79G+sWXggL3BrbkXtl+MRkTw/s3KoBgqYgwy4QiTm
	hCDgBGBNlXZbF2TFU2wjCglS1z39VBXdFgMq1XS2F+8ZVsraYJR+Cs2MhIr+HEx9h/BE/R
	Zc+slGZ9hmesbfazAThjsDaIOATtWAU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-cdjlqPVoNyyRyv0gJT07Fg-1; Mon,
 18 Aug 2025 08:43:27 -0400
X-MC-Unique: cdjlqPVoNyyRyv0gJT07Fg-1
X-Mimecast-MFC-AGG-ID: cdjlqPVoNyyRyv0gJT07Fg_1755521006
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1940180044F;
	Mon, 18 Aug 2025 12:43:25 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 99ABC1800280;
	Mon, 18 Aug 2025 12:43:24 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui
 Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 5/6] KVM: arm64: Make ID_AA64PFR1_EL1.RAS_frac writable
In-Reply-To: <20250817202158.395078-6-maz@kernel.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250817202158.395078-1-maz@kernel.org>
 <20250817202158.395078-6-maz@kernel.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 18 Aug 2025 14:43:22 +0200
Message-ID: <87qzx8er6d.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Sun, Aug 17 2025, Marc Zyngier <maz@kernel.org> wrote:

> Allow userspace to write to RAS_frac, under the condition that
> the host supports RASv1p1 with RAS_frac==1. Other configurations
> will result in RAS_frac being exposed as 0, and therefore implicitly
> not writable.
>
> To avoid the clutter, the ID_AA64PFR1_EL1 sanitisation is moved to
> its own function.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c   |  3 ++-
>  arch/arm64/kvm/sys_regs.c | 41 ++++++++++++++++++++++++++-------------
>  2 files changed, 29 insertions(+), 15 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


