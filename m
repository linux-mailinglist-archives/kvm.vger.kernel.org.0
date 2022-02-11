Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4AA4B209E
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 09:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348242AbiBKIxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 03:53:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348217AbiBKIwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 03:52:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E6AE6C;
        Fri, 11 Feb 2022 00:52:54 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21B8aKD9013455;
        Fri, 11 Feb 2022 08:52:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1AREIg3tT5M78O731Aq0XU8WW5XGAHYrzN5d+P7p8/w=;
 b=B/swpvNOse8fsay+klvSXUrlxPw1XNwEmbli2UtQ1A/mlCBFGzBe4jpVhamCI67pF1+K
 9hhwCThFRZEdfssxUcp39Ky00GfvyMvDv8U+NdR3kYKrIAcTO52Crr11ua1kJ4bG0TJF
 wq/S934I9nK7jy1jh7hDoZS0lKHEE/RcitmgIgk+QaIFdPIN/kZLBcFxs5cnLIYP8oDo
 XaTpEL8dcmn/0P43ICPNlq6rn26UpE7sLq5WtHeKtywHO3KJQ+2IxEysApTmZwMleqBr
 qJ6lEtPTIz6IoRqH8JxJWA7hn++DozWM7TPSK3VpgSrmTxnInlOrDwBWSAwVq8LjHaMG AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4kt37ba2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 08:52:53 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21B8ofnv032120;
        Fri, 11 Feb 2022 08:52:52 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4kt37b9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 08:52:52 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21B8mNJx008303;
        Fri, 11 Feb 2022 08:52:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3e1gva5j6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 08:52:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21B8qjQ242861006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 08:52:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36994AE059;
        Fri, 11 Feb 2022 08:52:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63D4BAE051;
        Fri, 11 Feb 2022 08:52:44 +0000 (GMT)
Received: from [9.171.43.150] (unknown [9.171.43.150])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Feb 2022 08:52:44 +0000 (GMT)
Message-ID: <efd48bf7-8463-01f3-566e-b372881e132f@linux.ibm.com>
Date:   Fri, 11 Feb 2022 09:52:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: s390: MAINTAINERS: promote Claudio Imbrenda
Content-Language: en-US
To:     KVM <kvm@vger.kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20220210085310.26388-1-borntraeger@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220210085310.26388-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vIDhZdrDCPjxSM-zAMgnv2H-cnZwpee4
X-Proofpoint-ORIG-GUID: vMlE_4zIhkXyfIAj4Sim6b_3_2SlEmpV
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 10.02.22 um 09:53 schrieb Christian Borntraeger:
> Claudio has volunteered to be more involved in the maintainership of
> s390 KVM.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f41088418aae..cde32aebb6ef 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10548,8 +10548,8 @@ F:	arch/riscv/kvm/
>   KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
>   M:	Christian Borntraeger <borntraeger@linux.ibm.com>
>   M:	Janosch Frank <frankja@linux.ibm.com>
> +M:	Claudio Imbrenda <imbrenda@linux.ibm.com>
>   R:	David Hildenbrand <david@redhat.com>
> -R:	Claudio Imbrenda <imbrenda@linux.ibm.com>
>   L:	kvm@vger.kernel.org
>   S:	Supported
>   W:	http://www.ibm.com/developerworks/linux/linux390/

applied.
