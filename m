Return-Path: <kvm+bounces-22237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C6D93C377
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7A61B22B69
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D570019B3EA;
	Thu, 25 Jul 2024 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TDc7bNrK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F96222339;
	Thu, 25 Jul 2024 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721916042; cv=none; b=fcj3U/IMv91bSO3gqduqP0pky3aS6AKDR8j2jFJHuMXWio7T0/GPOgsyTSk2edHzSnpRBJnIhZKAYWd43tiO4ayUbfeUom+j/LJfauecg6UxxnFShbe01d8xBtp5KAlzvMIeaIpWfGonC0D3jTP+FSqSxBDzsvWI8JevSAGW784=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721916042; c=relaxed/simple;
	bh=5LS8zT4+ae2WU98f6VoEPoVrG+0jFCXRqaywvi7a1LE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=uVhYjFZsPTbYgivJntRhicbiRIxpg2hTvBPiFqIRQzyvGsCtS4c63g1I094drhYPSkn3+Onc5ZHjEFq6haz/Wu4+4qE9LwzHXFJhb2XfINKAkHDuaWdtUWx6TmhYoorD1YMUjdJZoV1hS2XaJpQXOfw/De8vdljgPO9vGuFknrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TDc7bNrK; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5a156557026so1119170a12.2;
        Thu, 25 Jul 2024 07:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721916039; x=1722520839; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9U0C1ru6y/GjTW0NF/KENo2sJz3DMojxTlMSqwCD+hU=;
        b=TDc7bNrKsxMsBKjejuVyjJiGGapLVjueWPkYYko0SpCNbqKUAS2jakXoPuaygL/zCW
         Vj3o4RN6tofR92lScopF/+5E1/VpOOm4eSXIHeMCgtuOPytYsKAD37450jb+aAf5NMdY
         7cwIIAECZ+EJLAyN+68irt3Bjnak7QhUtDlOVmbTTVhaXrny4YD6L7YfmC7kSun19oJ1
         Db725B+9q37nt+5AlpR+ZiKrsInlrTzYmv57bA9PALFpPbmMgl5fMfHp37XVlkXa9oUp
         nadZxNSvH/VKRQ0f+ASKN+OWJulo3LYvgWLN/Hyn/ChV1Xhb5GXokOpmkA9cjLi8LjtV
         55CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721916039; x=1722520839;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9U0C1ru6y/GjTW0NF/KENo2sJz3DMojxTlMSqwCD+hU=;
        b=lggfffgWA/w4/DumWnqdRATX+8oICXiYMsl9EzFMZ8+m+CB8MKxFo7gF+BpfeQI4Vi
         PdP9Ohq4zGjv7ajZCLwGQdN2dEqhWZYCobo/ohojSVmalYblYD8LbNk5F0UVvhu4N9IP
         +0Q7LxkgsuObJ+C/XzdqaXVcIv1aJznBLhog/duO92y7MasldBYfCCB43JXcAMUyhz1x
         wV+slCyIAJuVAJxX3G1h7OTD1X31rNCSp3o1B+ExcGXIoZsVOdBkkk3zlEpU0wIFEJZL
         RnbrOab3J8/NpptV+Ukl8d1wCNhtYFRBxn0rOoakGEl3mEBplwhXumMbZd1WuCNaQieG
         d7rg==
X-Forwarded-Encrypted: i=1; AJvYcCVO8gNBR/AHdnxk2Bdd6Iuxx9KNGON9Ls/RrwrtofgsVY7/4LeiSJg+iSnw34xD0qFfZPHyhPFhUNBfxY8svdTW5Me+QlWM/pGJrsAQQ5hjSzplrWpCSITVXgLyVtBxo+4K
X-Gm-Message-State: AOJu0Yzz4pz1eUcCuCWsHXUARBCxWlQTia1xoZWNbXM9BTiOD8RH6utR
	kMr+CJn0h5UJmgwWF8W28bmnf2qkAvAckbtZ8EsQ2rK4bJTfeJg61En67q4r4mgDtNJpD14qvKF
	vn1U8kIcSYe1ou5/dqVS1CxNa/Tk=
X-Google-Smtp-Source: AGHT+IFnE4Xzc3BrgctEcu/SGHy6qtH+wPIxlD6KHqSNy7BtKhu6yz2RPUiasXReJ1FxFyk5IVcGm9kNuGnqoMKv6UM=
X-Received: by 2002:a17:907:948f:b0:a6f:e60b:911a with SMTP id
 a640c23a62f3a-a7acb8232damr179791866b.42.1721916038505; Thu, 25 Jul 2024
 07:00:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Liam Ni <zhiguangni01@gmail.com>
Date: Thu, 25 Jul 2024 22:00:27 +0800
Message-ID: <CACZJ9cV2gv+A_2wCXowzi9M-HrySeBxNLKfK+bXRLffwR94=fA@mail.gmail.com>
Subject: [PATCH] KVM:x86:Fix an interrupt injection logic error during PIC
 interrupt simulation
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The input parameter level to the pic_irq_request function indicates
whether there are interrupts to be injected,
a level value of 1 indicates that there are interrupts to be injected,
and a level value of 0 indicates that there are no interrupts to be injected.
And the value of level will be assigned to s->output,
so we should set s->wakeup_needed to true when s->output is true.

Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
---
 arch/x86/kvm/i8259.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 8dec646e764b..ec9d6ee7d33d 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -567,7 +567,7 @@ static void pic_irq_request(struct kvm *kvm, int level)
 {
    struct kvm_pic *s = kvm->arch.vpic;

-   if (!s->output)
+   if (s->output)
        s->wakeup_needed = true;
    s->output = level;
 }
-- 
2.34.1

