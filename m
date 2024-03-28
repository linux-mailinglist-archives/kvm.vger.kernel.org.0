Return-Path: <kvm+bounces-13019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94D28890295
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 16:04:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8628EB235A4
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 15:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACE712D21F;
	Thu, 28 Mar 2024 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b28V5b0q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04DE7D417
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 15:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711638238; cv=none; b=pYw1fjD7328OcuyBeHXzdPpeRc5IfettUHYnw5e/TdKxscpWgGBYaYEFzRARrb5RcIXaw50DJMZtxdZbvbvdCrRWiDFhy1RQKGJQccMHRqKV7TXcT7X+IyGnAAWOUJJ4ruTOPLJhjTAShlzuWBoq9B+YeIsDfKY/m+hdi1Kp2GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711638238; c=relaxed/simple;
	bh=gJHZ46h8jHWVRXzxUbrEFp1Bi2yWWykv7eE+mdolLJY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SD9i6UqUyBr0K76JGuyjCmOf8uY5g93mWile0KOOKVp9aeymmjWDsv6A4b8aqp9qECl9Nxy9Oy9dK+xp/BVBidC1mLDLw0oG2AksAxDWxAIMDdydE0AclWZf8BeHP/p2tvbP4JywN08V1SRmGgytrR7uHGNk9/Al9oT3ZH84KzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b28V5b0q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711638234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDanVVD4Yszv4zW65N/qyFiX7XqJVAu3Bm8+wTDV9/o=;
	b=b28V5b0qLdr7FAv6hH10E+/1EflBxm6eAAiZVMKkmgOcVWWc+b9U+DSh/sYyrkOx4sFAVe
	+veCar/9Mbc9Up4zOi+QPz5HcLZ+b9iZ4DvrufIKNX/Gou4UWIXg3SK6yxxvKDyatKPGaL
	65Z+67l5QFuWE9QOUk1HdLmPQMSq05Q=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-5PWDdwPIMs2QcnyxCV1QuA-1; Thu, 28 Mar 2024 11:03:53 -0400
X-MC-Unique: 5PWDdwPIMs2QcnyxCV1QuA-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7c8a98e52b5so76582439f.1
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 08:03:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711638232; x=1712243032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZDanVVD4Yszv4zW65N/qyFiX7XqJVAu3Bm8+wTDV9/o=;
        b=PfcoErPNDwqUcaWR9USJeYEPdH3pQOReNNcgkXIO3QDsM0fh2D3sMK4iaM6DgXp9Jx
         nbNDYkX7sq63o5OLkDMG13akOB/oISBDraKDbVm4R8CDOgd0o5SPhMY1cq72SfmEEZlz
         XeKEFPP1EXJj9WU7oH+0s1TSCNgyIUeL8UZQ9MQD5ptLA1ek+y1FTXQB/S/zpadkT4bR
         FW7RKZbC1J9tSFORDlZ7rFM8Er3Shw6l7ZbiTn+A0z7j7KJ+jxf3DqhiiLusg/2dfg8y
         hNSjPy/JzOSwBSA5S5VioBZb53O9CgCWHNhpDEICdHmw8htovk0XgTT7wHYrZyMCYa/4
         aJWA==
X-Forwarded-Encrypted: i=1; AJvYcCUlvBalbXm7HonZlRYO8fvyifk1sT9mb1qys5Ks2kj/9rqcq2nelUBnWmREqnjOLkKGB5s131Gmxke0IJ/bjwQZdX/b
X-Gm-Message-State: AOJu0YxT90GHvdSmKfGApvVizQW3SMBb9Nh3nLX3/Lyb5WbQV9l1Uanz
	Z83OfsHyAywIrBjJpD73Gn4O8b1FTMzHxw4/G29NVJVJr/hMIDvnYh1QmIzmMUxhTzml4VVv37t
	n9U1AhW/WY7TdWIKOabDZa8MZqsbzlw0wWTBhwujDTEgDBP1jUA==
X-Received: by 2002:a92:cd50:0:b0:368:98c2:fcaf with SMTP id v16-20020a92cd50000000b0036898c2fcafmr2565221ilq.0.1711638232266;
        Thu, 28 Mar 2024 08:03:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpTaDo//5WNLD+81yRkJrCSOR0W6wX23ZmAkwthAWMBbBiuFpz6SS/AzrpkI37HUCjEmei4A==
