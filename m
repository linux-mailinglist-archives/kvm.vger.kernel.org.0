Return-Path: <kvm+bounces-65884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F7BCB98E9
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 19:24:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CA5530A2163
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 18:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2D930215C;
	Fri, 12 Dec 2025 18:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hSCbjTai"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6FF2FFDF1
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 18:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765563751; cv=pass; b=UwWT5BFKIa2F8NMXuDjwS2LLmntmvd7QI1LqZS88wO3fl2of3ANbvGva7TPJUvQ7Wr730eWH0ogwQ3TQITbi5B+ovQY6E+/+hfrNva4FBQ8sUI0dAfIcoM1MkOq6tFtepGGjD1q23MQ+1j17PkNoBrasjhunOhQLt2nxz1Yplc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765563751; c=relaxed/simple;
	bh=UiGJCd+DCQ3zHLQQRaEWS359tCWVF37C6n4JKI9yF+E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KDVr6dPsp6cKPEfUSDjo9O62os6T5xUbXF3yItuqr7kv9DWjdVIUcj3txXV/xDascEw0DN/UPAlYbp5MW2RZjr+lKTs0P5tc8d+pCWrGetHnrQauu8QTWr4h4EiMxOfSfM2W2Cfkg4WhtxpEoE+bjetDTkt34eoCVH8OYFoO/9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hSCbjTai; arc=pass smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29f02651fccso305205ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 10:22:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765563749; cv=none;
        d=google.com; s=arc-20240605;
        b=E4AFFB3vQWhi5CAL+/yTrH8B3VI3i/Hf0QscA3UktVo6LybDSQDegqckUIzCrY4cmC
         aVAAvvvC5cae+FDipYWc1xiRmEJvyaXIlmg5FUXOr1dfK6n7nd0wfMqF1mJry9ruvyqL
         UR7RO6Yb+osbqTjG2BuVdZJ6afi2ySKYLRWSkZ2HdgEDeO3GgW6lGphr10NuyXsq/Lkt
         5bgRKMVUpS7toWRZ7F9T/62rXyH78cSOyw1BCOwFG74uDYJ7g8/yazxCEu/RZayvJR87
         mlmEal0eS5Xuvht/KZcsVdSjY5b3DKKGPSPKcFSd29vAsnbbEKXzufG3XT2aLvhRy4Oa
         PfrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jy+G93rLTI8kx5LpOA3CTDgeZbpceGo5CcKjxhVZvI4=;
        fh=bPOMGRpWB+ABDjVWA58fJbodwUeUeVSYkRgi6Xv8gpE=;
        b=hCor7u8oBl37V+IPfgbzIMLJuXhLcEdQZOA4HvccLfvPgT7DSgWt7U2d3Ovkmywsyk
         C9t9JwxlhOEZ5qbQ/6vXOVSh0W+/IxfeU1/88r1KOm+xLhVzq34580YRyyEdpmqRTPId
         eWwivp3DS6TJlMSqZaMLIn9GrsgRRVMr5PpMZ4m53c1vr2OybLz8oU+7qKejXZNs3vnn
         ARNwUPuy2K46XYhNH8c1GD4IMqVv99HIz4m0g39iOnyF6KD8AD+sMHlFhDcuI4elbxz4
         IB5GrHQonBjHS2ntq1cfruegUb9EP7UT416YMxzJGj65TyEWmlQOCfDYcxQ7IWqEdDHO
         Zvng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765563749; x=1766168549; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jy+G93rLTI8kx5LpOA3CTDgeZbpceGo5CcKjxhVZvI4=;
        b=hSCbjTaigjKHbkZ8L9w5hIDWwfeFh2TQUzQqHOHm6NDxQEYuTKpvAQyRc95PH2tGCy
         PyZbtCgGLQ0VsQKTVX2bkJT96K7zfnfbZSkBh0NvX8k2L9cT4dzpecfJytZycnWEwqLy
         hE8P+PMtwVA6rTYh7KohSznlfPP2CmTfr6xUeKou+GYYqeVG/29Z+Db0QwhFq2lQL2Y0
         JuC4h1DKyJ1VlhD7InCHiKQtsT2CtFILo7Div3LRAhlAyseFbNC+zoeFHf4ooiE4hma7
         O3JJca5rMIi7nHXB3NRCzQSxQAn55VvdDF0UUDMXahJ7ReSMe+6Q+DMdwb8NgJrEPzgK
         7TZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765563749; x=1766168549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jy+G93rLTI8kx5LpOA3CTDgeZbpceGo5CcKjxhVZvI4=;
        b=Mf4gKSSGeckLS30H7XRUPNwiJhwxgeRb0ggWALzjlYBkWXXYD7VExw3ZAvIjGcv0EO
         r6wwCBOAVu01WVM/HWqvfNgF4vJuXQF7Vx1Cauo9cAWEYHAQzO8TmOB/acLPJU6vPtwc
         HCiM7tPtZmQdNvTBMBxuwQrzaljflcj8dyNsj4ZZZZKn6iqgEve+1qo/qtkVdeJngjla
         X9zJM+5LsV7u0KCGBJoBcEavY4wD1r+gd0IHf55nFtNFJdN5f5w6QW6BTvaFgTAbMi8C
         gVBvSdaVoa23AP95Es+m6IOiCDoe/p1WAYP6igjxyjISHPu2cpQsNxWfQUZxxTzhJMAl
         PZYw==
