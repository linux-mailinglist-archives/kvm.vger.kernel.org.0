Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF52B5BB52B
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 03:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiIQBFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 21:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiIQBFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 21:05:45 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318D99E886
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:05:44 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so1145247pjl.0
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Ms7nUAHZlOrFk0AT6URL26jPlCSp0+EaZtlB5XtXTac=;
        b=MdPgXvkJHjv61QnOF0rlU2IGMQrERLFIYrhARKY87N6z3503c1B/CnL4gzoDJIy3gm
         Jp+3rGZles/4JlQqLWf95s8astDt9vgOWmtcLw7bJbrUxuRPjCf1vWwwGKHfhxBtQdFg
         Gamv9jPOQlsFt8QFu96OGdhFPFwwpE97UeZpl4uzDQdKci7HXhcNLoY5EJYgZMj4MPHf
         8hS4YcTPB3C+ajYgM53qRKyJYM9a7H+wky3q4em1MN1pK6CEX+BIGsGTGOjSc/vCtOYI
         Z9ofnoGy3zA4mvMGobLjtiO/O3bdaaKEpIfAeYVuZdKZCU6Fn+YKOOOp3zZODs4J5VLf
         yVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Ms7nUAHZlOrFk0AT6URL26jPlCSp0+EaZtlB5XtXTac=;
        b=i1E5mPFKtoIJ3YJKoWCITAq3Yl4OtOyLHwZGCGzkyOUZS5gv5s6PcJaUg0M9TMwebF
         fFJ/MvMb5fRKp3HoPAIbcwyfC/vAfgM4vX8cQLxngl09Iz8ZMuTMeT4RR6RbQeG9IdsZ
         /vWpk931ERvte3t6xvaKpwoP+A2HVSe/0Anq1S312XMqAUPBl9oPGgt5d7ee0b9L4+Nd
         p6e39WfQJf3b+LKZS4fIOWNbSfU9vB5Kx845qmmA80suNvrQYizAbJN4Q3zK1H34FbL9
         bsxgiTdKJMFQmYUCwA5bjl4X5IaGXq2gZZrNuGrBjDTMsTArlNs7FPPmXxH6lmRMaUj4
         Miuw==
X-Gm-Message-State: ACrzQf0jxEKJhbCkOe1cRPBe79atV6gzF3V5eC6easzT3FZSLlw44b/v
        fSsnxO7exIGxp37XFAk5TLIk3XqICkDFmQ==
X-Google-Smtp-Source: AMsMyM6OR2py8Li2mImtpqmauxL1OntNskkntg1zia7heScQCSXzmm8qZyu4Kr5Q+gXDXwAIVCkWPg==
X-Received: by 2002:a17:903:1c1:b0:178:1c92:e35 with SMTP id e1-20020a17090301c100b001781c920e35mr2326957plh.151.1663376743592;
        Fri, 16 Sep 2022 18:05:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n10-20020a170903404a00b00172d9f6e22bsm15289975pla.15.2022.09.16.18.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 18:05:42 -0700 (PDT)
Date:   Sat, 17 Sep 2022 01:05:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/33] KVM: VMX: Support updated eVMCSv1 revision +
 use vmcs_config for L1 VMX MSRs
Message-ID: <YyUdYziyOfMGxf17@google.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022, Vitaly Kuznetsov wrote:
> Changes since "[RFC PATCH v6 00/36] KVM: x86: eVMCS rework":
> - Drop the most controversial TSC_SCALING enablement for Hyper-V on KVM:
>   - "KVM: nVMX: Enforce unsupported eVMCS in VMX MSRs for host accesses" patch dropped.
>   - "KVM: nVMX: Support TSC scaling with enlightened VMCS" patch dropped.
>   - "KVM: selftests: Enable TSC scaling in evmcs selftest" patch dropped.

Pushed to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

Unless you hear otherwise, it will make its way to kvm/queue "soon".

Note, the commit IDs are not guaranteed to be stable, and in fact they are guaranteed
to not be stable right now as I need to do some surgery.
