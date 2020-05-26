Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54F11C6252
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 22:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgEEUu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 16:50:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31665 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728660AbgEEUuH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 16:50:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588711806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aTLHVMbsIaqAX7BaSrLpdm3P4nxyMTwYs/IkveEjuuM=;
        b=GJUdHb+wdANeh2PjO3788dB52RQcEUOexz0eR/BFsxxXZntHDl2TCOePkYmrpBaSZ2mp+B
        TV6GvPRRJz1Niwkg4KrD5k+5AZyV/pVh29/mD/SlQhZS9mBqw1gqzpHR/0SlSrfT7aReQm
        j2Y7aezXLfHi/ef45qDfMba+q7n5mZc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-YKQSZ9DROw-5ay_RB3EFXA-1; Tue, 05 May 2020 16:50:03 -0400
X-MC-Unique: YKQSZ9DROw-5ay_RB3EFXA-1
Received: by mail-qv1-f70.google.com with SMTP id c5so3478991qvi.10
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 13:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aTLHVMbsIaqAX7BaSrLpdm3P4nxyMTwYs/IkveEjuuM=;
        b=O1BfpaW8XgmZ317phAwdthnL3H0Q2Vh+huYYTAcEUuhVTLwcpS1YFnGU3zBE/LPPzi
         zttM5BE4dHYL7Wur7xWsaCRPIaSrwMb8262ocbTJxksh6bV9Ns3sVaUNemrWMdYkEuS/
         Qkguf3mhmS4TxqIU1N4Q4SKDgQ0cmF4zlLZyceWGs3YcjjTZdpFB0bRQQhxupPyK8ux/
         ajEG+sg8l0VbXjC8Soe30LGt6raX8QWuooI5kziMLFmW7HHLwMp7u1dHdkPkknI84jeg
         VZleypgpmGdyXaIWap9nMOB0ucnCcuh8uvgjji3RkorVfU23EyLxmwiaSwagmAm04mh+
         EzEA==
X-Gm-Message-State: AGi0PuZPH+LWNeB/kxKRzMDItJHb7qzEAUMtnCDp8KDlY68jjoKNH59A
        BygNJwMSoDr1j3s7g5yozQL6e4Tch4aU/nw0GulqSkKTg/sKdWrO0tKbHADIXCcrtDRR8uCaGJy
        546KxBemyIODj
X-Received: by 2002:ac8:5653:: with SMTP id 19mr4679677qtt.252.1588711802814;
        Tue, 05 May 2020 13:50:02 -0700 (PDT)
X-Google-Smtp-Source: APiQypJZWCseS8WCKKpT3aDra1sX1ikSoUZ46+/xjslmiir4MILBMJv5VWPlzmW+jNOSrx1v5dxLGw==
X-Received: by 2002:ac8:5653:: with SMTP id 19mr4679660qtt.252.1588711802514;
        Tue, 05 May 2020 13:50:02 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 193sm19380qkl.42.2020.05.05.13.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 13:50:01 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/3] KVM: X86: Two fixes for KVM_SET_GUEST_DEBUG, and a selftest
Date:   Tue,  5 May 2020 16:49:57 -0400
Message-Id: <20200505205000.188252-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first two patches try to fix two issues I found (I think) with the
selftest.  The 3rd patch is the test itself.  Note, we need below patches to be
applied too for the test to work:

        KVM: X86: Declare KVM_CAP_SET_GUEST_DEBUG properly
        KVM: selftests: Fix build for evmcs.h

Please review, thanks.

Peter Xu (3):
  KVM: X86: Set RTM for DB_VECTOR too for KVM_EXIT_DEBUG
  KVM: X86: Fix single-step with KVM_SET_GUEST_DEBUG
  KVM: selftests: Add KVM_SET_GUEST_DEBUG test

 arch/x86/kvm/vmx/vmx.c                        |   2 +-
 arch/x86/kvm/x86.c                            |   2 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   9 +
 .../testing/selftests/kvm/x86_64/debug_regs.c | 180 ++++++++++++++++++
 6 files changed, 194 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/debug_regs.c

-- 
2.26.2

