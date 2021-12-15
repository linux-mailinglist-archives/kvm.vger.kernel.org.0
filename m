Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43591475DB6
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 17:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhLOQnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 11:43:10 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:44189 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231801AbhLOQnJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 11:43:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0V-jf2Ei_1639586585;
Received: from 30.32.64.86(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0V-jf2Ei_1639586585)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 16 Dec 2021 00:43:07 +0800
Message-ID: <73990f49-bb72-5f73-06e4-667d92a94408@linux.alibaba.com>
Date:   Thu, 16 Dec 2021 00:43:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 11/15] KVM: VMX: Update vmcs.GUEST_CR3 only when the guest
 CR3 is dirty
Content-Language: en-US
From:   Lai Jiangshan <laijs@linux.alibaba.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211108124407.12187-12-jiangshanlai@gmail.com>
 <0271da9d3a7494d9e7439d4b8d6d9c857c83a45e.camel@redhat.com>
 <604709fa-e8bd-4eb6-6b79-8bf031a785ce@linux.alibaba.com>
In-Reply-To: <604709fa-e8bd-4eb6-6b79-8bf031a785ce@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/12/16 00:31, Lai Jiangshan wrote:

> 
> What I missed is the case of "if (!enable_unrestricted_guest && !is_paging(vcpu))"
> in vmx_load_mmu_pgd() which doesn't load GUEST_CR3 but clears dirty of VCPU_EXREG_CR3
> (when after next run).

Oops.

What I missed is the case of "if (!enable_unrestricted_guest && !is_paging(vcpu))"
in vmx_load_mmu_pgd() which doesn't load GUEST_CR3 with the guest cr3 and
VCPU_EXREG_CR3 dirty bit is cleared after VMEXIT.  When !PG -> PG, GUEST_CR3 is
still the ept_identity_map_addr, and VCPU_EXREG_CR3 dirty bit is not set, so
vmx_load_mmu_pgd() doesn't update GUEST_CR3.


> So when CR0 !PG -> PG, VCPU_EXREG_CR3 dirty bit should be set.
> 
