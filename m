Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D22977F4E4
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 13:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350192AbjHQLSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 07:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350183AbjHQLSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 07:18:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AC126A8;
        Thu, 17 Aug 2023 04:18:23 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HB8qdV025582;
        Thu, 17 Aug 2023 11:18:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Md/XQDzAqSdh/Lj36ZfSGdjTb6Al/dUfr5Li9y6J08o=;
 b=cCVtDMrxb581CQ9IBs6z8njleAOOofu5ZMvRC1nhNCMk/uy7LO3c60LUlLEc/ZqI+mY0
 EWMzRtthJ8FDU4M08YyKw0t4FX0kccyGsTgjdwByX4mQWO6blJ/bRIVqo1pzVF9vieVJ
 nuWF2s381/CgFHmtmsOQUqBSRYk2eIvhwqwJljtOCZGZ5sww7pbZT5fTFF8kkCnWK1iR
 gAWn0pONNJt3wfJ1S3CG0AekkxRu4drDeMz/mGPdx99yn1rTMJq1zYMobfrJlZZhdMJ/
 g2zDD3HujuhC5vNnVS10CzMGI+WIjhWnxTWGiJBvEpl9XKQgD+RGCw/C1sAQIV82q0Li Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3shja3g9v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 11:18:21 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37HBF5QL017058;
        Thu, 17 Aug 2023 11:18:21 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3shja3g9uh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 11:18:21 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37HAZcMS013500;
        Thu, 17 Aug 2023 10:59:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sepmk51gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 10:59:59 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37HAxtKw60752292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Aug 2023 10:59:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0D3320043;
        Thu, 17 Aug 2023 10:59:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5491C20040;
        Thu, 17 Aug 2023 10:59:55 +0000 (GMT)
Received: from [9.152.224.236] (unknown [9.152.224.236])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 17 Aug 2023 10:59:55 +0000 (GMT)
Message-ID: <5b671c7c-dcc8-9c33-6eb5-58c5921708a1@linux.ibm.com>
Date:   Thu, 17 Aug 2023 12:59:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v4 1/4] KVM: s390: pv: relax WARN_ONCE condition for
 destroy fast
To:     Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
References: <20230815151415.379760-1-seiden@linux.ibm.com>
 <20230815151415.379760-2-seiden@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <20230815151415.379760-2-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Y29V-gehlZm6ZyKQ6R8ZF9gzcGG7su2d
X-Proofpoint-GUID: NXaFu11Aai7L-p23LlB8V6mCg36kILPF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_03,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 mlxlogscore=773 impostorscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308170100
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.08.23 17:14, Steffen Eiden wrote:
> From: Viktor Mihajlovski <mihajlov@linux.ibm.com>
> 
> Destroy configuration fast may return with RC 0x104 if there
> are still bound APQNs in the configuration. The final cleanup
> will occur with the standard destroy configuration UVC as
> at this point in time all APQNs have been reset and thus
> unbound. Therefore, don't warn if RC 0x104 is reported.
> 
> Signed-off-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>


Reviewed-by: Michael Mueller <mimu@linux.ibm.com>

> ---
>   arch/s390/kvm/pv.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 8d3f39a8a11e..8570ee324607 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -285,7 +285,8 @@ static int kvm_s390_pv_deinit_vm_fast(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
>   	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM FAST: rc %x rrc %x",
>   		     uvcb.header.rc, uvcb.header.rrc);
> -	WARN_ONCE(cc, "protvirt destroy vm fast failed handle %llx rc %x rrc %x",
> +	WARN_ONCE(cc && uvcb.header.rc != 0x104,
> +		  "protvirt destroy vm fast failed handle %llx rc %x rrc %x",
>   		  kvm_s390_pv_get_handle(kvm), uvcb.header.rc, uvcb.header.rrc);
>   	/* Intended memory leak on "impossible" error */
>   	if (!cc)
