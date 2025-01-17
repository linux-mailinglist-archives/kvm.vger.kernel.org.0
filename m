Return-Path: <kvm+bounces-35881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C32AA15959
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:05:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEFF1188D12E
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 22:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49271B0411;
	Fri, 17 Jan 2025 22:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aKPy3Dm5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C781514EE
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 22:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737151524; cv=none; b=mHLg5p/v3bVq/opFi5xxnLWupz2EYM5glReuOkcwk1C9+2zzluv7ufcksM813vo7KUi4L0HUUkxF91paQu70oCS3MWXqWFqU7w0p+92miAR9ZPTWEafwhrxvjkp79flMMOeNs/yryO86gikhPhQI2HRkzfID+8WeQAvlU9FRH9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737151524; c=relaxed/simple;
	bh=pWWEkMtvtT/SQDohStnmEBJisNjdNNakk2Pb1ycp/w4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQHqz3JbOcX2h6Qv8SERlUGDn2xLY2ssRrwSRF0AJz2iZG6Fs7QpjhQXL5BiMIoXlKNArTRPynBYq6Mel0KT86fPVeQPt9sgVfwFUnBXepNgwZz2+wVOmETuaF7qXsjqM4rVsQ/zhmqyrJy4SS/kZkUCsI6eUjAbtf8Zp+lKTxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aKPy3Dm5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HFLGm2001545
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 22:05:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=JSLK34Lu3YRBCLGcytvmW0b3
	5pxC3UtVOnWaZ8x+bow=; b=aKPy3Dm5ouC+0mQnc+a+5z2phKxBp+BpMJ3Qt7Qt
	jPer4T9AyxYPNpWj9AYRr+he8QZMGUvmRIkhC1MXzXJxkSa+BSRV+VbJIfgLnT0s
	bddhrwTbqyamWg3GWpZiUCEHf/oy4CWxjWfEfw4q+bJCUhcUZXi3uZuCdKJe1JS8
	c82B2ENp4eL/6DbBTfy4QzR2H0V0hVgWlRsblRSuje5TK5R43R5K3qxy+MOpkOsE
	LGYDZiytEgrd9Lrc8T9EvPq/RlSUDlsYsfssj9i7sh5khdxEaXqJJ0vuGZhWcjLu
	67xJqQGis6JKy91qSaFmh/NZBpKG9mZ8RuMngPcCS0KlbA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 447ss10tdf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 22:05:18 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2178115051dso48713315ad.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 14:05:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737151517; x=1737756317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSLK34Lu3YRBCLGcytvmW0b35pxC3UtVOnWaZ8x+bow=;
        b=DDy2mEsYRIZRBxebCNkuZIlO79ysYKJxrNttSFbFBkopff/DbTOUZMqagx+Tp4fP4T
         NSv0ii45QPgvbg9fz1ZmHO2dxvh9LyEP60RdPm6vV1GyQcNwPpQqIAuRPxn/C3f4rmOX
         rqu31Ya/QNWPvOfcZ1Ejf+I3sInoYt14vk2KCrPgLJPxApTjFHvJFp3voXK4PgFi/F+d
         Hj8ZqsY+BOlgsF2dDZy2L69HM7pmUnhFO/OhUSjOFFuhN/V95aeE7VL/SmAMfSGWzLOl
         3sluZcNv2TEEJrX1kyFeXv+9s/0sovSn2EnqTGaYBsHyxmNUeKSd2/nN1rRQAth9QkvX
         ryuw==
X-Gm-Message-State: AOJu0YzPvJKnoAL+3+ZoLU6yaj294c07SK5liuawNCRIOjc46D+9tqNz
	nrOIEkUqLsYWNrLmKPHwTyh4cpj99VuOp0hdC8MNrt5vvEwDFUdqsYum+pVFQChIvVZd0DUIKrS
	E9oT8boD71ELZ7zxtpb1/nPzFsu/J+Td4zNB3qgjDG1smNQmuLqM=
X-Gm-Gg: ASbGncuS/Jg1x8aVWEfp7odsy8Tg53YPgYhXipsLtvMqLcDA0jxQqL0qRWKLxgCKI+a
	dJWJmdG4wdEUDIE7AAdkk8uD5LseYEmeui4ZVeOiLxjeLnWDwnn2XSMTApp/B8qbvqwCrjFQUQD
	oA+wtIg5oRJndtLVxtHg6KX0S0ztnoqgeBHorM/niJaf7ZwJqeOoaUhTHalB7Sj2KyMsyjcnswR
	9m5MK9GEVaVPogfqDf5x0L6TkwA8BpcDyTwE0FYqnnC/7M+1dXWMiiSYMIPT6YhvLLArd3sviuu
	xq5QI5yeWYtROResmCdiRl4XqSNmKnCQJYuRKta/Q4XTkUMYQQ==
X-Received: by 2002:a17:902:ea06:b0:216:45eb:5e4d with SMTP id d9443c01a7336-21c352c7921mr57027635ad.6.1737151517430;
        Fri, 17 Jan 2025 14:05:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHk7q6iHrRnd1nXp+s+RpidtLrv0uU4L62iDyixRYGuxhfV0N1Xq3R/zhpGVH2sq0L2lUGqQg==
