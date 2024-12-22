Return-Path: <kvm+bounces-34324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA3A09FA8A9
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 00:26:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CB6F1885F49
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 23:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67E21957F4;
	Sun, 22 Dec 2024 23:25:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C56F07DA8C;
	Sun, 22 Dec 2024 23:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734909952; cv=none; b=YYhYsKnwH6WDcT495mzWWY2fiE2pMaD0UQkQ9YjKil7rXgqld0nTQ1/HPSDGUKNnEM+O0LyLhS/7RX1A7hJZ3Jl/Jun4xHXCbN2Am89C2aAlBaUY+iKiM9vLEx2jynnVMjolOw3KuoK/YxX1A4jZcnGAxSMGKE2ohhlc5M+IAbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734909952; c=relaxed/simple;
	bh=cYJm52fOi7VdT2pC9KcmwbCAbS1huo+9NeEG1VVSayM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EjyF9zC0DsLtt9/hN5f8OS22ST2tdCcopsuCt/BBGh3Eb26Ue8As3nqwTMIZqKwIkcD60J6IUaLiee7/ILOnJtKeb9xFEorXsb7hlWxCZhW46CMavL2QHm5ut5uieuBn9WD7QGjxfM8xzjvbaCqqPk8ht5CJsdBqOiM908qH53I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 4BMMNW3F022029;
	Sun, 22 Dec 2024 16:23:32 -0600
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 4BMMNR4S022013;
	Sun, 22 Dec 2024 16:23:27 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Sun, 22 Dec 2024 16:23:26 -0600
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "A. Wilcox" <AWilcox@wilcox-tech.com>, Arnd Bergmann <arnd@kernel.org>,
        kvm@vger.kernel.org, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Alexander Graf <graf@amazon.com>, Crystal Wood <crwood@redhat.com>,
        Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 4/5] powerpc: kvm: drop 32-bit book3s
Message-ID: <20241222222325.GD20626@gate.crashing.org>
References: <20241221214223.3046298-1-arnd@kernel.org> <20241221214223.3046298-5-arnd@kernel.org> <9B9E07F0-3373-4F59-BE4C-E6C425B3C36D@Wilcox-Tech.com> <6253307c-d3d6-485f-9d01-12787b457a99@app.fastmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6253307c-d3d6-485f-9d01-12787b457a99@app.fastmail.com>
User-Agent: Mutt/1.4.2.3i

On Sun, Dec 22, 2024 at 10:09:14PM +0100, Arnd Bergmann wrote:
> On Sun, Dec 22, 2024, at 03:13, A. Wilcox wrote:
> > On Dec 21, 2024, at 3:42 PM, Arnd Bergmann <arnd@kernel.org> wrote:
> >
> >     R0 .. R7           R8 .. R15         R16 .. R23         R24 .. R31
> > 00000000014a1124   0000000000000000   000000000135b4ac   0000000000000000   
> > 000000000dc70f30   ffffffffc0000000   000000000dc70fa4   000000000173600c   
> > 0000000000000000   000000000e477010   0000000000000000   0000000000400000   
> > ffffffff0141be4c   000000000149ab74   00000000ffffffff   0000000000000008   
> > 00000000c0014b6c   0000000020000402   0000000040400000   00000000016f2000   
> > ffffffff40400000   0000000000000000   0000000000000000   000000000dc70f60   
> > 0000000000000000   0000000000000000   000000000e73d490   000000000149f000   
> > 0000000000000000   000000000e756118   000000000dc70fa0   ffffffff40400000   
> >
> >     CR / XER           LR / CTR          SRR0 / SRR1        DAR / DSISR
> >         80000402   00000000014a1124   00000000014a1128   ffffffff0141be4c   
> > 0000000020040000   0000000000000000   8000000000003000           00000000   
> >
> >
> > 2 > 
> >
> > Which is the same thing that happens if you boot a 32-bit Linux kernel
> > on a physical 64-bit Power machine.  This is probably because KVM is
> > so much more accurate than TCG for Power emulation :)
> 
> Did you ask kvm to emulate a 32-bit platform though? Since the
> register dump shows 64-bit registers, my guess is that this is the
> result of trying to load a 32-bit kernel on "-machine pseries
> -cpu native", which is not supported by the guest kernel. I would
> expect that you need at least a 32-bit machine type (mac99,
> pegasos2) and likely also a 32-bit CPU (7447a, e600).

SLOF always shows 64-bit registers; SLOF only ever runs as 64-bit
program.  The *client* program can be 32-bit of course, but the dump
of SRR1 here shows SF=1 (the top bit there).  No idea what was running
at the time, but something in the kernel I guess?

(To show the last set client state, use
  ciregs .regs
the thing exceptions print is via
  eregs .regs
so you'll probably figure out the format ;-) )

If the client program is a 32-bit ELF file, SLOF starts the client
program with SF=0.


Segher

