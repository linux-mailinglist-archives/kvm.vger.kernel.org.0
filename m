Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF52378896E
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 15:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245414AbjHYN5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 09:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245462AbjHYN52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 09:57:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED932727;
        Fri, 25 Aug 2023 06:57:01 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37PDr969026832;
        Fri, 25 Aug 2023 13:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZOV+tTXka1RAdJ4M3Kwz6+/OPBmhXbtrwzGEYR6YcBI=;
 b=tPZSLrRevhrwOErZyr3Bte1IACy/jeG8dXEEmbfO7SL1YUbQ27jpSZRpwwlp9UV7/X0f
 RbrZoOjwL20AO3t5+VIwilZd+2jGXuZtqnQHRf5YgjEhkyA6ZLnh76q3+hAktuSrxUOR
 IKAyVfuW8AXazX5eUu/It1IUqbRjggNK8XX/Emf7nzubkscOJ35gEnRSofyG/OIfheQP
 5zAE5hAfWyEViRgMC/i1wM4Y23PCUvafNv/JyhnDX7bPJxPBTYG5T/RrlbVtRBZ2D/Wb
 8dpIVI+OzP+AdXV1oPjTBGFzw6heV9mS8tp6Uz5PFjjtwrf+VwUoWjj8P7dyNQt83+FW yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3spwjyg24b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Aug 2023 13:56:55 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37PDrRdb026950;
        Fri, 25 Aug 2023 13:56:54 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3spwjyg23t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Aug 2023 13:56:54 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37PD9NaW004055;
        Fri, 25 Aug 2023 13:56:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn21ryxve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Aug 2023 13:56:53 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37PDuoSx19071616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 13:56:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4235620049;
        Fri, 25 Aug 2023 13:56:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80CD320040;
        Fri, 25 Aug 2023 13:56:49 +0000 (GMT)
Received: from [9.171.27.38] (unknown [9.171.27.38])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 25 Aug 2023 13:56:49 +0000 (GMT)
Message-ID: <99289fd4-0a1e-3c05-8934-732ef7815942@linux.ibm.com>
Date:   Fri, 25 Aug 2023 15:56:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, mihajlov@linux.ibm.com,
        seiden@linux.ibm.com, akrowiak@linux.ibm.com,
        Ilya Leoshkevich <iii@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [GIT PULL 00/22] KVM: s390: Changes for 6.6
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GrfdkVPZbHAgd_t2IbI6e7mGLLvVt3cQ
X-Proofpoint-GUID: jMPG2jvLV9uE81jgN5UeUh97XLKGGamW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_12,2023-08-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 mlxlogscore=878 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250120
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/23 14:43, Janosch Frank wrote:
> Hello Paolo,
> 
> please pull the following changes for 6.6.
> 

@Paolo:
Seems like neither Claudio (who picked the selftest) nor I had a closer 
look into the x86 selftest changes and Nina just informed me that this 
might lead to problems.

Please hold back on this pull request, I'll send a new one on Monday 
where we'll pull in the selftest changes and have a fixed up version of 
the selftest. I've spoken to Ilya privately and he's ok with Claudio 
fixing this up.

