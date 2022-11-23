Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389A46365E7
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238191AbiKWQed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbiKWQe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:34:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7CF23BD7
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:34:25 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANGEcQs007378
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 16:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1nFydNPxAUxuoi8nXW9HQxvXCVdeEEwsWNrpw8v5lXE=;
 b=aeQ86lyzZrHODaOYuQh3L9onCbRm8mrGPZJ+nhJXy4yrYALjLXaTNiGfe5rMV0IaJpVv
 8kL15YM7oSxVj0vOqPPlJQFpZJZDHXtrSeYwY/+FZygIthjMcZiSSV9ka2myNOI7egFX
 E27+stcdDaAKIdxWo9ytK07FfXpFNXwBr79g5/lyq4CU+5PE1l1UUIUd/ku1gxVBiR56
 2BVavLWVby/VaNqxXcWzxVkLV3B2Pt783lzPqdwz9WL7kOUSqbVRqMHUXj2RILPVpQXu
 x4IZRjIJqB2BxAxmsZdj6GKYQgU1ByOzkjzj3Fvdzdn+z2yQfxo8uSH5yu2JOKmfCuSD Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1n2vksc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 16:34:24 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANGRvM0018186
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 16:34:24 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1n2vksb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 16:34:23 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ANGKh3Z013422;
        Wed, 23 Nov 2022 16:34:21 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3kxps8mv4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 16:34:21 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ANGYxoc6357314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 16:34:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A241AE04D;
        Wed, 23 Nov 2022 16:34:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFC71AE045;
        Wed, 23 Nov 2022 16:34:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 16:34:17 +0000 (GMT)
Date:   Wed, 23 Nov 2022 17:34:15 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x: add a library for
 CMM-related functions
Message-ID: <20221123173415.4454641e@p-imbrenda>
In-Reply-To: <166921997196.14080.2103781613814018050@t14-nrb.local>
References: <20221122161243.214814-1-nrb@linux.ibm.com>
        <20221122161243.214814-2-nrb@linux.ibm.com>
        <20221123131338.7c091974@p-imbrenda>
        <166921997196.14080.2103781613814018050@t14-nrb.local>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BFWCLy5xSgZmMjBQ0aBFiq_Hx4I6mqVI
X-Proofpoint-GUID: GPK7Vpq8ua36Ql5XuVkO0AvF19ZqsfoT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_09,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Nov 2022 17:12:52 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2022-11-23 13:13:38)
> > > diff --git a/lib/s390x/cmm.c b/lib/s390x/cmm.c
> > > new file mode 100644
> > > index 000000000000..9609cea68950  
> [...]
> > > +static inline unsigned long get_page_addr(uint8_t *pagebuf, int page_idx)  
> > 
> > I don't like the name of this function, but maybe you can just get rid
> > of it (see below)  
> 
> Didn't like repeating the cast with the address calculation every time, but your solution with the cast first is good too. Done.
> 
> [...]
> > > +/*
> > > + * Verify CMM page states on pagebuf.
> > > + * Page states must have been set by cmm_set_page_states on pagebuf before.
> > > + * page_count must be a multiple of 4.
> > > + *
> > > + * If page states match the expected result,
> > > + * will return true and result will be untouched. When a mismatch occurs, will
> > > + * return false and result will be filled with details on the first mismatch.
> > > + */
> > > +bool cmm_verify_page_states(uint8_t *pagebuf, int page_count, struct cmm_verify_result *result)
> > > +{
> > > +     int i, state_mask, actual_state;  
> > 
> > I think "expected_mask" would be a better name, and maybe call the
> > other one "actual_mask"  
> 
> Yes, makes perfect sense. Done.
> 
> > > +
> > > +     assert(page_count % 4 == 0);
> > > +
> > > +     for (i = 0; i < page_count; i++) {
> > > +             actual_state = essa(ESSA_GET_STATE, get_page_addr(pagebuf, i));  
> > 
> > addr + i * PAGE_SIZE (if we get rid of get_page_addr)
> >   
> > > +             /* extract the usage state in bits 60 and 61 */
> > > +             actual_state = (actual_state >> 2) & 0x3;  
> > 
> > actual_mask = BIT((actual_mask >> 2) & 3);  
> 
> Yes makes sense, I will also adjust the comment a bit.
> 
> [...]
> > > +void cmm_report_verify_fail(struct cmm_verify_result const *result)
> > > +{
> > > +     report_fail("page state mismatch: first page = %d, expected_mask = 0x%x, actual_mask = 0x%x", result->page_mismatch, result->expected_mask, result->actual_mask);  
> > 
> > it would be a good idea to also print the actual address where the
> > mismatch was found (with %p and (pagebuf + result->page_mismatch))  
> 
> pagebuf is not available here, I want to avoid adding another argument, so I'll add a new field for the address in cmm_verify_result.
> 
> > > diff --git a/lib/s390x/cmm.h b/lib/s390x/cmm.h
> > > new file mode 100644
> > > index 000000000000..56e188c78704  
> [...]
> > > +struct cmm_verify_result {
> > > +     int page_mismatch;
> > > +     int expected_mask;
> > > +     int actual_mask;
> > > +};  
> > 
> > I'm not too fond of this, I wonder if it's possible to just return the
> > struct (maybe make the masks chars, since they will be small)  
> 
> No real reason to optimize for size, but also no reason not to, so I just changed it.
> 
> > but I am not sure if the code will actually look better in the end  
> 
> I am not a fan of returning structs, but none of my arguments against it apply
> here, so I changed it. Will add a field verify_failed to cmm_verify_result. 

I'm not sure I follow, but I guess I'll see it in v2

just make sure the code is not uglier, otherwise it's pointless :)

> 
> This has the nice side effect that I don't have to do 
>   if(cmm_verify_page_states()) 
>     report_pass()
>   else
>     cmm_report_verify_fail()
> in every caller, but can just move this whole logic to a function.

