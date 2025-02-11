Return-Path: <kvm+bounces-37904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F03B4A31329
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 18:33:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6436F160C21
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF84724394F;
	Tue, 11 Feb 2025 17:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="glQWEIx2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82812261566;
	Tue, 11 Feb 2025 17:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739295199; cv=none; b=HThDuPbZG6wSnszwo5O4TH6lXVklsJjOsB8nq/81aZm+5WXOvQSu/Fd0Me3vu90yn0ulwCFMzAlrLSJGRxSX7IbGOCfySPu3zGr87xhHk3jp6F4UVCprcRtsZQS2ozUkn2HZ47cCnEkSxKoEHR8YeRrCc5vBluK0jX8J9I/2AJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739295199; c=relaxed/simple;
	bh=Bx0xB0hDERyfamEt5nB03kpy1hwfA4pD/ajl6EoG6vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7B6unuwGN+xwqISxeEcdVLJcaPyn+fBLetVuxk2mTWuec3HgYCL7yuZ6oF82RsOKJVqr0qktZeElwIi27ipAJ5ZtDpY0mhg+odPuCKe83SWvnUl/k7g45nGOlk5HaCXMxQv7SSOr2kL3x9jQEOC6Rbqxq4hctTpl4yj/R4z7ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=glQWEIx2; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8E1FA40E01A3;
	Tue, 11 Feb 2025 17:33:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1AVrtT9nhL4M; Tue, 11 Feb 2025 17:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739295189; bh=EDPPB5pchJ3PRDuHl4/eMwbaqvfmU9GnhCPfxyCt6A0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=glQWEIx2q9bjFG6PmueoiyukaePapW3D33jKqhOxc2rdgmUWM20s/zvTLa7MeuHZR
	 Mc440i8zn5xR/bnl3R3Gq1lSPsmlRWR0LFEz/XvMunUZZ/ESPV+1AXfj394pnlc6gF
	 WZ8AMZP3rbFfuMlL9msyanR9Kb9m3HjlnS70O4M+9W9nf92A3GyikWJNgVPD/+Mp+I
	 ml4oawXWH263IanQmISY1HZMoYK2MLjsms33gWB9lLrBHqgnTcEq7rVcTP7aewKgWK
	 /kZG9FRFrMTcyqWLXkwe0/pvUPbVCP4/CaVt1WprSmfVJn1h35GKVv9KJumMRhePpr
	 WkxLlG1+Ali1lrvR3PiRAi1imSA38MxWOC4sOrDIT5zHbgr+wvXt1WW1gvJnxUblDz
	 cTm+XFhqWztTxTzsPg6zH/bmR5sqrpgOz6GlMHdZrbnPLNB43rHinsnjmRNBC55Uy7
	 F1RFtaz7MnerSzE214n+BE0wBbw3YirsuCgqu/MvP2MB+NEQrzi+QLnfDSWwdngjAr
	 9CJDrtszu/9W1zN3oxRvPAGC8fdvXy7k5GdpzB9GU2j71c3LPXy/mx/aXSmWxIdoYH
	 34PGLyH3rcWSFfr72qDMKzLahLR1mcO+zaCXili21ybDKAASqdF0wKBvkOMfCseBEa
	 hUcLD14V3tnJtgTsJg8wOtzc=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D21C540E01AE;
	Tue, 11 Feb 2025 17:32:44 +0000 (UTC)
Date: Tue, 11 Feb 2025 18:32:38 +0100
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
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev, virtualization@lists.linux.dev,
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 03/16] x86/tsc: Add helper to register CPU and TSC freq
 calibration routines
Message-ID: <20250211173238.GDZ6uJtkVBi8_X7kia@fat_crate.local>
References: <20250201021718.699411-1-seanjc@google.com>
 <20250201021718.699411-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250201021718.699411-4-seanjc@google.com>

On Fri, Jan 31, 2025 at 06:17:05PM -0800, Sean Christopherson wrote:

Drop:

jailhouse-dev@googlegroups.com
Alexey Makhalov <alexey.amakhalov@broadcom.com>

from Cc as they're bouncing.

> Add a TODO to call out that AMD_MEM_ENCRYPT is a mess and doesn't depend on
> HYPERVISOR_GUEST because it gates both guest and host code.

Why is it a mess?

I don't see it, frankly.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

