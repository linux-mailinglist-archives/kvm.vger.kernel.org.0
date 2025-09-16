Return-Path: <kvm+bounces-57721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB76B59726
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:14:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EB06320669
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 13:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B1E29ACEE;
	Tue, 16 Sep 2025 13:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="gmjf/lXN"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579132DC32C;
	Tue, 16 Sep 2025 13:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758028379; cv=none; b=CBMkfvA+fHTy0csEHT7QbuOLpa4Sa1o5nwo/lCQGhzC+/F3axBYFHLa4DnRG+aQmJSdpy+P1YfFPUH3TbBJS5cGC9Ut/fuUjx5xuOusj+qnS0sTsXWCa59C2IU+6fwbV//AOP3caSZ5JIJ7Rt9dNtr98RFjrwlUisBvFSJuOv5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758028379; c=relaxed/simple;
	bh=ik/Ise1iswo7LmVkd0oG8YoqIncJ668v/g3g8ti6nAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ekzN1S1bl/rGFrsOdr7g6DlfS808jh22/qyTPUzajUYqO86ZcJsiogE1ccLB5N9Ob7o+1AqMrMe/4yG1HNhA56UGnRB+IVMXytLUYp/ahLyr06Ee5HvfeWNczkLsf4Nl0b4obHV+iiFqZrawgvX63efZdnNweHKRUPluZi6npzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=gmjf/lXN reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5ACC740E01A2;
	Tue, 16 Sep 2025 13:12:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ttVk2Mn4Jhig; Tue, 16 Sep 2025 13:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1758028368; bh=NnBsyV+YEsnQMd6sc1QNEhxEPfHuUEo9ekvsKqyRBYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gmjf/lXNIcIJDLPQtdWfx1fRSmvkzzEwQ8vP/zezZ0107I0vRCVnG8vzblIbimzMR
	 X8ETN1ek9FNo+qVkh+/2kent5aIyRKV/zWvBbCrNCBDoB1AXeGBkOIlpUivWdiRLXj
	 iUP+ygZFwUqH5m9N4GvEUDckKHUleCf6g7oaOUN6gmKJSrxOI9YeLtPZBZvl6j/EX6
	 yNJtQXvYC84ewbNYlQYYrU1d0VptsrTwFY9MRkbqFBzPYcmbcX8cvfm8ssVzo1k7BK
	 RykS64aDoG7iOgzYnx4AbOpH7vos50ko+AmHylvqYhjmM6iEqTlvh/B29arKI4r8gu
	 Wqk2frZPZ1r0Wru0/phS3SK5BpjpaRerTe8cGME0SVAyfFxg44RbdZu8O3lB4TLQe5
	 idvZGgm4/qG6c1RzzI7Ut2C7gX0/INOEnYVQhs7MSsv7ICThwyxa4lXvtWVyrqLUW8
	 YffMmMXAVKXLfk7e7fOFb4p5LEAvEKi10B+cZz7Tpcwrhl3ko4vgmPgeb2fkwzhEiP
	 0MaTLQ2cBd6+uVUfY66JBtSf/ezJEqLFQb78Mk0BBQ/yHE6hgSupPxKmCUmllpJJza
	 RRQU/O1S0Tbod9G5uXfYCvXO2jcypjQIDUaUAiVuU+os+ZfYfLdSMJ/LEZS9b4YatR
	 2sAel0TbLh/0/kKOVDBUSZjk=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 3E68F40E00DD;
	Tue, 16 Sep 2025 13:12:28 +0000 (UTC)
Date: Tue, 16 Sep 2025 15:12:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, nikunj@amd.com, davem@davemloft.net,
	aik@amd.com, ardb@kernel.org, john.allen@amd.com,
	michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
Message-ID: <20250916131221.GCaMliNe3NVmOwzHEN@fat_crate.local>
References: <cover.1757969371.git.ashish.kalra@amd.com>
 <18ddcc5f41fb718820cf6324dc0f1ace2df683aa.1757969371.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <18ddcc5f41fb718820cf6324dc0f1ace2df683aa.1757969371.git.ashish.kalra@amd.com>
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 09:21:58PM +0000, Ashish Kalra wrote:
> @@ -668,6 +673,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa=
, enum pg_level level, u32 as
>  	return -ENODEV;
>  }
>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { retu=
rn -ENODEV; }
> +static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool=
 dump_rmp) {}
>  static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}

I basically don't even have to build your patch to see that this can't bu=
ild.
See below.

When your patch touches code behind different CONFIG_ items, you must mak=
e
sure it builds with both settings of each CONFIG_ item.

In file included from arch/x86/boot/startup/gdt_idt.c:9:
./arch/x86/include/asm/sev.h:679:20: error: redefinition of =E2=80=98snp_=
leak_pages=E2=80=99
  679 | static inline void snp_leak_pages(u64 pfn, unsigned int pages)
      |                    ^~~~~~~~~~~~~~
./arch/x86/include/asm/sev.h:673:20: note: previous definition of =E2=80=98=
snp_leak_pages=E2=80=99 with type =E2=80=98void(u64,  unsigned int)=E2=80=
=99 {aka =E2=80=98void(long long unsigned int,  unsigned int)=E2=80=99}
  673 | static inline void snp_leak_pages(u64 pfn, unsigned int npages) {=
}
      |                    ^~~~~~~~~~~~~~
make[4]: *** [scripts/Makefile.build:287: arch/x86/boot/startup/gdt_idt.o=
] Error 1
make[3]: *** [scripts/Makefile.build:556: arch/x86/boot/startup] Error 2
make[2]: *** [scripts/Makefile.build:556: arch/x86] Error 2
make[2]: *** Waiting for unfinished jobs....
In file included from drivers/iommu/amd/init.c:32:
./arch/x86/include/asm/sev.h:679:20: error: redefinition of =E2=80=98snp_=
leak_pages=E2=80=99
  679 | static inline void snp_leak_pages(u64 pfn, unsigned int pages)
      |                    ^~~~~~~~~~~~~~
./arch/x86/include/asm/sev.h:673:20: note: previous definition of =E2=80=98=
snp_leak_pages=E2=80=99 with type =E2=80=98void(u64,  unsigned int)=E2=80=
=99 {aka =E2=80=98void(long long unsigned int,  unsigned int)=E2=80=99}
  673 | static inline void snp_leak_pages(u64 pfn, unsigned int npages) {=
}
      |                    ^~~~~~~~~~~~~~
make[5]: *** [scripts/Makefile.build:287: drivers/iommu/amd/init.o] Error=
 1
make[4]: *** [scripts/Makefile.build:556: drivers/iommu/amd] Error 2
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [scripts/Makefile.build:556: drivers/iommu] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:556: drivers] Error 2
make[1]: *** [/mnt/kernel/kernel/linux/Makefile:2011: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

