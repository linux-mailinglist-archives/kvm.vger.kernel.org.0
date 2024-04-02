Return-Path: <kvm+bounces-13365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32105894FCA
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 12:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5772B24B6E
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 10:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C894E60DD3;
	Tue,  2 Apr 2024 10:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bkEalEOE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91FA5D749;
	Tue,  2 Apr 2024 10:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712052957; cv=none; b=bt9Q9doK+rRPoFpHABB0wC29rIdjQHOyCczM7wWv+UWxo1Ed3JywveHuQ263Qh9cN5plued/dlgDMOsFmLWVzxtZ0y5OHx2929YwBlkn6Z3UirIueZeeC5RZwKY9zhRX24o9zLKJwe9dab7WOWEdzdhGwtDPpZoC4W2KEHLRwZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712052957; c=relaxed/simple;
	bh=rxYIdnoOHeFpTj35MGLH9jKM15utL4Chn5z5QC6ILVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=Bpi0C5kJ0V+UwDNjHuZY+0dELUUjVCCm/KITnqGkrw4MwY/TPAANNliCXJLVoj3iC0xF12uJ25ceiOks4FNHVELvvE76QBPw5X3cY0AXz5MIvN8uyo7aRsAPqT9l0T8XHCMNpgz+5RVjbgIWDkYfIKoFsjgn/8EL9PO6F/KMULI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bkEalEOE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317DEC433F1;
	Tue,  2 Apr 2024 10:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712052956;
	bh=rxYIdnoOHeFpTj35MGLH9jKM15utL4Chn5z5QC6ILVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkEalEOE0E09mUR/L9JVW145aNEjNWVMtaT1Vtmpi6EV/Kqr1d35xm7kEP16lazpw
	 /fO3tUIAmiHnthELYszl+I5mKV3MaJWq+05lg32ClOPOaOOxqs0xcec2a9gQK0aYsg
	 FYN3MAabsAJgNYpMRZ0zxEh69swZJ+z/MqaCBzffHuzb2hovqjP1wVG/3BaKZRuSG/
	 9xexulSKbWqsKvXOqDDWuj5IRkIokn0/5ee/sv8bTWBj/HmRislWj+ZsZDJQMtHHL7
	 UB5o0PQHFRx0iDYCFlUCRLbkL5wp5kIUl9zSHf9qkVdATRwPgQPJpToS7s9mCyDUpI
	 EoytL8m2NFTHg==
From: bp@kernel.org
To: michael.roth@amd.com
Cc: bgardon@google.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	dmatlack@google.com,
	hpa@zytor.com,
	jpoimboe@kernel.org,
	kvm@vger.kernel.org,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	maz@kernel.org,
	mingo@redhat.com,
	mirsad.todorovac@alu.unizg.hr,
	pawan.kumar.gupta@linux.intel.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	seanjc@google.com,
	shahuang@redhat.com,
	tabba@google.com,
	tglx@linutronix.de,
	x86@kernel.org
Subject: Re: [BUG net-next] arch/x86/kernel/cpu/bugs.c:2935: "Unpatched return thunk in use. This should not happen!" [STACKTRACE]
Date: Tue,  2 Apr 2024 12:15:49 +0200
Message-ID: <20240402101549.5166-1-bp@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240328123830.dma3nnmmlb7r52ic@amd.com>
References: <1d10cd73-2ae7-42d5-a318-2f9facc42bbe@alu.unizg.hr> <20240318202124.GCZfiiRGVV0angYI9j@fat_crate.local> <12619bd4-9e9e-4883-8706-55d050a4d11a@alu.unizg.hr> <20240326101642.GAZgKgisKXLvggu8Cz@fat_crate.local> <8fc784c2-2aad-4d1d-ba0f-e5ab69d28ec5@alu.unizg.hr> <20240328123830.dma3nnmmlb7r52ic@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Mutt-References: <20240328123830.dma3nnmmlb7r52ic@amd.com>
X-Mutt-Fcc: =outbox
Status: RO
Lines: 21
Content-Transfer-Encoding: 8bit

From: Borislav Petkov <bp@alien8.de>

Sorry if this comes out weird - mail troubles currently.

On Thu, Mar 28, 2024 at 07:38:30AM -0500, Michael Roth wrote:
> I'm seeing it pretty consistently on kvm/next as well. Not sure if
> there's anything special about my config but starting a fairly basic
> SVM guest seems to be enough to trigger it for me on the first
> invocation of svm_vcpu_run().

Hmm, can you share your config and what exactly you're doing?

I can't reproduce with Mirsad's reproducer, probably because of .config
differences. I tried making all CONFIG*KVM* options =y but no
difference.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


