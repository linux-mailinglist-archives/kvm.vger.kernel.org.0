Return-Path: <kvm+bounces-12752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E2B588D5EC
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 06:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE8EC29BC3B
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 05:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE9B914288;
	Wed, 27 Mar 2024 05:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YCqO/Mxy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918AF10949
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 05:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711517929; cv=none; b=CQ/+SJXjcKoxjSs/GpHfU+O0YvDk7QnbncnJOywb75SkK3LnP3O1WHjZ02cPQ72XrT2/B+A0mc3R/GHX+52sx8PWmPXJst9DlUJ9nVSxuJes7zTOBtDmnEc0YZRlZBEWStS5UE3bfQm6go6ikJyCW0LiY7zmIvTldxUoJjZTEKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711517929; c=relaxed/simple;
	bh=c8Qxz3GjemwSldg1rtEYBEhGGs00Vj4gZEX2g47vXU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qG/E7Ul92XWz0M6vLyGSvDIMn3IzTG/VtWDpOk8M9Ol//Rwu+vUIQWV8LP7XM/UoziwcAUUhuLq/sIyMM8SR+pGvl1vyMdFUPPcSG1KCevnys1sMkjWzvCIS3Xc8cjQLb5cWJcm/Qv0GIvAw6bgcU5uHOvAo0nJNemKgWqjLgjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YCqO/Mxy; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3c36ecdb8cdso2954564b6e.1
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 22:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711517926; x=1712122726; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GEa1wJbE96+0XdxLOBaQ/cWqz0eCFh0pN8QmBlQTfhY=;
        b=YCqO/Mxybl+uDfTb5WvMPYlwKhKl4q3hDmbBb/BevaL1jgjFDjyC+S6nyAbbpGoz3m
         vVBQESkcXLhwLGmbltQMxoLbGl47/QvQBgda/v9gUuWWV8R3xHBdaTxKS1ytZHe/CLam
         fudmpnB8YpxOV3Oa8BKTz+fbDrzIn29rcZ/6siLVcCh0y6qMuAZVU69leGsqVd4QLs5o
         jjN9C+a9i5B0G6vo8HQF4RJl71kG0GlFL/gCWXBR2Zp5ZaxpYHKtkH3YcB5lDS2Qpr/h
         hwuWJJx5eMMgrB/PEkkmCihttdTwSj1J96hjm1Dlv+aPKxwLTCMlpWxtLUwlIum02TaD
         iCOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711517926; x=1712122726;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEa1wJbE96+0XdxLOBaQ/cWqz0eCFh0pN8QmBlQTfhY=;
        b=XEYVrteyAyPGktkmTB+48NZ1fsre6q3iXNCf0dNbAdPzgYGH+aRxoQawu00kWihztM
         PAV3HKvPr65QH2l0Mh4ViqX8RMKo97NoFRiaOWGKGCGYWIHKLiFVMfTw2Ll1X9FM8bq0
         Mc0DrOoOMtQ0FA1TFUw/7t7EMjwmlV6EHfQASdTJgoBTII/nQTVyufIPc/E8xb/jcuC0
         wuOY58fqP2aG993sbqN6TzKXBis2koS35k8UVWlo99xJF4sTtUWJo5vvMaiVoeU9CpRC
         v325sm/uSTN8lG/65r0A7WIzDk9XKpgPkNllVXcLwplTG1Ulluyq/3bSPXGap5ZzDFTO
         RxeQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/v9SXs4W+vvRdWLJftf4t9St9dfW0jEYwHBz1C40rUHhefN6qMCysTsG+qCGhQRoYJeaGA4UfDejSWyewrgJfAgma
X-Gm-Message-State: AOJu0YzJ4hg23NgVSeb6XEb/hRuAVT1UjXbt250X8rEAzn1VyRlZ1qU0
	rX7g9eMoS3TReP1Tl6pCc3AZyNY3GUZ/HZ7200FexJ15gNHyv0ol2kpyndlV5A==
X-Google-Smtp-Source: AGHT+IGp1R8GmfW8HUNyHIR3uCDgu524YP5Rj7c/dj/PXh/ZNJ7GIsh+Jq6UmTViK5/nupAbScuJgQ==
X-Received: by 2002:a05:6808:1381:b0:3c3:ccf2:7f5e with SMTP id c1-20020a056808138100b003c3ccf27f5emr353054oiw.11.1711517926472;
        Tue, 26 Mar 2024 22:38:46 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id g16-20020aa79f10000000b006e669357e83sm6941515pfr.189.2024.03.26.22.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 22:38:45 -0700 (PDT)
Date: Wed, 27 Mar 2024 05:38:42 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [kvm-unit-tests Patch v3 06/11] x86: pmu: Remove blank line and
 redundant space
Message-ID: <ZgOw4g61ejwD8oQ5@google.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-7-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103031409.2504051-7-dapeng1.mi@linux.intel.com>

On Wed, Jan 03, 2024, Dapeng Mi wrote:
> code style changes.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  x86/pmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index a2c64a1ce95b..46bed66c5c9f 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -207,8 +207,7 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
>  static bool verify_event(uint64_t count, struct pmu_event *e)
>  {
>  	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
> -	return count >= e->min  && count <= e->max;
> -
> +	return count >= e->min && count <= e->max;
>  }
>  
>  static bool verify_counter(pmu_counter_t *cnt)
> -- 
> 2.34.1
> 

