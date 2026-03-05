Return-Path: <kvm+bounces-72875-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CLv9Bye8qWlzDgEAu9opvQ
	(envelope-from <kvm+bounces-72875-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:23:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A192161E8
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D68D330811A0
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8E753E7160;
	Thu,  5 Mar 2026 17:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WgSst99w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151623E51C2
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730825; cv=none; b=Z0b4+sqNukBqoj1pwF9dO2tnU02Br9gvuDxM2uAshSr0rCK4j2jcvTZKr/GjbpAfnLZGn23QqJBx0ZUFGr1lbjRyi7mltlkKS+ozF4XCZh6DE2YBLCQ7llyQUOhp70jAWkUIWw9lP9AAMfp4FkyzRZeQ/OsZFZAzci5w1dz8ABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730825; c=relaxed/simple;
	bh=qHC00ISKgrMZfRY6dSld9netJgpoxAtIn0hM+5n3r7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lH9pNJ060fs+rAbyqGOa+cXuanwTVDUvhsla1pZ6NAXi/PMrXxsD5Nggy3r3nRhHXYsE15TY9CRti9L0hVgx/ruK8fPh5vleP6ncv/YB3PfqtbNVX4VHZaWd1D1lOMVG/nuZuYbbQy0Y5vncOsK7om/2gKfzqZHs9rfKRYE5djg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WgSst99w; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3598733bec0so24734716a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730823; x=1773335623; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E2bUC8Oe3NfU9TjoldHhqqoJKW3UcTrvlp0nRfSmBH0=;
        b=WgSst99wO14nPvwYGNzwVu7zFqWbhBYXbeWUh1X0bxuTonM88WDGioqoEDUAxoRsr8
         OHF7UqxvABpSSXCjkbjmo/9agMBHB/VtlE531cP6jYYMWxxYSvqRn2TrndTK8NGWVdM8
         ttrYauQ/XjExxfx1qcb366cvmHBi8r5lfYn94jhjX2JH6Xsy6d0fQFr3bfSLYnI/iIiA
         4ecDP5xtksAZLg///y16BagwYqPhwP2Mh2vuxMiEF/M6cK0NhlXc9goMUHAL3OWnl2gg
         OmFsU3cDq7QLYu8uLbH/a4BZ5GuKCaxhRSyHgwd1/6Tv+F6wYf/bkng19o8WL74fzmTw
         oz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730823; x=1773335623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E2bUC8Oe3NfU9TjoldHhqqoJKW3UcTrvlp0nRfSmBH0=;
        b=Kl41F/IKWn4Rjo86NVh/ahItGtJ6nJg6qfC1GAam0GIQ4RtopE4RHzhv6psE+ESjgU
         vTHZuCMX9qBfVx1xPx3+ZUEYsUiXrSsxb4rCm+nAxhYD3rgllI+IhPNSnPYvbZhtZm4Y
         FcM5jcFp/b9AvdjFN2vP0J+bi6CfbBxbrblQATQKlgTiLvULv7Kuzg33Dtr09cThwxlN
         z61VbaIICfmavpe80jzaPAsqo+4KDOSgWSldZnIBJjNTN8xRTQNrjTd9wGiKIt9Px3Bv
         bqoUNhOrPuBAfWcpYoFqO++GM1k81issoI2EsNAeHpY+LUgagwh1JuvDw2IjI0NODjWu
         sHog==
X-Forwarded-Encrypted: i=1; AJvYcCWACkOb1lTSCpZDGBR6Bgg/o/na+1cBzvBpmyFtkge2vH1sEZDFFx8IzZEDVB6siq+CFfE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2ygvUU/rSi749p2X3RR6eKdiPuS7YtqPYx8YulqK3jPWmkwb7
	itcVX9CVvng6vZUL8SeZrwdcHndmmwOnxlfKLT0bciarTGcDqLXIl9DUm03OtAwFYfnYf0Cc6uT
	OfSSDFQ==
X-Received: from pjbms20.prod.google.com ([2002:a17:90b:2354:b0:359:8d4a:7276])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388d:b0:359:8293:67f2
 with SMTP id 98e67ed59e1d1-359a6a7a05fmr4296177a91.32.1772730823229; Thu, 05
 Mar 2026 09:13:43 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:39 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272960351.1566277.2741684808536756847.b4-ty@google.com>
Subject: Re: [PATCH v3 00/16] KVM: x86/tdx: Have TDX handle VMXON during bringup
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 19A192161E8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72875-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[18];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Fri, 13 Feb 2026 17:26:46 -0800, Sean Christopherson wrote:
> Assuming I didn't break anything between v2 and v3, I think this is ready to
> rip.  Given the scope of the KVM changes, and that they extend outside of x86,
> my preference is to take this through the KVM tree.  But a stable topic branch
> in tip would work too, though I think we'd want it sooner than later so that
> it can be used as a base.
> 
> Chao, I deliberately omitted your Tested-by, as I shuffled things around enough
> while splitting up the main patch that I'm not 100% positive I didn't regress
> anything relative to v2.
> 
> [...]

Applied to kvm-x86 vmxon, with the minor fixups.  I'll make sure not to touch
the hashes at this point, but holler if anyone wants an "official" stable tag.

[01/16] KVM: x86: Move kvm_rebooting to x86
        https://github.com/kvm-x86/linux/commit/4059172b2a78
[02/16] KVM: VMX: Move architectural "vmcs" and "vmcs_hdr" structures to public vmx.h
        https://github.com/kvm-x86/linux/commit/3c75e6a5da3c
[03/16] KVM: x86: Move "kvm_rebooting" to kernel as "virt_rebooting"
        https://github.com/kvm-x86/linux/commit/a1450a8156c6
[04/16] KVM: VMX: Unconditionally allocate root VMCSes during boot CPU bringup
        https://github.com/kvm-x86/linux/commit/405b7c27934e
[05/16] x86/virt: Force-clear X86_FEATURE_VMX if configuring root VMCS fails
        https://github.com/kvm-x86/linux/commit/95e4adb24ff6
[06/16] KVM: VMX: Move core VMXON enablement to kernel
        https://github.com/kvm-x86/linux/commit/920da4f75519
[07/16] KVM: SVM: Move core EFER.SVME enablement to kernel
        https://github.com/kvm-x86/linux/commit/32d76cdfa122
[08/16] KVM: x86: Move bulk of emergency virtualizaton logic to virt subsystem
        https://github.com/kvm-x86/linux/commit/428afac5a8ea
[09/16] x86/virt: Add refcounting of VMX/SVM usage to support multiple in-kernel users
        https://github.com/kvm-x86/linux/commit/8528a7f9c91d
[10/16] x86/virt/tdx: Drop the outdated requirement that TDX be enabled in IRQ context
        https://github.com/kvm-x86/linux/commit/0efe5dc16169
[11/16] KVM: x86/tdx: Do VMXON and TDX-Module initialization during subsys init
        https://github.com/kvm-x86/linux/commit/165e77353831
[12/16] x86/virt/tdx: Tag a pile of functions as __init, and globals as __ro_after_init
        https://github.com/kvm-x86/linux/commit/9900400e20c0
[13/16] x86/virt/tdx: KVM: Consolidate TDX CPU hotplug handling
        https://github.com/kvm-x86/linux/commit/eac90a5ba0aa
[14/16] x86/virt/tdx: Use ida_is_empty() to detect if any TDs may be running
        https://github.com/kvm-x86/linux/commit/afe31de159bf
[15/16] KVM: Bury kvm_{en,dis}able_virtualization() in kvm_main.c once more
        https://github.com/kvm-x86/linux/commit/d30372d0b7e6
[16/16] KVM: TDX: Fold tdx_bringup() into tdx_hardware_setup()
        https://github.com/kvm-x86/linux/commit/f630de1f8d70

--
https://github.com/kvm-x86/linux/tree/next

