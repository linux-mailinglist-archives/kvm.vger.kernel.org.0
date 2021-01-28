Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1BA307E64
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhA1Sqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 13:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbhA1Sol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 13:44:41 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A24C061786
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:43:38 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id i187so8975370lfd.4
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gc8IAD89ohU9L5g7XLURxoRD1ypfXHd9129BbRQE4Vs=;
        b=ly0bdMEC9l7y2KBWFcGiVcAm4730SBb/exane8VwuSf7eQEN/tBlFKgh1wWslPiPdK
         37ltxyiH2T8+xJU06Ml7stRxi/Ex0Ya1CRIMhlTPUmDefMX6EA+U4O2zM0XtfJeNazP4
         1jTTH4LDF2wlGm0ieYFE9gBRPnfSavbNX1aRvsYZ80O8gHKIr1jBPaCe13ZdxnxmsK4M
         ioEMNRgjKwGTHgabRVNeV6fOik1F5HWarOIEhDwyrzFe8+LgF2Fat/D3WxAl3iAejIHY
         zQasTFhpR1OEbcI/s8uUBqI9ND6/+Hzc2OwqOGl+2kd6jaU9Zuza2H1H3vrl7CbA9zkr
         tTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gc8IAD89ohU9L5g7XLURxoRD1ypfXHd9129BbRQE4Vs=;
        b=skHXRej8m5CwUKXz8AAm9LM0fGAQGOK9QxYVFPyQ8Alepx7xnP6YDGLvuhwkADDAjv
         LJgujH2HqSLaEZYcRKY63au0ciWBJ0TzKh/eCwnljC+3gCOD4OkGgau2r6XW5E5yVJvr
         3BzYPr8L/TJWf7m8m4lAriZuVrTXhqLG1+Boqf5EiwuydiXIewDCAv6VUQeWr7KzJSBX
         W/mbNUvJLbrizE5pOMdikj7TxC5O+R4AsDNhyPIfKISBXhpvboT+ADs5eWJajAY1ZYGo
         2BZUts4/mgjxkJpCBuAqUEx9HjTolBG0rayUl46eqbc4ifNxuMbf+cttXP0Rl/JcwcGI
         lQpA==
X-Gm-Message-State: AOAM533MVMSKYKhpqvfKZLNzf+XamMw8OWYwbwwxiY4085QKD72gwg6Z
        JndqN4IVHEK3bYFMGWCpf5JC2jHKh9LBmO3b
X-Google-Smtp-Source: ABdhPJyr3hRBvWiLHLwPZGsn20Yns45V20s3ATv9DHDKcLfdt8ruTttYEjs9s+8jtiV8wSCtcGevng==
X-Received: by 2002:a19:ed0a:: with SMTP id y10mr174986lfy.601.1611859416938;
        Thu, 28 Jan 2021 10:43:36 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id k8sm1750508lfg.41.2021.01.28.10.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 10:43:36 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [RFC v2 0/4] Introduce MMIO/PIO dispatch file descriptors (ioregionfd)
Date:   Thu, 28 Jan 2021 21:32:19 +0300
Message-Id: <cover.1611850290.git.eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset introduces a KVM dispatch mechanism which can be used 
for handling MMIO/PIO accesses over file descriptors without returning 
from ioctl(KVM_RUN). This allows device emulation to run in another task 
separate from the vCPU task.

This is achieved through KVM vm ioctl for registering MMIO/PIO regions and 
a wire protocol that KVM uses to communicate with a task handling an 
MMIO/PIO access.

TODOs:
* Implement KVM_EXIT_IOREGIONFD_FAILURE
* Add non-x86 arch support
* Add kvm-unittests

Elena Afanasova (4):
  KVM: add initial support for KVM_SET_IOREGION
  KVM: x86: add support for ioregionfd signal handling
  KVM: add support for ioregionfd cmds/replies serialization
  KVM: enforce NR_IOBUS_DEVS limit if kmemcg is disabled

 arch/x86/kvm/Kconfig          |   1 +
 arch/x86/kvm/Makefile         |   1 +
 arch/x86/kvm/x86.c            | 216 ++++++++++++++-
 include/kvm/iodev.h           |  14 +
 include/linux/kvm_host.h      |  34 +++
 include/uapi/linux/ioregion.h |  32 +++
 include/uapi/linux/kvm.h      |  23 ++
 virt/kvm/Kconfig              |   3 +
 virt/kvm/eventfd.c            |  25 ++
 virt/kvm/eventfd.h            |  14 +
 virt/kvm/ioregion.c           | 479 ++++++++++++++++++++++++++++++++++
 virt/kvm/ioregion.h           |  15 ++
 virt/kvm/kvm_main.c           |  68 ++++-
 13 files changed, 905 insertions(+), 20 deletions(-)
 create mode 100644 include/uapi/linux/ioregion.h
 create mode 100644 virt/kvm/eventfd.h
 create mode 100644 virt/kvm/ioregion.c
 create mode 100644 virt/kvm/ioregion.h

-- 
2.25.1

