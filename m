Return-Path: <kvm+bounces-54817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F2B7B288F3
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 01:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB0B2AE41A7
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 23:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DADF2D375B;
	Fri, 15 Aug 2025 23:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ywScJGLc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C1D264A8E
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 23:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755302157; cv=none; b=TBm6xMXTTt7XWBV1Nn03mFn5kM05y9GE8fHTanFa5kFEk8CxBUz4K25IqEjr5BAQqHti8S7ZL/TfoOfTr5iGg48Zmbh1Qzz7Dr4eI5LYB8dWDt9Y1rFakxVlUM7+1LXTWC42XBnbVGUcOQabTH7uQP0mHDiXerqjkYD9PrQbQV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755302157; c=relaxed/simple;
	bh=zcLAsoX6pDXjnCPfRnsqRsSg+vU0W8rGPEmra6GA6HA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fIFqG6pMuf3bbBt/ehw9B/qh30K1SBX7f/bqgp0R9D9xbyVjd9wuqKLpsn4Yf+3Wev4ms6VmLugJ2+rGajhGG1vMS5offiybyjyHs4XMdSMmnadCYg64ersmq9TH1gWsCbgeyPElPQ4mSbQNIpXhUaY3OYz5lboTKNtas/UMpGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--korakit.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ywScJGLc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--korakit.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24458067fdeso26018105ad.1
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 16:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755302154; x=1755906954; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LNbL7GEH2GESEOq6c0BFv6o6Nfe7tGZQ+zzXfb4mnY0=;
        b=ywScJGLcIEQgXd1/xFLx9Cr1/y4HKsCWVCcenSqRr9AFkWbD1aFyWPg0a1GRQr82iH
         iSMCWxjlak2sHXTdLP53JVXzE7SJOGnZs0OXmqF0nGKKAWXgcvBVd3SYArTu5HowI+13
         HlzLuIVWNWHjcEzEAZzmlJmTwzQxiIgCGt8FrFTReHluFMm1/zVlGqVvyAdzqL7AweAJ
         crhGXsfkxQjin+2wGiPDIhIayDlt7xs1+l30c2TxEXU/CaG1cuanMoHjcOb/XaINu5nq
         mLcvDUUnV2kLi8iM1DcUhWeKX7yGg800IDY4xEbd2wDZNCqL9V5hoLBTeSH285Nci1go
         XJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755302154; x=1755906954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LNbL7GEH2GESEOq6c0BFv6o6Nfe7tGZQ+zzXfb4mnY0=;
        b=Qv1mdrnbsvvmj7UUFzM9DDUx0H15F1ZEo3vBA4qStXtJGSu3IVA5asmrTwxvt1xSJU
         O4Pou3Hwe55YIZNHrWctIQfhUTcR3fL5+aqO2YBiesfAtgRwdRhj7Y1N6SSo1Fw8B/rz
         IDVG/Przj6JtBhpUHvg5Hg99W7fjzl6AtyfjsetrjuYS8aX1eA5E2s+lxnYdlWKO8QgR
         m7k373M+y1AIaZJZ3Vf1Cy29nc1PljVVsTYuXwsjqawzyc1Wq6ONBgF0lHUrd+mb6pFS
         rBN4sf9fMoljUMzPoA+9BcWuheZtFUsL5aY1qcTOdHkEYC26VXvXopUJ1EfpW1EY0lxc
         lObA==
X-Forwarded-Encrypted: i=1; AJvYcCWN5E1hV1h7tZqmzLzWJMNur2ySWrl7InD8zH5OdXZuTJYhQxMV3gjpVwxQuVwVEfGSJVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAWF9mdDKhzHpslhLbCqx/1G078KwgqSGZY4EB9/N0d1PP1aTN
	ws3lJLIa4tVrw07OfOpLII8Z41LAMRwnjDbsX/4zbDb7ERu65JiomE5IihdcNVqOZGZml/jxndj
	t8lBAEDlKiQ==
