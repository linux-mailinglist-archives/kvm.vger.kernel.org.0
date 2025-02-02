Return-Path: <kvm+bounces-37085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60038A25020
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 22:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF2C9162893
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 21:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9105C2147F6;
	Sun,  2 Feb 2025 21:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b="lNI4wnLn"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E15C1581F9;
	Sun,  2 Feb 2025 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738532072; cv=none; b=JMkQXVCIIaxe+MPj1VK1E5tO4dgOLSXB05rU93VyXpNWxB8VSQ5DWinCke6UnpJIwmyXKScSWVwKXBHow5vF2FPb99xvctcrDGXv9i1iWgUK/PcdfTvvNIDkPOT2pnF8wb1XJxKzN/3HXbmNxU0W8IUnYao/uq5OiD+6Y6vk1Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738532072; c=relaxed/simple;
	bh=4hvX3V+SUJqChF35x8aAIao5Jeu/dWFA1HRIIuZm9jU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HepBznRg9r4J/XI4A3cszGboL4dtvaE7nLLjiZ+vwJGT9IDskjE1+6PbK+ix5OsEsCqsrRForimwi/hcmqoYg6xZJfGCaNxkWtdw/BGAKYurKwtI9OucaRuJGC1yjWarBB+xaJo4wqnxi4UMiWamvYy7lnEQwIEPRrClUpOnJOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b=lNI4wnLn; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1738532026; x=1739136826; i=j.neuschaefer@gmx.net;
	bh=G2eHfhQuejodnDOibyT663weFQ71Yl8E8QZl/5oxVv0=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=lNI4wnLn373mkDHyreS/4go2WqLLFqysiF0LW3XiW1x/TglUrcPjkWZnauK8Ui1R
	 XU0ggv4mZdMXv3WIM/qA8OqL7HzNFmRqsXPGeFv9qLqrDmBT9CieOrZXNo3TRsVwk
	 5M5fmis0I0ZqKFicCRUGYCSGRY00DySlih9CvpHUYhrtW0TI+4+LHWAK3xKKq9uiR
	 AF9sgaalNQduw0ptfF6P0GLSwGBTtZ2Sbnp0wUl9NT0xaO+o63RoPV2h2xRaj9KRH
	 T47MTCEDaWQ9lzGI6z2ONFo/9+tBc9+MSvoR7Cu76PREt+9/X+8/eolBYqU9OY5tI
	 ME/oP5Cwa5qXcTCPKA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([89.1.210.218]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MAfYw-1tlHAA11D6-007KTC; Sun, 02
 Feb 2025 22:33:46 +0100
Date: Sun, 2 Feb 2025 22:33:36 +0100
From: =?utf-8?Q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: "A. Wilcox" <AWilcox@wilcox-tech.com>
Cc: Arnd Bergmann <arnd@kernel.org>, kvm@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Graf <graf@amazon.com>, Crystal Wood <crwood@redhat.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
	Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 4/5] powerpc: kvm: drop 32-bit book3s
Message-ID: <Z5_ksID8Gv_Tg5F7@probook>
References: <20241221214223.3046298-1-arnd@kernel.org>
 <20241221214223.3046298-5-arnd@kernel.org>
 <9B9E07F0-3373-4F59-BE4C-E6C425B3C36D@Wilcox-Tech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <9B9E07F0-3373-4F59-BE4C-E6C425B3C36D@Wilcox-Tech.com>
