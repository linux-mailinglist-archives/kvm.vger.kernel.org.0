Return-Path: <kvm+bounces-33640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 786E49EF7B7
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 18:36:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4566B17EDC2
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 17:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF7421B8E1;
	Thu, 12 Dec 2024 17:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SCffMj89"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156AF21766D
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 17:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024258; cv=none; b=oV+tqonsna6ISYHu1iRoy6iyg4mLSfUloSwH5trtxcJWjF7sVI0g679B5VI4z8nxXB62p82PaQ6vk7q+J25XSKqeT1/U4jnxXMRMhLxE2s7EBHU3/g4DIHvEj+w1+cGL2TWqg4C9mPn3Dj0dPJFzT7feFJDdcEmKQkqYl+Z3Eng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024258; c=relaxed/simple;
	bh=ZN9iIEDIb+qeXTusHRIG1A2JOHVdIqP6CkyHsmJ9ujM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UmIUK+YQgbVDW5NhF5BJTLYRLMqXqXGX63S15ztbIIOj3m+8TfKQsnfNejh+vsQkaf25XV+ZzbOc8QhzkGsOpo0lxMcR0fUc6r2cBLDCal3ReIfnwCrA8avtp99d2IE9KJoxEXzkj8gVqpfuXH0sDus4vFl6KRwxweyKj3D+N50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SCffMj89; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734024257; x=1765560257;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZN9iIEDIb+qeXTusHRIG1A2JOHVdIqP6CkyHsmJ9ujM=;
  b=SCffMj89yMhFW+8ldpEVyHlU+8GRNKhSB16ezTW8KfH1suWaDfLLvwJ4
   8cndO4sZMZBnZHlBUxg183/Cs+Pvix8pUd5LrOIfKmF1Vabb53/8Up6Cn
   wK2huJuZmQczAcQ/k0yD6juoMWupyMacqU62v/ETRqZ/daKXB0AwxQMuG
   Bd2D67pqC2maFIBGDKhO1Pp1rHTzQjpNlCmsgZi+sMNvsDMSjw9Li/uRA
   n9D4oVRPGr+dD/3/4/OWWvopBydEe21btr/t6RsJc9iqbl8y2UudEKTkP
   7ImdIJC6hedXUG2jffDQ86T5WI1tRpNV7Apz8fOmm2W7fifqn/ehiSAxy
   g==;
X-CSE-ConnectionGUID: LigggYv+SCe1oeeEJ56NPg==
X-CSE-MsgGUID: Gl8YTshOTbW8KGA14rvnUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="38241603"
X-IronPort-AV: E=Sophos;i="6.12,229,1728975600"; 
   d="scan'208";a="38241603"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 09:24:16 -0800
X-CSE-ConnectionGUID: WAHnGzjwQpGSyx05PFjkYQ==
X-CSE-MsgGUID: eSvjt7GoRFe113nOgoiflQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="127292779"
Received: from puneetse-mobl.amr.corp.intel.com (HELO localhost) ([10.125.110.112])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 09:24:08 -0800
Date: Thu, 12 Dec 2024 11:24:03 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Tony Lindgren <tony.lindgren@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"riku.voipio@iki.fi" <riku.voipio@iki.fi>,
	"imammedo@redhat.com" <imammedo@redhat.com>,
	"Liu, Zhao1" <zhao1.liu@intel.com>,
	"marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
	"anisinha@redhat.com" <anisinha@redhat.com>,
	"mst@redhat.com" <mst@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>,
	"armbru@redhat.com" <armbru@redhat.com>,
	"philmd@linaro.org" <philmd@linaro.org>,
	"cohuck@redhat.com" <cohuck@redhat.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>,
	"eblake@redhat.com" <eblake@redhat.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"wangyanan55@huawei.com" <wangyanan55@huawei.com>,
	"berrange@redhat.com" <berrange@redhat.com>
Subject: Re: [PATCH v6 09/60] i386/tdx: Initialize TDX before creating TD
 vcpus
Message-ID: <Z1scMzIdT2cI4F5T@iweiny-mobl>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-10-xiaoyao.li@intel.com>
 <1235bac6ffe7be6662839adb2630c1a97d1cc4c5.camel@intel.com>
 <c0ef6c19-756e-43f3-8342-66b032238265@intel.com>
 <Zyr7FA10pmLhZBxL@tlindgre-MOBL1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zyr7FA10pmLhZBxL@tlindgre-MOBL1>

On Wed, Nov 06, 2024 at 07:13:56AM +0200, Tony Lindgren wrote:
> On Wed, Nov 06, 2024 at 10:01:04AM +0800, Xiaoyao Li wrote:
> > On 11/6/2024 4:51 AM, Edgecombe, Rick P wrote:
> > > +Tony
> > > 
> > > On Tue, 2024-11-05 at 01:23 -0500, Xiaoyao Li wrote:
> > > > +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
> > > > +{
> > > > +    X86CPU *x86cpu = X86_CPU(cpu);
> > > > +    CPUX86State *env = &x86cpu->env;
> > > > +    g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
> > > > +    int r = 0;
> > > > +
> > > > +    QEMU_LOCK_GUARD(&tdx_guest->lock);
> > > > +    if (tdx_guest->initialized) {
> > > > +        return r;
> > > > +    }
> > > > +
> > > > +    init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
> > > > +                        sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
> > > > +
> > > > +    r = setup_td_xfam(x86cpu, errp);
> > > > +    if (r) {
> > > > +        return r;
> > > > +    }
> > > > +
> > > > +    init_vm->cpuid.nent = kvm_x86_build_cpuid(env, init_vm->cpuid.entries, 0);
> > > > +    tdx_filter_cpuid(&init_vm->cpuid);
> > > > +
> > > > +    init_vm->attributes = tdx_guest->attributes;
> > > > +    init_vm->xfam = tdx_guest->xfam;
> > > > +
> > > > +    do {
> > > > +        r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, init_vm);
> > > > +    } while (r == -EAGAIN);
> > > 
> > > KVM_TDX_INIT_VM can also return EBUSY. This should check for it, or KVM should
> > > standardize on one for both conditions. In KVM, both cases handle
> > > TDX_RND_NO_ENTROPY, but one tries to save some of the initialization for the
> > > next attempt. I don't know why userspace would need to differentiate between the
> > > two cases though, which makes me think we should just change the KVM side.
> > 
> > I remember I tested retrying on the two cases and no surprise showed.
> > 
> > I agree to change KVM side to return -EAGAIN for the two cases.
> 
> OK yeah let's patch KVM for it.

Will the patch to KVM converge such that it is ok for qemu to loop forever?

Ira

> 
> Regards,
> 
> Tony

