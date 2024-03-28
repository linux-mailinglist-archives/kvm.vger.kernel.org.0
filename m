Return-Path: <kvm+bounces-12999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC3C088FD6D
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 11:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51E72B247B9
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C4C37D3E4;
	Thu, 28 Mar 2024 10:51:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1704A57334;
	Thu, 28 Mar 2024 10:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711623111; cv=none; b=Gif7kgzP2RPlyHoFu7Ok660LdtgkvrQb2ibQW2yI2RRrMX7v3EWazAFutCymVP5BRt/DWToFK0+uf9YtnIagAMErRnnAH5AYRQeKRnDXXOzLls+PAToVvM7Y0nFCfyDeeUoec5Js3XqlKFe8id93K3hwka4f1Zysx0AUP5p0fNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711623111; c=relaxed/simple;
	bh=YUac/5Z48Bc82q0skhz4hUdvU/QrE+zgJ4gLeiHGHe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cOuo3XZJM9vKQ5EZacBUg01aHMzonICuxC+2Hp3d1hMxwBjtg9RvBagcD9t1TALt0Ae/X9PqGvzGmjsr7ANDjKTqBfCWht9qP2gWzWdpU//gZLdLFi2ZLN/Ei+xO5fCTpAS7y5m3aFo+ai7i5VS3vN2hyNGvV2PqpHpykUmqcys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rpnLw-00C8Ms-DS; Thu, 28 Mar 2024 18:51:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 28 Mar 2024 18:51:41 +0800
Date: Thu, 28 Mar 2024 18:51:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Xin Zeng <xin.zeng@intel.com>
Cc: alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	qat-linux@intel.com
Subject: Re: [PATCH v5 00/10] crypto: qat - enable QAT GEN4 SRIOV VF live
 migration for QAT GEN4
Message-ID: <ZgVLvdhhU6o7sJwF@gondor.apana.org.au>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306135855.4123535-1-xin.zeng@intel.com>

