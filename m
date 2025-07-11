Return-Path: <kvm+bounces-52170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE017B01EEB
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:20:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB9A51895719
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 14:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7192B2E542E;
	Fri, 11 Jul 2025 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2R8BiM9p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C1C2E499A
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 14:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752243590; cv=none; b=H2kVM/FnvA57kOmYD4gkoiYdWIYzt5zB4W9thqnmxMs6XaNyi9je4bB8omrxzC0HxeSANlrbaJIn61/EWHEa77vLeq4zJECbF1sVj9xAZbemxjmaS+0TZTyHU+6FH+Meh352YeYGY+qsFl1taZe+vkU7JRqJO7GHuvC9A5X5vnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752243590; c=relaxed/simple;
	bh=Gn7a5w/0Au53NNrRVej3raiUtTjDyzPJLsxEFx+PCMk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AB58I2TRnBIJFq+4nwoW/FuhEY+BJWF6sUCMCFoyLBXhnoF55IDne2R+xD1z88SApxWinB+4FR/zu1d4ynFLus7qvWAPTmmmLmW19McRUz8d/NhSg22TfgYnmrn4sfjL4m5fOR97+Xi/DfunGAohFR+bsn0nMtfSL04B7lzT1XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2R8BiM9p; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31315427249so2078571a91.1
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752243588; x=1752848388; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BRImBF+DBE/XYRjk2dpLS5XtGJtnSfrVjhMTQWyVukM=;
        b=2R8BiM9p89/BvGs1d7z/hBsSqMcCKGAzalDigSjC5zLPkCJHY4XbE5UgWdlwaQqcei
         4cfEvFSzQ+AveJXJujsehsrVwRMMHCe/0dD9edABlCs7rOrb/eYu9ZzOWFt6lAWNcNJm
         44k4WkD8N9ZAb2NWBvDYJ1RSaUrDKY9lwjeplfSZRHkZ0tbpcDoO5TkjzDPfZwpSLWca
         mVweSGGs57JJ/XPQbZiYehWwIH8f9pt4Rk1C8MDP7xpAiAQ+nmFmenkvmT1MevntBHTO
         lY56hxSla/P8Ja+4FixxccCJdxbNJlyoX8l/cGuoeydXg4cSP5X2+HdAhfOfhXb77MTf
         efDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752243588; x=1752848388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BRImBF+DBE/XYRjk2dpLS5XtGJtnSfrVjhMTQWyVukM=;
        b=Y8uhjxBouJC+rUzT7+Y5pTwJ/5uqCdpTIv+93GThdnnNJT2pwQ0QqQ4UMF46FeVUGO
         aYm8hosx64zMpBE0gS+tzpgUc0JgTSqSey7jPCL0j7sp6KjDloPAnKJXnJQ/DqeAiwnZ
         Mz8Ci8+xsheNJsdAXsRtrBzUwU3xwYIGPfumadQWFYcZAjv6DXH+IOYGJSESrQ8rGh2w
         sDzBNWcTm5K6kwP07qMI8KKyZRM5lFUAQs+obb7oJ2YdAgbD1gvvbNUwp+6pdsqnWTzt
         lM9PSlnxDQ3lCxvbWcN2xrula8NHUmnBi3Pvy/8s/kDnRnKMywZyde1i8PGtH7xCuwzU
         vJZw==
X-Forwarded-Encrypted: i=1; AJvYcCUmDHtH29oYZaBZ1A9XCpRjuWtVfBnkVDB2l/VwcJ/ILm1mr0Zvoy8rMj/5QJrXMOP+RQw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmEHNIiWiF8HDpWGk0Nu+9Y0K56SYV2dZynNzc+ILPf9wYaUyb
	PyNw6q3iPp9wdlOXBGgBMQFx4UWb3FU3TBdwYoNeRCtB3dVnrJ2SHCb1PfqT4jP1Z6QQI1lBN6y
	RHqEi5g==
X-Google-Smtp-Source: AGHT+IFaR7BkydINBuhJvnqOtM3yiToiLejuuj/NfBatwfubOVGHHXabQfeMgnEvMOggVSzb6SkwtyZJ/dY=
X-Received: from pjbsd3.prod.google.com ([2002:a17:90b:5143:b0:313:245:8921])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2787:b0:311:d258:3473
 with SMTP id 98e67ed59e1d1-31c50d7b47cmr3414900a91.13.1752243588546; Fri, 11
 Jul 2025 07:19:48 -0700 (PDT)
