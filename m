Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B7B10D86F
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 17:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfK2Qcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 11:32:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45436 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726608AbfK2Qcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 11:32:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575045158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9V/qFvH8waqtXVKvhRpmWCEM/9qP0sAeZeU83cy8EOE=;
        b=S3zxl2u7OacaWD/m2W8RQhJXmuV7EEVAXmBkH1S0n6gH8kJ9uvTgHmcndmLjMmW3JyauZd
        1TBa23TcFcqyVJG7mC9fSjtzrf+2Db/rcALIvQLjsPL0jPYLel7+BgF6m2iJcqVXta1DID
        c3GMlboYEGwjR9W9Zk/tGeyVeGbP2/Y=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-Jif7Uz9rNsy4cEGHlBvNbQ-1; Fri, 29 Nov 2019 11:32:37 -0500
Received: by mail-qv1-f70.google.com with SMTP id y9so7400431qvi.10
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 08:32:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5iCofYmIjfyUSG8vHZf7wpoJnDoheL6AALy8kyz1tx8=;
        b=nraLA4io4oGKokG3v3KgSA0VAcL9yQ4Jbot9w1ST1wuMlHj7t9iGCMZGigj6B315Uc
         xub1A0pO6eV4u6PB5gZSHHsOQToZROYDgTfH8oWc1hW30ISkhU9NiI2E1gCKN+SGHcQf
         l+p8quSco+VYDqajDk//4Hl8aqeKdQ7j+oCNo2uFZzMb4T58p37MjI/gHNyOh9kM9sDu
         CjOivsewjI9MpjBDkCBEog9IPpXbJTIUmFxjbw3BwP7Dr9u/z1sr8SDLyO4Sy1+EqUYm
         wD9NUKbJRhe/afEOMGizITZkHLwUTXQXlCZEb6n6IEWKalXqPQ9Ktt/cbPtPce0ZtTJm
         zvFg==
X-Gm-Message-State: APjAAAUk0WpRh1/Fv3ehzC6b8dWNdbwQKBOOflYo3JNKoi+DlG6VaFhr
        1KeCqwHsCJF/xcs33JMluIiApQIiw/9HQd33t8L3i4Rygmsf3ImSZQHiW4zHOjGP6XnNp1Nt6/T
        +yRuAJDMu/XtW
X-Received: by 2002:a05:620a:2f1:: with SMTP id a17mr9045639qko.252.1575045156580;
        Fri, 29 Nov 2019 08:32:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqwt6klFGFPdiFCxtdNXCaWr4i8+5EKri2pR8sDM3UzAXUglAuAkDeGNQx+NxQAmWUnSI1w0ew==
X-Received: by 2002:a05:620a:2f1:: with SMTP id a17mr9045611qko.252.1575045156321;
        Fri, 29 Nov 2019 08:32:36 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id d9sm4568329qtj.52.2019.11.29.08.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 08:32:35 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2 0/3] KVM: X86: Cleanups on dest_mode and headers
Date:   Fri, 29 Nov 2019 11:32:31 -0500
Message-Id: <20191129163234.18902-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: Jif7Uz9rNsy4cEGHlBvNbQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Each patch explains itself.

Please have a look, thanks.

Peter Xu (3):
  KVM: X86: Some cleanups in ioapic.h/lapic.h
  KVM: X86: Use APIC_DEST_* macros properly
  KVM: X86: Fixup kvm_apic_match_dest() dest_mode parameter

 arch/x86/kvm/ioapic.c   | 9 ++++++---
 arch/x86/kvm/ioapic.h   | 6 ------
 arch/x86/kvm/irq_comm.c | 7 ++++---
 arch/x86/kvm/lapic.c    | 5 +++--
 arch/x86/kvm/lapic.h    | 7 +++++--
 arch/x86/kvm/x86.c      | 2 +-
 6 files changed, 19 insertions(+), 17 deletions(-)

--=20
2.21.0

