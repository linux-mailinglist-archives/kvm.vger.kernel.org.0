Return-Path: <kvm+bounces-42970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8157FA81877
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 00:25:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 028BE19E0460
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 22:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4C82566E4;
	Tue,  8 Apr 2025 22:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wrjaw6x0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F347425524A
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 22:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744151114; cv=none; b=uOIN+HL59PtcGDLZpbnednXE93QbnsVnVA7n+l3By2S4DFTcPVbj0d1VlkeTPQl6gYTbYenhpVbm4+ezNrR47RAdgeaudIMChNTjMaU61TKvH0jAq+pd8L1bDrRHTWDJ0mFRbjqbJbGgmhOOXuYVIM3qaZ1ejaVfrS0SLH0sQFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744151114; c=relaxed/simple;
	bh=ccAlpK2GJ8AJvkq+fowLZF3c1eIeInVWDTpL7xW7Uc8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pnWk8pNxLZPe3PnYqAIMEibMj2LMhHUZ1NDs/o4b7+hJwUlnBL9IEREEKroUmMF/deovr9AjhLlC6/1L0FPaBTIaHk5WKqkc6Yo2QbwxOSVzTQ728pRq5y6sLqyKfJuVm0khndvjVVBZVtU26euFRoHrhhNo2/0WamB+VT1vgXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wrjaw6x0; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736a7d0b82fso7712881b3a.1
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 15:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744151112; x=1744755912; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sIgnrXOk29PXtGhJ0MJfZMA68k7F5ofitj+uGIUhqWQ=;
        b=Wrjaw6x00omrao10UBDcRJlfoaMd517VWRscD3ScHmWBgPMqMXnLrHjzO9N74dwjAw
         s15bq+kIXK0KF6piJWY3cokC4qV2rTgpMHXJ9gMjPJM7Mga7XqlOJY5g+/0IcrQWssWb
         XZ2K/Pll1oLkYIzDRYniImWUGXSPcFomXpDN6dkVQUCTqfbn3HbgwnylLE917Lpq8BLQ
         SiK7OPQpCZFdxRDHjt0x0Kb0LVhqfoP/0diR+ZNUl8XizImUlcgpLEJcilMtwblHI844
         9fwzQEqNlrsm4Ln373mmqAucLxT+MvGHEldwm3Gaxv+/wYdnAV8E7W9PBeXapI2P0pgl
         +7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744151112; x=1744755912;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sIgnrXOk29PXtGhJ0MJfZMA68k7F5ofitj+uGIUhqWQ=;
        b=ZkWE9QZ7V8KEqC/CQi03G7uDTYppxkkF5m3sZMb9AEXZFB5kT+WEoxgIxOfea+LTRc
         CN1d+C6onyw8COH99ziG6s3m82WMMWxLQp0dh61ORM1q0Zi5pWuxoK7aaAYDVj10ecJA
         F3f7SoNNN5aj6U96+CuzfiBshVX0un4s+nCESiIEO62j4KAQIT2phc8axmYttxOpCxu3
         8rWDsTFB6yUWnRa5N35z9jHUW/l7Z7x613zqSCJ5qxhBzT39Y2hnsk0Bx7yw/5tgBQdT
         QeLFRnWBCu1SuH6mAHDZPmvCQE4f+jreJCsa3PRx6g8M5gRlAdyVTj4P07U6cQXXPVdT
         b5zA==
X-Forwarded-Encrypted: i=1; AJvYcCXGhA8QjL2UUsQmYvn1wY6JLHC+oduAkzr4+TamApwZoBtZ/WwLryo+pEhjU+AlzqrJ68M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIpdMI0PRu2jHOCsJUr4TBQU8GIo7VwKoRdmg5uQU5qHXyzU4d
	9LwanfQz2UbnASYZpzrbKvK+xre4V8YgUV8Gwy7Go0ELEMQIWV0EDDPcKVPoO0vuNaueEcpPrTY
	VEw==
X-Google-Smtp-Source: AGHT+IHTqPfvPHA35LrKeVma6IN8V+jh3iCyiyfrKN6jlTE/sMMd957ClboQYBC0BvqEPRp7vq7SpPie8ks=
X-Received: from pfbef12.prod.google.com ([2002:a05:6a00:2c8c:b0:730:796b:a54a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2285:b0:736:baa0:2acd
 with SMTP id d2e1a72fcca58-73bae55297bmr811030b3a.20.1744151112304; Tue, 08
 Apr 2025 15:25:12 -0700 (PDT)
Date: Tue, 8 Apr 2025 15:25:10 -0700
In-Reply-To: <8b061b2d-7137-498e-93b2-0cb714824d7b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250404193923.1413163-27-seanjc@google.com>
 <8b061b2d-7137-498e-93b2-0cb714824d7b@redhat.com>
Message-ID: <Z_WiRqRjNzmrh_YP@google.com>
Subject: Re: [PATCH 26/67] iommu/amd: KVM: SVM: Delete now-unused
 cached/previous GA tag fields
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 08, 2025, Paolo Bonzini wrote:
> On 4/4/25 21:38, Sean Christopherson wrote:
> > Delete the amd_ir_data.prev_ga_tag field now that all usage is
> > superfluous.
> 
> This can be moved much earlier (maybe even after patch 10 from a cursory
> look), can't it? 

Ya, I independently arrived at the same conclusion[*], specifically after

   KVM: SVM: Delete IRTE link from previous vCPU before setting new IRTE

[*] I was counting patches based on my local tree, which has three extra patches
    from the posted IRQs module param, and so initially thought the last dependency
    went away in patch 13.

