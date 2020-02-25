Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F35C16EADA
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 17:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgBYQJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 11:09:30 -0500
Received: from mail-il1-f170.google.com ([209.85.166.170]:42190 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729206AbgBYQJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 11:09:29 -0500
Received: by mail-il1-f170.google.com with SMTP id x2so1789115ila.9;
        Tue, 25 Feb 2020 08:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=bBxq4NlVT2GPfEQHH0hn7IMMrqDvaebxrDPcHRUCmVQ=;
        b=PeFnmIXiaQXXC1hZoM2/FOQBtn4LarKDEsvjyiZrpzK8iw4E2UVlU4HH6GpvmSJ0y7
         QJn1ZR4PP1964p1H5cLyiT0sKiJNQzovc3IPNX8n5g5gEAQN50Sp9zfCmJhIFMvtagof
         dTtLM0YWVOjwcEiqJzXm+hYalT96GGAe9+EF5qKCKZl+iguohVhoKoAcIoQ08OQkEMxA
         ALEa/qUjspBz+wPiwYccxf1fDZ+xoNAhzOwMH4wQw3bhA58gt14q6Yij9EybV4l2j/4J
         C1kQywJDY+v3PgdSk8tdMIuLKv2ei3cbYw5GgUfa6qNnzg0zifB/9r/myR49kD5J54xQ
         gKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=bBxq4NlVT2GPfEQHH0hn7IMMrqDvaebxrDPcHRUCmVQ=;
        b=X72hpqH4SRIzYikUDSw0G6covFB+QA4x6OOij2Er9InLESR9/jweXL3xk4q3cPCvdz
         IEZXLREG/GpubAJhVVYfS5N29nBbm6iCkQQ4ZwGmKBLOBb7OiEVOz52BTLHgRzq3MRgx
         zAqEhGKTo6HjfZoNjqntRDZ8jsQywwwBrcZuasjmjWEQsqeG9PZu4sSlSmD8r2Uzxk6i
         SwjeS5dBeYM5HcZaMdRQ7BOamQrLrZN3jiiEkSqfKodlyrKzbFgmvo9MOJp88LwRC2HB
         sFLveWSGGujUWVHptpIZCrRNyvEFtwbfFPaQAQQVSaueWR7l0+Pyn/sYOZi7/belSSeb
         guxw==
X-Gm-Message-State: APjAAAUzw+24T2KQ9TIFTqBHVh3heNjdyuRKvvvFpWVifabwwj+KmEeV
        DIxsrayOqkCW6PTZd1s92rMqXHZmNUXajtbWm9dn935D
X-Google-Smtp-Source: APXvYqzihMF67D637iOTQRASMq8d5Y/DQGqcGg8S2RvIEt9WmGR4Nnm1bzUynkgr5HxgldJSaZFAARvggtgly0kO3Zo=
X-Received: by 2002:a92:b749:: with SMTP id c9mr67810506ilm.143.1582646968592;
 Tue, 25 Feb 2020 08:09:28 -0800 (PST)
MIME-Version: 1.0
From:   Wayne Li <waynli329@gmail.com>
Date:   Tue, 25 Feb 2020 10:09:17 -0600
Message-ID: <CAM2K0nreUP-zW2pJaH7tWSHHQn7WWeUDoeH_HM99wysgOHANXw@mail.gmail.com>
Subject: Problem with virtual to physical memory translation when KVM is enabled.
To:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        QEMU Developers <qemu-devel@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear KVM list members,

We developed a virtual machine using the QEMU code.  This virtual
machine emulates a certain custom-made computer that runs on a certain
military platform.  All I can tell you about this virtual machine is
that it emulates a computer that has an e5500 processor.  Currently I
am running this virtual machine on a T4240-RDB which has a PowerPC
e6500 processor.

Anyway, right now I=E2=80=99m trying to get this virtual machine working wi=
th
KVM enabled.  But the problem I=E2=80=99m having is the VM doesn=E2=80=99t =
do anything
after the KVM_RUN ioctl call is made (NIP doesn=E2=80=99t progress and no
registers change).  What seems to be the problem is the VM doesn=E2=80=99t =
run
the instruction that=E2=80=99s supposed to be retrieved from the virtual
address 0xFFFF_FFFC.   When KVM isn=E2=80=99t enabled and the VM is running
using TCG (tiny code generator), a branch instruction to 0xFFFF_F700
is retrieved from the virtual address 0xFFFF_FFFC and the VM kicks off
running from there.

So what could be causing this problem?  I=E2=80=99m guessing it has somethi=
ng
to do with the translation lookaside buffers (TLBs)?  But the
translation between virtual and physical memory clearly works when KVM
isn=E2=80=99t enabled.  So what could cause this to stop working when KVM i=
s
enabled?  Or maybe I=E2=80=99m not understanding something right and missin=
g
what the problem actually is?  Let me know your thoughts.

-Thanks, Wayne Li
