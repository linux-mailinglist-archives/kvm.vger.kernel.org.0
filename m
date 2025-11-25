Return-Path: <kvm+bounces-64546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 28110C86CC0
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:24:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 13508353AFC
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A101335575;
	Tue, 25 Nov 2025 19:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cYtag8H3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="s4z14ezq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36CF33554B
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 19:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764098484; cv=none; b=ne/i7Fx8tlJCij7AaWo4EP7i4UxdoapVORoKoMLJne3zDkqLQBHCbJPx8mqebzq3UXyXXR46c82rLYeZ0c1g/TPKUa4Drq7ZO9bOyTIrswwJuJi0n2YRAXR7QgeBxoB1iIEEQrndQ3IyozcrbiPCnmTflUUMwOtEj+8N8YGth+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764098484; c=relaxed/simple;
	bh=HqayHoP1kvtY/gdJ3minqrH9s9nn7eYqWOg3b1zRuDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eqv4QyXV4bXnlrYvgZ/c0ND2AHuAmZVh9HHcvRKw7HBzLlBHxsUkuBRr2QBdU4pZnheTIRz2++aYkCSGFBdnqih1HiXAjLVLgkEv29ZLaKXDl6EZ3u31GvLiodRmUWnQQlb+7OuVH8on6rfdCTTk0hV1z0ArUoIoFqwjS2nee4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cYtag8H3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=s4z14ezq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764098481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6qx6sgcmtbzfT8nlrCbJjKmeKver9dtlckhLCSjjEuU=;
	b=cYtag8H3IKTGI3qw1xoA4MtxHAeh1ZiAa7nZOIJrEIGKbQCiWy1NvfHqqKuVMzVtgiyJVQ
	nlh5ScAEu04g5av8osRkPBbmEmNsmPFYdu29eeaddmZJYzQP4cVhFrPI76Tsi8pV6KocGp
	8lSQ8J4jm61k9E84hRMiqKiLvXaGFrs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-tZgs7On8PSapVGlhIEVFug-1; Tue, 25 Nov 2025 14:21:19 -0500
X-MC-Unique: tZgs7On8PSapVGlhIEVFug-1
X-Mimecast-MFC-AGG-ID: tZgs7On8PSapVGlhIEVFug_1764098479
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b24a25cff5so1411959085a.2
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 11:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764098479; x=1764703279; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6qx6sgcmtbzfT8nlrCbJjKmeKver9dtlckhLCSjjEuU=;
        b=s4z14ezqOlM0RNI8K6CUTrIlP4K3o2L3IV47hAOpMOZqauiirSVwp9jRnhzk53H7Pq
         adzBZYOU0a0lOzUfpKwsb1p7cVKZUTZnW+jW8r9F/7OWcZQMeksdz1LfcOzpJaXcu/BA
         ioPzOJNqTcqAYXzFruGJlQtjSgrAshjlXkDUxXRc7gyMBJeXH+yxC5XC+O5ybhYTSDNn
         ygdgm2ZS3gJQF4JIg6HgFEtIgj0Boihl3nUuy7/sbbMjUQcFuoQSbsBoyWlx+QhvtmgZ
         QQG3k2S6vg2e454izDUg3ENDhBfx4zaTIcK8wls8FT+rVIFZ6GP3zCUC9RX777k9oy0H
         F8CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764098479; x=1764703279;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6qx6sgcmtbzfT8nlrCbJjKmeKver9dtlckhLCSjjEuU=;
        b=HXQHktbS5MSVqcSG6OtNVovVzS7C8kttKU+tOH+LXnXaZtjmpNoI9bTQJD8ZOw89WD
         3Zc1ARINCu7dCp2JW4+Y5C8qZaB3sZr4xWfAuPWFxfCYrHLPL1d8sdQv5H1BLUznRfe1
         z8PVsW2tZ7YTg8yo29bcb2SqWMsYOTGNXWakFuswTKLK/ujSw4KKXnuspo9Sbm2eiz4L
         RB1cYr9veJ3U3MZM5Yibvb58JS31iyqhqJAZHYQqQh/ZaGJ7OCI4I1l/9mhN/b1J0WJh
         NvgCLNB9mzffn3m4Fjm7zcagtFaWvvOmRz856ok0H7jDoZg1wa8fQea0qfNiwikIuf8A
         gEzA==
