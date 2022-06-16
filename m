Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E918554E9A4
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 20:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377642AbiFPSrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 14:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiFPSrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 14:47:16 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A892CDC5
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:47:15 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t2so1958717pld.4
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uBB/J8bQS3jOMS4YDFQ1IMHL6GxPjjT1BgnhKdTawwA=;
        b=FAFNRwAXbqbs5kPP9MqWhm2jwLweXrkjXqm+QlkTQJ2uCUEcNluny0v21VXymHvoY9
         rqjC6bElkKMBNJY/JsTwEd4qcNvDdRtkC879eelmXJHmH2eKgd492mqxLy13i79gDImW
         DOqBjXdY4Se0V0Sq1AtX+VfzuEtBir5fJ22FJTWtjnzzQpzyEXTxyZ9YXZzrcAInIWbi
         FrxXKOl74i6O13QWYX99Uu+qHZpHdbzInW9krOeJksYSUzEz1tGq+Gxo6jP7dQ/pC155
         tZzAWhFKf1Ioj2w6JE+sro4Ml5Ps0nOdpLOntXF9hpPv4dv1mV57qdM4esraWNZv66up
         8tIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uBB/J8bQS3jOMS4YDFQ1IMHL6GxPjjT1BgnhKdTawwA=;
        b=GWRop5Gn8+p/0n026npgggQjbLTBsMDRftnI+UytxETZGnriBJA/jVqOl/goNZK7M8
         rTlIOUN/ZUrqInEL4jztiVv1wz1o14ssydxJyNjQgQrj/u/z11lIstReBrS5htfRCZlq
         xXc2C4SZ9aVG3VnwUypI/rM9QBS5irOV35Ufw5n5UhFwwko6TH3Jbaj6sNpcyoPNfCUz
         EQeIfLErUsYiM1yq2EcvvzODExw+rAACfThkimyAhCkKN+/lblV+dJOCwYHXbA5LjNDl
         9Kr6WKKYQ9V8kS7Fd7IOz3PA+ekfVyFJXoSxSBL+CQZ5SA5TMb0gggGyfUuOX+Hn60/r
         uQxg==
X-Gm-Message-State: AJIora9yffeAg0SDd45q0smr3XseSSGGTd/huegH4KEdU0B08AgBb+9m
        owxm0U4fpVG5sNsNc0JyV+vXyQ==
X-Google-Smtp-Source: AGRyM1uCJJ2F+oFOq0FLGO6wjzLEHVI9CHwNDtvXiwEJg0G+cL23BDN1LursbHbBFAUeKgpuST6/CA==
X-Received: by 2002:a17:903:11d2:b0:167:8a0f:8d33 with SMTP id q18-20020a17090311d200b001678a0f8d33mr5744330plh.95.1655405235081;
        Thu, 16 Jun 2022 11:47:15 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id v1-20020a62c301000000b0051ba8b742e4sm2117495pfg.69.2022.06.16.11.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:47:12 -0700 (PDT)
Date:   Thu, 16 Jun 2022 18:47:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
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
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v6 03/22] KVM: x86/mmu: Stop passing @direct to
 mmu_alloc_root()
Message-ID: <Yqt6rBPMxfwAPjp1@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-4-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022, David Matlack wrote:
> The argument @direct is vcpu->arch.mmu->root_role.direct, so just use
> that.

It's worth calling out that, unlike non-root page tables, it's impossible to have
a direct root in an indirect MMU.  I.e. provide a hint as to why there's a need to
pass @direct in the first place.

> Suggested-by: Lai Jiangshan <jiangshanlai@gmail.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
