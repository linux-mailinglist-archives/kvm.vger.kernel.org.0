Return-Path: <kvm+bounces-27208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7CE897D5A6
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 14:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2E71281ADB
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 12:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 638D114EC58;
	Fri, 20 Sep 2024 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYFn5NiB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A2D13C810;
	Fri, 20 Sep 2024 12:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726836320; cv=none; b=nu6jdZb7CCyur1igWA1U4Q+W3gj0/wIKS5C+wnv9Ts4YtxtRUf1xRUxZ4vezXiGBp4gAVpEkAcs/m2cyuY+o6eWivY1EjOUUPraPfTQNMraRydBDm/EOTHV964uKnWKtuSX4J/S4EC1BuGQP6OIBzVwiuS8pvZr6LM2KSsRztLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726836320; c=relaxed/simple;
	bh=RYWngLiCbNjQzy5/yxIOD0DzpgZ7opUeXx37QvvYUBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT7SHtcj0d0iEtdfrzwT6Dt82TSqFW/i1qzjwn2eR8zuwYKvtBKB+NxZpU3pxD/sd7zZnxqAJESAvvfdkbGXGYrmZQGnOdViXvWG+6cyiXZEf7c3AYIGdZvptx0uONambXF/LCp8FvPDRsB35M2bTzg6S7Wig1W030I8WbX/PdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nYFn5NiB; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5356bb55224so2847419e87.0;
        Fri, 20 Sep 2024 05:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726836317; x=1727441117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iipKVXQPvlGQHl6z6SLXbsM2IeHA9bK41lPtQi+8b6w=;
        b=nYFn5NiBjInuFlOw5AhQOY876ONfaNeMk+g3aqUWTQHkWmHG5+VdB/msmwKsZv0Yik
         d2g/VnoVFmZRqpdAR6iyxEw5PoJ11KGfZHtydYzx0GHA7Tig0kegjT1S7Yp/XesqaO85
         xKtADA6rP+sjOdXYLTPSho0HqXLVoa/EvZhTRtGQCS2SYyEHCtUx6bW9JaCaJW6ycwKo
         wmzPIR8lwthhOoMOSUaUrXIrHx8UFAAbZZPpzRnH+IpjYbrKfBHUHdCBj8NDA+BTFwYf
         XFL/zvXmsoTdRMhkL+IqbltlEYHJCte5X0a53aoCjQ0Yih+gOFMIj2KUyhsz0aMoTLyA
         kktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726836317; x=1727441117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iipKVXQPvlGQHl6z6SLXbsM2IeHA9bK41lPtQi+8b6w=;
        b=SwKhRRIzho3J/CrNjhIGVzPMKuRsRiMusp60xxDbrfGXsOZ1KtVHBVvAv3qaq2bY6p
         jKgZQ+oC53im3LallyA+Vxl4TgCbGs4WVKTY7zFBoRLz8dqQPn+x8Ct60dIqg/BpQNpC
         0O/wm6MgS6gnKJGD8mfo//JGdTbTL7GTJoDdMtbq06DWMDWawj2NDm4dMSTB12XlVF7B
         UDEJ2uAYeQrV6fRUU3II9SSZt98DKnvE6T08BiQQciY16kl6BB6cw5NBzHFi946S4mPD
         0aGC7LyGUU4SRppWmgKz5Gb5vyDiv9u49JG4R0uNIlH+g0gICQD77yvvHONlixscTM3Z
         uPgA==
X-Forwarded-Encrypted: i=1; AJvYcCUf1mGqP6AnKoQAi7VA8LpCMkxrIbvwIDobWto2v1YkCS6ghc86Oz7Y3CWeAqD8ZKoQE94=@vger.kernel.org, AJvYcCXEd0ZcU0BIst/BrRqPEaIPfyCo7CPnfH+f3hVdMgzTk/bHKq2aM7dJKBtikWz0nQuOXM2haBl6Ps1VBWyU@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlz9LqHhofNiO5WPzpu8Cq5+THQHHKToxNPBbuL3IkGLKa5Cuy
	v600pm1lyQoZ0/q6FUiF3fNh1Lv/iZKhJPjbYy26gjLqKpHxbCcy
X-Google-Smtp-Source: AGHT+IE77i3wedkjxsGyQ95132/mHVvyLiZFifKNCHjs28ASk9xbz5Z5yoDIUaVngB6SaRYWIvsTug==
X-Received: by 2002:a05:6512:b16:b0:52f:413:7e8c with SMTP id 2adb3069b0e04-536ad163556mr1655955e87.14.1726836316636;
        Fri, 20 Sep 2024 05:45:16 -0700 (PDT)
Received: from localhost.localdomain (2001-14ba-7262-6300-8661-c828-e9e5-8ce4.rev.dnainternet.fi. [2001:14ba:7262:6300:8661:c828:e9e5:8ce4])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5368704c1a4sm2161115e87.68.2024.09.20.05.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2024 05:45:16 -0700 (PDT)
From: =?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?= <mankku@gmail.com>
To: seanjc@google.com
Cc: bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	janne.karhunen@gmail.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mankku@gmail.com,
	mingo@redhat.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	x86@kernel.org
Subject: Re: [PATCH 1/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
Date: Fri, 20 Sep 2024 15:40:29 +0300
Message-ID: <20240920124414.26988-1-mankku@gmail.com>
X-Mailer: git-send-email 2.44.1
In-Reply-To: <Zu0vvRyCyUaQ2S2a@google.com>
References: <Zu0vvRyCyUaQ2S2a@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This is architecturally incorrect, PPR isn't refreshed at VM-Enter.

Ah, I see. Thanks for pointing out.

> Aha!  I wonder if the missing PPR update is due to the nested VM-Enter path
> directly clearing IRR when processing a posted interrupt.
> 
> On top of https://github.com/kvm-x86/linux/tree/next, does this fix things?
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index a8e7bc04d9bf..a8255c6f0d51 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3731,7 +3731,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>             kvm_apic_has_interrupt(vcpu) == vmx->nested.posted_intr_nv) {
>                 vmx->nested.pi_pending = true;
>                 kvm_make_request(KVM_REQ_EVENT, vcpu);
> -               kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);
> +               kvm_apic_ack_interrupt(vcpu, vmx->nested.posted_intr_nv);
>         }
> 
>         /* Hide L1D cache contents from the nested guest.  */

No, unfortunately.

The vmexits L1 is not receiving originate from deprivileged host (like timer
ticks), running in vmx non-root mode.

Thanks,
Markku

