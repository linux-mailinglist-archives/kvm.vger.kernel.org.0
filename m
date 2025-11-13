Return-Path: <kvm+bounces-63057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E5F2DC5A4B8
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:16:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 97A374E292B
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA0F325707;
	Thu, 13 Nov 2025 22:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lxnH37Cl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9D923EA8C
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763072206; cv=none; b=Zr22ZYaJjRSsFBO63x12NYqfJRRJzUevZ5OMN84G+0cOFpWYzgTb36fhSvKTqHnuVBiLx21W8y88UVQyXhDnenKLAS/+AjcUias6ntdNaZIaSQ2SUwMY/F3T7UZbWHdoii2DC7fQvpCqw4NdDJejZaK8C5cE0+GgjBbc3mZAPhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763072206; c=relaxed/simple;
	bh=JdBQcAsWlFlo5Ha79WPmayx98/KwI1e52xQFhXG7Mm4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qo77t2p51g5JyBu2OlIASaUzpwPv7CUmTlqO5/wXaaIKmJp16O2jVr0TZw73gAzZ8a6gOm52hHBwUri8WOT+ftBJ4OjouFJowUuStJuK5X2gMcinKoKxw4DxtsT1X0Mqi5C1SVuZYnjbV1ANLB97XxgPtZbbgvj6PjSqMyjTZYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lxnH37Cl; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b895b520a2so1492794b3a.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763072205; x=1763677005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMjpCguEvQW7NYJGx/IL/F0RtN/3l3y8bsXjBCAVXoI=;
        b=lxnH37ClDM9gXFPyI17IQxW8FaK7ru4z/gINfNy9qEsdqRK5B252f1He3yjxXzdhYW
         +ka49P+dCqLvuIxA9B7SqyAsJmjbpbDWOBdZbhALJ112TxtVr6t5ntYeTHquViBK7WA9
         /RNQTBBdbBPTyUQrRxBIMfHHY0d1IdK//Ca+cQh5xUDeCW1/eRgZCz0yxHtSzfRfGDtU
         6ilBjbq6DLaaza4xpRK4mkcZM++RFGoPSalz9A8xrXGoy7BQydk/sto4jG8T35EZO7gV
         sC4bXq4au9++Yn7D+MtX9JxqT4HQc4poaomncdHuW6mtwbk/QJIoVfzOeGHfAGc1juDC
         fUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763072205; x=1763677005;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FMjpCguEvQW7NYJGx/IL/F0RtN/3l3y8bsXjBCAVXoI=;
        b=RYWaxmxI+r9ddFLhY41aSLeHzJ3pCqwY3mllgYf4WyO06nfjnIOFe64i/xVS08XxDB
         2/SZ90M6RlSnXd4Y3eGrFF5pTrf1sCrFkVOnSXZo9wzPG4FB0KFO76WHzDWQzxjP2gaS
         ZcAQfKvCSPIpadvW6tvjUVqWgG6fk3A7VSIIL7e2atPfocnUUAmgYhS/JgcjjZJP6zT9
         7o7eHDt0gPo0tx1ilBkI8peoh+a6GwGwpi2K80fxtKs5ndvGilCCMcbUHhTQXsJCy7Qc
         nF7MZ+F8hyMnZCkv3f6V+NvabdzaFxst0IUirZjgRfuo+5L53NXKTY4EQyZOcMVbaN2x
         oH/Q==
X-Gm-Message-State: AOJu0YyGRaYPavF2ZAs/7FV0An19a+/d7LS1n6hcYEq8/NI5pHULjUSU
	WfYdUOwBwpkb4Ogp4M9XiGenyef/yHnvT/InlwptBZvvE/DHdWxv5StxxCavbg2GfADIGlQl9YL
	ouBoO2w==
X-Google-Smtp-Source: AGHT+IEtTwZ+tNJ8n3My2Pmt/4zjqfSexjTdTxns2w+dvgW8nsbwrXm9O1sqJ6JrsJVBgPG6oQcrv4tTAZM=
X-Received: from pgbgb8.prod.google.com ([2002:a05:6a02:4b48:b0:bac:a20:5ef4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7352:b0:34f:4309:ed32
 with SMTP id adf61e73a8af0-35ba0578077mr1328229637.23.1763072204716; Thu, 13
 Nov 2025 14:16:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 14:16:40 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113221642.1673023-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: SVM: Add fast MMIO bus writes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add support for expediting fast MMIO bus writes in SVM's npt_interception()
to match VMX's support in handle_ept_misconfig().

I don't recall what prompted me to write the patches; I suspect it was a
"well, why not?" situation.  They've been sitting in one of my bajillion
branches since May, and I rediscovered them while looking for something
else.

Sean Christopherson (2):
  KVM: SVM: Rename "fault_address" to "gpa" in npf_interception()
  KVM: SVM: Add support for expedited writes to the fast MMIO bus

 arch/x86/kvm/svm/svm.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)


base-commit: 16ec4fb4ac95d878b879192d280db2baeec43272
-- 
2.52.0.rc1.455.g30608eb744-goog


