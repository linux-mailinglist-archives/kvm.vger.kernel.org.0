Return-Path: <kvm+bounces-34600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8901A0264C
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 14:12:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67B6B18878A2
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B5E21DE3CA;
	Mon,  6 Jan 2025 13:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q1HOeQkF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE76B1DB92A
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 13:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736169050; cv=none; b=VBffBgiZKTtiukBa7b74A9r+u/uYvWyFj2+d6YhiZO0Pl9rOVAZ/xle9oAo9qU22UausyS/z3jULzZMj5vvStV5WTCX66cv+vNC6+ENkFRoNdtF7wu10gm3nxhr7mG+lAxS3d9eYJWxs1LsTPJopuAzItwwfjp46YXxnbI1ghfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736169050; c=relaxed/simple;
	bh=Y2/skVBTqhd4oLklzEFskLFMUMvllpIbud1I2WS39gc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kQAephjggPmnbOCNIqdjIVTYktklfqWWhtNjchIQJ7c2oUW43ZtKKEWOy6M88VuJGtn2SwgMUVFeFld9NbCuc+r+RGyAJWfTCvC7gE9q5pCMLfMD2GFcZvhzKLSvCSRQjFULOJOuau/bShS6cSArelnWVmEM9ZVtiFSXYznd2mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q1HOeQkF; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d3e638e1b4so9365a12.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 05:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736169047; x=1736773847; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2/skVBTqhd4oLklzEFskLFMUMvllpIbud1I2WS39gc=;
        b=q1HOeQkFFfC9sjNQtXpmvrZZbDIwmqk7VkwcFy4FP9Jdz0Aw7btniGC4OUZtEEMajE
         8+fYRcRrb+57W4+4BS5HxRpUtody1Q+3Rl2iaXQIspLyjRWHBYxG95fmJkmx3Msx0ig5
         ofE7TIVZSPr2PgFOtYpStWuDx0+gBAuQA/oqLPwUWeTxw7DUdt6jVpUOucg4Q+QEzpcm
         e2pA8uXNpPjfHYE+SCokSVkiij5czyF7d+M2NUMpRLoJ0CAul7DdQQZpO7yEJGGs0UOg
         hCQ7PgkuZ4/oRa4Wxgny+IZBqtdnRhYs3w8VMr9gAcGbi20Lw4s9y5g/NAX3QkqSxQsk
         aDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736169047; x=1736773847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y2/skVBTqhd4oLklzEFskLFMUMvllpIbud1I2WS39gc=;
        b=UYebqVg7iuBrqs3LIwbXY6XdqLiQUFbvTrQD5OZNicy376nvxHtvUGq6jmMXtXkdQt
         RmUeIZNo9ZYlTH6ZnvxYplpMdsZdgfBncrSFegbo7PZOKrszXLaAUTug5xeJ3uMELFT4
         fafcMhh7ikPrTH2dilBb1/UYJUaai7sI+x5pM3O4kR3LjHHGF7aYY2wD7TDzLfSFg3/1
         wXH6uzrGf+D2mYmW2plcLBH1XUHwa96z7jm9eKo6WmrdZ7lPnU/mx3fWdROI1j2648aJ
         +X+9Sgv751nJJy+Csf2dB8gWzOO2bFrARp3yUiqyHRrVM7Z/A7PvO68L6FGicl8r+zb5
         xLtg==
X-Forwarded-Encrypted: i=1; AJvYcCUfqXA2Laku8N2RzCKSlS6oAHjp/6cquFuRnlUGM4MGwHMc57Xoml30PWkg7W+dZtpdewM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUoOvv+pWorksJfMNQ7vx0NlKLJf/g9F/4PzBIpqd1l6xqb6dE
	sIztJjfFPCdVzPtXmqg4uCuirvhaASqLaYK9TKYv8iOmvj4FZp5IT0bKJbRelL3QwD0O5DZ6R48
	QYl8KtXtmMne1apUhA8/2jY2kNoZMytVIWbUr
X-Gm-Gg: ASbGnctp1IdQkXat2UM9CNsYVM9zI3XdbtuNxMof3gKyrceMKcAyjDH6GrsRNg/z6xL
	1v71t+iXkmH9GKyt9+GZhDWhzXURCm8Cn9qOLK21WHXdmoNUGb2SL+AaXbtNgc11Unw==
X-Google-Smtp-Source: AGHT+IEqowVMRHCVf9ZXb1dAIIluQ3OxhsYIVJjNkQnOdq9SrGz80N4cYCOuRdXFwKizwobQGPVJK2P5N87bSNQD8gQ=
X-Received: by 2002:a50:d79d:0:b0:5d0:eb21:264d with SMTP id
 4fb4d7f45d1cf-5d92bc4a158mr88175a12.1.1736169046950; Mon, 06 Jan 2025
 05:10:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241230175550.4046587-1-riel@surriel.com> <20241230175550.4046587-12-riel@surriel.com>
 <CAG48ez1nW7a+cHa4FDrri4SEZOWby9HbW+81JW7sY=CLZt98Tw@mail.gmail.com> <287e8a60e302929588eaf095584838fa745d69ac.camel@surriel.com>
In-Reply-To: <287e8a60e302929588eaf095584838fa745d69ac.camel@surriel.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 6 Jan 2025 14:10:11 +0100
X-Gm-Features: AbW1kva4ADdHVc-5wPKzpkJujus02xjPTKRKUxwJFcEYqAfE-LgD_XoqhrOBLng
Message-ID: <CAG48ez3aLwOW+jpJbLB-vXGudLQnDLCYs=Ao3eNikv6QiTc1Fw@mail.gmail.com>
Subject: Re: [PATCH 11/12] x86/mm: enable AMD translation cache extensions
To: Rik van Riel <riel@surriel.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, KVM list <kvm@vger.kernel.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, 
	akpm@linux-foundation.org, nadav.amit@gmail.com, zhengqi.arch@bytedance.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+KVM/SVM folks in case they know more about how enabling CPU features
interacts with virtualization; original patch is at
https://lore.kernel.org/all/20241230175550.4046587-12-riel@surriel.com/

On Sat, Jan 4, 2025 at 4:08=E2=80=AFAM Rik van Riel <riel@surriel.com> wrot=
e:
> On Fri, 2025-01-03 at 18:49 +0100, Jann Horn wrote:
> > On Mon, Dec 30, 2024 at 6:53=E2=80=AFPM Rik van Riel <riel@surriel.com>
> > > only those upper-level entries that lead to the target PTE in
> > > the page table hierarchy, leaving unrelated upper-level entries
> > > intact.
> >
> > How does this patch interact with KVM SVM guests?
> > In particular, will this patch cause TLB flushes performed by guest
> > kernels to behave differently?
> >
> That is a good question.
>
> A Linux guest should be fine, since Linux already
> flushes the parts of the TLB where page tables are
> being freed.
>
> I don't know whether this could potentially break
> some non-Linux guests, though.

