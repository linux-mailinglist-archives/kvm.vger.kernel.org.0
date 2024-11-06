Return-Path: <kvm+bounces-30847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 237989BDE37
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 06:14:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B42C41F24521
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 05:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1182190678;
	Wed,  6 Nov 2024 05:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OhQFUejs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30882190462
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 05:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730870049; cv=none; b=lfuOaOq9JZuCkDvg3TkM7oql+UtCVcg8VMA3VVrhy+FhvRbiwdHEGMKaP/HH78RmLBGDIXPWAGGOnxUMtk411qDYGbYaKkyOcHxRpemApIuVDsxgwXirBZcARuj6LqpKsuxDaBUCpV3tockkPRZty+a+twuKW/7U5dll54dSzPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730870049; c=relaxed/simple;
	bh=+GUtlbwkwgEWibYVDjD+xb0kv0/BuZe7m5hWZoXt4oA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0nUSF9J/b+XO89fEU0zh/So/PWhH9qJXPXwSmNCi4yurF102cw59+dYmC+jJKKiJAL2nQOzAiWzfLr+KkwggUB2V8WtOXXUW6vP68jGV+fhz70SXhUwnWwGoNNT0eHKMnADkJJW+6rGInMo2XQcVP8wE0yU6rO3T5cRz1SRmUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OhQFUejs; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730870048; x=1762406048;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=+GUtlbwkwgEWibYVDjD+xb0kv0/BuZe7m5hWZoXt4oA=;
  b=OhQFUejss5JFXb8whodTnZ3yuSHNrzJErvta3aRXXPBKxZutn8U1BvHn
   +FbJ2GVLNZhGl0H2soIoIZ1KmKLypWC7vgfBPAbiSml1Bm958zFJdEVTB
   hUqXacLT7sksvMJxAImcTEGZfghjEwZspMd5qBM6rYsyjE+6KQsiYzhZM
   wDsSYc3XCLAzamihGWm/VIrRUpod0lq/61AzRLBUJ5NbuNFWUZ05lkkh9
   nSSTnaFc+smxouai10RDKGiVdoYzJSKRbWCCO6FlJzKxZfOm3jTGVzB5y
   84dun5HDdfsxHVk0sPq41Hyw8YiZ9cDMTGyF2HJEoJweJv/9Vaj0f/ehl
   g==;
X-CSE-ConnectionGUID: eXHAKzM5Ty6+zFY271Zvtg==
X-CSE-MsgGUID: hMGHxWcOTxKSlfnwEe417Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="42033297"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="42033297"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 21:14:07 -0800
X-CSE-ConnectionGUID: fQA3sH3PQSqWqeOLGAOP3A==
X-CSE-MsgGUID: kDnoeCr3Rl6N+jQwZCQX9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="89144608"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.120])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 21:14:01 -0800
Date: Wed, 6 Nov 2024 07:13:56 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
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
Message-ID: <Zyr7FA10pmLhZBxL@tlindgre-MOBL1>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-10-xiaoyao.li@intel.com>
 <1235bac6ffe7be6662839adb2630c1a97d1cc4c5.camel@intel.com>
 <c0ef6c19-756e-43f3-8342-66b032238265@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0ef6c19-756e-43f3-8342-66b032238265@intel.com>

On Wed, Nov 06, 2024 at 10:01:04AM +0800, Xiaoyao Li wrote:
> On 11/6/2024 4:51 AM, Edgecombe, Rick P wrote:
> > +Tony
> > 
> > On Tue, 2024-11-05 at 01:23 -0500, Xiaoyao Li wrote:
> > > +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
> > > +{
> > > +    X86CPU *x86cpu = X86_CPU(cpu);
> > > +    CPUX86State *env = &x86cpu->env;
> > > +    g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
> > > +    int r = 0;
> > > +
> > > +    QEMU_LOCK_GUARD(&tdx_guest->lock);
> > > +    if (tdx_guest->initialized) {
> > > +        return r;
> > > +    }
> > > +
> > > +    init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
> > > +                        sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
> > > +
> > > +    r = setup_td_xfam(x86cpu, errp);
> > > +    if (r) {
> > > +        return r;
> > > +    }
> > > +
> > > +    init_vm->cpuid.nent = kvm_x86_build_cpuid(env, init_vm->cpuid.entries, 0);
> > > +    tdx_filter_cpuid(&init_vm->cpuid);
> > > +
> > > +    init_vm->attributes = tdx_guest->attributes;
> > > +    init_vm->xfam = tdx_guest->xfam;
> > > +
> > > +    do {
> > > +        r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, init_vm);
> > > +    } while (r == -EAGAIN);
> > 
> > KVM_TDX_INIT_VM can also return EBUSY. This should check for it, or KVM should
> > standardize on one for both conditions. In KVM, both cases handle
> > TDX_RND_NO_ENTROPY, but one tries to save some of the initialization for the
> > next attempt. I don't know why userspace would need to differentiate between the
> > two cases though, which makes me think we should just change the KVM side.
> 
> I remember I tested retrying on the two cases and no surprise showed.
> 
> I agree to change KVM side to return -EAGAIN for the two cases.

OK yeah let's patch KVM for it.

Regards,

Tony

