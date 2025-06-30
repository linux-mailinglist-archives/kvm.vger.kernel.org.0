Return-Path: <kvm+bounces-51069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2277AED612
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:47:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50F11189897C
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8590523AB88;
	Mon, 30 Jun 2025 07:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z+07wnDG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A8523717C
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 07:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751269641; cv=none; b=s0rLrzZ2v6Saw5c6Gvd0LenjS6dKlgBuZas+TPfm3Wuh1lNAOWxdc41KI2ybIJwdjXtdPZg8iRzPWhjHFcPiK87T4/jTJnGOXCyxDcJRnRR6tFZPqzO0SLho7LBQGLnaiWHTuYzI7nGSOcT9680/rYiwM+BJ0h4naNpl4cLombM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751269641; c=relaxed/simple;
	bh=3WCJLLv4RhnKEvcl21V/JHUYDcouCFwoRzhLS4CQ9mA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=etmKKVa7WWL7KdUeHJtEvJjnIAHT7Gw0aWWO0VQT+yNP/wjXkHreftVjBE8F9HYIlpybfZqkXUKQfwxpoNX+ciTqtiJlH/6zkmJoZ8/NgT5bczcIjew4UvBSpMWZkgiP/LPI/nIBtlsDnHBTtDBu6iKV4gmpf2DCtGnabLNxD9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z+07wnDG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751269638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ktNPhfijuEzODMwYTiQC+VuJwh6IE4+mAtetQ6pS/E=;
	b=Z+07wnDGYHQgJxeMEr4EXfJz1TH1ZAArOBZS62ZwOzxrlGlRh5inm5P2ggNcfYjz4E87IX
	Bf2on51Ldpem93qlp2Ag5kayZo++/5+7UUgALffPPusuNZRP3ZporDVEkdHaXl/Z2OZ9gc
	A3Zva7xxlNt0a3uslcadP7s3oKelciY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-DfPx2c31OxSsO9l93rFvVA-1; Mon, 30 Jun 2025 03:47:17 -0400
X-MC-Unique: DfPx2c31OxSsO9l93rFvVA-1
X-Mimecast-MFC-AGG-ID: DfPx2c31OxSsO9l93rFvVA_1751269636
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-450de98b28eso23273535e9.0
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 00:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751269636; x=1751874436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ktNPhfijuEzODMwYTiQC+VuJwh6IE4+mAtetQ6pS/E=;
        b=N3St/vAVGYcHJd0sl5Dh2USjb8gcQwlXPY9zVdAsb6iMhPqcAaUzbpT1SVJvRElPHM
         1FyZC+PZBesXUI4Frm+ZQ78Td3CE0x3PxAk0RM4SeLN1FC1mqnQZah17mDDeV1H2sttm
         uIcloHXPBQfG0jRzpC6KkNkzOVDX2DFcfBwugy7STxybLal3zscDVq7UVkTpaArTpji2
         Ghg3nfRz2qzjNMKxLXhspHtPmH1CacGtCcRwqdxW0Bmcn8iUpKk6kOBY6uEzn7ldVRi7
         NCJ+DeN5DXLHO1qXjSFG39QAs4W0m0ivk9SJXlP9uoUso0A3OqYdoqtJouk7L6UxqYKb
         nEsA==
X-Forwarded-Encrypted: i=1; AJvYcCVVdZilrrN0YyZJzzGKtKBnGWLZ7PrzWZHh/t+RO6MYYeG69xpQcCVoNrubwwD4jjsrMjE=@vger.kernel.org
X-Gm-Message-State: AOJu0YysSL8enQXwhI8Nj5kCCy2uE3cRcyuEhEl5x1RTZERbSCYlcQ+a
	5IiM/hVpX+HA7EwbuS0MyZUC/zroUQ1Hjvaoh2vy10TA0YDVIeTRnZsXnaUOAQ9pz5wtt0NTnHR
	F+vV1gJGi/P1hHNhhC9xfXR0j1ncB/oWTVxx5SEInm+IN+40kJ9aX+w==
X-Gm-Gg: ASbGncsFXXPHBU3M7Md6You8jAfR1CWOaLlnUgl55BvolKPskz5jwg9KfhunmcVdL5c
	G+2AAMdKFl5IAROrPfi3wX9bivlD6l1b5vvhD/6P0yW/XIqFH1V2xEUmJo5P+MTq/X/CxdyUs/l
	e7mlCb6jcnNsOi/zOVBKovh8OXq9jx3pXlrDwXe6T9/gCWbIeCqo1CLycMwvDt4Z+WYPj2X9sV/
	eX77pE9ICdq+0h84OpV1FJBWLfGEic7C9K8qMEwqsyyFwt+5S0fkzl9bEpM/qSHM47TVWq2FhQ8
	OSxIL/CwqexRwCmqG/6veAGpQ/Gb
