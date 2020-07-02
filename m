Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B23A2122CE
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 13:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgGBL74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 07:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgGBL7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 07:59:55 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17A7C08C5C1
        for <kvm@vger.kernel.org>; Thu,  2 Jul 2020 04:59:55 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id w2so12562719pgg.10
        for <kvm@vger.kernel.org>; Thu, 02 Jul 2020 04:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:in-reply-to:subject:date:message-id:mime-version
         :content-transfer-encoding:thread-index:content-language;
        bh=golg96dEpXJfAgzCstEFxGpWdvx8DIRvbEfz0uUuoIU=;
        b=oGit0OQ+v3MOMKe1sjN5JJFJHX6WQY7mFvxNExN8CetcH7tNuqfvFXx8xrgytbCx1v
         xLtm/bi3ADJHG1G2a9jzXTuvyrimP9fbCY6hLWfpd8lVsSwK5tUj25Gxcx0vle0wxX2n
         RJrCk8ll3IIvoh/V7E27oex+NQaRzRZCLGWyx/x+CDtUu95K/xAHQ3kl2sORwb86tHIR
         s41EyHnWiFUbh9XhkrG5/c6t7dRCPmI0tNs/rCLw4s5Vke/9zj7WpBKRs48PzoVt2q+Y
         nH6805Vc86t3KTclSgHYW/i4eyi4zTm7+RRElBLtHGC+50lJCop5A6iPZ98+svsRa++V
         PEpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=golg96dEpXJfAgzCstEFxGpWdvx8DIRvbEfz0uUuoIU=;
        b=RZ7FGx0f9yCdUgfrsz//tMSDEPEE0SLhp5y8+QXuo1PtHdh+hsrdfWjEjirnzFm3SL
         qFvKj755UEIJ+H5z7krIZATHxH+0QPvWwJ3UfhNrP/6CMoZjTGFEsHhUHcs+/COczGdR
         AlOCAQHKwD4XIPBWxkKob+DDU8BmuqAqVLXFIlIUzgP066M9ITBHfyIikhTOeXcRqhbQ
         5GTNDSJdaWldz3EjaW58Aj6prTK//Qt075odaRBf3GBxU/XQ20J5GhJ6iHVQOICQJNgm
         ulonRXffBZP2g6RX+P1r27kOtkimZ/Kbnzb10AXEiNEkW1RyE/YwYeP+4yNOL1FTvqFd
         pDXQ==
X-Gm-Message-State: AOAM532j7InYR6r0ePNZePo84F0fSDp3Qqcdx9bmS4uHqH6NMnxBmOA4
        y7xHK6eGWlFbt6cLl1AEMBZr/XVM
X-Google-Smtp-Source: ABdhPJzeW+/LIxZSNpAChZc6gtpeX6JkIp1xVfJP/brUku5AfqF+RkZPUr1J3aB9WTJWG/QSTgzUsg==
X-Received: by 2002:aa7:84ce:: with SMTP id x14mr23430650pfn.220.1593691194969;
        Thu, 02 Jul 2020 04:59:54 -0700 (PDT)
Received: from MarksSpectreX360 ([216.228.117.191])
        by smtp.gmail.com with ESMTPSA id z5sm8449133pfn.117.2020.07.02.04.59.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jul 2020 04:59:54 -0700 (PDT)
From:   <mwoodpatrick@gmail.com>
To:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <MN2PR12MB41758B8F79B8F3BBBAF6C314A06C0@MN2PR12MB4175.namprd12.prod.outlook.com>
In-Reply-To: <MN2PR12MB41758B8F79B8F3BBBAF6C314A06C0@MN2PR12MB4175.namprd12.prod.outlook.com>
Subject: Seeing a problem in multi cpu runs where memory mapped pcie device register reads are returning incorrect values
Date:   Thu, 2 Jul 2020 04:59:52 -0700
Message-ID: <05f901d65068$4c23be00$e46b3a00$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdZP0xwDhu8cf1EMQLyhyg6esmh9lQAkw8Jg
Content-Language: en-us
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Background
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I have a test environment which runs QEMU 4.2 with a plugin that runs =
two
copies of a PCIE device simulator on a CentOS 7.5 host with an Ubuntu =
18.04
guest. When running with a single QEMU CPU using:

=A0=A0=A0=A0 -cpu kvm64,+lahf_lm -M q35,kernel-irqchip=3Doff -device
intel-iommu,intremap=3Don

Our tests run fine.=20

But when running with multiple cpu=92s:

=A0=A0=A0 -cpu kvm64,+lahf_lm -M q35,kernel-irqchip=3Doff -device
intel-iommu,intremap=3Don -smp 2,sockets=3D1,cores=3D2

Some mmio reads to the simulated devices BAR 0 registers by our device
driver running on the guest are returning are returning incorrect =
values.=20

Running QEMU under gdb I see that the read request is reaching our =
simulated
device correctly and that the correct result is being returned by the
simulator. Using gdb I have tracked the return value all the way back up =
the
call stack and the correct value is arriving in KVM_EXIT_MMIO
in=A0kvm_cpu_exec (qemu-4.2.0/accel/kvm/kvm-all.c:2365)=A0 but the value
returned to the device driver which initiated the read is 0.

Question
=3D=3D=3D=3D=3D=3D=3D=3D

Is anyone else running QEMU 4.2 in multi cpu mode? Is anyone getting
incorrect reads from memory mapped device registers =A0when running in =
this
mode? I would appreciate any pointers on how best to debug the flow from
KVM_EXIT_MMIO back to the device driver running on the guest
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20

