Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7027777CD6C
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 15:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbjHONkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 09:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237456AbjHONjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 09:39:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F2B198A;
        Tue, 15 Aug 2023 06:39:40 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FDRiFu025436;
        Tue, 15 Aug 2023 13:39:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QXVhqLpSETY4yS9ieeYkEhpAAoSKsDHCtHIVOTMwAKU=;
 b=ofoHvZ4UHVYYK0XS6BMBUZKHhaXFKms6NQW9nfSF27yl4F3n7vjqbbpklI96pONTsiPS
 A1+LpRzxGgJgGKRBIuMxZPcT4h5ZIJT6MOX+0tRy9scqqz5QVkl+UFyiGJicMII8FQeP
 H4HAMWNbP0+K9ajQQy/lfFIF9STQjNixBNjjZDnLanx1ED2fKIbcvR5BHkdzxNwPO5QI
 0V3GhXvrrIU0KhpyyF26UOE3gaYx6pg0qfCvZDqmw09cQpxXo/ympnLSU/R/36aG6wYm
 rMREhZFHVB/JPAZyp/D00YRuXiW6nbdn34G2c1BY0G05lAhw94n545NJAtjP3dNsaYC3 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sga8x0gqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 13:39:40 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FDRl0g025531;
        Tue, 15 Aug 2023 13:39:39 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sga8x0gq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 13:39:39 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FCal1S003439;
        Tue, 15 Aug 2023 13:39:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3semdsdhf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 13:39:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FDdZTN39715088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 13:39:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D285E20040;
        Tue, 15 Aug 2023 13:39:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50B5C2004D;
        Tue, 15 Aug 2023 13:39:35 +0000 (GMT)
Received: from [9.171.12.89] (unknown [9.171.12.89])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 13:39:35 +0000 (GMT)
Message-ID: <464a84ad-bc8b-30be-3f20-8091a236113c@linux.ibm.com>
Date:   Tue, 15 Aug 2023 15:39:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 2/3] KVM: s390: Add UV feature negotiation
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20230810113255.2163043-1-seiden@linux.ibm.com>
 <20230810113255.2163043-3-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230810113255.2163043-3-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RdY7KNl9uVhzBxYrqG75dYxRKxglYzg9
X-Proofpoint-ORIG-GUID: Y-GVg1Iamt4gGUjoRHQnxynZA4S3udCL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_13,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 mlxlogscore=917 priorityscore=1501 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308150120
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/23 13:32, Steffen Eiden wrote:
> Add a uv_feature list for pv-guests to the KVM cpu-model.
> The feature bits 'AP-interpretation for secure guests' and
> 'AP-interrupt for secure guests' are available.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
[...]
>   
> +#define KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT 0

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

I don't think that's needed, just set it to 0 (and even that's not 
really needed since it's kzalloced but I'm fine with making this explicit).

>   int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   {
>   	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
> @@ -3296,6 +3368,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
>   	kvm->arch.model.ibc = sclp.ibc & 0x0fff;
>   
> +	kvm->arch.model.uv_feat_guest.feat = KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT;
> +
>   	kvm_s390_crypto_init(kvm);
>   
>   	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {

