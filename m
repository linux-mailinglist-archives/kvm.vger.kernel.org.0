Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F5F652E4B
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 10:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbiLUJPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 04:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLUJPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 04:15:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E720B9E
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 01:15:00 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BL9E4eb019923
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 09:14:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : subject : cc : message-id : date; s=pp1;
 bh=2/+LAA9jgHKnmyoOLxGqx2PMjjKCuG5yc0JudfXSoC4=;
 b=gIBcfytm1pS2EjlnHUoOJETxEuWDQPG8Jr5YW8E4eq+AZNhCLc9BJOygFH5tGt9kuH7G
 miv9e+JTvzThY02WnBiPhxnk493qQugnVU8ElzyjlvmrlpNv6Xb38gUgSLFhF1jE8VkS
 VGvuM2rUvsMPbEwPUj68hov+GzwfQeBNaA3qF7+4kJtS1o3kHvHwd09ZO0uP+pxMEQcT
 69NKjqKLdruSrSUy2+d+v64qOQs2IZxHuiVu2lNCllmP3v7Y7pio4Jum1wfQqXmbScib
 7+cTxIrzA3MBiEbMgaMdJM3C6CRmaJ2GFZ1r2s0wDjK9k/9kFDgn8Yy3wWvoQj4esA+i DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkyb300nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 09:14:59 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BL9Ewam021863
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 09:14:58 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkyb300mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Dec 2022 09:14:58 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKJSfur020557;
        Wed, 21 Dec 2022 09:14:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yy59rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Dec 2022 09:14:56 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BL9ErK226149520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 09:14:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11E1E20040;
        Wed, 21 Dec 2022 09:14:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E57E520049;
        Wed, 21 Dec 2022 09:14:52 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.40.3])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Dec 2022 09:14:52 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <167161061144.28055.8565976183630294954@t14-nrb.local>
References: <20221220175508.57180-1-imbrenda@linux.ibm.com> <167161061144.28055.8565976183630294954@t14-nrb.local>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
Cc:     frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        thuth@redhat.com
Message-ID: <167161409237.28055.17477704571322735500@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Wed, 21 Dec 2022 10:14:52 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fHtzSauvD9h9MUNXzjXZOSIJCSeXdEiS
X-Proofpoint-GUID: Fb5_C7wTbZ7gEmaOAIzytkgxIq8rjtOb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_04,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=655 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2212210072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nico Boehr (2022-12-21 09:16:51)
> Quoting Claudio Imbrenda (2022-12-20 18:55:08)
> > A recent patch broke make standalone. The function find_word is not
> > available when running make standalone, replace it with a simple grep.
> >=20
> > Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>=20
> I am confused why find_word would not be available in standalone, since r=
un() in runtime.bash uses it quite a few times.
>=20
> Not that I mind the grep, but I fear more might be broken in standalone?
>=20
> Anyways, to get this fixed ASAP:
>=20
> Acked-by: Nico Boehr <nrb@linux.ibm.com>

OK, I get it now, find_word is not available during _build time_.

Please make this a:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
