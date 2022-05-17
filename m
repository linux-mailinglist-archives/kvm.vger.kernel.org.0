Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4F452A5BA
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349729AbiEQPLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349708AbiEQPLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:11:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67D83BF83;
        Tue, 17 May 2022 08:11:44 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HF7KkR016543;
        Tue, 17 May 2022 15:11:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Cu1bSHxpXmEYAuVuMDHUzrs2lNTuKf3OPQkm7p7CTX8=;
 b=ErFK0gn2oXKepMPam1jXXyvsNusO9mQYnbNGBij/f+fyi5whoohbHDEPetJlt2pqdeZ/
 t3r4Hq1Go9ejTIxxFOd4R/cmKtARgd3TRZz8UPTNB77D887bR2MclxaQzOWwqTTilkeB
 gHNEc7v+/damGY1e29IS9uG+QnKoYYCn7iY0s47dwUxeOHyg76ZcuMRufL5N/J5wSf9L
 vqweoSMaERp4t98Q34mGBSISByI8osGVxtQx25KanVqoQaNQn2feYj5laBc6ikxQtlpE
 rtL0Xlps3AOvepN6m6jVZjY8a5+Mnp6zQyMB4m4JMSckjGO3i1eASrvNd44eQVMGI3fi rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4dpmh33q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:11:44 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HF9h1O006562;
        Tue, 17 May 2022 15:11:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4dpmh327-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:11:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HF4MLc009351;
        Tue, 17 May 2022 15:11:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjcdu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:11:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HEvm9247317452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 14:57:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64855A404D;
        Tue, 17 May 2022 15:11:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14C3FA4040;
        Tue, 17 May 2022 15:11:38 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.56.72])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 15:11:38 +0000 (GMT)
Message-ID: <5a0a7d03e11c8c4e379ac1a7198a8d965812fd63.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/4] s390x: Test TEID values in
 storage key test
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 17 May 2022 17:11:37 +0200
In-Reply-To: <20220517154603.6c7b9af5@p-imbrenda>
References: <20220517115607.3252157-1-scgl@linux.ibm.com>
         <20220517115607.3252157-3-scgl@linux.ibm.com>
         <20220517154603.6c7b9af5@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LoDX32w-QyTfbMXI3sqXPX9N_yEGr27E
X-Proofpoint-ORIG-GUID: zj8A451-0p9TE1GYAAx9m4xQmq51u2CA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-17 at 15:46 +0200, Claudio Imbrenda wrote:
> On Tue, 17 May 2022 13:56:05 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
> > On a protection exception, test that the Translation-Exception
> > Identification (TEID) values are correct given the circumstances of the
> > particular test.
> > The meaning of the TEID values is dependent on the installed
> > suppression-on-protection facility.
> > 
> > Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> > ---
> >  lib/s390x/asm/facility.h | 21 ++++++++++++++
> >  lib/s390x/sclp.h         |  4 +++
> >  lib/s390x/sclp.c         |  2 ++
> >  s390x/skey.c             | 60 ++++++++++++++++++++++++++++++++++++----
> >  4 files changed, 81 insertions(+), 6 deletions(-)
> > 
[...]

> > +static void check_key_prot_exc(enum access access, enum protection prot)
> > +{
> > +	struct lowcore *lc = 0;
> > +	union teid teid;
> > +
> > +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> > +	report_prefix_push("TEID");
> > +	teid.val = lc->trans_exc_id;
> > +	switch (get_supp_on_prot_facility()) {
> > +	case SOP_NONE:
> > +	case SOP_BASIC:
> > +		break;
> > +	case SOP_ENHANCED_1:
> > +		if ((teid.val & (BIT(63 - 61))) == 0)
> 
> can you at least replace the hardcoded values with a macro or a const
> variable?

I'll see if maybe I can come up with a nice way to extend the teid, but
I'll use a const if not.
> 
> like:
> 
> 	const unsigned long esop_bit = BIT(63 - 61);
> 
> 	...
> 
> 		if (!(teid.val & esop_bit))
> 
> > +			report_pass("key-controlled protection");
> 
> actually, now that I think of it, aren't we expecting the bit to be
> zero? should that not be like this?
> 
> report (!(teid.val & esop_bit), ...);

Indeed.
> 
> > +		break;
> > +	case SOP_ENHANCED_2:
> > +		if ((teid.val & (BIT(63 - 56) | BIT(63 - 61))) == 0) {
> 
> const unsigned long esop2_bits = 0x8C;	/* bits 56, 60, and 61 */
> const unsigned long esop2_key_prot = BIT(63 - 60);
> 
> if ((teid.val & esop2_bits) == 0) {
> 	report_pass(...);
> 
> > +			report_pass("key-controlled protection");
> > +			if (teid.val & BIT(63 - 60)) {
> 
> } else if ((teid.val & esop2_bits) == esop_key_prot) {

010 binary also means key protection, so we should pass that test here,
too. The access code checking is an additional test, IMO.
> 
> > +				int access_code = teid.fetch << 1 | teid.store;
> > +
> > +				if (access_code == 2)
> > +					report((access & 2) && (prot & 2),
> > +					       "exception due to fetch");
> > +				if (access_code == 1)
> > +					report((access & 1) && (prot & 1),
> > +					       "exception due to store");
> > +				/* no relevant information if code is 0 or 3 */
> 
> here you should check for the access-exception-fetch/store-indi-
> cation facility, then you can check the access code

Oh, yes. By the way, can we get rid of magic numbers for facility
checking? Just defining an enum in lib/asm/facility.h and doing
test_facility(FCLTY_ACCESS_EXC_FETCH_STORE_INDICATION) would be an
improvement.
Well, I guess you'd end up with quite horribly long names, but at least
you have to review the values only once and not for every patch that
tests a facility. 
> 
> and at this point you should check for 0 explicitly (always pass) and 3
> (always fail)

I'm fine with passing 0, but I'm not so sure about 3.
The value is reserved, so the correct thing to do is to not attribute
*any* meaning to it. But kvm currently really should not set it either.
> > +			}
> > +		}
> 
> } else {
> 	/* not key protection */
> 	report_fail(...);
> }
> > +		break;
> > +	}
> > +	report_prefix_pop();
> > +}
> > +
[...]

