Return-Path: <kvm+bounces-65888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31AA1CB99B8
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 19:57:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2893307F8C6
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 18:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52AC230B508;
	Fri, 12 Dec 2025 18:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WEsrs0hF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0071F309EEC
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 18:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765565815; cv=none; b=WLiPt7f4Bc+vbER+fV/PcZiC6c0BbB5Ybj7YdIjM9fOPep+BZ6a5xMRKQMOsT93EzurqE/lD5hO+5VT7Bq6+bduSESckJ+/L7ek5zm5sl1CnqzUeBvpOmOKDBaWtZIxWdUoCv7WdaoNqbzUtxX/hXX2dGYK2hs+8c2xuUwxnsPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765565815; c=relaxed/simple;
	bh=xYXxNc2AV3h7rbgZpayWXOomVpFD7awP3QlK1Lm5d0M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gqOK9LSPpHbNEsul41au56AsnZWsdH32IlmqFJNQB315gf9WdGE0fBpPkM8MQF0tA7/pjhIJipiy0BLjMeKHPpqwdMZ07IKkul4tZ6Q/Qv0xhufU5Xg4oNBEjWB44LS61gz9C3FPRbFoTXmroIlW9PKqqTfTdjKRs+ctz+TzkLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WEsrs0hF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34abd303b4aso2818434a91.1
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 10:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765565813; x=1766170613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mFwoukDCJ0i1Yt2vaHXPrXSJCcZgdjE7zAPQ1w0zwTo=;
        b=WEsrs0hFAItGEZ+O6KLL+so9cvt0+9rhmfZ67ElnUnIZ3W8gqwYECT3HsXkrS6KSXV
         qvIGOeLcz6fFGBPciIZQmQ7/YkMHz9PJhZir1GYkV+N4lu1E1Jd6kZgiii/NxdFM2U3h
         IHzrIPVMu7nkyv6Z9BnzD5mXKM92qKGvWA8OZw/tLkm5etF+ptRyAaY73ay+uhFKHxO+
         QlnlBKXs9nBKaNW29TdEWeycnGFimsiduiHAH2KCeS1C5dTTgsZ0tR31DJwgE7F8NHPo
         gW+oKNWhSPnVP414hUAgks9v8quPJdXvr7IcTE0V6aZ0OA1oWTjh682vGOwCtEYUbF08
         OhQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765565813; x=1766170613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mFwoukDCJ0i1Yt2vaHXPrXSJCcZgdjE7zAPQ1w0zwTo=;
        b=rFvu0BbHjULgJjwNBGDbDfGHdvybtFvxCWxLkrryjNdhDxZ4AZ3YWh2bp4Po0/Tgnr
         BBZ1LrD8AOBp2dB/+jjlXMIF3oPK/sgZi8+eAwDPTWVo4DxuTh2kk5SH3lO3qJBBhLX8
         c9fmY44PAMn55un4LjWszjedhM32Zk9X3sgDq4bFuJxtTmJlFyZ7ZuJ+T67I9dsfRc1f
         oZ6m0dcaY8U/DLAa6wMKkLJi5QkW7cmYiyo48ESQO9wdswtKFb/5M2Jhv3I7dwM1OQki
         MAcE/63WRXRDMSijgHhy7RuDZmnFp6/iA4LUOp11lnOzWxynsAXrf76Al64VexM6nnxh
         q/BA==
X-Forwarded-Encrypted: i=1; AJvYcCWmhjvoT3WMHYbrWEszk508N7P2ZDow7LzqFTIxWKsurWc8DIiSxo/UvSOoClBozn7+ehM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMiqljojiWz8c9NMEFlBZP91QdFmO9TA1qxoqd/q44VB+/ahZy
	bhaibbtUjWtxGZ64OPSqYUHffQuDO7H5Tw2EKtlta+xlJ6BZULRfQjoCSufshY3YvEFvrVGgcNv
	fZzoswg==
