Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909677270B6
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjFGVs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjFGVs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:48:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03851FC2
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:48:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-565ba5667d5so115209747b3.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686174536; x=1688766536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=24i4ZpInVA9Du9a9Xo0Uv6MiWYisMUzqAG7CEIdELlw=;
        b=JNOphaD6vaP2jz4GZ7/nvvTJ+7lf8NXrHCn6+xM7huMaIHaBzll97XCcOmWn2vCMhF
         TCMHu1r+1P8ywMiiMfOuLL/SvFz7nvRtuGzzLBdsDRdNxv7QKfGbJsxNJutv4ZgUx4Wy
         pqexacpZNlTNplJrhEs6G3pDORqKb8trSMnFtY9WpOSjcKHx2APiRuJGDC6f3taJLVRJ
         D9nwMXS/0r+oSLK6sAzUr9qjG76vPSgStCIiUsNfG8JlQDxMaV+LCE4eNUrZTsqtJAnQ
         UkkASsfCF7Tg2dqNkkxS50JIyxtif5ynw5Z5B3+kYrr5L/xsWpny6fvxOvyIjvf0WaiG
         B+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686174536; x=1688766536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=24i4ZpInVA9Du9a9Xo0Uv6MiWYisMUzqAG7CEIdELlw=;
        b=DaDdFQw+qn0//NRANJQWDKO0Qn8hJskqRUmtHcZwq/S85RYNFSYyCCJHuXbmwsSXg5
         1D6tip01D9CKwHxVFauihlzzwORUnxdB2PCMUsw/WwzL4gla/Wn2b0mPwZG5ukWfBqBT
         kn9jJgpLlBdJ+Y0RHjuS6TntSaBObGLaI6WbBMb0wGHeixEYTscDLiKXiQaD6caks90E
         qc2EbeequcZscsFdrE4F73KGYFXtR8d4hW53AZwEyxmQfxLotP6wDYYf9NUX5lXIiqXZ
         HTff+y0qOZpOBCafo07XbUPHTCdDMNAjJV7NG3gsIigbHyxjW5jdY73f/3wzCbr+6LEC
         hveg==
X-Gm-Message-State: AC+VfDyWwIdkmDyQWRYLXvWeL7Ae7QSNrYI9FIsglbZVTFBqg1tIKaW6
        DDgNEjqgh8ZitcJr6Otcov7TQ+30khc=
X-Google-Smtp-Source: ACHHUZ6+ybG/Ek3u5Dm2xCl7Ns7IwNNHmAl34QtjSmMPcBlQD4GKtKc2lihfgWUuI11fqdvKJU2Rv97Apv0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:7602:0:b0:565:ce25:2693 with SMTP id
 r2-20020a817602000000b00565ce252693mr3565111ywc.3.1686174536191; Wed, 07 Jun
 2023 14:48:56 -0700 (PDT)
Date:   Wed, 7 Jun 2023 14:48:54 -0700
In-Reply-To: <20230221082925.16014-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230221082925.16014-1-likexu@tencent.com>
Message-ID: <ZID7Ro8vTnhAl2jo@google.com>
Subject: Re: [PATCH kvm-unit-tests] x86/pmu: Check counter is working properly
 before AMD pmu init
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 21, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Avoid misleading pmu initialisation when vPMU is globally disabled
> by performing a read/write consistency test on one of AMD's counters.
> Without this check, pmu test will fail rather than be skipped.

This is unnecessary, the testcases can instead check KVM's enable_pmu module param.
Of course, runtime.bash has a bug and doesn't play nice with multiple requirements,
but that's easy enough to fix.  Patches incoming.

@@ -206,7 +206,7 @@ extra_params = -cpu max,vendor=GenuineIntel
 [pmu]
 file = pmu.flat
 extra_params = -cpu max
-check = /proc/sys/kernel/nmi_watchdog=0
+check = /sys/module/kvm/parameters/enable_pmu=Y /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
 groups = pmu