X-Forwarded-Encrypted: i=1; AJvYcCWSfGctO3W/kB9wkvw6gg/j34V+8/MtwnFZkAow/0VwOYYpEriaqTzrvAh1yyP3JSN4B50=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9o0x5wjpC8l8GvoVEXytOBsREM9hHoxh7U3Bt+1Gi1m9K/b3N
	SwiT/1/X4TxoFjlr595iyEcm42JNUq5FoYwE+rBEyNEu+n6Y9C0kQb9ek8ysaiEVjgYykmQLegC
	m2TK6bNftA2zKnoWWiyH9/xgTpwNJr0GEunWkHQvoo6+iIV2bqzEhug==
X-Gm-Gg: ASbGncs+qr9NNe7zPJ5bOezxO4JVJc+DnVAVBNgmwWKSPF0smoYjt3wWCxVYW6uomkn
	0sBDlGRPoqCJ8tVuE7iI37GMSBQWfRu3KQfW9zXjepc/ujBIYEtEoPnDjMMtPCHUZdGU6hVFlxw
	wqnSEWpcDimP+VS/j9AKUgrxpJ8K3UyQOiC3pueC74Y1x5nNGn8obFTRijKMeb3VdJjZ1TmET31
	Gr+MeMDwaHhuTydo0+JAAO2sFvAA4jvz16kr7SEIRpfVGLd/Rm3fY2hN8cuR8cAaDZNYkaeieJT
	KRn7lei/3OIBSwwpisgStrW5il2ZcS104rVsJoNr/t9Ir3a8kXbrNkUSdccyurQfhq5302uDyK3
	LieE=
X-Received: by 2002:a05:620a:700b:b0:891:9bb6:6b9c with SMTP id af79cd13be357-8b33d4cfb76mr2360728085a.44.1764098478781;
        Tue, 25 Nov 2025 11:21:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCwC+zV9ilL/kZYBgogz1BW/k0XjgDzjkTt78Ehqb7OwOZ4OSkjcxPe6SUz84vf0wVoVyZhQ==
X-Received: by 2002:a05:620a:700b:b0:891:9bb6:6b9c with SMTP id af79cd13be357-8b33d4cfb76mr2360721485a.44.1764098478205;
        Tue, 25 Nov 2025 11:21:18 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b32953735dsm1226353585a.24.2025.11.25.11.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 11:21:17 -0800 (PST)
Date: Tue, 25 Nov 2025 14:21:16 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH v2 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Message-ID: <aSYBrH_xfMfs6yDW@x1.local>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-4-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251125183840.2368510-4-rppt@kernel.org>

Hi, Mike,

On Tue, Nov 25, 2025 at 08:38:38PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When a VMA is registered with userfaulfd in minor mode, its ->fault()
> method should check if a folio exists in the page cache and if yes
> ->fault() should call handle_userfault(VM_UFFD_MISSING).

s/MISSING/MINOR/

> 
> Instead of calling handle_userfault() directly from a specific ->fault()
> implementation introduce new fault reason VM_FAULT_UFFD_MINOR that will
> notify the core page fault handler that it should call
> handle_userfaultfd(VM_UFFD_MISSING) to complete a page fault.

Same.

> 
> Replace a call to handle_userfault(VM_UFFD_MISSING) in shmem and use the

Same.

> new VM_FAULT_UFFD_MINOR there instead.

Personally I'd keep the fault path as simple as possible, because that's
the more frequently used path (rather than when userfaultfd is armed). I
also see it slightly a pity that even with flags introduced, it only solves
the MINOR problem, not MISSING.

If it's me, I'd simply export handle_userfault()..  I confess I still don't
know why exporting it is a problem, but maybe I missed something.

Only my two cents.  Feel free to go with whatever way you prefer.

Thanks,

-- 
Peter Xu


