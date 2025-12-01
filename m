Return-Path: <kvm+bounces-65025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AE6AFC98BAD
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 19:35:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 19EE6341E15
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 18:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CD4226861;
	Mon,  1 Dec 2025 18:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqVRxi1j";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AJaPzgqx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54910221542
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 18:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764614148; cv=none; b=dO5iEfiIon1IlfbQeL24QpEJ73oTR2T0M3MVNjPZQu842KcJMB9BRZ6f+VxbSbXJ72PsK7kb0RGnMY4UcB82jZ2ki4TOMLNn70i30rlb/0RozUBCtnanw37h5ecZx1bmN1/oXzEN3Ao1/Tlufr2fYj9u9SkEpCMYsaWTLKxLOBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764614148; c=relaxed/simple;
	bh=7GnbR9QZqw7J2SMIEk6efP4FG5Tr7Ngm60EmLw+aaV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uf+A+fsxrBtq9xRZTilsjFFWGhpR5grZZRRHr+GErWIFfETX1hNMS3Zyt4tdNhRig+KRUp1z96kB7BySuO8hyAY7fh+2r7dUaXC6yJLHKcy6lUXNnXv4Q7ewZ+MySJCEaTLyEGRC3NjDzfcCCfiiN8DkWBWAhGjnvn+3m92pqKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqVRxi1j; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AJaPzgqx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764614146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+SbwtOZH9ducWOEZb4+vngRgdkRzNyQHiBzNVLWt3d8=;
	b=eqVRxi1j8UrG84k5Yc5jkSU+KBhRANs4xYuxCjpw6j4ZQz9+3ZEzKr91D1AaQ0ZSusqBUG
	pf37V1YgsvgI8Ao5plgpBk0jqfXLRnrfk7TgVQCAcrMl2xZZentUYqYl4HsQLYC2HJO6ul
	H5mwxKihVBPi07O7BiJTBrMUXExTeQQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-PjmVVtYyPlyaVD7OOBMMlg-1; Mon, 01 Dec 2025 13:35:44 -0500
X-MC-Unique: PjmVVtYyPlyaVD7OOBMMlg-1
X-Mimecast-MFC-AGG-ID: PjmVVtYyPlyaVD7OOBMMlg_1764614144
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8b17194d321so447206785a.0
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 10:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764614144; x=1765218944; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+SbwtOZH9ducWOEZb4+vngRgdkRzNyQHiBzNVLWt3d8=;
        b=AJaPzgqxtxamZP/Jc/2sOHUS9o2QlayuF4AuWdPdk+G7F70VcO7MK9QM87bS9YmVsk
         ULTQ3GeueQjel0frYtpXNNw8BDH7ioE3+DXxXuJwHr0Skm+ulQQ4DT7e1fPgAAAWcOvl
         dfuPVXmf6JqVcV+oOMQAEb/Skx9E2SWxfJZ5y/wNu4JbrrJYY08PJ0F5BXKLDU2wOdnI
         8z/jJS0wOfhkvDL2Otl0j9eR4TirhgUpvieiNWpx/W5tgNPbXRVyt03WTcxUpJ7NG+2Y
         yQ93wiWtSw4mCkSBBxr+WXSJfuC8fOVKMev0FuHuPyt9Wn67l7/RPs0epaOKJXM9gjEI
         8zfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764614144; x=1765218944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+SbwtOZH9ducWOEZb4+vngRgdkRzNyQHiBzNVLWt3d8=;
        b=A9XY/QkCR6M9Oz8GghiL84QLqtE7oZx17PIs/a0f/yqD3Qp61xlK7zlhUlf7qlnILj
         yfz+ZB5ivdS+wdl2UefTmcVEpadrm+zTDLdA5OvODA3j9kwueixBwgbcA/nWSaNYCFF3
         5vMPIGGTOv03BpZDCeUVNYDOXB5X80QYfFkuqbqwbPEuT3tkZcS1tHBsEj7nLHjGpSzX
         gMx3Fejpe5+Kv7h3fEkCrhyNLZP+oj8MC1SOSf8RjeWKjd7PUHd5IJuWFvoeiGScXoWu
         TgnMoYp+XcZKF5e0hPIl7T5MqkY/2ms5ygXHiGzaKX/BpdP0dA4wcYSc9ET8X25rHcpB
         tRvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvJZkNnbA7gJ62gzsucnERlb/O6ekOXQ25rmsn3rrKAc9kZSxjvyilQ/znFuCuPIV2jrk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQnslPH7C1B5hzdYbSQXx//oM+Y+Z1rEJGHcH3EDcj9WQy4Paq
	eNflRLlXm7yFlzSybhp83hkNYC9DRnXLEg6E4eMC29nnXSTgBrv9oxRfhH8ihDOXSYFOb5avVvX
	9+VZm0onR8GVA+RHCCBbiN1ToC2TehI2PI1GLv1EUxluBwBWgq1zDUA==
