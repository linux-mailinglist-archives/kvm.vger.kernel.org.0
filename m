Return-Path: <kvm+bounces-23940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 673DE94FD9A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 08:08:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F8FC28424B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 06:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FEBE3A8CE;
	Tue, 13 Aug 2024 06:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bWBjp7Ik"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9397339AD5;
	Tue, 13 Aug 2024 06:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723529329; cv=none; b=TjhkKdwz962OV9tQElsZpyr7Hw19v2QpTCrLzwf1+AOLeH2/+4ILVtYDaAwEk7PLZEOQutWeuLISeAqf80T+hZcmcKe58zDFCtl/xFcOleyuxZsGVItQzvkOClBfjCVzkWw648OnN9HjtvhEuh7W+rA40PKlU1aWQ7cOeM5jTnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723529329; c=relaxed/simple;
	bh=PBXgINSxGxuENHEwEGC0ORhcosok2VFhg+2AmCUMhWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m8hWYRyUEdpgX8XH34sJdo1NAdRcn9ShHUbQo7hDBdhHk1pG38UTXGZzPNT89z+JST8vqRT7nhTy513IME6vNWQNT6iorN07gqRyKotVSgE6FQxwk+7XHNPWTkXEWBzREn08v/07u1u7s9zRdbmQRlS2epOFlHwcGk4aq7gXJA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bWBjp7Ik; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723529328; x=1755065328;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PBXgINSxGxuENHEwEGC0ORhcosok2VFhg+2AmCUMhWE=;
  b=bWBjp7IkpPcQJR+Bti7xKhteD6zKLbsbJzd43mmd1JjB+3Y/11OvQJ/a
   PSBTBiaT/ipaXre5vyGZaCwqJYyA+KTUjMA7E1yiZ+NeCZqvgYR4OZM5s
   Dl44gQuC0j03xUyqaiumE9d9sF9WG2X7Ep5QgMA+3olt0BNGxGXdd/Jr3
   7tFMPnNkZKSeelGksO61Z6fYgEMa5tct7Z0yL9ZEEzdoHDRdTb0r4Lzm6
   iGQi/VuKeGvrIEGinPrhzAj7OuZ91nClWiyjzVBrY9d2HcB0pmbhqfNTE
   jVlaY/Qu2PmLdVjWDsZE2SEWVrKbgyi6+stjvOLpmVqF/jq2WWCpoU9BG
   g==;
X-CSE-ConnectionGUID: VcjpaD09SiCERCn/uehLKg==
X-CSE-MsgGUID: plIoITe6Sv+yhpIKofd26w==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="21231890"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="21231890"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 23:08:47 -0700
X-CSE-ConnectionGUID: p3xyYkBGQ5Oe2RlZfMGQHw==
X-CSE-MsgGUID: HpIN/skQSPa1V8QhSYXT/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="96094135"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 23:08:44 -0700
Message-ID: <45cecaa1-d118-4465-98ae-8f63eb166c84@linux.intel.com>
Date: Tue, 13 Aug 2024 14:08:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/25] KVM: TDX: Add TDX "architectural" error codes
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Yuan Yao <yuan.yao@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-4-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240812224820.34826-4-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 8/13/2024 6:47 AM, Rick Edgecombe wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Add error codes for the TDX SEAMCALLs both for TDX VMM side for TDH
> SEAMCALL and TDX guest side for TDG.VP.VMCALL.  KVM issues the TDX
> SEAMCALLs and checks its error code.  KVM handles hypercall from the TDX
> guest and may return an error.  So error code for the TDX guest is also
> needed.
>
> TDX SEAMCALL uses bits 31:0 to return more information, so these error
> codes will only exactly match RAX[63:32].  Error codes for TDG.VP.VMCALL is
> defined by TDX Guest-Host-Communication interface spec.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> v19:
> - Drop TDX_EPT_WALK_FAILED, TDX_EPT_ENTRY_NOT_FREE
> - Rename TDG_VP_VMCALL_ => TDVMCALL_ to match the existing code
> - Move TDVMCALL error codes to shared/tdx.h
> - Added TDX_OPERAND_ID_TDR
> - Fix bisectability issues in headers (Kai)
> ---
>   arch/x86/include/asm/shared/tdx.h |  6 ++++++
>   arch/x86/kvm/vmx/tdx.h            |  1 +
>   arch/x86/kvm/vmx/tdx_errno.h      | 36 +++++++++++++++++++++++++++++++
>   3 files changed, 43 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
>
> diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
> index fdfd41511b02..6ebbf8ee80b3 100644
> --- a/arch/x86/include/asm/shared/tdx.h
> +++ b/arch/x86/include/asm/shared/tdx.h
> @@ -28,6 +28,12 @@
>   
>   #define TDVMCALL_STATUS_RETRY		1
>   
> +/*
> + * TDG.VP.VMCALL Status Codes (returned in R10)
> + */
> +#define TDVMCALL_SUCCESS		0x0000000000000000ULL
> +#define TDVMCALL_INVALID_OPERAND	0x8000000000000000ULL
> +
TDX guest code has already defined/uses "TDVMCALL_STATUS_RETRY", which 
is one
of the TDG.VP.VMCALL Status Codes.

IMHO, the style of the macros should be unified.
How about using TDVMALL_STATUS_* for TDG.VP.VMCALL Status Codes?

+/*
+ * TDG.VP.VMCALL Status Codes (returned in R10)
+ */
+#define TDVMCALL_STATUS_SUCCESS 0x0000000000000000ULL
-#define TDVMCALL_STATUS_RETRY                  1
+#define TDVMCALL_STATUS_RETRY 0x0000000000000001ULL
+#define TDVMCALL_STATUS_INVALID_OPERAND 0x8000000000000000ULL

[...]

