Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46FA32C73E
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347752AbhCDAbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:31:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232135AbhCCSfh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:35:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pU0d9Mw8PQdbgfBbP+KMCl6F0o1+MOAeJgm+3OD11Xs=;
        b=en+gxHXG70jcvFk9XV66lfetdfF37iCQuZn8FW3HVaT4SbjwUFLaZ0w5GTpYyBIdqzBwEb
        tSTpDR45oD8Q9Sqtskc8ll9aB5RWe/iP6LaZWkWl5AdfdQDxO1IFFCkjUq0Slpfdi24ETR
        w/cpnlng2UgDB+9onld0oRjVGTURmPg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-uVOQyKdLOTuX4qdHKxbGBw-1; Wed, 03 Mar 2021 13:22:23 -0500
X-MC-Unique: uVOQyKdLOTuX4qdHKxbGBw-1
Received: by mail-wr1-f72.google.com with SMTP id s10so2219125wre.0
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:22:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pU0d9Mw8PQdbgfBbP+KMCl6F0o1+MOAeJgm+3OD11Xs=;
        b=NzIyxVkyIHrboVnFfu8P1LUW+i+I52cNRjrz0bmbZ4mSgwntiIQILqixKaR5QJMIFA
         fJ7f83If7tze+012d8nUuhD4hxpr1Wdm5VvA0gMfkeZEno/mZ0CkmnTOb6tbzUHXWkd0
         qMwIvGUlC2UNGF6aQWD7bGVcDQqeCtcPci3eGbxHm/W/dhh7cuu4tMsf+7c5oSuoc+W7
         dThlB67UP102oxNaIEfbzk+WTZ/iyfuMa9QnmkhJo8+GgSBgWDLKE8NVM2gcdXpQiQdN
         pqARaDLpw8s61VfYlE5oUH6MA1G/kfs5mbDDrH46BZO9OD4zAwJ0ErtuWvCXR+u5LJZ0
         MzvA==
X-Gm-Message-State: AOAM531QMIT4sBdbkyT2esiJ84Une9CAp4JKxFYa4ixoiniqIE6R9wdL
        0jqU1TjiV/Jhyu6FIn4iwxaXQNZBH9G7PLNp5vsC2k+2maAut23BsnbEdD2Ul2HgkZr5IZkgjel
        izmw5kKToi84F
X-Received: by 2002:a5d:430a:: with SMTP id h10mr19960wrq.162.1614795742422;
        Wed, 03 Mar 2021 10:22:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUTywIC+KwxYJXuUyDhzg8Nuj7gHjGLk6CPjSdHmohYvyP+QZLu8kIXtLnUufcrNeJRgTWfQ==
X-Received: by 2002:a5d:430a:: with SMTP id h10mr19929wrq.162.1614795742181;
        Wed, 03 Mar 2021 10:22:22 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id i3sm35148487wra.66.2021.03.03.10.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:22:21 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [RFC PATCH 00/19] accel: Introduce AccelvCPUState opaque structure
Date:   Wed,  3 Mar 2021 19:22:00 +0100
Message-Id: <20210303182219.1631042-1-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,=0D
=0D
This series introduces the 'AccelvCPUState' which is forward=0D
declared opaque in "cpu.h", then each accelerator define it.=0D
=0D
The opaque CPUState::accel_vcpu pointer is shared by all=0D
accelerators (not a problem because there can be at most=0D
one accelerator per vCPU).=0D
=0D
Series is organized as:=0D
- preliminary trivial cleanups=0D
- introduce AccelvCPUState=0D
- move WHPX fields (build-tested)=0D
- move HAX fields (not tested)=0D
- move KVM fields (build-tested)=0D
- move HVF fields (not tested)=0D
=0D
For now vcpu_dirty is still shared in CPUState.=0D
=0D
Sending as RFC to see if it is worthwhile.=0D
=0D
Regards,=0D
=0D
Phil.=0D
=0D
Philippe Mathieu-Daud=C3=A9 (19):=0D
  target/i386/hvf: Use boolean value for vcpu_dirty=0D
  target/s390x/kvm: Simplify debug code=0D
  target/s390x/kvm: Reduce deref by declaring 'struct kvm_run' on stack=0D
  cpu: Croup accelerator-specific fields altogether=0D
  cpu: Introduce AccelvCPUState opaque structure=0D
  accel/whpx: Add typedef for 'struct whpx_vcpu'=0D
  accel/whpx: Rename struct whpx_vcpu -> AccelvCPUState=0D
  accel/whpx: Use 'accel_vcpu' generic pointer=0D
  accel/hax: Add typedef for 'struct hax_vcpu_state'=0D
  accel/hax: Use 'accel_vcpu' generic pointer=0D
  accel/kvm: Introduce kvm_vcpu_state() helper=0D
  accel/kvm: Use kvm_vcpu_state() when possible=0D
  accel/kvm: Declare and allocate AccelvCPUState struct=0D
  accel/kvm: Move the 'kvm_fd' field to AccelvCPUState=0D
  accel/kvm: Move the 'kvm_state' field to AccelvCPUState=0D
  accel/kvm: Move the 'kvm_run' field to AccelvCPUState=0D
  accel/hvf: Reduce deref by declaring 'hv_vcpuid_t hvf_fd' on stack=0D
  accel/hvf: Declare and allocate AccelvCPUState struct=0D
  accel/hvf: Move the 'hvf_fd' field to AccelvCPUState=0D
=0D
 include/hw/core/cpu.h         |  17 +--=0D
 include/sysemu/kvm.h          |   2 +=0D
 include/sysemu/kvm_int.h      |   9 ++=0D
 target/i386/hax/hax-i386.h    |  10 +-=0D
 target/i386/hvf/hvf-i386.h    |   4 +=0D
 target/i386/hvf/vmx.h         |  28 +++--=0D
 accel/kvm/kvm-all.c           |  44 ++++---=0D
 hw/s390x/pv.c                 |   3 +-=0D
 target/arm/kvm.c              |   2 +-=0D
 target/arm/kvm64.c            |  12 +-=0D
 target/i386/cpu.c             |   4 +-=0D
 target/i386/hax/hax-all.c     |  22 ++--=0D
 target/i386/hax/hax-posix.c   |   4 +-=0D
 target/i386/hax/hax-windows.c |   4 +-=0D
 target/i386/hvf/hvf.c         | 118 +++++++++---------=0D
 target/i386/hvf/x86.c         |  28 ++---=0D
 target/i386/hvf/x86_descr.c   |  32 +++--=0D
 target/i386/hvf/x86_emu.c     |  62 +++++-----=0D
 target/i386/hvf/x86_mmu.c     |   4 +-=0D
 target/i386/hvf/x86_task.c    |  14 ++-=0D
 target/i386/hvf/x86hvf.c      | 227 +++++++++++++++++-----------------=0D
 target/i386/kvm/kvm.c         |  36 +++---=0D
 target/i386/whpx/whpx-all.c   |  34 ++---=0D
 target/ppc/kvm.c              |  16 +--=0D
 target/s390x/kvm.c            | 148 +++++++++++-----------=0D
 25 files changed, 466 insertions(+), 418 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

