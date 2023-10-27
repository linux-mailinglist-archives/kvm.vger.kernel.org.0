Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4ED7D9656
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 13:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345711AbjJ0LTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 07:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjJ0LTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 07:19:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48493129;
        Fri, 27 Oct 2023 04:19:14 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39RBEDLi005170;
        Fri, 27 Oct 2023 11:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mwipWYAVb8YaWAy/RpG5D3vAZ+ckCTcTj/JKsmqJc4M=;
 b=ZFJ712XHZ0c46ZTVVSQfvlioGqkyPZc0dRwu6RVJnRtLg7icQ1aLvBwSWNAjh1NVptVA
 Df2k9ik+I++xOr3vSVrUvik7DOvZvwBkuEUco2ftjSSJ/g741cfDsblYkaXLyIuV5Bog
 j/l/ZLyygHEMLOxJu1yFtN7KWVtKvi/l0ZSgLHL2g1++9IULlbRfXySpzLSBSXx0nosH
 zYMIOnPtdNJzbc6aiFo/qrd4eit01UbJyRhZSpbIwA6MRY88+CoddbGyqIYTo0ok7Q2X
 NovwQhZvmroEzfBGScN092FOy/uaNR+j3qK5Pdm5rNJsFAIr+ArXTYBdD3IfsiYL/+GD sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0c5c876s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 11:19:13 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39RBGMqB017526;
        Fri, 27 Oct 2023 11:19:12 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0c5c8764-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 11:19:12 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39RASYvb021676;
        Fri, 27 Oct 2023 11:19:12 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tywqscm1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 11:19:11 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39RBJ8Xw11404028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Oct 2023 11:19:08 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9FE620049;
        Fri, 27 Oct 2023 11:19:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E80C20040;
        Fri, 27 Oct 2023 11:19:08 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 27 Oct 2023 11:19:08 +0000 (GMT)
Date:   Fri, 27 Oct 2023 13:19:04 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v3 2/3] s390/vfio-ap: set status response code to 06 on
 gisc registration failure
Message-ID: <20231027131904.165c7ad6.pasic@linux.ibm.com>
In-Reply-To: <20231026183250.254432-3-akrowiak@linux.ibm.com>
References: <20231026183250.254432-1-akrowiak@linux.ibm.com>
        <20231026183250.254432-3-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 52nVs5n_SCS3dPxZrNsNAdG5zGzKC9-Y
X-Proofpoint-ORIG-GUID: HUKW71VpXsQDYvGEU7jQF_dKpoDEdBMU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-27_09,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=998
 priorityscore=1501 adultscore=0 lowpriorityscore=0 clxscore=1015
 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310270098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Oct 2023 14:32:44 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Since this scenario is very unlikely to happen and there is no status
> response code to indicate an invalid ISC value, let's set the

Again invalid ISC won't happen except for hypervisor messes up.

> response code to 06 indicating 'Invalid address of AP-queue notification
> byte'. While this is not entirely accurate, it is better than indicating
> that the ZONE/GISA designation is invalid which is something the guest
> can do nothing about since those values are set by the hypervisor.

And more importantly AP_RESPONSE_INVALID_GISA is not valid for G2 in
the given scenario, since G2 is not trying to set up interrupts on behalf
of the G3 with a G3 GISA, but G2 is trying to set up interrupts for
itself. And then AP_RESPONSE_INVALID_GISA is architecturally simply not
a valid RC!

> 
> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Suggested-by: Halil Pasic <pasic@linux.ibm.com>

Except for the explanation in the commit message, the patch is good. It
is up to you if you want to fix the commit message or not.

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
