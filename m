Return-Path: <kvm+bounces-6513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B688835C2B
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 08:58:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A00D71C228EF
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 07:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5833420DDF;
	Mon, 22 Jan 2024 07:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jySAO7ow"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC901A71B;
	Mon, 22 Jan 2024 07:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705910270; cv=none; b=JLHP+m0CbQrOhKEdzszDy4VQK2f2M8xDwts5tzGNBIXz0E+LLFziMlcaCPR2LTf6O+I0ac2b38tRSkQ82kX8PKdCOZP6SAmu+Xmv29SNezbz/gNdhuuKfW7Yrz1nACdlXPvfQa7HyrjnuCIHKE/YG01NbKKbLcvNZ8lbTeCxRCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705910270; c=relaxed/simple;
	bh=MjiIoYwlMkNwAn1aR85M7buh7BSddsVlw/PLyOdAGPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o8uJeIXixPFXVEUJYjzXt1bnWgkK2aI+lmoJxFmY7Tm4RCgYa2JyXaEB8qceDhVmRtI65T5B6E8zzQs+9qTuhX1dwahVlI/4q/iOva8UMWajMwcs8pJzZUcLNgFly8xYfwnm84wgD+qGUVegpNCF5FxILmhY3RdP0Rt/BCGUuy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jySAO7ow; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705910268; x=1737446268;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MjiIoYwlMkNwAn1aR85M7buh7BSddsVlw/PLyOdAGPQ=;
  b=jySAO7owxS6ThkjiWt2e1/eya0kvnWWCI6W7nXJavclPSW+8Wbcf7VuJ
   FBQfe0M+VJx0C1xgP+/mvmnwziiVvrZBZNbiaXF4ZU313YmxUje9KJvHB
   poGFWGd1sAEOSuobtymZJEt2pwtsXEu8yfooSnUE1K9mKHCYhAUWBojrI
   sHmZsX9Bqzd8UUGQRjL34mvQnSYr647a6T5iZJEHmH9CwofKTautmYhp2
   B0aVZnyhtAnefC1hMmyM4nH3SQfVf6uQiNThRdb+upyowfIwFlEwETOui
   /kORtKynJdXGuFfIpK502NBaziwF/m1Bd2HVTNN125r9ep0pgPQb9Dupf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="1025353"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="1025353"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2024 23:57:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="1032499195"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="1032499195"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2024 23:57:45 -0800
Message-ID: <090dabe9-408f-4ab2-b1dd-9f73c808de42@linux.intel.com>
Date: Mon, 22 Jan 2024 15:57:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM: x86: LAM support for 6.8
To: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240104193303.3175844-1-seanjc@google.com>
 <20240104193303.3175844-4-seanjc@google.com>
 <CABgObfaBJQTm2stHFCsb8g0BKPsnnMYTvPfrqtc8aBmOcOimLQ@mail.gmail.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <CABgObfaBJQTm2stHFCsb8g0BKPsnnMYTvPfrqtc8aBmOcOimLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 1/8/2024 9:04 PM, Paolo Bonzini wrote:
