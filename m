Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14F25F16A1
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbiI3XZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbiI3XZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:25:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD67A8CC5
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:25:05 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-352e29ff8c2so55662397b3.21
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date;
        bh=SfDYQhii7AzyAPCyAJplNJblpYaUlSFyTSjl8z/eY00=;
        b=QySEEDRymXq3FHDv3F5SvFVmwvJNZonnDf6Vx9zAUimD1+JT6cWxsjm4ck76f7vPeV
         x/+Io0ghkn+SWQQ5y30Zs+mubEeE5ge14hWKpNPdE1zHnr2jvjbZOKMXMw043yXMZJBU
         d1i20hRhtwMuBDL2vZMOCUNZqtRjh+sz4CNeScus4jzVtdQsxDI7g76WallsGIEdC1hF
         UQEVcNuFHmmBQ40IGdxoddgeNxiUJC8gZDg0y0AjqinrL+5rPA7UqyAo4h3C8lkPKC/z
         /y7teh0KNbJTj/qRndvWGFC8/quwRzoD28Y+0sQObWfuRGsTh3/Cxz3XjkXXNRb+OWfM
         xH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=SfDYQhii7AzyAPCyAJplNJblpYaUlSFyTSjl8z/eY00=;
        b=TH3ew/7pEs69QvXYvthAGbIl+CTAVKnsuAiFYDSl/rZ8jqEfe77vjahtsbmkqwS2KM
         uzhvkWgk8fM4BsCBmrqou+bq+n2j0AOXKZhCasKJfWbcvC5X/j59WDloWWv241kG+MXm
         Z/CGUIDLcaLcyQKV3uAI1Ioahga8LlHGt2XtDO6yuJwYCguVF13UBMMURgPhwrdC5EEY
         JFiYN9W9ChQNuqObPc08UEDaevE5wSFt+f+2bohkbyMtNE70SGYJbOITJLDo7iGO/J2u
         3pWENnSjdV34n2UWLZbol++GJzBnAWgpxb7DmWsBPxJmLys26V/l01wibhA6VMDTpfd0
         hFxw==
X-Gm-Message-State: ACrzQf3uHqW1EAhyVAkIoXbGWbzwQC4n7V//p07SoTBxZGuB1BJzP91h
        GATK+T68gTrH/XDFRHsaBwmNplutzGQ=
X-Google-Smtp-Source: AMsMyM5HZvuNHk8Ctqn6hOnKsnMw22PcyX0U8DNOSDZ3BL5hWZ9XJ15m6gTz0ndf3UeaNDDsmBnz28uUF4E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:7b41:0:b0:356:4ab:d538 with SMTP id
 w62-20020a817b41000000b0035604abd538mr6088982ywc.508.1664580291960; Fri, 30
 Sep 2022 16:24:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 30 Sep 2022 23:24:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220930232450.1677811-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/3] nVMX: Fix VMREAD/VMWRITE #PF tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks to a recent gcc update, the VMREAD/VMWRITE #PF tests are now
failing due to gcc-12 optimizing away a non-volatile flag that it thinks
can't possibly change.  Avoid the volatile shenanigans entirely by
switching to ASM_TRY(), and dedup the two tests.

Sean Christopherson (3):
  x86: Handle all known exceptions with ASM_TRY()
  nVMX: Use ASM_TRY() for VMREAD and VMWRITE page fault tests
  nVMX: Dedup the bulk of the VMREAD/VMWRITE #PF tests

 lib/x86/desc.c |  10 ++--
 x86/vmx.c      | 158 ++++++++++++++-----------------------------------
 2 files changed, 49 insertions(+), 119 deletions(-)


base-commit: d8a4f9e5e8d69d4ef257b40d6cd666bd2f63494e
-- 
2.38.0.rc1.362.ged0d419d3c-goog

