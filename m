Return-Path: <kvm+bounces-48881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52FF8AD4360
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14E68189CDCA
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D4726560C;
	Tue, 10 Jun 2025 19:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f1Ry2YCX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD4123BCF8
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585492; cv=none; b=YEDl8wcV6RYnFBstpKxiwxgqqOPtVQTXIATGyGvCyhiRLEQVyi44Ac69oErnzQ5DRqCUBwFHxr90tgdlzRNqg33iYjPLkvFziQzmWypkoYXsYmC5vgKyPRgWGlJkStQcE8lVdAF581Cw93nKkPqU98PphkJxIErNVTGE1evJZmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585492; c=relaxed/simple;
	bh=ihCwGGEoD8fC9INm24omOseCfGg9QYvO2mr/2vHKcko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NNpTXhQUrWls/sL1TdrBQ63CK3ujKQcp45+2KZass6hARRncoI8UDWbc0BcxSPLiKFQXN9KrbNToEz3qEbH27gNPk9G9rKvDb/FjVf4rbETn1emncbyvdTcTxe/ZMeOJGx7GNoZ6K+fRguwMAfiUL/mZeAymkdcWPDqHd5yQ/WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f1Ry2YCX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23638e1605dso6663855ad.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585490; x=1750190290; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M0BRtyPs7ssFwm4bCrsdLDOjneVtqSl9fylp57SlbsM=;
        b=f1Ry2YCXmY1okvCrnpv8yeIFvmhvrlRzRmQGD2pYLX8iGPyKo3oSeXlyVUAayUDUN2
         Kls2BXjYJgzzswfHrIgDvvz/dMVLRx6XdG9t5hfGJrpT+oQ45q9SEPQo2rOfszqtYN+7
         23R9YJ2vCBcMAUB0W9meKzRQ75LsNIM97YxjF6LwVRUxkU/mZjIhFzDyAXgangDQzGgY
         2nHnG+h3qtwDWvFPM8xDSGfs7dLBQl7nDmm4H8xSa1u1H0q41S+PWbSfG4ixKTlGW8Me
         5SpiVCUJylAXhUu7YvDD5o9WDpCSJyAA0XrsH4qWvNzX5tyxtDVz37dJqNNqcKKb2o3o
         3B7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585490; x=1750190290;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M0BRtyPs7ssFwm4bCrsdLDOjneVtqSl9fylp57SlbsM=;
        b=VxVgZ6Epaj2W3n5wvNhKKdSQo3fM6uZ+Q3NxrOK0OjG0v+9avaap2Z0z6Rpfgn+EnE
         bQmq4b20DMzKgSAPcH17ElVpOEiwiy2ioPylvMTHiyUHvXVAF0Nafth6GfxGAomkGXcH
         J+KBK9TsenQX5PcgSguKQsHCEBSLX/p14GO/LkuUpKUs39eMoNK2jN/M/0xZGsYBr+un
         K1LSLYz9yhbPNIOn3uLE/AWUR8gtsa2S3j1jUeWwfohvY/6U8F2elRyarOFFZpa+hu4x
         NIPoyz5uAveq3djk09pnXdnUrBnFKEJQVomcx8j9H1b4gYvMO2NCXzTpdK172UwjZr7g
         2PUg==
X-Gm-Message-State: AOJu0YxCsu1pD5lprck204TQBdXG/iGs0A1b+g8OI86mq4e/XBmIgcip
	ZGS3ZXY4+RhZvxfQSoJVugVMdhtoOpKy1MflYhChKZHhViTtrM3IleDrRBRUwd6zbR9yZvVdIZj
	dth7axQ==
X-Google-Smtp-Source: AGHT+IHBrxHjWELJiauo4ekTKB6wyweoRO4KZWVQLjKaZT+cFCFEpa+zRq1kr/t1K2Tn2pFBq9SqItjfBU0=
X-Received: from pgcz18.prod.google.com ([2002:a63:7e12:0:b0:b2c:2139:ff4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c4f:b0:234:ef42:5d69
 with SMTP id d9443c01a7336-23641a99d41mr6706265ad.13.1749585490160; Tue, 10
 Jun 2025 12:58:10 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:58:08 -0700
In-Reply-To: <936ccea77b474fbad1bde799ee92139356f91c5f.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-5-binbin.wu@linux.intel.com> <936ccea77b474fbad1bde799ee92139356f91c5f.camel@intel.com>
Message-ID: <aEh0oGeh96n9OvCT@google.com>
Subject: Re: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE
 when TD finalize
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jiewen Yao <jiewen.yao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Tony Lindgren <tony.lindgren@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kirill Shutemov <kirill.shutemov@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 10, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-06-10 at 10:14 +0800, Binbin Wu wrote:
> > Check userspace has enabled KVM exit on KVM_HC_MAP_GPA_RANGE during
> > KVM_TDX_FINALIZE_VM.
> > 
> > TDVMCALL_MAP_GPA is one of the GHCI base TDVMCALLs, so it must be
> > implemented by VMM to support TDX guests. KVM converts TDVMCALL_MAP_GPA
> > to KVM_HC_MAP_GPA_RANGE, which requires userspace to enable
> > KVM_CAP_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE bit set. Check it when
> > userspace requests KVM_TDX_FINALIZE_VM, so that there is no need to check
> > it during TDX guests running.
> > 
> > Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> 
> Do we need this change? It seems reasonable, but I don't think we need KVM to
> ensure that userspace creates a TD that meets the GHCI spec.

+1.  We do need to be careful about unintentionally creating ABI, but generally
speaking KVM shouldn't police userspace.

> So I'm not sure about the justification.
> 
> It seems like the reasoning could be just to shrink the possible configurations
> KVM has to think about, and that we only have the option to do this now before
> the ABI becomes harder to change.
> 
> Did you need any QEMU changes as a result of this patch?
> 
> Wait, actually I think the patch is wrong, because KVM_CAP_EXIT_HYPERCALL could
> be called again after KVM_TDX_FINALIZE_VM. In which case userspace could get an
> exit unexpectedly. So should we drop this patch?

Yes, drop it.

