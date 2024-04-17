Return-Path: <kvm+bounces-15020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 034088A8E53
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:47:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94CC41F211A7
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 21:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E47012F398;
	Wed, 17 Apr 2024 21:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tl53NRU0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230FA47F7C
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 21:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390466; cv=none; b=klJDxQ8vNLjDvK8uYZk8MrV74GLZqAfEfXiIieUe4VmKauNb7B9ZnMqxJ946eyqhSrWgbRxwFuzdKe4q3Gaj8GDb8MfteteahYS7P/s31Tmp6NhoGV86XqxpbJPaL90LzxkduTf0yfhalW6grMVupJmt40mdjGRiUGUXDv34C2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390466; c=relaxed/simple;
	bh=/1sce9yrIU5eu34X2C0OsJ/X5/pYQ4mRDqN3t9ehA7Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bO3Yr/0VvzLKgwC5XFzpWnE9syxrGy8bKtXYYm6KZsK/A0VYdMxspExiqA8YXwDsiwNSqdEz+ZPfMS0tBgKD3RzIPVYYf3K2I2zgUnwH1ocQ05FP590Hf6JUrjdScdTJoViJjiA7Evrjg+HuVDo5mhqIUJr1ZWAQhjhJuvQp+74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tl53NRU0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713390464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZwmCErE/xwbeT8z31rMz6ID2aSBqGQpPtWnNtAkGcUg=;
	b=Tl53NRU0gs41hOQpjFHBj9Ax+ih/qGemwEL5sQc1N5saqBHd8Z33tGxUILInMuubbfuDUc
	UbRQHyZNrYIK2h9eWaXCB4vB1vvQAv++ueE1m0GuTXI083uWEBBis/njQJdsLvFYmnoBYc
	JYoGHcF9OrnTHDb17PVsOA8rIWT4dYU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-5tdK5EOLM0aW2s_Fj9-6sA-1; Wed, 17 Apr 2024 17:47:42 -0400
X-MC-Unique: 5tdK5EOLM0aW2s_Fj9-6sA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-345aa380e51so103938f8f.3
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 14:47:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713390461; x=1713995261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZwmCErE/xwbeT8z31rMz6ID2aSBqGQpPtWnNtAkGcUg=;
        b=PMjrFhb0ZUFN9dMuAG4cPsfOCZV7iL6eIo/JjH0Qj+VuG4SCg+CTFbAgvnkuRz1IDc
         /VvF1qOEo4s+Iw7IgN0JALEKkwwBfCQT6fdUiF5wFgSGDGX3AWwOnP13qe2hwEvjNwnG
         hRvhQv+7/grQwnfsLA27BNepNaBMGbvSnCVy+t8m3zQIHlTt95JQWeCSW7KJ9zp+oAip
         gCXZLPXSyAvqeF4wwhbw2+qMWFsfwfoV3MQlPUPnawaaBMq2y7Rzv3OWyrGwrgemERFC
         SrRaxdHDdyjLp2oa9VwGlGmUXMy4ZV7v3OqPzWaJ/IcbL9JUpYmKB+lZP6B2aWHYPeiv
         LiEw==
X-Forwarded-Encrypted: i=1; AJvYcCUj5C1iw733C9j7V7Gv7Ka7xI4eD+g9cneh7PggpitK+YG3YIbE/nMP0a6BuBld2kvW6YTgAwpuTdh3dxObK2+sx7i5
X-Gm-Message-State: AOJu0YxG7CaodH75KmNgeWg1GXAH6B7l7PxG/g9aeBvbrjBZpyIxlIux
	XemRUcDD4rTpiG6MObTpHrcOY8j1eW7qo7LqJzF/m/Ju2LGVQkpMeaa9YZyN1VCsUashsgVbIwp
	JwzrX+5uZtLX5R+7yzIPWErPvzWxCe162Q2zVlktezWGIXz90pBVOit0HQ8OEonUclq3wA11iPa
	W9Vu8XzTcQmvm+0mKXCk2cGzye
X-Received: by 2002:a5d:4990:0:b0:347:6f8e:a61e with SMTP id r16-20020a5d4990000000b003476f8ea61emr306267wrq.25.1713390461601;
        Wed, 17 Apr 2024 14:47:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfkYJ21lCmvE4ptWxsKBO6HxYnhgaSS/GZt13KX4C5q9PCEiQKSZ9v1A5ID7b0yfnwg9T/wgynUMDdvYCXDIk=
X-Received: by 2002:a5d:4990:0:b0:347:6f8e:a61e with SMTP id
 r16-20020a5d4990000000b003476f8ea61emr306259wrq.25.1713390461258; Wed, 17 Apr
 2024 14:47:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240417153450.3608097-1-pbonzini@redhat.com> <20240417153450.3608097-6-pbonzini@redhat.com>
 <ZiA-DQi52hroCSZ8@google.com> <ZiBAcfoIY3z_ARSF@google.com>
In-Reply-To: <ZiBAcfoIY3z_ARSF@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 Apr 2024 23:47:16 +0200
Message-ID: <CABgObfaFaSGmrfX+veWf_E3kp7ghRjxmiVQRC=Bmv0Z8stWRrg@mail.gmail.com>
Subject: Re: [PATCH 5/7] KVM: x86/mmu: Introduce kvm_tdp_map_page() to
 populate guest memory
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 11:34=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, Apr 17, 2024, Sean Christopherson wrote:
> > On Wed, Apr 17, 2024, Paolo Bonzini wrote:
> > > +   case RET_PF_EMULATE:
> > > +           return -EINVAL;
>
> Almost forgot.  EINVAL on emulation is weird.  I don't know that any retu=
rn code
> is going to be "good", but I think just about anything is better than EIN=
VAL,
> e.g. arguably this could be -EBUSY since retrying after creating a memslo=
t would
> succeed.

Then I guess -ENOENT?

Paolo


