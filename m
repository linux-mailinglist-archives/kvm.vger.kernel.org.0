Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB8D3DAC42
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 21:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhG2T4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 15:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhG2T4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 15:56:49 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DDFC061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 12:56:46 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id q137-20020a6b8e8f0000b02904bd1794d00eso4475270iod.7
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 12:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OUDEC1vqPr7sdUdf2B7zr2nu10+QX6s5o8FUl8jn128=;
        b=m3lZXoM3uP217QVv6csbkAltS9NEEhlX5Mu2B9nMMbJPkm+CF/zpiI1uNtLlaJ3MpF
         XKTxlciv8MR41Pp5L7tMTygFtTj8t5ato+tsIPb5PxLea28TW9AIQvorz4AvHHqUrbg0
         jl3TKtHlXkF/6dnirx+9CmRoi0oSZz7bUs5HqwZT5mfm5EptQVI1kIijkc+NydchjeGY
         k0xOPjTs+IS75wZoMWlION+1nkDz7PARYeuzxq5NugWy+CbXKybB1hCyzW6h9gKEWy7+
         JUI3EAqUwjfTN7sgZnM5Nc3G7DjRq4i1Np6UemRK4blDB/Bfs7c1L0Ww9qGVNI4nCEqF
         71mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OUDEC1vqPr7sdUdf2B7zr2nu10+QX6s5o8FUl8jn128=;
        b=aNKRvncl2t9lZZK/3BcmX5v66jfnMQeRtGsizPObLErXQbuijR/Ka1qkDvovo5t3ip
         GB83KdbyiLqIZElYcGD175JqR+6sgSVOX9fhleA8wBemFYoxx87H/uk+Ue/1FWnYjtHZ
         nrFXlHuyc/WElF6dwnwNDt0s1ZA6VycHCsOxekwuhnBOR0RD141L6E2bwPVZY3haKw9C
         vi+tSD5+0XLvEiEeKCyeD3mblGzcsL0pcYvXmxuLqoL1e+a0XIlAgz2gOFtTJwqfbdxN
         sk19ro9xCXQyf6yAux6nH+XVjiPLuieW8c5SExi9nJLjNmKAz3d7e+ExQyjLvWDmE+dT
         7TAg==
X-Gm-Message-State: AOAM530HdhuZPYpZoKQfe4CE3BkyyhbrWLUBOJ9tcFfdNjItkAlEnJpb
        U9vM5+BZ5jxZjKyuSTUAHWgUfW9Hfbw=
X-Google-Smtp-Source: ABdhPJwrrRQSELpkKclDmiXvKjRHCNyfC/t/jEaDJIBbOW61CMAAggTennP0JRqnhAKMtQYKP8Wl+xwYsLI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:2416:: with SMTP id
 z22mr5873473jat.57.1627588605328; Thu, 29 Jul 2021 12:56:45 -0700 (PDT)
Date:   Thu, 29 Jul 2021 19:56:31 +0000
In-Reply-To: <20210729195632.489978-1-oupton@google.com>
Message-Id: <20210729195632.489978-3-oupton@google.com>
Mime-Version: 1.0
References: <20210729195632.489978-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 2/3] entry: KVM: Allow use of generic KVM entry w/o full
 generic support
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Guangyu Shi <guangyus@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some architectures (e.g. arm64) have yet to adopt the generic entry
infrastructure. Despite that, it would be nice to use some common
plumbing for guest entry/exit handling. For example, KVM/arm64 currently
does not handle TIF_NOTIFY_PENDING correctly.

Allow use of only the generic KVM entry code by tightening up the
include list. No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 include/linux/entry-kvm.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 136b8d97d8c0..0d7865a0731c 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -2,7 +2,11 @@
 #ifndef __LINUX_ENTRYKVM_H
 #define __LINUX_ENTRYKVM_H
 
-#include <linux/entry-common.h>
+#include <linux/static_call_types.h>
+#include <linux/tracehook.h>
+#include <linux/syscalls.h>
+#include <linux/seccomp.h>
+#include <linux/sched.h>
 #include <linux/tick.h>
 
 /* Transfer to guest mode work */
-- 
2.32.0.554.ge1b32706d8-goog

