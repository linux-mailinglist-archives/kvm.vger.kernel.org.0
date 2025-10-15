Return-Path: <kvm+bounces-60090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24395BDFFEC
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 20:07:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AD91581D02
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 18:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C51330276F;
	Wed, 15 Oct 2025 18:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ed+G4eby"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5252FF66A
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 18:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760551579; cv=none; b=scwsebiozGLCfZmoyaIjmJNGJASdrB0r8HhQMjsGvIPdIIU3TrTz2cy++Z5HxnyaI4nufRRZHe/lZZTv+ro2at0hn14mBtEZJFV6/2e0incZfB2WHQdNwwP2i6vS8vsf+WSUQnY5c7GEjofLSSC5qAYlt8XG2fuiCxVL0yV286I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760551579; c=relaxed/simple;
	bh=oUJnw/ES22KXI4PYCvskJYEsYesu1u36fPnCUhxynuY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JNTb3TqEen1Pr2PLmrIa+Jr/nLXaXNe2/zysMhrB0rIzuvCDvuJp2dFgoMjnUQRmTiiWbWfE660lpV9jMCml9wm1AwYxea7n3QtnWNIK/ycz1DfoyLzfGvYP27e6mP0AeRsvMjQCsR0dw+l2aGZGFE5ClLcPG+sdhxql+sEdb2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ed+G4eby; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-339ee7532b9so28540805a91.3
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 11:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760551577; x=1761156377; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f61Rm9CXZ7yTPp5k0RnaJz34I/PB/mN1ZqanYu35itY=;
        b=Ed+G4ebyQI3EgC7TJGOrERRltkYlqwZbrAmzGhyT5w+ODm24vyTOoFy1oA2oFjOAnD
         qnT5G830vuf8QN1GFY5oXZcMo4LugJqcsb3YUF8NA005GJn4zu2jVgcgwbHjJjpX7ibh
         hy2RdxZgzRUDMeQz2RPtPiJvvMVpgLJfuOxqTLTXTQTBXsL402eLrhS59aAus+uqKyzx
         haGTGGG440xjXKy/XlFnBeZJmZTl0FBhPWq6A3fPdJPnazZyyxNFZ+TgVHQvbjNiHtP6
         uHzlx88qoTl/NyDRLqA1wvNfRi60Tp4XR3Uay85HoU5KpQn7X4xFofoQqTO1iqgz7tU2
         +XdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760551577; x=1761156377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f61Rm9CXZ7yTPp5k0RnaJz34I/PB/mN1ZqanYu35itY=;
        b=m2alf9ws8opvDyMhOoUdhRXSEIJGBcB8AQ1nIJP3rY7OuNeuKsblqzpV1pRb/hfRBe
         ELMQES0HaBc5JsCTXPWGfnn38sXJytNOE/9XapCej8t0hkC0Zt6a4PF+rQrwJQ/y9BIl
         sacUONP74wzlBWaqw6O2IiVNdfFbQ6i5J+VMv0D6OylPVQHqys2MI2mpD2ZIw0XA4DGr
         CioLhNfRVfY/dOKw4ET7j3jRmV6+CyyKFkxMIQLJ7WnWejTBwJAFPQOH6+BID8bOeXJh
         2rZkJjlEejDAuREtZZxnLU+3SOMMMM3jK4J+LVJVtfP3f2AjuybVVmW8Kh0syEYCZn4C
         wNbw==
X-Forwarded-Encrypted: i=1; AJvYcCUZilfABhj5dql85/zoO1/YUt94NrOVO5zzaC6tZwpwN6veHkufNuUBtJa0SdXhu7GnFdU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgvmGj/f7LyN9WQg2tzFPoAz/5U5fB0AnHRkygaGhkTGM3VQQr
	D/yIPtZF1el0UvUGGJzq5jJlpE5wz5+F+sDwjaTMpdKFtgv2h8gXOddOXRcRmAG1Cd4vTwzqC1l
	WwPGE6Q==
X-Google-Smtp-Source: AGHT+IGwrtYVIxH8yRc/kLwj6t3/4zFQjhWv04zO22u4AAldHuqy2xh4xdTXcqSGmYvfqEyrzff7Eq9esRs=
X-Received: from pjbhf7.prod.google.com ([2002:a17:90a:ff87:b0:330:5945:699e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3911:b0:32e:7512:b680
 with SMTP id 98e67ed59e1d1-33b51106b22mr38107821a91.1.1760551576921; Wed, 15
 Oct 2025 11:06:16 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:02:48 -0700
In-Reply-To: <20250926135139.1597781-1-dmaluka@chromium.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926135139.1597781-1-dmaluka@chromium.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <176055118045.1528618.11131558125165685639.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Skip MMIO SPTE invalidation if enable_mmio_caching=0
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Dmytro Maluka <dmaluka@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, 
	Grzegorz Jaszczyk <jaszczyk@google.com>, Vineeth Pillai <vineethrp@google.com>, 
	Tomasz Nowicki <tnowicki@google.com>, Chuanxiao Dong <chuanxiao.dong@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 26 Sep 2025 15:51:39 +0200, Dmytro Maluka wrote:
> If MMIO caching is disabled, there are no MMIO SPTEs to invalidate, so
> the costly zapping of all pages is unnecessary even in the unlikely case
> when the MMIO generation number has wrapped.

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Skip MMIO SPTE invalidation if enable_mmio_caching=0
      https://github.com/kvm-x86/linux/commit/b850841a53c5

--
https://github.com/kvm-x86/linux/tree/next

