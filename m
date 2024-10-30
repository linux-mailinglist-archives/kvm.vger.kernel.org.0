Return-Path: <kvm+bounces-30116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7AFD9B6FCF
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 23:18:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D5B4284B36
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 22:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559E52141A3;
	Wed, 30 Oct 2024 22:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Em372dfz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705791946A0
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 22:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730326720; cv=none; b=mkFpMdKNeHn4WNTy19/L8AesISY5Pt9Oylh5bzEZdFBOqGVbp+kSDutMD8iCWfUI/2GSUtMOlU23E9VUI60WtynWGaCLXgfxEkYUiDos6KbHSwlqqOPVp9ysGz68rawDCEsUV9YS+qfmx5Fgr3uAjhvLDaYdXnUtIaq2rmBpaFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730326720; c=relaxed/simple;
	bh=ATUKPegUcqo8YgRnCQbayM11NO//DrT2d618hoaV2QI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IR799GXUEQW1+OHuJrQojtaRwVD/JB1B52/+gCVNBIzf+tkZIYgXh3H54y8BjD/Rzmwnjdn0eIYLmHC4tuiwPE6CuWdqcXRnzQN6SOjhDcwbLms404eqcppsf03lC6eB049KwHwj548w5AyWi/4BMMtPVq0SuDqG+rXYppWreII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Em372dfz; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43150ea2db6so49455e9.0
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 15:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730326717; x=1730931517; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ATUKPegUcqo8YgRnCQbayM11NO//DrT2d618hoaV2QI=;
        b=Em372dfz+qC7D98LFYu1bsMVZoA5WwTEi9653N+xQpkFPV9vsLbGyzYrexb1OmcXg3
         TIaev95dbT70bqBvMPiADH2RfA1rv8PatmBsT1w1v48+gdO7vYcjdaToSRf04ehd6zX9
         RDgcNlES2otPZBCw6jmQrpMKmxYgYWhz8fc2KuCYZC7wwM9fYYi9XUF4R3hxj3z6Fd5v
         OOu/+mFyNiSoSqgRBpKhjzkrJRtxslw8F4K8VPbTN83FVoyyDH3zDlZn0vGmZ3f8dFqW
         N5KpvzIpguV6QvzlUeCD/0UGuyRFJfIYwM8hkvnAIOVM6Z538NVx8jenIs3SmxLYK7/h
         ubaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730326717; x=1730931517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ATUKPegUcqo8YgRnCQbayM11NO//DrT2d618hoaV2QI=;
        b=voctF+Ruk/S72NTeD0IO89Ivn0jFvMbCGtfeiHK6mE38ANjtxIJ6OcXkrNAKmviEkL
         t01JkXNjKTJv3IHIDnu81Bx+RJVNhLHJq2IONK3YLCflFEaLyilzkPJ8Wbhc2bUKZQFE
         dfj8B+FtvS/ALnhciofdGNlod885Ta+wwY+O+LluMnIUQj3gv7W8mnqSvU0UngccVXvT
         MQuhLF2yNB6TO/ica23K9I/8Ohm92fQLtiMBEWKdKIehDZ85G6YvPAIHnE21dXeDwVgW
         PlGhrdZZJJ5AyOEq27ApCaRby9yMzVq1Y7Fs1G39rYtrkNozRnsD3QirPgEdpfuG89So
         JXiA==
X-Forwarded-Encrypted: i=1; AJvYcCVAK6qCysP9ozsFCejTH3XIgSZxYAN7QC9tAGCvJLPI9hWDcrPfsgvTevLoPueSEA1icAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YylzA4Fm8LKTGw1yLb1V4K3Gt6BKxf1ja4K6CRwTXusxK+EEcHQ
	5VlA9NLXGRo0uKhTNEAV6FTRk5Di0h0obJ4y7TB5IKO8QvVSWA/NXIRc8XrQIYswyAt9vJ19RJ4
	rq4eVMOxqq8rvn4zv/1fiaNMcq6vM5/bE7s9K
