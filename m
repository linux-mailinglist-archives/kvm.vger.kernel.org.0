Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233F753AB93
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 19:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355433AbiFARLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 13:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbiFARLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 13:11:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57E8D91568
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 10:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654103493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bHOko4VTG01AuZ271PRVFNXvMPUd047zB7JER9LJTzw=;
        b=HX8PkyWvRAxGz5paZTdWg5NkWyoXTnRWjouE1ugD2kJZcAI7CXVRkWGdjkaRmNiX4CWszH
        eO4dcyQxS3g1LPB/M7MYuithrJckUidA7gP0bIpn4hZNC77CrCSn3R6WYLIQAfzw9ewDlN
        ePAst84NUpxNKw1rPP3z//Quou+47/U=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-mLkd105rNOWy6HnmGiyw1A-1; Wed, 01 Jun 2022 13:11:32 -0400
X-MC-Unique: mLkd105rNOWy6HnmGiyw1A-1
Received: by mail-io1-f70.google.com with SMTP id r17-20020a0566022b9100b00654b99e71dbso1236860iov.3
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 10:11:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-transfer-encoding;
        bh=bHOko4VTG01AuZ271PRVFNXvMPUd047zB7JER9LJTzw=;
        b=3SeHD8U6rikEFFqtoYH9pJa445P5D/WT7FJgTLgyKl5tcbvFujVYquf0n0okwDrwwa
         sMh2OltR7x5Ke4D3E+SS57e5GHZtdPbR4chErdLOClOK+vQ34B5JdO33HlSIOlu1bob6
         IyfN91jPTnI4QhoSh9UTAgjNF+Ua19i7SXcrSkzQjmb9c647fMJC9yFdHZzt39uO4aZF
         dToKznVvIQDY8LvcWiR4I3AbH6VLxuW+1XUCdxiDtnFC4Mhb48g5uXKLJJp5Ij/6wo4S
         +vE62DhB3vDYP3tsjid3rCq/7aW8mbEStsjHPNvdYxlURUGsxpR2jmID5YLAsfA5pQLx
         WvQg==
X-Gm-Message-State: AOAM533b7krt/80eJb0lH4+7xtJ6za6Q3bNJRnHpFruv7hUvTuQWgp4z
        iYN9Mgnl3EMysRHapmQaExrvTqTL3YIdK5Y9ihYUARLa4NP6HONiC/P+87ZI/NsEeOzCswzEFO4
        c14I94KuBeDF/
X-Received: by 2002:a92:3f0a:0:b0:2cf:7745:d38 with SMTP id m10-20020a923f0a000000b002cf77450d38mr562664ila.289.1654103490359;
        Wed, 01 Jun 2022 10:11:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk7g2d/ob89pgPLoGrG0fW9AYI+jTkWwsk60G6UFmCkNBd7TGRHDmHC76AxxSCpBeYYWvC7w==
X-Received: by 2002:a92:3f0a:0:b0:2cf:7745:d38 with SMTP id m10-20020a923f0a000000b002cf77450d38mr562625ila.289.1654103489849;
        Wed, 01 Jun 2022 10:11:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i45-20020a02602d000000b0032e22496addsm576465jac.139.2022.06.01.10.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 10:11:29 -0700 (PDT)
Date:   Wed, 1 Jun 2022 11:11:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.19-rc1
Message-ID: <20220601111128.7bf85da0.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

I'm not sure where git pull-request is getting the diffstat below, the
diff of the actual merge of this against mainline looks far less scary.
If I've botched something, please let me know.  Thanks,

Alex

The following changes since commit 0286300e60455534b23f4b86ce79247829ceddb8:

  iommu: iommu_group_claim_dma_owner() must always assign a domain (2022-05-13 14:54:04 +0200)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v5.19-rc1

for you to fetch changes up to 421cfe6596f6cb316991c02bf30a93bd81092853:

  vfio: remove VFIO_GROUP_NOTIFY_SET_KVM (2022-05-24 08:41:18 -0600)

----------------------------------------------------------------
VFIO updates for v5.19-rc1

 - Improvements to mlx5 vfio-pci variant driver, including support
   for parallel migration per PF (Yishai Hadas)

 - Remove redundant iommu_present() check (Robin Murphy)

 - Ongoing refactoring to consolidate the VFIO driver facing API
   to use vfio_device (Jason Gunthorpe)

 - Use drvdata to store vfio_device among all vfio-pci and variant
   drivers (Jason Gunthorpe)

 - Remove redundant code now that IOMMU core manages group DMA
   ownership (Jason Gunthorpe)

 - Remove vfio_group from external API handling struct file ownership
   (Jason Gunthorpe)

 - Correct typo in uapi comments (Thomas Huth)

 - Fix coccicheck detected deadlock (Wan Jiabing)

 - Use rwsem to remove races and simplify code around container and
   kvm association to groups (Jason Gunthorpe)

 - Harden access to devices in low power states and use runtime PM to
   enable d3cold support for unused devices (Abhishek Sahu)

 - Fix dma_owner handling of fake IOMMU groups (Jason Gunthorpe)

 - Set driver_managed_dma on vfio-pci variant drivers (Jason Gunthorpe)

 - Pass KVM pointer directly rather than via notifier (Matthew Rosato)

----------------------------------------------------------------
Abhishek Sahu (4):
      vfio/pci: Invalidate mmaps and block the access in D3hot power state
      vfio/pci: Change the PF power state to D0 before enabling VFs
      vfio/pci: Virtualize PME related registers bits and initialize to zero
      vfio/pci: Move the unused device into low power state with runtime PM

Alex Williamson (3):
      Merge tag 'mlx5-lm-parallel' of https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux into v5.19/vfio/next
      Merge tag 'gvt-next-2022-04-29' into v5.19/vfio/next
      Merge remote-tracking branch 'iommu/vfio-notifier-fix' into v5.19/vfio/next

