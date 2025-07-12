Return-Path: <kvm+bounces-52229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48763B02BAF
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 17:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A66616C39C
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 15:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D471B288C15;
	Sat, 12 Jul 2025 15:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="G5428cvg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010FD78F36;
	Sat, 12 Jul 2025 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752333718; cv=none; b=hUPZ4PB/7eODA0ULk4V4qgBmrtcVszJyXyBVUDLhvsWtFgFX0zc6fK4TbisvI6SFnfGj2+Tun21JIJ+n8KPcWNsQUi4UBY8ir7m6vPhpGgM5HWQG4n3A2l1Ffc1Ul9SnbjAeJBGuIvxIYL94t75KlGbBtk/ln2Zow4tvJWi4nQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752333718; c=relaxed/simple;
	bh=BburY2L8ZXzBfK/RO3aDc73YGJurbJb78aMaf9aLfr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SAiO6W7LY+kzi312DQlY7qXZU+v9++7qwuHQClAGWRIGYUHCCvsWa4uSh4N1m1K44/cbWQ+GJfwZohd0+aFuGmm+i2Opv/F0YFay93r2/c3bNiHKk2pqF62+dcsliRQbdOSMkLtYOH5t5MIizjKXzuGUE02bfs9TZAt/1VNyCL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=G5428cvg; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B46DC40E00CE;
	Sat, 12 Jul 2025 15:21:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id FvE9YNmnZBKQ; Sat, 12 Jul 2025 15:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1752333710; bh=breZNHGQ4dFqW1rW+APlexa7xzeFdCSgGuxUZypteJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G5428cvgfHR+826+IGSJqy3Pn/a/+u/tIpc9B1K4/pijVEVCposBHYBivhz8XNgK0
	 vjMXQatqp7tPsgSo1suus7ibVCgfOtkjES96bLI537IVZZ/1naSWOhXyn1HT9W7dFV
	 LfMvoy9QOO90QnA+6fJQKsYwvyVy9XiAk3h4Hs/UYkhDOIU/MdX9cxiVbX3h4auYvc
	 YGMqrCzD9eAZAR12dKKW5bhU/CqkyhtBDj6/rFFAOfqA1bgO+oxaCaO+qa+4F84FBq
	 bwGVqqTbF4iafrpSg8D87JcA9AJZbqrVlY76Dq9Dknc85eO5/LQEnq9GzHpnmOqJLU
	 uvv00f+mXoWgdXSf8L0NYBIyWPiY7+9FpCk/Hl1FlH9FilDyVgJV4DZse3EPJz6QdI
	 4NRyQvmesOAl9lY4SCrylnPXFJy5YZusoRkUm37LZH+IcplK2OIKz9O7m5Eu031MLP
	 55FT5yzrd8H9bK8i8QnoFdn0hIT0AtA6QkhhbKfv8IDJyPPpLDb1zi4GTp6Mcb61xZ
	 Uogs98RTW1pIUIRjPSs8riWtKZaFSNP/WXqv7MJu+QNhZF5g9KY+6Udb0ufkUjJ9be
	 qCXs3HcwyDjLzkSyY2Zr4D/IEvKc7TF3tsP7DZVbTBIQs2PWZZffisS69ogwajnfiY
	 Guz8dMEUmqkX2EhscwFr4848=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 244A940E0198;
	Sat, 12 Jul 2025 15:21:29 +0000 (UTC)
Date: Sat, 12 Jul 2025 17:21:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, kai.huang@intel.com
Subject: Re: [RFC PATCH v8 15/35] x86/apic: Unionize apic regs for
 32bit/64bit access w/o type casting
Message-ID: <20250712152123.GEaHJ9c16GcM5AGaNq@fat_crate.local>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
 <20250709033242.267892-16-Neeraj.Upadhyay@amd.com>
 <aG59lcEc3ZBq8aHZ@google.com>
 <be596f16-3a03-4ad0-b3d0-c6737174534a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <be596f16-3a03-4ad0-b3d0-c6737174534a@amd.com>

On Thu, Jul 10, 2025 at 09:13:11AM +0530, Neeraj Upadhyay wrote:
>     struct secure_apic_page {
> 	u8 *regs[PAGE_SIZE];
>     } __aligned(PAGE_SIZE);
> 
> 
> to
> 
>     struct secure_apic_page {

secure_apic_page or secure_aVic_page?

I mean, what is a secure APIC?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

