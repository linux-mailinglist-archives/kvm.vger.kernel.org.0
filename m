Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4086C6961
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 14:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjCWNV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 09:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWNV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 09:21:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5039EEB
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 06:21:55 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NCMdW5021717
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:21:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=NP+t4Z6r+31uC8P0A1EExOfb2WeSMAsyajo4CkReYZY=;
 b=FNBamzi+x47N+k4p8u5DzSotBRg5F0Devrfq6f+nJY8BV2tH3Ea9Z89JoqBDAqAwL+PR
 fMh/AbFK5SYTfu1u3FcMDAf6hx/hVSz3B5eK937hufNQHpnF1Zjo0IGbD/C9cBtMi4MD
 hTeMzVDD8T1RyDwdC/QSwhq2Dk3hrNlpY1aTi9qmBfFSF2I6Z/k5xkcw/7UEtjgo6+Sq
 OQMuTn2QinoOOMZCgimRkqjgto6JMJMOPoZ99BCiZRfVksRSjZPo2N2zQbAjC89esXKv
 0KxgtuT417XJs0i3H9y66Do0Qq9UUq3aODvc4RYkjW1+jXpzv3ptuWsSGPnNsSs0Jk81 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgj6wgmne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:21:54 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NBBB4J013737
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:21:54 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgj6wgmmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 13:21:54 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32N5IhbR008113;
        Thu, 23 Mar 2023 13:21:52 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3pd4x6e761-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 13:21:52 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NDLm1N30736922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 13:21:48 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADA5C2004B;
        Thu, 23 Mar 2023 13:21:48 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 906B520040;
        Thu, 23 Mar 2023 13:21:48 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.6.128])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 13:21:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230323103913.40720-9-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com> <20230323103913.40720-9-frankja@linux.ibm.com>
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 8/8] s390x: uv-host: Fence access checks when UV debug is enabled
Message-ID: <167957770833.13757.17159648074529530307@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 23 Mar 2023 14:21:48 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y6qyorN0zXRaNo97mmCusl-FIgkJ3n4g
X-Proofpoint-ORIG-GUID: 8Fho5oz61qOfTEhtz9X6S9su3b9GTdQO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230098
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-23 11:39:13)
> The debug print directly accesses the UV header which will result in a
> second accesses exception which will abort the test. Let's fence the
> access tests instead.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
