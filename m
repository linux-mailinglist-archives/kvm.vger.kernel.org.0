Return-Path: <kvm+bounces-59429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52622BB4343
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 16:43:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26F857A1C09
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 14:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C308E312822;
	Thu,  2 Oct 2025 14:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jWjQ9Aj6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA6E3128A3
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759416219; cv=none; b=Iq1gsP52weW1FLBucZDGqCB7GoJog7RiC82l8HsVXm9wiJwmeJYMgSb0itW/1ydavEzjo/6gkWtWDEu+P43kCmh1MtjE9klkSb7RGAvQlbFyYwpZBIQBheuVrlcE8oEfM37FEGryslvRTMsjLPxSQa3PY1MPBc12rr6yBiUHTXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759416219; c=relaxed/simple;
	bh=GlgNCqSjZpjIz8IRKR6GJ4b9WqqQmb59lUmwQAT+azY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=El2SpilykK6CozOQykTqi0zOhYnDeJHe3j6NOoxONRRfi9ANIUctf1Xe75X/11qE2jF5Q+SwJXXPWdw1bdq6jEs1/1tfYzu6G/r+KhtIdJIV/sXR3qBil6UfYO9EJ9nFVJoBV9TwYmyHoY2nh2aAqPc5wNtALGc6ISCEf0R+cc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jWjQ9Aj6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759416217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9rrcUC+gzDyEMjCtBSzxmOK2Xsj8RXVs22FZMi4vvac=;
	b=jWjQ9Aj64ojOrIBFOPvuPkwsxq20uJ/dviAfkL6baPPKcYRyoj+EuDXJiIb7L7CSPBYvNe
	m2U4TXsLs41jAb7q4seRNTmLnIVTWGDhE/P9Qq1mJ2idh23dU0fYJNvoa7GJ9T8eMyxAuc
	gDJBgmbGO+ndg7ogBqRxA56tcuBL4I4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-DZLMpxHbNw-Qz_0JMb0Krg-1; Thu, 02 Oct 2025 10:43:34 -0400
X-MC-Unique: DZLMpxHbNw-Qz_0JMb0Krg-1
X-Mimecast-MFC-AGG-ID: DZLMpxHbNw-Qz_0JMb0Krg_1759416214
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-78e30eaca8eso37623526d6.2
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 07:43:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759416214; x=1760021014;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9rrcUC+gzDyEMjCtBSzxmOK2Xsj8RXVs22FZMi4vvac=;
        b=AlQ2GTfKsJ9N5EGxEZDGCRUeTArobs23nsy5A/N2/3aMkYK4BO/359Lw/F4ILLqIyC
         CAJrEIjP/MCG6p+iYP+CcDSSsypEpL2fDADepfakFuZsjZDEP89dwIkaynEKWA7Xzz0E
         HQkboiK1nyFZA/MALLm94EPJSorGCoi1OOKT7m/0oZsoegoq0+ZLauekalMqwpn2/8Wz
         oh3WEEy+OGsNAFj53LqmlsmyWwQuPnil9+SB2CD8QnflQeN3k9i8+2EFGGia8N6BzOPH
         IoFaC2Zd9VIcB2qTxyoIk22nDNUBZFjTAYjYsgHaTw/j0Os0wo/+1pSxQ+DC4uujbD9d
         9Bsw==
X-Forwarded-Encrypted: i=1; AJvYcCWau+MphklbKsGVLGDS9Vo9BDakIcvTKP+rgGvDo7GpfER43R26+OkCrPx1zz3801Mbqs8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5FJ6W8ihNVd37jRPKfA1nonS7Eq7uL2wj/OlwNRt/WhkjO+jx
	5cHMhF1rjIzDiRl/otK/QWp8CiB0X9pDO5S9XmPa7eKPgKh8hMR3oq5+Vssg17aDKEHq40AAhQr
	+Q+S7kQuWVIAmKUZiVA3QgceQy9lcQkJo8fNof8W5cfe6Z6h27Nr7bA==
X-Gm-Gg: ASbGnctyi3gOfjtpa1TjZGz1SV+QwgxFXq4ChyLU/x+vxiJWVG0YJO6tRjUTW6Z/MU+
	FcxTqKZqtEB1B4Up1beY29NCC/kew2mYcPOGyAOvDCvNPV4Yvba+3GzLfi5JL6ES+WilwoJvwCg
	Nb5JyY/P0M35Q3B3iQbF+qWG4/ywAm6goySR3VkcPLg/BJ7/F6GRmiEHArcxJr/MRQgcTmxPfcP
	iqH5nzai/jbUtHKHENK8Pr/djZeAqg2/XSpVNt06zH+xSLKVRLzlh+MaA+8qck1+QtBUnQzlV5z
	r2sQgEyc6UOVjwMAN/edfs9wbmn8LDSbvwNgbA==
X-Received: by 2002:a05:620a:1910:b0:853:20b1:cf12 with SMTP id af79cd13be357-873768a536emr1089056385a.65.1759416214199;
        Thu, 02 Oct 2025 07:43:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYhhy9AiOFVdgEwVsdNu041FmEbs4JKWJfK2nsAoYrsrPMBghvMcNluzdipR5aoQkuErP90Q==
X-Received: by 2002:a05:620a:1910:b0:853:20b1:cf12 with SMTP id af79cd13be357-873768a536emr1089052185a.65.1759416213751;
        Thu, 02 Oct 2025 07:43:33 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e55a84a055sm22561111cf.15.2025.10.02.07.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 07:43:33 -0700 (PDT)
Date: Thu, 2 Oct 2025 10:43:29 -0400
From: Peter Xu <peterx@redhat.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, David Hildenbrand <david@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Subject: Re: [PATCH v3 0/5] system/ramblock: Sanitize header
Message-ID: <aN6Pkeu_tb5giiPc@x1.local>
References: <20251002032812.26069-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251002032812.26069-1-philmd@linaro.org>

On Thu, Oct 02, 2025 at 05:28:07AM +0200, Philippe Mathieu-Daudé wrote:
> (series fully reviewed, I plan to merge via my tree)
> 
> Usual API cleanups, here focusing on RAMBlock API:
> move few prototypes out of "exec/cpu-common.h" and
> "system/ram_addr.h" to "system/ramblock.h".

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


