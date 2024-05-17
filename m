Return-Path: <kvm+bounces-17642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 924CB8C8A16
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 18:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C34981C2176F
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA8E12FF69;
	Fri, 17 May 2024 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OcOX+ZbI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5AA3D9E;
	Fri, 17 May 2024 16:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715963108; cv=none; b=UJmnPm4n/rNjwtILaiLwHkTb6Svw53QhW/RYLcwvA5lUM+rowGCnQ6hGPGOJRkT1SqgyUUd84PMtSrQi+7t+R4DiUkw78PE60T7R70adMmIbG+TNDAJkF1IkMYkjTHQUhfU/gju1VPqwM68WhesT78kphIWMduOwH24WDtWmGRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715963108; c=relaxed/simple;
	bh=vhNvc95DBkL2aLYyLqRIQcrflwmg0YDC3PVeoxygFSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujYBuFlHN5eF8O2NXle94QOtpiQULH6mTkPg6vf7U5YbHB0VVFeHRVKx3gy2H/inHYLZbEWM9Pg16thbUn3JVvwcmYvyUc2dJ9kVatqIp/fvgylSIdKSGIkzdZjDXzY63dXCA6fwbaWwZ4XTrv5oZpXpy+boEdSD6JtWFNRPOjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OcOX+ZbI; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715963106; x=1747499106;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=vhNvc95DBkL2aLYyLqRIQcrflwmg0YDC3PVeoxygFSM=;
  b=OcOX+ZbIpHZd8cIWflTd3QO3eSreG+Bu82c7dXvtsyBMFYZOaNEVsYkw
   nPIHRZpsM8ylkbElqJbSxTj+1262EXlCn2/pT9eVxND04lwuZiIAg4GoW
   CSLBZNFUuLkh9PbeDIt2STiW9/3uv+qZND/VJyjBoBl3xH/b5GYpw8BsI
   i3e4JQ5BMRiuWYhI6q6iPmL/NS91mh7FyZB6TH4usbQ5+0VqEAN4CiIJW
   p+k17e8RHnewObqOAUQxr5gsVPyNoEzpyJpUpBK1lrezt38a6J2KSCTbF
   PKj+7JGqP9zJymxsC100PhOaD9UxS9UZPex5oZlxGVXqZ2DPfu/mJAM2B
   w==;
X-CSE-ConnectionGUID: GY6FLpUoS0eN04Q1cTG+aQ==
X-CSE-MsgGUID: TvQxkltzRaO/uWPp4/DoMQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="12360930"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="12360930"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 09:25:05 -0700
X-CSE-ConnectionGUID: Zb/wWZh/Rc2luuvItdghFw==
X-CSE-MsgGUID: XwKadQglQDKEPjnFfG4K3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="31847689"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa006.fm.intel.com with ESMTP; 17 May 2024 09:25:02 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id DBDCF1F1; Fri, 17 May 2024 19:25:00 +0300 (EEST)
Date: Fri, 17 May 2024 19:25:00 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, 
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <pfbphwefaefxw2l2u26qr6ptq7rtdmnihjmxvk34zv4srlnsum@qyjumzzdnfxo>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <46mh5hinsv5mup2x7jv4iu2floxmajo2igrxb3haru3cgjukbg@v44nspjozm4h>
 <de344d2c-6790-49c5-85be-180bc4d92ea4@suse.com>
 <etso5bvvs2gq3parvzukujgbatwqfb6lhzoxhenrapav6obbgl@o6lowhrcbucp>
 <e8b36230-d59f-44f1-ba48-5a0533238d8e@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e8b36230-d59f-44f1-ba48-5a0533238d8e@suse.com>

On Fri, May 17, 2024 at 05:00:19PM +0200, Jürgen Groß wrote:
> On 17.05.24 16:53, Kirill A. Shutemov wrote:
> > On Fri, May 17, 2024 at 04:37:16PM +0200, Juergen Gross wrote:
> > > On 17.05.24 16:32, Kirill A. Shutemov wrote:
> > > > On Mon, Feb 26, 2024 at 12:25:41AM -0800, isaku.yamahata@intel.com wrote:
> > > > > @@ -725,6 +967,17 @@ static int __init tdx_module_setup(void)
> > > > >    	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
> > > > > +	/*
> > > > > +	 * Make TDH.VP.ENTER preserve RBP so that the stack unwinder
> > > > > +	 * always work around it.  Query the feature.
> > > > > +	 */
> > > > > +	if (!(tdx_info->features0 & MD_FIELD_ID_FEATURES0_NO_RBP_MOD) &&
> > > > > +	    !IS_ENABLED(CONFIG_FRAME_POINTER)) {
> > > > 
> > > > I think it supposed to be IS_ENABLED(CONFIG_FRAME_POINTER). "!" shouldn't
> > > > be here.
> > > 
> > > No, I don't think so.
> > > 
> > > With CONFIG_FRAME_POINTER %rbp is being saved and restored, so there is no
> > > problem in case the seamcall is clobbering it.
> > 
> > Could you check setup_tdparams() in your tree?
> > 
> > Commit
> > 
> > [SEAM-WORKAROUND] KVM: TDX: Don't use NO_RBP_MOD for backward compatibility
> > 
> > in my tree comments out the setting TDX_CONTROL_FLAG_NO_RBP_MOD.
> > 
> > I now remember there was problem in EDK2 using RBP. So the patch is
> > temporary until EDK2 is fixed.
> > 
> 
> I have the following line in setup_tdparams() (not commented out):
> 
> 	td_params->exec_controls = TDX_CONTROL_FLAG_NO_RBP_MOD;

Could you check if it is visible from the guest side?

It is zero for me.

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index c1cb90369915..f65993a6066d 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -822,13 +822,33 @@ static bool tdx_enc_status_change_finish(unsigned long vaddr, int numpages,
 	return true;
 }
 
+#define TDG_VM_RD			7
+
+#define TDCS_CONFIG_FLAGS		0x1110000300000016
+
+#define TDCS_CONFIG_NO_RBP_MOD		BIT_ULL(2)
+
+/* Read TD-scoped metadata */
+static inline u64 tdg_vm_rd(u64 field, u64 *value)
+{
+	struct tdx_module_args args = {
+		.rdx = field,
+	};
+	u64 ret;
+
+	ret = __tdcall_ret(TDG_VM_RD, &args);
+	*value = args.r8;
+
+	return ret;
+}
+
 void __init tdx_early_init(void)
 {
 	struct tdx_module_args args = {
 		.rdx = TDCS_NOTIFY_ENABLES,
 		.r9 = -1ULL,
 	};
-	u64 cc_mask;
+	u64 cc_mask, config;
 	u32 eax, sig[3];
 
 	cpuid_count(TDX_CPUID_LEAF_ID, 0, &eax, &sig[0], &sig[2],  &sig[1]);
@@ -893,4 +913,7 @@ void __init tdx_early_init(void)
 	x86_cpuinit.parallel_bringup = false;
 
 	pr_info("Guest detected\n");
+
+	tdg_vm_rd(TDCS_CONFIG_FLAGS, &config);
+	printk("NO_RBP_MOD: %#llx\n", config & TDCS_CONFIG_NO_RBP_MOD);
 }
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

