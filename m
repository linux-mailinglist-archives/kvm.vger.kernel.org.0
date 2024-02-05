Return-Path: <kvm+bounces-7982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4C9849751
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 11:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D04271C227AE
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 10:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70061171A7;
	Mon,  5 Feb 2024 10:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4I6Yo5p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38242168BC
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 10:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707127526; cv=none; b=Np3Jw2vkAQSTHiWUNMA0VYyDx99xB44nONRtkhMnuSMzSOl7h7idfrRqjbbhBwGF5OGbYEqt6c9xQweSevQxZJHK1ZPNdtZZItWBrYj+sRxQaU2ZMXb1niGkfa8YD84GGcG9LHdDQlWsJ242MkqrCHMRH1KC5X+ofIgW2hF0DzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707127526; c=relaxed/simple;
	bh=FvTH7ce4HO+MqDVbYAWd4QDxi89r1l2keNPhU6hTSXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WqCD2ZJMpG6QDJFvBdZuvkaqxVg0zJCx2ARDgX3/6STV/r1qeS1t5IDwzmpdWRTdOddXBP1KslDW20mEzQGVqD5rKh9GTWIZ485nLB2djJdBykgpyzGqOU66YMfGnAC4rwvz7B6haenjy5EEk2UztJhU4RT6Ltmw3hnjC6Fcyso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C4I6Yo5p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707127524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jI4PbEn5bcHDGLMbu+52VQdT8MjOytUlCwJj0kXdfq0=;
	b=C4I6Yo5pRPtCxQG1Goc9bR4oZu65w37wGVf1rVcE+e0O4b65tHy9DlVE9IP3GzdpESOIul
	d5MhdGd4E1n9Hoyk25QPHihQ67KMNsKlsbvlBkhnXbutAG4ELBh/p4XwTNLeTF6jm9fZVE
	tl7BCyu5uYqQ6uR0vDqXcMMWR4bssGA=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-u0x51XN9MBinnYNvWqu9tA-1; Mon, 05 Feb 2024 05:05:20 -0500
X-MC-Unique: u0x51XN9MBinnYNvWqu9tA-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-59a5911a619so1143079eaf.0
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 02:05:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707127517; x=1707732317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jI4PbEn5bcHDGLMbu+52VQdT8MjOytUlCwJj0kXdfq0=;
        b=sCrgfyNKT+VHAYRq89uPWW75Ef7tU7Ma8IXSKHt/eqQs4rExv7gm2gsXMWyvVsyuP9
         R+r49JarfFUM4058yvGNLL8ahZwzdQo4Kd5hXZXjvvXQmZDiE1hWTXHOj1IaEC4lBXdY
         k8UsDyCdn8GNXzmszT4XFACtsnYaHEHLg1nQDERsZIYCGZhcXMrZTS6E2bhVYKKGysmv
         gxn32HsTUcg0Xs5rRiwrvj6dPiTuioGazZfFQi5dwprnwKF1p6OTozOgWoi0skDQuLs1
         z7CcCG+k9XAzue2CjTcXdDGT/SXv77nlvP/2ztY4q6lkJ2GAJrQhqtyEM/bxufVvzi9J
         jZ4w==
X-Gm-Message-State: AOJu0YwaVXf5ZxHfo0BcWnYP68V8kU2vJpfpQvMVtDT3PLM2x547Tf3U
	MEE3T8FP1qNwlPkxRz37p/0jyyz1HFEi4OcVCVMY0wGhfjxd6njZDqh9pHOl9tszCd57xvbUUoM
	E5/QEqS5XkAfRZThCU3QHAPpRDJKdSEVoaNaCiR0NY1ZIfmj73A==
X-Received: by 2002:a05:6358:7f05:b0:178:8c44:aa8b with SMTP id p5-20020a0563587f0500b001788c44aa8bmr11609009rwn.3.1707127517663;
        Mon, 05 Feb 2024 02:05:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiFWsiQYdb+lDxJj9dP1Ofli+cct1oipaMqfiulBEkAd5tnxRnsurpAwy4aMkIYd4YQ/WWQQ==
X-Received: by 2002:a05:6358:7f05:b0:178:8c44:aa8b with SMTP id p5-20020a0563587f0500b001788c44aa8bmr11608992rwn.3.1707127517378;
        Mon, 05 Feb 2024 02:05:17 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWoh+GzuRpjT9/ChYsEcK+q66hd4k8A3L/hx8CrGu0JVnDMkwpxykxZvzLQm56gLNHyyW2QTFnYegJxMsbcIVEXxSfXKKkWFO2nSjmi1/GPommUPYVDwDhPiiERdZpNku0MKXfJPD+LZq3Huot7R9CzYHxOgBN/+jWfnVymDFMMLyV3b2ftw/Z9fst/RoIahjBqxzjK59flIllJIPhksB8/CkqDPhUVsg==
Received: from x1n ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id r9-20020aa78449000000b006e050c8f22bsm230160pfn.207.2024.02.05.02.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 02:05:16 -0800 (PST)
Date: Mon, 5 Feb 2024 18:05:02 +0800
From: Peter Xu <peterx@redhat.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: selftests: Fix the dirty_log_test semaphore
 imbalance
Message-ID: <ZcCyzrUhXSlhKyqC@x1n>
References: <20240202064332.9403-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240202064332.9403-1-shahuang@redhat.com>

Shaoqin, Sean,

Apologies for a late comment.  I'm trying to remember what I wrote..

On Fri, Feb 02, 2024 at 01:43:32AM -0500, Shaoqin Huang wrote:
> Why sem_vcpu_cont and sem_vcpu_stop can be non-zero value? It's because
> the dirty_ring_before_vcpu_join() execute the sem_post(&sem_vcpu_cont)
> at the end of each dirty-ring test. It can cause two cases:

As a possible alternative, would it work if we simply reset all the sems
for each run?  Then we don't care about the leftovers.  E.g. sem_destroy()
at the end of run_test(), then always init to 0 at entry.

-- 
Peter Xu


