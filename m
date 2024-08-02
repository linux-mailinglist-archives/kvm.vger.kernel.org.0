Return-Path: <kvm+bounces-23080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 027C3946161
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD4E31F22C34
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 16:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4F91A34B9;
	Fri,  2 Aug 2024 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="glVZ/eAx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6F41A34A6
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722614844; cv=none; b=IHwV9UNvXp44ui7VnLFXiR0qFDbsMUwYJ9MPEUAFMI/I4MnjzW9XIpBp12YrYrgEg/qGpyqaO/Bwa+aUbrynUhVdUmGoK5ci5A1TLezy/gOuEmcmGi6K8XRFoAVq2iD7TvFGxfPgIVsndcRhD5u8hNYLyJv87DlN5uEOZGc2I9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722614844; c=relaxed/simple;
	bh=sFyAG3nK4mu05C0Jdhf3hBmQSgNhmuMJdUdTq7ZpIT4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k8HypBN5C8VXmsPGjbbd/zVTEhMBZSNVT20POIwllWpNn5vGW45CJtJOOHI/fxB4EC5CoF/w2wTp8tVNNTLYUgasif7RmaR9sZ0ALjAP9rJi7mEjj4iErThv1YwJxARpHbfIczF1W3aTUdRj7ZZHUhaYevdPV7kW1A9I/umAi28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=glVZ/eAx; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fd5fe96cfeso82516625ad.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 09:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722614843; x=1723219643; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sFyAG3nK4mu05C0Jdhf3hBmQSgNhmuMJdUdTq7ZpIT4=;
        b=glVZ/eAxh1+QgF/RV/9R3iIphHB+hz2pLP4Q5PocBD2smnV3K2oAZUgiumSpr0uuBc
         p4KgV3g4pkVLbOVcwfq8NvRmws7aDK4GyJpdpHMCscJmYnU60kpfZnfh+6klzoQqUIJu
         D0aHlp5D1r+9kWOsS3mw67rD6kFYrDb8K9tKu5wwiubaLgHPqF7AqCjvXp4+wLEaOw7o
         5W0SWNEYkAXYuLPfQ9qPIfUA2Q8qkKoXTqkU2a/5wjPE+YgLSUr9p6yZ3jg9L5P6WSeS
         wFqMRx+qz0HNFCr76sPf6AaqRGMyNbmg6DsofuJzPonj9IFNFQbCVop4T9IBLTT0cBS2
         yWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722614843; x=1723219643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sFyAG3nK4mu05C0Jdhf3hBmQSgNhmuMJdUdTq7ZpIT4=;
        b=txC1e0ouQRhSvbyAyqNZogzEp6afUcBccyEKCLgz5eR1SYqi7b1aB3pAr1sRAyzkzj
         1pmU/wx6nw9dclbeMSkzO0x8PXK4Vq5wzl2ctCTAl+4bgQpg+yLJvxtElJWPZ3FrBD7V
         CbruXZYLbCEUQt9x7X+cBy93/tS6RaQ1tepQeiOcMkbzc7cvUz1Lf1IZlVZ6eDuQkDPq
         o7cvBGLLD/S2pOGQ6tjgHH26U811LAlZbgG4uVyoeIlwqKvBpKNDgJiWLhGheziLEM08
         m30Aoh3aEQxGFiAS8Fd4O40Xn51QI3l4qJrmSIj9r3PPjgjtJhGhaod6e51RaVMmCcCs
         hfuQ==
X-Gm-Message-State: AOJu0YzfgWa9+7ZvcXUv5QdWGc+klW5KCSrVR+RmZqShwADUbl2DH3Um
	bpxs+dk6RsFhdeJ4rJP244E1CDHCx0wbnJZKQlDw3ylP0I43JISZqewRaUQ2Lgvh5z8b5m9DPGD
	7ow==
X-Google-Smtp-Source: AGHT+IHINqbBg/9c5OSwc9BiCQx2SQVtXAhAUSFK+j+IXkE2pJDyiIJF5AJ9wBpI3r76YW4W9K1i/tiwY9w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c6:b0:1ff:458e:8e01 with SMTP id
 d9443c01a7336-1ff570eb3ffmr2647095ad.0.1722614842659; Fri, 02 Aug 2024
 09:07:22 -0700 (PDT)
Date: Fri, 2 Aug 2024 09:07:21 -0700
In-Reply-To: <6d043ba2be415fae75d0789d1b7b4d432032a113.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240725175232.337266-1-mlevitsk@redhat.com> <6d043ba2be415fae75d0789d1b7b4d432032a113.camel@redhat.com>
Message-ID: <Zq0EOf--E30QNyhy@google.com>
Subject: Re: [PATCH v3 0/2] Fix for a very old KVM bug in the segment cache
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 02, 2024, mlevitsk@redhat.com wrote:
> Any update?

I am planning on jumpin into review/merge mode on Monday.

