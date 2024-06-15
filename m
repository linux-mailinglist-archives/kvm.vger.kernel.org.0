Return-Path: <kvm+bounces-19729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 714D09094EB
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 02:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2658C1F21D2C
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 00:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D8E12F22;
	Sat, 15 Jun 2024 00:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rd1PJh7W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E4E8F49
	for <kvm@vger.kernel.org>; Sat, 15 Jun 2024 00:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718409800; cv=none; b=ZKRpOD0oc88mg2XfvJoHHp4JyZv8GBC2aFb8/yC1hXZk4R9wu7EV7dzV6XM2/aOyX1RH4XmOsbsHrPfHScRSC+RR/FNahf3sOBnoi2psWgjrztYJ+JyiHp2wKpN1Uvyk04zDTL2kVXKOd07FjVvOlpBFZzp/yB9icSxG3nq0YVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718409800; c=relaxed/simple;
	bh=6N2Ip++JmeQyuxUzkw42Rq4cAQ0ea8bNaJo50wQTPxo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TGq+4ZZ1Bqhwl2xcdnwEwqIJKViNQq0iI/marzjk8b1kt8aMVsX6V1HbaQpZmKAsFBYclUwnVpXy4Yc6DF59exPe2aNsBe+kBR3pk5L7BdBB6pMYNBTTf9NQeCBHIAYUub7Dvo29wam3Xl4c2WaEzNxYEqYPJk9Un5HasBZulGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rd1PJh7W; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c30144b103so2023655a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 17:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718409799; x=1719014599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y1eiSTLvtTayEmKQX6ceqE3SYkZvXHsUIxZY7jPfllU=;
        b=rd1PJh7WZMiNCdNwubJ4zkKiTrrOvWYAsOaOzxnBMFBSzlvKDOvlctwT9xZ3tHce0Z
         0cJAobQB9SP7YrjtFdpLWYwd5jnfkoU6uazME1rI2T55GyteWm2g/ppYwcOTaTdi2ohL
         3wpRWjYhh+eMzpZRfPovXh9XbD1qs7HJEr0MiId7h4fZ+yPJcB89P9wN5vlchgx1WVko
         M//qk9pqpArm6EaftTYL+xV/r9C1tew/mTGY/zQ13ZGpHom8pbMIzI7hcK3V9g/ka46t
         QTO35M7rOqksBFSSMoeRLo24sMS/wQ7omKHi5Ml9JuwsNYT8rvwTg0RBnAh645JvigbK
         bHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718409799; x=1719014599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y1eiSTLvtTayEmKQX6ceqE3SYkZvXHsUIxZY7jPfllU=;
        b=v/kC+Lqu2uNe2BiJFmD509WIMTxB1RUCJ+melta6BrWNLK1S8v8wpdB5HsxkW4uYFg
         CvTarO9BxLy9j/S+157Up5sI+wQjMaGM7TLe6NLBbZWjksepO6eQK5Sg6gglNxhGMoAr
         TbCcKPfC0HY3c5vZPMQWhk94IKshyXmjbktaFngo73EEU/Er/AcJ+tWya4xa7kNjCaCe
         OpxmJTuF2AK1JYhLyweS+jRiTeBaYPnmVC5HNhXkKVsKTcAmxE/pcfEuK4yfprSznsgb
         +A7PEjKoQC9X/9gSW2A/aKo6wFnpImB9Xsamayvd6P5g974CyLI5LEmx8PpExZ40WbI6
         AV5w==
X-Gm-Message-State: AOJu0YwBBpwf3kU8wULjSJvnwfvqNoDJmqyH/TXBGbLSS4vduDSxF9Jr
	lYAbsxP30JN9vyLlQNtdS6GLZPiqCCTEQrXb1ZaQyZPG/ifRh9gjTcv4ZibSCXdWfS0LskZyzWH
	TiA==
X-Google-Smtp-Source: AGHT+IE+lSHliLC6cY456tUCe1Wd8WsI7CC5wV5huhOhGAOADGmGtWz4S5G0y5CIGTaZi6GKIaz9dzkWNO4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:903:b0:2c4:b518:10f9 with SMTP id
 98e67ed59e1d1-2c4bdb65b00mr126757a91.4.1718409798676; Fri, 14 Jun 2024
 17:03:18 -0700 (PDT)
Date: Fri, 14 Jun 2024 17:02:55 -0700
In-Reply-To: <20240608001108.3296879-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608001108.3296879-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <171840976799.1411209.2253384085532260534.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Rephrase comment about synthetic PFERR
 flags in #PF handler
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 07 Jun 2024 17:11:08 -0700, Sean Christopherson wrote:
> Reword the BUILD_BUG_ON() comment in the legacy #PF handler to explicitly
> describe how asserting that synthetic PFERR flags are limited to bits 31:0
> protects KVM against inadvertently passing a synthetic flag to the common
> page fault handler.
> 
> No functional change intended.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Rephrase comment about synthetic PFERR flags in #PF handler
      https://github.com/kvm-x86/linux/commit/caa727882937

--
https://github.com/kvm-x86/linux/tree/next

