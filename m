Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CCB278DA2
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 18:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgIYQIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 12:08:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727324AbgIYQIN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 12:08:13 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PFiKtl051963;
        Fri, 25 Sep 2020 12:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6xMHMQMGRwMYwPzqiGQaNxAYydHxZT4ZI7Pq1aKtwqs=;
 b=X6iJXkI0k4DtQnBX4ILNxpB1oDSm5hoRdgUbTfE+wWcxSlXIjkHxF2NfyxZFuHC9/q3A
 zxQ68ZloW6vX8qayC/+MsNKmCe9ni3WqBxp0ba+sFp5B+a338kmyu38gRYiDEURdp27Y
 XgS0HjwehLpBZ+JPtV5w6N2Gxq3ArQxNzynP409oJTMK4n3F86MidPb/LiOEthEFVXoV
 dJ3EHfsoOuknFLGXvr67/5XHoCZgaTx4aNknNvBGX/EW9G0XNYTeWVDog7llwPavbqh3
 pgGAa4xBhxOuruOQp3vSL4fGk8px2+TSTYqkQ9oxHSXM1WWfQcam4btvlB0f3paZB5Z4 gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33skev8rkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 12:08:12 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08PFiL5O052096;
        Fri, 25 Sep 2020 12:08:12 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33skev8rgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 12:08:12 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08PG89eZ018975;
        Fri, 25 Sep 2020 16:08:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 33n9m83bwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 16:08:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08PG869731326610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 16:08:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87EED4C04A;
        Fri, 25 Sep 2020 16:08:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 264CD4C046;
        Fri, 25 Sep 2020 16:08:06 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.49.151])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Sep 2020 16:08:06 +0000 (GMT)
Subject: Re: [PATCH v1 1/4] memory: allocation in low memory
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1601049764-11784-1-git-send-email-pmorel@linux.ibm.com>
 <1601049764-11784-2-git-send-email-pmorel@linux.ibm.com>
Message-ID: <769e3e7e-7bf1-4974-77da-a260b033f151@linux.ibm.com>
Date:   Fri, 25 Sep 2020 18:08:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1601049764-11784-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_14:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 priorityscore=1501
 adultscore=0 suspectscore=1 mlxscore=0 mlxlogscore=692 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Arrrghh sorry, I forgot the kvm-unit-tests TAG


On 2020-09-25 18:02, Pierre Morel wrote:
> Some architectures need allocations to be done under a
> specific address limit to allow DMA from I/O.
> 
> We propose here a very simple page allocator to get
> pages allocated under this specific limit.
> 
> The DMA page allocator will only use part of the available memory
> under the DMA address limit to let room for the standard allocator.
> 
-- 
Pierre Morel
IBM Lab Boeblingen
