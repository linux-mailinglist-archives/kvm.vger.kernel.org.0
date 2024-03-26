Return-Path: <kvm+bounces-12714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12FCA88CB48
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 18:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD1621F2FC5E
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 17:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60683763E6;
	Tue, 26 Mar 2024 17:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fsDoUcEu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC631CD31;
	Tue, 26 Mar 2024 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711475343; cv=none; b=IZBTNh2gPEX8ybu1nihldfw20Ju6Pkpgac6QJGBfKneX3OPp3myjtRnCkIi6vdWUTimvcDwzIoDi19p4OCDZKgQTSkiG4ustsQBd3D7B44pPXmwA1ME1j31VqLvcX7SL/J7+eWCVgrs1GAe6C929J28MhF/gzvn0NJMkpaoEnz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711475343; c=relaxed/simple;
	bh=x0X3KIjo28KMgDBY7G4N3EMgX+0BDWgru26mZ2+VhDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ixq5cOqFMgQvS18dn5eJ7r67A0FjwuyP7gSFKBAz3p+Kyk29c2Poteky6jv0M7TX347Zu7s/6ugbfHLhk35rvfict1IILo6TnrmEoNDl16q8Vt2/tVBd0SIky/e/yeddV93nqnUoDE2V0WOLozKxYFVF7nqcm/ydLIO/UPPBIrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fsDoUcEu; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711475342; x=1743011342;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=x0X3KIjo28KMgDBY7G4N3EMgX+0BDWgru26mZ2+VhDo=;
  b=fsDoUcEuyeAYt94FCd7K2Cb4hkRIhdBRnQnasbGyOEU1kEfVvozZkqCB
   Q9nFg4Ze3DGnVJFEyoNr7aWPKg9gDMnWDnn429kptwZ4fIrR/aw4YxPQA
   nb1j38hSKnv6kbnIo5/AXZ10K8EiW4BJUvhekJZVBEpX8qEJ5sNn4VLfi
   wFRmZCchnThQff83gORbs/98TPgTLhhRQlVrpOIcOhbjdXSv2zV105X3n
   Y0T+gRo06wR1oF0fAiLcHlrY/uWfkWS5RnB5yTR5c4u3zAd4x152KO7Av
   bhKl26ZYPM8Tv4/CNcFtf7LBZeslsgx4bC9Gwk635F9GeDojOeW6wWc8c
   Q==;
X-CSE-ConnectionGUID: fL5uzmBxSfahbE/0TFvSrg==
X-CSE-MsgGUID: zrRDr491SHOqt5KaU5elOQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6650937"
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="6650937"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 10:49:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="53498965"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 10:49:01 -0700
Date: Tue, 26 Mar 2024 10:48:59 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20240326174859.GB2444378@ls.amr.corp.intel.com>
References: <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
 <20240325190525.GG2357401@ls.amr.corp.intel.com>
 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
 <20240325221836.GO2357401@ls.amr.corp.intel.com>
 <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
 <ZgIzvHKobT2K8LZb@chao-email>
 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
 <ZgKt6ljcmnfSbqG/@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZgKt6ljcmnfSbqG/@chao-email>

On Tue, Mar 26, 2024 at 07:13:46PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Tue, Mar 26, 2024 at 10:42:36AM +0800, Edgecombe, Rick P wrote:
> >On Tue, 2024-03-26 at 10:32 +0800, Chao Gao wrote:
> >> > > > Something like this for "112/130 KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall"
> >> > > > Compile only tested at this point.
> >> > > 
> >> > > Seems reasonable to me. Does QEMU configure a special set of MSRs to filter for TDX currently?
> >> > 
> >> > No for TDX at the moment.  We need to add such logic.
> >> 
> >> What if QEMU doesn't configure the set of MSRs to filter? In this case, KVM
> >> still needs to handle the MSR accesses.
> >
> >Do you see a problem for the kernel? I think if any issues are limited to only the guest, then we
> >should count on userspace to configure the msr list.
> 
> How can QEMU handle MTRR MSR accesses if KVM exits to QEMU? I am not sure if
> QEMU needs to do a lot of work to virtualize MTRR.

The default kernel logic will to return error for
TDG.VP.VMCALL<RDMSR or WRMSR MTRR registers>.
Qemu can have mostly same in the current kernel logic.

rdmsr:
MTRRCAP: 0
MTRRDEFTYPE: MTRR_TYPE_WRBACK

wrmsr:
MTRRDEFTYPE: If write back, nop. Otherwise error.


> If QEMU doesn't configure the msr filter list correctly, KVM has to handle
> guest's MTRR MSR accesses. In my understanding, the suggestion is KVM zap
> private memory mappings. But guests won't accept memory again because no one
> currently requests guests to do this after writes to MTRR MSRs. In this case,
> guests may access unaccepted memory, causing infinite EPT violation loop
> (assume SEPT_VE_DISABLE is set). This won't impact other guests/workloads on
> the host. But I think it would be better if we can avoid wasting CPU resource
> on the useless EPT violation loop.

Qemu is expected to do it correctly.  There are manyways for userspace to go
wrong.  This isn't specific to MTRR MSR.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

