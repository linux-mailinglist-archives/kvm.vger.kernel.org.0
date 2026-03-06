Return-Path: <kvm+bounces-72977-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sAB4LOpFqmnxOQEAu9opvQ
	(envelope-from <kvm+bounces-72977-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 04:11:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2252E21AEBE
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 04:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ABA1D30935CC
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 03:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B66F36BCF2;
	Fri,  6 Mar 2026 03:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GF+PvDyp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF70836BCD5
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 03:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772766571; cv=none; b=rKXSCF/AosT6D8N0Ldjoo3Lvu0VghelovMTeZTrwzBroFiqf4wfuKGXu1m5OTPdAZk5enhEHD+8F4wrtN3GjKNhT0m//8hRvTln1tlAiBvfF8gPi4b/KBamUUeA7W28UON7IBLSck1YZolUNutfuJHw/NrrjT7rwcw3C+VOQkxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772766571; c=relaxed/simple;
	bh=LYj3xVqXBi2J7Efjkcv9Cxc9JLd6L4uoKCTZQxPc7dU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J32KW/CdRlPLk12f7lQE2mRqsiBhzDJr0uyJpwfRtlfZpQe+sJkT46lt6LkSsSi4BEfj1auHfjTt46kpndWNeik1HxAdqrKLZa17EsgvUVUpKnFp9iBZ5yquS7ZgVQ3xahTe9W0MPjeBa/OE853b0M1w/ANYudMkWT7rQ+hYcKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GF+PvDyp; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772766568; x=1804302568;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LYj3xVqXBi2J7Efjkcv9Cxc9JLd6L4uoKCTZQxPc7dU=;
  b=GF+PvDyp5xLb9nQ3NQvMkkGd4r7iM5TI9gLPq/3YmNc9XJMByWjituKd
   IeDBW6lk/kgQ6/xn2E6dDxc4zlT/lRzu54MfFUhpI2vnLfcQHIicfswoN
   EOm7C/KSHzf6aNNFt5jeOTMI+WOCl9IHh/uVuocSoodzpWiNEbgjw2teq
   mGgT2dSlACTFcF780duOVNvd67QjfDvKvHaWOHEf/GDbgNKHiD0ZYL/pO
   HHL20Zx0/FkD77fcDA2I/BRsL87WLAhi0U6FGHCtC2i2gryEN6C9RmDrC
   higl1DABK3YV+hMUs2bnqpLs7FBHS908P4/QArPjiSsb/ztNLaFH4RlJz
   A==;
X-CSE-ConnectionGUID: Pn02MzhKQZqmZ8mi76xtUw==
X-CSE-MsgGUID: FNAbpoa0QA+u220MqcrG1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="84955008"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="84955008"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 19:09:27 -0800
X-CSE-ConnectionGUID: wZHDxNX4SF6XZRTor3gUtg==
X-CSE-MsgGUID: WB5o8Q1mTZ6+FiAh9AjHlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="219016666"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.241.147]) ([10.124.241.147])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 19:09:25 -0800
Message-ID: <198db4f2-4aec-4930-97bf-ed0c3418083e@linux.intel.com>
Date: Fri, 6 Mar 2026 11:09:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 06/13] target/i386: Increase MSR_BUF_SIZE and split
 KVM_[GET/SET]_MSRS calls
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
 <20260304180713.360471-7-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260304180713.360471-7-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2252E21AEBE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72977-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email]
X-Rspamd-Action: no action

LGTM. Thanks.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

