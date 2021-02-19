Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C838A31FE0C
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhBSRkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:40:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229658AbhBSRkW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:40:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lykBUd6DAhrahT8nCJAC5FU9Ql8oesKH07nupx8xYdk=;
        b=LIXgwv60bbXZZIwcDQ5k5imvtugFoGSyk/vJ1Bny4rs/hfhyo1pGIW2lrWwXa1STjYL7aA
        7voQzyf/1T5wLwpLKktFTHSITkJzk6eLWwZ6sVMTYRPCeLnD5uHOnqlq9pDs3F4Kpn/Idg
        PzUyjlL8BkIi3Qry/IlDxDaeCRhXiZQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-sUJmk8MLO3ShdUet-3m-4A-1; Fri, 19 Feb 2021 12:38:52 -0500
X-MC-Unique: sUJmk8MLO3ShdUet-3m-4A-1
Received: by mail-wr1-f70.google.com with SMTP id f5so2782322wro.7
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:38:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lykBUd6DAhrahT8nCJAC5FU9Ql8oesKH07nupx8xYdk=;
        b=SKWgju7pWDq7PyHm15YbZoNM9V1B2seiwc37sLjd/A9yAur1sPjvyB9xgLKfA0ew8y
         hpku5uJAW4dwZvexqkO3qP/MVNY5ZgHkhFRKMTj2mQy3HSwgcfJAAgk1XgNh1mzwZvA+
         zS8JnW03cRSpeO1C2mz/qz8chxnuqqNKCxyQ53BgTZKyEGA/3VtUhka/ePkCTMWgJygz
         WVW/DTFYlVMDI834/+M+UvBjiIIknQj6PgaUrNAi4TxlAT7YhBxL5arbnYb+aHNpRbVx
         TBG7EaPJinODCiYTt1TyxJVz7HpcT4nKqpkN/V3szIc+9kWqQfN9IBrAYl6vXxv7eLNv
         Cd7Q==
X-Gm-Message-State: AOAM530mmL2QZHqNp0677mmScIP5jiqyCGsR6vU2HNf9oqr10f0mIPqa
        v3+XolozllfMgR/4YZZ9NyJVgfkoZd5uIzfABATWHeNlDboUdso1IZz+SCcZT5Q0AGBiieVcump
        X33k6oRrSxB4q
X-Received: by 2002:adf:e4c3:: with SMTP id v3mr10542040wrm.210.1613756331025;
        Fri, 19 Feb 2021 09:38:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwI/byrZ/GWSkkhxlUrl1Omb6LyZ4OFFS/CSa2qXI7tP50C7ZajzgipQ5EfU9sygOtDbt6r2g==
X-Received: by 2002:adf:e4c3:: with SMTP id v3mr10542005wrm.210.1613756330876;
        Fri, 19 Feb 2021 09:38:50 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id l2sm13785629wrm.6.2021.02.19.09.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:38:50 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 00/11] hw/accel: Exit gracefully when accelerator is
 invalid
Date:   Fri, 19 Feb 2021 18:38:36 +0100
Message-Id: <20210219173847.2054123-1-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,=0D
=0D
This series aims to improve user experience by providing=0D
a better error message when the user tries to enable KVM=0D
on machines not supporting it.=0D
=0D
Since v1:=0D
- added missing x86 arch (Peter)=0D
- consider all accelerators (Daniel and Peter)=0D
- do not enable KVM on sbsa-ref (Leif)=0D
- updated 'query-machines' (Daniel)=0D
- new patch for XenPV=0D
=0D
Supersedes: <20210219114428.1936109-1-philmd@redhat.com>=0D
=0D
Philippe Mathieu-Daud=C3=A9 (11):=0D
  accel/kvm: Check MachineClass kvm_type() return value=0D
  hw/boards: Introduce machine_class_valid_for_accelerator()=0D
  hw/core: Restrict 'query-machines' to those supported by current accel=0D
  hw/arm: Restrit KVM to the virt & versal machines=0D
  hw/mips: Restrict KVM to the malta & virt machines=0D
  hw/ppc: Restrict KVM to various PPC machines=0D
  hw/s390x: Explicit the s390-ccw-virtio machines support TCG and KVM=0D
  hw/i386: Explicit x86 machines support all current accelerators=0D
  hw/xenpv: Restrict Xen Para-virtualized machine to Xen accelerator=0D
  hw/board: Only allow TCG accelerator by default=0D
  softmmu/vl: Exit gracefully when accelerator is not supported=0D
=0D
 include/hw/boards.h        | 27 ++++++++++++++++++++++++++-=0D
 accel/kvm/kvm-all.c        |  6 ++++++=0D
 hw/arm/virt.c              |  5 +++++=0D
 hw/arm/xlnx-versal-virt.c  |  5 +++++=0D
 hw/core/machine-qmp-cmds.c |  4 ++++=0D
 hw/core/machine.c          | 26 ++++++++++++++++++++++++++=0D
 hw/i386/x86.c              |  5 +++++=0D
 hw/mips/loongson3_virt.c   |  5 +++++=0D
 hw/mips/malta.c            |  5 +++++=0D
 hw/ppc/e500plat.c          |  5 +++++=0D
 hw/ppc/mac_newworld.c      |  6 ++++++=0D
 hw/ppc/mac_oldworld.c      |  5 +++++=0D
 hw/ppc/mpc8544ds.c         |  5 +++++=0D
 hw/ppc/ppc440_bamboo.c     |  5 +++++=0D
 hw/ppc/prep.c              |  5 +++++=0D
 hw/ppc/sam460ex.c          |  5 +++++=0D
 hw/ppc/spapr.c             |  5 +++++=0D
 hw/s390x/s390-virtio-ccw.c |  5 +++++=0D
 hw/xenpv/xen_machine_pv.c  |  5 +++++=0D
 softmmu/vl.c               |  7 +++++++=0D
 20 files changed, 145 insertions(+), 1 deletion(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

