Return-Path: <kvm+bounces-33449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 184469EBAA5
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 21:10:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F8951664EA
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 20:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB35A226891;
	Tue, 10 Dec 2024 20:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eQB1ttjY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C293D153BF6
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 20:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733861417; cv=none; b=TRj+rP9ynlWxlx5WGBuTV31KLccXYhaQnrq+nK+MIfWo7iDw0zx70g3b8A+HfbHqRnabw4Wc7c7UESSBv4kvAsetfmyaGZj1F6byTe+9xgRfqMrkjS/7kbgTGnLwf3GZV528AJ1omOQdMJ75x653tpeFRUS2n0KbvZ1ekatxgQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733861417; c=relaxed/simple;
	bh=ArH+BDaYBBobT5PIUMi1jnRalONERI4QUQnKck5+RtY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DxOBKVePyax/Q3NycE3OpzkRAPiOofcM0fgfiLEO/X9YVcnv5FdOdpFR1cyQ7638KTnhL5nWSc4geaxOWFaPTGPxNGlPkYNONH73yWogpBrTJlTmvA2JjIrv0nAV1oqS1c8vmH/2k4v+MmW2bRFnanqtA4BXKKQBjm4e4Mk1P/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eQB1ttjY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee31227b58so5768408a91.3
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 12:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733861415; x=1734466215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4CcZIj8yhvlL/w3reHOFOEqXMEvWzMLZVJVn1HvOF+k=;
        b=eQB1ttjYKU3siMs7d/Kpgye6RWCC4nZrJCfZy96c3Db/uFjwSkNEgi2D5HxTzI8zWq
         iF+X6qhP1FRW6gz2bcvv7XSbhX+6aoiYUvGi3AJBA+ufxj3eNDFhdQ5N67l6Vrd50gqb
         hfjgGURZkkTUhlqKdNLrXMlN0d4g0HPBH6GIkoDu9bKzFU/fV64SXuHpBm6objz7sq90
         5/CRXtheDNG8xU5UAebhTBq0lO7uY5eh1VSaSfeyMQpvtQhqQeNEbD/jhiAgVbx1qY0m
         bdcesJOd+rZVgvshPrewJ//L6XufL32ZRW9YygLWgfC71BgvSiTVWn+vWg8/XDRdEt1b
         WSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733861415; x=1734466215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4CcZIj8yhvlL/w3reHOFOEqXMEvWzMLZVJVn1HvOF+k=;
        b=cGUbDMCTIb4SUCoxwrtMUBKBIJnEyEP1yIk1mqbpy1SKVXw7k/MpjzvKiEXf7p3Adh
         Oip4OIUxM4E9cDgMt1V+e/TcHcF4ozi0piVSZ+vpmEkxTVZ839Sw6lfoZ8YqpoNXIRjU
         29FA4q+/QgFCn5WtIrntTE4Kl6UqRuTjuynB3uCM7CtnFopE9sQsNj4iJ7y25T91Pnz9
         L319up1cuV+F8H7/YTM6iNpv8qydXoA3sgJusEPbSpDwF69MoVUSeo233RSh7SWrWYEw
         nXqW5NqYEiIEx0O6y6iGO1mFY8Esv3IhqkSVmclHs3glT3sIj/MaZNFnxML4o+1dW6ln
         k9nA==
X-Gm-Message-State: AOJu0YwXgMaduD+JPZt9km31jO2ZGF3hC+OIG6G1avuIGSxf7Gm2JWRk
	ap28DL5bhHamHXFV/2KDf3MKxBJAsZEvo1Xt4pYPI0zC8Kz/8vYiTDborXAYdrPPcrW3Pv7W6FJ
	7GA==
X-Google-Smtp-Source: AGHT+IGdwFwyc/i49yH9lxYKjEfEPyXHxb0toroZJAgwWjp3C6PzPZ+OK/X2WpQK5laCaKj9suPGSlqcsLI=
X-Received: from pjbsj11.prod.google.com ([2002:a17:90b:2d8b:b0:2d8:8340:8e46])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a:b0:2ee:df57:b194
 with SMTP id 98e67ed59e1d1-2f127fdbf48mr395474a91.21.1733861415188; Tue, 10
 Dec 2024 12:10:15 -0800 (PST)
Date: Tue, 10 Dec 2024 12:10:13 -0800
In-Reply-To: <ff1d01ff-5aa3-4ef7-a523-6bf4d29be6b6@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128004344.4072099-1-seanjc@google.com> <20241128004344.4072099-7-seanjc@google.com>
 <ff1d01ff-5aa3-4ef7-a523-6bf4d29be6b6@redhat.com>
Message-ID: <Z1igJYxwSxTk_DHF@google.com>
Subject: Re: [PATCH v4 6/6] KVM: x86: Refactor __kvm_emulate_hypercall() into
 a macro
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 10, 2024, Paolo Bonzini wrote:
> On 11/28/24 01:43, Sean Christopherson wrote:
> > +#define __kvm_emulate_hypercall(_vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, complete_hypercall)	\
> > +({												\
> > +	int __ret;										\
> > +												\
> > +	__ret = ____kvm_emulate_hypercall(_vcpu,						\
> > +					  kvm_##nr##_read(_vcpu), kvm_##a0##_read(_vcpu),	\
> > +					  kvm_##a1##_read(_vcpu), kvm_##a2##_read(_vcpu),	\
> > +					  kvm_##a3##_read(_vcpu), op_64_bit, cpl,		\
> > +					  complete_hypercall);					\
> > +												\
> > +	if (__ret > 0)										\
> > +		complete_hypercall(_vcpu);							\
> 
> So based on the review of the previous patch this should become
> 
> 	__ret = complete_hypercall(_vcpu);
> 
> Applied with this change to kvm-coco-queue, thanks.

I was planning on applying this for 6.14.  Should I still do that, or do you want
to take the bulk of the series through kvm/next, or maybe let it set in
kvm-coco-queue?  I can't think of any potential conflicts off the top of my head,
and the refactoring is really only useful for TDX.

Patch 1 should go in sooner than later though.

