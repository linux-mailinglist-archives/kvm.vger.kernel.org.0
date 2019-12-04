Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198B3113568
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 20:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbfLDTH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 14:07:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23377 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728114AbfLDTH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 14:07:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575486444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3sjFZw9opuacU4JfT1I2hipUIWoYYgMlYwS54eyyzWE=;
        b=Y+dd/6g3I0AJD+At8iNfT0xgibCmuLHOR6Jq8pv3Js16+GSEwVRb2998MuHA4QfgChfC+H
        b7nR/HA7UCScaEVqAn19J5cDzwiolP/PAW2cjYj2ohNDMUHG7ODxdXiG0PBHYl0xzUJPpj
        84pXUgtuGIUUR98RmIi6SXAAxXCwKfI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-QbVePQoNMWe3pfy7mv8nIA-1; Wed, 04 Dec 2019 14:07:23 -0500
Received: by mail-qt1-f198.google.com with SMTP id l1so598469qtp.21
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 11:07:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xsItnjtI2JZZmK3Ztp9Y4PpNo6TZaMFBK50xKDCNG6o=;
        b=QG8vcphMWnLdRVRWibiHFKuSicIvF3o2H28pD8g9Rm7scnZ6/o3Uo0NOAepLNBUp22
         XCgSvpFGgQF/e4Q10dCGSkHKy+kZ3EPofoqbOUJQE+pYWqJfExl2HNBdQVis96Vwv7Ne
         Z1xyCoiPmk5I/JaWKaB/989Xlo6xcDOkbF+l3b/oAVBcPqXShk3UcnqAemnYO+pBxuTr
         7Rtfb6TGGfaaQuTTtaYqa8DIEeRHXvodxG4vuXW4ayF1IY9tu71dfiTZ6n352KRi2MH6
         OlIIlicqmednbxc+9+IUDp3leMtLenaqiksW8wRSfAxJu0Sn8Psg6dYdj9EWQChvrv6g
         HXGQ==
X-Gm-Message-State: APjAAAWJHb8vqyYpJwyprmlnXPRHrbPt9S54Wpe7llZQ7pQlkpDgle6b
        hOh6LFMITpWmVeOTYTm7Xjw/VNvRuUcKH7cDYi89AddX1XYp68Ag+PAs+fz4gykqkTDO6SN2BiC
        VUCn/iw+lMzm2
X-Received: by 2002:ac8:1385:: with SMTP id h5mr4205463qtj.59.1575486443323;
        Wed, 04 Dec 2019 11:07:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqyLU0mdye3l7w56UCm9urWD6xnVdMRda/R8N73j8koZDC/cqy5mxzPws7nri9PIl8MC0d3yWA==
X-Received: by 2002:ac8:1385:: with SMTP id h5mr4205424qtj.59.1575486443053;
        Wed, 04 Dec 2019 11:07:23 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id y18sm4072126qtn.11.2019.12.04.11.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:07:22 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v5 0/6] KVM: X86: Cleanups on dest_mode and headers
Date:   Wed,  4 Dec 2019 14:07:15 -0500
Message-Id: <20191204190721.29480-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: QbVePQoNMWe3pfy7mv8nIA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v5:
- rename param of ioapic_to_lapic_dest_mode to dest_mode_logical [Sean]
- in patch 5, also do s/short_hand/shorthand/ for kvm_apic_match_dest [Vita=
ly]
- one more r-b picked

v4:
- address all comments from Vitaly, adding r-bs properly
- added one more trivial patch:
  "KVM: X86: Conert the last users of "shorthand =3D 0" to use macros"

v3:
- address all the comments from both Vitaly and Sean
- since at it, added patches:
  "KVM: X86: Fix kvm_bitmap_or_dest_vcpus() to use irq shorthand"
  "KVM: X86: Drop KVM_APIC_SHORT_MASK and KVM_APIC_DEST_MASK"

Each patch explains itself.

Please have a look, thanks.

Peter Xu (6):
  KVM: X86: Fix kvm_bitmap_or_dest_vcpus() to use irq shorthand
  KVM: X86: Move irrelevant declarations out of ioapic.h
  KVM: X86: Use APIC_DEST_* macros properly in kvm_lapic_irq.dest_mode
  KVM: X86: Drop KVM_APIC_SHORT_MASK and KVM_APIC_DEST_MASK
  KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros
  KVM: X86: Conert the last users of "shorthand =3D 0" to use macros

 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/hyperv.c           |  1 +
 arch/x86/kvm/ioapic.c           | 24 +++++++++++++++---------
 arch/x86/kvm/ioapic.h           |  6 ------
 arch/x86/kvm/irq.h              |  3 +++
 arch/x86/kvm/irq_comm.c         | 12 +++++++-----
 arch/x86/kvm/lapic.c            |  9 +++------
 arch/x86/kvm/lapic.h            |  9 +++++----
 arch/x86/kvm/svm.c              |  4 ++--
 arch/x86/kvm/x86.c              |  4 ++--
 10 files changed, 43 insertions(+), 34 deletions(-)

--=20
2.21.0

