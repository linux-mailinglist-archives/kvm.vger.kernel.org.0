Return-Path: <kvm+bounces-34407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 266D89FE365
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 08:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0724C1882234
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 07:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42DE61A01B0;
	Mon, 30 Dec 2024 07:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U25UNh6U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C067519F13B;
	Mon, 30 Dec 2024 07:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735544656; cv=none; b=ZdAUt0BHZu4Otb+VNx2rDSk8csWU9l/Ao5MxLmDZlPZGKHgmQ4m8461tCrcAKBG0DZHw5DRPSdnMnp4XrxX/YGz/d9ESt6aZAPpj3H3sHNRwz4+x15Q59GRhm5kd1qRkJryeiVPTmbDMd9W6+32ocnvS+1ryWFiNaI+Ct1lZzJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735544656; c=relaxed/simple;
	bh=AJ0EaeodhN80IPWocXNwPfRlfgCqAvCvMqgYRl1s1WU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rfffxFh4gHDNU62/YgdufvWqNibB2DADxO8R9aViSL9oYOZdqzcUb17aY7Wmdwhk7mdviQG3nJotQzqx+1UzcPWca7UB0/x/3iR37hYHYlRAXSOMIMg7286i9kppw28yihZOFPY7OxjgxcrzQL7hSFwJMR0zcf/7BmWvNLp2YMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U25UNh6U; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa6c0d1833eso1861040366b.1;
        Sun, 29 Dec 2024 23:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735544652; x=1736149452; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4PJMRBrMux8wVhfMava1Cnw6QgCPmCLdCAi2La2GbI8=;
        b=U25UNh6U21Lvw3yoys5hjE/e7T5oZqL/LTjoaX2ybEw+cnRe9yE8u4/tTX1wbQg6P2
         Vqx4qo6oTOexqEEamDFeDtTdi36Ngi8VVZR/dViIA6eg4qXoq5WsBPnQYUebR/UOEZcD
         LWy/4vYyv3Xajzq44lfELjLhCVMY6UDfMf5BXxJNB0PjLVtRY/3QZ2FgKNlu97Aovobo
         VN9IfeSL02Gz/3JGH3+Rrh+h95y6Ga6URjG7+ZK/GpGCz3291s/V9HRwAhAhqzEw1r5b
         xgHymnctT7+sjBZmmLvyVj7e04imP+ZVquSfuWafX5WC7BX1tmtAFtptTKHLFJ8d5yaP
         RtBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735544652; x=1736149452;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4PJMRBrMux8wVhfMava1Cnw6QgCPmCLdCAi2La2GbI8=;
        b=acSX96qiFq9HcYB8fBqBDP4UVyg6rWcpR7DvH5/XhmtNjQ4Wm1Ta/Z8jH2OmDD8DVY
         0CBoUzNuYee65TLN2yU0YlYPcPVzjH4coXe8XRR2726l2y5+NiSEJPOMreRc8zaFzk4j
         pzu8PPsl5+PMniO5UyQx+EACRESRx+p0SeS63lzhQyT5MHuKdzBDknYkpyDE0KUST4i1
         K5KxZW2attS38+1hqXICiml/N09/XnXQbZguH6wDUZLB9DxDHEPlyoYj3pOrVizw/4El
         892n3HfaVJGzFJiu071cadEg51MIB7L55+RpBuLuZ7AZ1uQ2pTNLGbQPG6d4J5QnqVGK
         JbnA==
X-Forwarded-Encrypted: i=1; AJvYcCVKB3JIVLgE4D6Cg7u7Vcd28qZ7Z2CP/zJhPu+jvLb4nLHpOysn/OJoGT+3Ooa47DNtOPt49y5mnbGUbFI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHmEw6kvzxZyiNiSPSE8lWbagElH0vdOW076axsApIaJe3+EID
	ZlJkLVwdN6IxIQqJimlV6ITiNQEScLGSgw/ckzSzDRUlIfPYTcHQZNy3t2+tQ8T24g9SHchWgRo
	WsqnOymbzd1rJMsi9uc60RGpNsNcXX1yoq3E=
X-Gm-Gg: ASbGncu+cQ6flCTcOBZlkORq4B7eY9laNGwhNItm8Q1maGxmIECncFaI/M3MK94IVfo
	HbjOc/UwVq7f4IP6JSH/rIty55NeX1fPNOeFr
X-Google-Smtp-Source: AGHT+IG0x9sJ9DYdSGOp1ukR23tSO8ERSKrqqY9dGWaOdrAV92LGQZCfuUfWf+YU7oFbSqtaZxM9Gs7JQ7kSg9b3gqQ=
X-Received: by 2002:a17:907:7f0b:b0:aab:dc3e:1c84 with SMTP id
 a640c23a62f3a-aac2b0a56b6mr3044190766b.17.1735544652234; Sun, 29 Dec 2024
 23:44:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Liam Ni <zhiguangni01@gmail.com>
Date: Mon, 30 Dec 2024 15:44:01 +0800
Message-ID: <CACZJ9cUY9ovqkazdcNCtJf=JPbwOO7+sqL2Xp6rBi_Jn1kx1bQ@mail.gmail.com>
Subject: Subject: [PATCH] x86: kvmclock: Clean up the usage of the
 apic_lvt_mask array.
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Clean up the usage of the apic_lvt_mask array.
Use LVT_TIMER instead of the number 0.

Signed-off-by: liamni <zhiguangni01@gmail.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3c83951c619e..949473e2cad8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2357,7 +2357,7 @@ static int kvm_lapic_reg_write(struct kvm_lapic
*apic, u32 reg, u32 val)
        case APIC_LVTT:
                if (!kvm_apic_sw_enabled(apic))
                        val |= APIC_LVT_MASKED;
-               val &= (apic_lvt_mask[0] | apic->lapic_timer.timer_mode_mask);
+               val &= (apic_lvt_mask[LVT_TIMER] |
apic->lapic_timer.timer_mode_mask);
                kvm_lapic_set_reg(apic, APIC_LVTT, val);
                apic_update_lvtt(apic);
                break;
--
2.34.1

