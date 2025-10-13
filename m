Return-Path: <kvm+bounces-59932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C481BD5C0E
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 20:41:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 483634EC4FD
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 18:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14412D77EA;
	Mon, 13 Oct 2025 18:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w5tymBBf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BC02D5939
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 18:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760380897; cv=none; b=H3sgWto26CnREWpuyWBy/tJrXO102YkucUduebamUA0ZqTMKjicIKZlyrN6Y46SisOsbU43GaC/w8zxFD25ip7TQTysXwuCt4h/C689qMEFYbMNthgFvwYxB+SlqfLAeosQJvRWFQZbcRA0V2NrYweWdWIygszS0eyfh0L8ox5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760380897; c=relaxed/simple;
	bh=iHfqM03svX+oQ66obSqo+eRScW0vFuqHkVSUnLn2398=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kdQ6m2TN9oc/pdvgl50cnODVwg8mHnZ9eovchcSyQZqsLn8BSMciQIxCE9iAv1rz8WMeYMiOpPuxrKjGtmXZyxvXPTOUSkD8YN1yMms3r8PJYkMZlIHOlhEhs44EA/18y2oMaAytQl8F08lPyJyDeBkdgjqYv6+23idGN7UEzWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w5tymBBf; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-62fa84c6916so24698a12.0
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 11:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760380893; x=1760985693; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHfqM03svX+oQ66obSqo+eRScW0vFuqHkVSUnLn2398=;
        b=w5tymBBfENAAYOJbrpESjxEEnYBrFspQtO6lya2gBf0ylx1B/FqoOVOTBfPe60zayX
         0SKhYlfkUNLx8u+t6licarE1ywGdVBZR7O+bh1gxRKs1qBedRKQNJlu0fosTBVnNHpES
         4JcPwfqgSsCBa8Kd6laQYAScvPZCcJo4xWxmLjAPFatCGu0cK0RcvxgXtlRaN6sJYBw0
         2CeqIfP6Q8tx6IU+WVXyYjLqsGR1qNlMEWYKhv3mdBlnDFPO1Ytt9mt8It+aW5A5MzQV
         DuoV4Judew7/7WAKm6N/+fKPX/py4lBgetGfmucEj5Ttpz9/RJ+xNBW/8u8+alhYGIaG
         CuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760380893; x=1760985693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHfqM03svX+oQ66obSqo+eRScW0vFuqHkVSUnLn2398=;
        b=RTuMDs/coxrFl4Rl/0cw8s1I7ZDW/7cm3D7XEit482edx+hjD2I8Pps+NMtAlVI1gq
         S0JhzZNGBHPsYsnHTi1GA6qBvvOI8VwzwNplvqFBnrW2/LRE42+Rwit9f1SY5jd2gSoS
         Ed/ABlysagHCbuIWOzNfASJixdYkH19RvPZsCTmZLS4w/VH9kDjl0atU3s3ZFz+EEmWR
         0GJvDHC72QesWhPbQBJPyNfMlZal2P+6duoznnbVGqU3kSKwKIcOn8bNUrTWdJZxVYcH
         h/SLTfnARZPftnGQr0HR/t+FnnWNNuPzKgDKnc5np1v+PnInqmOACHPyMDF2VBpcyNxr
         1Bwg==
X-Forwarded-Encrypted: i=1; AJvYcCXaKHVOuGm+tMJxFFTnr72SXOwXjxuQYb0SIFVErf4QW9dT7/KpDuSKUkVNRYF/gCotmyw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj1i4IZ26exeCkT58E6Aa31BLE2qfz5UTuCKhZOoHRxa3SGiyL
	dd+lDVpJ+Q8JMJL3AD1eRhihkyAAXw7NgRpDgcOvSReoZdreE9h/BkikUZe/8LFN3ygKyIdZqto
	JrhfgT0fXAAyQpZRtZkbHJXuRL+1TvAlBBfAXmVBi
X-Gm-Gg: ASbGnct81U658JlKxDighxIxyXISI4Aj9Fw5lqnhxCMYWJil9hzk0cdfOMce7db/arx
	yG+iAZanRMf0gEYB2mFU/Bw57FmNkcvdW8n2W0TNiLgaiq1He2/+i00n/DNRIJJv+i7BPrwwY8e
	fiuczu+qz5mf3pN5L87hnjYOD/noncZCURxKPTIZe8LLhnxNP+z8tSjxa3gIEYAtYIkBNswSEWi
	DJD3xoYoLssvzjS1cDCRrseYYmtd6N4CiHnJ8QjIqk=
X-Google-Smtp-Source: AGHT+IFbmLphFAx+O5iG90iX9HogRPWUiCByGZx68PKNe1ZloAu/b3Rao00A/sjzsen7DJqCgwzu5gI+Pcc4So+lDH8=
X-Received: by 2002:aa7:c397:0:b0:634:38d4:410a with SMTP id
 4fb4d7f45d1cf-639d51d0407mr545062a12.2.1760380893401; Mon, 13 Oct 2025
 11:41:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev> <20251001145816.1414855-10-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-10-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 13 Oct 2025 11:41:21 -0700
X-Gm-Features: AS18NWCalgoEMzCEfvMZw9n2fvq5F7tQ5ti-oUsJw3mE6SvX8KE83Zr7Sx3VYNI
Message-ID: <CALMp9eQacZ-hE3ePmWy2-ct1C56vs4FKR=HnFj8-=Tc3G3NVPQ@mail.gmail.com>
Subject: Re: [PATCH 09/12] KVM: selftests: Move all PTE accesses into nested_create_pte()
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 8:05=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> In preparation for making the nested mapping functions work for NPT,
> move all logic that directly accesses the PTE into nested_create_pte(),
> as these accesses will be different for SVM.
>
> Stop using struct eptPageTableEntry in the caller, instead pass a
> uint64_t pointer (and add an assertion on the size to make sure it stays
> correct).
>
> Calculate whether or not an EPT entry is a leaf in __nested_pg_map(),
> and return the address from nested_create_pte() to __nested_pg_map().
> Also, set the access and dirty bits in nested_create_pte() for leaf
> entries. This matches the current behavior and removes all direct
> accesses to the EPT entry from __nested_pg_map().
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Reviewed-by: Jim Mattson <jmattson@google.com>

