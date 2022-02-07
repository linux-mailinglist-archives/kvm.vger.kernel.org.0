Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90624AC718
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 18:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382720AbiBGROu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 12:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358003AbiBGRAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 12:00:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEF7C0401DA;
        Mon,  7 Feb 2022 09:00:08 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217GxHUr007312;
        Mon, 7 Feb 2022 17:00:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=NEsg68OCYapkaox1YrDGPfgjTIpVnWizeFI8UW1HsE4=;
 b=o9yReSqvfoC1vP8lCrPBzwWeFVzHy+CFEku/2tQGcM+0qwjVVm+LX2DKo3gWOTGKDumI
 9d3yB6WF4nLbX9LQFrjm5VwdwOOR68jTU7TqgMPH0DJKVsOfHp495cenNcUSiHlTR9d/
 kAAUzEmrTiQYYc/oxU8ZOaET23ds1Jt4FL43eqE5qdyyG76FcGK7D30zNHNFwtxG84RY
 U22kWYztwMWDTUueE0wwOZ+5AnourWybROJmMEvU0anfK6p/XP0jXYv5NYXWPNiR7rhp
 6GHndmpe0szOp5Lfhs1xqxJ7CP5uHQX5zLJAJtvNO0/mnF0RtZFZ5qTzeWjMj7ktn29G MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22whfb29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:05 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217GxNqr008212;
        Mon, 7 Feb 2022 17:00:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22whfb1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217Gs3Eb001153;
        Mon, 7 Feb 2022 17:00:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggjpvjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217GxxRV35782966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 16:59:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 772D8A405B;
        Mon,  7 Feb 2022 16:59:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3E19A4065;
        Mon,  7 Feb 2022 16:59:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 16:59:58 +0000 (GMT)
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
Subject: [PATCH v2 00/11] KVM: s390: Do storage key checking
Date:   Mon,  7 Feb 2022 17:59:19 +0100
Message-Id: <20220207165930.1608621-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6OVCEXeZprwEBeB3LCntHJhIKFMMaqU9
X-Proofpoint-ORIG-GUID: kUiInSIRxdg_A56pu0XPjBcR3-mmPVJH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202070103
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

TODO:
	I might refactor the memop selftest.

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

Janis Schoetterl-Glausch (11):
  s390/uaccess: Add copy_from/to_user_key functions
  KVM: s390: Honor storage keys when accessing guest memory
  KVM: s390: handle_tprot: Honor storage keys
  KVM: s390: selftests: Test TEST PROTECTION emulation
  KVM: s390: Add optional storage key checking to MEMOP IOCTL
  KVM: s390: Add vm IOCTL for key checked guest absolute memory access
  KVM: s390: Rename existing vcpu memop functions
  KVM: s390: selftests: Test memops with storage keys
  KVM: s390: Add capability for storage key extension of MEM_OP IOCTL
  KVM: s390: selftests: Make use of capability in MEM_OP test
  KVM: s390: Update api documentation for memop ioctl

 Documentation/virt/kvm/api.rst            | 112 ++++-
 arch/s390/include/asm/ctl_reg.h           |   2 +
 arch/s390/include/asm/page.h              |   2 +
 arch/s390/include/asm/uaccess.h           |  22 +
 arch/s390/kvm/gaccess.c                   | 250 +++++++++-
 arch/s390/kvm/gaccess.h                   |  84 +++-
 arch/s390/kvm/intercept.c                 |  12 +-
 arch/s390/kvm/kvm-s390.c                  | 153 +++++-
 arch/s390/kvm/priv.c                      |  66 +--
 arch/s390/lib/uaccess.c                   |  81 +++-
 include/uapi/linux/kvm.h                  |  11 +-
 tools/testing/selftests/kvm/.gitignore    |   1 +
 tools/testing/selftests/kvm/Makefile      |   1 +
 tools/testing/selftests/kvm/s390x/memop.c | 558 +++++++++++++++++++---
 tools/testing/selftests/kvm/s390x/tprot.c | 227 +++++++++
 15 files changed, 1395 insertions(+), 187 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/tprot.c

