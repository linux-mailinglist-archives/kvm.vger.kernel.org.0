Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840304AF7A6
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbiBIREl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237899AbiBIREc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:04:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE98C05CBB3;
        Wed,  9 Feb 2022 09:04:31 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219GrPli028111;
        Wed, 9 Feb 2022 17:04:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=iz1hViJ1VuZ0amMQDRev53XWSEnp5Z0yb6BMO0Vb5Tc=;
 b=lcBfElolFpkLREfJ+K/iZjSXNiVniIucZfK9VierVoanPLYHuruXRKaMhNzfvRn+13i7
 NByg5MmMC9lAfOKhB9G71tsEOVrKrKz++Xbu7yAuGKLJln9te1Bn6wyZ8vJ1Yh2hmozM
 epTZoLUdD+E8eVi10yo1w+OBC2UtUHbNqKz82nQF94mhdzGDHCvZpFr9u2S2faY9ZlKP
 b8dDy34xPnwz8vqZGVaiAwYKnCmw4Ita85MBSiHZa9fbf/+dC0dEeg2j+fUy1dmbqBxI
 vKXJlKp2VxTJm+TRCRbOzgzDRyeunqpdT6bwoeJ/a20iezHPsimdmaz8GYPHVtYcAy5o nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4ehpw27e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:30 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219EMMM6029218;
        Wed, 9 Feb 2022 17:04:30 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4ehpw26b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:30 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219H3cQY031125;
        Wed, 9 Feb 2022 17:04:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3e1gv9qaq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219H4OWB31392138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 17:04:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1F66A4064;
        Wed,  9 Feb 2022 17:04:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DF78A405B;
        Wed,  9 Feb 2022 17:04:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 17:04:23 +0000 (GMT)
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
Subject: [PATCH v3 00/10] KVM: s390: Do storage key checking
Date:   Wed,  9 Feb 2022 18:04:12 +0100
Message-Id: <20220209170422.1910690-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ARoz3y59cg2OWjnPtCFaDFsmG-3fxBXY
X-Proofpoint-ORIG-GUID: G3wxIiefpyFCKViKOXWk9c6IrW6ibjMt
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_09,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090091
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

v2: https://lore.kernel.org/kvm/20220207165930.1608621-1-scgl@linux.ibm.com/

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
 arch/s390/kvm/kvm-s390.c                  | 129 ++++-
 arch/s390/kvm/priv.c                      |  66 +--
 arch/s390/lib/uaccess.c                   |  81 +++-
 include/uapi/linux/kvm.h                  |  11 +-
 tools/testing/selftests/kvm/.gitignore    |   1 +
 tools/testing/selftests/kvm/Makefile      |   1 +
 tools/testing/selftests/kvm/s390x/memop.c | 558 +++++++++++++++++++---
 tools/testing/selftests/kvm/s390x/tprot.c | 227 +++++++++
 15 files changed, 1372 insertions(+), 186 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/tprot.c


