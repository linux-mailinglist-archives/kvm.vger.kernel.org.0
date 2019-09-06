Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7012ABF08
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 19:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389788AbfIFRzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 13:55:13 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:44557 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387514AbfIFRzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 13:55:13 -0400
Received: by mail-io1-f41.google.com with SMTP id j4so14614720iog.11
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 10:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=17R+hHxTazpGZhQYZ1Lrlkffcba41cwAFl0hBBhiJlI=;
        b=K1bceX96dEHekeseo6tFzp+N7q+DozO52OEwVdhE/2iqJUnEybpJPQPX+HWBGbCvRt
         7GrCmFuw+jDuj8lGztAahn0nMqduFISYG2VjdcafnNzpu6deriAkl8/Rb3yZXmOwSBnV
         kYiFYUdQuVPR8Mq0RxOPYpYXmxjO6BddO5iYTBkC806mR8wGcGmx+V+NHZmfJdcp2RFO
         ZtBYiAI2UmmnnO+ixw5qBA5FuWdk/nMRgyfsKYmHrq7N2ntteMWmjq2tvXRQUTkw7Gl3
         pmEh8DyvpECaxuHp2xMaUeYkFrQdQHckD74WnJiJhBt5o1hkB+euYogkodStcSNNDIOr
         s1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=17R+hHxTazpGZhQYZ1Lrlkffcba41cwAFl0hBBhiJlI=;
        b=YcjZN6Jad52IpA9re/Co5KaxbgYKDoAuJSvjjH3nVZxQr39Lv2dQu7oaO43TqMnVl4
         r3UPJLcUsFtmogY0RbinJjYidEPTzq4kdf5uAirbqfcjJgxTnd+fbNF94zHk26HOKW5w
         Nddg7IRvdpVJrPtHiQnn1Js8lyyGJsMuic8cq/Pkxw36fZIpleK7btJ+SiNdBtj8KcX3
         rGmYSGkMkZPj8Mo/apwH2uxH7s6ahcJ1HUDlr9GiY70rQME+pHvzK/vXFOhtF0qaBG2c
         rytFZe/VXyNjc3TUNoHK6OEbbGV/rEHyeKCzA2sRSg3bQ/+0SHJYj30ZPqtxDU/sUOdj
         ixGQ==
X-Gm-Message-State: APjAAAUsP2RjztO+Xo8MJHv/OvT47siwxKV3LEoszm7vNUIFwTOcGbiy
        YhftBy5qAf1AVZgce4VD4xvAxq40hRwtAAPK/s9qZQ==
X-Google-Smtp-Source: APXvYqzrc6PpvwWnVkEoLWy+JlhKpFWXAu51jPnsZiPicrRJ6kRSbbs6kQLMo8sugO5Dxsg4rPOJmeZhONJBBn/y0jY=
X-Received: by 2002:a05:6638:308:: with SMTP id w8mr11507072jap.75.1567792511843;
 Fri, 06 Sep 2019 10:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190904001422.11809-1-aaronlewis@google.com> <87o900j98f.fsf@vitty.brq.redhat.com>
In-Reply-To: <87o900j98f.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 6 Sep 2019 10:55:00 -0700
Message-ID: <CALMp9eRbDAB0NF=WVjHJWJNPgsTfE_s+4CeGMkpJpXSGP9zOyg@mail.gmail.com>
Subject: Re: [Patch] KVM: SVM: Fix svm_xsaves_supported
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 4, 2019 at 9:51 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Currently, VMX code only supports writing '0' to MSR_IA32_XSS:
>
>         case MSR_IA32_XSS:
>                 if (!vmx_xsaves_supported() ||
>                     (!msr_info->host_initiated &&
>                      !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
>                        guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
>                         return 1;
>                 /*
>                  * The only supported bit as of Skylake is bit 8, but
>                  * it is not supported on KVM.
>                  */
>                 if (data != 0)
>                         return 1;
>
>
> we will probably need the same limitation for SVM, however, I'd vote for
> creating separate kvm_x86_ops->set_xss() implementations.

I hope separate implementations are unnecessary. The allowed IA32_XSS
bits should be derivable from guest_cpuid_has() in a
vendor-independent way. Otherwise, the CPU vendors have messed up. :-)

At present, we use the MSR-load area to swap guest/host values of
IA32_XSS on Intel (when the host and guest values differ), but it
seems to me that IA32_XSS and %xcr0 should be swapped at the same
time, in kvm_load_guest_xcr0/kvm_put_guest_xcr0. This potentially adds
an additional L1 WRMSR VM-exit to every emulated VM-entry or VM-exit
for nVMX, but since the host currently sets IA32_XSS to 0 and we only
allow the guest to set IA32_XSS to 0, we can probably worry about this
later.

I have to say, this is an awful lot of effort for an MSR that's never used!
