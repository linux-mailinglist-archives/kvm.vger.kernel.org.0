Return-Path: <kvm+bounces-52069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D48B00F53
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 01:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44B0A7BF55E
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 23:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26BC2D29BA;
	Thu, 10 Jul 2025 23:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jf5TrXoA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF6D2BE7A5
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 23:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752188986; cv=none; b=AQUXWmdB6/DNvZH1Yy0DLS2/bkKKdM0vbcIWOHEb6Oyrc8Pqgs7/F713uWwyuzwFDQw/5g8K20LouHK3tj2+2R4fjd4ClML7bxxMHhP7cQBeEyAOTZU5ZSoW7Vnzd3+d7vPOO1ISiCSN1zS5kEkbkjKYojudeeu+0xjmxNHyPIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752188986; c=relaxed/simple;
	bh=4H+zfNPlWxOixUuqGBEeIQ3sWiU8ACGmQ8OjV8qazRo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VD4ob3pY2YYYqDM8yBu21pW4pnWAXkq25Zi2c5W9XnybRavak8I1MdacA7WV0nnxwsMRvdnBtCDZx/rXNOpveZFBjb1wAfBdk0be4O6tRJLCJnBCAtCwV6Thg3zVSC4ty34ltqjKjrtYA5cZ5YP/Yglxl5XAc0gBLl0gbuAUgcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jf5TrXoA; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31df10dfadso1090940a12.0
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 16:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752188985; x=1752793785; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f3IsLiXimwfLJYfCYW4Bpk5RR6JeL2hZFlHaP7Q6GbY=;
        b=Jf5TrXoANrCuQ7PXNScAcQ/92YMsTaJ9MU2d/JGRNWITilmPpZ+4iZ2EjE3MYp8tOe
         hIR5RQgezWsvx5XnLnzs2CT3R6HYObnXZJrLdItV6Z93it5R85jxX74gC7Ali3xhvD2w
         KG935lZu+Ih7fZ/Ys55z5uWu7cCmFs8Y3yXoruyb53yxQ+BYSjsRwKHJ4EsMRHpuKGBr
         WecbYDAKO4ZBI0RgZpUC1Gc2Z6dLVJeRAFTsM/8jj8a+ITO3upC4tU8hwVlnAKV1uh7G
         mwbPdzv1ZFegQshHrsHw3lOUOJrEX+alqC0kNXQRigE3iM2a9R4kUqbOzuNpayaaP+6g
         xCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752188985; x=1752793785;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f3IsLiXimwfLJYfCYW4Bpk5RR6JeL2hZFlHaP7Q6GbY=;
        b=aFT8gcD9rFltIrRVmhxf1dO6jwhyw0oL/nXBnA3rTMwOeiOP7NOe39murZbkdRa5JP
         3kVXA6eNayW1bjViUNVIFn6TVPfL4ov2J08TSqm5mZ/FBORqb7+KeY+hYLgzmXr+bH7j
         yO780pMKK6KRT8lui+JMNLHFpvRP2NfPREh1bgJCUsnrjKeDFty4o3n/j2wzx5aWKSuv
         4ONSDb4qtzpdI+XHyeIlqvMTijVI20YbkMX4kX7NVmX2xmZW2ySSHKayseir8Qy+kM8l
         TG2nf1Sw5Pf43vxu9g4NmD9Nim4TWGAbTVnkPmbo+cTjEctG0QGaMmVkAMgauFGlcU8s
         +aGA==
X-Forwarded-Encrypted: i=1; AJvYcCXczfc7sFJaXE2zJu0N5st56elYA++W5SFClRpByQsWpqcOcbxWvjsT+apI+5h+AMTF8a0=@vger.kernel.org
X-Gm-Message-State: AOJu0YztAtpKpn+fQkXlROeXOJA/aefCiE4nUHhcSwuGUnt62qSedjni
	Y9kL7F2X9bCQswwni+Q/1rghVP6uSWbRDuvwb4lOcZd4TsAnPgIazlTF5JEigH3aJ3Ft2Rl+oii
	JCYe/Yw==
X-Google-Smtp-Source: AGHT+IFeAvInzitINf3pLc1nD4We9OcxFw+HFWEOb6jDjct/HCN8/9fWYbI2cS57Z0CpUUQIKJo63+gaZTU=
X-Received: from pjz11.prod.google.com ([2002:a17:90b:56cb:b0:311:6040:2c7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:184d:b0:312:e49b:c972
 with SMTP id 98e67ed59e1d1-31c4ccdaa7dmr1480704a91.15.1752188984740; Thu, 10
 Jul 2025 16:09:44 -0700 (PDT)
Date: Thu, 10 Jul 2025 16:08:52 -0700
In-Reply-To: <20250626173521.2301088-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626173521.2301088-1-xin@zytor.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175218111367.1487754.6051373868234671503.b4-ty@google.com>
Subject: Re: [PATCH v1 1/1] KVM: x86: Advertise support for LKGS
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	"Xin Li (Intel)" <xin@zytor.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Jun 2025 10:35:21 -0700, Xin Li (Intel) wrote:
> Advertise support for LKGS (load into IA32_KERNEL_GS_BASE) to userspace
> if the instruction is supported by the underlying CPU.
>=20
> LKGS is introduced with FRED to completely eliminate the need to swapgs
> explicilty.  It behaves like the MOV to GS instruction except that it
> loads the base address into the IA32_KERNEL_GS_BASE MSR instead of the
> GS segment=E2=80=99s descriptor cache, which is exactly what Linux kernel=
 does
> to load a user level GS base.  Thus there is no need to SWAPGS away
> from the kernel GS base.
>=20
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Advertise support for LKGS
      https://github.com/kvm-x86/linux/commit/e88cfd50b606

--
https://github.com/kvm-x86/linux/tree/next