diff against v2, a bit more readable than the range-diff below:
 diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
 index 7b28657fe9de..2d131af44576 100644
 --- a/Documentation/virt/kvm/api.rst
 +++ b/Documentation/virt/kvm/api.rst
 @@ -3683,7 +3683,7 @@ The fields in each entry are defined as follows:
  4.89 KVM_S390_MEM_OP
  --------------------
  
 -:Capability: KVM_CAP_S390_MEM_OP, KVM_CAP_S390_MEM_OP_EXTENSION
 +:Capability: KVM_CAP_S390_MEM_OP, KVM_CAP_S390_PROTECTED, KVM_CAP_S390_MEM_OP_EXTENSION
  :Architectures: s390
  :Type: vm ioctl, vcpu ioctl
  :Parameters: struct kvm_s390_mem_op (in)
 @@ -3706,10 +3706,10 @@ Parameters are specified via the following structure::
  	union {
  		struct {
  			__u8 ar;	/* the access register number */
 -			__u8 key;	/* access key to use for storage key protection */
 +			__u8 key;	/* access key, ignored if flag unset */
  		};
  		__u32 sida_offset; /* offset into the sida */
 -		__u8 reserved[32]; /* must be set to 0 */
 +		__u8 reserved[32]; /* ignored */
  	};
    };
  
 @@ -3720,9 +3720,8 @@ KVM_CAP_S390_MEM_OP capability. "buf" is the buffer supplied by the
  userspace application where the read data should be written to for
  a read access, or where the data that should be written is stored for
  a write access.  The "reserved" field is meant for future extensions.
 -Reserved and unused bytes must be set to 0. If any of the following are used,
 -this is enforced and -EINVAL will be returned:
 -``KVM_S390_MEMOP_ABSOLUTE_READ/WRITE``, ``KVM_S390_MEMOP_F_SKEY_PROTECTION``.
 +Reserved and unused values are ignored. Future extension that add members must
 +introduce new flags.
  
  The type of operation is specified in the "op" field. Flags modifying
  their behavior can be set in the "flags" field. Undefined flag bits must
 @@ -3792,6 +3791,7 @@ SIDA read/write:
  
  Access the secure instruction data area which contains memory operands necessary
  for instruction emulation for secure guests.
 +SIDA accesses are available if the KVM_CAP_S390_PROTECTED capability is available.
  SIDA accesses are permitted for the VCPU ioctl only.
  SIDA accesses are permitted for secure guests only.
  
 diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
 index 4a502cac068c..5b387e75cb5b 100644
 --- a/arch/s390/kvm/kvm-s390.c
 +++ b/arch/s390/kvm/kvm-s390.c
 @@ -2371,7 +2371,6 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
  	void __user *uaddr = (void __user *)mop->buf;
  	u64 supported_flags;
  	void *tmpbuf = NULL;
 -	u8 access_key = 0;
  	int r, srcu_idx;
  
  	supported_flags = KVM_S390_MEMOP_F_SKEY_PROTECTION
 @@ -2382,19 +2381,15 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
  		return -E2BIG;
  	if (kvm_s390_pv_is_protected(kvm))
  		return -EINVAL;
 +	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
 +		if (access_key_invalid(mop->key))
 +			return -EINVAL;
 +	}
  	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
  		tmpbuf = vmalloc(mop->size);
  		if (!tmpbuf)
  			return -ENOMEM;
  	}
 -	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
 -		access_key = mop->key;
 -		mop->key = 0;
 -		if (access_key_invalid(access_key))
 -			return -EINVAL;
 -	}
 -	if (memchr_inv(&mop->reserved, 0, sizeof(mop->reserved)))
 -		return -EINVAL;
  
  	srcu_idx = srcu_read_lock(&kvm->srcu);
  
 @@ -2406,10 +2401,10 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
  	switch (mop->op) {
  	case KVM_S390_MEMOP_ABSOLUTE_READ: {
  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
 -			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_FETCH, access_key);
 +			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_FETCH, mop->key);
  		} else {
  			r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
 -						      mop->size, GACC_FETCH, access_key);
 +						      mop->size, GACC_FETCH, mop->key);
  			if (r == 0) {
  				if (copy_to_user(uaddr, tmpbuf, mop->size))
  					r = -EFAULT;
 @@ -2419,14 +2414,14 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
  	}
  	case KVM_S390_MEMOP_ABSOLUTE_WRITE: {
  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
 -			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_STORE, access_key);
 +			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_STORE, mop->key);
  		} else {
  			if (copy_from_user(tmpbuf, uaddr, mop->size)) {
  				r = -EFAULT;
  				break;
  			}
  			r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
 -						      mop->size, GACC_STORE, access_key);
 +						      mop->size, GACC_STORE, mop->key);
  		}
  		break;
  	}
 @@ -4779,54 +4774,37 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
  				 struct kvm_s390_mem_op *mop)
  {
  	void __user *uaddr = (void __user *)mop->buf;
 -	u8 access_key = 0, ar = 0;
  	void *tmpbuf = NULL;
 -	bool check_reserved;
  	int r = 0;
  	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
  				    | KVM_S390_MEMOP_F_CHECK_ONLY
  				    | KVM_S390_MEMOP_F_SKEY_PROTECTION;
  
 -	if (mop->flags & ~supported_flags || !mop->size)
 +	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
  		return -EINVAL;
  	if (mop->size > MEM_OP_MAX_SIZE)
  		return -E2BIG;
  	if (kvm_s390_pv_cpu_is_protected(vcpu))
  		return -EINVAL;
 +	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
 +		if (access_key_invalid(mop->key))
 +			return -EINVAL;
 +	}
  	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
  		tmpbuf = vmalloc(mop->size);
  		if (!tmpbuf)
  			return -ENOMEM;
  	}
 -	ar = mop->ar;
 -	mop->ar = 0;
 -	if (ar >= NUM_ACRS)
 -		return -EINVAL;
 -	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
 -		access_key = mop->key;
 -		mop->key = 0;
 -		if (access_key_invalid(access_key))
 -			return -EINVAL;
 -	}
 -	/*
 -	 * Check that reserved/unused == 0, but only for extensions,
 -	 * so we stay backward compatible.
 -	 * This gives us more design flexibility for future extensions, i.e.
 -	 * we can add functionality without adding a flag.
 -	 */
 -	check_reserved = mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION;
 -	if (check_reserved && memchr_inv(&mop->reserved, 0, sizeof(mop->reserved)))
 -		return -EINVAL;
  
  	switch (mop->op) {
  	case KVM_S390_MEMOP_LOGICAL_READ:
  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
 -			r = check_gva_range(vcpu, mop->gaddr, ar, mop->size,
 -					    GACC_FETCH, access_key);
 +			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
 +					    GACC_FETCH, mop->key);
  			break;
  		}
 -		r = read_guest_with_key(vcpu, mop->gaddr, ar, tmpbuf,
 -					mop->size, access_key);
 +		r = read_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
 +					mop->size, mop->key);
  		if (r == 0) {
  			if (copy_to_user(uaddr, tmpbuf, mop->size))
  				r = -EFAULT;
 @@ -4834,16 +4812,16 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
  		break;
  	case KVM_S390_MEMOP_LOGICAL_WRITE:
  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
 -			r = check_gva_range(vcpu, mop->gaddr, ar, mop->size,
 -					    GACC_STORE, access_key);
 +			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
 +					    GACC_STORE, mop->key);
  			break;
  		}
  		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
  			r = -EFAULT;
  			break;
  		}
 -		r = write_guest_with_key(vcpu, mop->gaddr, ar, tmpbuf,
 -					 mop->size, access_key);
 +		r = write_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
 +					 mop->size, mop->key);
  		break;
  	}
  
 diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
 index 50ce814267b3..fd01fe04a183 100644
 --- a/include/uapi/linux/kvm.h
 +++ b/include/uapi/linux/kvm.h
 @@ -564,10 +564,10 @@ struct kvm_s390_mem_op {
  	union {
  		struct {
  			__u8 ar;	/* the access register number */
 -			__u8 key;	/* access key to use for storage key protection */
 +			__u8 key;	/* access key, ignored if flag unset */
  		};
  		__u32 sida_offset; /* offset into the sida */
 -		__u8 reserved[32]; /* must be set to 0 */
 +		__u8 reserved[32]; /* ignored */
  	};
  };
  /* types for kvm_s390_mem_op->op */

