Return-Path: <kvm+bounces-10819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21371870A09
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 20:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D14B62813E3
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 19:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356D678B68;
	Mon,  4 Mar 2024 19:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y4/aWuqh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E709978B50
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 19:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579094; cv=none; b=hpuQ3RujZlthaVgSGKQF2eGI7Z/KgdwsnBMZpTMm9PG8KMSAR88khZMnPYFh3dpRJ0gm4VydmyWx9y+wnmjLo9AwH8gyMdiXnX5KpKb2TUGT6yB4h56tapmZHkjLJcdxEicpBQEGnN8+F0CODS2j+WFuavT7RvEcJiZuQpn3/Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579094; c=relaxed/simple;
	bh=XRF9d0llZoljeVZTnT/w8TYniFhcPPtMCaXbelwBxIM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hu90AtjCqbCONH+Wu6URB2uKR4cAHl4kb9Oe6GQYiZ1aD7fYogFt0svOQ+TKSyrjQTSL9Sf2FBsB1oYalSnMSX/7JR1jGTI0I1f6oJMRgQo92Siice6IuTVC0Lhffid2O4ovqaFGESpWYtfCycjuWb5dw7dB6jBTBSLwriH4RHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y4/aWuqh; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so9347810276.2
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 11:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709579092; x=1710183892; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qigiTJmlQO5CEcsHaxPL7QMEFIyfo2CTnjsxN/Vximw=;
        b=Y4/aWuqh9N2M+Wdi/7rSLwNBuyPUJAu0RogmGR9TWUGygaFRMFa4SIIMVauKYyHPG2
         ls4wDR3gcXOKw01ROAkzEAswyIQNyKMU3LDcRCXPme1XWER2Pbbd9RMc1tS1+CGTjM6F
         4TvXddhQQl5JtWby30+yVXQxHkVtl9J+6NGEYCrumXgumCSCDCMp2LlTPSPwLVQ5Ui3Z
         IoQZybD1KdBy84xId1HwySDgZZXxs6lSXOyEeivyZV6iCrlhlhIzg6P4m9Z4MlONOm9P
         O1l0PdhY2xPqyVkyPbYwzarg6vpZAKOSPAy8ZG+HenwWyJPwyaClxo13uSn28dWaM6CE
         OdSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579092; x=1710183892;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qigiTJmlQO5CEcsHaxPL7QMEFIyfo2CTnjsxN/Vximw=;
        b=UIwx7GwrDyru36rwwx2okJnAf7xssbS/n/ZAy0scFuh9X7dwIyiqxMw40VwjcFQjX4
         Zz+2X3xzoKkr+oOyrh84pBxX4TdPX0coSksZlT8hH41mvsNz+JoOrKSxPiTEzfh15IG6
         UL8b/+jKJXM10p4nlggoE0M8BAPW9wb0FYfGb1yS/yKdQ1adOq0hPo3x/NgdreK46dvz
         Qb3KnrOkdgfhbt976sa39+Q+0q66yR1DfdiwSVyoBVu1WkVxp3xKuuSwBkHAl/svhwQi
         ybpmobxnoXYkP0lchinxJmS5XBC/qj/YJd4lw+vdOZjWPQL17MdwP1XH/+q5n6PTxV14
         +PPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqDnbSx9LQdorCuJpLWgC5DYJ/g53I+b+crO4H6OQSyjBI68jywzLXYVVrVlVQFx+ePmMhwciXcv2uh1VJ6X9HnNmV
X-Gm-Message-State: AOJu0YwMlsrfq0wZ8y//Ti6VQWhIhsqKMAbwhxNfksqIBH8mVLE63lYy
	qpRUfO9e+lxDuYb0K5kb5XgFJ6xoyh1NQjgXmCk4GiH3Sg29QZZj2CQpt05ITp1rOOl7MPIgDd+
	bcg==
X-Google-Smtp-Source: AGHT+IG99XprlSdu2d42OzIQNXRQobjTVbkqOIhrS78D9U8gTWrmjRueDnAOyhYjkl87zP6p7oPrASHYRb0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2183:b0:dc7:68b5:4f21 with SMTP id
 dl3-20020a056902218300b00dc768b54f21mr2615442ybb.9.1709579091951; Mon, 04 Mar
 2024 11:04:51 -0800 (PST)
Date: Mon, 4 Mar 2024 11:04:50 -0800
In-Reply-To: <ZeXAOit6O0stdxw3@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com> <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com> <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com> <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com> <ZeXAOit6O0stdxw3@google.com>
Message-ID: <ZeYbUjiIkPevjrRR@google.com>
Subject: Re: folio_mmapped
From: Sean Christopherson <seanjc@google.com>
To: Quentin Perret <qperret@google.com>
Cc: David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, keirf@google.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 04, 2024, Quentin Perret wrote:
> > As discussed in the sub-thread, that might still be required.
> > 
> > One could think about completely forbidding GUP on these mmap'ed
> > guest-memfds. But likely, there might be use cases in the future where you
> > want to use GUP on shared memory inside a guest_memfd.
> > 
> > (the iouring example I gave might currently not work because
> > FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and
> > guest_memfd will likely not be detected as shmem; 8ac268436e6d contains some
> > details)
> 
> Perhaps it would be wise to start with GUP being forbidden if the
> current users do not need it (not sure if that is the case in Android,
> I'll check) ? We can always relax this constraint later when/if the
> use-cases arise, which is obviously much harder to do the other way
> around.

+1000.  At least on the KVM side, I would like to be as conservative as possible
when it comes to letting anything other than the guest access guest_memfd.

