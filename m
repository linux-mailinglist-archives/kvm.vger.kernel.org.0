Return-Path: <kvm+bounces-41116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D44E2A61C14
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 21:12:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CE29460511
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 20:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C215120ADC0;
	Fri, 14 Mar 2025 20:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gyeAkaBo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B846209F3C
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 20:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741982670; cv=none; b=r1qkpUJv2UdpyRxPlKkYvQNS6cX04s+dqZRGnpJFb2k4mqPpwxB55Qur0Xt9v5PbbY7RVu1Om83hOTQlkMDQKfoTmfqWRMnlID3HO37nfj/yqxg2SXe3eSDP9tJjtzJfmiBk8vwXRd3a1PFHUNU/RxGpqS5OiEHmFiFwXMOygJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741982670; c=relaxed/simple;
	bh=+H598cocfIacpoV/aS/IeuVnKEx5ukzRWbUj/A1EjyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BsVPiqaqot5eOlOgxduQ1JAfnNU//9j5GdGClFSJ8nc8FnnL4+5x9mslZ+NVjM+navdfyopRJPmVdKk1tBa5nBTUx5kOVPccTURfBlRtzZQ1mmAhS4nfOBMKThdPffTvpTsNL5kzg5tK7NhYFegg3VivZb8w91ikuxSNm5JFsTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gyeAkaBo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741982667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SqRyL6MA+QupMYvedIjsb0gClHlzTIPhGP8UWlhlKow=;
	b=gyeAkaBog+/GesMhkwYfRPUO0bC+ylsoNBh5oq8/IviAr4UmmEvxnSsEoq3Ev6L7ksFq/Z
	x5Pj+3LeydFhUquy2EtJq7M5jaWc8K92u8x0N/cCnEyA+VyLMYngQWXjK2HC4vAxKhoQyJ
	oJbShA5eJ2fzvYbtHCHXPxW4qt1aCek=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-uN30gehMPc-kTR6F5iUMYA-1; Fri, 14 Mar 2025 16:04:24 -0400
X-MC-Unique: uN30gehMPc-kTR6F5iUMYA-1
X-Mimecast-MFC-AGG-ID: uN30gehMPc-kTR6F5iUMYA_1741982663
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6e91054ea4eso41937186d6.3
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 13:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741982663; x=1742587463;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqRyL6MA+QupMYvedIjsb0gClHlzTIPhGP8UWlhlKow=;
        b=wo/6xGYnxnkPEfHNQjYzLUfAPTe8Gh2iEdBdQYHZZ+iTMdQIrwbqZwD4CTowFe6VW9
         urH7bbLoxr5dw20GWylpAK6+kfB5JuTOIV0TxZhSvzdAI9wNpzHGsuymHHWUfTVWjlqq
         +lT9tcuZcHyQFTE1CSViJDLn/frpDSgkdQcoGnE1w1QPwkDoNZtw+/aZDjmUVsO+5Mhr
         XDsqXuyIdGX4VV9wNOCnANsgDKSlxqLbs0T0CZsqLejJejWqX0QkKbT0l/q7Yc6VitBh
         P6MzC3ZiynX50hBdWFuPmJBhycJJNhcXW2EbbOV4Knghw5sczNBO01a0bV47DEkGCdrM
         wErQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtF6qLTXyQ6Kc183iVsMy849Q34yQyAPWsdp92R/cAMOxqPXu7ElUzmo8UeRLDKWJequM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLbSfJKZ1drwOTGX8VeECPwEJNJBME/BPH8Wdf3MRCUz1LY/NP
	1V0cYVR+hCUzDK9e5+mynWnE3HlqlzERSQewFR9rsUoTpKPXQ0B/S4ZVBVobALXhUVqqrfGz2mw
	GmNg7DKQ3NlostU94U+lkvYUkaNeHQxNGpdtjb60Teu4uTxRVHg==
X-Gm-Gg: ASbGncvzFSU/R8zLmUCECoTVg2jr8uZS1vUY4to/StSx3RBneTul9PUUfQm/ngCwcHQ
	J0paLiRWouN+ep6gmCEnFtoSGEaPdn/EkwbWytfgnGuMsOiJ2pnQLZxBFmeychmWImx+RPFbgOr
	67Ji55uarkt2eyAsvxUolQwtFnJxO8v8OeGfgYYacdqotiB+k18RhEUQ5jK2EkdAP3jNukdWsHx
	HIehtr4Ff6wdDswFOjoFBOV0oG85K2+l4E7ymrcBGxa4KQmIkXZtN4gXU2iPNoXS23O6KhpBq5X
	NlxtREY=
