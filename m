Return-Path: <kvm+bounces-13301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A5889477D
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 00:55:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11C211C21A14
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 22:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3F556B95;
	Mon,  1 Apr 2024 22:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DU2sZgTd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDBC33982;
	Mon,  1 Apr 2024 22:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712012118; cv=none; b=bgdZZlntpojsCm9MCWA/OjbByIVey/aPxRUWC59sGo9dv3K29QSItbZcIpdMJUeXsv/pondPZI4eQNQPavw/g8J0ktUoqRBPAXAfK1aDPlitabo/rAWhrhGHvcayODY1Ka8dzLlO5Ha33o+hSxPdPPDyPigRjUSIJ+LITW3epOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712012118; c=relaxed/simple;
	bh=fBRLXb8M1oUe7xHcHZtau0o3gCJ7+yXoMO8c301gkPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pNEiOc7imi/zgbDYCWNnNzsT5EOZF4bqdpBt4OyBWliwceK3VuOy9WqdqmcQP86VNcF16rdEUEfB748IRQlTxM6ZjpI0bbfrgFrxNgkhGGUVHsQwWD19DjtRV98BB2gE5KgyDs8DaCZly7zPQfTkPQZnir8Rlv6mDXZ/JFv/Xwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DU2sZgTd; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712012117; x=1743548117;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fBRLXb8M1oUe7xHcHZtau0o3gCJ7+yXoMO8c301gkPs=;
  b=DU2sZgTdNXzaHfb46UznpYjlUWQHWAiJ5o0Hp8K07pampC9gGbqVBhRw
   5nwhc3/TDXrAKuLGadB8YZp43M861hmuZVREJk1M66qTK1ZxVhSBa+X9U
   x6V/EkDOb/PAbl+zKqGonSesZc5nmG4TUqhJzy5Gx88nGIoWnxM8JX6eC
   etCJzJk6BWcdXGjYnvU62DZ2cHloDyve4pJfsdMvBODDddXAm0iBWOhoz
   QFyPRfiozYQgJiFxFwg5wi5m+puL1ZF2O2K/3VFTt7VNfJoHvtcbCHk/Q
   MGgr+gK6r4UE3I3E55EkHE8HpaNyQNq/TP+wV64e+OS3LbllENSfcb2zU
   Q==;
X-CSE-ConnectionGUID: rF6H24LXR4WTsSTT1sdFeg==
X-CSE-MsgGUID: 1SFXi37wRJGtaLgcMZo8Tg==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="7058422"
X-IronPort-AV: E=Sophos;i="6.07,173,1708416000"; 
   d="scan'208";a="7058422"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 15:55:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,173,1708416000"; 
   d="scan'208";a="18322003"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 15:55:16 -0700
Date: Mon, 1 Apr 2024 15:55:15 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240401225515.GU2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <ZfpwIespKy8qxWWE@chao-email>
 <20240321141709.GK1994522@ls.amr.corp.intel.com>
 <f52734ac-704a-49f7-bbee-de5909d53b14@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f52734ac-704a-49f7-bbee-de5909d53b14@linux.intel.com>

On Fri, Mar 29, 2024 at 02:22:12PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 3/21/2024 10:17 PM, Isaku Yamahata wrote:
> > On Wed, Mar 20, 2024 at 01:12:01PM +0800,
> > Chao Gao <chao.gao@intel.com> wrote:
> > 
> > > > config KVM_SW_PROTECTED_VM
> > > > 	bool "Enable support for KVM software-protected VMs"
> > > > -	depends on EXPERT
> 
> This change is not needed, right?
> Since you intended to use KVM_GENERIC_PRIVATE_MEM, not KVM_SW_PROTECTED_VM.

Right. The fix will be something as follows.

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f2bc78ceaa9a..e912b128bddb 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -77,6 +77,7 @@ config KVM_WERROR
 
 config KVM_SW_PROTECTED_VM
        bool "Enable support for KVM software-protected VMs"
+       depends on EXPERT
        depends on KVM && X86_64
        select KVM_GENERIC_PRIVATE_MEM
        help
@@ -90,7 +91,7 @@ config KVM_SW_PROTECTED_VM
 config KVM_INTEL
        tristate "KVM for Intel (and compatible) processors support"
        depends on KVM && IA32_FEAT_CTL
-       select KVM_SW_PROTECTED_VM if INTEL_TDX_HOST
+       select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
        select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
        help
          Provides support for KVM on processors equipped with Intel's VT
-- 
2.43.2
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

