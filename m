Return-Path: <kvm+bounces-33189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD7949E6458
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 03:42:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EFB8284A4C
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 02:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9938017BEA2;
	Fri,  6 Dec 2024 02:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IJ7v0dzQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8AF16132F
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 02:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733452944; cv=none; b=QanLtQhUlFKVE9t6MkvB+SYO5zFztuwmNHTcjmcG9JxvGRY2drun32yB02BIiwPLUsjf7D6eS81mjFwLm8j4AaKdyPzbuEboF/UFwRyJVdo9Dr7c2329yIrLa7XK9oLfRYsU3ek3PCyWbimP8UByXqM5n2PqT1YC32ODgUZ0NrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733452944; c=relaxed/simple;
	bh=BPAbfXQQYNvBKr+0fe03hKAUFPt0n+OzNTK11uRxPac=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=EZV7qYXKYomIezxvFCdZf9xZWXAxY3+TCAgGvFb60GdXDE5SR6DA20aht+FYn/YvPmXibRhv1enCqwmGN4EHLfNh7gLYAatf6K39CirPCS7dBU6rqNvjyn3WGaFeSlTunH4a28OLEYqFrBtAc0sG2OKRh4bWpqG1hGujekGif0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IJ7v0dzQ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733452942; x=1764988942;
  h=message-id:date:mime-version:to:cc:from:subject:
   content-transfer-encoding;
  bh=BPAbfXQQYNvBKr+0fe03hKAUFPt0n+OzNTK11uRxPac=;
  b=IJ7v0dzQHB5VEKjrvDS2nibyPG51G80awcBFo4FF+HfTlWfliAkdO7rn
   nHVUbM4ezUwqtXiiWB8Kv+SskRkMGYbbSFrEWDYa8NTKCoWKzotUodmCW
   RTHwVI+lsfUvopiAXc3rj5viHthy+yF1IZZz0rH/bhKUdXK4wPWsfn/CD
   Xo+TTn3Gq7NONXoM1qV0gYbpA8AX5VhQuLIp85RUZXPLs7F0PQPr0k0M9
   NfaZYuXo7INlcB7jgW4UbxH8DuHvlQvl5E+cekZU8lkIvetJc5Pz+v1it
   3NONcpw67N0ZXPKvQctb545Kz23tRLtcCmXON0FlF9tb4fizcTmUjYEgJ
   A==;
X-CSE-ConnectionGUID: VW9Fk7jMTkiAANolt/hakw==
X-CSE-MsgGUID: cbbjOYSORoGiUm1LRP4uEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="36630572"
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="36630572"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 18:42:22 -0800
X-CSE-ConnectionGUID: sEnyYx90RsOGSQcQ3/QttA==
X-CSE-MsgGUID: KAie4NgqS9ObFneeGnR/sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="99347225"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 18:42:18 -0800
Message-ID: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
Date: Fri, 6 Dec 2024 10:42:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, "Huang, Kai" <kai.huang@intel.com>,
 Tony Lindgren <tony.lindgren@linux.intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>, QEMU <qemu-devel@nongnu.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
Subject: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1 CPUID
 Bits
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

This is a proposal for a potential future TDX Module feature to assist 
QEMU/KVM in configuring CPUID leafs for TD guests. It is only in the 
idea stage and not currently being implemented. We are looking for 
comments on the suitability for QEMU/KVM.

# Background

To correctly virtualize CPUID for TD, the VMM needs to understand the 
behavior of CPUID configuration for each CPUID bit, including whether 
the bit can be configured by the VMM and what the allowed value is.

There is an interface to query the CPUID bit information after the TD 
has been configured. However, this interface does not work before the TD 
is configured. The TDX module, along with its release, provides a 
separate JSON format file, cpuid_virtualization.json, for CPUID 
virtualization information. This file can be used by the VMM even before 
the TD is configured. The TDX module also provides an interface to query 
some limited CPUID information, including:

  - The configurability of a subset of CPUIDs via global metadata 
CPUID_CONFIG_VALUES.

  - The 'fixed0' and 'fixed1' bits of ATTRIBUTES and XFAM via global 
metadata. The VMM can infer the 'configurable' bits related to 
ATTRIBUTES/XFAM indirectly (the bits that are neither 'fixed0' nor 
'fixed1' are 'configurable').

For the remaining CPUID bits not covered by the above two categories, no 
TDX module query interface exists.

# Problem

While the VMM can use the JSON format CPUID information and may embed or 
translate that information into the code, it may face several challenges:

  - The JSON file varies with each TDX module release, which can 
complicate the VMM code. Additionally, depending on its own needs, the 
VMM may require more information than what is provided in the JSON file.

  - The JSON format cannot be easily parsed with low-level programming 
languages like C, which is typically used to write VMMs.

There was objection from KVM community for parsing the JSON and requests 
for a more friendly interface to query CPUID information for each 
specific TDX module.[0][1]

# Analysis

