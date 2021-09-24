Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E084169FF
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 04:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243913AbhIXC01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 22:26:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243813AbhIXC01 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 22:26:27 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18O1dPdV018047;
        Thu, 23 Sep 2021 22:24:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gVljcN2fkJI0NveeAGQk6omVa10K35Qwoy8qUoEqafY=;
 b=W0ZOgIncXT0/VV2Tcderfk3GCZZTuU/ED7UoJusPhtnU4u2k4zVdqP9wVS0c6WcxA91P
 JDhHq4wFGNexQ2Mbm63f9m3Mi0tbNKYRPVj6w5VEJxnJ+zsVEGmX93bird4lfwADUQrF
 D1m5ECqC1W4iQx+Ci84NIoGBoxaYt2SOwgq5+AehQ2hPi19wVUvlZD1A3FkROqqR42gm
 WqpmL5XDRmXA4uTz9hNa3AztavF58FnTZ+o4ud6BFxoX0HZwsmRyfSG1/4/n6vsinDGx
 J7i3O6vXGSM+R+hstuRNYok4CsnlYJTJYrS3w7823SSwMyC3S9QjIFp2L6Ajz/I9H53/ 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b93suaarc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 22:24:50 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18O2HE38020162;
        Thu, 23 Sep 2021 22:24:49 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b93suaar8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 22:24:49 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18O2DZZb012224;
        Fri, 24 Sep 2021 02:24:48 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 3b93g1tsk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Sep 2021 02:24:48 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18O2OlGL45220136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 02:24:47 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24C7D6E056;
        Fri, 24 Sep 2021 02:24:47 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2C856E054;
        Fri, 24 Sep 2021 02:24:45 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com (unknown [9.65.75.198])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 24 Sep 2021 02:24:45 +0000 (GMT)
Subject: Re: [PATCH v3] vfio/ap_ops: Add missed vfio_uninit_group_dev()
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
References: <0-v3-f9b50340cdbb+e4-ap_uninit_jgg@nvidia.com>
 <4a50ed05-c60c-aad0-bceb-de9665602aed@linux.ibm.com>
 <20210922131150.GP327412@nvidia.com>
 <20210923141009.5196b90b.alex.williamson@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <065e2551-a61f-6703-95f5-91991f0a38f4@linux.ibm.com>
Date:   Thu, 23 Sep 2021 22:24:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210923141009.5196b90b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RB6XA6m6oyXToPGsjQN7hFc-UoDO8Xlt
X-Proofpoint-GUID: aaefuldBx7iQzcTZpVSPP6mlGA-WWyqe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-23_07,2021-09-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2109240009
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/23/21 4:10 PM, Alex Williamson wrote:

> Tony, I'd love to get an ack if you're satisfied with this so we can
> close up fixes for v5.15.  Thanks,
>
> Alex

Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>

>

