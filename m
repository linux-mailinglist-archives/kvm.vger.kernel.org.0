Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0B545A598
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 15:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238084AbhKWO2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 09:28:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238075AbhKWO2l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 09:28:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637677532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZDtecHcGG6uREO+dPTK7MwZPpOOPbHKRsEx76V4VSQc=;
        b=DDbXqRt6KQ/Qb+g7ngbB5yQxslC7iWFf8ORMd3q6SajVquA0RgvJK9cMf3Dn4HulwxkKTq
        7oX1jzw9MBpE7yWfrtwSN8E+woChrGpo641qcTGboK1nl85US935NyOC3qI6fUNuWm5A0T
        2NzHJuIhn9hPvMzyTz+0KxnfI6URzPY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-QrPrsFoiM32WtlEl6xLaTg-1; Tue, 23 Nov 2021 09:25:31 -0500
X-MC-Unique: QrPrsFoiM32WtlEl6xLaTg-1
Received: by mail-ed1-f71.google.com with SMTP id c1-20020aa7c741000000b003e7bf1da4bcso17913125eds.21
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 06:25:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZDtecHcGG6uREO+dPTK7MwZPpOOPbHKRsEx76V4VSQc=;
        b=0kkZnE8akFR3xmsw77Kzyx7YP1/C6KVItsBEiHXsxss3uzuxOeSdTKE7aOONyBD5nz
         75lHAafmctHTS4k5mlk0YyVydNhIgZPzZXVVobkIIw+pfmmSENQroM4U9BOk4oB+dr3d
         xx+GeDzq+uV0rI9bGU2dzAPBBtLZ60K7XtD46eYt29M56SHr8AsIBQmgMDL2M+SXnKj5
         Nnm0mKfMtM9RgravhbeorRBWBxtHw90F1iCemN+glCvbz5or8EWEtgGjN2hHsoPtN+uU
         RhJA168ntFAHntQwB4sI3jrNkH1MaV4C2OCda64Yc3SafKvmG69QgbjQLs/4X3w1ZdWh
         Nrjg==
X-Gm-Message-State: AOAM532xsa/SoFRAcPByGu1DpQ8LWT8fh1Xl+ORmjbi3cE/Umq8iOeir
        MdKcUPv+hqte63iqQZ+WzfCTZA5q+CDP2go3rtka9s01YOk+8pbN2Z/wbwzdf5S9p3jjCd2da/6
        2gxwhhUyiPeDF
X-Received: by 2002:a17:906:eda3:: with SMTP id sa3mr8124099ejb.51.1637677528069;
        Tue, 23 Nov 2021 06:25:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnoKfeX34OruxvnqgnkqOqBxkHRu62ZfO1tJVHZ2NuSw6a7j/qkRRSUXAc0Sqgyw1mXMoOrw==
X-Received: by 2002:a17:906:eda3:: with SMTP id sa3mr8123947ejb.51.1637677527157;
        Tue, 23 Nov 2021 06:25:27 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id k16sm5822213edq.77.2021.11.23.06.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 06:25:26 -0800 (PST)
Date:   Tue, 23 Nov 2021 15:25:24 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH 00/17] KVM: selftests: aarch64: Test userspace IRQ
 injection
Message-ID: <20211123142524.4bjhdvw5pkx3g5ct@gator.home>
References: <20211109023906.1091208-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 08, 2021 at 06:38:49PM -0800, Ricardo Koller wrote:
> This series adds a new test, aarch64/vgic-irq, that validates the injection of
> different types of IRQs from userspace using various methods and configurations
> (when applicable):
> 
>     Intid        Method     |       |          Configuration
>                             |       |
>                IRQ_LINE     |       |
>     SGI        LEVEL_INFO   |       |
>     PPI    x   IRQFD        |   x   | level-sensitive  x  EOIR + DIR
>     SPI        ISPENDR      |       | edge-triggered      EOIR only
>     bogus      ISACTIVER    |       |
>                             |       |
> 
> vgic-irq is implemented by having a single vcpu started in any of the 4 (2x2)
> configurations above.  The guest then "asks" userspace to inject all intids of
> a given IRQ type using each applicable method via a GUEST_SYNC call.  The
> applicable methods and intids for a given configuration are specified in tables
> like this one:
> 
>     /* edge-triggered */
>     static struct kvm_inject_desc inject_edge_fns[] = {
>             /*                            sgi    ppi    spi */
>             { KVM_IRQ_LINE,               false, false, true },
>             { IRQFD,                      false, false, true },
>             { ISPENDR,                    true,  false, true },
>     };
> 
> Based on the (example) table above, a guest running in an edge-triggered
> configuration will try injecting SGIs and SPIs.  The specific methods are also
> given in the table, e.g.: SGIs are injected from userspace by writing into the
> ISPENDR register.
> 
> This test also adds some extra edge tests like: IRQ preemption, restoring
> active IRQs, trying to inject bogus intid's (e.g., above the configured KVM
> nr_irqs).
> 
> Note that vgic-irq is currently limited to a single vcpu, GICv3, and does not
> test the vITS (no MSIs).
> 
> - Commits 1-3 add some GICv3 library functions on the guest side, e.g.: set the
>   priority of an IRQ.
> - Commits 4-5 add some vGICv3 library functions on the userspace side, e.g.: a
>   wrapper for KVM_IRQ_LINE.
> - Commit 6 adds the basic version of this test: inject an SPI using
>   KVM_IRQ_LINE.
> - Commits 7-17 add other IRQs types, methods and configurations.
>

Hi Ricardo,

I didn't review this in detail, but it looks good and quite thorough. Out
of curiosity did thoroughness come from attempting to get coverage on KVM
code? I.e were you running some sort of code coverage tool on KVM with
these tests?

Unfortunately I probably won't have a chance to look much closer than the
scan I just did, so FWIW

For the series

Acked-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