Jason Gunthorpe (26):
      vfio: Make vfio_(un)register_notifier accept a vfio_device
      vfio/ccw: Remove mdev from struct channel_program
      vfio/mdev: Pass in a struct vfio_device * to vfio_pin/unpin_pages()
      vfio/mdev: Pass in a struct vfio_device * to vfio_dma_rw()
      drm/i915/gvt: Change from vfio_group_(un)pin_pages to vfio_(un)pin_pages
      vfio: Remove dead code
      vfio: Remove calls to vfio_group_add_container_user()
      vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in drvdata
      vfio/pci: Remove vfio_device_get_from_dev()
      vfio: Delete container_q
      kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into functions
      kvm/vfio: Store the struct file in the kvm_vfio_group
      vfio: Change vfio_external_user_iommu_id() to vfio_file_iommu_group()
      vfio: Remove vfio_external_group_match_file()
      vfio: Change vfio_external_check_extension() to vfio_file_enforced_coherent()
      vfio: Change vfio_group_set_kvm() to vfio_file_set_kvm()
      kvm/vfio: Remove vfio_group from kvm
      vfio/pci: Use the struct file as the handle not the vfio_group
      vfio: Add missing locking for struct vfio_group::kvm
      vfio: Change struct vfio_group::opened from an atomic to bool
      vfio: Split up vfio_group_get_device_fd()
      vfio: Fully lock struct vfio_group::container
      vfio: Simplify the life cycle of the group FD
      vfio: Change struct vfio_group::container_users to a non-atomic int
      vfio: Do not manipulate iommu dma_owner for fake iommu groups
      vfio/pci: Add driver_managed_dma to the new vfio_pci drivers

Matthew Rosato (1):
      vfio: remove VFIO_GROUP_NOTIFY_SET_KVM

Robin Murphy (1):
      vfio: Stop using iommu_present()

Thomas Huth (1):
      include/uapi/linux/vfio.h: Fix trivial typo - _IORW should be _IOWR instead

Wan Jiabing (1):
      kvm/vfio: Fix potential deadlock problem in vfio

