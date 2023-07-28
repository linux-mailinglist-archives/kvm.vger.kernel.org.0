Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC89E766529
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 09:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbjG1HU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 03:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbjG1HU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 03:20:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1207A268B
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 00:20:52 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36S78bUS030331
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 07:20:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : subject : to : cc : message-id : date; s=pp1;
 bh=zbW1kxB5xGfrzduZfU2s5JmaSPAxx0vdgH8rNwJneCI=;
 b=SVtUNfh5W+c5WY/hwc3O+XQA3myulHFFjhOqUEp4eqq93H85jRetRPC4psBnLXggCM6E
 Vsj85I6EtmrDHhxPit0Q01WvstYYurmXjD1nDOTil6bynxki+SYDL13kjPXFFdn+7htb
 1Axj8nwDg2p818+iLc3dI+Ioa0UJT07ZtE3D/4elLKMjfgQXp8N4Zjp95lPINiETiWRZ
 pld1+TNJoH5SgJaIhs/E/m0IFbexW9ptKFW3QY/s6qWYzyk/VioY0q6hSrETNuu4ibA/
 q5+lI4vGnzwbVz2J3pHNw1amO76IWXPkuIrYx+fCteDLcD63E7vMHPK8Z/V+2Iz5VjgR dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s487v9bu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 07:20:51 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36S7HTSh020442
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 07:20:50 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s487v9btw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 07:20:50 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36S7FdIY003634;
        Fri, 28 Jul 2023 07:20:50 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0txkkyc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 07:20:49 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36S7KlxO1114666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 07:20:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E533E20040;
        Fri, 28 Jul 2023 07:20:47 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 791EB20049;
        Fri, 28 Jul 2023 07:20:47 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.77.129])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jul 2023 07:20:47 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230725033937.277156-2-npiggin@gmail.com>
References: <20230725033937.277156-1-npiggin@gmail.com> <20230725033937.277156-2-npiggin@gmail.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] migration: Fix test harness hang on fifo
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Message-ID: <169052884609.15205.8053450658195913694@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 28 Jul 2023 09:20:46 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OPcetDqKKTfTwpN9Gcv1dk5Be6S7MIm8
X-Proofpoint-ORIG-GUID: U6WD9d0hYQFAiL0LKGlKtQ7-i9U3FZZ4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 bulkscore=0 mlxlogscore=581 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307280063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nicholas Piggin (2023-07-25 05:39:35)
> If the test fails before migration is complete, the input fifo for the
> destination machine is not written to and that can leave cat waiting
> for input.
>=20
> Clear that condition in the error handler so the harness doesn't hang
> in this case.
>=20
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
