Return-Path: <kvm+bounces-37908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5863A31441
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 19:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 807473A5F0C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 18:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A8426214E;
	Tue, 11 Feb 2025 18:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="dSWlJrIC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5154B2512D5;
	Tue, 11 Feb 2025 18:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739299262; cv=none; b=lIAulcJB5xeRE+UsCC8ApEK+3v6iJIeDvUZ8t8TiuSYt8AVKa1hkok6kNHCB110ciH+vIYj0eBfUz+pUL3eADHHhCZ7O+7W5g5Viv9Y8f+8g41JNv4pmKnSaukV+kJa/UKfyE5aatGFs7GqmC04MzACsQR5/ntM02w5etE7arng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739299262; c=relaxed/simple;
	bh=KrcQzU2cuwcp/DKxZt8MWgikwP2pnNYmPOpVyvs0Klo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YQ+Qi6NVALXX11dPrigOmMuTSnpEHw1rNs+8IlEiZJFB5R24BYttJJ96j9DEfsmTSUHcTYNzUMkrOfzks9gy4ZJf/q3B9jrgVnoLuM/A6sBl2UFqn5wDkQZA0Y//VMsxTDP3w3JlwdrRlEgQEUspfqQXVkr1bfputkPfHxE2Ie0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=dSWlJrIC; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id F1F5F40E0177;
	Tue, 11 Feb 2025 18:40:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 5Rf2ncew0aZq; Tue, 11 Feb 2025 18:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739299254; bh=92xrLsP+k3VhCc+TsKTBqWx5JTdBo52z09H/w8PE7O4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dSWlJrICaWCIUzx8rfOK7k5chJur4bbdDfnuElowBNGfqm3bDAhDLXewRAWwDF+tc
	 o7Wllb4REZqBOVVeoVYaI47p8W9YpEo44jm7XvLpVoaj6I9984HLZzM3xx5RvcoSJa
	 ZCKcXGDiKvcpEVpntKsZt8dgBoz5kEAgxdd4ukYL2PIZZ20SwQLd21MC6Y7etN/TO5
	 Z72SWn+Nf1tMGD9p7Dg4DiGT1oRMhBwUJku3WLYMuVFq7+hfB8b0qIdfa/vSASaI2G
	 +iOgSXQANQmSV75kQ3CfiyPicE0lTjP0uo8qIKjUt0pAtD6v0a2wYsgXYQKj4vMZyg
	 fal2owI4xDoKeuuxfxGyGOrMTYw26eQ/izbZqlJN8CXwYxgcQeTbNqoxDRtpqyd9mM
	 EAJIH/HYVDSuoRb2nNxFKm99Occfe9DCM5apE1E3+VqZwRyFz1/gTwCnUT2D5Z1UVe
	 yFl392I+SmTcDDbJqhEB8jFn/dKcoFekGgU8qDOxPobsVD3I8qaQ/AiTRDQFN6EVGB
	 7kDuTcarQLnP9upD9/lZBlWWDz2f7OEfeG9AQgOcPBRzAs2rE0WVXfhIDksbGmcI4Y
	 9vOHSFnwx4nm0Fa2NpJ4hYHGiOrd1NQJ4ATLHurBnv/QowW5RdKISyvVwVYFhrzZvT
	 0HwTWcvM5ahVB6HzEDwuvqKI=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A9B5340E01A3;
	Tue, 11 Feb 2025 18:40:27 +0000 (UTC)
Date: Tue, 11 Feb 2025 19:40:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Juergen Gross <jgross@suse.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.amakhalov@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev, virtualization@lists.linux.dev,
	linux-hyperv@vger.kernel.org, jailhouse-dev@googlegroups.com,
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 01/16] x86/tsc: Add a standalone helpers for getting TSC
 info from CPUID.0x15
Message-ID: <20250211184021.GFZ6uZlZWPVTI5qO1_@fat_crate.local>
References: <20250201021718.699411-1-seanjc@google.com>
 <20250201021718.699411-2-seanjc@google.com>
 <20250211150114.GCZ6tmOqV4rI04HVuY@fat_crate.local>
 <Z6uIGwxx9HzZQ-N7@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z6uIGwxx9HzZQ-N7@google.com>

On Tue, Feb 11, 2025 at 09:25:47AM -0800, Sean Christopherson wrote:
> Because obviously optimizing code that's called once during boot is super
> critical?

Because let's stick 'em where they belong and keep headers containing only
small, trivial and inlineable functions. Having unusually big functions in
a header triggers my weird code patterns detector. :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

