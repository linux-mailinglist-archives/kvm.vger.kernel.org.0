Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0012D11A4
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 14:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgLGNQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 08:16:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29634 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725550AbgLGNQk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 08:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607346913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=D+Xzt47T3O6uanVPO2OPfmJ/SH9QMRtVuJ5cnLL0G9o=;
        b=XJcNucjFg6/wMUKU4ReBm+QmxzGaJ87q471BSw4qT+Ucm9kQCssrV+M8DVZFQGlQLCWI/a
        1BKP/D5z4rvzhBJGwvBdpyhYYD7OXPDRbViSqXmZHiTsLBAlqVvuLvxXgubqPleA3uD2zM
        Sl/I2skzvH+gf/z1XEebN7PZOuPo1jI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-pvtvFBvYOyOImE_AFkFRww-1; Mon, 07 Dec 2020 08:15:09 -0500
X-MC-Unique: pvtvFBvYOyOImE_AFkFRww-1
Received: by mail-wm1-f70.google.com with SMTP id k128so5297569wme.7
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 05:15:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D+Xzt47T3O6uanVPO2OPfmJ/SH9QMRtVuJ5cnLL0G9o=;
        b=VoRXN9ICh8P2SGKQPH9yQP58e8lRmFuEPt9dQlM9y6Q64HBti3PvOyFvzrej27iDOS
         F4f3hcvALixTn6L4uuR1Op+/u8Ir2lI0zYyuWDJE7Ts9dC3lui+GLQi0k1hXu5xwQniN
         EbyuOenHUyusA2xM7ta6HwaY2QXJuh0xnGyl6zs7M7yrRaMExzS8rlHfZad/NliTE47e
         DlX9PNmOe5UDEcRoBdgR+mfJaI+kBgAEfmuW6wyY6aw9rqkhPIfsOhJe67n/e92c9fyt
         VxHxeskWegdgWajpCkHN+H3EISff+j3Fl2OYKRfMFYcasz/DAXAnm4BGSuMH+pLyK8at
         7MoQ==
X-Gm-Message-State: AOAM531BEX+tn7a68FSeRLkBNmJcpcEIGkFgxPEGKP3WzDN9NcMZVLuf
        YOtLlW7zjpmnyRy6EZlHppnLLeSthWozwra+giuTAaPd4trcR4RrN5Z8Pv3SqAvTczvJh+ygQtl
        EknudA+XDr7ec
X-Received: by 2002:a5d:4d88:: with SMTP id b8mr19446877wru.134.1607346907512;
        Mon, 07 Dec 2020 05:15:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzpnUya1Cq26y+zerYd2xTIJ5RvuSXM0q1BxVsK+34xdINKnlF/ke5kWAF9RdCASl4P3rK0fg==
X-Received: by 2002:a5d:4d88:: with SMTP id b8mr19446856wru.134.1607346907342;
        Mon, 07 Dec 2020 05:15:07 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id 94sm6169289wrq.22.2020.12.07.05.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 05:15:06 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        qemu-s390x@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Cornelia Huck <cohuck@redhat.com>,
        xen-devel@lists.xenproject.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH v3 0/5] gitlab-ci: Add accelerator-specific Linux jobs
Date:   Mon,  7 Dec 2020 14:14:58 +0100
Message-Id: <20201207131503.3858889-1-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since v2:=0D
- Fixed ARM Xen job=0D
- Renamed jobs with -$accel trailer (Thomas)=0D
=0D
Since v1:=0D
- Documented cross_accel_build_job template (Claudio)=0D
- Only add new job for s390x (Thomas)=0D
- Do not add entry to MAINTAINERS (Daniel)=0D
- Document 'build-tcg-disabled' job is X86 + KVM=0D
- Drop the patches with negative review feedbacks=0D
=0D
Hi,=0D
=0D
I was custom to use Travis-CI for testing KVM builds on s390x/ppc=0D
with the Travis-CI jobs.=0D
=0D
During October Travis-CI became unusable for me (extremely slow,=0D
see [1]). Then my free Travis account got updated to the new=0D
"10K credit minutes allotment" [2] which I burned without reading=0D
the notification email in time (I'd burn them eventually anyway).=0D
=0D
Today Travis-CI is pointless to me. While I could pay to run my=0D
QEMU jobs, I don't think it is fair for an Open Source project to=0D
ask its forks to pay for a service.=0D
=0D
As we want forks to run some CI before contributing patches, and=0D
we have cross-build Docker images available for Linux hosts, I=0D
added some cross KVM/Xen build jobs to Gitlab-CI.=0D
=0D
Cross-building doesn't have the same coverage as native building,=0D
as we can not run the tests. But this is still useful to get link=0D
failures.=0D
=0D
Resulting pipeline:=0D
https://gitlab.com/philmd/qemu/-/pipelines/226240415=0D
=0D
Regards,=0D
=0D
Phil.=0D
=0D
[1] https://travis-ci.community/t/build-delays-for-open-source-project/1027=
2=0D
[2] https://blog.travis-ci.com/2020-11-02-travis-ci-new-billing=0D
=0D
Philippe Mathieu-Daud=C3=A9 (5):=0D
  gitlab-ci: Document 'build-tcg-disabled' is a KVM X86 job=0D
  gitlab-ci: Replace YAML anchors by extends (cross_system_build_job)=0D
  gitlab-ci: Introduce 'cross_accel_build_job' template=0D
  gitlab-ci: Add KVM s390x cross-build jobs=0D
  gitlab-ci: Add Xen cross-build jobs=0D
=0D
 .gitlab-ci.d/crossbuilds.yml | 78 ++++++++++++++++++++++++++----------=0D
 .gitlab-ci.yml               |  5 +++=0D
 2 files changed, 62 insertions(+), 21 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

