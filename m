Return-Path: <kvm+bounces-33718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 940ED9F094D
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 11:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 558E9280DCF
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 10:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A7B1B87CA;
	Fri, 13 Dec 2024 10:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="hafosO0p";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="3x+4DxUU"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389CF63D;
	Fri, 13 Dec 2024 10:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734085247; cv=none; b=mryQP99h7ZMhKHGxhryaCGaNWv89MO0a/LMiJWv3wCVB5pbT3z24UYflKNpHCrGM/Bip9BozdRw1FtVBELgKimWAAAJZRCxXvOBB/5b/wmdilGxetTMrN2R5glvp0m0547J7qcU8PFCntkPw1QU46EjWe6Oh68REpZDEeXtQ8BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734085247; c=relaxed/simple;
	bh=LOjegZ/Xiq5oEy2Wc2CpSGGoNbCRQOVFPJn0BWVjuT0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=DTrOK31FXvlkMKPTWdOOY8Kz0FCJo0lhwxPD1Mhm327/0CB+LHHuZP9C/CUVUdxTngBBbcy63gB9sp2FXHXrt0tdn7GLl9znWm9qh93eWjPhulpvFNAuCWrS4p72PAK98uFjavxbbP8aMvvrua3VwaSMtYhAw+UsNJ14Cc+p2HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=hafosO0p; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=3x+4DxUU; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 49C4911401EE;
	Fri, 13 Dec 2024 05:20:43 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Fri, 13 Dec 2024 05:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1734085243;
	 x=1734171643; bh=IMb1NpbRY5gQZp1GGEw6l+bgS26lmUCIQ/gBSo44bCo=; b=
	hafosO0pH2ac5V+nw0ZbLPTQPoCnj1AnMwiOphXwbkjr1QUumcWVOk+JCGzm6Vmb
	73nqdZMrmCmbHyU430dG2gjy4tDZ775WHwtR1MEiSYXwTfywli7b0zEMaHRIHSdh
	AE1H13704vBMNuzvJODkJQy5lG3XYE8HkHgINCpxlVFDfzg/PQLu7yYC/1vmOkH0
	E54PHfiAFIW5yl+zCHy2iUwzwK/6xX7NSwLqi228bb0yomLI8MToIL3qwswfCmQM
	H3tRpqyfS+mteHS16dbMR/ErgM0WNxEU8A5AIv16aghWGbSONNMlbfWQzebOKNYd
	/KFQCy5py8tXpXUFgRjg9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1734085243; x=
	1734171643; bh=IMb1NpbRY5gQZp1GGEw6l+bgS26lmUCIQ/gBSo44bCo=; b=3
	x+4DxUUnFK1oAP04tuB+w/czp3uTokr/Zg9W2b9Zjm630zQGMrBTi7LlvsthmHDF
	v4/n4Fk4g3Zagod+Xc9JyXFWFP5vYTDp5rWmaacipX4mnVDIVKTSojdJ4ioU3A8e
	uwscCfAdWDaV9O09NNUUAkQKVJJMfdiUNxixyh5bJkbTYqKbyuiwtR4YuVDr5LD9
	sflY9mRXNWdt8qb9634QVNe4BzlqbJY1+OrSMiXI653DnKhnRhvf7yZ5LoZqpcc0
	tgtckn6lJN1umcAb3hw3qpJo7MmWcZNcnZhsiwXXq9wRyHrrZJUMx2iIUqYUhNWW
	yVFIUsb95eoywfolRo4qQ==
