Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4080B425795
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242652AbhJGQTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:19:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241736AbhJGQTR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=p6fHLDVl0Cbua1Rf17vUj4XEPtHLVrJLYw1HhEkRr54=;
        b=Ox+tsblBpS5icZDt5IcxPvVGiVFxd8hvTqvbS3uaN+gV9qEv4fU51pvKH9Bh6+VuplCAUz
        ufav65Yx+Q1D9j+zVjmlj4O5F6gLJZN7iLcXWjCKlVqNWtHFM/JWIPS2zhWD275CMBoN9w
        ozoeUBFQ2BduKxPz6ftMbLQMVaBVYwg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-kGJ3MscRNIGp4JVSfiBC9g-1; Thu, 07 Oct 2021 12:17:22 -0400
X-MC-Unique: kGJ3MscRNIGp4JVSfiBC9g-1
Received: by mail-wr1-f70.google.com with SMTP id h11-20020adfa4cb000000b00160c791a550so4941522wrb.6
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:17:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p6fHLDVl0Cbua1Rf17vUj4XEPtHLVrJLYw1HhEkRr54=;
        b=uEhLV9IOXWcC66KGiiYbpfrB/v3Nh/UZSSbTNpWVb7xHWvAPVpSwNThPI9f7CiqQEq
         Xo1UjrbHcMxmyjFlzK6Iz7/ONztzTRep+kYK0pfQNlarmpQUiVrb5MsiWoYFbXZsgDk5
         0FtqcvTfHHmDBGGVtcNsCKZt0NU18EJLse4g83+1hL985vrFfAJomB6+uY0IwmjCANCY
         UqBjpJg/WWnpso3PwITm4PCcMg5U2gLKOufwOT0eImSaR2j2eTkL/E2+ZERA2ybkr5pL
         ipQAicwgQpMOLOM5DwrZ/YSeEQLfRoh6uLrDY1CTY/w0mnC12TQ7l0PgMbQRwAI0GVVf
         P+kQ==
X-Gm-Message-State: AOAM533BHTd2wVJnf5qOK+1PHc9SUjzM/vWaQUmQnGUEGEUBt9p/SsUC
        L7KAz14wyGgStwSI4sNX+qYO+7VjsCKbv1/bnAC7HP9sXL9DBh2jgD4g9yxlD0VgAl9vT5W0ed4
        LSlDwgDUxUmCl
X-Received: by 2002:a5d:4481:: with SMTP id j1mr6733753wrq.6.1633623438538;
        Thu, 07 Oct 2021 09:17:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2EmrFsCPnCn7w8xn3CHIU49Oj94zA0/VNeS7NO/gGdXhjH6plu98/nw1ribtc2xuIOoff5g==
X-Received: by 2002:a5d:4481:: with SMTP id j1mr6733725wrq.6.1633623438347;
        Thu, 07 Oct 2021 09:17:18 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id 189sm10243854wmz.27.2021.10.07.09.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:17:17 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 00/23] target/i386/sev: Housekeeping SEV + measured Linux SEV guest
Date:   Thu,  7 Oct 2021 18:16:53 +0200
Message-Id: <20211007161716.453984-1-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Missing review:=0D
  0005-target-i386-sev-Prefix-QMP-errors-with-SEV.patch=0D
  0012-target-i386-sev-Use-g_autofree-in-sev_launch_get_mea.patch=0D
  0014-target-i386-sev-Rename-sev_i386.h-sev.h.patch=0D
  0016-target-i386-sev-Remove-stubs-by-using-code-elision.patch=0D
  0023-MAINTAINERS-Cover-SEV-related-files-with-X86-KVM-sec.patch=0D