X-Received: by 2002:ad4:5cca:0:b0:6e8:f65a:67bd with SMTP id 6a1803df08f44-6eaeaa1c6e7mr54402546d6.11.1741982663663;
        Fri, 14 Mar 2025 13:04:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdrnxZkVhHJCu+0L4gTXfr+cGtUYoXrRv2lUDPgB5Dtd3VDIpsWxWp29AXtnPsgwf8cd2wQQ==
X-Received: by 2002:ad4:5cca:0:b0:6e8:f65a:67bd with SMTP id 6a1803df08f44-6eaeaa1c6e7mr54402066d6.11.1741982663335;
        Fri, 14 Mar 2025 13:04:23 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eade209335sm27689416d6.22.2025.03.14.13.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 13:04:21 -0700 (PDT)
Date: Fri, 14 Mar 2025 16:04:17 -0400
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: James Houghton <jthoughton@google.com>, akpm@linux-foundation.org,
	pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, david@redhat.com,
	ryan.roberts@arm.com, quic_eberman@quicinc.com, graf@amazon.de,
	jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com,
	nsaenz@amazon.es, xmarcalx@amazon.com
Subject: Re: [RFC PATCH 0/5] KVM: guest_memfd: support for uffd missing
Message-ID: <Z9SLwcWCMfmtwDZA@x1.local>
References: <Z89EFbT_DKqyJUxr@x1.local>
 <9e7536cc-211d-40ca-b458-66d3d8b94b4d@amazon.com>
 <Z9GsIDVYWoV8d8-C@x1.local>
 <7c304c72-1f9c-4a5a-910b-02d0f1514b01@amazon.com>
 <Z9HhTjEWtM58Zfxf@x1.local>
 <69dc324f-99fb-44ec-8501-086fe7af9d0d@amazon.com>
 <Z9MuC5NCFUpCZ9l8@x1.local>
 <507e6ad7-2e28-4199-948a-4001e0d6f421@amazon.com>
 <Z9NeTQsn4xwTtU06@x1.local>
 <24528be7-8f7a-4928-8bca-5869cf14eace@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <24528be7-8f7a-4928-8bca-5869cf14eace@amazon.com>

On Fri, Mar 14, 2025 at 05:12:35PM +0000, Nikita Kalyazin wrote:
> Anyway, it looks like the solution we discussed allows to choose between
> memcpy-only and memcpy/write-combined userspace implementations.  I'm going
> to work on the next version of the series that would include MINOR trap and
> avoiding KVM dependency in mm via calling vm_ops->fault() in
> UFFDIO_CONTINUE.

I'll attach some more context, not directly relevant to this series, but
just FYI.

One thing I am not yet sure is whether ultimately we still need to register
userfaultfd with another fd using offset ranges.  The problem is whether
there will be userfaultfd trapping demand on the pure private CoCo use case
later.  The only thing I'm not sure is if all guest-memfd use cases allow
mmap().  If true, then maybe we can stick with the current UFFDIO_REGISTER
on VA ranges.

In all cases, I think you can proceed with whatever you plan to do to add
initial guest-memfd userfaultfd supports, as long as acceptable from KVM
list.

The other thing is, what you're looking for indeed looks very close to what
we may need.  We want to have purely shared guest-memfd working just like
vanilla memfd_create(), not only for 4K but for huge pages.  We also want
GUP working, so it can replace the old hugetlbfs use case.

I had a feeling that all the directions of guest-memfd recently happening
on the list will ultimately need huge pages.  It would be the same for you
maybe, but only that your use case does not allow any permanant mapping
that is visible to the kernel. Probably that's why GUP is forbidden but
kmap isn't in your write()s; please bare with me if I made things wrong, I
don't understand your use case well.

Just in case helpful, I have some PoC branches ready allowing 1G pages to
be mapped to userspace.

https://github.com/xzpeter/linux/commits/peter-gmem-v0.2/

The work is based on Ackerley's 1G series, which contains most of the folio
management part (but I fixed quite a few bugs in my tree; I believe
Ackerley should have them fixed in his to-be-posted too).  I also have a
QEMU branch ready that can boot with it (I didn't yet test more things).

https://github.com/xzpeter/qemu/commits/peter-gmem-v0.2/

For example, besides guest-memfd alone, we definitely also need guest-memfd
being trappable by userfaultfd, as what you are trying to do here, one way
or another.

Thanks,

-- 
Peter Xu


