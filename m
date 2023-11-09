Return-Path: <kvm+bounces-1309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D19D07E651C
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 09:21:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E2F11C20818
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040401095A;
	Thu,  9 Nov 2023 08:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="s3Ig6YtH"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AF9107B4;
	Thu,  9 Nov 2023 08:21:32 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 731971FFD;
	Thu,  9 Nov 2023 00:21:31 -0800 (PST)
Received: from [192.168.2.39] (77-166-152-30.fixed.kpn.net [77.166.152.30])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1532B20B74C0;
	Thu,  9 Nov 2023 00:21:26 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1532B20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1699518090;
	bh=536QhSnmvjUjksMTxK3AqvYT0q2acvm2TvmKO/JNg/I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s3Ig6YtH2xeo+PTvKPvXKtQtZ2RQaBN+nhHcTkkMBEF08uYQNcijM+O1oP8zwvlKx
	 +7rZ0GMkVO3jxS9g5x+tgVFu6wkSLrcxyjBUAYQbUYWoLDxxncUfqjGrnDLVMwx2Cd
	 4w8XcMlnjAp5L2kkRGbMJY5FZre9PlTj3fcMPI7c=
Message-ID: <02faa42b-7b10-40b4-8442-5f95a2934f5f@linux.microsoft.com>
Date: Thu, 9 Nov 2023 09:21:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 15/23] KVM: nVMX: Add support for the secondary VM exit
 controls
Content-Language: en-US
To: Xin Li <xin3.li@intel.com>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net,
 kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 vkuznets@redhat.com, peterz@infradead.org, ravi.v.shankar@intel.com
References: <20231108183003.5981-1-xin3.li@intel.com>
 <20231108183003.5981-16-xin3.li@intel.com>
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <20231108183003.5981-16-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/11/2023 19:29, Xin Li wrote:
> Enable the secondary VM exit controls to prepare for nested FRED.
> 
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>  Documentation/virt/kvm/x86/nested-vmx.rst |  1 +
>  arch/x86/include/asm/hyperv-tlfs.h        |  1 +
>  arch/x86/kvm/vmx/capabilities.h           |  1 +
>  arch/x86/kvm/vmx/hyperv.c                 | 18 +++++++++++++++++-
>  arch/x86/kvm/vmx/nested.c                 | 18 +++++++++++++++++-
>  arch/x86/kvm/vmx/vmcs12.c                 |  1 +
>  arch/x86/kvm/vmx/vmcs12.h                 |  2 ++
>  arch/x86/kvm/x86.h                        |  2 +-
>  8 files changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/nested-vmx.rst b/Documentation/virt/kvm/x86/nested-vmx.rst
> index ac2095d41f02..e64ef231f310 100644
> --- a/Documentation/virt/kvm/x86/nested-vmx.rst
> +++ b/Documentation/virt/kvm/x86/nested-vmx.rst
> @@ -217,6 +217,7 @@ struct shadow_vmcs is ever changed.
>  		u16 host_fs_selector;
>  		u16 host_gs_selector;
>  		u16 host_tr_selector;
> +		u64 secondary_vm_exit_controls;
>  	};
>  
>  
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index 2ff26f53cd62..299554708e37 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -616,6 +616,7 @@ struct hv_enlightened_vmcs {
>  	u64 host_ssp;
>  	u64 host_ia32_int_ssp_table_addr;
>  	u64 padding64_6;
> +	u64 secondary_vm_exit_controls;
>  } __packed;
> >  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE			0

Hi Xin Li,

The comment at the top of hyperv-tlfs.h says:
"This file contains definitions from Hyper-V Hypervisor Top-Level Functional Specification (TLFS)"

These struct definitions are shared with the hypervisor, so you can't just add fields to it.
Same comment for patch 16.

Would FRED work in nested virtualization if the L0 hypervisor does not support it (or doesn't know
about it)?

Thanks,
Jeremi

