Return-Path: <kvm+bounces-11333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0942C875971
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 22:35:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF95F2882F5
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 21:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23E613D31D;
	Thu,  7 Mar 2024 21:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eMSr0M09"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3916D13A25F
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 21:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709847298; cv=none; b=C4LF8rLFo3QSE04z5i93IELPe62qRfNOZ72Wmz7LOgiRhYZ4+YuWFS7Z1aibBJJnyPr686jXFpyaD8KwvbWcW4fLPUYCmrdMSzC8JxHk88vbKkMNz2zdKjYStK0LGc1ldMEzRhRGOipwszxL7/gbkGv6jBOB1DsEgEieJhV4JgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709847298; c=relaxed/simple;
	bh=zosnbcQBHDZJn7lgRn7WlpqjgvvkYT4PTwJ15x8XE60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F1FauZFDHibFUkyVMtTPUM28pr2pRF8QrYDmdd7HOalOo7Xg7+v7KwCp0vPtU22jvEBmHguTgG5Usu6vJKoddsXKMapuhjYrpJodNVlmNwXY83f2lMJU2O50UP7QIlmuiAtp8Weexa6HFiXU1/RGi1s50RCvtO7k8rwanZQioh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eMSr0M09; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-47282752fc7so435425137.2
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 13:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709847296; x=1710452096; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1mAHU45iYzGHo2plm27AKfA1XRi9U3g+RWLipOIim28=;
        b=eMSr0M09R6+ImTRrW0M09IVmrh4g2slGcbigWyaJ+lK+9cnEjsYTQRxtgmHQrAc0Eb
         stqG48ckcDzCNt9CoHlW5lr38SBSiU9TLpPxTmsVDf2F3EoZdzf35pNDFBRJBQAQ9VaV
         tQw+Ht/vIAhLvLbfjaWEVl5bA0RDl6k7pvYmwKUWzpBBcA2vflnXAvD5tHYdhbZccVC2
         9fYYZ8OAPqpH6kqNXu4xTWaU+GLmr44vP3H7bWGLwt3GIn0FjHVMhmVJd8CdsbsR2UJv
         7J1gkjb/ezBDiQ3JK17zjj5ptat/w0+uCKBTv1bawv5j9zH2+HtFIl7TC19/tBetFoVN
         HzaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709847296; x=1710452096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1mAHU45iYzGHo2plm27AKfA1XRi9U3g+RWLipOIim28=;
        b=XZQeYjsmfYnz96nn4NA6AZnm3G//kuDbLMPuH7v0b42BiuD/AUvvtXeFpU+nvzi+sc
         NNL3E+UIk6Gh0UJvq8wP18QHasqyTtilGs/Z8RM2DsW7iXzZ5phngc5FdomNRkDcLpwt
         IHR4cW/TROPMKvrdWNxWG78J+pk0EmRWfdu1Gg73WAi7CsTVLCL8XHzdywa2McUspWpF
         RV8bgZJaJC9JoJejz+XyAKQEQp3/Wivbi3qN3UvbgvcayKhVb0kY+gVTOONrFZVkIIeC
         HveL1gl+k7T19KlKJwMUVqxyfNOZKAnLzkQfCVetvqFqCPJ5uZVN8071UGlmX8GnjC83
         XlUg==
X-Forwarded-Encrypted: i=1; AJvYcCXWzGzq50A7LKYGi9QiDDPv2AGvvzqXAMTAWFQKJ5Ls2NAOQchmI+zvpmSpQnVqyV6/LeuGRIb/jhcWwrkx9Mnq2JEy
X-Gm-Message-State: AOJu0YxeocxjHRpH1NMOD7EyzHW53Qt87V5caUUufhBTTyzePNyCzGNX
	Pitri402t7iiF8nl58unebSVt9g5fIhHNHi/LbILDKCsWeUkJKlg0lhUyi2+917Ztnl7Wy2DfOB
	AIgNZbVZvb7e4hbvVDcig6tyYoKCYWX2QsQ55
