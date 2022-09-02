Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B361E5ABB72
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 01:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIBXxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 19:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIBXxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 19:53:47 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79A710A9FC
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 16:53:46 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-11eb8b133fbso8716493fac.0
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 16:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=byFLwcg9x+gHraQrqrEjfjLMCVWO7X/nOfj7IDMY3JQ=;
        b=SLR7s6DN3bky4K+LC1+1d0AzZwNu7yioQOGM3fFOlV94bseaQ/Rd0gDXkNqDpPBC7U
         eek5W0S6ZhArYn3JXNozRo5mCovGV3zkppeniezxm/5TYKowBbxG/+tU1WntPhHrFsiX
         jC7gmwWpmEtFxxqQFbfO6Oww1HGHc6mC1DTsHONo89/+xRXnDNNexyZrM06NlZsythVB
         Q8E29a+zDC05AqdgTFvrs/v7Zc1Lb88TGrfxbRPKY+ImG8GVWvr810AdXt7FeMrUQD2f
         +Y59cy9WHAuRU0B3yl2RjEaB8hyiJmDoWFiYvNH8F7rF/5ICU4Y42tqs8+QkwBe5lWpL
         xmZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=byFLwcg9x+gHraQrqrEjfjLMCVWO7X/nOfj7IDMY3JQ=;
        b=ge8H3g0zIeNjxVDL4uB923AqanGvgQGl8XRb0/g70Wb7qelMHnbNOu/0sLGNuOb6Xp
         SEVLcQs4TDe/O5a1asVHgiTjop93VDol5a/YVZJyYs7PLQWufVFg4LOOi4aLCi0LAdDr
         Ylxd6xhqbY3f6lW/3UBibo1AlDSw+wefP2aR8OWHGX9JknmqGXywq7AOwh1dnn5qieKv
         YYJxlHx+oxsg0wJzjQEcLoPOsV4gVtLKUnnlEO7J70aqu5tTxTTwySRO/Jg2/LbS45i0
         6hTdpAZgIjSewFKTRqSzy6TJ8i4EeoPKHALA9BNGmMurxTSln+d7hLV/QeoBvl2NKFds
         RWiQ==
X-Gm-Message-State: ACgBeo3gl9QV/IExejj14ZYmAX79BwCwdBKIRcwDhLDCDR6uk9wUxkyD
        JOThEcSCfzKLZwPEbqSssyoiz/CASGiqEA7NX8w8nAEokA2OTw==
X-Google-Smtp-Source: AA6agR5Ue+jJQk0uTbnYd4ZmU2F8/8Ge4iyvhriOFKo1lQ9rqjKQaoRTE/2cJcqZbzuHfotBva5iq+zA5+w5/JqsXJk=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr3431670oab.112.1662162825981; Fri, 02
 Sep 2022 16:53:45 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 2 Sep 2022 16:53:35 -0700
Message-ID: <CALMp9eRkuPPtkv7LadDDMT6DuKhvscJX0Fjyf2h05ijoxkYaoQ@mail.gmail.com>
Subject: Guest IA32_SPEC_CTRL on AMD hosts without X86_FEATURE_V_SPEC_CTRL
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Moger, Babu" <Babu.Moger@amd.com>, jpoimboe@kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On the Intel side, restoration of the guest's IA32_SPEC_CTRL is done
as late as possible, with the comment:

* IMPORTANT: To avoid RSB underflow attacks and any other nastiness,
* there must not be any returns or indirect branches between this code
* and vmentry.

In light of CVE-2022-23825 ("Branch Type Confusion"), don't we also
need to avoid returns or indirect branches between the wrmsr and
VM-entry on AMD hosts without X86_FEATURE_V_SPEC_CTRL?

Yet, we still restore the guest's IA32_SPEC_CTRL quite early, with the comment:

* If this vCPU has touched SPEC_CTRL, restore the guest's value if
* it's non-zero. Since vmentry is serialising on affected CPUs, there
* is no need to worry about the conditional branch over the wrmsr
* being speculatively taken.

This entire comment seems quite stale, and not relevant today.
