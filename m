Return-Path: <kvm+bounces-68559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FCB6D3C130
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 08:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 86E054428C1
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 07:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44E43B8BDA;
	Tue, 20 Jan 2026 07:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="Oq3G10X1"
X-Original-To: kvm@vger.kernel.org
Received: from out28-101.mail.aliyun.com (out28-101.mail.aliyun.com [115.124.28.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E863B530B;
	Tue, 20 Jan 2026 07:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768895715; cv=none; b=aZzgTrxSqEhgpp7MxrYwdkVEJqLH7cuamxJfDmRIb6HWCTSefY77C6YLg0m1wJ5JcfaWFspKlzYla30cUbfQOaucem9N+/9Vp/Y/xfI3mSAOm1bNVpLq8RnU4EtFPCR0VOYF40gN06K6InQxEsibUv05I97rzM0jjFbM+NIvN1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768895715; c=relaxed/simple;
	bh=2ekVgjWfH/AsWv7REPqcE3vg44dQfi/IXR4Yf1HWf3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Euem3ZIK5udlKt3wy6RfHMbmDRzAx4GvNUyTMPV4le3h7xrraGgUSTER65hRtyZJYzrD5eDpftoQUnpjcIwyxDYbA4Ixc8h2RVoXhQYHpGWUbJnSGEjnPQ7WzH5qKUUq6esy1eBxHaatN732YYXXfg0uXFbTsNtk4m8v2VfXtNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=Oq3G10X1; arc=none smtp.client-ip=115.124.28.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1768895708; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=DR7Rbxu7fFj/VSsyrXMKreBjbgZsM4uK/wXVjs/Jb5s=;
	b=Oq3G10X1y0JKSiXevnPPZWRyL94WPFNdrFfVnkXyR9iGwIfxQiqHDijcewQ8xHv+BpMFilznx/lT5xkNrHeMIG2ZOINnTkk0lI+lDLS92HMZ41C6d1M41QTwKnEFaicCD0/BRRs9itWuKLw+bhM38417EgRwt9ZhkWTHSiuvYBU=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.gAyIShv_1768895707 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 20 Jan 2026 15:55:07 +0800
Date: Tue, 20 Jan 2026 15:55:07 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH RESEND v2] x86/xen/pvh: Enable PAE mode for 32-bit guest
 only when CONFIG_X86_PAE is set
Message-ID: <20260120075507.GA2071@k08j02272.eu95sqa>
References: <d09ce9a134eb9cbc16928a5b316969f8ba606b81.1768017442.git.houwenlong.hwl@antgroup.com>
 <20260120073927.GA119722@k08j02272.eu95sqa>
 <409f5119-7dc1-4f45-a099-281db82254f3@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <409f5119-7dc1-4f45-a099-281db82254f3@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jan 20, 2026 at 08:48:43AM +0100, Jürgen Groß wrote:
> On 20.01.26 08:39, Hou Wenlong wrote:
> >+kvm, I'm not sure whether it is needed.
> 
> I have queued it in the Xen tree for the next merge window.
>
Thanks for the notification.
 
> 
> Juergen
> 
> >
> >On Sat, Jan 10, 2026 at 12:00:08PM +0800, Hou Wenlong wrote:
> >>The PVH entry is available for 32-bit KVM guests, and 32-bit KVM guests
> >>do not depend on CONFIG_X86_PAE. However, mk_early_pgtbl_32() builds
> >>different pagetables depending on whether CONFIG_X86_PAE is set.
> >>Therefore, enabling PAE mode for 32-bit KVM guests without
> >>CONFIG_X86_PAE being set would result in a boot failure during CR3
> >>loading.
> >>
> >>Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> >>Reviewed-by: Juergen Gross <jgross@suse.com>
> >>---
> >>I resend this because I encountered the 32-bit KVM guest PVH booting failure again. I
> >>hope this can be fixed.
> >>original v2:
> >>https://lore.kernel.org/all/0469c27833be58aa66471920aa77922489d86c63.1713873613.git.houwenlong.hwl@antgroup.com
> >>---
> >>  arch/x86/platform/pvh/head.S | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >>diff --git a/arch/x86/platform/pvh/head.S b/arch/x86/platform/pvh/head.S
> >>index 344030c1a81d..53ee2d53fcf8 100644
> >>--- a/arch/x86/platform/pvh/head.S
> >>+++ b/arch/x86/platform/pvh/head.S
> >>@@ -91,10 +91,12 @@ SYM_CODE_START(pvh_start_xen)
> >>  	leal rva(early_stack_end)(%ebp), %esp
> >>+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
> >>  	/* Enable PAE mode. */
> >>  	mov %cr4, %eax
> >>  	orl $X86_CR4_PAE, %eax
> >>  	mov %eax, %cr4
> >>+#endif
> >>  #ifdef CONFIG_X86_64
> >>  	/* Enable Long mode. */
> >>
> >>base-commit: b7dccac786071bba98b0d834c517fd44a22c50f9
> >>prerequisite-patch-id: 590fa7e96c6bb8e0b9d15017cfa5ce1eb314957a
> >>-- 
> >>2.31.1
> >>
> >>
> 

> pub  2048R/28BF132F 2014-06-02 Juergen Gross <jg@pfupf.net>
> uid                            Juergen Gross <jgross@suse.com>
> uid                            Juergen Gross <jgross@novell.com>
> uid                            Juergen Gross <jgross@suse.de>
> sub  2048R/16375B53 2014-06-02





