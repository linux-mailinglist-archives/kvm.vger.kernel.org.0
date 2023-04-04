Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9BE6D70D2
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 01:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbjDDXlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 19:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjDDXlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 19:41:16 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C7C40D9
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 16:41:14 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h8-20020a654688000000b0050fa9ced8e3so9972465pgr.18
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 16:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680651674;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZTrBcRKleW9UrcsDyVQMvkBhRymFuvTtYNyd2YnMnF0=;
        b=Ef3XmLF5Sh/XzSLLiqk2F+jAGNymh5KUEZksUtHOcVXGz7TwZhiDj5i/8rL3k0HoNn
         rdWLtbzmvcesq0oShXoi8tOR5Zb5NcX2Uwv6QFsMaN/AKo7VeEPjLpXl7ZJ7sIfbbpun
         ksQWfvufTpHr/bRq3nkN4ffIZayods8+nW0x8t4NH60gp6VCrhqiy9krxP4rbefYAcoJ
         soUwfKSuLKXnj/ouQwMtTp2YNLn/YPcaWqBCU5ElIEPb6eWoxeQUACo6cEsXx4/fNJfj
         Y8DU88a4sQbVNaXScy1STZ1r96zwYQn1X2ytxZZL1Ga2Gfy7hIPAUakuJTI+kKdXn3Yr
         yCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680651674;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTrBcRKleW9UrcsDyVQMvkBhRymFuvTtYNyd2YnMnF0=;
        b=dam4PFn7ik/1AM2jUQJmHIyzqnK92mfJ1kLD1onnZEgUm1Fh1xdy59otB/A4P0N4kb
         555olZTD5wGv8ZHwW0oP1pZte/o/9Lz4J0pbdxptezH3wKXv3Lv5ndNBI8a3l2t+IfY5
         1RnOB/JVwaMhu24iyFs1wiFNTXbhiqklNFrOK7OMbtcuxLYTMn2ElRycdCNXHEWcWHfK
         8ekd4wN0hH6McfU1P6/2hQ49jq1Jl+ppj64xIMbIY/gbuN7NGZzIQGtGx8jVfZtU+P9j
         SnLIfnIu8FKMJRVEWyVHrWzcUo5AjENT1N6wIocbnMgMus4HFzyfg60r+HM6OluHBBpU
         UnqQ==
X-Gm-Message-State: AAQBX9es8wpSuKj8S+1iSxG3IIO/CRuneXO7tLsAnQ0//e8LeQLyzvEE
        GpszogzcEr63tTlyG6amuLHiY9NfCV4=
X-Google-Smtp-Source: AKy350Zq0hmsfnsiNYr1hK5ROMTl9FP3TSgRHzpa0ByzzRFApkBLsudMAUprENvUfgvRwFdNsS+sJOdkyys=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ac16:b0:240:ab2b:5420 with SMTP id
 o22-20020a17090aac1600b00240ab2b5420mr1542031pjq.9.1680651674325; Tue, 04 Apr
 2023 16:41:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 16:41:10 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404234112.367850-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/2] x86: Fix goofs in FEP access configs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix goofs in the config from the FEP access changes.  I tested the changes
manually before posting, but only did the standard "run everything" after
the fact.

Sean Christopherson (2):
  x86: Set forced emulation access timeouts to 240
  x86: Exclude forced emulation #PF access test from base "vmx" test

 x86/unittests.cfg | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


base-commit: 723a5703848d91f7aea8bc01d12fe8b1a6fc2391
-- 
2.40.0.348.gf938b09366-goog

