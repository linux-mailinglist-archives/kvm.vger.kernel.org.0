Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9563C54E62D
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 17:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377944AbiFPPgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 11:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377809AbiFPPgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 11:36:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C9B31503;
        Thu, 16 Jun 2022 08:36:35 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GEecYK013165;
        Thu, 16 Jun 2022 15:36:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=F2D5JfxwtgyI3b6ctYA9aNW/R40yNZMWEhJ9PxgN60g=;
 b=aoE22GAbMMpAJDjVwtsl9yJEP7piWN6k4lty0ar4FqJ18CBOS8XYWgTIzFZIIoZZl60e
 d1iYpAuJrXZdKnj0NF4MnO7zxmdKipPHjID8l62qMRcaHGMqUSEK3Lu64wubrYaBx24c
 Qg+7V/tZ5d0ZlX4WsLmenNxNeVCBUHFRo36R2HfplbxGqqhindYwJ8f4rlS01koxjuac
 zGLBzqX7h+1yT7EEZWi43P4urM6yLAiNL20bpqMLJrw+fPEAkWcMq5gfp0V3EpySvqcp
 ffiDVfVvjos4sRADYsqlPaRRnwD7Nnk6eiUg0nBJX7A+ce7tT8aPUy54n4IrkyNEFJNA IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqr2ppt0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 15:36:33 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25GF2LwK000745;
        Thu, 16 Jun 2022 15:36:33 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqr2ppt0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 15:36:33 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25GFZ1O1026006;
        Thu, 16 Jun 2022 15:36:32 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3gmjp9tp93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 15:36:32 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25GFaV2p15991122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 15:36:31 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B27D6136051;
        Thu, 16 Jun 2022 15:36:31 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E71A13604F;
        Thu, 16 Jun 2022 15:36:31 +0000 (GMT)
Received: from [9.211.56.136] (unknown [9.211.56.136])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jun 2022 15:36:30 +0000 (GMT)
Message-ID: <285b6fe1-d1bd-21a0-97d2-e8ef52e9acf3@linux.ibm.com>
Date:   Thu, 16 Jun 2022 11:36:30 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 04/10] vfio/ccw: Remove private->mdev
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220615203318.3830778-1-farman@linux.ibm.com>
 <20220615203318.3830778-5-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220615203318.3830778-5-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7uO0xnwC404RSkZ4BAAqT8rNqzAuhsPQ
X-Proofpoint-ORIG-GUID: FYW2UkhqO8SQZPWpiidCz7GTR2ew89k0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_12,2022-06-16_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=901 phishscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160060
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/15/22 4:33 PM, Eric Farman wrote:
> There are no remaining users of private->mdev. Remove it.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
