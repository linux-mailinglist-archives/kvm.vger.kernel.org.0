Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB07D724A44
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 19:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbjFFRbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 13:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238772AbjFFRbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 13:31:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BB010F0
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 10:30:55 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53fa2d0c2ebso1946848a12.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 10:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686072654; x=1688664654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dXKYuUg7HoIp7PZjxrN4e8/tttddAPBgDCmI9zzNWIM=;
        b=SdF8/Z8EJeQRk6nebFYNKI2ucCPZHcq5xy8rfaeU4njQPuJ7kQD4azGin/4+gcsoYN
         T9nCw0DFwLMYDwiicyCl+XEXq94tp9cQFrvkr7ZFTRPM/JB+daXfx0nXheK8kXrPF/dc
         /aC6zuULKdGJLxMhHBrUt+V4MzKkdO4sAQe+keAXvWNSCMaApSLvB3SBe+8DVBkjOYes
         P5hTSpCcJmIzeoyw+GZbX6//R83wPKpDiFqvMwtkpzDpUg9qrBi290KMuxvUwJuagkIm
         TzQoatrZ8G21t/ztprM6CizXlJOLzoQt+N/156P0Wvc97YTtFzZ242UvZXCanXGzqmri
         RQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686072654; x=1688664654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dXKYuUg7HoIp7PZjxrN4e8/tttddAPBgDCmI9zzNWIM=;
        b=eCw1h/mbmEmJKv0YpLkcHDJUYP6lgIQ8HdxCjDNE1I5HKovIekH9V6FQyg9lpwqgjH
         oPq7lfuXwOGc416vVHxL5e+C2nBhIPZLYstOE0wWV8kgxNN3N67hPTztASdNQRhl5LAS
         G2z6sEkKTi/dxxlHoiiNlR6jmVxkIq9BbWUHySa5kyp92gnjZcQ2c3KpoKwtPm5LBieM
         qXkakg9kbY34hbUHo6N4duxno/sHbIT0KRM7ytIv7zM/gjNMUw9hGG4EsHuscoSyO8vD
         gI5Xkh6NqsMpndy+BjluQyZhK27PnXhd4Sx6ItiQ9k+7FRdJLaj/HiU3C84pyMhXB6GK
         SE7g==
X-Gm-Message-State: AC+VfDwzIxFy7mnmWGOFF5ImY//2QseKviygQgOLSI5piRsKBd7Ss41m
        26uG6MLUd1pbg7KPOIgfk/d5aL5oEdo=
X-Google-Smtp-Source: ACHHUZ4i/DCFPvysT54z4dqzO5kTYCE62ZranopSaW8d8GEcgURpwx2SFcJj3U6mfewoMduvG5M7OXMP73Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:58c5:0:b0:540:ca81:4a1d with SMTP id
 e5-20020a6558c5000000b00540ca814a1dmr571812pgu.11.1686072654653; Tue, 06 Jun
 2023 10:30:54 -0700 (PDT)
Date:   Tue,  6 Jun 2023 10:26:57 -0700
In-Reply-To: <20230524061634.54141-1-chao.gao@intel.com>
Mime-Version: 1.0
References: <20230524061634.54141-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168607240700.1276728.3313479971658390819.b4-ty@google.com>
Subject: Re: [PATCH v2 0/3] MSR_IA32_ARCH_CAPABILITIES cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, Chao Gao <chao.gao@intel.com>
Cc:     xiaoyao.li@intel.com,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
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

On Wed, 24 May 2023 14:16:30 +0800, Chao Gao wrote:
> Do some cleanups about MSR_IA32_ARCH_CAPABILITIES in KVM e.g, fix stale
> comments, elimite open-coded MSR reads, track features that can be exposed to
> guests to avoid computing them runtime. They are found when reading the code.
> 
> No functional change intented.
> 
> Changes from v1 -> v2:
> 1. toggle ARCH_CAP_SKIP_VMENTRY_L1DFLUSH bit when l1tf mitigation state is
>    changed by module param. [Xiaoyao, Sean]
> 2. add more cleanups (patch 2/3)
> 
> [...]

Applied [2/3] to kvm-x86 misc, no need for that one to wait for the dust to
settle on the "supported" snapshot.  Thanks!

[2/3] KVM: x86: Correct the name for skipping VMENTER l1d flush
      https://github.com/kvm-x86/linux/commit/02f1b0b73660

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
