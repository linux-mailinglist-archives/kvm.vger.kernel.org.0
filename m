Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D957E16646D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 18:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgBTRWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 12:22:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42233 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728896AbgBTRWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 12:22:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582219335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rZyXD5q+onhmCDPHKZnUNJAstGhWUGrhi7Vh7fDt5g0=;
        b=a9QKLynW6RUm++W22qLQQxtWjevCgd061TBDDHsrTYQ6nYITuvStFDXPItVzdd71dDodCt
        0SytloLUuu3DN5cT6yVU0mJQ160bta3lGis185UIHS/akE7F+Gpx/wV6nlCXbo1fMQZctF
        V4KOxWt2xRTfurypSgVE2+WKcZBKNEs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-QhU0mJ4QO262gXPKlvMnXw-1; Thu, 20 Feb 2020 12:22:09 -0500
X-MC-Unique: QhU0mJ4QO262gXPKlvMnXw-1
Received: by mail-wm1-f71.google.com with SMTP id g138so842921wmg.8
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 09:22:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rZyXD5q+onhmCDPHKZnUNJAstGhWUGrhi7Vh7fDt5g0=;
        b=DAo83Xtpj5PJODzXvLkXFPSMc3Kc29mKr78T3GS9WZM/Ly/AtlhgbruKDjpdYWnsPM
         4v7D58N2sFfByF6VUPpTnTNWDeLD+VVujyERHgosHBem2P/ELvChiH3GXIfMuRipQ5jN
         jpYJQ+ebRNrnO7OoRy81KKgX/444gbd5EOM3yL0wMCQRP9nlHXcOqa44rpX/3KohE/z5
         cJxGb13HLiWgcwZpZUnVkZiQflVK1/7/kztApaFT6Kpr8hzuvYyFXX9AsM4pAu9GSrxC
         /xaZEJA6dpFfdZiVK7srX3qexWivakk4PeLVRCyTZcSnCWSer5D2BorVKLsRThZCabCp
         /a4Q==
X-Gm-Message-State: APjAAAVESP7Lvs6V8jwgvTR7hTraNxuQjqJJ9AmEt4vHhg9KVI+sx+xg
        IM4vCBMWe8U8tzh5zFX7QXOLh5R8yixKvH1vWdD7fyoRYpUS9TXvC44yUtJ0aBSG6fvEgSvEybd
        iJbMtO31gFdwk
X-Received: by 2002:adf:fd87:: with SMTP id d7mr45699846wrr.226.1582219328193;
        Thu, 20 Feb 2020 09:22:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqyznpk/Mju2cxo6UDLosBl/WALhWP2M64Z82L2SgtLE3m4B2Qb1Kh7smxIT3jRFYoOJt4jZkQ==
X-Received: by 2002:adf:fd87:: with SMTP id d7mr45699820wrr.226.1582219327916;
        Thu, 20 Feb 2020 09:22:07 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a184sm5355891wmf.29.2020.02.20.09.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 09:22:07 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/2] KVM: nVMX: fix apicv disablement for L1
Date:   Thu, 20 Feb 2020 18:22:03 +0100
Message-Id: <20200220172205.197767-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It was found that fine-grained VMX feature enablement in QEMU is broken
when combined with SynIC:

    qemu-system-x86_64 -machine q35,accel=kvm -cpu host,hv_vpindex,hv_synic -smp 2 -m 16384 -vnc :0
    qemu-system-x86_64: error: failed to set MSR 0x48d to 0xff00000016
    qemu-system-x86_64: <...>: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
    Aborted

QEMU thread: https://lists.gnu.org/archive/html/qemu-devel/2020-02/msg04838.html

Turns out, this is a KVM issue: when SynIC is enabled, PIN_BASED_POSTED_INTR
gets filtered out from VMX MSRs for all newly created (but not existent!)
vCPUS. Patch1 addresses this. Also, apicv disablement for L1 doesn't seem
to disable it for L2 (at least on CPU0) so unless there's a good reason
to not allow this we need to make it work. PATCH2, suggested by Paolo,
is supposed to do the job.

RFC: I looked at the code and ran some tests and nothing suspicious popped
out, however, I'm still not convinced this is a good idea to have apicv
enabled for L2 when it's disabled for L1... Also, we may prefer to merge
or re-order these two patches.

Vitaly Kuznetsov (2):
  KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested pinbased_ctls only
    when apicv is globally disabled
  KVM: nVMX: handle nested posted interrupts when apicv is disabled for
    L1

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/lapic.c            |  5 +----
 arch/x86/kvm/svm.c              |  7 ++++++-
 arch/x86/kvm/vmx/capabilities.h |  1 +
 arch/x86/kvm/vmx/nested.c       |  5 ++---
 arch/x86/kvm/vmx/nested.h       |  3 +--
 arch/x86/kvm/vmx/vmx.c          | 23 +++++++++++++----------
 7 files changed, 25 insertions(+), 21 deletions(-)

-- 
2.24.1

