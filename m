Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5934528A45
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 18:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343607AbiEPQ0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 12:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343585AbiEPQ0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 12:26:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0233A701;
        Mon, 16 May 2022 09:26:43 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GGCOdp030439;
        Mon, 16 May 2022 16:26:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FW7LXEMJ9ccPDqxTB2fNIrNiMkgGgzIJb2LJamfTN1c=;
 b=RJ6MmqluV7IZwhEGYh5OC/kAjd842cjLpI0CvsAhXw9s8OHkVyI+o/yV2N/iI5RBtYlc
 UixYpW+thKJO+VPJRYO7kHIIyW60/fG3WR0Fp4xI1UeJq04zi7FLMcYTKGH0YzDrJmQx
 +wDk+c2wh1bXRI4abP/e5joYkPAarjeP2T2w8eJXyc4peanB4xggrX46Lho/wgmmVoar
 /9T1SgGL/WC//27Amif9g1ceK1wfmhCb63pDtt0i+vWnpg7amcllkZPvR/mXj/8Su+KR
 V8i8bkRPzx+/2sQLZiGr5Ow9jOdaRvUuy42K6l3awQSrYmmGnrd8Ip9r8Glw2gt0dQa+ oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3swy09a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:26:43 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GGExP2008296;
        Mon, 16 May 2022 16:26:42 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3swy099j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:26:42 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GGAMV2012754;
        Mon, 16 May 2022 16:26:40 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428tbhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:26:39 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GGQav041091544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 16:26:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90FA3A4055;
        Mon, 16 May 2022 16:26:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBF29A404D;
        Mon, 16 May 2022 16:26:35 +0000 (GMT)
Received: from [9.171.15.172] (unknown [9.171.15.172])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 16:26:35 +0000 (GMT)
Message-ID: <15c52e89-d6cf-213a-fc03-413d3dcba90c@linux.ibm.com>
Date:   Mon, 16 May 2022 18:30:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 1/3] s390x: KVM: ipte lock for SCA access should be
 contained in KVM
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-2-pmorel@linux.ibm.com>
 <e23160b6-2d3c-ebdb-ac5a-c71311e7e5ec@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <e23160b6-2d3c-ebdb-ac5a-c71311e7e5ec@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RIuCxaz11snyi8IfVRivkNE-DjSOn0Ha
X-Proofpoint-GUID: CDHvPm2uNGaGKjFLqeu8NoyXsSodW2PT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_14,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 clxscore=1015 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160091
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/12/22 11:08, David Hildenbrand wrote:
> On 06.05.22 11:24, Pierre Morel wrote:
>> The former check to chose between SIIF or not SIIF can be done
>> using the sclp.has_siif instead of accessing per vCPU structures
>>
>> When accessing the SCA, ipte lock and ipte_unlock do not need
>> to access any vcpu structures but only the KVM structure.
>>
>> Let's simplify the ipte handling.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Much better
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> 

Thanks,
Regards,

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
