Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260B87BFB9A
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 14:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjJJMf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 08:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjJJMfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 08:35:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870C3B0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 05:35:51 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39ACOXT2027532
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 12:35:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : to : cc : from : message-id : date; s=pp1;
 bh=wPt9tgFp4deGDBcc9AC0NLXctSNMgzPHL8kH5IbS+AA=;
 b=Y62+6Y21U1BE+PnEmOT6D5nUgPzKr+bi5xqjqVWKoQICYUrl6Uar/EsVNtWXLukGtgLT
 e2TXtFa02rdASA86K2GMgapEYvnecOT1esdeNTxzmJMQD62HnIsM86T13wLgfY8MAUxe
 9zxlJE+IiBKee80PjAoPQtCvDdP8rWB3jJF9M6k2PNyuCDSSWfRmspZWIpSKnnPA2IUr
 6B4wJoJ81JmUdPn7e73lpS8mY25MkraV9lbqfG89721/A0v2cRkfZr7SMqBu9rPd8VaX
 0p7RdYLv/eaYqy/RddhKOAnb6p0GHpe41JCCIPk1ipcOCJEn1OYr6S5vYQgvwktPOXve JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn6kc0bpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 12:35:51 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ACPJjA031970
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 12:35:50 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn6kc0bpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 12:35:50 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39ACHdCJ023032;
        Tue, 10 Oct 2023 12:35:49 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkmc1fssq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 12:35:49 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39ACZlW620775588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 12:35:47 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1D2E20040;
        Tue, 10 Oct 2023 12:35:46 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4343020043;
        Tue, 10 Oct 2023 12:35:46 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.21.115])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 12:35:46 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <34fcf7ce-f3ac-4d38-b70e-ff626e5108a0@linux.ibm.com>
References: <20231010073855.26319-1-frankja@linux.ibm.com> <20231010073855.26319-3-frankja@linux.ibm.com> <169692691109.15053.11870167586294044363@t14-nrb> <34fcf7ce-f3ac-4d38-b70e-ff626e5108a0@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] lib: s390x: sclp: Add compat handling for HMC ASCII consoles
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169694134495.15053.12368806793833722005@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 10 Oct 2023 14:35:44 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MlYJfEqxE0M5zlB8piJxE9P-HF8o1dlE
X-Proofpoint-ORIG-GUID: wYA3b3zHlQSy6uW_Xgm4KVG2sOj-m-mI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_07,2023-10-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-10-10 10:57:24)
> On 10/10/23 10:35, Nico Boehr wrote:
> > Quoting Janosch Frank (2023-10-10 09:38:54)
> > [...]
> >> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> >> index 19c74e46..313be1e4 100644
> >> --- a/lib/s390x/sclp-console.c
> >> +++ b/lib/s390x/sclp-console.c
> > [...]
> >> +static bool lpar_ascii_compat;
> >=20
> > This only toggles adding \r. So why not name it accordingly?
>=20
> Because it also toggles clearing the screen

OK

[...]
> >> @@ -97,14 +100,27 @@ static void sclp_print_ascii(const char *str)
> >>   {
> >>          int len =3D strlen(str);
> >>          WriteEventData *sccb =3D (void *)_sccb;
> >> +       char *str_dest =3D (char *)&sccb->msg;
> >> +       int i =3D 0;
> >>  =20
> >>          sclp_mark_busy();
> >>          memset(sccb, 0, sizeof(*sccb));
> >> +
> >> +       for (; i < len; i++) {
> >> +               *str_dest =3D str[i];
> >> +               str_dest++;
> >> +               /* Add a \r to the \n for HMC ASCII console */
> >> +               if (str[i] =3D=3D '\n' && lpar_ascii_compat) {
> >> +                       *str_dest =3D '\r';
> >> +                       str_dest++;
> >> +               }
> >> +       }
> >=20
> > Please don't hide the check inside the loop.
> > Do:
> > if (lpar_ascii_compat)
> >    // your loop
> > else
> >    memcpy()
>=20
>=20
> I'd rather have a loop than to nest it inside an if.

I disagree, but it's not worth discussing too much over this.

> > Also, please add protection against overflowing sccb->msg (max 4088 byt=
es
> > if I looked it up right).
>=20
> I considered this but we already have a 2k length check before that

...which is not sufficient...

> and I'd like to see someone print ~2k in a single call.
>=20
> The question is if we want the complexity for something that we'll very=20
> likely never hit.

IMO we want it since it can lead to random memory corruption which can be
very hard to debug.

And I don't think it's complex since in the simplest case you could just go
with a strnlen() here. Better just truncate the string than to corrupt
random memory.
