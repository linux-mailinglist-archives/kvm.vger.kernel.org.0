Return-Path: <kvm+bounces-57657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFDEEB58962
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B046552203C
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B541F5434;
	Tue, 16 Sep 2025 00:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fEMCeB70"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3B51D6DDD
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982515; cv=none; b=SRCzc5Qu8Crp+oO6GJ4uQd7XOxUzq9P1XoTpaB2c3eHqYlXvFRSmbG41SY4mxYz+SKqEc0TxIoqdwanLzdhNuY40lndxgXRmSg9T5Z88E2pS3Z5zs+TRHmg4Tx2SntGKWK/ZBiUXb5Y72UzPfG9xnzT7SExEQRSD9QinIM3o05o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982515; c=relaxed/simple;
	bh=JX0UcQuHupmId46IJr43SiaDoDTDb3nm36tgidFfH8Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mBHmKqEHAxpKXI6v/jeIyMVuFuzkV/8mB0WumNlNpOrf6w5fJeEcpmo5SYI/A364yV2vkWHsEtKmEq6c0fFVZ3zY1zoudK9XwtQaZJIq/JNVkVnn+5FjTHSEbPHgqGrQmqGwx6LkQJ+LfpZMygF2EcLuU+N7VJmA57Y4GFISCiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fEMCeB70; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32e0ef48819so1814274a91.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757982513; x=1758587313; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qh3c25Knpj/n+HZod2yW+2iuXH9YBdAZGgMPVRPQco4=;
        b=fEMCeB709QvPayI/bYcFYnrPMx8O/Euk5Y/RdbD9mbDR8d2TSPdEFJlhXyRnHLzHAC
         u7pGtJhA+rTJweo5pZx0wT4Tah+kmap6tYEyhjWk8ERMqmmvEFpe63H5yPdJyf1nlBmv
         k1vERCFkfVZl7jwZ1fTbbT6nJ16Tx8WyZYDca9lTs5gbRSJ1qsTUJKfz17rWftSpP6iW
         po/3CSNUKX5CsUODNhTdr3TOqP+ik35Xj2oR/9Y5Ndmm4pPjYgab2T2QpVCx3aO9jxzo
         LD8PnFNPpOHfweSAYmqKtWtgy4coBv2nahSU3TZPQIyeXFTx/58QuaoY/UgD/al1Gij2
         haIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757982513; x=1758587313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qh3c25Knpj/n+HZod2yW+2iuXH9YBdAZGgMPVRPQco4=;
        b=nyxShfcplKGky8cP7bLi6GoVjvgn5BkWDzaT6ScZUfmoTvd9CyCtfCUh/ldR+2u7PT
         CQryxJNraBnjKMmP/yFLWXV/rHgDtTbUPKw+iEANs6s0qOaumWYxPt3QHmD2fTUVEeo5
         3RCu7Vr6si2+njwnJuMU1veh2zQKnDo13TKLHd3QUEKICheC8KtyMsH8C/R7PG1RbV6u
         RglnwkaGHP2zVJiWiQW0Hn35iNc6jdKtJJ3qv8t+VSlnO57NemmOWutHnz5GLcGoxMX2
         wD3o8JB1n9SMWhDGVuSZ39pYL12PChkbz9Shmd1zNAk12BPKfU8TF2/dXWqSdp03SmGd
         tR7A==
X-Gm-Message-State: AOJu0YwQIDs5Hkxn/1s+hx38G1zXspMs/EMSje7z1JFFJ9+qL+kfeXVx
	tAxfuIJHnofZwJck6m5AfNpgTWZK6MQyggw7kr2tOtdhArnBChXUuSxXGd9pB2LZJpX4gxGWCjl
	SaI3GMA==
X-Google-Smtp-Source: AGHT+IHlqPB2LQWi0UOxXLJVTLGdTA8AQIKB/YZM3ckd+1Eu1ThWb/99D6oOfDRWrjfnum2LfoUj4QLmLVg=
X-Received: from pjbsx6.prod.google.com ([2002:a17:90b:2cc6:b0:32e:613f:b8d2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5866:b0:327:734a:ae7a
 with SMTP id 98e67ed59e1d1-32de4ed232cmr15805386a91.11.1757982513133; Mon, 15
 Sep 2025 17:28:33 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:25:47 -0700
In-Reply-To: <20250821214209.3463350-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821214209.3463350-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <175798180645.621821.15899499815524721468.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: x86: Clean up lowest priority IRQ code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 21 Aug 2025 14:42:06 -0700, Sean Christopherson wrote:
> Move some local APIC specific code into lapic.c that has no business being
> exposed outside of local APIC emulation.   The lowest priority vector
> hashing code in particular is *very* specific to lapic.c internals, but
> that's not at all obvious from the globally-visible symbols.
> 
> Sean Christopherson (3):
>   KVM: x86: Move kvm_irq_delivery_to_apic() from irq.c to lapic.c
>   KVM: x86: Make "lowest priority" helpers local to lapic.c
>   KVM: x86: Move vector_hashing into lapic.c
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/3] KVM: x86: Move kvm_irq_delivery_to_apic() from irq.c to lapic.c
      https://github.com/kvm-x86/linux/commit/cbf5d9457462
[2/3] KVM: x86: Make "lowest priority" helpers local to lapic.c
      https://github.com/kvm-x86/linux/commit/73473f31a4bf
[3/3] KVM: x86: Move vector_hashing into lapic.c
      https://github.com/kvm-x86/linux/commit/aac057dd6231

--
https://github.com/kvm-x86/linux/tree/next

