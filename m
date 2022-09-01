Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCC55AA06E
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 21:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiIATxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 15:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiIATw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 15:52:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A87247B8C
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 12:52:59 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33ef3e5faeeso231616177b3.0
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 12:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=o7Y/J55YrNoOFsUg2eZcRMAMIK262wAufkGrjfPIWIw=;
        b=awpueYoFJD25VxHhQhdduolZ/yQfJbPNStK/0pi/6ZanOfhNmUmz0A4fRFh1gUAQB7
         bdZHJk+bVB0dXuwRu5WEhE/15nu59h8rjlQKAOH5p+9XjcgG5aXGvZZucga5orNfoRmH
         D4YyF7CDBwNzkW8LcTeNrOR0dXSOhLveW54dLCFEZMpmAJcIsfxnTW777XgJsX+vTQQ6
         nOGo3FLoBSht76HvnCZBqCvTnXEjQywpgjBYaWa9XgIsQIcNJxBmK3wC8zzmE3FrrWm0
         MNLmMCFaP/PntqsgGHHmftgUVowANA00MSGxXoxKQB/vW9gN0gmjAMK3qiuUOY+/PLK7
         R0vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=o7Y/J55YrNoOFsUg2eZcRMAMIK262wAufkGrjfPIWIw=;
        b=0IQZqJSFWH+BYxXa2Ori5chXnDQ9vCWrSRiEIp837yxCpcymfc/RQ+XsUQ0XstUS7o
         R7aLhgLAjPuQ0/flSKDx0yu8jo9zYuNzHC5IlWwsUeBPb3VjEP1K3CknmfkbLluLhZlu
         d0KIj+m60Uzi1gIWzFd152EDytLwsQLZsYWNJ+uEa1/3K5lEKeylFAReWB+DMDmSRf58
         w0zXDYEMM8gjwzCYxZyIe7VkA4YTl7gqda2RqBm0RuIW88ULfwzUNyZ6z8t+DI6lXfUl
         onllJVBrbPtL9+D9ycwlOLz97XRL/5VIQywIpedgia6z2ogZrnahoJ8zghfIjPdlV4hX
         8Z0A==
X-Gm-Message-State: ACgBeo36NIL/zJb8fFdRdW8wWpK7ouLeO9sym3r7AuzmkH4q4o0XjN0e
        2kYrtolLpq46CWAmpTbP1MkZo3PdXPhAjFugcBAddr0J8vLJuDQcNj+GUZ1NexBm+UEo7iksNXv
        TMjAPLNw58SukJzJAhfSFP0wNRjO+1patoIWbpZHc+JhgxiAQxRH9YpEKZQAtrg0WIYBY/n8=
X-Google-Smtp-Source: AA6agR48Kfd3+0PtoDeJ+ESNJTHRcRqFsZgzAO0J1G15yOteC8S1WgSiv3eg8IY+JkYm3R2Tv6giY4jlv2hO/5T9pQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:d04d:0:b0:69c:a60e:4ecf with SMTP
 id h74-20020a25d04d000000b0069ca60e4ecfmr8496208ybg.526.1662061978229; Thu,
 01 Sep 2022 12:52:58 -0700 (PDT)
Date:   Thu,  1 Sep 2022 19:52:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220901195237.2152238-1-coltonlewis@google.com>
Subject: [PATCH v3 0/3] Randomize memory access of dirty_log_perf_test
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds the ability to randomize parts of dirty_log_perf_test,
specifically the order pages are accessed and whether pages are read
or written.

This version scraps the use of arrays to remove the memory management
concerns and implementes a well-known random number generator, the
Park-Miller Linear Congruential Generator, for the guest code to use
directly. From comments on v2, several others agree this is the right
approach. I came to the same conclusion and was already working on it.

Though I had this idea and ignored it previously over concerns about
introducing mysterious code, doing some research convinced me
Park-Miller is both extremely easy to understand and high enough
quality for this purpose. I also believe this approach better
preserves the integrity of the test as a couple math instructions are
definitely faster than fetching from memory.

Compiled and run on x86_64 and arm64 to test the new flags.
Based on v5.19 as tests on kvm/queue do not build

Colton Lewis (3):
  KVM: selftests: Implement random number generation for guest code.
  KVM: selftests: Randomize which pages are written vs read.
  KVM: selftests: Randomize page access order.

 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 48 +++++++++++++------
 .../selftests/kvm/include/perf_test_util.h    |  8 +++-
 .../selftests/kvm/lib/perf_test_util.c        | 40 +++++++++++++---
 4 files changed, 74 insertions(+), 24 deletions(-)

--
2.37.2.672.g94769d06f0-goog
