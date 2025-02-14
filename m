Return-Path: <kvm+bounces-38183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEF88A3651A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 18:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 059F0171CB1
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 17:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7FE7268FE1;
	Fri, 14 Feb 2025 17:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="GRxRh52V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8339B2690EA
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739555918; cv=none; b=gvzXlGdfcf5du2ozvko+DsFQ3YxSwm5w10qFYRN8i3A7XZFlwRWZ2TeEMtw805AbE5hvjNbeDPGBBCMnIwQXPw5INCokYY4KJt1lhpKEw8GKEf9iwjdzqncL0ZKMjKSoEf5F62v3vbBiWaeJFvTYTvkyNf6bcokdW+b66QwXdRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739555918; c=relaxed/simple;
	bh=qpkKS4e8HItfRZYJWNtNUlb2dPtuv8zQncwy6wMk6vM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJ5ihF7/90eyum7j/S2DVrViCT0BiMksqxAYDtOlDS7CHrihVuZTFCVvdh/X+AFwoNwPKE4AmInhZ4jTpYQ5uRr222PXt9D4EUuDCAP7BvBu8npHOKQ0D7+GfESyOCKnpqsjlJIr7skuNB5vAD2q5WwZB93V7tozbOaFUj4hWow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=GRxRh52V; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6dd420f82e2so32230196d6.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 09:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1739555914; x=1740160714; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qpkKS4e8HItfRZYJWNtNUlb2dPtuv8zQncwy6wMk6vM=;
        b=GRxRh52VbE1LCA0bn0IU0fSDClyZNHSjH79i6LsW+As2+jiVMfja3hCdoXD3wIrQqr
         pIhmU/QjybgxXSOUKuOyfrCQ1DKq/7l5mmy2otRAdF2cBYLKjXe129iW6Rl20ViL8PaC
         yFK2PbRLAN8kQKsk3YM8LHAcWacyGYAlugQrPc+2H4TwHdbQM27zg056CtLBZQf3Q3oI
         4bRqj2+NtcVEyBJVAZnYrZkAZIxltPQS2YinSzGzne0KR5bKdBGQpVC7LWir634EUhTi
         HYi6PEQ3LwgAEqK89Kf426kh2hy3tBGUy5pzRHjJBehObA9FBvQ2oEpDM/07YLuOovRW
         UIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739555914; x=1740160714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpkKS4e8HItfRZYJWNtNUlb2dPtuv8zQncwy6wMk6vM=;
        b=N7OwlbPDorThZHRrob70x/nK2m8SNn2vbLKmlhFH8aXhJweo4mCTheQdD78WS4Og3d
         F3UktvTenK5NPd88sC8qDsqszxOLpSiI03tUASiEJ6Ui+BU/5oa7v2JRa5SFfe6FPWuy
         uGrBFMFKI9z/tmmZvh67S694kBnrXHMYEoo6sI8LOxJV25O65JV4YuRnaL1HCIU5C+3d
         M9NOmWnNKIgpsYcUybIBvwrzf7VZAPBvxj8Go2QmhDlCQHY+FI8EtswNYzRb34i5oseF
         gAJ1cWz6Jf8R5C4zd2e/cAqpS770Dyg4V5bci6iHI3P15S2RBAkpkLcmdW8g7RV1SYEb
         1Zcg==
X-Gm-Message-State: AOJu0YwamRy6xlLQvn99fkR3ci+76IQxMZeHqlv9GjakzDkq3n9dtK2P
	SeNipJtUduW7FwD8JNVYEmBSOlyjvL/ZcgbWqhaO7Vs3dFY+usnQns/fDLAyj10=
X-Gm-Gg: ASbGncvDuEPV01tzcqIqs/h1cRsampEf6L69HHE/Nr2wfAHeG7VSbSFINrGwnJJWEu6
	OeepcEfxL/ZtHTWeJWVF+Ple12AlgjfcukNyK81KLX459mNgINXxazIKvfhnYrN+LGetcc1oT9Y
	ynTVGDQDQPoTi4Ifcp6XXYyvx8fZ7Y5/pF0e6643OzkbPXuqXwqpNJqyIE/0b4ugoTbyx4D7+j7
	V9NlBNZ2sJp6wUKNWq3ltyXA5nP5Ro5taLbgksOADQPFNSNYYfEsx28xbqNLIsVQpxtQkAayyx5
	xu2GReJiJeAbqqpEW/xkZbnOhW0E/dWfTZrgXBCiW2dtM7j1yIuK+7GfV9bSLCWo
X-Google-Smtp-Source: AGHT+IFQXyA1QsywBm27eP/YuJP0NIYkqtqnAWu3j0y7rUPGIIJHkpKTgTdEVUvYQ9T8YBfH/i2P2A==
X-Received: by 2002:a05:6214:5085:b0:6e4:4484:f358 with SMTP id 6a1803df08f44-6e66cd0b70fmr2403576d6.33.1739555914298;
        Fri, 14 Feb 2025 09:58:34 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-471c29e9261sm20091841cf.5.2025.02.14.09.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 09:58:33 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tizxR-0000000GliU-0b2Z;
	Fri, 14 Feb 2025 13:58:33 -0400
Date: Fri, 14 Feb 2025 13:58:33 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
	mitchell.augustin@canonical.com, clg@redhat.com
Subject: Re: [PATCH 1/5] vfio/type1: Catch zero from pin_user_pages_remote()
Message-ID: <20250214175833.GB3696814@ziepe.ca>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
 <20250205231728.2527186-2-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205231728.2527186-2-alex.williamson@redhat.com>

On Wed, Feb 05, 2025 at 04:17:17PM -0700, Alex Williamson wrote:
> pin_user_pages_remote() can currently return zero for invalid args

It is so weird that it still does that, I tried to get rid of most of
those but didn't dare touch that..

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

