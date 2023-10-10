Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1D87BF5FF
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442890AbjJJIf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442719AbjJJIfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7F297
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 01:35:19 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A8YEA8014149
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:35:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : to : cc : from : message-id : date; s=pp1;
 bh=OOjmVU41BxwbnjQAcly2AKSMaNN/72LCKeRVvvqFNbM=;
 b=AucAaLYU8OWTZmKkOZEy2G0OVXX9z3EHHuuRMDmsrs9j4KhOhBP3pB6U8lIMOyLPUuqK
 C+9mBfR8E+qGM5J4KfT9WVkvZGXhZDEDu5MGW8QL6KZtuDP9Ptc/GV5W3zqu99dq+6K4
 oNjavRhLUYh5LL18mpfUIv92cZ6+Cwt/BLS6TrhIJquJKJ8iCzMNCuNrpQyXrdeCbP4J
 1XWTmXm0QVJdSnwYN9y+6iF4aT7O8SNBIrPadwnwMcoy4AC+uef8noB/HRhFIa1JXSUM
 R/dXHmnFVO6Xe6rF6a2u4ldquSRNbuAV2DIVDA3ycjt+/DtyRlzYk6kJq60sIL5e4ghI Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn31w0bj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:35:18 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A8YokR018846
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:35:18 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn31w0bg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:35:18 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A6Zcmq023032;
        Tue, 10 Oct 2023 08:35:16 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkmc1ek8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:35:16 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A8ZDRM44630290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 08:35:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A19520040;
        Tue, 10 Oct 2023 08:35:13 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 690B120043;
        Tue, 10 Oct 2023 08:35:12 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.21.115])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 08:35:12 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231010073855.26319-3-frankja@linux.ibm.com>
References: <20231010073855.26319-1-frankja@linux.ibm.com> <20231010073855.26319-3-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] lib: s390x: sclp: Add compat handling for HMC ASCII consoles
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169692691109.15053.11870167586294044363@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 10 Oct 2023 10:35:11 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZSS-qBnYIofbh9DGSSRrxXYzIm22ErPg
X-Proofpoint-ORIG-GUID: WOHfmrf5AY8euu-3qK4zLEIl6N-uo7cp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0 spamscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-10-10 09:38:54)
[...]
> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> index 19c74e46..313be1e4 100644
> --- a/lib/s390x/sclp-console.c
> +++ b/lib/s390x/sclp-console.c
[...]
> +static bool lpar_ascii_compat;

This only toggles adding \r. So why not name it accordingly?
Something like:
  ascii_line_end_dos
or
  ascii_add_cr_line_end

>  static char lm_buff[120];
>  static unsigned char lm_buff_off;
>  static struct spinlock lm_buff_lock;
> @@ -97,14 +100,27 @@ static void sclp_print_ascii(const char *str)
>  {
>         int len =3D strlen(str);
>         WriteEventData *sccb =3D (void *)_sccb;
> +       char *str_dest =3D (char *)&sccb->msg;
> +       int i =3D 0;
> =20
>         sclp_mark_busy();
>         memset(sccb, 0, sizeof(*sccb));
> +
> +       for (; i < len; i++) {
> +               *str_dest =3D str[i];
> +               str_dest++;
> +               /* Add a \r to the \n for HMC ASCII console */
> +               if (str[i] =3D=3D '\n' && lpar_ascii_compat) {
> +                       *str_dest =3D '\r';
> +                       str_dest++;
> +               }
> +       }

Please don't hide the check inside the loop.
Do:
if (lpar_ascii_compat)
  // your loop
else
  memcpy()

Also, please add protection against overflowing sccb->msg (max 4088 bytes
if I looked it up right).

> +       len =3D (uintptr_t)str_dest - (uintptr_t)&sccb->msg;

And when you do the above, it should be easy to get rid of pointer
subtraction.

[...]
>  void sclp_console_setup(void)
>  {
> +       lpar_ascii_compat =3D detect_host_early() =3D=3D HOST_IS_LPAR;
> +
>         /* We send ASCII and line mode. */
>         sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_M=
ASK_MSG);
> +       /* Hard terminal reset to clear screen for HMC ASCII console */
> +       if (lpar_ascii_compat)
> +               sclp_print_ascii("\ec");

I have in the past cursed programs which clear the screen, but I can see
the advantage here. How do others feel about this?
