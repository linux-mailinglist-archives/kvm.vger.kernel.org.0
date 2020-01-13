Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868EB139C32
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 23:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgAMWK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 17:10:57 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:52786 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbgAMWK5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 17:10:57 -0500
Received: by mail-pf1-f202.google.com with SMTP id 145so7471900pfx.19
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 14:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=tgXHdBhTxnbggm48PWjGbR468zkVyYGw0KccqoL7rpE=;
        b=nMOkTXEuejp7ltUHNH5PwzsoaA8hAe+3a/zcrS0wD8S2/J5Umx5O9KFmaYDfxeKiik
         Ux9uUEvVKwo29Kvaxp/OARzzgcyr9F3EBK2dLNuKxxifrtu17aKlMZcmYOU9QLwlPolH
         Bgr1dV2ZalUSIQ1DjUyQ1Q3uhc8/Fd1rxoNGwQm/QviERBptioRJtBbDT04+naXxgkJv
         ePXuR757YoKbkB4VG0B+H1Jol3Jy6MWGsr34Zr9e4lZwgAltPBgo3e114UEON9Guicj7
         t03g8Vs2Oz8k2AHzBnnG+QycgVG2S+OvvQi8X00fD/hX2f7dGNxos4EyzdQMFAFKj8z6
         bpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=tgXHdBhTxnbggm48PWjGbR468zkVyYGw0KccqoL7rpE=;
        b=KEWI1ZkUn1yiLSiGsuoTBx8L6dccXTmZLV4Ncv7e04gy5cur+CdEuYcvtjOMmif+Bk
         ufC/CogXcyPJSQ0b2Yve5U+rohwmyXqSLjOVT2eW44CH1KjgcNqr7v5U8P3PESWb9ZHL
         TjCQOQgymz2CcANZfpV/VS459phuDOMgfX5G7Q0JVZo5j9Oz2ws/Z6mnhp5R/nCObZq/
         UO9APYf896jzm2SKKBr8e0/omK8AOWXMy0/SMSQs+qAupE6KSto2mHfS468ooV7qXSp2
         aoFwr5psAzslus+uYjdFxkFtrA7VC6bLw4JLAoPjfQpPMFsgN8WM16AjG5OWbM2B8bW/
         R5qQ==
X-Gm-Message-State: APjAAAXehvBb3pXkEGWQyoVrc0tVikGjvRlPizclSSFO/8b4/cn5rQnk
        Z5BDn1Iq9II+RAyifzciwKhhKQMUw+bRQJpyoY/+aTyBdiSeo2p5D23zWi0qgFGo9EMelNvbgt8
        j2EXpNhNSDJbKTLGypkK2qTeuE1iIK4Eg2UBa+QHCQ2tkYdjuQjF2sHf/og==
X-Google-Smtp-Source: APXvYqz09qNCQFN5bt1F8eq7/D6JLu/oaru0DGVcMGilzCKvI5HYi8omESd5WpXJNj/CErdAQJKLEGA61as=
X-Received: by 2002:a63:7944:: with SMTP id u65mr21442503pgc.298.1578953455971;
 Mon, 13 Jan 2020 14:10:55 -0800 (PST)
Date:   Mon, 13 Jan 2020 14:10:50 -0800
Message-Id: <20200113221053.22053-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH 0/3] Handle monitor trap flag during instruction emulation
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM already provides guests the ability to use the 'monitor trap flag'
VM-execution control. Support for this flag is provided by the fact that
KVM unconditionally forwards MTF VM-exits to the guest (if requested),
as KVM doesn't utilize MTF. While this provides support during hardware
instruction execution, it is insufficient for instruction emulation.

Should L0 emulate an instruction on the behalf of L2, L0 should also
synthesize an MTF VM-exit into L1, should control be set.

The first patch fixes the handling of #DB payloads for both Intel and
AMD. To support MTF, KVM must also populate the 'pending debug
exceptions' field, rather than directly manipulating the debug register
state. Additionally, the exception payload associated with #DB is said
to be compatible with the 'pending debug exceptions' field in VMX. This
does not map cleanly into an AMD DR6 register, requiring bit 12 (enabled
breakpoint on Intel, reserved MBZ on AMD) to be masked off.

The second patch implements MTF under instruction emulation by adding
vendor-specific hooks to kvm_skip_emulated_instruction(). Should any
non-debug exception be pending before this call, MTF will follow event
delivery. Otherwise, an MTF VM-exit may be synthesized directly into L1.

Third patch introduces tests to kvm-unit-tests. These tests path both
under virtualization and on bare-metal.

Oliver Upton (2):
  KVM: x86: Add vendor-specific #DB payload delivery
  KVM: x86: Emulate MTF when performing instruction emulation

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm.c              | 25 +++++++++++++++++++++
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/nested.h       |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 39 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              | 27 ++++++-----------------
 6 files changed, 78 insertions(+), 22 deletions(-)

-- 
2.25.0.rc1.283.g88dfdc4193-goog

