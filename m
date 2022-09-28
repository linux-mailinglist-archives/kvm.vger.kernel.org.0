Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561DC5EDC53
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 14:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbiI1MKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 08:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbiI1MKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 08:10:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28305760E2;
        Wed, 28 Sep 2022 05:10:02 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SBaWwt008816;
        Wed, 28 Sep 2022 12:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=A09ruHtf25zP9PVLRmBwNZ5WG1VCBThTc43GTflH9IY=;
 b=p649tse+zfOqV4wG0+LEbhd/s7bh44w467HngCB/Tr/h3D4EKTcy5spiKiEqyRnmyh7A
 Oyg7tB2rwAwU67zv5uHWcyGy/QwJmWl6T7/ThCqhZGWN2ni6p8bOGQ+MhZOkwZPGoFr6
 aZy8Onzxxw+uTgoe64l8iT64If2FiQdT33ZKKLWCANXEBZF2Tnn1EXKtcAgi7a1fQm4T
 0rr2hH8ijARG6SlYy1Da7TOVJx/hQf7T+/3Ey7aa1LKmCUzOedUGYNDlyebxN+u6yX0B
 l6wW6ffvN14dyG0ATDhM3q+R3uOj9nEozvpz7E0yyB42XKgX+cTMTjKzKNDNHSwpTBOB bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvjn6xpap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 12:10:01 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28SB7CrP001747;
        Wed, 28 Sep 2022 12:10:01 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvjn6xp9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 12:10:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28SC5hhv016554;
        Wed, 28 Sep 2022 12:09:58 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3jssh9d6df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 12:09:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28SCAN5252691444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 12:10:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0E1DA404D;
        Wed, 28 Sep 2022 12:09:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35B2EA4040;
        Wed, 28 Sep 2022 12:09:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 12:09:55 +0000 (GMT)
Date:   Wed, 28 Sep 2022 14:09:53 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, farman@linux.ibm.com,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: pci: register pci hooks without
 interpretation
Message-ID: <20220928140953.3935ea39@p-imbrenda>
In-Reply-To: <20220920193025.135655-1-mjrosato@linux.ibm.com>
References: <20220920193025.135655-1-mjrosato@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nxUw6Ns0YjzRoGJ8MoOnyGCSG5nUyTtY
X-Proofpoint-GUID: b4XytSelsY8TwnWCgNbsZ9LHVl6Zr1aM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_04,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Sep 2022 15:30:25 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> The kvm registration hooks must be registered even if the facilities
> necessary for zPCI interpretation are unavailable, as vfio-pci-zdev will
> expect to use the hooks regardless.
> This fixes an issue where vfio-pci-zdev will fail its open function
> because of a missing kvm_register when running on hardware that does not
> support zPCI interpretation.
> 
> Fixes: ca922fecda6c ("KVM: s390: pci: Hook to access KVM lowlevel from VFIO")
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c |  4 ++--
>  arch/s390/kvm/pci.c      | 14 +++++++++++---
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index e20e126944aa..5c7f5f97ea09 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -510,7 +510,7 @@ int kvm_arch_init(void *opaque)
>  		goto out;
>  	}
>  
> -	if (kvm_s390_pci_interp_allowed()) {
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
>  		rc = kvm_s390_pci_init();
>  		if (rc) {
>  			pr_err("Unable to allocate AIFT for PCI\n");
> @@ -532,7 +532,7 @@ int kvm_arch_init(void *opaque)
>  void kvm_arch_exit(void)
>  {
>  	kvm_s390_gib_destroy();
> -	if (kvm_s390_pci_interp_allowed())
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
>  		kvm_s390_pci_exit();
>  	debug_unregister(kvm_s390_dbf);
>  	debug_unregister(kvm_s390_dbf_uv);
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 90aaba80696a..c50c1645c0ae 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -672,23 +672,31 @@ int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
>  
>  int kvm_s390_pci_init(void)
>  {
> +	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
> +	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
> +
> +	if (!kvm_s390_pci_interp_allowed())
> +		return 0;
> +
>  	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
>  	if (!aift)
>  		return -ENOMEM;
>  
>  	spin_lock_init(&aift->gait_lock);
>  	mutex_init(&aift->aift_lock);
> -	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
> -	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
>  
>  	return 0;
>  }
>  
>  void kvm_s390_pci_exit(void)
>  {
> -	mutex_destroy(&aift->aift_lock);
>  	zpci_kvm_hook.kvm_register = NULL;
>  	zpci_kvm_hook.kvm_unregister = NULL;
>  
> +	if (!kvm_s390_pci_interp_allowed())
> +		return;
> +
> +	mutex_destroy(&aift->aift_lock);
> +
>  	kfree(aift);
>  }

