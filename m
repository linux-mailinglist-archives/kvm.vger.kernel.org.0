Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3844CE325
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 06:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiCEFra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 00:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiCEFra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 00:47:30 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A541D304C
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 21:46:40 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id l25so9993030oic.13
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 21:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:from:date:message-id:subject:to;
        bh=ruVFlDXXB/Q6JKyzyVhxk+4gUxOPwPUJPvXqS35wHDw=;
        b=hAavAsgZpY6fHXyFWUypz/7iYwh9CXGIxFHon289TDqKh/ULWzYdvAtn281+2ldynX
         m9G5vq5PDUkhXSGtXhI1iCPXuAW2ailBt3Nqncs2SKYE4Jtr0JbpslCmirIZZGYkyZP+
         biXd3/kfRQNTIrZhjrZ1GGZ5FFOejkcFnbSTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ruVFlDXXB/Q6JKyzyVhxk+4gUxOPwPUJPvXqS35wHDw=;
        b=culZzcFCL6Xq9BrY1K5CbCyMBajXUWyHyR6HLtU4fLYgitE3+UOCP2W/Wf7IDL/wPm
         ZZXaoP5bdOUhPBkdwyUSUUs/D18Tw6e0x5WpkyEzwFGPna9vbi1z6fn2688o/vTBxco3
         etKNc3oC05zt8OWeuGwR8MJWULLGj0AXkV1ZiThQDFYUjwN7elBSslS8BeCrjB0EnK5w
         DmYmxFDDqGxD4WOD5KlOflxjmJ7uWQcJNEtQDHwQO0FD/CyYXV5RmtUcggSHjqrGGtJ6
         g5A4Zi59Oma2BD2BNyJX1MRYJdvdnFFPN7nSK2EhGK/WofDq2LPT4T2n8VLnIXbmJ0Rv
         7IFQ==
X-Gm-Message-State: AOAM531V7B1qVaY5ZyCRxSTzbyRrmyi2URWdK+EwBH+r+xpxY16dqvko
        Ljq2HIKI4PCb2MJU08AyMCqu2vz+r3L08tvU/ks1v2KeBPEjlg==
X-Google-Smtp-Source: ABdhPJzFD4Wpm9m2OMudyrAeEubxTyA7vw1ekgx1+jJpPLDQbiomoyJZ9XJJbJjxwxCSHzadwTiVP0ImoV0cpJUJ++k=
X-Received: by 2002:a05:6808:14c7:b0:2d9:a01a:486f with SMTP id
 f7-20020a05680814c700b002d9a01a486fmr1642700oiw.186.1646459199794; Fri, 04
 Mar 2022 21:46:39 -0800 (PST)
MIME-Version: 1.0
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Sat, 5 Mar 2022 11:16:29 +0530
Message-ID: <CAJGDS+GeE=_WjXixAz+xs_WwizAfneo78e_wkjHoC1EQ5Z3hbg@mail.gmail.com>
Subject: Intercepting IPI (inter-processor interrupts) in a KVM guest
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello all,

I have a need to record all IPIs that are sent and received between
cores in a multi-core guest. Specifically, I have a need to record the
source CPU ID and the destination CPU ID of such interrupts.

I am using KVM with QEMU and I did read about "hypercalls", but I'm
not sure if IPIs are sent that way. I tried putting debug statements
in the host kernel at "kvm_emulate_hypercall" but I didn't get any
requisite logs. I am using Linux Kernel 5.8.0 on the host. I am using
QEMU version 5.0.1. My target and host architecture is x86_64.

The command line I use to start QEMU is as below -

sudo ./qemu-system-x86_64 -m 1024 --machine pc-i440fx-2.5 -cpu
qemu64,-kvmclock, -kvm_pv_eoi,+kvm_pv_ipi -smp 2 -enable-kvm -netdev
tap,id=tap1,ifname=tap0,script=no,downscript=no -device
virtio-net-pci,netdev=tap1,mac=00:00:00:00:00:00 -drive
file=~/os_images_for_qemu/ubuntu-16.04.server.qcow2,format=qcow2,if=none,id=img-direct
-device virtio-blk-pci,drive=img-direct

Is there a way to intercept IPIs in a multi-core guest ? I would like
to cause a VMEXIT in the guest when an IPI is sent so I could record
all the information I need.

Thank you very much.

Best Regards,
Arnabjyoti Kalita
