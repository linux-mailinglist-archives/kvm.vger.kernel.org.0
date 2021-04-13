Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B80235D899
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 09:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhDMHQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 03:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237515AbhDMHQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 03:16:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D816BC061574;
        Tue, 13 Apr 2021 00:16:20 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d124so10816539pfa.13;
        Tue, 13 Apr 2021 00:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4jaLokaB9YgYGQd1dte3mGoZJD+miSFwfBYhbyWtFbs=;
        b=jjh64cmhug+f7SLA7mg20jYLt0Z/v2rJIYUWy5rAgV0dkPAb/0h6Mnc2vuWxoX6akK
         99L2qqnphiDmeOHfQtbTxbc/ghnbtvZ89QPfve1Sy+tt8uCcStSSJ3sREiMNyuKgFr0U
         mYGIecSUAqIcqF/0KbgAP8cW0PrdlebHvpFsWlOPD0cBOeLmF7SLV3rumTir5ZE3Pfba
         y+5fMB+Oqd/tFtYbr6yW9uRdd3g7JcTD7Db5WgClMDFGoeO4PVkd3xu5zEB+oQ82xz7c
         CNYiBQEtMIrguncbmpm6UlX/zei6ulwdXJuOCrFuxX9p0SqYCWyJ5OmlQvFgVYZMYlK4
         VNXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4jaLokaB9YgYGQd1dte3mGoZJD+miSFwfBYhbyWtFbs=;
        b=PSHwcXDu5sn5u949FCOxjzJUhBRg7p3AmjOCK6K1kLng56O7njWZqBQgTMncX3AR+C
         nmpcEeQwj7OmXL9VOwNyOn0D9ycWDaunhC/ByfV7f/IMrAhkXdKKj1KpIOfTl3e1lk4H
         O1jaUfe6EOuY7DfWuD2RuFnkXKeYog+9XzvVubDEOEuNTgyHZhd7q6Cj1OHozXmR/nH+
         GYr8KvajumloD3xo9H4sy3wukrqizzE2ysVbBZutMC2PuJzfaCEizZ+5A4TwNOZMchXF
         spNGNC/g3jZ7IeQX+rLsrKcOguTYA1vQ8EO3hKJqAjPNdgbPIP0HYfbacOdWGEqOYauV
         66yA==
X-Gm-Message-State: AOAM532rM7syq0udoA5OmpLjTd3xK/Ex6tDcNA4N4CfCtwdJgB/jfBWz
        PV/ywBdA6rdk0x4KkjyJk7+Kj9yVD48=
X-Google-Smtp-Source: ABdhPJxHMv+p+T4Gek6gYXJ37Y4b4Fh/Wylwlnld+vQvNYSEcBNARDog28+6qhAwEYLaLpqhY5RcUw==
X-Received: by 2002:a65:6483:: with SMTP id e3mr31253666pgv.208.1618298180233;
        Tue, 13 Apr 2021 00:16:20 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id i10sm2031088pjm.1.2021.04.13.00.16.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Apr 2021 00:16:19 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
Subject: [PATCH v2 0/3] KVM: Properly account for guest CPU time
Date:   Tue, 13 Apr 2021 15:16:06 +0800
Message-Id: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bugzilla https://bugzilla.kernel.org/show_bug.cgi?id=209831
reported that the guest time remains 0 when running a while true
loop in the guest.

The commit 87fa7f3e98a131 ("x86/kvm: Move context tracking where it
belongs") moves guest_exit_irqoff() close to vmexit breaks the
tick-based time accouting when the ticks that happen after IRQs are
disabled are incorrectly accounted to the host/system time. This is
because we exit the guest state too early.

This patchset splits both context tracking logic and the time accounting 
logic from guest_enter/exit_irqoff(), keep context tracking around the 
actual vmentry/exit code, have the virt time specific helpers which 
can be placed at the proper spots in kvm. In addition, it will not 
break the world outside of x86.

v1 -> v2:
 * split context_tracking from guest_enter/exit_irqoff
 * provide separate vtime accounting functions for consistent
 * place the virt time specific helpers at the proper splot 

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>

Wanpeng Li (3):
  context_tracking: Split guest_enter/exit_irqoff
  context_tracking: Provide separate vtime accounting functions
  x86/kvm: Fix vtime accounting

 arch/x86/kvm/svm/svm.c           |  6 ++-
 arch/x86/kvm/vmx/vmx.c           |  6 ++-
 arch/x86/kvm/x86.c               |  1 +
 include/linux/context_tracking.h | 84 +++++++++++++++++++++++++++++++---------
 4 files changed, 74 insertions(+), 23 deletions(-)

-- 
2.7.4

