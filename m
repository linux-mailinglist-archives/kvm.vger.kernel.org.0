Return-Path: <kvm+bounces-44144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B517A9B04E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABF6C17EE66
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72BD81A2557;
	Thu, 24 Apr 2025 14:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L4QM/kh2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BAD19DF53
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504020; cv=none; b=XBENEDZTZe4QtyCEQhcGDgKESAMZuvfUWW7pzRGMbSKYA5iIW3vbXQGEV7AJBVVkt3bh0QlcvoFpTY9vrDJiDkTFAW5XhteVwSF96JSvmapFp8RkFWfaDcau/1itogW+jMAjTae1pMXm9aalqO2jKCWOXxzgcpg3gayRy1kpXMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504020; c=relaxed/simple;
	bh=IU1W/JCdrrhxdJ5WvmQGAwCklNVOFnQBmbNWHuEVJyY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cCFi/WypV1XjyQ8kX12lJFJ7d3vWR5nd8tsm1WgCQLFBzq/I0oiuk+QBaPYsM08196jqZZdIZuqSAkfHeep/gcim/YV8vm/29ohlEaNaZSFYS8OkOBgeTtGYNnyT1b3OjVlgbTZiVMMx+M/T9FsKBfqonpU+qYhTw8ekWndsQGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L4QM/kh2; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-afd1e7f52f7so692715a12.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745504018; x=1746108818; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t921yTGj75JTSKsSLngkcs2w5nGrP5C6g0Ynh60adb4=;
        b=L4QM/kh2Sfy20MrUlCIpP+cxS/I+cnVhDUHXBSY85N4adZlOZJRVi7Z504aZHnaWcE
         aqmfpX0NOK3NyvMT34lf+pzSWIhExo1vzMXAYgLcXKu/q1uGDNVtPr18Qn+cKbV4W6TG
         24VzLKk9hdqig7pMStEIZnVhtREDIbgJ3EUZxEDJGR8A7R2CdJ0UnUAP1LoYh+2HBVHm
         YOT40nxKvj+CFWDuE5ULXYf1YvPhCHNJxHk+8yxw391Tf70ki+1oPZvoWmyvkk8apnXk
         P1htsxzoAuk8DqZDfZ6D3RHUFLoYrfgSRL2Uy34a32iU6PhqjWRhPJe5jW9JCnmax2HR
         kjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504018; x=1746108818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t921yTGj75JTSKsSLngkcs2w5nGrP5C6g0Ynh60adb4=;
        b=HZTP50h5ZZgrzFXtZ4R9SYd9yiS05PLw1Ut5VaEQlsplN/WH7OzWKvLP34qZn0JbmE
         EogNllUIs62oLP0tf/7EyuwqfeHmLDC1qehcgTBb6DgHngoAi00HsKrEV9uO0UJpgsZe
         15fw3TpwrpjhPVyH5NyFagxnMdxOKSvAmj8HZraaX9cBZFsB/DLwwN223s+SNxgrhe60
         ugGqlwsH292eSIGfqyETTTCxIBTk4hO7SzqWM8MmpCjeJwrfgYjzeBI3DLDq7UdOMuLR
         UaBKceV6eCAF9lbUr9cKBw0tvyUoyQhKrD//2tPwfFpJEpEE+mLUwdWXpcg5gQffBQ7n
         fKIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXT8PZUTq+55d7FKR38pglmAjrCGSj+ksNyK1DQy4q8IkS+f7QVdms3vz8MWV9ihi+gNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPVa/xBltX7FaVWypzd/5ShUhCPpJ4e48JKOdyhXtPQu/Lr4nR
	1gztY2oQnpFWBhRmVjSgi6czdXd6sOJm26GnLyfme5JXR9VirR2tGznIuctGiliyCyoF708yzRJ
	1kQ==
X-Google-Smtp-Source: AGHT+IH1Gu9GLKfGiYTCOjMoGySHlcEjW+ds+b1IrKT29iIUpO61X0NEHkvZCaXOOFQOQ3oqS5p4trwyczY=
X-Received: from pfbkm27.prod.google.com ([2002:a05:6a00:3c5b:b0:736:47b8:9b88])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1309:b0:736:5c8e:bab8
 with SMTP id d2e1a72fcca58-73e245ba24bmr4220090b3a.3.1745504018497; Thu, 24
 Apr 2025 07:13:38 -0700 (PDT)
Date: Thu, 24 Apr 2025 07:13:36 -0700
In-Reply-To: <1fa0f7f8-be88-4617-a0b2-57d4204c6d6f@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250404193923.1413163-34-seanjc@google.com>
 <1fa0f7f8-be88-4617-a0b2-57d4204c6d6f@amd.com>
Message-ID: <aApHEK4R4tAYi5Q0@google.com>
Subject: Re: [PATCH 33/67] KVM: x86: Dedup AVIC vs. PI code for identifying
 target vCPU
From: Sean Christopherson <seanjc@google.com>
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 24, 2025, Sairaj Kodilkar wrote:
> On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b8b259847d05..0ab818bba743 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -13567,6 +13567,43 @@ bool kvm_arch_has_irq_bypass(void)
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_arch_has_irq_bypass);
> > +static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
> > +			      struct kvm_kernel_irq_routing_entry *old,
> 
> the argument 'old' is redundant in this function.

Ooh, and @new to kvm_x86_ops.pi_update_irte is also unused.  I'll get rid of them
both.  I went through multiple iterations of hacking to figure out how to dedup
the code, and (obviously) missed a few things when tidying up after the fact.

Good eyes, and thanks again for the reviews!

P.S. Please trim your replies.