X-Google-Smtp-Source: AGHT+IG4eKINYgr2XwrFOOgeml2vyTvpIAjHgoplhjb1xbj/jh7rF2cQgxFsDB0rkoUxw+YeQnZopUn5fPG9
X-Received: from pluo13.prod.google.com ([2002:a17:903:4b0d:b0:23f:e63a:dfb])
 (user=korakit job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e80a:b0:234:c549:da0e
 with SMTP id d9443c01a7336-2447905d2d5mr13406915ad.47.1755302153943; Fri, 15
 Aug 2025 16:55:53 -0700 (PDT)
Date: Fri, 15 Aug 2025 23:55:52 +0000
In-Reply-To: <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250815235552.969779-1-korakit@google.com>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
From: Korakit Seemakhupt <korakit@google.com>
To: binbin.wu@linux.intel.com
Cc: bp@alien8.de, dave.hansen@linux.intel.com, dionnaglaze@google.com, 
	hpa@zytor.com, jgross@suse.com, jiewen.yao@intel.com, jxgao@google.com, 
	kirill.shutemov@linux.intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, nik.borisov@suse.com, 
	pbonzini@redhat.com, pgonda@google.com, rick.p.edgecombe@intel.com, 
	seanjc@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, x86@kernel.org, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"

>> On 5/28/2025 11:33 PM, Sean Christopherson wrote:
>>
>> Summary, with the questions at the end.
>>
>> Recent upstream kernels running in GCE SNP/TDX VMs fail to probe the TPM due to
>> the TPM driver's ioremap (with UC) failing because the kernel has already mapped
>> the range using a cachaeable mapping (WB).
>>
>>   ioremap error for 0xfed40000-0xfed45000, requested 0x2, got 0x0
>>   tpm_tis MSFT0101:00: probe with driver tpm_tis failed with error -12
>>
>> The "guilty" commit is 8e690b817e38 ("x86/kvm: Override default caching mode for
>> SEV-SNP and TDX"), which as the subject suggests, forces the kernel's MTRR memtype
>> to WB.  With SNP and TDX, the virtual MTRR state is (a) controlled by the VMM and
>> thus is untrusted, and (b) _should_ be irrelevant because no known hypervisor
>> actually honors the memtypes programmed into the virtual MTRRs.
>>
>> It turns out that the kernel has been relying on the MTRRs to force the TPM TIS
>> region (and potentially other regions) to be UC, so that the kernel ACPI driver's
>> attempts to map of SystemMemory entries as cacheable get forced to UC.  With MTRRs
>> forced WB, x86_acpi_os_ioremap() succeeds in creating a WB mapping, which in turn
>> causes the ioremap infrastructure to reject the TPM driver's UC mapping.
>>
>> IIUC, the TPM entry(s) in the ACPI tables for GCE VMs are derived (built?) from
>> EDK2's TPM ASL.  And (again, IIUC), this code in SecurityPkg/Tcg/Tcg2Acpi/Tpm.asl[1]
>>
>>        //
>>        // Operational region for TPM access
>>        //
>>        OperationRegion (TPMR, SystemMemory, 0xfed40000, 0x5000)
>>
>> generates the problematic SystemMemory entry that triggers the ACPI driver's
>> auto-mapping logic.
>>
>> QEMU-based VMs don't suffer the same fate, as QEMU intentionally[2] doesn't use
>> EDK2's AML for the TPM, and QEMU doesn't define a SystemMemory entry, just a
>> Memory32Fixed entry.
>>
>> Presumably this an EDK2 bug?  If it's not an EDK2 bug, then how is the kernel's
>> ACPI driver supposed to know that some ranges of SystemMemory must be mapped UC?
> 
> On 7/30/2025 3:34 PM, Binbin Wu: Wrote
> 
> According to the ACPI spec 6.6, an operation region of SystemMemory has no
> interface to specify the cacheable attribute.
> 
> One solution could be using MTRRs to communicate the memory attribute of legacy
> PCI hole to the kernel. But during the PUCK meeting last week, Sean mentioned
> that "long-term, firmware should not be using MTRRs to communicate anything to
> the kernel." So this solution is not preferred.
> 
> If not MTRRs, there should be an alternative way to do the job.
> 1. ACPI table
>     According to the ACPI spec, neither operation region nor 32-Bit Fixed Memory
>     Range Descriptor can specify the cacheable attribute.
>     "Address Space Resource Descriptors" could be used to describe a memory range
>     and the they can specify the cacheable attribute via "Type Specific Flags".
>     One of the Address Space Resource Descriptors could be added to the ACPI
>     table as a hint when the kernel do the mapping for operation region.
>     (There is "System Physical Address (SPA) Range Structure", which also can
>     specify the cacheable attribute. But it's should be used for NVDIMMs.)
> 2. EFI memory map descriptor
>     EFI memory descriptor can specify the cacheable attribute. Firmware can add
>     a EFI memory descriptor for the TPM TIS device as a hint when the kernel do
>     the mapping for operation region.
> 
> Operation region of SystemMemory is still needed if a "Control Method" of APCI
> needs to access a field, e.g., the method _STA. Checking another descriptor for
> cacheable attribute, either "Address Space Resource Descriptor" or "EFI memory
> map descriptor" during the ACPI code doing the mapping for operation region
> makes the code complicated.
> 
> Another thing is if long-term firmware should not be using MTRRs to to
> communicate anything to the kernel. It seems it's safer to use ioremap() instead
> of ioremap_cache() for MMIO resource when the kernel do the mapping for the
> operation region access?

Even after changing the ACPI memory resource descriptor from 32-Bit Fixed 
Memory to DWordMemory with caching parameter set to uncached, the ACPI stack still 
tries to ioremap the memory as cachable. 

However, forcing the Operation Region to be PCI_Config instead of SystemMemory 
in the ACPI table seems to allow the vTPM device initilization to succeed as 
it avoids the vTPM region from getting ioremapped by the ACPI stack.

We have also verified that forcing the ACPI stack to use ioremap() instead of 
ioremap_cache() also allows vTPM to initialize properly. The reference change 
I made is below.

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index dae6a73be40e..2771d3f66d0a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1821,7 +1821,7 @@ u64 x86_default_get_root_pointer(void)
 #ifdef CONFIG_XEN_PV
 void __iomem *x86_acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
 {
-       return ioremap_cache(phys, size);
+       return ioremap(phys, size);
 }

