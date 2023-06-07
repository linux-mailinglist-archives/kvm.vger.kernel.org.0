Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87667725144
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbjFGAzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbjFGAzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:55:13 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E057A19AE
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:55:08 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b24e50f4dfso583805ad.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686099308; x=1688691308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TiiO5lm09/llcY60xbB1wTnnlYaNwmcjaEBpMB+pCik=;
        b=z/n2Yj8Ts6rQStJro2tcUg1PikLgoHTBxYJ+XtKESQy+bdryu0EUhVMuvWuMQeHeb8
         Ky0hS97SteZuODEwYhAJ+xpUC5n3+1EJ7OWbEJrVJIK+b8hxQd11b1pVTozS+9qvyICg
         zAGSVT0hYjeXaz6TqE+GCSvnWFfF4LQsfkFt6wxr1lVlRsycMAkWAlgJ3NtLWFlBXHXr
         PbOetXDr4siY96SThhTxhiJfMVDZR5L+N6G9WQ6Xj929DRbhIb80LBKMkeThO3kz6Vo+
         cHMZlowDyM83hiFt85WBD5RH2XjfppX6H9FpEcfgvW0StaH/rd8w3C6QIA+1rLJw+SDK
         6aCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099308; x=1688691308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TiiO5lm09/llcY60xbB1wTnnlYaNwmcjaEBpMB+pCik=;
        b=Id3IIUrfwnFOjKlPIEO25tMWqtmfJBiHeT6vTs5XCIeA28vB/6vCiYBpg9SOSGi9ER
         qGCVdis0tVQv32LLBqFc3xgk2n4Dt++4nGoo4peITATc4EEDvBxeNGMDUPM81ucp8zaT
         tWQ+0ojN0AnBBVvEppB+IBV2mSxzrayH7PYhNZkmGQRUxHyJC/CRKgHWIRPKTEV4SSEW
         omIQwbMbg5aDAaRtOvY74i+4R2qDJugzRPp6iPiHUlRa52cQx4r1oqugxAD6u7xo7LZr
         Js0hrcCiSE2vnsaBT9u65N/JdQNIS5AbTnqPLfAU6uyysK/eRZ3NsTGDPmOWkeXAvE0C
         e3Hw==
X-Gm-Message-State: AC+VfDySeJFrC31m4oK70n0r2AfszDsKoSlCJlGadrjhaYAEauABPBUr
        O+GHehFtaRhr+qeuAIOfucueGH/RDN0=
X-Google-Smtp-Source: ACHHUZ4+IZRjVf4X3xVTuElJaPs8Qz55nNTuGU2QwK7hS2HYGczghUV5PbAQFRJ9YWawoOnByBff8TsUnDI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c20d:b0:1ac:82e8:4917 with SMTP id
 13-20020a170902c20d00b001ac82e84917mr1187156pll.13.1686099308332; Tue, 06 Jun
 2023 17:55:08 -0700 (PDT)
Date:   Tue,  6 Jun 2023 17:55:02 -0700
In-Reply-To: <20230602011518.787006-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230602011518.787006-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168608931025.1367101.1539584781892191292.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: x86: Use "standard" mmu_notifier hook for APIC page
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 01 Jun 2023 18:15:15 -0700, Sean Christopherson wrote:
> Convert VMX's handling of mmu_notifier invalidations of the APIC-access page
> from invalidate_range() to KVM's standard invalidate_range_{start,end}().
> 
> KVM (ab)uses invalidate_range() to fudge around not stalling vCPUs until
> relevant in-flight invalidations complete.  Abusing invalidate_range() works,
> but it requires one-off code in KVM, sets a bad precedent in KVM, and is
> blocking improvements to mmu_notifier's definition of invalidate_range()
> due to KVM's usage diverging wildly from the original intent of notifying
> IOMMUs of changes to shared page tables.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/3] KVM: VMX: Retry APIC-access page reload if invalidation is in-progress
      https://github.com/kvm-x86/linux/commit/878940b33d76
[2/3] KVM: x86: Use standard mmu_notifier invalidate hooks for APIC access page
      https://github.com/kvm-x86/linux/commit/0a8a5f2c8c26
[3/3] KVM: x86/mmu: Trigger APIC-access page reload iff vendor code cares
      https://github.com/kvm-x86/linux/commit/0a3869e14d4a

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
