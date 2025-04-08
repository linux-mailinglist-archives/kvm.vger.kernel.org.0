Return-Path: <kvm+bounces-42961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C2AA8172F
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 22:52:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 500FC1BA3920
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 20:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE13253334;
	Tue,  8 Apr 2025 20:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ht4RsMjW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A683723C8C1
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 20:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744145496; cv=none; b=NiFGrVOX5MKgd5XCZ8aTOH8fAABfNqZOk7B4wq8YZUEwaTUau/V7MjlgkDT5tB3eyJsECCYFfBqoRBXeke/PDK7HkQUdqKWik0HTOjwk8ZVfYsYj7lJ7CzOfoZnHW4BINt2YjoifjvoL6Sa7Nplwl4/hEIInIOQeUAXEME1a6lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744145496; c=relaxed/simple;
	bh=OMfNblk7e1bqcX5flCxsW4kUHjTHdM3NGhtOUfpBXUU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Icy/QFbCRHtXb9uq67qoO6o3AH6TyCzYAwyxz/cwSKKmJ9DhugMcHJkxg5mVW2cVoZ7tOYAbFn7RJRjQuQS8kit2cj/9YdhzZ2YWOHdtOWimJFLZ0Gp00oxp7mNMM4mmkBmW6gMLoXR51UZvNjrFqVWusRx3YD6IOmDqXaQxA2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ht4RsMjW; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22650077995so87332535ad.3
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 13:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744145494; x=1744750294; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BTcE6+WHWu4qnclYQMHYIxEySZ/v7P1Al1jdu/317JQ=;
        b=ht4RsMjWVYIBhZOkNjCATDYrPg+qYrvvE10s3cmSdqF2E9s/GJaAQ5dE6L2Xi9aZXE
         42IgKZkQvVPHUa5X9lHGpBbxcYBSLtnoipzpW9FN85SYnNG/3Vv3XQkw0FsK2Qf48KZB
         Fj38ujfN1tS57GGJFI6ni9gq+t8H7w9bntMyxAjuG0Yq+Nml07FyTHAzTlTXJ1Ws8u8e
         uK+zras/Elyq4h7fF+qdHj37WPLlai/pZeR2z3rjfTH0hAi292NYMuxnKw3/PtgsNN4C
         79cXGuNBtEfcWCqb4jA3R8b0gk9llYWJNqs/dzG/vyk49etgz6z1MMJdHPao3c4INck7
         Gg3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744145494; x=1744750294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BTcE6+WHWu4qnclYQMHYIxEySZ/v7P1Al1jdu/317JQ=;
        b=TE6KDruDFsmW7RAclLwEAUYi/hGkaUNQwd7ByFUjSRxzTx1mcD9rPRV9YaMuHaBoHS
         iJ9ESHGdqlVDKf7jgweiAbTPcvApoaZl8Bd8gWubVxlbF3iRbZ3M773+ke5lCFWpGUL6
         ixS+UWctMfnnQG2AsNWrcLvZHwhx3k4ChpgqvVfg6F/cDSIOS2AdcNMYtLaeaiTNocpJ
         uL/RfmfH9AOlHIpm2rMH5tWTr/n3HtcKhx5MkAB3h5vOBp6kwM0jLrDVdHPYGLMpEGge
         1XQTVSU1S34fptSdCPrMeMz7b4axEEk9HDw2WL2+7ecQMDYj/knA4Pq/OvPxX1wCliX+
         wnEw==
X-Forwarded-Encrypted: i=1; AJvYcCXAiXuTNbLhr7iIhQ2a2iDShN7ctgw64PDZVXB+oBHbnWy131wh4I3AgW520s4BDLT4OAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLKzC9R2GB/oXiUptM3HxYS6qMbscodRQvjgz/A4mjCC1XxQDi
	CIF/W9I4F1InM8lCAueHwJxC957rdxAhQh4J/+I84igRjXQuUfxIytOExfVoz5owZEYA/yko0Le
	9zg==
X-Google-Smtp-Source: AGHT+IEkkZsY8ruaiafHFgvGKu+qq4+sFmbSt1BxoMGSqk6S6uLwO7DhByw4VjeW33u71GKRfK37WDJpDHQ=
X-Received: from pjbdb3.prod.google.com ([2002:a17:90a:d643:b0:2ea:3a1b:f493])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d501:b0:223:90ec:80f0
 with SMTP id d9443c01a7336-22ac29a85demr8617275ad.22.1744145493932; Tue, 08
 Apr 2025 13:51:33 -0700 (PDT)
Date: Tue, 8 Apr 2025 13:51:32 -0700
In-Reply-To: <cf4d9b81-c1ab-40a6-8c8c-36ad36b9be63@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250404193923.1413163-34-seanjc@google.com>
 <cf4d9b81-c1ab-40a6-8c8c-36ad36b9be63@redhat.com>
Message-ID: <Z_WFolTVWQtkoNIU@google.com>
Subject: Re: [PATCH 33/67] KVM: x86: Dedup AVIC vs. PI code for identifying
 target vCPU
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 08, 2025, Paolo Bonzini wrote:
> On 4/4/25 21:38, Sean Christopherson wrote:
> > Hoist the logic for identifying the target vCPU for a posted interrupt
> > into common x86.  The code is functionally identical between Intel and
> > AMD.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  3 +-
> >   arch/x86/kvm/svm/avic.c         | 83 ++++++++-------------------------
> >   arch/x86/kvm/svm/svm.h          |  3 +-
> >   arch/x86/kvm/vmx/posted_intr.c  | 56 ++++++----------------
> >   arch/x86/kvm/vmx/posted_intr.h  |  3 +-
> >   arch/x86/kvm/x86.c              | 46 +++++++++++++++---
> 
> Please use irq.c, since (for once) there is a file other than x86.c that can
> be used.

Hah, will do.  I honestly forget that irq.c and irq_comm.c exist on a regular
basis.

> Bonus points for merging irq_comm.c into irq.c (IIRC irq_comm.c was "common"
> between ia64 and x86 :)).

With pleasure :-)

