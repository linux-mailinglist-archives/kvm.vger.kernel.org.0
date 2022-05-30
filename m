Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04986537598
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 09:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbiE3Hk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 03:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiE3Hkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 03:40:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CAC12ABF;
        Mon, 30 May 2022 00:40:51 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U6Sg0Y016905;
        Mon, 30 May 2022 07:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8r2CwYpOMgTsUtXt8RgONrQEqvKpBTXOCl3fdoB2M4w=;
 b=qnpj1rTpn+xOuD4a+5nn8Rwl/MI/jWVHlWuCJMNDla2e/NkGBb8kFYEmsLord1GS9KfV
 xNaaxeUjVOEY9+B3NLYOOak0vagabm216mEBMCPorMrHfwhVUonbgGL5bOvk725o0GWB
 z57mpeVvXmrtojm04MRkxhk9RW3CAuG5xkSe6Hor5hFtNRPuTizFOVWW0l/QyfFqksBl
 E6pO1l3woFt8d/8Yh9ZitvmSRZ9oWQwvrBIua3mKeguooHfNHGkaa65aFzAivKcB13FK
 VyPCPnmQjYtA8ucJuUObNKzVFEt/ZOtFjEEhB7fQnZcoN8J3dqX9bTa62VWF64e+SQ0/ 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcrpk176v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 07:40:50 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24U70Koi011098;
        Mon, 30 May 2022 07:40:50 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcrpk176f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 07:40:50 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24U7ZjwB030763;
        Mon, 30 May 2022 07:40:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3gbcb7hqsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 07:40:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24U7dg5127656618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 07:39:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91DE24C050;
        Mon, 30 May 2022 07:40:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22D1A4C040;
        Mon, 30 May 2022 07:40:44 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.70.209])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 07:40:44 +0000 (GMT)
Message-ID: <4aa518425958496e763294023ac950837ff8eac3.camel@linux.ibm.com>
Subject: Re: [PATCH v10 04/19] KVM: s390: pv: refactor s390_reset_acc
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, mimu@linux.ibm.com
Date:   Mon, 30 May 2022 09:40:43 +0200
In-Reply-To: <20220516181134.40652725@p-imbrenda>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
         <20220414080311.1084834-5-imbrenda@linux.ibm.com>
         <6948806da404fd5822b59fd65b8a5a948e6bb317.camel@linux.ibm.com>
         <20220516181134.40652725@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ovCfyO7LVXQieE6aqI2NnbOLW3WGLw6I
X-Proofpoint-ORIG-GUID: RxVfgpQ9wcqWSTUYhS54bjpzwGVgvkKK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_02,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=855 bulkscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-05-16 at 18:11 +0200, Claudio Imbrenda wrote:
[...]
> > [...]
> > > diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> > > index e8904cb9dc38..a3a1f90f6ec1 100644
> > > --- a/arch/s390/mm/gmap.c
> > > +++ b/arch/s390/mm/gmap.c
> > > @@ -2676,44 +2676,81 @@ void s390_reset_cmma(struct mm_struct
> > > *mm)
> > > =C2=A0}
> > > =C2=A0EXPORT_SYMBOL_GPL(s390_reset_cmma);
> > > =C2=A0
> > > -/*
> > > - * make inaccessible pages accessible again
> > > - */
> > > -static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 unsigned long next, struct mm_walk
> > > *walk)
> > > +#define DESTROY_LOOP_THRESHOLD 32=C2=A0=20
> >=20
> > maybe GATHER_NUM_PAGE_REFS_TO_TAKE?
>=20
> what about GATHER_GET_PAGES ?

Yes, that's good as well.

