Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C38B7152AA
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 02:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjE3Avy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 20:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjE3Avw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 20:51:52 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E61D9
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 17:51:51 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-565f1145dc8so23203427b3.1
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 17:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=binghamton.edu; s=google; t=1685407910; x=1687999910;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cgE3FstVR/tvsWGBxnSbcx721qA6Blm5fT4Ys3ixZ0A=;
        b=InLwHYhIrZCHMIYa3QIicSc/HtMWpxI2Hkr8V5LiWVD2BK6AsKQ4zrnL9YFh2npb4y
         RhGqWsQA52x1kbpLnJyQ0fnQIUsHiAcAAObYpk53yzRLjoYm58zLFkzZwy2fxq+iG/34
         7DWaysZh/Gwwdv3G/tNAlrUYLRsXIoC+qqoBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685407910; x=1687999910;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cgE3FstVR/tvsWGBxnSbcx721qA6Blm5fT4Ys3ixZ0A=;
        b=MchXtZ4yBFB4bg5LujhXIAXJ4u8of/O/cKu/Niaz/1nF06jLot/ccIBTxKR5/F2pbe
         6L0p1jBSIPpKkQ6QLJpK0LWNpyNtTPUNpDoQfJa3nK9ltuBC7FlG1K78GXDfRXIESl6O
         VxUuZ+TstXWM1CTTVxOQ9rO85l2QYwZi3yqD0/ol1t9EqCIpf5xluZpf3hQqRE4ji4qp
         rlbvfIiPKoerl0bRUtAElBcZ9irvT0ngbjhVt1FC1eqxvo2NCpelPAx+7XPYF7sYb1R+
         AaGcYGCrzL/Q8J30lxJgDPESPE8Mw2CMnCxzuJ16D9l/SwOrqyLQli7XZpovmrnyXi9g
         yUug==
X-Gm-Message-State: AC+VfDzQJ3+hPr4HdOdGCDE0jKE7HhD409a7F5mAVgHpeB0CEgBbK7ks
        un6iCxhD2T/3OhnAgA++msNvowqFx0WhFuvF1trefZdyasgpgMbHLBU=
X-Google-Smtp-Source: ACHHUZ6pI566FkkA9gspdAgmSLE4ZwloRQqcTxAmvUHVRA2ktKyKl6ygu+NO8pghPTJNXvYQFDJmtLkVr9LpUZ6O+T4=
X-Received: by 2002:a81:7d41:0:b0:561:e690:7c0e with SMTP id
 y62-20020a817d41000000b00561e6907c0emr655491ywc.21.1685407910164; Mon, 29 May
 2023 17:51:50 -0700 (PDT)
MIME-Version: 1.0
From:   Roja Eswaran <reswara1@binghamton.edu>
Date:   Mon, 29 May 2023 17:51:37 -0700
Message-ID: <CAGTfD8bYH6acW2sr_U7r4Xcad55L8DuUkWYYaAkEsRp=wW_MHw@mail.gmail.com>
Subject: RDMA migration is slower than TCP
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello everyone,

I have encountered a problem regarding the migration process using
RDMA, which seems to have a longer total time compared to TCP.

Here are the relevant details:
- Network configuration: Mellanox ConnectX-3 Pro EN 40G NIC
- Software versions: QEMU 4.2.0, kernel 4.4.0

Steps taken:
1) Installed MLNX_OFED from NVIDIA as instructed.
2) Compiled QEMU with the "--enabled-rdma" flag to ensure the presence
of librdmacs and libibverbs interfaces.
3) Verified bandwidth using iperf for both RDMA and TCP. RDMA achieved
26 Gbits/sec, while TCP reached 20 Gbits/sec, demonstrating the
expected superiority of RDMA.
4) During the migration of a 30GB VM at the maximum migration speed of
40G, I observed the following migration times:
   - RDMA: 13531ms
   - TCP: 13483ms

I'm uncertain about what might be causing this discrepancy. Any
insights or suggestions would be greatly appreciated. Thank you.

--
Thanks,
Roja
