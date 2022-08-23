Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B36759ED06
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 22:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiHWUE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 16:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiHWUEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 16:04:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC51C6B17F;
        Tue, 23 Aug 2022 12:18:06 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NJ18pH032376;
        Tue, 23 Aug 2022 19:18:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hYI5wQbk46HuU9DogCcm5GnSiESCEzQY7HBqFtIr1PE=;
 b=HnTQER1PNvlio7DYFV56iMouLD9qkUNS1zw7QHGC8flNAqfhcJww3FzpWSA7/pPUZLSc
 bjjuAgUpdt+BgNF5swmBUDfvpoAz3BEeFYIwYAWO6G2uWOaJNee3U0s2/EQ1VPX+6d/o
 voX9qf6OZ0ZTBU9MvttY7ghTHxdwFTuHD5wfbT83J2MecKg5UCoEYtyQqTDoS5l+BrA3
 Kayz2nsAc79MvFK9B+Nzt9P0gN5MG+KKTzmqK+VQdWNUFG+sULITL8TrFZO3hnScjn6T
 1Og+xZ0Cz4tw9MzwlarZ1do8jnSSnfIVECvUw12Gs11CtAkYunZTmyZobocC4pwepjJF YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j54je141d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 19:18:05 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NJ1Cat000734;
        Tue, 23 Aug 2022 19:18:05 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j54je1414-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 19:18:05 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NIp3rt020198;
        Tue, 23 Aug 2022 19:18:04 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 3j2q8a22ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 19:18:04 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NJI3h18782572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 19:18:03 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 254C9C605B;
        Tue, 23 Aug 2022 19:18:03 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B49ABC605A;
        Tue, 23 Aug 2022 19:18:01 +0000 (GMT)
Received: from [9.211.112.122] (unknown [9.211.112.122])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 19:18:01 +0000 (GMT)
Message-ID: <c558a8c8-4d87-13ee-8d33-ba0285445d62@linux.ibm.com>
Date:   Tue, 23 Aug 2022 15:18:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] KVM: s390: pci: fix plain integer as NULL pointer
 warnings
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org, frankja@linux.ibm.com
Cc:     farman@linux.ibm.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20220823191548.77526-1-mjrosato@linux.ibm.com>
In-Reply-To: <20220823191548.77526-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oTP1Ss4Gkc_1GdAfVMnNZHkj5TTSuhkQ
X-Proofpoint-GUID: o2uygq3sU7XsrUaUMO0jLqx7OcOlX7gq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208230072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/23/22 3:15 PM, Matthew Rosato wrote:
> Fix some sparse warnings that a plain integer 0 is being used instead of
> NULL.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

@Janosch, since you are taking the other PCI fix can you also take this small cleanup through KVM?

> ---
>  arch/s390/kvm/pci.c | 4 ++--
>  arch/s390/kvm/pci.h | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index bb8c335d17b9..3c12637ce08c 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -58,7 +58,7 @@ static int zpci_setup_aipb(u8 nisc)
>  	if (!zpci_aipb)
>  		return -ENOMEM;
>  
> -	aift->sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, 0);
> +	aift->sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, NULL);
>  	if (!aift->sbv) {
>  		rc = -ENOMEM;
>  		goto free_aipb;
> @@ -373,7 +373,7 @@ static int kvm_s390_pci_aif_disable(struct zpci_dev *zdev, bool force)
>  		gaite->gisc = 0;
>  		gaite->aisbo = 0;
>  		gaite->gisa = 0;
> -		aift->kzdev[zdev->aisb] = 0;
> +		aift->kzdev[zdev->aisb] = NULL;
>  		/* Clear zdev info */
>  		airq_iv_free_bit(aift->sbv, zdev->aisb);
>  		airq_iv_release(zdev->aibv);
> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
> index 3a3606c3a0fe..7be5568d8bd2 100644
> --- a/arch/s390/kvm/pci.h
> +++ b/arch/s390/kvm/pci.h
> @@ -46,9 +46,9 @@ extern struct zpci_aift *aift;
>  static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
>  						 unsigned long si)
>  {
> -	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == 0 ||
> -	    aift->kzdev[si] == 0)
> -		return 0;
> +	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == NULL ||
> +	    aift->kzdev[si] == NULL)
> +		return NULL;
>  	return aift->kzdev[si]->kvm;
>  };
>  

