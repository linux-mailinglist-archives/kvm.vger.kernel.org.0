Return-Path: <kvm+bounces-55748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4AA1B363E5
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 15:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0C7E8A7DFB
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 13:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5C033CEBC;
	Tue, 26 Aug 2025 13:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="XDghpPg6"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FCE299AAB;
	Tue, 26 Aug 2025 13:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214765; cv=none; b=oQJUfwb9Ph0qaMY2JHhj9dxf6G5+JwSJPmR0uWAEHRwj0yn9GMTzBq54/P5zVicNd7rSIYGWNZCeVk9GAqA7Nevkq2nilVFlGGPo6nNj6edDrrW48ubESihD7PNLcX97pWAtLqvAutWc5+8hTwlRa0O2Rkyrwwru2SjTv4rummk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214765; c=relaxed/simple;
	bh=1k5c/M/i2Yfu95IdR3Upie4zGu8fS2Q/phiESDFvzXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUpQb7g0x8r46Zd42UdagOl+thjWPN29BdZPUH+gNWramCzeH3jW80LDDzf4nh6zsSQ6YH1a+djZBTHdN7+Jde2eS3PYbtPC3jrbs+oqcjHrsYPS7kCzN5yk3lO96YrlKMA1JanSun7Nzoam3uO0RsuJbaG+a1luoAccoO16JTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=XDghpPg6; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1592440E02A2;
	Tue, 26 Aug 2025 13:25:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 0xr7g7-msv9G; Tue, 26 Aug 2025 13:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756214755; bh=QYodkVHQWRILKGiAD29E79aU/fibF8xosvTbdEgk3Dk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XDghpPg6BrNJNXiexULylkUKZL9c+0dMhMikq4MxQF7eZ4+d+6J864JLMwLvF7f9y
	 +8yiIf/Vm12WI/awXdkqmj6U4lTXikjGiH2eTbZZ8A9Au9q57yRVkmhpsoS5IcPvlx
	 a6mZBlzodubtbDp8HU1Y/vWv9pMhG3q1K9AiVDuXzaT9prT5uazAaRUMkebknWyaBN
	 QGqPTCS/MMFaaD0G9hQpAt0rBe8Pu60eUFCl8fWEj8MojB4iZJZNOXPnE+1CR2hmsi
	 aeOSV5CIpfW4ciQks8l68WC7g0oWR85maWmAeamoN2YmJ+ZLClxbZOGbMoEbEHUh2D
	 QaZQzrne16PDRFIEE6KTwAEolDO/ZGlefz+/0cu46ayLeVPCSfXent12Ph6rTGF1vg
	 Cj1r2J9Rrkvg2kZaYNZSzx1gDFM8NnPIgUQQ5mzGgkGzmSHIs8aphzDq+6vwGKCSqh
	 4Dg1Gjvw61Y5TPPKVVCFmE+M7yBOf9uz1wlRgCCZbdVeK3c77fPLqYjWAhcLDRRy0W
	 iz2Srpg21djx5hqVYM+ttSHPTxm4OioNF+jGjMPw/26dDr8ZdYsNnrMqWYshCRx8sk
	 Xw6Zx9+n63mNxQTU5oAc8Q4edMPrcGJ+yiANbWAKnhMAwOUd/vX1jplzV/qN3afMNu
	 PhkLYFBU6DVI56aYsCEUCsno=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6635E40E02A1;
	Tue, 26 Aug 2025 13:25:33 +0000 (UTC)
Date: Tue, 26 Aug 2025 15:25:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [PATCH v9 05/18] x86/apic: Add update_vector() callback for apic
 drivers
Message-ID: <20250826132527.GFaK21x6tEHv6Ti3ot@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-6-Neeraj.Upadhyay@amd.com>
 <20250819215906.GNaKTzqvk5u0x7O3jw@fat_crate.local>
 <c079f927-483c-46c4-a98e-6ad393cb23ef@amd.com>
 <20250825144926.GVaKx39npwZZ18htgX@fat_crate.local>
 <74234b63-d9c3-4429-848d-0953fa684d5c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <74234b63-d9c3-4429-848d-0953fa684d5c@amd.com>

On Tue, Aug 26, 2025 at 09:36:56AM +0530, Upadhyay, Neeraj wrote:
> or chip_data_update_vector() as the updates are specific for a new vector
> assignment?

This function assigns a bunch of things to struct apic_chip_data - not only
vector.

If we had to be precise perhaps update_vector_chip_data() or so. Or
chip_data_update_for_vector(). To better describe what the function does.

> Got it. However, I see other static functions in this file using "apic_"
> prefix (in some cases, maybe to differentiate "apic_chip_data" from a
> generic "chip_data" in common kernel/irq/ subys?).

Looks like this file would need cleaning up wrt naming but that's not that
important at the moment I'd say. There are other functions which don't have
the apic_ prefix so it is kinda arbitrary.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

