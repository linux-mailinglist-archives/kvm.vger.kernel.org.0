Return-Path: <kvm+bounces-52281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 501BDB03A4B
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9365A189C256
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 09:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C4923C518;
	Mon, 14 Jul 2025 09:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DLbN8lqG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D8B239E63;
	Mon, 14 Jul 2025 09:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752483977; cv=none; b=JNRrIxmewrUaDKXyzcZvoxdCeZcYqpT4HEr+3KT7YvyEV/KWSLZes1ZBf08PfEv2YTswL0e5FSS5Ij4CXUyamTQ7FsVplKyFer5AhnY8nMtUJJfH9Zq1NzeL5Il3SuGKg1six0RAZb6Y7+I2LtkwslmyaRAOsx3VoDuI8UWH+ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752483977; c=relaxed/simple;
	bh=tacLCJKYV6AZKl8YlsOm4XJaz/JnZL8Pv6pfbEUHiek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZE/8pUpsunyn94X99nNjAaNMSewHWGPqwFKbmjCfumVm29Qp1L+6x1s4H/3WfB7jyG9qJZlvK2lWUaNmN2SAqOqRNVvQh+vFhpio8SColyV5AyEDN+X29UV6zGqAhwwNJJ+bY9cyxKU5O5Gt0rK252sq6gJsFeMpeVvP+dZefdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DLbN8lqG; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752483976; x=1784019976;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tacLCJKYV6AZKl8YlsOm4XJaz/JnZL8Pv6pfbEUHiek=;
  b=DLbN8lqGjXQvGBUjJzOneYyv7Kcdv/+o6rfN5RCRnzm6O/obi5VlJpsV
   altBC49afOX+byWNr/5o4YVvd5ONmD7WBtFwuEtpUZI1ooQmvrAFfGd7r
   zPfK9XQko9Y51t+oGICbcSejq+o3trl7hTZAmNpjnYD1n6lgTZgJq27wU
   dGaIUL9JBftCfm34UfWbLYa817j+Uuq2KOirKRE2CeLshMES01GWvDjhu
   nL+3RlWvHZOAEvA/T7Sr0AZWWKXKhZR3ZMtWa3cJkUmSxlw+/C2B9HkGi
   8AatRmCzfVFzZJA/65Mrh1S8vBzEDQuIoQv72kXUC01EGS2V5pSKyCeGK
   A==;
X-CSE-ConnectionGUID: l5r9ApESRtK0M3LZBJkEVA==
X-CSE-MsgGUID: lD3Fi+8sTYagY/laZj8Mqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="80106686"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="80106686"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 02:06:15 -0700
X-CSE-ConnectionGUID: DZT8l6T6QBy3cBt2d6bBaQ==
X-CSE-MsgGUID: ZFv+VlLrT/qEi1cKo1jzaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="180572095"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.34]) ([10.124.240.34])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 02:06:10 -0700
Message-ID: <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com>
Date: Mon, 14 Jul 2025 17:06:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Jianxiong Gao <jxgao@google.com>, Nikolay Borisov <nik.borisov@suse.com>,
 Sean Christopherson <seanjc@google.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dionna Glaze <dionnaglaze@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 jgross@suse.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>, pbonzini@redhat.com,
 Peter Gonda <pgonda@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
References: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 7/10/2025 12:54 AM, Jianxiong Gao wrote:
> I tested this patch on top of commit 8e690b817e38, however we are
> still experiencing the same failure.
>
I didn't reproduce the issue with QEMU.
After some comparison on how QEMU building the ACPI tables for HPET and TPM,

- For HPET, the HPET range is added as Operation Region:
     aml_append(dev,
         aml_operation_region("HPTM", AML_SYSTEM_MEMORY, aml_int(HPET_BASE),
                              HPET_LEN));

- For TPM, the range is added as 32-Bit Fixed Memory Range:
     if (TPM_IS_TIS_ISA(tpm_find())) {
         aml_append(crs, aml_memory32_fixed(TPM_TIS_ADDR_BASE,
                    TPM_TIS_ADDR_SIZE, AML_READ_WRITE));
     }

So, in KVM, the code patch of TPM is different from the trace for HPET in the
patch https://lore.kernel.org/kvm/20250201005048.657470-3-seanjc@google.com/,
HPET will trigger the code path acpi_os_map_iomem(), but TPM doesn't.

I tried to hack the code to map the region to WB first in tpm_tis driver to
trigger the error.
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 9aa230a63616..62d303f88041 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -232,6 +232,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info)
         if (phy == NULL)
                 return -ENOMEM;

+       ioremap_cache(tpm_info->res.start, resource_size(&tpm_info->res));
         phy->iobase = devm_ioremap_resource(dev, &tpm_info->res);
         if (IS_ERR(phy->iobase))
                 return PTR_ERR(phy->iobase);
Then I got the same error
[ 4.606075] ioremap error for 0xfed40000-0xfed45000, requested 0x2, got 0x0
[ 4.607728] tpm_tis MSFT0101:00: probe with driver tpm_tis failed with error -12

And with Sean's patch set, the issue can be resolved.

I guess google's VMM has built different ACPI table for TPM.
But according to my experiment, the issue should be able to be fixed by this
patch set, though I am not sure whether it will be the final solution or not.

