Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468BB60E256
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 15:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiJZNlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 09:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiJZNlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 09:41:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F3B543FC;
        Wed, 26 Oct 2022 06:40:56 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QDVpR3021913;
        Wed, 26 Oct 2022 13:40:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=00A1apqt2kKruKrD56FowRzbsUtdUcFY/b9tW/muIkY=;
 b=DR3s/Mc6OtJh5zvVPC1op46OlGzH5X+jAptJX41K+543/OXLQsGUb4P4W533R/5SqvPx
 S6P+pT3iy+xOk46YwMomGrofkrjRQj5pCXNPpcEqe7wKLWR1MZOn0n2NweiU8Tb2e+oQ
 6Kg0j5C1IPhgT8FBGSrUfwedP10SV4EOZg+A26Tz0sN95KBY1xplHP2reINaD6/YhR6a
 72ndy6ZrMUsmmCoUvnu8yI4q0XwioJKCoVt7isNma08eLZkmTEPOdyogyyEKnZO/8adD
 atmtXoLW8HaqdIb7sUT6qqtdah9TS22OvjxYH0FxQP6TkRuYy6PPR0i3Wgx6kQZ1oFd5 jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kf5v10aag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 13:40:55 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29QDWeZV023772;
        Wed, 26 Oct 2022 13:40:55 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kf5v10a9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 13:40:54 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29QDak6W006854;
        Wed, 26 Oct 2022 13:40:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3kdv5fhbny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 13:40:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29QDfO0v51839310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 13:41:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D80D2A4060;
        Wed, 26 Oct 2022 13:40:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43774A405C;
        Wed, 26 Oct 2022 13:40:49 +0000 (GMT)
Received: from [9.171.91.40] (unknown [9.171.91.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Oct 2022 13:40:49 +0000 (GMT)
Message-ID: <b9abd0ab-79d8-5e41-20e4-d8218d58693b@linux.ibm.com>
Date:   Wed, 26 Oct 2022 15:40:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] KVM: s390: pci: Fix allocation size of aift kzdev
 elements
To:     Rafael Mendonca <rafaelmendsr@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221026013234.960859-1-rafaelmendsr@gmail.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221026013234.960859-1-rafaelmendsr@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4-rcfqfu8sqA3OBB99fn0WKU2c3uhbvr
X-Proofpoint-ORIG-GUID: T6i6fyjn-RYZ0H-Qa7mCxbAAH0sgL7xx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_06,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 26.10.22 um 03:32 schrieb Rafael Mendonca:
> The 'kzdev' field of struct 'zpci_aift' is an array of pointers to
> 'kvm_zdev' structs. Allocate the proper size accordingly.
> 
> Reported by Coccinelle:
>    WARNING: Use correct pointer type argument for sizeof
> 
> Fixes: 98b1d33dac5f ("KVM: s390: pci: do initial setup for AEN interpretation")
> Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   arch/s390/kvm/pci.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index c50c1645c0ae..ded1af2ddae9 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -126,7 +126,7 @@ int kvm_s390_pci_aen_init(u8 nisc)
>   		return -EPERM;
>   
>   	mutex_lock(&aift->aift_lock);
> -	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev),
> +	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev *),
>   			      GFP_KERNEL);
>   	if (!aift->kzdev) {
>   		rc = -ENOMEM;
