Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D626D7903BD
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 00:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240231AbjIAWuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 18:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjIAWuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 18:50:11 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C9E196
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 15:50:08 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-26f49ad3b86so2815642a91.3
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 15:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693608607; x=1694213407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FlKKCfU6lwqTWahfFIsUJe3N10TYJrm9hB//kG9T5vo=;
        b=kf/xs9STb6SGoeZ7Dk1UbdeUbP2HL/92pxY+h6Hsvij1X5CmMrXUAFg58QRVmXZF6E
         RCZ7ugua0WHWaurekHilfj2NhpqDX1FbTOc0RMNmO482XXoiJ0LwlVzfKjYnok+xDrBC
         Bs/fqmPZtt9wMoeDoy+KXizyZ5w7kAjdBjcQ8daLA5UN06V2RXhGbojZpvYSBvuFRpqg
         qTS9exLDZ3CJ+rCoBor2VZXruIk20VPk5l9GVM6fRxJ2Do/gmQbsQ6dAFVPfySlhYKie
         GFT3qB6jFrqn8KGo4yQmKFDnB5FXm/aG7/z+28RDy7oEbV8EP0tht/Dh4VWSZERKq3oQ
         GEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693608607; x=1694213407;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlKKCfU6lwqTWahfFIsUJe3N10TYJrm9hB//kG9T5vo=;
        b=P4o5dph4tFRFwWHYLOWfp3nfoc0zSJ90TbyP/YX+4V1NI3EPC/LYmeNBf0VZjISDT/
         swsTDLqyiuWEW9OU8JBGULKaFdtW65U7HdNhIJZQPajRlNC4Zgrn/RGfvBo7sBEb2QBw
         EtfMA4sOi8pJ6X4LMUUPatZgB41bTHvxnfPI5zJvXVavtFrePbnDyfmdHLJaN1RwwuNr
         SeFPyzEhgZz/mLf/LgCbicUTUDqH/IA1wSJif469vUtq/49gvysbfJWOa0OJ2jUAuoff
         9OOHxti/LBXXPa8aM3Pc2vhNK4n25px7xQgcGZ4RBaZZUwLp9FGZT7fRP+j5arusOe3g
         Uj/A==
X-Gm-Message-State: AOJu0YzF2d+MDKmGSCLR750OrfDv0ug2Tt8RxLrp9BKNRQqo8xSNZH2J
        a1+jClEN/RNyKonVcmb2mceBTFuv2Zs=
X-Google-Smtp-Source: AGHT+IE1HELSIbvuGYPn1KfDGfkON3D65TyqxyLdx0Dc4Z48ZOYNryO+mjkRlpEhsxz7GxWSpYUeOlaICUg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e887:b0:1bc:e6a:205e with SMTP id
 w7-20020a170902e88700b001bc0e6a205emr1352221plg.5.1693608607623; Fri, 01 Sep
 2023 15:50:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  1 Sep 2023 15:49:56 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230901225004.3604702-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/7] nVMX: Fix garbage "host addr size" tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This started out as a "simple" fix for vCPUs without PCID, which thanks to
a bug on Alderlake/Raptorlake, are suddenly quite prevelant.  Then I got
the bright idea to tidy up a bit, and lo and behold, test_host_addr_size()
is full of garbage.

Patches 2 and 3 are cleanups to reduce indentation and help detect bogus
setups.

Patch 4 renames vmlaunch_succeeds(), which has bugged me forever, and would
get especially weird when the last patch adds a version that _must_ fail.

Patches 5-7 fix the HOST_RIP testcases.  Unsurpisingly, vmlaunch() writes
HOST_RIP to ensure the resulting VM-Exit doesn't go into the weeds, which
means the tests that write HOST_RIP and expect meaningful test coverage are
completely useless.  Patch 5 deliberately introduces a test failure by
exposing the underlying bugs related to the above.

I could have ordered the patches to not introduce the bug, but I'm more
than a bit annoyed at the moment, and I want to highlight the issue, as
not restoring/sanitizing state is a massive problem throughout KUT, and
the nVMX tests in particular are a horrible mess in this regard.

Patch 6 rips out the HOST_RIP tests that provide no meaningful coverage and
have no hope of passing.

Patch 7 fixes the noncanonical HOST_RIP testcase by using a bare VMLAUNCH.

Sean Christopherson (7):
  nVMX: Test CR4.PCIDE can be set for 64-bit host iff PCID is supported
  nVMX: Assert CR4.PAE is set when testing 64-bit host
  nVMX: Assert that the test is configured for 64-bit mode
  nVMX: Rename vmlaunch_succeeds() to vmlaunch()
  nVMX: Shuffle test_host_addr_size() tests to "restore" CR4 and RIP
  nVMX: Drop testcase that falsely claims to verify vmcs.HOST_RIP[63:32]
  nVMX: Fix the noncanonical HOST_RIP testcase

 x86/vmx_tests.c | 122 ++++++++++++++++++++++++++++--------------------
 1 file changed, 71 insertions(+), 51 deletions(-)


base-commit: e8f8554f810821e37f05112a46ae9775a029b5d1
-- 
2.42.0.283.g2d96d420d3-goog

