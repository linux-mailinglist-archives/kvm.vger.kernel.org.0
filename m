Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEC53FA150
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 23:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhH0V7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 17:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhH0V7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 17:59:23 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0CAC0613D9
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 14:58:33 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id b13-20020a92dccd0000b0290223ea53d878so5023906ilr.19
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 14:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zEqo65HFDniYflruEifCzsGz9EVUlfE1N13W9ndiFw8=;
        b=Kf5wvNW/F8mZENQSvB6E0t62gx2c13xS9fZ7bvLOY/uUK3eG29DV9WfFReAeHMMBM6
         uUIfykSV6VJY80Hh2Z4401C4axUd3T1FM1WgeyixkrnoOfVlrFTia4IqSCo9VNRR2JSf
         IhWdS3onWejDsQ+4rvGuHBdvmHdVj9gdHdOFTvU6U7r65c5ICMAFOZ9iMMmz9J93v5s7
         PQ4TCjXWljFu7DI7EuSpYQwq/0P9KKzBuoy0lJw85BNlwCd+aVFGymOad//ol+aX/457
         wiBbeBSWej8la76YXEOxRQqW5sP8X7MjRQXfoV5C2eReoKsOR2rdng0BFMInfbi6wV0h
         iWfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zEqo65HFDniYflruEifCzsGz9EVUlfE1N13W9ndiFw8=;
        b=Imsm/wWxnjMKl3sqBZRfuPitgypfXJGeBPPxNNvgF9hj/OV3fJp+Vc0HzpbkAdGjQ3
         0l1CobvVm6gm44+Y4eYvhaKjEXCP+kb7ygPVsZ7kSVn0jOw+9GnT2/riiGLe0vTcpIp8
         gePpxGl9dhaxrKWolb0FJw9JjIb11QGbGu+DCGjTI2M9z9Lm8qPqOONMGpS0l3+wzbWE
         FZ8qpMhWdpWFjqysocq+xyQGahT6rZwBA0vfTHaPd89MehkiIPBVMcrT79WZXCNHJ/Jw
         szYLUSXtnQWU4ItmtiHQPXRCwA3gT3LYCkdcmToSY17l9X9cfzf6wsO+txhBKxZkScwF
         VG7Q==
X-Gm-Message-State: AOAM531725tDAjHGt2IKEdNPd19AGw05PIG14yh5iegREblOFFQ8Hly4
        xmEqQ/8tbQBSwrHz+IxfwA6eWaephIXxmRGgMSpCQ87hZ6YNhDgyR55QDCPu76WifoxZv+WwCVe
        Ls5v2IYHPAuacoxcrB1u8Bv8P/Vox7hjOv7ZT2xSpjLMg/qPxvGvq559GtQ==
X-Google-Smtp-Source: ABdhPJwffoNQdD/D+ASti6AvwuymHnK3xqKzLwLel1ZYsRFrWbbSuNMVpIKrlgv4Bqgz/Bcn4un7QeXuqUQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:cbb0:: with SMTP id v16mr10001890jap.114.1630101513235;
 Fri, 27 Aug 2021 14:58:33 -0700 (PDT)
Date:   Fri, 27 Aug 2021 21:58:25 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210827215827.3774670-1-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [RFC kvmtool PATCH 0/2] PSCI SYSTEM_SUSPEND support
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>, reijiw@google.com,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series was developed to test support for PSCI SYSTEM_SUSPEND
currently proposed for KVM/arm64 [1]. Since there isn't much for kvmtool
to do for a suspend (we don't have save/restore), just restart the guest
immediately.

Tested on kvm-arm/next kernel with the aforementioned series applied.

[1] https://lore.kernel.org/r/20210819223640.3564975-1-oupton@google.com

Oliver Upton (2):
  TESTONLY: KVM: Update KVM headers
  KVM/arm64: Add support for KVM_CAP_ARM_SYSTEM_SUSPEND

 arm/kvm.c           |  12 ++
 include/kvm/kvm.h   |   1 +
 include/linux/kvm.h | 414 +++++++++++++++++++++++++++++++++++++++++++-
 kvm-cpu.c           |   5 +
 kvm.c               |   7 +
 5 files changed, 432 insertions(+), 7 deletions(-)

-- 
2.33.0.259.gc128427fd7-goog

