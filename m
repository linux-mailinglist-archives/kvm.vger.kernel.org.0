Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FAD2CE106
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 22:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgLCVqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 16:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbgLCVqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 16:46:00 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8C9C061A52
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 13:45:20 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id i13so884775oou.11
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 13:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1CLO7AFMn+8z0i19Z85OO0S7AbDmXYy/hyeLXj3/omo=;
        b=FA7Iqjeb+7dxH6zie2VAiYSrxiUeT5PIGoofTpmzciXwiuV7nLRV80BYrsf4XGf4UN
         F6yzrLftlNm9n/cMzHRIZJ0YS2OBuaPv6zkTk+1yhQ3hexhrEZ+k54icVJpoQ5k4iJ9U
         cTx93cBiJ314C4sFBkr60eTzlRvMlI9z5t0thZiEks1fX+Tud4tGsqtjcHNYE0nJ2KjK
         RATbkuTR/Ubs6id6O3lDGaZePzdGHElHYU9624S/QGAZOHpn8FNW4wVT8IdHV4pHZpeS
         rje2dQLbbH0KjI6meZbT9UaVrcMAm63UZejRjiQy3qZzRISfC2CSxBDW9W4/PimwzLy5
         gf8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1CLO7AFMn+8z0i19Z85OO0S7AbDmXYy/hyeLXj3/omo=;
        b=jPi4QLYIulUGJX1YHV9Zt6ybwG1UGpv9BxSKBxs0+IlGZVJ6ObOYJTsmo+m6kBLiti
         ghW8OiyBsSI8PIQIXpaq2oqfXEPGzXKGlTV01lUjvAbi9SEONvvpvMRFGH9AEJuoLusM
         JquerKH/12Av3Dmq4hsDr/lg5cXF8UVmNSRc9cqLN6UQscq0S3WorbivFQzxs6skHLVJ
         XCciAGr8OOB/+mskGunbwnwyIlyAiQjA+BBIPL+wFyxlL9Xy7ImPgIhdT0tQ2sgUns9T
         biCD8w5ByxTPNHViBV9avCLz1K//OfklnTKB3obohxu5IP/fRDLVtki05FuFRiJOsYCD
         BDGw==
X-Gm-Message-State: AOAM530KBLBxLm1tKrLeo9ORoTkiPWgMy/RgqZaoiq5v1AOrNNy5SJ2Q
        XYEvf3fXW80legrRIhYMwo1FFE0Jjbdww0KtMcihzg==
X-Google-Smtp-Source: ABdhPJzlM0S1QNQ4rp0E39zX1w7sUkTkJpaH+pQIrgHaOyFJmRbBKEmKTsYEtKQmICf+E+OQkd8pe4dLj0n7Cu0czCg=
X-Received: by 2002:a4a:8e16:: with SMTP id q22mr937980ook.81.1607031919684;
 Thu, 03 Dec 2020 13:45:19 -0800 (PST)
MIME-Version: 1.0
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com> <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com> <7ffaa63e-6e75-cf5f-e0c1-d168016c4eca@redhat.com>
In-Reply-To: <7ffaa63e-6e75-cf5f-e0c1-d168016c4eca@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Dec 2020 13:45:08 -0800
Message-ID: <CALMp9eQirnVLc=gi76nYhtFKpgxKh9zUz_sh+u2HKxf7=8fa6A@mail.gmail.com>
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>,
        Idan Brown <idan.brown@oracle.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        Wanpeng Li <wanpeng.li@hotmail.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 24, 2020 at 3:09 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/11/20 01:10, Oliver Upton wrote:
> >> but you also have to do the same*in the PINV handler*
> >> sysvec_kvm_posted_intr_nested_ipi too, to handle the case where the
> >> L2->L0 vmexit races against sending the IPI.
> > Indeed, there is a race but are we assured that the target vCPU thread
> > is scheduled on the target CPU when that IPI arrives?
>
> This would only happen if the source vCPU saw vcpu->mode ==
> IN_GUEST_MODE for the target vCPU.  Thus there are three cases:
>
> 1) the vCPU is in non-root mode.  This is easy. :)
>
> 2) the vCPU hasn't entered the VM yet.  Then posted interrupt IPIs are
> delayed after guest entry and ensured to result in virtual interrupt
> delivery, just like case 1.
>
> 3) the vCPU has left the VM but it hasn't reached
>
>          vcpu->mode = OUTSIDE_GUEST_MODE;
>          smp_wmb();
>
> yet.  Then the interrupt will be right after that moment, at.
>
>          kvm_before_interrupt(vcpu);
>          local_irq_enable();
>          ++vcpu->stat.exits;
>          local_irq_disable();
>          kvm_after_interrupt(vcpu);
>
> Anything else will cause kvm_vcpu_trigger_posted_interrupt(vcpu, true)
> to return false instead of sending an IPI.

This logic only applies to when the IPI is *sent*. AFAIK, there is no
bound on the amount of time that can elapse before the IPI is
*received*. (In fact, virtualization depends on this.)
