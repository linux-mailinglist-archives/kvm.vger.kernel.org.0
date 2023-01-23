Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6268567792E
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 11:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbjAWK35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 05:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjAWK34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 05:29:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D90013D42;
        Mon, 23 Jan 2023 02:29:54 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30N9JnCG015251;
        Mon, 23 Jan 2023 10:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=RWwKngLyZRUeCYsnMNQWIAHgwZplc5GGnn7Z4wEhdoU=;
 b=GRVbSB4FHpJC34JC7phDKNNmrsXj9YCx34bzIOhSJzel9DoYE/Mq+48A9lnMBSgLNCrX
 R18hpgXN7dfCMGwFV7/NvdW/XXLQ4TnIVfkcbcR4QQatFbfp7an/UpQ9Fva78DYRLFb+
 scFOeKZEDexebHmPEjEz63wir+QH6s+tLCd6DucFV9jrI2sQ2DpvIqiHBfMPGvtwc8Xs
 +KDAjzH+KGx1omTKlnndSXTNlMpG1EdD5EntmCgV2mJ65Kl5I7/znFHdBhwwcSRMVpkW
 0zcJ9Mey9pAgPvLnG0JiUzox7uMapRVvvQrXAF8qIbWiWKs0Ux9RjkmpEHzr4vQ2brPn 7g== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9qgs9k46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 10:29:53 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30N5FK51014950;
        Mon, 23 Jan 2023 10:29:51 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n87afa4mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 10:29:51 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30NATg2T34799942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 10:29:42 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F00F2004B;
        Mon, 23 Jan 2023 10:29:42 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 680AD20043;
        Mon, 23 Jan 2023 10:29:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 23 Jan 2023 10:29:42 +0000 (GMT)
Date:   Mon, 23 Jan 2023 11:29:41 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1] KVM: s390: disable migration mode when dirty
 tracking is disabled
Message-ID: <20230123112941.5bd57576@p-imbrenda>
In-Reply-To: <20230120075406.101436-1-nrb@linux.ibm.com>
References: <20230120075406.101436-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BXk8QF8RgNYd6qx_AJ1ew-Zow-aOstRt
X-Proofpoint-GUID: BXk8QF8RgNYd6qx_AJ1ew-Zow-aOstRt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_05,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 adultscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301230094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Jan 2023 08:54:06 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Migration mode is a VM attribute which enables tracking of changes in
> storage attributes (PGSTE). It assumes dirty tracking is enabled on all
> memslots to keep a dirty bitmap of pages with changed storage attributes.
> 
> When enabling migration mode, we currently check that dirty tracking is
> enabled for all memslots. However, userspace can disable dirty tracking
> without disabling migration mode.
> 
> Since migration mode is pointless with dirty tracking disabled, disable
> migration mode whenever userspace disables dirty tracking on any slot.
> 
> Also update the documentation to clarify that dirty tracking must be
> enabled when enabling migration mode, which is already enforced by the
> code in kvm_s390_vm_start_migration().
> 
> To disable migration mode, slots_lock should be held, which is taken
> in kvm_set_memory_region() and thus held in
> kvm_arch_prepare_memory_region().
> 
> Restructure the prepare code a bit so all the sanity checking is done
> before disabling migration mode. This ensures migration mode isn't
> disabled when some sanity check fails.
> 
> Cc: stable@vger.kernel.org
> Fixes: 190df4a212a7 ("KVM: s390: CMMA tracking, ESSA emulation, migration mode")
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  Documentation/virt/kvm/devices/vm.rst |  4 +++
>  arch/s390/kvm/kvm-s390.c              | 41 ++++++++++++++++++---------
>  2 files changed, 32 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
> index 60acc39e0e93..147efec626e5 100644
> --- a/Documentation/virt/kvm/devices/vm.rst
> +++ b/Documentation/virt/kvm/devices/vm.rst
> @@ -302,6 +302,10 @@ Allows userspace to start migration mode, needed for PGSTE migration.
>  Setting this attribute when migration mode is already active will have
>  no effects.
>  
> +Dirty tracking must be enabled on all memslots, else -EINVAL is returned. When
> +dirty tracking is disabled on any memslot, migration mode is automatically
> +stopped.
> +
>  :Parameters: none
>  :Returns:   -ENOMEM if there is not enough free memory to start migration mode;
>  	    -EINVAL if the state of the VM is invalid (e.g. no memory defined);
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index e4890e04b210..4785f002cd93 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5628,28 +5628,43 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  				   enum kvm_mr_change change)
>  {
>  	gpa_t size;
> +	int rc;
>  
>  	/* When we are protected, we should not change the memory slots */
>  	if (kvm_s390_pv_get_handle(kvm))
>  		return -EINVAL;
>  
> -	if (change == KVM_MR_DELETE || change == KVM_MR_FLAGS_ONLY)
> -		return 0;
> +	if (change != KVM_MR_DELETE && change != KVM_MR_FLAGS_ONLY) {
> +		/* A few sanity checks. We can have memory slots which have to be
> +		 * located/ended at a segment boundary (1MB). The memory in userland is
> +		 * ok to be fragmented into various different vmas. It is okay to mmap()
> +		 * and munmap() stuff in this slot after doing this call at any time
> +		 */
>  
> -	/* A few sanity checks. We can have memory slots which have to be
> -	   located/ended at a segment boundary (1MB). The memory in userland is
> -	   ok to be fragmented into various different vmas. It is okay to mmap()
> -	   and munmap() stuff in this slot after doing this call at any time */
> +		if (new->userspace_addr & 0xffffful)
> +			return -EINVAL;
>  
> -	if (new->userspace_addr & 0xffffful)
> -		return -EINVAL;
> +		size = new->npages * PAGE_SIZE;
> +		if (size & 0xffffful)
> +			return -EINVAL;
>  
> -	size = new->npages * PAGE_SIZE;
> -	if (size & 0xffffful)
> -		return -EINVAL;
> +		if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
> +			return -EINVAL;
> +	}
>  
> -	if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
> -		return -EINVAL;
> +	/* Turn off migration mode when userspace disables dirty page logging.
> +	 * Migration mode expects dirty page logging being enabled to store
> +	 * its dirty bitmap.
> +	 */
> +	if (kvm->arch.migration_mode) {
> +		if ((old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
> +		    !(new->flags & KVM_MEM_LOG_DIRTY_PAGES)) {
> +			rc = kvm_s390_vm_stop_migration(kvm);
> +
> +			if (rc)
> +				pr_warn("Failed to stop migration mode\n");
> +		}
> +	}
>  
>  	return 0;
>  }

