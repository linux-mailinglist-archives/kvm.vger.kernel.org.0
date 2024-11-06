Return-Path: <kvm+bounces-30908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8250A9BE3D0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:11:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B462A1C23A9F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE951DD537;
	Wed,  6 Nov 2024 10:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mqkiNwNK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FF11D358B;
	Wed,  6 Nov 2024 10:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887896; cv=none; b=gcP64JU6h6/73rAAOziFzya/PwepxZ8aZzPUxFAzNeYZQMVNphZa7ywdFgdr7jKPOCxpMSpyn8ubrlpFskuM0EMw2bFgK/1vVJ/VCNA3xxX7cQEB8UQaOm5cfeJPYFVmDnVfSZzux1x3wA7c8zTnk1yxPB9ikmOgj3CMPVLApz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887896; c=relaxed/simple;
	bh=mBTlHkqIDGFgtXS3zzd4nGQ9onIhlkOH7JjqrhQRUfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dGRfVuqYsWb1nh8XzxVTO7+5BkAZ5hp07AbPxrl/JWSUcLCWRBPLidDIsrMr/hZh+SYfJSqYwIcbPnvPuIDqxRcG3KaiyS3IWHtdgKFAWmNFz/XoS38HF8SXLk+gdlD0wqvup2/xK1xHfzXkZEpvXFQZWCrHYaoFScKcXuPQAAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mqkiNwNK; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730887895; x=1762423895;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mBTlHkqIDGFgtXS3zzd4nGQ9onIhlkOH7JjqrhQRUfw=;
  b=mqkiNwNKPmlbErZBYjVMMufeJHDUqZ0j36BJZWtKpf4r1PLuX2UY6aHU
   Y+NqfFTapDIKxBv40UJNjlhQihMC9llQzcvst8zSUV+qIaZFSGNhfFN8/
   7fpBXU88FYmJ+3O7VqUZ3X2KLvBVFBifqZ0YPi7FhXPQpl35fB/2s19vL
   2joGA4ymPiJiU6nXnlEVaIU6dLXdpJ6mlAIi5++xCR4L3ng7w/YHkBKXQ
   RddLCNOKaevcetY91C0KBpSALhGQKZL5DIZS42zozXjcDxR7yggXwggpN
   kXL3AUiQ7o+VDR6xB7cSdGB+u62QdlA1Xqcpsr+Hjl/mUnm1IPt9HfN5X
   A==;
X-CSE-ConnectionGUID: IArztv/hR6eNYr5Bd8SSmw==
X-CSE-MsgGUID: U8H2w3VBTjGil1x3QjH57A==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="41270042"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="41270042"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:11:34 -0800
X-CSE-ConnectionGUID: zezsPG9dR+WhQ2X6CUPDrA==
X-CSE-MsgGUID: /uCg8RrIRF2KiWmRxgt9Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="89302190"
Received: from unknown (HELO [10.238.12.149]) ([10.238.12.149])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:11:32 -0800
Message-ID: <b7fd2ddf-77a4-423c-b5cf-36505997990d@linux.intel.com>
Date: Wed, 6 Nov 2024 18:11:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com>
 <ZyKbxTWBZUdqRvca@google.com>
 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
 <ZyLWMGcgj76YizSw@google.com>
 <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
 <ZyUEMLoy6U3L4E8v@google.com>
 <f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com>
 <95c92ff265cfa48f5459009d48a161e5cbe7ab3d.camel@intel.com>
 <ZymDgtd3VquVwsn_@google.com>
 <662b4aa037bfd5e8f3653a833b460f18636e2bc1.camel@intel.com>
 <cef7b663-bc6d-44a1-9d5e-736aa097ea68@linux.intel.com>
 <e2c19b20b11c307cc6b4ae47cd7f891e690b419b.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <e2c19b20b11c307cc6b4ae47cd7f891e690b419b.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 11/6/2024 4:54 PM, Huang, Kai wrote:
> On Wed, 2024-11-06 at 16:32 +0800, Binbin Wu wrote:
>>> static void kvm_complete_hypercall_exit(struct kvm_vcpu *vcpu, int ret_reg,
>>>   				        unsigned long ret, bool op_64_bit)
>>> {
>>>   	if (!op_64_bit)
>>>   		ret = (u32)ret;
>>>   	kvm_register_write_raw(vcpu, ret_reg, ret);
>>>   	++vcpu->stat.hypercalls;
>>> }
>> If this is going to be the final version, it would be better to make it
>> public, and export the symbol, so that TDX code can reuse it.
> Does making it 'static inline' and moving to kvm_host.h work?
It doesn't have a complete definition of struct kvm_vcpu in
arch/x86/include/asm/kvm_host.h, and the code is dereferencing
struct kvm_vcpu.
Also, the definition of kvm_register_write_raw() is in
arch/x86/kvm/kvm_cache_regs.h, which make it difficult to be called
there.

>
> kvm_register_write_raw(), and kvm_register_mark_dirty() which is called by
> kvm_register_write_raw()), are both 'static inline'.  Seems we can get rid of
> export by making it 'static inline'.


