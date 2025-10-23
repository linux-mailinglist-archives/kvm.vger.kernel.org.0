Return-Path: <kvm+bounces-60899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E95FC02B94
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 19:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C41A93AB331
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 17:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C331347BDA;
	Thu, 23 Oct 2025 17:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oYbIdCoB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1556B347BBB
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 17:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761240439; cv=none; b=LXx6uwBpzIo4hH6PsCAfhQUOxrOIT8Da4MVLL6N9XlzLXy1YlfWSJDl+pHBVqvqdM5ZW9oHTKFkICNg4/E9AMYENiWHEEPKxi50Exs1/uUp6vVjlNm9XUhLR5stQDVEO4l6dTHWQAAEzT/FU698ty04zMtO5LdYiNqyhKzPtBlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761240439; c=relaxed/simple;
	bh=XVDzXI4Y1e4iRpQIyW9vAwBiWIuzXTa0TJZpBTTKBPM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KFP+Nl/BRYsBTVU+S4OtUaZBfXWK3rhQ8JKPdeGEeL/UbCaP/1Ylmyq3geXziAb5WG96QZ7eGb5f/sQuGsEeVR9/uqhqRcsg4hozjHTVzdtrmEjPN6YZxjI6VxlME4teUyPPgEImKjoa0VZEqjqXyx5G1k2Ud0iUDybN78aWzVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oYbIdCoB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-27356178876so7254265ad.1
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 10:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761240437; x=1761845237; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PMd4YohbYBDUY30TTRBHmO9DyPvx8MjhdR/tVFXtYYI=;
        b=oYbIdCoBvuoC0xoZz8Vf64f/MMaTw1kYJUtRLeTOGUnKQytAs8zrLYMyqAcKQY1C1y
         SDURXm8iJER0VyEqb+TpW8ZVe/yc6GFygCVT18Veb0vpkM6TjjEtIH0KiKT7j0ZhPmFY
         JM0j1A5l9nwgDn1Y5wIkyrWb++aO5KPbSiFSUKqb9FiFJZDkTmSem7ufqGMTrsLpv5S1
         /vRuK3uik4CeoSwZ9VQkLd2a75SG0Pdp2Ek1mt9C3sO7fjGen6bOdwW2lw1K1/wgJH9Y
         vb2lm4GEudDdMU26+vX+oMtkwG52wc+A246E9lpwCk8oixKTr2+g9Yf2lwFS2PezeEXA
         kN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761240437; x=1761845237;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PMd4YohbYBDUY30TTRBHmO9DyPvx8MjhdR/tVFXtYYI=;
        b=O68Zs+7ELtL4c4HgsQJfWxtVp+J3LY+1eACxQF+tWjuhOrj0IDs1O/ThvDJn0AIbSz
         odktDUbrJ1huVpUCTN14rsp5Uj73yJJSZrHd8L/dOyzcAwt/DFQCGu0pm2zz0lbRvWsS
         m+mjrpNdJ4PVd4EXk2EdaAv7+HLayADWu+g2EuJn3eVQwXpNpjQOPwB1g7TQXm0d3faB
         rP+6oJV14IE8uAqgzASxv11N8ec7gsOJ6m+3D57OTY002VijPcynNzP5PrcEuxdHEQ29
         TsfrklZgyYUzmD77vG3I7iwB/fgwvuwp5q9jhfnWgFHEWnFk0TzkZC4z4E3Of/Dtt/pP
         xGSw==
X-Forwarded-Encrypted: i=1; AJvYcCUcQcPZgka0/cr5unD3ywntcp2IN2FX85Y8alIgrk/RufA8Mk+OEyq5Xjn+UW+etEL1q6A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmn+FpmU95RXodn17VjJYLdcCoIuVcHnA3EABsJtFJKHtEhz4V
	CVJwIlYgRmY5JetxcDtbCpaTw88yDAq2UnIxXvFd8NNfrz300Ln6tfThI+ohaa2Qnd6J3SAXuqj
	qIdN86Q==
X-Google-Smtp-Source: AGHT+IFjhG//1khxmFCKdE4+6wWu9+6PA/jOl4XyR0eCgR53v+ZECkEt8twGk0B4jVNQwQCsevpreYrKXxc=
X-Received: from pjuj5.prod.google.com ([2002:a17:90a:d005:b0:33b:a35b:861])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db11:b0:240:48f4:40f7
 with SMTP id d9443c01a7336-290cba4efc9mr387536115ad.39.1761240437319; Thu, 23
 Oct 2025 10:27:17 -0700 (PDT)
Date: Thu, 23 Oct 2025 10:27:16 -0700
In-Reply-To: <707a01ee36c28863bdc6a4444a5560e9a0b19597.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-15-seanjc@google.com>
 <707a01ee36c28863bdc6a4444a5560e9a0b19597.camel@intel.com>
Message-ID: <aPpldKdiQYYnl4uC@google.com>
Subject: Re: [PATCH v3 14/25] KVM: TDX: Bug the VM if extended the initial
 measurement fails
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"kas@kernel.org" <kas@kernel.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, 
	"zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Kai Huang <kai.huang@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-10-16 at 17:32 -0700, Sean Christopherson wrote:
> > WARN and terminate the VM if TDH_MR_EXTEND fails, as extending the
> > measurement should fail if and only if there is a KVM bug, or if the S-=
EPT
> > mapping is invalid, and it should be impossible for the S-EPT mappings =
to
> > be removed between kvm_tdp_mmu_map_private_pfn() and tdh_mr_extend().
> >=20
> > Holding slots_lock prevents zaps due to memslot updates,
> > filemap_invalidate_lock() prevents zaps due to guest_memfd PUNCH_HOLE,
> > and all usage of kvm_zap_gfn_range() is mutually exclusive with S-EPT
> > entries that can be used for the initial image.=C2=A0 The call from sev=
.c is
> > obviously mutually exclusive, TDX disallows KVM_X86_QUIRK_IGNORE_GUEST_=
PAT
> > so same goes for kvm_noncoherent_dma_assignment_start_or_stop, and whil=
e
> > __kvm_set_or_clear_apicv_inhibit() can likely be tripped while building=
 the
> > image, the APIC page has its own non-guest_memfd memslot and so can't b=
e
> > used for the initial image, which means that too is mutually exclusive.
> >=20
> > Opportunistically switch to "goto" to jump around the measurement code,
> > partly to make it clear that KVM needs to bail entirely if extending th=
e
> > measurement fails, partly in anticipation of reworking how and when
> > TDH_MEM_PAGE_ADD is done.
> >=20
> > Fixes: d789fa6efac9 ("KVM: TDX: Handle vCPU dissociation")
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
>=20
> Per the discussion in v2, shouldn't it go after patch 24 'KVM: TDX: Guard=
 VM
> state transitions with "all" the locks'? Otherwise it introduces a KVM_BU=
G_ON()
> that can be triggered from userspace. not a huge deal though.

Oh, right.  And then the changelog needs to be updated too.