X-Forwarded-Encrypted: i=1; AJvYcCU1EubY3TFNlHyyYNtvLP43ZWS5OHxbluvSWGihYvjCmybgTzGWenmIn8g6sZZyX63wJFM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHCReIxU36oHM6gFvsQ6SNDVqfmqCZShO2qpaChqgTU2Bu3LLa
	NSuOjpk9o/FEH70CgdgxhyKsZlKlABqqYgA+AokScLHaw00Pl62Nr/m520EwdvLxB+Y8bF6yEiq
	N3HXMiRsSQbbMbwdbYWl1RGct0S6L27X2XdFfpr87
X-Gm-Gg: AY/fxX4jPHUiK3e6jhLhdI1DJnGm5ismQgSNK2BswmBoqigNt+u+5ibT4NvzKXrfJDu
	Rsg99mATs7IaOiAmJdX6bkI7E6mMJXbZBwmHljHv92wALMNi5sWweat5RGLAuXwfHZIlTMm+i6W
	XU9v94bjYqPmuXIZzJtFerZTv6lhw2ixJrRfGefm6SLLRX9u/c2ka4uqwVE2PGp3z8XD6bgwOdX
	XDuGbvDnVW+Yv0BfBK7fhelgQ84IfkYVl3HK8n/vjf/tXv2rfCIfKOcIBno9v5ku9BM6o0=
X-Google-Smtp-Source: AGHT+IG+b9iOIeq/Jvn5taafgpUU/G5PMPUlEYgxiYwL1QzNTImjX4wuc0I8dUHwFDoF+OEr0awNbb6sicQSJTLgV40=
X-Received: by 2002:a05:7022:6288:b0:11f:38dd:8927 with SMTP id
 a92af1059eb24-11f3a6524b9mr2343c88.5.1765563747256; Fri, 12 Dec 2025 10:22:27
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com> <20251210181417.3677674-7-rananta@google.com>
In-Reply-To: <20251210181417.3677674-7-rananta@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 12 Dec 2025 10:21:59 -0800
X-Gm-Features: AQt7F2qu20jtWjQdK0ZSjbq3CSIUWj5wGHydx5-F-8arHwxIzfxAt1jTQNQ2qS8
Message-ID: <CAJHc60yPHzj=qRuRWszv1uFGqKe3YD1nODsTOVpcWxpim_85mw@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] vfio: selftests: Add tests to validate SR-IOV UAPI
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 10:14=E2=80=AFAM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> +FIXTURE_SETUP(vfio_pci_sriov_uapi_test)
> +{
> +       int nr_vfs;
> +       int ret;
> +
'ret' is unused in the function. I'll remove it in v3.

Thank you.
Raghavendra

