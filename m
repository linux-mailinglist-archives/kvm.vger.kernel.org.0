Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D345379A2
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 13:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiE3LRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 07:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiE3LRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 07:17:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2CC2BFF;
        Mon, 30 May 2022 04:17:01 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U9hhWq012309;
        Mon, 30 May 2022 11:17:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=P9AVFZWf0HG36drg4odsdhvueQ9fVsxMlv3iuTAcDH8=;
 b=lU/ONV7vXcmpFyNn60Vl2GVk7hUd+M1fEVl6YB2ow2u9spcxAAszb7NDyCYkkdR8p7FZ
 8tQur4sCOHD1bGCPsx3/yOvrQsN8maoLMYXnhiOZdYMzQB62rFCL2cJSLFkgJu3bu0LS
 8TJ8rL8AC4q6Q3E+2sXvhiWmXWngNSANptWZpHiW4TMj4Pm1VuWdgux2524EJ0RyE0oM
 yZTwUHG+hmAy6kG6srctmZCai7QSdFfMb9eYliNGfwRl/3FaWoBHpZUPGvmLFNuY0x+5
 t6DmRDCDYxqB+Sf9r+oK1DOG7qqqlWBpP9iJ05k3ogLLbwo914Pr5IVkoInJum152AKt Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcuhw9jpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 11:17:00 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24UB9EqO012053;
        Mon, 30 May 2022 11:17:00 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcuhw9jpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 11:17:00 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24UB4cZf031661;
        Mon, 30 May 2022 11:16:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h2m8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 11:16:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24UBGtLU20775282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 11:16:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12BB2A405C;
        Mon, 30 May 2022 11:16:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D40EA4054;
        Mon, 30 May 2022 11:16:54 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.149])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 11:16:54 +0000 (GMT)
Date:   Mon, 30 May 2022 13:16:52 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v10 18/19] KVM: s390: pv: avoid export before import if
 possible
Message-ID: <20220530131652.4a0b0057@p-imbrenda>
In-Reply-To: <d76e875c360c53d6bd03c3f2767c90dcc4ca6df9.camel@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
        <20220414080311.1084834-19-imbrenda@linux.ibm.com>
        <d76e875c360c53d6bd03c3f2767c90dcc4ca6df9.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1EpXGJDaZm9b2eG_pQWvgVLYvfbeKl79
X-Proofpoint-GUID: IHiGLOAV--jpkv7lrNu626JPF5eRkpEX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 mlxscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2205300058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 May 2022 12:07:43 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Thu, 2022-04-14 at 10:03 +0200, Claudio Imbrenda wrote:
>=20
> > diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> > index e358b8bd864b..43393568f844 100644
> > --- a/arch/s390/kernel/uv.c
> > +++ b/arch/s390/kernel/uv.c
> > @@ -236,7 +236,8 @@ static int make_secure_pte(pte_t *ptep, unsigned
> > long addr,
> > =C2=A0
> > =C2=A0static bool should_export_before_import(struct uv_cb_header *uvcb,
> > struct mm_struct *mm)
> > =C2=A0{
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return uvcb->cmd !=3D UVC_CM=
D_UNPIN_PAGE_SHARED &&
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return !test_bit_inv(BIT_UV_=
FEAT_MISC,
> > &uv_info.uv_feature_indications) &&
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0uvcb->cmd !=3D UVC_CMD_UNPIN_PAGE_SHARED &&
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_read(&mm->context.protected_count) > 1; =
=20
>=20
> This might be nicer to read like this:
>=20
> if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications))
>   return false;
>=20
> if (uvcb->cmd =3D=3D UVC_CMD_UNPIN_PAGE_SHARED)
>   return false;
>=20
> return atomic_read(&mm->context.protected_count) > 1;

fair enough

then I'll also fix patch 6 in a similar way, the function is first
introduced there



