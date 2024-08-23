Return-Path: <kvm+bounces-24973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3512095D9F0
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B11BEB2415C
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A3B1CCB3B;
	Fri, 23 Aug 2024 23:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0osuhRQ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24731C9446
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457274; cv=none; b=P+z0MOBxvf8ZqW/bgeTKPDIaKXc1gMmI/aH+UyAHCX/r7FRxpm66kEu3h4Yys9e8CzXN7j7+ihR9obNq9k1+a+SW0IXvCPbqXyFBnI2LKcCJL7kiGH88aFY5L3P10NMMFxeV2MHpwc/u+FbpEf4mFyjUP3F5HxCsFM8NffviNSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457274; c=relaxed/simple;
	bh=ZsGbrVfo9OkjdxgpqSfk8utdzoF8z3yMoR3uwvLyy2E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ym0qCGp4MvWofmCJ13bVCmBTcuGSEcWAr5IA6XrafUK2Iz14SW3B9n8G5HhxS91D4vQnAiJpsLmMVjZAqflKk2ShMcvLEheGETVqOUNtnFgDcN3qAbjVHJ36jLKNc9vMyTVP8hRhkZBMN6ivWowoZsWsPTHfQ/JHixh+TPdkyqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0osuhRQ7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d3d413c4edso2774474a91.0
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457272; x=1725062072; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I2v2MHDt4esEOK/DxuPwtgfOFZoYYQTEeuqo4M+jXGM=;
        b=0osuhRQ7sH7zrk5U3BvtbkFoo1CCbywysNtofdxaYniBe2yX9rKlaUsJ6ox+Hj+wCg
         e6ylKsFwbl9GQHXF3aA4IiY2PWkBVk0/wUHVDodGtta5kuWMQLTXusk/aGe1zykSHFwm
         /OkPMpGc/kcVOeJ6lY+coHZ6ZL+bb48AaSFrW1eiHQpdyvdQqlg3LFNt2qV7tg1IcRal
         +rGkBtpSzst4sJ2cy6unSzCDOTVbtJ06wLPIaTQCDP6nbWnX2c4eCevv8XCoHiXOo6rb
         Zt/r5oi0N4K37FQ6P3Fqgc2uhdRao3QD9hPqlCrO1jK0aN0nt+lxVrplw6EoxsE5j4Mi
         IJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457272; x=1725062072;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I2v2MHDt4esEOK/DxuPwtgfOFZoYYQTEeuqo4M+jXGM=;
        b=IJhZ8iwbG4xf27tGl8HjBAYjkzOOEI9cXpA22KQNQpIE6Cs2ooGUbACWzb76tVFllm
         pLT1qPeBHMepF/acLfZn5S/aV4F1nBSdCuw8ITnwCRWsrnMzOvH7ibqB8XyXS/HSmGrd
         D1oDODDHWJJiNZSwahFtGrshc2VrsQbd1YbcenDTTKV3IsqMhBOJ6NdLK0dz536HTOF9
         w4iSM/ysRfZuRtuq5r/Hjfy8b6OcqWEbTMT+U7j433foJKWsDTNZORe/5zzS+4v0T2r+
         kErok5MlZzWUVdgfgPkXI0Vd5Y4XyBly3thSE6uDPWNTyiI4bTWUc6PAMuTTR5WIR430
         hy5A==
X-Gm-Message-State: AOJu0YzKTNjrihyr+u7ToB2LwGGZbWApSLWapwyOmuQ78OwotxCyJ20/
	dAiGrrS9yN9moZUDFgBCie3RKSS9LyCd5ymxmbvr4c+2Wfc0Pg9E2yl57T85gUxuLJBCjIDZzcr
	mGQ==
X-Google-Smtp-Source: AGHT+IHm1c1eC7EMuzeGgtY+z7vJ1lrOuEaIgxUAfa1UDufYAd0VdDhBdDFlj2e3bEGajgU0/zU2XZlhzo4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fa86:b0:2d3:ce45:9148 with SMTP id
 98e67ed59e1d1-2d646d81615mr54476a91.7.1724457271818; Fri, 23 Aug 2024
 16:54:31 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:53 -0700
In-Reply-To: <20240802202006.340854-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802202006.340854-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172443896940.4129936.14195284777076363677.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Clean up function comments for dirty
 logging APIs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 02 Aug 2024 13:20:06 -0700, Sean Christopherson wrote:
> Rework the function comment for kvm_arch_mmu_enable_log_dirty_pt_masked()
> into the body of the function, as it has gotten a bit stale, is harder to
> read without the code context, and is the last source of warnings for W=1
> builds in KVM x86 due to using a kernel-doc comment without documenting
> all parameters.
> 
> Opportunistically subsume the functions comments for
> kvm_mmu_write_protect_pt_masked() and kvm_mmu_clear_dirty_pt_masked(), as
> there is no value in regurgitating similar information at a higher level,
> and capturing the differences between write-protection and PML-based dirty
> logging is best done in a common location.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Clean up function comments for dirty logging APIs
      https://github.com/kvm-x86/linux/commit/acf2923271ef

--
https://github.com/kvm-x86/linux/tree/next

