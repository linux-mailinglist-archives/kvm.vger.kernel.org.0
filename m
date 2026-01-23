Return-Path: <kvm+bounces-68948-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBCEHCMPc2ntrwAAu9opvQ
	(envelope-from <kvm+bounces-68948-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 07:03:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C278670B42
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 07:03:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 989C33010D9F
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 06:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56FC39F31B;
	Fri, 23 Jan 2026 06:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZTPEoQfJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D551E38F220;
	Fri, 23 Jan 2026 06:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769148179; cv=none; b=Xd8SeaIhOASzt0aWNcizehrVvGUulI8iZeEBpDtP3JlCyfuxKI4DjKFm+JAxwv9sfttTQTOzIVuoJ78mp+RE2yRbCWukueq9fGDVK6rzYAd/X1+QgRZMUBQyLNKtZyUIfGvpalb1TDzO9EUGTcgxUxmbx8carV4hSvvYprpTn0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769148179; c=relaxed/simple;
	bh=w5QxVYjLpIz8ZxUQ65k5wpaYI4icRM4cGhjOapYy8Z0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=giZz/x7yhkKpbRWmCcp0uR1CCPqKUCRioN9WqKEAkb2Mfyy0EoDY855sRe08mp/vZjIzTphhJzNM+r3K5yCm2ScwoZ1CuOcoxxr+WDPeWhbJVEGAE1u9YqJ34qC9h65ztBfYkBzD5qyHeLY+o/l1+dX7yL22A77h0jEWq0RHIWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZTPEoQfJ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769148175; x=1800684175;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=w5QxVYjLpIz8ZxUQ65k5wpaYI4icRM4cGhjOapYy8Z0=;
  b=ZTPEoQfJtE0orbEcIAkgM8pf8YzcN5YdKFbWoVYTUDKIUoiKcfeZx6Hd
   fb0t+3UROa6oFEnQlGbORT0NgAaVqkhscU97vvTz3Z2quC9egrLPVz7Lh
   g1giNoBLD2Xv/2Q2cAeO1MXAEs6gxZsVl4p2IKorilrdyvFXoNPhBzxJ1
   9Ghw9r6ye2MrlZ0qrhWgDv8oSlWIwALMaJJv2Hos+U+hL8qBs5m3j0rEx
   belowqfcQvCqTmj0zNuW7js8+h440kgP391coAWr/ve2Jiup/sYnNXxwd
   0gqpOEd3yrSEH5Dl0vQvfkKTmH1BD0m8vTdrKh6q/8qTtxChwxlgwEzIS
   A==;
X-CSE-ConnectionGUID: k3lz4uVYSKuP/2DPJoq20A==
X-CSE-MsgGUID: kF4t4UUpTKCSQ8/vRAmp3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="69417417"
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="69417417"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 22:02:50 -0800
X-CSE-ConnectionGUID: f/khXmrmScWfxE2vMTZf/g==
X-CSE-MsgGUID: yLN9rmbjQ/muHeqDGzWHjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="211398318"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 22:02:46 -0800
Message-ID: <cf20fff4-931a-4a07-83c1-a33de13fa230@intel.com>
Date: Fri, 23 Jan 2026 14:02:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1 to
 userspace
To: Zhao Liu <zhao1.liu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>, Xudong Hao <xudong.hao@intel.com>
References: <20251120050720.931449-1-zhao1.liu@intel.com>
 <20251120050720.931449-3-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251120050720.931449-3-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-68948-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C278670B42
X-Rspamd-Action: no action

On 11/20/2025 1:07 PM, Zhao Liu wrote:
> In addition to the new features, CPUID 0x1E.0x1.EAX[bits 0-3] are
> mirrored positions of existing AMX feature bits distributed across the
> 0x7 leaves. To avoid duplicate feature names, name these mirror bits
> with a *_MIRROR suffix, and define them in reverse_cpuid.h as KVM-only
> features as well.

It looks that KVM can emulate the mirroring CPUIDs regardless of whether 
hardware supports subleaf 1. However, given such emulation provides no 
real benefit but complicates KVM implementation, this patch looks good 
to me.

