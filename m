Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D198E742EDE
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 22:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjF2Uuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 16:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjF2Uuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 16:50:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC5730EC
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 13:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688071794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=p3Vp3rwhn+p+DOqGjp5roAc+L4HiC1iWcg0rxheHFZg=;
        b=URGTnri4IhxkEDDhyVpFP9h1MjMIKwnjPqlmjI6O1lARObr2gp7GbXAKdjenFSRKLMCFes
        NYO/IpAdPPBI+WCklvMozgJtDGxGXB6q0c2tpyhuwNOmFm5FMtSQmwb8YVlWpwcmHrTsjL
        chHy2ACZnvYivJiu3t78YS/IhQ/smAE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-A1NFQlmDNkSxqUP8-0Y0vQ-1; Thu, 29 Jun 2023 16:49:52 -0400
X-MC-Unique: A1NFQlmDNkSxqUP8-0Y0vQ-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-76c5c78bc24so48227839f.2
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 13:49:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688071792; x=1690663792;
        h=content-transfer-encoding:mime-version:organization:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3Vp3rwhn+p+DOqGjp5roAc+L4HiC1iWcg0rxheHFZg=;
        b=TE032cdZp+wlBZsvs7jo5gbll8/1XlbqRR7qTGnE7o7Djjj93xTOVdS4bKWvvKGf7+
         4SKmN0EOxezbJ/nyK4EhV+3StyGJBaBNU+j0wtCuQyIackR1lMXYbsaDL6CjXJ8LE/JE
         0IQVkJs07rysrYBj45RlzHIcFjjCC7NF60val/KqcLO0t3ybM4D31b17QE5o9/Ulu+gL
         IrfKbKkLm03eEu4hjU/UcTe5UL9G6mziWABd64rmir8WvY8pBcvMUcbtdSgdV6TQo9Lx
         h/PQUo4qKfVg3KDUsJ0bsZfNnct6mOh1jK8Yzb3kHbTFCC3Heu+qgFSoCemhTQahlkNj
         1Oxg==
X-Gm-Message-State: AC+VfDwUrcAQcHHcgjsH7xsr0CxJ7zH7rLUi+HhJUftPU0l2FQHqErMx
        HxO+0vZBHDnN50/Pke/Dk0sxzdy+YLVFy2gf3vGq+c5RCI6ZCL2ImkAdPn79YMlUbwjixjmIqcZ
        QHEt57g4kzmrz
X-Received: by 2002:a6b:e308:0:b0:786:2878:9593 with SMTP id u8-20020a6be308000000b0078628789593mr819533ioc.0.1688071791749;
        Thu, 29 Jun 2023 13:49:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6xKHDlA0smrFl44a/e+yacmCPzvKHISZ+A7ODOaf0op5jZ2Yb52khHqsOAdLbSJHShkEpzeA==
X-Received: by 2002:a6b:e308:0:b0:786:2878:9593 with SMTP id u8-20020a6be308000000b0078628789593mr819520ioc.0.1688071791492;
        Thu, 29 Jun 2023 13:49:51 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p13-20020a02c80d000000b004249d9e81besm4041609jao.131.2023.06.29.13.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jun 2023 13:49:51 -0700 (PDT)
Date:   Thu, 29 Jun 2023 14:49:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.5-rc1
Message-ID: <20230629144949.07e6cd78.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 44c026a73be8038f03dbdeef028b642880cf1511:

  Linux 6.4-rc3 (2023-05-21 14:05:48 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.5-rc1

for you to fetch changes up to ff598081e5b9d0bdd6874bfe340811bbb75b35e4:

  vfio/mdev: Move the compat_class initialization to module init (2023-06-27 12:05:26 -0600)

----------------------------------------------------------------
VFIO updates for v6.5-rc1

 - Adjust log levels for common messages. (Oleksandr Natalenko,
   Alex Williamson)

 - Support for dynamic MSI-X allocation. (Reinette Chatre)

 - Enable and report PCIe AtomicOp Completer capabilities.
   (Alex Williamson)

 - Cleanup Kconfigs for vfio bus drivers. (Alex Williamson)

 - Add support for CDX bus based devices. (Nipun Gupta)

 - Fix race with concurrent mdev initialization. (Eric Farman)

----------------------------------------------------------------
Alex Williamson (5):
      vfio/pci: Also demote hiding standard cap messages
      vfio/pci-core: Add capability for AtomicOp completer support
      vfio/pci: Cleanup Kconfig
      vfio/platform: Cleanup Kconfig
      vfio/fsl: Create Kconfig sub-menu

Eric Farman (1):
      vfio/mdev: Move the compat_class initialization to module init

Nipun Gupta (1):
      vfio/cdx: add support for CDX bus

Oleksandr Natalenko (1):
      vfio/pci: demote hiding ecap messages to debug level

Reinette Chatre (11):
      vfio/pci: Consolidate irq cleanup on MSI/MSI-X disable
      vfio/pci: Remove negative check on unsigned vector
      vfio/pci: Prepare for dynamic interrupt context storage
      vfio/pci: Move to single error path
      vfio/pci: Use xarray for interrupt context storage
      vfio/pci: Remove interrupt context counter
      vfio/pci: Update stale comment
      vfio/pci: Use bitfield for struct vfio_pci_core_device flags
      vfio/pci: Probe and store ability to support dynamic MSI-X
      vfio/pci: Support dynamic MSI-X
      vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X

 MAINTAINERS                         |   7 +
 drivers/vfio/Kconfig                |   1 +
 drivers/vfio/Makefile               |   5 +-
 drivers/vfio/cdx/Kconfig            |  17 ++
 drivers/vfio/cdx/Makefile           |   8 +
 drivers/vfio/cdx/main.c             | 234 +++++++++++++++++++++++++++
 drivers/vfio/cdx/private.h          |  28 ++++
 drivers/vfio/fsl-mc/Kconfig         |   6 +-
 drivers/vfio/mdev/mdev_core.c       |  23 +--
 drivers/vfio/pci/Kconfig            |   8 +-
 drivers/vfio/pci/hisilicon/Kconfig  |   4 +-
 drivers/vfio/pci/mlx5/Kconfig       |   2 +-
 drivers/vfio/pci/vfio_pci_config.c  |   8 +-
 drivers/vfio/pci/vfio_pci_core.c    |  46 +++++-
 drivers/vfio/pci/vfio_pci_intrs.c   | 305 ++++++++++++++++++++++++------------
 drivers/vfio/platform/Kconfig       |  18 ++-
 drivers/vfio/platform/Makefile      |   9 +-
 drivers/vfio/platform/reset/Kconfig |   2 +
 include/linux/cdx/cdx_bus.h         |   1 -
 include/linux/mod_devicetable.h     |   6 +
 include/linux/vfio_pci_core.h       |  26 +--
 include/uapi/linux/vfio.h           |  18 +++
 scripts/mod/devicetable-offsets.c   |   1 +
 scripts/mod/file2alias.c            |  17 +-
 24 files changed, 654 insertions(+), 146 deletions(-)
 create mode 100644 drivers/vfio/cdx/Kconfig
 create mode 100644 drivers/vfio/cdx/Makefile
 create mode 100644 drivers/vfio/cdx/main.c
 create mode 100644 drivers/vfio/cdx/private.h

