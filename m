Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17AAA623632
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 22:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbiKIVyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 16:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbiKIVyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 16:54:09 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203C931DCE
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 13:53:50 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i3so17923658pfc.11
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 13:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OjtTll63kEDv75PwR7o0lnOxIMI339azC+QX7bn1Io8=;
        b=ZO89qv+qCkNp/HiQ4Q6ZJHGSsutpkVQ0xhTCiLfOk0GkhfFmwFuMtZN/Ed/uuBdDsm
         b4X5XeR59abjiW7lNZ1Z9sR8LJFUsx+a9B2SHUeRRp6/cYrXLpoetVMHXFuCgwZAQnqE
         pZ/BWXqM7bIWHIcqAXTSDbjGG1ERbeFNTk0Y4PtVgfNcm9PuSJ9sfiFrUcEyBLE9HlM8
         QkMLkRFVrLYk5OZ84sNAclJOw5/83UK4EKX6nFYv+wTNUyqxRuFtrezzGGJav2rHU/CN
         Zf6bz4ZbCHT13Hi9brY3D91Fmcisb7qCwzTNns0F2mJxXzQkAu6FEZ58AeO8lHDoc3Oi
         RJWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjtTll63kEDv75PwR7o0lnOxIMI339azC+QX7bn1Io8=;
        b=gUkkHlNBfQASrRabxXF0izfJPVy0rYAT4Ah09DeDPlAj7u/M5PyqffXJStQu9mNB66
         nTy95KiuIOkYM+YRgcw9/i1T3OouQidIOfBY6pJ1GuaHI1JrlIyZh1RD8lvLTUp5IPvX
         x3Hart5LcQN+/8+UZPUYns64joilLc+SsdK6ydQ7vebCTuGNJ/W6s3mJcQ1/wK+pH0XS
         riF2poj0OHl9x7k2aXN+iUqWs1rH6UdV4YwEpiaHPtUWYUZmcWmXjRfis6bQn3+J3AgW
         SX86UpHhup9e44SSHCSAcHBiIT6BYbsbukQPMPKJhVZ1SiY3BrfXHCW/0hzziNLHL7Vl
         8brg==
X-Gm-Message-State: ACrzQf1peCYgneG+ncMIbh+TvTpa9BnAGHYI9wqUY2rlQRxCFvOotqyy
        94h7ro0ViS+xFzeSONMDftBQtg==
X-Google-Smtp-Source: AMsMyM405OCKBpJo33fzWng4KuCQaVeCIAwiX562TxX4BcFcitQF+k78e7DEu09G23/oE/uOT0+mjQ==
X-Received: by 2002:aa7:859a:0:b0:56b:d76d:8c76 with SMTP id w26-20020aa7859a000000b0056bd76d8c76mr61634658pfn.77.1668030829526;
        Wed, 09 Nov 2022 13:53:49 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902da8c00b00186b04776b0sm9672086plx.118.2022.11.09.13.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 13:53:49 -0800 (PST)
Date:   Wed, 9 Nov 2022 21:53:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y2whaWo3SIOOMKOE@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107215644.1895162-9-oliver.upton@linux.dev>
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

On Mon, Nov 07, 2022, Oliver Upton wrote:
> Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> release the RCU read lock when traversing the page tables. Defer the
> freeing of table memory to an RCU callback. Indirect the calls into RCU
> and provide stubs for hypervisor code, as RCU is not available in such a
> context.
> 
> The RCU protection doesn't amount to much at the moment, as readers are
> already protected by the read-write lock (all walkers that free table
> memory take the write lock). Nonetheless, a subsequent change will
> futher relax the locking requirements around the stage-2 MMU, thereby
> depending on RCU.

Two somewhat off-topic questions (because I'm curious):

 1. Are there plans to enable "fast" page faults on ARM?  E.g. to fixup access
    faults (handle_access_fault()) and/or write-protection faults without acquiring
    mmu_lock?

 2. If the answer to (1) is "yes!", what's the plan to protect the lockless walks
    for the RCU-less hypervisor code?