X-Gm-Gg: ASbGncsUjRQYkmrH7BwTUEN+G+qmgMz5i2+sQbYLjXWQMbDb12QgnYMJC6VSVfDSF/u
	aasx726gKZkfxjRinXrViMYM/KjWe
X-Google-Smtp-Source: AGHT+IGgBxG9itQN01XAI+q7Fq91bG06PVTigFgOg09wvSOuCtpqcUewGTf7vCbKMXJrOM8i9YvEy2dObrXwLiwtf/4=
X-Received: by 2002:a05:600c:3acc:b0:426:66a0:6df6 with SMTP id
 5b1f17b1804b1-4327bd7e197mr1792485e9.0.1730326716591; Wed, 30 Oct 2024
 15:18:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240805093245.889357-1-jgowans@amazon.com> <20240805093245.889357-6-jgowans@amazon.com>
 <20241029120232032-0700.eberman@hu-eberman-lv.qualcomm.com>
In-Reply-To: <20241029120232032-0700.eberman@hu-eberman-lv.qualcomm.com>
From: Frank van der Linden <fvdl@google.com>
Date: Wed, 30 Oct 2024 15:18:25 -0700
Message-ID: <CAPTztWYZtO6Bfphdrfr6Pbc-v4WAgCG+iCJJK26aS1f1AdNbVw@mail.gmail.com>
Subject: Re: [PATCH 05/10] guestmemfs: add file mmap callback
To: Elliot Berman <quic_eberman@quicinc.com>
Cc: James Gowans <jgowans@amazon.com>, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Steve Sistare <steven.sistare@oracle.com>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Anthony Yznaga <anthony.yznaga@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-fsdevel@vger.kernel.org, 
	Usama Arif <usama.arif@bytedance.com>, kvm@vger.kernel.org, 
	Alexander Graf <graf@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Paul Durrant <pdurrant@amazon.co.uk>, Nicolas Saenz Julienne <nsaenz@amazon.es>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 4:06=E2=80=AFPM Elliot Berman <quic_eberman@quicinc=
.com> wrote:
>
> On Mon, Aug 05, 2024 at 11:32:40AM +0200, James Gowans wrote:
> > Make the file data usable to userspace by adding mmap. That's all that
> > QEMU needs for guest RAM, so that's all be bother implementing for now.
> >
> > When mmaping the file the VMA is marked as PFNMAP to indicate that ther=
e
> > are no struct pages for the memory in this VMA. Remap_pfn_range() is
> > used to actually populate the page tables. All PTEs are pre-faulted int=
o
> > the pgtables at mmap time so that the pgtables are usable when this
> > virtual address range is given to VFIO's MAP_DMA.
>
> Thanks for sending this out! I'm going through the series with the
> intention to see how it might fit within the existing guest_memfd work
> for pKVM/CoCo/Gunyah.
>
> It might've been mentioned in the MM alignment session -- you might be
> interested to join the guest_memfd bi-weekly call to see how we are
> overlapping [1].
>
> [1]: https://lore.kernel.org/kvm/ae794891-fe69-411a-b82e-6963b594a62a@red=
hat.com/T/
>
> ---
>
> Was the decision to pre-fault everything because it was convenient to do
> or otherwise intentionally different from hugetlb?
>

It's memory that is placed outside of of page allocator control, or
even outside of System RAM - VM_PFNMAP only. So you don't have much of
a choice..

In general, for things like guest memory or persistent memory, even if
struct pages were available, it doesn't seem all that useful to adhere
to the !MAP_POPULATE standard, why go through any faults to begin
with?

For guest_memfd: as I understand it, it's folio-based. And this is
VM_PFNMAP memory without struct pages / folios. So the main task there
is probably to teach guest_memfd about VM_PFNMAP memory. That would be
great, since it then ties in guest_memfd with external guest memory.

- Frank

