Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1F01D88F6
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 22:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgERUQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 16:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERUQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 16:16:17 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AD0C061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 13:16:17 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id o16so13250426qto.12
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 13:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=E/Lnnyqh/lIivI+1URST7q6N2yYOibnHjeOOhY+GB/M=;
        b=PtcPYJSWjRgmemqaf9hq8pOmW726EE92vxW7O2VPll+hIdFZJmUcU0wKaEx7c/O8xG
         rpW7rf/D7XLOXq9OT3kOZb5suGSrlzYRwNnz9qAkCO8C3zFjg+cMresPJE+7MQvj1Ky4
         tb2zXw/dPCGjpArbWXdXeqpO6a0J86QANu+nhkRwHc8ApVJ6/L0dwr0PjO4xonQ1HzHn
         w8OyimH8H+JdPNeEIK7VcALgT7SWQFLttW9f8UmhA5Eyt06+iiJGj2kZv8Lr9Zv6Kikf
         7npoJFCKx02vxw8/jJ/BQ56s0zKY22sNf3qsGhqkeTT9qBjd75XPreCswLbXm9TqCoax
         6zKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=E/Lnnyqh/lIivI+1URST7q6N2yYOibnHjeOOhY+GB/M=;
        b=ueqDiIcX6GFpXcctp3W46NzhajnzeLy7H+RliO8w7BSq9gD5cIcVdBfXjP/EHgKtUf
         B3xgBiUcWEBtkRttPLeik1Dowezq1bZLxJXdgTUSNO6w9em5kBy5yjWQTDNd5yII6F1u
         7Zwo+lJIYPnB+IWpeBRVejHnQsaxvaei5R6fwJYneQ0WpbJvxwh6BtxRbKV18UykQWQ2
         puwjeMR8lwWdoS7ogpxWpnBAZ7Ukhgk05NlPm2lgiZOa26nslapnNdixklBVa41KBQH8
         bWrMrLoOg+mvUGA1WtNY1u8VrAvurX2g2b1bCp7VbBMOUTvPIClsr5jZ0JbXAq52s0Bh
         F7/Q==
X-Gm-Message-State: AOAM530XMjeDSZTrYBVyCvd6dETkVHdzBNbLzG92iZku3L00lDwYdTQd
        QeiBRx4MYjCgI8rwFFwo5bGvR+ppKdLQa4ssFbZ6n1MWxknjjW075Nf4EbuAyfuMefMgIGfbC1p
        JM5J01yWD7Ngm7nCCUtnAzO1i8eEOpnrYWhILxdn4S40ESJzz6Z8jvrEkfSiHWzxsrZvT6JZFvF
        BEZq8=
X-Google-Smtp-Source: ABdhPJy691o5sLjc2nzmh9X7ocGJANa+iBKDwes9LiQsV058FJOvj21R96Dq4hERKutpZtjYsEgOz0FG574G6RctQNk6sg==
X-Received: by 2002:a25:4cc4:: with SMTP id z187mr30161244yba.274.1589832976751;
 Mon, 18 May 2020 13:16:16 -0700 (PDT)
Date:   Mon, 18 May 2020 13:15:58 -0700
Message-Id: <20200518201600.255669-1-makarandsonare@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH  0/2] Fix VMX preemption timer migration
From:   Makarand Sonare <makarandsonare@google.com>
To:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Cc:     Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix VMX preemption timer migration. Add a selftest to ensure post migration
both L1 and L2 VM observe the VMX preemption timer exit close to the original
expiration deadline.

Makarand Sonare (1):
  KVM: selftests: VMX preemption timer migration test

Peter Shier (1):
  KVM: nVMX: Fix VMX preemption timer migration

 Documentation/virt/kvm/api.rst                |   4 +
 arch/x86/include/uapi/asm/kvm.h               |   2 +
 arch/x86/kvm/vmx/nested.c                     |  61 ++++-
 arch/x86/kvm/vmx/vmx.h                        |   1 +
 arch/x86/kvm/x86.c                            |   3 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/arch/x86/include/uapi/asm/kvm.h         |   3 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  11 +-
 .../selftests/kvm/include/x86_64/vmx.h        |  27 ++
 .../kvm/x86_64/vmx_preemption_timer_test.c    | 256 ++++++++++++++++++
 13 files changed, 362 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c

--
2.26.2.761.g0e0b3e54be-goog

