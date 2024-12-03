Return-Path: <kvm+bounces-32920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 230599E1B33
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 12:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD101281331
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 11:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E341E47A8;
	Tue,  3 Dec 2024 11:43:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2331E048B
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 11:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733226215; cv=none; b=tcwLeCCODAHSsf0euLGx4r/WOjYLRa/yF4kCeA0hwtbrTTJo9pM72tuOp0Eoojpi9wzVUNWnREmevhmFjYsHsq0Dg7hVYvYzbpjMF4ymhU9XUVaF0spXHe58r2HbJ7XWNK6bRF9nSJpxToB4rTTAPgf+6GkqLd5Yh6Z5gKASE00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733226215; c=relaxed/simple;
	bh=y8MozKhBVISsPUQa/JqcZPuhmafdyND+g1bctCn5YqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dZd7QKNy0w6Kq0S+k/L5qj9V+G+2OPBfwyA6S8P0Z3aVlMtD2wN2giktMcEzw8yB6nhsJkAWDDNrwjDuHd5kordOps2LXf1YmaZnyKa2GXjTu8XaUol35HGQ9d2wzwEnBgpjzUS7G6E+bmzlIQC8lwZ1le/Limhh4wRagtBnK9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49EA6FEC;
	Tue,  3 Dec 2024 03:43:59 -0800 (PST)
Received: from arm.com (e134078.arm.com [10.32.101.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EE263F71E;
	Tue,  3 Dec 2024 03:43:29 -0800 (PST)
Date: Tue, 3 Dec 2024 11:43:27 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev, atishp@rivosinc.com, jamestiotio@gmail.com,
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/3] lib/on-cpus: A couple of fixes
Message-ID: <Z07lIOfsypu++H8/@arm.com>
References: <20241031123948.320652-5-andrew.jones@linux.dev>
 <20241111-ef3ba6e132792aaf8ad901f7@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241111-ef3ba6e132792aaf8ad901f7@orel>

Hi Drew,

On Mon, Nov 11, 2024 at 03:36:30PM +0100, Andrew Jones wrote:
> On Thu, Oct 31, 2024 at 01:39:49PM +0100, Andrew Jones wrote:
> > While creating riscv SBI HSM tests a couple strange on-cpus behaviors
> > were observed. Fix 'em.
> > 
> > v2:
> >  - Added patch for barrier after func() [Alex]
> >  - Improved commit message for patch1 [Alex]
> > 
> > Andrew Jones (3):
> >   lib/on-cpus: Correct and simplify synchronization
> >   lib/on-cpus: Add barrier after func call
> >   lib/on-cpus: Fix on_cpumask
> > 
> >  lib/cpumask.h | 14 +++++++++++++
> >  lib/on-cpus.c | 56 ++++++++++++++++++++-------------------------------
> >  2 files changed, 36 insertions(+), 34 deletions(-)
> > 
> > -- 
> > 2.47.0
> >
> 
> Merged to master through riscv/queue.

Sorry, I was busy with something else and I didn't have the time to review
the series until now.

I had a look and it looks good to me.

Thanks,
Alex

