Return-Path: <kvm+bounces-25887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B402A96C0AB
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 16:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6E731C25186
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6611DCB0A;
	Wed,  4 Sep 2024 14:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="d7EHeRQz"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E063C1DC18D;
	Wed,  4 Sep 2024 14:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725460344; cv=none; b=qITbQdDz4ke5miFMLW89+jyC7PNplKS20NFTAjTbyq+smvL5Cu+sXv2mKjpbDunyzeTia1WbmiJMpZyhhqFKMlpB/FymBslc/VC8ZkUUV6MYaMwQE1WHaZEazNDK2ZGgnumPC3x8RY4xtkl6bcs2WRk3Wmesd2GrTSK6pqABCkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725460344; c=relaxed/simple;
	bh=bv6kiTbzsWTd3CnH8QckhfmRKPcHJ4ZmnPmSbbTtg/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RP+4CBcWUO8L2+mtPnv3H8vHJqZQ0GzgXbQuLp6XUGrZNThZAqgaTDngK0Nn4aV9jlnyN7fsn6sZdC7pgR81SIjRa5tOD1TYj06YH8gUrpuDaL64OTFPfPj+GvjpCazAI3r+YPtfa8eNSuaptbbYIIVlPyKj5ffY5llBsijl2g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=d7EHeRQz; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8180140E0275;
	Wed,  4 Sep 2024 14:32:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ryy-xUCOGGpD; Wed,  4 Sep 2024 14:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1725460335; bh=GDJp3zEoTP59/gRDfov3IDTCm5F1N1QFOj6Sf2ColFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d7EHeRQzfr/l/O9+0sgETwBPiVBDSJLbE4xF4D65OioW5pF7DIGXSyvCit7kJ/yP1
	 Ur9bW8wTxQqB/GMq867ei/88ZDblcmthtiP/WuYiE1gUioZMD1oqeI0rNC97SkbdrC
	 sp2DeGA1Bt4LxcCSDCQRvbuZNX3jvlmv9/b2jwtUH74dIjjAnq99ipNkeICJxc7gWt
	 HFjtnETPft4SSR29m//DlwtFtDnWelZnZJYKtbf2grauRi8uqGbj1TQQiuewlqQqbG
	 ERhH8WuE0MaQ0V1FuwdyOjDLzhQq5VF+hSC0R6JJBnL/DxnIMb8BG6TgoVumBKNpJI
	 NBLTXBZi6xfEejO+0qPro4CWpqaZUTfdkCpy1vxR3DOE+JxJLXKHGIqhjkP/H6xG0K
	 WUrj/z9UlVTItAfjHhzkMBH6R9sECXSJkNuJ0TTiGKKI/tBqHsnVewwpLJk3Wcf/ZW
	 RJQxFqdRD8VlDSZ5J4VY9c1eISqUNyy+esOJuwt/YK1HVe6DAUBhEI3kExVeY7eXua
	 Xj9PGZTKJ6Zdu/G+RYOBaptHvkRGJmYzAaOJ7CK3jwSB1dz+MLmyLlGMlJo7bCwihM
	 977btg8PP4VJoQO5bbgzBljRFXMlPYKCYjIz5GiGSD/xLEi4SSX2m19kd3Y4xod95q
	 JmXACnkp4pBfz6xZglNkW+o8=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0EF9040E0191;
	Wed,  4 Sep 2024 14:32:04 +0000 (UTC)
Date: Wed, 4 Sep 2024 16:31:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v11 08/20] virt: sev-guest: Consolidate SNP guest
 messaging parameters to a struct
Message-ID: <20240904143158.GCZthvXgYmvl0VNZVz@fat_crate.local>
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-9-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240731150811.156771-9-nikunj@amd.com>

On Wed, Jul 31, 2024 at 08:37:59PM +0530, Nikunj A Dadhania wrote:
> +static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
> +				struct snp_guest_request_ioctl *rio, u8 type,
> +				void *req_buf, size_t req_sz, void *resp_buf,
> +				u32 resp_sz)
> +{
> +	struct snp_guest_req req = {
> +		.msg_version	= rio->msg_version,
> +		.msg_type	= type,
> +		.vmpck_id	= vmpck_id,
> +		.req_buf	= req_buf,
> +		.req_sz		= req_sz,
> +		.resp_buf	= resp_buf,
> +		.resp_sz	= resp_sz,
> +		.exit_code	= exit_code,
> +	};
> +
> +	return snp_send_guest_request(snp_dev, &req, rio);
> +}

Right, except you don't need that silly routine copying stuff around either
but simply do the right thing at each call site from the get-go.

using the following coding pattern:

	struct snp_guest_req req = { };

	/* assign all members required for the respective call: */
	req.<member> = ...;
	...

	err = snp_send_guest_request(snp_dev, &req, rio);
	if (err)
		...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

