Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6841FBDC0A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 12:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbfIYKTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 06:19:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbfIYKTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 06:19:07 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 24C405859E
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 10:19:07 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id f11so2104682wrt.18
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 03:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K+rttGEecpHbq8Ld8mEd0xixgNyYzjAcykoYhYhc6C0=;
        b=RWzZVISEErRfUHyPapyw1q/yLy37OMIPMDwgQ9ZmGviLDtwmoYB9Ew/eHytEfQqOBA
         24akXrmCtdkuDnHWHPFR0m76cThNRvp/uUctaE+wufrkbJsW74yw8CZKNgnnmXVp4kF3
         8IsFX+mYu4NXmXDR/nxmw4Ij3GKB1LvwaOyD168tzQYpy9cbto5dHBFMPH+qfNdxZrPv
         wqEj5N+XP2g3czcJSMzq//tlT82cePa/AK3XERNPJVBsYpFCgTfKuvGXipdX4R0Zm+YO
         qm2DTKPEGUf6bgkMGUIXM5NTp/MMqeAR/piFoKLwxXxaTNDn/+XRdP5oIFd0uV1C72qh
         A2RA==
X-Gm-Message-State: APjAAAX6XSPi99EyjW6XK3XwBtEzPExdG7Mw5JBVJy2a1zQECoc/rtAU
        MAp+Zp9UjGsKCHteWndn8kGdZryJq3V7aHGDD+R4VYQT3c/501wFUAi6mkdLppeyHNIndvUDJCW
        p6QfzQTzZSrTI
X-Received: by 2002:adf:e849:: with SMTP id d9mr8437363wrn.358.1569406745824;
        Wed, 25 Sep 2019 03:19:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwrvUr0qgn78HfJeD5ClbslLh48/3q2qowypmAsSIjSUOTWOFeFBhLzjofRh50aKkErmgHVsw==
X-Received: by 2002:adf:e849:: with SMTP id d9mr8437343wrn.358.1569406745538;
        Wed, 25 Sep 2019 03:19:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id z3sm2871366wmi.30.2019.09.25.03.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 03:19:05 -0700 (PDT)
Subject: when to use virtio (was Re: [PATCH v4 0/8] Introduce the microvm
 machine type)
To:     David Hildenbrand <david@redhat.com>, Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org,
        Pankaj Gupta <pagupta@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com>
 <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com> <87h850ssnb.fsf@redhat.com>
 <b361be48-d490-ac6a-4b54-d977c20539c0@redhat.com>
 <231f9f20-ae88-c46b-44da-20b610420e0c@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <77a157c4-5f43-5c70-981c-20e5a31a4dd1@redhat.com>
Date:   Wed, 25 Sep 2019 12:19:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <231f9f20-ae88-c46b-44da-20b610420e0c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a tangent, but I was a bit too harsh in my previous message (at
least it made you laugh rather than angry!) so I think I owe you an
explanation.

On 25/09/19 10:44, David Hildenbrand wrote:
> I consider virtio the silver bullet whenever we want a mature
> paravirtualized interface across architectures. And you can tell that
> I'm not the only one by the huge amount of virtio device people are
> crafting right now.

Given there are hardware implementation of virtio, I would refine that:
virtio is a silver bullet whenever we want a mature ring buffer
interface across architectures.  Being friendly to virtualization is by
now only a detail of virtio.  It is also not exclusive to virtio, for
example NVMe 1.3 has incorporated some ideas from Xen and virtio and is
also virtualization-friendly.

In turn, the ring buffer interface is great if you want to have mostly
asynchronous operation---if not, the ring buffer is just adding
complexity.  Sure, we have the luxury of abstractions and powerful
computers that hide most of the complexity, but some of it still lurks
in the form of race conditions.

So the question for virtio-mem is what makes asynchronous operation
important for memory hotplug?  If I understand the virtio-mem driver,
all interaction with the virtio device happens through a work item,
meaning that it is strictly synchronous.  At this point, you do not need
a ring buffer, you only need:

- a command register where you write the address of a command buffer.
The device will do DMA from the command block, do whatever it has to do,
DMA back the results, and trigger an interrupt.

- an interrupt mechanism.  It could be MSI, or it could be an interrupt
pending/interrupt acknowledge register if all the hardware offers is
level-triggered interrupts.

I do agree that virtio-mem's command buffer/DMA architecture is better
than the more traditional "bunch of hardware registers" architecture
that QEMU uses for its ACPI-based CPU and memory hotplug controllers.
But that's because command buffer/DMA is what actually defines a good
paravirtualized interface; virtio is a superset of that that may not be
always a good solution.

Paolo
