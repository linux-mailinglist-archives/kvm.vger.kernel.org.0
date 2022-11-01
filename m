Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2747614E39
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 16:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiKAPV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 11:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiKAPV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 11:21:27 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7591E1
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 08:21:26 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k5so5938806pjo.5
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 08:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SWwI4HddTr5hZsOzf2RypoXH7oScXpad+VTxgJy3JSU=;
        b=V2ni/OAKFDBPORA+0ZeSWUG89qhd2Dv2ryK/aTZFvP9bOCrQ7odY6kYDX/XzmFIehs
         OMQhkM8rztuimR0+4jdPRLh6q1pSN59P38KLVKaLGiZ+c1NZmTu9+XSBDfunWtvglq1R
         hkCGjhhgrbfUsCL4ZjYfvLxirq7NZsC/MdQVEcPLWFKoFLCO/NdS8Dg7No+mTFrQPY0/
         Kv9tHzQ8ujjhE+syyDE9e9zYFMS/m84zwgy+eFwnzzsanvcYteB52kZJdYb7gTzQh4u8
         hNvuCOD1aeNFWhT0Ja2k3RMurJ4BgDVHHmkUmlLPfh1HXd1+31sjSLWJLwI+rQKMzG9Q
         2wug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWwI4HddTr5hZsOzf2RypoXH7oScXpad+VTxgJy3JSU=;
        b=hadhhsOF9fFH+9+na9j90DBtSlyJoDnyV8bCr2h5obvV4SJIls3zILVYVnjo82n0St
         zo4l7b8zqM2e/P9/oaVOC9xDjWHCPwBN75zju+wnWYNaJVntZqOsQQnJcgATg8jyBz4K
         EhkoW8FzCaTxCLd83A75xtHXQdpKjcGp42mm8kyz4dBBn88kV3tKfIGnJwqfpHMNZfaP
         fPIGjGkZV2O7UyuSgU9MRGv4F9JQDv/kNZvwMXZZZaIumwz6MouSfWaBi71//dSRjV8H
         qi4ZNIorfMQ1pGbCUJg/vdp6U1PjwCCEjWXKtsjcS76ckW/zdFREBPrKT55xIVGNlrsZ
         S4TQ==
X-Gm-Message-State: ACrzQf1nU/nSkGkp857R8fJF+DDtz4Uf9c6Ee5coaiRaLM63LUIXGhe6
        jewJMqnGpU5ZsXXPGItJgVkWjw==
X-Google-Smtp-Source: AMsMyM73tDHw4PtLUZRmG04g7QlQfytvU9Eydf0ikb6gjSEIUo5oMBNMEeo82jEamOECjKrhS7hN0w==
X-Received: by 2002:a17:902:aa46:b0:186:e220:11d4 with SMTP id c6-20020a170902aa4600b00186e22011d4mr20058322plr.163.1667316086196;
        Tue, 01 Nov 2022 08:21:26 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 6-20020a631446000000b0046f7e1ca434sm6105617pgu.0.2022.11.01.08.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 08:21:25 -0700 (PDT)
Date:   Tue, 1 Nov 2022 15:21:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 00/48] KVM: x86: hyper-v: Fine-grained TLB flush + L2
 TLB flush features
Message-ID: <Y2E5chB/9pZcRWi6@google.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022, Vitaly Kuznetsov wrote:
> Changes since v12 (Sean):
> - Reviewed-by: tags added.
> - PATCH13: added a comment explaining why 'hc->ingpa' doesn't need to be
>   translated when the hypercall is 'fast'.
> - PATCH34: s,wraping,wrapping, in the blurb.
> - PATCH36: added missing Signed-off-by: tag.
> - "KVM: selftests: Stuff RAX/RCX with 'safe' values in vmmcall()/vmcall()"
>   patch added (and used later in the series).
> - "KVM: selftests: Introduce rdmsr_from_l2() and use it for MSR-Bitmap
>   tests" patch added (and used later in the series).

Note, this doesn't apply cleanly to kvm/queue for me, looks like there are superficial
conflicts that make git unhappy with the vmx/evmcs.{ch} => vmx/hyperv.{ch}, though I
might be missing a git am flag to help it deal with renames.

Applies cleanly to e18d6152ff0f ("Merge tag 'kvm-riscv-6.1-1' of
https://github.com/kvm-riscv/linux into HEAD") and then rebases to kvm/queue without
needing human assistance.
