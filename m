Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17589575076
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 16:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbiGNOM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 10:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240350AbiGNOMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 10:12:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E42654C82;
        Thu, 14 Jul 2022 07:12:08 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26ECaxI7031958;
        Thu, 14 Jul 2022 14:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=678zjVBjiVOwXHJhZQpMbyH65qlU4B7o72itmKDXWz4=;
 b=te6WQXJeFPgHlUAS9ZTh+d4mlFG3Li/FNiCHg2MKyRcXiz5XRi4LtTI6WGiOP+ohnXgg
 ss8DfGPO1hHnLgg5hbIfDIUXWp++LD1mvuRL2RCgHQ7tdgCcUvlq8F0u3qCp3IdVVKWV
 QSxhEJ5C+xA9MRjuTMiFlwR9SsKjva7Nh3kUnv8mX0g/r12twz01WULtwiJVukhwGQV/
 oHEWfzWgK2xqV49nFH5xZMIJrs8RnsSHaxWWngNz3nbynwtzOQrlHw5mtBaZhIpRfnFd
 1o7bznvsaU78uRgkua3IWBhHLPPD1W1H1ePspi09Jpw+5qkBv4nbuPpFzhw1cy6t1J3h GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hak32aq4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 14:12:07 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26EE08NI028291;
        Thu, 14 Jul 2022 14:12:07 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hak32aq3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 14:12:07 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26EE5Q8k015181;
        Thu, 14 Jul 2022 14:12:04 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3h71a8necr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 14:12:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26EEC1BS24904102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 14:12:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BC23A405B;
        Thu, 14 Jul 2022 14:12:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97DC4A4054;
        Thu, 14 Jul 2022 14:12:00 +0000 (GMT)
Received: from [9.145.62.186] (unknown [9.145.62.186])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jul 2022 14:12:00 +0000 (GMT)
Message-ID: <541d85d3-4864-583c-ff33-d0f566770c9f@linux.ibm.com>
Date:   Thu, 14 Jul 2022 16:12:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
References: <20220714101824.101601-1-pmorel@linux.ibm.com>
 <20220714101824.101601-3-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v13 2/2] KVM: s390: resetting the Topology-Change-Report
In-Reply-To: <20220714101824.101601-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HMjFGSPX4U6Gaf9HY3xHKcarm35HOhcO
X-Proofpoint-GUID: VoOHqQY2O1Xi0R0dvQYg7TLmBxfjvtZF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_10,2022-07-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/22 12:18, Pierre Morel wrote:
> During a subsystem reset the Topology-Change-Report is cleared.
> 
> Let's give userland the possibility to clear the MTCR in the case
> of a subsystem reset.
> 
> To migrate the MTCR, we give userland the possibility to
> query the MTCR state.
> 
> We indicate KVM support for the CPU topology facility with a new
> KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Nit below, but:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1158,6 +1158,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_SYSTEM_EVENT_DATA 215
>   #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
>   #define KVM_CAP_S390_PROTECTED_DUMP 217
> +#define KVM_CAP_S390_CPU_TOPOLOGY 218
>   #define KVM_CAP_S390_ZPCI_OP 221

Using 222 and moving it a line down might make more sense as 218 is 
KVM_CAP_X86_TRIPLE_FAULT_EVENT.

Can you fix this and push both patches to devel?
Also send the fixed patch as a reply to this message so I can pick it 
from the list.

next and devel have diverted a bit so I will need to fix this up for 
next, same for the Documentation entry which will be 6.39 instead of 6.38.

>   
>   #ifdef KVM_CAP_IRQ_ROUTING

