Return-Path: <kvm+bounces-55059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C60F8B2CFBB
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4D585867E1
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 568B4277CA2;
	Tue, 19 Aug 2025 23:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xL17ugPL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D71725B30E
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645322; cv=none; b=kJfdn1kRgb8A7g8tyOLOSXqU0k0qf0zcbi5SN4C+BwRrn+COCezRFPcht7G+zyFJRu3b+dcChTNqDf9v4Yx0ups0pA3hvaalyGT9V/1NCNAUMHKy6ES3ukl61rFKTH1v7nh3bzE1iNc7WW0kakseoendMNbPDlcRtayt+S8FyJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645322; c=relaxed/simple;
	bh=NO0oXe7nSF7sb8xwBbHnSSDx3KfKR41RTPJEjLKn5m0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e2z4u/ja2ojC4UGwZRd/Rwqj+LK9DSJujwzMYJriT0WnuBxo4n+0HbIbR/0DYF4NqUKFJkQJvnFf55PS8oVVDuzCP2UdbpZfr/afPhPHYqqb3daAxmrkvLoBYymeTF2s/SjTzYqGHKOs323GtWq4/41yeWW/A1QIeAYZiMZ7fB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xL17ugPL; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326e21dd6so11117810a91.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645321; x=1756250121; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HCSQ/Am55bF9MGdMp3JvRTmoLDVuILdPZYo8GVSAz8E=;
        b=xL17ugPLAP0jTcGp6S6S9bDnWC/G/DFHlJ7zMVyH+akrM3Pfwa9yCx9/MrRipba5Kw
         uo/CFrm9zVe4SNzV7kt7cvWxoGZ+snmhcsDRRG2VylQVKJpCT52aMm14hD4gXpCB7Uia
         aLL++8DCHTd6jFqOiFJBxpFMOb1R0DoDAvCcUceoq6fMne+VHNwTAXjbcTXypHKh+ozi
         Z0Tfuy98Eodg3IfsWr3TLfPUywAGnCSvWi07Ut+8i4EoeQ2/K7jmDG2DuPUZzPavxOtZ
         j2upEV/bWgMkek6TvycJ52G0Hb7vd97stE8wCPCPesq9SEcnjHYzoYJBV93FdIBUV9rv
         puww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645321; x=1756250121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HCSQ/Am55bF9MGdMp3JvRTmoLDVuILdPZYo8GVSAz8E=;
        b=p1Cns0tn/S6jFzIdCZZXSC5kQ2auFoFqYp1hywXCPp+aorUU5pP42WzurfG9zxxzBZ
         g8ykNxgxXK27ZZhz06zPtrIGu87K7BldmXgenmO+fmr+hqxk6RKt9EPK8ne8NVLpBTKT
         IOWAM6a2dvLZ8giCGEkQs6byPV72d9ii4cX2u4A5e6GFuql113sVz/AdHLpol1LgJ/62
         hA5uhi3BzoEQ7A6oPfVmE5hMvO6ZDi+TQSWHleAx80aVNHmY+Ne18dJqPSFkpMP7np59
         AyOqHQBK7UZMXUhixKBvhhu6X9QDSWzVDSTtvKS5RwuAY6rndwnruCCjm7fftpI3MAZN
         MH6w==
X-Gm-Message-State: AOJu0YzIs8iOoD/Dj7yPIumZH5yh81b4w6M+BE6EsQ5kQnJo1yiSzGf/
	mB4ln+GuQ8BsxKwHsJZaMpderEbMhhVhdr/qFjqKhr9O88qohTImkv7oYbV0u7YAWUpCmqmvHUC
	877cygg==
X-Google-Smtp-Source: AGHT+IE1K4buv10AFWYrBwJ+SKB86jYN9Gb1rRMj44XCwms08Pl+nZMjhO/8s8VnTxgnLwB69IvYigodA5Y=
X-Received: from pjbdb4.prod.google.com ([2002:a17:90a:d644:b0:324:e309:fc3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d888:b0:321:c02f:3fac
 with SMTP id 98e67ed59e1d1-324e1454069mr1160630a91.35.1755645320817; Tue, 19
 Aug 2025 16:15:20 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:12:05 -0700
In-Reply-To: <20250805202224.1475590-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805202224.1475590-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564463988.3065435.10575489379736763901.b4-ty@google.com>
Subject: Re: [PATCH v3 0/6] KVM: VMX: Handle the immediate form of MSR instructions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 05 Aug 2025 13:22:18 -0700, Sean Christopherson wrote:
> On behalf of Xin, to avoid having to resolve conflicts when applying.
> This applies on the fastpath cleanup series:
> https://lore.kernel.org/all/20250805190526.1453366-1-seanjc@google.com
> 
> This patch set handles two newly introduced VM exit reasons associated
> with the immediate form of MSR instructions to ensure proper
> virtualization of these instructions.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/6] x86/cpufeatures: Add a CPU feature bit for MSR immediate form instructions
      https://github.com/kvm-x86/linux/commit/3c7cb8414533
[2/6] KVM: x86: Rename local "ecx" variables to "msr" and "pmc" as appropriate
      https://github.com/kvm-x86/linux/commit/ec400f6c2f27
[3/6] KVM: x86: Rename handle_fastpath_set_msr_irqoff() to handle_fastpath_wrmsr()
      https://github.com/kvm-x86/linux/commit/87a877de367d
[4/6] KVM: x86: Add support for RDMSR/WRMSRNS w/ immediate on Intel
      https://github.com/kvm-x86/linux/commit/885df2d2109a
[5/6] KVM: VMX: Support the immediate form of WRMSRNS in the VM-Exit fastpath
      https://github.com/kvm-x86/linux/commit/ec93675a3251
[6/6] KVM: x86: Advertise support for the immediate form of MSR instructions
      https://github.com/kvm-x86/linux/commit/d90ebf5a06ec

--
https://github.com/kvm-x86/linux/tree/next

