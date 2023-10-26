Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA2C7D8452
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 16:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345183AbjJZOPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 10:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjJZOPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 10:15:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CB3128;
        Thu, 26 Oct 2023 07:15:17 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QDei4T006996;
        Thu, 26 Oct 2023 14:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=77A4uI71aLDR2Db3JvgQkrU3Bx1ZsYc0mBBzKN4HpKc=;
 b=OK16cxR+jtKDAQLYrcnvJWoBQRmyaM4c1vHKZM2r6Abflqd15h/bQ3/DaEsRu64Ti0ZC
 Dv2EgCe10AYx/ObrOqdShmXhVH04OR+gJOxRE3fjbWPxukc7oOYCLjB+PTvZZuZERHb+
 Nf3+GWeFAwUygKzY06dpAgf+Ac+/oToqv6x+vp+s/ePtuDzEh0yT8cqg87iuyTgtC5DJ
 9zoMUMxGmMuPGw258NKU6ijbUO7SH4VX9U5BpaYP/LX71Aoab9vae0y6vQz7DHEpqNVt
 nQVqN2lI8BSVQpi/mGVeYmm4K35pFKXf/9FxoIlnmJpX5wmd0EoX8QocXQa/v0TyGRlo bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tys74hp4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 14:15:15 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39QDsO7H025868;
        Thu, 26 Oct 2023 14:15:14 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tys74hp3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 14:15:14 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QDesuP023800;
        Thu, 26 Oct 2023 14:15:13 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tvryteuvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 14:15:13 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QEFCdt65405348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 14:15:13 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D19E15805B;
        Thu, 26 Oct 2023 14:15:12 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B975358055;
        Thu, 26 Oct 2023 14:15:11 +0000 (GMT)
Received: from [9.61.72.236] (unknown [9.61.72.236])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Oct 2023 14:15:11 +0000 (GMT)
Message-ID: <0bed3d29-7fb1-d56d-5f12-e2010ae7d97f@linux.ibm.com>
Date:   Thu, 26 Oct 2023 10:15:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 3/3] s390/vfio-ap: improve reaction to response code 07
 from PQAP(AQIC) command
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20231018133829.147226-1-akrowiak@linux.ibm.com>
 <20231018133829.147226-4-akrowiak@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20231018133829.147226-4-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ogj1CPFT1XYk4-Zbf1c8knNYu0fj2EF-
X-Proofpoint-GUID: FXJDR8LlgFemaX1G07i4-8ukJ6xy37be
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_12,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=930 clxscore=1011 impostorscore=0 spamscore=0 phishscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310260123
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/23 9:38 AM, Tony Krowiak wrote:
> Let's improve the vfio_ap driver's reaction to reception of response code
> 07 from the PQAP(AQIC) command when enabling interrupts on behalf of a
> guest:
> 
> * Unregister the guest's ISC before the pages containing the notification
>   indicator bytes are unpinned.
> 
> * Capture the return code from the kvm_s390_gisc_unregister function and
>   log a DBF warning if it fails.
> 
> Suggested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

I went back-and-forth on whether this should be a stable/fixes candidate but I think no...  I happened to notice it while reviewing other code, I'm not aware that it's ever created a visible issue, and it's on a pretty immediate error path.  If anyone thinks it should be a stable candidate I have no objection but in that case would suggest to break the patch up to separate the new WARN from the fix.



