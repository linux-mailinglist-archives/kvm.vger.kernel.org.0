Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E51559B7BF
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 04:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiHVCky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Aug 2022 22:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbiHVCkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Aug 2022 22:40:52 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20A1237C3
        for <kvm@vger.kernel.org>; Sun, 21 Aug 2022 19:40:50 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oPxMt-009LUY-J8; Mon, 22 Aug 2022 04:40:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=NTl9qG7mOuB6Livrcj4tubCrztyGP8ZqVXkdo13hDDo=; b=wPby+kOMEMfoZhroppAyzZdO3t
        oCrGuAep7SN01Oux81xfKnE7WO6uJHrMyaWAcubWNn8BmCgrzTAl/rJVjSZ9jP+1cCIf0Dig39m7R
        xCBQRlwd9jWiVfmB6lgHuK3l9h4PM2DtBKMcahgh6kdeapVe906DFRRL7eR163JZziU9GtHBCpNQz
        lCBxR/EfQVa0jCcx2llLjpjjnDra5TbSiO9Xg/yzU9shyI1hRxZEavwEPa4XsV4hzeXiOWy2Oxws6
        ol6bG/lpRoU//qHWUvq8DJc2IpTghkwkjF3tQGru5spvJTp8kwcOyK9/Eg/t7Atzu4qo/W4x2PW9p
        MkCY12PA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oPxMo-00080M-7s; Mon, 22 Aug 2022 04:40:42 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oPxMk-0003fr-Tr; Mon, 22 Aug 2022 04:40:38 +0200
Message-ID: <9b853239-a3df-f124-e793-44cbadfbbd8f@rbox.co>
Date:   Mon, 22 Aug 2022 04:40:37 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test POP-SS blocking
Content-Language: en-US
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com
References: <20220821215900.1419215-1-mhal@rbox.co>
 <20220821220647.1420411-1-mhal@rbox.co>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <20220821220647.1420411-1-mhal@rbox.co>
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

On 8/22/22 00:06, Michal Luczaj wrote:
> Note that doing this the ASM_TRY() way would require extending
> setup_idt() (to handle #DB) and introducing another ASM_TRY() variant
> (one without the initial `movl $0, %%gs:4`).

Replying to self as I was wrong regarding the need for another ASM_TRY() variant.
Once setup_idt() is told to handle #DB, test can be simplified to something like

	asm volatile("push %[ss]\n\t"
		     __ASM_TRY(KVM_FEP "pop %%ss", "1f")
		     "ex_blocked: mov $1, %[success]\n\t"
		     "1:"
		     : [success] "+g" (success)
		     : [ss] "r" (read_ss())
		     : "memory");

Should I resend the patch?

Sorry for the noise,
Michal
