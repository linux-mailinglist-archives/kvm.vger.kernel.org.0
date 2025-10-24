Return-Path: <kvm+bounces-61035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 09942C07598
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 18:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AEA87562EBD
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 16:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594BB26ED2F;
	Fri, 24 Oct 2025 16:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jEuvgC5D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCD16FC3
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 16:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761323746; cv=none; b=B/KxKFW2vu2gEsIzMdBjZj3f3V8zEUKJQjB63ZuyFtYKhHiYlOx0sgnfuRBTu9I2Z97bBav4TEIP2wuGrLbgbnTdeXKlB5dLzI5RRWe0fiBinLZ3lnNYVnbiWmEOH3ehPgk9NVKBQ1wP+yjlXxBEwaWRwC+VRjltD5x3Z/iRdbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761323746; c=relaxed/simple;
	bh=s28pXsj7j48oGy0M5J0TJBpSlcMgbzBpynjpCatcGWM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FTVTHczrrCSpIiSmSbbhAsxxQBq0/o2FYjaruEdxdbUM3F4H/RINi3slhjH8PQRtWfGhHjPfAoRBhuHQltws/ZGIV1XwrTubwNoF1sCNkk4+SLhuuOd3Zbz6pgtTa+zgaZY3sOd4yPgRES7jD6sT0QcYYmi0HxSsS4rkug0mWTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jEuvgC5D; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2909e6471a9so16543945ad.0
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 09:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761323744; x=1761928544; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cu0gmfEAQ+U9vhoL2h/iCeG4Q5kdgS/ChdUsj5vfglQ=;
        b=jEuvgC5DOumwmetbFY+z7K66X/Eo1+upUYDpadKytDeaSvw5YJfu+T18FuGG6btJor
         TIiBH1hG36nFg4jsih92B+w4SD3WBJc9q6o2agMe9m+noUS6UHqH5VE8yz95oY2CnQ2T
         2+/eWb2G+SXNJ92wNneX1xLsfkk3pFW+8dbXJsN+8hvrxUKop6sjP91/sv3DrbAnbflg
         U61rCS81HM0vEPQ7NIArFbIXNUfW/vlNeIYWIlmFu9ELewwWRMMXXYpCQXZ7c9pmzAMI
         2vRIOC4sBD+34s6gcmeIJIAzZyMpwyVuBczpfsdnut0Z6tiGN3/z5HwcwpwEV+ePcpgm
         OLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761323744; x=1761928544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cu0gmfEAQ+U9vhoL2h/iCeG4Q5kdgS/ChdUsj5vfglQ=;
        b=gKRGaXwVlYcCugx/lMnLRqHsHRMQD3hPmyQVM2eO7tvOSYiDtYzipn6iyVmhOzMvO8
         sUAsgIwAqQwQGMDur74RANZzx33+Y2QI/GuIcpsTLy3xqgPs0KF8i3TS95FGx3znDV4n
         CB2a450iJrT7lIsbKchr1ArKaXT7jEn6lQieIzQOhD8aYRj7O/XhxF54/v3KdIXoz2sR
         3VMhi0WlkeANT2bfJVD2NeriVNRrTeDeQcXs+66XtmkESEtcwugAda2/G2ypDt0AkDP6
         Lb496gycaYfbI9HMiAqBySccU1uN5nryDPsxo7/QWaKyLIR028fesDsakQHJWNIv4Lc+
         PFOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpu+IpB767l67uLHO/JcBn2wG3iYNOfGRPHSRmEl/ZPE90q0jFHQb8DB3tCHUVITxS088=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4452US0/EUpwKsjPGeSBqDjhn+DYXmdi+bTtofTXVL5zQ78LG
	cdVXBLHnU1JiJKpqq1zbAx9dN75Icpn6F7EV5WP0oQZEiLDuEgMK2WtTRaKfo7OOSlVYjmlkOHc
	zz4T8ng==
X-Google-Smtp-Source: AGHT+IHEqEX/8GwSPDTtO9R4g/+ZtFO0C94Pe4ULgHF/AbXONvqtNga/vyT3hE3hD5zVd0KE3EnoXL2eWbI=
X-Received: from pjyj8.prod.google.com ([2002:a17:90a:e608:b0:33b:51fe:1a8b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db05:b0:24e:3cf2:2450
 with SMTP id d9443c01a7336-290c9c8a5e6mr368813165ad.2.1761323744332; Fri, 24
 Oct 2025 09:35:44 -0700 (PDT)
Date: Fri, 24 Oct 2025 09:35:43 -0700
In-Reply-To: <442f5488e4a66f6a1517082df3d2ae47316be010.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-15-seanjc@google.com>
 <442f5488e4a66f6a1517082df3d2ae47316be010.camel@intel.com>
Message-ID: <aPuq33-qEJsDhdgG@google.com>
Subject: Re: [PATCH v3 14/25] KVM: TDX: Bug the VM if extended the initial
 measurement fails
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"kas@kernel.org" <kas@kernel.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, 
	"zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, Vishal Annapurve <vannapurve@google.com>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 23, 2025, Kai Huang wrote:
> On Thu, 2025-10-16 at 17:32 -0700, Sean Christopherson wrote:
> > WARN and terminate the VM if TDH_MR_EXTEND fails, as extending the
> > measurement should fail if and only if there is a KVM bug, or if the S-EPT
> > mapping is invalid, and it should be impossible for the S-EPT mappings to
> > be removed between kvm_tdp_mmu_map_private_pfn() and tdh_mr_extend().
> > 
> > Holding slots_lock prevents zaps due to memslot updates,
> > filemap_invalidate_lock() prevents zaps due to guest_memfd PUNCH_HOLE,
> > and all usage of kvm_zap_gfn_range() is mutually exclusive with S-EPT
> > entries that can be used for the initial image.  The call from sev.c is
> > obviously mutually exclusive, TDX disallows KVM_X86_QUIRK_IGNORE_GUEST_PAT
> > so same goes for kvm_noncoherent_dma_assignment_start_or_stop, and while
> > __kvm_set_or_clear_apicv_inhibit() can likely be tripped while building the
> > image, the APIC page has its own non-guest_memfd memslot and so can't be
> > used for the initial image, which means that too is mutually exclusive.
> > 
> > Opportunistically switch to "goto" to jump around the measurement code,
> > partly to make it clear that KVM needs to bail entirely if extending the
> > measurement fails, partly in anticipation of reworking how and when
> > TDH_MEM_PAGE_ADD is done.
> > 
> > Fixes: d789fa6efac9 ("KVM: TDX: Handle vCPU dissociation")
> 
> So IIUC this patch only adds a KVM_BUG_ON() when TDH.MR.EXTEND fails.  How
> does this fix anything?

Hmm, yeah, I'll drop the Fixes.  It made more sense when I thought it was
impossible for tdh_mr_extend() to fail, as returning an error and not explicitly
terminating the VM was "wrong".  But I agree it does far more harm than good,
even when relocated to the end of the series.

