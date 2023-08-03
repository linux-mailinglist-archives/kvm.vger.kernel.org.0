Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CED76F490
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 23:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjHCVQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 17:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbjHCVQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 17:16:30 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94958211E
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 14:16:07 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qRffv-001Wdx-MG; Thu, 03 Aug 2023 23:16:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=o6ADhGBGatE7+sdmfROO7/jkQ1U913VY/QN0h5fzE7s=; b=Tr7hKSiXqF5rtxfKWGv+x00t0h
        5xOsY9ZJtOx/hFRey8TbRAkVcpC1W9Ohmp3qILCABtsyo4PbFOWm/OcwYSvWjOP2O0cIe2a5+b9KQ
        od6KQooF4xwzBKknj+CGN1OT/goBxxtAhTprUh34Yy64ptXc33kz8UQl532o7xz8VZe/ZAEIlZtur
        NFHp3cKscfhHgEPKFL9or+3XRMxtc31Rk1vhIzqWJ3IElGCmnXChvd5Amc5JPiz7xyjlGjr0qqJ9H
        vU7dNIeVd3c2NVS1u3qF9Q8qA7v2xiUau0VbpDUH6K6JO18XTIiAuhuYzxat1WSDhZlR8eNrvPSy/
        Vok5608A==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qRffo-0000Xz-KM; Thu, 03 Aug 2023 23:15:58 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qRffc-00041W-47; Thu, 03 Aug 2023 23:15:44 +0200
Message-ID: <8adb2f2b-df9c-3e49-3bdd-7970d918a1d0@rbox.co>
Date:   Thu, 3 Aug 2023 23:15:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU
 issues
Content-Language: pl-PL, en-GB
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, shuah@kernel.org
References: <20230728001606.2275586-1-mhal@rbox.co>
 <20230728001606.2275586-2-mhal@rbox.co> <ZMhIlj+nUAXeL91B@google.com>
 <7e24e0b1-d265-2ac0-d411-4d6f4f0c1383@rbox.co> <ZMqr/A1O4PPbKfFz@google.com>
 <38f69410-d794-6eae-387a-481417c6b323@rbox.co>
 <e55656be-2752-a317-80eb-ad40e474b62f@redhat.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <e55656be-2752-a317-80eb-ad40e474b62f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/23 19:48, Paolo Bonzini wrote:
> On 8/3/23 02:13, Michal Luczaj wrote:
>> Anyway, while there, could you take a look at __set_sregs_common()?
>>
>> 	*mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
>> 	static_call(kvm_x86_set_cr0)(vcpu, sregs->cr0);
>> 	vcpu->arch.cr0 = sregs->cr0;
>>
>> That last assignment seems redundant as both vmx_set_cr0() and svm_set_cr0()
>> take care of it, but I may be missing something (even if selftests pass with
>> that line removed).
> 
> kvm_set_cr0 assumes that the static call sets vcpu->arch.cr0, so indeed 
> it can be removed:

I guess the same can be done in enter_smm()?

	cr0 = vcpu->arch.cr0 & ~(X86_CR0_PE | X86_CR0_EM | X86_CR0_TS | X86_CR0_PG);
	static_call(kvm_x86_set_cr0)(vcpu, cr0);
	vcpu->arch.cr0 = cr0;

> Neither __set_sregs_common nor its callers does not call 
> kvm_post_set_cr0...  Not great, even though most uses of KVM_SET_SREGS 
> are probably limited to reset in most "usual" VMMs.  It's probably 
> enough to replace this line:
> 
>          *mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
> 
> with a call to the function just before __set_sregs_common returns.

What about kvm_post_set_cr4() then? Should it be introduced to
__set_sregs_common() as well?

thanks,
Michal

