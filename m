Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C0D5BC07F
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 01:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiIRXNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Sep 2022 19:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiIRXNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Sep 2022 19:13:38 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF3114D2C
        for <kvm@vger.kernel.org>; Sun, 18 Sep 2022 16:13:36 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oa3Th-009FFS-Dr; Mon, 19 Sep 2022 01:13:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=AE99YbHbKOSdlJSs6IzB7w17FA5Zftb2AELywf85VFg=; b=cxBDgAHUOP5DinjZl9v3ej9LDj
        UgvkyQUpU3PfuVG2r4sQL5mpi3imppvRUUBX6zNfHQyXu+KvnJxYTPsQq1vTJThQUXJ0UW85PMVEC
        KanvSfBJgaWcPfdNQkK9nTxB010ohw/S8GSdxGRpsvUsbd4vQGz/nUZUKSmgX+7IH8OaWFySCLbQ6
        0FTAB8Nfnbhqwk18ruIH2ssXszBOTJnZkvjoCH+TLSJ+w1cBiR3rtkcMlJC33fb68X6x2VKOvIpX/
        S1Ck48JnR57G1/XxHMuQTma8qQqQmi48wIhxfPO0EszYug0tgn1JopfzfXxXInuMOx6D+nd/MuoTK
        2ldU/N+A==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oa3Th-00052M-2q; Mon, 19 Sep 2022 01:13:33 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oa3TR-00032p-SR; Mon, 19 Sep 2022 01:13:17 +0200
Message-ID: <bd4274cd-57c0-ed9d-97e1-580387e96b41@rbox.co>
Date:   Mon, 19 Sep 2022 01:13:16 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [RFC PATCH 3/4] KVM: x86/xen: Disallow gpc locks reinitialization
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org
References: <20220916005405.2362180-1-mhal@rbox.co>
 <20220916005405.2362180-4-mhal@rbox.co> <YySujDJN2Wm3ivi/@google.com>
Content-Language: pl-PL, en-GB
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <YySujDJN2Wm3ivi/@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/16/22 19:12, Sean Christopherson wrote:
> On Fri, Sep 16, 2022, Michal Luczaj wrote:
>> For example: a race between ioctl(KVM_XEN_HVM_EVTCHN_SEND) and
>> kvm_gfn_to_pfn_cache_init() leads to a corrupted shinfo gpc lock.
>>
>>                 (thread 1)                |           (thread 2)
>>                                           |
>>  kvm_xen_set_evtchn_fast                  |
>>   read_lock_irqsave(&gpc->lock, ...)      |
>>                                           | kvm_gfn_to_pfn_cache_init
>>                                           |  rwlock_init(&gpc->lock)
>>   read_unlock_irqrestore(&gpc->lock, ...) |
>>
> 
> Please explicitly include a sample call stack for reaching kvm_gfn_to_pfn_cache_init().
> Without that, it's difficult to understand if this is a bug in the gfn_to_pfn_cache
> code, or if it's a bug in the caller.

OK, I'll try to be more specific.

> Rather than add another flag, (...)
> Let me know if yout want to take on the above cleanups, if not I'll add them to
> my todo list.

Sure, I'll do it.

Thanks for all the suggestions,
Michal

