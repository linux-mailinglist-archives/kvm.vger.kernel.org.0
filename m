Return-Path: <kvm+bounces-27202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 37EAF97D267
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 10:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E35991F23425
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 08:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96A2768EC;
	Fri, 20 Sep 2024 08:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0WuBoSGr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5DD76048
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 08:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726820292; cv=none; b=fWOGSnjSl7rYB9bThhHAJ627W5fnxic0t9WHc8PP9q/MSqRUB413F59COT0vGgZ760/uuhma01H1835EyA+lm8XCk0D6VJ94qHN/VDsnvVLUnkfVPmiM+HZNdaYunjiqJzbt4yiP1x3iL/1O6wO9V7AHKsqygKBLRSiVpqfYMS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726820292; c=relaxed/simple;
	bh=RAQrRvtbIqXdLwHQwT/AKIvCp5PD00AGUk+DKN/PzkI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OMHyBOn76FkHL/aSA7IJYMNj6xt8kyz0kaQ4BB4cFzqMxUpTQdk51vk/lFK7/mlvyqpu5aAT+GytKx9p87xZUy8e+sdiyJyxV6tokSlVElpUz0OIsPBxIB/kIFrSr0Ujvv+/QMN3nfs2EkCGF8VBlS4crC0+q5twYa4a+IK3MuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0WuBoSGr; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b3d35ccfbso2623894276.3
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 01:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726820289; x=1727425089; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/uRJgyLOLddEMNrdHfSjNAL0ubIHrvPY02GX6Qup/s=;
        b=0WuBoSGrHo13D7kyKV/Q4R+1i/xAqRWYPGgc+0KI/q7ul+CqwCdXwyynoJQNnuWV5R
         nC2sI6Bz83gGI0yMd5OnZhJ1p2RogpxILGNP3ByrXZbrgQHXvg7xo0YL4onIzQ73QOPe
         zeDr1Pl9ffGYL0t4C9MGZqvZ18xSRSGPwVbKomUCwHaKaPDhYJ4D1p9hkBTJoGtxC0yc
         adPiF6iurJCuLYlix4YMOAhcf62gWExdql9mbnfUlShk5OicosaLmj3YfS47CIl/lLnY
         by8BYczVlgBNVP9aVLzLMsL6MhPN7+rsittJrL1Ux4jHq807gxK1PmV+knZ/RyyKp5Pl
         IL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726820289; x=1727425089;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G/uRJgyLOLddEMNrdHfSjNAL0ubIHrvPY02GX6Qup/s=;
        b=BPVPyB+Dh0VV6VR/YWJMgGSEsjNsuMt3hK1y1thR4HaikR0syDvh6gULpxMFz/Exfy
         r3f394wyltVw1y/wrJqyOwAahh9NpjVIwKjJVAU/C8abQ/0oUgGleoDUIFybjaWZ5AET
         wHkvxvQLcEID6wpQAP9kzJdaOlpTay8K6kbprU28ysjhB2we2DxyIm6Tiv7ciy06+CKC
         v/BoYM0+QBC4JumVVNfIUuZ12ljlbAsQrHQ0kSUjzIKMLIWY6zE5la014iXsYCJWgA1Y
         59tS/xBoz6YNT7ee63LiQ7x+L8CO8bPxdKw7NQPWdpvEnEFkCTHzpCrHub666FysCHq1
         JPVw==
X-Forwarded-Encrypted: i=1; AJvYcCVF+7DVjv0gjNDB11kudkrSJHdoEwEVyzIt+u/k2rQx6G1b2VqLBD36vqokYvhL4I4g4yw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQFB2nzeyWG+Les7Y1qYbi+ARGlCytTl3RPTLFY0YZ/OTtp6KQ
	4NI2kbQ52ba7nvl07yxDOz4YZ/MG2MDgfcQ49vxK3W/347sD1TNIHY256R7zZhmMyZ14DvZSsu9
	JnA==
X-Google-Smtp-Source: AGHT+IH2cetVHeWWdupsX/QGjDvXhnZwXWbzfvZX7m34wcYgwGDvwUA0kxLlrpZ7xGI3OlYmd0LLvAvK1TM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:b0d:0:b0:e16:67c4:5cd4 with SMTP id
 3f1490d57ef6-e2250c2d5demr1864276.4.1726820288549; Fri, 20 Sep 2024 01:18:08
 -0700 (PDT)
Date: Fri, 20 Sep 2024 01:18:05 -0700
In-Reply-To: <20240920080012.74405-2-mankku@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240920080012.74405-1-mankku@gmail.com> <20240920080012.74405-2-mankku@gmail.com>
Message-ID: <Zu0vvRyCyUaQ2S2a@google.com>
Subject: Re: [PATCH 1/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
From: Sean Christopherson <seanjc@google.com>
To: "Markku =?utf-8?Q?Ahvenj=C3=A4rvi?=" <mankku@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, janne.karhunen@gmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2024, Markku Ahvenj=C3=A4rvi wrote:
> Running certain hypervisors under KVM on VMX suffered L1 hangs after
> launching a nested guest. The external interrupts were not processed on
> vmlaunch/vmresume due to stale VPPR, and L2 guest would resume without
> allowing L1 hypervisor to process the events.
>=20
> The patch ensures VPPR to be updated when checking for pending
> interrupts.

This is architecturally incorrect, PPR isn't refreshed at VM-Enter.

Aha!  I wonder if the missing PPR update is due to the nested VM-Enter path
directly clearing IRR when processing a posted interrupt.

On top of https://github.com/kvm-x86/linux/tree/next, does this fix things?

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a8e7bc04d9bf..a8255c6f0d51 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3731,7 +3731,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool=
 launch)
            kvm_apic_has_interrupt(vcpu) =3D=3D vmx->nested.posted_intr_nv)=
 {
                vmx->nested.pi_pending =3D true;
                kvm_make_request(KVM_REQ_EVENT, vcpu);
-               kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);
+               kvm_apic_ack_interrupt(vcpu, vmx->nested.posted_intr_nv);
        }
=20
        /* Hide L1D cache contents from the nested guest.  */

