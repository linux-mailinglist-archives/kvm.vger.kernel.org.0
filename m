Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9319F46FDD7
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbhLJJiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:38:16 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:40596 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230296AbhLJJiQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 04:38:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0V-93KLN_1639128875;
Received: from 30.22.113.127(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0V-93KLN_1639128875)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Dec 2021 17:34:37 +0800
Message-ID: <9dcd7f1d-609d-c9f4-bcb1-c5e465383722@linux.alibaba.com>
Date:   Fri, 10 Dec 2021 17:34:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Subject: Re: [PATCH 1/12] KVM: X86: Fix when shadow_root_level=5 && guest
 root_level<4
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
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
 <20211124122055.64424-2-jiangshanlai@gmail.com> <YbFY533IT3XSIqAK@google.com>
Content-Language: en-US
In-Reply-To: <YbFY533IT3XSIqAK@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/12/9 09:16, Sean Christopherson wrote:
> On Wed, Nov 24, 2021, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> If the is an L1 with nNPT in 32bit, the shadow walk starts with
>> pae_root.
>>
>> Fixes: a717a780fc4e ("KVM: x86/mmu: Support shadowing NPT when 5-level paging is enabled in host)
> 
> Have you actually run with 5-level nNPT?  I don't have access to hardware, at least
> not that I know of :-)

The code is just obvious incorrect for shadow_root_level=5 && guest root_level<4.

> 
> I'm staring at kvm_mmu_sync_roots() and don't see how it can possibly work for
> 5-level nNPT with a 4-level NPT guest.
> 

It doesn't use pml5_root for 5-level nNPT with a 4-level NPT guest, so
kvm_mmu_sync_roots() can work in a silence way with an "unexpected" root shadow
page.  It has problems for 5-level nNPT with a 4-level NPT guest.

See:
https://lore.kernel.org/lkml/20211210092508.7185-1-jiangshanlai@gmail.com/

especially patch4.

Your this reply motivated me to complete the changelog of a patchset and send
it, thanks!

Although the patchset is immature, it would be better than losing it.

