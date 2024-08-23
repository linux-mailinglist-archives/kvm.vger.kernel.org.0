Return-Path: <kvm+bounces-24966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B87395D9DF
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48C48285D8B
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2B641CCEF3;
	Fri, 23 Aug 2024 23:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eabNc5X7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E39D1CB305
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724456903; cv=none; b=fIxSe5S0yW3rNs01/i/nlcsNbcsmjnQEzewlD7LceNZUDC+0/cy2VQ8kUjeGWLweXnjF7MRQGtW44zEZ4101UAw9RKLsGiaKarhho2Th3t1wsx3F3sLNsaHUKHVLvoavSe5sS5wBmne5t0wvqgCqxjF7JSmRSq4up/8BQvt2aLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724456903; c=relaxed/simple;
	bh=PnVmzKJJoLtxPKYlnrhO8hCFrtM9qp0qrnc+xF9wO18=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GOtJLwMWK+4mqSfkC3mpEiOKarldt4s4GDMscM342oGPV5A5tF3jn9779VD/Er+EpG8AoffiPZKKleVHLtCQDAkLPnV+Gx5XnZZn+Q5oSDcR30xbtX/wh7LMHEcNLhkjIItmlzXzXvG1rzRheov07ULAJOffAQZetTJm3RQMVog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eabNc5X7; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-714290c2b34so2344486b3a.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724456902; x=1725061702; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WCZ3bF2/cwaD0m14rX979B6XZ+dCyFWivoHXohUIvY0=;
        b=eabNc5X7oPOOHIuNqNJrJ7mE8ttKd44IcmLXmVvZAS/FCQSApWoMmVsFkCXPVfRAJz
         6MveGlzCKjZT2WIcTSbp2cgALc+TSehiggTUv3pzSD7P/DzmdtEMCWEwU1hnNw8+crmP
         xI9zWh4nxAowLCBN0Q9dk46Yg1o7GMN2/FtAcDlSzmgYim6TSXlXaXZ26sfzqFkoa9wY
         wvzAiT2XcENcMZnU1exzfu7Lpo8p+1n3E6KRnnG/4W5rwmFYdDWCHu6miAN91Z+PxZjJ
         ZSBaSk9Hw/+ed+RYKEyizYdXlXlRkPdAcdrMQ69AWlDx7UNOgbeyPR7X+vA0Ozknr3UB
         0CNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724456902; x=1725061702;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WCZ3bF2/cwaD0m14rX979B6XZ+dCyFWivoHXohUIvY0=;
        b=eIj+tB7HPKq/tf436su4Ou5QKeS+LsfQ9kqoFkDxL9aztdEZpmH8r5w7K5kb4JBdPf
         jzyRNWjyHffzNZcczKOYzJ4nwm25z4ZpBS4Nj/2i2biiQBHq5nbrUTwRs/qOwlZZI7yn
         FzlEgQbscipfyHeQrLYbvboHMRyeQ6HsmzqPthbO+HsijUZ+W6rh2wxUj6wnDqRsdofz
         kPSM+Se4YBUuOZTWmP7S2rnHqY4AlJCM/sLmDDkYTt4Fy4xSyONx/Drx4Dr7Xp1iJ5Ye
         O66k3+h8qUQn1Pzv0BQe0luDM/MhXut9b7hEWiENo0onLdbosmgt3i5hA/l5aBKh/+Ih
         7yYA==
X-Gm-Message-State: AOJu0Yz0Bj21XGFFXdjPFbpUogMAlg/b7H+37VZ/pREitOmzaEw9wHlC
	yNaRoZ6uDUZPOzJcZXge0e5drZpSrUFeFkFsp3JukvhtOwYKHsWSO5keMVgC536Hqzntlq8Kb6Y
	liA==
X-Google-Smtp-Source: AGHT+IFOzpKLkzk5rA/2rrwxxc/5JMDIP/kI66+HhXb7YtDLUhZ6qPLoyOuTrpJna3EykNDsGMdgJt46xRI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f03:b0:70d:323f:d0aa with SMTP id
 d2e1a72fcca58-71431945089mr88104b3a.2.1724456901668; Fri, 23 Aug 2024
 16:48:21 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:41 -0700
In-Reply-To: <20240723000211.3352304-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240723000211.3352304-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172442177547.3955389.11987354449064860269.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Check that root is valid/loaded when
 pre-faulting SPTEs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+23786faffb695f17edaa@syzkaller.appspotmail.com
Content-Type: text/plain; charset="utf-8"

On Mon, 22 Jul 2024 17:02:11 -0700, Sean Christopherson wrote:
> Error out if kvm_mmu_reload() fails when pre-faulting memory, as trying to
> fault-in SPTEs will fail miserably due to root.hpa pointing at garbage.
> 
> Note, kvm_mmu_reload() can return -EIO and thus trigger the WARN on -EIO
> in kvm_vcpu_pre_fault_memory(), but all such paths also WARN, i.e. the
> WARN isn't user-triggerable and won't run afoul of warn-on-panic because
> the kernel would already be panicking.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86/mmu: Check that root is valid/loaded when pre-faulting SPTEs
      https://github.com/kvm-x86/linux/commit/28cec7f08b8b

--
https://github.com/kvm-x86/linux/tree/next