X-Provags-ID: V03:K1:9/xKYk+mj967yFEydW37x3unDxvlzZDdriScJwSUFGFBVPwz408
 R4O7IVTtnXePPO+gVIX8jktVCSK3SLk5KSpqblHo9ocA7Uo1TTIFaSqN1IJ0B/nSnHdz+v4
 BQJUDyiTjBjastoDpF/hhIklw774C2Nk4pN/wxnwAA2nZ2/XzPYAWN671OjQUfPE/hjZF1w
 siMMlhFzAtG6iMd99XMIg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:lvJI8XggPhM=;4W9A0Oo2CZWjUIca1pWrNgsKvKX
 z8V5mRgOrYvpaHbx85mspd7QV2ItcjEq+fbuEkib8xY69HipoOK+VJcOAfiLKjAnQJa/cEWvo
 CyiUn1zvL9+XgfNLjZDQvyYLO0OegTg5uO6ds6wuAoImA3OZR02zmCDlQoBOZ9Os/C7ncaKHX
 70bHqXPyIx5rnA5PX8W9/Gx/G2VS6JmbZloyyR+qYGwoXMa82ikMXsHgpXshd/zLqq4sSRHoV
 brXeZgfYB3/4Q/i8lba34oeUVPvRB47g7yr3WhGmhykJVM3QHf5w+IWCNM4T4JwjPSqcbUnBy
 pW5753Wdt1o3+XSulwpYV+SF3ehRAAk8zx7oc1eskQUwPEFPv3oL1tNRzd7KDJ7QGTMXKcMRR
 yJQnkoyomns15uYcWXEWc4eJ0Q3nqODjrT7/oPRM6PfF1axZPTcN9Ivt/coi8oAHzidpeZRw0
 1Nj7DtAAuIiIqTiXFnM71/83afL3vQKgrXVDhbGQ1eHgcUKHDNURj8Ov+oopEjNcqjdlWGWoN
 y/06JKYTlBaAC0sx1Fr8k1oOerFxYn2v0A6Nocs597aQ1BLqzSDJUkMmq+p9P2Xm8dVSsGGu4
 +4an3otnMm7ZdorWY7g0UeLINMt1RvZyhf3fM1MuxetqEnqnIxXuoEaAUo/5g5Axxnc7d+90+
 CqQvSZiR32dd7HV8x/oBhj3492A7USPGpPBHD4yhGucmE0EQGVrTjkK8T9VYH8nj9cnnIYytQ
 c78FwW3q6Jv7eRX43bsv6QZUi4Y1zzlJYyE8P/w9Z+DTvFNbOjo4v0JtfT9UWCC2FhaBW9Oqe
 anaWkC6cv6od7SLhWicorQPsOM2UcDiSTAWA1JBBk92fj+U5TadCXASiSa9qQiymc4ZHM3yzO
 lM7OUKempveM0+57H8oZtb5No0NKCLwN9BQw0eLJ5IAWaDGAEIDJxt+ql7gxKacp5U/eU07Qj
 +x4rzmw88GtPCbybRi41JUDTYLunI5I5clPvmpGMh+Q+iArBl4xRCVHV5M51h1gBJZkv85dmD
 aH2sWMqQaEJ7FBWhGUSRu1GLj09VqIO7JAoY2C9TpRmf/ao9g02EJaYOiaCtGJWsPsri7Jq9g
 rHR6DYNhdqLKm2SF8kAE86rpcJ8B0HKl2UyhO/OCxLvlUOemuYGVqW3BDk5RgNpYgKaXWeuiW
 ThzTcYCT9+ztyzdFsFjgwtA56kVcQc7C+VVodKwz9RtObFvhrK1yC2CXdCA+KcPiSnCTKvqes
 2EQX8ZYBWmYwZFGRWQrJtQmcKMRszV78bn8FnLMJ/9/2KEifFR7S9q34teR7+FFb4iUM9FW6x
 3zyl/UGrzimjzwEO+HD7CetGSspTpweqegk7AqIu8he+lY=

On Sat, Dec 21, 2024 at 08:13:12PM -0600, A. Wilcox wrote:
> On Dec 21, 2024, at 3:42=E2=80=AFPM, Arnd Bergmann <arnd@kernel.org> wro=
te:
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > Support for KVM on 32-bit Book III-s implementations was added in 2010
> > and supports PowerMac, CHRP, and embedded platforms using the Freescal=
e G4
> > (mpc74xx), e300 (mpc83xx) and e600 (mpc86xx) CPUs from 2003 to 2009.
> >
> > Earlier 603/604/750 machines might work but would be even more limited
> > by their available memory.
> >
> > The only likely users of KVM on any of these were the final Apple
> > PowerMac/PowerBook/iBook G4 models with 2GB of RAM that were at the hi=
gh
> > end 20 years ago but are just as obsolete as their x86-32 counterparts=
.
> > The code has been orphaned since 2023.
> >
> > There is still a need to support 32-bit guests in order to better
> > debug problems on ppc32 kernels. This should work in theory on both
> > 64-bit booke and on 64-bit book3s hosts, but it would be good to
> > confirm that this is still the case before the known working option
> > gets removed.
[...]
> That said, I would like to keep the support alive for more than just
> ppc32 kernel testing.  There are plenty of Power Macs with enough
> memory to run some environments within KVM.  Ad=C3=A9lie=E2=80=99s new r=
elease
> boots a full XFCE desktop in under 300 MB RAM, so even a 1 GB machine
> has enough memory to run AmigaOS, Mac OS 9, or another XFCE in KVM.

FWIW, I second this. I do intend to get KVM to run on my e300-based
board for some relatively light guests such as Mac OS 9. I suspect I
won't be able to contribute much to the maintenance, though.

Best regards,
J. Neusch=C3=A4fer

