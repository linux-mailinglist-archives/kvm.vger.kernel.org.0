Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892F26F05ED
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 14:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243747AbjD0Mis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 08:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243513AbjD0Mir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 08:38:47 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9751DC2
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 05:38:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-64115eef620so4573672b3a.1
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 05:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682599125; x=1685191125;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lveTZ5JeoD/bLSzQdM3ZOxUdvr2aGEOFivaadln6H74=;
        b=AAlO74sHsj0bkipg8Q2VyWtY31LXgdhfzaJEjVUwIFrvyWwKDHO5A5S8C29NF7M2nd
         8Nk4NQSkXo9TGwmQv/+A7DF+R1ulUqLDCtXHXxxhSBSw8jHljVwf4i1WUTOauye46/A/
         yflFoAhrd8QFIU9X9zNUeN07aAdMViM5Ub4zaWE3/t7YjrKl0EEcqmSjkQkDdkqK5X1K
         AaiQDwICA2X9MGQXuz2kbpoI7UOPe5Rg4AyHqyArpp8THP3E3GXeZqb+h1ypby7zcoVD
         eLcIOAnrie8CkSwTteUZ/0AxPCeaZyGs7+lRoB0UdZhjE/2nVgflpxLDBz3bLOOCPY2W
         1HiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682599125; x=1685191125;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lveTZ5JeoD/bLSzQdM3ZOxUdvr2aGEOFivaadln6H74=;
        b=MxIGz1HKQRkatLyHl26Orey8xEHQIpKO7n8R0MJuStsKrpLi+Y37s9UFDDQ8QSJ3xY
         Rhbw6I191lKx2RILcdQ9mzrogbFn4nrvxcPy2UhSd/2QnHZFJkSkg0IIBEbqn3h8YWk0
         a9ibM53ZAN4NLPRtw7RglhZkwX9xKBlOZHZRR4ca0UZRIeRuZdJFn8CD7mNWIV/qQDMl
         8sq6ZdjsD7k2BzI/7z1qEs9WjbmjsMPVdcge8l4jorUR2rzUKs6+th0Iqbgt4F/U74RC
         ATND+wT9Q2xbJ9KYGsvMQF12jLJJd4tjL5ZOcHfiIGB0a857hoo9rQKOBqVqGHyVuDSB
         a7Ww==
X-Gm-Message-State: AC+VfDxJBDJPUGhZCLIhmEaZeTKCch2b3QIMW3ZRNtRQW9DsDz4DcIuZ
        tvts8Z+JRStc6/ZrYLdJrcNuoHIUQBhexHQYdZ3xBEoZxaSNQI9R
X-Google-Smtp-Source: ACHHUZ5zRHa/okc+ncOo0uRJ4SpfYcOHIsZTbD4c1vQz3SFXaL69W9XtuRh/YoNqV7M+zyDrb4rlPwzZ24Q5Mnd02gQ=
X-Received: by 2002:a17:90a:dc18:b0:247:e54:2ca4 with SMTP id
 i24-20020a17090adc1800b002470e542ca4mr2145245pjv.19.1682599124790; Thu, 27
 Apr 2023 05:38:44 -0700 (PDT)
MIME-Version: 1.0
From:   zhuangel570 <zhuangel570@gmail.com>
Date:   Thu, 27 Apr 2023 20:38:32 +0800
Message-ID: <CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXhqjbV9w@mail.gmail.com>
Subject: Latency issues inside KVM.
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

We found some latency issue in high-density and high-concurrency scenarios,=
 we
are using cloud hypervisor as vmm for lightweight VM, using VIRTIO net and
block for VM. In our test, we got about 50ms to 100ms+ latency in creating =
VM
and register irqfd, after trace with funclatency (a tool of bcc-tools,
https://github.com/iovisor/bcc), we found the latency introduced by followi=
ng
functions:

- irq_bypass_register_consumer introduce more than 60ms per VM.
  This function was called when registering irqfd, the function will regist=
er
  irqfd as consumer to irqbypass, wait for connecting from irqbypass produc=
ers,
  like VFIO or VDPA. In our test, one irqfd register will get about 4ms
  latency, and 5 devices with total 16 irqfd will introduce more than 60ms
  latency.

- kvm_vm_create_worker_thread introduce tail latency more than 100ms.
  This function was called when create "kvm-nx-lpage-recovery" kthread when
  create a new VM, this patch was introduced to recovery large page to reli=
ef
  performance loss caused by software mitigation of ITLB_MULTIHIT, see
  b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation") and 1aa9b9572b10
  ("kvm: x86: mmu: Recovery of shattered NX large pages").

Here is a simple case, which can emulate the latency issue (the real latenc=
y
is lager). The case create 800 VM as background do nothing, then repeatedly
create 20 VM then destroy them after 400ms, every VM will do simple thing,
create in kernel irq chip, and register 15 riqfd (emulate 5 devices and eve=
ry
device has 3 irqfd), just trace the two function latency, you will reproduc=
e
such kind latency issue. Here is a trace log on Xeon(R) Platinum 8255C serv=
er
(96C, 2 sockets) with linux 6.2.20.

Reproduce Case
https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/kvm_irqfd_fo=
rk.c
Reproduce log
https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/test.log

To fix these latencies, I didn't have a graceful method, just simple ideas
is give user a chance to avoid these latencies, like a module parameter to
disable "kvm-nx-lpage-recovery" kthread and new flag to disable irqbypass
for each irqfd.

Any suggestion to fix the issue if welcomed.

Thanks!

--=20
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94
   zhuangel570
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94
