Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE8475761B
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 10:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjGRICL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 04:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjGRIBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 04:01:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6AE1BE7
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 01:00:59 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36I7qqZZ024189;
        Tue, 18 Jul 2023 07:59:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=mJY05nR5Wx5Iv/YluOfOqgKi1bomFqOd3CeiuNR2kb8=;
 b=hC/vkPB3E88fldQKlZAgtXUyD/16QCWHJJkNukoUS9C/Gd0n8IUQFpPHOv2SmHiOnLc+
 iUufHpCfe+uQ+AxDYln4nzX23JeJ6VBGIjfKyLhjaFTWuCkwDaQjRVxXz6SAaWUHabAM
 eo2z8iVuqXe7lIlhGuiptZTQ+115QoSRUKl3FVLUFk/VkpF+l6gL1ySStsWcOKC88nzO
 Bd6aZTKwMgLV3QWALE/t9UTWGG6LLDnZUnOfrW20zJKzIsd4IpKMO8bnn1rHeqOp42Cg
 3n8nxpqLjYgvo9ZNVagud4G3PQ/hpajluqpQwvKMd3MsA/cAd6YGtpRcBTU+ULvIoh4B yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwpqu84e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 07:59:41 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36I7raFr026695;
        Tue, 18 Jul 2023 07:59:40 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwpqu84e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 07:59:40 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36I51uPM007106;
        Tue, 18 Jul 2023 07:59:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv80j25ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 07:59:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36I7xZgd17891926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 07:59:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BA3B2004B;
        Tue, 18 Jul 2023 07:59:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D6CB20049;
        Tue, 18 Jul 2023 07:59:34 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.179.14.18])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jul 2023 07:59:34 +0000 (GMT)
Message-ID: <94f9f61ac3503bed380ce232ca0f5885982ee6e4.camel@linux.ibm.com>
Subject: Re: [PATCH v21 11/20] qapi/s390x/cpu topology:
 CPU_POLARIZATION_CHANGE qapi event
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Tue, 18 Jul 2023 09:59:33 +0200
In-Reply-To: <20230630091752.67190-12-pmorel@linux.ibm.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
         <20230630091752.67190-12-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YZV9pEPkdIDiGCqSgZvxfO3kSZ7i5pP8
X-Proofpoint-GUID: SE2LkQmUh6tjRec7Wl-gLr_nD-ShTpCe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_15,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxlogscore=886 mlxscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307180067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-06-30 at 11:17 +0200, Pierre Morel wrote:
> When the guest asks to change the polarization this change
> is forwarded to the upper layer using QAPI.
> The upper layer is supposed to take according decisions concerning
> CPU provisioning.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