=0D
Hi,=0D
=0D
While testing James & Dov patch:=0D
https://www.mail-archive.com/qemu-devel@nongnu.org/msg810571.html=0D
I wasted some time trying to figure out how OVMF was supposed to=0D
behave until realizing the binary I was using was built without SEV=0D
support... Then wrote this series to help other developers to not=0D
hit the same problem.=0D
=0D
Since v3:=0D
- Rebased ('Measured Linux SEV guest' from Dov [1] merged)=0D
- Addressed Paolo & David review comments=0D
=0D
Since v2:=0D
- Rebased on top of SGX=0D
- Addressed review comments from Markus / David=0D
- Included/rebased 'Measured Linux SEV guest' from Dov [1]=0D
- Added orphean MAINTAINERS section=0D
=0D
[1] https://lore.kernel.org/qemu-devel/20210825073538.959525-1-dovmurik@lin=
ux.ibm.com/=0D
=0D
Supersedes: <20210616204328.2611406-1-philmd@redhat.com>=0D
=0D
Dr. David Alan Gilbert (1):=0D
  target/i386/sev: sev_get_attestation_report use g_autofree=0D
=0D
Philippe Mathieu-Daud=C3=A9 (22):=0D
  qapi/misc-target: Wrap long 'SEV Attestation Report' long lines=0D
  qapi/misc-target: Group SEV QAPI definitions=0D
  target/i386/kvm: Introduce i386_softmmu_kvm Meson source set=0D
  target/i386/kvm: Restrict SEV stubs to x86 architecture=0D
  target/i386/sev: Prefix QMP errors with 'SEV'=0D
  target/i386/monitor: Return QMP error when SEV is not enabled for=0D
    guest=0D
  target/i386/cpu: Add missing 'qapi/error.h' header=0D
  target/i386/sev_i386.h: Remove unused headers=0D
  target/i386/sev: Remove sev_get_me_mask()=0D
  target/i386/sev: Mark unreachable code with g_assert_not_reached()=0D
  target/i386/sev: Use g_autofree in sev_launch_get_measure()=0D
  target/i386/sev: Restrict SEV to system emulation=0D
  target/i386/sev: Rename sev_i386.h -> sev.h=0D
  target/i386/sev: Declare system-specific functions in 'sev.h'=0D
  target/i386/sev: Remove stubs by using code elision=0D
  target/i386/sev: Move qmp_query_sev_attestation_report() to sev.c=0D
  target/i386/sev: Move qmp_sev_inject_launch_secret() to sev.c=0D
  target/i386/sev: Move qmp_query_sev_capabilities() to sev.c=0D
  target/i386/sev: Move qmp_query_sev_launch_measure() to sev.c=0D
  target/i386/sev: Move qmp_query_sev() & hmp_info_sev() to sev.c=0D
  monitor: Reduce hmp_info_sev() declaration=0D
  MAINTAINERS: Cover SEV-related files with X86/KVM section=0D
=0D
 qapi/misc-target.json                 |  77 ++++++------=0D
 include/monitor/hmp-target.h          |   1 +=0D
 include/monitor/hmp.h                 |   1 -=0D
 include/sysemu/sev.h                  |  28 -----=0D
 target/i386/{sev_i386.h =3D> sev.h}     |  35 ++++--=0D
 hw/i386/pc_sysfw.c                    |   2 +-=0D
 hw/i386/x86.c                         |   2 +-=0D
 target/i386/cpu.c                     |  16 +--=0D
 target/i386/kvm/kvm.c                 |   3 +-=0D
 {accel =3D> target/i386}/kvm/sev-stub.c |   2 +-=0D
 target/i386/monitor.c                 |  92 +--------------=0D
 target/i386/sev-stub.c                |  88 --------------=0D
 target/i386/sev-sysemu-stub.c         |  70 +++++++++++=0D
 target/i386/sev.c                     | 164 +++++++++++++++++++-------=0D
 MAINTAINERS                           |   2 +=0D
 accel/kvm/meson.build                 |   1 -=0D
 target/i386/kvm/meson.build           |   8 +-=0D
 target/i386/meson.build               |   4 +-=0D
 18 files changed, 279 insertions(+), 317 deletions(-)=0D
 delete mode 100644 include/sysemu/sev.h=0D
 rename target/i386/{sev_i386.h =3D> sev.h} (62%)=0D
 rename {accel =3D> target/i386}/kvm/sev-stub.c (94%)=0D
 delete mode 100644 target/i386/sev-stub.c=0D
 create mode 100644 target/i386/sev-sysemu-stub.c=0D
=0D
-- =0D
2.31.1=0D
=0D

