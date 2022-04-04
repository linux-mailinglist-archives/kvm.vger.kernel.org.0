Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D254F1F7C
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbiDDWxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbiDDWxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55724B859;
        Mon,  4 Apr 2022 15:11:50 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234LdrjO022040;
        Mon, 4 Apr 2022 22:11:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=1xGiAAOP8cITnG6KNAd7UIQDKk9RmlxxVxu7y4UKAD4=;
 b=TqOHJxPs42/VFkBKf83zJtVS5vXNC3bu4442jv9QCIC5QRTavOQX42o8WsD9oi3l82Mm
 oOLLyX0J6a7ifmvD2PfrqdtIf57Hqbp1HWlJfFj9FllBn7OnLK4xKhfMoD6eNwu66224
 AxCBLwVg5V3G+2P/V2jFonDRFb38GwVhCmZVppMbbhF/Y234sHdFkwvHqoSFK/HPmhyg
 WkSsc1WJoRc5L5j22cas+XMZq5lTD7BuoEqlUQovr8GB1fizs3YAem1UXsMNfr8M6z7M
 cCS2GvqC+Qt5QzBivSLeMGw7CHj4y3bL1VBK/38nEQZGhixBMC6MtyvIIeePuQzKJ9pm VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f87jtanrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:48 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234M1NPJ010695;
        Mon, 4 Apr 2022 22:11:47 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f87jtanqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:47 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Lr3Rq017279;
        Mon, 4 Apr 2022 22:11:46 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 3f6e48tp6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:46 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MBjOp32309682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:11:45 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8BF77806E;
        Mon,  4 Apr 2022 22:11:44 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C837F7805C;
        Mon,  4 Apr 2022 22:11:43 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:11:43 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 00/20] s390/vfio-ap: dynamic configuration support
Date:   Mon,  4 Apr 2022 18:10:19 -0400
Message-Id: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hzwMPSOoWg2HZj7ZTXCh2No_c9h3QneZ
X-Proofpoint-ORIG-GUID: EOH4NwZ1zzQh4Qb9lSyMaoGPL_j__-Qa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 phishscore=0 suspectscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current design for AP pass-through does not support making dynamic
changes to the AP matrix of a running guest resulting in a few
deficiencies this patch series is intended to mitigate:

1. Adapters, domains and control domains can not be added to or removed
    from a running guest. In order to modify a guest's AP configuration,
    the guest must be terminated; only then can AP resources be assigned
    to or unassigned from the guest's matrix mdev. The new AP
    configuration becomes available to the guest when it is subsequently
    restarted.

2. The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask interfaces can
    be modified by a root user without any restrictions. A change to
    either mask can result in AP queue devices being unbound from the
    vfio_ap device driver and bound to a zcrypt device driver even if a
    guest is using the queues, thus giving the host access to the guest's
    private crypto data and vice versa.

3. The APQNs derived from the Cartesian product of the APIDs of the
    adapters and APQIs of the domains assigned to a matrix mdev must
    reference an AP queue device bound to the vfio_ap device driver. The
    AP architecture allows assignment of AP resources that are not
    available to the system, so this artificial restriction is not
    compliant with the architecture.

4. The AP configuration profile can be dynamically changed for the linux
    host after a KVM guest is started. For example, a new domain can be
    dynamically added to the configuration profile via the SE or an HMC
    connected to a DPM enabled lpar. Likewise, AP adapters can be
    dynamically configured (online state) and deconfigured (standby state)
    using the SE, an SCLP command or an HMC connected to a DPM enabled
    lpar. This can result in inadvertent sharing of AP queues between the
    guest and host.

5. A root user can manually unbind an AP queue device representing a
    queue in use by a KVM guest via the vfio_ap device driver's sysfs
    unbind attribute. In this case, the guest will be using a queue that
    is not bound to the driver which violates the device model.

This patch series introduces the following changes to the current design
to alleviate the shortcomings described above as well as to implement
more of the AP architecture:

1. A root user will be prevented from making edits to the AP bus's
    /sys/bus/ap/apmask or /sys/bus/ap/aqmask if the change would transfer
    ownership of an APQN from the vfio_ap device driver to a zcrypt driver
    while the APQN is assigned to a matrix mdev.

2. Allow a root user to hot plug/unplug AP adapters, domains and control
    domains for a KVM guest using the matrix mdev via its sysfs
    assign/unassign attributes.

4. Allow assignment of an AP adapter or domain to a matrix mdev even if
    it results in assignment of an APQN that does not reference an AP
    queue device bound to the vfio_ap device driver, as long as the APQN
    is not reserved for use by the default zcrypt drivers (also known as
    over-provisioning of AP resources). Allowing over-provisioning of AP
    resources better models the architecture which does not preclude
    assigning AP resources that are not yet available in the system. Such
    APQNs, however, will not be assigned to the guest using the matrix
    mdev; only APQNs referencing AP queue devices bound to the vfio_ap
    device driver will actually get assigned to the guest.

5. Handle dynamic changes to the AP device model.

