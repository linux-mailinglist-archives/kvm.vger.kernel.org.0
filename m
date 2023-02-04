Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FA368A746
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 01:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjBDAbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 19:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjBDAbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 19:31:41 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB20E99D4A
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 16:31:40 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id h16-20020a63df50000000b004f74bc0c71fso813487pgj.18
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 16:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ovs7iQ+tfeI7w6azGbOrEAxMZouDlct5a973AB7AMGw=;
        b=iGVjBX+0PS9UxR7UzWAUgjBM6sc7TQer1UlH7jLJ0CaxHzRa039HKM8PTzY7qlUKkQ
         ZswCz7Zg1M4y6wZikhewEL/mDal22aK4hgbuV1XV5fBOxiUj9aDtKNVkf2AERmUpXNzJ
         F4W1GKNyL7HzkSxH03XlZWGaZEBSlu4qxKf3WDyeaHvisG+X2CjqLh1sU2kOYxiLOThn
         YY8vA+o//xG2uev9yRMCFJUJ0D2NnzEaWW/J6l3Lb0DYXsoZCuidG8S+ZaCfeDgzAN8p
         94Sm+TXHg5jaeEAtBS+uWJCyigBIvAjylryr8Y+vCnyW0d0wBXmpH+SrggGufQHZ9H+X
         vAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ovs7iQ+tfeI7w6azGbOrEAxMZouDlct5a973AB7AMGw=;
        b=PQJDOl7pcj6qx6NJRtPK2E5N2Vj1cC/PPgt7U+qJojaUISVDVCUAduuZoKaJe+xh0g
         AG32RSoYhhyb7QcUfe8MINb2UcVSdXAP8E7Hj36Xr1UkZod7/diIMRIg7GFsRNi2ZkSh
         AS3TRgH3iaI1SvkkPtnZoXcm4KnEAdsYR8Vqeibu49abLG6VrXb66t0ySDIk+cd0RQru
         2rCehpY6rD6fxgVTNvcD4G9ADt2HI1uuB8hXOP45+fM3lz50sYZRZcW6dmsoKih76jBU
         L9Ia7xUsT0OMvt7LSbp8AqOkv8wJTE/StmbesQkY8gi6XsozHt54ZoRTpxP10ypBoJnE
         bCIg==
X-Gm-Message-State: AO0yUKW3E3HbjdZd8LXf2KDvYyw8NFFy00B1tlgzQkr3KBQGY1WHSgrh
        l1dhXusqALyPhLBahrFpzKVlyxXVpzI=
X-Google-Smtp-Source: AK7set+dfbQJqs533ffOyhAWuqyjy1PEP11TUIoZNFXFCTfQmGHVmdcxtAeirQ2myqCBNgJ5Oq3p+spGkHA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1490:b0:593:8deb:820c with SMTP id
 v16-20020a056a00149000b005938deb820cmr2727422pfu.2.1675470700139; Fri, 03 Feb
 2023 16:31:40 -0800 (PST)
Date:   Sat,  4 Feb 2023 00:31:08 +0000
In-Reply-To: <20230107001256.2365304-1-mhal@rbox.co>
Mime-Version: 1.0
References: <20230107001256.2365304-1-mhal@rbox.co>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <167546859235.189151.11265081003538435603.b4-ty@google.com>
Subject: Re: [PATCH v2 0/6] kvm->lock vs. SRCU sync optimizations
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Cc:     dwmw2@infradead.org, paul@xen.org, pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 07 Jan 2023 01:12:50 +0100, Michal Luczaj wrote:
> This series is mostly about unlocking kvm->lock before synchronizing SRCU.
> Discussed at https://lore.kernel.org/kvm/Y7dN0Negds7XUbvI@google.com/ .
> 
> I'm mentioning the fact it's an optimization (not a bugfix; at least under
> the assumption that Xen does not break the lock order anymore) meant to
> reduce the time spent under the mutex. Sean, would that suffice?
> 
> [...]

Applied to kvm-x86 misc, thanks!

Note, I massaged a few changelogs to provide more context and justification,
but didn't see a need to respond to individual patches.

[1/6] KVM: x86: Optimize kvm->lock and SRCU interaction (KVM_SET_PMU_EVENT_FILTER)
      https://github.com/kvm-x86/linux/commit/95744a90db18
[2/6] KVM: x86: Optimize kvm->lock and SRCU interaction (KVM_X86_SET_MSR_FILTER)
      https://github.com/kvm-x86/linux/commit/708f799d22fe
[3/6] KVM: x86: Simplify msr_filter update
      https://github.com/kvm-x86/linux/commit/4d85cfcaa82f
[4/6] KVM: x86: Explicitly state lockdep condition of msr_filter update
      https://github.com/kvm-x86/linux/commit/1fdefb8bd862
[5/6] KVM: x86: Remove unnecessary initialization in kvm_vm_ioctl_set_msr_filter()
      https://github.com/kvm-x86/linux/commit/4559e6cf45b5
[6/6] KVM: x86: Simplify msr_io()
      https://github.com/kvm-x86/linux/commit/e73ba25fdc24

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
