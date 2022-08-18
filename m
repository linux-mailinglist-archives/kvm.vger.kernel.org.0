Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005C25983F9
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 15:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244988AbiHRNSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 09:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244978AbiHRNSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 09:18:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A92A89900;
        Thu, 18 Aug 2022 06:18:39 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ID0jY2004791;
        Thu, 18 Aug 2022 13:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ssj/yDLBypS6mx8/sQN/396WrOf9FQBZQ6GN+dBtpC8=;
 b=j989wUjvd/fkkatCFKJu5cnpyzolQOtNLf8AD42t1QlBX0Z+Xb2Wh5no3noQPSvInNsG
 f4ULduI67PUp0oj4TqfOWAG4m96kaXxDYASkbvDZ6rAfJJAYhTuO5V7vRbc3YZtjQTsb
 9HKQIawvf8Uyeph0Zs9UaT6vUdIZLDl4p0adIoDdCNsqDB6ZgYiHwfMn3P30BCZshnqC
 W9tVQ+lbFfosSGccqhqdHDr3fpZQh2Co1QWXH3NrIRvxAF7eAJj2AFWqO15bfrEs6aan
 k5DGQB8du41wBQOMXoY1mBNULIAQcKkeO918F82b1EKt0OUCSfczJDcnBseiqIN08SJ2 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1nxerp73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:18:37 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27ID34vq017629;
        Thu, 18 Aug 2022 13:18:36 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1nxerp6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:18:36 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27ID63o6017162;
        Thu, 18 Aug 2022 13:18:36 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3hx3ka6y7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:18:36 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IDIYnX9241150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 13:18:34 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4B0FBE051;
        Thu, 18 Aug 2022 13:18:34 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C22EABE053;
        Thu, 18 Aug 2022 13:18:33 +0000 (GMT)
Received: from [9.160.64.167] (unknown [9.160.64.167])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Aug 2022 13:18:33 +0000 (GMT)
Message-ID: <05640a9f-ef84-8ab6-48ee-8a7906ea477f@linux.ibm.com>
Date:   Thu, 18 Aug 2022 09:18:33 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/2] s390/vfio-ap: fix two problems discovered in the
 vfio_ap driver
Content-Language: en-US
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220817225242.188805-1-akrowiak@linux.ibm.com>
 <Yv3ynhVYegld5MsO@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <Yv3ynhVYegld5MsO@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 85-_5jbEEr4eZczMr6qQZSV9GB3ZbUxH
X-Proofpoint-ORIG-GUID: aEi3v0sf_JBrPZBrZ5bgRDu9nHMNAStu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=890 malwarescore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/18/22 4:04 AM, Alexander Gordeev wrote:
> On Wed, Aug 17, 2022 at 06:52:40PM -0400, Tony Krowiak wrote:
>> Two problems have been discovered with the vfio_ap device driver since the
>> hot plug support was recently introduced:
> Hi Tony,
>
> Could you please add Fixes tags to the patches?


Will do.


>
> Thanks!
