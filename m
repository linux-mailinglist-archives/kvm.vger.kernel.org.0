Return-Path: <kvm+bounces-70706-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AO4qI5zXimnrOAAAu9opvQ
	(envelope-from <kvm+bounces-70706-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:00:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BC92117988
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:00:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 40B673028EF7
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85FDB32E73D;
	Tue, 10 Feb 2026 06:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dGohdTx3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4725E32692D
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 06:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770706667; cv=none; b=myZScOtlsbbWCnZ/37Ur8BsqZFvxl9VEVnXyTca6mLangkIRrftsmFIgnW/V/f0+oIlbQZlPUz293awb7+GY9wVDLBWrXTI+d0vfYUj6/tdFfMrF97QwvdDhT1f1zHw+3hSVs8fTOFUHX/QjklEVm5achJYk6oU5+A+PlDqX8cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770706667; c=relaxed/simple;
	bh=3IVJkycU5hEphx7Ql2+tJjdu+UWIEVQMVzOp9oBWOhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDl5a0DXGKaqsJ6GXrwdBNjjpSVIzYOb4OqjT92Pf/sIxQ13LozNx4wawgnB3QhgtbBnpm5qCYjokixkzpE8zk4qqzCDyQShf0BtSPm4rB6cjIAyvGBRfqADXHAnHhUht+u2PDeA1TF+wxVKJRW4ws7diEGcHZruA1i7pLeehbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dGohdTx3; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770706666; x=1802242666;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3IVJkycU5hEphx7Ql2+tJjdu+UWIEVQMVzOp9oBWOhY=;
  b=dGohdTx3XH+zc2rrGj4Q0VxmQBTGUpsniaFzDdghMO8h/Gb1VGvLNu/g
   /It3RGIign5zc/b2SXLFs4rInwKOkyIWUY0LkjXEACWzSHKUjH5B/N/Q3
   jETAyzfoh7zCk9JyYJ+3kcmUTOPPvjeaxS97XjBbBgzI3JFSJ7NtosPbN
   8dtRIwO0BKhIoVFX46NagNJrD/EfuM3m2jeDQiTskxaK697ZKDOD5FfLK
   ZI8oHm8t5BcY4VOIO/+RyS+9VeeYQe/YGTEMpiM1YrOSFtVUQIB+QdVgC
   bcF/mV6ME9wVV+904TA9xd3shHO6nzOAg5ntG8rhcVZXrUacSkoiWnONP
   w==;
X-CSE-ConnectionGUID: yWJ8sZcMSnGBIhET/rZ7sQ==
X-CSE-MsgGUID: i7nsJwbzTpO5fy0IJPMcfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="83198781"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="83198781"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 22:57:45 -0800
X-CSE-ConnectionGUID: uCnxIYa7R/+7I7o3xiyebQ==
X-CSE-MsgGUID: u3CkQEc9SL2mean7Vs3S5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211365351"
Received: from qianm-mobl2.ccr.corp.intel.com (HELO [10.238.1.184]) ([10.238.1.184])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 22:57:43 -0800
Message-ID: <9ac55e27-7667-4b4a-a4bc-b0bdafdbb3b1@linux.intel.com>
Date: Tue, 10 Feb 2026 14:57:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 05/11] target/i386: Increase MSR_BUF_SIZE and split
 KVM_[GET/SET]_MSRS calls
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260128231003.268981-1-zide.chen@intel.com>
 <20260128231003.268981-6-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260128231003.268981-6-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,linux.intel.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70706-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 0BC92117988
X-Rspamd-Action: no action


On 1/29/2026 7:09 AM, Zide Chen wrote:
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
> V2:
> - No changes.
>
>  target/i386/kvm/kvm.c | 109 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 92 insertions(+), 17 deletions(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 530f50e4b218..a2cf9b5df35d 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -98,9 +98,12 @@
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
> @@ -3878,23 +3881,102 @@ static void kvm_msr_entry_add_perf(X86CPU *cpu, FeatureWordArray f)
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
> +static int kvm_buf_set_msrs(X86CPU *cpu)

Better add inline.


> +{
> +    kvm_buf_set_or_get_msrs(cpu, true);
>      return 0;

why not directly return the return value of kvm_buf_set_or_get_msrs().


>  }
>  
> +static int kvm_buf_get_msrs(X86CPU *cpu)

inline.

Others look good to me.


> +{
> +    return kvm_buf_set_or_get_msrs(cpu, false);
> +}
> +
>  static void kvm_init_msrs(X86CPU *cpu)
>  {
>      CPUX86State *env = &cpu->env;
> @@ -3928,7 +4010,7 @@ static void kvm_init_msrs(X86CPU *cpu)
>      if (has_msr_ucode_rev) {
>          kvm_msr_entry_add(cpu, MSR_IA32_UCODE_REV, cpu->ucode_rev);
>      }
> -    assert(kvm_buf_set_msrs(cpu) == 0);
> +    kvm_buf_set_msrs(cpu);
>  }
>  
>  static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
> @@ -4746,18 +4828,11 @@ static int kvm_get_msrs(X86CPU *cpu)
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

