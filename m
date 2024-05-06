Return-Path: <kvm+bounces-16766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AA188BD537
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 21:10:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB9251C20F67
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 19:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1291591F7;
	Mon,  6 May 2024 19:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I2J6A22s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DC0158DD5;
	Mon,  6 May 2024 19:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715022643; cv=none; b=GWb8+Ioeg3JjO4ghzwdcYZ8tltOMWCGlwSChM7EIUr2ClaUkkQ1mYZqlp7ucvY1tE19IyeSWFCyUDCOqngBv0NJmlJsP5fpo+nuyqLprMJ6YO0W7x3HLAn0EjXifiIcdWurWtL9maTyEZdjS0yRtGhq9rUs7NFk91BU1TlDfNu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715022643; c=relaxed/simple;
	bh=kPCSlFZ/lSBt4Pb75v7rCK1VScHWGpdu2/lhZVIUnFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FM8XiZZd7ItnUPIbOnWYnFNxMtFDadjjWQDkqeTRjArdFqk/rM3RaDdOZ6DjhIZk3PvIpwbJ/lXSA2EtKWeZ6b0/6jYJG6iM9ZiSjJjdyE/bhd0LraO+i5LlkPxH8qkYkK9FHlQL97HoNMUsbSOD32k/1CP4CBWWYL1J/wJu5Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I2J6A22s; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715022642; x=1746558642;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=kPCSlFZ/lSBt4Pb75v7rCK1VScHWGpdu2/lhZVIUnFM=;
  b=I2J6A22sTpl+tEIaT3v4LI904FId8r9SqCLnDqzSyemho0BWhPsGsXkU
   0VBo+2ka6wTW+nGDe53Z6UejuRBfQDq9NgLFTLidaLHIznIAEurRI5nv7
   ThNDdsifslXeyVW/kyUqSpIB79umdbTmBt7r0Td0nTICcv/P4bYahxyeo
   xtYAOOnzPu7wXcV3AnxqyLF2T9rG2W/AEKxekKNNhJrLcXC/iJn5K6HNo
   ekmSkcE+/fZmq9P57uP9Z62AIIpBZ4thwpGbeXJBJZY2R8hC9PzfQQzuB
   oJ0qTcnl3HfXUVvFvqnJ1cXi+Kutdas86fV2+XWfrQgYjpDZAUpDGV6jL
   w==;
X-CSE-ConnectionGUID: Q15XhlraSuSqpNUnMUgXcA==
X-CSE-MsgGUID: P4KfYnaEQ52VF1fSbCU/jw==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10633270"
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="10633270"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 12:10:41 -0700
X-CSE-ConnectionGUID: cN8StRI6TXKdC5LTZBgCOA==
X-CSE-MsgGUID: PMOoDdOgSv+aA3f33moy0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="28351970"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 12:10:41 -0700
Date: Mon, 6 May 2024 12:10:39 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v19 088/130] KVM: x86: Add a switch_db_regs flag to
 handle TDX's auto-switched behavior
Message-ID: <20240506191039.GE13783@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ca5d0399cdbbaa6c7c6528ad85b3560cec0f0752.1708933498.git.isaku.yamahata@intel.com>
 <fdf2d5fa-64dc-4429-8529-66106632a95b@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fdf2d5fa-64dc-4429-8529-66106632a95b@linux.intel.com>

On Mon, May 06, 2024 at 11:30:52AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 1b189e86a1f1..fb7597c22f31 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11013,7 +11013,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >   	if (vcpu->arch.guest_fpu.xfd_err)
> >   		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
> > -	if (unlikely(vcpu->arch.switch_db_regs)) {
> > +	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH)) {
> 
> As pointed by Paolo in
> https://lore.kernel.org/lkml/ea136ac6-53cf-cdc5-a741-acfb437819b1@redhat.com/
> KVM_DEBUGREG_BP_ENABLED could be set in vcpu->arch.switch_db_regs,  by
> userspace
> kvm_vcpu_ioctl_x86_set_debugregs()  --> kvm_update_dr7()
> 
> So it should be fixed as:
> 
> -       if (unlikely(vcpu->arch.switch_db_regs)) {
> +       if (unlikely(vcpu->arch.switch_db_regs &&
> +                    !(vcpu->arch.switch_db_regs &
> KVM_DEBUGREG_AUTO_SWITCH))) {

Yes, that's true. Thanks for catching this.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

