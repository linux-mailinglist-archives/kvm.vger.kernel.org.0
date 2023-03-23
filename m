Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE28F6C6906
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 14:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjCWNBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 09:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjCWNBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 09:01:11 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F3B31E2D
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 06:01:08 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NBUra3026376
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:01:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=VGhqfuCzr9cR22Ri6MlCGw+rcUHAMO4c+A75kzp8/OI=;
 b=mXGRkxSDHv13nVoFsXo2VuWApEspBBPlqRYsxeK1Qvz4vOCZCYOOEk34ccg3YSJ8VTTe
 QlXnpRuExdaJc2yMfN9rcZQDoyUJO9TTznWwh/e0hpT7QahjDj07T34mwcMc/g4Z3mAg
 x9YqcjVhgOdqSgfVjg2+kjLs8jQuK4+1w1+K7D8lxmKFo/TQByZ0kMF6+EfHFHqguSfo
 QK+uMuF8Z46/ieienPeYNGUpG0CUWyryrzq2mm7V9Fr/1y5AZWM9m56nZM4djDVal7ua
 91pt7h4Oly1W8zhrTeWaNYI1nITYx4gR1Dqv9bsVs9YIYlkFcyIhItzHzOd2UgyiXhGI nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmg6mans-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:01:07 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NApaqq009005
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:01:06 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmg6mams-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 13:01:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32N8Pihl016519;
        Thu, 23 Mar 2023 13:01:04 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pd4x6fc6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 13:01:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32ND11bU38142370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 13:01:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 075852004B;
        Thu, 23 Mar 2023 13:01:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D98DB20040;
        Thu, 23 Mar 2023 13:01:00 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.6.128])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 13:01:00 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230323103913.40720-7-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com> <20230323103913.40720-7-frankja@linux.ibm.com>
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 6/8] s390x: uv-host: Fix create guest variable storage prefix check
Message-ID: <167957646059.13757.6545237796999072562@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 23 Mar 2023 14:01:00 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YNwTB8FOU27IcKTP1eYWhrjH7Q_t8Wpi
X-Proofpoint-ORIG-GUID: PV-y4120fuhr-nHZmI8MoX_RdzsDVL1b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230094
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-23 11:39:11)
> We want more than one cpu and the rc is 10B, not 109.
                                                     ^
Code says 10e        --------------------------------|

>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/uv-host.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 42ea2a53..d92571b5 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -434,11 +434,15 @@ static void test_config_create(void)
>                "base storage origin contains lowcore");
>         uvcb_cgc.conf_base_stor_origin =3D tmp;
> =20
> -       if (smp_query_num_cpus() =3D=3D 1) {
> +       /*
> +        * Let's not make it too easy and use a second cpu to set a
> +        * non-zero prefix.
> +        */
> +       if (smp_query_num_cpus() > 1) {
>                 sigp_retry(1, SIGP_SET_PREFIX,
>                            uvcb_cgc.conf_var_stor_origin + PAGE_SIZE, NUL=
L);

While at it, this should be smp_sigp, no?

With the commit message fixup:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
