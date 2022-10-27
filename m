Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FA560FBC2
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 17:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiJ0PWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 11:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbiJ0PVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 11:21:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293336A508
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1F75B826DA
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48301C433C1;
        Thu, 27 Oct 2022 15:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666884091;
        bh=H9WUjCzGGNN06EF+TlX9yvE8arkV5DGJVVT0ALe9MQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YAel0MsaU6b9iw+V6SqZfCenO14l6YoNOssEiNX0pq4BLbUN/2N0iukDE3J5SpVWD
         Sai+B/Hvv5+ZtwLr0kU7CiyGmY5nopq7lszd1WJfAIr3P/u4byZatGvNz2hCpJmcZ2
         tYh+H8rTvwyHf/NX75p3sRI8xaTe1txYgpcB5HI8JE86lwZPiiwcGTt4YWm2YcyDB3
         UXV71CkWqAStvsfX+fu2UTVEz4mRSzZ9+O59sEKfE4A5HWflAYBJlfq3n2Ee1H9dmC
         UUM+OBpdky72YQ3ialxejhS4+lmICYzTqhpluzzC6GB5qGlIpsgVwb8d9SVlE9waCU
         iW4gZZX037IQA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oo4hE-0021wH-He;
        Thu, 27 Oct 2022 16:21:29 +0100
MIME-Version: 1.0
Date:   Thu, 27 Oct 2022 16:21:28 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH 1/9] KVM: arm64: PMU: Align chained counter implementation
 with architecture pseudocode
In-Reply-To: <CAAeT=FzbYp58Yw6QXqD92w4UMG8x+O81i6hoC+_jeOEL0vFjGA@mail.gmail.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-2-maz@kernel.org>
 <CAAeT=Fz55H09PWpmMu1sBkV=iUEHWezwhghJskaWAoqQsi2N0A@mail.gmail.com>
 <86zgdlms58.wl-maz@kernel.org>
 <CAAeT=FzbYp58Yw6QXqD92w4UMG8x+O81i6hoC+_jeOEL0vFjGA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <cf1bb582d44cf2a40a3dfc12d21f24fa@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reijiw@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 2022-10-27 15:33, Reiji Watanabe wrote:
> Hi Marc,
> 
>> > > +static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
>> > > +                                     unsigned long mask, u32 event)
>> > > +{
>> > > +       int i;
>> > > +
>> > > +       if (!kvm_vcpu_has_pmu(vcpu))
>> > > +               return;
>> > > +
>> > > +       if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
>> > > +               return;
>> > > +
>> > > +       /* Weed out disabled counters */
>> > > +       mask &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>> > > +
>> > > +       for_each_set_bit(i, &mask, ARMV8_PMU_CYCLE_IDX) {
>> > > +               u64 type, reg;
>> > > +
>> > > +               /* Filter on event type */
>> > > +               type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
>> > > +               type &= kvm_pmu_event_mask(vcpu->kvm);
>> > > +               if (type != event)
>> > > +                       continue;
>> > > +
>> > > +               /* Increment this counter */
>> > > +               reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
>> > > +               reg = lower_32_bits(reg);
>> > > +               __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
>> > > +
>> > > +               if (reg) /* No overflow? move on */
>> > > +                       continue;
>> > > +
>> > > +               /* Mark overflow */
>> > > +               __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
>> >
>> > Perhaps it might be useful to create another helper that takes
>> > care of just one counter (it would essentially do the code above
>> > in the loop). The helper could be used (in addition to the above
>> > loop) from the code below for the CHAIN event case and from
>> > kvm_pmu_perf_overflow(). Then unnecessary execution of
>> > for_each_set_bit() could be avoided for these two cases.
>> 
>> I'm not sure it really helps. We would still need to check whether the
>> counter is enabled, and we'd need to bring that into the helper
>> instead of keeping it outside of the loop.
> 
> That's true. It seems that I overlooked that.
> Although it appears checking with kvm_vcpu_has_pmu() is unnecessary
> (redundant), the check with PMCR_EL0.E is necessary.

Ah indeed, I'll drop the kvm_vcpu_has_pmu() check.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
