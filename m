Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC83F39AF1B
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 02:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhFDAjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 20:39:32 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:43885 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDAjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 20:39:31 -0400
Received: by mail-oi1-f169.google.com with SMTP id x196so7730792oif.10;
        Thu, 03 Jun 2021 17:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s7nEdQcY/p+TC08ogyU8FerWaBHWxe/Eo8CRfV1cw0w=;
        b=OoVvJFTqT/DtLQvE1kRAzRIdTWnLogZekSec/LIhGLxo8dkW3ZsAO78qeGdOWecA4W
         5F7QrYQ7UN8XCETOA/ThG3sweQ1uTZniMqi7hZcsKOpAW0BeONRP4Fkv0Yu2Z8URxevz
         1t8vqkg71grw8zz3OvXwMQz8l5CGWz74x/THfXRR6zTxl5AO0pBxQGLw/Lv/F1PP3nlG
         APQMbhE4LdwOyyKihxuEcseCdVx3HseAaATlQHrmBT10BCuh1cOimJd8Di2349O65R5p
         LPGlaXzQm252rA+GSK8VhCv8qFnEhEyDaxTgeirst2K1csNNJ0ClW/iOsPHLd+2dvgMa
         PT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s7nEdQcY/p+TC08ogyU8FerWaBHWxe/Eo8CRfV1cw0w=;
        b=AMGde64sshSW+0DB0m2Y/TqnNKQMHiORqomurajZX/chfbKC/0J/RNNj1K2NZYgtgp
         Wt/lJh+cSYJENlPLMXo6yFzbe+GfLc0t+O2sFZDLCFm1OHXvrQE1mXqmTsbv0UbwrN/S
         jI3ARUGvdREdkZPYkyp2ea78TxPschYwD6jUcFe2XJHBMOucjL7dbtWg9cQF60gJf/DS
         lKwvyCb0BkrvI6EnHU6k8p+Zje1ksoXZGw6uEdClZq80/uAs72GJe8BJykQVehJT9NgM
         W1QCwyDe0S6EQtzJyaso7LsdT2D4mHTMHG7WgFKo5rwv0d7Llt8SdCQL609jD38Rf7aB
         iTQQ==
X-Gm-Message-State: AOAM530W58kgHFGFdVy7OYxO4DhiqQOYVLhqx9E8y8WzzC1ENzznlC+l
        17CyI3IGnp8hjsTWnBsOn676zXvWCf9eieLyyjo=
X-Google-Smtp-Source: ABdhPJwhPTHlEgWA6urtgjI0fypdk7rUTFacZHeHsKfsR5gCNCpetpf6y6LJNZbLDZ9zgAp7zne3+yBRKOjMxzwT4OI=
X-Received: by 2002:a05:6808:8e5:: with SMTP id d5mr9155116oic.141.1622766994027;
 Thu, 03 Jun 2021 17:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <1622710841-76604-1-git-send-email-wanpengli@tencent.com> <YLjzJ59HPqGfhhvm@google.com>
In-Reply-To: <YLjzJ59HPqGfhhvm@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 4 Jun 2021 08:36:22 +0800
Message-ID: <CANRm+CxSAD9+050j-1e1_f3g1QEwrSaee6=2cB6qseBXfDkgPA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: LAPIC: write 0 to TMICT should also cancel
 vmx-preemption timer
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Jun 2021 at 23:20, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jun 03, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > According to the SDM 10.5.4.1:
> >
> >   A write of 0 to the initial-count register effectively stops the local
> >   APIC timer, in both one-shot and periodic mode.
> >
> > The lapic timer oneshot/periodic mode which is emulated by vmx-preemption
> > timer doesn't stop since vmx->hv_deadline_tsc is still set.
>
> But the VMX preemption timer is only used for deadline, never for oneshot or
> periodic.  Am I missing something?

Yes, it is upstream.
https://lore.kernel.org/kvm/1477304593-3453-1-git-send-email-wanpeng.li@hotmail.com/

    Wanpeng