Range-diff against v1:
 1:  bac88076fe29 !  1:  bcbcf21bdc2f s390/uaccess: Add storage key checked access to user memory
    @@ Metadata
     Author: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
     
      ## Commit message ##
    -    s390/uaccess: Add storage key checked access to user memory
    +    s390/uaccess: Add copy_from/to_user_key functions
     
    -    KVM needs a mechanism to do accesses to guest memory that honor
    -    storage key protection.
    -    Since the copy_to/from_user implementation makes use of move
    +    Add copy_from/to_user_key functions, which perform storage key checking.
    +    These functions can be used by KVM for emulating instructions that need
    +    to be key checked.
    +    These functions differ from their non _key counterparts in
    +    include/linux/uaccess.h only in the additional key argument and must be
    +    kept in sync with those.
    +
    +    Since the existing uaccess implementation on s390 makes use of move
         instructions that support having an additional access key supplied,
    -    we can implement __copy_from/to_user_with_key by enhancing the
    +    we can implement raw_copy_from/to_user_key by enhancing the
         existing implementation.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
     
      ## arch/s390/include/asm/uaccess.h ##
    -@@ arch/s390/include/asm/uaccess.h: static inline int __range_ok(unsigned long addr, unsigned long size)
    - 
    - #define access_ok(addr, size) __access_ok(addr, size)
    +@@ arch/s390/include/asm/uaccess.h: raw_copy_to_user(void __user *to, const void *from, unsigned long n);
    + #define INLINE_COPY_TO_USER
    + #endif
      
     +unsigned long __must_check
    -+raw_copy_from_user_with_key(void *to, const void __user *from, unsigned long n,
    -+			    char key);
    -+
    -+unsigned long __must_check
    -+raw_copy_to_user_with_key(void __user *to, const void *from, unsigned long n,
    -+			  char key);
    ++_copy_from_user_key(void *to, const void __user *from, unsigned long n, unsigned long key);
     +
    -+static __always_inline __must_check unsigned long
    -+__copy_from_user_with_key(void *to, const void __user *from, unsigned long n,
    -+			  char key)
    ++static __always_inline unsigned long __must_check
    ++copy_from_user_key(void *to, const void __user *from, unsigned long n, unsigned long key)
     +{
    -+	might_fault();
    -+	if (should_fail_usercopy())
    -+		return n;
    -+	instrument_copy_from_user(to, from, n);
    -+	check_object_size(to, n, false);
    -+	return raw_copy_from_user_with_key(to, from, n, key);
    ++	if (likely(check_copy_size(to, n, false)))
    ++		n = _copy_from_user_key(to, from, n, key);
    ++	return n;
     +}
     +
    -+static __always_inline __must_check unsigned long
    -+__copy_to_user_with_key(void __user *to, const void *from, unsigned long n,
    -+			char key)
    ++unsigned long __must_check
    ++_copy_to_user_key(void __user *to, const void *from, unsigned long n, unsigned long key);
    ++
    ++static __always_inline unsigned long __must_check
    ++copy_to_user_key(void __user *to, const void *from, unsigned long n, unsigned long key)
     +{
    -+	might_fault();
    -+	if (should_fail_usercopy())
    -+		return n;
    -+	instrument_copy_to_user(to, from, n);
    -+	check_object_size(from, n, true);
    -+	return raw_copy_to_user_with_key(to, from, n, key);
    ++	if (likely(check_copy_size(from, n, true)))
    ++		n = _copy_to_user_key(to, from, n, key);
    ++	return n;
     +}
     +
    - unsigned long __must_check
    - raw_copy_from_user(void *to, const void __user *from, unsigned long n);
    + int __put_user_bad(void) __attribute__((noreturn));
    + int __get_user_bad(void) __attribute__((noreturn));
      
     
      ## arch/s390/lib/uaccess.c ##
    @@ arch/s390/lib/uaccess.c: static inline int copy_with_mvcos(void)
      
      static inline unsigned long copy_from_user_mvcos(void *x, const void __user *ptr,
     -						 unsigned long size)
    -+						 unsigned long size, char key)
    ++						 unsigned long size, unsigned long key)
      {
      	unsigned long tmp1, tmp2;
      	union oac spec = {
    @@ arch/s390/lib/uaccess.c: static inline unsigned long copy_from_user_mvcos(void *
      
      static inline unsigned long copy_from_user_mvcp(void *x, const void __user *ptr,
     -						unsigned long size)
    -+						unsigned long size, char key)
    ++						unsigned long size, unsigned long key)
      {
      	unsigned long tmp1, tmp2;
      
    @@ arch/s390/lib/uaccess.c: static inline unsigned long copy_from_user_mvcp(void *x
      	return size;
      }
      
    - unsigned long raw_copy_from_user(void *to, const void __user *from, unsigned long n)
    +-unsigned long raw_copy_from_user(void *to, const void __user *from, unsigned long n)
    ++static unsigned long raw_copy_from_user_key(void *to, const void __user *from,
    ++					    unsigned long n, unsigned long key)
      {
      	if (copy_with_mvcos())
     -		return copy_from_user_mvcos(to, from, n);
     -	return copy_from_user_mvcp(to, from, n);
    -+		return copy_from_user_mvcos(to, from, n, 0);
    -+	return copy_from_user_mvcp(to, from, n, 0);
    ++		return copy_from_user_mvcos(to, from, n, key);
    ++	return copy_from_user_mvcp(to, from, n, key);
    ++}
    ++
    ++unsigned long raw_copy_from_user(void *to, const void __user *from, unsigned long n)
    ++{
    ++	return raw_copy_from_user_key(to, from, n, 0);
      }
      EXPORT_SYMBOL(raw_copy_from_user);
      
    --static inline unsigned long copy_to_user_mvcos(void __user *ptr, const void *x,
    --					       unsigned long size)
    -+unsigned long raw_copy_from_user_with_key(void *to, const void __user *from,
    -+					  unsigned long n, char key)
    ++unsigned long _copy_from_user_key(void *to, const void __user *from,
    ++				  unsigned long n, unsigned long key)
     +{
    -+	if (copy_with_mvcos())
    -+		return copy_from_user_mvcos(to, from, n, key);
    -+	return copy_from_user_mvcp(to, from, n, key);
    ++	unsigned long res = n;
    ++
    ++	might_fault();
    ++	if (!should_fail_usercopy()) {
    ++		instrument_copy_from_user(to, from, n);
    ++		res = raw_copy_from_user_key(to, from, n, key);
    ++	}
    ++	if (unlikely(res))
    ++		memset(to + (n - res), 0, res);
    ++	return res;
     +}
    -+EXPORT_SYMBOL(raw_copy_from_user_with_key);
    ++EXPORT_SYMBOL(_copy_from_user_key);
     +
    -+inline unsigned long copy_to_user_mvcos(void __user *ptr, const void *x,
    -+					unsigned long size, char key)
    + static inline unsigned long copy_to_user_mvcos(void __user *ptr, const void *x,
    +-					       unsigned long size)
    ++					       unsigned long size, unsigned long key)
      {
      	unsigned long tmp1, tmp2;
      	union oac spec = {
    @@ arch/s390/lib/uaccess.c: static inline unsigned long copy_to_user_mvcos(void __u
      
      static inline unsigned long copy_to_user_mvcs(void __user *ptr, const void *x,
     -					      unsigned long size)
    -+					      unsigned long size, char key)
    ++					      unsigned long size, unsigned long key)
      {
      	unsigned long tmp1, tmp2;
      
    @@ arch/s390/lib/uaccess.c: static inline unsigned long copy_to_user_mvcs(void __us
      	return size;
      }
      
    - unsigned long raw_copy_to_user(void __user *to, const void *from, unsigned long n)
    +-unsigned long raw_copy_to_user(void __user *to, const void *from, unsigned long n)
    ++static unsigned long raw_copy_to_user_key(void __user *to, const void *from,
    ++					  unsigned long n, unsigned long key)
      {
      	if (copy_with_mvcos())
     -		return copy_to_user_mvcos(to, from, n);
     -	return copy_to_user_mvcs(to, from, n);
    -+		return copy_to_user_mvcos(to, from, n, 0);
    -+	return copy_to_user_mvcs(to, from, n, 0);
    - }
    - EXPORT_SYMBOL(raw_copy_to_user);
    -+unsigned long raw_copy_to_user_with_key(void __user *to, const void *from,
    -+					unsigned long n, char key)
    -+{
    -+	if (copy_with_mvcos())
     +		return copy_to_user_mvcos(to, from, n, key);
     +	return copy_to_user_mvcs(to, from, n, key);
     +}
    -+EXPORT_SYMBOL(raw_copy_to_user_with_key);
    ++
    ++unsigned long raw_copy_to_user(void __user *to, const void *from, unsigned long n)
    ++{
    ++	return raw_copy_to_user_key(to, from, n, 0);
    + }
    + EXPORT_SYMBOL(raw_copy_to_user);
      
    ++unsigned long _copy_to_user_key(void __user *to, const void *from,
    ++				unsigned long n, unsigned long key)
    ++{
    ++	might_fault();
    ++	if (should_fail_usercopy())
    ++		return n;
    ++	instrument_copy_to_user(to, from, n);
    ++	return raw_copy_to_user_key(to, from, n, key);
    ++}
    ++EXPORT_SYMBOL(_copy_to_user_key);
    ++
      static inline unsigned long clear_user_mvcos(void __user *to, unsigned long size)
      {
    + 	unsigned long tmp1, tmp2;
 2:  d480b09711e6 !  2:  d634b7e34245 KVM: s390: Honor storage keys when accessing guest memory
    @@ Commit message
         to access_guest_with_key.
         Accesses via access_guest_real should not be key checked.
     
    -    For actual accesses, key checking is done by __copy_from/to_user_with_key
    -    (which internally uses MVCOS/MVCP/MVCS).
    +    For actual accesses, key checking is done by
    +    copy_from/to_user_key (which internally uses MVCOS/MVCP/MVCS).
         In cases where accessibility is checked without an actual access,
    -    this is performed by getting the storage key and checking
    -    if the access key matches.
    -    In both cases, if applicable, storage and fetch protection override
    -    are honored.
    +    this is performed by getting the storage key and checking if the access
    +    key matches. In both cases, if applicable, storage and fetch protection
    +    override are honored.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## arch/s390/include/asm/ctl_reg.h ##
     @@
    @@ arch/s390/kvm/gaccess.c: static int low_address_protection_enabled(struct kvm_vc
     +	return vcpu->arch.sie_block->gcr[0] & CR0_STORAGE_PROTECTION_OVERRIDE;
     +}
     +
    -+static bool storage_prot_override_applies(char access_control)
    ++static bool storage_prot_override_applies(u8 access_control)
     +{
     +	/* matches special storage protection override key (9) -> allow */
     +	return access_control == PAGE_SPO_ACC;
     +}
     +
    -+static int vcpu_check_access_key(struct kvm_vcpu *vcpu, char access_key,
    ++static int vcpu_check_access_key(struct kvm_vcpu *vcpu, u8 access_key,
     +				 enum gacc_mode mode, union asce asce, gpa_t gpa,
     +				 unsigned long ga, unsigned int len)
     +{
    -+	unsigned char storage_key, access_control;
    ++	u8 storage_key, access_control;
     +	unsigned long hva;
     +	int r;
     +
    @@ arch/s390/kvm/gaccess.c: static int low_address_protection_enabled(struct kvm_vc
     +	if (access_control == access_key)
     +		return 0;
     +	if (mode == GACC_FETCH || mode == GACC_IFETCH) {
    -+		/* mismatching keys, no fetch protection -> allowed */
    ++		/* it is a fetch and fetch protection is off -> allow */
     +		if (!(storage_key & _PAGE_FP_BIT))
     +			return 0;
    -+		if (fetch_prot_override_applicable(vcpu, mode, asce))
    -+			if (fetch_prot_override_applies(ga, len))
    -+				return 0;
    -+	}
    -+	if (storage_prot_override_applicable(vcpu))
    -+		if (storage_prot_override_applies(access_control))
    ++		if (fetch_prot_override_applicable(vcpu, mode, asce) &&
    ++		    fetch_prot_override_applies(ga, len))
     +			return 0;
    ++	}
    ++	if (storage_prot_override_applicable(vcpu) &&
    ++	    storage_prot_override_applies(access_control))
    ++		return 0;
     +	return PGM_PROTECTION;
     +}
     +
    @@ arch/s390/kvm/gaccess.c: static int low_address_protection_enabled(struct kvm_vc
      			       unsigned long *gpas, unsigned long len,
     -			       const union asce asce, enum gacc_mode mode)
     +			       const union asce asce, enum gacc_mode mode,
    -+			       char access_key)
    ++			       u8 access_key)
      {
      	psw_t *psw = &vcpu->arch.sie_block->gpsw;
      	unsigned int offset = offset_in_page(ga);
    @@ arch/s390/kvm/gaccess.c: static int access_guest_page(struct kvm *kvm, enum gacc
     -		 unsigned long len, enum gacc_mode mode)
     +static int
     +access_guest_page_with_key(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
    -+			   void *data, unsigned int len, char key)
    ++			   void *data, unsigned int len, u8 access_key)
     +{
     +	struct kvm_memory_slot *slot;
     +	bool writable;
    @@ arch/s390/kvm/gaccess.c: static int access_guest_page(struct kvm *kvm, enum gacc
     +
     +	if (kvm_is_error_hva(hva))
     +		return PGM_ADDRESSING;
    ++	/*
    ++	 * Check if it's a ro memslot, even tho that can't occur (they're unsupported).
    ++	 * Don't try to actually handle that case.
    ++	 */
     +	if (!writable && mode == GACC_STORE)
     +		return -EOPNOTSUPP;
     +	hva += offset_in_page(gpa);
     +	if (mode == GACC_STORE)
    -+		rc = __copy_to_user_with_key((void __user *)hva, data, len, key);
    ++		rc = copy_to_user_key((void __user *)hva, data, len, access_key);
     +	else
    -+		rc = __copy_from_user_with_key(data, (void __user *)hva, len, key);
    ++		rc = copy_from_user_key(data, (void __user *)hva, len, access_key);
     +	if (rc)
     +		return PGM_PROTECTION;
     +	if (mode == GACC_STORE)
    @@ arch/s390/kvm/gaccess.c: static int access_guest_page(struct kvm *kvm, enum gacc
     +
     +int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
     +			  void *data, unsigned long len, enum gacc_mode mode,
    -+			  char access_key)
    ++			  u8 access_key)
      {
      	psw_t *psw = &vcpu->arch.sie_block->gpsw;
      	unsigned long nr_pages, idx;
    @@ arch/s390/kvm/gaccess.c: int access_guest(struct kvm_vcpu *vcpu, unsigned long g
      		ipte_lock(vcpu);
     -	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
     -	for (idx = 0; idx < nr_pages && !rc; idx++) {
    ++	/*
    ++	 * Since we do the access further down ultimately via a move instruction
    ++	 * that does key checking and returns an error in case of a protection
    ++	 * violation, we don't need to do the check during address translation.
    ++	 * Skip it by passing access key 0, which matches any storage key,
    ++	 * obviating the need for any further checks. As a result the check is
    ++	 * handled entirely in hardware on access, we only need to take care to
    ++	 * forego key protection checking if fetch protection override applies or
    ++	 * retry with the special key 9 in case of storage protection override.
    ++	 */
     +	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode, 0);
     +	if (rc)
     +		goto out_unlock;
    @@ arch/s390/kvm/gaccess.c: int access_guest(struct kvm_vcpu *vcpu, unsigned long g
     +		ga = kvm_s390_logical_to_effective(vcpu, ga + fragment_len);
      	}
     +	if (rc > 0)
    -+		rc = trans_exc(vcpu, rc, ga, 0, mode, prot);
    ++		rc = trans_exc(vcpu, rc, ga, ar, mode, prot);
     +out_unlock:
      	if (need_ipte_lock)
      		ipte_unlock(vcpu);
    @@ arch/s390/kvm/gaccess.c: int access_guest_real(struct kvm_vcpu *vcpu, unsigned l
     -			    unsigned long *gpa, enum gacc_mode mode)
     +int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
     +				     unsigned long *gpa, enum gacc_mode mode,
    -+				     char access_key)
    ++				     u8 access_key)
      {
      	union asce asce;
      	int rc;
    @@ arch/s390/kvm/gaccess.c: int guest_translate_address(struct kvm_vcpu *vcpu, unsi
      		return rc;
     -	return guest_range_to_gpas(vcpu, gva, ar, gpa, 1, asce, mode);
     +	return guest_range_to_gpas(vcpu, gva, ar, gpa, 1, asce, mode,
    -+				 access_key);
    ++				   access_key);
     +}
     +
     +int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
     +			    unsigned long *gpa, enum gacc_mode mode)
     +{
    -+	char access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
    ++	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
     +
     +	return guest_translate_address_with_key(vcpu, gva, ar, gpa, mode,
     +						access_key);
    @@ arch/s390/kvm/gaccess.c: int guest_translate_address(struct kvm_vcpu *vcpu, unsi
       */
      int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
     -		    unsigned long length, enum gacc_mode mode)
    -+		    unsigned long length, enum gacc_mode mode,
    -+		    char access_key)
    ++		    unsigned long length, enum gacc_mode mode, u8 access_key)
      {
      	union asce asce;
      	int rc = 0;
    @@ arch/s390/kvm/gaccess.h: enum gacc_mode {
      
     +int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
     +				     unsigned long *gpa, enum gacc_mode mode,
    -+				     char access_key);
    ++				     u8 access_key);
     +
      int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva,
      			    u8 ar, unsigned long *gpa, enum gacc_mode mode);
     +
      int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
     -		    unsigned long length, enum gacc_mode mode);
    -+		    unsigned long length, enum gacc_mode mode,
    -+		    char access_key);
    ++		    unsigned long length, enum gacc_mode mode, u8 access_key);
      
     -int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
     -		 unsigned long len, enum gacc_mode mode);
     +int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
     +			  void *data, unsigned long len, enum gacc_mode mode,
    -+			  char access_key);
    ++			  u8 access_key);
      
      int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
      		      void *data, unsigned long len, enum gacc_mode mode);
    @@ arch/s390/kvm/gaccess.h: int access_guest_real(struct kvm_vcpu *vcpu, unsigned l
       */
      static inline __must_check
     +int write_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
    -+			 void *data, unsigned long len, char access_key)
    ++			 void *data, unsigned long len, u8 access_key)
     +{
     +	return access_guest_with_key(vcpu, ga, ar, data, len, GACC_STORE,
     +				     access_key);
    @@ arch/s390/kvm/gaccess.h: int access_guest_real(struct kvm_vcpu *vcpu, unsigned l
      		unsigned long len)
      {
     -	return access_guest(vcpu, ga, ar, data, len, GACC_STORE);
    -+	char access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
    ++	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
     +
     +	return write_guest_with_key(vcpu, ga, ar, data, len, access_key);
     +}
    @@ arch/s390/kvm/gaccess.h: int access_guest_real(struct kvm_vcpu *vcpu, unsigned l
     + */
     +static inline __must_check
     +int read_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
    -+			void *data, unsigned long len, char access_key)
    ++			void *data, unsigned long len, u8 access_key)
     +{
     +	return access_guest_with_key(vcpu, ga, ar, data, len, GACC_FETCH,
     +				     access_key);
    @@ arch/s390/kvm/gaccess.h: int write_guest(struct kvm_vcpu *vcpu, unsigned long ga
      	       unsigned long len)
      {
     -	return access_guest(vcpu, ga, ar, data, len, GACC_FETCH);
    -+	char access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
    ++	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
     +
     +	return read_guest_with_key(vcpu, ga, ar, data, len, access_key);
      }
    @@ arch/s390/kvm/gaccess.h: static inline __must_check
      		     unsigned long len)
      {
     -	return access_guest(vcpu, ga, 0, data, len, GACC_IFETCH);
    -+	char access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
    ++	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
     +
     +	return access_guest_with_key(vcpu, ga, 0, data, len, GACC_IFETCH,
     +				     access_key);
 3:  794aa5ded474 !  3:  dc1f00356bf5 KVM: s390: handle_tprot: Honor storage keys
    @@ Commit message
     
      ## arch/s390/kvm/gaccess.c ##
     @@ arch/s390/kvm/gaccess.c: int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u
    - 				 access_key);
    + 				   access_key);
      }
      
     -int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
     -			    unsigned long *gpa, enum gacc_mode mode)
     -{
    --	char access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
    +-	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
     -
     -	return guest_translate_address_with_key(vcpu, gva, ar, gpa, mode,
     -						access_key);
    @@ arch/s390/kvm/gaccess.c: int guest_translate_address_with_key(struct kvm_vcpu *v
      ## arch/s390/kvm/gaccess.h ##
     @@ arch/s390/kvm/gaccess.h: int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u
      				     unsigned long *gpa, enum gacc_mode mode,
    - 				     char access_key);
    + 				     u8 access_key);
      
     -int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva,
     -			    u8 ar, unsigned long *gpa, enum gacc_mode mode);
     -
      int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
    - 		    unsigned long length, enum gacc_mode mode,
    - 		    char access_key);
    + 		    unsigned long length, enum gacc_mode mode, u8 access_key);
    + 
     
      ## arch/s390/kvm/priv.c ##
     @@ arch/s390/kvm/priv.c: int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
    @@ arch/s390/kvm/priv.c: int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
     -	int ret = 0, cc = 0;
     +	u64 address, operand2;
     +	unsigned long gpa;
    -+	char access_key;
    ++	u8 access_key;
      	bool writable;
     +	int ret, cc;
      	u8 ar;
 4:  df00883ee516 !  4:  6eac8a0f969a KVM: s390: selftests: Test TEST PROTECTION emulation
    @@ tools/testing/selftests/kvm/.gitignore
      /s390x/resets
      /s390x/sync_regs_test
     +/s390x/tprot
    + /x86_64/amx_test
    + /x86_64/cpuid_test
      /x86_64/cr4_cpuid_sync_test
    - /x86_64/debug_regs
    - /x86_64/evmcs_test
     
      ## tools/testing/selftests/kvm/Makefile ##
     @@ tools/testing/selftests/kvm/Makefile: TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
    @@ tools/testing/selftests/kvm/s390x/tprot.c (new)
     +// SPDX-License-Identifier: GPL-2.0-or-later
     +/*
     + * Test TEST PROTECTION emulation.
    -+ * In order for emulation occur the target page has to be DAT protected in the
    -+ * host mappings. Since the page tables are shared, we can use mprotect
    -+ * to achieve this.
     + *
     + * Copyright IBM Corp. 2021
     + */
    @@ tools/testing/selftests/kvm/s390x/tprot.c (new)
     +static uint8_t *const page_store_prot = pages[0];
     +static uint8_t *const page_fetch_prot = pages[1];
     +
    ++/* Nonzero return value indicates that address not mapped */
     +static int set_storage_key(void *addr, uint8_t key)
     +{
     +	int not_mapped = 0;
    @@ tools/testing/selftests/kvm/s390x/tprot.c (new)
     +enum permission {
     +	READ_WRITE = 0,
     +	READ = 1,
    -+	NONE = 2,
    -+	UNAVAILABLE = 3,
    ++	RW_PROTECTED = 2,
    ++	TRANSL_UNAVAIL = 3,
     +};
     +
     +static enum permission test_protection(void *addr, uint8_t key)
    @@ tools/testing/selftests/kvm/s390x/tprot.c (new)
     +		: "cc"
     +	);
     +
    -+	return (enum permission)mask >> 28;
    ++	return (enum permission)(mask >> 28);
     +}
     +
     +enum stage {
    @@ tools/testing/selftests/kvm/s390x/tprot.c (new)
     +	uint8_t key;
     +	enum permission expected;
     +} tests[] = {
    -+	/* Those which result in NONE/UNAVAILABLE will be interpreted by SIE,
    -+	 * not KVM, but there is no harm in testing them also.
    ++	/*
    ++	 * We perform each test in the array by executing TEST PROTECTION on
    ++	 * the specified addr with the specified key and checking if the returned
    ++	 * permissions match the expected value.
    ++	 * Both guest and host cooperate to set up the required test conditions.
    ++	 * A central condition is that the page targeted by addr has to be DAT
    ++	 * protected in the host mappings, in order for KVM to emulate the
    ++	 * TEST PROTECTION instruction.
    ++	 * Since the page tables are shared, the host uses mprotect to achieve
    ++	 * this.
    ++	 *
    ++	 * Test resulting in RW_PROTECTED/TRANSL_UNAVAIL will be interpreted
    ++	 * by SIE, not KVM, but there is no harm in testing them also.
     +	 * See Enhanced Suppression-on-Protection Facilities in the
     +	 * Interpretive-Execution Mode
     +	 */
    ++	/*
    ++	 * guest: set storage key of page_store_prot to 1
    ++	 *        storage key of page_fetch_prot to 9 and enable
    ++	 *        protection for it
    ++	 * STAGE_INIT_SIMPLE
    ++	 * host: write protect both via mprotect
    ++	 */
    ++	/* access key 0 matches any storage key -> RW */
     +	{ TEST_SIMPLE, page_store_prot, 0x00, READ_WRITE },
    ++	/* access key matches storage key -> RW */
     +	{ TEST_SIMPLE, page_store_prot, 0x10, READ_WRITE },
    ++	/* mismatched keys, but no fetch protection -> RO */
     +	{ TEST_SIMPLE, page_store_prot, 0x20, READ },
    ++	/* access key 0 matches any storage key -> RW */
     +	{ TEST_SIMPLE, page_fetch_prot, 0x00, READ_WRITE },
    ++	/* access key matches storage key -> RW */
     +	{ TEST_SIMPLE, page_fetch_prot, 0x90, READ_WRITE },
    -+	{ TEST_SIMPLE, page_fetch_prot, 0x10, NONE },
    -+	{ TEST_SIMPLE, (void *)0x00, 0x10, UNAVAILABLE },
    -+	/* Fetch-protection override */
    ++	/* mismatched keys, fetch protection -> inaccessible */
    ++	{ TEST_SIMPLE, page_fetch_prot, 0x10, RW_PROTECTED },
    ++	/* page 0 not mapped yet -> translation not available */
    ++	{ TEST_SIMPLE, (void *)0x00, 0x10, TRANSL_UNAVAIL },
    ++	/*
    ++	 * host: try to map page 0
    ++	 * guest: set storage key of page 0 to 9 and enable fetch protection
    ++	 * STAGE_INIT_FETCH_PROT_OVERRIDE
    ++	 * host: write protect page 0
    ++	 *       enable fetch protection override
    ++	 */
    ++	/* mismatched keys, fetch protection, but override applies -> RO */
     +	{ TEST_FETCH_PROT_OVERRIDE, (void *)0x00, 0x10, READ },
    -+	{ TEST_FETCH_PROT_OVERRIDE, (void *)2049, 0x10, NONE },
    -+	/* Storage-protection override */
    ++	/* mismatched keys, fetch protection, override applies to 0-2048 only -> inaccessible */
    ++	{ TEST_FETCH_PROT_OVERRIDE, (void *)2049, 0x10, RW_PROTECTED },
    ++	/*
    ++	 * host: enable storage protection override
    ++	 */
    ++	/* mismatched keys, but override applies (storage key 9) -> RW */
     +	{ TEST_STORAGE_PROT_OVERRIDE, page_fetch_prot, 0x10, READ_WRITE },
    ++	/* mismatched keys, no fetch protection, override doesn't apply -> RO */
     +	{ TEST_STORAGE_PROT_OVERRIDE, page_store_prot, 0x20, READ },
    ++	/* mismatched keys, but override applies (storage key 9) -> RW */
     +	{ TEST_STORAGE_PROT_OVERRIDE, (void *)2049, 0x10, READ_WRITE },
    -+	/* End marker */
    ++	/* end marker */
     +	{ STAGE_END, 0, 0, 0 },
     +};
     +
    @@ tools/testing/selftests/kvm/s390x/tprot.c (new)
     +	bool skip;
     +
     +	for (; tests[*i].stage == stage; (*i)++) {
    ++		/*
    ++		 * Some fetch protection override tests require that page 0
    ++		 * be mapped, however, when the hosts tries to map that page via
    ++		 * vm_vaddr_alloc, it may happen that some other page gets mapped
    ++		 * instead.
    ++		 * In order to skip these tests we detect this inside the guest
    ++		 */
     +		skip = tests[*i].addr < (void *)4096 &&
    -+		       !mapped_0 &&
    -+		       tests[*i].expected != UNAVAILABLE;
    ++		       tests[*i].expected != TRANSL_UNAVAIL &&
    ++		       !mapped_0;
     +		if (!skip) {
     +			result = test_protection(tests[*i].addr, tests[*i].key);
     +			GUEST_ASSERT_2(result == tests[*i].expected, *i, result);
 5:  8a83549d76fa !  5:  ccd4ec096613 KVM: s390: Add optional storage key checking to MEMOP IOCTL
    @@ Commit message
         User space needs a mechanism to perform key checked accesses when
         emulating instructions.
     
    -    The key can be passed as an additional argument via the flags field.
    -    As reserved flags need to be 0, and key 0 matches all storage keys,
    -    by default no key checking is performed, as before.
    +    The key can be passed as an additional argument.
         Having an additional argument is flexible, as user space can
         pass the guest PSW's key, in order to make an access the same way the
         CPU would, or pass another key if necessary.
    @@ arch/s390/kvm/kvm-s390.c
      
      #include <asm/asm-offsets.h>
      #include <asm/lowcore.h>
    +@@ arch/s390/kvm/kvm-s390.c: static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
    + 	return r;
    + }
    + 
    ++static bool access_key_invalid(u8 access_key)
    ++{
    ++	return access_key > 0xf;
    ++}
    ++
    + long kvm_arch_vm_ioctl(struct file *filp,
    + 		       unsigned int ioctl, unsigned long arg)
    + {
     @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
    + 				  struct kvm_s390_mem_op *mop)
      {
      	void __user *uaddr = (void __user *)mop->buf;
    ++	u8 access_key = 0, ar = 0;
      	void *tmpbuf = NULL;
    -+	char access_key = 0;
    ++	bool check_reserved;
      	int r = 0;
      	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
     -				    | KVM_S390_MEMOP_F_CHECK_ONLY;
     +				    | KVM_S390_MEMOP_F_CHECK_ONLY
    -+				    | KVM_S390_MEMOP_F_SKEYS_ACC;
    ++				    | KVM_S390_MEMOP_F_SKEY_PROTECTION;
      
    - 	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
    +-	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
    ++	if (mop->flags & ~supported_flags || !mop->size)
      		return -EINVAL;
    -@@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
    +-
    + 	if (mop->size > MEM_OP_MAX_SIZE)
    + 		return -E2BIG;
    +-
    + 	if (kvm_s390_pv_cpu_is_protected(vcpu))
    + 		return -EINVAL;
    +-
    + 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
    + 		tmpbuf = vmalloc(mop->size);
    + 		if (!tmpbuf)
      			return -ENOMEM;
      	}
    ++	ar = mop->ar;
    ++	mop->ar = 0;
    ++	if (ar >= NUM_ACRS)
    ++		return -EINVAL;
    ++	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
    ++		access_key = mop->key;
    ++		mop->key = 0;
    ++		if (access_key_invalid(access_key))
    ++			return -EINVAL;
    ++	}
    ++	/*
    ++	 * Check that reserved/unused == 0, but only for extensions,
    ++	 * so we stay backward compatible.
    ++	 * This gives us more design flexibility for future extensions, i.e.
    ++	 * we can add functionality without adding a flag.
    ++	 */
    ++	check_reserved = mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION;
    ++	if (check_reserved && memchr_inv(&mop->reserved, 0, sizeof(mop->reserved)))
    ++		return -EINVAL;
      
    -+	access_key = FIELD_GET(KVM_S390_MEMOP_F_SKEYS_ACC, mop->flags);
    -+
      	switch (mop->op) {
      	case KVM_S390_MEMOP_LOGICAL_READ:
      		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
     -			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
     -					    mop->size, GACC_FETCH, 0);
    -+			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
    ++			r = check_gva_range(vcpu, mop->gaddr, ar, mop->size,
     +					    GACC_FETCH, access_key);
      			break;
      		}
     -		r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
    -+		r = read_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
    ++		r = read_guest_with_key(vcpu, mop->gaddr, ar, tmpbuf,
     +					mop->size, access_key);
      		if (r == 0) {
      			if (copy_to_user(uaddr, tmpbuf, mop->size))
    @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcp
      		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
     -			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
     -					    mop->size, GACC_STORE, 0);
    -+			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
    ++			r = check_gva_range(vcpu, mop->gaddr, ar, mop->size,
     +					    GACC_STORE, access_key);
      			break;
      		}
    @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcp
      			break;
      		}
     -		r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
    -+		r = write_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
    ++		r = write_guest_with_key(vcpu, mop->gaddr, ar, tmpbuf,
     +					 mop->size, access_key);
      		break;
      	}
      
     
      ## include/uapi/linux/kvm.h ##
    +@@ include/uapi/linux/kvm.h: struct kvm_s390_mem_op {
    + 	__u32 op;		/* type of operation */
    + 	__u64 buf;		/* buffer in userspace */
    + 	union {
    +-		__u8 ar;	/* the access register number */
    ++		struct {
    ++			__u8 ar;	/* the access register number */
    ++			__u8 key;	/* access key to use for storage key protection */
    ++		};
    + 		__u32 sida_offset; /* offset into the sida */
    +-		__u8 reserved[32]; /* should be set to 0 */
    ++		__u8 reserved[32]; /* must be set to 0 */
    + 	};
    + };
    + /* types for kvm_s390_mem_op->op */
     @@ include/uapi/linux/kvm.h: struct kvm_s390_mem_op {
      /* flags for kvm_s390_mem_op->flags */
      #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
      #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
    -+#define KVM_S390_MEMOP_F_SKEYS_ACC		0x0f00ULL
    ++#define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
      
      /* for KVM_INTERRUPT */
      struct kvm_interrupt {
 6:  c5d59f1894d4 !  6:  9b99399f7958 KVM: s390: Add vm IOCTL for key checked guest absolute memory access
    @@ Commit message
         checked accesses.
         The vm IOCTL supports read/write accesses, as well as checking
         if an access would succeed.
    +    Unlike relying on KVM_S390_GET_SKEYS for key checking would,
    +    the vm IOCTL performs the check in lockstep with the read or write,
    +    by, ultimately, mapping the access to move instructions that
    +    support key protection checking with a supplied key.
    +    Fetch and storage protection override are not applicable to absolute
    +    accesses and so are not applied as they are when using the vcpu memop.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
         Acked-by: Janosch Frank <frankja@linux.ibm.com>
    @@ arch/s390/kvm/gaccess.c: static int low_address_protection_enabled(struct kvm_vc
      	return 1;
      }
      
    -+static int vm_check_access_key(struct kvm *kvm, char access_key,
    ++static int vm_check_access_key(struct kvm *kvm, u8 access_key,
     +			       enum gacc_mode mode, gpa_t gpa)
     +{
    -+	unsigned long hva;
    -+	unsigned char storage_key, access_control;
    ++	u8 storage_key, access_control;
     +	bool fetch_protected;
    ++	unsigned long hva;
     +	int r;
     +
     +	if (access_key == 0)
    @@ arch/s390/kvm/gaccess.c: access_guest_page_with_key(struct kvm *kvm, enum gacc_m
      }
      
     +int access_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, void *data,
    -+			      unsigned long len, enum gacc_mode mode, char key)
    ++			      unsigned long len, enum gacc_mode mode, u8 access_key)
     +{
     +	int offset = offset_in_page(gpa);
     +	int fragment_len;
    @@ arch/s390/kvm/gaccess.c: access_guest_page_with_key(struct kvm *kvm, enum gacc_m
     +
     +	while (min(PAGE_SIZE - offset, len) > 0) {
     +		fragment_len = min(PAGE_SIZE - offset, len);
    -+		rc = access_guest_page_with_key(kvm, mode, gpa, data, fragment_len, key);
    ++		rc = access_guest_page_with_key(kvm, mode, gpa, data, fragment_len, access_key);
     +		if (rc)
     +			return rc;
     +		offset = 0;
    @@ arch/s390/kvm/gaccess.c: access_guest_page_with_key(struct kvm *kvm, enum gacc_m
     +
      int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
      			  void *data, unsigned long len, enum gacc_mode mode,
    - 			  char access_key)
    + 			  u8 access_key)
     @@ arch/s390/kvm/gaccess.c: int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
      	return rc;
      }
    @@ arch/s390/kvm/gaccess.c: int check_gva_range(struct kvm_vcpu *vcpu, unsigned lon
     + * @access_key: access key to mach the storage keys with
     + */
     +int check_gpa_range(struct kvm *kvm, unsigned long gpa, unsigned long length,
    -+		    enum gacc_mode mode, char access_key)
    ++		    enum gacc_mode mode, u8 access_key)
     +{
     +	unsigned int fragment_len;
     +	int rc = 0;
    @@ arch/s390/kvm/gaccess.c: int check_gva_range(struct kvm_vcpu *vcpu, unsigned lon
       * @vcpu: virtual cpu
     
      ## arch/s390/kvm/gaccess.h ##
    -@@ arch/s390/kvm/gaccess.h: int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
    - 		    unsigned long length, enum gacc_mode mode,
    - 		    char access_key);
    +@@ arch/s390/kvm/gaccess.h: int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u
    + int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
    + 		    unsigned long length, enum gacc_mode mode, u8 access_key);
      
     +int check_gpa_range(struct kvm *kvm, unsigned long gpa, unsigned long length,
    -+		    enum gacc_mode mode, char access_key);
    ++		    enum gacc_mode mode, u8 access_key);
     +
     +int access_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, void *data,
    -+			      unsigned long len, enum gacc_mode mode, char key);
    ++			      unsigned long len, enum gacc_mode mode, u8 access_key);
     +
      int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
      			  void *data, unsigned long len, enum gacc_mode mode,
    - 			  char access_key);
    + 			  u8 access_key);
     
      ## arch/s390/kvm/kvm-s390.c ##
    -@@ arch/s390/kvm/kvm-s390.c: static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
    - 	return r;
    +@@ arch/s390/kvm/kvm-s390.c: static bool access_key_invalid(u8 access_key)
    + 	return access_key > 0xf;
      }
      
     +static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
     +{
    -+	static const __u8 zeros[sizeof(mop->reserved)] = {0};
     +	void __user *uaddr = (void __user *)mop->buf;
     +	u64 supported_flags;
     +	void *tmpbuf = NULL;
    -+	char access_key;
    ++	u8 access_key = 0;
     +	int r, srcu_idx;
     +
    -+	access_key = FIELD_GET(KVM_S390_MEMOP_F_SKEYS_ACC, mop->flags);
    -+	supported_flags = KVM_S390_MEMOP_F_SKEYS_ACC
    ++	supported_flags = KVM_S390_MEMOP_F_SKEY_PROTECTION
     +			  | KVM_S390_MEMOP_F_CHECK_ONLY;
     +	if (mop->flags & ~supported_flags)
     +		return -EINVAL;
    @@ arch/s390/kvm/kvm-s390.c: static int kvm_s390_handle_pv(struct kvm *kvm, struct
     +		return -E2BIG;
     +	if (kvm_s390_pv_is_protected(kvm))
     +		return -EINVAL;
    -+	if (memcmp(mop->reserved, zeros, sizeof(zeros)) != 0)
    -+		return -EINVAL;
    -+
     +	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
     +		tmpbuf = vmalloc(mop->size);
     +		if (!tmpbuf)
     +			return -ENOMEM;
     +	}
    ++	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
    ++		access_key = mop->key;
    ++		mop->key = 0;
    ++		if (access_key_invalid(access_key))
    ++			return -EINVAL;
    ++	}
    ++	if (memchr_inv(&mop->reserved, 0, sizeof(mop->reserved)))
    ++		return -EINVAL;
     +
     +	srcu_idx = srcu_read_lock(&kvm->srcu);
     +
 7:  52d7be8fe69d !  7:  e3047ac90594 KVM: s390: Rename existing vcpu memop functions
    @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_sida_op(struct kvm_vcpu *vc
     +				 struct kvm_s390_mem_op *mop)
      {
      	void __user *uaddr = (void __user *)mop->buf;
    - 	void *tmpbuf = NULL;
    + 	u8 access_key = 0, ar = 0;
     @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
      	return r;
      }
 8:  b486a58a72ce !  8:  058a6fbaf7dc KVM: s390: selftests: Test memops with storage keys
    @@ tools/testing/selftests/kvm/s390x/memop.c
      #define VCPU_ID 1
      
     +const uint64_t last_page_addr = UINT64_MAX - PAGE_SIZE + 1;
    -+const unsigned int key_shift = ffs(KVM_S390_MEMOP_F_SKEYS_ACC) - 1;
     +
      static uint8_t mem1[65536];
      static uint8_t mem2[65536];
      
    -+static void set_storage_key_range(void *addr, size_t len, char key)
    ++static void set_storage_key_range(void *addr, size_t len, u8 key)
     +{
     +	uintptr_t _addr, abs, i;
     +
    @@ tools/testing/selftests/kvm/s390x/memop.c
     +	};
     +
     +	return _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
    -+}
    -+
    + }
    + 
     +static void vcpu_read_guest(struct kvm_vm *vm, void *host_addr,
     +			    uintptr_t guest_addr, size_t len)
     +{
    @@ tools/testing/selftests/kvm/s390x/memop.c
     +}
     +
     +static int _vcpu_read_guest_key(struct kvm_vm *vm, void *host_addr,
    -+				uintptr_t guest_addr, size_t len, char key)
    ++				uintptr_t guest_addr, size_t len, u8 access_key)
     +{
    -+	struct kvm_s390_mem_op ksmo = {
    -+		.gaddr = guest_addr,
    -+		.flags = key << key_shift,
    -+		.size = len,
    -+		.op = KVM_S390_MEMOP_LOGICAL_READ,
    -+		.buf = (uintptr_t)host_addr,
    -+		.ar = 0,
    -+	};
    ++	struct kvm_s390_mem_op ksmo = {0};
    ++
    ++	ksmo.gaddr = guest_addr;
    ++	ksmo.flags = KVM_S390_MEMOP_F_SKEY_PROTECTION;
    ++	ksmo.size = len;
    ++	ksmo.op = KVM_S390_MEMOP_LOGICAL_READ;
    ++	ksmo.buf = (uintptr_t)host_addr;
    ++	ksmo.ar = 0;
    ++	ksmo.key = access_key;
     +
     +	return _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
     +}
     +
     +static void vcpu_read_guest_key(struct kvm_vm *vm, void *host_addr,
    -+				uintptr_t guest_addr, size_t len, char key)
    ++				uintptr_t guest_addr, size_t len, u8 access_key)
     +{
     +	int rv;
     +
    -+	rv = _vcpu_read_guest_key(vm, host_addr, guest_addr, len, key);
    ++	rv = _vcpu_read_guest_key(vm, host_addr, guest_addr, len, access_key);
     +	TEST_ASSERT(rv == 0, "vcpu memop read failed: reason = %d\n", rv);
     +}
     +
    @@ tools/testing/selftests/kvm/s390x/memop.c
     +}
     +
     +static int _vcpu_write_guest_key(struct kvm_vm *vm, uintptr_t guest_addr,
    -+				 void *host_addr, size_t len, char key)
    ++				 void *host_addr, size_t len, u8 access_key)
     +{
    -+	struct kvm_s390_mem_op ksmo = {
    -+		.gaddr = guest_addr,
    -+		.flags = key << key_shift,
    -+		.size = len,
    -+		.op = KVM_S390_MEMOP_LOGICAL_WRITE,
    -+		.buf = (uintptr_t)host_addr,
    -+		.ar = 0,
    -+	};
    ++	struct kvm_s390_mem_op ksmo = {0};
    ++
    ++	ksmo.gaddr = guest_addr;
    ++	ksmo.flags = KVM_S390_MEMOP_F_SKEY_PROTECTION;
    ++	ksmo.size = len;
    ++	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
    ++	ksmo.buf = (uintptr_t)host_addr;
    ++	ksmo.ar = 0;
    ++	ksmo.key = access_key;
     +
     +	return _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
     +}
     +
     +static void vcpu_write_guest_key(struct kvm_vm *vm, uintptr_t guest_addr,
    -+				 void *host_addr, size_t len, char key)
    ++				 void *host_addr, size_t len, u8 access_key)
     +{
     +	int rv;
     +
    -+	rv = _vcpu_write_guest_key(vm, guest_addr, host_addr, len, key);
    ++	rv = _vcpu_write_guest_key(vm, guest_addr, host_addr, len, access_key);
     +	TEST_ASSERT(rv == 0, "vcpu memop write failed: reason = %d\n", rv);
     +}
     +
     +static int _vm_read_guest_key(struct kvm_vm *vm, void *host_addr,
    -+			      uintptr_t guest_addr, size_t len, char key)
    ++			      uintptr_t guest_addr, size_t len, u8 access_key)
     +{
    -+	struct kvm_s390_mem_op ksmo = {
    -+		.gaddr = guest_addr,
    -+		.flags = key << key_shift,
    -+		.size = len,
    -+		.op = KVM_S390_MEMOP_ABSOLUTE_READ,
    -+		.buf = (uintptr_t)host_addr,
    -+		.reserved = {0},
    -+	};
    ++	struct kvm_s390_mem_op ksmo = {0};
    ++
    ++	ksmo.gaddr = guest_addr;
    ++	ksmo.flags = KVM_S390_MEMOP_F_SKEY_PROTECTION;
    ++	ksmo.size = len;
    ++	ksmo.op = KVM_S390_MEMOP_ABSOLUTE_READ;
    ++	ksmo.buf = (uintptr_t)host_addr;
    ++	ksmo.key = access_key;
     +
     +	return _vm_ioctl(vm, KVM_S390_MEM_OP, &ksmo);
     +}
     +
     +static void vm_read_guest_key(struct kvm_vm *vm, void *host_addr,
    -+			      uintptr_t guest_addr, size_t len, char key)
    ++			      uintptr_t guest_addr, size_t len, u8 access_key)
     +{
     +	int rv;
     +
    -+	rv = _vm_read_guest_key(vm, host_addr, guest_addr, len, key);
    ++	rv = _vm_read_guest_key(vm, host_addr, guest_addr, len, access_key);
     +	TEST_ASSERT(rv == 0, "vm memop read failed: reason = %d\n", rv);
     +}
     +
     +static int _vm_write_guest_key(struct kvm_vm *vm, uintptr_t guest_addr,
    -+			       void *host_addr, size_t len, char key)
    ++			       void *host_addr, size_t len, u8 access_key)
     +{
    -+	struct kvm_s390_mem_op ksmo = {
    -+		.gaddr = guest_addr,
    -+		.flags = key << key_shift,
    -+		.size = len,
    -+		.op = KVM_S390_MEMOP_ABSOLUTE_WRITE,
    -+		.buf = (uintptr_t)host_addr,
    -+		.reserved = {0},
    -+	};
    ++	struct kvm_s390_mem_op ksmo = {0};
    ++
    ++	ksmo.gaddr = guest_addr;
    ++	ksmo.flags = KVM_S390_MEMOP_F_SKEY_PROTECTION;
    ++	ksmo.size = len;
    ++	ksmo.op = KVM_S390_MEMOP_ABSOLUTE_WRITE;
    ++	ksmo.buf = (uintptr_t)host_addr;
    ++	ksmo.key = access_key;
     +
     +	return _vm_ioctl(vm, KVM_S390_MEM_OP, &ksmo);
     +}
     +
     +static void vm_write_guest_key(struct kvm_vm *vm, uintptr_t guest_addr,
    -+			       void *host_addr, size_t len, char key)
    ++			       void *host_addr, size_t len, u8 access_key)
     +{
     +	int rv;
     +
    -+	rv = _vm_write_guest_key(vm, guest_addr, host_addr, len, key);
    ++	rv = _vm_write_guest_key(vm, guest_addr, host_addr, len, access_key);
     +	TEST_ASSERT(rv == 0, "vm memop write failed: reason = %d\n", rv);
     +}
     +
    @@ tools/testing/selftests/kvm/s390x/memop.c
     +};
     +
     +static int _vm_check_guest_key(struct kvm_vm *vm, enum access_mode mode,
    -+			       uintptr_t guest_addr, size_t len, char key)
    ++			       uintptr_t guest_addr, size_t len, u8 access_key)
     +{
    -+	int op;
    ++	struct kvm_s390_mem_op ksmo = {0};
     +
    ++	ksmo.gaddr = guest_addr;
    ++	ksmo.flags = KVM_S390_MEMOP_F_CHECK_ONLY | KVM_S390_MEMOP_F_SKEY_PROTECTION;
    ++	ksmo.size = len;
     +	if (mode == ACCESS_READ)
    -+		op = KVM_S390_MEMOP_ABSOLUTE_READ;
    ++		ksmo.op = KVM_S390_MEMOP_ABSOLUTE_READ;
     +	else
    -+		op = KVM_S390_MEMOP_ABSOLUTE_WRITE;
    -+	struct kvm_s390_mem_op ksmo = {
    -+		.gaddr = guest_addr,
    -+		.flags = key << key_shift | KVM_S390_MEMOP_F_CHECK_ONLY,
    -+		.size = len,
    -+		.op = op,
    -+		.reserved = {0},
    -+	};
    ++		ksmo.op = KVM_S390_MEMOP_ABSOLUTE_WRITE;
    ++	ksmo.key = access_key;
     +
     +	return _vm_ioctl(vm, KVM_S390_MEM_OP, &ksmo);
    - }
    - 
    ++}
    ++
     +static void vm_check_guest_key(struct kvm_vm *vm, enum access_mode mode,
    -+			       uintptr_t guest_addr, size_t len, char key)
    ++			       uintptr_t guest_addr, size_t len, u8 access_key)
     +{
     +	int rv;
     +
    -+	rv = _vm_check_guest_key(vm, mode, guest_addr, len, key);
    ++	rv = _vm_check_guest_key(vm, mode, guest_addr, len, access_key);
     +	TEST_ASSERT(rv == 0, "vm memop write failed: reason = %d\n", rv);
     +}
     +
    @@ tools/testing/selftests/kvm/s390x/memop.c: int main(int argc, char *argv[])
     +		/* Set fetch protection */
     +		HOST_SYNC(vm, 50);
     +
    -+		/* Write without key, read back, machting key, fetch protection */
    ++		/* Write without key, read back, matching key, fetch protection */
     +		reroll_mem1();
     +		vcpu_write_guest(vm, guest_0_page, mem1, PAGE_SIZE);
     +		memset(mem2, 0xaa, sizeof(mem2));
    @@ tools/testing/selftests/kvm/s390x/memop.c: int main(int argc, char *argv[])
     +		if (guest_0_page != 0)
     +			print_skip("Did not allocate page at 0 for fetch protection override test");
     +
    -+		/* Write without key, read back, mismachting key,
    ++		/* Write without key, read back, mismatching key,
     +		 * fetch protection override, 1 page
     +		 */
     +		if (guest_0_page == 0) {
    @@ tools/testing/selftests/kvm/s390x/memop.c: int main(int argc, char *argv[])
     +		if (guest_last_page != last_page_addr)
     +			print_skip("Did not allocate last page for fetch protection override test");
     +
    -+		/* Write without key, read back, mismachting key,
    ++		/* Write without key, read back, mismatching key,
     +		 * fetch protection override, 2 pages, last page not fetch protected
     +		 */
     +		reroll_mem1();
 9:  23aabd53c7ab !  9:  f93003ab633d KVM: s390: Add capability for storage key extension of MEM_OP IOCTL
    @@ Metadata
      ## Commit message ##
         KVM: s390: Add capability for storage key extension of MEM_OP IOCTL
     
    -    Availability of the KVM_CAP_S390_MEM_OP_SKEY capability signals that:
    +    Availability of the KVM_CAP_S390_MEM_OP_EXTENSION capability signals that:
         * The vcpu MEM_OP IOCTL supports storage key checking.
         * The vm MEM_OP IOCTL exists.
     
    @@ arch/s390/kvm/kvm-s390.c: int kvm_vm_ioctl_check_extension(struct kvm *kvm, long
      	case KVM_CAP_S390_VCPU_RESETS:
      	case KVM_CAP_SET_GUEST_DEBUG:
      	case KVM_CAP_S390_DIAG318:
    -+	case KVM_CAP_S390_MEM_OP_SKEY:
    ++	case KVM_CAP_S390_MEM_OP_EXTENSION:
      		r = 1;
      		break;
      	case KVM_CAP_SET_GUEST_DEBUG2:
     
      ## include/uapi/linux/kvm.h ##
     @@ include/uapi/linux/kvm.h: struct kvm_ppc_resize_hpt {
    - #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
    - #define KVM_CAP_ARM_MTE 205
    - #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
    -+#define KVM_CAP_S390_MEM_OP_SKEY 209
    + #define KVM_CAP_VM_GPA_BITS 207
    + #define KVM_CAP_XSAVE2 208
    + #define KVM_CAP_SYS_ATTRIBUTES 209
    ++#define KVM_CAP_S390_MEM_OP_EXTENSION 210
      
      #ifdef KVM_CAP_IRQ_ROUTING
      
10:  2f2794c72878 ! 10:  2ff8d7f47ffd KVM: s390: selftests: Make use of capability in MEM_OP test
    @@ tools/testing/selftests/kvm/s390x/memop.c: int main(int argc, char *argv[])
      	}
      	if (maxsize > sizeof(mem1))
      		maxsize = sizeof(mem1);
    -+	has_skey_ext = kvm_check_cap(KVM_CAP_S390_MEM_OP_SKEY);
    ++	has_skey_ext = kvm_check_cap(KVM_CAP_S390_MEM_OP_EXTENSION);
     +	if (!has_skey_ext)
    -+		print_skip("CAP_S390_MEM_OP_SKEY not supported");
    ++		print_skip("Storage key extension not supported");
      
      	/* Create VM */
      	vm = vm_create_default(VCPU_ID, 0, guest_code);
 -:  ------------ > 11:  20476660a710 KVM: s390: Update api documentation for memop ioctl

base-commit: dcb85f85fa6f142aae1fe86f399d4503d49f2b60
-- 
2.32.0

