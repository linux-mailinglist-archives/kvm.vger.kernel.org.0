Return-Path: <kvm+bounces-38223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90DABA36A7D
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:03:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 044673B26CE
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B171A9B34;
	Sat, 15 Feb 2025 00:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GwuOd1Gq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46671369B6
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580988; cv=none; b=hJqrBPJd0geu79AzncKHae16mhO2SrpCFxTJIoNpiDF7+8JmCfsrKX5mofVcy/guEcMZlJoXkLp/rFz9SQ1XgIqcKE42XgYSn33EeEEqk28odENo70+7pCN3/mswSMgXAPtkoqYmuHfXKvO1IVkLZsgPPZTzVoKc3LwN9yC4nn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580988; c=relaxed/simple;
	bh=DCnpPQ/WwTAd3s72FgUzg4owdgtwbQZ4WJnMni9AG5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U42ooUAaGXAr9zNrh0sGGkMLWHGZwn+3XyWjrWTeCknlfXxS073eqMn41UymCWv6gfW6TafM8+MjJp9SWz0ht/lGKUaFjAqRicWMyVwAcHhOsQAh8bNtmHn9DeIclBjvtTB4w60u4fwGZa/gPGPQOmXY/HGgf5kikIgQY/kJR0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GwuOd1Gq; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220bf94cb40so44062875ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580986; x=1740185786; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TBK4qn2rx/nQg12elABJ09B0nERLMVWWp6HU7JkxYNc=;
        b=GwuOd1Gq5Lhk4129h3TMGzWEXytNG8xDJs3PZoIjpAJ1VL0Ja6JqJ0fW+X8vC0SP0Z
         EaUAGC6KiQVcEzIVCnamLGFtYFjXM+sKQ/oc+uXPRqqn1VYyMAglcb5Q6o+2a/fCgBZv
         WZXOGzyHPd69DTlyOz6t+9a7TcU49k2O3P4WZgeoPwfQQhmJozKecOCju/pk0EyxRlL0
         o3wBtU1r1P5yPyg94JogIeREa4JJJpm/CjvMgOcFnKkREbLkwewXkxbXsmTkQ6yUIfgA
         tC4QcLeYjh5S91zyY9HOKhlwTph+V8xZNyIWbFv6J3vIYoDf5wkh3oEEwnvTDX0nNjU5
         D/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580986; x=1740185786;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBK4qn2rx/nQg12elABJ09B0nERLMVWWp6HU7JkxYNc=;
        b=T/CjqSFjC80HAdZYDDrZISKCEKxDrUaiK5LVfl0vc4MUjAQyhSPzrbW/qvLlyA/qzC
         lzvBnaB/Vw6i+oF1ihHtzOhgrw+aTvYT1KIWQvVyvVEQFF80FVIQWk/fm5CDpay7C/a5
         /vp67X4YJ5pNiFvKCUxA5xEYSHVw4LAqxiGsAVR3t54CSOiEVx4eGURuD0CR0bK4+zl5
         pXDxIWi479sqTmkR7D09Xtb4MnQgqjq9Y3tkjxU8pMYgRUndmK+pS7P0JbbrmUyDCiD6
         u7D3DWVHuuOsDGGvjgSEcRGl7ru2dL4iRLrfkROP5VDrax0ojKTicMp1Ac0QS16IsFpE
         /6fg==
X-Gm-Message-State: AOJu0YxpWZSHNgV4LEetfu+CY3evtcjk5Q02Z+TJcIwr3B8hoZNaShxN
	WD3beke5FF+2E1km/qWwJrwICg3WUXNhliKzIGiogueDrV0zP2H6CFLgro2rm/SN5jkpKSA0VzM
	/kQ==
X-Google-Smtp-Source: AGHT+IG436XgYDFB9d76yPBzvXUSNT2hkZpYz09EOUNzfzyxpmDvZeQLTqGccih51oIdBy5h2H10zp9vp00=
X-Received: from pjbeu15.prod.google.com ([2002:a17:90a:f94f:b0:2fc:1eb0:5743])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:28f:b0:21f:85af:4bbf
 with SMTP id d9443c01a7336-22103f0d484mr16863465ad.20.1739580986053; Fri, 14
 Feb 2025 16:56:26 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:31 -0800
In-Reply-To: <20250130163135.270770-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250130163135.270770-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958027698.1189587.16446324269012932260.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Actually emit forced emulation prefix for kvm_asm_safe_fep()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 30 Jan 2025 08:31:35 -0800, Sean Christopherson wrote:
> Use KVM_ASM_SAFE_FEP, not simply KVM_ASM_SAFE, for kvm_asm_safe_fep(), as
> the non-FEP version doesn't force emulation (stating the obvious).  Note,
> there are currently no users of kvm_asm_safe_fep().

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Actually emit forced emulation prefix for kvm_asm_safe_fep()
      https://github.com/kvm-x86/linux/commit/89ea56a4043a

--
https://github.com/kvm-x86/linux/tree/next

