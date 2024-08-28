Return-Path: <kvm+bounces-25271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7490F962D52
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D8B5B2398E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F661A3BB8;
	Wed, 28 Aug 2024 16:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jIjx1vJB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CB813775E
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724861452; cv=none; b=OjNB+oHVrnd4lIKIcHR3Vx+bqOsYDMB3qdVRr4FilEairun1gInKil6UWB7cypsT3JqWrnTIuxEL0ljR1aVA52nOrSsvNWLdtm40CPXKs7XsjrfVeZsxKinKaydBo8sR3tzvVXI2L6whdCLvGntu6GXoTliWbkBcbVTU0TJs91w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724861452; c=relaxed/simple;
	bh=pUxW3H51tdCti7975tz1MGr7ixTkv8/Vj6O0jDTq5hM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p+up5bzwPyN1l1ZOON6ADhoeJfrkdLXO3ktxTuJSHJ2OV5IsPLXxhpD4GYxmxiFE8G+YUlDMHhyS8rwH2wZqyepD2HMByOAiJWbfj7OuSXlTuMOrSRVHxkCV6mQTZHaHJLgLDAbE7bItxeaF91DqZmyelFwjiYdRPKtZf8mwAzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jIjx1vJB; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-427fc9834deso70715e9.0
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 09:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724861449; x=1725466249; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUxW3H51tdCti7975tz1MGr7ixTkv8/Vj6O0jDTq5hM=;
        b=jIjx1vJBh3p5OZbqQ+ZxHO7j4xRxIIQlQZfA3tuV9sX3QG4AntHH+Hv2BYiKE9ZrRQ
         zme8QX/hUQmZmWipREV7nGqT3f6k9EQu3On9vC8NXBY2mVXM7z+XTaxF11HKHAPfKYA7
         iZPYyhndGaeRcb/WBk9tbv3xkLf6ej2uK/E5CpRBO9z4OfSaJ5ivVIfToF/ELhPwP+B7
         rHCOb/BB+P0A6j23E0l3dpJGGf0flFFRjklzSb5FQpM7VgSxmFCKwqY+xOB1QLcnsAZG
         gR6+xXOGNFgOo9CjFZ15y5Dkgr5TEUyPvlisHwWXUPtGdPsgKRVb5nR2MSRRH4Lvz35b
         mR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724861449; x=1725466249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pUxW3H51tdCti7975tz1MGr7ixTkv8/Vj6O0jDTq5hM=;
        b=J0fFUkn+vuqlQbOAWxK9VqcvTyqGLMRHeTtz+I81FJQLcjnGxvMlL/pMJ83EZYQl6o
         LNR3H7vzIxwqpUwbKkIyWESOMOk5z8fC646CaYxjCmp35qzMbgWxsR5hEv+4HseMfbnn
         aIAEkYiZunmcNcWh6tLdctq2Mh8IiCbbbPckD8YO64eLLZmiZq05ZZ+5I+gR1xhRyvkl
         wfV+Xs+QuIVawEC7LsF4KkPuO5CK2Sqwvl+Sc32WyuulVho/HJP4ZQsd5N1ZbE/UVJIH
         UMDMSWh3mHRTa66I6Pp62MHRGqByp2tmd7KlNhOw1Igd4QL4BUtgLQ2HuOHltZIdjd8w
         8Xvw==
X-Forwarded-Encrypted: i=1; AJvYcCU9WMc2objAMNMjGZV3dIYF2+FrgIvRCqgw7YDKMoTYeLcJvdCCXEsppUTKiaTzpy5uCow=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7gpMZlajTTN1Zwm54vt+bOr48yMlV/iWbBcnNINr6JhycrfGb
	Lt77PiGD3hu2ZaBXXXdIOScIIAvl9q1RVtsFclcZ8Qog22PiwyqQnw8C5/x8rIbzOwWIoj7O7d3
	HdzGKsahx9kWosNLb+rchMyyw/c9BeYCx4MIt
X-Google-Smtp-Source: AGHT+IHtbZb6lBm6dWZvdL70hryO/pm9b4DtbL7TjizNJ7LY01ZIlDL96COPc9v/E4sIswiSF687/R0RG3k7W+e1uXo=
X-Received: by 2002:a05:600c:54d2:b0:42b:a961:e51 with SMTP id
 5b1f17b1804b1-42ba9611004mr714685e9.0.1724861448603; Wed, 28 Aug 2024
 09:10:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826204353.2228736-1-peterx@redhat.com> <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
 <Zs5Z0Y8kiAEe3tSE@x1n> <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
 <20240828142422.GU3773488@nvidia.com>
In-Reply-To: <20240828142422.GU3773488@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 28 Aug 2024 09:10:34 -0700
Message-ID: <CACw3F53QfJ4anR0Fk=MHJv8ad_vcG-575DX=bp7mfPpzLgUxbQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Borislav Petkov <bp@alien8.de>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand <david@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 7:24=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Aug 27, 2024 at 05:42:21PM -0700, Jiaqi Yan wrote:
>
> > Instead of removing the whole pud, can driver or memory_failure do
> > something similar to non-struct-page-version of split_huge_page? So
> > driver doesn't need to re-fault good pages back?
>
> It would be far nicer if we didn't have to poke a hole in a 1G mapping
> just for memory failure reporting.

If I follow this, which of the following sounds better? 1. remove pud
and rely on the driver to re-fault PFNs that it knows are not poisoned
(what Peter suggested), or 2. keep the pud and allow access to both
good and bad PFNs.

Or provide some knob (configured by ?) so that kernel + driver can
switch between the two?

>
> Jason

