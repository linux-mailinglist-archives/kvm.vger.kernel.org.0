Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB273A09CB
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 04:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbhFICLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 22:11:38 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:44942 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhFICLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 22:11:37 -0400
Received: by mail-oi1-f174.google.com with SMTP id a26so2922224oie.11;
        Tue, 08 Jun 2021 19:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j6J8M2LW4OQTXoCnMqD6GZA3YY4qIJ+14ZMMPzy3nNA=;
        b=TO/1/ZmQTZVlXVreEz1Wnm35M7XfbS2kPnUV8GPoTi/1yQlimKeNHWRFexvfKFViO8
         qLyDzXq73KAYKsR1guyy0kMx42zj305Ka2+1LZSeremO96Vm3NCHwfDsU+oGJA5IB37T
         h5p21+sxx7JIZ5YcN7NCWzULIYNlckcn8YOrzmt6f1Pq/6PNIbe8xrexOn3lDQkTMcuL
         GybTKgT2lBmAkjb9GicsAquCQTdFN0RgsondW0EDAnc2CzeSDfLrgLV1gX0HqX+mA8Kg
         mI0YNYXw+Cd0wEochnOlTx4UzkxwYGNhXP+ZyxLEKuDW+w8ZJr+9GEcGQpE42NsMluKE
         4k6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j6J8M2LW4OQTXoCnMqD6GZA3YY4qIJ+14ZMMPzy3nNA=;
        b=lHR5xi4DCVWmP8oHuqk+K6kPtVnfQqw8iEOMBLB48DRL2ZwSb8Tj8N1tf73S3tZg+M
         OCHutvgeKWwjx57Q0mXxaNe91TUNYQEWKO5s0haDoF2gxuAkX6GaZicqh0b20Fbsbn0l
         MqaVyJnomUQTHcHdoxWgnC8IDC2jpoNbxTfwKLq4Y1+jtuFlKCpnt3M93JkdcSa1q0UZ
         +QclpIV8kj6/6Ah40aYpWWM5BTnTwBJJDO4X84qKRGn+8KiHG0t+FNrUCscLEFZ93Jxp
         7PhAJ8BiHS+jnY+LysFAx+G/rcqNHiCOmcO9B0UdQU+B6yL/YSBEtnoMOX5isE1QJBkj
         9zyQ==
X-Gm-Message-State: AOAM532uwASb9VgZWgVgH7Y0yzBex4w2xLsfCuSNhjPUbHoIu0Sse9Et
        jP+LxIzHLbC3fRVAp16YBcZgHbCTAaFR7LMPUu0INBdr
X-Google-Smtp-Source: ABdhPJx5PCs8Ixy9IcHz6ujk1QmNLxyKbDNsO8+sukAlzqfMxkYL4uEyRL++kadw8K0KJzZnfZQQrKfJ4lydegFbKeY=
X-Received: by 2002:a05:6808:c3:: with SMTP id t3mr4568257oic.5.1623204510120;
 Tue, 08 Jun 2021 19:08:30 -0700 (PDT)
MIME-Version: 1.0
References: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
 <1623050385-100988-3-git-send-email-wanpengli@tencent.com> <YL+cX8K3r7EWrk33@google.com>
In-Reply-To: <YL+cX8K3r7EWrk33@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 9 Jun 2021 10:08:19 +0800
Message-ID: <CANRm+CyecU4KYxNv77WGsiUB35r4TDNnLk7m_GLv=HvDCOGOLQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: X86: Let's harden the ipi fastpath condition
 edge-trigger mode
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

On Wed, 9 Jun 2021 at 00:35, Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jun 07, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Let's harden the ipi fastpath condition edge-trigger mode.
>
> Can you elaborate on the motivation for this patch?
>
> Intel's SDM states that the trigger mode is ignored for all IPIs except INIT,
> and even clarifies that the local xAPIC will override the bit and send the IPI
> as edge-triggered.
>
> AMD's APM on the other hand explicitly lists level-triggered Fixed IPIs as a
> valid ICR combination.
>
> Regardless of which of the two conflicting specs we want KVM to emulate (which
> is currently AMD), I don't see why the fastpath code should care, as I can't
> find anything in the kvm_apic_send_ipi() path that would go awry if it's called
> from the fastpath for a level-triggered IPI.

Fair enough.

    Wanpeng
