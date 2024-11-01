Return-Path: <kvm+bounces-30370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5522F9B987F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:27:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C4261F220AF
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49D61D12FB;
	Fri,  1 Nov 2024 19:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q3C6c/Wg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C01144D01
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730489203; cv=none; b=tWjujZ8jRcWWPP73ILxbjCDnMgDyAdPgq/fJvlGleQgITdFRyfVCR5S+nWhhBpb63UuHkcxWY4TvfNy4fc91HURjhBGYzVb6LUrnTU1ppx4yrBZ5SjSyl+rafazlIJbKw0sd6ksM+aYF/nED2tscJeLqSvN93RW9m7IS7Pt62EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730489203; c=relaxed/simple;
	bh=y9gMRmSgRhR2ZzgRFa1iVD1DWemELrWiDT0kiGYVqFQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tuALVzc9eru2oJF3RDI/4VOPR/f1vn9soEPXaIXY7zHxB0tZxZDqKcpQ1xXOg1TMMdnDM44RhqMvCEp5cfBCfXKWVqEBML+sxz6KjV8MWPIh0aheaAztc1Aj06IzWURHZUHk40dKsYqsPVjGfErSbqV8e1A94OMMtOY4lBRR7Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q3C6c/Wg; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e69e06994so3373376b3a.3
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730489201; x=1731094001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l6/SBlVL29Guf7OgbzpBZ87muPd4kGOblg4NhLF75g8=;
        b=Q3C6c/WgNh3t5T9LzHw29pJdc/AyHgJBeb0CKoQijvZi5YS1gyienTzLOonqLCCU4e
         PirkoOjUcKU42RV/XbySH2HkuhIcot7+y9vojPUCKwGs1E3MaLMNCe2z46Nb0fsRdeOC
         lAvLtDhNBnCLweUuCQFn305csdvtjkuQsZxh3YU7tsWzEw4Nb/OAsg9nvOZglAWs2ZKy
         MbZhduf3VszsOwJaAJit2Sm3NVdIs1cywBgr82thhWoUNIP/99Vp5A0k6J+Cr87YhEPq
         SLlQP0ZLMRPpcEMHooX2vcFqjtG9g5rYL1Uzq595gYTwkW7TBh4iqR03sVMKou1ft5KC
         HNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730489201; x=1731094001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l6/SBlVL29Guf7OgbzpBZ87muPd4kGOblg4NhLF75g8=;
        b=gE9Om23QIbb3rfAf24Q0XOz+uTJKJQwn5j7zR2jE6vY5ovgU/wT0Up478wpJpfvizh
         0/aEV/R5EOUu6oBWZP4glBRzMfNy/BfK+6dSMexL/kKP62rLvBb8ieR+wc/pRRSKNF29
         2zzULMeeNvpGTenSsrULbBgjmJFvMklTVv0e1edAMpoXVoocF1Wqjd6LO8VnEYLP+k1Y
         /PMLXIWzaF+VltvYWPraCGe4WiUyjBBQGrMfLGB0eBfrb2W9UOlWkUFSxdeWQmCE7vWn
         IE1MgtZlJbJzyYXjn9XW55WG+7yxGe5CWR+SdQpFTF/641rMComn4jQEjJBCoA+saPED
         P4xQ==
X-Gm-Message-State: AOJu0Yzrg9YYI7wUDggoXamJpsptNQj+FeQt5ALip82EMBaXlvnrR83W
	hly7zfmU063mq9TcYnh+5vOEdokwT8UULJ/WPaCThTOS+kA5J7FwEtGzny3G/SYl68oyF/Ja9RF
	1Xg==
X-Google-Smtp-Source: AGHT+IFkhgtKHE81DUnfzmtMTNF6Rg9WpI+qnz+2pkM4Gl68lwQnDeSODf98f2ouigJe4+3xU4RiVhh5za0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a62:f20f:0:b0:71e:5dff:32dd with SMTP id
 d2e1a72fcca58-72062f04347mr39339b3a.2.1730489201065; Fri, 01 Nov 2024
 12:26:41 -0700 (PDT)
Date: Fri, 1 Nov 2024 12:26:39 -0700
In-Reply-To: <173039505425.1508775.86255062373291663.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240828232013.768446-1-seanjc@google.com> <173039505425.1508775.86255062373291663.b4-ty@google.com>
Message-ID: <ZyUrbykshu2YcrfR@google.com>
Subject: Re: [PATCH] KVM: x86: Ensure vcpu->mode is loaded from memory in kvm_vcpu_exit_request()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Sean Christopherson wrote:
> On Wed, 28 Aug 2024 16:20:13 -0700, Sean Christopherson wrote:
> > Wrap kvm_vcpu_exit_request()'s load of vcpu->mode with READ_ONCE() to
> > ensure the variable is re-loaded from memory, as there is no guarantee the
> > caller provides the necessary annotations to ensure KVM sees a fresh value,
> > e.g. the VM-Exit fastpath could theoretically reuse the pre-VM-Enter value.
> 
> Applied to kvm-x86 misc, thanks!
> 
> [1/1] KVM: x86: Ensure vcpu->mode is loaded from memory in kvm_vcpu_exit_request()
>       https://github.com/kvm-x86/linux/commit/ba50bb4a9fb5

FYI, I rebased misc to v6.12-rc5, as patches in another series had already been
taken through the tip tree.  New hash:

[1/1] KVM: x86: Ensure vcpu->mode is loaded from memory in kvm_vcpu_exit_request()
      https://github.com/kvm-x86/linux/commit/3ffe874ea3eb

