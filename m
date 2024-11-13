Return-Path: <kvm+bounces-31792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC0D9C7B5D
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 19:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D40531F22EFA
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 18:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9382038B1;
	Wed, 13 Nov 2024 18:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MLyQZjpH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02A5167D83
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 18:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731523182; cv=none; b=LSjheRKvc3vf8Bvc9kBi9JfvvrM40kPB51BbUctAGOmDr2UKICZrsbXFAS3U3eKYJEha5xpCuDPWjbaZOBwhYFJAzQVma5Tl5Pd7wZRBX4hsD5ZQ4beStFR5qXYi6yS5AJ59JTWWSR+XFT3ny5C6PvH8NLG+85wKX1wVSgRNfqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731523182; c=relaxed/simple;
	bh=9NGGxQ16BK45p9VSBjrrYc8rcurik7f9vC7s3z+C5ZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kc4Ja2EHCdHN14zoKBwL1xDuNXN0RDZ2fJ6I+XiUhI8+0I/TetZh7vjJIv04qNMWAngW1t2V/mr0/SfoHpQqY5a748H5OGaJdbkG4UBRrCo0376rLU7YRhl/rPJfVJWWox9S8UwL9gbyw6DWXZ+CDusHeUIazoDKLnJ84NzvVPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MLyQZjpH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731523179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9NGGxQ16BK45p9VSBjrrYc8rcurik7f9vC7s3z+C5ZM=;
	b=MLyQZjpHC650//Rx/kPEd0/5aqiimJR8NZrctz4L0VJkZcJmV9uwpRyXgC/kkrD6T2RvUu
	pxT4ZzosTHNfN3Ly6yN9IDwnvitcQgb1SoXTd6QpL300QC0GNtx0aHrabQzH6MNHzqtvC6
	E3coEy7QL8Cmed7tMNFxh/hy6eaeMqk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-SL-FIqOXPFifirOGlLa8AQ-1; Wed, 13 Nov 2024 13:39:38 -0500
X-MC-Unique: SL-FIqOXPFifirOGlLa8AQ-1
X-Mimecast-MFC-AGG-ID: SL-FIqOXPFifirOGlLa8AQ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43159c07193so66553215e9.0
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 10:39:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731523177; x=1732127977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9NGGxQ16BK45p9VSBjrrYc8rcurik7f9vC7s3z+C5ZM=;
        b=Mt2zkMJL7WcGkt72+xn0ZtK2bLgxvpbjJ1bBlNxWP6dvY99oI2ZoZSvgjBJdXeVcb5
         hT1eXGrX3Cd0Zaihw1q2JuG4NJLiH+al547oAw4HdrMtqfP5BrQOcoiJBFEfHZ+zSIC8
         flA8rQ/tY2JrSo0Wsl14pUAMCbtaIih3uelJcu3laZnq4kk4spy6Vn+blEo2m69UdENV
         vycK03+tJYzGLqaSRoemfQ/tRpc8q/QaA5G2/9O/0Az8TvisDt/Pp8LHT1GOo4vvkzuL
         +vSdFUt8W5ZyGgb3L3KPNGm61igrG+qF/WJap3BtgIrUFGGO3Wk1SQC+iGlO8vqubZxH
         5+TQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKmHDTL1c5+xxjT6MtX/9TeuDv7VjH/XrYF8pDA2RNvrQMxW+hC8tB+kqAFut7wfCS9s8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv7kRe7qTSFDQImOLKNcCZQwwinN2WV9lk2c09+wP9+22EJCjX
	SyIzqtoD3oKgF1x4JXPb4IULNDkMkfnw0LbJrvxNGuZ3jxpJDel5k8wuvPqskQeogRI4lzCmb9c
	WULjOAW7sj/QcuYWtGvS/0+KMvevPORBodpb2h+IVNV8MYzINMIWrZRoJDrNYfbIRM4cSmZiEsz
	y9Ml3FycUmG59THvs1mVW0PUEN
X-Received: by 2002:a05:600c:34c8:b0:431:604d:b22 with SMTP id 5b1f17b1804b1-432b750acc4mr241633755e9.16.1731523177447;
        Wed, 13 Nov 2024 10:39:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQkTjNqFFxBwbztI3KElEWR8DIfZgx/lOwPE5mFGWXrnd/2X+JY85/TL2D9FlEeRFluu1DheNxmNl2Ho6uwNY=
X-Received: by 2002:a05:600c:34c8:b0:431:604d:b22 with SMTP id
 5b1f17b1804b1-432b750acc4mr241633555e9.16.1731523177089; Wed, 13 Nov 2024
 10:39:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241113144923.41225-1-phil@philjordan.eu> <b772f6e7-e506-4f87-98d1-5cbe59402b2b@redhat.com>
 <ed2246ca-3ede-918c-d18d-f47cf8758d8c@amd.com>
In-Reply-To: <ed2246ca-3ede-918c-d18d-f47cf8758d8c@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 13 Nov 2024 19:39:25 +0100
Message-ID: <CABgObfYhQDmjh4MJOaqeAv0=cFUR=iaoLeSoGYh9iMnjDKM2aA@mail.gmail.com>
Subject: Re: [PATCH] i386/kvm: Fix kvm_enable_x2apic link error in non-KVM builds
To: "Shukla, Santosh" <santosh.shukla@amd.com>
Cc: Phil Dennis-Jordan <phil@philjordan.eu>, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	mtosatti@redhat.com, suravee.suthikulpanit@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2024 at 7:25=E2=80=AFPM Shukla, Santosh <santosh.shukla@amd=
.com> wrote:
> Same proposed at https://lore.kernel.org/qemu-devel/cebca38a-5896-e2a5-8a=
68-5edad5dc9d8c@amd.com/
> and I think Phil confirmed that it works.

Thanks Santosh, can you post it with commit message and everything?

Paolo