Yishai Hadas (4):
      net/mlx5: Expose mlx5_sriov_blocking_notifier_register / unregister APIs
      vfio/mlx5: Manage the VF attach/detach callback from the PF
      vfio/mlx5: Refactor to enable VFs migration in parallel
      vfio/mlx5: Run the SAVE state command in an async mode

 .mailmap                                           |    1 +
 Documentation/arm64/memory-tagging-extension.rst   |    4 +-
 .../devicetree/bindings/clock/imx8m-clock.yaml     |    4 -
 .../devicetree/bindings/clock/microchip,mpfs.yaml  |   13 +-
 .../bindings/display/bridge/renesas,lvds.yaml      |    4 -
 .../devicetree/bindings/display/renesas,du.yaml    |   23 -
 .../devicetree/bindings/hwmon/ti,tmp421.yaml       |    7 +-
 .../devicetree/bindings/iio/adc/st,stm32-adc.yaml  |    2 -
 .../devicetree/bindings/leds/leds-mt6360.yaml      |    2 -
 .../devicetree/bindings/mfd/atmel-flexcom.txt      |    2 +-
 .../bindings/mmc/nvidia,tegra20-sdhci.yaml         |    7 +-
 .../devicetree/bindings/mtd/gpmi-nand.yaml         |    2 -
 .../devicetree/bindings/net/can/bosch,c_can.yaml   |    3 -
 .../devicetree/bindings/net/dsa/realtek.yaml       |   35 +-
 .../devicetree/bindings/pci/apple,pcie.yaml        |    3 -
 .../devicetree/bindings/phy/brcm,sata-phy.yaml     |   10 +-
 .../devicetree/bindings/pinctrl/pincfg-node.yaml   |   12 +-
 .../regulator/richtek,rt5190a-regulator.yaml       |    2 +-
 .../bindings/rtc/allwinner,sun6i-a31-rtc.yaml      |   10 -
 .../bindings/rtc/microchip,mfps-rtc.yaml           |   15 +-
 .../devicetree/bindings/serial/samsung_uart.yaml   |    4 -
 .../bindings/sound/allwinner,sun4i-a10-i2s.yaml    |    1 -
 .../bindings/sound/ti,j721e-cpb-audio.yaml         |    2 -
 .../bindings/thermal/rcar-gen3-thermal.yaml        |    1 -
 .../devicetree/bindings/ufs/cdns,ufshc.yaml        |    3 +
 .../bindings/usb/samsung,exynos-usb2.yaml          |    1 +
 Documentation/driver-api/vfio-mediated-device.rst  |   31 +-
 Documentation/filesystems/f2fs.rst                 |   70 -
 Documentation/security/siphash.rst                 |   46 +-
 Documentation/virt/kvm/api.rst                     |   24 +-
 Documentation/vm/page_owner.rst                    |    5 +-
 MAINTAINERS                                        |   43 +-
 Makefile                                           |    2 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                   |    2 +
 arch/arm/boot/dts/am3517-evm.dts                   |   45 +-
 arch/arm/boot/dts/am3517-som.dtsi                  |    9 +
 arch/arm/boot/dts/at91-dvk_su60_somc.dtsi          |    2 +-
 arch/arm/boot/dts/at91-kizbox3-hs.dts              |    2 +-
 arch/arm/boot/dts/at91-kizbox3_common.dtsi         |    2 +-
 arch/arm/boot/dts/at91-q5xr5.dts                   |    2 +-
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi        |    2 +-
 arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts      |    2 +-
 arch/arm/boot/dts/at91-sama5d2_xplained.dts        |    2 +-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |    8 +-
 arch/arm/boot/dts/at91-sama5d4_ma5d4.dtsi          |    2 +-
 arch/arm/boot/dts/at91-sama5d4_xplained.dts        |    6 +-
 arch/arm/boot/dts/at91-sama5d4ek.dts               |    2 +-
 arch/arm/boot/dts/at91-sama7g5ek.dts               |    4 +-
 arch/arm/boot/dts/at91-vinco.dts                   |    2 +-
 arch/arm/boot/dts/at91rm9200ek.dts                 |    4 +-
 arch/arm/boot/dts/at91sam9260ek.dts                |    2 +-
 arch/arm/boot/dts/at91sam9261ek.dts                |    2 +-
 arch/arm/boot/dts/at91sam9263ek.dts                |    2 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   45 +-
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |    2 +-
 arch/arm/boot/dts/at91sam9n12ek.dts                |    2 +-
 arch/arm/boot/dts/at91sam9rlek.dts                 |    2 +-
 arch/arm/boot/dts/at91sam9x5ek.dtsi                |    2 +-
 arch/arm/boot/dts/dra7-l4.dtsi                     |    4 +-
 arch/arm/boot/dts/imx6qdl-apalis.dtsi              |   10 +-
 arch/arm/boot/dts/imx6ull-colibri.dtsi             |    2 +-
 arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts   |   15 +
 arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts   |   15 +
 arch/arm/boot/dts/logicpd-som-lv.dtsi              |   15 -
 arch/arm/boot/dts/omap3-gta04.dtsi                 |    2 +
 arch/arm/boot/dts/sama5d3xmb.dtsi                  |    2 +-
 arch/arm/boot/dts/sama5d3xmb_cmp.dtsi              |    2 +-
 arch/arm/boot/dts/sama7g5.dtsi                     |   18 +-
 arch/arm/boot/dts/usb_a9263.dts                    |    2 +-
 arch/arm/configs/multi_v7_defconfig                |    1 +
 arch/arm/configs/tegra_defconfig                   |    3 +-
 arch/arm/mach-exynos/Kconfig                       |    1 -
 arch/arm/mach-omap2/omap4-common.c                 |    2 +
 arch/arm64/boot/dts/amlogic/meson-g12b-a311d.dtsi  |   40 -
 arch/arm64/boot/dts/amlogic/meson-g12b-s922x.dtsi  |   40 -
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi          |    8 +-
 .../boot/dts/amlogic/meson-sm1-bananapi-m5.dts     |    1 +
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi         |   20 -
 .../boot/dts/freescale/imx8mm-venice-gw71xx.dtsi   |    4 +-
 .../boot/dts/freescale/imx8mm-venice-gw72xx.dtsi   |    4 +-
 .../boot/dts/freescale/imx8mm-venice-gw73xx.dtsi   |    4 +-
 arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts  |    4 +
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |   10 +-
 arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi  |    2 +-
 arch/arm64/boot/dts/freescale/imx8qm.dtsi          |    2 +-
 arch/arm64/boot/dts/nvidia/tegra186-p3310.dtsi     |    8 +-
 .../dts/nvidia/tegra186-p3509-0000+p3636-0001.dts  |    8 +-
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi     |    6 +-
 arch/arm64/boot/dts/nvidia/tegra194-p3668.dtsi     |    6 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi     |    6 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2894.dtsi     |    8 +-
 arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts |    8 +-
 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts      |    4 +-
 arch/arm64/include/asm/kvm_emulate.h               |    1 +
 arch/arm64/kernel/elfcore.c                        |    2 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |   18 +-
 arch/arm64/kvm/inject_fault.c                      |   28 +
 arch/arm64/kvm/mmu.c                               |   19 +
 arch/arm64/kvm/pmu-emul.c                          |   23 +-
 arch/arm64/kvm/psci.c                              |    3 +-
 arch/mips/include/asm/timex.h                      |    8 +-
 arch/mips/kernel/time.c                            |   11 +-
 arch/parisc/Kconfig                                |    1 +
 arch/parisc/configs/generic-32bit_defconfig        |    4 +-
 arch/parisc/configs/generic-64bit_defconfig        |    3 +-
 arch/parisc/include/asm/pgtable.h                  |    2 +-
 arch/parisc/kernel/cache.c                         |   18 +-
 arch/parisc/kernel/kprobes.c                       |    2 +-
 arch/parisc/kernel/patch.c                         |   25 +-
 arch/parisc/kernel/processor.c                     |   11 +-
 arch/parisc/kernel/setup.c                         |    2 +
 arch/parisc/kernel/time.c                          |    6 +-
 arch/parisc/kernel/traps.c                         |    2 +-
 arch/parisc/math-emu/dfadd.c                       |    2 +-
 arch/parisc/math-emu/dfsub.c                       |    2 +-
 arch/parisc/math-emu/sfadd.c                       |    2 +-
 arch/parisc/math-emu/sfsub.c                       |    2 +-
 arch/powerpc/kernel/vdso/gettimeofday.S            |    9 +-
 arch/powerpc/platforms/pseries/papr_scm.c          |    7 +-
 arch/powerpc/platforms/pseries/vas-sysfs.c         |   19 +-
 arch/powerpc/platforms/pseries/vas.c               |   23 +-
 arch/powerpc/platforms/pseries/vas.h               |    2 +-
 .../boot/dts/microchip/microchip-mpfs-fabric.dtsi  |   16 +-
 .../dts/microchip/microchip-mpfs-icicle-kit.dts    |    2 +-
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi  |   10 +-
 arch/riscv/configs/defconfig                       |    1 +
 arch/riscv/configs/rv32_defconfig                  |    1 +
 arch/riscv/kernel/patch.c                          |    2 +-
 arch/riscv/kvm/vcpu_sbi.c                          |    5 +-
 arch/riscv/mm/init.c                               |   21 +-
 arch/s390/Makefile                                 |   10 +
 arch/s390/kvm/kvm-s390.c                           |   11 +-
 arch/s390/mm/gmap.c                                |    7 +
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/entry/entry_64.S                          |    3 +
 arch/x86/include/asm/intel-family.h                |    3 +
 arch/x86/include/asm/microcode.h                   |    2 +
 arch/x86/include/asm/pgtable_types.h               |    4 -
 arch/x86/include/asm/static_call.h                 |    1 +
 arch/x86/kernel/cpu/microcode/core.c               |    6 +-
 arch/x86/kernel/fpu/core.c                         |   67 +-
 arch/x86/kernel/unwind_orc.c                       |    8 +-
 arch/x86/kvm/cpuid.c                               |   24 +-
 arch/x86/kvm/mmu.h                                 |   24 +
 arch/x86/kvm/mmu/mmu.c                             |   91 +-
 arch/x86/kvm/mmu/spte.c                            |   28 +
 arch/x86/kvm/mmu/spte.h                            |   10 +-
 arch/x86/kvm/mmu/tdp_iter.h                        |   34 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   97 +-
 arch/x86/kvm/svm/pmu.c                             |   28 +-
 arch/x86/kvm/svm/sev.c                             |   42 +-
 arch/x86/kvm/vmx/vmx.c                             |    2 +-
 arch/x86/kvm/x86.c                                 |    8 +-
 arch/x86/lib/copy_user_64.S                        |   87 +-
 arch/x86/lib/putuser.S                             |    4 +
 arch/x86/lib/retpoline.S                           |    2 +-
 arch/x86/mm/pat/set_memory.c                       |   11 -
 arch/x86/pci/xen.c                                 |    6 +-
 arch/x86/platform/pvh/head.S                       |    1 +
 arch/x86/power/cpu.c                               |   10 +-
 arch/x86/xen/xen-head.S                            |    1 +
 block/bfq-iosched.c                                |   12 +-
 block/blk-core.c                                   |    4 -
 block/blk-iocost.c                                 |   12 +-
 block/blk-mq.c                                     |    9 +-
 drivers/acpi/processor_idle.c                      |    8 +-
 drivers/android/binder.c                           |   10 +-
 drivers/base/arch_topology.c                       |   11 +-
 drivers/base/topology.c                            |   10 +
 drivers/block/Kconfig                              |   16 +
 drivers/block/ataflop.c                            |   10 +-
 drivers/block/floppy.c                             |   61 +-
 drivers/bus/fsl-mc/fsl-mc-msi.c                    |    6 +-
 drivers/bus/imx-weim.c                             |    5 +-
 drivers/bus/mhi/host/pci_generic.c                 |    2 +
 drivers/bus/sunxi-rsb.c                            |    2 +
 drivers/bus/ti-sysc.c                              |   16 +-
 drivers/char/ipmi/ipmi_msghandler.c                |    7 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |    5 +-
 drivers/char/random.c                              |    9 +-
 drivers/clk/microchip/clk-mpfs.c                   |  195 ++-
 drivers/clk/qcom/clk-rcg2.c                        |    2 +-
 drivers/clk/sunxi-ng/ccu-sun6i-rtc.c               |    2 +
 drivers/clk/sunxi/clk-sun9i-mmc.c                  |    2 +
 drivers/cpufreq/qcom-cpufreq-hw.c                  |   70 +-
 drivers/cpufreq/sun50i-cpufreq-nvmem.c             |    4 +-
 drivers/firewire/core-card.c                       |    3 +
 drivers/firewire/core-cdev.c                       |    4 +-
 drivers/firewire/core-topology.c                   |    9 +-
 drivers/firewire/core-transaction.c                |   30 +-
 drivers/firewire/sbp2.c                            |   13 +-
 drivers/gpio/gpio-mvebu.c                          |    7 -
 drivers/gpio/gpio-pca953x.c                        |    4 +-
 drivers/gpio/gpio-visconti.c                       |    7 +-
 drivers/gpio/gpiolib-of.c                          |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  105 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |    4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |   10 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   83 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |    2 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   10 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |    2 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |    1 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                |   39 +
 drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c     |   10 -
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |   35 -
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   10 -
 drivers/gpu/drm/bridge/Kconfig                     |    1 +
 drivers/gpu/drm/i915/Kconfig                       |   36 +-
 drivers/gpu/drm/i915/Makefile                      |    8 +-
 .../gpu/drm/i915/display/intel_dp_aux_backlight.c  |   34 +-
 drivers/gpu/drm/i915/display/intel_fbc.c           |    2 +-
 drivers/gpu/drm/i915/gvt/Makefile                  |   30 +-
 drivers/gpu/drm/i915/gvt/cfg_space.c               |   89 +-
 drivers/gpu/drm/i915/gvt/cmd_parser.c              |    4 +-
 drivers/gpu/drm/i915/gvt/dmabuf.c                  |   36 +-
 drivers/gpu/drm/i915/gvt/execlist.c                |   12 +-
 drivers/gpu/drm/i915/gvt/firmware.c                |   25 +-
 drivers/gpu/drm/i915/gvt/gtt.c                     |   55 +-
 drivers/gpu/drm/i915/gvt/gvt.c                     |  340 -----
 drivers/gpu/drm/i915/gvt/gvt.h                     |  124 +-
 drivers/gpu/drm/i915/gvt/handlers.c                | 1035 ++-----------
 drivers/gpu/drm/i915/gvt/hypercall.h               |   82 -
 drivers/gpu/drm/i915/gvt/interrupt.c               |   40 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c                   | 1108 ++++++--------
 drivers/gpu/drm/i915/gvt/mmio.c                    |    4 +-
 drivers/gpu/drm/i915/gvt/mmio.h                    |    1 -
 drivers/gpu/drm/i915/gvt/mpt.h                     |  400 -----
 drivers/gpu/drm/i915/gvt/opregion.c                |  148 +-
 drivers/gpu/drm/i915/gvt/page_track.c              |    8 +-
 drivers/gpu/drm/i915/gvt/reg.h                     |    9 +-
 drivers/gpu/drm/i915/gvt/scheduler.c               |   37 +-
 drivers/gpu/drm/i915/gvt/trace.h                   |    2 +-
 drivers/gpu/drm/i915/gvt/vgpu.c                    |   22 +-
 drivers/gpu/drm/i915/i915_driver.c                 |    7 -
 drivers/gpu/drm/i915/i915_drv.h                    |    3 +
 drivers/gpu/drm/i915/i915_reg.h                    |    6 +-
 drivers/gpu/drm/i915/intel_gvt.c                   |  252 +++-
 drivers/gpu/drm/i915/intel_gvt.h                   |   32 +-
 drivers/gpu/drm/i915/intel_gvt_mmio_table.c        | 1291 ++++++++++++++++
 drivers/gpu/drm/msm/dp/dp_display.c                |    6 -
 drivers/gpu/drm/msm/dp/dp_panel.c                  |   11 -
 drivers/gpu/drm/msm/dp/dp_panel.h                  |    1 -
 drivers/gpu/drm/sun4i/sun4i_frontend.c             |    3 -
 drivers/hwmon/adt7470.c                            |    4 +-
 drivers/hwmon/asus_wmi_sensors.c                   |    2 +-
 drivers/hwmon/f71882fg.c                           |    5 +-
 drivers/hwmon/pmbus/delta-ahe50dc-fan.c            |   16 +
 drivers/hwmon/pmbus/pmbus_core.c                   |    3 +
 drivers/hwmon/pmbus/xdpe12284.c                    |    2 +-
 drivers/idle/intel_idle.c                          |   27 +-
 drivers/iio/adc/ad7280a.c                          |   12 +-
 drivers/iio/chemical/scd4x.c                       |    5 +-
 drivers/iio/dac/ad3552r.c                          |    6 +-
 drivers/iio/dac/ad5446.c                           |    2 +-
 drivers/iio/dac/ad5592r-base.c                     |    2 +-
 drivers/iio/dac/ltc2688.c                          |    2 +-
 drivers/iio/dac/ti-dac5571.c                       |   28 +-
 drivers/iio/filter/Kconfig                         |    1 +
 drivers/iio/imu/bmi160/bmi160_core.c               |   20 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c    |   15 +-
 drivers/iio/magnetometer/ak8975.c                  |    1 +
 drivers/iio/proximity/sx9324.c                     |   32 +-
 drivers/iio/proximity/sx_common.c                  |    1 +
 drivers/infiniband/core/device.c                   |    2 -
 .../infiniband/core/uverbs_std_types_flow_action.c |  383 +----
 drivers/infiniband/hw/irdma/cm.c                   |   33 +-
 drivers/infiniband/hw/irdma/utils.c                |   21 +-
 drivers/infiniband/hw/irdma/verbs.c                |    4 +-
 drivers/infiniband/hw/mlx5/fs.c                    |  223 +--
 drivers/infiniband/hw/mlx5/main.c                  |   31 -
 drivers/infiniband/sw/rxe/rxe_mcast.c              |   81 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |   35 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |    7 +-
 drivers/interconnect/qcom/sc7180.c                 |   21 -
 drivers/interconnect/qcom/sdx55.c                  |   21 -
 drivers/iommu/apple-dart.c                         |   10 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |    9 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c       |   30 +
 drivers/iommu/intel/iommu.c                        |   27 +-
 drivers/iommu/intel/svm.c                          |    4 +
 drivers/iommu/iommu.c                              |    9 +-
 drivers/memory/renesas-rpc-if.c                    |   60 +-
 drivers/misc/eeprom/at25.c                         |   19 +-
 drivers/mmc/core/mmc.c                             |   23 +-
 drivers/mmc/host/sdhci-msm.c                       |   42 +
 drivers/mmc/host/sunxi-mmc.c                       |    5 +-
 drivers/mtd/nand/raw/mtk_ecc.c                     |   12 +-
 drivers/mtd/nand/raw/qcom_nandc.c                  |   24 +-
 drivers/mtd/nand/raw/sh_flctl.c                    |   14 +-
 drivers/net/can/grcan.c                            |   46 +-
 drivers/net/dsa/b53/b53_common.c                   |   36 +-
 drivers/net/dsa/b53/b53_priv.h                     |   24 +-
 drivers/net/dsa/b53/b53_serdes.c                   |   74 +-
 drivers/net/dsa/b53/b53_serdes.h                   |    9 +-
 drivers/net/dsa/b53/b53_srab.c                     |    4 +-
 drivers/net/dsa/lantiq_gswip.c                     |    3 -
 drivers/net/dsa/microchip/ksz9477.c                |   38 +-
 drivers/net/dsa/mt7530.c                           |    1 +
 drivers/net/dsa/mv88e6xxx/port_hidden.c            |    5 +-
 drivers/net/dsa/realtek/realtek-mdio.c             |    1 -
 drivers/net/dsa/realtek/realtek-smi.c              |    4 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   13 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   15 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |    7 +
 drivers/net/ethernet/cavium/thunder/nic_main.c     |   16 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |    4 -
 drivers/net/ethernet/freescale/fec_main.c          |    2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |    6 +-
 .../hns3/hns3_common/hclge_comm_tqp_stats.c        |    4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   84 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |    9 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   31 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c    |    7 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  129 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |    6 -
 drivers/net/ethernet/intel/ice/ice_main.c          |    3 +
 drivers/net/ethernet/intel/ice/ice_sriov.c         |    2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   27 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |    3 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c          |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   58 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   12 +-
 .../net/ethernet/mellanox/mlx5/core/accel/accel.h  |   36 -
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.c  |  179 ---
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.h  |   96 --
 .../mellanox/mlx5/core/accel/ipsec_offload.h       |   38 -
 .../net/ethernet/mellanox/mlx5/core/accel/tls.c    |  125 --
 .../net/ethernet/mellanox/mlx5/core/accel/tls.h    |  156 --
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    |   31 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    1 -
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   19 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |    4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |    3 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c |   34 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   11 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |    3 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   11 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   30 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   31 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |    5 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h         |    7 +-
 .../mlx5/core/{accel => en_accel}/ipsec_offload.c  |   95 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.h    |   14 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |  245 +--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |    3 -
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c      |   63 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |   71 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |   86 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |    2 +-
 .../core/en_accel/{tls_stats.c => ktls_stats.c}    |   51 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   20 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |   28 +-
 .../mellanox/mlx5/core/en_accel/ktls_utils.h       |    1 -
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |  247 ---
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |  132 --
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |  390 -----
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         |   91 --
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   61 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   11 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |    2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/core.h    |    3 -
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   | 1582 --------------------
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.h   |   62 -
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c |  622 --------
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h |   74 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |    2 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   15 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   60 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |   38 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h   |    7 +-
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |    2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c   |    2 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   18 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |   65 +-
 .../net/ethernet/microchip/lan966x/lan966x_mac.c   |    4 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   14 +-
 drivers/net/ethernet/smsc/smsc911x.c               |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |    1 +
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |   12 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |    1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    2 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |    5 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   30 +-
 drivers/net/mdio/mdio-mux-bcm6368.c                |    2 +-
 drivers/net/phy/marvell10g.c                       |    2 +-
 drivers/net/phy/sfp.c                              |   12 +-
 drivers/net/virtio_net.c                           |   20 +-
 drivers/net/wan/cosa.c                             |    2 +-
 drivers/net/wireguard/device.c                     |    3 +-
 drivers/nfc/nfcmrvl/main.c                         |    2 +-
 drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c     |   20 +-
 drivers/phy/motorola/phy-mapphone-mdm6600.c        |    3 +-
 drivers/phy/samsung/phy-exynos5250-sata.c          |   21 +-
 drivers/phy/ti/phy-am654-serdes.c                  |    2 +-
 drivers/phy/ti/phy-omap-usb2.c                     |    2 +-
 drivers/phy/ti/phy-ti-pipe3.c                      |    1 +
 drivers/phy/ti/phy-tusb1210.c                      |   12 +-
 drivers/pinctrl/intel/pinctrl-alderlake.c          |   60 +-
 drivers/pinctrl/mediatek/Kconfig                   |    1 +
 drivers/pinctrl/pinctrl-pistachio.c                |    6 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |   69 +-
 drivers/pinctrl/qcom/pinctrl-sm6350.c              |   16 +-
 drivers/pinctrl/samsung/Kconfig                    |   11 +-
 drivers/pinctrl/samsung/pinctrl-exynos-arm64.c     |    2 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   23 +-
 drivers/pinctrl/sunplus/sppctl_sp7021.c            |    8 +
 drivers/platform/x86/asus-wmi.c                    |   15 +-
 drivers/platform/x86/dell/dell-laptop.c            |   13 +
 drivers/platform/x86/gigabyte-wmi.c                |    1 +
 drivers/platform/x86/intel/pmc/core.h              |    2 +-
 drivers/platform/x86/intel/sdsi.c                  |   44 +-
 .../x86/intel/uncore-frequency/uncore-frequency.c  |    3 +
 drivers/s390/block/dasd.c                          |   18 +-
 drivers/s390/block/dasd_eckd.c                     |   33 +-
 drivers/s390/block/dasd_int.h                      |   14 +
 drivers/s390/cio/vfio_ccw_cp.c                     |   47 +-
 drivers/s390/cio/vfio_ccw_cp.h                     |    4 +-
 drivers/s390/cio/vfio_ccw_fsm.c                    |    3 +-
 drivers/s390/cio/vfio_ccw_ops.c                    |   14 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |   59 +-
 drivers/s390/crypto/vfio_ap_private.h              |    3 -
 drivers/soc/imx/imx8m-blk-ctrl.c                   |    2 +-
 drivers/target/target_core_pscsi.c                 |   10 +-
 drivers/tee/optee/ffa_abi.c                        |    1 +
 drivers/thermal/Kconfig                            |    6 +-
 drivers/thermal/gov_user_space.c                   |    3 +-
 .../intel/int340x_thermal/int3400_thermal.c        |    4 +-
 drivers/thermal/thermal_sysfs.c                    |    3 -
 drivers/tty/n_gsm.c                                |  477 +++---
 drivers/tty/serial/8250/8250_pci.c                 |    8 +-
 drivers/tty/serial/8250/8250_port.c                |    6 +-
 drivers/tty/serial/amba-pl011.c                    |    9 +-
 drivers/tty/serial/imx.c                           |    2 +-
 drivers/tty/serial/sc16is7xx.c                     |    6 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |    7 +-
 drivers/usb/core/devio.c                           |   14 +-
 drivers/usb/core/quirks.c                          |    6 +
 drivers/usb/dwc3/core.c                            |   34 +-
 drivers/usb/dwc3/drd.c                             |   11 +-
 drivers/usb/dwc3/dwc3-pci.c                        |    8 +
 drivers/usb/dwc3/gadget.c                          |   31 +-
 drivers/usb/gadget/configfs.c                      |    2 +
 drivers/usb/gadget/function/uvc_queue.c            |    2 +
 drivers/usb/host/ehci-hcd.c                        |   23 +
 drivers/usb/host/ehci-pci.c                        |    4 +
 drivers/usb/host/ehci.h                            |    1 +
 drivers/usb/host/xhci-hub.c                        |    2 +-
 drivers/usb/host/xhci-pci.c                        |    4 +-
 drivers/usb/host/xhci-ring.c                       |    1 +
 drivers/usb/host/xhci-tegra.c                      |    4 +-
 drivers/usb/host/xhci.c                            |   11 +
 drivers/usb/misc/qcom_eud.c                        |   10 +-
 drivers/usb/misc/uss720.c                          |    3 +-
 drivers/usb/mtu3/mtu3_dr.c                         |    6 +-
 drivers/usb/phy/phy-generic.c                      |    7 +
 drivers/usb/serial/cp210x.c                        |    2 +
 drivers/usb/serial/option.c                        |   12 +
 drivers/usb/serial/whiteheat.c                     |    5 +-
 drivers/usb/typec/Kconfig                          |    1 +
 drivers/usb/typec/ucsi/ucsi.c                      |   24 +-
 drivers/vfio/mdev/Makefile                         |    2 +-
 drivers/vfio/mdev/mdev_core.c                      |   52 +-
 drivers/vfio/mdev/mdev_driver.c                    |   10 -
 drivers/vfio/mdev/mdev_private.h                   |    6 +-
 drivers/vfio/mdev/mdev_sysfs.c                     |   37 +-
 drivers/vfio/mdev/vfio_mdev.c                      |  152 --
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |   16 +-
 drivers/vfio/pci/mlx5/cmd.c                        |  236 ++-
 drivers/vfio/pci/mlx5/cmd.h                        |   52 +-
 drivers/vfio/pci/mlx5/main.c                       |  136 +-
 drivers/vfio/pci/vfio_pci.c                        |    6 +-
 drivers/vfio/pci/vfio_pci_config.c                 |   56 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  254 ++--
 drivers/vfio/vfio.c                                |  781 ++++------
 drivers/video/fbdev/arkfb.c                        |    3 +
 drivers/video/fbdev/aty/aty128fb.c                 |    1 -
 drivers/video/fbdev/aty/atyfb_base.c               |    1 -
 drivers/video/fbdev/aty/radeon_pm.c                |    1 -
 drivers/video/fbdev/aty/radeonfb.h                 |    2 +-
 drivers/video/fbdev/clps711x-fb.c                  |    3 +-
 drivers/video/fbdev/controlfb.c                    |    3 -
 drivers/video/fbdev/core/fbmem.c                   |    5 +-
 drivers/video/fbdev/i740fb.c                       |    5 +-
 drivers/video/fbdev/imxfb.c                        |    2 +
 drivers/video/fbdev/kyro/fbdev.c                   |    2 +
 drivers/video/fbdev/matrox/matroxfb_base.h         |    1 -
 drivers/video/fbdev/mb862xx/mb862xxfbdrv.c         |    2 +
 drivers/video/fbdev/mmp/core.c                     |   11 +-
 drivers/video/fbdev/neofb.c                        |    2 +-
 drivers/video/fbdev/omap/hwa742.c                  |    6 +-
 drivers/video/fbdev/omap/lcdc.c                    |    6 +-
 drivers/video/fbdev/omap/sossi.c                   |    5 +-
 drivers/video/fbdev/platinumfb.c                   |    2 +-
 drivers/video/fbdev/pm2fb.c                        |    8 +-
 drivers/video/fbdev/pxafb.c                        |    4 +-
 drivers/video/fbdev/s3fb.c                         |    3 +
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |    3 -
 drivers/video/fbdev/sis/sis_main.c                 |    2 +-
 drivers/video/fbdev/tridentfb.c                    |    3 +
 drivers/video/fbdev/udlfb.c                        |   14 +-
 drivers/video/fbdev/valkyriefb.c                   |    3 +-
 drivers/video/fbdev/vt8623fb.c                     |    3 +
 drivers/video/of_display_timing.c                  |    2 +-
 fs/btrfs/btrfs_inode.h                             |   11 +
 fs/btrfs/ctree.h                                   |    1 +
 fs/btrfs/dev-replace.c                             |    7 +-
 fs/btrfs/disk-io.c                                 |   12 +
 fs/btrfs/extent_io.c                               |   44 +-
 fs/btrfs/inode.c                                   |   33 +-
 fs/btrfs/props.c                                   |   59 +-
 fs/btrfs/props.h                                   |    4 +-
 fs/btrfs/scrub.c                                   |   26 +-
 fs/btrfs/sysfs.c                                   |    3 +
 fs/btrfs/tree-log.c                                |   54 +-
 fs/btrfs/volumes.h                                 |    3 +
 fs/btrfs/xattr.c                                   |   11 +-
 fs/btrfs/zoned.c                                   |   34 +-
 fs/btrfs/zoned.h                                   |    4 +-
 fs/ceph/caps.c                                     |    7 +
 fs/ceph/mds_client.c                               |    6 -
 fs/f2fs/checkpoint.c                               |    6 +-
 fs/f2fs/data.c                                     |   33 +-
 fs/f2fs/f2fs.h                                     |    9 -
 fs/f2fs/inode.c                                    |    3 +-
 fs/f2fs/segment.c                                  |   95 --
 fs/f2fs/super.c                                    |   32 +-
 fs/gfs2/file.c                                     |    6 +-
 fs/io_uring.c                                      |   14 +-
 fs/kernfs/dir.c                                    |    7 +-
 fs/nfs/nfs4proc.c                                  |   12 +-
 fs/xfs/xfs_buf.c                                   |    6 +-
 fs/xfs/xfs_buf.h                                   |   42 +-
 fs/xfs/xfs_inode.c                                 |   24 +-
 fs/xfs/xfs_trans.h                                 |    2 +-
 fs/zonefs/super.c                                  |   46 +-
 include/asm-generic/bug.h                          |   11 +-
 include/dt-bindings/clock/microchip,mpfs-clock.h   |    5 +-
 include/linux/bio.h                                |    5 +-
 include/linux/blk-mq.h                             |    1 -
 include/linux/cpu.h                                |    2 +-
 include/linux/kernel.h                             |    2 +-
 include/linux/mdev.h                               |   82 +-
 include/linux/mlx5/accel.h                         |   35 +-
 include/linux/mlx5/driver.h                        |   15 +-
 include/linux/mlx5/mlx5_ifc_fpga.h                 |  211 ---
 include/linux/mlx5/port.h                          |    2 +-
 include/linux/mtd/mtd.h                            |    6 +-
 include/linux/netdevice.h                          |   21 +-
 include/linux/stmmac.h                             |    1 +
 include/linux/sunrpc/clnt.h                        |    1 +
 include/linux/usb/pd_bdo.h                         |    2 +-
 include/linux/vfio.h                               |   44 +-
 include/linux/vfio_pci_core.h                      |    3 +-
 include/memory/renesas-rpc-if.h                    |    1 +
 include/net/bluetooth/hci.h                        |    1 +
 include/net/bluetooth/hci_core.h                   |    2 +-
 include/net/inet_hashtables.h                      |    2 +-
 include/net/ip6_tunnel.h                           |    2 +-
 include/net/ip_tunnels.h                           |    2 +-
 include/net/secure_seq.h                           |    4 +-
 include/net/tcp.h                                  |    8 +
 include/net/xsk_buff_pool.h                        |    1 +
 include/rdma/ib_verbs.h                            |    8 -
 include/uapi/linux/elf.h                           |    2 +-
 include/uapi/linux/fb.h                            |    2 +-
 include/uapi/linux/kvm.h                           |   10 +-
 include/uapi/linux/vfio.h                          |    4 +-
 kernel/fork.c                                      |    2 +-
 kernel/irq/internals.h                             |    2 +
 kernel/irq/irqdesc.c                               |    2 +
 kernel/irq/manage.c                                |   39 +-
 kernel/kprobes.c                                   |    2 +-
 kernel/time/timekeeping.c                          |    4 +-
 lib/hexdump.c                                      |   41 +-
 lib/strncpy_from_user.c                            |    2 +-
 lib/strnlen_user.c                                 |    2 +-
 mm/kasan/quarantine.c                              |    7 +
 mm/nommu.c                                         |    2 +
 mm/readahead.c                                     |   15 +-
 net/bluetooth/hci_conn.c                           |   32 +-
 net/bluetooth/hci_event.c                          |   80 +-
 net/bluetooth/hci_sync.c                           |   11 +-
 net/bpf/test_run.c                                 |    5 +-
 net/bridge/br_switchdev.c                          |    2 +
 net/can/isotp.c                                    |   25 +-
 net/ceph/osd_client.c                              |    6 +-
 net/core/dev.c                                     |   14 +-
 net/core/lwt_bpf.c                                 |    7 +-
 net/core/secure_seq.c                              |   16 +-
 net/dsa/port.c                                     |    2 +
 net/dsa/slave.c                                    |    2 +-
 net/ipv4/igmp.c                                    |    9 +-
 net/ipv4/inet_hashtables.c                         |   42 +-
 net/ipv4/ip_gre.c                                  |   12 +-
 net/ipv4/netfilter/nf_flow_table_ipv4.c            |    0
 net/ipv4/syncookies.c                              |    8 +-
 net/ipv4/tcp_input.c                               |   15 +-
 net/ipv4/tcp_minisocks.c                           |    2 +-
 net/ipv4/tcp_output.c                              |    1 +
 net/ipv4/tcp_rate.c                                |   11 +-
 net/ipv6/inet6_hashtables.c                        |    4 +-
 net/ipv6/ip6_gre.c                                 |   16 +-
 net/ipv6/mcast.c                                   |    8 +-
 net/ipv6/netfilter.c                               |   10 +-
 net/ipv6/syncookies.c                              |    3 +-
 net/mctp/device.c                                  |    2 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   21 +-
 net/netfilter/nf_conntrack_standalone.c            |    2 +-
 net/netfilter/nft_set_rbtree.c                     |    6 +-
 net/netfilter/nft_socket.c                         |   52 +-
 net/nfc/core.c                                     |   29 +-
 net/nfc/netlink.c                                  |    4 +-
 net/rds/tcp.c                                      |    8 +
 net/rxrpc/local_object.c                           |    3 +
 net/sctp/sm_sideeffect.c                           |    4 +
 net/smc/af_smc.c                                   |  137 +-
 net/smc/smc.h                                      |   29 +
 net/smc/smc_close.c                                |    5 +-
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |    2 +-
 net/sunrpc/clnt.c                                  |   14 +-
 net/sunrpc/xprtsock.c                              |   35 +-
 net/tls/tls_device.c                               |   12 +-
 net/xdp/xsk.c                                      |   15 +-
 net/xdp/xsk_buff_pool.c                            |   16 +-
 samples/vfio-mdev/mbochs.c                         |    9 +-
 samples/vfio-mdev/mdpy.c                           |    9 +-
 samples/vfio-mdev/mtty.c                           |   39 +-
 scripts/Makefile.build                             |    2 +-
 scripts/link-vmlinux.sh                            |    2 +-
 sound/firewire/fireworks/fireworks_hwdep.c         |    1 +
 sound/pci/hda/patch_realtek.c                      |   15 +-
 sound/soc/atmel/mchp-pdmc.c                        |    1 +
 sound/soc/codecs/da7219.c                          |   14 +-
 sound/soc/codecs/max98090.c                        |    5 +-
 sound/soc/codecs/rt9120.c                          |    1 -
 sound/soc/codecs/wm8958-dsp2.c                     |    8 +-
 sound/soc/generic/simple-card-utils.c              |    2 +-
 sound/soc/meson/aiu-acodec-ctrl.c                  |    2 +-
 sound/soc/meson/aiu-codec-ctrl.c                   |    2 +-
 sound/soc/meson/axg-card.c                         |    1 -
 sound/soc/meson/axg-tdm-interface.c                |   26 +-
 sound/soc/meson/g12a-tohdmitx.c                    |    2 +-
 sound/soc/soc-generic-dmaengine-pcm.c              |    6 +-
 sound/soc/soc-ops.c                                |   20 +-
 sound/soc/sof/sof-pci-dev.c                        |    5 +
 tools/objtool/check.c                              |   94 +-
 tools/objtool/elf.c                                |  189 ++-
 tools/objtool/include/objtool/elf.h                |    4 +-
 tools/objtool/include/objtool/objtool.h            |    2 +-
 tools/objtool/objtool.c                            |    1 -
 tools/perf/arch/arm64/util/arm-spe.c               |   10 +
 tools/perf/arch/arm64/util/machine.c               |   21 -
 tools/perf/arch/powerpc/util/Build                 |    1 -
 tools/perf/arch/powerpc/util/machine.c             |   25 -
 tools/perf/arch/s390/util/machine.c                |   16 -
 tools/perf/tests/attr/README                       |    1 +
 .../tests/attr/test-record-spe-physical-address    |   12 +
 tools/perf/util/arm-spe.c                          |    5 +-
 tools/perf/util/session.c                          |    2 +-
 tools/perf/util/symbol-elf.c                       |    2 +-
 tools/perf/util/symbol.c                           |   37 +-
 tools/perf/util/symbol.h                           |    3 +-
 tools/power/x86/intel-speed-select/Makefile        |    2 +-
 .../drivers/net/ocelot/tc_flower_chains.sh         |    2 +-
 tools/testing/selftests/net/Makefile               |    3 +-
 tools/testing/selftests/net/forwarding/Makefile    |   33 +
 .../net/forwarding/mirror_gre_bridge_1q.sh         |    3 +
 tools/testing/selftests/net/so_txtime.c            |    4 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   10 +-
 tools/testing/selftests/wireguard/netns.sh         |   34 +-
 tools/testing/selftests/wireguard/qemu/.gitignore  |    1 +
 tools/testing/selftests/wireguard/qemu/Makefile    |  205 ++-
 .../selftests/wireguard/qemu/arch/aarch64.config   |    5 +-
 .../wireguard/qemu/arch/aarch64_be.config          |    5 +-
 .../selftests/wireguard/qemu/arch/arm.config       |    5 +-
 .../selftests/wireguard/qemu/arch/armeb.config     |    5 +-
 .../selftests/wireguard/qemu/arch/i686.config      |    3 +-
 .../selftests/wireguard/qemu/arch/m68k.config      |    2 +-
 .../selftests/wireguard/qemu/arch/mips.config      |    2 +-
 .../selftests/wireguard/qemu/arch/mips64.config    |    2 +-
 .../selftests/wireguard/qemu/arch/mips64el.config  |    2 +-
 .../selftests/wireguard/qemu/arch/mipsel.config    |    2 +-
 .../selftests/wireguard/qemu/arch/powerpc.config   |    2 +-
 .../selftests/wireguard/qemu/arch/powerpc64.config |   13 +
 .../wireguard/qemu/arch/powerpc64le.config         |    2 +-
 .../selftests/wireguard/qemu/arch/riscv32.config   |   12 +
 .../selftests/wireguard/qemu/arch/riscv64.config   |   12 +
 .../selftests/wireguard/qemu/arch/s390x.config     |    6 +
 .../selftests/wireguard/qemu/arch/x86_64.config    |    3 +-
 tools/testing/selftests/wireguard/qemu/init.c      |    6 -
 virt/kvm/kvm_main.c                                |    1 +
 virt/kvm/vfio.c                                    |  329 ++--
 702 files changed, 9040 insertions(+), 12665 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gvt/gvt.c
 delete mode 100644 drivers/gpu/drm/i915/gvt/hypercall.h
 delete mode 100644 drivers/gpu/drm/i915/gvt/mpt.h
 create mode 100644 drivers/gpu/drm/i915/intel_gvt_mmio_table.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
 rename drivers/net/ethernet/mellanox/mlx5/core/{accel => en_accel}/ipsec_offload.c (84%)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
 rename drivers/net/ethernet/mellanox/mlx5/core/en_accel/{tls_stats.c => ktls_stats.c} (63%)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h
 delete mode 100644 drivers/vfio/mdev/vfio_mdev.c
 delete mode 100644 net/ipv4/netfilter/nf_flow_table_ipv4.c
 delete mode 100644 tools/perf/arch/powerpc/util/machine.c
 create mode 100644 tools/perf/tests/attr/test-record-spe-physical-address
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/powerpc64.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/riscv32.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/riscv64.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/s390x.config

