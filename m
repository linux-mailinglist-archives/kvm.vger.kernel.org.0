Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3891643A493
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 22:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbhJYU1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 16:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbhJYU06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 16:26:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948F0C06965A
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 13:13:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s7-20020a25aa07000000b005bfb84d2315so19254468ybi.0
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 13:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=c9TMSSQDkdJckQqgk1hQJ6Z3xWFgZz2oJuTapjWnAto=;
        b=Hmmi585al96YhjrNsBozCKeUSsjxcY+9cb3dVhw8c8LAOlBpL6FI6zre4ofU/j2I/J
         V862W70ij9ivO1OZv5jdgJxaJ15S8Ia/rZT6P7IabKA/GJNEUL6a0wqOS32GO/wzzTtF
         Hx5w4djmSNoIi4SvDjNkaq5c/xl2t986X98KgD2AV3CZkE+ajJ/ANEYrZsaVGkx5CYa5
         7mhxXq5Byy5xgwFmlSplm6VWUcQobVycDE9HXKM5DooNjtSD2FtuwkkQRDeDFVnrUGRG
         ifhMl9/CMlLQ8EMsnorspXLn48zgLAklfYbmFEDiPYTggB7skFlhjYV32yZ8wKlb5Oe+
         29qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=c9TMSSQDkdJckQqgk1hQJ6Z3xWFgZz2oJuTapjWnAto=;
        b=y44kSK2idUGtw1C49qFYUab9Aww36RopciFQ6OeexmjETGCcEoaLLLZTXChjDh/uUD
         CEfsAb8ZMP234sj7DwppWyn4iiZahkod9xMH/41KcQ+OL9hhC4jTk4pJMUr1Z+/AD2/j
         3WU15Wo0AiGVy3Oe4Vd37a+AX4bzmTvcN1FL9FAqiGOCCzYgHwzcdj7KC9/qtgFt0L+X
         aiJ6ab9q2BY1saz7321oMjtcabNNRz9UWAmH0AtRO6ZcqHnj2tySxLfXThmVKfpbGH0a
         gA+OHzDZp+LovGpfxvpNNdbbOWEgcNcW587O/DudVO4HwO4M5e1UvVaRW1+Mab03T/F4
         6Arw==
X-Gm-Message-State: AOAM532zeY/PE+s7MDg7UskCBL2lgLNR+WK7Pr3OXVZdPEWVV71ysv/n
        rSkullEwHWE0LDaAn8+B3ifIL38Ber8=
X-Google-Smtp-Source: ABdhPJzn6GPUNwCw/iEfKewQMUshkaPgozSQ1anxYst/oAgSpVR/9rUQxDjo0whaxXVvN0vFpNOzpYrJQlc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:ffbb:dc28:15d8:6cdc])
 (user=seanjc job=sendgmr) by 2002:a25:c88:: with SMTP id 130mr19489124ybm.176.1635192793836;
 Mon, 25 Oct 2021 13:13:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 25 Oct 2021 13:13:09 -0700
Message-Id: <20211025201311.1881846-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH 0/2] KVM: x86: Rep string I/O WARN removal and test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove a WARN that was added as part of the recent I/O overhaul to play
nice with SEV-ES string I/O.

For the record, my FIXME in lieu of a WARN was deliberate, as I suspected
userspace could trigger a WARN ;-)

Based on kvm/master, commit 95e16b4792b0 ("KVM: SEV-ES: go over the
sev_pio_data buffer in multiple passes if needed").

Sean Christopherson (2):
  KVM: x86: Don't WARN if userspace mucks with RCX during string I/O
    exit
  KVM: selftests: Add test to verify KVM doesn't explode on "bad" I/O

 arch/x86/kvm/x86.c                            |   9 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/userspace_io_test.c  | 114 ++++++++++++++++++
 4 files changed, 123 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_io_test.c

-- 
2.33.0.1079.g6e70778dc9-goog

