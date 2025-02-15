Return-Path: <kvm+bounces-38212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 440D0A36A19
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5657E189432F
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 00:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7470824A3;
	Sat, 15 Feb 2025 00:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S05eg5MG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBE332C85
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580644; cv=none; b=hGI06iEmK/9mXNimjLbGt03ZNnIMbF2VUngES/1c9zYb0SiKf5wIgkG3vbVPLPJDYrj2/GJsULbENR/qXTLmODfkd/cXs1nn5u8MzZ2N0qjhomkH38Nu75hVoGd64r1DoRAGqa5SmkfiAkC2Jec7HX5aoJo3L9fCshE+C6wVpjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580644; c=relaxed/simple;
	bh=POYEUzJf4F7hR6ErGP8+kECs4BJCAdIjReed4JoMUes=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZfhbyPDfr6L8CQtRXttL0+8r/S1E6vTkt+ybAZt/ykGI67m9kQM47fNi1L7HwQxSxFAH+pzXPFx/RDMX8uxaFk/cSM+7b0e7n/pe8v/NI3yjh1I25B0kaiBXGNxd6DWcL/iC2PkKXiOZWj5olxRMbMvwOEHPxl0W4BMW4tdFOu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S05eg5MG; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220d6018858so41996095ad.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580642; x=1740185442; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8zARw4+ZV2w+QskDlMwskXcGP20di1IcERKsXgaTywA=;
        b=S05eg5MGb7+H/ed8tgKfCkK7Eo0lsqwrtjHxw2vkP5MYmKnW/pb/GJZcp0XJ8Ytxza
         qiIDViQtBjqnFnMXsPfV5KwfmULqZkwFR4tHOluc5W0KG0ebTKnQALJDcLY3RbPZdxCk
         ficaPXcnEghgzJZDjcq7TxHy3TZhyj4FsI24NWu/BDe7x6E0wjs8Ztxk54i/iyBHC8T5
         0dRHHlJ/Op2Pq0DHzH+kGhK2Yx7R74dX4MTNHUKnLpwyqIHGLbSpyIYt3LDyNguFpXBY
         8vJ2CZK4TQxtb2pVjtWnmbEh8DH735XE2VvHjtnsz2SkxbRI44q2uGvXYwvXvu5mt1eq
         l7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580642; x=1740185442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8zARw4+ZV2w+QskDlMwskXcGP20di1IcERKsXgaTywA=;
        b=dcG2Av4/mfcQ0zwbrpbJ0KloFpJqjM1tccBdFBS5cWhUVP3YgPntnZvTt0eYcLKxTA
         jQuE2vzyewa1ThNAstaroW45iEvAMoOvWBl/aJS6YI/aRSNdBNHXOOsV0XWyn1gmrOJx
         +DCke656JDg3dLDcw1JSnC6LjNIZObW+7HLYkTLdQh3mB8LEjL2UMkIxuPJYc5iWHHRs
         yFwt8wB7pJoBSrMQiYV6xxmkBdWqiKUzHYfTrIzmIg0kL0ctbjqb1aSwowRfITQcOJGB
         iREWtNl7stTU2uJ1wSN1DoU1s3r6t5fN+06FJFvdSplngCqchNp2s3g7Y+Fy13zSRpDh
         xHuw==
X-Gm-Message-State: AOJu0YzZgQeyUE68K7yo17wRb5JuFOVw+d5ALO/ajLiYpbztqIlew0F6
	w7gu2q+VOpsthi67GZhRY9j8CbQdGLryL8HTut1nlYBoWXprNcfyFEJhhfdw20zmOzpQkbCv4UJ
	CUQ==
X-Google-Smtp-Source: AGHT+IFz4wSyDecNXJFqvihaxPn+qeYB3cCNRHI/ww3DuyZD0TGU1JQo3GTzf2tFJmRc3FF10QG3ATPZpok=
X-Received: from pfmv8.prod.google.com ([2002:a62:a508:0:b0:730:7b0c:592c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a07:b0:732:5b10:572b
 with SMTP id d2e1a72fcca58-732617bd3c5mr2231913b3a.10.1739580641807; Fri, 14
 Feb 2025 16:50:41 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:09 -0800
In-Reply-To: <20250125011833.3644371-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250125011833.3644371-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958027023.1189487.12347713108460200107.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Load DR6 with guest value only before entering
 .vcpu_run() loop
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	John Stultz <jstultz@google.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 24 Jan 2025 17:18:33 -0800, Sean Christopherson wrote:
> Move the conditional loading of hardware DR6 with the guest's DR6 value
> out of the core .vcpu_run() loop to fix a bug where KVM can load hardware
> with a stale vcpu->arch.dr6.
> 
> When the guest accesses a DR and host userspace isn't debugging the guest,
> KVM disables DR interception and loads the guest's values into hardware on
> VM-Enter and saves them on VM-Exit.  This allows the guest to access DRs
> at will, e.g. so that a sequence of DR accesses to configure a breakpoint
> only generates one VM-Exit.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86: Load DR6 with guest value only before entering .vcpu_run() loop
      https://github.com/kvm-x86/linux/commit/c2fee09fc167

--
https://github.com/kvm-x86/linux/tree/next

