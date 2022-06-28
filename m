Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DFE55E3F3
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345785AbiF1NAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbiF1NAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:00:04 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CDF2FFC2
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:00:02 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q9so17585136wrd.8
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YvORtU2X4Ctw78w6mCE8JIrhIWsbwGsiz5u4iBZsYPA=;
        b=GWNL4HgUKZX8MxR2iNVTXEdLcOTLFg1Ww4JeUkneInzWUReZY4jtERqrsNPgapidIj
         UyCP7byAXTJluDPpUiF42pL6J3DlixKxPkXcx5qCNypNFuOk7otahoI02Xp7kmffZuqo
         YG0c1xC0SlGP0olZHxt2COA5h2op03upgvLXXIv6zYM+fbh5tEAZg7I/hZMraHnyiWsz
         fCAWp6CDKt4dWYGdsWz7rPUCwaUqmliy/oW8Nk+x5iLEh79DFghewz2/wJ9tCZgqOHJX
         /4I9TD/YyembiGKoBch6SnkSDdfM+LIincXPheWflF9dFy4N5ves8Ek3MU4b1q25oea1
         Lvew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YvORtU2X4Ctw78w6mCE8JIrhIWsbwGsiz5u4iBZsYPA=;
        b=e22uvI+MtWcr3O4cvA8XDExjU76+GvKlGOjaPQ8YsBYhLNKhPW/ProMsVkfYKiA84c
         tuuwF/52y424mTEJnObHMQCZ8SjyHUfqp9WuU50yMi+9wwOcs20B60SaJHxyehXPExqz
         4brp9wMztVjWla3YLLIhMnO6WTMxv+178ay0t5OFAPzQTJ4nwpcpFAb+fMuw12sxvmAA
         BrMki+aOOXYZZs2RyKfBikTRDUee0kk9NIALy6TXi2aeXSmsHEl9zl8EGqMg/ODKtU9c
         SNu/lJbnvaKQorMrHVj6tAWeA0SfFVR1f+wMKf2gL3Xf5sXKL4gA5Pi3/CJOVI5V/lED
         YFkQ==
X-Gm-Message-State: AJIora9XQlxbgUzor1/dSnJO2iDtXhcJeUePmdpxLnicVqqhqVlVKvJe
        hi4h5gAfcHtE1cGZq0fizHiuRGQolDA=
X-Google-Smtp-Source: AGRyM1se02//9mZe0YAPgQ5BrhpOQ9ltjYKb0yoKF3R/O7ZDvA10tX+uObiLJ02es5AXlmKM3BFCag==
X-Received: by 2002:adf:ffcf:0:b0:21a:3cc0:d624 with SMTP id x15-20020adfffcf000000b0021a3cc0d624mr17720856wrs.164.1656421200927;
        Tue, 28 Jun 2022 06:00:00 -0700 (PDT)
Received: from [192.168.189.248] (93-33-45-102.ip42.fastwebnet.it. [93.33.45.102])
        by smtp.googlemail.com with ESMTPSA id l10-20020a5d560a000000b0021b9270de3csm14425611wrv.10.2022.06.28.05.59.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 05:59:59 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7d0eec84-6e93-c75c-c91e-957c6788c929@redhat.com>
Date:   Tue, 28 Jun 2022 14:59:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/5] Fix wrong gfn range of tlb flushing with range
Content-Language: en-US
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
 <YrZDkBSKwuQSrK+r@google.com>
 <8b3d1e58-fb79-ca84-c396-a44318d3ebd1@redhat.com>
 <20220627041503.GA12292@k08j02272.eu95sqa>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220627041503.GA12292@k08j02272.eu95sqa>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/22 06:15, Hou Wenlong wrote:
>> I'm pretty sure it's in use on Azure.  Some of the changes are
>> flushing less, for the others it's more than likely that Hyper-V
>> treats a 1-page flush the same if the address points to a huge page.
>>
> I lookup hyperv_fill_flush_guest_mapping_list(), gpa_list.page.largepage
> is always false. Or the behaviour you said is implemented in Hyper-V not
> in KVM ?
> 

Yes, I mean in Hyper-V (and/or in the processor).

Paolo
