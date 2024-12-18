Return-Path: <kvm+bounces-34071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C399D9F6D7B
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 19:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B45BE1889F73
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 18:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDFFC1FBC91;
	Wed, 18 Dec 2024 18:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JGjqn4li"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818671591EA
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734547154; cv=none; b=J/eSRdIDsFCOpDUHjW7DqqD0fB1pIJ5KsS6C9hEudecr97pxECYDxqYz8kIk/GKZJ6Ohlm3aNEREyX1KZ9aMr5TF6UavUmMoumyU6Jr2zFWV8CTQj4Ed8DW9zw7d00wXEYDKu7LHo/vIwuQVnABhKOAU76eUyKsl1Sok2VsKo9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734547154; c=relaxed/simple;
	bh=54aEEBZXu5l8G8dSNrScl0HgsJCU88tBZMrBdnnGc+M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vk0kAPvM+vnwzWd9B3Mu822qQZ4W5aLADBVZWpEo/u5pdIxjXF02lXIp1Fp1IZ7j/HvEs9LZ/fS+dHZ/bIrwrJtEYRsa7oZJcgRBucOPu8KaPPGI8fLCW1j2gbsu9CUGtNClHi6nsxAkAF9N5RRCDVSIr+A9zlmiru+rhHkwyr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JGjqn4li; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso6039331a91.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 10:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734547153; x=1735151953; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ThSbZiShkgu5e03SVywCH9ZkF+kD7172meNNyMCsukQ=;
        b=JGjqn4lizOb4Okc/2AXyWxF/IDjq5ZRuWbQCp2V/hbWGyRm64wbnTGPdsCJ9dXkwDA
         UzyBEKNMiUlD9LJlnQdYyBkTmnrJ4EgZBKDsQ0BusZB0OUX+F5VXtggo/y3e7Nz7CId5
         kDFlBjJUjzEd+TfIi7O/s33BbKyBPKhkHpwE/QvctS5uri5FW5a+lj/0BRKa5RhNFBW6
         KwJ7ha0CPaNtDWEeXNDQjJLGyl/usiPpqRVQpnprnVFESThLvKIPAH5kumXpobkkv5jM
         /nBWLqaLsLv1rebskGlQxAmI0ZJFHGZr64sF65n/dfXjzDoNP1HLYKgeKn9tn7xIDMV8
         zOOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734547153; x=1735151953;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ThSbZiShkgu5e03SVywCH9ZkF+kD7172meNNyMCsukQ=;
        b=kRQLbvSCRF2wRdY5YBv9IxBgB7B5s6/imt9p/fgWhhIvA4qFid7dZBgyB7m1eqeNgI
         8NUoMKhGkkmPDUAzVL/ZkHHgSr1+evJQq3HRrfT2l2taCC7uAmvKYb525BLwvZiU4ieZ
         I1SkJfFIaBaDlmYd4tnVXzmSnfTacZVEug72a+zPiweSnuuDVmCvvdc+gUkxPecPvsJR
         ksPiUrONka0UiNq3SzEPV4Yuzd54+ZAPm0TIRzhApvT3BoU7mjWlCrsc2mbIm+XaEr7Y
         aCHiGaeevipclHxA1eBKLK7vxryX0U0DgPv1kuB5uGanj+yopvszsaQdMEbTcgXHUXk9
         1VRg==
X-Forwarded-Encrypted: i=1; AJvYcCXe74mzQ3kHR3aJlQckpI965cGnvm529MR3B3W05/z1aVjTU7mOdx1SYRxo1bDvXmv5Lj8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc9SkQGyqzfeWF3Zy4dxAZu/7m4eUEXYR2C6c7JOcudIVQeCco
	9wtrsZKB3uFWs4qQKPLuTJ6Uewqr8xquhUfKRInZr/zHnHBpY7r9KAj3xLKrfIOzg+GkXJAlnMX
	yEA==
X-Google-Smtp-Source: AGHT+IGexWYaZ1SI4kjhNWXK7opgvllRMgRXEQRWmGX9yzNrM6pDTH6/xNiTrW2iL7iCndhz2fxMorhYmOU=
X-Received: from pjuw4.prod.google.com ([2002:a17:90a:d604:b0:2da:5868:311c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:270a:b0:2f2:a664:df33
 with SMTP id 98e67ed59e1d1-2f2e91ad917mr5094136a91.1.1734547152868; Wed, 18
 Dec 2024 10:39:12 -0800 (PST)
Date: Wed, 18 Dec 2024 10:39:11 -0800
In-Reply-To: <20241217181458.68690-5-iorlov@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241217181458.68690-1-iorlov@amazon.com> <20241217181458.68690-5-iorlov@amazon.com>
Message-ID: <Z2MWzyoq8c2FfJnM@google.com>
Subject: Re: [PATCH v3 4/7] KVM: VMX: Handle vectoring error in check_emulate_instruction
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <iorlov@amazon.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, dwmw@amazon.co.uk, 
	pdurrant@amazon.co.uk, jalliste@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 17, 2024, Ivan Orlov wrote:
> Move unhandleable vmexit during vectoring error detection
> into check_emulate_instruction. Implement the function which prohibits
> the emulation if EMULTYPE_PF is set when vectoring, otherwise such a
> situation may occur:

I definitely think it's worth explaining that moving the detection covers new
emulation cases, and also calling out that handle_ept_misconfig() consults
vmx_check_emulate_instruction(), i.e. that moving the detection shouldn't
affect KVM's overall handlng of EPT Misconfig.

--

Move handling of emulation during event vectoring, which KVM doesn't
support, into VMX's check_emulate_instruction(), so that KVM detects
all unsupported emulation, not just cached emulated MMIO (EPT misconfig).
E.g. on emulated MMIO that isn't cached (EPT Violation) or occurs with
legacy shadow paging (#PF).

Rejecting emulation on other sources of emulation also fixes a largely
theoretical flaw (thanks to the "unprotect and retry" logic), where KVM
could incorrectly inject a #DF:

  1. CPU executes an instruction and hits a #GP
  2. While vectoring the #GP, a shadow #PF occurs
  3. On the #PF VM-Exit, KVM re-injects #GP
  4. KVM emulates because of the write-protected page
  5. KVM "successfully" emulates and also detects the #GP
  6. KVM synthesizes a #GP, and since #GP has already been injected,
     incorrectly escalates to a #DF.

Fix the comment about EMULTYPE_PF as this flag doesn't necessarily
mean MMIO anymore: it can also be set due to the write protection
violation.

Note, handle_ept_misconfig() checks vmx_check_emulate_instruction() before
attempting emulation of any kind.

