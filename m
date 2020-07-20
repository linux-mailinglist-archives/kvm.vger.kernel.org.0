Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E4C226EBC
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 21:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbgGTTIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 15:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgGTTIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 15:08:22 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65347C061794
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 12:08:20 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i19so5090724lfj.8
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 12:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RAtDgbS/hP0vKX/bJra48LpyRkjoV3iGTct2/3+4uDA=;
        b=EUUvQycc/lJ4zBYdRtZOPWR8MiVsfztwnjSFOrn7+s3Rlof2v7jC5paDOIkmgZfcOV
         5Faj/TDqlNMlrfvaZ55m24ALFFknYhtWUtGLj+96Oz8TvhzZDRijL5m6iL6vOht383zs
         Ju+kmtbmmM4pBT0RBW5cBpSFpFy0y2YbqgrLmOVYNYtC7OHeh3zkDQwmUNYjiC6XZkzn
         8WjdCZOJHah2CSc76Ifdz6r4m0EqyG3olvXjZJSOvwnnO0/FKQPR7rT2IN3+Ib69jPJu
         pR6W62gfgrH/HbiPMDA026vnlfLrvFJJxYi5GSCmvQsP96piLj1sBVbhZLCs+kEDO49v
         0oDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RAtDgbS/hP0vKX/bJra48LpyRkjoV3iGTct2/3+4uDA=;
        b=s0oOHGUvD3g4TCOd61wsFO3nKYkSlJNaJDHHIb+LK/IlCzBYu8XKFLOfNrf8euzpz5
         bLnZ+/GO1vKH3D29fxpqyDa29S2dyoQsrSho2TUcYkRw4oWmgcoumb0lT9m5MjL5fp3v
         XepfGRcawkdC2GvicsRF+g8NWYi1gX/vYJbp3xec9YPnpsqu0PhVHaSqnlLxrGD8e++q
         l6+ai97d82oOCW5yd+18LHpCSiyP5HTZ3Nk9++NJx0Vzsw6F/QRyTUzge9x8EKZQLwpt
         DB74SclvPD3T7PCojwM0gcCchGAgVnXBZeptJKkSryZaqJaaU3ABKFNhhMSnMZCzzOxh
         dqig==
X-Gm-Message-State: AOAM533G730TbqeSj9x+G9/aX/tIleLPyMuvvz9bMkC2f0lVT4G9x7nl
        RIS9ofBqRKe/XHKBIehCkn8CMvfkVVjY/Y0h7H9a+CTy
X-Google-Smtp-Source: ABdhPJzDkSUzrPIi8i7nxhGvk268rgXijiQGTxqha55blo4KcklgPSFIBaSdoPEy2BOEuOEA10rW9ENM9D5LL9pKz8o=
X-Received: by 2002:a19:cc9:: with SMTP id 192mr8617628lfm.61.1595272097401;
 Mon, 20 Jul 2020 12:08:17 -0700 (PDT)
MIME-Version: 1.0
From:   Jacob Xu <jacobhxu@google.com>
Date:   Mon, 20 Jul 2020 12:08:05 -0700
Message-ID: <CAJ5mJ6i-SoZO+F+Xz5OqK7BE7z7eLvE1hC=KX1ABwdnTw-QZuA@mail.gmail.com>
Subject: tlb_flush stat on Intel/AMD
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

I wrote a kvm selftest to enter a 1-vcpu guest VM running a nop in one
thread and check the VM's debugfs entry for # of tlb flushes while
that was running. Installing the latest upstream kernel and running
this on an intel host showed a tlb_flush count of 30, while running it
on an amd host shows the tlb_flush count at 0.

Do we have an inconsistency between Intel and AMD in how VCPU_STAT is
incremented?

From browsing the code, we see that the stat only gets incremented in
the kvm_ wrappers of the x86_ops functions tlb_flush_all,
tlb_flush_current, and tlb_flush_guest. These wrappers are only called
via the KVM request api (referred to as deferred flushes in some other
threads), and there other instances of calling the x86_ops tlb_flush
methods directly (immediate flush).

It looks like most of the tlb flush calls are deferred, but there are
a few instances using the immediate flush where it's not counted
(kvm_mmu_load, svm_set_cr4, vmx_set_apic_access_page,
nested_prepare_vmcb_control). Is there a guideline on when to
deferred/immediate tlb_flush?

Could this be a cause for the lower tlb_flush stat seen on an AMD
host? Or perhaps there's another reason for the difference due to the
(too) simple selftest?

In the case of svm_tlb_flush, it seems like the tlb flush is deferred
anyway since the response to setting a tlb flush control bit in the
VMCB is not acted upon until entering the guest. So it seems we could
count tlb flushes on svm more easily by incrementing the counter by
checking the control bit before KVM_RUN. Though perhaps there's
another case we'd like to count as tlb flush when the guest switches
ASID (where would we track this?).

Would switching to this alternative for incrementing tlb_flush stat in
svm be much different than what we do right now?

Thanks,

Jacob
