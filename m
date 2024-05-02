Return-Path: <kvm+bounces-16430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2598BA096
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 20:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B4171C2249F
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 18:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B953F178CE7;
	Thu,  2 May 2024 18:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L/KBlq/q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1578155350
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 18:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714674894; cv=none; b=YEWcXWdbSNuJincUxEFkcoScmNYqHcR6aQO6zkZsYcQOiUkexSiYHruUdWgSude4l91kAXHO6QpP4jJ2KKdk5+xFgoSZv5chbBlJMIj1wjCN3R7UioR3hKBkw1CeAHOk1KqD/2yTh5aR4RnkZ8GFZQCPcgfQp7V7gZRHtRNrt4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714674894; c=relaxed/simple;
	bh=jytgknmHYWTrXv1GAauTxUQg2j1Ex2jV+8u8ch/uEp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=II0UXXT9n6mNn0CN7G4rSEdCI8YCq8c43oPW0cxfPotxaMIpOPzyOapk0z11piZK7LgWNG7liqz89FQD4HcX5uEUw3j6U0NuQno83X4A1Sc19Ia6z65TRM172+phE56cIUvioCcD4tCUPFGEPB47c6DYF/iSa3i5ayhBnjOKiU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L/KBlq/q; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ed4298be66so6009019b3a.0
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 11:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714674892; x=1715279692; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jytgknmHYWTrXv1GAauTxUQg2j1Ex2jV+8u8ch/uEp4=;
        b=L/KBlq/qMeOxxcs6qukbEQgikZ2Wg6YAfdIwExebOHi8w4tdERla2XU+0nLJQa3FVa
         DMjtQRPHCH1RJBX+SIf+j70Fu2rzx1xeh6DMFGpbqjjmJu0SXf6mOnfriGje7YtirNLf
         Q6+4in3rss3/6YmzYKVb+xqB2La4Ba6u+6x7Zew8Hbto5wixo3/0NENjWS3pkSLPDfu6
         FUZxiWsh8Rtd+UrZCbY5O9ymfYAfJKnq57GvJYxWT3cP04HQ1JzZfA7KU/A7KzhipQ5M
         IDNr/yw1ge31SuvJ05DE2dZDAaSRq1mwikcgQ9yl7zbPsgNZ58jSTLBY1mZ7s43n+htJ
         3llg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714674892; x=1715279692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jytgknmHYWTrXv1GAauTxUQg2j1Ex2jV+8u8ch/uEp4=;
        b=FIC15bGGzMWcdZpc8LZCn+exNmZ1NVKC1OSNK/T2JShqYIzE2NCe/xY4xYTc3NIZlj
         0Ut9DaIf8rtSDVug2/mgws28pKk1Y1OwNsQXckA92PMd5CfZ82mC7vvvuro9zBOk56M/
         5LRG+NE7xQR6CBc7Np6bLK6O7mX+X9+EmsMuaQkEr/cbpjgIj4R80IeKOU/aXHsz4doP
         8m4OSkTxSpuri3sshi4EOlmRZy3PWOVptuy1kCSFRO47fbEXIdHF4e2+elPuywtkLUTV
         Wxc8ZKJMrNaR/mFZia0RXminYeVtEY17yp6QjDCTlwWcxlffzJAAWuaXErvKkdLp5UnC
         vATg==
X-Forwarded-Encrypted: i=1; AJvYcCVmG192cBL9Tf7KH4PNLvCBftqa+I2lBNiY8onMvi4cs849GwJeJ1xir7bac1+DSVcf2sdlnSK04B1/5h7PVmGy9JRX
X-Gm-Message-State: AOJu0YxgWVzSiSek2vw59vCdzwnIWQgyuHrYZP6OaPfGZ6zJ/Ah+3y2D
	fihsKJn81Tts4bTpc6JqtyemvOpwOaI6GRbIXx8+bf82sEBeaGL9rGbfmvkMPP6lWsWCtRaFQ14
	Ruw==
X-Google-Smtp-Source: AGHT+IHWL5Bv8mTDqw5PQCUQ3Ma17xnc0OOcCgLDrt0pU0GynYuPCW7ysv0HOkzIsyoIRHjZ3DtUj8iHTnI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3982:b0:6e5:b5e8:e076 with SMTP id
 fi2-20020a056a00398200b006e5b5e8e076mr11141pfb.3.1714674892052; Thu, 02 May
 2024 11:34:52 -0700 (PDT)
Date: Thu, 2 May 2024 11:34:50 -0700
In-Reply-To: <9b05e2d7-ac1c-e60f-0f6e-f4befea06334@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240226213244.18441-1-john.allen@amd.com> <20240226213244.18441-7-john.allen@amd.com>
 <ZjLTr0n0nwBrZW36@google.com> <9b05e2d7-ac1c-e60f-0f6e-f4befea06334@amd.com>
Message-ID: <ZjPcytxDWHKLYNsU@google.com>
Subject: Re: [PATCH v2 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for
 hypervisor kernel
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: John Allen <john.allen@amd.com>, kvm@vger.kernel.org, weijiang.yang@intel.com, 
	rick.p.edgecombe@intel.com, bp@alien8.de, pbonzini@redhat.com, 
	mlevitsk@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, May 02, 2024, Tom Lendacky wrote:
> The hypervisor side could be optimized to compare the value and only update
> the CPUID runtime if those values are different.

Heh, this is exactly the thought I had around dinner time yesterday :-)

