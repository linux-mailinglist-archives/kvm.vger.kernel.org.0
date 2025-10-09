Return-Path: <kvm+bounces-59698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27CDEBC8701
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 12:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5585A3C0D9E
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 10:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 496002D8DD9;
	Thu,  9 Oct 2025 10:16:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from Atcsqr.andestech.com (60-248-80-70.hinet-ip.hinet.net [60.248.80.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C130C1CCEE0
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 10:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.248.80.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760004990; cv=none; b=CBNA8RjVUGNcNYlPhCfrs8BqgrXDPr5kXZVK/d9cN51grhSTQ/4zqaKTRMyfl8csqCiwZbHKyrRJfagqamgqI0A9dsCmuLP/guDt9/c8kIFcqv863IrZ207+MoKFKXRBUEryOHE49dFcL/zAJMwGSnRkDVa8PhSw35sLFRCfjn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760004990; c=relaxed/simple;
	bh=ohtR0oYn448oPLiSFOjbSqDaVglh/DTDY7LpHa0tRdE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j66Fjoou7/Z8IyOiNSAAi03/+eadWV1hiv9zz7E0UOreHXFiJO6ers8rjabAaS5TgHJi5KuY8B0b9hXRQPir/yUH885XvsN7dNNR9vEvfR2G1/2Xz7vZd1pVisTv6sEHDNAGzNr7DH/lfoAF4m/FUw39X9lDYkBSjjXzCh0cvgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com; spf=pass smtp.mailfrom=andestech.com; arc=none smtp.client-ip=60.248.80.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andestech.com
Received: from mail.andestech.com (ATCPCS34.andestech.com [10.0.1.134])
	by Atcsqr.andestech.com with ESMTPS id 599AFpSq031528
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
	Thu, 9 Oct 2025 18:15:51 +0800 (+08)
	(envelope-from ben717@andestech.com)
Received: from atctrx.andestech.com (10.0.15.173) by ATCPCS34.andestech.com
 (10.0.1.134) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 9 Oct
 2025 18:15:51 +0800
Date: Thu, 9 Oct 2025 18:15:51 +0800
From: Ben Zong-You Xie <ben717@andestech.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
CC: <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
        <liujingqi@lanxincomputing.com>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tim609@andestech.com>,
        Hui Min Mina Chou
	<minachou@andestech.com>,
        linux-riscv
	<linux-riscv-bounces@lists.infradead.org>
Subject: Re: [PATCH] RISC-V: KVM: flush VS-stage TLB after VCPU migration to
 prevent stale entries
Message-ID: <aOeLVwXW/sF4NBUJ@atctrx.andestech.com>
References: <20251002033402.610651-1-ben717@andestech.com>
 <DDDKX1VNCCVS.2KVYNU4WBEOVI@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DDDKX1VNCCVS.2KVYNU4WBEOVI@ventanamicro.com>
User-Agent: Mutt/2.1.4 (2021-12-11)
X-ClientProxiedBy: ATCPCS33.andestech.com (10.0.1.100) To
 ATCPCS34.andestech.com (10.0.1.134)
X-DKIM-Results: atcpcs34.andestech.com; dkim=none;
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:Atcsqr.andestech.com 599AFpSq031528

Hi Radim,

Thanks for the review and the detailed comments.

> What RISC-V implementation are you using?  (And does the implementation
> have the same memory access performance in V=0 and V=1 modes, even
> though the latter has two levels of TLBs?)
> 

The issue is found when validating our new AndesCore AX66.
The address translation performance is the same for U and VU-mode when the uTLB is hit.

> > To fix this, kvm_riscv_gstage_vmid_sanitize() is extended to flush both
> > G-stage and VS-stage TLBs whenever a VCPU migrates to a different Host CPU.
> > This ensures that no stale VS-stage mappings remain after VCPU migration.
> >
> > Fixes: b79bf2025dbc ("RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sanitize()")
> 
> b79bf2025dbc does not change behavior.
> The bug must have been introduced earlier.
> 

Will fix the incorrect Fixes tag in the next version.
Thanks for pointing that out, we'll change to the following:

    Fixes: 92e450507d56 ("RISC-V: KVM: Cleanup stale TLB entries when host CPU changes")

> > Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
> > Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
> > ---
> > diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> > @@ -146,4 +146,10 @@ void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
> 
> The function is now doing more that sanitizing gstage.
> Maybe we can again call it kvm_riscv_local_tlb_sanitize()?
> 

As for the naming, your suggestion makes sense.
We’re also considering whether it should be moved back from vmid.c to tlb.c,
and we’d like to hear other maintainers’ opinions before doing so.

Thanks again for your feedback.

Best regards,
Ben

