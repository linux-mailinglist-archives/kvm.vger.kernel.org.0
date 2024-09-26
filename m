Return-Path: <kvm+bounces-27536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C8F1986ACA
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 03:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51E4C1F228BC
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D79A175D47;
	Thu, 26 Sep 2024 01:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C4/tDrCr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA9B37B
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 01:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315747; cv=none; b=EH4gXWk7zwjxEGv2Y3a0TUANBTHwmYu9AarPhlQ8g6zb4hF93323CUYTHVe6ntghH1c8/S4RqW91MDJFP3D190C/3/TGPU2HYR64QiK0YHL6qZ5PIpEsHHO6mcsHC32cG7brh6qUWg/8dX3MklmybfyrqvoalOtgj4HoRYsmOWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315747; c=relaxed/simple;
	bh=AvOeu1aCuavSpf/Qxzj/pTTNG2WKfA/2mpgDnn4nCwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FmTxEylzGL7A+gp/dS+6IwyvPvcRZMiJZCppz51igTOn948cayFnNqj+882poHzAIrSXu9BYijYsYdT/90BLoQk0Hjo4zNKqWzAz9nVxXH2le9fMq1pX604f6n4ds9bbfyhVYlXUClrrFYE+sUDWhZV2jHbdz3qhbL7SSXxN4+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C4/tDrCr; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6dbbe7e51bbso4281137b3.3
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 18:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727315744; x=1727920544; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AvOeu1aCuavSpf/Qxzj/pTTNG2WKfA/2mpgDnn4nCwk=;
        b=C4/tDrCrv1Fh5YPVT97pj7co+Y+hsVvZo15FVQuHqnwNMW7iIN/yJQrg14wn1xmeO+
         FBPMSOqNVmRKB5+VsnAtqONysg3ATzWxFHcpQXlPVE07wHMsBEsvZS3mwdGmZz+wABBd
         R817wHk019Uo8HxWfzFJ+GvW8iM05pvLPdyfh43L4VBnIa7S+cgb6UbCSZ0HGFcV9CaX
         IaGOCYyub4UPbj6QHUaqqcxi3EzJ2+QMnEQetJdyNz2nI+29eOEteWfkoMe0cafWQ8id
         CYzg6oeak7LhhZXhfp3oRpshj+S0fFoI5E4n8zHfaX+Mmf7CZqwNtpG5gSqYvPL6g2s5
         CQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727315744; x=1727920544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AvOeu1aCuavSpf/Qxzj/pTTNG2WKfA/2mpgDnn4nCwk=;
        b=Kxcz3wEVb3VZbizCvR9ITCgCz/aRn1tYnqA3JlRYevU3FvS/hKy4sWe54fdrkCa+hj
         2WNyWm6DqmDtaCGcn0R/zhaIW9F60c84yEllYE6u+bvpGuhNw+emGlc86LN2TefjG3CG
         l3NIoW/6ichNSCYMulKJGrM8yJzpQn9ikAae2aFyrLjirkbvEx6VX4KEcREJOwUCMDlv
         NBJLkdzT1suKL6+U5ZizfVZ78BrZE1QrFj0/ZgEx1ryxVdQO8ZoI0/7kuXCdE8b/9Kfo
         RosvD2ziqhcucpN+N7yAJ3RdtpW6LeQRPZTNmntq755x+JLSeKAn2lnsVErjwxFw1ndM
         qXZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOJrCZh6Qu5zjxr4MRa3/CLaGtUTZewobleTz02TR6Jb8fn1aSuNff5HDack3Dh3LhCaE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6wN6CWemFrJt/C1b4uXYVRbwzEVfZ5fooc/1+jms4yfJ2Yc5W
	TZgPSLK9NmiHtIrar6kP46659gYyUaeffsUldC7DYecXLlqG3cv/9zKAfhMeSPasz7/IIVtF8SQ
	+ITztDDN+siYlNdTxGvffiFxneDnte8nx8iEo
X-Google-Smtp-Source: AGHT+IFii9QgwJ7X6I4kq0clALv2ZlfTWM+Ez0PZcdvnVsO0zqwYPfgk8ziwPN23MIImR0+NDVcsRZ7OngewarYkwr4=
X-Received: by 2002:a05:690c:368f:b0:6db:e03f:7c39 with SMTP id
 00721157ae682-6e21d833401mr46817427b3.16.1727315743978; Wed, 25 Sep 2024
 18:55:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com> <20240926013506.860253-5-jthoughton@google.com>
In-Reply-To: <20240926013506.860253-5-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 25 Sep 2024 18:55:07 -0700
Message-ID: <CADrL8HXZttWQcsUBPYBuctEP4BWhGwSoTNvT7eeknsGJkgbGig@mail.gmail.com>
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
>
> Walk the TDP MMU in an RCU read-side critical section without holding
> mmu_lock when harvesting and potentially updating age information on
> sptes. This requires a way to do RCU-safe walking of the tdp_mmu_roots;
> do this with a new macro. The PTE modifications are now done atomically,
> and kvm_tdp_mmu_spte_need_atomic_write() has been updated to account for
> the fact that kvm_age_gfn can now lockless update the accessed bit and
> the W/R/X bits).
>
> If the cmpxchg for marking the spte for access tracking fails, leave it
> as is and treat it as if it were young, as if the spte is being actively
> modified, it is most likely young.
>
> Harvesting age information from the shadow MMU is still done while
> holding the MMU write lock.
>
> Suggested-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>

Oh no! I have left off David Matlack's Reviewed-bys[1, 2] from this
patch and from patch 2[3], and I failed to apply his comment
suggestion on this patch like I said I would. Sorry David, I have
fixed up my tree now.

[1]: https://lore.kernel.org/linux-mm/ZqJ_xANKf3bNcaHM@google.com/
[2]: https://lore.kernel.org/linux-mm/ZqKUefN3HgBQQkuA@google.com/
[3]: https://lore.kernel.org/kvm/20240926013506.860253-3-jthoughton@google.=
com/

