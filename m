Return-Path: <kvm+bounces-65118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A37C9BF9D
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 16:36:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55F813A8F77
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 15:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2432676DE;
	Tue,  2 Dec 2025 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WTFs57X9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bXNttpwi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5F423BD02
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764689776; cv=none; b=gJx1PxEwOE+luxTo4K4ULFLg/ijJ6XVdgCtMoxTfJb4SnHliL7u/SCZfxEcMTTJCzGCZ4BvtyaTriN/j7HIN9ktqdlrqsXBTmmVc8Xoqatge9nhP6DcIdCGyaDDr+AaaUpzMcxofTJFwxVaTh0NQso45cegxTcCSOwWAuca6eFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764689776; c=relaxed/simple;
	bh=i3C3bUlfDJDSJz+UEgqncbzEDCMJ04lynUCqoI5h7Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aakAkqTmNvl1KeiGFZINH6qhucoUdyXFCyq0cM58TYzKHT1THa7Ak52SpZwRKbcD9tREs1OjJh2uzu9mc63NyTQU88N/WChddgLMgxv2lMFUbSwilHm82zUWlSIwea/eM60fBq5LAGJ1K0fFmHujVIpO3ja22RuEin5M+Ilzwd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WTFs57X9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bXNttpwi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764689774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YeUhnIQnNrHzJpcHAzDpdS8MH/0dybZ954xw+b5apLM=;
	b=WTFs57X9AdPDzKYIOZdKJkcWNCjIBeO9kN6T6Vb+RH/5S4HoZSkbZQfypdGoLQjeszKCv+
	tBiYKP4ZX0pP3cQrKwoafynYFiecHftHgNgFQfmPdt9KsHyXBVZidAwmJPlrzRDnsXPhQD
	X0CkXFroCZrtkjDsvw1kRWh3ZVW891Q=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-iSFues1jPt2fZELwCoa3iA-1; Tue, 02 Dec 2025 10:36:13 -0500
X-MC-Unique: iSFues1jPt2fZELwCoa3iA-1
X-Mimecast-MFC-AGG-ID: iSFues1jPt2fZELwCoa3iA_1764689772
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ee0995fa85so135190461cf.1
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 07:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764689772; x=1765294572; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YeUhnIQnNrHzJpcHAzDpdS8MH/0dybZ954xw+b5apLM=;
        b=bXNttpwic51dPVpgUGsg7JohE924HeWKXleYn93pdrvXRmKPqZdN4GD9mAqOaCnKpX
         8O149A6cFJgWkIjk/uPvps0ThD5WUMIFN3C8EiZFaZhI4NXODZQVhZoKD+bmJ/PEWYIS
         v9JIW+BVBcUZJSlpu34opG+lrww3TJEqIuOm48Us9Eb0jMWXJ201jT3LduSIVQZbtVYT
         B4flYcAvSqaRq+MZNQqh9apOl8MhiV9dpGoedSqJwDUf/zJ2oN+8hR2MVXVf8f+zfQOV
         aMpNTx1GZeJShYby59mb99irnAkxXpfHXzsyeCQORx4RGkBBWNCGoKSeA4AWZcTYjnRa
         zv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764689772; x=1765294572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YeUhnIQnNrHzJpcHAzDpdS8MH/0dybZ954xw+b5apLM=;
        b=hBXHig50jaQHohn0+Q3poKrLHStoVayBa9cxxBQMQNkvJItWsyVLJWCj9Y4mo2SKma
         AcrDzTfO4PGYyodsWxanu8NB6Xj2BOTH4KOyA+8qGl3P3Fnv1EnPz9kE/7U24EARpxSq
         Dazgc3IL1Hnl8mlQKPMXwyN/wx+kke6J6IgmEqCrN0nIH6BaVaFTl6r5TmlukcXjO47+
         xnEQ/u2wCKWvtwKDkexTl3PMRZ9ZSRi1C60hNLO0676vyftNkgAVXULWQ3ExFAq8WCHJ
         dU7TOJp06BCU4U+f0tjgwoYMN57Nn048dxx0emVdeTCgweNSWQ6S95gLe+leQATSe2Rk
         4oyw==
