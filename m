Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E718460C688
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 10:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiJYIeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 04:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiJYIen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 04:34:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEBF46205;
        Tue, 25 Oct 2022 01:34:40 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29P8L9gZ011902;
        Tue, 25 Oct 2022 08:34:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8Ze4U+O9d75Pe8gsL4NoqynoDAILp1sxiQw/sGUnyvE=;
 b=UcHZNJddm2+afEElNd/TavtGaHH9aAH0U0G5jBs7JeCQuzri6rSWYdUyQJ2s+8kKHMYk
 G8MJ9wgtox8Q65k483CFqvQxdg3ujwFBGq1PkrD8XafruExppdp5/9vphR9uD2ZtGzEB
 EV4CaolHkSQDZ58Slw+ugPeeA2E6gsm9LGkCrXMe8zkRQxNvvf+KI4nG/NLnZbqfpGQ/
 doFEf68CTVMpNGhqzk9KfsrPV8q3GkGOR/OITLk1SarVRN6CsfEjbkW1HH4ccWOFFbvT
 rO+eNsMKZkxZcjcAOoy3BMPb0Gwyl/OPDmdmqUaX44vaUxeeO3DMTygrhktM83HmjCL6 qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kec7cgcef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 08:34:39 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29P8T2v7004065;
        Tue, 25 Oct 2022 08:34:38 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kec7cgcdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 08:34:38 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29P8Kpab005681;
        Tue, 25 Oct 2022 08:34:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3kc8593nj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 08:34:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29P8TLUB24838406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 08:29:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98C70A405F;
        Tue, 25 Oct 2022 08:34:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4916CA405C;
        Tue, 25 Oct 2022 08:34:33 +0000 (GMT)
Received: from [9.171.5.17] (unknown [9.171.5.17])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 08:34:33 +0000 (GMT)
Message-ID: <27590367-1667-f21b-44b7-70b0301366ed@linux.ibm.com>
Date:   Tue, 25 Oct 2022 10:34:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [v2 1/1] KVM: s390: VSIE: sort out virtual/physical address in
 pin_guest_page
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
References: <20221025082039.117372-1-nrb@linux.ibm.com>
 <20221025082039.117372-2-nrb@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221025082039.117372-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G1LGbywQGeLK0bziyeFSJReQHXICFODC
X-Proofpoint-GUID: x6NKagmD3on1RaJFlaYlbKzij6e5mWEC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_03,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 25.10.22 um 10:20 schrieb Nico Boehr:
> pin_guest_page() used page_to_virt() to calculate the hpa of the pinned
> page. This currently works, because virtual and physical addresses are
> the same. Use page_to_phys() instead to resolve the virtual-real address
> confusion.
> 
> One caller of pin_guest_page() actually expected the hpa to be a hva, so
> add the missing phys_to_virt() conversion here.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Looks good.
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>


Adding David CC.

> ---
>   arch/s390/kvm/vsie.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 94138f8f0c1c..0e9d020d7093 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -654,7 +654,7 @@ static int pin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t *hpa)
>   	page = gfn_to_page(kvm, gpa_to_gfn(gpa));
>   	if (is_error_page(page))
>   		return -EINVAL;
> -	*hpa = (hpa_t) page_to_virt(page) + (gpa & ~PAGE_MASK);
> +	*hpa = (hpa_t)page_to_phys(page) + (gpa & ~PAGE_MASK);
>   	return 0;
>   }
>   
> @@ -869,7 +869,7 @@ static int pin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
>   		WARN_ON_ONCE(rc);
>   		return 1;
>   	}
> -	vsie_page->scb_o = (struct kvm_s390_sie_block *) hpa;
> +	vsie_page->scb_o = phys_to_virt(hpa);
>   	return 0;
>   }
>   
