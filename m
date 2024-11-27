Return-Path: <kvm+bounces-32566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E4C9DA986
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 15:01:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6695B21C50
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 14:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD5B1FCFE5;
	Wed, 27 Nov 2024 14:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zEyvsi9o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F231FBE84
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 14:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732716056; cv=none; b=EXQUThEQ7C3WGjGENzyB/fgd2ANeyyochk/84nJdYRVLtawNZUPNusoQ7D22bIcyhvNn2qE5ss76PSL44zcMc5czo3McrvwjL1UT0B9XOnMUgmi1HxikhbITHfUORuI52wTBqtRND1Io5svgCD9mI9TACPSHx1igaCD1DJwN0VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732716056; c=relaxed/simple;
	bh=W1DxBS8fDYv3TRxGQaecFUft0N2XtDvc2T/7HVuJ2y0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=McSegAx1zjAieq6KIgjhxQL17uMZg00YvVz8TGuAH1kV5IF4K9o1hNiDwzyogOcnO0q0vGtuCzJdgDVLMR4xP9NRNAKKggr7RvnTAkK6hVi7Q1fUN3inN5TsTop94wBqcuV7c4PpT7+JOSGI93/URa7hTMnYtdWUQ6SxTwuSV3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zEyvsi9o; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea2bf5b5fbso6462020a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 06:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732716054; x=1733320854; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EdwWS10u7VCBrGSuDVmxmJIAY/501oDBhCB/j2Uherc=;
        b=zEyvsi9oxc1WkLQF3ylJM7iMhdnLKRmx1eIs9LYCH5cm6VFS4MAJYghSX4+ayLqQgX
         F97xH2Cp2qfV9vNOVVG++SNj/CShrYHnINJeeJ4rhXAjHCBDJnrj/9NQQcu5YIigXGcW
         MTobQMEVT+ZgXPEv50pr05kfuVadLjDVcbFK4Ib7Vb1eTW8NMjpx16xd9j02tZ3/TXdu
         Q2bYbrn0+oxQGfciUlui+vnrqw/F9HPaeMJvP7wcM7AuQbmAx5nPhCAAYO017jtAspGb
         +Foq4EApTQ1NPoXx5XARYTC1YAWNIQMcROuKbLXYpEGoHyqc/glarh82UdJ70k6zzpOw
         PdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732716054; x=1733320854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EdwWS10u7VCBrGSuDVmxmJIAY/501oDBhCB/j2Uherc=;
        b=ZD4q/00YuZW7WXMEGg9+LYqQbk17aP9bwfoU/2igFbM70TlrOa58V2v0sCD0eA/b8Z
         OJ2MWi+OdEVS98DlbUNFpiMPrTwDKM7pFacfUM+41mq3Pl5oFaAogES+xAGq6lAwOAhg
         0VPTWldsr+apHE39nQo3qlW68QjarFEn8hxYNT+jEfQQ26XCDQEIzx4K+wwICZSHXbY9
         gnl2I4dBvPpfiZW46c+tJ+A33RNqMA6kKZjNyzIiHDVtaY9vC14il0YFCbr+ezUmfwmG
         Fn18Il4fZAMef5A0AEADD8K4VwN+LnyA/jFVJAbYFbXrQrESYTIkf6nxKtmPfYaiwdUc
         v+wQ==
X-Forwarded-Encrypted: i=1; AJvYcCUutzCjr9+CVTxxuQu60l/jeylQbGQTefKouKEj0GTjN4W5rucOoXjFOS1qNiXvf+bELZw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxtDPXoZxzeo3AbJTtdjur9sI+/ISILLc7yd4naheAOVzJ7+5Q
	G/zjeG6VacVPkG0B5gmAEO2eaiT/EIv30eku8dvvAKIEyzNlrJK2nbGWHavg1aS3VWiNw0uhQyb
	6zA==
X-Google-Smtp-Source: AGHT+IEceWTnc4XBuGV61B8FQtJMJ4GYGuGv/V6MFcmhcEEziILmmaudgMsDr7JH5R7liBwxVt0pxc+caLk=
X-Received: from pjbph7.prod.google.com ([2002:a17:90b:3bc7:b0:2c7:b802:270a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2245:b0:2ea:61de:3900
 with SMTP id 98e67ed59e1d1-2ee097e3427mr3408431a91.32.1732716054604; Wed, 27
 Nov 2024 06:00:54 -0800 (PST)
Date: Wed, 27 Nov 2024 06:00:49 -0800
In-Reply-To: <Zz/6NBmZIcRUFvLQ@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-8-adrian.hunter@intel.com> <Zz/6NBmZIcRUFvLQ@intel.com>
Message-ID: <Z0cmEd5ehnYT8uc-@google.com>
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org, yan.y.zhao@intel.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 22, 2024, Chao Gao wrote:
> >+static bool tdparams_tsx_supported(struct kvm_cpuid2 *cpuid)
> >+{
> >+	const struct kvm_cpuid_entry2 *entry;
> >+	u64 mask;
> >+	u32 ebx;
> >+
> >+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x7, 0);
> >+	if (entry)
> >+		ebx = entry->ebx;
> >+	else
> >+		ebx = 0;
> >+
> >+	mask = __feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM);
> >+	return ebx & mask;
> >+}
> >+
> > static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> > 			struct kvm_tdx_init_vm *init_vm)
> > {
> >@@ -1299,6 +1322,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> > 	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
> > 	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
> > 
> >+	to_kvm_tdx(kvm)->tsx_supported = tdparams_tsx_supported(cpuid);
> > 	return 0;
> > }
> > 
> >@@ -2272,6 +2296,11 @@ static int __init __tdx_bringup(void)
> > 			return -EIO;
> > 		}
> > 	}
> >+	tdx_uret_tsx_ctrl_slot = kvm_find_user_return_msr(MSR_IA32_TSX_CTRL);
> >+	if (tdx_uret_tsx_ctrl_slot == -1 && boot_cpu_has(X86_FEATURE_MSR_TSX_CTRL)) {
> >+		pr_err("MSR_IA32_TSX_CTRL isn't included by kvm_find_user_return_msr\n");
> >+		return -EIO;
> >+	}
> > 
> > 	/*
> > 	 * Enabling TDX requires enabling hardware virtualization first,
> >diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> >index 48cf0a1abfcc..815ff6bdbc7e 100644
> >--- a/arch/x86/kvm/vmx/tdx.h
> >+++ b/arch/x86/kvm/vmx/tdx.h
> >@@ -29,6 +29,14 @@ struct kvm_tdx {
> > 	u8 nr_tdcs_pages;
> > 	u8 nr_vcpu_tdcx_pages;
> > 
> >+	/*
> >+	 * Used on each TD-exit, see tdx_user_return_msr_update_cache().
> >+	 * TSX_CTRL value on TD exit
> >+	 * - set 0     if guest TSX enabled
> >+	 * - preserved if guest TSX disabled
> >+	 */
> >+	bool tsx_supported;
> 
> Is it possible to drop this boolean and tdparams_tsx_supported()? I think we
> can use the guest_can_use() framework instead.

Yeah, though that optimized handling will soon come for free[*], and I plan on
landing that sooner than TDX, so don't fret too much over this.

[*] https://lore.kernel.org/all/20240517173926.965351-1-seanjc@google.com

