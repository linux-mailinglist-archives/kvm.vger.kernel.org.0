Return-Path: <kvm+bounces-25611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAFEB966D74
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:24:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 804582827D9
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C317922F1E;
	Sat, 31 Aug 2024 00:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p31RDI1R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B22C23749
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063703; cv=none; b=WnSrvJoQYbJwPbVFFV3cc3HfXbISI4WhcTp+Cre3uD+a6KE4oy4p8c3R1ei+tYPFGl2m6Pe2wkdctD/PloJQZvGLOMlyZ4ryjsjN3lDtxabVPpjml8QMnx39UXVYKXj69/MrsZgJ/k8UzEooRSngbut7WT6s+mHNn6lpc9v52hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063703; c=relaxed/simple;
	bh=/wdKel1aSrBmj9802LMSDDEvGq2PjPxbrU3uI863aVg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cK9NiLLTGKHCKN31854R+pBDF/cefEFinncMJogI77BFBRgVH3ZjUSdyp7/RpuD/4WxWDR3cq3ddSF0YuY+85TO7LLmF/ulhDcAUtH6z9ngJrW9jD4nY9YTG+2bJqNj6EPf3wm5zcrNg2DFv5cNoVBH9vYbEnU3Fet7ZzOCnQow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p31RDI1R; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2053f49d0c9so4711035ad.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063701; x=1725668501; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cjA+z7q8loku4LvOBKYYpqX6RoC5fSx8Vq6jSIkf/kM=;
        b=p31RDI1Rpe5qpBwQIN0f04Ies68uIkIJvowFoLrQYgei/3KDVW2nIlImGM/U/Fgkdu
         CdAqb/PLhupSIbnz6OitbhemgnBCunP8KtojAuMzirkpYY713AkZN6j4xr9w99Tnion3
         AoU648okufQCogIQKUoj8x2tU2uBC6q15metqsckbQRk5i5oDee7K8GgsEO6Tak04BYB
         AKaRjST9IucQj1hI+6uDlhHb/6996WjfUJx+jaAzbnV/gFRuhUD53M3CYo6Hn7e8AB9K
         /lYlkyHla2Y2/d5dfokErEgV6NjnQnIqzt2kPMZ4ErhLFu+9HNua3SETVlF2PVn/sz6T
         kClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063701; x=1725668501;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cjA+z7q8loku4LvOBKYYpqX6RoC5fSx8Vq6jSIkf/kM=;
        b=Y0PTeGA1Gn7pIwh0uttOnwDV+K6aKL+8itaP4R3g7DOkaXjNqOY3gB3qA8/jW2p83k
         8f/3i+sVoc9Dh02I47fONnA6OdWcg+At3cd5drQ6+yPhxs4pdYRtIt4PWRfHQsGVXaKF
         sVfc1MR2zSN0w1Nwr7gi/t2dwlQcDYPMtrwag/p5S0DoSu4bMINvyR0kvZdMw6CWwy2U
         SZypzGqKHntvg1DH6LmvGDG095BUebQ7O7Nwd/1lH1r7JGetH0KdXx22pkuzRD09an+z
         SNG4uHb92tOQNNA1ocnG3Hv0BZpb7RZRfRvhAcOmpEuz20b9aoFhpR/zecIveUU8xAx4
         sFbw==
X-Gm-Message-State: AOJu0YzFoGzO/F95BhSnseUV0W1abZaBp3AzEf5CzOqDxon8psXk2ZUN
	Poh/czghbtR3q3mQKibB0BWgjXMPvIjrjEL9OW2xLGGrA58/9ICnEladv/G5XblOXQ9Wpxf6qmD
	wBQ==
X-Google-Smtp-Source: AGHT+IFIwzby144KSsd4gfVYXr/GeuNPWDDFEHr12PDOWSx2iayMxNXVoZWHEAj0QdceAdDmPA6K61xVOeI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:27c6:b0:205:3bc6:bf1 with SMTP id
 d9443c01a7336-2053bc60ffcmr40685ad.4.1725063700787; Fri, 30 Aug 2024 17:21:40
 -0700 (PDT)
Date: Fri, 30 Aug 2024 17:20:57 -0700
In-Reply-To: <20240802203900.348808-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802203900.348808-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <172506354608.338443.7550017619173819898.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: x86/mmu: Misc shadow paging cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 02 Aug 2024 13:38:57 -0700, Sean Christopherson wrote:
> A handful of loosely related shadow paging cleanups I unearthed.  I believe
> I wrote them when reviewing eager page splitting?
> 
> Sean Christopherson (3):
>   KVM: x86/mmu: Decrease indentation in logic to sync new indirect
>     shadow page
>   KVM: x86/mmu: Drop pointless "return" wrapper label in FNAME(fetch)
>   KVM: x86/mmu: Reword a misleading comment about checking
>     gpte_changed()
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/3] KVM: x86/mmu: Decrease indentation in logic to sync new indirect shadow page
      https://github.com/kvm-x86/linux/commit/174b6e4a25ea
[2/3] KVM: x86/mmu: Drop pointless "return" wrapper label in FNAME(fetch)
      https://github.com/kvm-x86/linux/commit/7d67b03e6fff
[3/3] KVM: x86/mmu: Reword a misleading comment about checking gpte_changed()
      https://github.com/kvm-x86/linux/commit/1dc9cc1c4c23

--
https://github.com/kvm-x86/linux/tree/next

