Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A172110313
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfLCQ7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 11:59:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55382 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726074AbfLCQ7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 11:59:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575392347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9idJJsQV/2uEwKnGkN4mjfcfOqrJXpGQnakfdpkG6DI=;
        b=cGGXHtKA+seDsh6eU6dLZin/AyVSU9ZyJkvkuwD93zh3Nhk5uQmXhnxsBvhdNkuT0efJki
        oaIDNaqaWpwt/C0XP9TvPOHjV5K+VmBBcfAyEYwTQG/h14wDW773pDTfRGb4an5tO43iqO
        W9cui3U8Zyfpk+gzZmtbij0k1cVc6XA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-KTl2_h25Pa-AKp3lvIqyjw-1; Tue, 03 Dec 2019 11:59:06 -0500
Received: by mail-qk1-f200.google.com with SMTP id a1so2597364qkn.15
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 08:59:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ki0zcq1Hd91HT74Xqb0k5NM023hUsBT8hpjru9BF2VU=;
        b=suZgdlwL1uOpIeTVAdOZ1OfHm8i5upMuzartUQCKWe7BVnYWU1B4JlEseKs3VXcY+O
         z5PxABYpwCelpX3ZtHqHLpCYmnCii8PtzMkwtRImayMzrrmhfDEGhecXnhXPDDrE9j9i
         h0mWwJS9EZbqkMPRdkvjG+1MWyLdOUkFJ866cjLkuIgGbDo0JzvkfUtssuP76bYC29s+
         a8R/YUijGpRHGBkpd5OzCYgzmtBzsI2Sru1cQlXsxZDl0z9CLHbS9sEwqEuz7q2BLBlJ
         zwVVeIzBy/Y2hVChIpVGpdmWl8EvoUMY4J5Mu3Kd34wR9Hl+oFczWjk2QzzDWff3RUaa
         gZ2Q==
X-Gm-Message-State: APjAAAUkw0AVXyp5YjXxUk8UoPQDz38cND/QMiNM0uJ6fKTClymtQQLe
        RfrasM62te+EYEUdcYKC+nBuPDUh89CrejwZw54i4xJOEQfOa+3CxiiIUBhzBpfUnZlXNbDgy8h
        3wRyFnIxZ70q6
X-Received: by 2002:ac8:1017:: with SMTP id z23mr5922474qti.154.1575392345722;
        Tue, 03 Dec 2019 08:59:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqyJfsAGRsZ+YvZuBbG3sFkoCk1FF9Ev5phxgEhOfqT73zztJ/7/gzPmD1aFE0Ca9XawO46P9Q==
X-Received: by 2002:ac8:1017:: with SMTP id z23mr5922449qti.154.1575392345471;
        Tue, 03 Dec 2019 08:59:05 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a16sm482585qkn.48.2019.12.03.08.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:59:04 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v4 0/6] KVM: X86: Cleanups on dest_mode and headers
Date:   Tue,  3 Dec 2019 11:58:57 -0500
Message-Id: <20191203165903.22917-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: KTl2_h25Pa-AKp3lvIqyjw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 arch/x86/kvm/lapic.c            |  5 +----
 arch/x86/kvm/lapic.h            |  7 ++++---
 arch/x86/kvm/svm.c              |  4 ++--
 arch/x86/kvm/x86.c              |  4 ++--
 10 files changed, 40 insertions(+), 31 deletions(-)

--=20
2.21.0

