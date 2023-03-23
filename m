Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5BE6C695E
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 14:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjCWNTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 09:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjCWNTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 09:19:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29F09EEB
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 06:19:52 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NCoXbf024858
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:19:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=WLB6tTIp9D3KRMT+Xcu0+aDe3pjUTAz58j8vBWypais=;
 b=GhL4wFRxHTTLeZJY2EXcyK1roFJ6S+QVHed3iOHZnRoOZ2lXDFz5b3v3QG4NkUgobefT
 9Yku8kKXprYxtfKdCEyvMPV7BDGHxuEOeTcsLX+qjSFPLMz/HNUioI7ReSsiZbmy+4Zv
 +fpU5FtaNl+q5pCtvH+p8CXJHZxXyKb0cppZq95DzdEIdjMdbHmUAG4nC3sSLD4o8TEU
 OOOHzaBOORxsPCM9Rz9B6Ybf4SjAjzkTn8JAwsBBDUt9u/Unl+/tVIR8T5vbUyfd1Yav
 /srXb6Tr4JqvvSUvoGuxYJkgwaS7wEoCH7YqbXw9j3+pJt1XwUm2fi/vuyRa0LdnoVV0 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmu7cch1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:19:51 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NCidNx016770
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:19:51 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmu7ccga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 13:19:51 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NCdN9W021620;
        Thu, 23 Mar 2023 13:19:49 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3pd4x6e8kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 13:19:49 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NDJjfo64225678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 13:19:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A5C620043;
        Thu, 23 Mar 2023 13:19:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BD7B20040;
        Thu, 23 Mar 2023 13:19:45 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.6.128])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 13:19:45 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230323103913.40720-8-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com> <20230323103913.40720-8-frankja@linux.ibm.com>
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 7/8] s390x: uv-host: Properly handle config creation errors
Message-ID: <167957758513.13757.3801977482458852875@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 23 Mar 2023 14:19:45 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3-xe6YLlXFrQ2lbDbsqL2Pam4rJYg4OQ
X-Proofpoint-GUID: 7TSwhbLgBqfczmMMZh4ag915ui5JfIKD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303230098
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-23 11:39:12)
[...]
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index d92571b5..b23d51c9 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -370,6 +370,38 @@ static void test_cpu_create(void)
>         report_prefix_pop();
>  }
> =20
> +/*
> + * If the first bit of the rc is set we need to destroy the
> + * configuration before testing other create config errors.
> + */
> +static void cgc_destroy_if_needed(struct uv_cb_cgc *uvcb)

Is there a reason why we can't make this a cgc_uv_call() function which per=
forms the uv_call and the cleanups if needed?

Mixing reports and cleanup activity feels a bit odd to me.

[...]
> +/* This function expects errors, not successes */

I am confused by this comment. What does it mean?

> +static bool cgc_check_data(struct uv_cb_cgc *uvcb, uint16_t rc_expected)

Rename to cgc_check_rc_and_handle?

> +{
> +       cgc_destroy_if_needed(uvcb);
> +       /*
> +        * We should only receive a handle when the rc is 1 or the
> +        * first bit is set.

Where is the code that checks for rc =3D=3D 1?

Ah OK, so that's what you mean with the comment above, this function only w=
orks if the UVC fails, right?

> +        */
> +       if (!(uvcb->header.rc & UVC_RC_DSTR_NEEDED_FLG) && uvcb->guest_ha=
ndle)
> +               return false;

It would be nicer if I got a proper report message that tells me that we go=
t a handle even though we shouldn't destroy.