X-ME-Sender: <xms:eQpcZ3huzLNM1lDyiMsvx3zdY-XIPlyj85bTVQ28NNItrL90D4PEBw>
    <xme:eQpcZ0D14Gc52X5S5ZtfNduM96IUCXe7iD_C4IjaB9BHFrGbc9FpC4kwx3NgdVEmJ
    TFesn6TphuzzfUsCKs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrkeejgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeen
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpeevgfeigeffgfekteehvedvlefhgeeghedvfedukeeu
    keeugfetveeludeuieehtdenucffohhmrghinhephhgvrggupgekheiggidrshgsnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegr
    rhhnuggsrdguvgdpnhgspghrtghpthhtohepfeegpdhmohguvgepshhmthhpohhuthdprh
    gtphhtthhopegsphesrghlihgvnhekrdguvgdprhgtphhtthhopehtshgsohhgvghnuges
    rghlphhhrgdrfhhrrghnkhgvnhdruggvpdhrtghpthhtohepghhrrghfsegrmhgriihonh
    drtghomhdprhgtphhtthhopegrthhishhhphesrghtihhshhhprghtrhgrrdhorhhgpdhr
    tghpthhtoheprghnuhhpsegsrhgrihhnfhgruhhlthdrohhrghdprhgtphhtthhopegthh
    hrihhsthhophhhvgdrlhgvrhhohiestghsghhrohhuphdrvghupdhrtghpthhtohepphgr
    lhhmvghrsegurggssggvlhhtrdgtohhmpdhrtghpthhtoheprghouhesvggvtghsrdgsvg
    hrkhgvlhgvhidrvgguuhdprhgtphhtthhopehmphgvsegvlhhlvghrmhgrnhdrihgurdgr
    uh
X-ME-Proxy: <xmx:eQpcZ3FEgOWNkcGeKkURorYx6QvueeNLqkuTc_Hwx94hTEsT9_8MjA>
    <xmx:egpcZ0QWKlBjJmj7g4B_YZtG_NZWIGeroqsXKuAsAsZjN5Mq79wB0g>
    <xmx:egpcZ0xX4KzLhFwxphxSuo4EEuBLRe9OFVrz62tF1b5HJgyn_Ncy0A>
    <xmx:egpcZ64P6gxah9oEjaEyU5qKQVeZk6phMOorf8qb-RmlMlHNpRDZvA>
    <xmx:ewpcZyi2q0m3LnnLOp-IJ-luaQ5vhyjpu8MHEogB8umRK8eOuJjQ2PhV>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D070E2220072; Fri, 13 Dec 2024 05:20:41 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 13 Dec 2024 11:20:21 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Arnd Bergmann" <arnd@kernel.org>, kvm@vger.kernel.org
Cc: "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "Huacai Chen" <chenhuacai@kernel.org>,
 "Jiaxun Yang" <jiaxun.yang@flygoat.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Naveen N Rao" <naveen@kernel.org>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Alexander Graf" <graf@amazon.com>, "Crystal Wood" <crwood@redhat.com>,
 "Anup Patel" <anup@brainfault.org>,
 "Atish Patra" <atishp@atishpatra.org>,
 "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>,
 "Sean Christopherson" <seanjc@google.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Vitaly Kuznetsov" <vkuznets@redhat.com>,
 "David Woodhouse" <dwmw2@infradead.org>, "Paul Durrant" <paul@xen.org>,
 "Marc Zyngier" <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Message-Id: <43a3765d-709b-4583-ad27-f9bb46a88440@app.fastmail.com>
In-Reply-To: <1f1beb34-65cc-4038-a8b2-de8af3e0703e@csgroup.eu>
References: <20241212125516.467123-1-arnd@kernel.org>
 <20241212125516.467123-3-arnd@kernel.org>
 <3589ad69-13df-40f1-88c2-55d39790bbac@csgroup.eu>
 <1633f30e-d885-4f31-a14d-11881e16deb9@app.fastmail.com>
 <1f1beb34-65cc-4038-a8b2-de8af3e0703e@csgroup.eu>
Subject: Re: [RFC 2/5] powerpc: kvm: drop 32-bit booke
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024, at 07:25, Christophe Leroy wrote:
> Le 12/12/2024 =C3=A0 22:08, Arnd Bergmann a =C3=A9crit=C2=A0:
>
> So yes it is used on e5500/e6500 but only when they run a 32 bits kern=
el=20
> built with CONFIG_PPC_85xx. Isn't it what you want to get rid of with=20
> this patch ?
>
> Am I missing something ?

