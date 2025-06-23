Return-Path: <kvm+bounces-50391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3581CAE4B4F
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:46:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C146617624F
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC481279DC5;
	Mon, 23 Jun 2025 16:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C674cHVi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9637D2571D9
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750697205; cv=none; b=cVE5lsizTgtsKDdA3QUWA4VcerzFeFk8LHH28ohO2Etcau60r9j1PH3I+Enps3QPUIKC7Kbt0xqXye5Ofx7fZliadqo1M/Z504gvq0jv+x2qwTIJ6JuGbduEVhn1lxtWfyGYmm4I2b1ydF3kPfETTYLUTpmslGYDIe6om9pc72w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750697205; c=relaxed/simple;
	bh=PTkCH4bY0/JrT78kPVp8u6zIyFxZdruXqxwb9NjROfM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sOC4bJ3Ls+rG7WfIgqI3pXcHzKuOP64kBUE2B+od1sTJdCZtMwlDzbmc61OX2AyDguB5lp2fnr2oHwEfW443FtE/gBvjG/R6qWEBoKHWbt5j22dbiYzM7IPopo47MFCb7QhmYp57r0yhAIskeOr0kKPWq1T/Vquhk89QoPUjY5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C674cHVi; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138e64b3f1so5456629a91.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 09:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750697203; x=1751302003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7lKL+8FPzXbEzHdQK18UrqhFoWyJyqFhk5D3NzvCiSw=;
        b=C674cHViHZ3L2kC53vq2jVkNs9iPXHkJonvPLPpQyx1p51AIEe9XAyP/20aToX7kiG
         TSOR8jXR//Ow9sS4d6u0fIhA8Qy8YauJ7FbQDP6kiC36qdZ4V7TmQY5IqG5K8D398ZnS
         ln7NbifPB1XmIVIExx8jgXVRbrWCCYEZi1s71MA5tUw/NX+ajdWQFQtGXj++sPRrdXKI
         7PLDkoKVtZ2DyXGj0VdfmfvS3cTuHbsjWmNG2wCAZ6ZAgv9XZ1RMeZyH2fsjnCAp0nQC
         j+UKgDuWb4KoFmome+fwadsDytI3cmAaJefejkt+efTamY9QBUt6rXYZYP00cLG17NF1
         sSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750697203; x=1751302003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7lKL+8FPzXbEzHdQK18UrqhFoWyJyqFhk5D3NzvCiSw=;
        b=HQLrFrPjiAG7AsvmpBx2C2F5G5GFU9kpS01OVaP1qOTO/zZeCkEm/KvMxArbOT+uiE
         y1KLzdXzN8Z87ngjcJ6EDf4FPQ5CAoaTmlJaWKyWDy8wDc9V+M+kao0t35bRuFLtvWNg
         qLX4syJHPWv66XNjG/04ogvEssEuyEUi4xrKuGLy/OlwbbaXmVV7nWcy5aiMqZwP2i58
         nWcXXmx+LbbPUBuvD5bTt9sJBFQqYCqjPhdkjpdmWgC15wmQyaxXxbQohilV6lJzaTle
         YLtkGP32tiQ+MzW+C1y/vtqCw1qtjD7uMTrYnLwgUsu84MCZCtd2gRP4dhqjQ5pkrB8E
         XKkA==
X-Forwarded-Encrypted: i=1; AJvYcCUcy78TuBopCUDjQO9F7j7xbbouQI+cRgbW56cCV24/YqGoHaGlr29B4cUx6ZbO9d6ow4s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX051FETXj+YbvYkpWBQn57Uth2AQMzaiOLAvIvoGZvsjky10A
	8eZVIW/H4K2Pg9/is4VzNP3o1rQxryvio9e04roLIn17GhAQrzCKDZUw3+ZOTOmUL24j1gtXv25
	+AivErQ==
X-Google-Smtp-Source: AGHT+IFqQcKBEffd+/bm/pwSMxSA4pUyJvWSuTZaRbFIA4d7phi69ClHdBJaop2cLRhGg1gLy3XueS/nDgA=
X-Received: from pjd11.prod.google.com ([2002:a17:90b:54cb:b0:314:3153:5650])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d64f:b0:311:f684:d3cd
 with SMTP id 98e67ed59e1d1-3159d63d9e7mr24601590a91.12.1750697202941; Mon, 23
 Jun 2025 09:46:42 -0700 (PDT)
Date: Mon, 23 Jun 2025 09:46:39 -0700
In-Reply-To: <20250326193619.3714986-4-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev> <20250326193619.3714986-4-yosry.ahmed@linux.dev>
Message-ID: <aFmE7-osX2rmdGL5@google.com>
Subject: Re: [RFC PATCH 03/24] KVM: SVM: Add helpers to set/clear ASID flush
 in VMCB
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Rik van Riel <riel@surriel.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 26, 2025, Yosry Ahmed wrote:
> Incoming changes will add more code paths that set tlb_ctl to
> TLB_CONTROL_FLUSH_ASID, and will eliminate the use of
> TLB_CONTROL_FLUSH_ALL_ASID except as fallback when FLUSHBYASID is not
> available. Introduce set/clear helpers to set tlb_ctl to
> TLB_CONTROL_FLUSH_ASID or TLB_CONTROL_DO_NOTHING.
> 
> Opportunistically move the TLB_CONTROL_* definitions to
> arch/x86/kvm/svm/svm.h as they are not used outside of arch/x86/kvm/svm/.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/asm/svm.h |  5 -----
>  arch/x86/kvm/svm/nested.c  |  2 +-
>  arch/x86/kvm/svm/sev.c     |  2 +-
>  arch/x86/kvm/svm/svm.c     |  4 ++--
>  arch/x86/kvm/svm/svm.h     | 15 +++++++++++++++
>  5 files changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 9b7fa99ae9513..a97da63562eb3 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -171,11 +171,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  };
>  
>  
> -#define TLB_CONTROL_DO_NOTHING 0
> -#define TLB_CONTROL_FLUSH_ALL_ASID 1
> -#define TLB_CONTROL_FLUSH_ASID 3
> -#define TLB_CONTROL_FLUSH_ASID_LOCAL 7

These should stay in asm/svm.h as they are architectural definitions.  KVM's
headers are anything but organized, but my goal is to eventually have the asm/
headers hold most/all architectural definitions, while KVM's internal headers
hold KVM-internal stuff.