X-Google-Smtp-Source: AGHT+IFdYerkZWtP1NXy2kU9yZAfFtjJMGJe0JOgNEVXvauEDyOpmUwOP9++p8T1hQVmE8aoL89QEMQQEsHM8IO1XgI=
X-Received: by 2002:a67:f1d4:0:b0:470:397e:5329 with SMTP id
 v20-20020a67f1d4000000b00470397e5329mr9847290vsm.10.1709847295887; Thu, 07
 Mar 2024 13:34:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307194059.1357377-1-dmatlack@google.com>
In-Reply-To: <20240307194059.1357377-1-dmatlack@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Thu, 7 Mar 2024 13:34:19 -0800
Message-ID: <CAHVum0fVO3TbFLN5OOZdxX+Y5K3OGie+T0x603oDJPEDp7e9uw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Process atomically-zapped SPTEs after
 replacing REMOVED_SPTE
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 7, 2024 at 11:41=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> Process SPTEs zapped under the read-lock after the TLB flush and
> replacement of REMOVED_SPTE with 0. This minimizes the contention on the
> child SPTEs (if zapping an SPTE that points to a page table) and
> minimizes the amount of time vCPUs will be blocked by the REMOVED_SPTE.
>
> In VMs with a large (400+) vCPUs, it can take KVM multiple seconds to
> process a 1GiB region mapped with 4KiB entries, e.g. when disabling
> dirty logging in a VM backed by 1GiB HugeTLB. During those seconds if a
> vCPU accesses the 1GiB region being zapped it will be stalled until KVM
> finishes processing the SPTE and replaces the REMOVED_SPTE with 0.
>
> Re-ordering the processing does speed up the atomic-zaps somewhat, but
> the main benefit is avoiding blocking vCPU threads.
>
> Before:
>
>  $ ./dirty_log_perf_test -s anonymous_hugetlb_1gb -v 416 -b 1G -e
>  ...
>  Disabling dirty logging time: 509.765146313s
>
>  $ ./funclatency -m tdp_mmu_zap_spte_atomic
>
>      msec                : count    distribution
>          0 -> 1          : 0        |                                    =
    |
>          2 -> 3          : 0        |                                    =
    |
>          4 -> 7          : 0        |                                    =
    |
>          8 -> 15         : 0        |                                    =
    |
>         16 -> 31         : 0        |                                    =
    |
>         32 -> 63         : 0        |                                    =
    |
>         64 -> 127        : 0        |                                    =
    |
>        128 -> 255        : 8        |**                                  =
    |
>        256 -> 511        : 68       |******************                  =
    |
>        512 -> 1023       : 129      |**********************************  =
    |
>       1024 -> 2047       : 151      |************************************=
****|
>       2048 -> 4095       : 60       |***************                     =
    |
>
> After:
>
>  $ ./dirty_log_perf_test -s anonymous_hugetlb_1gb -v 416 -b 1G -e
>  ...
>  Disabling dirty logging time: 336.516838548s
>
>  $ ./funclatency -m tdp_mmu_zap_spte_atomic
>
>      msec                : count    distribution
>          0 -> 1          : 0        |                                    =
    |
>          2 -> 3          : 0        |                                    =
    |
>          4 -> 7          : 0        |                                    =
    |
>          8 -> 15         : 0        |                                    =
    |
>         16 -> 31         : 0        |                                    =
    |
>         32 -> 63         : 0        |                                    =
    |
>         64 -> 127        : 0        |                                    =
    |
>        128 -> 255        : 12       |**                                  =
    |
>        256 -> 511        : 166      |************************************=
****|
>        512 -> 1023       : 101      |************************            =
    |
>       1024 -> 2047       : 137      |*********************************   =
    |

Nice! Whole 2048-> 4095 is gone.

>
> KVM's processing of collapsible SPTEs is still extremely slow and can be
> improved. For example, a significant amount of time is spent calling
> kvm_set_pfn_{accessed,dirty}() for every last-level SPTE, which is
> redundant when processing SPTEs that all map the folio.
>
> Cc: Vipin Sharma <vipinsh@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 81 ++++++++++++++++++++++++++------------
>  1 file changed, 55 insertions(+), 26 deletions(-)
>
Reviewed-by: Vipin Sharma <vipinsh@google.com>

