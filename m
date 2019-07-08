Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7093461AEE
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 09:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfGHHJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 03:09:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:33901 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbfGHHJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 03:09:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 00:09:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,465,1557212400"; 
   d="scan'208";a="167593116"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.129.57]) ([10.238.129.57])
  by orsmga003.jf.intel.com with ESMTP; 08 Jul 2019 00:09:01 -0700
Subject: Re: [PATCH 5/5] KVM: cpuid: remove has_leaf_count from struct
 kvm_cpuid_param
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190704140715.31181-1-pbonzini@redhat.com>
 <20190704140715.31181-6-pbonzini@redhat.com>
From:   Jing Liu <jing2.liu@linux.intel.com>
Message-ID: <bb5e81f4-bb34-2841-0fa1-63876b97e54c@linux.intel.com>
Date:   Mon, 8 Jul 2019 15:09:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704140715.31181-6-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 7/4/2019 10:07 PM, Paolo Bonzini wrote:
> The has_leaf_count member was originally added for KVM's paravirtualization
> CPUID leaves.  However, since then the leaf count _has_ been added to those
> leaves as well, so we can drop that special case.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[...]
> @@ -835,11 +834,10 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>   	int limit, nent = 0, r = -E2BIG, i;
>   	u32 func;
>   	static const struct kvm_cpuid_param param[] = {
> -		{ .func = 0, .has_leaf_count = true },
> -		{ .func = 0x80000000, .has_leaf_count = true },
> -		{ .func = 0xC0000000, .qualifier = is_centaur_cpu, .has_leaf_count = true },
> +		{ .func = 0 },
> +		{ .func = 0x80000000 },
> +		{ .func = 0xC0000000, .qualifier = is_centaur_cpu },

>   		{ .func = KVM_CPUID_SIGNATURE },
> -		{ .func = KVM_CPUID_FEATURES },

It seems the two func are introduced by 2b5e97e, as paravirtual cpuid.
But when searching KVM_CPUID_SIGNATURE, there seems no caller requesting
this cpuid. Meanwhile, I felt curious if KVM_CPUID_FEATURES is still in 
use but it seems kvm_update_cpuid() uses that. Not sure which spec 
introduces the latest pv cpuid.

Thanks,
Jing

[...]
