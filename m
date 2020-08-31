Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15657257E16
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 17:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgHaP7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 11:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbgHaP7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 11:59:16 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437F3C061573
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 08:59:16 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i22so3326434eja.5
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 08:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=357mXB3JYBVjgoA+GRZINKp692bd2nd7RWi+dE3ZXVg=;
        b=GKhVSXDfbECNGdKlh0y7I79pjWvh9JDFs2stP8hXHhuzVXwyyInufpIQ+Kzfw/5TZQ
         1hy39eSFmiL3H4ObIjwbBu5tf4nFFAawrb6vYtMXrBD50Q/mL8tqyzbGliv5f75xwVO2
         KL59m7AkopHNysBWc44BoGtELIU1ACYiSXqxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=357mXB3JYBVjgoA+GRZINKp692bd2nd7RWi+dE3ZXVg=;
        b=FiQ5FKAs94xtK2fSGPyvgHW6kcvSUYDCP6E3hWZ/NZY5rOAX0nCeuILWzfz9lN2t8k
         jkKRDlarzZFbkPEfyP5DvDCiqL8UeUgmPCGdPZmZCP7nR5613s83c7AoMN5tqFKHLTNi
         EolIv+V7NGHuBj/JT8z0Ewguh74RDNzctn3l3lkM7eJwUbV+O3Yn9c+MndtmEyR+ZQPg
         P24BGLxEaG56zLyQ1uWemsMDo+IlamtbEEBBvxheQlJ+ye5BSBJgQppH1gE75/Ikix5G
         EHdwSbNlHbpkWIVTZhJ/o04/IIJeiM4KWVWcRqCaqhKfXAEhlsfp27PcHIX9+MfbdvZS
         OX7w==
X-Gm-Message-State: AOAM531qu/nkkEvqJm8LYehw4FHy1CAfA0cNt76oxjwrlTSQQFhIt6Pt
        Q0BhDindwDxmY2oKZAgVa3998tZ/ZyS+sl4LWQwiApvgtbmNWQ==
X-Google-Smtp-Source: ABdhPJyKQunXH+0vaVmTfhSaWpAaiynEDWPlfFMjvIGV6nXzYWSTaj7SZTpHjAz6tHDk4g12Jh1XxfXaPN8gbyqnnFg=
X-Received: by 2002:a17:906:2acf:: with SMTP id m15mr1746404eje.257.1598889554139;
 Mon, 31 Aug 2020 08:59:14 -0700 (PDT)
MIME-Version: 1.0
From:   Micah Morton <mortonm@chromium.org>
Date:   Mon, 31 Aug 2020 08:59:03 -0700
Message-ID: <CAJ-EccPKv+LUXfoqHg-T1XCUJE8aLzTsKwiQa1UojeYC4UPPVg@mail.gmail.com>
Subject: Not enough IRQ lines on the 82093AA IOAPIC
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I've recently noticed that the IOAPIC
(https://pdos.csail.mit.edu/6.828/2018/readings/ia32/ioapic.pdf) that
kvm/QEMU emulate for providing interrupts to a guest VM is quite
limited in terms of free/unused IRQs available for use (section 2.4 in
the ioapic.pdf above gives descriptions). Essentially there are enough
(4) shared PCI IRQ lines to go around for emulated/passthrough PCI
devices -- but most/all the other lines have dedicated uses and are
unavailable.


I see evidence of device emulation code running into this lack of
legacy IRQ slots on x86 kvm/QEMU, as here's an example of QEMU's
emulated TPM choosing to use polling instead of interrupts since there
are no available lines in the IOAPIC:
https://www.qemu.org/docs/master/specs/tpm.html#acpi-interface . It
seems there are other prospective projects that might run into this
issue as well (https://www.mail-archive.com/qemu-devel@nongnu.org/msg585732=
.html
might be a good example if the i2c devices in question use interrupts
-- there may be better examples). From what I can tell, any emulated
device someone wants to add to QEMU can=E2=80=99t use interrupts unless it =
is
an emulated PCI device. My particular interest is platform device
passthrough on x86 kvm/QEMU/VFIO, which requires legacy IRQ forwarding
via the emulated IOAPIC if the platform device uses interrupts.


I=E2=80=99m mostly sending this email to see if I am missing any background
context on this issue. Has this limitation of the 82093AA IOAPIC been
surfaced before in KVM discussions?


I recently sent a similar question on the vfio-users mailing list and
got a suggestion to use multiple IOAPICs for the guest
(https://www.redhat.com/archives/vfio-users/2020-August/msg00038.html).
Does this seem like the most reasonable approach? Would it be easy
enough to emulate multiple IOAPICs in kvm, assuming the guest OS can
handle multiple? Here are a few other possible options:


1) Update the 82093AA emulation to allow for more IRQs (while
maintaining backwards compatibility to avoid breaking guests). Of
course at this point you are no longer emulating a real piece of
hardware. Not sure if there=E2=80=99s any precedent for that.

2) Choose a new IOAPIC HW device to emulate in KVM (that has more IRQs
and is widely supported). From what I=E2=80=99ve seen x86 IOAPICs feature >=
100
IRQ lines these days.

3) Add a virtio/paravirtualized approach for the IOAPIC instead of
emulating real hardware for the guest.

Any advice on which of these options seems the most reasonable?


Thanks,
Micah
