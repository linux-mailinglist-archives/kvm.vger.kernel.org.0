Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51DB543947
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 18:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245344AbiFHQkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 12:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240244AbiFHQkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 12:40:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E87622C2EC;
        Wed,  8 Jun 2022 09:40:42 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258FBdLr032608;
        Wed, 8 Jun 2022 16:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=EQdZ6SdAFQVF7NZKnxywfL2ol2y7+FlkIJ28zJGufqk=;
 b=oabyeIym9COHO30GckBBgGYZbjXO6dymQE7PwjYu1p4qLfkIW4Ij97Ey2AeuWW7RjAnN
 fv6bj/S4IfccrtbsFDSDbHqgfSdynYhYwi5Ortyz7i761FUO2OkPtgP2ki4pfiMCx3od
 3KuWXq1dfFgXzohfryXZtN3byjP6U2L1FR1jXTW/XnyxXgJfQiI6yzmMjp92VoNyJSHR
 8HJLR/sZKqqsLkd1KBsZdz8hGMFZSjAD2B3I6z8EUylnXcqjKnRSAhykFv1gLmM4r4hG
 cvuKdyG3pSizLmtzUOk0sPWS5R5EirTTwGfDd4O3hldg1COXetMBYQFfoWlXLbi/dxYu EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjx6p1w6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 16:40:41 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258GbhH3001164;
        Wed, 8 Jun 2022 16:40:41 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjx6p1w67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 16:40:41 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258GMKRo020301;
        Wed, 8 Jun 2022 16:40:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3gfxnhwqcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 16:40:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258GeIcb22741296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 16:40:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C20CD5204F;
        Wed,  8 Jun 2022 16:40:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8DFDD5204E;
        Wed,  8 Jun 2022 16:40:35 +0000 (GMT)
Date:   Wed, 8 Jun 2022 18:40:33 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Rework TEID decoding and
 usage
Message-ID: <20220608184033.6959c4e2@p-imbrenda>
In-Reply-To: <6ed956e7-81e0-cb09-85ea-383af9d4446e@linux.ibm.com>
References: <20220608133303.1532166-1-scgl@linux.ibm.com>
        <20220608133303.1532166-4-scgl@linux.ibm.com>
        <20220608160357.4fa94ecc@p-imbrenda>
        <6ed956e7-81e0-cb09-85ea-383af9d4446e@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vdfHZkq8LxajJBOfN9ub_pbT4tzlK4Pv
X-Proofpoint-GUID: sIy4jxiMAp6UfdseGe2owQbV9GkbPmMe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jun 2022 17:55:08 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On 6/8/22 16:03, Claudio Imbrenda wrote:
> > On Wed,  8 Jun 2022 15:33:03 +0200
> > Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> >   
> >> The translation-exception identification (TEID) contains information to
> >> identify the cause of certain program exceptions, including translation
> >> exceptions occurring during dynamic address translation, as well as
> >> protection exceptions.
> >> The meaning of fields in the TEID is complex, depending on the exception
> >> occurring and various potentially installed facilities.
> >>
> >> Rework the type describing the TEID, in order to ease decoding.
> >> Change the existing code interpreting the TEID and extend it to take the
> >> installed suppression-on-protection facility into account.
> >>
> >> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> >> ---
> >>  lib/s390x/asm/interrupt.h | 61 +++++++++++++++++++++++++++---------
> >>  lib/s390x/fault.h         | 30 +++++-------------
> >>  lib/s390x/fault.c         | 65 ++++++++++++++++++++++++++-------------
> >>  lib/s390x/interrupt.c     |  2 +-
> >>  s390x/edat.c              | 26 ++++++++++------
> >>  5 files changed, 115 insertions(+), 69 deletions(-)
> >>
> >> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> >> index d9ab0bd7..3ca6bf76 100644
> >> --- a/lib/s390x/asm/interrupt.h
> >> +++ b/lib/s390x/asm/interrupt.h
> >> @@ -20,23 +20,56 @@
> >>    
> 
> [...]
> 
> >>  
> >> +enum prot_code {
> >> +	PROT_KEY_LAP,
> >> +	PROT_DAT,
> >> +	PROT_KEY,
> >> +	PROT_ACC_LIST,
> >> +	PROT_LAP,
> >> +	PROT_IEP,  
> > 
> > add:
> > 	PROT_CODE_SIZE,	/* Must always be the last one */
> > 
> > [...]
> >   
> >> +	case SOP_ENHANCED_2: {
> >> +		static const char * const prot_str[] = {  
> > 
> > static const char * const prot_str[PROT_CODE_SIZE] = {
> > 
> > so you have the guarantee that this has the right size, and you will
> > get a compile error if a new value is added to the enum but not here  
> 
> Will I? It would just initialize missing elements with NULL, no?

hmm makes sense, somehow I was convinced you would at least get a
warning, probably a case of -ENOCOFFEE

in any case, if you add the "SIZE" element at the end (and especially
if you also move the array right after the enum) there should be no
issues to keep the two in sync.

even better, you can put a
_Static_assert(ARRAY_SIZE(prot_str) == PROT_CODE_SIZE);

> > 
> > and at this point I think it might make more sense to move this right
> > after the enum itself
> >   
> >> +			"KEY or LAP",
> >> +			"DAT",
> >> +			"KEY",
> >> +			"ACC",
> >> +			"LAP",
> >> +			"IEP",
> >> +		};
> >> +		int prot_code = teid_esop2_prot_code(teid);  
> > 
> > enum prot_code prot_code = teid_esop2_prot_code(teid)>   
> >>  
> >> -	if (prot_is_datp(teid)) {
> >> -		printf("Type: DAT\n");
> >> -		return;
> >> +		assert(0 <= prot_code && prot_code < ARRAY_SIZE(prot_str));  
> > 
> > then you can remove this assert ^
> >   
> >> +		printf("Type: %s\n", prot_str[prot_code]);
> >> +		}
> >>  	}
> >>  }
> >>    
> [...]

