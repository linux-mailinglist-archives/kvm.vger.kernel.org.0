Return-Path: <kvm+bounces-53818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA0EB17A4F
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 01:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7C54174695
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 23:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52FFB28A402;
	Thu, 31 Jul 2025 23:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="InbsWBo6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3258B42A9D
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 23:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754005996; cv=none; b=CklcoGOsWkfh80IiTbRNEcK0ETcksBrVLOBja4QkCO7m4z5detZExnNupGa3MKqmgjhnw+GbiB5gW+40xR8H0F13o7xVp7wfYXs8FWjSycwBW7Y9uOjywgcoeGcpVAWD84HmcXGX7upSbpT00otNeLp1kjBqeNnUwJ9R2TRw3G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754005996; c=relaxed/simple;
	bh=gAbRw7uH3XXn+Sglf+E7heaWdxMLlW+TtO+KicM6Atw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KXBdK4A7azoKqQWYzspgeDCXam5tP2nIeakHDVpwm2Oin8BBJV3xFAohVhVnM4xwMTtobUM9BA6UrYsvEO0cfIKXtfcRkjLHASbIFPJf6zbp2xA9Am2Td0yjsYfY1WrkjKW/QwUkesakBDJhd2rWpFLV2EDXbkmKw7+M81CC330=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=InbsWBo6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f3cfdd3d3so272505a91.3
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 16:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754005994; x=1754610794; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FdNmMaDXwOSAnSNITEaVtFj8sCKjwB2O/VXZWVuTvEM=;
        b=InbsWBo6sPKZMqX6d79viqk6amAv7sMejxiQ0KPs52KTLXnDtFHIDE6VGUVL7cSwil
         X1VDuSqcjyinUy3FlW0SjGUhEUlyrXWFzu0V0wy/XObOffVa/L9RhPYQHHkxPLLnxnrK
         kjX27T9+4z42J0MBPG73N7rSkFgBObFMS+vQMOOZ2nnSi119DPyxBk55zdoHEzAsqmYw
         l1Uha/9w4Abqo/3o8cGx1OSx+xvH0Mv+CY0ytT2k5TCoDfMJrWvw/ISKfpoU7xhJmipH
         Xc6Sd4xpT20ppf162B7V8eLqAvqXeqHRM0ziM1wg2CUUzOIbb6v/Tpjl/Eo/PMwSb24O
         Cv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754005994; x=1754610794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FdNmMaDXwOSAnSNITEaVtFj8sCKjwB2O/VXZWVuTvEM=;
        b=JVP7Lail5r726itnOPLzpQOMF2zsqFxHAmY7BMZP6IEB2pMmiLft4XlOCxueTjxriL
         aGkaVUKJGvkGFJicihuv7wbvzkFsey8pvMkfGHCBWq2K/mVWWbCGOUsC6V/SxX3GDiG6
         DPrIDdSWHPEJ+fwt30wteUlGkIYXqMR6reAIBn1W34YDWm4Y0m2KPh9frJSSiXRYI5dr
         zijU14GFSj5rOg1jSKONNC1GlTj7b0XKK+oQ9ROMeIdkAQGPgjJuu7EhmyDs89q3BfKB
         krqAPOgX6ItGS8F5CP0oHmW8uEzTinPojHU920la4Nh+3iI+XoXp6Z2XbEZYzGODgyvR
         ByLw==
X-Forwarded-Encrypted: i=1; AJvYcCWtHMFgNsVbrsluKUHk201mmGmP0NyWSt34+rwh+2ILvBPmz2wBDKqC5chHkC+lBMeitdI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIPTsyEN09o3UW5uX/Oc+l4UWwkp6Y/9K5RcYxexewLUa24BLC
	4Ebi0aWsP1W6LtsZOkoBWvCYjFe4dhggU/TBZwP6fWzkCjv6MevqvBZQRPVoct3pjUa69R66HVZ
	7DmZyyQ==
X-Google-Smtp-Source: AGHT+IF/xJsJThBWRLK7V7PkLQxZ0BHJZfUUHaMinJ5hy7aj9uko69XjGVMYarBMMDIdNyJOz47ad9dgynE=
X-Received: from pjboh6.prod.google.com ([2002:a17:90b:3a46:b0:2ff:6132:8710])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55c8:b0:311:f05b:869b
 with SMTP id 98e67ed59e1d1-31f5de58622mr12279406a91.30.1754005994626; Thu, 31
 Jul 2025 16:53:14 -0700 (PDT)
Date: Thu, 31 Jul 2025 16:53:13 -0700
In-Reply-To: <3f39e6f85341e141f61527b3192cefde0097edb8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
 <d897ab70d48be4508a8a9086de1ff3953041e063.camel@intel.com>
 <aFxpuRLYA2L6Qfsi@google.com> <vgk3ql5kcpmpsoxfw25hjcw4knyugszdaeqnzur6xl4qll73xy@xi7ttxlxot2r>
 <3e55fd58-1d1c-437a-9e0a-72ac92facbb5@intel.com> <aF1sjdV2UDEbAK2h@google.com>
 <1fbdfffa-ac43-419c-8d96-c5bb1bdac73f@intel.com> <70484aa1b553ca250d893f80b2687b5d915e5309.camel@intel.com>
 <aIv8wZzs1oXDCXSU@google.com> <3f39e6f85341e141f61527b3192cefde0097edb8.camel@intel.com>
Message-ID: <aIwB6X6cw9kwgJzs@google.com>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, Kai Huang <kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 31, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-07-31 at 16:31 -0700, Sean Christopherson wrote:
> > On Wed, Jul 30, 2025, Rick P Edgecombe wrote:
> > > So STATUS_OPERAND_BUSY() seems like an ok thing to try next for v3 of this
> > > series at least. Unless anyone has any strong objections ahead of time.
> > 
> > Can you make it IS_TDX_STATUS_OPERAND_BUSY() so that it's obviously a check and
> > not a statement/value, and to scope it to TDX?
> 
> It's a mouthful, but I can live with it. Yea, it def should have TDX in the name.

IS_TDX_STATUS_OP_BUSY?

