Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2C2468542
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 15:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385162AbhLDOMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Dec 2021 09:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385108AbhLDOMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Dec 2021 09:12:50 -0500
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90F4C061751
        for <kvm@vger.kernel.org>; Sat,  4 Dec 2021 06:09:24 -0800 (PST)
Received: by mail-vk1-xa41.google.com with SMTP id u68so3737689vke.11
        for <kvm@vger.kernel.org>; Sat, 04 Dec 2021 06:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=sjZXHJMUq7uvoUrcjUJzKAwi12OhaiQKRqagT7avtE0=;
        b=iXXbQVSCBE0OM4QYMWNU7ciivZ1WS19fZgDXxrSwreE/sNERI4w+B4mSzU60lbWoLB
         p5XGzUV+FVfDTQE473jp74QR1ammQe51NPVkdGejyjU5f4kN6IYCy7Yw+obeC2MfQAl6
         WmLr2jfbK+M1t53KsmtYwxWbSWrz6RXplVHMaXPuFo0g3Hfe6LFq2h0Y1oOdiCjy3iwn
         pZQy4ThUaThT3cAi1fIruVqBkg0OqORooREj1gLe/04bceVwNFrgJulgJRSJzZcrlwAH
         WWvmoewDqwFWQOkKFG5MIca+EOsp0yWJj10kwxz7lGcI8GhmI4ibNhKMEUqA43GBgcxE
         E6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sjZXHJMUq7uvoUrcjUJzKAwi12OhaiQKRqagT7avtE0=;
        b=ortMgH0gAEvAY9U40rg13GhcdozpQcIjuai09m6hPAVGHKx5OmeAYxVIPyMJxxah/Z
         dr+qpEIoujscuoajXbSrjrcQ0/ffs2dtNb+GtHNfelxD9hUEsB7qmzrT48bmns5r64Z9
         ztEaqDiaXn7Vd3qk5Zii3fanp2rpBuauoQXZUr+UJKVT86x0CzAuKVV6xSwZ7v6MM5dF
         KlPP+1p+glqlXVab4lGNyK5Zoiqeew8jgcCR4bF8VS8yQKVGuZOsnFN4EQLalEDQuIds
         awVbKpzwAgBpdRkchLMZgJNknfORaGnmYGcPaafRNMIrfjz45JF/pTboLa6H5UP7Xv0l
         GNIg==
X-Gm-Message-State: AOAM531gHHYip9ajGRjyQrcd8/kP/eGuNfw2fFblAaAYF33TSWFD1KdA
        CWUs70QuZXGaxs5O2Qrii8V03q2J5x1OVILifTuKb3xmUC0=
X-Google-Smtp-Source: ABdhPJxJobMxoWbdELpt5KJRdtS83ebD8c2VRhadRtFkJrLa9RRbemf/FytMk+L0ytADjb634Dt4siso2Q8LqfBOdwE=
X-Received: by 2002:a1f:c605:: with SMTP id w5mr29160048vkf.28.1638626963432;
 Sat, 04 Dec 2021 06:09:23 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?Q?Musa_=C3=9Cnal?= <umusasadik@gmail.com>
Date:   Sat, 4 Dec 2021 17:09:12 +0300
Message-ID: <CAMjwK+d_H2qYjMjdQo=0ouz87u1XS1Cv+daLRj9_jLe6_FOkQw@mail.gmail.com>
Subject: Trap and Emulate RDTSC Instructions
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello all,
For an academic project we need to trap and emulate each RDTSC
instruction executed in a virtual machine. (Our main aim is to
calculate how many rdtsc instructions are executed in a virtual
machine.) Currently we can intercept each of them. But we have a
problem to give the correct tsc values (values are not stable). So we
don't want to mess up the rdtsc reads. We just need to count rdtscs.
Our current approach looks like this.

static int handle_rdtsc(struct kvm_vcpu *vcpu)
{
counter += 1;
vcpu->arch.regs[VCPU_REGS_RAX] = (rdtsc() - VM_EXIT_COS) & -1u;
vcpu->arch.regs[VCPU_REGS_RDX] = ((rdtsc() -  VM_EXIT_COST) >> 32) & -1u;
return skip_emulated_instruction(vcpu);

}

VM_EXIT_COST calculated by how many clock cycles are executed during
host to guest transition (for RDTSC exits only). Can KVM handle these
operations built-in or do you have any idea how we can achieve this?

Thanks a lot.
