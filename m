Return-Path: <kvm+bounces-19485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C4159059BB
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 19:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 114FE1F23354
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF26181D1D;
	Wed, 12 Jun 2024 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="XN8gxad6"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E9A6EB74;
	Wed, 12 Jun 2024 17:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718212655; cv=none; b=IiLUXnLmVnJh03folGur1Swy+zIHtslwyi3PWWtQDymGSAujlNcbQmgnnxQc0CppsJglIN2Up6Hg7QAaGuIU690mIFGN8POoAUGBCAgNNkJiul8Z0r+0G10fBSkYCBGCQEpEkSJJKnsEpbmlwBWNBfiEod9jFPljp5dLycrejfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718212655; c=relaxed/simple;
	bh=NJQMBQRil58ND6OFo6p92d10MzwhfVEBtzsvz5Bo+ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQygiJp+qppwDpnaJfx36rLYK9vp6Kx9hYr4f5RKO1Bf8buOZGQVFdcwEUSs4rYjipJGwWCOc2yM0X5JaZ+oA61eyxB8oPlq3EpXkpWRCFR10MlYHMa7CJFIbZcYeHrv5saxNiqWVI6hT08JT/yGeGJyVZZjIAueVqkBs3xwwHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=XN8gxad6; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C36C740E016C;
	Wed, 12 Jun 2024 17:17:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 5M2K0XrWouNU; Wed, 12 Jun 2024 17:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1718212647; bh=4k1pYfkT1S0YudCsGUl2eGS93cevs5Njco0yazIY5Pc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XN8gxad6ao+pXDaG6rRqdCedtjTtnJ52hyH8meG72hsLzB/APF3GZuzJpfkzdgAq1
	 4Uj7fhU5UVOd+vCMgOcHd9Tts3VjqUo5o+Q2bJv/+rit/qYUY0H9Z0gSMsasSqsSuM
	 mAD4tmG+47kEjPdtT6UoUQuuxyb/8PmoVjI5GGgsqWulqIZ5arjYaGJc8VHnHAsSNg
	 RJpwDB0LvuH9DX19+SM9bpKmJHhzARYIHzqkrs/rLEdzZRSbe6OPtUJl9q1fyucR71
	 KTiIlhQOKbGDn64VIyQvSz9VorGOebFNFYJO9SRz9mqpnEGMGGSx+b5NxxT/UaK07o
	 UvnbpjEfATB9xZDnhf9yRmmXnUQietv1nC/jOjeECpcIYiQ1DfymB4w42IKT+kvPaP
	 pWZqItHq/WGpycqTJo86b5cHsqmbvIwglAeprm/eY02JWfKAzyDItHVYdTLhKGriEO
	 aoxTuz+65EcycNoqLVaL2expunHkPYylBulX/nFibTkQ6X2vaxF8nWXR78SYMyDf9u
	 S3RG2G+ksk2i2LUcwKJ0O5eHY3bczhvHSTrktak2+L5DsXYCtcknEgzGqmueX1Oc0s
	 IxqPsRvXZFAMzWhpYReaY8kPLYe9ksH3P3ZFw5nxHGY8EztcUJT4lbo9kKWXWZp831
	 KJAHaqfW6Yw4N/j/CxaBHlW8=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7BE7840E0081;
	Wed, 12 Jun 2024 17:17:16 +0000 (UTC)
Date: Wed, 12 Jun 2024 19:17:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v9 01/24] virt: sev-guest: Use AES GCM crypto library
Message-ID: <20240612171710.GDZmnYFizmJoS5nMS1@fat_crate.local>
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-2-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240531043038.3370793-2-nikunj@amd.com>

On Fri, May 31, 2024 at 10:00:15AM +0530, Nikunj A Dadhania wrote:
> The sev-guest driver encryption code uses Crypto API for SNP guest
> messaging to interact with AMD Security processor. For enabling SecureTSC,
> SEV-SNP guests need to send a TSC_INFO request guest message before the
> smpboot phase starts. Details from the TSC_INFO response will be used to
> program the VMSA before the secondary CPUs are brought up. The Crypto API
> is not available this early in the boot phase.
> 
> In preparation of moving the encryption code out of sev-guest driver to
> support SecureTSC and make reviewing the diff easier, start using AES GCM
> library implementation instead of Crypto API.
> 
> Drop __enc_payload() and dec_payload() helpers as both are pretty small and
> can be moved to the respective callers.

Please use this streamlined commit message for your next submission:

"The sev-guest driver encryption code uses the crypto API for SNP guest messaging
with the AMD Security processor. In order to enable secure TSC, SEV-SNP guests
need to send such a TSC_INFO message before the APs are booted. Details from the 
TSC_INFO response will then be used to program the VMSA before the APs are 
brought up.

However, the crypto API is not available this early in the boot process.

In preparation for moving the encryption code out of sev-guest to support secure
TSC and to ease review, switch to using the AES GCM library implementation
instead.

Drop __enc_payload() and dec_payload() helpers as both are small and can be
moved to the respective callers."

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

