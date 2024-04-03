Return-Path: <kvm+bounces-13456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E041896EC3
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 14:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B59E1B26AA1
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 12:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FFD5146019;
	Wed,  3 Apr 2024 12:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="WKkxqaYc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AF713AA5D;
	Wed,  3 Apr 2024 12:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712146511; cv=none; b=Vbmz+51DTXfFstBrUJPvQ8XszjEclQIuHbyZE344esKBhcNIvxXSF6DZbFxBLO2L8olCpaVZjsGgB7suc54dgbILKwaDnsmZUQjo64OHUwStmUm5sugtbnlptWmQ1cgjTotxp7SKUUeRc1+3DgALjBw+QxcXms0K2FNCMuzjfdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712146511; c=relaxed/simple;
	bh=RPXA2HTkBS2JPIkfJglLsWttEBkHy5eUQCIPyOXEQLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfeQ3PzO7OVeESafBemld387wb2lkzz5PJMw8sbLvXV11iELT7CbwkPsY9855BxoEVrzPnUes30G7Gn565o+upLJ8yhhl4MtxYJUqTqF8lPv3s94yKkhSh2SfKNyJBufb+xpULzuECtPablAMqWjWZ3dbVaz8BuhZQU2St1CVE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=WKkxqaYc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A4B8540E00F4;
	Wed,  3 Apr 2024 12:15:05 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id eg6rn_od8uTx; Wed,  3 Apr 2024 12:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1712146499; bh=E8LB5hiOLH6m1TqgFK0JkkQmVlOzLzpB4oN5tmq5L8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WKkxqaYcGegOg4evRGWi6hoCMxYf2EUBMm1NPk+U5xyvOaVHVbxczHwwZCS6JZYCv
	 kebdRoRwDYZxgaTR63vWGjlapDGY3LKB3aIMoOmdd0O6oumTNE/SrsBCU+Q7E6xMIy
	 B1QAEuVuC7xe0nYTJTLn91untZOE1MX2oIhPZWAcp61beuIphVcdMTfK7zh911HJzt
	 NUkwM147aVNXmbDRt2iwWrVqddPDfVi/Nij540TzIT2HsZkPLfWKUNQwDoWfK1dUs9
	 XinY6zYa/BGMX5p+IpWxPpVd5/Vz4vkXFC/9vPqNeY3Nyu7EvwDE4psET0KKrYVrdj
	 YdP2N+x1V62egZgw9jvT+IZs9lzFYhwJ7+SdimBZRb8WTZDqioakSfFQUG1RRlkKPp
	 l9cMYmAMM30BPn1b9grDciPEPCHQIvYUhN3yXqtFIIiLGz010ezKqLQ+MNf8JFx0uN
	 RURBUBTEPn69lNKiQTBDoLN8HDycNB/oJrha6BpryaCX7lc+KUTLsCSHmQsE2chxAY
	 iokuozLXIv9FcpfDvYkz02CEo4QpTs85M/IAFcRk/MlUL1b6zj4asXHQxmv2Uo7DnW
	 kQ+VqFuSlYLfik540DGZvsqufNNK29ob+Qmrk8stIMnsZXxcKr/lVpht8ZWNSXBdm2
	 tnNOb0H/+MNV9vm5HeDf03EE=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1C71740E0177;
	Wed,  3 Apr 2024 12:14:37 +0000 (UTC)
Date: Wed, 3 Apr 2024 14:14:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: bp@kernel.org, bgardon@google.com, dave.hansen@linux.intel.com,
	dmatlack@google.com, hpa@zytor.com, jpoimboe@kernel.org,
	kvm@vger.kernel.org, leitao@debian.org,
	linux-kernel@vger.kernel.org, maz@kernel.org, mingo@redhat.com,
	mirsad.todorovac@alu.unizg.hr, pawan.kumar.gupta@linux.intel.com,
	pbonzini@redhat.com, peterz@infradead.org, seanjc@google.com,
	shahuang@redhat.com, tabba@google.com, tglx@linutronix.de,
	x86@kernel.org
Subject: Re: [BUG net-next] arch/x86/kernel/cpu/bugs.c:2935: "Unpatched
 return thunk in use. This should not happen!" [STACKTRACE]
