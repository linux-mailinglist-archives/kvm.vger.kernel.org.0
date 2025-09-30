Return-Path: <kvm+bounces-59196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F45BBAE23C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3EB8326D9A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B91430BB98;
	Tue, 30 Sep 2025 17:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C0z5F8RY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B0B14D283
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759252229; cv=none; b=DPqAgYAsLy4fvamrTr9BR6GnhL5gu0L52otx6olNIHlbjkpb9wfecTlOeNKjKsxi5k7Pi1zr4VDeGgq2P8Z7wnwRxgQgRu4sit0fm3gM83NFwdgAaDDEeyVfgXhicmVVAnRgCduCZJmFI8GP8u8ofZ81UQdXhpJlpSks4xymtKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759252229; c=relaxed/simple;
	bh=l/9vQOja52zWGr2SV6BFIwB/eAZdivVGNlNimJSrUyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T8n0FIdetSE8lbbq5qQb2LgVUb5PJLPIDv98geViTUtfVKTIfV3kQhRxFO+3+THxzowYYoIWY9lP6FHdSSdx/txxR1ssAsv2G6OJqWwVNEZamYa3U/M8CB9GEBa7WXdAS6zpCh3/d9gzwJCTfxlxfv0M6cNJ+SQvxeBx0/SzAIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C0z5F8RY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759252227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0bvZchW5POfl0SklzNLfUUgxWMzju251m1BlgdouOoU=;
	b=C0z5F8RYvy6I5FpK4SB8CHo9Lagtcvq0sHkDvAMR2RcPNtkYopjk8Dk2/Mp7sanckre2AH
	CoL8EgfFyXLCpEjgEyXdMcnUhrUJ+9e1edGBP8QpS4fumYDBq5Y3mGmiC/U1TjBCaiDa4y
	7ZI7Q8HRX5WQ3tjEwhVyCooWl7s41dk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-R-jqdwnXMn-Y6QNdPoS38w-1; Tue, 30 Sep 2025 13:10:22 -0400
X-MC-Unique: R-jqdwnXMn-Y6QNdPoS38w-1
X-Mimecast-MFC-AGG-ID: R-jqdwnXMn-Y6QNdPoS38w_1759252222
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ee1317b132so4659044f8f.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759252222; x=1759857022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0bvZchW5POfl0SklzNLfUUgxWMzju251m1BlgdouOoU=;
        b=IVSXtV5t9i/VL36uGZSGpqmvf1U92L90Pjn+dp7ZvSmus/50ZL5hret0Cg1I1eYnVF
         Ov/LXdh1D9/RR0f5rZmDR6eWPjWm7XzDumpC7gaCeVp6guzbnVe/BwISjAAjet0joVA9
         VAzwTYpjyYpU6vBUANYh/WspOZvDmdh6i7Qjh8iqUOLcooRjz3RTtfWVTz+tp96iin0p
         6KzUnmCK6GZrlxTwP+JnItVRjchOptLQUMslMAZpkTrzvepQMy9sWZlbjf5yiq9Bad2R
         H5v6PXOzyvFCgZ0fzrTDq2bjwNqtOfnVrgh35c3Ik76qvbijTLrdn32v1J18t4+/EvPI
         AM7A==
X-Gm-Message-State: AOJu0YykuQx8RwHwv2qmBpGEm9EXqiZnR3Up+ZkMhp2fpqSf9SVn39sC
	X94hkq1nLzzwy3pEq0WkaOnsgeYHeF/9H0fgk49/W0jEsWmiiAYTvT2kY0YwGt5e6YSgKYJhd2T
	tz+Z9BHFZGxaYeeXaoZ+ayGbh1JxL0bIC5KHE+1MTr2pDSSn4ESfmfBvNzW7rwNPTN9+MnFyQbW
	heHieq2g+T8ELL9BtDyfRcj+uMKffT
