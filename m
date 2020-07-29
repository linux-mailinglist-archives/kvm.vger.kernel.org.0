Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE942232794
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 00:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgG2WZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 18:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgG2WZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 18:25:34 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0213EC0619D2
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 15:25:33 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l17so26239029iok.7
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 15:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OQix/zi4zcvd/1V7gOM1KOXd4VNs5uUsD1lxq267omk=;
        b=oT1aUzp1Cir3SIhEKVPCMyczX6Log3jJ7mmwHY7j0ylzXfZ5lrcA7yqpK7cj+g5o+f
         BZMIHKb/fiN/31wb9sLVPD0NTUoN7fC8D1VqvcmJAB72MsTmNoF/boxmI1SGyAfVetAA
         yQV7muOMvPv1VPhdDzEaMZJcwVkr3w4BrlteFkLHdqcF59LcCwfNRXViQFFkIA7WL5v5
         CCLM3IFKXpZet4mPOQykBg8CrhOiTBrx4Ad+OIIY/cpRiuZG3VlH1lgz9aWQWd55BQdg
         A2GX2MTSW9QdjsS8oFLJhgI1c5uppJtRRKzoz7L2lOptiiQDDpHB70ej1UIVM8Zg3NQV
         g4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OQix/zi4zcvd/1V7gOM1KOXd4VNs5uUsD1lxq267omk=;
        b=p1LH8EPVZYQtPzCtLkwB+TdhTqsQauIFKEhXfHh6gNoN1j/1AwSTtslisAhj0XkYYF
         4NH8LeXHL6uqAhFC3uhf6n+ryFQ9RsKb/7nrHpZSBiufZ8y2U8MYV5gAsFpprnNUWSe/
         ZmpWqGWGYFqqX09czyN4VT3UR5gGy4MBMSAD0lGp2ISS/Nli3kbf/iTWJk1EgqLzVohT
         gXb0D+CpNb8Y2IwOZFl58K4jbu7zX6plZZcuG3hgPhXD1A+B4gfkb7m534TreW4/oTB4
         t7MuNIk8TyeiPJnMpgr/CZJct4zfwKH7/vTPCbcoOQSuLK1CluexdNrpk+7I3zGEMW76
         sdJA==
X-Gm-Message-State: AOAM531QUdmvxBWNr6e+PAAvoxjBplYOCpu9tclznck+sL5yTUd8sRq5
        b4XW03luyrMA2GrbzvjrSuF05oloqbaRKEacaB5okaiWI28=
X-Google-Smtp-Source: ABdhPJw5CPuJri7GLgSp032H+EdTGOED3fpS21Kngu5E8Ar7I8+zuLM/XzSkDyl9zW6btwwI0Y6z0glEGB52/kl00+Y=
X-Received: by 2002:a02:394c:: with SMTP id w12mr266083jae.18.1596061533081;
 Wed, 29 Jul 2020 15:25:33 -0700 (PDT)
MIME-Version: 1.0
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu> <159597953280.12744.625668493094858788.stgit@bmoger-ubuntu>
In-Reply-To: <159597953280.12744.625668493094858788.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jul 2020 15:25:22 -0700
Message-ID: <CALMp9eS+u_NS6PCB5pqGoeCad0Q04pMpfy0f74Af1LOWZA6Xhg@mail.gmail.com>
Subject: Re: [PATCH v3 10/11] KVM: X86: Move handling of INVPCID types to x86
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
>
> INVPCID instruction handling is mostly same across both VMX and
> SVM. So, move the code to common x86.c.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
