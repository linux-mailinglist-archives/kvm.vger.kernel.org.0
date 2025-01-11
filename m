Return-Path: <kvm+bounces-35168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DAE8A09F8F
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:40:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56C3E188ED59
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA08B1802B;
	Sat, 11 Jan 2025 00:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q+m3kt5z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A866823AD
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556031; cv=none; b=svuWM9p5WNBS4NdEXXinZ7fYkPtgL//J/h3GOfKIyzSOLxi4NF0GTLFAyYJUQHtUxgzr/EE9e0SwuGy8pMzaq8Vl5oLlQGUGJhVl59oK5WR4/wFQRUeN+DosrM0Nu+1BLhMkhUwZhNL3VqrLaITq4cIcDWHLqAFzBIvoRrJ/D0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556031; c=relaxed/simple;
	bh=LYCX+42re+3E8A1I0Co36RucaMGSTo7jis8Nnz9qJdM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XZ2rWXKepKlvlk+YFsyUP5F3p0OLBU1uzvwQsCsKQK7lXScAmORRp3zeD+cOYnRjZ5YXvM2vGV7OTT9aaLXLGbq9OqZ2HzPa7y8SO/wJu1vEbx0q+hPWEkQ3sfmvp9hnxFdAy4QF4R0wOBwLdgpnvDqfR69FMZk2e68qDDu6BOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q+m3kt5z; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2eeeb5b7022so4788323a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556029; x=1737160829; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9yMVbiaBA6FoWo38EEFg01Y6eTRR0fobEa+ZtoTkLg=;
        b=q+m3kt5zE+fp/tMuaIqWCBIAkwiwWTHsDPSgpolfnxABpI6VJGxmWGDh0P2sRQJy26
         Vc1jUrfTbavrHAIZ4sn2LOTbae2yyCb98WpR7Z5YTb8DUBZQkhYB0PtKCVL2IJPcYtiO
         oBcWuVBxOS+e3DK2s8+l6VWG5ZiBA0uvlqHM2GqZsatU6kAX3BNs1OSSM6V5AHH+q9M6
         t/iU1g6p0RE+5ni82j6cMJNxVkV9A3Ut5QTRD5PxqhCr1FoSsSUnMqbk/RThwl8wRAAS
         4Nc/iqf8mpogDouBUBndcRG4tyELvIhjOiXy6woOdGx9lyoO/+KFN74SpOMlSgTZl2B1
         ENvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556029; x=1737160829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9yMVbiaBA6FoWo38EEFg01Y6eTRR0fobEa+ZtoTkLg=;
        b=vbsJoy0JVGkdYcvKS9uMjdC0iwIcE5x4X9ZDKc4mxlT1lwY9kGYG/L440l76IDMW1s
         lSfwL93OgMJu9fLvzpoBSO5vXNZf72CC41djHfFsddRt/F4tC6vIlREMFTy+wqP2PiFh
         ob0u0KdmNSTXJOLJDlKHLwd6NO8/uWruqQnoOWOqjd1v9MS9l/2XHTFyuYNNblzlebqs
         bbTqbkK+BtmDD/m/t/eJgFu0gr2azZbxN19Jl3fX6yP4pRZF4a3JZz4EyrZZlklk4Ifm
         dR2EXCM/UYox9f/oJH9HietISUTgc4jrqcpcwgV+B8g6qLqyMT3qvcs0S0B2pKPrQN9Z
         fXRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXe1Ve4x1vLWZ0OiDMo+ROaghZkpM/k3lAih4OqrUCg+EWnHW7/Y0m4NPD7EsN7gtkZaqw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRjBKJz1rIQ+e5wPDnX/tiwHsuNGYVtgn3aWQ3p/7rerPVAiC9
	uAF1lqZkINQ/KiMHBmPsQbW0HbmzK4MQVNxWLI8mv9Oa+NqMYaXX0LtOk02SvbN5Bn+LPWA9E7a
	jUA==