X-Gm-Gg: ASbGncszwVOaS5tdzsaNCj7XnIBxzZLlFUvRZjxFm0pZ+mwATCWBZ8acF6mv9VsYUz9
	TraB8Kbqo47EvExByGKmkDbB6ikIf88qgkNbnyEvcvbxWr2t+eQ7lg/6A6oCI/2jych2Aa8JeHA
	iAbCUYLJn5BQzk0Ewp+PaBzgXgCleiLzIo899ALMj3KXBj+dAkVTtc4zW/54qXEPySI6eq8y2SZ
	Tje+RHOLqFUpD1ljs5oF82hVyJ8cp1I
X-Received: by 2002:a05:6000:2282:b0:3ec:df2b:14ff with SMTP id ffacd0b85a97d-4255780b81dmr424397f8f.40.1759252221734;
        Tue, 30 Sep 2025 10:10:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbexHK/yhWIuTTvHWW5mhOLtn/qDAllptgnJWjFy6ytUWmpWCTjnevpMYv4ZPhPR3RAr9+DHFBsNcIQPLx4GE=
X-Received: by 2002:a05:6000:2282:b0:3ec:df2b:14ff with SMTP id
 ffacd0b85a97d-4255780b81dmr424381f8f.40.1759252221336; Tue, 30 Sep 2025
 10:10:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250930163350.83377-1-imbrenda@linux.ibm.com>
In-Reply-To: <20250930163350.83377-1-imbrenda@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 19:10:09 +0200
X-Gm-Features: AS18NWBf5MK9iIP6571zd9JW4tv_B2VHrv4ecEs21NVitTR9bCVqN-UF9-XjQ4Q
Message-ID: <CABgObfacb9VhNXQkV6dNWy+E4JEShFhFnpuvJtW4qVNKWTEgmA@mail.gmail.com>
Subject: Re: [GIT PULL v1 0/2] KVM: s390: A bugfix and a performance improvement
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com, 
	borntraeger@de.ibm.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2025 at 6:34=E2=80=AFPM Claudio Imbrenda <imbrenda@linux.ib=
m.com> wrote:
>
> Ciao Paolo,
>
> here is a small pull request that does two things:
>
> * Improve interrupt cpu for wakeup, change the heuristic to decide wich
>   vCPU to deliver a floating interrupt to.
> * Clear the pte when discarding a swapped page because of CMMA; this
>   bug was introduced in 6.16 when refactoring gmap code.
>
> Unfortunately Christian had pushed his patch on -next when it was still
> based on the previous release, and he wanted to keep the patch ID stable;
> the branch should nonetheless merge cleanly (I tested).

No problem, it merges cleanly and has no semantic conflicts so it's fine.

Pulled, tanks.

Paolo

>
>
> The following changes since commit 57d88f02eb4449d96dfee3af4b7cd4287998bd=
bd:
>
>   KVM: s390: Rework guest entry logic (2025-07-21 13:01:03 +0000)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-next-6.18-1
>
> for you to fetch changes up to 5deafa27d9ae040b75d392f60b12e300b42b4792:
>
>   KVM: s390: Fix to clear PTE when discarding a swapped page (2025-09-30 =
15:58:30 +0200)
>
> ----------------------------------------------------------------
> KVM: s390: A bugfix and a performance improvement
>
> * Improve interrupt cpu for wakeup, change the heuristic to decide wich
>   vCPU to deliver a floating interrupt to.
> * Clear the pte when discarding a swapped page because of CMMA; this
>   bug was introduced in 6.16 when refactoring gmap code.
>
> ----------------------------------------------------------------
> Christian Borntraeger (1):
>       KVM: s390: improve interrupt cpu for wakeup
>
> Gautam Gala (1):
>       KVM: s390: Fix to clear PTE when discarding a swapped page
>
>  arch/s390/include/asm/kvm_host.h |  2 +-
>  arch/s390/include/asm/pgtable.h  | 22 ++++++++++++++++++++++
>  arch/s390/kvm/interrupt.c        | 20 +++++++++-----------
>  arch/s390/mm/gmap_helpers.c      | 12 +++++++++++-
>  arch/s390/mm/pgtable.c           | 23 +----------------------
>  5 files changed, 44 insertions(+), 35 deletions(-)
>


