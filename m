Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325276C684D
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 13:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCWM30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 08:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCWM3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 08:29:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26F83599
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 05:29:23 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NB0M4h029159
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 12:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=UGwkqqEmtcGve47bHiI48mlJn69UBrdu4wmw/sXCGGM=;
 b=JjfMW2FrQ1wDG05zEov66b+RFf5cu3wgjoiIL6Aunwdkc8yfhvENsnrEs0/pn6vYqGOQ
 Mst0jwScNlvzdOxQU9IQa1ypvBamfrIsWFZ2iDJ6jGXZjPkfNq7sAQ1otowk367MlcgI
 5uMtSveaMyDf0UC+9eFa24KJ5K0+nMeWZOj13CIEBGlnoDfiN1Jd/mikWnl+JWn5dzF8
 2HK2MMzlg3J0cW0IYpv6lsAt1R4DGlahO+yhgL9Zs3T3TR/qRRM8mtWtenXzpeoblxQI
 KrPlhD9oLXIAm3TYXmgTPN51ayqC7nldCso8jO9iJ3PUGHi7g/U2LZlEA/IJX1P4N7aL xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgk65nhuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 12:29:23 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NBbGFT027831
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 12:29:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgk65nhu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 12:29:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32N8PifG016519;
        Thu, 23 Mar 2023 12:29:21 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pd4x6fb1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 12:29:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NCTHlw43385352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 12:29:17 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50A082004D;
        Thu, 23 Mar 2023 12:29:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22B8F20043;
        Thu, 23 Mar 2023 12:29:17 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.6.128])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 12:29:17 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230323103913.40720-2-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com> <20230323103913.40720-2-frankja@linux.ibm.com>
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/8] s390x: uv-host: Fix UV init test memory allocation
Message-ID: <167957455680.13757.15542563577684808380@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 23 Mar 2023 13:29:16 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vo_PvimXi4IMxVNgxfBU-oLXy7zJqpXB
X-Proofpoint-GUID: 71hrd8aUY6adIrSBZIFuWog-rIM4_zt1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230091
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-23 11:39:06)
> The init memory has to be above 2G and 1M aligned but we're currently
> aligning on 2G which means the allocations need a lot of unused
> memory.
>=20
> Let's fix that.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/uv-host.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 33e6eec6..68de47e7 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -555,7 +555,7 @@ static void test_init(void)
>         rc =3D uv_call(0, (uint64_t)&uvcb_init);
>         report(rc =3D=3D 0 && uvcb_init.header.rc =3D=3D UVC_RC_EXECUTED,=
 "successful");
> =20
> -       mem =3D (uint64_t)memalign(1UL << 31, uvcb_qui.uv_base_stor_len);
> +       mem =3D (uint64_t)memalign_pages_flags(HPAGE_SIZE, uvcb_qui.uv_ba=
se_stor_len, AREA_NORMAL);
>         rc =3D uv_call(0, (uint64_t)&uvcb_init);
>         report(rc =3D=3D 1 && uvcb_init.header.rc =3D=3D 0x101, "double i=
nit");
>         free((void *)mem);

Your fix looks reasonable, but I think this is still broken, no?

We allocate a new mem, initalize the ultravisor again and then free the mem=
ory. We do absolutely nothing with the allocated memory, do we?

Are we maybe missing a
  uvcb_init.stor_origin =3D mem;
here?

Also, a comment stating that AREA_NORMAL starts at PFN 524288 (2G) might be=
 nice.