Range-diff against v2:
 1:  bcbcf21bdc2f !  1:  0049c4412978 s390/uaccess: Add copy_from/to_user_key functions
    @@ Commit message
         existing implementation.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Acked-by: Heiko Carstens <hca@linux.ibm.com>
    +    Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
    +    Acked-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## arch/s390/include/asm/uaccess.h ##
     @@ arch/s390/include/asm/uaccess.h: raw_copy_to_user(void __user *to, const void *from, unsigned long n);
 2:  d634b7e34245 !  2:  296096b9a7b9 KVM: s390: Honor storage keys when accessing guest memory
    @@ Commit message
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
         Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
    +    Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
     
      ## arch/s390/include/asm/ctl_reg.h ##
     @@
 3:  dc1f00356bf5 =  3:  a5976cb3a147 KVM: s390: handle_tprot: Honor storage keys
 4:  6eac8a0f969a !  4:  5f5e056e66df KVM: s390: selftests: Test TEST PROTECTION emulation
    @@ Commit message
         Trigger this by protecting the test pages via mprotect.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## tools/testing/selftests/kvm/.gitignore ##
     @@
 5:  ccd4ec096613 !  5:  64fa17a83b26 KVM: s390: Add optional storage key checking to MEMOP IOCTL
    @@ arch/s390/kvm/kvm-s390.c: static int kvm_s390_handle_pv(struct kvm *kvm, struct
      		       unsigned int ioctl, unsigned long arg)
      {
     @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
    - 				  struct kvm_s390_mem_op *mop)
    - {
    - 	void __user *uaddr = (void __user *)mop->buf;
    -+	u8 access_key = 0, ar = 0;
      	void *tmpbuf = NULL;
    -+	bool check_reserved;
      	int r = 0;
      	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
     -				    | KVM_S390_MEMOP_F_CHECK_ONLY;
     +				    | KVM_S390_MEMOP_F_CHECK_ONLY
     +				    | KVM_S390_MEMOP_F_SKEY_PROTECTION;
      
    --	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
    -+	if (mop->flags & ~supported_flags || !mop->size)
    + 	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
      		return -EINVAL;
     -
      	if (mop->size > MEM_OP_MAX_SIZE)
    @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcp
      	if (kvm_s390_pv_cpu_is_protected(vcpu))
      		return -EINVAL;
     -
    - 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
    - 		tmpbuf = vmalloc(mop->size);
    - 		if (!tmpbuf)
    - 			return -ENOMEM;
    - 	}
    -+	ar = mop->ar;
    -+	mop->ar = 0;
    -+	if (ar >= NUM_ACRS)
    -+		return -EINVAL;
     +	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
    -+		access_key = mop->key;
    -+		mop->key = 0;
    -+		if (access_key_invalid(access_key))
    ++		if (access_key_invalid(mop->key))
     +			return -EINVAL;
     +	}
    -+	/*
    -+	 * Check that reserved/unused == 0, but only for extensions,
    -+	 * so we stay backward compatible.
    -+	 * This gives us more design flexibility for future extensions, i.e.
    -+	 * we can add functionality without adding a flag.
    -+	 */
    -+	check_reserved = mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION;
    -+	if (check_reserved && memchr_inv(&mop->reserved, 0, sizeof(mop->reserved)))
    -+		return -EINVAL;
    - 
    + 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
    + 		tmpbuf = vmalloc(mop->size);
    + 		if (!tmpbuf)
    +@@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
      	switch (mop->op) {
      	case KVM_S390_MEMOP_LOGICAL_READ:
      		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
     -			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
     -					    mop->size, GACC_FETCH, 0);
    -+			r = check_gva_range(vcpu, mop->gaddr, ar, mop->size,
    -+					    GACC_FETCH, access_key);
    ++			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
    ++					    GACC_FETCH, mop->key);
      			break;
      		}
     -		r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
    -+		r = read_guest_with_key(vcpu, mop->gaddr, ar, tmpbuf,
    -+					mop->size, access_key);
    ++		r = read_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
    ++					mop->size, mop->key);
      		if (r == 0) {
      			if (copy_to_user(uaddr, tmpbuf, mop->size))
      				r = -EFAULT;
    @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcp
      		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
     -			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
     -					    mop->size, GACC_STORE, 0);
    -+			r = check_gva_range(vcpu, mop->gaddr, ar, mop->size,
    -+					    GACC_STORE, access_key);
    ++			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
    ++					    GACC_STORE, mop->key);
      			break;
      		}
      		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
    @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcp
      			break;
      		}
     -		r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
    -+		r = write_guest_with_key(vcpu, mop->gaddr, ar, tmpbuf,
    -+					 mop->size, access_key);
    ++		r = write_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
    ++					 mop->size, mop->key);
      		break;
      	}
      
    @@ include/uapi/linux/kvm.h: struct kvm_s390_mem_op {
     -		__u8 ar;	/* the access register number */
     +		struct {
     +			__u8 ar;	/* the access register number */
    -+			__u8 key;	/* access key to use for storage key protection */
    ++			__u8 key;	/* access key, ignored if flag unset */
     +		};
      		__u32 sida_offset; /* offset into the sida */
    --		__u8 reserved[32]; /* should be set to 0 */
    -+		__u8 reserved[32]; /* must be set to 0 */
    + 		__u8 reserved[32]; /* should be set to 0 */
      	};
    - };
    - /* types for kvm_s390_mem_op->op */
     @@ include/uapi/linux/kvm.h: struct kvm_s390_mem_op {
      /* flags for kvm_s390_mem_op->flags */
      #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 6:  9b99399f7958 !  6:  57e3ad332677 KVM: s390: Add vm IOCTL for key checked guest absolute memory access
    @@ arch/s390/kvm/kvm-s390.c: static bool access_key_invalid(u8 access_key)
     +	void __user *uaddr = (void __user *)mop->buf;
     +	u64 supported_flags;
     +	void *tmpbuf = NULL;
    -+	u8 access_key = 0;
     +	int r, srcu_idx;
     +
     +	supported_flags = KVM_S390_MEMOP_F_SKEY_PROTECTION
    @@ arch/s390/kvm/kvm-s390.c: static bool access_key_invalid(u8 access_key)
     +		return -E2BIG;
     +	if (kvm_s390_pv_is_protected(kvm))
     +		return -EINVAL;
    ++	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
    ++		if (access_key_invalid(mop->key))
    ++			return -EINVAL;
    ++	}
     +	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
     +		tmpbuf = vmalloc(mop->size);
     +		if (!tmpbuf)
     +			return -ENOMEM;
     +	}
    -+	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
    -+		access_key = mop->key;
    -+		mop->key = 0;
    -+		if (access_key_invalid(access_key))
    -+			return -EINVAL;
    -+	}
    -+	if (memchr_inv(&mop->reserved, 0, sizeof(mop->reserved)))
    -+		return -EINVAL;
     +
     +	srcu_idx = srcu_read_lock(&kvm->srcu);
     +
    @@ arch/s390/kvm/kvm-s390.c: static bool access_key_invalid(u8 access_key)
     +	switch (mop->op) {
     +	case KVM_S390_MEMOP_ABSOLUTE_READ: {
     +		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
    -+			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_FETCH, access_key);
    ++			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_FETCH, mop->key);
     +		} else {
     +			r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
    -+						      mop->size, GACC_FETCH, access_key);
    ++						      mop->size, GACC_FETCH, mop->key);
     +			if (r == 0) {
     +				if (copy_to_user(uaddr, tmpbuf, mop->size))
     +					r = -EFAULT;
    @@ arch/s390/kvm/kvm-s390.c: static bool access_key_invalid(u8 access_key)
     +	}
     +	case KVM_S390_MEMOP_ABSOLUTE_WRITE: {
     +		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
    -+			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_STORE, access_key);
    ++			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_STORE, mop->key);
     +		} else {
     +			if (copy_from_user(tmpbuf, uaddr, mop->size)) {
     +				r = -EFAULT;
     +				break;
     +			}
     +			r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
    -+						      mop->size, GACC_STORE, access_key);
    ++						      mop->size, GACC_STORE, mop->key);
     +		}
     +		break;
     +	}
 7:  e3047ac90594 !  7:  1615f5ab6e30 KVM: s390: Rename existing vcpu memop functions
    @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_sida_op(struct kvm_vcpu *vc
     +				 struct kvm_s390_mem_op *mop)
      {
      	void __user *uaddr = (void __user *)mop->buf;
    - 	u8 access_key = 0, ar = 0;
    + 	void *tmpbuf = NULL;
     @@ arch/s390/kvm/kvm-s390.c: static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
      	return r;
      }
 9:  f93003ab633d !  8:  a8420e0f1b7f KVM: s390: Add capability for storage key extension of MEM_OP IOCTL
    @@ Commit message
         * The vm MEM_OP IOCTL exists.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## arch/s390/kvm/kvm-s390.c ##
     @@ arch/s390/kvm/kvm-s390.c: int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
