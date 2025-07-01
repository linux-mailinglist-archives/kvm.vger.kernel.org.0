Return-Path: <kvm+bounces-51203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B27BDAEFEA2
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 17:48:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30035177BE2
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 15:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E6F2798FA;
	Tue,  1 Jul 2025 15:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="YdTGdhLu"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE6927932F;
	Tue,  1 Jul 2025 15:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751384884; cv=none; b=hDPiIYXVAiLeXELe+QWPGy7HAeKytH867R9BOyFtL9cbNgtpdy349e7cYvA+MAxwBuSVlHgZyN7i0tBuBDKkA50R6xNJNSdlrsTs/4ZbNYGb9TMKiTt/1MAhGWYYrUZZgxVhwOQsOjmx5KvkIjVCYxAeF/jCAlXA27jUZC6WGLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751384884; c=relaxed/simple;
	bh=BYKUkuKuZok2k151Lq0Rk/kgOX2cVc1bCNA0dzoEqSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHgXjO/mqDo9dxQS6dwxTog8BOFbklAFa/pCGt+PM0CVjxWvRt11tz7kX/VLtEfIWPHrWO+T2Jy9WKU96sFehydNG52A6Ui+fXV4BuPZl26thJWeKKhcIZTokk7CScHoyzeg/whmPdg+kIE2mVQdZkQgRgWAu32jyEDtxjuhGLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=YdTGdhLu; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EB08940E020E;
	Tue,  1 Jul 2025 15:47:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id iroTVB6vc-os; Tue,  1 Jul 2025 15:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1751384874; bh=+/ExG4tE06IMdPfzSSj3t7/LJHzcBw9WIOBAEswCrHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YdTGdhLu96e0XrGyrWDJsSFPX/yHy21ZxhVMxDl+bQAzcDZyBAJMO9plL+P2K0iCk
	 zGdHup6lJWyoohMqzuMgWbsqvdXwMSfgUfY5+Qy1utVIwq2luLejnG0QvrfxGpuV0J
	 PgJ62jRNVfqX/CrwIurrUHy80b/nAna3g0z1ZVwhgVNRTsylcGiAkT5Sp1cUQ8hG6b
	 GvQcakz7AGJQ0B7ogAw0ha8Mov+7+bZrBkYvhAdmu+ybaJ6ZZmCXTqVkCN8AVTlnZP
	 hA7+7RaycoBlaM9pwfGUyNPOKjBJLJ2n7vLT/KLu7vjmgnP7B9kD4W89zA8w28Uvyt
	 WtcOL1hRUQFQBWPxB0gFQiE4CCTDzXYvr8fFjxXt5CIB+0veSOEfFl39nN80xTIbPu
	 kbEWVgzcOkzpFIX1rbzmnbnJBvZgmcPMls8YQ9ozoUPlDn7XSrhF7O5noB4l9FCKhS
	 EQO3ygd/YDxH1QF2m4MFlbGXlFv7w10cYpfLb4FMYHcglwR/e2KohbOJO8H1gYROhJ
	 2Q4JXVuqeSQVQQO6IxTDQRFF2GyiksHoDwbRqreAzbzEYyZyaLvWpjukcFUmiEA+BS
	 Jv4buF1yG5UzFw6NAD9P+TdKG2mU46aClhEvZjQqL3UJw07ksqTjFu7wROULoCjOBQ
	 b3mspAYQXofvqKS/6RN5J+VY=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7113040E01FC;
	Tue,  1 Jul 2025 15:47:32 +0000 (UTC)
Date: Tue, 1 Jul 2025 17:47:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [RFC PATCH v7 05/37] KVM: lapic: Change lapic regs base address
 to void pointer
Message-ID: <20250701154726.GJaGQDDjGGDNpuqhFF@fat_crate.local>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
 <20250610175424.209796-6-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250610175424.209796-6-Neeraj.Upadhyay@amd.com>

On Tue, Jun 10, 2025 at 11:23:52PM +0530, Neeraj Upadhyay wrote:
> Change lapic regs base address from "char *" to "void *" in KVM
> lapic's set/reg helper functions. Pointer arithmetic for "void *"
> and "char *" operate identically. With "void *" there is less
> of a chance of doing the wrong thing, e.g. neglecting to cast and
> reading a byte instead of the desired apic reg size.

Please go through your commit messages and do

s/apic/APIC/g

s/reg/register/g in human-readable text. I know this is talking about code but
still - writing a commit message which reads like code is yucky.

And all those abbreviations. You have a mish-mash of all lower letters and all
caps and it reads weird.

Next patch too:

"... for use in Secure AVIC apic driver..." why not "APIC" as a real
abbreviation too?

"... to signify that it is part of apic api."

... as part of the APIC API.

And so on.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

