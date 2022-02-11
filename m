Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF1E4B215E
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 10:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348422AbiBKJRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 04:17:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237952AbiBKJRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 04:17:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BBE102D;
        Fri, 11 Feb 2022 01:17:20 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21B8ciEo015018;
        Fri, 11 Feb 2022 09:17:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BepGLEN3A2hawUn04CXKRhRJv1ry5IbqIi7zt/wNAU8=;
 b=O4q6xEeSFvGDsoiENhHdkGvPlKTM89FhIc7OwjdX5zOLpCIjooKPYNddQyX33lwrFbd5
 ZTBaBiaP6wYsDCgW/2NTYvQFjOMhNti26hkYg/nOddD4Y64w5hurGLTUB1UqVOuDbFKL
 PXCZZ3+R7tmXSO3/y+CBJiC3frqh3pomvRkyQ6D3c/dJXKTT9hlcxQxWVBuoF+qeqyUe
 5as+HjrDJ0MiF3Arpwfv0T/2pGrOdH7BpyPiCbO14SHH0uxS+PtG5oScXfDbBjeQdQf5
 SaS/ig231ECgb+sRqGMbsuSVNeT1PnebCjBORs4BOK1j6zpscQlPlCMPmsBaBSynGoOt Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5gt84dba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 09:17:20 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21B90FYu020099;
        Fri, 11 Feb 2022 09:17:19 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5gt84daj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 09:17:19 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21B990xj025512;
        Fri, 11 Feb 2022 09:17:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gva8099-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 09:17:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21B9HCXm39649560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 09:17:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC7D0A4059;
        Fri, 11 Feb 2022 09:17:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2780FA405E;
        Fri, 11 Feb 2022 09:17:12 +0000 (GMT)
Received: from [9.145.74.171] (unknown [9.145.74.171])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Feb 2022 09:17:12 +0000 (GMT)
Message-ID: <95cd44de-f035-4371-812f-5d6bad68cd7b@linux.ibm.com>
Date:   Fri, 11 Feb 2022 10:17:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20220209170422.1910690-1-scgl@linux.ibm.com>
 <20220209170422.1910690-10-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v3 09/10] KVM: s390: Update api documentation for memop
 ioctl
In-Reply-To: <20220209170422.1910690-10-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5rSCGnlk0XX_Vi0IZ2nqSi2CuhLASZHe
X-Proofpoint-ORIG-GUID: GZNDZloHbp0U3jss8-w8KJATKjPfIo8q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_03,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/22 18:04, Janis Schoetterl-Glausch wrote:
> Document all currently existing operations, flags and explain under
> which circumstances they are available. Document the recently
> introduced absolute operations and the storage key protection flag,
> as well as the existing SIDA operations.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Minor nits below

> ---
>   Documentation/virt/kvm/api.rst | 112 ++++++++++++++++++++++++++-------
>   include/uapi/linux/kvm.h       |   2 +-
>   2 files changed, 91 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a4267104db50..2d131af44576 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3683,15 +3683,17 @@ The fields in each entry are defined as follows:
>   4.89 KVM_S390_MEM_OP
>   --------------------
>   
> -:Capability: KVM_CAP_S390_MEM_OP
> +:Capability: KVM_CAP_S390_MEM_OP, KVM_CAP_S390_PROTECTED, KVM_CAP_S390_MEM_OP_EXTENSION
>   :Architectures: s390
> -:Type: vcpu ioctl
> +:Type: vm ioctl, vcpu ioctl
>   :Parameters: struct kvm_s390_mem_op (in)
>   :Returns: = 0 on success,
>             < 0 on generic error (e.g. -EFAULT or -ENOMEM),
>             > 0 if an exception occurred while walking the page tables
>   
> -Read or write data from/to the logical (virtual) memory of a VCPU.
> +Read or write data from/to the VM's memory.
> +The KVM_CAP_S390_MEM_OP_EXTENSION capability specifies what functionality is
> +supported.
>   
>   Parameters are specified via the following structure::
>   
> @@ -3701,33 +3703,99 @@ Parameters are specified via the following structure::
>   	__u32 size;		/* amount of bytes */
>   	__u32 op;		/* type of operation */
>   	__u64 buf;		/* buffer in userspace */
> -	__u8 ar;		/* the access register number */
> -	__u8 reserved[31];	/* should be set to 0 */
> +	union {
> +		struct {
> +			__u8 ar;	/* the access register number */
> +			__u8 key;	/* access key, ignored if flag unset */
> +		};
> +		__u32 sida_offset; /* offset into the sida */
> +		__u8 reserved[32]; /* ignored */
> +	};
>     };
>   
> -The type of operation is specified in the "op" field. It is either
> -KVM_S390_MEMOP_LOGICAL_READ for reading from logical memory space or
> -KVM_S390_MEMOP_LOGICAL_WRITE for writing to logical memory space. The
> -KVM_S390_MEMOP_F_CHECK_ONLY flag can be set in the "flags" field to check
> -whether the corresponding memory access would create an access exception
> -(without touching the data in the memory at the destination). In case an
> -access exception occurred while walking the MMU tables of the guest, the
> -ioctl returns a positive error number to indicate the type of exception.
> -This exception is also raised directly at the corresponding VCPU if the
> -flag KVM_S390_MEMOP_F_INJECT_EXCEPTION is set in the "flags" field.
> -
>   The start address of the memory region has to be specified in the "gaddr"
>   field, and the length of the region in the "size" field (which must not
>   be 0). The maximum value for "size" can be obtained by checking the
>   KVM_CAP_S390_MEM_OP capability. "buf" is the buffer supplied by the
>   userspace application where the read data should be written to for
> -KVM_S390_MEMOP_LOGICAL_READ, or where the data that should be written is
> -stored for a KVM_S390_MEMOP_LOGICAL_WRITE. When KVM_S390_MEMOP_F_CHECK_ONLY
> -is specified, "buf" is unused and can be NULL. "ar" designates the access
> -register number to be used; the valid range is 0..15.
> +a read access, or where the data that should be written is stored for
> +a write access.  The "reserved" field is meant for future extensions.
> +Reserved and unused values are ignored. Future extension that add members must
> +introduce new flags.
> +
> +The type of operation is specified in the "op" field. Flags modifying
> +their behavior can be set in the "flags" field. Undefined flag bits must
> +be set to 0.
> +
> +Possible operations are:
> +  * ``KVM_S390_MEMOP_LOGICAL_READ``
> +  * ``KVM_S390_MEMOP_LOGICAL_WRITE``
> +  * ``KVM_S390_MEMOP_ABSOLUTE_READ``
> +  * ``KVM_S390_MEMOP_ABSOLUTE_WRITE``
> +  * ``KVM_S390_MEMOP_SIDA_READ``
> +  * ``KVM_S390_MEMOP_SIDA_WRITE``
> +
> +Logical read/write:
> +^^^^^^^^^^^^^^^^^^^
> +
> +Access logical memory, i.e. translate the given guest address to an absolute
> +address given the state of the VCPU and use the absolute address as target of
> +the access. "ar" designates the access register number to be used; the valid
> +range is 0..15.
> +Logical accesses are permitted for the VCPU ioctl only.
> +Logical accesses are permitted for non secure guests only.

