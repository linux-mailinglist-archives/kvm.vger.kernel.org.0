Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9270363A74F
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 12:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiK1LoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 06:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiK1LoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 06:44:08 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EED130
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 03:44:07 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASBa22D008405
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 11:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : cc : to : subject : message-id : date; s=pp1;
 bh=N8wMsG3baAUxYesLiN7ZhRN6xQTV7S7ag1hz/AIEZQY=;
 b=BXxvKWfklQehSVa9qqBEg9B640tslhBDeG1wdPAKT69NarQtIjbRlIwl2SYe55/1fac+
 /zfFJyC+yTvThbwTkd0f9RlnRQZUNQdwdUBPewnNdiXdUehOY+Y4cnY2kE5D6pGrhWNR
 XEngdlbOaYy9qubiEbEIJiPmKqxrxxoGcQYToW7VCNxb8DEbUOE6LXOgcOuzcfl8RAun
 O1L5dLT57xjGZNOcHQyRbfdwFsYmgxBtmoNjew8bCdzTvI9Ch6ZMGVh5TCahAZnRqwwi
 Zf60L9GBJS/yqKK8Hr5FDSAxS9ME8U5WMpfQxuZikf4dDLPUW8K9e0sfEj6+RM/j3bA0 Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vfjp4dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 11:44:06 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ASAoOOt028546
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 11:44:06 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vfjp4d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 11:44:06 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASBb2HT021901;
        Mon, 28 Nov 2022 11:44:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3m3a2hsrqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 11:44:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASBbZWJ64356802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 11:37:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A1664C046;
        Mon, 28 Nov 2022 11:44:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFF404C044;
        Mon, 28 Nov 2022 11:44:00 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.62.74])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 11:44:00 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <2cc74b33-1b29-c77f-960f-e1c3b35ae47f@redhat.com>
References: <20221124134429.612467-1-nrb@linux.ibm.com> <20221124134429.612467-2-nrb@linux.ibm.com> <2cc74b33-1b29-c77f-960f-e1c3b35ae47f@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: add a library for CMM-related functions
Message-ID: <166963584015.7765.15181610555192773681@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Mon, 28 Nov 2022 12:44:00 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8KoAZwCiIsXNRlCJM2wIXIwwxR0-uvvJ
X-Proofpoint-GUID: fyekpDhAmX3aAlIGstl5qYQYFtRwMhqG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_09,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2022-11-25 14:45:53)
> On 24/11/2022 14.44, Nico Boehr wrote:
[...]
> > diff --git a/lib/s390x/cmm.c b/lib/s390x/cmm.c
> > new file mode 100644
> > index 000000000000..5da02fe628f9
[...]
> > +/*
> > + * Maps ESSA actions to states the page is allowed to be in after the
> > + * respective action was executed.
> > + */
> > +const int allowed_essa_state_masks[4] =3D {
>=20
> Could be declared as "static const int ...", I guess?

Yes, done.

> Apart from that nit:
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks.
