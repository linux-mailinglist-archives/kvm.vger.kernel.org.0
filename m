Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C3976249A
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 23:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjGYVlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 17:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjGYVlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 17:41:24 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5891FD2;
        Tue, 25 Jul 2023 14:41:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFwiYT1uxy/enn1B9z5xMAnNPLJqu/pwUKj43cnFdLeK7dFRYy0cQWSVsgajf+A+oHHhSzOyhisuSZQDPniFhDngjNVA/241DfRRZtZ4QuZ8bV/co6iMGl5eUsFl0rk0nqrU1j6EpV56je38eLhoVjvuMguO1IwelQagtklL6Biq/1B/GKOjiC4NJsjIGiUjkQN3uzH5r9M41cUErztLImjjymy5RJOtZ3g5UToNnXimw2Tnd18wIIb5Zb725DVgmBWV1pIkxMRIFL6vySbeJBPKZcYBKBqubBDn/wvQpruJ3PPKDL2bRUOcxQFhjbU/izR5dKXPJldA5OsokrdH8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X9KyUMYVGi4RONHBOTgHPOCYsmgLnv1+aY5mdyLtV+g=;
 b=F9jqex5rcE6wV3Tp+4p7rBTtetce0c6rNLR6sh97R8N7d8+/DuZm4dJlVbt/wLVkUiJBAQ3J7Yw6c+jzsSXGeIA7jM60kIKhDQB9d1VmoccYBoaj+bDrjxh09YLhXKrto0o6Wz2kgsAWeDG3iNJeNgQuxH/2zatxoKHCgCdaFuqlz2MDBH7iUpN9qIIUoOXuC/uiFackfkYvf4niF1tehvYu7DWjt5SmIETJXNZrt8rKoAUNwa+Dppb/IkekwMx//G2PRip+aJU+DRxuEexwrE8UG0OOTCGWp4KNOqiSFJUZxcvMJqB3cUO4RVM0ycTGkePd4sbqbKVSj2z5p86mFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9KyUMYVGi4RONHBOTgHPOCYsmgLnv1+aY5mdyLtV+g=;
 b=FIEJu9zSKe6MMjlwgo+eVO/eEYdTS9D2STKYne5daE+vqc1zfGkg1HM3N3qHtZzhOTWF1myJP4DsVKm1ccrVZ6SjE+W/0fvr+ZkObRrLedH6sNmZF87BVz8uP5PsBFTyp5Ye9qNAdq83KwN7AuJ0mcQ2T/7jP8HCQYJIr4oAIG4=
