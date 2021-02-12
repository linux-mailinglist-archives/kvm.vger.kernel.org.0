Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68703197A7
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 02:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhBLA7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 19:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhBLA7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 19:59:49 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB0FC061756
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 16:59:09 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id i20so7010522otl.7
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 16:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E8dTklfppDgtQ5t+jdmFpUHmiL5MAONXlpGXODd+kf0=;
        b=SorPw2Scef1yOshGti7Inf8DzOeiRsZ7yHSUKsbc8+NXWhPG7zW6N0DoyhxI6UIQNh
         mayKPkr0QDB6iD4VNbHnqlgheyTykyjR8/q7e4w6T94NDAwfNxEWA95SmJyrzPkWaRRP
         13sIzAmOwV6ixC/LwBlXS3oJ47cquyc5yETttJHrDGcTj8myLn377pxQMxqAWlE6CzyH
         xHgkRcokd3P0ywLLItHIyZBp9MQhc649ifyZu/v3VpdQOi9XLPFydp7JZVvo96aSBbH6
         m9JI3H6OhFvjpglhgPpXY6zDoGUkcpexn1f70W2OrhC+GOzZAtx0PpVQRaUUKjI+badu
         jU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E8dTklfppDgtQ5t+jdmFpUHmiL5MAONXlpGXODd+kf0=;
        b=ULTHSibvROmENmyMNYDUy7LSxRghdktgQCZeFVNGgqq9D/F5KfBGqBFnqaKXUmI4hi
         Mb56ppKc/dO+awh1fn+tfYhamCEfPqd/tvzEQOSOMiCQtL0E5pqGJaKw50+VPoZMQvI5
         gcb/B9Joecuj4gk+pquOK5EzirTctLs1/kjVeAEg2zrZcv7XCJrI/txLkSoTpQcpwTa6
         bpRxVCLXOe19yph5pnlN6ZFfyFDbokQo//amdT/8jKkYQ+hIfcq4cns/aEu7+zKhbtb6
         yEcdaqN7/uc/lGCBcuWNo2wFdJF23oce7awFjPXQfDNROy3jWCRC2aOBEUhJpkgWudlc
         Bv2Q==
X-Gm-Message-State: AOAM532yg2kQZEuQUTb3Cxja5CyY9NazqIFhs5dlAhBkLAvIXZunIPpU
        pmQ4EyE7wofJBPbheOGro9GVF16wZ2YKEpfFzRX6nw==
X-Google-Smtp-Source: ABdhPJwboH2bgMuX2aLA+0ostnowl3Ehax1DZAhkm1wfOYTPGkTXxKvLSaPPwydNjb3E+ZSGF8jwG+s959v/ITGHUbc=
X-Received: by 2002:a05:6830:902:: with SMTP id v2mr474189ott.56.1613091548340;
 Thu, 11 Feb 2021 16:59:08 -0800 (PST)
MIME-Version: 1.0
References: <20210212003411.1102677-1-seanjc@google.com> <20210212003411.1102677-4-seanjc@google.com>
In-Reply-To: <20210212003411.1102677-4-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 11 Feb 2021 16:58:57 -0800
Message-ID: <CALMp9eQL4YOofdAV9CiZg-AD5atzxR28LcejB2sHHQ0SZZ6+ug@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Allow INVPCID in guest without PCID
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Babu Moger <babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 11, 2021 at 4:34 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Remove the restriction that prevents VMX from exposing INVPCID to the
> guest without PCID also being exposed to the guest.  The justification of
> the restriction is that INVPCID will #UD if it's disabled in the VMCS.
> While that is a true statement, it's also true that RDTSCP will #UD if
> it's disabled in the VMCS.  Neither of those things has any dependency
> whatsoever on the guest being able to set CR4.PCIDE=1, which is what is
> effectively allowed by exposing PCID to the guest.
>
> Removing the bogus restriction aligns VMX with SVM, and also allows for
> an interesting configuration.  INVPCID is that fastest way to do a global
> TLB flush, e.g. see native_flush_tlb_global().  Allowing INVPCID without
> PCID would let a guest use the expedited flush while also limiting the
> number of ASIDs consumed by the guest.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
I always thought this was a bizarre one-off restriction.
Reviewed-by: Jim Mattson <jmattson@google.com>
