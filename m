Return-Path: <kvm+bounces-6208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9BF82D58E
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 10:07:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 436511F21B5B
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 09:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8388EE55E;
	Mon, 15 Jan 2024 09:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ZkNaz/iK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A7BC2D2;
	Mon, 15 Jan 2024 09:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9238240E01A9;
	Mon, 15 Jan 2024 09:07:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4xtKFCvfzKuy; Mon, 15 Jan 2024 09:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705309639; bh=fdg/Qndr0DWBNTkgQOVl8J+shnlTJdeLN2SZCkKmRQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZkNaz/iKc3LzjTMyl6FnAiSlV+JZM1UpTOX9qLr8pnYEKoXUT9jNAtvvmQ8pU0p6m
	 +fYgLGKa+NNt52aDxT3FpVtS7PdZmIN2D80G8SNHTsur2lzAr9RxEVRbPf6TVbVJqg
	 0OwMIGnWbY/YpFkgkdd2AgwDqcuc1ok33QTw6PNjtU2wtGxK0WfVqX9ipSXjt25gXe
	 +dJPbtsuhvtfPISu0HiFaBDwQPXcW1bgGFX851UQQ/tfaV05wYYFOrnKy1Bwvl6WpL
	 js+6kZTo4WwJfudgNjOUwobT/R51fBqnsVeQfwp9rByapzDXXmQCtuTLkfmLgrQnzo
	 mCFKfrxrLmq2Z9s4w13d+ebgoK3PriI6UcnJAWGPrdbnoWBPB9ojjR7LmmyoMqSQM7
	 woKce8ot8gcs1H3Br3HLrT7GD+QpKD3RqWHYhyYjpxmZMg3TtHA+lHD+cdRiWxop/r
	 NJy9jak8MYl+VK11r8GNDN3IJe7Xe/nyo4sH0lFeP5FFWIev2qm5caSfykhOcspSbi
	 LGwGMPgfy9HbTFJABSlxrxEqtUzDembSgLL4wMMy9w4doK5sYupWifRHZ70nABRpgq
	 5nF4zTphmDGv45tYTfXv2gYEibHZQZ8i+vIJ6/ONEFrnq995zzrgNZjmhBPmF9K2IF
	 j8KFtKvdHtbTsDvqHcn/GVZo=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ED04740E016C;
	Mon, 15 Jan 2024 09:06:39 +0000 (UTC)
Date: Mon, 15 Jan 2024 10:06:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20240115090639.GAZaT1nx4C4xJuF8IA@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
 <f0f44280-799a-4bf8-bf88-d423a2bd41ec@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f0f44280-799a-4bf8-bf88-d423a2bd41ec@suse.cz>

On Fri, Jan 12, 2024 at 09:27:45PM +0100, Vlastimil Babka wrote:
> Yeah and last LSF/MM we concluded that it's not as a big disadvantage as we
> previously thought https://lwn.net/Articles/931406/

How nice, thanks for that!

Do you have some refs to Mike's tests so that we could run them here too
with SNP guests to see how big - if any - the fragmentation has.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

