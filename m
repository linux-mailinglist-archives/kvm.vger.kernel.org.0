Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA151934F2
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 01:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgCZAU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 20:20:56 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44275 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbgCZAU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 20:20:56 -0400
Received: by mail-oi1-f196.google.com with SMTP id v134so3929737oie.11;
        Wed, 25 Mar 2020 17:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cXCQWGOzZbHlQrF+J0jHCYgxM5tUf5xEiJJPZMX3IWk=;
        b=bj3dQDFG1NQldxJ6xsrP/T9Pg7GlPHLtSnn3ao2+6CopJsP/L+2LgouWqf/ZJfqSHH
         Y1HTnrdJAddU6DjXM8SxLDiD0vcXWOAV9hmN1e3nTtcjXCECBvIIuXex3CQ8vcZrO2Xb
         nrLntxJQgXPmLbrTqUImP0/aaNik9ahRowBlqa/eVDPeXFil6gz/j7u0y9d8+fD03Mk1
         tKQ15TpIRr0yM+wyYi1ClkZEa8XXCtbVTNhRHM6vrK2N+JFuvoWwU9f7KmxnVS65LnjM
         ntvwXZrCFPkAH5yn8stjgrhR6KndHfOMxKYGVUP+ShD8bcTPDli7DLPYsV6iYM9oBu99
         l5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cXCQWGOzZbHlQrF+J0jHCYgxM5tUf5xEiJJPZMX3IWk=;
        b=flD4PslWu/+0KxIYmVnG+cb1GJ+eQRWzLQbTLW5Y2RyVbGWTJ9VLRnY+pQC+FL4Evk
         JIeEsbZYgxBg7ts0pV4ZzFeDSy7McSVKMDHSQrwDSe+KH1Z4ywImlPySYfxPoKSPOKSU
         yS0EmBhLuEm+kZAn6pZZh7/Pp9rVdhWAgbxHmhb5eIfqLVSXhRYltq66tLAlKIlAlXyx
         YzgOwBsirO0kfjKln3sz0JHuBiYMbK5RYDUaKse2uv1pnqiFhOuDH/MXv7WwbjZ8gm08
         nccMkFWKyMXnDsyhWY0n2zCF4nQOmVjpSg+D7hLKBeCNKo2tGZRE0g4o68Yl2Yr4mfjZ
         zOmA==
X-Gm-Message-State: ANhLgQ1JWKCrshX3HcuvZFNZSbkmwaBO2G+kLMCmHJlaoy5SoV185/bC
        7sk08Lze57Hba/jUxpvGb2L7kogyNsnSmKyt+0A=
X-Google-Smtp-Source: ADFU+vt1GcySl1g/SC/21eloPefOnHfQC4QzBvP4QNMs95v9AA9pUnQ90a2CWHra9vyGxtWpF8UvZ6UkArexMw64UIA=
X-Received: by 2002:a54:4094:: with SMTP id i20mr107839oii.141.1585182053512;
 Wed, 25 Mar 2020 17:20:53 -0700 (PDT)
MIME-Version: 1.0
References: <1585031530-19823-1-git-send-email-wanpengli@tencent.com> <708f1914-be5e-91a0-2fdf-8d34b78ca7da@redhat.com>
In-Reply-To: <708f1914-be5e-91a0-2fdf-8d34b78ca7da@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 26 Mar 2020 08:20:42 +0800
Message-ID: <CANRm+CwGT4oU_CcpRcDhS992htXdP4rcO6QqkA1CyryUJbE6Ug@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Also cancel preemption timer when disarm
 LAPIC timer
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Mar 2020 at 23:55, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/03/20 07:32, Wanpeng Li wrote:
> >                       hrtimer_cancel(&apic->lapic_timer.timer);
> > +                     preempt_disable();
> > +                     if (apic->lapic_timer.hv_timer_in_use)
> > +                             cancel_hv_timer(apic);
> > +                     preempt_enable();
> >                       kvm_lapic_set_reg(apic, APIC_TMICT, 0);
> >                       apic->lapic_timer.period = 0;
> >                       apic->lapic_timer.tscdeadline = 0;
>
> There are a few other occurrences of hrtimer_cancel, and all of them
> probably have a similar issue.  What about adding a cancel_apic_timer

Other places are a little different, here we just disarm the timer,
other places we will restart the timer just after the disarm except
the vCPU reset (fixed in commit 95c065400a1 (KVM: VMX: Stop the
preemption timer during vCPU reset)), the restart will override
vmx->hv_deadline_tsc. What do you think? I can do it if introduce
cancel_apic_timer() is still better.

    Wanpeng
