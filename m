Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD30652DCC
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 09:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbiLUISj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 03:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiLUISB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 03:18:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8B6220EA
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 00:17:00 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BL8BWKD015549
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 08:17:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : subject : cc : message-id : date; s=pp1;
 bh=nZ7Nu5zXlab0tDAOrqCOKqSlUKqy22rKMGJ5Jog4M1k=;
 b=bxyX5wCGbehE8zcKHlpEz0w4nzdM/UujZV5jerjJ5qpNfC29z3CRIccVTj/wLmhgvZFu
 dnMkUImE2GE26cU+YFVD9Ui5VFFNoVCHGd2S5UhNFbN9Q/E2VMuaY4eF5uTrEDpwWuNM
 w5PHawDiqHnGSAx3Z15zLmTLLkRQe+SuEy+tsyjLAN3Ri26RfMNWhPTmr9apTAlKNR6s
 a0vDdW+G/ni97TqgwPiVWsmdMTDEgqZKVVcIGCVsMNaRs/ji6A4DJRiV7vfn9y2q408D
 u5raqEyVgHcj30+naTjuZHnZwYU6QKFlMRH/r4Oqi+tGMWqfnPFnkuSzkpkgKP7h1WdO Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkxdv857m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 08:17:00 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BL8C533019024
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 08:16:59 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkxdv856p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Dec 2022 08:16:59 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKJtgHw025292;
        Wed, 21 Dec 2022 08:16:57 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mh6ywn734-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Dec 2022 08:16:57 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BL8GrgB46662124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 08:16:53 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACCB92004B;
        Wed, 21 Dec 2022 08:16:53 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BA2E20040;
        Wed, 21 Dec 2022 08:16:53 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.10.91])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Dec 2022 08:16:52 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221220175508.57180-1-imbrenda@linux.ibm.com>
References: <20221220175508.57180-1-imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
Cc:     frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        thuth@redhat.com
Message-ID: <167161061144.28055.8565976183630294954@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Wed, 21 Dec 2022 09:16:51 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: w4o9ce7l5kH_ytBIBJnHJ3cX3wQYvDlv
X-Proofpoint-ORIG-GUID: jj7JJfjGOzjNxoHXFlrFYk1s2GcfgG9D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_03,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=733 mlxscore=0
 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212210062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-12-20 18:55:08)
> A recent patch broke make standalone. The function find_word is not
> available when running make standalone, replace it with a simple grep.
>=20
> Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

I am confused why find_word would not be available in standalone, since run=
() in runtime.bash uses it quite a few times.

Not that I mind the grep, but I fear more might be broken in standalone?

Anyways, to get this fixed ASAP:

Acked-by: Nico Boehr <nrb@linux.ibm.com>
