Return-Path: <kvm+bounces-30784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 350A49BD54B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:50:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E09991F23E7C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4E31E9082;
	Tue,  5 Nov 2024 18:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lIiA33qV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735DB1E766B
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832397; cv=none; b=QFRKN6i4+8bvxWxP3mz9zQdyYE9IuUU0dPktZhWh3BsNb4RYkAuTXhkBZQCOKURp7Y3kZFJGUqIXyHddqec0fgqgsI4kdZQSfBNl5dCmLj+wCd/NTvCKruokwGt1fwbK77Cyc56e5rilChpetTuxP8HtMbeyLOQ/RW97XLsqNUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832397; c=relaxed/simple;
	bh=1i0FOvF50T0Ef1h1llr2gxoNkv5HMssajoroaqVaToQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BS6f6kFDCWkywpVT/TWxyYvbt7qfR4Hv4Z8Ff09FAUNfoEk2mpgjAVBIeQ44HEY1IBsp31yOm9tvD3GV+M7mA3k8JR6jagoaJ7GJ/0FnPM3YsMAWGz8yab5ZWzPEbu+jrFynPr9ZJfTgi8Vq8tm7WMM/h5NUPKoXVNt4hEHbs3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lIiA33qV; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-851d6c397bbso1844901241.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730832395; x=1731437195; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1i0FOvF50T0Ef1h1llr2gxoNkv5HMssajoroaqVaToQ=;
        b=lIiA33qV0Btj/YODpuLYlteuSRrgcTREUq3vXLY2hmsFnB7G92luSsAD2DAl5SjPb9
         p+bcEfvkT8WkmuQLPcKGwUSx7gb/rK+AANcw05CdTjPHZzFjHDz+DZHe5ZsM2cDOTr9b
         IFU20bvPtIKrYZ9bkazfHTXU2y7ipku7JExnI2F8E6AGtGVj08j9NmCmJVgK6EGtuAsf
         tOp3F5QnJtOcdbJ9OiFvjaR2PIdUq5VQyo5cpGw6nPkfjgPM2p9LTKiTKbJu+7DKSrr4
         +1xlPa+PKyoqT+M1b4DJIZQbXR7bnwnPGOgGa3lGGctXRXDENRowwrSPtMpHIcQPDaX6
         /rmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730832395; x=1731437195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1i0FOvF50T0Ef1h1llr2gxoNkv5HMssajoroaqVaToQ=;
        b=Ln9X1VuKRPSDtiNQdMOXlJcthkSjXVB4NKTzWlOdHMd6zdxs4vwLevdjSAgdYBIx2W
         9hrVu+bHq24pWPMRatApNKGQt0FAXAPS8b8e4gixwL9TfY4sNLTknXUcIF+I7efvrL9E
         4bKql3g7i3ggSsHJqwUPdmlh7W7GPV6Hdl9YdGmDg13qXmyxkojCE5a84ClXRmQx1XrM
         kvrDRaEp+8vOqHHG9bBGMiBTgghYD4EOFPHunJA+6r3CRp9Cz1aI58UvXhdX7fYM079e
         gdbz6Zw99EIMWGPLWyS4khq3+OSYokMHxEfOLuKRbTY6yxBaGWptJ4ZhCiPL0lZnWvUx
         p54Q==
X-Forwarded-Encrypted: i=1; AJvYcCXXQgPhwdVUkpRbu+cFhS3XELUE6Io+xCcDxtQCIcEbbFN2bdfspF3ff+DVQJZoerg4EgY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRrsDV9Gmaon6GBfcmhj26nWViemuKGVIssVr8uU0qcctzsXW/
	rcRmguDOeKfN8++P/RJ/Gp+rVwK36fmXJU7vqJOv/zkPFDs4lL7G9WSn0Yk1irDDaSwp87Dgop4
	Wk8/HRtngKqf4jb2dt87x+0LTWlc5ULXkUN5g
X-Google-Smtp-Source: AGHT+IE5LMdjcCy1ZrhtEovdAaMKmDaAnpFBy+6eJLHbVFX2T8VCFH6X0K4CF/HvkRQN+qJETH3XEBaX1WHT/QzlmFA=
X-Received: by 2002:a05:6102:3e8d:b0:4a3:ed09:4746 with SMTP id
 ada2fe7eead31-4a8cf9d011emr37527002137.0.1730832395065; Tue, 05 Nov 2024
 10:46:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-4-jthoughton@google.com>
In-Reply-To: <20241105184333.2305744-4-jthoughton@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Tue, 5 Nov 2024 11:45:57 -0700
Message-ID: <CAOUHufbGVyjfxZugixtA1m4ANkei5OUvcvgNFuODjUJmxUQsMg@mail.gmail.com>
Subject: Re: [PATCH v8 03/11] KVM: x86/mmu: Factor out spte atomic bit
 clearing routine
To: James Houghton <jthoughton@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 11:43=E2=80=AFAM James Houghton <jthoughton@google.c=
om> wrote:
>
> This new function, tdp_mmu_clear_spte_bits_atomic(), will be used in a
> follow-up patch to enable lockless Accessed and R/W/X bit clearing.
>
> Signed-off-by: James Houghton <jthoughton@google.com>

Acked-by: Yu Zhao <yuzhao@google.com>

