Return-Path: <kvm+bounces-50126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1D8AE2020
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:33:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA2EA16C0BD
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 16:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 498932E6139;
	Fri, 20 Jun 2025 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fvTFQIOV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9E3283FE1
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 16:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750437169; cv=none; b=dUCimAQwfcuDLsxvtAgr0nCRD557CFsgvtUvOKFl6Qu1LGoMuj01akfKNAm/ypfm6DraFm+SCpCVigHPvmXfM1Wwl0EiGgvVL+Aiu3pod7sS5yRQHCFxTaHFEtfn8YmjDda0AuDVSu+MteRp2qlubOhOdBNtX2onXk/4UIwCtF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750437169; c=relaxed/simple;
	bh=UUGJEFvMJiJUtG7fX1QfkYcrarliY8x2EX8fnH9uylQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dh0yHrAzZmd/p9e93tbBYqVxCS9OYLXW9RaleknrfkH30lUnRpni6a3F+f4HSFHuGttMLhIZF4bsuqihePABmCT50k/Vbbo7gzJRuwSuNQTwDQBdsW4gI/PPYHZTI97ZLzIwSJNn6Orh9OuHdPx1EGo1l+x4V65oLq5v3VcXPE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fvTFQIOV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313fb0ec33bso2055817a91.2
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750437167; x=1751041967; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q+T1i5SEvV9Z31e1J8RLYYDl1XVmkXwiuo3ZuligXs0=;
        b=fvTFQIOVyFkKoDSFDA/Az2bqZ194NqRSMO6AJj529Gpke4F46MRJotOn+q40m7d/Cm
         I6g+kQaue3nJOJDgy8L5W0/HwYhhpP0F0wn5GFR49yJLVhE/u0d2ochybNubxYLNjzmG
         Lb6x7xDUWce4cANDYSze2dIClPJteQnVh3KVLl+10cln8f0I/GByuSzDNaaXlgXxNjIM
         fAqmnrvc3c8JWCgRL49CmhDzoBhpETM+Y7M01dAolMFOEqmFSH9jxjYhKOnzxFlCYGa0
         fEcCd0nd1G66tnK4EiMOO1eOrDvNxaszTauXl9EyzXbdbiYFMeFW3zWzMMaJVXV3AalL
         Ao/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750437167; x=1751041967;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q+T1i5SEvV9Z31e1J8RLYYDl1XVmkXwiuo3ZuligXs0=;
        b=Sojj0GEdkx9YplDXcZIJjINGUNRjxfZlRu9Qt/tbQR8LuqNTbsuTcgugREG9d7JRKC
         cmQV0+T7SvNQryQPc7kswoqcJSlljdmBeC9279vbH8BnmKKenuBRRfHji7SmbW1iO1mL
         25M4p/zdAPSoetw/VgIt102/fxh0LBpZHptX3A0qVVGdDUuiRsXX4M71tB59MKRzAuTZ
         YIPgJh1GP5A6CPCM9yfFaLBdydWutn3EpwsRyPCH3fdDN1MA2gffjNXHggR4M7wQpL8h
         zq4VjnmXBpGd5oixIV1Ly8g/x9yEQIBVY11QEhb8MDj9V9LAZRE1ih8cCOSFF2/5gabv
         EDTw==
X-Forwarded-Encrypted: i=1; AJvYcCXI7oocAUde4cQWoqAN3AM7VHtG5cI84O5/7E7I78rjIdpwuCkJHODnYXlpIO/pgKfLNW8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1uXCSJ9Hj9Eq0CTHfvX85Mxmp1XHMku8dWnlcodPO5/Eo61es
	qWvCkyryDpb8BuQ6OlQauYn1OmC+s78JZr7e0FbV8feCl0DQR7jGCvss4AbXf4oLj8feyIv4Wr3
	Xpy4E3A==
X-Google-Smtp-Source: AGHT+IF4a/lQAv0v8vtOXY+IEOif7YdEgd0jQc9cVywSkFokkZqxDv7+GLbnpUPU9MJdS63sq1uw+hx5gPQ=
X-Received: from pjz13.prod.google.com ([2002:a17:90b:56cd:b0:312:df0e:5f09])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e87:b0:315:6f2b:ce53
 with SMTP id 98e67ed59e1d1-3159d8df90bmr5531527a91.25.1750437167470; Fri, 20
 Jun 2025 09:32:47 -0700 (PDT)
Date: Fri, 20 Jun 2025 09:32:45 -0700
In-Reply-To: <t6z42jxmbskbtiruoz2hj67d7dwffu6sgpsfcvkwl6mpysgx2b@5ssfh35xckyr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
 <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com> <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
 <aEyj_5WoC-01SPsV@google.com> <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com> <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com> <803d857f730e205f0611ec97da449a9cf98e4ffb.camel@intel.com>
 <t6z42jxmbskbtiruoz2hj67d7dwffu6sgpsfcvkwl6mpysgx2b@5ssfh35xckyr>
Message-ID: <aFWNLZQ7pqQahdEh@google.com>
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

On Wed, Jun 18, 2025, Kirill Shutemov wrote:
> On Wed, Jun 18, 2025 at 04:22:59AM +0300, Edgecombe, Rick P wrote:
> > On Tue, 2025-06-17 at 08:52 +0800, Yan Zhao wrote:
> > > > hopefully is just handling accepting a whole range that is not 2MB aligned.
> > > > But
> > > > I think we need to verify this more.
> > > Ok.
> > 
> > In Linux guest if a memory region is not 2MB aligned the guest will accept the

What is a "memory region" in this context?  An e820 region?  Something else?

> > ends at 4k size. If a memory region is identical to a memslot range this will be
> > fine. KVM will map the ends at 4k because it won't let huge pages span a
> > memslot. But if several memory regions are not 2MB aligned and are covered by
> > one large memslot, the accept will fail on the 4k ends under this proposal. I
> > don't know if this is a common configuration, but to cover it in the TDX guest
> > may not be trivial.
> > 
> > So I think this will only work if guests can reasonably "merge" all of the
> > adjacent accepts. Or of we declare a bunch of memory/memslot layouts illegal.
> > 
> > Kirill, how difficult would it be for TDX Linux guest to merge all 2MB adjacent
> > accepts?
> 
> Hm. What do you mean by merging?
> 
> Kernel only accepts <4k during early boot -- in EFI stub. The bitmap we
> use to track unaccepted memory tracks the status in 2M granularity and
> all later accept requests will be issues on 2M pages with fallback to 4k.
> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

