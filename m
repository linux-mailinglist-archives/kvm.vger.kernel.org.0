Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72E740B553
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhINQyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:54:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhINQyC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:54:02 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18EF0KiW022418;
        Tue, 14 Sep 2021 12:52:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4ESj+6KO+3A52gu6PVxC6TdHhPGQbw6bZ5a83zR1ryo=;
 b=lsY60wx+OPDiz7z8/9hDwBiQ8wCliOYP6Vpu1Tf42dZftvthcfAan+0O/CJ/oIDCfuJf
 CZQ5xTk+fv5QAqQcU6NoN9RVa+VPfBXJcXpZYVWmF8xo+5VZHYgDpsOdBIU1yaUD3GDz
 e0Rsy0dFGR+TqfD5MpwsJLQn4oKHiAqg+/pLlCbfKnrXAfnSumqhEBChjjLFIjMxjdaP
 itAKQmFHTzPWNOoK96+yMnOWDiZlYkQ5HQ+oXqPsAcS2DOInn/tRMRjrNSbZ/LQ1CAhT
 NS7T0YBxcOVEHdgb/0Mt2wIje0UFsHRzJUraDRhWzSpkJsmjOOyMrG+LijJJ9w9fScxM Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2x0gjty3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:52:43 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18EF1RL8026129;
        Tue, 14 Sep 2021 12:52:43 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2x0gjtxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:52:43 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18EGTSnT030129;
        Tue, 14 Sep 2021 16:52:40 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3b0m39xb5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 16:52:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18EGqa0b45678902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 16:52:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8822642042;
        Tue, 14 Sep 2021 16:52:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04F0642049;
        Tue, 14 Sep 2021 16:52:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.12])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 16:52:35 +0000 (GMT)
Date:   Tue, 14 Sep 2021 18:52:32 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: Re: [PATCH resend RFC 2/9] s390/gmap: don't unconditionally call
 pte_unmap_unlock() in __gmap_zap()
Message-ID: <20210914185232.3b86c7d3@p-imbrenda>
In-Reply-To: <20210909162248.14969-3-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
 <20210909162248.14969-3-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gh8oP10Yy3CcRrDUk05R5AEHlr7A2r90
X-Proofpoint-ORIG-GUID: nzLA_OHx0ymGw3_JXA9_iI_qv_jk5Cry
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Sep 2021 18:22:41 +0200
David Hildenbrand <david@redhat.com> wrote:

> ... otherwise we will try unlocking a spinlock that was never locked via a
> garbage pointer.
> 
> At the time we reach this code path, we usually successfully looked up
> a PGSTE already; however, evil user space could have manipulated the VMA
> layout in the meantime and triggered removal of the page table.
> 
> Fixes: 1e133ab296f3 ("s390/mm: split arch/s390/mm/pgtable.c")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/mm/gmap.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index b6b56cd4ca64..9023bf3ced89 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -690,9 +690,10 @@ void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
>  
>  		/* Get pointer to the page table entry */
>  		ptep = get_locked_pte(gmap->mm, vmaddr, &ptl);
> -		if (likely(ptep))
> +		if (likely(ptep)) {
>  			ptep_zap_unused(gmap->mm, vmaddr, ptep, 0);
> -		pte_unmap_unlock(ptep, ptl);
> +			pte_unmap_unlock(ptep, ptl);
> +		}
>  	}
>  }
>  EXPORT_SYMBOL_GPL(__gmap_zap);

