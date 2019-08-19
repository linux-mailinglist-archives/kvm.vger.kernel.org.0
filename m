Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CABC951B0
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 01:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbfHSXfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 19:35:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:4965 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728730AbfHSXfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 19:35:38 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 16:35:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,406,1559545200"; 
   d="scan'208,223";a="329524525"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 19 Aug 2019 16:35:37 -0700
Date:   Mon, 19 Aug 2019 16:35:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nikita Leshenko <nikita.leshchenko@oracle.com>
Cc:     kvm@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH 2/2] KVM: nVMX: Check guest activity state on vmentry of
 nested guests
Message-ID: <20190819233537.GG1916@linux.intel.com>
References: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
 <20190819214650.41991-3-nikita.leshchenko@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20190819214650.41991-3-nikita.leshchenko@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 20, 2019 at 12:46:50AM +0300, Nikita Leshenko wrote:
> The checks are written in the same order and structure as they appear in "SDM
> 26.3.1.5 - Checks on Guest Non-Register State", to ease verification.
> 
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 24 ++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmcs.h   | 13 +++++++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 24734946ec75..e2ee217f8ffe 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2666,10 +2666,34 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
>   */
>  static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
>  {
> +	/* Activity state must contain supported value */
>  	if (vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE &&
>  	    vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT)
>  		return -EINVAL;
>  
> +	/* Must not be HLT if SS DPL is not 0 */
> +	if (VMX_AR_DPL(vmcs12->guest_ss_ar_bytes) != 0 &&
> +	    vmcs12->guest_activity_state == GUEST_ACTIVITY_HLT)
> +		return -EINVAL;
> +
> +	/* Must be active if blocking by MOV-SS or STI */
> +	if ((vmcs12->guest_interruptibility_info &
> +	    (GUEST_INTR_STATE_MOV_SS | GUEST_INTR_STATE_STI)) &&
> +	    vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE)

IMO, following the SDM verbatim doesn't help readability in this case.
E.g. filtering out ACTIVE state right away cuts down on the amount of
code and helps the reader focus on the unique aspects of each check.

	if (vmcs12->guest_activity_state == GUEST_ACTIVITY_ACTIVE)
		return 0;

> +		return -EINVAL;
> +
> +	/* In HLT, only some interruptions are allowed */
> +	if (vmcs12->vm_entry_intr_info_field & INTR_INFO_VALID_MASK &&
> +	    vmcs12->guest_activity_state == GUEST_ACTIVITY_HLT) {
> +		u32 intr_info = vmcs12->vm_entry_intr_info_field;
> +		if (!is_ext_interrupt(intr_info) &&
> +		    !is_nmi(intr_info) &&
> +		    !is_debug(intr_info) &&
> +		    !is_machine_check(intr_info) &&
> +		    !is_mtf(intr_info))
> +		    return -EINVAL;

Bad indentation.  scripts/checkpatch.pl will catch this.  It'll also
complain about the changelog running past 75 chars and about "Missing a
blank line after declarations" for u32 intr_info, both of which are
easy nits to fix.

> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> index cb6079f8a227..c5577c40b19d 100644
> --- a/arch/x86/kvm/vmx/vmcs.h
> +++ b/arch/x86/kvm/vmx/vmcs.h
> @@ -102,6 +102,13 @@ static inline bool is_machine_check(u32 intr_info)
>  		(INTR_TYPE_HARD_EXCEPTION | MC_VECTOR | INTR_INFO_VALID_MASK);
>  }
>  
> +static inline bool is_mtf(u32 intr_info)

We may want to call this is_pending_mtf().  MTF has a dedicated VM-Exit
type and doesn't populate VM_EXIT_INTRO_INFO, while all of the other
helpers are valid for both VM-Enter and VM-Exit.

> +{
> +	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
> +			     INTR_INFO_VALID_MASK)) ==
> +		(INTR_TYPE_OTHER_EVENT | 0 | INTR_INFO_VALID_MASK);

This reminded me a patch I've been meaning to write.  Any objection to
carrying the attached patch as cleanup and reworking this code accordingly?

> +}
> +
>  /* Undocumented: icebp/int1 */
>  static inline bool is_icebp(u32 intr_info)
>  {
> @@ -115,6 +122,12 @@ static inline bool is_nmi(u32 intr_info)
>  		== (INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK);
>  }
>  
> +static inline bool is_ext_interrupt(u32 intr_info)
> +{
> +	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
> +		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
> +}
> +
>  enum vmcs_field_width {
>  	VMCS_FIELD_WIDTH_U16 = 0,
>  	VMCS_FIELD_WIDTH_U64 = 1,
> -- 
> 2.20.1
> 

--VbJkn9YxBvnuCH5J
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-KVM-VMX-Add-helpers-to-identify-interrupt-type-from-.patch"

From 588a85e32e3d2ed71712a21557ba9baf0e3aa25c Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Mon, 19 Aug 2019 16:14:01 -0700
Subject: [PATCH] KVM: VMX: Add helpers to identify interrupt type from
 intr_info

Add is_intr_type() and is_intr_type_n() to consolidate the boilerplate
code for querying a specific type of interrupt given an encoded value
from VMCS.VM_{ENTER,EXIT}_INTR_INFO, with and without an associated
vector respectively.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmcs.h | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 481ad879197b..dcf21cca160b 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -72,11 +72,22 @@ struct loaded_vmcs {
 	struct vmcs_controls_shadow controls_shadow;
 };
 
+static inline bool is_intr_type(u32 intr_info, u32 type)
+{
+	return (intr_info & (INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK))
+		== (INTR_INFO_VALID_MASK | type);
+}
+
+static inline bool is_intr_type_n(u32 intr_info, u32 type, u8 vector)
+{
+	return (intr_info & (INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK |
+			     INTR_INFO_VECTOR_MASK)) ==
+		(INTR_INFO_VALID_MASK | type | vector);
+}
+
 static inline bool is_exception_n(u32 intr_info, u8 vector)
 {
-	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
-			     INTR_INFO_VALID_MASK)) ==
-		(INTR_TYPE_HARD_EXCEPTION | vector | INTR_INFO_VALID_MASK);
+	return is_intr_type_n(intr_info, INTR_TYPE_HARD_EXCEPTION, vector);
 }
 
 static inline bool is_debug(u32 intr_info)
@@ -106,28 +117,23 @@ static inline bool is_gp_fault(u32 intr_info)
 
 static inline bool is_machine_check(u32 intr_info)
 {
-	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
-			     INTR_INFO_VALID_MASK)) ==
-		(INTR_TYPE_HARD_EXCEPTION | MC_VECTOR | INTR_INFO_VALID_MASK);
+	return is_exception_n(intr_info, MC_VECTOR);
 }
 
 /* Undocumented: icebp/int1 */
 static inline bool is_icebp(u32 intr_info)
 {
-	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
-		== (INTR_TYPE_PRIV_SW_EXCEPTION | INTR_INFO_VALID_MASK);
+	return is_intr_type(intr_info, INTR_TYPE_PRIV_SW_EXCEPTION);
 }
 
 static inline bool is_nmi(u32 intr_info)
 {
-	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
-		== (INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK);
+	return is_intr_type(intr_info, INTR_TYPE_NMI_INTR);
 }
 
 static inline bool is_external_intr(u32 intr_info)
 {
-	return (intr_info & (INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK))
-		== (INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR);
+	return is_intr_type(intr_info, INTR_TYPE_EXT_INTR);
 }
 
 enum vmcs_field_width {
-- 
2.22.0


--VbJkn9YxBvnuCH5J--