I think I mixed up CONFIG_PPC_E500 and CONFIG_PPC_85xx and hadn't
realized that we use CONFIG_PPC_BOOK3E_64 instead of PPC_85xx for
the 64-bit mode. I found a few more things that can be removed
now and folded in the patch below, which includes your suggestions.

     Arnd

diff --git a/arch/powerpc/kernel/head_85xx.S b/arch/powerpc/kernel/head_=
85xx.S
index f9a73fae6464..661903d31b54 100644
--- a/arch/powerpc/kernel/head_85xx.S
+++ b/arch/powerpc/kernel/head_85xx.S
@@ -425,16 +425,10 @@ interrupt_base:
 	mtspr	SPRN_SPRG_WSCRATCH0, r10 /* Save some working registers */
 	mfspr	r10, SPRN_SPRG_THREAD
 	stw	r11, THREAD_NORMSAVE(0)(r10)
-#ifdef CONFIG_KVM_BOOKE_HV
-BEGIN_FTR_SECTION
-	mfspr	r11, SPRN_SRR1
-END_FTR_SECTION_IFSET(CPU_FTR_EMB_HV)
-#endif
 	stw	r12, THREAD_NORMSAVE(1)(r10)
 	stw	r13, THREAD_NORMSAVE(2)(r10)
 	mfcr	r13
 	stw	r13, THREAD_NORMSAVE(3)(r10)
-	DO_KVM	BOOKE_INTERRUPT_DTLB_MISS SPRN_SRR1
 START_BTB_FLUSH_SECTION
 	mfspr r11, SPRN_SRR1
 	andi. r10,r11,MSR_PR
@@ -517,16 +511,10 @@ END_BTB_FLUSH_SECTION
 	mtspr	SPRN_SPRG_WSCRATCH0, r10 /* Save some working registers */
 	mfspr	r10, SPRN_SPRG_THREAD
 	stw	r11, THREAD_NORMSAVE(0)(r10)
-#ifdef CONFIG_KVM_BOOKE_HV
-BEGIN_FTR_SECTION
-	mfspr	r11, SPRN_SRR1
-END_FTR_SECTION_IFSET(CPU_FTR_EMB_HV)
-#endif
 	stw	r12, THREAD_NORMSAVE(1)(r10)
 	stw	r13, THREAD_NORMSAVE(2)(r10)
 	mfcr	r13
 	stw	r13, THREAD_NORMSAVE(3)(r10)
-	DO_KVM	BOOKE_INTERRUPT_ITLB_MISS SPRN_SRR1
 START_BTB_FLUSH_SECTION
 	mfspr r11, SPRN_SRR1
 	andi. r10,r11,MSR_PR
@@ -660,8 +648,6 @@ END_BTB_FLUSH_SECTION
 	DEBUG_DEBUG_EXCEPTION
 	DEBUG_CRIT_EXCEPTION
=20
-	GUEST_DOORBELL_EXCEPTION
-
 	CRITICAL_EXCEPTION(0, GUEST_DBELL_CRIT, CriticalGuestDoorbell, \
 			   unknown_exception)
=20
diff --git a/arch/powerpc/kernel/head_booke.h b/arch/powerpc/kernel/head=
_booke.h
index 0b5c1993809e..d1ffef4d05b5 100644
--- a/arch/powerpc/kernel/head_booke.h
+++ b/arch/powerpc/kernel/head_booke.h
@@ -3,8 +3,6 @@
 #define __HEAD_BOOKE_H__
=20
 #include <asm/ptrace.h>	/* for STACK_FRAME_REGS_MARKER */
-#include <asm/kvm_asm.h>
-#include <asm/kvm_booke_hv_asm.h>
 #include <asm/thread_info.h>	/* for THREAD_SHIFT */
=20
 #ifdef __ASSEMBLY__
