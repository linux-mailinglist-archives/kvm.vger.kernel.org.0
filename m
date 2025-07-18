Return-Path: <kvm+bounces-52908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A8FB0A70D
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 863E07AF42F
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 544812DD5F3;
	Fri, 18 Jul 2025 15:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1q5TgRO3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40610770FE
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752852178; cv=none; b=uye+AK2BNkkAxuyzwOgixjVjGiWJyRNe92X4IwdfvhuyAM3yb1UKsjTtDX0t1Mt4cE5gyqdiXw1sgaQ/D+fZePKMPvXAxN4Be9PqDU0X8ronFQZ1gdoCqpNsqtLJhi6RRzsyjbVGNZj17jUWRWIZGtciq22/NUB2GQSuqE/bEgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752852178; c=relaxed/simple;
	bh=h7q6reLOVheGsZaNKSwl4n0WAcp7uhc0p7859t2Tq2Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ecjpV9Qo+MNn58T0Belz0HfSGsyhO/HyE/ZeUdcR6azmA73VAaJ3nJnKhr9Hm04+lpkZ9ajAfTEGbVny23fvXhc+jrC9gAvi31p2tv6fzfNBLhxnch3EhlscRWStfBvbW5P/3Wi4Ip0LPEMgqeIcPuIudfD/U7T1q36iz+LOTlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1q5TgRO3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3141f9ce4e2so3264303a91.1
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 08:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752852176; x=1753456976; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8gk7HrZFZ4ah7oZlUSyYLVPKufe4IyNCvV96cxCrMuk=;
        b=1q5TgRO36rLGIGhsDQpu4PeQCFfRvSL8Vx7elBvddH1ZgvzDPld+dFQR+76gDWBP6U
         3HnsSUPbdKx30e1OYt0ENDZO73mD6zah0o98LVb4fRpbpw+NrsYxNw1Crdj04VvsvG1+
         g6JuJetfxuC1+7P0Ufw7in4qwm2kxnlsN67UPtwIOhwtRmCeIoT8QrPYuTactzluuzy9
         R6b/dv7L3v8PCGM/sNC0TPcFXfnBH/M872LmQw1N5rk8Ix9GpbHkQhzBU1/6/vbJPzF/
         liPButKa66rb8KfGHmirI5A7nOpdo6nvPFRM7rAM7MMtX/lRHa75ItHOthTzAbUs9fuZ
         5YXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752852176; x=1753456976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8gk7HrZFZ4ah7oZlUSyYLVPKufe4IyNCvV96cxCrMuk=;
        b=ZzLs/0LrdY07ix0ffO0MXCuq/FPuvfx/RmYXKmMb9OEF30HR7wPtt3A6QAVZt7L7sI
         q+zeIgiSXCvdSfnslTlYZLRLf2GnKSHo5uqo7N0x+dv3owxOT3M4UgJiuGXNLTsyYPPU
         eP9mxCTJAr86CPgNZJrJtoZuhP8DTsw+yUuIaKk2Js2Kj+siTUvEc73zkbajdQsqvhCx
         Dr6y6veVOVPm7kI3w8mvOcIHpOGe6L+owfghT5VtDXq9YI/U80sOPwgxaxSRJ436enUg
         POqh1Q7ITXsIPq2cNFbi1KB9GnA72m/PcfLCkrrmlT6P3f3nKm/gisuPNjKwu7S/cS31
         smTw==
X-Forwarded-Encrypted: i=1; AJvYcCVuW0K+uFclS9FT5bw77XWYuCqBoOuWfZ3mUPZKhV4724qOtaooZRI6/BTxrMc7QaR+doE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCGqbmp4avqxgsbGVcN1XrSyjPVyNwiQqnS5H2SyZ+mdWmaCYB
	mNwNCe6MkbOm8DoyeYUVzgbMYQLWt5hf1J/Wq5MFnDhH9Ogm38Ndqoyk+QUT98aDbouFDkxHJtz
	jKUYlgw==
X-Google-Smtp-Source: AGHT+IHemYLkPGfTNf/KBJ684XD0OoZDbY+eeRoJgnLdcVPIkiZ0MwG35e6cDv98jF7HooJYupn2MwsKGDw=
X-Received: from pjbsu4.prod.google.com ([2002:a17:90b:5344:b0:312:dbc:f731])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f91:b0:311:ea13:2e70
 with SMTP id 98e67ed59e1d1-31c9f3c612fmr17703545a91.14.1752852176493; Fri, 18
 Jul 2025 08:22:56 -0700 (PDT)
Date: Fri, 18 Jul 2025 08:22:54 -0700
In-Reply-To: <aHplCKOxhBL0O4xr@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250718062429.238723-1-lulu@redhat.com> <CACGkMEv0yHC7P1CLeB8A1VumWtTF4Bw4eY2_njnPMwT75-EJkg@mail.gmail.com>
 <aHopXN73dHW/uKaT@intel.com> <CACGkMEvNaKgF7bOPUahaYMi6n2vijAXwFvAhQ22LecZGSC-_bg@mail.gmail.com>
 <aHo7vRrul0aQqrpK@intel.com> <aHpTuFweA5YFskuC@google.com> <aHplCKOxhBL0O4xr@intel.com>
Message-ID: <aHpmzhaU5JNqhp75@google.com>
Subject: Re: [PATCH v1] kvm: x86: implement PV send_IPI method
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, "Kirill A. Shutemov" <kas@kernel.org>, "Xin Li (Intel)" <xin@zytor.com>, 
	Rik van Riel <riel@surriel.com>, "Ahmed S. Darwish" <darwi@linutronix.de>, 
	"open list:KVM PARAVIRT (KVM/paravirt)" <kvm@vger.kernel.org>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 18, 2025, Chao Gao wrote:
> >> >> >> From: Jason Wang <jasowang@redhat.com>
> >If xAPIC vs. x2APIC is stable when
> >kvm_setup_pv_ipi() runs, maybe key off of that?
> 
> But the guest doesn't know if APICv is enabled or even IPI virtualization
> is enabled.

Oh yeah, duh.  Given that KVM emulates x2APIC irrespective of hardware support,
and that Linux leans heavily towards x2APIC (thanks MMIO stale data!), my vote
is to leave things as they are.

