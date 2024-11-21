Return-Path: <kvm+bounces-32242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B4529D474E
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 06:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ABC6FB22A24
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 05:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFBEE1A9B38;
	Thu, 21 Nov 2024 05:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="E9N70WDZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0842309B6;
	Thu, 21 Nov 2024 05:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732167721; cv=none; b=THXJKS4tnlmK/icP8GShXVJzqKPzr3r4d8CSCu4Vz+kyBRBLPut+KXqQk5+U6ls+5bgBPwT95a4qEMRzCn5Q6NbENlaKScw0tPflGeJH4SR3rTylA58WKzwKqikRgQUQ8vTyaMHnIRgew4LLrrtZCt9UMolmHYaMZzZN75pzijo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732167721; c=relaxed/simple;
	bh=XOfeTJpBYj1oASFvJ0wokqLQSpp4fkLutQEKi7Y8BCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C/0m9YdX/l1U0WjpvEP/xuSfUrCUKBpKuV+o2CJ/BJkzJsM8ZjQpT9eZnAAavsDTbyRikjA7anrpkf1KyjI72JIwGsJTmLguIcrNd93xgkcV3cj8Lrurtyit7Cbto9HBUXNzc5UCIvoqS/N8vklkqlGApKYYCSTjxpWmXzN/Ips=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=E9N70WDZ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2799540E0263;
	Thu, 21 Nov 2024 05:41:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TOPIyVX0cGws; Thu, 21 Nov 2024 05:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732167707; bh=fD+so7iwQxwnZXOMmJxkk19zSXMUKaOmkfXzpkSwzCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E9N70WDZ6LWNOBgosrT6o4cCN79uj8B7my0gDo43omlycL5C171x2ZWSEjVLMUpkV
	 7G44i58FsIY0JY0soW7ptToAOwsvR+VuYmc66t1u3V7okB4tKgiEHJZ+Wz/jL4bluh
	 VgT2cTOGAw6DcwmpSR4y9AZrfYcgL7VdR9lByHTtSQqUykSgSBRwp8A9zf4SeWn4xA
	 huY8AEZVlGTHCoL3G9gtD/A6NbQzM85Q7s4/9ypHVcTWW0No5EsChcP75T0hCqoqeb
	 vpsgcqtMc3AGOvFqRDTbLf39mGfAMQe4Usl1ZkSpqLfR5vZSPChRFykXkacaxJS8+I
	 ShOHo53AEuQSP505H7oFFc8dlOc/tFQnuUC3Nm8Op9hzrVk/Bbgzm5+UF3w6m+E1Nn
	 paf3Cx6zNuvmqugYHQzKmSumxdv+lhow4v1sRnlz5UGhD8E8UDeRqIiSy17hhH+AN4
	 10H4eOHHYlN3gSv813OjCQrMbSwI5TXjiSELgsrcXAbXhTFBYRARVKzEhTf5Rg+KTm
	 ogaTbJuVNAEA8fPhchR0ZHiZjb7rPyO9DG5jhcnb41xG0F6qN0xMvK2rV7Ke7Eh8jf
	 MDjApawum6Tk3XqL6pqra0hhGbVQQjPGgwYal8UahIFVGonvs7QD5QItgx/J0+yXqf
	 EWjeYWdb5OQXTaJvJSRD0MBM=
Received: from zn.tnic (p200300ea9736a1a8329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9736:a1a8:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3CE4E40E021C;
	Thu, 21 Nov 2024 05:41:29 +0000 (UTC)
Date: Thu, 21 Nov 2024 06:41:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: "Melody (Huibo) Wang" <huibo.wang@amd.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <20241121054116.GAZz7H_Cub_ziNiBQN@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <6f6c1a11-40bd-48dc-8e11-4a1f67eaa43b@amd.com>
 <4f0769a6-ef77-46f8-ba78-38d82995aa26@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4f0769a6-ef77-46f8-ba78-38d82995aa26@amd.com>

On Thu, Nov 21, 2024 at 10:35:35AM +0530, Neeraj Upadhyay wrote:
> APIC common code (arch/x86/kernel/apic/apic.c) and other parts of the
> x86 code use X86_X2APIC config to enable x2apic related initialization
> and functionality. So, dependency on X2APIC need to be there.

Have you actually tried to remove the dependency and see how it looks?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