11:  20476660a710 !  9:  c59952ee362b KVM: s390: Update api documentation for memop ioctl
    @@ Documentation/virt/kvm/api.rst: The fields in each entry are defined as follows:
      --------------------
      
     -:Capability: KVM_CAP_S390_MEM_OP
    -+:Capability: KVM_CAP_S390_MEM_OP, KVM_CAP_S390_MEM_OP_EXTENSION
    ++:Capability: KVM_CAP_S390_MEM_OP, KVM_CAP_S390_PROTECTED, KVM_CAP_S390_MEM_OP_EXTENSION
      :Architectures: s390
     -:Type: vcpu ioctl
     +:Type: vm ioctl, vcpu ioctl
    @@ Documentation/virt/kvm/api.rst: Parameters are specified via the following struc
     +	union {
     +		struct {
     +			__u8 ar;	/* the access register number */
    -+			__u8 key;	/* access key to use for storage key protection */
    ++			__u8 key;	/* access key, ignored if flag unset */
     +		};
     +		__u32 sida_offset; /* offset into the sida */
    -+		__u8 reserved[32]; /* must be set to 0 */
    ++		__u8 reserved[32]; /* ignored */
     +	};
        };
      
    @@ Documentation/virt/kvm/api.rst: Parameters are specified via the following struc
     -register number to be used; the valid range is 0..15.
     +a read access, or where the data that should be written is stored for
     +a write access.  The "reserved" field is meant for future extensions.
    -+Reserved and unused bytes must be set to 0. If any of the following are used,
    -+this is enforced and -EINVAL will be returned:
    -+``KVM_S390_MEMOP_ABSOLUTE_READ/WRITE``, ``KVM_S390_MEMOP_F_SKEY_PROTECTION``.
    ++Reserved and unused values are ignored. Future extension that add members must
    ++introduce new flags.
     +
     +The type of operation is specified in the "op" field. Flags modifying
     +their behavior can be set in the "flags" field. Undefined flag bits must
    @@ Documentation/virt/kvm/api.rst: Parameters are specified via the following struc
     +
     +Access the secure instruction data area which contains memory operands necessary
     +for instruction emulation for secure guests.
    ++SIDA accesses are available if the KVM_CAP_S390_PROTECTED capability is available.
     +SIDA accesses are permitted for the VCPU ioctl only.
     +SIDA accesses are permitted for secure guests only.
      
    @@ Documentation/virt/kvm/api.rst: Parameters are specified via the following struc
      
      4.90 KVM_S390_GET_SKEYS
      -----------------------
    +
    + ## include/uapi/linux/kvm.h ##
    +@@ include/uapi/linux/kvm.h: struct kvm_s390_mem_op {
    + 			__u8 key;	/* access key, ignored if flag unset */
    + 		};
    + 		__u32 sida_offset; /* offset into the sida */
    +-		__u8 reserved[32]; /* should be set to 0 */
    ++		__u8 reserved[32]; /* ignored */
    + 	};
    + };
    + /* types for kvm_s390_mem_op->op */
 8:  058a6fbaf7dc ! 10:  68752e1eca95 KVM: s390: selftests: Test memops with storage keys
    @@ tools/testing/selftests/kvm/s390x/memop.c
     +	};
     +
     +	return _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
    - }
    - 
    ++}
    ++
     +static void vcpu_read_guest(struct kvm_vm *vm, void *host_addr,
     +			    uintptr_t guest_addr, size_t len)
     +{
    @@ tools/testing/selftests/kvm/s390x/memop.c
     +
     +	rv = _vm_write_guest_key(vm, guest_addr, host_addr, len, access_key);
     +	TEST_ASSERT(rv == 0, "vm memop write failed: reason = %d\n", rv);
    -+}
    -+
    + }
    + 
     +enum access_mode {
     +	ACCESS_READ,
     +	ACCESS_WRITE
    @@ tools/testing/selftests/kvm/s390x/memop.c
      	struct kvm_run *run;
      	struct kvm_s390_mem_op ksmo;
     -	int rv, i, maxsize;
    ++	bool has_skey_ext;
     +	vm_vaddr_t guest_mem1;
     +	vm_vaddr_t guest_mem2;
     +	vm_paddr_t guest_mem1_abs;
    @@ tools/testing/selftests/kvm/s390x/memop.c
      	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
      
     @@ tools/testing/selftests/kvm/s390x/memop.c: int main(int argc, char *argv[])
    + 	}
    + 	if (maxsize > sizeof(mem1))
    + 		maxsize = sizeof(mem1);
    ++	has_skey_ext = kvm_check_cap(KVM_CAP_S390_MEM_OP_EXTENSION);
    ++	if (!has_skey_ext)
    ++		print_skip("Storage key extension not supported");
    + 
      	/* Create VM */
      	vm = vm_create_default(VCPU_ID, 0, guest_code);
      	run = vcpu_state(vm, VCPU_ID);
    @@ tools/testing/selftests/kvm/s390x/memop.c: int main(int argc, char *argv[])
     -		    "Unexpected exit reason: %u (%s)\n",
     -		    run->exit_reason,
     -		    exit_reason_str(run->exit_reason));
    -+	{
    ++	if (has_skey_ext) {
     +		vm_vaddr_t guest_0_page = vm_vaddr_alloc(vm, PAGE_SIZE, 0);
     +		vm_vaddr_t guest_last_page = vm_vaddr_alloc(vm, PAGE_SIZE, last_page_addr);
     +		vm_paddr_t guest_mem2_abs = addr_gva2gpa(vm, guest_mem2);
    @@ tools/testing/selftests/kvm/s390x/memop.c: int main(int argc, char *argv[])
     +		TEST_ASSERT(rv != 0, "Fetch should result in exception");
     +		rv = _vm_read_guest_key(vm, mem2, addr_gva2gpa(vm, 0), 2048, 2);
     +		TEST_ASSERT(rv == 4, "Fetch should result in protection exception");
    ++	} else {
    ++		struct ucall uc;
    ++
    ++		do {
    ++			vcpu_run(vm, VCPU_ID);
    ++			get_ucall(vm, VCPU_ID, &uc);
    ++			ASSERT_EQ(uc.cmd, UCALL_SYNC);
    ++		} while (uc.args[1] < 100);
     +	}
     +
     +	/* Check error conditions */
10:  2ff8d7f47ffd <  -:  ------------ KVM: s390: selftests: Make use of capability in MEM_OP test

base-commit: dcb85f85fa6f142aae1fe86f399d4503d49f2b60
-- 
2.32.0

