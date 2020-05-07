Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43EE1C948B
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 17:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgEGPNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 11:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgEGPNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 11:13:31 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95836208D6;
        Thu,  7 May 2020 15:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588864410;
        bh=k29A0IdfLiHWDqKOzD4CblXmGpqrNA1u5nmT1s31i0o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yyZ6rd0NSWlhpoG9Q0esg6nHGFLl1NvhjNZwMMitnXQY0hBkjr5SL58/FXa5w+2S/
         aCztoEdN/hC5vzhkizpb/ZCOWhDH7YpgoI1B3dtt6Cpkd/aQoaKglYMjAYfeE2wwbk
         SnBEvBxqaKuIc3M+0ZF2Eb+5vROr7m2O8A8pccEQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jWiDJ-00AJjI-1O; Thu, 07 May 2020 16:13:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 07 May 2020 16:13:28 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Scull <ascull@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 07/26] KVM: arm64: Add a level hint to
 __kvm_tlb_flush_vmid_ipa
In-Reply-To: <20200507150843.GG237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-8-maz@kernel.org>
 <20200507150843.GG237572@google.com>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <6a347ce739ff46f03fc6c6c7bc5b0c4f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, andre.przywara@arm.com, Dave.Martin@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-07 16:08, Andrew Scull wrote:
>> -void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, 
>> phys_addr_t ipa)
>> +void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
>> +					 phys_addr_t ipa, int level)
> 
> The level feels like a good opportunity for an enum to add some
> documentation from the type.

Sure, why not. I'll give it a go.

> 
>>  static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, 
>> phys_addr_t ipa)
>>  {
>> -	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa);
>> +	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa, 0);
> 
> With the constants from the next patch brought forward, the magic 0 can
> be given a name, although it's very temporary so..

Yup. To the point where I've now squashed this patch and the following
one together, and moved the constants to the previous patch.

> Otherwise, looks good.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
