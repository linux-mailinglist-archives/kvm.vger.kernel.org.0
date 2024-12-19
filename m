Return-Path: <kvm+bounces-34111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F369F72EB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:48:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A437E1891A14
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3689A19FA92;
	Thu, 19 Dec 2024 02:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H8f2tFep"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040CA198E77
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576309; cv=none; b=pwKdYznnUL1pMPYtW8krWE7orYbVfgVp3h+iQ+olFD1xaNlNNUqaH3N7+CiPte20KfkaioUvt0w2ApPwJbIWPfVBwEkbcoxlpiDhI8FQM/pxtQZjnaSaNP8NihDmxChqeY7oZV2BPc54x4ARcMtZ1xJc6NMJqbpP6alUUeTjmEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576309; c=relaxed/simple;
	bh=NzHJJtpOtd1WItoExeLvKeiVA6lPDVYu9O0Lhn7Fv58=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sE9t4mJuQYpYwkeWyML3v1ePoH2YlHROAchJXZLRnkSHmUSjBHztV2TPzcIJwSRLb9m7QtZKWVfToCSp7QFV0w3OK+w1IFrGFpwsW/bplesUNwlfTS2BLOsJslORD7c7NDTimp5PyYQxutj2aaP+QXGeF7tEDNaEVLwcXry/HYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H8f2tFep; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9da03117so412140a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576307; x=1735181107; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oMa6M6qeXf7eFmv895QwR1Mw+IztHYVWb/mr/5ATvJg=;
        b=H8f2tFepC/e9RsnroZkgke26HNz0iLr3KuBlvEwpPO/oSi/TxKsL18DcVuQJZ7QdWb
         verWCw3pyNbmBSidoHGxeLPHe/GlJO1cQaiF2D00bTx/KSBp0XQ3X2048sqH+CuoU2+d
         abBYKzZzrn2ERwvuotmsDSCds8rxC20cNNruaBFgqg8L7RujmHEGy6gNBZXfv4xDlhrZ
         LS4K3Ohx8Wehi1txuyAPjtyLRSLKdR+sdARFxS3+A8oBRLBwRvpkQmbHMQElSZOhuQGr
         QfFrKPAm/g3eI/pu1MDh/YQIPbaf2mR/VxgCxqDcmCFCfXBh0EfJM7BgjU6OSkJOpgzg
         gihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576307; x=1735181107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oMa6M6qeXf7eFmv895QwR1Mw+IztHYVWb/mr/5ATvJg=;
        b=BUM3M1iHUDj2A+/n6n/7rSoqHDTljAe+Zqhy+QI+RjrhTIo0caQZo0PeuHlUAm7q2B
         T3aEFqvSMWwHfFppJubfn3PckG0WJyUvNhIQJLZyddWxSKsUZtMXveMD97/SsO1ueWou
         JtCzUu5mv2c/Km7XPAPiTD37P6dN+f80pP9pS85GS7SoGB5c0I2hlTtNdM1gOuQ2WHkw
         22lsuZhAZZLolhChdMJSByejd9UZFyj5uwhiiThVP4aHmLKhx6+LvhR58OfEtSuPkENH
         8CnRXF0l5k3/rXgtJekU9K/h5SPbNjfFhNVYNqJwye+zxRvLDv367Gh2QiHQnhxQekDz
         bHGQ==
X-Gm-Message-State: AOJu0YwzykmwaKljVc4k+gwZCMPzPe4Jwnxw4lNxjbykZ+BrfONl3ZyI
	CmySLzN+zMIbLpz4FQP+XgWZ/78wLf1voi1HmbGfB1KTT4ttxGC4IyVgcHMdBtWy3Rmq9KhYp99
	utQ==
X-Google-Smtp-Source: AGHT+IEg9adkTnQukfAhPRrZLxYJum3uufxHjJZt67IZqjriQPgMk8yRvO11wd6yWimVfLPAOixgPwbB2ug=
X-Received: from pjbsd6.prod.google.com ([2002:a17:90b:5146:b0:2ef:8055:93d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f84:b0:2ee:d958:1b18
 with SMTP id 98e67ed59e1d1-2f2e93a1fafmr6918091a91.36.1734576307245; Wed, 18
 Dec 2024 18:45:07 -0800 (PST)
Date: Wed, 18 Dec 2024 18:41:06 -0800
In-Reply-To: <20241128000010.4051275-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128000010.4051275-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457543074.3293774.16414966683052346412.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: nVMX: Fix an SVI update bug with passthrough APIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, 
	"=?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?=" <mankku@gmail.com>, Janne Karhunen <janne.karhunen@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 27 Nov 2024 16:00:08 -0800, Sean Christopherson wrote:
> Defer updating SVI (i.e. the VMCS's highest ISR cache) when L2 is active,
> but L1 has not enabled virtual interrupt delivery for L2, as an EOI that
> is emulated _by KVM_ in such a case acts on L1's ISR, i.e. vmcs01 needs to
> reflect the updated ISR when L1 is next run.
> 
> Note, L1's ISR is also effectively L2's ISR in such a setup, but because
> virtual interrupt deliver is disable for L2, there's no need to update
> SVI in vmcs02, because it will never be used.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/2] KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()
      https://github.com/kvm-x86/linux/commit/76bce9f10162
[2/2] KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID
      https://github.com/kvm-x86/linux/commit/b682d2fbf17c

--
https://github.com/kvm-x86/linux/tree/next

