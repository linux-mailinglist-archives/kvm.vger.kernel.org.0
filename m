Return-Path: <kvm+bounces-30829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 078BA9BDBB9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBC24283932
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD4D18DF83;
	Wed,  6 Nov 2024 02:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m0XIgyQA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F76818950A
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730858478; cv=none; b=qtuoug5nhgOxDfH9R1w/7CgTn66tKjcAAhIVW+dfHQBAaXlSgYQDwVda+Y/j1tqrChnenVtuVETBOiZIVEEelKOf/g9B2KOQicrQ6gn+Om1dI+EFLQX2ZbPNPHqZZHyMZUso5jMAQyFMjP+HCqRCBIfrCKjZuqPghUJ6W7eCCak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730858478; c=relaxed/simple;
	bh=OCdsTvS2i4OgPF2aSQUzB0Sr7iZca5HzkvtLjQfKFAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=otG3shH2mLbCuiXIjDY31CpvBFL2lzHGUNpnDZkKq3wX1N+7NwPosAqp6tthJWlxgWB3YC1HIELB3KNojJgIkd6wErgtWP/oMawXTll+F2Vd7qkCewoXzg4C16Q/El92xZQ3QBoTkkzjX6Uh+K535CnIgbhJZ37exU12G7yEYjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m0XIgyQA; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730858477; x=1762394477;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OCdsTvS2i4OgPF2aSQUzB0Sr7iZca5HzkvtLjQfKFAA=;
  b=m0XIgyQAEhWoUqhQNkONzNNZm2jn/RiPw6mYfjbVZpnyuhj6NuuphNTs
   JzMvTHh+vbZFjLvhxvcaIIcQx6xeKCRB87cNZZF/l4cWBbLp+PS/EtuMf
   Il/5oE9Vr9qPxcKnNSTa1AV82ETJ55AOC99c8fZKRbXFlT8dFHEUeClg4
   vfJN9aqT/7HqLevNfJJrukGNvZI6+FsL6X54ZqtmDS7n16tt31MIrsYZX
   oApxdz9Lalq2EOKVvMhnm+ASPWvIrzZFBSXgWZTbcYwoMv+Wikc74YAtc
   2PRe82J0mNcKSFC1n4STUhPbaccWNbY/69SznfJkCuRUTjB0jM+0zu7tm
   w==;
X-CSE-ConnectionGUID: Z62S3cWYRu+gD1qxVifp1Q==
X-CSE-MsgGUID: umYKm2F6Se+RfPjWNLn77A==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="34564869"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="34564869"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:01:12 -0800
X-CSE-ConnectionGUID: 8hAthuPTRTeD8o14Dc9J/Q==
X-CSE-MsgGUID: oSaLmyWZRhyhjp8Sy642cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="84213238"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:01:07 -0800
Message-ID: <c0ef6c19-756e-43f3-8342-66b032238265@intel.com>
Date: Wed, 6 Nov 2024 10:01:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/60] i386/tdx: Initialize TDX before creating TD
 vcpus
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "riku.voipio@iki.fi" <riku.voipio@iki.fi>,
 "imammedo@redhat.com" <imammedo@redhat.com>, "Liu, Zhao1"
 <zhao1.liu@intel.com>,
 "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
 "anisinha@redhat.com" <anisinha@redhat.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "mst@redhat.com" <mst@redhat.com>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>
Cc: "armbru@redhat.com" <armbru@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "mtosatti@redhat.com" <mtosatti@redhat.com>,
 "eblake@redhat.com" <eblake@redhat.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "wangyanan55@huawei.com" <wangyanan55@huawei.com>,
 "berrange@redhat.com" <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-10-xiaoyao.li@intel.com>
 <1235bac6ffe7be6662839adb2630c1a97d1cc4c5.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <1235bac6ffe7be6662839adb2630c1a97d1cc4c5.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/6/2024 4:51 AM, Edgecombe, Rick P wrote:
> +Tony
> 
> On Tue, 2024-11-05 at 01:23 -0500, Xiaoyao Li wrote:
>> +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>> +{
>> +    X86CPU *x86cpu = X86_CPU(cpu);
>> +    CPUX86State *env = &x86cpu->env;
>> +    g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
>> +    int r = 0;
>> +
>> +    QEMU_LOCK_GUARD(&tdx_guest->lock);
>> +    if (tdx_guest->initialized) {
>> +        return r;
>> +    }
>> +
>> +    init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>> +                        sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
>> +
>> +    r = setup_td_xfam(x86cpu, errp);
>> +    if (r) {
>> +        return r;
>> +    }
>> +
>> +    init_vm->cpuid.nent = kvm_x86_build_cpuid(env, init_vm->cpuid.entries, 0);
>> +    tdx_filter_cpuid(&init_vm->cpuid);
>> +
>> +    init_vm->attributes = tdx_guest->attributes;
>> +    init_vm->xfam = tdx_guest->xfam;
>> +
>> +    do {
>> +        r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, init_vm);
>> +    } while (r == -EAGAIN);
> 
> KVM_TDX_INIT_VM can also return EBUSY. This should check for it, or KVM should
> standardize on one for both conditions. In KVM, both cases handle
> TDX_RND_NO_ENTROPY, but one tries to save some of the initialization for the
> next attempt. I don't know why userspace would need to differentiate between the
> two cases though, which makes me think we should just change the KVM side.

I remember I tested retrying on the two cases and no surprise showed.

I agree to change KVM side to return -EAGAIN for the two cases.

>> +    if (r < 0) {
>> +        error_setg_errno(errp, -r, "KVM_TDX_INIT_VM failed");
>> +        return r;
>> +    }
>> +
>> +    tdx_guest->initialized = true;
>> +
>> +    return 0;
>> +}
> 


