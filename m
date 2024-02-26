Return-Path: <kvm+bounces-9990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F08098680FC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0782B254AB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B99E12FF65;
	Mon, 26 Feb 2024 19:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J2GMF/yl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA5C12F5A1;
	Mon, 26 Feb 2024 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975682; cv=none; b=F7DbIVvcHS13rMaU4jAzO0pBG060vujxlVhsbY9oJvrYReLfC0qwxW0Ca8/ToenydsD3N4GP2jal/R1iojRZJxMoxrBJI0gXLKN0bFgjRSWXXiETjOJX9rhfEeiqVL6ddRWr8J5mVm8Xb/ZzBJrmaLmBtOv+dNoHVprdrP1PPnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975682; c=relaxed/simple;
	bh=z3CtMvNdNhYJJenylM+bgudMHFASYy1j0Pe/vc9ycbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBAns2PcUMrZXVowMBrTaOyoBDUejyEUg5RMkTx0Z6OG9bxMmQFB25Vlu9WHnodY8IZBUGMze5kxONOvVUyKgNxZGPgRO7clGmDfOtdtO2gVlFf+MeZUkgPy57J3doA34cTwkyH2+2C8z+qyEfrleBJpRqIBC19TVJMxf6mZnjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J2GMF/yl; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708975680; x=1740511680;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z3CtMvNdNhYJJenylM+bgudMHFASYy1j0Pe/vc9ycbQ=;
  b=J2GMF/ylSX1eE9AmN11KZdHCnw/55iaZpsHTCYh4nECKgUqpSKuXlyX9
   nyMsno49jIs1fNU+UVG0TRc3tAmW/zRzRLWmnK80UdXjFb3TdZqwDRRcl
   QqyHecPJ2PEVTqJgtUvlbxUR3GRWDmbuka7pVJ8fgtAcadtiQCufxLKNE
   DKw3b4ijyVa5MsrVsYfsySZcAFjtPGQJPlf/huGTaitheiJme58x2e4tT
   cWCjGVWaesifZJx82cLm6Ai7G78/oOUVLoAf8JUySF1Z6aSKuXrUrIWSp
   LyWxRY6N/wF5DsNoXFsEl/cu/KJJ8pfHuXUkvpIFSwU0hTXVS6nL9i8VB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3161312"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="3161312"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:27:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="6749704"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:27:58 -0800
Date: Mon, 26 Feb 2024 11:27:57 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Yuan Yao <yuan.yao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 028/130] KVM: TDX: Add TDX "architectural" error codes
Message-ID: <20240226192757.GS177224@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ae0b961d80ab90e43c6eff4a675e00ff80ab3b9f.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ae0b961d80ab90e43c6eff4a675e00ff80ab3b9f.1708933498.git.isaku.yamahata@intel.com>

On Mon, Feb 26, 2024 at 12:25:30AM -0800,
isaku.yamahata@intel.com wrote:

> diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
> index fdfd41511b02..28c4a62b7dba 100644
> --- a/arch/x86/include/asm/shared/tdx.h
> +++ b/arch/x86/include/asm/shared/tdx.h
> @@ -26,7 +26,13 @@
>  #define TDVMCALL_GET_QUOTE		0x10002
>  #define TDVMCALL_REPORT_FATAL_ERROR	0x10003
>  
> -#define TDVMCALL_STATUS_RETRY		1

Oops, I accidentally removed this constant to break tdx guest build.

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index ef1c8e5a2944..1367a5941499 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -28,6 +28,8 @@
 #define TDVMCALL_REPORT_FATAL_ERROR    0x10003
 #define TDVMCALL_SETUP_EVENT_NOTIFY_INTERRUPT  0x10004
 
+#define TDVMCALL_STATUS_RETRY          1
+
 /*
  * TDG.VP.VMCALL Status Codes (returned in R10)
  */
-- 
2.25.1
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

