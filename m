Return-Path: <kvm+bounces-27865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AFFC98F7DB
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 22:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D70E1C214DC
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 20:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39E81AE879;
	Thu,  3 Oct 2024 20:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j7tqYcVV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EAC7711F
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 20:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727985968; cv=none; b=jrtnqsdznQ2IclkEsmsu7cj3h6WCtvORIwSF1wlltgeA3kvUm4W/KL3Wm006UM6LnKa1XmuW8EvV7lm1fNM/ZaCTlKKaiJv5KrTi2hRPih1yyvBKvhgat2BrY4wyY8QUo3LQHOQlG4KljYqrJ4NyXqVRVBHqBeMwQ5QNliY/IK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727985968; c=relaxed/simple;
	bh=hSUWgNV185nneWzES4OzK4vK5Eea03Ph2K2/JhNMW+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lt1BOmoN1e80duzeUouz5rly+1/i3hVt2GSBgs2CbM0WDQ/UqwALqVbt/Y8tjKRz7S5njiMAoUzUYryFPusXb/Cpl+7OTI8/rEertiUMaFzSLfehij9OoI+npOnX4nRed29JDaH4/Um+LVE8gjbnqf7FZI1oNBcdecbuQ44AvTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j7tqYcVV; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e28833f1c31so829726276.1
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 13:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727985965; x=1728590765; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHzI9kibwBGfbX+u9LfgG392Bz0yBO/FrADznXjpfXo=;
        b=j7tqYcVV3x/XlKQt4Jrfe6glfAkoAUeui0hIfdxsK9C6OY1DNRxjcxTIrRHfCmC4HU
         DMFRDFowt6izwr868bjssZK13KpWkILt+iEfCI68S4akc3ZDYG7yrQkKSR8PhBY/GTGp
         PKVP8diE+qMPB/s8L2HKb1w2//jHthg/mI/QHlQKozaziyigN2zH7wf7FnC0cZREX33F
         TjGZauupae3PRbZ+3RR8Xc8QN56z3kIq1L6rjrBnBlJE6sx9TWsLXafk4Yzr2SCyy4yI
         ghTbmYhvlW2KLfsgrvMeco3oPU7SRaDBSWl++MLq/eArkXUYU0sekXLnwKWi0l9xt55R
         kB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727985965; x=1728590765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHzI9kibwBGfbX+u9LfgG392Bz0yBO/FrADznXjpfXo=;
        b=wNkSW8fdAjkrTc6KU9y2xV5fZHrprggsEFrUk3KKC5tqqOsNquV3Nt6SJICAPxN4BV
         IZKmg3yBkGo4lCZLMBq/UPUsq9GSqpNyYa8DnbA8X5fUYgsd2eAw0DdF3QRc8UcGMZyg
         PdaEom2+cNE0YVoQOup0ukNzVqkQbRlokkb2H5Hozog+DA4ucHMwyMZ8JOrKbxRLBND1
         iYXn87Ska6Astnfa+N8ehNSnY1DzG4mvg4YB+ZXj77xEFGg5JcBldCgCB+FknZ7GILJL
         miJnIJ9/4WD2qHdB4RPabJUpljFlSA67ycxShgy42FEJ1Qx1YioOiz68LJsAJmnypjmy
         Gg9A==
X-Forwarded-Encrypted: i=1; AJvYcCVUwqXkWl+VLE+SBEhuyiwpFvEw5nTDL/tXO0Zpi8Q2wD+d2neJbp/aPJlvmQhGyszxWP8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJtifnIYSQ5ocVWRyzIYncwOaFTL4h/LACHfTduwgfcjqC0gRP
	qBdI42soXU51IP2tHMiSmF6LX6P3zTbFpecQumfVZZRvTXuS9C/jlw2+vnEIpmvjeg8RjlQt+Yl
	Aoj1TE+hqTr2b6q6HgGXzREPreYrTlPIQA/ny
X-Google-Smtp-Source: AGHT+IESiGJnMtl1gZFqJRNktO5r59aOQQF1KKLqhp/PZ7O+Nz98cRWkE2b6UlCPgSskCbDZSVsRWB9LF8R5tSuAhAA=
X-Received: by 2002:a05:690c:60c2:b0:63b:ba95:c8b3 with SMTP id
 00721157ae682-6e2c7c16a00mr3687097b3.6.1727985964764; Thu, 03 Oct 2024
 13:06:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com> <20240926013506.860253-5-jthoughton@google.com>
In-Reply-To: <20240926013506.860253-5-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 3 Oct 2024 13:05:28 -0700
Message-ID: <CADrL8HX5WxpRD98rQkBhVQo0asw_c9VOwk79OJDWqzRDmkoX9A@mail.gmail.com>
Subject: Re: [PATCH v7 04/18] KVM: x86/mmu: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yu Zhao <yuzhao@google.com>, Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 6:35=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
> @@ -70,8 +70,6 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t spt=
ep, u64 old_spte,
>  static inline u64 tdp_mmu_clear_spte_bits(tdp_ptep_t sptep, u64 old_spte=
,
>                                           u64 mask, int level)
>  {
> -       atomic64_t *sptep_atomic;
> -
>         if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level))
>                 return tdp_mmu_clear_spte_bits_atomic(sptep, mask);
>

This delete should have gone in the previous patch. Will be fixed in v8.

