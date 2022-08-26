Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29995A26D2
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 13:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245272AbiHZLYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 07:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245290AbiHZLYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 07:24:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAF9DB058;
        Fri, 26 Aug 2022 04:24:19 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QAhXAk031610;
        Fri, 26 Aug 2022 11:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=yQwd7KDRVdN2b7PpLXmcOt2jDojVRGt7YZu8LCwonoc=;
 b=gkmCdkpWQWKnxsl21qPHjMBU9xkP0sLIxIeAF8b6j7bsn3jeE3icZFTrL9N2Q13gMtyR
 LUDPjG46M46Q1V/z1tbKrDv2EPJIqegOWhV6ctxsU0a+Zj/8v9abdQo3Z2+G4KA5mjGs
 4X3BuUYZOTEnyzVttrHa710TCZyWNKiSuERJK4mjWq6OAKaHlMcLkBdNxsUUefMOxgT3
 Zf2CLw/iRUj5KkEfe9eOdWkgcwlnFBcia0JDixsugu2KcJg1p0cM8u6KrOlAAI+K4BVD
 YjL0PBxcPHtGswsfaJSrukH43W9aaHMbE9LdiJP+daNtddaNly5G2Oal4BhDwhiF7kmX Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6vnyh0y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 11:24:12 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27QAiq9h003326;
        Fri, 26 Aug 2022 11:24:11 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6vnyh0xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 11:24:11 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27QBL276023574;
        Fri, 26 Aug 2022 11:23:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3j2q88wmfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 11:23:38 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27QBKUZl35062148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 11:20:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30166A4040;
        Fri, 26 Aug 2022 11:23:35 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7664A4053;
        Fri, 26 Aug 2022 11:23:34 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.7.23])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Aug 2022 11:23:34 +0000 (GMT)
Message-ID: <c7d094b7eb2d06449f8afe2d8486a0e853858483.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 1/2] s390x: Add specification
 exception test
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        qemu-s390x@nongnu.org
Date:   Fri, 26 Aug 2022 13:23:34 +0200
In-Reply-To: <1d0ef541-2b83-3c61-ec22-d5bf9a7698af@linux.ibm.com>
References: <20220720142526.29634-1-scgl@linux.ibm.com>
         <20220720142526.29634-2-scgl@linux.ibm.com>
         <1d0ef541-2b83-3c61-ec22-d5bf9a7698af@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Sav_9JksLanSp6JSqmswrJIsQLc9z9FW
X-Proofpoint-GUID: vXKjztPjmuGWE9MOfNQbbRw14zsep8R-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208260046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-24 at 11:35 +0200, Janosch Frank wrote:
> On 7/20/22 16:25, Janis Schoetterl-Glausch wrote:
> > Generate specification exceptions and check that they occur.
> > 
> > Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> > ---
> >   s390x/Makefile           |   1 +
> >   lib/s390x/asm/arch_def.h |   5 ++
> >   s390x/spec_ex.c          | 180 +++++++++++++++++++++++++++++++++++++++
> >   s390x/unittests.cfg      |   3 +
> >   4 files changed, 189 insertions(+)
> >   create mode 100644 s390x/spec_ex.c
> > 
> > 
> > +
> > +/*
> > + * Load possibly invalid psw, but setup fixup_psw before,
> > + * so that fixup_invalid_psw() can bring us back onto the right track.
> > + * Also acts as compiler barrier, -> none required in expect/check_invalid_psw
> > + */
> > +static void load_psw(struct psw psw)
> > +{
> > +	uint64_t scratch;
> > +

[...]

> /*
> Store a valid mask and the address of the nop into the fixup PSW.
> Then load the possibly invalid PSW.
> */

This seems a bit redundant given the function comment, but I can
drop a comment in here describing how the fixup psw is computed.

> 
> > +	fixup_psw.mask = extract_psw_mask();
> > +	asm volatile ( "larl	%[scratch],0f\n"
> > +		"	stg	%[scratch],%[addr]\n"
> > +		"	lpswe	%[psw]\n"
> > +		"0:	nop\n"
> > +		: [scratch] "=&d"(scratch),
> > +		  [addr] "=&T"(fixup_psw.addr)
> 
> s/addr/psw_addr/ ?
> 
> > +		: [psw] "Q"(psw)
> > +		: "cc", "memory"
> > +	);
> > +}
> > +
> > +static void load_short_psw(struct short_psw psw)
> > +{
> > +	uint64_t scratch;
> > +
> > +	fixup_psw.mask = extract_psw_mask();
> > +	asm volatile ( "larl	%[scratch],0f\n"
> > +		"	stg	%[scratch],%[addr]\n"
> > +		"	lpsw	%[psw]\n"
> > +		"0:	nop\n"
> > +		: [scratch] "=&d"(scratch),
> > +		  [addr] "=&T"(fixup_psw.addr)
> > +		: [psw] "Q"(psw)
> > +		: "cc", "memory"
> > +	);
> 
> Same story.

Do you want me to repeat the comments here or just rename addr?

[...]

> > +static int not_even(void)
> > +{
> > +	uint64_t quad[2] __attribute__((aligned(16))) = {0};
> > +
> > +	asm volatile (".insn	rxy,0xe3000000008f,%%r7,%[quad]" /* lpq %%r7,%[quad] */
> > +		      : : [quad] "T"(quad)
> 
> Is there a reason you never put a space after the constraint?

TBH I never noticed I'm unusual in that regard. I guess I tend to think
of the operand and constraint as one entity.
I'll add the spaces.

> 
> > +		      : "%r7", "%r8"
> > +	);
> > +	return 0;
> > +}
> > +

[...]