Received: from BN9P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::17)
 by SN7PR12MB6930.namprd12.prod.outlook.com (2603:10b6:806:262::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 21:41:19 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::42) by BN9P220CA0012.outlook.office365.com
 (2603:10b6:408:13e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33 via Frontend
 Transport; Tue, 25 Jul 2023 21:41:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6631.29 via Frontend Transport; Tue, 25 Jul 2023 21:41:19 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 25 Jul
 2023 16:40:35 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <simon.horman@corigine.com>, <brett.creeley@amd.com>,
        <shannon.nelson@amd.com>
Subject: [PATCH v13 vfio 0/7] pds-vfio-pci driver
Date:   Tue, 25 Jul 2023 14:40:18 -0700
Message-ID: <20230725214025.9288-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT055:EE_|SN7PR12MB6930:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c7b6ab3-1b4c-44b4-6fdd-08db8d57e1e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +e0+QvMx3aKqiYEP/cN+1z/JyWw7rJbYxA0D+fZqa4HWJPqUSjJg7RAQeahtR3D5/uDxObPIXrp3vr0n7HZqFa/6334pahlbwXlTTojZ+VW2XUuwippg59urZOkaOo29ojQSc+hHO2wshD9mtt9tdzv9CXXTqh9sqpx9FeUJJlO/ixD2UcV4BWp6+nBVdaTPYNwMdAOJEfTXNzovO4PmugLBg/CPnjo61WqiQj5KGHA9vtNb7xkYjvADFariTxotvcserU6Sjx1hpDcewvsXKYvs7kAXRc6h625i6T7rfJ3WhqL/PDKqdaBId8nljw1GZ0UoberOCUym45yJ9tNYUEzdMN5pFx4vKLJ+44Ma11C3zK+RL6DBATumaAYqLieUWPTHBB/18KGkw3HvCQo6N3yEx43LDWhjcPYff5a2kHWumfvEHvSsKQWIUTSz2WlOIWAk4V8O2gW2fUaURbP/3ASak5KsUxk0eEkw5NH8zkNTS2bTEfSWrmj7urEicLh5Yld0fsXZ9wNB6nGYeFyMNRWKL+09x2ybKEFbpALIX3wJSZ5ioNC9eMdUT3KCSudFhczuumdv/IPauIY578F0TRosvJNGqQ0ovqrcnJqlOMBPmuWIyU2fqIcRkUYndPqs3nmwnZ1unqMCRB1dJJVuIjX5dciZVbssPjblRM0KAnrnwFeY3kVg5vly/U298r+Cy2Q9EBNhLBBw/15TT+POz/BgWQTUF6ILlDtTZSrFW6tARbeq8fN2bhw411pi34ClWaLUjbVHiP+uL/q795/xgDwnU6Z4UBnJtnn+qnQq4WfJc595AU00dl3cS9tuKnhICPenHqB5ZLdCFp7mzB//EQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199021)(82310400008)(40470700004)(46966006)(36840700001)(966005)(110136005)(54906003)(6666004)(478600001)(16526019)(186003)(336012)(426003)(1076003)(2616005)(2906002)(44832011)(30864003)(26005)(41300700001)(8936002)(5660300002)(4326008)(8676002)(70206006)(81166007)(316002)(82740400003)(70586007)(356005)(86362001)(47076005)(83380400001)(40460700003)(36860700001)(36756003)(40480700001)(333604002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 21:41:19.4366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c7b6ab3-1b4c-44b4-6fdd-08db8d57e1e8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6930
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a patchset for a new vendor specific VFIO driver
(pds-vfio-pci) for use with the AMD/Pensando Distributed Services
Card (DSC). This driver makes use of the pds_core driver.

This driver will use the pds_core device's adminq as the VFIO
control path to the DSC. In order to make adminq calls, the VFIO
instance makes use of functions exported by the pds_core driver.

In order to receive events from pds_core, the pds-vfio-pci driver
registers to a private notifier. This is needed for various events
that come from the device.

An ASCII diagram of a VFIO instance looks something like this and can
be used with the VFIO subsystem to provide the VF device VFIO and live
migration support.

                               .------.  .-----------------------.
                               | QEMU |--|  VM  .-------------.  |
                               '......'  |      |   Eth VF    |  |
                                  |      |      .-------------.  |
                                  |      |      |  SR-IOV VF  |  |
                                  |      |      '-------------'  |
                                  |      '------------||---------'
                               .--------------.       ||
                               |/dev/<vfio_fd>|       ||
                               '--------------'       ||
Host Userspace                         |              ||
===================================================   ||
Host Kernel                            |              ||
                                  .--------.          ||
                                  |vfio-pci|          ||
                                  '--------'          ||
       .------------------.           ||              ||
       |   | exported API |<----+     ||              ||
       |   '--------------|     |     ||              ||
       |                  |    .--------------.       ||
       |     pds_core     |--->| pds-vfio-pci |       ||
       '------------------' |  '--------------'       ||
               ||           |         ||              ||
             09:00.0     notifier    09:00.1          ||
== PCI ===============================================||=====
               ||                     ||              ||
          .----------.          .----------.          ||
    ,-----|    PF    |----------|    VF    |-------------------,
    |     '----------'         |'----------'         VF        |
    |                     DSC  |                 data/control  |
    |                          |                     path      |
    -----------------------------------------------------------

The pds-vfio-pci driver is targeted to reside in drivers/vfio/pci/pds.
It makes use of and introduces new files in the common include/linux/pds
include directory.

Note: This series is based on the latest linux-next tree. I did not base
it on the Alex Williamson's vfio/next because it has not yet pulled in
the latest changes which include the pds_vdpa driver. The pds_vdpa
driver has conflicts with the pds-vfio-pci driver that needed to be
resolved, which is why this series is based on the latest linux-next
tree.

Changes:

v13:
- Various fixes/suggestions by Kevin Tian:
	- Fix commit message for patch 1/7
	- Re-order pds_vfio_init_device() so no unrolling of
	  vfio_pci_core_init_dev() is necessary
	- Update #define to align with live migration via VFIO
	- Change dev_info() to dev_err() on a failed AQ command
	- Rename AQ command from PDS_LM_CMD_STATUS to PDS_LM_CMD_STATE_SIZE
	  and rename the associated structures
- Various fixes/suggestions by Simon Horman:
	- Fix RCT issue
	- Don't check for null before calling vfree()

v12:
https://lore.kernel.org/netdev/20230719223527.12795-1-brett.creeley@amd.com/
- Fix htmldocs issue reported by Simon Horman

v11:
https://lore.kernel.org/netdev/20230713003727.11226-1-brett.creeley@amd.com/
- Various fixes/suggestions by Kevin Tian:
	- Update commit message on patch 1/7 to mention ethernet VF
	- Fix formatting
	- Check return of pci_iov_vf_id() for error
	- Update MODULE_AUTHOR to be myself
	- Remove double print of pci_id
	- Set fast_poll=true for PDS_LM_CMD_RESUME
	- Update comments around SUSPEND and SUSPEND_STATUS operations
	- Get rid of pds_vfio_deferred_reset() and just perform the
	  operations inline to the only caller
	- Rework pds_vfio_state_mutex_unlock() to be simpler
	- Rework comments in pds_vfio_recovery()
	- Append "vfio" to the end of PDS_LM_DEV_NAME
	- Remove req_len from pds_vfio_client_adminq_cmd()
	- Remove unused completion structures in pds_adminq.h
	- Fix comment above creating VFs to specify pds_core as the PF
	  device
- Various fixes/suggestions by Alex Williamson:
	- Removed cached pci_id from pds_vfio_device structure
	- Rename from pds_vfio to pds-vfio-pci
- Various fixes/suggestions by  Shameerali Kolothum Thodi:
	- Fix checking return of pds_client_register()
	- Use bool argument for flags instead of u64 on
	  pds_vfio_client_adminq_cmd()
- Fix support for VFIO_MIGRATION_P2P
- Improve member name alignment in pds_adminq.h
- Rework Kconfig based on latest changes from Alex Williamson

v10:
https://lore.kernel.org/netdev/1b5bb4df-df6f-65af-df05-08f1a4b3dacf@amd.com/
- Various fixes/suggestions by Jason Gunthorpe
	- Simplify pds_vfio_get_lm_file() based on fpga_mgr_buf_load()
	- Clean-ups/fixes based on clang-format
	- Remove any double goto labels
	- Name goto labels baesed on what needs to be cleaned/freed
	  instead of a "call from" scheme
	- Fix any goto unwind ordering issues
	- Make sure call dma_map_single() after data is written to
	  memory in pds_vfio_dma_map_lm_file()
	- Don't use bitmap_zalloc() for the dirty bitmaps
- Use vzalloc() for dirty bitmaps and refactor how the bitmaps are DMA'd
  to and from the device in pds_vfio_dirty_seq_ack()
- Remove unnecessary goto in pds_vfio_dirty_disable()

v9:
https://lore.kernel.org/netdev/20230422010642.60720-1-brett.creeley@amd.com/
- Various fixes/suggestions by Alex Williamson
	- Fix how ID is generated in client registration
	- Add helper functions to get the VF's struct device and struct
	  pci_dev pointers instead of caching the struct pci dev
	- Remove redundant pds_vfio_lm_state() function and remove any
	  places this was being called
	- Fix multi-line comments to follow standard convention
	- Remove confusing comments in
	  pds_vfio_step_device_state_locked() since the driver's
	  migration states align with the VFIO documentation
	- Validate pdsc returned from pdsc_get_pf_struct()
- Various fixes/suggestions by Jason Gunthorpe
	- Use struct pdsc instead of void *
	- Use {} instead of {0} for structure initialization
	- Use unions on the stack instead of casting to the union when
	  sending AQ commands, which required including pds_lm.h in
	  pds_adminq.h
	- Replace use of dma_alloc_coherent() when creating the sgl DMA
	  entries for the LM file
	- Remove cached struct device *coredev and instead use
	  pci_physfn() to get the pds_core's struct device pointer
	- Drop the recovery work item and call pds_vfio_recovery()
	  directly from the notifier callback
	- Remove unnecessary #define for "pds_vfio_lm" and just use the
	  string inline to the anon_inode_getfile() argument
- Fix LM file reference counting
- Move initialization of some struct members to when the struct is being
  initialized for AQ commands
- Make use of GFP_KERNEL_ACCOUNT where it makes sense
- Replace PDS_VFIO_DRV_NAME with KBUILD_MODNAME
- Update to latest pds_core exported functions
- Remove duplicated prototypes for
  pds_vfio_dma_logging_[start|stop|report] from lm.h
- Hold pds_vfio->state_mutex while starting, stopping, and reporting
  dirty page tracking in pds_vfio_dma_logging_[start|stop|report]
- Remove duplicate PDS_DEV_TYPE_LM_STR define from pds_lm.h that's
  already included in pds_common.h
- Replace use of dma_alloc_coherent() when creating the sgl DMA
  entries for the dirty bitmaps

v8:
https://lore.kernel.org/netdev/20230404190141.57762-1-brett.creeley@amd.com/
- provide default iommufd callbacks for bind_iommufd, unbind_iommufd, and
  attach_ioas for the VFIO device as suggested by Shameerali Kolothum
  Thodi

v7:
https://lore.kernel.org/netdev/20230331003612.17569-1-brett.creeley@amd.com/
- Disable and clean up dirty page tracking when the VFIO device is closed
- Various improvements suggested by Simon Horman:
	- Fix RCT in vfio_combine_iova_ranges()
	- Simplify function exit paths by removing unnecessary goto
	  labels
	- Cleanup pds_vifo_print_guest_region_info() by adding a goto
	  label for freeing memory, which allowed for reduced
	  indentation on a for loop
	- Where possible use C99 style for loops

v6:
https://lore.kernel.org/netdev/20230327200553.13951-1-brett.creeley@amd.com/
- As suggested by Alex Williamson, use pci_domain_nr() macro to make sure
  the pds_vfio client's devname is unique
- Remove unnecessary forward declaration and include
- Fix copyright comment to use correct company name
- Remove "." from struct documentation for consistency

v5:
https://lore.kernel.org/netdev/20230322203442.56169-1-brett.creeley@amd.com/
- Fix SPDX comments in .h files
- Remove adminqcq argument from pdsc_post_adminq() uses
- Unregister client on vfio_pci_core_register_device() failure
- Other minor checkpatch issues

v4:
https://lore.kernel.org/netdev/20230308052450.13421-1-brett.creeley@amd.com/
- Update cover letter ASCII diagram to reflect new driver architecture
- Remove auxiliary driver implementation
- Use pds_core's exported functions to communicate with the device
- Implement and register notifier for events from the device/pds_core
- Use module_pci_driver() macro since auxiliary driver configuration is
  no longer needed in __init/__exit

v3:
https://lore.kernel.org/netdev/20230219083908.40013-1-brett.creeley@amd.com/
- Update copyright year to 2023 and use "Advanced Micro Devices, Inc."
  for the company name
- Clarify the fact that AMD/Pensando's VFIO solution is device type
  agnostic, which aligns with other current VFIO solutions
- Add line in drivers/vfio/pci/Makefile to build pds_vfio
- Move documentation to amd sub-directory
- Remove some dead code due to the pds_core implementation of
  listening to BIND/UNBIND events
- Move a dev_dbg() to a previous patch in the series
- Add implementation for vfio_migration_ops.migration_get_data_size to
  return the maximum possible device state size

RFC to v2:
https://lore.kernel.org/all/20221214232136.64220-1-brett.creeley@amd.com/
- Implement state transitions for VFIO_MIGRATION_P2P flag
- Improve auxiliary driver probe by returning EPROBE_DEFER
  when the PCI driver is not set up correctly
- Add pointer to docs in
  Documentation/networking/device_drivers/ethernet/index.rst

RFC:
https://lore.kernel.org/all/20221207010705.35128-1-brett.creeley@amd.com/


Brett Creeley (7):
  vfio: Commonize combine_ranges for use in other VFIO drivers
  vfio/pds: Initial support for pds VFIO driver
  vfio/pds: register with the pds_core PF
  vfio/pds: Add VFIO live migration support
  vfio/pds: Add support for dirty page tracking
  vfio/pds: Add support for firmware recovery
  vfio/pds: Add Kconfig and documentation

 .../ethernet/amd/pds_vfio_pci.rst             |  79 +++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   7 +
 drivers/vfio/pci/Kconfig                      |   2 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/mlx5/cmd.c                   |  48 +-
 drivers/vfio/pci/pds/Kconfig                  |  19 +
 drivers/vfio/pci/pds/Makefile                 |  11 +
 drivers/vfio/pci/pds/cmds.c                   | 493 +++++++++++++++
 drivers/vfio/pci/pds/cmds.h                   |  25 +
 drivers/vfio/pci/pds/dirty.c                  | 573 ++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h                  |  39 ++
 drivers/vfio/pci/pds/lm.c                     | 434 +++++++++++++
 drivers/vfio/pci/pds/lm.h                     |  41 ++
 drivers/vfio/pci/pds/pci_drv.c                | 214 +++++++
 drivers/vfio/pci/pds/pci_drv.h                |   9 +
 drivers/vfio/pci/pds/vfio_dev.c               | 227 +++++++
 drivers/vfio/pci/pds/vfio_dev.h               |  42 ++
 drivers/vfio/vfio_main.c                      |  47 ++
 include/linux/pds/pds_adminq.h                | 375 ++++++++++++
 include/linux/pds/pds_common.h                |   3 +-
 include/linux/vfio.h                          |   3 +
 22 files changed, 2646 insertions(+), 48 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci.rst
 create mode 100644 drivers/vfio/pci/pds/Kconfig
 create mode 100644 drivers/vfio/pci/pds/Makefile
 create mode 100644 drivers/vfio/pci/pds/cmds.c
 create mode 100644 drivers/vfio/pci/pds/cmds.h
 create mode 100644 drivers/vfio/pci/pds/dirty.c
 create mode 100644 drivers/vfio/pci/pds/dirty.h
 create mode 100644 drivers/vfio/pci/pds/lm.c
 create mode 100644 drivers/vfio/pci/pds/lm.h
 create mode 100644 drivers/vfio/pci/pds/pci_drv.c
 create mode 100644 drivers/vfio/pci/pds/pci_drv.h
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.h

-- 
2.17.1

