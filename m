Return-Path: <kvm+bounces-53852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 01486B187E9
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 21:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FD9F1AA385F
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 19:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F31228D8C7;
	Fri,  1 Aug 2025 19:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="F0HMak6z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD0E6F53E
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 19:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754078352; cv=none; b=ZffSZAsSY+OngRmBRRLB0g9MGkHaTHOPV6XkqpUO4nfel/gnGogoiMdjNzMzn1d9te5oaivjdr9YrAPD7HtOWKq4ukyB/delf1JQOBrYy9moRIPX1WNHzvdfuFJhylk8x2kMfr8D2THGK1v/4gavkvQV3gIIeOJp3bGr/mhAzCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754078352; c=relaxed/simple;
	bh=qQDPBYpTKtjZAvUgkS6YEnyxF+oCioRSoLiXTFwQ3H0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYylOJQcDwyXdbX3htBBD71cmfrOue+54i8l/RXMcpAXut0uEjrFSg4l73l/Wyyuvi0bNjPzkS0HQqxDYw9rjwZETgBg9MMMhITe4Yj0jarUN6OLHbJsrk+sLvoMuW6vV5QxaJsvrb/opsoijuEm2ZHB15rX2mmol/5YKgdfJNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=F0HMak6z; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 571Jn8h0009620
	for <kvm@vger.kernel.org>; Fri, 1 Aug 2025 12:59:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=BU1cxiUGdi+AyNrYPU4S
	Daom2YUAeQkF9Gt6mdofMQg=; b=F0HMak6zeCC+6+/IKyU+U6Tet1Q1EFLvVLIM
	7d2ftnDFL3CYH82FZGqaqNmjshs7o0y2Q96GDQodJlWCQ8LbOuUqWOHIMOmGL7CO
	RXR5Rq3mwI0GHWIpYQ08D+/4fC6/7mTZNxGTP2NA29PxCl+0kjZWiRqcZbBOpd2O
	aGdDqfekjjSBkbGEPFXVnfctVHgyT+NaH1ndIGe8+iu7hgfaPK1ffgoEa6EMDNX4
	jT42op6UU7DcvzO2PHwmVVTkrumsmZnILov+Aoj4aRq37YPN8nYs0SH3o6BCseFt
	Gp4hAE5L+/ACxQ03U1z6k4bV/LhwLBzlBFtRVpaN+20I6IYGKg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 488rmrvbaw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 12:59:09 -0700 (PDT)
Received: from twshared52133.15.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.17; Fri, 1 Aug 2025 19:59:09 +0000
Received: by devgpu013.nha3.facebook.com (Postfix, from userid 199522)
	id 63B0149F1E1; Fri,  1 Aug 2025 12:58:55 -0700 (PDT)
Date: Fri, 1 Aug 2025 12:58:55 -0700
From: Alex Mastro <amastro@fb.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: <alex.williamson@redhat.com>, <kvm@vger.kernel.org>, <peterx@redhat.com>,
        <kbusch@kernel.org>
Subject: Re: [PATCH v2] vfio/pci: print vfio-device syspath to fdinfo
Message-ID: <aI0cf000fXWFlF9B@devgpu013.nha3.facebook.com>
References: <20250724-show-fdinfo-v2-1-2952115edc10@fb.com>
 <20250801144800.GA26511@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250801144800.GA26511@ziepe.ca>
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: fiU5MlWDLCBV74dXnbVgTrkfM7vHecpx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDE1OCBTYWx0ZWRfXxPVugvlru/yT d8bAxe+swSWKQwW0o9Tqb9eNZrGOg8ZcfLGEgMbuXfF4225BmjNDYHIdEr5l07IoLbG0Nx/eYuF eH89JrUlkxPLqqO0gw/Djx7p4iPKm9CHIFJC2ClTLsTzqLeAqUGzW8+jXTVzL0obFQ/jg0B3leQ
 agSqrF1kAQx37gFlL8CTerIBzpglWomQcWGjzFhIxsflcYrmC6ov/wV8qu1fGlqAV1D6htjiB5b 9ULHA+zbSNjdQbUoR3oA2rQCfJf9UPBIhWbHlc7+nNOnHh6sFYNuWgfMwgMJx4LH7pQ+HPwFr7u FnXqDFg+k4rPcm05ZK4oXczMPseB8sG6LONQpb/kT0Vtq51ICtswIl/owXAEJ1uy8XAQzBYhOfg
 8GV/aRjwkjXdJhDh3T1KrlllRD8auHV80eNJI3323/jYDp+wQRSzj1K+1CYaXImToViJmv6F
X-Authority-Analysis: v=2.4 cv=a+Iw9VSF c=1 sm=1 tr=0 ts=688d1c8e cx=c_pps a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=Pn7XcPFJ1egebTjzJtwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: fiU5MlWDLCBV74dXnbVgTrkfM7vHecpx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_06,2025-08-01_01,2025-03-28_01

On Fri, Aug 01, 2025 at 11:48:00AM -0300, Jason Gunthorpe wrote:
> ??
<...>
> vdev->pdev == core_vdev->dev 
<...>
> Every vfio parent device has a sysfs path.

Hi Jason, thanks for bearing with me. I lacked some fundamental understandings
here. This suggestion makes sense, and is simpler and more to the point. I'll
address this in v3, and also add the documentation for this new behavior to
proc.rst.

