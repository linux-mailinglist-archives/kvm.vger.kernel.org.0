Return-Path: <kvm+bounces-35131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FDEEA09E6F
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 672223A3D9E
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C14921CFF7;
	Fri, 10 Jan 2025 22:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FWpEnqDH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4E8219A94
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 22:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549967; cv=none; b=LD4736KnOe7MhgmKUtIa7EiGB6V6wzAtPxDVQxDbiogorlVHHAdIenQAyro4sE0vF7YWAYqDH0jamXPzFoGupMZKtCZGRmxXTbscQ609Xq3/lwbyMZb18W6XcM3xhQmMYB1sQfo69n73Li5B+RV7V72+xqhgmO/dshjzTThrioc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549967; c=relaxed/simple;
	bh=D0QwY5iy78ntBIBZ5fxC3CHWSp0vbBl3oyR/XQTHdlo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZwMtnmQnXFUMxXUUsF7YFZCLoDj1lkOXPNNXhl1RChGuoI25VkYMePW09VEWTo6KYBIFrLQb8aQLjIMYIjDSkVXQUWFvex8Je3Iha0nXELe3TOo5QUIOpcmHYFK6Yj9YcpV63hGT0r5lWDLFeZP52TyKNygG137GQwMVZVJgcl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FWpEnqDH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso4760193a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736549965; x=1737154765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cdj5Dgcv+cC5TtyXPAS1MtVJ9aQejYKryRyO9M7Iak4=;
        b=FWpEnqDH6uJdDTXKaL+7IocjchUPvtrWlheC6WjQZmYCADmULCUliN0OORLz8DylPg
         iAkTJajmjTvcdO0iMbEi6seGfdk1IZAxh5F94Mp+O1/fOZycqhKi4ORGRvaTO56H2Q8O
         QOLGZp2uIXqIjqwdJKozfTQPQKorw1O9P24MmiscxaB+AZUvbAIvIG6b+EygGhWEnsZX
         a4lLcOnF57I0mWjBK47xfb/fq5jie+Ovm/3r0rB8lKIK+qGzKqpSBZj7eTfUfmrE9NcX
         Fcp/xD3su6Yds6dQKPZLPavbhoKfRl8fCOMBhYGeGCObTK7bg4VdqrdnZSKIr0/uz+Ri
         XzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736549965; x=1737154765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cdj5Dgcv+cC5TtyXPAS1MtVJ9aQejYKryRyO9M7Iak4=;
        b=i8tHxjTz96v73axO00VxXtS4MBKJrOsk9vjabGyS8+o0jXsUR1Ipy9JIDmyYHefBVo
         +/wu/HC7EkPmNStL9Fhr5n3LSDgAuluCt5lLJ/igdnGA06V8n54d6t507P0tgk10Jdm/
         rlqHIb8g9yMe6lGDhcpQBlWw/6ZQyaJKcN/J72cX5qBDajRJuj9KYc82R6yYTLaPwJe9
         2TUz6H2MfiIeVSuyKkIW7WYA2PTItUCvjtxs5bNMtVeMnBKqdN/7AaG6bNL5Hf3ou+/A
         CIbJGeXcslPIFysyZOw+Tsggas9A/sHIWBpnsJWWLYcTQ3c1QOy+Aq9AZfHy4jCeUEnh
         o6Uw==
X-Forwarded-Encrypted: i=1; AJvYcCVkyoQXDFyuVnDtomFMeyd8tnRCSw44pxnhieq0wvxS+n3u1Y9xciss082Citwm0MF3t4s=@vger.kernel.org
X-Gm-Message-State: AOJu0YydU3USYxRiFO1pgG6HGoiFmeXusHNaPpQqYnFuz3N0DMyesPzO
	X4DK3Ns3BX0zbPOCUyDz2cnP7bAIgQTsIQFoerMNppj3BZPJlB2ZfrOtQpnT3Dmm4GP8ydEj+AC
	QLA==
X-Google-Smtp-Source: AGHT+IF3TnhekNxKJUwPsbSHFfCXMowWagLC4X9XCaxXElMMVujoSjn9qlX7KNEZvxY5HBZbUw7TNC8Ob2k=
X-Received: from pjuw14.prod.google.com ([2002:a17:90a:d60e:b0:2ef:abba:8bfd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d64b:b0:2ee:8aa7:94a0
 with SMTP id 98e67ed59e1d1-2f548f42490mr15723099a91.32.1736549965312; Fri, 10
 Jan 2025 14:59:25 -0800 (PST)
Date: Fri, 10 Jan 2025 14:59:23 -0800
In-Reply-To: <20241105184333.2305744-6-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-6-jthoughton@google.com>
Message-ID: <Z4GmS48TBDetli-X@google.com>
Subject: Re: [PATCH v8 05/11] KVM: x86/mmu: Rearrange kvm_{test_,}age_gfn
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, James Houghton wrote:
> Reorder the TDP MMU check to be first for both kvm_test_age_gfn and

() on functions, i.e. kvm_test_age_gfn().  That said, even better would be to
avoid using the function names.  Let the patch itself communicate which functions
are affected, and instead write the changelog as you would verbally communicate
the change.

> kvm_age_gfn. For kvm_test_age_gfn, this allows us to completely avoid

No "us" or "we".


> needing to grab the MMU lock when the TDP MMU reports that the page is
> young.

The changelog should make it clear that the patch actually does this, i.e. that
there is a functional change beyond just changing the ordering.  Ooh, and that
definitely needs to be captured in the shortlog.  I would even go so far as to
say it should be the focal point of the shortlog.

E.g. something like:

KVM: x86/mmu: Skip shadow MMU test_young if TDP MMU reports page as young

Reorder the processing of the TDP MMU versus the shadow MMU when aging
SPTEs, and skip the shadow MMU entirely in the test-only case if the TDP
MMU reports that the page is young, i.e. completely avoid taking mmu_lock
if the TDP MMU SPTE is young.  Swap the order for the test-and-age helper
as well for consistency.

> Do the same for kvm_age_gfn merely for consistency.