X-Google-Smtp-Source: AGHT+IF6dJqkFdvJ/t4pUYySPc+qKbEBtTOzjtwAhnrNAl1U2vPupjI6nWiArj29VBbhv0O4Szus9aJ2EzQ=
X-Received: from pjbsb4.prod.google.com ([2002:a17:90b:50c4:b0:2ea:5c73:542c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:540e:b0:2ee:a76a:830
 with SMTP id 98e67ed59e1d1-2f548f1b2bfmr20165708a91.24.1736556029072; Fri, 10
 Jan 2025 16:40:29 -0800 (PST)
Date: Fri, 10 Jan 2025 16:40:27 -0800
In-Reply-To: <d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1735931639.git.ashish.kalra@amd.com> <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com> <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
 <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com> <ee9d2956-fa55-4c83-b17d-055df7e1150c@amd.com>
 <d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com>
Message-ID: <Z4G9--FpoeOlbEDz@google.com>
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, michael.roth@amd.com, dionnaglaze@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 10, 2025, Ashish Kalra wrote:
> It looks like i have hit a serious blocker issue with this approach of moving
> SEV/SNP initialization to KVM module load time. 
> 
> While testing with kvm_amd and PSP driver built-in, it looks like kvm_amd
> driver is being loaded/initialized before PSP driver is loaded, and that
> causes sev_platform_init() call from sev_hardware_setup(kvm_amd) to fail:
> 
> [   10.717898] kvm_amd: TSC scaling supported
> [   10.722470] kvm_amd: Nested Virtualization enabled
> [   10.727816] kvm_amd: Nested Paging enabled
> [   10.732388] kvm_amd: LBR virtualization supported
> [   10.737639] kvm_amd: SEV enabled (ASIDs 100 - 509)
> [   10.742985] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
> [   10.748333] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
> [   10.753768] PSP driver not init                        <<<---- sev_platform_init() returns failure as PSP driver is still not initialized
> [   10.757563] kvm_amd: Virtual VMLOAD VMSAVE supported
> [   10.763124] kvm_amd: Virtual GIF supported
> ...
> ...
> [   12.514857] ccp 0000:23:00.1: enabling device (0000 -> 0002)
> [   12.521691] ccp 0000:23:00.1: no command queues available
> [   12.527991] ccp 0000:23:00.1: sev enabled
> [   12.532592] ccp 0000:23:00.1: psp enabled
> [   12.537382] ccp 0000:a2:00.1: enabling device (0000 -> 0002)
> [   12.544389] ccp 0000:a2:00.1: no command queues available
> [   12.550627] ccp 0000:a2:00.1: psp enabled
> 
> depmod -> modules.builtin show kernel/arch/x86/kvm/kvm_amd.ko higher on the list and before kernel/drivers/crypto/ccp/ccp.ko
> 
> modules.builtin: 
> kernel/arch/x86/kvm/kvm.ko
> kernel/arch/x86/kvm/kvm-amd.ko
> ...
> ...
> kernel/drivers/crypto/ccp/ccp.ko
> 
> I believe that the modules which are compiled first get called first and it
> looks like that the only way to change the order for builtin modules is by
> changing which makefiles get compiled first ?
> 
> Is there a way to change the load order of built-in modules and/or change
> dependency of built-in modules ?

The least awful option I know of would be to have the PSP use a higher priority
initcall type so that it runs before the standard initcalls.  When compiled as
a module, all initcall types are #defined to module_init.

E.g. this should work, /cross fingers

diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 7eb3e4668286..02c49fbf6198 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -295,5 +295,6 @@ static void __exit sp_mod_exit(void)
 #endif
 }
 
-module_init(sp_mod_init);
+/* The PSP needs to be initialized before dependent modules, e.g. before KVM. */
+subsys_initcall(sp_mod_init);
 module_exit(sp_mod_exit);

