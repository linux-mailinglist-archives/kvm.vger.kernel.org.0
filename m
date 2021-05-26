Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABFC391108
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 08:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhEZG4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 02:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbhEZG4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 02:56:47 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90555C061756
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 23:55:15 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id p39so231427pfw.8
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 23:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lIYi5GnoKtr8i2F095rp7bhScVGwxvgeu7J1/N2EUAk=;
        b=TAHzx3QbIOsujqmEG+HQ52yVDfI9Y+k0TE0z6yWLam76zV1j3Bljso+qDhDs+XH04X
         vMTaL/pvMa2fSonYSD0hp/PfT4qIv40b2qbL3vtyLKAXdJ7bb1R7+RfnxqwlPBLx1bQF
         toyt/iC8s3j24OuMUxvT0hI1zIZo0wpHWZZb8ceMIbHYLNtTuXhCZhqCDvcwaXaKHGog
         QUS2P5UOzNYUbc0RjO+UlRVZe+zoD8rMsIFR54BfxZx1RIYCILUGaxwPYuTQavhFYJat
         R0K6eNIFkmhpdlV7Wru86HMY0xM0fapOvj3z1ET7dVkncGnrGbI8I4TQEJM6nxU5i/yp
         cp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lIYi5GnoKtr8i2F095rp7bhScVGwxvgeu7J1/N2EUAk=;
        b=ShuIpyc9CNfD5huob5s9KLxMduz3drE2PGmaCv5XnGxOhThlwyK+0bZkO1fb3hhwbE
         vt1bodd8IJcf3NLIPpEntSkwMSoV2w/IsNlQsZuHQWSYtgusu4mdNf3hkpQkD8iUTZbn
         r46+SgibdiYLqGcOqWPDdInU40rYptmxtTvON2gkU3u5u9boU0fZspmy/SR1eiwzGsqz
         lFneBnOwTezodpWvvVlTjQ12zci0qXaNtqj5WQEZPFSYfPKE11FBHu15JWw+k8CRIw3s
         S3PslxxA/utSMQH9I8VKP1ggouy9lRqxzg7O9UugB/zdNy+c5qCwXvMUMnX6cAP3YNUI
         iGEA==
X-Gm-Message-State: AOAM5318ZADiT4oT7b5IKApOTcqy1B99kQ30IAzKy0av8HleaeTyCRgL
        5GoWoB7jieNA0v0U+F4Fo5bcw95AOB5ajbhAN5dvyQ==
X-Google-Smtp-Source: ABdhPJxqcWSulclnjmI7hHh8p2hlD5seevQBCNSAUIHO5Hm1wujO2iFXmGa0oes7zjBWwhnrusw6Kk0A0xLa+Z7/1jM=
X-Received: by 2002:a63:1e4f:: with SMTP id p15mr23315875pgm.40.1622012115027;
 Tue, 25 May 2021 23:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-13-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-13-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 25 May 2021 23:54:59 -0700
Message-ID: <CAAeT=FxK_2hjL5w93b1sgOg0WdHuFkvLCbxvoMoJyTWW2m7cRw@mail.gmail.com>
Subject: Re: [PATCH 12/43] KVM: x86: Remove defunct BSP "update" in local APIC reset
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 5:49 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Remove a BSP APIC update in kvm_lapic_reset() that is a glorified and
> confusing nop.  When the code was originally added, kvm_vcpu_is_bsp()
> queried kvm->arch.bsp_vcpu, i.e. the intent was to set the BSP bit in the
> BSP vCPU's APIC.  But, stuffing the BSP bit at INIT was wrong since the
> guest can change its BSP(s); this was fixed by commit 58d269d8cccc ("KVM:
> x86: BSP in MSR_IA32_APICBASE is writable").
>
> In other words, kvm_vcpu_is_bsp() is now purely a reflection of
> vcpu->arch.apic_base.MSR_IA32_APICBASE_BSP, thus the update will always
> set the current value and kvm_lapic_set_base() is effectively a nop if
> the new and old values match.  The RESET case, which does need to stuff
> the BSP for the reset vCPU, is handled by vendor code (though this will
> soon be moved to common code).
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
