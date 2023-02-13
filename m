Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F603693F5C
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 09:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBMIMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 03:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBMIL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 03:11:58 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B23B113CE;
        Mon, 13 Feb 2023 00:11:55 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D7xeH7004132;
        Mon, 13 Feb 2023 08:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 in-reply-to : references : cc : from : subject : to : message-id : date :
 content-transfer-encoding : mime-version; s=pp1;
 bh=fsKxpmLqryfprG9oWaA6x8SPT89wB2WHtxxuVkRYcHo=;
 b=kcLs2o29JY7kOQ94kXnFjzKBFhcWq/jSzk9JyFPOgIumVVH94tyhJCv2KtyRfccm4j48
 ORtcw4WZsb3JvlYFYTLwLyr/2DBdRmKzVtR8S2vJUqRFR3L77zp47MCYLAh9u0/19Wm3
 A7DrnDBxnWsFlHjUDv1zIp+OVZBadlJLYuCHN0PMo7duteMZ1zQp+B8Bsp6ORl8//C1S
 yKCBUio7VIiJY2PMf5MNFFO7JYiM4p/IFshQn+km7hvTmF3WGnx4LT1awuPeRhxe65hv
 YCvwSm2LKGmMNgf9LMKpa93hkCltA6OY2bxI5YE1tk+kaSFIRuN+p9raE9HxoRxrzGGj dQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nqha288ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 08:11:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31CHqjof032710;
        Mon, 13 Feb 2023 08:11:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3np29fjcdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 08:11:52 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31D8BmAW48759062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 08:11:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5DD220049;
        Mon, 13 Feb 2023 08:11:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DC1720040;
        Mon, 13 Feb 2023 08:11:48 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.32.27])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Feb 2023 08:11:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20221005122050.60625-1-nrb@linux.ibm.com>
References: <20221005122050.60625-1-nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [v2] KVM: s390: pv: fix external interruption loop not always detected
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Message-ID: <167627590762.7662.2548443744874886411@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Mon, 13 Feb 2023 09:11:48 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OuGeyoJjYVMwi2QBOho3dq1QV2eYFaAM
X-Proofpoint-GUID: OuGeyoJjYVMwi2QBOho3dq1QV2eYFaAM
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_03,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 mlxscore=0 malwarescore=0
 phishscore=0 mlxlogscore=598 bulkscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nico Boehr (2022-10-05 14:20:50)
> To determine whether the guest has caused an external interruption loop
> upon code 20 (external interrupt) intercepts, the ext_new_psw needs to
> be inspected to see whether external interrupts are enabled.
>=20
> Under non-PV, ext_new_psw can simply be taken from guest lowcore. Under
> PV, KVM can only access the encrypted guest lowcore and hence the
> ext_new_psw must not be taken from guest lowcore.
>=20
> handle_external_interrupt() incorrectly did that and hence was not able
> to reliably tell whether an external interruption loop is happening or
> not. False negatives cause spurious failures of my kvm-unit-test
> for extint loops[1] under PV.
>=20
> Since code 20 is only caused under PV if and only if the guest's
> ext_new_psw is enabled for external interrupts, false positive detection
> of a external interruption loop can not happen.
>=20
> Fix this issue by instead looking at the guest PSW in the state
> description. Since the PSW swap for external interrupt is done by the
> ultravisor before the intercept is caused, this reliably tells whether
> the guest is enabled for external interrupts in the ext_new_psw.
>=20
> Also update the comments to explain better what is happening.
>=20
> [1] https://lore.kernel.org/kvm/20220812062151.1980937-4-nrb@linux.ibm.co=
m/

Polite Ping.
