Return-Path: <kvm+bounces-16408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0EAC8B9891
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 12:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1B9DB21E46
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 10:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462B257333;
	Thu,  2 May 2024 10:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rUEu0fgN"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B677054913
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 10:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714644683; cv=none; b=p3MO9EfdbvfiXCALJQ/PPHoTm3EgRVRsqNKMFrDkUx1tugJfJhS7/B1LsdmFHqTsAmt/zDDPRD3R5xl0NFhMReUQ8/JFp2uYQDwTjLxR+/C3R5U1k8iI5dV4CUHOy1r0CB26atL0K1qPSAy7rq3jDE07NTVFV7UxAKQbVGg8mug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714644683; c=relaxed/simple;
	bh=7dcsPu7CPfetIHLBuly2zBTe/e14bVh8lZfmBoiZszk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gGC4ahIIDssY4w9UUB3Rz2gagqvEiWJfd+juG5roH8INY4Y0jzlFI8K5xBVqfhj1PduU/GgRmkjQtOHttoVapuKp8f0J4yVsoPrcklFJHVtUx4GvMEugZ/6ZBpcTFPNyoavy/gXaGSdpcmw5r5czCFgnsKgUN+lMbjGxxA6L+IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rUEu0fgN; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <c59146ec-fac3-47f5-ae2b-4f74db11b55c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714644677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bqolwl4lR31IKj9AKrAjAeQL2Yk/FzNTidMmKRxxIJ0=;
	b=rUEu0fgNmbFi4hEzKwX8HN+WPcJiZeWmLEHVMnqlei9k7tq2veUyb3cIlJzWbmcxCPt+Io
	cXTJnb5/8I0Q/BrGTdqmXNm5PDTzOVsX+bjx2KI/l06SP5guLZ+Jt/vhsN769ztGLKlxcU
	zZZZAnsQZPMEGQB4BnzvB2EgNTe2v7g=
Date: Thu, 2 May 2024 18:10:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [kvm-unit-tests PATCH] arm64: Default to 4K translation granule
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Andrew Jones <andrew.jones@linux.dev>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Huth <thuth@redhat.com>
References: <20240502074156.1346049-1-oliver.upton@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20240502074156.1346049-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2024/5/2 15:41, Oliver Upton wrote:
> Some arm64 implementations in the wild, like the Apple parts, do not
> support the 64K translation granule. This can be a bit annoying when
> running with the defaults on such hardware, as every test fails
> before getting the MMU turned on.

Yup, I had to manually specify the translation granule before building
(and running) these tests on M1.

./configure --arch=aarch64 --page-size={4k,16k} --cross-prefix=aarch64-elf-

> Switch the default page size to 4K with the intention of having the
> default setting be the most widely applicable one.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Acked-by: Zenghui Yu <zenghui.yu@linux.dev>

