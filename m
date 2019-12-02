Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE3510F256
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 22:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfLBVsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 16:48:02 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:38351 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfLBVsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 16:48:02 -0500
Received: by mail-io1-f66.google.com with SMTP id u24so1193556iob.5;
        Mon, 02 Dec 2019 13:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=3Ms8zlHQJK2hwaXeaP4qZ/hAYQme4ETl6wKmDCNALCA=;
        b=aMsbcC4Boq/giplL1LvjNzNBE+1LBRESfzKVlx8v/rJ8ZA1f1TfzFCbI/1pyLvj7jb
         x9S9ns7eF1jmYnTJVc7GRhmF8r0NqpE965lqqet+5wZy7VSPzuQgNp6PKqYCFdw5YzMJ
         5u66QwYZn4FL+qtUb3Gq7V2U43QhwBY5ZWHRmGpxPEPZe/taKcsjeu7gMTFMBAFgToOY
         LsINb6Xc+n985se0ivH0CStK1cS5N5a56+Sz2KJr+3xsOFx2IaygvfmFPPLglthTqEf1
         Pe4tNmjK2BBFO3cjGljF30P2uuZYG6BVs49kQkJ25sILR5M4TEQN3gU5xQedhpMhzERX
         u9Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3Ms8zlHQJK2hwaXeaP4qZ/hAYQme4ETl6wKmDCNALCA=;
        b=r6LsuHjKE6ltgVlAAJjzZjIclT/yxLYj3/ahlUcVSPTE/stRr21AFn79JiDm+cNDUK
         rG8jMP2hErEaHeqyyvq77kwTxQeqyH2Am0KefV2vS6GMTOiBLVvDuC2Rj6YlSqry+KBH
         6dDjWxDfpvm4IgLbp0KrUY8a8g67SrlvtcbEkOE7ZbII70I0anmfqSrV0Q4GrnV/MyQ1
         y6hf/PUObZMAz/HnS/1vqgnXyPb2+iSLEi6+oYaP9Jdd42DJa3XtDULIqplMwwuDjmKm
         hEop8c3ukI8a6NrvP1ksq/mrcmg3rhS1OM3EhCk6sbXR1HpuB+xAd2aWNMKKVLbw/uVU
         6Paw==
X-Gm-Message-State: APjAAAU4P5JLLIdqsfsHMuW9uI3Ug/5GYHk2FPjFZ8zyAtjRuRhiU+zv
        2KIy/xsr0utlrKX2FFOFReMEj9c6ahjYaoEOJ+LUiiCo
X-Google-Smtp-Source: APXvYqwoT5huCFrp42VNz1qNPTyyuAKGHcl/c3UforoZ8JkonNQxmRCDNFvLxknzveYZ8LKoRYlvFtJdZ4POHYDXfzc=
X-Received: by 2002:a02:1d04:: with SMTP id 4mr2255009jaj.48.1575323281611;
 Mon, 02 Dec 2019 13:48:01 -0800 (PST)
MIME-Version: 1.0
From:   Wayne Li <waynli329@gmail.com>
Date:   Mon, 2 Dec 2019 21:47:50 +0000
Message-ID: <CAM2K0nqWjaPB3gFD4m6DjciJUCpix4MaGr0hZkp20PxObtL1Zw@mail.gmail.com>
Subject: KVM Kernel Module not being built for Yocto Kernel
To:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear KVM community,

First of all I'd like mention I've posted this question on the Yocto
mailing list as well as the KVM mailing list because my question has
huge ties to the bitbake process (a concept related to the Yocto
project).  Though I believe I'm mainly addressing the KVM community
because my problem is more directly related to the intricacies of the
KVM build process.

So I am trying to build the kvm-kmod from source and I'm running into
an issue where the compilation doesn't produce any kernel modules.
But before I describe my issue and question any further, here's a
little background information on my current endeavour.

My goal right now is to get KVM to work on a T4240RDB running on a
Yocto-based kernel.  For those of you who don't know what a Yocto
kernel is, it is a kernel that you can build/customize yourself using
a program called bitbake.  Anyway, the KVM kernel modules are supposed
to be included in the Yocto kernel by default but they aren't there.
And no tweaking of the configuration for the bitbake process to build
the Yocto kernel has made the KVM kernel modules appear in the kernel
(I've tried pretty much everything!  Just search my name in the Yocto
mailing list archive haha...).  So my final solution was to download
the kvm-kmod source code and write a custom recipe to bitbake it into
the kernel module (in layman terms this means I just download the code
and write a "recipe" to tell bitbake how to compile the kvm-kmod
source code and insert the output files into the kernel).  Here's the
recipe that I wrote for this:

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=c616d0e7924e9e78ee192d99a3b26fbd"

inherit module

SRC_URI = "file:///homead/QorIQ-SDK-V2.0-20160527-yocto/sources/meta-virtualization/recipes-kernel/kvm-kmodule/kvm-kmod-3.10.21.tar.bz2"

S = "${WORKDIR}/kvm-kmod-3.10.21"

do_configure() {
    ./configure --arch=ppc64
--kerneldir=/homead/QorIQ-SDK-V2.0-20160527-yocto/build_t4240rdb-64b/tmp/work/t4240rdb_64b-fsl-linux/kernel-devsrc/1.0-r0/image/usr/src/kernel
}

FILES_${PN} += "/lib/modules/4.1.8-rt8+gbd51baf"

Anyway when I run "bitbake kvm-kmod", it runs fine with no errors.
This runs the recipe I wrote (I conveniently named my recipe kvm-kmod)
which runs the configure file present in the kvm-kmod source code and
then runs make.  In other words I ran make on the kvm-kmod source code
with no errors.  But the problem is there is no kvm.ko or anything
like that anywhere in my project code.

Compiling the kvm-kmod source code is supposed to produce kvm kernel
modules right?  I mean kvm-kmod literally stands for kvm kernel
module?  Could I have forgotten to do something when building the
kvm-kmod source code?  Or maybe my problem has something to do with my
recipe?  Let me know your thoughts.

-Thanks!, Wayne Li