X-Received: by 2002:a17:902:ea06:b0:216:45eb:5e4d with SMTP id d9443c01a7336-21c352c7921mr57027115ad.6.1737151516934;
        Fri, 17 Jan 2025 14:05:16 -0800 (PST)
Received: from hu-eberman-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d4042f8sm20582705ad.236.2025.01.17.14.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 14:05:16 -0800 (PST)
Date: Fri, 17 Jan 2025 14:05:13 -0800
From: Elliot Berman <elliot.berman@oss.qualcomm.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
        pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
        anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
        brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
        xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
        jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
        yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
        vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
        mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
        wei.w.wang@intel.com, liam.merwick@oracle.com,
        isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
        suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
        quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
        quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
        quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
        catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
        oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
        qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
        shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
        rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com,
        hughd@google.com, jthoughton@google.com
Subject: Re: [RFC PATCH v5 01/15] mm: Consolidate freeing of typed folios on
 final folio_put()
Message-ID: <20250117135917364-0800.eberman@hu-eberman-lv.qualcomm.com>
References: <20250117163001.2326672-1-tabba@google.com>
 <20250117163001.2326672-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117163001.2326672-2-tabba@google.com>
X-Proofpoint-ORIG-GUID: RuFfKVkllM3-Jl9nr5nX5JLO0dNuPtBs
X-Proofpoint-GUID: RuFfKVkllM3-Jl9nr5nX5JLO0dNuPtBs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 clxscore=1011 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 impostorscore=0 adultscore=0 phishscore=0 mlxlogscore=998
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170169

On Fri, Jan 17, 2025 at 04:29:47PM +0000, Fuad Tabba wrote:
> Some folio types, such as hugetlb, handle freeing their own
> folios. Moreover, guest_memfd will require being notified once a
> folio's reference count reaches 0 to facilitate shared to private
> folio conversion, without the folio actually being freed at that
> point.
> 
> As a first step towards that, this patch consolidates freeing
> folios that have a type. The first user is hugetlb folios. Later
> in this patch series, guest_memfd will become the second user of
> this.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/page-flags.h | 15 +++++++++++++++
>  mm/swap.c                  | 24 +++++++++++++++++++-----
>  2 files changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 691506bdf2c5..6615f2f59144 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -962,6 +962,21 @@ static inline bool page_has_type(const struct page *page)
>  	return page_mapcount_is_type(data_race(page->page_type));
>  }
>  
> +static inline int page_get_type(const struct page *page)
> +{
> +	return page->page_type >> 24;
> +}
> +
> +static inline bool folio_has_type(const struct folio *folio)
> +{
> +	return page_has_type(&folio->page);
> +}
> +
> +static inline int folio_get_type(const struct folio *folio)
> +{
> +	return page_get_type(&folio->page);
> +}
> +
>  #define FOLIO_TYPE_OPS(lname, fname)					\
>  static __always_inline bool folio_test_##fname(const struct folio *folio) \
>  {									\
> diff --git a/mm/swap.c b/mm/swap.c
> index 10decd9dffa1..6f01b56bce13 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -94,6 +94,20 @@ static void page_cache_release(struct folio *folio)
>  		unlock_page_lruvec_irqrestore(lruvec, flags);
>  }
>  
> +static void free_typed_folio(struct folio *folio)
> +{
> +	switch (folio_get_type(folio)) {

I think you need:

+#if IS_ENABLED(CONFIG_HUGETLBFS)
> +	case PGTY_hugetlb:
> +		free_huge_folio(folio);
> +		return;
+#endif

I think this worked before because folio_test_hugetlb was defined by:
FOLIO_TEST_FLAG_FALSE(hugetlb)
and evidently compiler optimizes out the free_huge_folio(folio) before
linking.

You'll probably want to do the same for the PGTY_guestmem in the later
patch!

> +	case PGTY_offline:
> +		/* Nothing to do, it's offline. */
> +		return;
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
>  void __folio_put(struct folio *folio)
>  {
>  	if (unlikely(folio_is_zone_device(folio))) {
> @@ -101,8 +115,8 @@ void __folio_put(struct folio *folio)
>  		return;
>  	}
>  
> -	if (folio_test_hugetlb(folio)) {
> -		free_huge_folio(folio);
> +	if (unlikely(folio_has_type(folio))) {
> +		free_typed_folio(folio);
>  		return;
>  	}
>  
> @@ -934,13 +948,13 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
>  		if (!folio_ref_sub_and_test(folio, nr_refs))
>  			continue;
>  
> -		/* hugetlb has its own memcg */
> -		if (folio_test_hugetlb(folio)) {
> +		if (unlikely(folio_has_type(folio))) {
> +			/* typed folios have their own memcg, if any */
>  			if (lruvec) {
>  				unlock_page_lruvec_irqrestore(lruvec, flags);
>  				lruvec = NULL;
>  			}
> -			free_huge_folio(folio);
> +			free_typed_folio(folio);
>  			continue;
>  		}
>  		folio_unqueue_deferred_split(folio);
> -- 
> 2.48.0.rc2.279.g1de40edade-goog
> 

