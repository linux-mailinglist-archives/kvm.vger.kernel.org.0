Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162C54B2CCC
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 19:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352712AbiBKSWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 13:22:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343586AbiBKSWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 13:22:30 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16606196;
        Fri, 11 Feb 2022 10:22:29 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BGRJ7l004788;
        Fri, 11 Feb 2022 18:22:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=pINOevvoQ/9f0NFUrCoqY0W/We+zzYj735erAO3/O9A=;
 b=m3QmE8x+h8DmOlNT3znGXT6ZvN09BdW09el5CwVA52QBzLs8qgoOrNgr7APS03HbjemD
 6GZHUDnYh6UNiqf88k9tB+pDo0HZKFTW84V7G9Or0slEhyxJj7p+uA3Pd8NTrSBJT4/y
 mKi/uTWhME6PpPbups5lPmJ21bGc9zH+p0/vqrpVSuIfgkyw0EQfk23gkFsOlNdQfZoW
 SXpugymiSADtFEkRowc4AVwFcbome67F3tEteaoWl8oze0xkKc2ls4uC9Br0dVxU2KL/
 RgZezKkwBikC7IeMBXXj3s1GUyNI+fwSt+LvzM8Tpw4+7sAI8Dj6+K+TrPufg0wmmJL0 yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5ub9aenn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:26 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21BI9pKe023922;
        Fri, 11 Feb 2022 18:22:26 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5ub9aem8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:26 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21BICYXH030099;
        Fri, 11 Feb 2022 18:22:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3e1gva9nk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21BIMHOj46072072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 18:22:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BC7C52051;
        Fri, 11 Feb 2022 18:22:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0F2B752052;
        Fri, 11 Feb 2022 18:22:17 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v4 00/10] KVM: s390: Do storage key checking
Date:   Fri, 11 Feb 2022 19:22:05 +0100
Message-Id: <20220211182215.2730017-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kWciM2TJOqsHy__HsM7xTKN8g_xunFjN
X-Proofpoint-ORIG-GUID: 3elo-BIlQFIHQ7domBC1VyLRMKotQ9aG
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check keys when emulating instructions and let user space do key checked
accesses.
User space can do so via an extension of the MEMOP IOCTL:
* allow optional key checking
* allow MEMOP on vm fd, so key checked accesses on absolute memory
  become possible

I haven't finished the memop selftest rewrite, but decided to send out a
new version anyway, since the functional patches are (hopefully) final
and the memop selftest patch works. I'll reply to it with the
rewritten version.

v3: https://lore.kernel.org/kvm/20220209170422.1910690-1-scgl@linux.ibm.com/
v2: https://lore.kernel.org/kvm/20220207165930.1608621-1-scgl@linux.ibm.com/

v3 -> v4
 * rebase
 * ignore key in memop if skey flag not specified
 * fix nits in documentation
 * pick up tags

v2 -> v3
 * get rid of reserved bytes check in vm,vcpu memop
 * minor documentation changes
 * moved memop selftest patches to end of series and squashed them,
   currently working on making the test pretty

v1 -> v2
 * rebase
 * storage key variants of _?copy_from/to_user instead of
   __copy_from/to_user_key, with long key arg instead of char
 * refactor protection override checks
 * u8 instead of char for key argument in s390 KVM code
 * add comments
 * pass ar (access register) to trans_exec in access_guest_with_key
 * check reserved/unused fields (backwards compatible)
 * move key arg of MEMOP out of flags
 * rename new MEMOP capability to KVM_CAP_S390_MEM_OP_EXTENSION
 * minor changes

Janis Schoetterl-Glausch (10):
  s390/uaccess: Add copy_from/to_user_key functions
  KVM: s390: Honor storage keys when accessing guest memory
  KVM: s390: handle_tprot: Honor storage keys
  KVM: s390: selftests: Test TEST PROTECTION emulation
  KVM: s390: Add optional storage key checking to MEMOP IOCTL
  KVM: s390: Add vm IOCTL for key checked guest absolute memory access
  KVM: s390: Rename existing vcpu memop functions
  KVM: s390: Add capability for storage key extension of MEM_OP IOCTL
  KVM: s390: Update api documentation for memop ioctl
  KVM: s390: selftests: Test memops with storage keys

 Documentation/virt/kvm/api.rst            | 112 ++++-
 arch/s390/include/asm/ctl_reg.h           |   2 +
 arch/s390/include/asm/page.h              |   2 +
 arch/s390/include/asm/uaccess.h           |  22 +
 arch/s390/kvm/gaccess.c                   | 250 +++++++++-
 arch/s390/kvm/gaccess.h                   |  84 +++-
 arch/s390/kvm/intercept.c                 |  12 +-
 arch/s390/kvm/kvm-s390.c                  | 132 ++++-
 arch/s390/kvm/priv.c                      |  66 +--
 arch/s390/lib/uaccess.c                   |  81 +++-
 include/uapi/linux/kvm.h                  |  11 +-
 tools/testing/selftests/kvm/.gitignore    |   1 +
 tools/testing/selftests/kvm/Makefile      |   1 +
 tools/testing/selftests/kvm/s390x/memop.c | 558 +++++++++++++++++++---
 tools/testing/selftests/kvm/s390x/tprot.c | 227 +++++++++
 15 files changed, 1375 insertions(+), 186 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/tprot.c

