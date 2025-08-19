Return-Path: <kvm+bounces-55066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61846B2CFD0
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:22:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE8B71C44C78
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFA526CE22;
	Tue, 19 Aug 2025 23:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LUWBSJ1S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8C2259CA7
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645503; cv=none; b=X/jrhMZ1ol4nTQKbLTTlGHP8FY/IIGf2mmQhl6NTnH+Y4frORo1ob+epKPmaVcd35DYfk1cuPezuqNdqM04fdNse6wt3CTFx8eqGT8KS+ShAxF93VjEOzoy5qRo6XtYaJUz64WisDnMqBtIqzoTzLOZOMqwcuB2B1XgBGVPCUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645503; c=relaxed/simple;
	bh=lVXQBqnqbxpFe1IjAlD49yL+k/R3myhx9rjbCNek3Y0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V/iR2KzREcE/Y3C88rEj1UH0v736VlQ5ivsdwjQGkSSsAaHDn0PoOFYsRvBIzpGWH8fLHbtXxWDva3DC1VmgQaGCuRNlztoaLtwMwbo7+5J8j2WPZ4XucXn2EIEwNdJHzGgoEm0YOKkZcwuAvrR4y61c3pL2xvwHytsdwezKpZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LUWBSJ1S; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2445812598bso157685025ad.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645501; x=1756250301; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rONFSpHM+4UT9RUEpdOXX+LBPAp0V3YjAVNh2Y6TMoA=;
        b=LUWBSJ1SCYZwp5KvnodCzvgtixetO/uNManEEbvcOged4m1cs5wEi0l5oZTFEJOMha
         s1CZKDlvFVFk5LfI6Tn0d0KSaYJQMHu2sMBE0IODBOugz70fdAbIIPEnFn+CUrQviU/b
         vzbOfsqcDwNcrY6dmR7v0k/2WXSxvO1QcqSiDpYVFNbe1bTMydv1qL9prWdagRe8W+83
         0UA8gd/WN/imPYZTCxEuuXinlf8RzN2MLbqjey3Ehu0St6PyYTZ+0eZAD7ZHYTWnPLP1
         CvRSCCG6N80uCoodfsRc9kRJbX0Ks5xn9oJ/IfITjnamJDjQT+m1IJeOUagRvdJHtvGY
         Cchw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645501; x=1756250301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rONFSpHM+4UT9RUEpdOXX+LBPAp0V3YjAVNh2Y6TMoA=;
        b=tgyCLj3w1NwHOe7Cg4TMF8DZU8G1C7qnKPls0RDFhJDaTp70M6C035zHhqOeotI6Ik
         aVLbMw5G4QrmyljqvN2yCeAzCQ60xe2yPiO1HO3x0yqL6/bbHYSC3qMrwrmH5UDv7nZi
         CY5UYii+1kxZs4b4kPK4BGpSHybSPGMH94Y5/naSP9gpvVUXpWvs3HQLcbolzfMIC+CG
         535uqRYSYEXxpFaB2E05gavfHVwxgXiiqQz2YRWWpJyNUjBjR9l04trr1UU3ck8WYvI0
         Gw7soKt/7tbKYZGPQU0BAkzhPRPJYNJXloXsnPjsBRwj2st8+eR2YpoD1rxeXXxxP+li
         Em3g==
X-Forwarded-Encrypted: i=1; AJvYcCXwvbp9381DUZGETo8f20EA/e1InymZ2gJEUml1YisoGIRfb2vHXzqgVLal7hVzG/FEXbA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP9q5XaVkYbbi2calV74iRJjHZNYeZniw170yrF+h29pxU05pM
	VvVZTvgSlsvj1uaCidVQoH9W5S5EWQswVybxh/Ff6WXGXYdsa8IPKDIVagqm0Z0XvH5qvgaIBNu
	Xhwlm4w==
X-Google-Smtp-Source: AGHT+IHqe32KfT6dho6aCFJ3G/d8VrXeyydbRiGHvGnmJfWMRn3n7mFQuRV7TKc7F+1F+ayU2D2GFF3pcFw=
X-Received: from pjxx12.prod.google.com ([2002:a17:90b:58cc:b0:31f:4e21:7021])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ec7:b0:240:1bca:54
 with SMTP id d9443c01a7336-245ef1e87f3mr7883665ad.35.1755645501030; Tue, 19
 Aug 2025 16:18:21 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:12:21 -0700
In-Reply-To: <20250626171601.2293914-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626171601.2293914-1-xin@zytor.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564427331.3063305.13126467496293838105.b4-ty@google.com>
Subject: Re: [PATCH v1 1/1] KVM: VMX: Add host MSR read/write helpers to
 consolidate preemption handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	"Xin Li (Intel)" <xin@zytor.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"

On Thu, 26 Jun 2025 10:16:01 -0700, Xin Li (Intel) wrote:
> Add host MSR read/write helpers to consolidate preemption handling to
> prepare for adding FRED RSP0 access functions without duplicating the
> preemption handling code.

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Add host MSR read/write helpers to consolidate preemption handling
      https://github.com/kvm-x86/linux/commit/65391feb042b

--
https://github.com/kvm-x86/linux/tree/next