X-Google-Smtp-Source: AGHT+IFAEi7fFkbRvgT/6RcbxzALSy/ReWD7zmWx1G02iRXYNeE26LiRDzb2r0XLIAu6l30uM6JLKfwuS3g=
X-Received: from pjbcl17.prod.google.com ([2002:a17:90a:f691:b0:33b:5907:81cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5288:b0:343:5f43:933e
 with SMTP id 98e67ed59e1d1-34abd78fcaemr2987040a91.19.1765565813345; Fri, 12
 Dec 2025 10:56:53 -0800 (PST)
Date: Fri, 12 Dec 2025 10:56:51 -0800
In-Reply-To: <aTfKeNMIiF8NCRlO@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com> <20251206011054.494190-4-seanjc@google.com>
 <aTfKeNMIiF8NCRlO@intel.com>
Message-ID: <aTxlc4u5VfW8sE-2@google.com>
Subject: Re: [PATCH v2 3/7] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during subsys init
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 09, 2025, Chao Gao wrote:
> On Fri, Dec 05, 2025 at 05:10:50PM -0800, Sean Christopherson wrote:
> > static int __init __tdx_bringup(void)
> > {
> > 	const struct tdx_sys_info_td_conf *td_conf;
> >@@ -3417,34 +3362,18 @@ static int __init __tdx_bringup(void)
> > 		}
> > 	}
> > 
> >-	/*
> >-	 * Enabling TDX requires enabling hardware virtualization first,
> >-	 * as making SEAMCALLs requires CPU being in post-VMXON state.
> >-	 */
> >-	r = kvm_enable_virtualization();
> >-	if (r)
> >-		return r;
> >-
> >-	cpus_read_lock();
> >-	r = __do_tdx_bringup();
> >-	cpus_read_unlock();
> >-
> >-	if (r)
> >-		goto tdx_bringup_err;
> >-
> >-	r = -EINVAL;
> > 	/* Get TDX global information for later use */
> > 	tdx_sysinfo = tdx_get_sysinfo();
> >-	if (WARN_ON_ONCE(!tdx_sysinfo))
> >-		goto get_sysinfo_err;
> >+	if (!tdx_sysinfo)
> >+		return -EINVAL;
> 
> ...
> 
> >-	/*
> >-	 * Ideally KVM should probe whether TDX module has been loaded
> >-	 * first and then try to bring it up.  But TDX needs to use SEAMCALL
> >-	 * to probe whether the module is loaded (there is no CPUID or MSR
> >-	 * for that), and making SEAMCALL requires enabling virtualization
> >-	 * first, just like the rest steps of bringing up TDX module.
> >-	 *
> >-	 * So, for simplicity do everything in __tdx_bringup(); the first
> >-	 * SEAMCALL will return -ENODEV when the module is not loaded.  The
> >-	 * only complication is having to make sure that initialization
> >-	 * SEAMCALLs don't return TDX_SEAMCALL_VMFAILINVALID in other
> >-	 * cases.
> >-	 */
> > 	r = __tdx_bringup();
> >-	if (r) {
> >-		/*
> >-		 * Disable TDX only but don't fail to load module if the TDX
> >-		 * module could not be loaded.  No need to print message saying
> >-		 * "module is not loaded" because it was printed when the first
> >-		 * SEAMCALL failed.  Don't bother unwinding the S-EPT hooks or
> >-		 * vm_size, as kvm_x86_ops have already been finalized (and are
> >-		 * intentionally not exported).  The S-EPT code is unreachable,
> >-		 * and allocating a few more bytes per VM in a should-be-rare
> >-		 * failure scenario is a non-issue.
> >-		 */
> >-		if (r == -ENODEV)
> >-			goto success_disable_tdx;
> 
> Previously, loading kvm-intel.ko (with tdx=1) would succeed even if there was
> no TDX module loaded by BIOS. IIUC, the behavior changes here; the lack of TDX
> module becomes fatal and kvm-intel.ko loading would fail.
> 
> Is this intentional?

Nope, definitely not intentional.  I think this as fixup?

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d0161dc3d184..4e0372f12e6d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3365,7 +3365,7 @@ static int __init __tdx_bringup(void)
        /* Get TDX global information for later use */
        tdx_sysinfo = tdx_get_sysinfo();
        if (!tdx_sysinfo)
-               return -EINVAL;
+               return -ENODEV;
 
        /* Check TDX module and KVM capabilities */
        if (!tdx_get_supported_attrs(&tdx_sysinfo->td_conf) ||
@@ -3470,8 +3470,20 @@ int __init tdx_bringup(void)
        }
 
        r = __tdx_bringup();
-       if (r)
-               enable_tdx = 0;
+       if (r) {
+               /*
+                * Disable TDX only but don't fail to load module if the TDX
+                * module could not be loaded.  No need to print message saying
+                * "module is not loaded" because it was printed when the first
+                * SEAMCALL failed.  Don't bother unwinding the S-EPT hooks or
+                * vm_size, as kvm_x86_ops have already been finalized (and are
+                * intentionally not exported).  The S-EPT code is unreachable,
+                * and allocating a few more bytes per VM in a should-be-rare
+                * failure scenario is a non-issue.
+                */
+               if (r == -ENODEV)
+                       goto success_disable_tdx;
+       }
 
        return r;

