Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054D32D06AA
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 19:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgLFS4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 13:56:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgLFS4n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 13:56:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607280916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5L9zYVEk7UDV9e8J6jUWmDLNneFBSRjTDjE9eeZGMJ4=;
        b=AlmlVAjbudmTkFWzmCLl/1/kkJ9ebmqJdDSKT5+hc63KjH+NgghvApaRkA78PP9TfId15E
        RxOl30jqb9pFeDoJqLIyhtiVKLUWlGoDQQ5PxJxRUy52TdcYB+tHYL3Bo2n3k1O80lzkOC
        PVmWlvI8vdZF7adadAz8bFiXVou1rwQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-IMhiZGzCPiGkIpXD7dKlCw-1; Sun, 06 Dec 2020 13:55:13 -0500
X-MC-Unique: IMhiZGzCPiGkIpXD7dKlCw-1
Received: by mail-wm1-f71.google.com with SMTP id v5so4349064wmj.0
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 10:55:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5L9zYVEk7UDV9e8J6jUWmDLNneFBSRjTDjE9eeZGMJ4=;
        b=B/J2t7CPigC7tfeO2P3YQ688x0I01SFVXeFiIhLnQSxk/gTyvnVTyEQSkvDV6vuyRd
         6YNvgFt9S/9KdOzTLCFmWFgsGumM19N1NSRlfQUllOmY0flSdbMp09I79hP3rU3oD6sS
         YZL+w3T0/K8tZa4Djvlp/UEa8qOkIP0kEH1yBSmKkXoN3nB7pz7doTMIKNEDxrB5MkPZ
         QtaT4zQ9YdrDHNYX9+hbipSXPTb/5XaloP5UVEc4BUtWXLr6JAQs6RpqtpqyKsFgj8yE
         4ve4umPqoHphE6Ie5JaJWu/r33uG+8vcI/L+pmCvr7IlyubYNzgxfwpjXRiLHjTzsqW9
         zjHg==
X-Gm-Message-State: AOAM532jLDWc9gQLN13VmItDputHN6Uyf/CLqZqlIkDKoCMdOm2WJD6/
        SaylyMHBr+iATtNuNn0kDJOVLZMK80xMdSLJgJxwdYtjJ1jmVga6QndmnUUHlD47kIvxiXz2904
        ALxry/tX31p4d
X-Received: by 2002:a1c:6056:: with SMTP id u83mr14528860wmb.90.1607280911972;
        Sun, 06 Dec 2020 10:55:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyCSZGi5rbiGoVRoGKRNGTcTbBvyODVVSoiL6GLaxlOiqbwRFYQlZdlM1E+jjVm6ac4G5YFvw==
X-Received: by 2002:a1c:6056:: with SMTP id u83mr14528834wmb.90.1607280911735;
        Sun, 06 Dec 2020 10:55:11 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id a62sm4051738wmh.40.2020.12.06.10.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 10:55:10 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Claudio Fontana <cfontana@suse.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org
Subject: [PATCH 0/8] gitlab-ci: Add accelerator-specific Linux jobs
Date:   Sun,  6 Dec 2020 19:55:00 +0100
Message-Id: <20201206185508.3545711-1-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
Each job is added in its own YAML file, so it is easier to notify=0D
subsystem maintainers in case of troubles.=0D
=0D
Resulting pipeline:=0D
https://gitlab.com/philmd/qemu/-/pipelines/225948077=0D
=0D
Regards,=0D
=0D
Phil.=0D
=0D
[1] https://travis-ci.community/t/build-delays-for-open-source-project/1027=
2=0D
[2] https://blog.travis-ci.com/2020-11-02-travis-ci-new-billing=0D
=0D
Philippe Mathieu-Daud=C3=A9 (8):=0D
  gitlab-ci: Replace YAML anchors by extends (cross_system_build_job)=0D
  gitlab-ci: Introduce 'cross_accel_build_job' template=0D
  gitlab-ci: Add KVM X86 cross-build jobs=0D
  gitlab-ci: Add KVM ARM cross-build jobs=0D
  gitlab-ci: Add KVM s390x cross-build jobs=0D
  gitlab-ci: Add KVM PPC cross-build jobs=0D
  gitlab-ci: Add KVM MIPS cross-build jobs=0D
  gitlab-ci: Add Xen cross-build jobs=0D
=0D
 .gitlab-ci.d/crossbuilds-kvm-arm.yml   |  5 +++=0D
 .gitlab-ci.d/crossbuilds-kvm-mips.yml  |  5 +++=0D
 .gitlab-ci.d/crossbuilds-kvm-ppc.yml   |  5 +++=0D
 .gitlab-ci.d/crossbuilds-kvm-s390x.yml |  6 +++=0D
 .gitlab-ci.d/crossbuilds-kvm-x86.yml   |  6 +++=0D
 .gitlab-ci.d/crossbuilds-xen.yml       | 14 +++++++=0D
 .gitlab-ci.d/crossbuilds.yml           | 52 ++++++++++++++++----------=0D
 .gitlab-ci.yml                         |  6 +++=0D
 MAINTAINERS                            |  6 +++=0D
 9 files changed, 85 insertions(+), 20 deletions(-)=0D
 create mode 100644 .gitlab-ci.d/crossbuilds-kvm-arm.yml=0D
 create mode 100644 .gitlab-ci.d/crossbuilds-kvm-mips.yml=0D
 create mode 100644 .gitlab-ci.d/crossbuilds-kvm-ppc.yml=0D
 create mode 100644 .gitlab-ci.d/crossbuilds-kvm-s390x.yml=0D
 create mode 100644 .gitlab-ci.d/crossbuilds-kvm-x86.yml=0D
 create mode 100644 .gitlab-ci.d/crossbuilds-xen.yml=0D
=0D
-- =0D
2.26.2=0D
=0D

