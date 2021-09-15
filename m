Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C9C40CA22
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 18:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhIOQeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 12:34:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhIOQeB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Sep 2021 12:34:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631723561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YHkGOnRH445M1d9hLlLUWfMXPA2J8M8wItfcEOw5gl8=;
        b=ZWokIJBvEh6iKbPazDpPYFQYIzbyGQeAmOtN0CnPZe3J8DxWYNBGfJoUGTQ0ikySBGBQ0B
        Ltj5Z4PXu2XW39eqpzf1Yopa4912b2RHxsc7pmOEUshGborHYOxgcrpNtGU+8FtBlNda9J
        pKHMFvljzAp1wlwYXUokzGLK+k3oe00=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-T0UhG7jWN7GXB3sTYtiBBQ-1; Wed, 15 Sep 2021 12:32:40 -0400
X-MC-Unique: T0UhG7jWN7GXB3sTYtiBBQ-1
Received: by mail-oo1-f72.google.com with SMTP id 68-20020a4a0d47000000b0028fe7302d04so3630095oob.8
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 09:32:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHkGOnRH445M1d9hLlLUWfMXPA2J8M8wItfcEOw5gl8=;
        b=SpTIoL3GxyG3toSotExBot+QfcRM2j59WNlSSFqnP9Goi5HC9pbm1fERqHOtZbxYDS
         LiAEQJZx4PxohlkIqSX1hBynEc7C3ZWg0kXJfKgUG2Oa7Xw4blHzWrtL08RE5cK+xtL4
         d6ZbZC1245e5ef9uE7ViCRh6e+AGDw35u9PRCMg1s1OxG39m/BskTGW1rerdVzNHN/WZ
         BV53nS4BtZ4yhKb+Pkk7myyQBOCQewXMCdbf804s52NBtYvcJa/FGZ3BsST5Vl0BtID1
         +4v09BgX2YwPM/eKk306oEN1hAQRGg8Gk4bHQCyrlhNzoR0f6SYJ7LD/iubEpt39fqDV
         AtCA==
X-Gm-Message-State: AOAM532ay0wFGK+EwJYGGtLrj0bvRTtzL7K4azbwxngLaLdtGEsMuNPP
        V/RHkTqfTXh47Bj+6IsiVSRZo4mNiojP/UZwvXJbJLeu1/NkSX8vfYGzjPpYbIwZrKi2LTSkY4K
        PgmrlHk0314j8
X-Received: by 2002:a9d:6398:: with SMTP id w24mr777171otk.140.1631723557706;
        Wed, 15 Sep 2021 09:32:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEqEMq5Emx3QGBfkQ0rbyCrZIePE3tj2f7Z2WEi4Rv/KLV4WT4gXmfCPEt+bUaapt3BePG7Q==
X-Received: by 2002:a9d:6398:: with SMTP id w24mr777147otk.140.1631723557449;
        Wed, 15 Sep 2021 09:32:37 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id q131sm122216oif.44.2021.09.15.09.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:32:37 -0700 (PDT)
Date:   Wed, 15 Sep 2021 10:32:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Ruffell <matthew.ruffell@canonical.com>
Cc:     linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, nathan.langford@xcelesunifiedtechnologies.com
Subject: Re: [PROBLEM] Frequently get "irq 31: nobody cared" when passing
 through 2x GPUs that share same pci switch via vfio
Message-ID: <20210915103235.097202d2.alex.williamson@redhat.com>
In-Reply-To: <9e8d0e9e-1d94-35e8-be1f-cf66916c24b2@canonical.com>
References: <d4084296-9d36-64ec-8a79-77d82ac6d31c@canonical.com>
        <20210914104301.48270518.alex.williamson@redhat.com>
        <9e8d0e9e-1d94-35e8-be1f-cf66916c24b2@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Sep 2021 16:44:38 +1200
Matthew Ruffell <matthew.ruffell@canonical.com> wrote:
> On 15/09/21 4:43 am, Alex Williamson wrote:
> > 
> > FWIW, I have access to a system with an NVIDIA K1 and M60, both use
> > this same switch on-card and I've not experienced any issues assigning
> > all the GPUs to a single VM.  Topo:
> > 
> >  +-[0000:40]-+-02.0-[42-47]----00.0-[43-47]--+-08.0-[44]----00.0
> >  |                                           +-09.0-[45]----00.0
> >  |                                           +-10.0-[46]----00.0
> >  |                                           \-11.0-[47]----00.0
> >  \-[0000:00]-+-03.0-[04-07]----00.0-[05-07]--+-08.0-[06]----00.0
> >                                              \-10.0-[07]----00.0


I've actually found that the above configuration, assigning all 6 GPUs
to a VM reproduces this pretty readily by simply rebooting the VM.  In
my case, I don't have the panic-on-warn/oops that must be set on your
kernel, so the result is far more benign, the IRQ gets masked until
it's re-registered.

The fact that my upstream ports are using MSI seems irrelevant.

Adding debugging to the vfio-pci interrupt handler, it's correctly
deferring the interrupt as the GPU device is not identifying itself as
the source of the interrupt via the status register.  In fact, setting
the disable INTx bit in the GPU command register while the interrupt
storm occurs does not stop the interrupts.

The interrupt storm does seem to be related to the bus resets, but I
can't figure out yet how multiple devices per switch factors into the
issue.  Serializing all bus resets via a mutex doesn't seem to change
the behavior.

I'm still investigating, but if anyone knows how to get access to the
Broadcom datasheet or errata for this switch, please let me know.
Thanks,

Alex

