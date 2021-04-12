Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6246935D2F6
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343673AbhDLWVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240210AbhDLWVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:21:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B03C061574
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 15:20:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l30so1832462ybj.1
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 15:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=FmBbxZ043goYbQIFSTxJ5QFyMNro4zr+9usEl2+6KDo=;
        b=hebwHaNs+u2Qy3E5HnHs5sMbimi6gtUB5qGU2iwPTwr39qciShPjHjm2OjWEBnJv/H
         2Z5lGaeZ/CxTwz0GnZt4uyBMidroUpcfjHNxD54TFfmT7toDqzikl9Kp3K708NdTulaq
         W4OEOj+1tePlpcyup7wK3zdUH2C+ypfZ8CSjfzyfsQWY8Cp3lkXJ7quWGdr9OyKdluhS
         sAGgDl84wKM4pJWIvxCUz5iIFkXGbBy2e4pKVc/RfErxIS8M7GpgnWrctmIW06X5AoFQ
         r2LHB4gYWVJVQ7b3s/WBQz5yD9mZ15LQChGVrPOYofyYgxHHbWTzu0E6ydSR4VVS8EYU
         /c4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=FmBbxZ043goYbQIFSTxJ5QFyMNro4zr+9usEl2+6KDo=;
        b=kjxe30DdEEqx/Ew45x0hQqEI3OpBUDu2mE4g9F+vm3GMZuTXXS1zGnkrkfunB/sm5/
         32y6rHFJDMGBlh/DIQkyMWf+PLa1g0zg6L+w3DiCUjibArg5aJ9sITW2vHHzKJwfCopS
         UbUE6XjyLQLQDrEmlPlvp61suOHFmsNYyOmEqx+p4KGNiGOlM1p32DZRXcypcu9Y44pP
         QE1SAFR7IqnUp75oJ12ipqTKEklGGkQWUxye7DJFvQMCY6R6hdOoNa6oQCduftIukkal
         bqyo4q5vQVjftL8n3D6rop7CPy1c1xnnYZGZuwLFBmNqm3u31a8WSiQs3XFY64KPh821
         MPTw==
X-Gm-Message-State: AOAM530V+Bif8jiYcAOXuIioUBssM1jn491cA6V0vUWYR96cT+IkpQSG
        oKavcyWqOUx+FlE5DubvDxszjZ4PkF8=
X-Google-Smtp-Source: ABdhPJxLzjwHbeMX6Sc39ErUuoMnIIuqepvQr0GA8yDCc1C9yqhYjoovvhYRQv4GKHvI5QOlH8N/sWIX7t0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f031:9c1c:56c7:c3bf])
 (user=seanjc job=sendgmr) by 2002:a25:25d0:: with SMTP id l199mr27919439ybl.256.1618266053917;
 Mon, 12 Apr 2021 15:20:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 12 Apr 2021 15:20:47 -0700
Message-Id: <20210412222050.876100-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH 0/3] KVM: Fixes and a cleanup for coalesced MMIO
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Hao Sun <sunhao.th@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix two bugs that are exposed if unregistered a device on an I/O bus fails
due to OOM.  Tack on opportunistic cleanup in the related code.
 
Sean Christopherson (3):
  KVM: Destroy I/O bus devices on unregister failure _after_ sync'ing
    SRCU
  KVM: Stop looking for coalesced MMIO zones if the bus is destroyed
  KVM: Add proper lockdep assertion in I/O bus unregister

 include/linux/kvm_host.h  |  4 ++--
 virt/kvm/coalesced_mmio.c | 19 +++++++++++++++++--
 virt/kvm/kvm_main.c       | 26 ++++++++++++++++----------
 3 files changed, 35 insertions(+), 14 deletions(-)

-- 
2.31.1.295.g9ea45b61b8-goog

