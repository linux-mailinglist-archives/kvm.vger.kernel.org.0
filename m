Return-Path: <kvm+bounces-31882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB6949C9249
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 20:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 706F52827F5
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 19:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269F71AA1E1;
	Thu, 14 Nov 2024 19:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YqISrxel"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EF219E98E
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 19:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731611555; cv=none; b=lmltZCQE922Jsp0XBxBea60mY8n06D0KoddD7eSD9Nn45GhPnPzUCjgCmKNh1wOdYzvehY/txM4x+jq/F5ZJaICLDAImh0RHEmpD8M63f+u1Jz7Mu+tJRg5XxioQa89/03+xYrdp7wTv/dqQz7BdBs5lrhP3DWwbqDiYwh+lycE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731611555; c=relaxed/simple;
	bh=8NIsFh9HjLOsPUCctkUZ0OQoop3hB0APVZblVw+P4MU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n7NMDt0Zz7PHcPN9ftoBe+qAhoLSQyzx84NP1+6LKGT5eY/MVcWjvjxwbiEMYRdpOFb/FwJ8IN+XQ/Qpg2q1rSZE12nIxcI9/vv/q9Ta1VZjOHbg9SKObDVcPYZmUadvMWFmjVjk5QbG7whPqj5v0GQV4YkDlH7gx51U81G9WcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YqISrxel; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731611552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fRAysetKQ3mmbtVIPe2O8tbisqHkftH8tQ6gNwLYHtY=;
	b=YqISrxelBI2yG212Fa0J9JCwrP2wPOtbfUcAp+mAdCt4sr5oZ5tgrD8gre+bglgInEpJnU
	yo8DaRcItupmVo1n2bnL/v3riaXQBF2sRYgRh4eaPPahEQ6ujXRTxzbDz0NTl0JktLhDSW
	PY1fP7SAjPWkrBjh7nCMtT8KmoS3keA=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-Fh-7jvJxNYqmXbuWXFaY1w-1; Thu, 14 Nov 2024 14:12:31 -0500
X-MC-Unique: Fh-7jvJxNYqmXbuWXFaY1w-1
X-Mimecast-MFC-AGG-ID: Fh-7jvJxNYqmXbuWXFaY1w
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-5eb7e7cb216so105032eaf.2
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 11:12:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731611550; x=1732216350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRAysetKQ3mmbtVIPe2O8tbisqHkftH8tQ6gNwLYHtY=;
        b=WJ22Z1sjT4f46A7Ab1oMbDv4UflaQdHVZZFvjAejjzgV6UKV4hyLXDW+GA7C0yG9ld
         18E8rfy+/QLcMaUyAomkLHYTJl5D5XCg5i0k0v8T/Fjy4SdQzKlJoyYBxsEXQYN5YG+a
         mky+BuS90QzjSL1ScvxLUue+M9ckJQ+AOzz3bFvZxUjPfJuf3m+8QjrieJspjgteC8wv
         8oo57Z8adCwlj3/+UQRsT/CXFc2DIDbDD+N317YjSY+KlbZpsd1mUtoagTEK1YexYwN0
         7q0AJ4R0VXPrf2w91uRQWqf2aLGGsVJrQb6JqfgToqTp5ucaODA7VeY8kZOI/xGsZyrI
         MsAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiySIuBwPERxcwqYgz7yezcHKHiJUoNr8SzYXciXyUQDpH8mSIqCyiYQnW+y452+RtRAg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjmxNBcTPp9ibiBlm5mU0+vwXUvhmMoXhGwKqugJLIScoP/L8Y
	GTCTd5L/YO14rE+U4WN3ntpLViznOF19iPz2kKkcJRJ7Npyx43tIVkfrqtMVVYvnGbpE6XiNl1Y
	VP5Vqrlrb5u022NmmhqOKyBB3sPIALi6A4KtxO/foMBiB0zq8sA==
X-Received: by 2002:a05:6808:1794:b0:3e0:4133:99a0 with SMTP id 5614622812f47-3e7bc7bc66amr16378b6e.4.1731611549094;
        Thu, 14 Nov 2024 11:12:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH/UJ9X2WjL5AFyWAPl6EYQVm4D+EAWr9fpOXs+H30M0xXdRkYbHQnvY0S8JdsEfPoxb3t5uQ==
X-Received: by 2002:a05:6808:1794:b0:3e0:4133:99a0 with SMTP id 5614622812f47-3e7bc7bc66amr16361b6e.4.1731611547330;
        Thu, 14 Nov 2024 11:12:27 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7b8599703sm561728b6e.1.2024.11.14.11.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 11:12:26 -0800 (PST)
Date: Thu, 14 Nov 2024 12:12:25 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v15 0/4] debugfs to hisilicon migration driver
Message-ID: <20241114121225.3ab59ce6.alex.williamson@redhat.com>
In-Reply-To: <20241112073322.54550-1-liulongfang@huawei.com>
References: <20241112073322.54550-1-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 12 Nov 2024 15:33:18 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> Add a debugfs function to the hisilicon migration driver in VFIO to
> provide intermediate state values and data during device migration.
> 
> When the execution of live migration fails, the user can view the
> status and data during the migration process separately from the
> source and the destination, which is convenient for users to analyze
> and locate problems.
> 
> Changes v14 -> v15
> 	Correct variable declaration type

Applied to vfio next branch for v6.13.  Thanks,

Alex


