Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2E939110B
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 08:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbhEZG5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 02:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbhEZG5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 02:57:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE87BC061756
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 23:55:34 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t11so308011pjm.0
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 23:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RjiFmCiLoMXys/jJOXLgjINLJSxKbFwfyeipr8yG200=;
        b=UILHNq0ZQ44Op1yN22PE+fr0aPxKsRcqBKe2vgj/ZYCZ5zgqK8ESD6c0o2OctpBqAO
         F4gAYpcVJYglNj74YRntIWOHnu/4MftKwOz/Wv1XjE09wrxeTqPZvM1gXTb8/Gac51M9
         Eez1H76ppX48hU+F3TNmSSSy1KabYUGNcA97NTM445m8zOv6Mag/4vBmqaeqUm3scvXk
         T1k3kW60T8B2TqEuavy1/nAP17gACa3ZkHtkIyetscuvYT+QmJ4is+ecgGBneayKgBn8
         0jnWZX9XPv+8aVYjiFtP4kZ7aVFyX5gdsQHRHMlJMX7+KMSd13kfi7dkTx7O/gDIr3Bx
         MrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RjiFmCiLoMXys/jJOXLgjINLJSxKbFwfyeipr8yG200=;
        b=lPQd7cxDVIeFjgrOYer9nIJZ2r21EczOxC/4+auJFTgFtULMc90JVRT2qQio8d1+uD
         To/GDHanIR8iDLrU+VCUs1lmotwfAdzzUPzh33zSkUhPk8ThUxttZa5dOWacIKqxTgLI
         HJ2ue3syRt3CBYp6Ll6u3w9xWDHMGewgWqDTDBHVgP2QUOnEjQbsGFbR3V/8K8zF9DCg
         qJ3LHACo2pXwhA0KzQpsxRTS+j/8W0doGP7ekEqLQR1WWA42NOomdRdi/5+hDxF9WYlJ
         N52qMZ//qO/35d20hwCOE0hTdkttJZhTxp4/GoG9bbzgkQDpivbWb2kJwWUDfXiMwIB3
         TPug==
X-Gm-Message-State: AOAM533X6E99XfplDyA03wbTrbAgoCerWUMG+GYRlSwOFofl+SBqVlsf
        qW1xuNa0RFrlK8DdEJrV878njBgalzlRuME7icpo5A==
X-Google-Smtp-Source: ABdhPJwRRVEHDVTMqfFTUnYVfd0PVGRjf+M4h6VX2CYE8bx4GDAuDS39o3O9kkzOO/8gmF6Auu/QL9KeqY9zad/UMz4=
X-Received: by 2002:a17:90b:1185:: with SMTP id gk5mr33983187pjb.168.1622012134164;
 Tue, 25 May 2021 23:55:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-15-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-15-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 25 May 2021 23:55:18 -0700
Message-ID: <CAAeT=FzQBOy=ysxXM24_w0O+p5vrAOWCTMxxv__aF2TG=U_AHA@mail.gmail.com>
Subject: Re: [PATCH 14/43] KVM: x86: Don't force set BSP bit when local APIC
 is managed by userspace
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

On Fri, Apr 23, 2021 at 5:50 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Don't set the BSP bit in vcpu->arch.apic_base when the local APIC is
> managed by userspace.  Forcing all vCPUs to be BSPs is non-sensical, and
> was dead code when it was added by commit 97222cc83163 ("KVM: Emulate
> local APIC in kernel").  At the time, kvm_lapic_set_base() was invoked
> if and only if the local APIC was in-kernel (and it couldn't be called
> before the vCPU created its APIC).
>
> kvm_lapic_set_base() eventually gained generic usage, but the latent bug
> escaped notice because the only true consumer would be the guest itself
> in the form of an explicit RDMSRs on APs.  Out of Linux, SeaBIOS, and
> EDK2/OVMF, only OVMF consume the BSP bit from the APIC_BASE MSR.  For
> the vast majority of usage in OVMF, BSP confusion would be benign.
> OVMF's BSP election upon SMI rendezvous might be broken, but practically
> no one runs KVM with an out-of-kernel local APIC, let alone does so while
> utilizing SMIs with OVMF.
>
> Fixes: 97222cc83163 ("KVM: Emulate local APIC in kernel")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
