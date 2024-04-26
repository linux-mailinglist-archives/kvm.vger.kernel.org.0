Return-Path: <kvm+bounces-16065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D17258B3D9C
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 018961C21A4E
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA8A15CD59;
	Fri, 26 Apr 2024 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BkbMv1vE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293FA1DA58
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714151272; cv=none; b=sg78p2UranHlyCyElIFRJVKhi3ekWUeFlHtN0r6FIRz2lWQsrgToEzLGReUcp6XzzRb547+QpwKHboC9XCJqZkDjhrbMhHVGezYufmPGWxiESaLMUncKo6sEATrhrDE8B4FvEW1ZF7HqJd+68nUXkIea6GR+oLlcmb2yGMmdt2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714151272; c=relaxed/simple;
	bh=v0cjrOdojoDruGFwvT7gLve4U0ajKztNrbaWcRyDn4U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lvA9TUEjNrkobnIu9bNDYAL9qceMkAkhKJhQjLv4dr+0EaGebT14yvR64VlMyCb7Vh1CXRnk9cB13NbWUXQ66viHhTyhVwGQDKdX7HHQ+C2lGkV22Jpsclv7WB0zo9ronzLxUJsSQCW3XnsXo2wiA9NL+OBRtAYFPMRkchmnDhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BkbMv1vE; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so3838166276.3
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 10:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714151269; x=1714756069; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SlGnJ6wh5ohNMtHhgNVTVsDp8M3FkTj0mvOIqLIk45U=;
        b=BkbMv1vErgzGZ+LZASgo7d16nBJCHelznFI4QebV6hPhMtR0uUkFEEqIy1ElyA0Jt2
         qdmmOAYfX/dqgg5o6Kl3gD1p4HlhzeTo4cx4FYmQKpOLDf4YJ5qWp/9827bkX367H7iL
         O+tBcGEQymgye1c7dxc7lsnmhTL/YPgfNy6xhv9ChAHwS8acFSgkiXfq0hn0MPdBZ9mp
         ofnTSIooaWXd943iP4b+iz7BKVnRXK1jCo5C7AOri0DS45lw9iBbjB9t0RnJIvUrm31j
         Cawu3tBjaZCMVCR70kYXqkGxtgvPhJk+wijiGL7gfZAw+VJeGON7V/BRRnk2EbxU6uUJ
         dlOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714151269; x=1714756069;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SlGnJ6wh5ohNMtHhgNVTVsDp8M3FkTj0mvOIqLIk45U=;
        b=OSoOafO2wKRhqObX9M8D2Iq/vRs8+kxIEfk/+wU7aqP4ohNMOnfRMG7l02ye8Yu5xG
         MXVbcsFUqC4xZnvi1wcK9Icy+j/x9Fnz4x5bJOaZCXnKsIkNVSOlY25aaKZVX9u5bfld
         6BiegEjRqwPVHXtk4YIjxpXr/QmRyw9AeXTzlZsGFgD6ibxl1+CNqIwhodupcyo20fSA
         l2lr6sfiia/kAM8KbAyxRYMNCquSaI4w318DbVhiqI86Cog16e0QKeoPBvevWrBB/LeD
         K9dqw4a/uNr8CG/CL5qvYfTVR8HQY2+F12PLbX6EjfCutpgm6FM/Gn0HYXwgq/6/V5Tb
         BtSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcKFE0ri/LnKaSrGMXy4M9jzsLzb2wgSIdVSbKZpnTSrzEiBg80bm7tkdevHpJdN8pBJJIOF7AShUFWP/h8qnto/H/
X-Gm-Message-State: AOJu0Yy/H9y8KWvChc+HX3fprbLv2/mKsl9rfrGBaRTCAfkCj/0E6mPZ
	6z7uTyGWRfCmYPaltdiJaEVSH71IwlY/dAIw2uYsjQAIYojS45gb7p+apqwdtZ4iMjfRVM3lcHC
	0Kg==
X-Google-Smtp-Source: AGHT+IHFWbdJsO5bamVtR2FN4Y9IErPitiM2PCYxxNNZI+02lYYOMjfIdKgH5zwPCEDGgTBK6EB0bayQM9Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1028:b0:de5:3003:4b64 with SMTP id
 x8-20020a056902102800b00de530034b64mr306689ybt.1.1714151269111; Fri, 26 Apr
 2024 10:07:49 -0700 (PDT)
Date: Fri, 26 Apr 2024 10:07:47 -0700
In-Reply-To: <ZitmpS0lt+wVjRwl@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425233951.3344485-1-seanjc@google.com> <20240425233951.3344485-4-seanjc@google.com>
 <ZitmpS0lt+wVjRwl@chao-email>
Message-ID: <ZivfY8F_MF1U6QS0@google.com>
Subject: Re: [PATCH 3/4] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 26, 2024, Chao Gao wrote:
> >+static int hardware_enable_all(void)
> >+{
> >+	int r;
> >+
> >+	guard(mutex)(&kvm_lock);
> >+
> >+	if (kvm_usage_count++)
> >+		return 0;
> >+
> >+	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
> >+			      kvm_online_cpu, kvm_offline_cpu);
> 
> A subtle change is: cpuhp_setup_state() calls kvm_online_cpu() serially
> on all CPUs. Previously, hardware enabling is done with on_each_cpu().

Ooh, I hadn't considered that side effect.

> I assume performance isn't a concern here. Right?

Hmm, performance isn't critical, but I wouldn't be at all surprised if it's
noticeable and problematic for large systems.  Assuming we do end up going this
route, maybe we can "solve" this by documenting KVM's behavior, e.g. so that if
userspace cares about the latency of VM creation, it can that fudge around the
potential latency problem by creating a dummy VM.  Hrm, that's pretty gross though.

Oh!  Hah!  What if we add a module param to let userspace force virtualization to
be enabled when KVM is loaded?  And then kvm_enable_virtualization() doesn't even
need to be exported/public, because KVM can simply require enable_virt_at_load
(or whatever is a good name) to be %true in order to enable TDX.

I don't think there's any real danger for abuse, e.g. *unprivileged* userspace
can effectively do this already by creating a dummy VM.

Am I missing something?  This seems too easy.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7579bda0e310..1bfbb612a98f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -96,6 +96,9 @@ unsigned int halt_poll_ns_shrink;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 
+static bool enable_virt_at_load;
+module_param(enable_virt_at_load, uint, 0444);
+
 /*
  * Ordering of locks:
  *
@@ -6377,6 +6380,12 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 
        kvm_gmem_init(module);
 
+       if (enable_virt_at_load) {
+               r = kvm_enable_virtualization();
+               if (r)
+                       goto err_virt;
+       }
+
        /*
         * Registration _must_ be the very last thing done, as this exposes
         * /dev/kvm to userspace, i.e. all infrastructure must be setup!
@@ -6390,6 +6399,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
        return 0;
 
 err_register:
+       kvm_disable_virtualization();
+err_virt:
        kvm_vfio_ops_exit();
 err_vfio:
        kvm_async_pf_deinit();
@@ -6415,6 +6426,11 @@ void kvm_exit(void)
         */
        misc_deregister(&kvm_dev);
 
+       if (enable_virt_at_load) {
+               kvm_disable_virtualization();
+               BUG_ON(kvm_usage_count);
+       }
+
        debugfs_remove_recursive(kvm_debugfs_dir);
        for_each_possible_cpu(cpu)
                free_cpumask_var(per_cpu(cpu_kick_mask, cpu));

> >+	if (r)
> >+		return r;
> 
> decrease kvm_usage_count on error?

/facepalm, yes.

