Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F45177CB4E
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 12:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjHOKq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 06:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbjHOKqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 06:46:06 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488E11BEE;
        Tue, 15 Aug 2023 03:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1692096320;
        bh=ZyKq2ZClCOeYiMbItIk4ip+/+X634+gPGWCXK7C4M6A=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=n8ovVRAotvT0TUkDs1kyQW5Hj/1SWHSL8+YWLwTwJ1wXZK9BEgkQBWhj3Zp3yGZpL
         qv9MctJ+JljgV6o5pUG8MV6XQO6LBRGvu8bZMtK7EHJv0fW+guQ8jXXzzWugGqv+fE
         GLFgEV9nJK9yodHRD5jRPo+jl+p2ucT+Z5/u8g5CafGnQ51honVIdz/b9ze2N5Ccqu
         hDIrUrXkEw6q087HQk25hDGVHdfjc5bYo9uw1hcD+hA4pJZTtn4kH9Ow8l8jXK3338
         lsX5wvlRmdmlT4HouM2WX0LDRBmlu+wwnJznThIbsulz/ZA1re14mZ0civ6pY2gonC
         CQaub8iAMxcVA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RQ7Fr3SBbz4wZn;
        Tue, 15 Aug 2023 20:45:20 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Jordan Niethe <jniethe5@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, mikey@neuling.org,
        paulus@ozlabs.org, vaibhav@linux.ibm.com, sbhat@linux.ibm.com,
        gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com,
        amachhiw@linux.vnet.ibm.com
Subject: Re: [PATCH v3 4/6] KVM: PPC: Book3s HV: Hold LPIDs in an unsigned long
In-Reply-To: <CUS477NDPEQI.27SBUCRNYD0XG@wheely>
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-5-jniethe5@gmail.com>
 <CUS477NDPEQI.27SBUCRNYD0XG@wheely>
Date:   Tue, 15 Aug 2023 20:45:14 +1000
Message-ID: <87ttt0d1ol.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Nicholas Piggin" <npiggin@gmail.com> writes:
> On Mon Aug 7, 2023 at 11:45 AM AEST, Jordan Niethe wrote:
>> The LPID register is 32 bits long. The host keeps the lpids for each
>> guest in an unsigned word struct kvm_arch. Currently, LPIDs are already
>> limited by mmu_lpid_bits and KVM_MAX_NESTED_GUESTS_SHIFT.
>>
>> The nestedv2 API returns a 64 bit "Guest ID" to be used be the L1 host
>> for each L2 guest. This value is used as an lpid, e.g. it is the
>> parameter used by H_RPT_INVALIDATE. To minimize needless special casing
>> it makes sense to keep this "Guest ID" in struct kvm_arch::lpid.
>>
>> This means that struct kvm_arch::lpid is too small so prepare for this
>> and make it an unsigned long. This is not a problem for the KVM-HV and
>> nestedv1 cases as their lpid values are already limited to valid ranges
>> so in those contexts the lpid can be used as an unsigned word safely as
>> needed.
>>
>> In the PAPR, the H_RPT_INVALIDATE pid/lpid parameter is already
>> specified as an unsigned long so change pseries_rpt_invalidate() to
>> match that.  Update the callers of pseries_rpt_invalidate() to also take
>> an unsigned long if they take an lpid value.
>
> I don't suppose it would be worth having an lpid_t.
>
>> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
>> index 4adff4f1896d..229f0a1ffdd4 100644
>> --- a/arch/powerpc/kvm/book3s_xive.c
>> +++ b/arch/powerpc/kvm/book3s_xive.c
>> @@ -886,10 +886,10 @@ int kvmppc_xive_attach_escalation(struct kvm_vcpu *vcpu, u8 prio,
>>  
>>  	if (single_escalation)
>>  		name = kasprintf(GFP_KERNEL, "kvm-%d-%d",
>> -				 vcpu->kvm->arch.lpid, xc->server_num);
>> +				 (unsigned int)vcpu->kvm->arch.lpid, xc->server_num);
>>  	else
>>  		name = kasprintf(GFP_KERNEL, "kvm-%d-%d-%d",
>> -				 vcpu->kvm->arch.lpid, xc->server_num, prio);
>> +				 (unsigned int)vcpu->kvm->arch.lpid, xc->server_num, prio);
>>  	if (!name) {
>>  		pr_err("Failed to allocate escalation irq name for queue %d of VCPU %d\n",
>>  		       prio, xc->server_num);
>
> I would have thought you'd keep the type and change the format.

Yeah. Don't we risk having ambigious names by discarding the high bits?
Not sure that would be a bug per se, but it could be confusing.

cheers
