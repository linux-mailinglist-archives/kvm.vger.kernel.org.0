Return-Path: <kvm+bounces-66034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BDFBDCBF90C
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6BA0F30184E7
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB6725A2CF;
	Mon, 15 Dec 2025 19:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4FFU6wXB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA83C22129B
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765827484; cv=none; b=qriP2OKPaK5raO6eUvA04dixhQNF3FkmAm3f0HIRHZz7W5AF7/wlsvXejLTwh4L4xtwqHvC+YFvLdADlwH5kot9KzoTl/16+Af/86xsn5UUNSibElqODjeghfvXoOcex8aEqsGeMLHIMFbFBben60MaV0+BhlzOrdX3YCLBweHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765827484; c=relaxed/simple;
	bh=QSVCuDZHeXlv5qRq1cwLUzWtmhl9PphTRk/SWKQ108E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q+6m/8wZ7BPTgq1+z7GjI2iVvaqjCvFUJIoON9ViRMzL7VcV5+mr65Bmg9JR0Uih/pcwz3B1x8g9Gn23o5+25FdpWxvackG99b1syxd16M24rAMTIYCDNtk7mG3OHS5QILYySJ/Q7t+0F7tMsxA4fJ4K3aQgsoiF6aPtMKkrTAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4FFU6wXB; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c6cda4a92so3489915a91.3
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 11:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765827482; x=1766432282; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DKjoJyRjos7coqbgkgOB5Xmzn+82ea4/Olyic+3yMeI=;
        b=4FFU6wXB4mYlu0wU1D8pd5JZ8XrF6QZa65bb+Dps9aKVxdC30MfOfu8tXtsW/bnpHU
         xxH1uOx2Sf/Gfv1JRa7E5z3BZFZVOKsCyWd1LSc5WZHr+jkuxyAByoBmbsZRWxmlyJyn
         bYbvkUxzQ5AZ/ABrZ7T8+wSiTvGvxPZm/sI0u1KAHwa9sGELfXSRJDBvRVQe37Q8NpzF
         DJc5jkh8Kl9dNSgIB9ZgbX0G+E+Kk2mlNIxC+LM5adB93w+38lzYactfDgxB70fWfx5N
         g6GUbIHSqB6R7D0LJGuCRlKvA+obXPUF6aM2oRpW3v1JhifHEOo/t1d7R3UtIf5f6jd/
         UliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765827482; x=1766432282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DKjoJyRjos7coqbgkgOB5Xmzn+82ea4/Olyic+3yMeI=;
        b=mf+9Hml6G3Zf/XcoGXRmO0TCRbDD+RlEmX+t6aoYL4qDwPqkG4uS2iNd9ym23r4b5l
         NW4EzrnZcWcinqyLhcLrvinSvTO0DD1a/Dbel7ah1rl4JskJBuzfccREd24b4Eh+jNDc
         NW9oeypGf93KCB0xVMYhh5wDrVB+Wzec6qLdDINR8KPy2YfxA6nGAhg4oGipkHrELRLO
         V+fL2GuY2Vk34gCdwlY4Dw/Vnq2RDSMz29SoBvVJyke6V9G0CLpDI8iK/PPhmZg0ZpJP
         pp12oR0m2eNuDaVXQOknzGqbdQrdgnwI9UMhb9U97oSyxa6Dyf96LaSR55r4tVlhNGPo
         yD4A==
X-Forwarded-Encrypted: i=1; AJvYcCVSxSXiQqnAynKRgtKr+5cO1iX9n+VnDTLkni1ftmIWisAHBVFu4at2JkcUCPosKo61cQM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpwzUpCWy+UK2rsPsTIJCWfX7wukVMTMMFStdfsqxhlhLF566O
	IHi1HkURIZWlyh2wlkhCEx2/ggnuG0H3E6dtaT1w7yF+ru7xIPgvNWLSienC7i4sdWhSG2oS6bG
	Ewz4CXA==
X-Google-Smtp-Source: AGHT+IHit10ZHn9UY8WNy/CzbinoH55sfpFrNDcKrt3yEBE1gwmZXOnkKtIYr9huTvRfD3JmRO8fKHX4RDM=
X-Received: from pjbqc2.prod.google.com ([2002:a17:90b:2882:b0:34c:489a:f4c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2684:b0:340:bde5:c9e3
 with SMTP id 98e67ed59e1d1-34abe478030mr11650081a91.23.1765827482112; Mon, 15
 Dec 2025 11:38:02 -0800 (PST)
Date: Mon, 15 Dec 2025 11:38:00 -0800
In-Reply-To: <3rdy3n6phleyz2eltr5fkbsavlpfncgrnee7kep2jkh2air66c@euczg54kpt47>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev> <3rdy3n6phleyz2eltr5fkbsavlpfncgrnee7kep2jkh2air66c@euczg54kpt47>
Message-ID: <aUBjmHBHx1jsIcWJ@google.com>
Subject: Re: [PATCH] KVM: SVM: Fix redundant updates of LBR MSR intercepts
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 15, 2025, Yosry Ahmed wrote:
> On Mon, Dec 15, 2025 at 07:26:54PM +0000, Yosry Ahmed wrote:
> > svm_update_lbrv() always updates LBR MSRs intercepts, even when they are
> > already set correctly. This results in force_msr_bitmap_recalc always
> > being set to true on every nested transition, essentially undoing the
> > hyperv optimization in nested_svm_merge_msrpm().
> > 
> > Fix it by keeping track of whether LBR MSRs are intercepted or not and
> > only doing the update if needed, similar to x2avic_msrs_intercepted.
> > 
> > Avoid using svm_test_msr_bitmap_*() to check the status of the
> > intercepts, as an arbitrary MSR will need to be chosen as a
> > representative of all LBR MSRs, and this could theoretically break if
> > some of the MSRs intercepts are handled differently from the rest.
> > 
> > Also, using svm_test_msr_bitmap_*() makes backports difficult as it was
> > only recently introduced with no direct alternatives in older kernels.
> > 
> > Fixes: fbe5e5f030c2 ("KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> 
> Sigh.. I had this patch file in my working directory and it was sent by
> mistake with the series, as the cover letter nonetheless. Sorry about
> that. Let me know if I should resend.

Eh, it's fine for now.  The important part is clarfying that this patch should
be ignored, which you've already done.

