Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182DA494BA7
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 11:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359858AbiATK14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 05:27:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241964AbiATK1u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 05:27:50 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20K9wbex020333;
        Thu, 20 Jan 2022 10:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DVIj3GFgTkgKFo2VvBZ/iCyurbcDaBoDFE2fV/wwMxE=;
 b=VKTX+OH0G5TYiuEH20v5oDLvR2Z2yGd+RShzd4JK3xZ4xbSDaylOOBbAbqiLPNG6BxUp
 FV9wia2OYYk5VJQ4/gauu+SqSm+gf1V2GfND88i3AD+xm0oVrxTAjELumLjLHyVvDm5Q
 ++FnGXmTWVFRtx7Bji3VMsFwjRmm48O2XvBlOu5ef2cvKJxlyOuG3PW3F29NlrPWF7aJ
 Xriymftk45GZIOcgjlcGel+FhbFGdQ4Za1jV0pIQgOoGVW7sVoxXd00wIYS9Fc0hpD6D
 ZjMiPUrxMrZ4paZG9JRsSavcnXiFc88ifun05/pIlCdSgB59uPRkYSZ+uPGU5df5bOG4 qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq5k1rgw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 10:27:50 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20KA0JwE024807;
        Thu, 20 Jan 2022 10:27:50 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq5k1rgvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 10:27:50 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20KANp0C026798;
        Thu, 20 Jan 2022 10:27:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3dknhk030r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 10:27:47 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20KARirJ10354998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 10:27:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0EBFA4082;
        Thu, 20 Jan 2022 10:27:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B98AA405F;
        Thu, 20 Jan 2022 10:27:44 +0000 (GMT)
Received: from [9.171.38.24] (unknown [9.171.38.24])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Jan 2022 10:27:44 +0000 (GMT)
Message-ID: <d5247a6c-2088-cbfa-20f9-c1c748f90daf@linux.ibm.com>
Date:   Thu, 20 Jan 2022 11:27:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 02/10] KVM: s390: Honor storage keys when accessing
 guest memory
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-3-scgl@linux.ibm.com>
 <e5b06907-471d-fe4f-8461-a7dea37abca2@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <e5b06907-471d-fe4f-8461-a7dea37abca2@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1Y7FW37KP1asLZqtYofSVCCT09h35gef
X-Proofpoint-ORIG-GUID: t_eo0gSrPiFTT1nOlu1ssWHltFclHPuQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_03,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 18.01.22 um 15:38 schrieb Janosch Frank:
[...]
> /*
> We'll do an actual access via the mv instruction which will return access errors to us so we don't need to check here.
> */

Be slightly more verbose I guess. Something like
We'll do an actual access via the mv instruction which will return access errors to us so we don't need to check here.
By using key 0 all checks are skipped and no performance overhead occurs.

?

>> +    rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode, 0);
