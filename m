Return-Path: <kvm+bounces-50153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A69BAE225D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 20:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43A7D4A5DDD
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75A32EAB93;
	Fri, 20 Jun 2025 18:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="16xb1XTJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2692E8E1D
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 18:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750444834; cv=none; b=s+D1GkP4OXOmt0Eq7XNUosQ5exLxs+iY0E36ZFNAtfteDYRrs/kdKKei6HTpg0dGKKZmyPBCY1s6iEqU+GoGs9CLZtSxBkAvIZOk7IBOUM5PH+fSlbaDolvo0fzFn4uE0J0Ue4P0dVdHugyBh9YropyxpwMVc28SiDwFoWz0Oe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750444834; c=relaxed/simple;
	bh=lyY6FNfCAGhST5Sl1y1OUV5CF+K4ALihyqm6anBB/r0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jN1irlzaIV5wFpPmUD21HRAD78DtLZvn6dhCQUf5cTYBdwEzfw98UR/QymzOX9ZoPWMaAe0rMB4RCs+u7zNkQmtPp+/piqp7CSjJFcamIwWQd1x5gyZsb2OL3fLZ5g/bs47yH1HwVVFEdYgcHWOjjoBoMIws3HE2bkeln+N2ERk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=16xb1XTJ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234fedd3e51so21051555ad.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 11:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750444833; x=1751049633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=atP7hQh0CjR/tS90I/fm9NKffIAdFW+oOMo+3bGt6wE=;
        b=16xb1XTJEALseSv+Ltpvp0HAF2pvyqXVXffsAgM88Eh80tBU8s91g20v5Eb6T9deDZ
         E7Ky/z1KyxxIUg1yBcwZCN8MaEKngPkgpV7wNii5xqZ7xTdAQbTSN/lxDmT+eStgl7OF
         FtRQGNNxRZwZdlZw+m8l62Tx+yNkvM0o3c/hJNjcSfehejSZukhreqe6tcMittqK7nvp
         Riu5X1mcIDlWUy8Ph0nQJYHd5MudnhdLzP4OqCMDKKdgaopf4Etp7hXsKaf9a7g548im
         MbxQ2sl7GxUV8hush0pvc9Y5ZEaXPpdnmW5TofVAhRXlShDZleLHvbKy5i7kr6dyu8JR
         vUfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750444833; x=1751049633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=atP7hQh0CjR/tS90I/fm9NKffIAdFW+oOMo+3bGt6wE=;
        b=hatF4X1YMkrYX2HA/6LAy8YWo2/Z1eShPaPH3KCB6u73ZjFgAOdd1dPuu0ecp2qn3c
         t7PCbRqPpLMt5LKc5Ofv1WMbAYcdsX0nQehuuSmRmhH207HGJB13rkeJzmv+CFHqm8Uv
         GNx6Xu3luOccRQMTNW1x81w56n31XSJ66GKg6vQ+2xaOV+nars9SVukj6j/wGWOTQQLv
         /O0ImST8wj1tYetwkGSsSy8YPIhWqbpza78eTS7uVGq0abXOV/B2/yDAdDxsboQYL3Fr
         Z9VKLGDWnJZH7GF0k1ruDWh75K3j1cqUOw8UZWSNJozUxzpvOMFORp1LtE+yk4+dh+Fu
         arlA==
X-Forwarded-Encrypted: i=1; AJvYcCXYFNOqs46/mSj7o/onrxg8+Gh8cO/msitIryx2zRkuQ336jnSKF5IxrIyqhanwpeEwQNE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY/tlyYWA985kw8big4+Zvi8DOw/2Z/GMOCBNd41KF8gwDKNS1
	kcLQ1f5jALNnS0fbsZx7h1QoNoFKRZPrbCiWCsSIaEHshMzwnlg+PlILNCmDnmALSJXhPfxX7wh
	7SEgzew==
X-Google-Smtp-Source: AGHT+IHH9/J7sptbL1Cp0bAus4GBwHUgnmlfkgFvU1ch0096H5hv3XDFYHuGwQtRcOasE80UGEVl3WtvpxU=
X-Received: from plhw5.prod.google.com ([2002:a17:903:2f45:b0:234:a456:85ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3bd0:b0:234:aa9a:9e0f
 with SMTP id d9443c01a7336-237d9872225mr62675575ad.23.1750444832810; Fri, 20
 Jun 2025 11:40:32 -0700 (PDT)
Date: Fri, 20 Jun 2025 11:40:31 -0700
In-Reply-To: <4m25vi2w2r4zfmck4giiqryy64etpfvozyqifv4f3i636i7i2o@erv7a6wrtvyy>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
 <aEyj_5WoC-01SPsV@google.com> <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com> <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com> <803d857f730e205f0611ec97da449a9cf98e4ffb.camel@intel.com>
 <t6z42jxmbskbtiruoz2hj67d7dwffu6sgpsfcvkwl6mpysgx2b@5ssfh35xckyr>
 <aFWNLZQ7pqQahdEh@google.com> <4m25vi2w2r4zfmck4giiqryy64etpfvozyqifv4f3i636i7i2o@erv7a6wrtvyy>
Message-ID: <aFWrH5EYg5ljBwNZ@google.com>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is RUNNABLE
From: Sean Christopherson <seanjc@google.com>
To: Kirill Shutemov <kirill.shutemov@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Fan Du <fan.du@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, Dave Hansen <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, Zhiquan1 Li <zhiquan1.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chao P Peng <chao.p.peng@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	"tabba@google.com" <tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, Jun Miao <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 20, 2025, Kirill Shutemov wrote:
> On Fri, Jun 20, 2025 at 09:32:45AM -0700, Sean Christopherson wrote:
> > On Wed, Jun 18, 2025, Kirill Shutemov wrote:
> > > On Wed, Jun 18, 2025 at 04:22:59AM +0300, Edgecombe, Rick P wrote:
> > > > On Tue, 2025-06-17 at 08:52 +0800, Yan Zhao wrote:
> > > > > > hopefully is just handling accepting a whole range that is not 2MB aligned.
> > > > > > But
> > > > > > I think we need to verify this more.
> > > > > Ok.
> > > > 
> > > > In Linux guest if a memory region is not 2MB aligned the guest will accept the
> > 
> > What is a "memory region" in this context?  An e820 region?  Something else?
> 
> EFI memory map entry.

I forget, for TDX, is the EFI map built by guest firmware or by the VMM?

