Return-Path: <kvm+bounces-20639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E963391BA3A
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 10:39:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0F791F20EEA
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 08:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8A414B06C;
	Fri, 28 Jun 2024 08:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Shy2uYiA"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAAD14F98;
	Fri, 28 Jun 2024 08:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719563965; cv=none; b=qyIpnvdRFXkWl4Hg4yQZXbr8VV5z4tlKDzTppVGVQ58d29Q7a52KZunyrYCMA/jSWNd7kzAGZh6nayNd6HJXniPHKpEkXmkJ7WVThearhDe54MiUAFGTWHdcenZH8kRKMfbJzrZIxJf2ZqjgaSL1+prYgLOIqu61hUaFo1Ol7Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719563965; c=relaxed/simple;
	bh=CMvIU3Q5KXspV87Df2eVYvbsA4fubNV11mkmbeKmxas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hivkoUn1C978ZGbB68DFMzKgoQ85kGgwTIjELJBaZAX8ysOxWFbDFEQYe3LGBe3hHGZxKLJDt7+ebiKa1vej6sQ1Ua86zJyIalFef/OroAAQaDBk6fO3CUrheI7cvTXOHhjSyNhIfef2giByRgiRiwj57s5Tae9k/fEYhnxEcaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Shy2uYiA; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6E3D540E0027;
	Fri, 28 Jun 2024 08:39:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ai-3D3DBxyTB; Fri, 28 Jun 2024 08:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719563958; bh=yjV8mA0tjQNdFq+u3e3W9D1Gzi5n8+CoX3byN9eQsrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Shy2uYiAx1gFfrFXkaagSkI6rxoNUwJm4F8fwgVdXueZGm10cjkGYK34QtYDn7XcE
	 NJBdJxb2AHo1WH4NVGzdtIDsfyyBrg6Dq6ByrtmNMiaHedvFiZrAOlVun8fG1ZNPmC
	 wYDv75VfMLz0/LDzKA7m8nQGeAgFtajXGoUagSOKLgB3ZeEnUds665lc56bbqn+FiG
	 2pzoowuQKEdAV9Fl6nOTt0JIgO8wh2aX57AgsoxMvZljTdj2QS3xw6OXj5zGO/D9ve
	 Fy3Y+5leXFWcKzhlYmoTEFpuwdKUaTN+L2+ZZvf6cAK51//VtgI6V302/QIIyq48B0
	 BbY3HuxRpSyAfbGMV+zuYWFC9ntv1hr0eYlXgYHZ8NUWWWze0cGbIBKvjSsgRb2yMn
	 +roQOQobSUD8V6YiCz5bqdXwBvmVxILld8gzYdZA1Ux0diAaWOQmaZr22DkydIUTrm
	 6LIZbyuYbi6uPDrN2ZsLQx7PIFaTOEOK3uiuaX35oENy+Vwy9cAVzP852agE4c+fFq
	 K/VYT+eP1xsmEbxCXpRE8cWNzjv23Zg1ioM7uNoBkTpuTFRHJYTCoXiMHCdiwYKa/y
	 QWB00owveCC0S/5xU5jAFCxatQmfy5IrqOMUeRYY666d8V6ZR5cmLcAfzKHXe5xOa4
	 RfXpFCr246HRrFGkPg9QmxLY=
Received: from nazgul.tnic (business-24-134-159-81.pool2.vodafone-ip.de [24.134.159.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EC7EB40E0219;
	Fri, 28 Jun 2024 08:39:06 +0000 (UTC)
Date: Fri, 28 Jun 2024 10:39:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v10 08/24] virt: sev-guest: Take mutex in
 snp_send_guest_request()
Message-ID: <20240628083933.GAZn52xedNc4YbyvQY@fat_crate.local>
References: <20240621123903.2411843-1-nikunj@amd.com>
 <20240621123903.2411843-9-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240621123903.2411843-9-nikunj@amd.com>

On Fri, Jun 21, 2024 at 06:08:47PM +0530, Nikunj A Dadhania wrote:
> SNP command mutex is used to serialize access to the shared buffer, command
> handling and message sequence number races.

serialize access to ... races?

Needs re-formulation.

> As part of the preparation for moving SEV guest driver common code and
> making mutex private, take the mutex in snp_send_guest_request() instead of
> snp_guest_ioctl(). This will result in locking behavior change as detailed
> below:
> 
> Current locking behaviour:
> 
>     snp_guest_ioctl()
>       mutex_lock(&snp_cmd_mutex)
>         get_report()/get_derived_key()/get_ext_report()
>           snp_send_guest_request()
>     	...
>       mutex_unlock(&snp_cmd_mutex)
> 
> New locking behaviour:
> 
>     snp_guest_ioctl()
>       get_report()/get_derived_key()/get_ext_report()
>         snp_send_guest_request()
>            guard(mutex)(&snp_cmd_mutex)
>              ...

Why is it ok to grab the mutex in snp_send_guest_request()?

Folks need to learn to stop spelling out what the patch does but WHY it
does it and WHY is it ok?!?

> Remove multiple lockdep check in the sev-guest driver as they are redundant
> now.

More "what" redundancy.

"The new locking region covers <bla> and that is ok because of <foo>."

This is what your commit message should say.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

