Return-Path: <kvm+bounces-34108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF279F72E1
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:46:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8F787A37A7
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A81113AD20;
	Thu, 19 Dec 2024 02:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kG6e9nx7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5425812AAE2
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576285; cv=none; b=F62hq/H+P7hgbK9RuYPZMb9S/VJ/JaK9CFCE5pvjA6QR78yy+tAqVKcAX/TBCgWpNwETEhwzF5pbTIsSlvnri6THBvfiuecBnZOspu5r0BmfzFj+mVxVG5j0cGTrwetbnzn+NqKrNlLvnPOJJdok0ylCsFkcjh0WayUf0i4Wz9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576285; c=relaxed/simple;
	bh=VsRz9cbcuRf60G80oMJAjKlGe28cQi/BXihZPRlFcVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PtK7RUHeX+q5c4jR5K4Ar5loDZiO8237HSSSpkKx83AF7s294qgiCSXkajYuBpBgaObHLE4u9ku0xZm89ABSBz5sR7blUQOnnXCnqLo1aDxlVFouxYHS7gW6gDiTl/ZPoRTfsn4I402KFFgb7vZT+EmI/oc16dmu2fwNXTWBBBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kG6e9nx7; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7f8af3950ecso179302a12.3
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576284; x=1735181084; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4xcZuRtspKYfmogvsUxP3kyYrFvlzBCT1VAAsqmPHfs=;
        b=kG6e9nx7H17pe7tw6QRKmjsNDchLzL327uFF3+nIL9aZv5QbDuvWZny2g7vtoqEDvy
         QXhtQ2ZQY4hdXCeHKRRgHwpK1N+0/PLmGER0Z75NydQWGnnY7OoJ/t+ymuiWBreVSQ58
         4HmQE6skoCSwo91tc4hlS44d58s+ghJSiImLoZeEZdyGzZqhAu1PHT6zjpY2iLZQiP3y
         pwnUfK+SUqSjId+GDHDCDdO1S3byx8O+6yfBX9NbGJTEmcXBgcaykLrqiGzF6AnHSJWx
         KiqOVdvRSsSSWSb3dqdAEtM4cCy+2eAwsOaZi55nZzMOmPMRzMrU3HCmEol2GNo9NVg4
         uVfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576284; x=1735181084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4xcZuRtspKYfmogvsUxP3kyYrFvlzBCT1VAAsqmPHfs=;
        b=daf9da8nReFwVP9jQcYIfC6vn1lfqUQ5YsIDhPJq4DdtyqHwkboYYSjzfrwtf6+7gc
         lIz6i+G0EUoc3YiSy6SNrR2X22nx2O8bdRS6IGEAzCRURL01ZnGvtGYfjjYwtRyg9j2A
         35zijbOc26t1i+r1fsaeANG8F47TWlAFX26oIJFYJWxToHGM+w3vSGoV2u5M9YhtDkcZ
         JGS1Dq5fs24FrEtc8ViNvGoYb6MN4jjpQb9m327y4cnHb+trdwXMHJKHJpByGzcACeQZ
         H1nsrkJxGmu/qhx8M+nTQQH6qGM8YdFIsgkUOxS5zTTekJb7e+NOc4xmwAYqrOy/Gb1r
         fEuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBKgy9Ft/c1QxuIPUeq0Cf2Z/LhCDIfWtkVevbRAmQCgXPsGY01J9+4isvBgno4lsOK7M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn2iM+YGy6geRaGuJFBcBYu4hl9bLZ7UlDcXKvDw6BijR2+jb7
	EwBY+Kvs4EouWME+6ZAAYw9OvoFYOHWhV0LP8yZFjA9za13Kk78pTY4o1oB5UYNSdWmvVxkQ+KL
	wuQ==
X-Google-Smtp-Source: AGHT+IHr+zgYnxtJiQ4X+C4Vpg3GuR0SOmHziXEWcP588jeib8mFa32XYwTmxnVH6yHUlwpPf/8X2a5bEWk=
X-Received: from pjtu8.prod.google.com ([2002:a17:90a:c888:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d48:b0:2ee:b2be:f390
 with SMTP id 98e67ed59e1d1-2f2e9352b0emr6631246a91.28.1734576283774; Wed, 18
 Dec 2024 18:44:43 -0800 (PST)
Date: Wed, 18 Dec 2024 18:41:00 -0800
In-Reply-To: <20241111085947.432645-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241111085947.432645-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457544278.3294676.11531425279601074983.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Remove hwapic_irr_update() from kvm_x86_ops
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 11 Nov 2024 16:59:46 +0800, Chao Gao wrote:
> Remove the redundant .hwapic_irr_update() ops.
> 
> If a vCPU has APICv enabled, KVM updates its RVI before VM-enter to L1
> in vmx_sync_pir_to_irr(). This guarantees RVI is up-to-date and aligned
> with the vIRR in the virtual APIC. So, no need to update RVI every time
> the vIRR changes.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: x86: Remove hwapic_irr_update() from kvm_x86_ops
      https://github.com/kvm-x86/linux/commit/de81b8b2532e

--
https://github.com/kvm-x86/linux/tree/next

