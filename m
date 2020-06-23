Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429D6204F82
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732259AbgFWKvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:51:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25507 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732254AbgFWKvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:51:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592909460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q94CucqHN1D7KKGTyBIU8O5tt3pd+XQigNdMLEupMvs=;
        b=cRetiDK3/WA9O9IwNSfKC0Xe2NsNkYeaxAgqDPF2u0izGgMVqNNKxczv/3fa6q1/3ZX4Sx
        OA9yZ4Ci4xYx6lwmUcZki9AV5tQjim3UFEa+W6laYL89nv/vxHvPhrvAopDEg6PJ7bIjQL
        wjrcwF3q0F7sv4Lek6l5yfgp3x6CDW4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-761Z8lZHOdKBOFTVQBq1kg-1; Tue, 23 Jun 2020 06:50:57 -0400
X-MC-Unique: 761Z8lZHOdKBOFTVQBq1kg-1
Received: by mail-wr1-f70.google.com with SMTP id f5so14795876wrv.22
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 03:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q94CucqHN1D7KKGTyBIU8O5tt3pd+XQigNdMLEupMvs=;
        b=HOinm9Qbl0QHBc8QmJFZGeYnCxQva2PDukwnxitiSj/sCGW+kaZgsptSlLn8GgLoaS
         B0K/2W8ANtwVDQAeH+Hpz6Ykvx4/ZXsR4tPBeueAKr3cHTXXIp0KTBJ4L/o/E12MDpIW
         nLP6b1skNMiflP5ndeRAPxdm6b18/7qsYGVOfIQYTqNgCQDlCXPA2h6gLIVK/Usc3MIW
         E9Dv4zRVPXFqGWyiT+TeTqay+zgPFXb5Pdj+q8zyxm1Ju7wnGY51phNi3yJD+YRQaZCE
         f1ZYIxaxsJsR87I2ACHqnUXW0wcHthhhgQAj/rvFZXIBJJYt75Fz/Q2+Y1BTfx4Md5MP
         Z8yQ==
X-Gm-Message-State: AOAM533LHZIdoHGF4Y99ln+4fJgYS+NmGokguJxYAwAdTDzlewWxzRm6
        IGfATTudUKHj85g0dvvdEgxvWb5luVNLUQlkG8lDmwvMFzUS8XjWgLQIgpYbZMoTZ08olJKVLXw
        1mfhezs8ps1iR
X-Received: by 2002:adf:f70e:: with SMTP id r14mr25942423wrp.150.1592909456037;
        Tue, 23 Jun 2020 03:50:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlFax+p3i5iqFekMZp1RI7Mb/GelsfigfVK2k+fsxbIpqx4pyzX+QN9QZ0xJFmneZKKMePoA==
X-Received: by 2002:adf:f70e:: with SMTP id r14mr25942396wrp.150.1592909455858;
        Tue, 23 Jun 2020 03:50:55 -0700 (PDT)
Received: from localhost.localdomain (1.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.1])
        by smtp.gmail.com with ESMTPSA id r7sm3069566wmh.46.2020.06.23.03.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 03:50:55 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 0/7] accel/kvm: Simplify few functions that can use global kvm_state
Date:   Tue, 23 Jun 2020 12:50:45 +0200
Message-Id: <20200623105052.1700-1-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following Paolo's idea on kvm_check_extension():
https://www.mail-archive.com/qemu-devel@nongnu.org/msg713794.html

CI:
https://travis-ci.org/github/philmd/qemu/builds/701213438

Philippe Mathieu-Daudé (7):
  accel/kvm: Let kvm_check_extension use global KVM state
  accel/kvm: Simplify kvm_check_extension()
  accel/kvm: Simplify kvm_check_extension_list()
  accel/kvm: Simplify kvm_set_sigmask_len()
  target/i386/kvm: Simplify get_para_features()
  target/i386/kvm: Simplify kvm_get_mce_cap_supported()
  target/i386/kvm: Simplify kvm_get_supported_[feature]_msrs()

 include/sysemu/kvm.h         |  4 +-
 accel/kvm/kvm-all.c          | 76 +++++++++++++++----------------
 hw/hyperv/hyperv.c           |  2 +-
 hw/i386/kvm/clock.c          |  2 +-
 hw/i386/kvm/i8254.c          |  4 +-
 hw/i386/kvm/ioapic.c         |  2 +-
 hw/intc/arm_gic_kvm.c        |  2 +-
 hw/intc/openpic_kvm.c        |  2 +-
 hw/intc/xics_kvm.c           |  2 +-
 hw/s390x/s390-stattrib-kvm.c |  2 +-
 target/arm/kvm.c             | 13 +++---
 target/arm/kvm32.c           |  2 +-
 target/arm/kvm64.c           | 15 +++---
 target/i386/kvm.c            | 88 +++++++++++++++++-------------------
 target/mips/kvm.c            |  6 +--
 target/ppc/kvm.c             | 34 +++++++-------
 target/s390x/cpu_models.c    |  3 +-
 target/s390x/kvm.c           | 30 ++++++------
 18 files changed, 141 insertions(+), 148 deletions(-)

-- 
2.21.3