Range-diff against v3:
 1:  0049c4412978 =  1:  313eb689b715 s390/uaccess: Add copy_from/to_user_key functions
 2:  296096b9a7b9 =  2:  192fe30b1863 KVM: s390: Honor storage keys when accessing guest memory
 3:  a5976cb3a147 =  3:  19bd017ae5a4 KVM: s390: handle_tprot: Honor storage keys
 4:  5f5e056e66df =  4:  d20fad8d501b KVM: s390: selftests: Test TEST PROTECTION emulation
 5:  64fa17a83b26 !  5:  bdee09b4a15e KVM: s390: Add optional storage key checking to MEMOP IOCTL
    @@ Commit message
         CPU would, or pass another key if necessary.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    -    Acked-by: Janosch Frank <frankja@linux.ibm.com>
         Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
    +    Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## arch/s390/kvm/kvm-s390.c ##
    -@@
    - #include <linux/sched/signal.h>
    - #include <linux/string.h>
    - #include <linux/pgtable.h>
    -+#include <linux/bitfield.h>
    - 
    - #include <asm/asm-offsets.h>
    - #include <asm/lowcore.h>
     @@ arch/s390/kvm/kvm-s390.c: static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
      	return r;
      }
    @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcp
     +	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
     +		if (access_key_invalid(mop->key))
     +			return -EINVAL;
    ++	} else {
    ++		mop->key = 0;
     +	}
      	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
      		tmpbuf = vmalloc(mop->size);
 6:  57e3ad332677 !  6:  e207a2f9af8a KVM: s390: Add vm IOCTL for key checked guest absolute memory access
    @@ Commit message
         accesses and so are not applied as they are when using the vcpu memop.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    -    Acked-by: Janosch Frank <frankja@linux.ibm.com>
    +    Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
     
      ## arch/s390/kvm/gaccess.c ##
     @@ arch/s390/kvm/gaccess.c: static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
    @@ arch/s390/kvm/kvm-s390.c: static bool access_key_invalid(u8 access_key)
     +	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
     +		if (access_key_invalid(mop->key))
     +			return -EINVAL;
    ++	} else {
    ++		mop->key = 0;
     +	}
     +	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
     +		tmpbuf = vmalloc(mop->size);
 7:  1615f5ab6e30 =  7:  52adbceebe41 KVM: s390: Rename existing vcpu memop functions
 8:  a8420e0f1b7f =  8:  43280a2db282 KVM: s390: Add capability for storage key extension of MEM_OP IOCTL
 9:  c59952ee362b !  9:  9389cd2f4d23 KVM: s390: Update api documentation for memop ioctl
    @@ Commit message
         as well as the existing SIDA operations.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## Documentation/virt/kvm/api.rst ##
     @@ Documentation/virt/kvm/api.rst: The fields in each entry are defined as follows:
    @@ Documentation/virt/kvm/api.rst: Parameters are specified via the following struc
     +the access. "ar" designates the access register number to be used; the valid
     +range is 0..15.
     +Logical accesses are permitted for the VCPU ioctl only.
    -+Logical accesses are permitted for non secure guests only.
    ++Logical accesses are permitted for non-protected guests only.
     +
     +Supported flags:
     +  * ``KVM_S390_MEMOP_F_CHECK_ONLY``
    @@ Documentation/virt/kvm/api.rst: Parameters are specified via the following struc
     +  * ``KVM_S390_MEMOP_F_SKEY_PROTECTION``
     +
     +The KVM_S390_MEMOP_F_CHECK_ONLY flag can be set to check whether the
    -+corresponding memory access would cause an access exception, without touching
    -+the data in memory at the destination.
    ++corresponding memory access would cause an access exception; however,
    ++no actual access to the data in memory at the destination is performed.
     +In this case, "buf" is unused and can be NULL.
     +
     +In case an access exception occurred during the access (or would occur
    @@ Documentation/virt/kvm/api.rst: Parameters are specified via the following struc
     +Absolute accesses are permitted for the VM ioctl if KVM_CAP_S390_MEM_OP_EXTENSION
     +is > 0.
     +Currently absolute accesses are not permitted for VCPU ioctls.
    -+Absolute accesses are permitted for non secure guests only.
    ++Absolute accesses are permitted for non-protected guests only.
     +
     +Supported flags:
     +  * ``KVM_S390_MEMOP_F_CHECK_ONLY``
    @@ Documentation/virt/kvm/api.rst: Parameters are specified via the following struc
     +^^^^^^^^^^^^^^^^
     +
     +Access the secure instruction data area which contains memory operands necessary
    -+for instruction emulation for secure guests.
    ++for instruction emulation for protected guests.
     +SIDA accesses are available if the KVM_CAP_S390_PROTECTED capability is available.
     +SIDA accesses are permitted for the VCPU ioctl only.
    -+SIDA accesses are permitted for secure guests only.
    ++SIDA accesses are permitted for protected guests only.
      
     -The "reserved" field is meant for future extensions. It is not used by
     -KVM with the currently defined set of flags.
10:  68752e1eca95 = 10:  af33593d63a4 KVM: s390: selftests: Test memops with storage keys

base-commit: f1baf68e1383f6ed93eb9cff2866d46562607a43
-- 
2.32.0

