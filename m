Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E9B664BCA
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 19:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbjAJS7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 13:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239777AbjAJS6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 13:58:35 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A3D26CF
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 10:58:27 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 31-20020a17090a0fa200b00226e43409c2so5170705pjz.9
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 10:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QkDHaL3LaMHWtJtBt02a3dk6dVQ22Akc4nPiBV7pqqM=;
        b=JDdFGY6AvPVG7FpYMmZ9o2qqrL+RkBPaZNi2CN4Mn+4LitAaiDH2PwmJaVBaZeUtun
         UZYp8ezN8wbUU8c8qepaC64M6NjziL3/EMqIHInjzCXtEXcEw0yCZtLRil3+at7TUo1q
         Etxg0LEhEM0gS7HU8d8zzPpg1BcRIaG/KC1g/ZnktbvtYbR1nlqgAGAD4mf+TNCyvMz/
         /C4cueQlQKXqKhEgrkixrEu2zsiNnYO2JxcEbZTrc6RjkROmhcNoxF856n6qdIjL55r+
         aZ6IpTpJ0c9v2ybbJae+MRzqN5mSKfT3aDIeWhbDM4PNDQSk3/T3ElcyBw5U0wIttBga
         FMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QkDHaL3LaMHWtJtBt02a3dk6dVQ22Akc4nPiBV7pqqM=;
        b=O0JN6DPmz/Ie/ljlMNusXnSQFQDrQ/q1j+SkLwQXzxQa711kdss+A2j2S1q5uFea9v
         Bhunswo5rTLE70vYRf8gLuTKztkNxshy16Lcmh5jk7A2mz/AOCx/Z4XlvjgpTLh8fGnb
         PatIRVrGeER1wAFPC9xhi9WCdlou/y9rroHhNfAqUSF7nFwF6xp4etsiX4bR6JhmRK8D
         bBzhE+3b9YVLwHDNlJhT5++M8opZNbn4BeXxUEMB5lUjNudji8uOpzIqU+2N8lZphvnr
         XSjzuLdrrid3pfpW6tD6jQ7wrWVsVC7GMbFwWPXGsj/2sDQuL+atq94QdlAWG1OC2yZq
         1Wxw==
X-Gm-Message-State: AFqh2krk245vMtCbqKziDAdPJR1E/glSblbRW4yRPBtqfXzITmmHb57P
        YZ6pn+4Vru3OQLViNLn040VLPQWC9hAwQYDXlh60KOKkZ2x07StX8/Nm6ghtuWb/LJsWBzl8cSa
        rZfFJnEH9r7Cfx4ndQL+7w9IMeEXYVj1EVe9w2r7iKkGxPnB8OHLJ/EOFyZlm
X-Google-Smtp-Source: AMrXdXsORJaJqusebv2OHlH1y/rJw7SNL+AJcj8/wDIaKD8r052wmiF/rhkszcOaGJFrpJWCFuOsJ/OvLJhf
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:aa7:8051:0:b0:582:e939:183d with SMTP id
 y17-20020aa78051000000b00582e939183dmr2492635pfm.63.1673377106539; Tue, 10
 Jan 2023 10:58:26 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 10 Jan 2023 18:58:19 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110185823.1856951-1-mizhang@google.com>
Subject: [PATCH 0/4] Add extra checkings to amx_test
From:   Mingwei Zhang <mizhang@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMX architecture involves several entities such as xstate, XCR0,
IA32_XFD. This series add several missing checks on top of the existing
amx_test. In particular, the 1st commit just fixes a typo in comment.
The 2nd and 4th commit focus on the properties of IA32_XFD/IA32_XFD_ERR
when interating with xsavec and #NM, while the 3rd commit adds the
checking of xcomp_bv in xstate.

Mingwei Zhang (4):
  KVM: selftests: x86: Fix an error in comment of amx_test
  KVM: selftests: x86: Add check of IA32_XFD in amx_test
  KVM: selftests: x86: Enable checking on xcomp_bv in amx_test
  KVM: selftests: x86: Repeat the checking of xheader when IA32_XFD[18]
    is set in amx_test

 tools/testing/selftests/kvm/x86_64/amx_test.c | 43 +++++++++++++++++--
 1 file changed, 40 insertions(+), 3 deletions(-)

-- 
2.39.0.314.g84b9a713c41-goog

