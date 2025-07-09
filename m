Return-Path: <kvm+bounces-51938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 629F6AFEB96
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A16764A1013
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A782E5B0D;
	Wed,  9 Jul 2025 14:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KJGQ6yMA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE09291C3D
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752069945; cv=none; b=Zj1U5oNixZikIQJQ5bXbFk7ISv/IUn+YOhmbsqLAX7lzpnln4squqN0JsrnE9hq1FVGQ7sp1xPOAhVvwFJy488DVSssAtRw1dDuTHi/GmCeQpWuyQWFBUVcPERRf+x9Ux4IP/YagrYr44LhMn6ss+2zbSJ1Exvkw2+nww9jyjMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752069945; c=relaxed/simple;
	bh=PUvIaqsWfsVx1IqeqReOjQqX2mL4vrwZF2ErZytGi7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mqwdSxdJnrsBifFr+AZX+tu4NHDHSh83qGS8/Uxn6+2sVA8njXyzmgord4X8L5CkIvLWm2n0kz4xgKAizwgRlqHGLDTs3aWbT4vSB4sUwRxJc1i30hfqfXG7GHwgwNAn70NHsfagepPPYmmkQFE5LTxooFr4xHIzMqvLU2drzug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KJGQ6yMA; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234906c5e29so71198255ad.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752069943; x=1752674743; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1jYnZjZf6ufM9SyHc+iG+DGsukrd9VmFJ4DhvE9WEkQ=;
        b=KJGQ6yMAST3fNo+SA80C52jiw161cuorLhz14u/Z/eD2kvXSafJA73ffoU9CYeyWR/
         BqyoCfunKZJmOEKl8k4A2ig//+BLNz05x1psftfjSy2csf+699R9vxPCkkUcQ8ykdKVt
         q5ThJHsAn0t1R5lMlSVbSBzCjTCgeCDWHFAdFzQepoox4pkv9BNm03tXJfTtNeO6l2sz
         RzTq0TCT+Sg5XIR+Py3WCMm9dCnU1RklJqUPxNCrMjkNL8jCib0tulAhAs1dcj3w5Jk4
         3QYEDjvr3dooRNsL+0rcyDF7+oWVrYJCVC7JkApDty1QBti2AwsXAfaDygLP+HUvmXd5
         paUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752069943; x=1752674743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1jYnZjZf6ufM9SyHc+iG+DGsukrd9VmFJ4DhvE9WEkQ=;
        b=maoLxTsaBYuPSUzfT5pZCvQb9bZpioMHV+DthESbosafO/KlF9A9g0mrO4cNyZx9LL
         KQkwt7B3Rzn5M64ZHByhWlVKe4xxepsqGtpRQiP82MpKlCDME3mWOkpez+i8BBKF9Opi
         +4o4pepMcRuTv0S6DM6+ZfKEaCwGMm8ipbA1y+8TWdRsBrRI2etUg6OUlQp8orXERRNV
         CiMZKIb/4xUuOczZPpgoIJA/Tl1uD+LO0ccALaKgTkXqusk9nVwmx9rIR1op/j9ZonLi
         Tk9xO0CdZKPN7jag2cLVZm6aYRLSW4PnbRifcwTq+faiQ81nGJfpolaTBxKYHx76YTla
         58Hw==
X-Forwarded-Encrypted: i=1; AJvYcCXTIFxCVvExQba2MytGrc33f+0UDfsPfTidSebJxkgMh8wuZaHvUCLNYLpVHpeBKMMb6ig=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpuTzSugEaMhvXn2aac/aVU/iepVKL5jkb7JsuA3gTS4pHJZMz
	WYKs6XJElHkyOjwuSjqLNa1mSuXyMyiTT2WVeKdsj3V4BN/Uf6x1DtQWzAs1j2naqx4bn/Ib/kk
	7nl3uwg==
X-Google-Smtp-Source: AGHT+IF5YmCnSm3azK2lqCf9HxbkqI3KFjMgu2W7dGogQud3tJLYHgc16fRocT/6iMSvPs5pSKJvEZhdEgY=
X-Received: from plbg4.prod.google.com ([2002:a17:902:d1c4:b0:234:c2e4:1e08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec8e:b0:234:a139:120b
 with SMTP id d9443c01a7336-23de2436c91mr787235ad.11.1752069943226; Wed, 09
 Jul 2025 07:05:43 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:05:41 -0700
In-Reply-To: <20250709033242.267892-6-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-6-Neeraj.Upadhyay@amd.com>
Message-ID: <aG53Ne2hYrG8rfFR@google.com>
Subject: Re: [RFC PATCH v8 05/35] KVM: x86: Change lapic regs base address to
 void pointer
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
> Change APIC base address from "char *" to "void *" in KVM
> lapic's set/get helper functions. Pointer arithmetic for "void *"
> and "char *" operate identically. With "void *" there is less
> of a chance of doing the wrong thing, e.g. neglecting to cast and
> reading a byte instead of the desired APIC register size.
> 
> No functional change intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

