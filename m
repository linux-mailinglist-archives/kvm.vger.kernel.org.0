Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C394C1CB90D
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 22:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgEHUgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 16:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726811AbgEHUgw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 16:36:52 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7CBC061A0C
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 13:36:52 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id fe18so2987012qvb.11
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 13:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=17ywsygLyzXzKvE1o24FLCWQbEa2U3x3ZZW9XrMM+vc=;
        b=g5ixACjYin6jSZckRdyy/UzAYTUEz6SehoYl4Ntkn2M3cJddj7KsYxFr/2RxVUcg+H
         sxBgy6XgYSHjDbciASHMpGYmEUBWLlEcKQVLgS1ll8XNGRk7G4MjrvJ98LBmmjNO8ndt
         /tFxRZkeQs8AKjoMnsTFabqe59jYqw+coEL69Rez6gpg/jz1B/aOECROUkTL9zQFLGB1
         +LRzPp5UJsSxAbnNP5Qct20Ugtiy1Ryn+1KwdFAhvDNPK8x4vgxtaQQ7bHeHjZ9zqfn7
         7I0zXoe0Isz9+kFHjY0DLFiFITsGcCk87qC5LtyNx8qaUj9uPnQyEIoUOdjesOijudGR
         vWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=17ywsygLyzXzKvE1o24FLCWQbEa2U3x3ZZW9XrMM+vc=;
        b=kEdSAK0VUyfOL9pZX8BTYdTXfccITXXxSC2lRM4taCtb7C7/btjkkKJaJjySSZuCy8
         MxdKF+Lf0t6DUOXANxeAqzXeHMoBVEd5K/IS/XR8BXrQZeBGEPzNdZcFJS46gdBSfCE7
         20YfaPhfnOVS86jhySd09b9FkCYVpqzQUEyQpMobMcPtM5HGFCsRXHgDeFP7TvttxTxc
         iHzS2HAm0m0VitXvbEh59alD/at47fLJBn9Mjv1jg6QZS9mA+SpEN8tL5UYddlE2P/ng
         Ok3GaH41pIFVEXkI5DT6OyGo23ckuyqajdkHuIza7pr75WSuqQEvWHOi24YF265VOTcx
         wO4Q==
X-Gm-Message-State: AGi0PuabB49suea1NqDfSxu0RghfzjoMBODzvvbivM6M4T2XceJ4rHQT
        OUrX4pyMnmWXKlhAZaMbgKg5e4eTkux3i8cv3mTdVfHpKCtv0ACJxl8baRtyHJf5OYe1Sbiz4lB
        VTI/phiP4CTR2ILaJFw9/eB4Wm0q+wOG0gl3NIzEitHS8JlQlbbiqcH1h1T7Xclo=
X-Google-Smtp-Source: APiQypIyTWq2vo9sq7tOeCqr+X5NjHGVrME+s/YHsjIKqz0KK6gvojdgUTeA/UiM8dYqGakMqIaV9Sdjo9QK3w==
X-Received: by 2002:ad4:568a:: with SMTP id bc10mr4510760qvb.148.1588970211919;
 Fri, 08 May 2020 13:36:51 -0700 (PDT)
Date:   Fri,  8 May 2020 13:36:40 -0700
Message-Id: <20200508203643.85477-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH 0/3] Pin the hrtimer used for VMX-preemption timer emulation
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm still not entirely convinced that the Linux hrtimer can be used to
accurately emulate the VMX-preemption timer, but it definitely doesn't
work if the hrtimer is on a different logical processor from the vCPU
thread that needs to get kicked out of VMX non-root operation.

With these changes, the kvm-unit-test (sent separately) that verifies
that a guest can't actually observe a delayed VMX-preemption timer
VM-exit passes 99.999% of the time on a 2GHz Skylake system.

It might be possible to improve that pass rate even more by increasing
the scaling factor in the virtual IA32_VMX_MISC[4:0], but you'd have
to be even more of a stickler than I to go to that extreme.

By the way, what is the point of migrating the hrtimers for the APIC
and the PIT, since they aren't even pinned to begin with?

The subject line of the first patch was crafted for you, Sean. :-D

Jim Mattson (3):
  KVM: nVMX: Really make emulated nested preemption timer pinned
  KVM: nVMX: Change emulated VMX-preemption timer hrtimer to absolute
  KVM: nVMX: Migrate the VMX-preemption timer

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/irq.c              |  2 ++
 arch/x86/kvm/vmx/nested.c       |  5 +++--
 arch/x86/kvm/vmx/vmx.c          | 11 +++++++++++
 4 files changed, 18 insertions(+), 2 deletions(-)

-- 
2.26.2.645.ge9eca65c58-goog

