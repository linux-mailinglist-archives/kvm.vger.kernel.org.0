Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F75A7EB6
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 15:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiHaN0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 09:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbiHaN0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 09:26:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF47ED0215
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 06:26:42 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VD1ZDP027488
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:26:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : subject : cc : to : message-id : date; s=pp1;
 bh=NJ8zZaP8Hx896Er+gAx+RS2RDqsgf1NgPrkcnPtWLPc=;
 b=ZT4K2PuuTvLsUiwEaamjVijBPoGu4MX61tHss9ZQo2gumeUhuFz6s0022YH9ohATnZ4q
 FgrrFYifsTbvs2xFhELUSFghukzPcjalHnRiCqSwYObi7vtOzUylqG2YBFLIiDefPkvt
 aKyHAiXoWPTlSSj1CPiFrtDnVQEGfDUmjfHrXGHMb9nS5Co4jcxFbnwqbBoSRqKrtgsg
 dxsERPi+BrHZLdWS9TsFFiFy6aKdwfW9kaz8PDEolsq2aeGpMyWEb8fC47A9uFgyOXSr
 myz3ybtXRWVHKTXpmeICH+iA+5llcfS1Oql/owe2RG/V7XnucIOOyiswuBtr6NC1JAJ0 TA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ja85ts3mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:26:42 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27VDPSlf010062
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:26:39 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3j7aw9bvjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:26:39 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27VDQarI37224844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Aug 2022 13:26:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5746B42042;
        Wed, 31 Aug 2022 13:26:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37E8C42041;
        Wed, 31 Aug 2022 13:26:36 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 31 Aug 2022 13:26:36 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220829075602.6611-2-nrb@linux.ibm.com>
References: <20220829075602.6611-1-nrb@linux.ibm.com> <20220829075602.6611-2-nrb@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [RFC PATCH v2 1/1] KVM: s390: pv: don't allow userspace to set the clock under PV
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com, Marc Hartmayer <mhartmay@linux.ibm.com>
To:     kvm@vger.kernel.org
Message-ID: <166195239599.44305.2713073327282944995@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 31 Aug 2022 15:26:35 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tSrrqBwZ7pHgK8tb69Lmte7IycdKeMnV
X-Proofpoint-ORIG-GUID: tSrrqBwZ7pHgK8tb69Lmte7IycdKeMnV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-31_07,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=618
 priorityscore=1501 spamscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1015
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nico Boehr (2022-08-29 09:56:02)
> When running under PV, the guest's TOD clock is under control of the
> ultravisor and the hypervisor isn't allowed to change it. Hence, don't
> allow userspace to change the guest's TOD clock by returning
> -EOPNOTSUPP.
>=20
> When userspace changes the guest's TOD clock, KVM updates its
> kvm.arch.epoch field and, in addition, the epoch field in all state
> descriptions of all VCPUs.
>=20
> But, under PV, the ultravisor will ignore the epoch field in the state
> description and simply overwrite it on next SIE exit with the actual
> guest epoch. This leads to KVM having an incorrect view of the guest's
> TOD clock: it has updated its internal kvm.arch.epoch field, but the
> ultravisor ignores the field in the state description.
>=20
> Whenever a guest is now waiting for a clock comparator, KVM will
> incorrectly calculate the time when the guest should wake up, possibly
> causing the guest to sleep for much longer than expected.
>=20
> With this change, kvm_s390_set_tod() will now take the kvm->lock to be
> able to call kvm_s390_pv_is_protected(). Since kvm_s390_set_tod_clock()
> also takes kvm->lock, use __kvm_s390_set_tod_clock() instead.
>=20
> Fixes: 0f3035047140 ("KVM: s390: protvirt: Do only reset registers that a=
re accessible")

I missed a=20

Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>

here. Sorry Marc.
