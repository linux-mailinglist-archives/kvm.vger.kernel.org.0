Return-Path: <kvm+bounces-59177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0B48BAE097
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EDAE172B06
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA09238C03;
	Tue, 30 Sep 2025 16:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NtFZGqjP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F10CA4E
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759249744; cv=none; b=paxXzWN/slytHjVut+QbJ6nud2EJKDXtnnE17pLbENABCFVjF72HcyRdHxbhU0PrXeQlO0NMfGdmt0BX9Y31ZNmLXcpMMLi9EFD5xtyQ9yZon4gNcjTRuLFeZAqK1LpYQZeBE+D7TE/P0U0ZTxtcRL1uHgX5TgpUXpPA+BRN8mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759249744; c=relaxed/simple;
	bh=jvs1HpDbHuLHsXwdNWN5OQ0EARN3lWmBRfQzMHZ4nD8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J7+TRplsdm+qw2/QSuUEv+wrRjpJIGGwAqt7vdFD3M6URGGnrCTJMcrR9UjBYwOiLjXEApQ17iY52JnPypEMxy970lBDnGirikw2P0rt66TyQ6f8Hq/P4zSCI2IHbrLNeCWlMopxomqVLNZL8LefUrRR9twszH9MGNZQuZSabUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NtFZGqjP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee4998c50so5452665a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759249742; x=1759854542; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IvqulNZyHw3NH8THJ4dZILvp5eZnrhz0uuimme275IM=;
        b=NtFZGqjP9/oDU/iJQb1suyJeAJSQGyRMiGsMfGsjox+lP8W+OY6lE/C7GfRLxTN3y1
         LUGXtwqtupEgvrUTGJx8WXY7m5ZsZhSZ9tVMMlTs6G92E8AAbhjdMWt26Q3SA30YJQLf
         cx+V+/tGScN5UQaskeFLaagz5KkWFhlYrlJaffFP+gqMgYY6GorU3MyehYzHsgGMDPov
         epPDUJmqKKD7+Hc43KGZ/hmQa9YsukYXZwlGI6zzs4uul8jRIz3dJO0Lilk7WYD/6ivD
         q/NSx5aA2cGwCPj7E8h4/9UQ+vQ3stMa+E4wBCAM1Rspp3EmaGbGZzFWzNHcvjFIxrIW
         I66g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759249742; x=1759854542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IvqulNZyHw3NH8THJ4dZILvp5eZnrhz0uuimme275IM=;
        b=YWOJV8fyENbJFAhAZ9Xf0NKG4Xdbj0lJsUILaerZguN9K8/+UA0XxhtPLVEW7ANSNd
         gSU3exy++rsF/aqH2ZTUoneYmvDCoFlayxLtkNg6iTjJGHi46V+O8DnQ7gYFS/qqXsD4
         sK9IJbCvzCdYd4x/4hKJo/tymE7INA0CNoiWWWKWGFaGn1KOF/u2HNl8UQJLh6aRkSCW
         EpmcoF70QTUc5JHcBf+MDqRhy2K7z5AjrNMWjLpFdVfOcQEHeaCpVN45khdrVuuYo3+y
         bdVo7/WEOUdSy0FMkA6zPgKMaQyqx0x6kROfnr5E6yANznS9L2LMMGTIE95523v+m55X
         lg/g==
X-Forwarded-Encrypted: i=1; AJvYcCU/sXDW0p2HV202KRyRaGVeMlkFXunUMaVGJTg4xiGeqH/JbukUKW0HCFUBR2cIP7Exnmc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwctXuQtDNg/nW+zHKVDGeI7UYT/TPvNasX7OHItb7dQVIL63fD
	hmN9hHHGjkZhrId/PbTRgGWqRbWFCYcGOP9LsSmt8kxVl/68nE1JT4LHSIYf9EERG+EjcltgDyI
	gh6rMOA==
