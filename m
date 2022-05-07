Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E01651E554
	for <lists+kvm@lfdr.de>; Sat,  7 May 2022 09:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383564AbiEGHuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 03:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442082AbiEGHuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 03:50:11 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EAD54BC9;
        Sat,  7 May 2022 00:46:26 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id x12so7889637pgj.7;
        Sat, 07 May 2022 00:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HoNZSyMsFh0YGr6XMn2S1QvK2RQy1yb4yDnc0NWz6oc=;
        b=Ebb7mWsRqf/tGM07zO/HW9zZ5uDpqZ7FmKRVWRwJ5I9vjjFF1+vYkK6F4/1cru8rq7
         OjRLKU4N3l9l6c5pTvoUEbItc/bQc6dGsj8uGOJAqCKhQ8KstUnZU55m0c20a7JRFn9y
         Y15yeYCujfL7rKv0Dpckke6FJzfSrhst7NiQpAKOsAD1rHQhvCGYgItqP9r+iKtnCzbC
         EHSOS18gj2ZZwOxGC2LR2VcyNibP3U8o8yYdyN+uPA0o9UfdXr+zLOcUPzVstYe1BBXZ
         zmk7NtWev27+5si9mgOUUMT/1xO1XsYg5DVZHVUSZ2pNAqTNHSOeMttvKZv4e9UzP3eX
         4ssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HoNZSyMsFh0YGr6XMn2S1QvK2RQy1yb4yDnc0NWz6oc=;
        b=2kz5fuaS3dVhXQ4/Q9IGRP0mW6s9vimaASb4sQ/a66+zy+IzbT0PtlY6PdmmMTsnzq
         nt5JcAyxiEkUPp9zcOoKMgfJhKq33SCg7qAEQDrgMvIw5taRZd4ihWdcTCnYzeOzEH7m
         xbX8mKffmjrUhVMETmRKB2vCuIZ7Va5y3akHjYHnASU6zVz7AdnpVskc1dvadPT7LNi0
         c2QnBAGgWrrnB69pITXKlcCvy/6DC9MswtctAicI8xlCY3v8W6/0d4YzRIYmnDNOVidh
         tI5ODtFA+g0cQbuN7NkGP/wBF0hUwo4bNZHo7G8I5zwHQZJXlVYdzqKi5CV0qR5RP3wu
         hU/g==
X-Gm-Message-State: AOAM533yG4k+J/nf+2qtJ+sRVTsClF8hkDPkHC86hXpB03wBMsLCBITq
        QAwnp0gTpAukg0LsH38ySao=
X-Google-Smtp-Source: ABdhPJxjguZ9DDrPz4gDnb9yHPkMUMCF3GCbvbp/S7EovieX143wCGT1AeBuk0StNs+kplE5MiMg0Q==
X-Received: by 2002:a05:6a00:130e:b0:4cc:3c7d:4dec with SMTP id j14-20020a056a00130e00b004cc3c7d4decmr7398006pfu.32.1651909585489;
        Sat, 07 May 2022 00:46:25 -0700 (PDT)
Received: from [30.22.112.212] ([205.204.117.91])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e21200b0015e8d4eb283sm2990078plb.205.2022.05.07.00.46.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 00:46:25 -0700 (PDT)
Message-ID: <eb54e7c0-9270-bc9b-d91e-8d0dcaa02a71@gmail.com>
Date:   Sat, 7 May 2022 15:46:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v4 01/20] KVM: x86/mmu: Optimize MMU page cache lookup for
 all direct SPs
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-2-dmatlack@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
In-Reply-To: <20220422210546.458943-2-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/4/23 05:05, David Matlack wrote:
> Commit fb58a9c345f6 ("KVM: x86/mmu: Optimize MMU page cache lookup for
> fully direct MMUs") skipped the unsync checks and write flood clearing
> for full direct MMUs. We can extend this further to skip the checks for
> all direct shadow pages. Direct shadow pages in indirect MMUs (i.e.
> shadow paging) are used when shadowing a guest huge page with smaller
> pages. Such direct shadow pages, like their counterparts in fully direct
> MMUs, are never marked unsynced or have a non-zero write-flooding count.
>
> Checking sp->role.direct also generates better code than checking
> direct_map because, due to register pressure, direct_map has to get
> shoved onto the stack and then pulled back off.
>
> No functional change intended.
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>


Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>


