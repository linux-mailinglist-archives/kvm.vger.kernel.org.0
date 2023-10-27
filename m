Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485E57D9CE7
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 17:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346252AbjJ0P1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 11:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjJ0P1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 11:27:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E97BAC;
        Fri, 27 Oct 2023 08:27:37 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39RFRWKS020602;
        Fri, 27 Oct 2023 15:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aTofS//6lM+7vOdImDA4rxnNot16RvEWBnEbVQegqtE=;
 b=OkEvk8ZSe/eVkZtxonJ1CUi7Ypip6vRGcq8uGV3mEogA6GHdSPXztBhsaAAer6qhc6Ei
 s2B+ilOdagwVy53if+BNKabPiaONwd91DZhJfak6ZQJHZn2wunkYnbdKIuP3ERX4Rt2+
 sXkdh7tUr0b2OyX1ypiFtR3Zebzg3uynvyS75JZKR0PGI2uPONzAm5p4Z7NicTRWFv4x
 w6j01bluGDf8XhHBMqw58Z3fTd9ACiaxum1YHF+w7+htI5PeqXTKRXrvH7dRyVmxlvEO
 J8MvyXrSIAmEmUfTtvTyeBOGrN+bnUNGQ/tnOEGggTq5dszTXjqMvgMu0Uv5dyK02kLZ SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0fqb0bdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 15:27:36 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39RFHddn017470;
        Fri, 27 Oct 2023 15:27:35 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0fqb0ahu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 15:27:33 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39RDP75T025010;
        Fri, 27 Oct 2023 15:26:00 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tywqrww41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 15:26:00 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39RFPwrv12518028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Oct 2023 15:25:59 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7F065805E;
        Fri, 27 Oct 2023 15:25:58 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0019D58051;
        Fri, 27 Oct 2023 15:25:57 +0000 (GMT)
Received: from [9.61.163.200] (unknown [9.61.163.200])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 27 Oct 2023 15:25:57 +0000 (GMT)
Message-ID: <7fe05c94-06ae-4e40-8894-95ad0b21a4a9@linux.ibm.com>
Date:   Fri, 27 Oct 2023 11:25:57 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] s390/vfio-ap: set status response code to 06 on
 gisc registration failure
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com
References: <20231026183250.254432-1-akrowiak@linux.ibm.com>
 <20231026183250.254432-3-akrowiak@linux.ibm.com>
 <20231027131904.165c7ad6.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20231027131904.165c7ad6.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xsa4torbGIfr5LiTVNH6-vM4L4Y433dc
X-Proofpoint-GUID: nITYVzzeQ1SHCxO7Guegs83rVdJAUTLD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-27_13,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 mlxlogscore=921 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310240000 definitions=main-2310270133
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/27/23 07:19, Halil Pasic wrote:
> On Thu, 26 Oct 2023 14:32:44 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> Since this scenario is very unlikely to happen and there is no status
>> response code to indicate an invalid ISC value, let's set the
> 
> Again invalid ISC won't happen except for hypervisor messes up.

Again, that is one of the checks performed by the kvm_s390_gisc_register
function; however, I get your point and will remove reference in the 
comment.

> 
>> response code to 06 indicating 'Invalid address of AP-queue notification
>> byte'. While this is not entirely accurate, it is better than indicating
>> that the ZONE/GISA designation is invalid which is something the guest
>> can do nothing about since those values are set by the hypervisor.
> 
> And more importantly AP_RESPONSE_INVALID_GISA is not valid for G2 in
> the given scenario, since G2 is not trying to set up interrupts on behalf
> of the G3 with a G3 GISA, but G2 is trying to set up interrupts for
> itself. And then AP_RESPONSE_INVALID_GISA is architecturally simply not
> a valid RC!

Got it.

> 
>>
>> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
>> Suggested-by: Halil Pasic <pasic@linux.ibm.com>
> 
> Except for the explanation in the commit message, the patch is good. It
> is up to you if you want to fix the commit message or not.
> 

I'll fix the commit message.

> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