Date: Fri, 11 Jul 2025 07:19:47 -0700
In-Reply-To: <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com> <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
 <aHEMBuVieGioMVaT@google.com> <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
Message-ID: <aHEdg0jQp7xkOJp5@google.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, tony.lindgren@linux.intel.com, 
	binbin.wu@linux.intel.com, isaku.yamahata@intel.com, 
	linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 11, 2025, Xiaoyao Li wrote:
> On 7/11/2025 9:05 PM, Sean Christopherson wrote:
> > On Fri, Jul 11, 2025, Xiaoyao Li wrote:
> > > On 6/26/2025 11:58 PM, Sean Christopherson wrote:
> > > > On Wed, Jun 25, 2025, Sean Christopherson wrote:
> > > > > On Wed, 11 Jun 2025 12:51:57 +0300, Adrian Hunter wrote:
> > > > > > Changes in V4:
> > > > > > 
> > > > > > 	Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
> > > > > > 	Use KVM_BUG_ON() instead of WARN_ON().
> > > > > > 	Correct kvm_trylock_all_vcpus() return value.
> > > > > > 
> > > > > > Changes in V3:
> > > > > > 	Refer:
> > > > > >               https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
> > > > > > 
> > > > > > [...]
> > > > > 
> > > > > Applied to kvm-x86 vmx, thanks!
> > > > > 
> > > > > [1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
> > > > >         https://github.com/kvm-x86/linux/commit/111a7311a016
> > > > 
> > > > Fixed up to address a docs goof[*], new hash:
> > > > 
> > > >         https://github.com/kvm-x86/linux/commit/e4775f57ad51
> > > > 
> > > > [*] https://lore.kernel.org/all/20250626171004.7a1a024b@canb.auug.org.au
> > > 
> > > Hi Sean,
> > > 
> > > I think it's targeted for v6.17, right?
> > > 
> > > If so, do we need the enumeration for the new TDX ioctl? Yes, the userspace
> > > could always try and ignore the failure. But since the ship has not sailed,
> > > I would like to report it and hear your opinion.
> > 
> > Bugger, you're right.  It's sitting at the top of 'kvm-x86 vmx', so it should be
> > easy enough to tack on a capability.
> > 
> > This?
> 
> I'm wondering if we need a TDX centralized enumeration interface, e.g., new
> field in struct kvm_tdx_capabilities. I believe there will be more and more
> TDX new features, and assigning each a KVM_CAP seems wasteful.

Oh, yeah, that's a much better idea.  In addition to not polluting KVM_CAP, 

LOL, and we certainly have the capacity in the structure:

	__u64 reserved[250];

Sans documentation, something like so?

--
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 13da87c05098..70ffe6e8d216 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -963,6 +963,8 @@ struct kvm_tdx_cmd {
        __u64 hw_error;
 };
 
+#define KVM_TDX_CAP_TERMINATE_VM       _BITULL(0)
+
 struct kvm_tdx_capabilities {
        __u64 supported_attrs;
        __u64 supported_xfam;
@@ -972,7 +974,9 @@ struct kvm_tdx_capabilities {
        __u64 kernel_tdvmcallinfo_1_r12;
        __u64 user_tdvmcallinfo_1_r12;
 
-       __u64 reserved[250];
+       __u64 supported_caps;
+
+       __u64 reserved[249];
 
        /* Configurable CPUID bits for userspace */
        struct kvm_cpuid2 cpuid;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f4d4fd5cc6e8..783b1046f6c1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -189,6 +189,8 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
        if (!caps->supported_xfam)
                return -EIO;
 
+       caps->supported_caps = KVM_TDX_CAP_TERMINATE_VM;
+
        caps->cpuid.nent = td_conf->num_cpuid_config;
 
        caps->user_tdvmcallinfo_1_r11 =
--


Aha!  And if we squeeze in a patch for 6.16. to zero out the reserved array, we
can even avoid adding a capability to enumerate the TDX capability functionality.

--
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f4d4fd5cc6e8..9c2997665762 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -181,6 +181,8 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
 {
        int i;
 
+       memset(caps->reserved, 0, sizeof(caps->reserved));
+
        caps->supported_attrs = tdx_get_supported_attrs(td_conf);
        if (!caps->supported_attrs)
                return -EIO;
--

