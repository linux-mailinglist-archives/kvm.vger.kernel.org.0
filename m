Return-Path: <kvm+bounces-9286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8EE85D198
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:42:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 337C71F241CB
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17CAA3AC26;
	Wed, 21 Feb 2024 07:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C77Pte+L"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B917939FE4
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 07:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708501331; cv=none; b=D9WFPpfGqgDqao950Nlm5aicpKe436SOOxkcYEoWDZ7K1BEpy6TehKLSfWsgAgC6AZ9tUek7B3mbW4u5c83O0LVwBMfI24qL0EFdfrzPUMhMWE4VGg2QYEqFW5M+Udi9gfWusHmk7twkLikadOqYuGcZYvneNe06576Jxwmr0mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708501331; c=relaxed/simple;
	bh=K0/IrVU7DaNY7XENrSERf/YmPhy3471CvOOlogyKG2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgLp+RCCJn4dVgC9J3kXgn/7isU6GwhfX1707ELw3YIbklYSPHosMUiDY0cbums9i0dzlgtkL+UOzr8uHOrp5+eSsO6UCUrxleVXCACOlZwHRGDK8OIKlBplGXYKcPcRGHzM1i1JCDLEq/bA1eElN/+61lyuTO+NJnvRqevb4J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C77Pte+L; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 21 Feb 2024 08:42:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708501328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L5DvEec2Dqw6aoCbSL3ub/PJa5JQf1N9WqJiLTqK6rY=;
	b=C77Pte+LXiv6zxFt6E4ezD/hwArkRYFW3qithwerNx2hhQdDigZbrdcyQpstSy+aIfxzZ7
	1hAkIXpvrOrfFpIt0z2F9BrX/LC6fiITpJachsa4DMeknl8YOhfA0K0hpuXJmoxj3Hwa1C
	1yuhGCBIEEBI9SfjaQg38gHmhQp+1mE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
Message-ID: <20240221-499d5537872c9fc9de5a5dea@orel>
References: <20240216140210.70280-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240216140210.70280-1-thuth@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 16, 2024 at 03:02:10PM +0100, Thomas Huth wrote:
> getchar() can currently only be called once on arm since the implementation
> is a little bit too  naïve: After the first character has arrived, the
> data register never gets set to zero again. To properly check whether a
> byte is available, we need to check the "RX fifo empty" on the pl011 UART
> or the "RX data ready" bit on the ns16550a UART instead.
> 
> With this proper check in place, we can finally also get rid of the
> ugly assert(count < 16) statement here.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/arm/io.c | 34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
>

Acked-by: Andrew Jones <andrew.jones@linux.dev>

