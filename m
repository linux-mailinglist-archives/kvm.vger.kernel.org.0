Return-Path: <kvm+bounces-13565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 087808988B3
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 15:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 192691C23102
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 13:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A676512838A;
	Thu,  4 Apr 2024 13:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ePvdrOB7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455C118AF6;
	Thu,  4 Apr 2024 13:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712236953; cv=none; b=jPhY4zqX4BlcoyMwDazqA3cTIeqnAGUXKHPjdlEIjxPlcZ69C/0bhEeSW7KocSlVvb+rZXwM/GmGQjYyPqUlc0n8wET/ZGiRXYB3RXlYUG4BBiVyfrYhsb6Ijs+ZTB+xU3NDzVdw3z15Z8uSU3WdlUYz1jhledVwxIWEgYUXyyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712236953; c=relaxed/simple;
	bh=yx7FNH6/lotPCypW7VEki+uBhT6Ese9cjwR+dtMNvBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7imWTJnTyOAlgkKcdi+3w5b0JYVYqFC6XiKYjo3dIfQn1kQTHf4EcmVFoHIDA/1ZAhtWEcfjxg+71mgRpb6K+dDGA4yCoR6GesUsujnq6d27roHkvGrTm0Hgxs9VAt0Kk073+qol2/rpcIRn9iylccE+WhySVF8tCx7p64OBAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ePvdrOB7; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712236952; x=1743772952;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yx7FNH6/lotPCypW7VEki+uBhT6Ese9cjwR+dtMNvBs=;
  b=ePvdrOB73WnKGql2h6vSHT3wKgcInIv4dV9NkgpTnYI8S5iZB9xWb5eS
   aSpSa6fDZHUz19ZJqeux3Tab+VYxHkKVFtMOqHCrT+lQEswwjfWQmo23N
   RpCwI0E7UI69nZpZsyw5VzO7SOyWpYHKSEBWTUV3CuccOG4+3xGBSJsr2
   axjIZ2zZG/uzMphLLUK3/j9KQX955N2Qa3wmOWnFlz4sqdwspqvGbZlKt
   eXCVOdgN5lIpUmSr5iaFVq/bjSjpKObdDokrcH1CR9V2xDFyes2jHV3uZ
   m9/MzHGS+BkLRdkrBmQGzZnYtqMgbG0NPwaOSapRWt4+EkGsk90eSJ4Qa
   A==;
X-CSE-ConnectionGUID: 14qbZmsRQcaSDXwnmnQCrA==
X-CSE-MsgGUID: PBJ/25U2RKS8BYCSam/paQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7385021"
X-IronPort-AV: E=Sophos;i="6.07,179,1708416000"; 
   d="scan'208";a="7385021"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 06:22:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="937086562"
X-IronPort-AV: E=Sophos;i="6.07,179,1708416000"; 
   d="scan'208";a="937086562"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 04 Apr 2024 06:22:27 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 732E5812; Thu,  4 Apr 2024 16:22:26 +0300 (EEST)
Date: Thu, 4 Apr 2024 16:22:26 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sean Christopherson <seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, 
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
Message-ID: <gnu6i2mz65ie2fmaz6yvmgsod6p67m7inxypujuxq7so6mtg2k@ed7pozauccka>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>

On Mon, Feb 26, 2024 at 12:26:20AM -0800, isaku.yamahata@intel.com wrote:
> @@ -491,6 +494,87 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	 */
>  }
>  
> +static noinstr void tdx_vcpu_enter_exit(struct vcpu_tdx *tdx)
> +{

...

> +	tdx->exit_reason.full = __seamcall_saved_ret(TDH_VP_ENTER, &args);

Call to __seamcall_saved_ret() leaves noinstr section.

__seamcall_saved_ret() has to be moved:

diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
index e32cf82ed47e..6b434ab12db6 100644
--- a/arch/x86/virt/vmx/tdx/seamcall.S
+++ b/arch/x86/virt/vmx/tdx/seamcall.S
@@ -44,6 +44,8 @@ SYM_FUNC_START(__seamcall_ret)
 SYM_FUNC_END(__seamcall_ret)
 EXPORT_SYMBOL_GPL(__seamcall_ret);
 
+.section .noinstr.text, "ax"
+
 /*
  * __seamcall_saved_ret() - Host-side interface functions to SEAM software
  * (the P-SEAMLDR or the TDX module), with saving output registers to the
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

