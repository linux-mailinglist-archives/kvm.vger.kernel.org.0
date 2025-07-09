Return-Path: <kvm+bounces-51941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C127AFEB97
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:18:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E6913BD0DB
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A54662E9EB9;
	Wed,  9 Jul 2025 14:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PTxIKlRN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9487D2E719B
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752069985; cv=none; b=rI7g0Y5xeGFkxaP/KOFQtzTU2kQ5djfZHnl9iXLJj08YYm6LfrzM19fjkQM442i31h6qCVlCeovutStc5ec4bbnxlO1kIQgPI+cMvVVxwKJG/XdCl1rBZb/zGMCFcnpKQu6MPwKU2d9B1+r87YL6SmnBqVtO6VIHSHSRHJCdWm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752069985; c=relaxed/simple;
	bh=WDjc3gj4jQOgT0wQPLLNSrhraX36b/fAJ5t6OlsrilA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jr1hWVdxxc369sjzZ5awlRBRqWVSLD4Arc7J+HoRTy4rWRX4wemtAQ+Za8/CyTLZTzaJQ/uvap1AX6ajKGjNMHW3SvT/CEJ2+zxMhosRqaLyOWoH9K/vkhWuQgp0TJqAPZ7bq6IIY4ea1BO/p6DAlH71m2ErZqx1CeWeIRaJFhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PTxIKlRN; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b0e0c573531so3888077a12.3
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752069984; x=1752674784; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rpVhcnqQ4QopgzrrBAwITtPwYaxzjuUgzAB3u2opJd4=;
        b=PTxIKlRNhS77rr8ToV4HuRPyqWpMY/EmYGAPmXSorPzFKYUnwZsQvvhBCZgffqcokS
         NFPRg/mupUHnQHeYk5CrsiqJnTDWFIe4fDuqteT3bW52osTMz+ofoL0+VTy52Gad1MME
         ZrzM2zid9A+TBdu65grxfZOI09u+Pe3NB2uwvFJPhppjlhU1VNmyX7Ry/hSZqKL+CMnw
         jC8jVly32lmzQpe3dhMrokfbymI16uQNV7d6kb1EHI4yCfEc4K7vxL9uRbn6c4Qy8OYQ
         SPd0/yChiVrd3Gn/d2WcHeZYQKN4TYfrFl0IS+4quLhnddgq2/mWkmWuujFmxyqh1mPg
         2h0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752069984; x=1752674784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rpVhcnqQ4QopgzrrBAwITtPwYaxzjuUgzAB3u2opJd4=;
        b=PXxNjMbLv9ZboKy15nL2x2iVkYTwUBdPKT7HZeue91Sd603pq1HPfMkeyxtrKzl09A
         x0PweEumvarvXYs5RTJht3s4dJjEBskhVCTLDoEFHCEYKFqkTbMyYOdm4/0/nvCzlLjl
         N8s4GwQfn2eFVSd2kb/hW10FTJpl/fTuGlF1RIfrN4WZLTR8P9eZH60mkjo8U8+l/X7+
         7kZNkxDpll+UcdMXL/pGsCb6bYAmIb5zGwacMgDBtldGbkCYQfVPKY9uAg3xX477Pker
         Ey9znmnS41YxygNNWAqRvxb7OOZmEqI11IODHhotwXh6lB8dymHk2obGW9Mj/xDib8N/
         tCzg==
X-Forwarded-Encrypted: i=1; AJvYcCVIYtl0NInB1KGk5wpDrf9aaSTnfSKqIcRtGkzfAyqeNJaNDehaTTNVP5cVJyWsalyHQ8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhpjbo2oPV82AW26yBVa3c00fxwzwe3nSqWtH1kCnnLiTi9t9D
	uhdeRffjc96zP5Wzc2YpFZwUhSuGMdC6gdXRpEfne8+Y4vXguU+ht+vGbgmalNbK6MFn/HylOy5
	UyIa1Mw==
X-Google-Smtp-Source: AGHT+IGHAf/W0Pdlaq5GH+DDJpvg9O5Pkb7w1Gmd8Aste4OllMRWIMmZLxVBD8UYx6G+uWRoqyjy3+F9l2g=
X-Received: from pjbnk16.prod.google.com ([2002:a17:90b:1950:b0:31c:2fe4:33bf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a8c:b0:313:d6d9:8891
 with SMTP id 98e67ed59e1d1-31c2fccddadmr3702955a91.3.1752069983670; Wed, 09
 Jul 2025 07:06:23 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:06:22 -0700
In-Reply-To: <20250709033242.267892-9-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-9-Neeraj.Upadhyay@amd.com>
Message-ID: <aG53XtIe_FPwi7Aa@google.com>
Subject: Re: [RFC PATCH v8 08/35] KVM: x86: Rename lapic get/set_reg64() helpers
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
> In preparation for moving kvm-internal __kvm_lapic_set_reg64(),
> __kvm_lapic_get_reg64() to apic.h for use in Secure AVIC APIC driver,
> rename them as part of the APIC API.
> 
> No functional change intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

