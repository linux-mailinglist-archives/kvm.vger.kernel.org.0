Return-Path: <kvm+bounces-18226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1088D2244
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 19:16:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90C8D286AE2
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D18C174EC6;
	Tue, 28 May 2024 17:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kbJ0qTOC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3009823BF;
	Tue, 28 May 2024 17:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716916575; cv=none; b=K/qBG+xbL4JAi6YtFRMzavl6AregPi1nmZLqAn6kajdwS4WC6w2Pl+XhY/pwi0+X/acRV8gf6apGwtU8SZJKAyY7ac7mEKIuox3JDfeBifvk2s1zKbATwzCXiWAY1CMDwtYO6MzG65uJnE6ujkjDSkwzMEC/rLySlhho5RHyGJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716916575; c=relaxed/simple;
	bh=Or6uWrOuLzhTuj50EEBT2/wQLVqQ+kLlFEZ5TAS64OU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7/unHpvQIIjDnEx5l8szGM4r2aT+jGd6y/79nKAygkUHmNAHs4RTX1DRrPj6ua38jr6aaNX6Pcb8w41hYoARfLfmajbAPGlfLoIG9dma48HPNzNyFMVlZ5/QTnyC17Q1RTsN2jPJbDnlnv/20GVNjLhgzh9wxvWmRg68UOAlp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kbJ0qTOC; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716916574; x=1748452574;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Or6uWrOuLzhTuj50EEBT2/wQLVqQ+kLlFEZ5TAS64OU=;
  b=kbJ0qTOCGKHM6tdaLyV5F4hcRihzj3KBczoSyxk0kaxKRwAw4WanZ9N4
   mrMZE8bon4bwoqdiEQN9TJgnFQW+DGpizJ6XwAyjqvfVzA0nXUGgn/iJ3
   so72rPEs/LztZqAPEuJ878hRbnOiu+EprdRxWQ/ICo5TH3YYoULuzs5fG
   fY0UrmIobk9vLv2IIUbM9Bqbv+KSs8TbzbVrpodNQTZBqkGnt43Zd/d71
   1bvDWm4FlUIIkopUuqqY5QQW7l121tulOjyYegV1xtdIc4BKCiVw/0hQ5
   rdN7WwNphWQs98vQpQVUehLjvz0vNMpSeqgf3QDbMv70+5tWjWPS3FbrP
   w==;
X-CSE-ConnectionGUID: /X+oGZGVSiq8Qt02V4HLiQ==
X-CSE-MsgGUID: b6punY0qR0azhgYU3etFGg==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="24695126"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="24695126"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 10:16:13 -0700
X-CSE-ConnectionGUID: D57IhtI8QgW3uXhmkndhgQ==
X-CSE-MsgGUID: xuMfQJNMS/qeAGV5537ZFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="39646966"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 10:16:13 -0700
Date: Tue, 28 May 2024 10:16:12 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 105/130] KVM: TDX: handle KVM hypercall with
 TDG.VP.VMCALL
Message-ID: <20240528171612.GA454482@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ab54980da397e6e9b7b8d6636dc88c11c303364f.1708933498.git.isaku.yamahata@intel.com>
 <ZgvHXk/jiWzTrcWM@chao-email>
 <20240404012726.GP2444378@ls.amr.corp.intel.com>
 <8d489a08-784b-410d-8714-3c0ffc8dfb39@linux.intel.com>
 <20240417070240.GF3039520@ls.amr.corp.intel.com>
 <6a7b865f-9513-4dd2-9aff-e8f19dea6d90@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a7b865f-9513-4dd2-9aff-e8f19dea6d90@linux.intel.com>

On Mon, May 27, 2024 at 08:57:28AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 4/17/2024 3:02 PM, Isaku Yamahata wrote:
> > On Wed, Apr 17, 2024 at 02:16:57PM +0800,
> > Binbin Wu <binbin.wu@linux.intel.com> wrote:
> > 
> > > 
> > > On 4/4/2024 9:27 AM, Isaku Yamahata wrote:
> > > > On Tue, Apr 02, 2024 at 04:52:46PM +0800,
> > > > Chao Gao <chao.gao@intel.com> wrote:
> > > > 
> > > > > > +static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
> > > > > > +{
> > > > > > +	unsigned long nr, a0, a1, a2, a3, ret;
> > > > > > +
> > > > > do you need to emulate xen/hyper-v hypercalls here?
> > > > No. kvm_emulate_hypercall() handles xen/hyper-v hypercalls,
> > > > __kvm_emulate_hypercall() doesn't.
> > > So for TDX, kvm doesn't support xen/hyper-v, right?
> > > 
> > > Then, should KVM_CAP_XEN_HVM and KVM_CAP_HYPERV be filtered out for TDX?
> > That's right. We should update kvm_vm_ioctl_check_extension() and
> > kvm_vcpu_ioctl_enable_cap().  I didn't pay attention to them.
> Currently, QEMU checks the capabilities for Hyper-v/Xen via
> kvm_check_extension(), which is the global version.
> Only modifications in KVM can't hide these capabilities. It needs userspace
> to use VM or vCPU version to check the capabilities for Hyper-v and Xen.
> Is it a change of ABI when the old global version is still workable, but
> userspace switches to use VM/vCPU version to check capabilities for Hyper-v
> and Xen?
> Are there objections if both QEMU and KVM are modified in order to
> hide Hyper-v/Xen capabilities for TDX?

I think it's okay for KVM_X86_TDX_VM as long as we don't change the value for
KVM_X86_DEFAULT_VM.  Because vm_type KVM_X86_TDX_VM is different from the
default and the document (Documentation/virt/kvm/api.rst), 4.4
KVM_CHECK_EXTENSION explicitly encourages VM version.

  Based on their initialization different VMs may have different capabilities.
  It is thus encouraged to use the vm ioctl to query for capabilities (available
  with KVM_CAP_CHECK_EXTENSION_VM on the vm fd)

The change to qemu will be mostly trivial with the quick check.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

