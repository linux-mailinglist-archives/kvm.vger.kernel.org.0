Return-Path: <kvm+bounces-38513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD22A3ACEE
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:04:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D25B188DB86
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 00:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7374C6D;
	Wed, 19 Feb 2025 00:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6j9IXf2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2859133F9
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 00:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923491; cv=none; b=DSYGb7lnFStdhgR/4oTuSXAX5ZKRzxbuilg4j7GfwfGy3DfZMbGetKE9fvc4jZcEEBu9yXM0OMTh4kIDr2T6u06vm0Qow86m5QOhZfQ4IhX9gu+TqG9I8t2gsLodlhNVEte3rZ4L6jQjOQ4z7KtsLdjr+lILjN7oqq4/h9AhUeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923491; c=relaxed/simple;
	bh=6CWoQOfb4FU5vlKJOSNdErFQBNlpEU0i6VbcMbJzVGc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R9QgiCrU9vAQt8b6U6ACN7sPROxy4BRBGV0SnRIv9i987VjKdf+sY9OrHRlcCJRioUCUmMektihRLDGJcdtnx4YIMSI7uyDxNOrIbRPJhGgTc+yDy4zjwrgSqxSmLYdhjAni8xk51vXGsoviLHPdcQ/w6pv+i+aJr3GqJE3xfM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U6j9IXf2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739923488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PtAD2DRQQatUEPzSGyeRv1jlS72oVKbcGUJmNht3aCs=;
	b=U6j9IXf2lqHpFtFfwMNCVyGrGeq+1cphlF4a2fsNsUmsjKMwxs9HC/cOVBpwCX8S0EsTGN
	4upfP6viPMsmWwD7mtE3XPCPFkYYaxVp2PBbQtdaKMqqm4/Jx9LiBtWB++jGBZzhd69P+H
	228XVgG5W+2I1yJk6fC4WpCtDO+2Jvg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-M_w8QKdsO5mSZwZB0Fv9pA-1; Tue, 18 Feb 2025 19:04:47 -0500
X-MC-Unique: M_w8QKdsO5mSZwZB0Fv9pA-1
X-Mimecast-MFC-AGG-ID: M_w8QKdsO5mSZwZB0Fv9pA_1739923487
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6e65e656c41so118312846d6.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 16:04:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739923486; x=1740528286;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PtAD2DRQQatUEPzSGyeRv1jlS72oVKbcGUJmNht3aCs=;
        b=S5JWWNADuJGEfnHIr4zyrgpHbFVBOhkbsit8Obc/C45juU98U68yl0cGg3q6/G+m33
         8HLfLq+eIIZaaFtONvkuuCf0A7uPlmsZFOsHzlE10G859nm8A368YXIKxBGAoacXqsp4
         cigBVZYZX/pD5wJ2qDgpLppX/5y7NSPy/1qsv6WCj3EbQKoHcN33SmJ4EvKp92OO0wiS
         JTCcg7IVkD4W69+aAS5qinJwdWjaigJ95rAfBauEk4u77kD/b1sQCeUM+XUq+eyFG9io
         Vxyol5EVal1tEC9YVFSwJoczPWBOQKWgCGU9qK907yNimvt/pow3tbdEpjBgpH3s6oP+
         BDYA==
X-Gm-Message-State: AOJu0Ywzg2Cq3CS+AXhtABwX0wSeOdEPfAEz06UfuNrhJ/RJ0hT7MISg
	t9dvJ8952l1OX9ZZuz2tc/pPC1KtkLI+E/r8b4DbwL9AuUwJ8bo4n6ylUqhrWvPqYckQGxZUV0J
	cEEx60JY6EajENxgEQlxq8tAFbr6voJ5g+pYxR48lP/j3HPJj+cyVuTYXAA==
X-Gm-Gg: ASbGncv7NQy1ME6jBqVcA71566VOFg3uUflKTT8VA51AMheZ3JJm7zeUjG7MjD7pKWP
	8tfdmkXKlK/tnnt5ou6tdSxzlU8Vos48HMBqjdfNOPvxQj4bOKzEVBvB/Jb4JfuJQKbP1M+T4r5
	DoeYRpKHSFGGMflqaN/T8wJg/9P0Pq7mqKj3eEkACND0dDsU948RQMJIXy8tqyQ9MG7lckNTaFK
	1SdonR0KADuDeKLFEkqjcVKYK/5YsxiV9kWNY5CG/fGxkdJCeqWEtr5bF62xGWtflwXT7fg8t7O
	e95+
X-Received: by 2002:a05:6214:19e1:b0:6e6:659d:296 with SMTP id 6a1803df08f44-6e6974f600cmr27524786d6.5.1739923486757;
        Tue, 18 Feb 2025 16:04:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH71nPxsX2fG/CAWopegfJPlFRk1fAUW2cPCoJ4pNSv6i6os3CSmH8EoCiaS7aAxhZCAqCaeQ==
X-Received: by 2002:a05:6214:19e1:b0:6e6:659d:296 with SMTP id 6a1803df08f44-6e6974f600cmr27524536d6.5.1739923486486;
        Tue, 18 Feb 2025 16:04:46 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e65d779348sm69090416d6.12.2025.02.18.16.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 16:04:46 -0800 (PST)
Message-ID: <655e1fbaa8470cba823d3d0429af3d2f4f24570b.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/6] x86: LA57 canonical testcases
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Date: Tue, 18 Feb 2025 19:04:45 -0500
In-Reply-To: <20250215013018.1210432-1-seanjc@google.com>
References: <20250215013018.1210432-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2025-02-14 at 17:30 -0800, Sean Christopherson wrote:
> v2 of Maxim's series to add testcases for canonical checks of various MSRs,
> segment bases, and instructions that were found to ignore CR4.LA57 on CPUs
> that support 5 level paging.
> 
> v2:
>  - Fold into existing la57 test.
>  - Always skip SYSENTER tests (they fail when run in a VM).
>  - Lots of cosmetics cleanups (see v1 feedback for details).
> 
> v1: https://lore.kernel.org/all/20240907005440.500075-1-mlevitsk@redhat.com
> 
> Maxim Levitsky (5):
>   x86: Add _safe() and _fep_safe() variants to segment base load
>     instructions
>   x86: Add a few functions for gdt manipulation
>   x86: Move struct invpcid_desc descriptor to processor.h
>   x86: Add testcases for writing (non)canonical LA57 values to MSRs and
>     bases
>   nVMX: add a test for canonical checks of various host state vmcs12
>     fields.
> 
> Sean Christopherson (1):
>   x86: Expand LA57 test to 64-bit mode (to prep for canonical testing)
> 
>  lib/x86/desc.c      |  38 ++++-
>  lib/x86/desc.h      |   9 +-
>  lib/x86/msr.h       |  42 ++++++
>  lib/x86/processor.h |  58 +++++++-
>  x86/Makefile.common |   3 +-
>  x86/Makefile.i386   |   2 +-
>  x86/la57.c          | 342 +++++++++++++++++++++++++++++++++++++++++++-
>  x86/pcid.c          |   6 -
>  x86/unittests.cfg   |   2 +-
>  x86/vmx_tests.c     | 167 +++++++++++++++++++++
>  10 files changed, 645 insertions(+), 24 deletions(-)
> 
> 
> base-commit: f77fb696cfd0e4a5562cdca189be557946bf522f

Hi!
No major objections to any of the changes.

Can you also take a look at my other patch to kvm-unit-tests:

"pmu_lbr: drop check for MSR_LBR_TOS != 0"

Thanks,
Best regards,
	Maxim Levitsky


