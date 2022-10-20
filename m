Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91A560631E
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 16:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJTOcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 10:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJTOcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 10:32:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792B619635B
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 07:32:44 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KEMA2G005212;
        Thu, 20 Oct 2022 14:32:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pkaKCD6eUecp+1SxFlu+uWxIaeD0jm3xzPJMF1CqNTE=;
 b=en9hXo5oFVwxOFG9ld7cVhgKAd/IpithZice1iK1pOYsMT9fTnyOBXPKSp2PoJ2zinYi
 Nk7P8tKz+CMma+cNkiA7PY3ar1DOUjtqN8yJWV5w1AReqBaud/bZ/YR7rLm4wqlrNykS
 z80TPDm0VlBxtxkHxNYyYCg2nDKE3HBtPeZfzVOviwuEyJIWYz60JIaArICag5kxpUFI
 eGojRK4gTaqBf6jBMPljCiUYhuNzhX99G4RHAgTlBmM1RV5vK+ovLITwJt2S5Q/en1el
 7Wbtvj8Cb9qim60nfVxjvbVKoN2Ljdzzpv75iZMPzv39/PEvFo8Jk1POYhmXNrZrnU05 Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb81e0afh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:36 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KEOE7f012225;
        Thu, 20 Oct 2022 14:32:36 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb81e0adx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:36 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KEKHkG026369;
        Thu, 20 Oct 2022 14:32:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3k7mg9et23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:33 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KEWU3T66453792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 14:32:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E4E84C046;
        Thu, 20 Oct 2022 14:32:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5194D4C044;
        Thu, 20 Oct 2022 14:32:29 +0000 (GMT)
Received: from [9.171.54.135] (unknown [9.171.54.135])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 14:32:29 +0000 (GMT)
Message-ID: <3db6c742-4d48-788a-7a84-710a4b4e2e0f@linux.ibm.com>
Date:   Thu, 20 Oct 2022 16:32:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v10 6/9] s390x/cpu topology: add topology-disable machine
 property
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
 <20221012162107.91734-7-pmorel@linux.ibm.com>
 <f4e07f9f-dd31-d300-cb3b-9714b88880e5@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <f4e07f9f-dd31-d300-cb3b-9714b88880e5@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XEqZOm4IQPSzef1luWhewb8aW4-KnArF
X-Proofpoint-ORIG-GUID: OLqqVs5j2ZcRHeiT1iPqmeFrCJzlWIrY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_05,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 mlxlogscore=727 adultscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 spamscore=0 clxscore=1015
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/18/22 19:51, Cédric Le Goater wrote:
> On 10/12/22 18:21, Pierre Morel wrote:
>> S390 CPU topology is only allowed for s390-virtio-ccw-7.3 and
>> newer S390 machines.
>> We keep the possibility to disable the topology on these newer
>> machines with the property topology-disable.
> 
> Isn't 'topology' enough for the property ? I don't think the
> '-disable' prefix adds much to the meaning.
> 
> C.
> 
> 

Agreed.

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
