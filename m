Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF62263A2AC
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiK1IT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiK1ITy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:19:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C267F13F80;
        Mon, 28 Nov 2022 00:18:59 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AS6KALw016693;
        Mon, 28 Nov 2022 08:18:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=3ZlcKzcq2aPY79XtwvYIcoDL334lDVsqNBpgbBmrhfk=;
 b=pzMxUbfcMiSvMv1RCRBoJ2pW463WWIhpBDGYZsCSQ0hFPNv28/czW9qK1jnTqWOhudaJ
 4SSzRlQUuXMmZKFnZgjfS/oEjRD+9WfEqu3YK8g8X4pKvfgtz8bF0dLqJkMR1voYXAmh
 Qj2R3E2g8Aqxxa1QttnSP29fDoXRkRP2H+onvBN6uOyNBGOesdLznXCOSwqgIDHDQU7/
 aKENWEWNO7KXwVCaXcuX3HpTq8Qg+MgkfvdPiF1oIaMmKSr0NHFSv8xfyfYEjv0JhZTZ
 gLQUinl301STIgMUloWWe+WNF662pyJRw4/MXSESy2tObH4AeHSxzRo4nysy6bkNzw36 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vmr9nmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 08:18:52 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AS89Edf014435;
        Mon, 28 Nov 2022 08:18:52 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vmr9nm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 08:18:52 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AS85BfP017431;
        Mon, 28 Nov 2022 08:18:49 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3m3ae9a5w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 08:18:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AS8IkHR37290388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 08:18:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C54E42042;
        Mon, 28 Nov 2022 08:18:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 098484203F;
        Mon, 28 Nov 2022 08:18:46 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.84.206])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 28 Nov 2022 08:18:45 +0000 (GMT)
Date:   Mon, 28 Nov 2022 09:18:44 +0100
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Anshuman Khandual <anshuman.khandual@arm.com>
Cc:     linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: Re: [PATCH] s390/mm: Use pmd_pgtable_page() helper in
 __gmap_segment_gaddr()
Message-ID: <Y4Ru5Cnz+yps7RST@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20221125034502.1559986-1-anshuman.khandual@arm.com>
 <Y4IvaRNLmASfRJiZ@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <d3bcb8e1-cbf0-e820-47cf-f455128c597a@arm.com>
 <Y4Rflp1Z48hp/OAb@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <28b976dd-3d12-3f2c-9b70-a5423255943e@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28b976dd-3d12-3f2c-9b70-a5423255943e@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i9QB9KPSkBca30NmWvQWdzvnptN-URJ3
X-Proofpoint-ORIG-GUID: UqlFqcRABGtMyGTgkQ6MDDEWT0tayKnL
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_06,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=586 impostorscore=0 mlxscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211280063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 01:13:45PM +0530, Anshuman Khandual wrote:
> >>>> index e9e387caffac..5ead9e997510 100644
> >>>> --- a/include/linux/mm.h
> >>>> +++ b/include/linux/mm.h
> >>>> @@ -2403,7 +2403,7 @@ static inline void pgtable_pte_page_dtor(struct page *page)
> >>>>  
> >>>>  #if USE_SPLIT_PMD_PTLOCKS
> >>>>  
> >>>> -static struct page *pmd_pgtable_page(pmd_t *pmd)
> >>>> +static inline struct page *pmd_pgtable_page(pmd_t *pmd)
> >>>>  {
> >>>>  	unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
> >>>>  	return virt_to_page((void *)((unsigned long) pmd & mask));
> >>>
> >>> This chunk does not appear to belong to this patch.
> >>
> >> Should not this helper be made a 'static inline' before using it else where ?
> > 
> > Probably yes, but it is not kvm s390-specific change.
> 
> Right, just that the s390 change here is the first instance where this helper
> is being used outside the header, hence kept them together.
> 
> > 
> > I guess, you wanted to make it together or as a follow-up to this one?
> > https://lore.kernel.org/all/20221124131641.1523772-1-anshuman.khandual@arm.com/
> > 
> Unless too much trouble, could we just keep it here as proposed.

For s390 part:

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>

Thanks!
