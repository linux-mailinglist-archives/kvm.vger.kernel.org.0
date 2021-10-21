Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F794358A7
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 04:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhJUCeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 22:34:50 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:55915 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229842AbhJUCet (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 22:34:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0Ut5VQir_1634783550;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Ut5VQir_1634783550)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 21 Oct 2021 10:32:31 +0800
Subject: Re: [PATCH 3/4] KVM: X86: Use smp_rmb() to pair with smp_wmb() in
 mmu_try_to_unsync_pages()
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
 <20211019110154.4091-4-jiangshanlai@gmail.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <4192556d-8890-d94b-d03d-23922ff1674c@linux.alibaba.com>
Date:   Thu, 21 Oct 2021 10:32:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019110154.4091-4-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Junaid Shahid

Any comments on the patch?  I may have been misunderstanding many things and I
have been often.

thanks
Lai

On 2021/10/19 19:01, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> The commit 578e1c4db2213 ("kvm: x86: Avoid taking MMU lock in
> kvm_mmu_sync_roots if no sync is needed") added smp_wmb() in
> mmu_try_to_unsync_pages(), but the corresponding smp_load_acquire()
> isn't used on the load of SPTE.W which is impossible since the load of
> SPTE.W is performed in the CPU's pagetable walking.
> 
> This patch changes to use smp_rmb() instead.  This patch fixes nothing
> but just comments since smp_rmb() is NOP and compiler barrier() is not
> required since the load of SPTE.W is before VMEXIT.
> 
> Cc: Junaid Shahid <junaids@google.com>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
