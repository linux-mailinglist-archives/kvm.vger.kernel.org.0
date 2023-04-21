Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B576EA511
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjDUHkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjDUHkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:40:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089CC86A4;
        Fri, 21 Apr 2023 00:40:23 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L7YZ6Q002380;
        Fri, 21 Apr 2023 07:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=WFpAemugtiATB/tic7/Gve76ND1/HvTCsA+phNaOt+Y=;
 b=XO7enn+t4lx15eM+fOhJhN7QGHNc25TEH0uuZvqKS/BtLG+C8SZ3k4GKe3PUumokfmqZ
 5Tq0Yyz35M4B7L8Fa4wySkL2X/6KHysDSNmGR0V/2t5jWD0uZrfcl+eMigDrErt7RW39
 I+FxK0a+VDYvkdEmzSK4JNvJIOQg4sDPeGdtS/aZ9o2PnUPJRbCNjEyfNHNiqiyE21pe
 R8hfLE5vzZHMDbDz9L7wWVwcMgVut9ID+jkLyD+HO8muKxA9L/QpDSO7QEDhzt/T5dEl
 S7WP3FNy+tq7nCmgZY+LC7Va8JswuPs10lHVuEWWtDYBvuVD4U67hKWTmDsdtOe4PlTn qA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3p7b8121-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 07:40:19 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33L1o4qk015437;
        Fri, 21 Apr 2023 07:36:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3pykj6b7nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 07:36:12 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33L7Zx2P28443200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 07:35:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E7B620090;
        Fri, 21 Apr 2023 07:35:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C48A720092;
        Fri, 21 Apr 2023 07:35:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.7.117])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 21 Apr 2023 07:35:58 +0000 (GMT)
Date:   Fri, 21 Apr 2023 09:35:55 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     "Marc Hartmayer" <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com,
        kvm390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] KVM: s390: pv: fix asynchronous teardown for
 small VMs
Message-ID: <20230421093555.2eba4dd1@p-imbrenda>
In-Reply-To: <87a5z2ttqv.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
References: <20230420160149.51728-1-imbrenda@linux.ibm.com>
        <87a5z2ttqv.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xozANXYoIDC8T2lHBVgEPWdSm8N8pYxg
X-Proofpoint-ORIG-GUID: xozANXYoIDC8T2lHBVgEPWdSm8N8pYxg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_02,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 clxscore=1011 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Apr 2023 18:15:36 +0200
"Marc Hartmayer" <mhartmay@linux.ibm.com> wrote:

> Claudio Imbrenda <imbrenda@linux.ibm.com> writes:
>=20
> > On machines without the Destroy Secure Configuration Fast UVC, the
> > topmost level of page tables is set aside and freed asynchronously
> > as last step of the asynchronous teardown.
> >
> > Each gmap has a host_to_guest radix tree mapping host (userspace)
> > addresses (with 1M granularity) to gmap segment table entries (pmds).
> >
> > If a guest is smaller than 2GB, the topmost level of page tables is the
> > segment table (i.e. there are only 2 levels). Replacing it means that
> > the pointers in the host_to_guest mapping would become stale and cause
> > all kinds of nasty issues.
> >
> > This patch fixes the issue by synchronously destroying all guests with
> > only 2 levels of page tables in kvm_s390_pv_set_aside. This will
> > speed up the process and avoid the issue altogether.
> >
> > Update s390_replace_asce so it refuses to replace segment type ASCEs.
> >
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
> > ---
> >  arch/s390/kvm/pv.c  | 35 ++++++++++++++++++++---------------
> >  arch/s390/mm/gmap.c |  7 +++++++
> >  2 files changed, 27 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index e032ebbf51b9..ceb8cb628d62 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -39,6 +39,7 @@ struct pv_vm_to_be_destroyed {
> >  	u64 handle;
> >  	void *stor_var;
> >  	unsigned long stor_base;
> > +	bool small; =20
>=20
> I would rather use a more verbose variable name (maybe =E2=80=98lower_2g=
=E2=80=98

lower_2g would mean that there is more above 2g, but in this case the VM
is smaller than 2g (which is the whole point)

> accordingly to the `kvm_s390_destroy_lower_2g` function name or even
> better something indicating the actual implications).
>=20
> At least, I would add a comment what =E2=80=98small=E2=80=98 means and th=
e implications

I'll add a comment

> of it.
>=20
> [=E2=80=A6snip]
>=20

