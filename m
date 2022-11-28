Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E3C63A10C
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 07:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiK1GHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 01:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiK1GHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 01:07:37 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3A0307;
        Sun, 27 Nov 2022 22:07:32 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AS2CQOa025596;
        Mon, 28 Nov 2022 06:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=PjT+MfJJ3/eFkYXjY/kO+PmNcQCtw/hZMgnEnTpWVUE=;
 b=rVoKjTHNvMUd9wAIEHCBlfezLg4cZ+/3trV53cItcanTZvQtTOCg74DMaAn/QiwUGuTN
 FyeDH40Qn6gYFhn/rt2sydNwln95q4cq7Jkr2Ix8XIlcS91oFspQVivNMErBqtB+/X4n
 jAyXf43eXihjfu5H//104pImWPpXs33kAvKiNAG3yy+oFpQUe6VF8OlHYcBRc/OIAxL7
 7DT0NahkY2MMG5mMA+uKy9Vo5dlvC7LzcUdhr7MqL+fMR2cvkeG4mLTX3XwAClXvDFuE
 pf2ilMn74miCalpP2HwfpQqG5jxeTr1jXBcnKmcT3O2oFnPyJXw3sZsIjDv9W9vO1bA9 VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vnnxuv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 06:07:27 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AS5jegh001876;
        Mon, 28 Nov 2022 06:07:27 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vnnxuus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 06:07:27 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AS67PGj024064;
        Mon, 28 Nov 2022 06:07:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3m3ae9a0pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 06:07:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AS60vDe3408466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 06:00:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B4BD4203F;
        Mon, 28 Nov 2022 06:07:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFB3142042;
        Mon, 28 Nov 2022 06:07:21 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.84.206])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 28 Nov 2022 06:07:21 +0000 (GMT)
Date:   Mon, 28 Nov 2022 07:07:20 +0100
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Anshuman Khandual <anshuman.khandual@arm.com>
Cc:     linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/mm: Use pmd_pgtable_page() helper in
 __gmap_segment_gaddr()
Message-ID: <Y4IvaRNLmASfRJiZ@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20221125034502.1559986-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125034502.1559986-1-anshuman.khandual@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H_ZeDN8WWMpM6hhRfHv3uOHEfKUsSV0l
X-Proofpoint-GUID: YLYRH3nZvkEDWY5MrgI78-BPk0TOQjqi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0 clxscore=1011
 mlxlogscore=745 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022 at 09:15:02AM +0530, Anshuman Khandual wrote:

Hi Anshuman,

> In __gmap_segment_gaddr() pmd level page table page is being extracted from
> the pmd pointer, similar to pmd_pgtable_page() implementation. This reduces
> some redundancy by directly using pmd_pgtable_page() instead,  though first
> making it available.

[...]

> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 02d15c8dc92e..8947451ae021 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -336,12 +336,11 @@ static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
>  static unsigned long __gmap_segment_gaddr(unsigned long *entry)
>  {
>  	struct page *page;
> -	unsigned long offset, mask;
> +	unsigned long offset;
>  
>  	offset = (unsigned long) entry / sizeof(unsigned long);
>  	offset = (offset & (PTRS_PER_PMD - 1)) * PMD_SIZE;
> -	mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
> -	page = virt_to_page((void *)((unsigned long) entry & mask));
> +	page = pmd_pgtable_page((pmd_t *) entry);
>  	return page->index + offset;
>  }

Looks okay to me.

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e9e387caffac..5ead9e997510 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2403,7 +2403,7 @@ static inline void pgtable_pte_page_dtor(struct page *page)
>  
>  #if USE_SPLIT_PMD_PTLOCKS
>  
> -static struct page *pmd_pgtable_page(pmd_t *pmd)
> +static inline struct page *pmd_pgtable_page(pmd_t *pmd)
>  {
>  	unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
>  	return virt_to_page((void *)((unsigned long) pmd & mask));

This chunk does not appear to belong to this patch.

Thanks!
