Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44564231144
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 20:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732156AbgG1SII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 14:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgG1SIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 14:08:07 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5D5C061794
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 11:08:07 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id v15so6975847lfg.6
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 11:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ZNW2KQX07GwhrRQSaht18Jf7IWigkF5mQEeicomsg4=;
        b=ncbKFXyY0+Av004YmAE8x3dA+VdJK8QDDSX+TDzfw5T4KGV6NZDGZbh6PhwwgJXfiN
         3OdGVkAbOBc5a5ia+hOE6v20zid6rqWd0+BiJ/Awlo4A7r85BPYh/SiU+AyLs3EqQJtX
         1EyidBwuMOlBnkQRdHXg8XXuOeZY88htoppPWkSstuzsj1K2tQ78jwNAkvZdCjb1MgWs
         hwShYmvp3MV3UTMu9XZysdE9Hl78ETAdvJXcK5qCmPdBQspNQtJtzFVOhwH4mLztExA0
         UX8XzWxJ4VGN8ffJ1Ntvd+dpxa1Yy0heIqLqUUeWP96OLcbabf2w3qs0nLms8C2v/XaB
         ydDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ZNW2KQX07GwhrRQSaht18Jf7IWigkF5mQEeicomsg4=;
        b=aKbOsDbTx2NBNtiPkbJdj9PqOsEBOUDOFWHFK8Fil3u0RPh4fHiYtCSspsNZQjpYJx
         R+swQk8lWh2Ey0WiJjSAReeqOLFnjpoR07qai5P7vRQfZmw7pTm0rhlnaa6x7VT4GC4w
         Q1cdW5nEElwSGdczzULPXpipAjtqVYpL1HCvw/UA/z8xvoEPWLfbSgQ7rZRvXbQAqCU2
         bBe1OgjPT84158sWWWKRzzMMKBh4v6ptCkphlimTa+VE6zGsESwPgNAHEcNg2lQvZ5KV
         RwOI/RXudaI+vQ1HH9vm7p89LfbeHdZXdtHmgUKOmBNXqj9/oiL/QH0+eAG8AjavWAK5
         vHUw==
X-Gm-Message-State: AOAM532nAOj7gcNsrjErNv9lxBp6mRXLbsJQvo28b3spfl/vlnzdcrYJ
        X/r7RsmF9Pf4jrb7AoMX0c+pxcqr2pyUUXuMdJSjx+0t
X-Google-Smtp-Source: ABdhPJxD735RZzgInyRg67uc5PtX/Pk2QqqKRlVufPlSOzR4QVe1kaW6hgc7sz/Yh7Q1GaoyQY9w1k/aZorqsu3mRR0=
X-Received: by 2002:a19:2256:: with SMTP id i83mr15429592lfi.165.1595959684265;
 Tue, 28 Jul 2020 11:08:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ5mJ6i-SoZO+F+Xz5OqK7BE7z7eLvE1hC=KX1ABwdnTw-QZuA@mail.gmail.com>
 <20200721201643.GI22083@linux.intel.com>
In-Reply-To: <20200721201643.GI22083@linux.intel.com>
From:   Jacob Xu <jacobhxu@google.com>
Date:   Tue, 28 Jul 2020 11:07:52 -0700
Message-ID: <CAJ5mJ6h6WYJHTKNWvyZ2co0HEBWjkrNC5yX4hn9v9VdMzyqo3g@mail.gmail.com>
Subject: Re: tlb_flush stat on Intel/AMD
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> The VMX APIC flush could be deferred by hoisting KVM_REQ_APIC_PAGE_RELOAD
> up.  I think that's safe?  But it's a very infrequent operation so I'm not
> exactly chomping at the bit to get it fixed.

Could moving KVM_REQ_TLB_FLUSH and _CURRENT down also work?
It seems that none of the check_request() calls below depend on them.

> Given that you see 0 on SVM and a low number on VMX, my money is on the
> difference being that VMX accounts the TLB flush that occurs on vCPU
> migration.  vmx_vcpu_load_vmcs() makes a KVM_REQ_TLB_FLUSH request, whereas
> svm_vcpu_load() resets asid_generation but doesn't increment the stats.

I'll try adding a one-off stat increment here, and check the results.

> I think a better option is to keep the current accounting, defer flushes
> when possible to naturally fix accounting, and then fix the remaining one
> off cases, e.g. kvm_mmu_load() and svm_vcpu_load().
>
> I can prep a small series unless you want the honors?

I'll try making a small series:
kvm: selftests: add get_debugfs_stat to kvm_util
kvm: x86: increment tlb_flush stat on svm_vcpu_load(), kvm_mmu_load()
# omit kvm_mmu_load() if feasible to move check_request(KVM_REQ_TLB_FLUSH) down
kvm: x86: re-order check_request() to prefer use of deferred tlb_flush

Thanks for the explanations! Sorry for my late reply, I've updated my
email filter accordingly.
