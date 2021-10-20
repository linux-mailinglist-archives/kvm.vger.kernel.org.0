Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C8843485D
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 11:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhJTJ4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 05:56:30 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:49129 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229639AbhJTJ4a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 05:56:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Ut1RDyh_1634723653;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Ut1RDyh_1634723653)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Oct 2021 17:54:14 +0800
Subject: Re: [PATCH 1/4] KVM: X86: Fix tlb flush for tdp in
 kvm_invalidate_pcid()
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
 <20211019110154.4091-2-jiangshanlai@gmail.com> <YW7jfIMduQti8Zqk@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <da4dfc96-b1ad-024c-e769-29d3af289eee@linux.alibaba.com>
Date:   Wed, 20 Oct 2021 17:54:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YW7jfIMduQti8Zqk@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/10/19 23:25, Sean Christopherson wrote:

> 
> 	/*
> 	 * MOV CR3 and INVPCID are usually not intercepted when using TDP, but
> 	 * this is reachable when running EPT=1 and unrestricted_guest=0,  and
> 	 * also via the emulator.  KVM's TDP page tables are not in the scope of
> 	 * the invalidation, but the guest's TLB entries need to be flushed as
> 	 * the CPU may have cached entries in its TLB for the target PCID.
> 	 */

Thanks! It is a better description.

I just read some interception policy in vmx.c, if EPT=1 but vmx_need_pf_intercept()
return true for some reasons/configs, #PF is intercepted.  But CR3 write is not
intercepted, which means there will be an EPT fault _after_ (IIUC) the CR3 write if
the GPA of the new CR3 exceeds the guest maxphyaddr limit.  And kvm queues a fault to
the guest which is also _after_ the CR3 write, but the guest expects the fault before
the write.

IIUC, it can be fixed by intercepting CR3 write or reversing the CR3 write in EPT
violation handler.

Thanks
Lai.
