Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0076C7E35
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjCXMmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbjCXMmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:42:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033341556C
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:42:08 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OBEXe4022118
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=wBXXZzRIuoOjzza/+1hndB+zKBj3LJNpcjnM+zK1qtA=;
 b=pNDWa5sH+i+JVnTZM8TEbJkcPrbVSUbBDDzWttT7yDbK+xyD5uEO7ltYemm5jZ32l+I1
 qvHw5DARBjHShbM7mNo9HQSfGMkJd0pMMnEnu+Yi85xVInw1cjqch4h82RZGenMeLbA8
 PMXZVmil7X0nSavhgl84fe/LB9yZL5v0vZ0glQos+Rm6b5VOxkk4WZMxCiFwFpYKyrXK
 +r3azLg3ZX9u6eNiL12PDt+F5iqcHK+z5vttSyNJl2Sf/QxbiuJV4RWUpYu6sOb3a4Id
 5Y80pRqkNQG82kYBn7oXRNlUzljEWShrQV5IJURryH1fhFZMx6Ln+hLNPUIqS9vI6TXJ bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgxsssrhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:42:07 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBsISQ015461
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:42:07 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgxsssrh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:42:07 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLatF7010797;
        Fri, 24 Mar 2023 12:42:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pgxua8u53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:42:05 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCg1wG16646682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:42:01 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AEB620043;
        Fri, 24 Mar 2023 12:42:01 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58B6820040;
        Fri, 24 Mar 2023 12:42:01 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.14.197])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:42:01 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230324121724.1627-9-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com> <20230324121724.1627-9-frankja@linux.ibm.com>
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 8/9] s390x: uv-host: Properly handle config creation errors
Message-ID: <167966172104.41638.6215057938642660953@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 24 Mar 2023 13:42:01 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WlL3OCHnom4u3o-vdYSRhR1GGkDG-j1V
X-Proofpoint-GUID: USt1PVlwa5DcVDMSWa9ITB41HD1qwvom
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=841 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240102
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-24 13:17:23)
> If the first bit is set on a error rc, the hypervisor will need to
> destroy the config before trying again. Let's properly handle those
> cases so we're not usign stale data.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
