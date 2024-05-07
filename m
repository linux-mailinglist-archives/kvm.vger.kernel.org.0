Return-Path: <kvm+bounces-16799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3288E8BDC15
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B38641F23461
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 07:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767C913A41B;
	Tue,  7 May 2024 07:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qlf5mnyz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A9A13AD3A;
	Tue,  7 May 2024 07:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715065628; cv=none; b=Tbo7G39RKwyOrWXPo9ZLW64VYXtvmIEwsTFi9V9YEzgnx5aXhG0MioUHZvl52bvy9LGx4g5vxZO4WprYMb8TPJ6pIv6vD1hv6IvQVEMQQXx3SkT3fXt6mp6JLIoGh9y4NzdcWzLFMNU9Owa5pneINv0LtNenJ/7wwKahZ3DW49o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715065628; c=relaxed/simple;
	bh=bQXv9Hy2x6/R2wGqVfX1vS8ZAi8sBzqHlNmfcbOrRLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q9FhL8EOEQzVVC7x+hDE/b9jndKlPKVQq/32Zg+U5nCb3d4c1kajgN8/P08jXLlmd2CYh+F4cYZzjuUABx0XCySRxuZDGtpiwIQrC+LgqvqBUf0oPxvcWUyt4FshSEsGXGNDgn0t7uFVEm9I+4BQvslFWIJsmAhf0v2udeuCBx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qlf5mnyz; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715065626; x=1746601626;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bQXv9Hy2x6/R2wGqVfX1vS8ZAi8sBzqHlNmfcbOrRLo=;
  b=Qlf5mnyzOAV9friAlL3PUKb15MBGJBt+iq5bh33bmcvfF8Vwvy2w/grn
   Fkeh/7V/qEy0KcudV/HeqPgO5hlsy4n6456Z6ZDgFbuigMTBVaKKrYHA2
   1KJE0cvpRBkWolSeBbcVQZyjBTgSl9iyQj/IT1rSVDsLyV7xwzgPbm7OA
   gVHh5BDevRr4WdoM0eSZuqdITkoEULLL2MW/n8ob2upZxSETCJagHk2Nc
   6qsmH/uH3aol8J5Fmr7I2RY5HmmZ13VUYT470lXh2WKk8Ezhr/JuRWh03
   Vwfa4sjw0+beVUlix8S69OU/BMSMdiNmesIJvizQglMXCGgTXkeg06y9z
   g==;
X-CSE-ConnectionGUID: C2ojva96TwWWJY89cq24Nw==
X-CSE-MsgGUID: Sq7pq3uMS0O2hCYHdhfeXA==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="14651310"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="14651310"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 00:07:05 -0700
X-CSE-ConnectionGUID: bLBIefyXRgmLlyQfmsasAA==
X-CSE-MsgGUID: XvRz4mRFRGC5tZAna8hZGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="28416128"
Received: from unknown (HELO [10.238.8.173]) ([10.238.8.173])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 00:07:00 -0700
Message-ID: <7ac867ff-62f4-419f-9a76-db015cd78ad7@linux.intel.com>
Date: Tue, 7 May 2024 15:06:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 103/130] KVM: TDX: Handle EXIT_REASON_OTHER_SMI with
 MSMI
To: Isaku Yamahata <isaku.yamahata@intel.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 isaku.yamahata@linux.intel.com, Reinette Chatre <reinette.chatre@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4a96a33c01b547f6e89ecf40224c80afa59c6aa4.1708933498.git.isaku.yamahata@intel.com>
 <Zgp62iK3HQEvcDyQ@chao-email>
 <20240403222336.GM2444378@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240403222336.GM2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/4/2024 6:23 AM, Isaku Yamahata wrote:
> On Mon, Apr 01, 2024 at 05:14:02PM +0800,
> Chao Gao <chao.gao@intel.com> wrote:
>
>> On Mon, Feb 26, 2024 at 12:26:45AM -0800, isaku.yamahata@intel.com wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> When BIOS eMCA MCE-SMI morphing is enabled, the #MC is morphed to MSMI
>>> (Machine Check System Management Interrupt).  Then the SMI causes TD exit
>>> with the read reason of EXIT_REASON_OTHER_SMI with MSMI bit set in the exit
>>> qualification to KVM instead of EXIT_REASON_EXCEPTION_NMI with MC
>>> exception.
>>>
>>> Handle EXIT_REASON_OTHER_SMI with MSMI bit set in the exit qualification as
>>> MCE(Machine Check Exception) happened during TD guest running.
>>>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> ---
>>> arch/x86/kvm/vmx/tdx.c      | 40 ++++++++++++++++++++++++++++++++++---
>>> arch/x86/kvm/vmx/tdx_arch.h |  2 ++
>>> 2 files changed, 39 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index bdd74682b474..117c2315f087 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -916,6 +916,30 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>>> 						     tdexit_intr_info(vcpu));
>>> 	else if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
>>> 		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
>>> +	else if (unlikely(tdx->exit_reason.non_recoverable ||
>>> +		 tdx->exit_reason.error)) {
>> why not just:
>> 	else if (tdx->exit_reason.basic == EXIT_REASON_OTHER_SMI) {
>>
>>
>> i.e., does EXIT_REASON_OTHER_SMI imply exit_reason.non_recoverable or
>> exit_reason.error?
> Yes, this should be refined.
>
>
>>> +		/*
>>> +		 * The only reason it gets EXIT_REASON_OTHER_SMI is there is an
>>> +		 * #MSMI(Machine Check System Management Interrupt) with
>>> +		 * exit_qualification bit 0 set in TD guest.
>>> +		 * The #MSMI is delivered right after SEAMCALL returns,
>>> +		 * and an #MC is delivered to host kernel after SMI handler
>>> +		 * returns.
>>> +		 *
>>> +		 * The #MC right after SEAMCALL is fixed up and skipped in #MC
>> Looks fixing up and skipping #MC on the first instruction after TD-exit is
>> missing in v19?
> Right. We removed it as MSMI will provides if #MC happened in SEAM or not.

According to the patch of host #MC handler
https://lore.kernel.org/lkml/171265126376.10875.16864387954272613660.tip-bot2@tip-bot2/,
the #MC triggered by MSMI can be handled by kernel #MC handler.
There is no need to call kvm_machine_check().

Does the following fixup make sense to you?
--------

KVM: TDX: Handle EXIT_REASON_OTHER_SMI

Handle "Other SMI" VM exit for TDX.

Unlike VMX, an SMI occurs in SEAM non-root mode cause VM exit to TDX
module, then SEAMRET to KVM. Once it exits to KVM, SMI is delivered and
handled by kernel handler right away.

Specifically, when BIOS eMCA MCE-SMI morphing is enabled, the #MC occurs
in TDX guest is delivered as an Machine Check System Management Interrupt
(MSMI) with the exit reason of EXIT_REASON_OTHER_SMI with MSMI (bit 0) set
in the exit qualification.  On VM exit, TDX module checks whether the "Other
SMI" is caused by a MSMI or not.  If so, TDX module makes TD as fatal,
preventing further TD entries, and then completes the TD exit flow to KVM
with the TDH.VP.ENTER outputs indicating TDX_NON_RECOVERABLE_TD.
After TD exit, the MSMI is delivered and eventually handled by the kernel
#MC handler[1].

So, to handle "Other SMI" VM exit:
- For non-MSMI case, KVM doesn't need to do anything, just continue TDX vCPU
   execution.
- For MSMI case, since the TDX guest is dead, follow other non-recoverable
   cases, exit to userspace.

[1] The patch supports handling MSMI signaled during SEAM operation.
     It's already in tip tree.
https://lore.kernel.org/lkml/171265126376.10875.16864387954272613660.tip-bot2@tip-bot2/

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4ee94bfb17e2..fd756d231204 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -975,30 +975,6 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
tdexit_intr_info(vcpu));
         else if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
                 vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
-       else if (unlikely(tdx->exit_reason.non_recoverable ||
-                tdx->exit_reason.error)) {
-               /*
-                * The only reason it gets EXIT_REASON_OTHER_SMI is 
there is an
-                * #MSMI(Machine Check System Management Interrupt) with
-                * exit_qualification bit 0 set in TD guest.
-                * The #MSMI is delivered right after SEAMCALL returns,
-                * and an #MC is delivered to host kernel after SMI handler
-                * returns.
-                *
-                * The #MC right after SEAMCALL is fixed up and skipped 
in #MC
-                * handler because it's an #MC happens in TD guest we cannot
-                * handle it with host's context.
-                *
-                * Call KVM's machine check handler explicitly here.
-                */
-               if (tdx->exit_reason.basic == EXIT_REASON_OTHER_SMI) {
-                       unsigned long exit_qual;
-
-                       exit_qual = tdexit_exit_qual(vcpu);
-                       if (exit_qual & TD_EXIT_OTHER_SMI_IS_MSMI)
-                               kvm_machine_check();
-               }
-       }
  }

  static int tdx_handle_exception(struct kvm_vcpu *vcpu)
@@ -1923,10 +1899,6 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, 
fastpath_t fastpath)
                               to_kvm_tdx(vcpu->kvm)->hkid,
                               set_hkid_to_hpa(0, 
to_kvm_tdx(vcpu->kvm)->hkid));

-               /*
-                * tdx_handle_exit_irqoff() handled 
EXIT_REASON_OTHER_SMI.  It
-                * must be handled before enabling preemption because 
it's #MC.
-                */
                 goto unhandled_exit;
         }

@@ -1970,14 +1942,14 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, 
fastpath_t fastpath)
                 return tdx_handle_ept_misconfig(vcpu);
         case EXIT_REASON_OTHER_SMI:
                 /*
-                * Unlike VMX, all the SMI in SEAM non-root mode (i.e. when
-                * TD guest vcpu is running) will cause TD exit to TDX 
module,
-                * then SEAMRET to KVM. Once it exits to KVM, SMI is 
delivered
-                * and handled right away.
+                * Unlike VMX, SMI occurs in SEAM non-root mode (i.e. when
+                * TD guest vCPU is running) will cause VM exit to TDX 
module,
+                * then SEAMRET to KVM.  Once it exits to KVM, SMI is 
delivered
+                * and handled by kernel handler right away.
                  *
-                * - If it's an Machine Check System Management Interrupt
-                *   (MSMI), it's handled above due to non_recoverable 
bit set.
-                * - If it's not an MSMI, don't need to do anything here.
+                * - A MSMI will not reach here, it's handled as 
non_recoverable
+                *   case above.
+                * - If it's not a MSMI, no need to do anything here.
                  */
                 return 1;
         default:
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 2aecffe9f276..aa2fea7b2652 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -41,8 +41,6 @@
  #define TDH_PHYMEM_PAGE_WBINVD         41
  #define TDH_VP_WR                      43

-#define TD_EXIT_OTHER_SMI_IS_MSMI      BIT_ULL(1)
-
  /* TDX control structure (TDR/TDCS/TDVPS) field access codes */
  #define TDX_NON_ARCH                   BIT_ULL(63)
  #define TDX_CLASS_SHIFT                        56