1. Rationale for changes to AP bus's apmask/aqmask interfaces:
----------------------------------------------------------
Due to the extremely sensitive nature of cryptographic data, it is
imperative that great care be taken to ensure that such data is secured.
Allowing a root user, either inadvertently or maliciously, to configure
these masks such that a queue is shared between the host and a guest is
not only avoidable, it is advisable. It was suggested that this scenario
is better handled in user space with management software, but that does
not preclude a malicious administrator from using the sysfs interfaces
to gain access to a guest's crypto data. It was also suggested that this
scenario could be avoided by taking access to the adapter away from the
guest and zeroing out the queues prior to the vfio_ap driver releasing the
device; however, stealing an adapter in use from a guest as a by-product
of an operation is bad and will likely cause problems for the guest
unnecessarily. It was decided that the most effective solution with the
least number of negative side effects is to prevent the situation at the
source.

2. Rationale for hot plug/unplug using matrix mdev sysfs interfaces:
----------------------------------------------------------------
Allowing a user to hot plug/unplug AP resources using the matrix mdev
sysfs interfaces circumvents the need to terminate the guest in order to
modify its AP configuration. Allowing dynamic configuration makes
reconfiguring a guest's AP matrix much less disruptive.

3. Rationale for allowing over-provisioning of AP resources:
-----------------------------------------------------------
Allowing assignment of AP resources to a matrix mdev and ultimately to a
guest better models the AP architecture. The architecture does not
preclude assignment of unavailable AP resources. If a queue subsequently
becomes available while a guest using the matrix mdev to which its APQN
is assigned, the guest will be given access to it. If an APQN
is dynamically unassigned from the underlying host system, it will
automatically become unavailable to the guest.

Change log v18-v19:
------------------
* Changed name of vfio_ap_mdev_hotplug_apcb (vfio_ap_ops.c) to
  vfio_ap_mdev_update_guest_apcb
  (Suggested by Jason: review of patch 10/18)

* Replace call to kvm_arch_crypto_set_masks in vfio_ap_mdev_set_kvm with
  call to vfio_ap_mdev_update_guest_apcb
  (Suggested by Jason: review of patch 10/18)

* Moved changes related to new locking scheme into its own set of
  patches (Suggested by Jason: review of patch 10/18)

* Consolidated some of the lock acquisition code into macros called by the
  functions that update a KVM guest's APCB.

* Refactored vfio_ap_mdev_unlink_adapter() and
  vfio_ap_unlink_apqn_fr_mdev() functions according to Jason's sample
  code. (Suggested by Jason: review of patch 12/18)

* Require callers of the AP bus ap_apqn_in_matrix_owned_by_def_drv and
  ap_owned_by_def_drv - only called by the vfio_ap driver - to take the
  ap_perms_mutex lock. The adapter/domain assignment interfaces will take
  the ap_perms_mutex lock prior to other required locks to maintain a
  proper locking order and avoid circular locking dependencies when the
  vfio_ap device driver's in_use callback is invoked simultaneously with
  the adapter/domain assignment interfaces. (Suggested by Jason)

* Refactored patch 15/18: handle config changed and scan complete
  notification (Suggested by Jason)

* Refactored filtering of the matrix to reduce redundant processing of
  APQNs:
  - Inspect only the new APIDs or APQIs assigned to the matrix mdev or
    added to the host's AP configuration
  - Automatically removing APIDs or APQIs unassigned from the matrix mdev
    or removed from the host's AP configuration.
  (Suggested by Halil)

Tony Krowiak (20):
  s390/vfio-ap: use new AP bus interface to search for queue devices
  s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
  s390/vfio-ap: manage link between queue struct and matrix mdev
  s390/vfio-ap: introduce shadow APCB
  s390/vfio-ap: refresh guest's APCB by filtering AP resources assigned
    to mdev
  s390/vfio-ap: allow assignment of unavailable AP queues to mdev device
  s390/vfio-ap: rename matrix_dev->lock mutex to matrix_dev->mdevs_lock
  s390/vfio-ap: introduce new mutex to control access to the KVM pointer
  s390/vfio-ap: use proper locking order when setting/clearing KVM
    pointer
  s390/vfio-ap: prepare for dynamic update of guest's APCB on
    assign/unassign
  s390/vfio-ap: prepare for dynamic update of guest's APCB on queue
    probe/remove
  s390/vfio-ap: allow hot plug/unplug of AP devices when
    assigned/unassigned
  s390/vfio-ap: hot plug/unplug of AP devices when probed/removed
  s390/vfio-ap: reset queues after adapter/domain unassignment
  s390/vfio-ap: implement in-use callback for vfio_ap driver
  s390/vfio-ap: sysfs attribute to display the guest's matrix
  s390/vfio-ap: handle config changed and scan complete notification
  s390/vfio-ap: update docs to include dynamic config support
  s390/Docs: new doc describing lock usage by the vfio_ap device driver
  MAINTAINERS: pick up all vfio_ap docs for VFIO AP maintainers

 Documentation/s390/vfio-ap-locking.rst |  389 +++++++
 Documentation/s390/vfio-ap.rst         |  492 ++++++---
 MAINTAINERS                            |    6 +-
 drivers/s390/crypto/ap_bus.c           |   31 +-
 drivers/s390/crypto/vfio_ap_drv.c      |   69 +-
 drivers/s390/crypto/vfio_ap_ops.c      | 1321 ++++++++++++++++++------
 drivers/s390/crypto/vfio_ap_private.h  |   47 +-
 7 files changed, 1820 insertions(+), 535 deletions(-)
 create mode 100644 Documentation/s390/vfio-ap-locking.rst

-- 
2.31.1

