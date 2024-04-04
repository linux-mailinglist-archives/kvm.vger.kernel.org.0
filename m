Return-Path: <kvm+bounces-13592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D93D898DD3
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:17:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 287B72840F1
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC641304A8;
	Thu,  4 Apr 2024 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z1JfOCt0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC8212EBDC
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712254648; cv=none; b=nNBvWBL1JgrA7kesdNRLrmsd3wgIu8DxKuCpt7PoLR84+YjDUrv1XnCJ5J68rybmmrGkvpTMMv/q1LyDnNfzyckSUXpGk10v6QuxFaLOpZWM0OMPVDnB4OZ2/bG9aqDHWS9MASUd9SNgI4hqMDY1zNnanGdEIad4+ESkx/T03t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712254648; c=relaxed/simple;
	bh=ohuExL0HfhgjZhZ+ZuA3robEPaGBpOyucP2yOlunWeI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eHlv1+4ddV9f9FEeHnPtxZs4YqGbcg3XHr98R5AVlyF7RG4fvJHC01hmigJGprEQ1AADo0r5X0WgNmMGPRspCoQWvcvGUn/DkbNrsTqi1y3unLtMXP/kllADPj+CZNNVjVq9BQEYd9ZrAX5fxi3MYv7BISt/7TILshuczZ3mqrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z1JfOCt0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a2386e932so24511697b3.1
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 11:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712254646; x=1712859446; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sYOoCh6UJhjoVdf8xQjst2vIFE23d+HvcvbvOgUucm0=;
        b=z1JfOCt0+vA3Daf6QtYus/MjMZNL2ZLiZQuFIxbkURyKjZfx1QcYTFvFd8hS5zbPIN
         uLLSAnw1LfZHcONqME8APiRNQc4dM6yufwjokZdiHICOM8YQomPWijIgWIwU5hegXn7O
         U0beiJjkVIZ38dP4lXdFo1ozwFCzzXS0RVB/tPNZoXwTLSToiE56eRIU2D8yN0l1HXpG
         BlUS+d8h2OrOm8TvKCBnW4Vdzcv5XjBw64A1aoHRYYbFMLs8zxg5/dS7Sev9k1Wd74Yy
         kRh/oMXQkQn1gtYZWDbasP20dps2pE7JKb5NErEulzpw3WohfWr+lgP7S35N31/XFefW
         KOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712254646; x=1712859446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sYOoCh6UJhjoVdf8xQjst2vIFE23d+HvcvbvOgUucm0=;
        b=b/+PHvaLqtKMZGW1gOs17pXIgIBqtClSp10Y4fhs96EpiK4U75qy/GW95Mz3hzL1Hh
         VWurOn+RoqS4ILjErERv5tnAvzVRB33ZsC489lJgqQ1Dsrx9clhqYSzqMUaD3sNV+mF5
         x103jaIcrzfYj8ZYWFMGNXOskAnUSLCzffeAFkvplpQGe4PDiOqR7eGywnjhVM+GgxCn
         ge5xImmhiOYSNPvK1etjaGwcEvv9t2I1Pwkdwu9DPRYdsqdlZiqpPYjnHI94H1XlUxjA
         SbfbGfuYsY/C4BBbgeZJ5TImpxbqBVGfla4zFrDYR/kzigPsDuXY/eYp+lVULxHGIK3N
         S0pw==
X-Forwarded-Encrypted: i=1; AJvYcCX1labOn88ECCKO+NIKIZKRSn2pz7AhE08yCce6VfDiI9Vuq0G9G2sy4nZB84bkSU91GCuQS8Y5OKoxodjiZrVA0Z3k
X-Gm-Message-State: AOJu0YyWQukhK04uHKYjttTo4TLOC0dZAa74X1L/mNJLFLW0uYH0noR2
	8XfB5Dw9d15apJT3Lm+eXcuBNV0Rd9ezwTCqKesIBgeccp8OInWU3tl2PtTJub3HMdewQ+QXG6h
	ACg==
X-Google-Smtp-Source: AGHT+IEcHLFp93PcSOAa5ozTc9zxJWoG/AELZU74M7vve6Dr7+EEuIIZ50eim8Mxletl8KelzhVzCmD8Nak=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a1c5:0:b0:615:12cc:b325 with SMTP id
 y188-20020a81a1c5000000b0061512ccb325mr69298ywg.7.1712254646318; Thu, 04 Apr
 2024 11:17:26 -0700 (PDT)
Date: Thu, 4 Apr 2024 11:17:24 -0700
In-Reply-To: <CALzav=cF+tq-snKbdP76FpodUdd7Fhu9Pf3jTK5c5=vb-MY9cQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240402213656.3068504-1-dmatlack@google.com> <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
 <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
 <Zg7fAr7uYMiw_pc3@google.com> <CALzav=cF+tq-snKbdP76FpodUdd7Fhu9Pf3jTK5c5=vb-MY9cQ@mail.gmail.com>
Message-ID: <Zg7utCRWGDvxdQ6a@google.com>
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 04, 2024, David Matlack wrote:
> > I don't love the idea of adding more arch specific MMU behavior (going the wrong
> > direction), but it doesn't seem like an unreasonable approach in this case.
> 
> I wonder if this is being overly cautious.

Probably.  "Lazy" is another word for it ;-)

> I would expect only more benefit on architectures that more aggressively take
> the mmu_lock on vCPU threads during faults. The more lock acquisition on vCPU
> threads, the more this patch will help reduce vCPU starvation during
> CLEAR_DIRTY_LOG.
> 
> Hm, perhaps testing with ept=N (which will use the write-lock for even
> dirty logging faults) would be a way to increase confidence in the
> effect on other architectures?

Turning off the TDP MMU would be more representative, just manually disable the
fast-path, e.g.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 992e651540e8..532c24911f39 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3371,7 +3371,7 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
         * Note, instruction fetches and writes are mutually exclusive, ignore
         * the "exec" flag.
         */
-       return fault->write;
+       return false;//fault->write;
 }
 
 /*


