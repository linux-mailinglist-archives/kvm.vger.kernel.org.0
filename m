Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDE272319B
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 22:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbjFEUnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 16:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjFEUnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 16:43:19 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9489AA7
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 13:43:18 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q6H2k-00CZCa-Te; Mon, 05 Jun 2023 22:43:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=v4Bi7tyyUd+tjqQMljkfix7e2ZExX/wnrFV+XOW9EBo=; b=fsBLH7sbx0GB/OI9OLBiFm18h1
        zi96BbiX5fCLMBT7yeuu4vAbghAgVnav/RSvdejSlfAiVbL82JGE3DJHtmXQrBswvg+VAc3uYOIsP
        jyoabMRGp6Jbin0xJfl6oQ9Vqy2sYWmoU9HqRsm3Da3G1Ygfg2B3D9JyFli2mPpWK52J08G9oUXfn
        SL2YDKPbNFomdNIpdAXlRDcDyczVjtQNfsBZTFOvAv6FTynydbu4DWw6l67HGArw5vR9eHdhJ5AYL
        tdCaNKgl76nRmAdlcPOFJuAfQzO1WYAAjUenQjYCAyxf0Qk9Mr6Fx7Q3te9IQ3BM6B3xBJgJfl0zU
        lt3jgvbA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q6H2k-0007Tg-1U; Mon, 05 Jun 2023 22:43:10 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q6H2b-0004Fs-82; Mon, 05 Jun 2023 22:43:01 +0200
Message-ID: <80f7f3dc-285f-39c3-655e-fd4a499f81a1@rbox.co>
Date:   Mon, 5 Jun 2023 22:42:59 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     dmatlack@google.com, mizhang@google.com, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, Wei Wang <wei.w.wang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230307135233.54684-1-wei.w.wang@intel.com>
 <168565180722.660019.15543226381784798973.b4-ty@google.com>
 <8f319a1e-a869-b666-b606-c0b4764ef7b1@rbox.co> <ZHofVKJxjaUxIDUN@google.com>
 <7a4a503d-9fc4-d366-02b4-bc145943bd45@rbox.co> <ZH39H0gpNX4ak6yM@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZH39H0gpNX4ak6yM@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/5/23 17:19, Sean Christopherson wrote:
> On Mon, Jun 05, 2023, Michal Luczaj wrote:
>> OK, so xa_store() aside[*], I see some bool-to-bools:
>>
>> arch/x86/kvm/x86.c:
>> 	kvm_msr_allowed():allowed = !!test_bit(index - start, bitmap);
>> arch/x86/kvm/hyperv.c:
>> 	kvm_hv_hypercall():hc.rep = !!(hc.rep_cnt || hc.rep_idx);
>> arch/x86/kvm/mmu/mmu.c:
>> 	update_pkru_bitmask():
>> 		pkey_bits = !!check_pkey;
>> 		pkey_bits |= (!!check_write) << 1;
>> arch/x86/kvm/svm/svm.c:
>> 	msr_write_intercepted():return !!test_bit(bit_write,  &tmp);
>> 	svm_vcpu_after_set_cpuid():
>> 		2x set_msr_interception...
>> tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c:
>> 	set_or_clear_invalid_guest_state():sregs.tr.unusable = !!set;
>>
>> But perhaps this is a matter of style and those were meant to be this kind-of
>> explicit?
> 
> I doubt it, I'm guessing most cases are due to the author being overzealous for
> one reason or another, e.g. I suspect the test_bit() ones are due to the original
> author incorrectly assuming test_bit() returned an unsigned long, i.e. the bit,
> as opposed to the bool.
> 
> If you want to clean these up, I'd say "fix" the test_bit() cases, but leave the
> others alone.  The test_bit() ones are clearly redundant, and IMO can be actively
> due to implying test_bit() returns something other than a bool.

Done: https://lore.kernel.org/kvm/20230605200158.118109-1-mhal@rbox.co/
