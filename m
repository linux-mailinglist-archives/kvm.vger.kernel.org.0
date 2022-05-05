Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4804951C28B
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 16:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380637AbiEEOai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 10:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378188AbiEEOaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 10:30:35 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88003AE46
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 07:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651760814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i0cUYdqS9xzmHM5kRAiCV+ZbNGelOHxmao2CZi0snPU=;
        b=OdY94zFDeMEAvcR0QfEOWDzP7yRVYisL3d8x5B3F/ggHjAJna+ogvpUmddgiIrd7MyeT7Z
        CDeVks34nX8QmS3GdcA/sdjUP1WPNvIMkWicqE2o7P29jHvKCtpgiXlmQMZ4IV8p39EHOZ
        HuEVsTV48duc1QTFJ7VDkkGlKDZuk/Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-2LHtWPp4OZSJNa8KfmQfNA-1; Thu, 05 May 2022 10:26:46 -0400
X-MC-Unique: 2LHtWPp4OZSJNa8KfmQfNA-1
Received: by mail-wr1-f69.google.com with SMTP id v17-20020a056000163100b0020c9b0e9039so496370wrb.18
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 07:26:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=i0cUYdqS9xzmHM5kRAiCV+ZbNGelOHxmao2CZi0snPU=;
        b=072fBSEMDOkkzQzwHcrzD9/GybWvKkV/D4s5E5xD12pnx7Fe5he6CQERHe3CXJFKGX
         0vIGR+wdzFUF3ZjcEwsHbexLqb8WK6YwXFQjCbGAOwAahU4+6CL5UIC/7xaaBSi9+HwS
         JYvKBAPJiulcxxcCDMiH73MseIjDagLw2voEjFxierWHpBcjHstvuavXUjrSyvbV89NK
         fdSrTgtkr7jpE0rVCBerrGTHUqMIOLCH4h8otf/b0xlC2pr6AXR+X2ZJv8ZZN1W1ZK8Y
         TKOQ3Mo3DYBVUH9GkiKv7NtylgHOkK0JYBZw5jDEtjsZKVARxFCdqulw8JNCyLBjWaTE
         W9OA==
X-Gm-Message-State: AOAM531+MoolulfzD0MkyNNwJaIbhFGGWajjsnBLJvS71g37CFyTLQXp
        CKENShPF44M1K+rhp1I8C548dIWxn++C9j6LdLnhLQKcLECcKGFZEUuV8THCfLJzj8gw1goJKNl
        vDo1JgGq22Omn
X-Received: by 2002:a5d:6c68:0:b0:20c:7246:a86 with SMTP id r8-20020a5d6c68000000b0020c72460a86mr11371719wrz.283.1651760804942;
        Thu, 05 May 2022 07:26:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfO9wYCP5WFn8whkyiypT2RoD+B4ozX8T8FJ9GKGRxy89IUG4oGCdAZOy4HeM1xugGkuYWeA==
X-Received: by 2002:a5d:6c68:0:b0:20c:7246:a86 with SMTP id r8-20020a5d6c68000000b0020c72460a86mr11371709wrz.283.1651760804754;
        Thu, 05 May 2022 07:26:44 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s22-20020a1cf216000000b003942a244ee9sm1476899wmc.46.2022.05.05.07.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 07:26:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 000/128] KVM: selftests: Overhaul APIs, purge VCPU_ID
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
References: <20220504224914.1654036-1-seanjc@google.com>
Date:   Thu, 05 May 2022 16:26:43 +0200
Message-ID: <8735ho12e4.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Overhaul KVM's selftest APIs to get selftests to a state where adding new
> features and writing tests is less painful/disgusting (I feel dirty every
> time I copy+paste VCPU_ID).
>
> The primary theme is to stop treating tests like second class citizens.
> Stop hiding vcpu, kvm_vm, etc...  There's no sensitive data/constructs, and
> the encapsulation has led to really, really bad and difficult to maintain
> code.  E.g. having to pass around the VM just to call a vCPU ioctl(),
> arbitrary non-zero vCPU IDs, tests having to care about the vCPU ID in the
> first place, etc...
>
> The other theme in the rework is to deduplicate code and try to set us
> up for success in the future.  E.g. provide macros/helpers instead of
> spamming CTRL-C => CTRL-V (see the -700 LoC), structure the VM creation
> APIs to build on one another, etc...
>
> The ridiculous patch count (as opposed to just laughable) is due to
> converting each test away from using hardcoded vCPU IDs in a separate patch.
> The vast majority of those patches probably aren't worth reviewing in depth,
> the changes are mostly mechanical in nature.
>
> However, _running_ non-x86 tests (or tests that have unique non-x86
> behavior) would be extremely valuable.  All patches have been compile tested
> on x86, arm, risc-v, and s390, but I've only run the tests on x86.  Based on
> my track record for the x86+common tests, I will be very, very surprised if
> I didn't break any of the non-x86 tests, e.g. pthread_create()'s 'void *'
> param tripped me up multiple times.
>
> I believe the only x86 test I haven't run is amx_test, due to lack of
> hardware.
>
> Based on kvm/queue + kvm/master (wanted to avoid conflicts with fixes that
> are sitting in kvm/master):
>
>   2fd3ab9c169a Merge remote-tracking branch 'kvm/master' into x86/selftests_overhaul
>   2764011106d0 (kvm/queue) KVM: VMX: Include MKTME KeyID bits in shadow_zero_check
>
> Cc: kvm@vger.kernel.org
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>

This looks like a really nice API cleanup and a lot of work, thanks!
I've skimmed through the series and nothing besides '-Werror' caught my
eye (I've commented separately). I think that if post-series selftests
still compile and run with the same result on VMX/SVM/ARM we should get
this merged early as any patch to selftests is going to break the
mergeability and rebasing this is no fun.

Also, this series conflicts with my Hyper-V IPI/TLB flush selftests
added in "[PATCH v3 00/34] KVM: x86: hyper-v: Fine-grained TLB flush +
L2 TLB flush feature" but I can certainly rebase as soon as this hits
kvm/queue.

...

-- 
Vitaly