X-Google-Smtp-Source: AGHT+IHzjBQ0AdCcBjAnrdTTq/5Smhx7Q7IlZ3njiQ56g/bLqUrOXudSTMTSnkrzIbu2QJ5VRD4RdJoqhv8=
X-Received: from pjbnu4.prod.google.com ([2002:a17:90b:1b04:b0:32e:ca6a:7ca9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d91:b0:32b:9bec:158f
 with SMTP id 98e67ed59e1d1-339a6f5b668mr72251a91.29.1759249742526; Tue, 30
 Sep 2025 09:29:02 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:29:00 -0700
In-Reply-To: <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919214259.1584273-1-seanjc@google.com> <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
 <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com>
Message-ID: <aNwFTLM3yt6AGAzd@google.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 30, 2025, Yan Zhao wrote:
> On Tue, Sep 30, 2025 at 08:22:41PM +0800, Yan Zhao wrote:
> > On Fri, Sep 19, 2025 at 02:42:59PM -0700, Sean Christopherson wrote:
> > > Rename kvm_user_return_msr_update_cache() to __kvm_set_user_return_msr()
> > > and use the helper kvm_set_user_return_msr() to make it obvious that the
> > > double-underscores version is doing a subset of the work of the "full"
> > > setter.
> > > 
> > > While the function does indeed update a cache, the nomenclature becomes
> > > slightly misleading when adding a getter[1], as the current value isn't
> > > _just_ the cached value, it's also the value that's currently loaded in
> > > hardware.
> > Nit:
> > 
> > For TDX, "it's also the value that's currently loaded in hardware" is not true.
> since tdx module invokes wrmsr()s before each exit to VMM, while KVM only
> invokes __kvm_set_user_return_msr() in tdx_vcpu_put().

No?  kvm_user_return_msr_update_cache() is passed the value that's currently
loaded in hardware, by way of the TDX-Module zeroing some MSRs on TD-Exit.

Ah, I suspect you're calling out that the cache can be stale.  Maybe this?

  While the function does indeed update a cache, the nomenclature becomes
  slightly misleading when adding a getter[1], as the current value isn't
  _just_ the cached value, it's also the value that's currently loaded in
  hardware (ignoring that the cache holds stale data until the vCPU is put,
  i.e. until KVM prepares to switch back to the host).

Actually, that's a bug waiting to happen when the getter comes along.  Rather
than document the potential pitfall, what about adding a prep patch to mimize
the window?  Then _this_ patch shouldn't need the caveat about the cache being
stale.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ff41d3d00380..326fa81cb35f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -789,6 +789,14 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
                vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
 
        vt->guest_state_loaded = true;
+
+       /*
+        * Several of KVM's user-return MSRs are clobbered by the TDX-Module if
+        * VP.ENTER succeeds, i.e. on TD-Exit.  Mark those MSRs as needing an
+        * update to synchronize the "current" value in KVM's cache with the
+        * value in hardware (loaded by the TDX-Module).
+        */
+       to_tdx(vcpu)->need_user_return_msr_update = true;
 }
 
 struct tdx_uret_msr {
@@ -816,7 +824,6 @@ static void tdx_user_return_msr_update_cache(void)
 static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
 {
        struct vcpu_vt *vt = to_vt(vcpu);
-       struct vcpu_tdx *tdx = to_tdx(vcpu);
 
        if (!vt->guest_state_loaded)
                return;
@@ -824,11 +831,6 @@ static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
        ++vcpu->stat.host_state_reload;
        wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
 
-       if (tdx->guest_entered) {
-               tdx_user_return_msr_update_cache();
-               tdx->guest_entered = false;
-       }
-
        vt->guest_state_loaded = false;
 }
 
@@ -1067,7 +1069,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
                update_debugctlmsr(vcpu->arch.host_debugctl);
 
        tdx_load_host_xsave_state(vcpu);
-       tdx->guest_entered = true;
+
+       if (tdx->need_user_return_msr_update) {
+               tdx_user_return_msr_update_cache();
+               tdx->need_user_return_msr_update = false;
+       }
 
        vcpu->arch.regs_avail &= TDX_REGS_AVAIL_SET;
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ca39a9391db1..fcac1627f71f 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -67,7 +67,7 @@ struct vcpu_tdx {
        u64 vp_enter_ret;
 
        enum vcpu_tdx_state state;
-       bool guest_entered;
+       bool need_user_return_msr_update;
 
        u64 map_gpa_next;
        u64 map_gpa_end;


