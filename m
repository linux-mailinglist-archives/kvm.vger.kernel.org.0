Return-Path: <kvm+bounces-39204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD66A451CA
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 02:00:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EB40189B6B6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 01:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217BA154BF0;
	Wed, 26 Feb 2025 01:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZY+f46QH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069CB25771
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 00:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740531600; cv=none; b=Qbuhn6C+7LERvHd8mXCkO94XZjFFQW6+VLwWcfMxQEtculmWbXZBzcm535WJnUB6krF8TQS+RUkjjQmtKicMlZJ/v24KaLenNmpO3RYnkwlNNJcKOc8z6X+LSdfae4tOdIFRVFYPfYcrkqmxJYZRhb1zM0sY38TeooQFO/Jqlzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740531600; c=relaxed/simple;
	bh=UZuoXvVoYlHLe2ZJ31ykIrX5on5fG3MR/NQwxEXkUhc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uGR7lPG6wiw7PqZUnO7Z2ga1HxQICGynZE7BMnR9PSWxPclW9pPPmGOFy+zFrFbceDd5TGBOzksQC4gljpusBGPDi0WiU4doFYB5uTPBee5uNTgSY9ptF57qXvZZCdmv+CH18ARBSqAhjggjOdVz3m0FBRamSy2k0gbbyfRrW8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZY+f46QH; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220fb031245so108025445ad.3
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 16:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740531598; x=1741136398; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H/yRfs+ROvmr6zgK0XZwah8gAq+1Fneqtf50nUYSsfQ=;
        b=ZY+f46QHFnmxWoJHh+i+SHK/+ce/wTI1ZA7Bpelya1OHnS56lZE7kRodK7GsU69iri
         VYRQi573BmknGC9r6tycudbfw6wABFsHswAb+MKIKopIKGAEzOZsZERHl2648Iqs7MLP
         B0vj9RO8/ztulQwPR6FmfVnW8GDxI6reszsIpVZ++FmhvYHgQtp3R6MyxzW+285zjSxY
         aBvtA8+xsCqHNbMrF4noPda2SgN8aufePecHihm6Fc85Tb9ZdWIT4nYGn2RaPoVHsdlh
         k6JrrIXuLUiX3/YDNQhMfMJjK4Qd/hHJ76SlXbV4HJp0AjU855ipV/4erbYHhvEGZOO9
         XNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740531598; x=1741136398;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H/yRfs+ROvmr6zgK0XZwah8gAq+1Fneqtf50nUYSsfQ=;
        b=ZNTL2/HXEdTOaUt+PKRtZMjwdkTU8sGxH0XHFJMx5nPUFLrAdvwzj5Bsn/5vlZe4K1
         Zd2FcRjjqmpcexqyasidSFigfBBcDkHb6CG32+7nsYYFEO85UEJWcLs3ZSAvjvHgtMkb
         dIiGadO1L0bxr831AQDQmGU3s+pB2Nd+G/WJpaNy97RCQYreR35S/IvkjbcrVWphVBrP
         EkgL0hkMxlP5ubvouoYJyrNfUmZ5Zf088s/BrSdwYc4KmnWzUIxZt23lUlsveOn7BK/A
         dbo7dRCvY2kAjsJl+McvsINQEVJm1KqW50KYZoPP/un3PRWf+M/1YPHtW5tv8b9/6cpC
         EplA==
X-Forwarded-Encrypted: i=1; AJvYcCXN/UMfQpwp5aIJUU9vCyD5xuoXuBbR6M1FCHAxAabdfSwov3wg/3pgLxpBV6JZ47MvAyc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8HbD+9ox7VooUmkTV8t7y2WvmC8WntUGo6ZY7FdY7FNWraA8v
	0mXzSC83nHSuqfpJBtJYjZbcKe/c0hd/2aJrxr/D261VL9SG7NhIXA01PHAuSlcT7NEZ6Lmu3gJ
	kLw==
X-Google-Smtp-Source: AGHT+IH496irJstB/O9V4P9MxhU3mjS9uTgOnuszad1Q+wwrdjAdB/BhMFsGxC844mwcdWTH/dPBcGAvxYg=
X-Received: from pjbsw14.prod.google.com ([2002:a17:90b:2c8e:b0:2fc:11a0:c546])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d2cd:b0:220:c911:3f60
 with SMTP id d9443c01a7336-221a00260e0mr311608095ad.47.1740531598367; Tue, 25
 Feb 2025 16:59:58 -0800 (PST)
Date: Tue, 25 Feb 2025 16:59:52 -0800
In-Reply-To: <5fb9fa5e-5769-3ad8-32d8-e4a045f041a1@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250128015345.7929-1-szy0127@sjtu.edu.cn> <20250128015345.7929-2-szy0127@sjtu.edu.cn>
 <5fb9fa5e-5769-3ad8-32d8-e4a045f041a1@amd.com>
Message-ID: <Z75niMjZTQQ28HKP@google.com>
Subject: Re: [PATCH v7 1/3] KVM: x86: Add a wbinvd helper
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Zheyun Shen <szy0127@sjtu.edu.cn>, pbonzini@redhat.com, tglx@linutronix.de, 
	kevinloughlin@google.com, mingo@redhat.com, bp@alien8.de, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 06, 2025, Tom Lendacky wrote:
> On 1/27/25 19:53, Zheyun Shen wrote:
> > At the moment open-coded calls to on_each_cpu_mask() are used when
> > emulating wbinvd. A subsequent patch needs the same behavior and the
> > helper prevents callers from preparing some idential parameters.
> > 
> > Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
> 
> Not sure if this wouldn't be better living in the same files that
> wbinvd_on_all_cpus() lives, so I'll leave it up to the maintainers.

It definitely belongs in arch/x86/lib/cache-smp.c.

