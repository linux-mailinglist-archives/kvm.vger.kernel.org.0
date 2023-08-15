Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9414977C8A6
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 09:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbjHOHih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 03:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235203AbjHOHiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 03:38:05 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37EF10C
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 00:38:02 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qVocq-00GTR7-0K; Tue, 15 Aug 2023 09:38:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=bjvkxw/0DRLHOuO0XbwbecMtmiRmjuqU+0R1kCiCRfI=; b=B48I2jes2OLqQb1HR7eCdv9pHB
        7c652BZNLlCoG9t2zqrzJNrEal0feYIejgqTHl9a+5Ucj6rp0yN2xCh7Pg/Wc1nCjtbszABSULirP
        8iu1D9vQnNhkV/nskqL9d9eyXamV2r71bDpeSJ7tIydaU+WQnvc+XoOFJFV8Tr4KUMb1FhwgAhqlF
        lBlRE2mchNEPel4uAeEMAHdxR8i1m+8Ex15fD2eVg3AHqFEOL2nKa/PdyXMVG/WzylwOec/gW0VTX
        7qcipxT9O+iWURGy1b9w+/l85sOqzCA1UMoy6Ej5+NmQ4LK+Sk1EUpf8jeKywjsLadWssv092tci9
        kgegsQ5A==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qVocp-0002VT-Es; Tue, 15 Aug 2023 09:37:59 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qVocl-0002ny-DK; Tue, 15 Aug 2023 09:37:55 +0200
Message-ID: <2c823911-4712-4d06-bfb5-e6ee3f7023a7@rbox.co>
Date:   Tue, 15 Aug 2023 09:37:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] sync_regs() TOCTOU issues
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
References: <20230728001606.2275586-1-mhal@rbox.co>
 <169100872740.1737125.14417847751002571677.b4-ty@google.com>
 <ZNrLYOiQuImD1g8A@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZNrLYOiQuImD1g8A@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/15/23 02:48, Sean Christopherson wrote:
> ...
> Argh, apparently I didn't run these on AMD.  The exception injection test hangs
> because the vCPU hits triple fault shutdown, and because the VMCB is technically
> undefined on shutdown, KVM synthesizes INIT.  That starts the vCPU at the reset
> vector and it happily fetches zeroes util being killed.

Thank you for getting this. I should have mentioned, due to lack of access to
AMD hardware, I've only tested on Intel.

> @@ -115,6 +116,7 @@ static void *race_events_exc(void *arg)
>  	for (;;) {
>  		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_EVENTS);
>  		WRITE_ONCE(events->flags, 0);
> +		WRITE_ONCE(events->exception.nr, GP_VECTOR);
>  		WRITE_ONCE(events->exception.pending, 1);
>  		WRITE_ONCE(events->exception.nr, 255);

Here you're setting events->exception.nr twice. Is it deliberate?

Thanks again,
Michal