s/secure/protected/

> +
> +Supported flags:
> +  * ``KVM_S390_MEMOP_F_CHECK_ONLY``
> +  * ``KVM_S390_MEMOP_F_INJECT_EXCEPTION``
> +  * ``KVM_S390_MEMOP_F_SKEY_PROTECTION``
> +
> +The KVM_S390_MEMOP_F_CHECK_ONLY flag can be set to check whether the
> +corresponding memory access would cause an access exception, without touching

I think the comma needs to be removed.

> +the data in memory at the destination.
> +In this case, "buf" is unused and can be NULL.
> +
> +In case an access exception occurred during the access (or would occur
> +in case of KVM_S390_MEMOP_F_CHECK_ONLY), the ioctl returns a positive
> +error number indicating the type of exception. This exception is also
> +raised directly at the corresponding VCPU if the flag
> +KVM_S390_MEMOP_F_INJECT_EXCEPTION is set.
> +
> +If the KVM_S390_MEMOP_F_SKEY_PROTECTION flag is set, storage key
> +protection is also in effect and may cause exceptions if accesses are
> +prohibited given the access key passed in "key".
> +KVM_S390_MEMOP_F_SKEY_PROTECTION is available if KVM_CAP_S390_MEM_OP_EXTENSION
> +is > 0.
> +
> +Absolute read/write:
> +^^^^^^^^^^^^^^^^^^^^
> +
> +Access absolute memory. This operation is intended to be used with the
> +KVM_S390_MEMOP_F_SKEY_PROTECTION flag, to allow accessing memory and performing
> +the checks required for storage key protection as one operation (as opposed to
> +user space getting the storage keys, performing the checks, and accessing
> +memory thereafter, which could lead to a delay between check and access).
> +Absolute accesses are permitted for the VM ioctl if KVM_CAP_S390_MEM_OP_EXTENSION
> +is > 0.
> +Currently absolute accesses are not permitted for VCPU ioctls.
> +Absolute accesses are permitted for non secure guests only.

s/secure/protected/

> +
> +Supported flags:
> +  * ``KVM_S390_MEMOP_F_CHECK_ONLY``
> +  * ``KVM_S390_MEMOP_F_SKEY_PROTECTION``
> +
> +The semantics of the flags are as for logical accesses.
> +
> +SIDA read/write:
> +^^^^^^^^^^^^^^^^
> +
> +Access the secure instruction data area which contains memory operands necessary
> +for instruction emulation for secure guests.
> +SIDA accesses are available if the KVM_CAP_S390_PROTECTED capability is available.
> +SIDA accesses are permitted for the VCPU ioctl only.
> +SIDA accesses are permitted for secure guests only.

s/secure/protected/

>   
> -The "reserved" field is meant for future extensions. It is not used by
> -KVM with the currently defined set of flags.
> +No flags are supported.
>   
>   4.90 KVM_S390_GET_SKEYS
>   -----------------------
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 26bff414f1a0..fd01fe04a183 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -567,7 +567,7 @@ struct kvm_s390_mem_op {
>   			__u8 key;	/* access key, ignored if flag unset */
>   		};
>   		__u32 sida_offset; /* offset into the sida */
> -		__u8 reserved[32]; /* should be set to 0 */
> +		__u8 reserved[32]; /* ignored */
>   	};
>   };
>   /* types for kvm_s390_mem_op->op */