X-Gm-Gg: ASbGnctQswzBpS7/wAquA7pasHvs5SUi1sUjSNYbpzT6impP6QHT6IMTbxanw3d7yoz
	lXQewrQXGu+kQEgvn+eSaBB8NGMCRk2Fqre+mamtxa/HajLDp2n7k19RODr4XEHmKW9BDHQRCLt
	DCQ06KyQ8jgN062X5J/cIECSctyhXh9k/DtXIBskfttfaoSi9VwXxWN2zwxdliZgPQUqG50JhYg
	qCqSutQsOM29BY3d5WVG8A2GA2KABR7ceu62vRYoy3iHxNHcsU5OClLwKpXpvIxUyNLd/AbWsrN
	BxJpMSE+SySXhJsy3uz+GDv+h7OS6Lc6Uw6+1hTR6jMGT0LsghrfjuXJlXxEX8qZ2y9rmOFPySE
	j+FY=
X-Received: by 2002:a05:620a:4047:b0:850:b7ad:c978 with SMTP id af79cd13be357-8b4ebd9eb33mr3684777785a.49.1764614144199;
        Mon, 01 Dec 2025 10:35:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHc/IAOaSDf8i1YjJ+6md5JjMRZyr0e09X4B+I8m0ASlSLeFoGocESiXm6l1ZZbPYuAyWGexg==
X-Received: by 2002:a05:620a:4047:b0:850:b7ad:c978 with SMTP id af79cd13be357-8b4ebd9eb33mr3684771285a.49.1764614143671;
        Mon, 01 Dec 2025 10:35:43 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b5299a69d1sm898568985a.16.2025.12.01.10.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 10:35:42 -0800 (PST)
Date: Mon, 1 Dec 2025 13:35:40 -0500
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
Message-ID: <aS3f_PlxWLb-6NmR@x1.local>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <553c64e8-d224-4764-9057-84289257cac9@amazon.com>

On Mon, Dec 01, 2025 at 04:48:22PM +0000, Nikita Kalyazin wrote:
> I believe I found the precise point where we convinced ourselves that minor
> support was sufficient: [1].  If at this moment we don't find that reasoning
> valid anymore, then indeed implementing missing is the only option.
> 
> [1] https://lore.kernel.org/kvm/Z9GsIDVYWoV8d8-C@x1.local

Now after I re-read the discussion, I may have made a wrong statement
there, sorry.  I could have got slightly confused on when the write()
syscall can be involved.

I agree if you want to get an event when cache missed with the current uffd
definitions and when pre-population is forbidden, then MISSING trap is
required.  That is, with/without the need of UFFDIO_COPY being available.

Do I understand it right that UFFDIO_COPY is not allowed in your case, but
only write()?

One way that might work this around, is introducing a new UFFD_FEATURE bit
allowing the MINOR registration to trap all pgtable faults, which will
change the MINOR fault semantics.

That'll need some further thoughts, meanwhile we may also want to make sure
the old shmem/hugetlbfs semantics are kept (e.g. they should fail MINOR
registers if the new feature bit is enabled in the ctx somehow; or support
them properly in the codebase).

Thanks,

-- 
Peter Xu