> On Thu, Jan 4, 2024 at 8:33 PM Sean Christopherson <seanjc@google.com> wrote:
>> LAM virtualization support.  FWIW, I intended to send this in early-ish
>> December as you've asked in the past, but December was basically a lost cause
>> for me in terms of doing upstream work.  :-/
>>
>> The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b2f:
>>
>>    selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:58:25 -0500)
>>
>> are available in the Git repository at:
>>
>>    https://github.com/kvm-x86/linux.git tags/kvm-x86-lam-6.8
>>
>> for you to fetch changes up to 183bdd161c2b773a62f01d1c030f5a3a5b7c33b5:
>>
>>    KVM: x86: Use KVM-governed feature framework to track "LAM enabled" (2023-11-28 17:54:09 -0800)
> Patches are surprisingly small for this. What's the state of tests
> (https://www.spinics.net/lists/kvm/msg313712.html) though?

The patch series is tested by the LAM kselftest cases as well as
a set of test cases[1] in kvm-unit-tests.

[1] 
https://lore.kernel.org/kvm/20230530024356.24870-1-binbin.wu@linux.intel.com/
Will send a new version with minor change to resolve a feedback soon.


>
> Thanks,
>
> Paolo
>
>> ----------------------------------------------------------------
>> KVM x86 support for virtualizing Linear Address Masking (LAM)
>>
>> Add KVM support for Linear Address Masking (LAM).  LAM tweaks the canonicality
>> checks for most virtual address usage in 64-bit mode, such that only the most
>> significant bit of the untranslated address bits must match the polarity of the
>> last translated address bit.  This allows software to use ignored, untranslated
>> address bits for metadata, e.g. to efficiently tag pointers for address
>> sanitization.
>>
>> LAM can be enabled separately for user pointers and supervisor pointers, and
>> for userspace LAM can be select between 48-bit and 57-bit masking
>>
>>   - 48-bit LAM: metadata bits 62:48, i.e. LAM width of 15.
>>   - 57-bit LAM: metadata bits 62:57, i.e. LAM width of 6.
>>
>> For user pointers, LAM enabling utilizes two previously-reserved high bits from
>> CR3 (similar to how PCID_NOFLUSH uses bit 63): LAM_U48 and LAM_U57, bits 62 and
>> 61 respectively.  Note, if LAM_57 is set, LAM_U48 is ignored, i.e.:
>>
>>   - CR3.LAM_U48=0 && CR3.LAM_U57=0 == LAM disabled for user pointers
>>   - CR3.LAM_U48=1 && CR3.LAM_U57=0 == LAM-48 enabled for user pointers
>>   - CR3.LAM_U48=x && CR3.LAM_U57=1 == LAM-57 enabled for user pointers
>>
>> For supervisor pointers, LAM is controlled by a single bit, CR4.LAM_SUP, with
>> the 48-bit versus 57-bit LAM behavior following the current paging mode, i.e.:
>>
>>   - CR4.LAM_SUP=0 && CR4.LA57=x == LAM disabled for supervisor pointers
>>   - CR4.LAM_SUP=1 && CR4.LA57=0 == LAM-48 enabled for supervisor pointers
>>   - CR4.LAM_SUP=1 && CR4.LA57=1 == LAM-57 enabled for supervisor pointers
>>
>> The modified LAM canonicality checks:
>>   - LAM_S48                : [ 1 ][ metadata ][ 1 ]
>>                                63               47
>>   - LAM_U48                : [ 0 ][ metadata ][ 0 ]
>>                                63               47
>>   - LAM_S57                : [ 1 ][ metadata ][ 1 ]
>>                                63               56
>>   - LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>>                                63               56
>>   - LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>>                                63               56..47
>>
>> The bulk of KVM support for LAM is to emulate LAM's modified canonicality
>> checks.  The approach taken by KVM is to "fill" the metadata bits using the
>> highest bit of the translated address, e.g. for LAM-48, bit 47 is sign-extended
>> to bits 62:48.  The most significant bit, 63, is *not* modified, i.e. its value
>> from the raw, untagged virtual address is kept for the canonicality check. This
>> untagging allows
>>
>> Aside from emulating LAM's canonical checks behavior, LAM has the usual KVM
>> touchpoints for selectable features: enumeration (CPUID.7.1:EAX.LAM[bit 26],
>> enabling via CR3 and CR4 bits, etc.
>>
>> ----------------------------------------------------------------
>> Binbin Wu (9):
>>        KVM: x86: Consolidate flags for __linearize()
>>        KVM: x86: Add an emulation flag for implicit system access
>>        KVM: x86: Add X86EMUL_F_INVLPG and pass it in em_invlpg()
>>        KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
>>        KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
>>        KVM: x86: Remove kvm_vcpu_is_illegal_gpa()
>>        KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in emulator
>>        KVM: x86: Untag addresses for LAM emulation where applicable
>>        KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
>>
>> Robert Hoo (3):
>>        KVM: x86: Virtualize LAM for supervisor pointer
>>        KVM: x86: Virtualize LAM for user pointer
>>        KVM: x86: Advertise and enable LAM (user and supervisor)
>>
>>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>>   arch/x86/include/asm/kvm_host.h    |  5 +++-
>>   arch/x86/kvm/cpuid.c               |  2 +-
>>   arch/x86/kvm/cpuid.h               | 13 +++++----
>>   arch/x86/kvm/emulate.c             | 27 ++++++++++---------
>>   arch/x86/kvm/governed_features.h   |  1 +
>>   arch/x86/kvm/kvm_emulate.h         |  9 +++++++
>>   arch/x86/kvm/mmu.h                 |  8 ++++++
>>   arch/x86/kvm/mmu/mmu.c             |  2 +-
>>   arch/x86/kvm/mmu/mmu_internal.h    |  1 +
>>   arch/x86/kvm/mmu/paging_tmpl.h     |  2 +-
>>   arch/x86/kvm/svm/nested.c          |  4 +--
>>   arch/x86/kvm/vmx/nested.c          | 11 +++++---
>>   arch/x86/kvm/vmx/sgx.c             |  1 +
>>   arch/x86/kvm/vmx/vmx.c             | 55 ++++++++++++++++++++++++++++++++++++--
>>   arch/x86/kvm/vmx/vmx.h             |  2 ++
>>   arch/x86/kvm/x86.c                 | 18 +++++++++++--
>>   arch/x86/kvm/x86.h                 |  2 ++
>>   18 files changed, 134 insertions(+), 30 deletions(-)
>>
>


