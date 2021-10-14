Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB63642D698
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhJNKA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 06:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhJNKAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 06:00:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2C7C061570;
        Thu, 14 Oct 2021 02:58:19 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so6529945pjb.1;
        Thu, 14 Oct 2021 02:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G4rIb7beJwQqUdF+ZBNJoTZ2AvHg1kCA9YpDdPt+250=;
        b=qTgsgp7JXouqeXF5dWuhL4S6rIr8gnsnjU2RvvoTCZkUazqASzivyt7xhwJ4pYdtUI
         gDU+sCGxn4po6o6D73N6VgbqNDpy+ZIVcz8Yf8ODdVzLrznEqHzDWdxiwWOaPvVVB4hz
         ZjyYLcGuxVqbAl1XJ5kOHADIJYtpf1yHRbwjd6/0PESNIDyU6qykUd6TIMsh2IYATrDW
         f8nsZCGvms3GhnZERoa3vaydWepnqU3ryonss8DNWa9LXxa5VqMTLBtjOUxbUyAiVgEj
         OHodqrpBORUqkMJHgXupRfZHazA6ggCpVM9Chwrt1rEXl1U+q6V5aDPWXzoG/GAwCLf5
         j0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G4rIb7beJwQqUdF+ZBNJoTZ2AvHg1kCA9YpDdPt+250=;
        b=BYe9eL215n9443xxgu9XE6lnEVKt6m3SC6JsOz+nxC5pnbheJUA/CZBNjPZXJ233Q8
         GRUEpNf79+YdYPSCU8Kp/jjdLWXNi/Nshaxts/J4g282XmjEomfciEsrWQuJW7s7t+B4
         +QiCzlv4Nf/reYw/ihQF1J1frDHdDIrqn/GGQdB+lTufS23bHTQUrO9P18+YjJXyrxvK
         Q9Rk3NseymK5FBDYwB6mRIs2mPQON1dYLq9KNFNxv5JMhur2vsDUdoFURuHfO6zxQGHx
         bC3nj+S8s5aLRBOEK37yt/Wzoa4kO8NUd4DjYV/6EwzrVN4Mu0AujTtVbQ3AkVsy7w9X
         cSCw==
X-Gm-Message-State: AOAM533l9JKhZ97wiYP6FXzgde9dHnZf4bA6b6T+MOrXGT67Qvc99dVB
        kdokLXM0aW6y20Eg09t5d6XJ8O2X+cFu3g==
X-Google-Smtp-Source: ABdhPJybauUsRb6kcRpIweDhwUczxKkSy9GOsnk8QIcNBgG0KtwOGGPIusMCSU+GGv22Q6g7y+LJIA==
X-Received: by 2002:a17:90a:f013:: with SMTP id bt19mr17067122pjb.82.1634205499115;
        Thu, 14 Oct 2021 02:58:19 -0700 (PDT)
Received: from localhost.localdomain (5e.8a.38a9.ip4.static.sl-reverse.com. [169.56.138.94])
        by smtp.gmail.com with ESMTPSA id k127sm2080664pfd.1.2021.10.14.02.58.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Oct 2021 02:58:18 -0700 (PDT)
From:   Zhenguo Yao <yaozhenguo1@gmail.com>
To:     bhelgaas@google.com, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, jgg@ziepe.ca, mgurtovoy@nvidia.com,
        yishaih@nvidia.com, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaozhenguo@jd.com,
        Zhenguo Yao <yaozhenguo1@gmail.com>
Subject: [PATCH v1 0/2] Add ablility of VFIO driver to ignore reset when device don't need it  
Date:   Thu, 14 Oct 2021 17:57:46 +0800
Message-Id: <20211014095748.84604-1-yaozhenguo1@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some scenarios, vfio device can't do any reset in initialization
process. For example: Nvswitch and GPU A100 working in Shared NVSwitch
Virtualization Model. In such mode, there are two type VMs: service
VM and Guest VM. The GPU devices are initialized in the following steps:

1. Service VM boot up. GPUs and Nvswitchs are passthrough to service VM.
Nvidia driver and manager software will do some settings in service VM.

2. The selected GPUs are unpluged from service VM.

3. Guest VM boots up with the selected GPUs passthrough.

The selected GPUs can't do any reset in step3, or they will be initialized
failed in Guest VM.

This patchset add a PCI sysfs interface:ignore_reset which drivers can
use it to control whether to do PCI reset or not. For example: In Shared
NVSwitch Virtualization Model. Hypervisor can disable PCI reset by setting
ignore_reset to 1 before Gust VM booting up.

Zhenguo Yao (2):
  PCI: Add ignore_reset sysfs interface to control whether do device
    reset in PCI drivers
  vfio-pci: Don't do device reset when ignore_reset is setting

 drivers/pci/pci-sysfs.c          | 25 +++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c | 48 ++++++++++++++++++++------------
 include/linux/pci.h              |  1 +
 3 files changed, 56 insertions(+), 18 deletions(-)

-- 
2.27.0

