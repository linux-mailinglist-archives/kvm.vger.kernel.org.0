Return-Path: <kvm+bounces-62524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60148C479F5
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 136FB188A64C
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E1231A053;
	Mon, 10 Nov 2025 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J80sQnt5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAA1319608
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 15:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789178; cv=none; b=Lov3OqJFDgibVEZohgyCMNGuTkgaPnnArmY1XX6ng/GgVpdUu/2A5Q2FLhMdgE2LtiFHxd82rpWyUXUZYXeJp/h9fFC2FbjwckI3p0olnPC7lPxkwnEjaol4aGOmEDDX+9+2p76+KE1maNZ7YNK2SFtBudRgRtqDwrE5JYv/tfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789178; c=relaxed/simple;
	bh=HLqpw9OccrvyzVMI8pr94sqlLBqJLI8wM/NU8/1R4X4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KYIPTXmZODYVf5XAmHyt0AI2BjhEpT2WL515/IA8Mtvxneu00ZlDki/p5jCrRg4tc1M5FSAq46icXatzHEtnzVb4e9mIIYI8TbnLrNYhr4WZ0UMOlNdCXbaLM0bcxgL3SxIUQJC9wEcFxHOEJxnLiEkmEB4WGvJ3fAcgTzC350Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J80sQnt5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33da1f30fdfso7653878a91.3
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 07:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762789174; x=1763393974; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IxV2BK8QKnCiH1AuK2g4amllIFkIURPoopgCW0Ha0PY=;
        b=J80sQnt5gziIRbw9fSifeRn8BYIsf1jg4gw6ZdmS9RIw5840ZKkrW7sfEfxeCiIoPO
         8OGDzuc3vvVtLbGrcMvxkIcqwwa1TBPyn4S9bGzjrLRnP5r62KK29Vb/pFLGRbtT8gj9
         C7C5X4cANXIPEeIOd0HmXl9JULUpX67Ncnfq3jXAJPOgS0wVi1wrDbTXHSbhuFZPzvuX
         fSB1TZDH9+v232CESYGHDs9KntKyzQV/pwkuUJ0H34CXCaPMFFneDtl6cA1rE0INC7xe
         N31upxXcVF00QY7vKF1xMz2Loijcxowhnt52P+Rr9Na9lU2wTBXPfoFo0XmD8vAjNEks
         rzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762789174; x=1763393974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IxV2BK8QKnCiH1AuK2g4amllIFkIURPoopgCW0Ha0PY=;
        b=WmzlBnBO6FjwPasZo6+pUHGqNIFi4m9baLWz2U1yCDYs4KWGnIKRfmfvCDp3JqHjmF
         sgHBqgcNNxyp/jPw9Ur6s6IvF5Cyy1cRbU093t6FxB+DvhUj+2hOIRM0ATxKzPDkbSv8
         CR75pGL87b4HPH8E0000Vwk2XXKtNIcGrW33z9I6Nj0IyGp6NgoN6fdeV/6pjKD5tuyZ
         L4cmBtpL9Oo0MvU4PmKYWdEvsz5yXjpD7OB+0chwm+xfKstGnvpW55O+m4uxaLKKpUsf
         GfVEaMDPmYBHZoMOn7g2eO1zUYNLUaKCwNcxxGYcELdLyQiK9qAtxrpuP9v8+OjOT0le
         P8uA==
X-Gm-Message-State: AOJu0YxIYcwPAheDH8DnUy3J5MDD7pZ26ptk7/PChBhyoT2+WbxlfPOu
	g/DBz+NOIzj945Ycs4C+ZdQt0B7Hf6TWmhpxk1ualmq6nUyHqhfq4/Xv3TpAr8PQx7dMMP2CTa/
	GgeHPCQ==
X-Google-Smtp-Source: AGHT+IG1WjnuFZxaKrB2Uz9FQb9ICjT0M8KZd2b+Eh4t1Ia5GLPxzkUDRvJD7JP0d2vdeKv3tjb+ORIQYT0=
X-Received: from pjbsv16.prod.google.com ([2002:a17:90b:5390:b0:33d:98cb:883b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3cc3:b0:33f:eca0:47ae
 with SMTP id 98e67ed59e1d1-3436cbc9a33mr8936483a91.28.1762789173839; Mon, 10
 Nov 2025 07:39:33 -0800 (PST)
Date: Mon, 10 Nov 2025 07:37:25 -0800
In-Reply-To: <20251106191230.182393-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251106191230.182393-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <176254226343.805329.8193068148325939353.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Ensure SPEC_CTRL[63:32] is context switched
 between guest and host
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Uros Bizjak <ubizjak@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 06 Nov 2025 11:12:30 -0800, Sean Christopherson wrote:
> SPEC_CTRL is an MSR, i.e. a 64-bit value, but the VMRUN assembly code
> assumes bits 63:32 are always zero.  The bug is _currently_ benign because
> neither KVM nor the kernel support setting any of bits 63:32, but it's
> still a bug that needs to be fixed.

Applied to kvm-x86 svm, with the comment fixups.

[1/1] KVM: SVM: Ensure SPEC_CTRL[63:32] is context switched between guest and host
      https://github.com/kvm-x86/linux/commit/c331b400e291

--
https://github.com/kvm-x86/linux/tree/next