X-Received: by 2002:a05:6000:418a:b0:3a4:f70d:aff0 with SMTP id ffacd0b85a97d-3a6f312df2bmr9022668f8f.14.1751269635649;
        Mon, 30 Jun 2025 00:47:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxPyEI4vtDCAHmMrt9Bgdg2700Ez6oVkN9Z1NlWqAtZ1aXzxk700hjPBCX6uj4jbe2vAmlKg==
X-Received: by 2002:a05:6000:418a:b0:3a4:f70d:aff0 with SMTP id ffacd0b85a97d-3a6f312df2bmr9022638f8f.14.1751269635049;
        Mon, 30 Jun 2025 00:47:15 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.177.127])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453814a6275sm105907065e9.1.2025.06.30.00.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 00:47:14 -0700 (PDT)
Date: Mon, 30 Jun 2025 09:47:06 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: mst@redhat.com, pabeni@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, netdev@vger.kernel.org, stefanha@redhat.com, 
	leonardi@redhat.com, decui@microsoft.com, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, fupan.lfp@antgroup.com, 
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [PATCH net-next v4 0/3] vsock: Introduce SIOCINQ ioctl support
Message-ID: <gv5ovr6b4jsesqkrojp7xqd6ihgnxdycmohydbndligdjfrotz@bdauudix7zoq>
References: <20250630073827.208576-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250630073827.208576-1-niuxuewei.nxw@antgroup.com>

On Mon, Jun 30, 2025 at 03:38:24PM +0800, Xuewei Niu wrote:
>Introduce SIOCINQ ioctl support for vsock, indicating the length of unread
>bytes.

I think something went wrong with this version of the series, because I 
don't see the patch introducing support for SIOCINQ ioctl in af_vsock.c, 
or did I miss something?

Thanks,
Stefano

>
>Similar with SIOCOUTQ ioctl, the information is transport-dependent.
>
>The first patch adds SIOCINQ ioctl support in AF_VSOCK.
>
>Thanks to @dexuan, the second patch is to fix the issue where hyper-v
>`hvs_stream_has_data()` doesn't return the readable bytes.
>
>The third patch wraps the ioctl into `ioctl_int()`, which implements a
>retry mechanism to prevent immediate failure.
>
>The last one adds two test cases to check the functionality. The changes
>have been tested, and the results are as expected.
>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>
>--
>
>v1->v2:
>https://lore.kernel.org/lkml/20250519070649.3063874-1-niuxuewei.nxw@antgroup.com/
>- Use net-next tree.
>- Reuse `rx_bytes` to count unread bytes.
>- Wrap ioctl syscall with an int pointer argument to implement a retry
>  mechanism.
>
>v2->v3:
>https://lore.kernel.org/netdev/20250613031152.1076725-1-niuxuewei.nxw@antgroup.com/
>- Update commit messages following the guidelines
>- Remove `unread_bytes` callback and reuse `vsock_stream_has_data()`
>- Move the tests to the end of array
>- Split the refactoring patch
>- Include <sys/ioctl.h> in the util.c
>
>v3->v4:
>https://lore.kernel.org/netdev/20250617045347.1233128-1-niuxuewei.nxw@antgroup.com/
>- Hyper-v `hvs_stream_has_data()` returns the readable bytes
>- Skip testing the null value for `actual` (int pointer)
>- Rename `ioctl_int()` to `vsock_ioctl_int()`
>- Fix a typo and a format issue in comments
>- Remove the `RECEIVED` barrier.
>- The return type of `vsock_ioctl_int()` has been changed to bool
>
>Xuewei Niu (3):
>  hv_sock: Return the readable bytes in hvs_stream_has_data()
>  test/vsock: Add retry mechanism to ioctl wrapper
>  test/vsock: Add ioctl SIOCINQ tests
>
> net/vmw_vsock/hyperv_transport.c | 16 +++++--
> tools/testing/vsock/util.c       | 32 +++++++++----
> tools/testing/vsock/util.h       |  1 +
> tools/testing/vsock/vsock_test.c | 80 ++++++++++++++++++++++++++++++++
> 4 files changed, 117 insertions(+), 12 deletions(-)
>
>-- 
>2.34.1
>