X-Received: by 2002:a92:cd50:0:b0:368:98c2:fcaf with SMTP id v16-20020a92cd50000000b0036898c2fcafmr2565202ilq.0.1711638231996;
        Thu, 28 Mar 2024 08:03:51 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id h8-20020a02c4c8000000b0047bee4d297asm402412jaj.155.2024.03.28.08.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 08:03:51 -0700 (PDT)
Date: Thu, 28 Mar 2024 09:03:49 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Xin Zeng <xin.zeng@intel.com>, jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v5 00/10] crypto: qat - enable QAT GEN4 SRIOV VF live
 migration for QAT GEN4
Message-ID: <20240328090349.4f18cb36.alex.williamson@redhat.com>
In-Reply-To: <ZgVLvdhhU6o7sJwF@gondor.apana.org.au>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
	<ZgVLvdhhU6o7sJwF@gondor.apana.org.au>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 Mar 2024 18:51:41 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Mar 06, 2024 at 09:58:45PM +0800, Xin Zeng wrote:
> > This set enables live migration for Intel QAT GEN4 SRIOV Virtual
> > Functions (VFs).
> > It is composed of 10 patches. Patch 1~6 refactor the original QAT PF
> > driver implementation which will be reused by the following patches.
> > Patch 7 introduces the logic to the QAT PF driver that allows to save
> > and restore the state of a bank (a QAT VF is a wrapper around banks) and
> > drain a ring pair. Patch 8 adds the QAT PF driver a set of interfaces to
> > allow to save and restore the state of a VF that will be called by the
> > module qat_vfio_pci which will be introduced in the last patch. Patch 9
> > implements the defined device interfaces. The last one adds a vfio pci
> > extension specific for QAT which intercepts the vfio device operations
> > for a QAT VF to allow live migration.
> > 
> > Here are the steps required to test the live migration of a QAT GEN4 VF:
> > 1. Bind one or more QAT GEN4 VF devices to the module qat_vfio_pci.ko 
> > 2. Assign the VFs to the virtual machine and enable device live
> > migration 
> > 3. Run a workload using a QAT VF inside the VM, for example using qatlib
> > (https://github.com/intel/qatlib) 
> > 4. Migrate the VM from the source node to a destination node
> > 
> > Changes in v5 since v4: https://lore.kernel.org/kvm/20240228143402.89219-9-xin.zeng@intel.com
> > -  Remove device ID recheck as no consensus has been reached yet (Kevin)
> > -  Add missing state PRE_COPY_P2P in precopy_iotcl (Kevin)
> > -  Rearrange the state transition flow for better readability (Kevin)
> > -  Remove unnecessary Reviewed-by in commit message (Kevin)
> > 
> > Changes in v4 since v3: https://lore.kernel.org/kvm/20240221155008.960369-11-xin.zeng@intel.com
> > -  Change the order of maintainer entry for QAT vfio pci driver in
> >    MAINTAINERS to make it alphabetical (Alex)
> > -  Put QAT VFIO PCI driver under vfio/pci directly instead of
> >    vfio/pci/intel (Alex)
> > -  Add id_table recheck during device probe (Alex)
> > 
> > Changes in v3 since v2: https://lore.kernel.org/kvm/20240220032052.66834-1-xin.zeng@intel.com
> > -  Use state_mutex directly instead of unnecessary deferred_reset mode
> >    (Jason)
> > 
> > Changes in v2 since v1: https://lore.kernel.org/all/20240201153337.4033490-1-xin.zeng@intel.com
> > -  Add VFIO_MIGRATION_PRE_COPY support (Alex)
> > -  Remove unnecessary module dependancy in Kconfig (Alex)
> > -  Use direct function calls instead of function pointers in qat vfio
> >    variant driver (Jason)
> > -  Address the comments including uncessary pointer check and kfree,
> >    missing lock and direct use of pci_iov_vf_id (Shameer)
> > -  Change CHECK_STAT macro to avoid repeat comparison (Kamlesh)
> > 
> > Changes in v1 since RFC: https://lore.kernel.org/all/20230630131304.64243-1-xin.zeng@intel.com
> > -  Address comments including the right module dependancy in Kconfig,
> >    source file name and module description (Alex)
> > -  Added PCI error handler and P2P state handler (Suggested by Kevin)
> > -  Refactor the state check duing loading ring state (Kevin) 
> > -  Fix missed call to vfio_put_device in the error case (Breet)
> > -  Migrate the shadow states in PF driver
> > -  Rebase on top of 6.8-rc1
> > 
> > Giovanni Cabiddu (2):
> >   crypto: qat - adf_get_etr_base() helper
> >   crypto: qat - relocate CSR access code
> > 
> > Siming Wan (3):
> >   crypto: qat - rename get_sla_arr_of_type()
> >   crypto: qat - expand CSR operations for QAT GEN4 devices
> >   crypto: qat - add bank save and restore flows
> > 
> > Xin Zeng (5):
> >   crypto: qat - relocate and rename 4xxx PF2VM definitions
> >   crypto: qat - move PFVF compat checker to a function
> >   crypto: qat - add interface for live migration
> >   crypto: qat - implement interface for live migration
> >   vfio/qat: Add vfio_pci driver for Intel QAT VF devices
> > 
> >  MAINTAINERS                                   |    8 +
> >  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |    3 +
> >  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |    5 +
> >  .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |    1 +
> >  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |    1 +
> >  .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |    1 +
> >  .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c |    1 +
> >  drivers/crypto/intel/qat/qat_common/Makefile  |    6 +-
> >  .../intel/qat/qat_common/adf_accel_devices.h  |   88 ++
> >  .../intel/qat/qat_common/adf_common_drv.h     |   10 +
> >  .../qat/qat_common/adf_gen2_hw_csr_data.c     |  101 ++
> >  .../qat/qat_common/adf_gen2_hw_csr_data.h     |   86 ++
> >  .../intel/qat/qat_common/adf_gen2_hw_data.c   |   97 --
> >  .../intel/qat/qat_common/adf_gen2_hw_data.h   |   76 --
> >  .../qat/qat_common/adf_gen4_hw_csr_data.c     |  231 ++++
> >  .../qat/qat_common/adf_gen4_hw_csr_data.h     |  188 +++
> >  .../intel/qat/qat_common/adf_gen4_hw_data.c   |  380 +++++--
> >  .../intel/qat/qat_common/adf_gen4_hw_data.h   |  127 +--
> >  .../intel/qat/qat_common/adf_gen4_pfvf.c      |    8 +-
> >  .../intel/qat/qat_common/adf_gen4_vf_mig.c    | 1010 +++++++++++++++++
> >  .../intel/qat/qat_common/adf_gen4_vf_mig.h    |   10 +
> >  .../intel/qat/qat_common/adf_mstate_mgr.c     |  318 ++++++
> >  .../intel/qat/qat_common/adf_mstate_mgr.h     |   89 ++
> >  .../intel/qat/qat_common/adf_pfvf_pf_proto.c  |    8 +-
> >  .../intel/qat/qat_common/adf_pfvf_utils.h     |   11 +
> >  drivers/crypto/intel/qat/qat_common/adf_rl.c  |   10 +-
> >  drivers/crypto/intel/qat/qat_common/adf_rl.h  |    2 +
> >  .../crypto/intel/qat/qat_common/adf_sriov.c   |    7 +-
> >  .../intel/qat/qat_common/adf_transport.c      |    4 +-
> >  .../crypto/intel/qat/qat_common/qat_mig_dev.c |  130 +++
> >  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |    1 +
> >  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |    1 +
> >  drivers/vfio/pci/Kconfig                      |    2 +
> >  drivers/vfio/pci/Makefile                     |    2 +
> >  drivers/vfio/pci/qat/Kconfig                  |   12 +
> >  drivers/vfio/pci/qat/Makefile                 |    3 +
> >  drivers/vfio/pci/qat/main.c                   |  662 +++++++++++
> >  include/linux/qat/qat_mig_dev.h               |   31 +
> >  38 files changed, 3344 insertions(+), 387 deletions(-)
> >  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.c
> >  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.h
> >  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c
> >  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h
> >  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
> >  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.h
> >  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
> >  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.h
> >  create mode 100644 drivers/crypto/intel/qat/qat_common/qat_mig_dev.c
> >  create mode 100644 drivers/vfio/pci/qat/Kconfig
> >  create mode 100644 drivers/vfio/pci/qat/Makefile
> >  create mode 100644 drivers/vfio/pci/qat/main.c
> >  create mode 100644 include/linux/qat/qat_mig_dev.h
> > 
> > 
> > base-commit: 318407ed77e4140d02e43a001b1f4753e3ce6b5f
> > -- 
> > 2.18.2  
> 
> Patches 1-9 applied.  Thanks.

Hi Herbert,

Would you mind making a branch available for those in anticipation of
the qat vfio variant driver itself being merged through the vfio tree?
Thanks,

Alex


