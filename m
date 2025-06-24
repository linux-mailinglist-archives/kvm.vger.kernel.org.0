Return-Path: <kvm+bounces-50486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C6EAE6546
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 14:42:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 338C93B5A2E
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 12:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8943C291C27;
	Tue, 24 Jun 2025 12:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="ZnPmYoOl"
X-Original-To: kvm@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A89222571;
	Tue, 24 Jun 2025 12:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750768944; cv=none; b=lpjlz/G3QhicjYrq3JG2NZrWGnH3hFw4cBQpuTlpPJH5QLZ7WWS91BQtU+gFl6J5syt7jWt2XrQV8NXN0Pftg/PLAQEuFXxS4uf+qgDBmiG2cm4fH9s5hQlOryBU8GoLy//mPOFm1EhgtJXGKz5H3s1FGW3UyY2YXbPBpFiXdBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750768944; c=relaxed/simple;
	bh=VIVzvuGLxfr6FEARxXBTW3jW4mO77H2gDFFgT8Ut+io=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BcT9ytmcm7pXX8HumYlWO8FBCiPgZShuj6yYaxcKhCsxhSE8jHaaNkfMHg+TyqBX3M2zdPYXws0v3PQYTsRbASSsLHxNLMAklv0NxhV2X9Hk3g8GYExPGJQdDkI09u8xguMgZpkcUcRWxr+Pz0wz8MhxYkTR+nsJnCVlnLeq/eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=ZnPmYoOl; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 0164C406FC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1750768936; bh=oD11XIAvJqRoGH2EZZgtZLub3E/yceoBzeCcm0HjK9w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZnPmYoOliNLXAjgiNqpuGzcUHCNR4FJRzfHgzfy8KdeufvTwe2ryg1jpnDR7Vol64
	 BMwv9G8UpXUKaGWBc9BbpkfIovyuGZU87SwLUyPvo9tE0wO0TvNJZVmAn5EHNtaS/M
	 wfbWVhykEHi5jevC8x4mwJ0v0dwlqMVCBoaGp8MwlRlYekhrPg3MvDhLv/FF1rfg3u
	 zbkuVVBX29yYVk6WblsAd/xgA6a0ai6RBQTNAMEfVQpMjkOMsLXoyHoIoYVJc1PQT3
	 /UVJOJtV8oCb2Knv2OSANKhBH94dQOzBymYx0IuOyumBcDW1pBzZ61H6jPe4UJ2RyZ
	 bPg5RVIac6WIQ==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 0164C406FC;
	Tue, 24 Jun 2025 12:42:15 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Bagas Sanjaya <bagasdotme@gmail.com>, Alok Tiwari
 <alok.a.tiwari@oracle.com>, pbonzini@redhat.com, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] Documentation: KVM: fix reference for
 kvm_ppc_resize_hpt and various typos
In-Reply-To: <aFniQYHCyi4BKVcs@archie.me>
References: <20250623191152.44118-1-alok.a.tiwari@oracle.com>
 <aFniQYHCyi4BKVcs@archie.me>
Date: Tue, 24 Jun 2025 06:42:15 -0600
Message-ID: <87jz5171lk.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bagas Sanjaya <bagasdotme@gmail.com> writes:

> On Mon, Jun 23, 2025 at 12:11:47PM -0700, Alok Tiwari wrote:
>>  If this ioctl is called when a hash table has already been allocated,
>>  with a different order from the existing hash table, the existing hash
>> -table will be freed and a new one allocated.  If this is ioctl is
>> -called when a hash table has already been allocated of the same order
>> +table will be freed and a new one allocated. If this ioctl is called
>> +when a hash table has already been allocated of the same order
>
> Two spaces between sentences (just to be consistent), please.

Spaces after periods are explicitly documented as something we do not
"correct" or harass our contributors about.  Please, for the Nth time,
do not add unnecessary friction to the process of improving our
documentation.

jon

