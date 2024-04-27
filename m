Return-Path: <kvm+bounces-16096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C583F8B43FE
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 05:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A84B0B22530
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 03:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8683C06B;
	Sat, 27 Apr 2024 03:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="grY/K7a5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EBB3A1B9
	for <kvm@vger.kernel.org>; Sat, 27 Apr 2024 03:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714189827; cv=none; b=ci/PhBh2YlyrvXQRk8So7WYRmVCPEe+Cdlmdgow4LkBAJbwWJ+4aocGUXZMMs3nBS4BqCAiidrRQl+rB+lCg45P/HOZGqkNMB6AXJAet8UP8Gxs1ATV9w4GRw9bax+EHm20dYGtziMXvL52nDpbToolsbeC0Xvr4H0ctMFfSVpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714189827; c=relaxed/simple;
	bh=KNU1QiM8gOCsHLqD+i8H1AAHupLbmEIoUsA2FIxkhD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HTeh+XZEvJn25DWbfkobHYZQhDY31up3x5qfNcHM8qn06me1/AsdOPzFTbhb3tMh0d9DYBbLVGHA+dRriq30uaPEgo21XxnyO8K4P369bs72Nws2XXpMR/ob6dqp8/2DYhLq6A2I57hmggPREdsc7BGDoufDaNgS4ffNG3SE8l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=grY/K7a5; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43R3j603032126
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 23:50:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=pps01;
 bh=yh5RHaspzgWGOt7DtuOYZKmxuDOcmHFLXAbL78TuTQs=;
 b=grY/K7a5GWyjCvNn+7RBzf8R0NqOmsEJSc4UuL0QBiD1wrhEQe/raRQjcePuODurJPzE
 DkaTLa6fKe2dFz4xSIE2F5LO44k5NRqdimpWp+WICe57pa8RJ4U3NNz3VBJZAVCiCveN
 Mk95BfVnkJffvFKtyle3gfoHVfvb7vsIlZu0sxBEBy+jkT0WI9rylHnehpd/e2yyZEuX
 PiEzhdQtH1ybLWmfEe/zhcEnvhWkKCe/AdWkXaYuK79IGdIgUXGPyxR1GmX4s5kj4ZmI
 HpGfreruD6tdD/zM++vFSthzlBbYIK0g39IMlGEpk1mrsssab5Gy7OFe9GOnQwzhgbqL Lg== 
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 3xm79yf59m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 23:50:24 -0400
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7d9c78cf68aso63448939f.3
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 20:50:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714189823; x=1714794623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yh5RHaspzgWGOt7DtuOYZKmxuDOcmHFLXAbL78TuTQs=;
        b=WS0wR9zH24gqesdxpyvraRx5uVpRBH2lx8RkdkyJLZltV/35aNY2V8VRoYEBXbI3qL
         VRcQ7tcN3nPO2nIWPxt6KYonvP2+vTuztQ+O4FBM+BNwh5ZQZIpq9SvBl8oEALvtleET
         LYcYNz0K/nTeDkJRU+MYI/0M8rn/+xe/wqXf2K7B8dydGMyWdMBaQkPs2+NpjeWCM5QR
         bVJSG133CldvUDtTo8WQrCUwBfNWUEdP5MsH2/z1ZplCu1h3uu8LdN0zme7krF67IttD
         PUWDGlIWORSiDTaF5A0IcGWTum3JlsELz4N5ySMlSGC7MmGLq271306Dn/2JfxCMCyco
         DMoQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8pmM/y/k5TcywO4N9tVeCNqv6NZnxyM5l1oyn/tzUW1dixQWKI8dM0Iy98XlOyyy3pptwG4Mqf45fPcv/lNmfuk5x
X-Gm-Message-State: AOJu0YwHNYxIwqCh12K5Z7upChmxWyeCoPfICgyCXtZinkfcN5iGwhhN
	55GsVXUqUhmOcoNH2BtXa9IgdbcDwgDxHTBP6X0xeJkix1rL070MjrNDKdYcpLpKujX6n2QLf4H
	yyW7d9IoKP9B33Z6OWLWHsMXjO8aWBiXgAvaX3oT8ltPmc0t9fOAegbHV9OG+rUxYInV5un5Wor
	HUmcj4xDZwQvcfiyQKkbgx
X-Received: by 2002:a05:6e02:1fe5:b0:369:f53b:6c2 with SMTP id dt5-20020a056e021fe500b00369f53b06c2mr5645129ilb.1.1714189823057;
        Fri, 26 Apr 2024 20:50:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcsUU18fQATWLc1xKstI34PwWrwVloBNqLHAGla1UT1Ssk8IonR9QNYAvWS1sekHiHTiaVzRYp+14lyb1h7hQ=
X-Received: by 2002:a05:6e02:1fe5:b0:369:f53b:6c2 with SMTP id
 dt5-20020a056e021fe500b00369f53b06c2mr5645123ilb.1.1714189822773; Fri, 26 Apr
 2024 20:50:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240423024933.80143-1-kele@cs.columbia.edu> <ZitI9x3P43U8iuz4@infradead.org>
In-Reply-To: <ZitI9x3P43U8iuz4@infradead.org>
From: Kele Huang <kele@cs.columbia.edu>
Date: Fri, 26 Apr 2024 23:50:11 -0400
Message-ID: <CAOfLF_+QSvAQa9PSV2goxiY28w6=Nxd4kYb+WKdxLBc0xrmNQw@mail.gmail.com>
Subject: Re: [1/1] KVM: restrict kvm_gfn_to_hva_cache_init() to only accept
 address ranges within one page
To: Christoph Hellwig <hch@infradead.org>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: sbAqbM4iyV0D6r_1cZUDBlFWL-47oKYW
X-Proofpoint-ORIG-GUID: sbAqbM4iyV0D6r_1cZUDBlFWL-47oKYW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-26_22,2024-04-26_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=10
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 bulkscore=10 spamscore=0 mlxlogscore=744 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404270025

On Fri, Apr 26, 2024 at 2:26=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:

>
> I don't really have enough knowledge to comment on the functionality,
> but this code structure is really odd to read.
>
> Try to handle error conditions with early returns first, please:
>
>         if (unlikely(nr_pages_needed !=3D 1))
>                 return -EINVAL;
>         return __kvm_gfn_to_hva_cache_init(slots, ghc, gpa, len);

Thanks for the tip!  This makes sense to me and I will take care of
this code structure.

