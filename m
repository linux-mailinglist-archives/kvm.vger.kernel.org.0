Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A771871F7D4
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbjFBBZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbjFBBZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:25:37 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3C11AD
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:25:35 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53fd224ad48so694922a12.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685669135; x=1688261135;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lq7frf+VgUfmOcmAYYbmBY1JZgdr/fBmTrjKZPM1pj0=;
        b=6opU3e6fL9Q2z10jgMTSS2TfElIhcUyIZ4E8KVXvRK8L2P3i4e9+XsJ7X8Jj1DW+4B
         2Jxr72BRCij/H5jbc8xb4ZVQDTcLOYtpvYicgfEjiUqlR7LzHdj7X7q9hxVjXh2PygsL
         1GzcoOWH1Kb6zXaPaURpdVNdObpLCoyi5ZTO1zAgqVTKZNoNTMKDp+wO8qDdNIM++7Qf
         Xx1PCz0zL+5ncBK5TrkAB3qRHnCODkqurJWSazHKToxcCgR64F87sgTFf6r8WRPlaHL5
         B87GOMYt7UXfezGjQ9flbuasNAYxhGV+wZcdmH8brldnVK1a9xQgTQqGGlWFl20FTHQV
         Otpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685669135; x=1688261135;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lq7frf+VgUfmOcmAYYbmBY1JZgdr/fBmTrjKZPM1pj0=;
        b=KEZVmuCaAnX211bpKIM3hM0uY0fOhEL2BL34gXV1tNmDc1/NpG1VfURJNZgN4osA1X
         kEYKkR8++44fJkV1Vlc6rWptaWIYuUON5doL/so1s1aDGOKxNWNbHjX9pdpUqHmEaI8H
         ujjDKX+0KJennBab7JbnjW+HZNfnbV3WejE/fj4lRywdsyDvoRQFdk5om5u1QLDYnt1I
         zKadNH+HzojRSgu0jeqIWuGsAeYK861QTb+e2SVlZZ0mnzjiuftjOtVr0zUXPDNxzEw0
         A0y9lM3UT37E0uTJAL+g/DfoZunJeGUC3NnGgkAHH3tOv0W7Z2li+6onv4sGyxhAHg8N
         oBMw==
X-Gm-Message-State: AC+VfDzFVmsDT91Hw2BsmqKSXS8R4z+FLmpx7BLthlvFF6Qjx2OV791G
        Pj+sWMXX5lo5WQSTqPErkMie10tjXB4=
X-Google-Smtp-Source: ACHHUZ6d2ywVeoK0qZleaJ2VSaV1W+BhkYAd4W0LGnTJwO57JRWRO/J25Yg2F/8UhBAToQYz7fV5XA9Mb1w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:db16:0:b0:520:7943:3de4 with SMTP id
 e22-20020a63db16000000b0052079433de4mr1997990pgg.4.1685669135301; Thu, 01 Jun
 2023 18:25:35 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:23:38 -0700
In-Reply-To: <20230427201112.2164776-1-peterx@redhat.com>
Mime-Version: 1.0
References: <20230427201112.2164776-1-peterx@redhat.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168556721574.515120.10821482819846567909.b4-ty@google.com>
Subject: Re: [PATCH 0/2] selftests/kvm: Fixes for demand paging test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>
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

On Thu, 27 Apr 2023 16:11:10 -0400, Peter Xu wrote:
> Two trivial fixes per subject, please see each patch, thanks.
> 
> Peter Xu (2):
>   selftests/kvm: Setup vcpu_alias only for minor mode test
>   selftests/kvm: Allow dump per-vcpu info for uffd threads
> 
> .../testing/selftests/kvm/demand_paging_test.c  | 17 +++++++++--------
>  .../selftests/kvm/lib/userfaultfd_util.c        |  4 ++--
>  2 files changed, 11 insertions(+), 10 deletions(-)
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/2] selftests/kvm: Setup vcpu_alias only for minor mode test
      https://github.com/kvm-x86/linux/commit/ba125de35da5
[2/2] selftests/kvm: Allow dump per-vcpu info for uffd threads
      https://github.com/kvm-x86/linux/commit/21912a653d7d

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