There are many virtualization types defined for single bit or bitfields 
in JSON file, e.g., 12 types in TDX 1.5.06:

   - fixed
   - configured
   - configured & native
   - XFAM & native
   - XFAM & configured & native
   - attributes & native
   - attributes & configured & native
   - CPUID_enabled & native
   - attributes & CPUID_enabled & native
   - attributes & CPUID_enabled & configured & native
   - calculated
   - special

And more types are getting added as TDX evolves.

Though so many types defined, for a single bit, it can only be one of three:
   - fixed0
   - fixed1
   - configurable

For example:
1. For type "configured & native", the bit is “fixed0” bit if the native 
value is 0, and the “configurable” bit if native value is 1.

2. For type "XFAM & native",
    a) the CPUID is “fixed0” if the corresponding XFAM bit is reported 
in XFAM_FIXED0, or the native value is 0;

    b) the CPUID bit is ‘fixed1’ if the corresponding XFAM bit is set in 
XFAM_FIXED1;

    c) otherwise, the CPUID is ‘configurable’ (indirectly by TD_PRRAMS.XFAM)

# Proposal

Current TDX module provides interface to report the “configurable” bits 
via global metadata CPUID_CONFIG_VALUES directly or via global metadata 
ATTRIBUTES/XFAM_fixed0/1 indirectly. But it lacks the interface to 
report the “fixed0” and “fixed1” bits generally (it only reports the 
fixed bits for ATTRIBUTES and XFAM).

We propose to add two new global metadata fields, CPUID_FIXED0_BITS and 
CPUID_FIXED1_BITS, for “fixed0” and “fixed1” bits information respectively.

The encoding of the two fields uses the same format as TDCS field 
CPUID_VALUES:

   Field code is composed as follows:
     - Bits 31:17  Reserved, must be 0
     - Bit  16     Leaf number bit 31
     - Bits 15:9   Leaf number bit 6:0
     - Bit 8       Sub-leaf not applicable flag
     - Bits 7:1    Sub-leaf number bits 6:0
     - Bit 0       Element index within field

   The same for returned result:
     - Element 0[31:0]:   EAX
     - Element 0[63:32]:  EBX
     - Element 1[31:0]:   ECX
     - Element 1[63:32]:  EDX

For CPUID_FIXED0_BITS, any bit in E[A,B,C,D]X is 0, means the bit is fixed0.
For CPUID_FIXED1_BITS, any bit in E[A,B,C,D]X is 1, means the bit is fixed1.

# Interaction with TDX_FEATURES0.VE_REDUCTION

TDX introduces a new feature VE_REDUCTION[2]. From the perspective of 
host VMM, VE_REDUCTION turns several CPUID bits from fixed1 to 
configurable, e.g., MTRR, MCA, MCE, etc. However, from the perspective 
of TD guest, it’s an opt-in feature. The actual value seen by TD guest 
depends on multiple factors: 1). If TD guest enables REDUCE_VE in 
TDCS.TD_CTLS, 2) TDCS.FEATURE_PARAVIRT_CTRL, 3) CPUID value configured 
by host VMM via TD_PARAMS.CPUID_CONFIG[]. (Please refer to latest TDX 
1.5 spec for more details.)

Since host VMM has no idea on the setting of 1) and 2) when creating the 
TD. We make the design to treat them as configurable bits and the global 
metadata interface doesn’t report them as fixed1 bits for simplicity.

Host VMM must be aware itself that the value of these VE_REDUCTION 
related CPUID bits might not be what it configures. The actual value 
seen by TD guest also depends on the guest enabling and configuration of 
VE_REDUCTION.

# POC

We did a POC in QEMU to verify the fixed0/1 data by such an interface is 
enough for userspace to validate and generate a supported vcpu model for 
TD guest.[3]

It retrieves the “fixed” type in JSON file and hardcodes them into two 
arrays, tdx_fixed0_bits and tdx_fixed1_bits. Note, it doesn’t handle the 
other types than “fixed” because 1) just a few of them falls into fixed0 
or fixed1 and 2) turning them into fixed0 or fixed0 needs to check 
various condition which complicates the POC. And in the POC it uses 
value 1 in tdx_fixed0_bits for fixed0 bits, while the proposed metadata 
interface uses value 0 to indicate fixed0 bits.

With the hardcoded information, VMM can validate the TD configuration 
requested from user early by checking whether a feature requested from 
users is allowed to be enabled and is allowed to be disabled.

When TDX module provides fixed0 and fixed1 via global metadata, QEMU can 
change to requested them from KVM to replace the hardcoded one.

[0] https://lore.kernel.org/all/ZhVdh4afvTPq5ssx@google.com/
[1] https://lore.kernel.org/all/ZhVsHVqaff7AKagu@google.com/
[2] https://cdrdv2.intel.com/v1/dl/getContent/733575
[3] 
https://lore.kernel.org/qemu-devel/20241105062408.3533704-49-xiaoyao.li@intel.com/ 






