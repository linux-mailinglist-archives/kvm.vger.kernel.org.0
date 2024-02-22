Return-Path: <kvm+bounces-9446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 673EE8605D9
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 23:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B2B3B23423
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 22:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80EEC1C68E;
	Thu, 22 Feb 2024 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iVbh+rMW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B6C18AED
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 22:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708642534; cv=none; b=fcz6qcmV/g/dgLVVObdfDhxEGOs0kLLLT0M4IzrfdbU/f5qb/BcC3v7RwrLAI/GlVNWBVz0RJzNY7M7iXR4EbOl1IhckjhUvaXKXTdOq4/XXG2XrKUiyCh7zMY3hZRLE+vkK3UNAXZ7H0S0dhyOoT9Lb4yFbpczaUIq8yDEfkF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708642534; c=relaxed/simple;
	bh=v30ix5UBN1fgNn1Yl2t1RwDrBFJ0VxBN5nvmOI21F6U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=sBFXcebDf+k1HEOT0l2aALP+7Rvp+2jrFDH6X60CeE3NITc+/ju69+tu5z6BG5QdBzZ6ii7IzOVXmrR737HWMlpbsRIyNqX3kwjN3HL9qnenn4KS4vYvfqndJ17zjwtuIHlfalRYhadCkdrrD5KGfH6kc+cpwatvNfGbiCPD1zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iVbh+rMW; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6088fa18619so4166407b3.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 14:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708642532; x=1709247332; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vd/YICqtxLMDMc5n5d3K7q6H9URrpma0RkwQ+FIE2QY=;
        b=iVbh+rMWQ7Jm42jZnvb6vlQywoLqYY97GROYBSQ4xVA7KARLuS6yPX8kTCcZhaZOSD
         6P104Kjo6E78M21IH863nF0FiY2Z6tkoMspzgvqhuGE9AQDk0UJfLZcSj3CtY91klNdx
         B9VjQ0iClYdZ4qoi9H2wPHcBeDFRg3Ohz8ZaPEJRI5yfiFxRZhIVUECpo319vm3pW0ew
         zSxhGKzgxs0lS0B2queBlW3l/reYoIoTGrUubv0ZtprfV2EZWcq33yyoMG3IqYsOkDrJ
         Y0xnp0i200mTCy+5e2Y3S5XWOKkjMLkDo9bH9Uf94FiJ3i/oD9gAmuyyyqc4eQ0LCf1o
         yEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708642532; x=1709247332;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vd/YICqtxLMDMc5n5d3K7q6H9URrpma0RkwQ+FIE2QY=;
        b=FNNXwEDAxof/q1Oy5Z7qz8owvj4yCJIi5BIiYmZiIvEB1MRBMT9CW6T5OCJzJvIPmg
         XXfqP+wJHxScVy9nmm0d5AISS5py60mxXzLqr1wMYoQ3y6B7yOnjXv+z3mK8SqRov0S+
         fbjkNLLtcw41R1Zv9eyMsoSTF5/wKUpe4l/MzPpqjqKRzlbMyS1yn6VqfrKZHxmS+VJr
         Gy9Qxb4JIGOO3hd0IxKNOUtg08YOtJu2Hm03dWt1RndY+84/kI2//n2YXy+6ilZW8t+p
         Rrj5rDXdIPSneeaoGXoYBh+QvaRtGZ4IvLmt3W8KAH4SSadP1qyFqw2ydGhPMNu7/879
         tI5A==
X-Forwarded-Encrypted: i=1; AJvYcCVb6fxaId1cSZHp5+lsNtmdKgaP7Ni+EZkF7n2PhZ711bbSOz/PHmnu8tRx/5hsXnlppldONNZfD6dU9O+YmtDYsyA1
X-Gm-Message-State: AOJu0YwMwYne1C7TRwMxB/7iTyO6wBQlv5SS4YOUAoAW6lP4cCJLA0r5
	nDHB8wT7FNFJGqFtjqY4OdViYpaLm/7M905awZay+TGD39C2D/96PwkzmgfDSnhMO5+aPa9KXgr
	xzA==
X-Google-Smtp-Source: AGHT+IH6zbDx9owFk0HWBGgG9KN5obudLpTf6CD+r6Pc0oEDuyl4v9GZAk2ErtxIMUz9+tCkdL7Tsne7vIE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9150:0:b0:608:a1ff:6c39 with SMTP id
 i77-20020a819150000000b00608a1ff6c39mr130883ywg.2.1708642532143; Thu, 22 Feb
 2024 14:55:32 -0800 (PST)
Date: Thu, 22 Feb 2024 14:55:30 -0800
In-Reply-To: <ZdfNwhe2s0Mn2gB4@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com> <20240203000917.376631-11-seanjc@google.com>
 <ZcKYRsNUAngWGy2a@google.com> <ZdfNwhe2s0Mn2gB4@google.com>
Message-ID: <ZdfQ4jI8yT-bvbV4@google.com>
Subject: Re: [PATCH v8 10/10] KVM: selftests: Add a basic SEV smoke test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 22, 2024, Sean Christopherson wrote:
> On Tue, Feb 06, 2024, Sean Christopherson wrote:
> > On Fri, Feb 02, 2024, Sean Christopherson wrote:
> > > +int main(int argc, char *argv[])
> > > +{
> > > +	TEST_REQUIRE(is_kvm_sev_supported());
> > 
> > This also needs
> > 
> > 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
> > 
> > to handle the case where the platform supports SEV, i.e. /dev/sev exists, but
> > KVM doesn't support SEV, e.g. if TDP is disabled, if SEV was explicitly disabled
> > via module param, etc.
> 
> Thinking more about this, I think we should simply delete is_kvm_sev_supported().
> (a) it obviously doesn't query _KVM_ support, and (b) if KVM says SEV is supported,
> then it darn well actually be supported.

Ugh, and selftests also need to handle the scenario where SEV is enabled, but all
ASIDs are assigned to SEV-ES.  We could try to create a dummy VM and check for an
-EBUSY return, but that is ugly and could result in missing KVM bugs due to tests
being skipped instead of failing.

That's a future problem though, because I think we'll need new KVM functionality
to surface that information.

