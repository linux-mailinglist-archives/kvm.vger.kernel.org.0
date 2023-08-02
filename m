Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D5276DACB
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 00:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbjHBW0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 18:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbjHBWZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 18:25:52 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEFB468D
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 15:24:35 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bba9a0da10so2831585ad.2
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 15:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691015074; x=1691619874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F9yIn4dK3mSmUtcCp8LFFT4F/LQPHHPvz5xo49Hmxkk=;
        b=H+aTSYmBYRO7DEl0/Htl+Y5MU3zO0wo2l+1FTpMwOYDrAjZnYx7ET8cvGNBa+VhiQo
         VNh5q/Dn9hvp4uKDjTfLgLfw15kkhnDEnfRhiU9yFwZZHyeTWZpXkJqPylFoHBgQAyaf
         aBTifmJXqJLmP5lVQAoPZsli5/e5GDX78w5BAZjdL1vToFkiklboUC2FYPw4yrY5o7zi
         FKfloQC0qrIZC8aaCFXsGriAuqPWzKBenKQfVkqPaUsunkHJ9IDkCXMZqn79LQm2+khs
         y6UAtFp77IpR1eHxik0mHjgsYCbadkRl1CkaPHJo8SdYL1zsjEcOXb/edT5pHOCJNcVZ
         haXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691015074; x=1691619874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F9yIn4dK3mSmUtcCp8LFFT4F/LQPHHPvz5xo49Hmxkk=;
        b=JIfrVu+9LfV7t/+MdKX2+FdC+6IKphhEEWrV2RtPBWofqNlUokJUmOT07JgjhDh0a3
         43LoADREzzbBbL9LR0kUNiqErCKcaaJMHxWQ26tTGBF0E3+RLtGKZCvEZ+8qUtDsUTWt
         mMMHVZAsYX/OepFCeCKfmdfwBzF839w3HxWhw1HmYpuj0Mb0cDAtFJG6cSt0Bh7OPsuE
         hTYyt4vbPeLASJOupxC/XEUEYxQIEZg9gtW4SwNFqZ5+hZH2PJH0ZRwBz9okTraUT21V
         A2L7xd4qM582tWEwMAO38qbUWuGe7wrK/TM+93F7UxTSSwW2WPXhasLHjWVPUjcCqRbp
         XBLg==
X-Gm-Message-State: ABy/qLb30Q9eeVsF+qKA/lS8PTIplE1Unkiwwy33Tij7Ly5hC377mrZh
        /q+0qZXvP8Ut175VgtbgJqEuTglyNFs=
X-Google-Smtp-Source: APBJJlEIByBfYoY/KC32/g8HzkxLqseO0XeVYpg+NMSyLBH6gtwD9otmWgLk0cSs3kJzChFA66PNbRObft0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2291:b0:1b5:2b14:5f2c with SMTP id
 b17-20020a170903229100b001b52b145f2cmr105841plh.4.1691015074397; Wed, 02 Aug
 2023 15:24:34 -0700 (PDT)
Date:   Wed, 2 Aug 2023 15:24:33 -0700
In-Reply-To: <20230725143857.228626-1-iii@linux.ibm.com>
Mime-Version: 1.0
References: <20230725143857.228626-1-iii@linux.ibm.com>
Message-ID: <ZMrXoQ0wN5ZyCf6Q@google.com>
Subject: Re: [PATCH v4 0/6] KVM: s390: interrupt: Fix stepping into interrupt handlers
From:   Sean Christopherson <seanjc@google.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023, Ilya Leoshkevich wrote:
> Ilya Leoshkevich (6):
>   KVM: s390: interrupt: Fix single-stepping into interrupt handlers
>   KVM: s390: interrupt: Fix single-stepping into program interrupt
>     handlers
>   KVM: s390: interrupt: Fix single-stepping kernel-emulated instructions
>   KVM: s390: interrupt: Fix single-stepping userspace-emulated
>     instructions
>   KVM: s390: interrupt: Fix single-stepping keyless mode exits
>   KVM: s390: selftests: Add selftest for single-stepping

FYI, the selftests change silently conflicts with a global s/ASSERT_EQ/TEST_ASSERT_EQ
rename[1], but the conflicts are very straightforward to resolve (just prepend TEST_).
If we want to proactively avoid mild pain in linux-next, one option would be to merge
the full kvm-x86/selftests branch/tag once I've made that immutable[2] (will be done
Friday if there are no fireworks).  Though we can probably just get away with doing
nothing other than letting Paolo know there's a silent conflict.

[1] https://lore.kernel.org/all/169101245511.1754469.7852701829984104093.b4-ty@google.com
[2] https://lore.kernel.org/all/169101267140.1755771.17089576255751273053.b4-ty@google.com

