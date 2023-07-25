Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FD07606C2
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 05:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjGYDju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 23:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjGYDjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 23:39:49 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B311720
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 20:39:48 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b9d80e33fbso28643985ad.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 20:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690256387; x=1690861187;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OxaQz8/dLUNQNqi3QcL8AYfrflhdJ7sgQboufy3/A+o=;
        b=KhNu4YQP6ZPTI26YT1NmhHtBFTMWY9KjsBVT5XdGpp9q9vSOtRztr10kkLsKIkIdEA
         AjrMKv4ORu6ukKIP7NdeJZ8W4LQabEz9QLQ/AjtGuB1gIgF/UuXVGSHLm9jghmkXxI4U
         tbFm2BOz3J8nWUQLHBwZEHrD1yKYoXTTHLS+ph5+HwIllX3E6HV1JNJxZ9RRtSN3Vl2K
         uOj8M5TClaMcL7wd3Gr34qQwFRDSwn8crkTRIf0RFGJUmsnucZXNrivbFjPRwGNxvFTJ
         lCCo2DJuGGh7M4moYNMbPcB08YygDuzs6FBlbZqO1OChJMC3kaggkQQuWvdDFQGHU6Gq
         kQlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690256387; x=1690861187;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OxaQz8/dLUNQNqi3QcL8AYfrflhdJ7sgQboufy3/A+o=;
        b=fGEU2uRI5P8JiWcIyF71RY8IeADkNl7EYp9qvf7BA6yofQS1xnpjAjzPRdfLSgKAFQ
         qoBw6uPJpmnk2tvNeHXqKS94OuSVzcfoBXmVYscv+phyKvlhnU0ivNJEJvv66LPQ6+Qt
         VOUef/RF4N06WcGNhEOH3DqGNhJjm3SxPXKnNvwfrKDIZpYR+AYELVhatiGlRsgkrLHX
         4gOJSfq8BSOoXrQaH4dpBcCzIirEAnMuTf2kw9NKH5FRDEn+u8RvZl288H/KTjfO1gZO
         Q98AZQERMb5oC1mdQ/rOxCwklZJxAVVYvJaibRc6szztnRXPJuwIKEgJ8OUWxlQFEzEi
         ryew==
X-Gm-Message-State: ABy/qLattAudPMBLf75zVX8Z3Fm9sUd+YpU7vftWQJC0gg7C0wyMd3TW
        VZqAv5TIVLlzu+kBjBGPZLs9H8/AzyA=
X-Google-Smtp-Source: APBJJlGXKceh8dnRLA5IcWKDRWLGwQm7IqO+MWrKEL6RTxngP9u2ZyWQQlP3JDy8Ok0aLfhcGDi7Iw==
X-Received: by 2002:a17:902:9a89:b0:1bb:7996:b267 with SMTP id w9-20020a1709029a8900b001bb7996b267mr6223851plp.17.1690256387242;
        Mon, 24 Jul 2023 20:39:47 -0700 (PDT)
Received: from wheely.local0.net ([118.102.104.45])
        by smtp.gmail.com with ESMTPSA id i5-20020a170902c94500b001b809082a69sm9793112pla.235.2023.07.24.20.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 20:39:46 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH 0/3] migration: fixes and multiple migration
Date:   Tue, 25 Jul 2023 13:39:34 +1000
Message-Id: <20230725033937.277156-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Spent too long looking at bash code after posting previous RFC, but
got it into shape.

The first 2 seem to be real bugs you can trigger by making a test
case fail. Third IMO is pretty solid now but no users yet so I can
keep it around and resubmit with a user some time later.

Thanks,
Nick

Nicholas Piggin (3):
  migration: Fix test harness hang on fifo
  migration: Fix test harness hang if source does not reach migration
    point
  arch-run: Support multiple migrations

 lib/migrate.c         |  8 +++---
 lib/migrate.h         |  1 +
 scripts/arch-run.bash | 65 ++++++++++++++++++++++++++++++++++++-------
 3 files changed, 60 insertions(+), 14 deletions(-)

-- 
2.40.1