Message-ID: <20240403121436.GDZg1ILCn0a4Ddif3g@fat_crate.local>
References: <1d10cd73-2ae7-42d5-a318-2f9facc42bbe@alu.unizg.hr>
 <20240318202124.GCZfiiRGVV0angYI9j@fat_crate.local>
 <12619bd4-9e9e-4883-8706-55d050a4d11a@alu.unizg.hr>
 <20240326101642.GAZgKgisKXLvggu8Cz@fat_crate.local>
 <8fc784c2-2aad-4d1d-ba0f-e5ab69d28ec5@alu.unizg.hr>
 <20240328123830.dma3nnmmlb7r52ic@amd.com>
 <20240402101549.5166-1-bp@kernel.org>
 <20240402133856.dtzinbbudsu7rg7d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240402133856.dtzinbbudsu7rg7d@amd.com>

On Tue, Apr 02, 2024 at 08:38:56AM -0500, Michael Roth wrote:
> On Tue, Apr 02, 2024 at 12:15:49PM +0200, bp@kernel.org wrote:
> > From: Borislav Petkov <bp@alien8.de>
> > 
> > Sorry if this comes out weird - mail troubles currently.
> > 
> > On Thu, Mar 28, 2024 at 07:38:30AM -0500, Michael Roth wrote:
> > > I'm seeing it pretty consistently on kvm/next as well. Not sure if
> > > there's anything special about my config but starting a fairly basic
> > > SVM guest seems to be enough to trigger it for me on the first
> > > invocation of svm_vcpu_run().
> > 
> > Hmm, can you share your config and what exactly you're doing?
> > 
> > I can't reproduce with Mirsad's reproducer, probably because of .config
> > differences. I tried making all CONFIG*KVM* options =y but no
> > difference.
> 
> I've reproduced against tip/master from today and attached the host
> config I used.
> 
> I can reproduce with a normal SVM guest using the following cmdline,
> but I don't think there's anything particular special regarding what
> QEMU options you use. It seems to trigger on the very first entry into
> VMRUN path:
> 
>   /home/mroth/qemu-build-snp-v4-wip2/qemu-system-x86_64
>     -smp 32,maxcpus=255 -cpu EPYC-Milan-v2 -overcommit cpu-pm=off
>     -enable-kvm -m 4G,slots=5,maxmem=210G -vga std -nographic
>     -machine pc,memory-backend=ram1
>     -object memory-backend-memfd,id=ram1,size=4G,share=true,prealloc=false,reserve=false
>     -device virtio-scsi-pci,id=scsi0,disable-legacy=on,iommu_platform=true
>     -drive file=/home/mroth/ubuntu-18.04-seves2.qcow2,if=none,id=drive0,snapshot=on
>     -device scsi-hd,id=hd0,drive=drive0,bus=scsi0.0
>     -device virtio-net-pci,mac=52:54:00:6c:3c:01,netdev=netdev0,id=net0,disable-legacy=on,iommu_platform=true,romfile=
>     -netdev tap,script=/home/mroth/qemu-ifup,id=netdev0
>     -L /home/mroth/AMDSEV/snp-release-2024-02-22/usr/local/share/qemu
>     -msg timestamp=on
>     -drive if=pflash,format=raw,unit=0,file=/home/mroth/AMDSEV/snp-release-2024-02-22/usr/local/share/qemu/OVMF_CODE.fd,readonly=on
>     -drive if=pflash,format=raw,unit=1,file=/home/mroth/AMDSEV/snp-release-2024-02-22/usr/local/share/qemu/OVMF_VARS.fd
> 
> I can also trigger using one of the more basic KVM selftests:
> 
>   make INSTALL_HDR_PATH="$headers_dir" headers_install
>   make -C tools/testing/selftests TARGETS="kvm" EXTRA_CFLAGS="-DDEBUG -I$headers_dir"
>   sudo tools/testing/selftests/kvm/userspace_io_test

Ok, thanks, that helped.

Problem is:

7f4b5cde2409 ("kvm: Disable objtool frame pointer checking for vmenter.S")

it is disabling checking of the arch/x86/kvm/svm/vmenter.S by objtool
when CONFIG_FRAME_POINTER=y but that also leads to objtool *not*
generating .return_sites and the return thunk remains unpatched.

I think we need to say: ignore frame pointer checking but still generate
.return_sites.

Josh, ideas?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

