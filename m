Return-Path: <kvm+bounces-61470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB7DC1F0D8
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 09:47:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EE1AD4EA4E5
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 08:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D6CF30C636;
	Thu, 30 Oct 2025 08:45:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from Atcsqr.andestech.com (60-248-80-70.hinet-ip.hinet.net [60.248.80.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C561B2EAB8D
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 08:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.248.80.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761813910; cv=none; b=EphYtSFxpfWqFK03Ve+v3/mQtXdnb5r3ZgOOqSIrRyE8yHTVKAw/wPp6GCLrYd7/+t6OSOu0QY0MDI9b/ScoWAl7EK16mC/e/BUxmvfNzv5GijHTFBxud+7imUbE4SFR8yoBhnljrgXMbA8sO86K8kVfAktW+DoKBNI56sCJLo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761813910; c=relaxed/simple;
	bh=dDyVShFKKx2f2vVwijS5AYePbVsj8lnQ7TDJ2r9dOdY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/5G5gHL2XpjVGFFp7CX5ZhVDBoeJrK19WKzlKxqVlIACXPtTEH9T/Nl9EoIPqyNHcKQSZTioqJZEGHPCXPaZIRcPZrPug9P7f6i602/Vj5VqXNSGp6drDKiQNYWzDs2vbDm1B6+zEqPZD+bGPR39cObjt2e3lsYNvjL3Rklpb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com; spf=pass smtp.mailfrom=andestech.com; arc=none smtp.client-ip=60.248.80.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andestech.com
Received: from mail.andestech.com (ATCPCS34.andestech.com [10.0.1.134])
	by Atcsqr.andestech.com with ESMTPS id 59U8j0Ca025288
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
	Thu, 30 Oct 2025 16:45:00 +0800 (+08)
	(envelope-from minachou@andestech.com)
Received: from atcsi01.andestech.com (10.0.15.32) by ATCPCS34.andestech.com
 (10.0.1.134) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 30 Oct
 2025 16:45:00 +0800
Date: Thu, 30 Oct 2025 16:44:56 +0800
From: Mina Chou <minachou@andestech.com>
To: Anup Patel <apatel@ventanamicro.com>
CC: <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <tim609@andestech.com>, <ben717@andestech.com>, <az70021@gmail.com>
Subject: Re: [PATCH v2] RISC-V: KVM: flush VS-stage TLB after VCPU migration
 to prevent stale entries
Message-ID: <aQMliHDRpejqwOro@atcsi01.andestech.com>
References: <20251021083105.4029305-1-minachou@andestech.com>
 <CAK9=C2XjygELuUnQErbpVzh6-4wc4HHypf91aKUtUzMYGJwmtw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK9=C2XjygELuUnQErbpVzh6-4wc4HHypf91aKUtUzMYGJwmtw@mail.gmail.com>
User-Agent: Mutt/2.1.4 (2021-12-11)
X-ClientProxiedBy: ATCPCS33.andestech.com (10.0.1.100) To
 ATCPCS34.andestech.com (10.0.1.134)
X-DKIM-Results: atcpcs34.andestech.com; dkim=none;
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:Atcsqr.andestech.com 59U8j0Ca025288

Hi Anup,

> 
> Here's what the non-normative text says about HFENCE.GVMA ...
> 
> "Conceptually, an implementation might contain two address-translation
> caches: one that
> maps guest virtual addresses to guest physical addresses, and another
> that maps guest
> physical addresses to supervisor physical addresses. HFENCE.GVMA need
> not flush the
> former cache, but it must flush entries from the latter cache that
> match the HFENCE.GVMA???s
> address and VMID arguments."
> "More commonly, implementations contain address-translation caches
> that map guest virtual
> addresses directly to supervisor physical addresses, removing a level
> of indirection. For such
> implementations, any entry whose guest virtual address maps to a guest
> physical address that
> matches the HFENCE.GVMA???s address and VMID arguments must be flushed.
> Selectively
> flushing entries in this fashion requires tagging them with the guest
> physical address, which is
> costly, and so a common technique is to flush all entries that match
> the HFENCE.GVMA???s
> VMID argument, regardless of the address argument."
> 
> This means ...
> 
> For implementations (most common) which have TLBs caching
> guest virtual address to supervisor physical address, the
> kvm_riscv_local_hfence_gvma_vmid_all() is sufficient upon
> VCPU migrating to a different host CPU.
> 
> For implementations (relatively uncommon) which have TLBs
> caching guest virtual address to guest physical address, the
> HFENCE.GVMA will not touch guest virtual address to guest
> physical address mapping and KVM must explicitly sanitize
> VS-stage mappings using HFENCE.VVMA (like this patch)
> when migrating VCPU to a different host CPU.
> 
> We should not penalize all implementations by explicitly calling
> kvm_riscv_local_hfence_vvma_all()  rather this should be only
> done on implementations where it is required using a static jump.
> One possible way of detecting whether the underlying implementation
> needs explicit HFENCE.VVMA upon VCPU is to use marchid,
> mimpid, and mvendorid. Another way is to use implementation
> specific CPU compatible strings.
> 
> Regards,
> Anup
> 
> 
> 

Thanks for the detailed explanation! Our implementation does require the
extra hfence.vvma, so we'll add a check to make sure it only runs on
the platforms that actually need it.

Thanks again for your feedback.

Best regards,
Mina