X-Forwarded-Encrypted: i=1; AJvYcCWkiq9CeT7dWV63fyjxLVwqaGsUoRI+zLNU/sHqbcmixMOBaJLJ8e2Y/COQN9uIrfCLH+c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXb13jzUsPvhlNiXk1aaYDBR5wYamj9bIo80btJCdnqT81TKcE
	sMvRxEcODbwUYX8XGt6Q4svbnqt+ysHkQeCNrnic1J7NSZXJZTefUNtDT9xU1kXi1as3WnpO+wr
	Bu2gBklNolmmv3k3onxH6ZJx0l5jTflFkftw7gTOG4TDD38W/+BhS7+qzdNXE7g==
X-Gm-Gg: ASbGncvfMVIsSLYFhuCv/6Bp66dWNgqkmlrT7CLe6gg6Wik1TsMe1T4qv2Kp9bj/GCc
	y1WfkkdomNr+fnYs5FFOV/rR83NHBkvJw6ObR3dn9jpWGf5SMVmjaQFzl+YFbipVWzlKc4vh6Wl
	UwnogKDrayaP0HL4XzN8i12q6rh8ASRauuP6CqawX5A+WJR+Tb0ymJfVPZI2nGf6ADz6IebRAfR
	K6TNvDAHk0BgTaYT0jeOmqlJ3Wc8APsSCbzorbmxFNoZmhLZDRjGtuku3ARfwhd0a57xpQuDUFZ
	3xdWOz8f59TyN6shkVn9cz3+JlXX4Dmhc3jy6V5VQ+9PPuwfnRV2naAlTVAXYYFaJ2Uq7uifw9m
	gVpM=
X-Received: by 2002:ac8:5a49:0:b0:4ee:41b2:91a6 with SMTP id d75a77b69052e-4ee58b066b0mr583360601cf.82.1764689771723;
        Tue, 02 Dec 2025 07:36:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLXfWGfXaBCM5txXHiaHxg/MnHqIkbYXvhInhcx15cakUIHeqTAWdqvhhC3SSFQ3wIt4nqmQ==
X-Received: by 2002:ac8:5a49:0:b0:4ee:41b2:91a6 with SMTP id d75a77b69052e-4ee58b066b0mr583359971cf.82.1764689771231;
        Tue, 02 Dec 2025 07:36:11 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd2edcebcsm95292531cf.0.2025.12.02.07.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 07:36:10 -0800 (PST)
Date: Tue, 2 Dec 2025 10:36:08 -0500
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
Message-ID: <aS8HaDX5Pg9h_nkl@x1.local>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com>
 <aS3f_PlxWLb-6NmR@x1.local>
 <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com>
 <aS4BVC42JiUT51rS@x1.local>
 <415a5956-1dec-4f10-be36-85f6d4d8f4b4@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <415a5956-1dec-4f10-be36-85f6d4d8f4b4@amazon.com>

On Tue, Dec 02, 2025 at 11:50:31AM +0000, Nikita Kalyazin wrote:
> > It looks fine indeed, but it looks slightly weird then, as you'll have two
> > ways to populate the page cache.  Logically here atomicity is indeed not
> > needed when you trap both MISSING + MINOR.
> 
> I reran the test based on the UFFDIO_COPY prototype I had using your series
> [2], and UFFDIO_COPY is slower than write() to populate 512 MiB: 237 vs 202
> ms (+17%).  Even though UFFDIO_COPY alone is functionally sufficient, I
> would prefer to have an option to use write() where possible and only
> falling back to UFFDIO_COPY for userspace faults to have better performance.

Yes, write() should be fine.

Especially to gmem, I guess write() support is needed when VMAs cannot be
mapped at all in strict CoCo context, so it needs to be available one way
or another.

IIUC it's because UFFDIO_COPY (or memcpy(), I recall you used to test that
instead) will involve pgtable operations.  So I wonder if the VMA mapping
the gmem will still be accessed at some point later (either private->share
convertable ones for device DMAs for CoCo, or fully shared non-CoCo use
case), then the pgtable overhead will happen later for a write()-styled
fault resolution.

From that POV, above number makes sense.

Thanks for the extra testing results.

> 
> [2]
> https://lore.kernel.org/all/7666ee96-6f09-4dc1-8cb2-002a2d2a29cf@amazon.com

-- 
Peter Xu