On Wed, Mar 06, 2024 at 09:58:45PM +0800, Xin Zeng wrote:
> This set enables live migration for Intel QAT GEN4 SRIOV Virtual
> Functions (VFs).
> It is composed of 10 patches. Patch 1~6 refactor the original QAT PF
> driver implementation which will be reused by the following patches.
> Patch 7 introduces the logic to the QAT PF driver that allows to save
> and restore the state of a bank (a QAT VF is a wrapper around banks) and
> drain a ring pair. Patch 8 adds the QAT PF driver a set of interfaces to
> allow to save and restore the state of a VF that will be called by the
> module qat_vfio_pci which will be introduced in the last patch. Patch 9
> implements the defined device interfaces. The last one adds a vfio pci
> extension specific for QAT which intercepts the vfio device operations
> for a QAT VF to allow live migration.
> 
> Here are the steps required to test the live migration of a QAT GEN4 VF:
> 1. Bind one or more QAT GEN4 VF devices to the module qat_vfio_pci.ko 
> 2. Assign the VFs to the virtual machine and enable device live
> migration 
> 3. Run a workload using a QAT VF inside the VM, for example using qatlib
> (https://github.com/intel/qatlib) 
> 4. Migrate the VM from the source node to a destination node
> 
> Changes in v5 since v4: https://lore.kernel.org/kvm/20240228143402.89219-9-xin.zeng@intel.com
> -  Remove device ID recheck as no consensus has been reached yet (Kevin)
> -  Add missing state PRE_COPY_P2P in precopy_iotcl (Kevin)
> -  Rearrange the state transition flow for better readability (Kevin)
> -  Remove unnecessary Reviewed-by in commit message (Kevin)
> 
> Changes in v4 since v3: https://lore.kernel.org/kvm/20240221155008.960369-11-xin.zeng@intel.com
> -  Change the order of maintainer entry for QAT vfio pci driver in
>    MAINTAINERS to make it alphabetical (Alex)
> -  Put QAT VFIO PCI driver under vfio/pci directly instead of
>    vfio/pci/intel (Alex)
> -  Add id_table recheck during device probe (Alex)
> 
> Changes in v3 since v2: https://lore.kernel.org/kvm/20240220032052.66834-1-xin.zeng@intel.com
> -  Use state_mutex directly instead of unnecessary deferred_reset mode
>    (Jason)
> 
> Changes in v2 since v1: https://lore.kernel.org/all/20240201153337.4033490-1-xin.zeng@intel.com
> -  Add VFIO_MIGRATION_PRE_COPY support (Alex)
> -  Remove unnecessary module dependancy in Kconfig (Alex)
> -  Use direct function calls instead of function pointers in qat vfio
>    variant driver (Jason)
> -  Address the comments including uncessary pointer check and kfree,
>    missing lock and direct use of pci_iov_vf_id (Shameer)
> -  Change CHECK_STAT macro to avoid repeat comparison (Kamlesh)
> 
> Changes in v1 since RFC: https://lore.kernel.org/all/20230630131304.64243-1-xin.zeng@intel.com
> -  Address comments including the right module dependancy in Kconfig,
>    source file name and module description (Alex)
> -  Added PCI error handler and P2P state handler (Suggested by Kevin)
> -  Refactor the state check duing loading ring state (Kevin) 
> -  Fix missed call to vfio_put_device in the error case (Breet)
> -  Migrate the shadow states in PF driver
> -  Rebase on top of 6.8-rc1
> 
> Giovanni Cabiddu (2):
>   crypto: qat - adf_get_etr_base() helper
>   crypto: qat - relocate CSR access code
> 
> Siming Wan (3):
>   crypto: qat - rename get_sla_arr_of_type()
>   crypto: qat - expand CSR operations for QAT GEN4 devices
>   crypto: qat - add bank save and restore flows
> 
> Xin Zeng (5):
>   crypto: qat - relocate and rename 4xxx PF2VM definitions
>   crypto: qat - move PFVF compat checker to a function
>   crypto: qat - add interface for live migration
>   crypto: qat - implement interface for live migration
>   vfio/qat: Add vfio_pci driver for Intel QAT VF devices
> 
>  MAINTAINERS                                   |    8 +
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |    3 +
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |    5 +
>  .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |    1 +
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |    1 +
>  .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |    1 +
>  .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c |    1 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |    6 +-
>  .../intel/qat/qat_common/adf_accel_devices.h  |   88 ++
>  .../intel/qat/qat_common/adf_common_drv.h     |   10 +
>  .../qat/qat_common/adf_gen2_hw_csr_data.c     |  101 ++
>  .../qat/qat_common/adf_gen2_hw_csr_data.h     |   86 ++
>  .../intel/qat/qat_common/adf_gen2_hw_data.c   |   97 --
>  .../intel/qat/qat_common/adf_gen2_hw_data.h   |   76 --
>  .../qat/qat_common/adf_gen4_hw_csr_data.c     |  231 ++++
>  .../qat/qat_common/adf_gen4_hw_csr_data.h     |  188 +++
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   |  380 +++++--
>  .../intel/qat/qat_common/adf_gen4_hw_data.h   |  127 +--
>  .../intel/qat/qat_common/adf_gen4_pfvf.c      |    8 +-
>  .../intel/qat/qat_common/adf_gen4_vf_mig.c    | 1010 +++++++++++++++++
>  .../intel/qat/qat_common/adf_gen4_vf_mig.h    |   10 +
>  .../intel/qat/qat_common/adf_mstate_mgr.c     |  318 ++++++
>  .../intel/qat/qat_common/adf_mstate_mgr.h     |   89 ++
>  .../intel/qat/qat_common/adf_pfvf_pf_proto.c  |    8 +-
>  .../intel/qat/qat_common/adf_pfvf_utils.h     |   11 +
>  drivers/crypto/intel/qat/qat_common/adf_rl.c  |   10 +-
>  drivers/crypto/intel/qat/qat_common/adf_rl.h  |    2 +
>  .../crypto/intel/qat/qat_common/adf_sriov.c   |    7 +-
>  .../intel/qat/qat_common/adf_transport.c      |    4 +-
>  .../crypto/intel/qat/qat_common/qat_mig_dev.c |  130 +++
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |    1 +
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |    1 +
>  drivers/vfio/pci/Kconfig                      |    2 +
>  drivers/vfio/pci/Makefile                     |    2 +
>  drivers/vfio/pci/qat/Kconfig                  |   12 +
>  drivers/vfio/pci/qat/Makefile                 |    3 +
>  drivers/vfio/pci/qat/main.c                   |  662 +++++++++++
>  include/linux/qat/qat_mig_dev.h               |   31 +
>  38 files changed, 3344 insertions(+), 387 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/qat_mig_dev.c
>  create mode 100644 drivers/vfio/pci/qat/Kconfig
>  create mode 100644 drivers/vfio/pci/qat/Makefile
>  create mode 100644 drivers/vfio/pci/qat/main.c
>  create mode 100644 include/linux/qat/qat_mig_dev.h
> 
> 
> base-commit: 318407ed77e4140d02e43a001b1f4753e3ce6b5f
> -- 
> 2.18.2

Patches 1-9 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