On 3/5/2026 2:07 AM, Zide Chen wrote:
> Newer Intel server CPUs support a large number of PMU MSRs.  Currently,
> QEMU allocates cpu->kvm_msr_buf as a single-page buffer, which is not
> sufficient to hold all possible MSRs.
>
> Increase MSR_BUF_SIZE to 8192 bytes, providing space for up to 511 MSRs.
> This is sufficient even for the theoretical worst case, such as
> architectural LBR with a depth of 64.
>
> KVM_[GET/SET]_MSRS is limited to 255 MSRs per call.  Raising this limit
> to 511 would require changes in KVM and would introduce backward
> compatibility issues.  Instead, split requests into multiple
> KVM_[GET/SET]_MSRS calls when the number of MSRs exceeds the API limit.
>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
> v3:
> - Address Dapeng's comments.
> ---
>  target/i386/kvm/kvm.c | 110 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 92 insertions(+), 18 deletions(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 39a67c58ac22..4ba54151320f 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -97,9 +97,12 @@
>  #define KVM_APIC_BUS_CYCLE_NS       1
>  #define KVM_APIC_BUS_FREQUENCY      (1000000000ULL / KVM_APIC_BUS_CYCLE_NS)
>  
> -/* A 4096-byte buffer can hold the 8-byte kvm_msrs header, plus
> - * 255 kvm_msr_entry structs */
> -#define MSR_BUF_SIZE 4096
> +/* A 8192-byte buffer can hold the 8-byte kvm_msrs header, plus
> + * 511 kvm_msr_entry structs */
> +#define MSR_BUF_SIZE      8192
> +
> +/* Maximum number of MSRs in one single KVM_[GET/SET]_MSRS call. */
> +#define KVM_MAX_IO_MSRS   255
>  
>  typedef bool QEMURDMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t *val);
>  typedef bool QEMUWRMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t val);
> @@ -4016,21 +4019,99 @@ static void kvm_msr_entry_add_perf(X86CPU *cpu, FeatureWordArray f)
>      }
>  }
>  
> -static int kvm_buf_set_msrs(X86CPU *cpu)
> +static int __kvm_buf_set_msrs(X86CPU *cpu, struct kvm_msrs *msrs)
>  {
> -    int ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, cpu->kvm_msr_buf);
> +    int ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, msrs);
>      if (ret < 0) {
>          return ret;
>      }
>  
> -    if (ret < cpu->kvm_msr_buf->nmsrs) {
> -        struct kvm_msr_entry *e = &cpu->kvm_msr_buf->entries[ret];
> +    if (ret < msrs->nmsrs) {
> +        struct kvm_msr_entry *e = &msrs->entries[ret];
>          error_report("error: failed to set MSR 0x%" PRIx32 " to 0x%" PRIx64,
>                       (uint32_t)e->index, (uint64_t)e->data);
>      }
>  
> -    assert(ret == cpu->kvm_msr_buf->nmsrs);
> -    return 0;
> +    assert(ret == msrs->nmsrs);
> +    return ret;
> +}
> +
> +static int __kvm_buf_get_msrs(X86CPU *cpu, struct kvm_msrs *msrs)
> +{
> +    int ret;
> +
> +    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, msrs);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    if (ret < msrs->nmsrs) {
> +        struct kvm_msr_entry *e = &msrs->entries[ret];
> +        error_report("error: failed to get MSR 0x%" PRIx32,
> +                     (uint32_t)e->index);
> +    }
> +
> +    assert(ret == msrs->nmsrs);
> +    return ret;
> +}
> +
> +static int kvm_buf_set_or_get_msrs(X86CPU *cpu, bool is_write)
> +{
> +    struct kvm_msr_entry *entries = cpu->kvm_msr_buf->entries;
> +    struct kvm_msrs *buf = NULL;
> +    int current, remaining, ret = 0;
> +    size_t buf_size;
> +
> +    buf_size = KVM_MAX_IO_MSRS * sizeof(struct kvm_msr_entry) +
> +               sizeof(struct kvm_msrs);
> +    buf = g_malloc(buf_size);
> +
> +    remaining = cpu->kvm_msr_buf->nmsrs;
> +    current = 0;
> +    while (remaining) {
> +        size_t size;
> +
> +        memset(buf, 0, buf_size);
> +
> +        if (remaining > KVM_MAX_IO_MSRS) {
> +            buf->nmsrs = KVM_MAX_IO_MSRS;
> +        } else {
> +            buf->nmsrs = remaining;
> +        }
> +
> +        size = buf->nmsrs * sizeof(entries[0]);
> +        memcpy(buf->entries, &entries[current], size);
> +
> +        if (is_write) {
> +            ret = __kvm_buf_set_msrs(cpu, buf);
> +        } else {
> +            ret = __kvm_buf_get_msrs(cpu, buf);
> +        }
> +
> +        if (ret < 0) {
> +            goto out;
> +        }
> +
> +        if (!is_write)
> +            memcpy(&entries[current], buf->entries, size);
> +
> +        current += buf->nmsrs;
> +        remaining -= buf->nmsrs;
> +    }
> +
> +out:
> +    g_free(buf);
> +    return ret < 0 ? ret : cpu->kvm_msr_buf->nmsrs;
> +}
> +
> +static inline int kvm_buf_set_msrs(X86CPU *cpu)
> +{
> +    return kvm_buf_set_or_get_msrs(cpu, true);
> +}
> +
> +static inline int kvm_buf_get_msrs(X86CPU *cpu)
> +{
> +    return kvm_buf_set_or_get_msrs(cpu, false);
>  }
>  
>  static void kvm_init_msrs(X86CPU *cpu)
> @@ -4066,7 +4147,7 @@ static void kvm_init_msrs(X86CPU *cpu)
>      if (has_msr_ucode_rev) {
>          kvm_msr_entry_add(cpu, MSR_IA32_UCODE_REV, cpu->ucode_rev);
>      }
> -    assert(kvm_buf_set_msrs(cpu) == 0);
> +    kvm_buf_set_msrs(cpu);
>  }
>  
>  static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
> @@ -4959,18 +5040,11 @@ static int kvm_get_msrs(X86CPU *cpu)
>          }
>      }
>  
> -    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, cpu->kvm_msr_buf);
> +    ret = kvm_buf_get_msrs(cpu);
>      if (ret < 0) {
>          return ret;
>      }
>  
> -    if (ret < cpu->kvm_msr_buf->nmsrs) {
> -        struct kvm_msr_entry *e = &cpu->kvm_msr_buf->entries[ret];
> -        error_report("error: failed to get MSR 0x%" PRIx32,
> -                     (uint32_t)e->index);
> -    }
> -
> -    assert(ret == cpu->kvm_msr_buf->nmsrs);
>      /*
>       * MTRR masks: Each mask consists of 5 parts
>       * a  10..0: must be zero

