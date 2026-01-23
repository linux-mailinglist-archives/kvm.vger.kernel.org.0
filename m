Return-Path: <kvm+bounces-68949-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ULQJM1wPc2ntrwAAu9opvQ
	(envelope-from <kvm+bounces-68949-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 07:04:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C8170B77
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 07:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 12E43301B72D
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 06:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94DD39F8A3;
	Fri, 23 Jan 2026 06:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f6Y8fC3z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F1B35DCE9;
	Fri, 23 Jan 2026 06:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769148221; cv=none; b=aOO8344U03BDsr3mgjgjUrebgJ4juX2+NAmp2sWPO5jCjV4UOJ9/gUhqGDiqtJ4nhPhzDNsjKsWfWURrisFIQz43xPleVbW8csjvoriKAW1ifDHNZ13U+7FOz4yNwKbPUkXQtjYQbNDSfMrjF3k/ITV3RsFFJSUF8z58KmLEwDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769148221; c=relaxed/simple;
	bh=Huws0kh82G4zxZfZT98FP53TxBbpAbPUXlVXqbKA4p4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qw9nnhccAw0zC3oFDKRfC2gPaWxheSxL8eqlZVYiN9gZj0oM1y/eISgqA9UWpgMs+82yUKenwHf3LKURfVP0BM8n2vXh1boDQXT8KOKZnFvdcxU5ORaaAwGgI+c3kWKg5CP1e2s0GeiQX+ZIFKoAFjxWkfJjvpGy4jHXkNHwkyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f6Y8fC3z; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769148216; x=1800684216;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Huws0kh82G4zxZfZT98FP53TxBbpAbPUXlVXqbKA4p4=;
  b=f6Y8fC3zU51KqNdihVkPcb2F2MvmmglnOZkZBeFCXcZzGNnEwiA7DAgI
   QOvvC10NxOAN13CU+O2KnD+iHJ1EqIJ4kLAQ/2IYmYRgNRwzy+mXZgsB6
   UWAm5vXOXDdNAAvncY7EsMA2onPSuetlHTfC54VmCpfslWIhFxZCNamY9
   JGCYuDuM850uG+lNYCw/OSGJAJgWPlfDU6O7vAjkvSzyM6iPtBl/WMQGS
   6QFR9+UPC7f1rq3+ev0HRRxIFmaJji2W9vN5zKmgtKY6HIJ1n+UeKzFUz
   Pm6vUKsCPSwopoWi2CdThpBL0J7WHsM2uBGsjJ8nvohK2y5Et93PE2MnA
   w==;
X-CSE-ConnectionGUID: hoKvT+OvT/ux9PPuNC0OlA==
X-CSE-MsgGUID: px7G81S4Q4ionKuoZf2Rtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="69417453"
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="69417453"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 22:03:31 -0800
X-CSE-ConnectionGUID: F4eexOaKSnyJy0t+cH4BXQ==
X-CSE-MsgGUID: mEn6+Vn1RnOMV8gh9MhNrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="211398679"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 22:03:28 -0800
Message-ID: <9acca03d-5ec4-41ba-83b4-3505435b1e1b@intel.com>
Date: Fri, 23 Jan 2026 14:03:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] KVM: x86: Advertise new instruction CPUIDs for Intel
 Diamond Rapids
To: Zhao Liu <zhao1.liu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>
References: <20251120050720.931449-1-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251120050720.931449-1-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-68949-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 46C8170B77
X-Rspamd-Action: no action

On 11/20/2025 1:07 PM, Zhao Liu wrote:
> Hi,
> 
> This series advertises new instruction CPUIDs to userspace, which are
> supported by Intel Diamond Rapids platform.
> 
> I've attached the spec link for each (family of) instruction in each
> patch. Since the instructions included in this series don't require
> additional enabling work, pass them through to guests directly.
> 
> This series is based on the master branch at the commit 23cb64fb7625
> ("Merge tag 'soc-fixes-6.18-3' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc").
> 
> Thanks for your review!
> 
> Best Regards,
> Zhao
> ---
> Zhao Liu (4):
>    KVM: x86: Advertise MOVRS CPUID to userspace
>    KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1 to userspace
>    KVM: x86: Advertise AVX10.2 CPUID to userspace
>    KVM: x86: Advertise AVX10_VNNI_INT CPUID to userspace

For the series,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>



