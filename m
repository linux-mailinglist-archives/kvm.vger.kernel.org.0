Return-Path: <kvm+bounces-57241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A393B52044
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5314A1895FC1
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E8A2BE657;
	Wed, 10 Sep 2025 18:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RVKJYhBQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94E925C80E
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757528988; cv=none; b=ZPk/lpTbonPZ2xmk2Uy7Qxd8oHk0xqtD9EEPubxArGMgZOHQGfVxkGBHvLn2flKgkdl1j0lUSf6AvAQU2xB+KXhXiyBEBObJHvUQLay/sqFwQg5PvvlYWXsOYw7z8lfSGhdGfCkyiqJQd0+l+vaKzTjLFqQC17PXlsWdak6ZgkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757528988; c=relaxed/simple;
	bh=O9ecuj8kRXRq6dEl5kGqSphF2XCxCU5mNbrki8VIT9o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ox0P+BzRWHac0ycubIAO9JiIVWVhxS/E9XYYQJnZBk2BKMTYwqGrE6m2S4zKb6x+k3eYOZhnkXV5H9hSpSXaX9y22iXrFwKeQebPKWtc2nXXsuixzIoxBojB7YKx1I66cqKPm2guDKibyVg1lGNVgfE3yKEVrvHULjvSK4PqaXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RVKJYhBQ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2507ae2fa99so122983205ad.1
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 11:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757528986; x=1758133786; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MtiDzw6RmLEmA2FOdaMw8DNJxzNAmIgO0MAX2XQmYOE=;
        b=RVKJYhBQ3KKjjezygxtC+yg9IzHXElg8NhaSR/vylxevedbQZ/F5Ab6Tf1kTLfErCE
         4zoPwh4QbHFOc0yqYjmGhPfiZgDYwY6MoJL+SkljMVAxi0ItiAW6qfxY/deozg9XFxO6
         arvJRYg01jZ0hHV2TXRZHUxpy41xqDGhw0wGW7GkUOeIeeANB7ab56+2mBweN96oAmgF
         Vfc+UoCcbPMS+/Bw1iARtZ2hQOKvfvzd8pkapeOmBmxSUupfgytqsdIz+FkDMvPtHm4A
         bCFh08JxwM0fx7smQfFfGIXjWinWZ2oX7G3tYOquALGCVBL6ggAlMwyrQ27MS4cADK8r
         O7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757528986; x=1758133786;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MtiDzw6RmLEmA2FOdaMw8DNJxzNAmIgO0MAX2XQmYOE=;
        b=eG1u4JH565fmMbWSpmWAcz/kY6RSjawcT5eITURxIcTV2dCXZm+2iFnYq2njquo0MG
         r1hBfWGcPWV8xk3NwR0msSyc5E+iD6mzNx75OuM8g7/AkYWkNn2GG0x9c6qeVWmUDMiR
         37+vHTghAm9SRbNv3F2QlmxG6rqcISlxDaDzyM5W6m4iLZvO7vnJy5gVJpMc5flzRW3D
         /aQX3d4hqzfdquqFWIVXdurGL3/kSrqHva5xDxLQqykXlYCm3flFm4dVuasQwz/Ya/Y0
         +jSTgOmWHqqVNhrOjSdxZxjwQIVIOdNnxH49+2ChC8xGeq/bbrZvFJEqbIGXNb55dVID
         9Zfw==
X-Gm-Message-State: AOJu0YzRSkA9ZPjo4Sqcfe6pq4pnd4DD4gGVaqTRf+oBYO9Ahv4aDKqk
	9I4d87y2sGFC34GU0emDYgdPJCRpIBgW7qiGQMM9GXXR5jFo/ynozyH+4ySo42NQWk9hECFmE9o
	5wJN5Nw==
X-Google-Smtp-Source: AGHT+IHDAjtJnh2q/ezPGV1CwRbRlP2Vheml2ZcWOEaCBTqyS1/Lt4YX44JMxVa1LU+2TnaPjQioFqmGGcg=
X-Received: from pjbkl5.prod.google.com ([2002:a17:90b:4985:b0:329:748c:a5af])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:184:b0:245:f2c2:64ed
 with SMTP id d9443c01a7336-2516f04efefmr243902875ad.24.1757528986042; Wed, 10
 Sep 2025 11:29:46 -0700 (PDT)
Date: Wed, 10 Sep 2025 11:29:44 -0700
In-Reply-To: <aL/4548thhQFylmp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909093953.202028-1-chao.gao@intel.com> <aL/4548thhQFylmp@intel.com>
Message-ID: <aMHDmGmW8QzyDv7X@google.com>
Subject: Re: [PATCH v14 00/22] Enable CET Virtualization
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, john.allen@amd.com, 
	mingo@kernel.org, mingo@redhat.com, minipli@grsecurity.net, 
	mlevitsk@redhat.com, namhyung@kernel.org, pbonzini@redhat.com, 
	prsampat@amd.com, rick.p.edgecombe@intel.com, shuah@kernel.org, 
	tglx@linutronix.de, x86@kernel.org, xin@zytor.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 09, 2025, Chao Gao wrote:
> On Tue, Sep 09, 2025 at 02:39:31AM -0700, Chao Gao wrote:
> >The FPU support for CET virtualization has already been merged into 6.17-rc1.
> >Building on that, this series introduces Intel CET virtualization support for
> >KVM.
> >
> >Changes in v14
> >1. rename the type of guest SSP register to KVM_X86_REG_KVM and add docs
> >   for register IDs in api.rst (Sean, Xiaoyao)
> >2. update commit message of patch 1
> >3. use rdmsrq/wrmsrq() instead of rdmsrl/wrmsrl() in patch 6 (Xin)
> >4. split the introduction of per-guest guest_supported_xss into a
> >separate patch. (Xiaoyao)
> >5. make guest FPU and VMCS consistent regarding MSR_IA32_S_CET
> >6. collect reviews from Xiaoyao.
> 
> (Removed Weijiang's Intel email as it is bouncing)

Yeah, I'll try to remember to filter it out.  I'll post a v15, I have a decent
number of local changes and fixes (see responses, hopefully I captured everything),
along with a more comprehensive selftest.

