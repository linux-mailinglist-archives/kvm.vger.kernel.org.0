Return-Path: <kvm+bounces-69958-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UKOlFohAgWl6FAMAu9opvQ
	(envelope-from <kvm+bounces-69958-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 01:25:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E62D3D2F3C
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 01:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AC8F7301E9A8
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 00:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1B21B4F1F;
	Tue,  3 Feb 2026 00:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="fHO3w0XQ"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob02.noc.sony.co.jp (jpms-ob02.noc.sony.co.jp [211.125.140.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CF62F872;
	Tue,  3 Feb 2026 00:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770078305; cv=none; b=nR7nuBhlWuwns7ERxDwuz5/6CNdRctCfiYXvyXidHQxvXeQk6ReMAujGc/sK2Xdb/Qze+Pijn2spSSzmuCkswUtRlErwvP0KQiwqmjpamRyCPHXdD6DVhXhSla9YUPjZseO0szeSnK7BndgjKhCO5+qcbApF0rh5xxJeYI4LyFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770078305; c=relaxed/simple;
	bh=BntylBVVgecoypzFquKfaO5D5v56DcVhmxm/iNQxf4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/nIazeC5S1C/XDvdisLDZLExqNgtBiiJbuf6Kk1JO7H1jQkm9kp4KpuxJjFUzSUjOdKS0HK2kZbfch6IfvwjbYKPijqR1muG6n3Jbkf86jJECgnxmAoGyFnomJ7/pleWrMDveT1fyfpwyhyR9W4SlaeH0ngWWmJ0NgWQfmwDo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=fHO3w0XQ; arc=none smtp.client-ip=211.125.140.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1770078304; x=1801614304;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+mESz147mY99AmYLlTyE/1U+z38Cj71ObLjn1oYbbso=;
  b=fHO3w0XQoI2WqF5YgUqMWB6VZaa9/Q4IyTO664iYoU3Wv6rkTfcG/qph
   7KHt9QrDJHUAQyH1CscG11pVElrEWVAQY2swJNooFFtOQmu3PYDsd/c7M
   XYpNsXh+CHmYy2mQ3N+SqtbQlim7rXCCIMvKVHxDv35QALZjG3HgUBhYd
   RjAD/tcdq9Tb07xnD1ocB9HvUkZAh+KMYFPrN5d2v22vOBVZyasbsDH3N
   7tdXESbiPT4ikX34kGM+9T7tV2GnqxIlw07DJ3NBJX90rQx+b/nBKkvTQ
   ugUnPryVOIizL6CNWWCZWToWLu62aprcG7U2xO/BE+3IfYmGfGR6XR/mh
   g==;
Received: from unknown (HELO jpmta-ob1.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::6])
  by jpms-ob02.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 09:25:02 +0900
X-IronPort-AV: E=Sophos;i="6.21,269,1763391600"; 
   d="scan'208";a="607577797"
Received: from unknown (HELO JPC00244420) ([IPv6:2001:cf8:1:573:0:dddd:6b3e:119e])
  by jpmta-ob1.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 09:25:02 +0900
Date: Tue, 3 Feb 2026 09:24:56 +0900
From: Shashank Balaji <shashank.mahadasyam@sony.com>
To: kernel test robot <lkp@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	jailhouse-dev@googlegroups.com, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, Rahul Bukte <rahul.bukte@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Tim Bird <tim.bird@sony.com>
Subject: Re: [PATCH 1/3] x86/x2apic: disable x2apic on resume if the kernel
 expects so
Message-ID: <aYFAWPRTx7RqZn32@JPC00244420>
References: <20260202-x2apic-fix-v1-1-71c8f488a88b@sony.com>
 <202602030600.jFhsJyEC-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202602030600.jFhsJyEC-lkp@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69958-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	DKIM_TRACE(0.00)[sony.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shashank.mahadasyam@sony.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,sony.com:dkim,01.org:url]
X-Rspamd-Queue-Id: E62D3D2F3C
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 06:31:40AM +0800, kernel test robot wrote:
> Hi Shashank,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on 18f7fcd5e69a04df57b563360b88be72471d6b62]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Shashank-Balaji/x86-x2apic-disable-x2apic-on-resume-if-the-kernel-expects-so/20260202-181147
> base:   18f7fcd5e69a04df57b563360b88be72471d6b62
> patch link:    https://lore.kernel.org/r/20260202-x2apic-fix-v1-1-71c8f488a88b%40sony.com
> patch subject: [PATCH 1/3] x86/x2apic: disable x2apic on resume if the kernel expects so
> config: i386-randconfig-001-20260202 (https://download.01.org/0day-ci/archive/20260203/202602030600.jFhsJyEC-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260203/202602030600.jFhsJyEC-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202602030600.jFhsJyEC-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> arch/x86/kernel/apic/apic.c:2463:3: error: call to undeclared function '__x2apic_disable'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     2463 |                 __x2apic_disable();
>          |                 ^
>    arch/x86/kernel/apic/apic.c:2463:3: note: did you mean '__x2apic_enable'?
>    arch/x86/kernel/apic/apic.c:1896:20: note: '__x2apic_enable' declared here
>     1896 | static inline void __x2apic_enable(void) { }
>          |                    ^
>    1 error generated.

This happens when CONFIG_X86_X2APIC is disabled. This patch fixes it,
which I'll include in v2:

diff --git i/arch/x86/kernel/apic/apic.c w/arch/x86/kernel/apic/apic.c
index 8820b631f8a2..06cce23b89c1 100644
--- i/arch/x86/kernel/apic/apic.c
+++ w/arch/x86/kernel/apic/apic.c
@@ -1894,6 +1894,7 @@ void __init check_x2apic(void)

 static inline void try_to_enable_x2apic(int remap_mode) { }
 static inline void __x2apic_enable(void) { }
+static inline void __x2apic_disable(void) {}
 #endif /* !CONFIG_X86_X2APIC */

 void __init enable_IR_x2apic(void)

