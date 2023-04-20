Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989C86E9963
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 18:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbjDTQUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 12:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjDTQUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 12:20:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD983A96;
        Thu, 20 Apr 2023 09:20:47 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33KFrrsc004493;
        Thu, 20 Apr 2023 16:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=dtgeyGA4/k7IrUduP0NGemCiFBjzrfQF1pDPIM/11j4=;
 b=cGFUOWF+Vkr7/YBnpaXCAhe1QpzchpZCfeYcnVSf4K9AERxVjptfjYux6GXIE3JBumeh
 RShFPrL5j1ZUsyPYZnwcOn4D+h7NSBnR3mDH5+14CoIocaebYk7JQ8EvLemMFdVRTs4m
 AJp7w9CQPFiKk5bFYw01fcWtHs5m9hoYMKDd6I9HfFs5ZC55BnWyOxU3G/H0uEkdgl2Q
 5vAvu2HFD/qkcP3YOn7aM9wDa/oJ27tbMU78vnP54DhHCIh2JmijI6IqTvzxTjfgdCac
 kvrsEY4/SU1FCr/Vn2Ik3fafCijeJtwFOJ4289YH4UaL9ksHS8H4fLGlO1ug+oUOjxce Kg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q38em16kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 16:20:47 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33K2ET60008355;
        Thu, 20 Apr 2023 16:15:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3pykj6jwr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 16:15:43 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33KGFbPU57672014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 16:15:37 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97F0D20043;
        Thu, 20 Apr 2023 16:15:37 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F41220040;
        Thu, 20 Apr 2023 16:15:37 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.54.241])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 20 Apr 2023 16:15:36 +0000 (GMT)
From:   "Marc Hartmayer" <mhartmay@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, kvm390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] KVM: s390: pv: fix asynchronous teardown for
 small VMs
In-Reply-To: <20230420160149.51728-1-imbrenda@linux.ibm.com>
References: <20230420160149.51728-1-imbrenda@linux.ibm.com>
Date:   Thu, 20 Apr 2023 18:15:36 +0200
Message-ID: <87a5z2ttqv.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lhePkqVCD88InmRSs3OyI4xqfrK-3Du4
X-Proofpoint-ORIG-GUID: lhePkqVCD88InmRSs3OyI4xqfrK-3Du4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_12,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304200132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Claudio Imbrenda <imbrenda@linux.ibm.com> writes:

> On machines without the Destroy Secure Configuration Fast UVC, the
> topmost level of page tables is set aside and freed asynchronously
> as last step of the asynchronous teardown.
>
> Each gmap has a host_to_guest radix tree mapping host (userspace)
> addresses (with 1M granularity) to gmap segment table entries (pmds).
>
> If a guest is smaller than 2GB, the topmost level of page tables is the
> segment table (i.e. there are only 2 levels). Replacing it means that
> the pointers in the host_to_guest mapping would become stale and cause
> all kinds of nasty issues.
>
> This patch fixes the issue by synchronously destroying all guests with
> only 2 levels of page tables in kvm_s390_pv_set_aside. This will
> speed up the process and avoid the issue altogether.
>
> Update s390_replace_asce so it refuses to replace segment type ASCEs.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
> ---
>  arch/s390/kvm/pv.c  | 35 ++++++++++++++++++++---------------
>  arch/s390/mm/gmap.c |  7 +++++++
>  2 files changed, 27 insertions(+), 15 deletions(-)
>
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index e032ebbf51b9..ceb8cb628d62 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -39,6 +39,7 @@ struct pv_vm_to_be_destroyed {
>  	u64 handle;
>  	void *stor_var;
>  	unsigned long stor_base;
> +	bool small;

I would rather use a more verbose variable name (maybe =E2=80=98lower_2g=E2=
=80=98
accordingly to the `kvm_s390_destroy_lower_2g` function name or even
better something indicating the actual implications).

At least, I would add a comment what =E2=80=98small=E2=80=98 means and the =
implications
of it.

[=E2=80=A6snip]

