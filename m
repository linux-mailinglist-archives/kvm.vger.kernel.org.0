Return-Path: <kvm+bounces-55386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A6BB306A4
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:49:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 16CBC4E6805
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31640374294;
	Thu, 21 Aug 2025 20:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rn087/J5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A20D374289
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807889; cv=none; b=eDxYZII/sWgIAJtNpH4a0YWzanh8yl8z7GpaC0Q5EI+Lb6345JXx0Mzzzb56QJpiFJfxQVRbSIP80cGwwSC8LRwjdmz5Dv8MWi7cc4GzcKDdcKmSVyOz7emyLc/TI+zLERVK85dVaAvXT05qk5Jzbz4NLH13pp3P271vBnIxStg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807889; c=relaxed/simple;
	bh=oA3XFTq+X9InxrtY53OI1FqTpqPTKR+1uoMqvtlA0+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ABpzs2iQydAl+kT909YdeZ/0zgcCwwlr/K1pfM8yCsBldULqApFD1xC8Hdicq3Jo1gf3ZAxh+ieHn5XaywtwLMwAPm0gYjcLAPs41lu/qGBOc7CnLBS1nF6f2tQu007vczbBH9xKMVUiZMqqZ3R9YAvaDlKFNI3bS3ddraWLNh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rn087/J5; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-53b1718837dso603914e0c.0
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1755807886; x=1756412686; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6aeG3+zXNcZH2d1Z1/su6zkQOg7Uc4j3Xw+oqie+iPw=;
        b=Rn087/J5j5FyNm4Qob+9GCqTtp8pQbHjYbCRu64LYME9nCB/R8OdClXzzaa7a+/uxY
         ujfPt2eRSJw/WeMN0EQF8as3k6xLpR5eUf3rYsO8DckcIhSxFOL7+S65CbXwcqa1jcr4
         iB1ovtPyDAUUI5rkLx/QO2uZ3EMX/16guNRXo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807886; x=1756412686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6aeG3+zXNcZH2d1Z1/su6zkQOg7Uc4j3Xw+oqie+iPw=;
        b=IPYP+8FXdk6gqgA9MmxUZjGzjCSCrE1GvGx/aS6dmrT0Hl7yUZDjJy9v12ixky314H
         t+PMo/tuAr7W/En5CcfolEfnIq1oONqVXkckzM/vz9sFtpmuv/Dppy0mHuaTai2y2Csf
         yfUL4Ti+f+wQ852cVyRCh1Q+R6LHQuECU3tkjQXrjg07I7HDE5v5vNNOebtiIgAPYVte
         53rmRkkQZaB1iTMoE6JNWp3pfep2SLHm1bsROxkj3g8THKR9hTI42FSLXUSlTb9CXrqn
         hdnDaH7JNw4PPUZEKnRKVFP3U2lrR3JdaPMBw2WUfEP/EM+8vG8fzqASZEWowZ8S0QHQ
         GnuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxvn5g9hyjgdtUIJhrbKw7Lv503J50vwNlBQfgEWOyXW1eytUQVKqlLxL4vVkQms37pW4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYJR+8mtfWRie7yLyad29m13qEFWjW4h8jp1fFD3yhPAo+WEIG
	eaJFnLLoSm8DqODZsZy7qvQ7b/m/Qa/Qi6td0pXRam2ul4tHzOQcCwQ5fkcpx/H4SzMoXzBUpnq
	ZBbD8wrg=
X-Gm-Gg: ASbGnctExfn71akNZ/rpi/zEe2edrSFmo2e2IWiDFfIHB9NMAIh0ambhIq4MVSj7Z9I
	+JY+SgM5VR0b9VRR6mNtIPrWebCc3w5OMQJxyq7AEoP7jQdjIr9VyhNy2/zf6bVTBz37M4b6uYC
	koyefmIbrBEyhSBiTWkheWB0SqiIiXCISVDlF6mzwhQVCyS7bCiQVkkO8tGB8uBKK3Rd6uN9K6Q
	30/8UZ8W1i/06vF31iabRNoMHIBj7XWOAuZS4X68Te0D6Y+HphkAa8x8agLev4CL8E3SKTPHjHm
	ia13zzDratb6xHYy3/5Jk7nIP6Mv4jknBUzmlALzq9WDKEnNs+z1tzFuiv/E2Cm0fcv4R/TeSnS
	rfSYtWEcuOOj5prHEu1tMv6qSlggLlgL0aDXvyGN3G9Z0HkkLlLX0b17PRSCj2QkTBbakS880co
	QsLNRnOvHn4F/Jwfilvc5WWw==
X-Google-Smtp-Source: AGHT+IHvvZIdAY2mrk1q9vdsnBEznBMfJJnchYe813TAUxKB+j1X/3lEJjNM4gALs95rFDtbVkUlPQ==
X-Received: by 2002:a05:6102:3e1b:b0:4e5:8b76:44c5 with SMTP id ada2fe7eead31-51d0edcc3afmr172450137.22.1755807886305;
        Thu, 21 Aug 2025 13:24:46 -0700 (PDT)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com. [209.85.221.180])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-890278edb96sm3675015241.21.2025.08.21.13.24.45
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:24:45 -0700 (PDT)
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-53b174ac3e5so531255e0c.2
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:24:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW907SXcHU1EWc8UHAZRH/vymeoag9Z2r+RNGUkojtkSZxu5I12hjH2t6HGKOuZeeVRSCM=@vger.kernel.org
X-Received: by 2002:a05:6122:1ad2:b0:53c:896e:2870 with SMTP id
 71dfb90a1353d-53c8a40b923mr212315e0c.12.1755807884664; Thu, 21 Aug 2025
 13:24:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-32-david@redhat.com>
In-Reply-To: <20250821200701.1329277-32-david@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Aug 2025 16:24:23 -0400
X-Gmail-Original-Message-ID: <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com>
X-Gm-Features: Ac12FXxaZhwn04a0gbwY6rjh9UGLxnRlGOG0Jy0WjRbVAG0UxLDqNy0Wydj0GQk
Message-ID: <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com>
Subject: Re: [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-arm-kernel@axis.com, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 21 Aug 2025 at 16:08, David Hildenbrand <david@redhat.com> wrote:
>
> -       page = nth_page(page, offset >> PAGE_SHIFT);
> +       page += offset / PAGE_SIZE;

Please keep the " >> PAGE_SHIFT" form.

Is "offset" unsigned? Yes it is, But I had to look at the source code
to make sure, because it wasn't locally obvious from the patch. And
I'd rather we keep a pattern that is "safe", in that it doesn't
generate strange code if the value might be a 's64' (eg loff_t) on
32-bit architectures.

Because doing a 64-bit shift on x86-32 is like three cycles. Doing a
64-bit signed division by a simple constant is something like ten
strange instructions even if the end result is only 32-bit.

And again - not the case *here*, but just a general "let's keep to one
pattern", and the shift pattern is simply the better choice.

             Linus

