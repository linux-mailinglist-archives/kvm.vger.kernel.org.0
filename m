Return-Path: <kvm+bounces-38218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA3D3A36A6A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B9223B284E
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B834D19D8AC;
	Sat, 15 Feb 2025 00:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AgRUF6z2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DF27DA7F
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580927; cv=none; b=IyPTXcJSOL7xkPO0N/Xir17GUEBWfL4O+RKdexEgNHMmJYoJg65jJaciKc/Sgi7RFc7tUqOp1MRyHVu30j97Ncolkp5x7BLUZt60pYRLLIiLkeacUuZF8GBoJ1noGMJby7Ee39pJWbzEXNSftGRMmodAwQol+eAq3RQjJr2Ko3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580927; c=relaxed/simple;
	bh=I3I/I1h+OO/0YADrUPFiEPeEHfEFccR/feZdyUvMcDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OKVtB+6DsGYdkk9EcIY2R7H5SXcd98XdijlyFr6452tMSTOWEjNdTYvwqw09cbrYxrHM2J2uiutp9ztyjGX452VTvheKL46ucQHCbCNXZCSygKSb4zXbxwEeK6EQQOblOimngEGKaiIAg6X7mwSeEoJYU83xK10/6is92NM8MoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AgRUF6z2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fbfa786a1aso8052813a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580926; x=1740185726; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P9LzQSA5rRtonPXxH6y0V9FpnyXE8gcf+hdCI3QIwSM=;
        b=AgRUF6z2TEAwMTi1OuynRaEtKmnOrupPC80DlPv1R9oA4HopYBfsGN2zndrHVUn8Bw
         fdQcZSosk8q93zbblagkz5LjeLvPeRgFIVqelJaoJywQgYoFEMFKPinLTwLa4KTLqmeg
         +PGnRdSPS4hRmpZo7LXPgLlqCT/HXfXusZjTcbtOIs9wkuVTbqiUOmg8C+q++i3xzKwT
         1RLLmcmKkoYoL18n55Y+lWbJ/H/14brw38fIH06VazlbD5KjS1rCJbBxjl9lX99H257s
         kZe2/bIKowMUjUw9HhFGEENY+AfY0NfdEkso3sGftaUiezN7C7EHZI5PhBz45/vxZAhn
         yBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580926; x=1740185726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P9LzQSA5rRtonPXxH6y0V9FpnyXE8gcf+hdCI3QIwSM=;
        b=jrWNT1RQ8lyh2Fzh4mzFqqzxRQedhysswiwr/P/iRF7QjQ4SY4Jue03BtJ8iLb+Sxv
         rZjTqsMVh5pBWP3xnjXcuSM17cj+JDvKz0uN4HTbzQb9UhxmexRx60B2hbIcBP8Hs6ru
         PsAw6sFMa0N1uF/kFSLzxvTKUSPhlHOjwVcLBUa8E8TM2eE4okFTdIgwxKMW8xcJ8PAJ
         BonK9bAA7DVowjndS5Bm0JCRcP6C88cGGSQ95bsR99efKg6j+1eA3Y/NY786/DgiOU9K
         do2IEGWMww8Xq8nJbtH0PmZENvkQrawNzALLZdW/F1OqxEKrAMv5c7TYpisng9cAISB+
         VqRw==
X-Forwarded-Encrypted: i=1; AJvYcCViOy2W/Fb76ZOk6OlOvhXKN1pytvb495BGYCMZXB/XuPNgiUiXeQVwthaVXpSY/zlN1xA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+VzXcOYC4UBef/wSO71/P3kHDporQvjzOU2MGwzCRLAkBDhq/
	SroB0X0cUnz1RVxqulWdLTw2vEgAgzVjzU/yioNFMiAdeZPlVwiNLFKR8sKO35nVZSG3HI3+6nJ
	RSQ==
X-Google-Smtp-Source: AGHT+IGXCnxFph/47jBO6gezh198vbhbpiqJKCCbd9oF5b5bKFEtRf36qGRJifDiuvJwGbMX4gW0X2tJgIc=
X-Received: from pfbjt23.prod.google.com ([2002:a05:6a00:91d7:b0:725:c7de:e052])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734c:b0:1e1:ac4f:d322
 with SMTP id adf61e73a8af0-1ee8cb5d175mr2579012637.14.1739580925886; Fri, 14
 Feb 2025 16:55:25 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:20 -0800
In-Reply-To: <CACZJ9cX2R_=qgvLdaqbB_DUJhv08c674b67Ln_Qb9yyVwgE16w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CACZJ9cX2R_=qgvLdaqbB_DUJhv08c674b67Ln_Qb9yyVwgE16w@mail.gmail.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958044518.1190905.5350869932218121015.b4-ty@google.com>
Subject: Re: [PATCH V2] KVM:x86:Fix an interrupt injection logic error during
 PIC interrupt simulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Liam Ni <zhiguangni01@gmail.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 30 Jul 2024 21:59:41 +0800, Liam Ni wrote:
> The input parameter level to the pic_irq_request function indicates
> whether there are interrupts to be injected,
> a level value of 1 indicates that there are interrupts to be injected,
> and a level value of 0 indicates that there are no interrupts to be injected.
> And the value of level will be assigned to s->output,
> so we should set s->wakeup_needed to true when s->output is true.
> 
> [...]

Applied to kvm-x86 misc, with a rewritten shortlog+changelog.  Thanks!

[1/1] KVM:x86:Fix an interrupt injection logic error during PIC interrupt simulation
      https://github.com/kvm-x86/linux/commit/4cad9f87876a

--
https://github.com/kvm-x86/linux/tree/next

