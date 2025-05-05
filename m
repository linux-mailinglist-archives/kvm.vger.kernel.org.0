Return-Path: <kvm+bounces-45422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF12CAA97D4
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 17:48:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE00118888E0
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 15:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FF025E457;
	Mon,  5 May 2025 15:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="T2A/yTdc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBB31F540F;
	Mon,  5 May 2025 15:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746460081; cv=none; b=bkPwprtWveC8BRLd7i+eg3iGCf1L9sO4dQy/ThaUsLcRN3R3zkLpkW51MMLrXi9Zvc/vAE+zHHxD6amWE3n6TS7HDmMLLulpx1e98TMgP0T+DcjU6J0wf/4amv4jNafpy2Wuvp6DEr1ecHDTZQBpd/PFrQ5Wbkxi63LfHsy8cHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746460081; c=relaxed/simple;
	bh=eeAdHTJm6FSrjCZKlfIOq8+Vn3n8V2I6OFBiLTT5iKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FTbP9Xyfk87R1yx94T/FPTVrUgm0U5802EhltetkiRvaBRgR6FMkSKQ07AhQo/8k97MLLfQf3j0XFTSTP2eR6i61t71tYFAysbSJDvz6LA5nKwTxy6hNzHM+T9SnDl4hEu8brSlj5VP4vyEMFH1XJ/ZQviUJg5btMRKSq/BzvPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=T2A/yTdc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AD57140E01FA;
	Mon,  5 May 2025 15:47:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id YEE7AJJhfvNQ; Mon,  5 May 2025 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1746460071; bh=Uoj54ZHamcLCff/Dsy1RSXhTMNk3UMUXjW5gx1XCL/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T2A/yTdcAkpsXv56oFoV4TxKUcjztflUlTqG7JatgyVomIj57BznaXSKAM7cy0yAY
	 17aK3s6HfwmPA0VRaZTR3myWr5sN2hIInJpJpMRA7LsX8L64ls/KPCSAIuyQU166HB
	 7bv20nmAnDJ4HX9Ux9AV18/CqYAtoCT6Dgsqfhr9KtSdmB1OAGvxJkoCKrxY8ZdMdK
	 HGlKitBNbH+edAVPiJS0OP+aS2aflUHid1RJZ212bfBsD/wVaLGl/meW5z1Ynp/SLm
	 BvN+gE+R86rxANyykpVZPGUjpaU0xxHbK1w9fzPj8TJfPC8a6J0G2pHXaCR+suDWF/
	 4TLX9WbYle0cq7D4yHHE9qayMgvE8uT7KVbbA6yof7adk6N4xApBwLfVfckHjOWudV
	 kuATfFcS2mONV+dwaPk4IBT9FDSmSPy8HjRKat25Bx50yORxLnqdsvDvAFXLE6ha1d
	 vEDRtmjYv2unFy7rqHf+LvQNiwQrjcJLzFo6NAa3YRNROOSR4kizFDXX0Ta4GsqUIH
	 ksQ7lkg/TeSzQJ4GENEVLD/kdt/hH7kb/dt+1x7VL3cPhY1e0nh3Y2s3yYdh9xR4GL
	 6NV0IojZMWmTgzcFr2JllYdd6KLZmfEYDdlSeO4mZ7m4Ovm64bcRJ2WvAC8aaFVNUA
	 bJmwxPUdqjQBHdNvLYe0y8wg=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7248040E0196;
	Mon,  5 May 2025 15:47:38 +0000 (UTC)
Date: Mon, 5 May 2025 17:47:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Kaplan, David" <David.Kaplan@amd.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Patrick Bellasi <derkling@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	Michael Larabel <Michael@michaellarabel.com>
Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
Message-ID: <20250505154732.GIaBjdlKe_vA9U7gmb@fat_crate.local>
References: <Z7OUZhyPHNtZvwGJ@Asmaa.>
 <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
 <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
 <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
 <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local>
 <aBKzPyqNTwogNLln@google.com>
 <20250501081918.GAaBMuhq6Qaa0C_xk_@fat_crate.local>
 <aBOnzNCngyS_pQIW@google.com>
 <20250505152533.GHaBjYbcQCKqxh-Hzt@fat_crate.local>
 <LV3PR12MB9265E790428699931E58BE8D948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <LV3PR12MB9265E790428699931E58BE8D948E2@LV3PR12MB9265.namprd12.prod.outlook.com>

On Mon, May 05, 2025 at 03:40:20PM +0000, Kaplan, David wrote:
> Almost.  My thought was that kvm_run could do something like:
> 
> If (!this_cpu_read(bp_spec_reduce_is_set)) {
>    wrmsrl to set BP_SEC_REDUCE
>    this_cpu_write(bp_spec_reduce_is_set, 1)
> }

That's what I meant too. :-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

