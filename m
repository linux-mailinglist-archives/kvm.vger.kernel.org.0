Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B587F692660
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 20:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbjBJTa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 14:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbjBJTa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 14:30:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DD67E022;
        Fri, 10 Feb 2023 11:30:26 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AJC1TT022977;
        Fri, 10 Feb 2023 19:30:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ruisLi78RjHoixlKjC6u1GfJ6FalANjgq/pU+XOCVTE=;
 b=ORqy8L0Nl54ulz7vyRwoH4Wtw/r2cVgVayRXOcqtt3ujgBzelvk2zZRf9+6ZRPEn67wO
 yfMq3kN9U8fCUsYNbG4vySyCw4R73Yfft9KRYV4OTja9Pxr8iBeh9YT/IzkXtVHH5/S8
 tAPlxtbd9QqBt9BTqxd+cMFe8mkv84do9N/s9YSHl1h9lkijXAGsd1MtxXSUS+ir6iN5
 hmcb7URZI5YxPw4lMZETTJE3BWSy2va/JMF0cAty7ZsIaM6lUDieO/eSfmAy/e/Evpyj
 3IoxXx6xfj5nt9eZaSB16BVhUTIhWI9DCVkQJH6HE9HLsj9Rp0q1rfGz23q5F+u7Wt25 VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnuv7rcbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 19:30:25 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31AJM5U8025598;
        Fri, 10 Feb 2023 19:30:25 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnuv7rcbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 19:30:25 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31AIxZOL019723;
        Fri, 10 Feb 2023 19:30:24 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3nhf08gkjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 19:30:24 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31AJUM2l34210158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 19:30:22 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E3E65805B;
        Fri, 10 Feb 2023 19:30:22 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 170AC58059;
        Fri, 10 Feb 2023 19:30:21 +0000 (GMT)
Received: from [9.65.251.35] (unknown [9.65.251.35])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Feb 2023 19:30:20 +0000 (GMT)
Message-ID: <055a5964-af3f-5b6e-7eff-a87d2d0ecab9@linux.ibm.com>
Date:   Fri, 10 Feb 2023 14:30:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] vfio/ccw: Remove WARN_ON during shutdown
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20230210174227.2256424-1-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230210174227.2256424-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3ibfz0t3TTD9y3Zo2e-tPhGMxRqWNYNK
X-Proofpoint-GUID: B48__ZxyklQEMiDRgdENIWKz0xvf8qgv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_13,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100160
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/23 12:42 PM, Eric Farman wrote:
> The logic in vfio_ccw_sch_shutdown() always assumed that the input
> subchannel would point to a vfio_ccw_private struct, without checking
> that one exists. The blamed commit put in a check for this scenario,
> to prevent the possibility of a missing private.
> 
> The trouble is that check was put alongside a WARN_ON(), presuming
> that such a scenario would be a cause for concern. But this can be
> triggered by binding a subchannel to vfio-ccw, and rebooting the
> system before starting the mdev (via "mdevctl start" or similar)
> or after stopping it. In those cases, shutdown doesn't need to
> worry because either the private was never allocated, or it was
> cleaned up by vfio_ccw_mdev_remove().
> 
> Remove the WARN_ON() piece of this check, since there are plausible
> scenarios where private would be NULL in this path.
> 
> Fixes: 9e6f07cd1eaa ("vfio/ccw: create a parent struct")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

The other ops in vfio_ccw_sch_driver look OK in that they quietly tolerate this scenario -- with .irq being an exception but the rationale and what we log there makes sense to me (we shouldn't get an interrupt on a disabled subchannel) plus it's only a debug log not a WARN.
