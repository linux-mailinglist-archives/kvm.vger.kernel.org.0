Return-Path: <kvm+bounces-54884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE036B2A1E9
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 14:43:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27750166B9B
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 12:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362DE3218B1;
	Mon, 18 Aug 2025 12:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TqdH3Nfm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B30D3218A3
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 12:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755520338; cv=none; b=Dpyq0X5KKVUmxtbkcYxY89BOVnGkN3I0vRE56vr40UNNg5zwieFoi2x/FZhu8lfeQvT+u9A+IhPa8/gcxwalV2Q4cGnV/4y9DJG3/1uIfY2WFoiztmJA2lb8J6fuI3e3gL1tWQJ84Od/vLdK6Tdh9nnLFM5sVzY3sYP+FPe6P24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755520338; c=relaxed/simple;
	bh=wnzyKxf8inTgU8+M+6idd9OtmixsX9MUjnCXKR2eJKs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ktEVt8OPdr7ILmhueBrZnc+2ZiW7tyuKdj/ifVbbO5HaqWpvWId6K1spcH9BKsxwvmSuUXxXo8H8oA/r+hXscRxwKq3ymJxQw9hQwh2cwfI9FW/XPer9i+oNAhDKnHpHgqLsNctYd6v/KRJd5S8z646AC+CnKNGz7+05J8YQMtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TqdH3Nfm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755520335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/xhetDspssApBKISBn5ZaW5PlAHoD+TybPOqB+IwKDk=;
	b=TqdH3Nfm/z19nW2plS+vc1GpKcZ4IFZyJ0ERMtDTgjErf4gOdF9H/ypSwCOTvOO9/RuHu9
	6MkRjEg4nmwAf93Uo4275MFEl+Aw5DpYlbeNaAmVwAjyf9Ch3tpRQS3fG8CNdpzDKlDj4b
	qdjGtXoNmvX36u0E1MI+/nBb56dfe98=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-QzENNlAGPtaUSEVz6EQjMw-1; Mon,
 18 Aug 2025 08:32:12 -0400
X-MC-Unique: QzENNlAGPtaUSEVz6EQjMw-1
X-Mimecast-MFC-AGG-ID: QzENNlAGPtaUSEVz6EQjMw_1755520330
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F34E195608A;
	Mon, 18 Aug 2025 12:32:09 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC335180028C;
	Mon, 18 Aug 2025 12:32:07 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui
 Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 1/6] arm64: Add capability denoting FEAT_RASv1p1
In-Reply-To: <20250817202158.395078-2-maz@kernel.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250817202158.395078-1-maz@kernel.org>
 <20250817202158.395078-2-maz@kernel.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 18 Aug 2025 14:32:05 +0200
Message-ID: <87zfbwerp6.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Sun, Aug 17 2025, Marc Zyngier <maz@kernel.org> wrote:

> Detecting FEAT_RASv1p1 is rather complicated, as there are two
> ways for the architecture to advertise the same thing (always a
> delight...).
>
> Add a capability that will advertise this in a synthetic way to
> the rest of the kernel.
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/cpufeature.c | 24 ++++++++++++++++++++++++
>  arch/arm64/tools/cpucaps       |  1 +
>  2 files changed, 25 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