@@ -52,7 +50,6 @@ END_BTB_FLUSH_SECTION
 	stw	r13, THREAD_NORMSAVE(2)(r10);				     \
 	mfcr	r13;			/* save CR in r13 for now	   */\
 	mfspr	r11, SPRN_SRR1;		                                     \
-	DO_KVM	BOOKE_INTERRUPT_##intno SPRN_SRR1;			     \
 	andi.	r11, r11, MSR_PR;	/* check whether user or kernel    */\
 	LOAD_REG_IMMEDIATE(r11, MSR_KERNEL);				\
 	mtmsr	r11;							\
@@ -114,25 +111,7 @@ END_BTB_FLUSH_SECTION
=20
 .macro SYSCALL_ENTRY trapno intno srr1
 	mfspr	r10, SPRN_SPRG_THREAD
-#ifdef CONFIG_KVM_BOOKE_HV
-BEGIN_FTR_SECTION
-	mtspr	SPRN_SPRG_WSCRATCH0, r10
-	stw	r11, THREAD_NORMSAVE(0)(r10)
-	stw	r13, THREAD_NORMSAVE(2)(r10)
-	mfcr	r13			/* save CR in r13 for now	   */
-	mfspr	r11, SPRN_SRR1
-	mtocrf	0x80, r11	/* check MSR[GS] without clobbering reg */
-	bf	3, 1975f
-	b	kvmppc_handler_\intno\()_\srr1
-1975:
-	mr	r12, r13
-	lwz	r13, THREAD_NORMSAVE(2)(r10)
-FTR_SECTION_ELSE
 	mfcr	r12
-ALT_FTR_SECTION_END_IFSET(CPU_FTR_EMB_HV)
-#else
-	mfcr	r12
-#endif
 	mfspr	r9, SPRN_SRR1
 	BOOKE_CLEAR_BTB(r11)
 	mr	r11, r1
@@ -198,7 +177,6 @@ ALT_FTR_SECTION_END_IFSET(CPU_FTR_EMB_HV)
 	stw	r11,GPR11(r8);						     \
 	stw	r9,_CCR(r8);		/* save CR on stack		   */\
 	mfspr	r11,exc_level_srr1;	/* check whether user or kernel    */\
-	DO_KVM	BOOKE_INTERRUPT_##intno exc_level_srr1;		             \
 	BOOKE_CLEAR_BTB(r10)						\
 	andi.	r11,r11,MSR_PR;						     \
 	LOAD_REG_IMMEDIATE(r11, MSR_KERNEL & ~(MSR_ME|MSR_DE|MSR_CE));	\
@@ -272,23 +250,6 @@ ALT_FTR_SECTION_END_IFSET(CPU_FTR_EMB_HV)
 		EXC_LEVEL_EXCEPTION_PROLOG(MC, trapno+4, MACHINE_CHECK, \
 			SPRN_MCSRR0, SPRN_MCSRR1)
=20
-/*
- * Guest Doorbell -- this is a bit odd in that uses GSRR0/1 despite
- * being delivered to the host.  This exception can only happen
- * inside a KVM guest -- so we just handle up to the DO_KVM rather
- * than try to fit this into one of the existing prolog macros.
- */
-#define GUEST_DOORBELL_EXCEPTION \
-	START_EXCEPTION(GuestDoorbell);					     \
-	mtspr	SPRN_SPRG_WSCRATCH0, r10;	/* save one register */	     \
-	mfspr	r10, SPRN_SPRG_THREAD;					     \
-	stw	r11, THREAD_NORMSAVE(0)(r10);				     \
-	mfspr	r11, SPRN_SRR1;		                                     \
-	stw	r13, THREAD_NORMSAVE(2)(r10);				     \
-	mfcr	r13;			/* save CR in r13 for now	   */\
-	DO_KVM	BOOKE_INTERRUPT_GUEST_DBELL SPRN_GSRR1;			     \
-	trap
-
 /*
  * Exception vectors.
  */

