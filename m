Return-Path: <kvm+bounces-51641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA834AFAA69
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ECB417821D
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF0625A337;
	Mon,  7 Jul 2025 03:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="M85gggbz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB847F510
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 03:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751860389; cv=none; b=fp8RHWl2DkDZWk9eWcTdk6pejDqXMN+3wt1k/m9tEqBClyaUBJijOFURKI6cZJio4NBslnJd1wrLKciQhS+AmeMHVsxWMwq66cSIeRg9Gh7nRFB95Zrj0rXhUEnjT827eqoINOF1uGBTZx4m0Zi34J6vLxwwk8izpcQjnp1Q4O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751860389; c=relaxed/simple;
	bh=/fve97GTd9bXitqStqnzD3wq1Emy4aKwuUyvzEethf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyY+1TgxgD0lSw0ET4SrbPxg4UJSNWNQhJE2MRSYf6j9mOLpUH64qQUQIXQE3+M1BUCAGqd59ln0S55MKFm6PRHK9inWQo0VoUWBnNC3DAZPYde7ZzcRpyYplmkCOKq81LxCv3KVpdfYPxKoUQGtfagiKtsB5WYjkEqIaGU8t9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=M85gggbz; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b3507b63c6fso2803499a12.2
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 20:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751860387; x=1752465187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mub7PjK+ZQMm18cy8qNtEOXQgRqk+RrTOpKNrinRMis=;
        b=M85gggbzleyl75AKcW75Gr+fuPYxB3zn8bnX3qIGBLkv9LG8oewUWUfCFns/SZFqP+
         ZHipB8vpt8/6TrgOmIF/4+R3m/1M6uhLUmXb3GlY64fG/Ttf3kaUlQ0OYZu6PsHP/tPv
         WWt2Jg1OiS6yTlUYN6OO4zaC/Ofrnqc+iEKetJvVbGYJfMHJrSDgH+ywo+Y86RPk2G6i
         RKNj3kY0CMZm481x66rqyXoqOfIGRdcMe8hwjjztBUzmMnGZsMpoQzPf5g105pYR7Goc
         msHLyKrGvglB5pvrpcVbEJ5NQZFQLwKSne3SRK94zoEfYdELnd2ktZrspdqpj7hT7ohQ
         3NrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751860387; x=1752465187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mub7PjK+ZQMm18cy8qNtEOXQgRqk+RrTOpKNrinRMis=;
        b=LNV4aCLPbwzt/M5VLjuVZQatikR51XtpvLW80DxXaMSczSWmTayb1rVyXjpJ7TLPjk
         UVezd2QU5zAfDhRuQyGp2KuSrpDCWllLJpa1b/kJAcadt6neJgV2jNEVMZvu09xedMsO
         /tx/31eVMZAYdVMYabVXngaS4kI6zw95tf0HvpBdu0aRYp4WqyXVI5aQemGCEs+mIFz/
         VYEg23MohA2biEzY+EkHPfzO4NbLuQtLDCOwOZ73Bs5s9CJEIbrziFvRIctXy7KPIgJ+
         rfS46rWR8+6JrUdR/uzMeJlegxWi8fFWCFMjJunES6QnVp2Zmm/ACl7jrE5ARJrBi4Cb
         EgBQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+Aw2v8rFQ8W/NIvnpbmvn0pIyFR6+k+r+a88G2sGB8IH5g4aACD4+qHX0QUBlMpoFQqc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv8TP+sOhFQSI/BE+NOWdBR1rfKMESfx0wZSSO3dOq5z5CqWyp
	rRzsvuUYG05x6yRBj8dCBNXSu5jGj63Jp7vWAXn2/5Cxk6b9s4PZC5gvD2ko+s9RVzs=
X-Gm-Gg: ASbGnct3U4NH1g3bPToZwo1RFc/YkSzaC4Z81zJhcCBQj7vjz2BRDe1wnjtC3JJxkgm
	QlyFbRnNacXoE0l5pTJ1q/Ok93Ak4Fx2ABmUrjQgrwJI1pvWDzBg+9Ii6mfl+UGoPyht9zb395z
	EG0GVgTU8aoZslnV0c3o/sS+zFhgNWKW9lfjg/BkNngvm45/YVeSw5hngZDBodsdTCWPyz/gseO
	23Z4mqANsUCB+5U75x5yvBmfv6xuckjRebJesC9PBPmE6+BXH6WkDu4BoYCLL6pYlcuGaZUKnAQ
	iImkbFiT20IeLFJXhV4s79TOJraHyQXJxycm/yph4SVZ76z/26rzzlfu2/ZO5M0gDxigNdiY2Vw
	L2shLtSAAHiX/w3UHV/0ebcc=
X-Google-Smtp-Source: AGHT+IFtHyTBc6qEYu6hdCH6cigb35sVn8qLgWaMfVrg0MupVPG7/z/yW4uRvdyfX28do9yc+RvdzQ==
X-Received: by 2002:a05:6a20:6a0d:b0:225:defd:26f0 with SMTP id adf61e73a8af0-2260c92da99mr18422851637.32.1751860387103;
        Sun, 06 Jul 2025 20:53:07 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.6])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee74cf48sm7538658a12.77.2025.07.06.20.53.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 06 Jul 2025 20:53:06 -0700 (PDT)
From: lizhe.67@bytedance.com
To: lkp@intel.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	david@redhat.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	oe-kbuild-all@lists.linux.dev,
	peterx@redhat.com
Subject: Re: [PATCH v2 1/5] mm: introduce num_pages_contiguous()
Date: Mon,  7 Jul 2025 11:52:59 +0800
Message-ID: <20250707035259.61640-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <202507050529.EoMuEtd8-lkp@intel.com>
References: <202507050529.EoMuEtd8-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 5 Jul 2025 05:19:34 +0800, lkp@intel.com wrote:
 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/sh/include/asm/page.h:160,
>                     from arch/sh/include/asm/thread_info.h:13,
>                     from include/linux/thread_info.h:60,
>                     from include/asm-generic/preempt.h:5,
>                     from ./arch/sh/include/generated/asm/preempt.h:1,
>                     from include/linux/preempt.h:79,
>                     from include/linux/spinlock.h:56,
>                     from include/linux/mmzone.h:8,
>                     from include/linux/gfp.h:7,
>                     from include/linux/mm.h:7,
>                     from arch/sh/kernel/asm-offsets.c:14:
>    include/linux/mm.h: In function 'num_pages_contiguous':
> >> include/asm-generic/memory_model.h:48:21: error: implicit declaration of function 'page_to_section'; did you mean 'present_section'? [-Wimplicit-function-declaration]
>       48 |         int __sec = page_to_section(__pg);                      \
>          |                     ^~~~~~~~~~~~~~~
>    include/asm-generic/memory_model.h:53:32: note: in definition of macro '__pfn_to_page'
>       53 | ({      unsigned long __pfn = (pfn);                    \
>          |                                ^~~
>    include/asm-generic/memory_model.h:65:21: note: in expansion of macro '__page_to_pfn'
>       65 | #define page_to_pfn __page_to_pfn
>          |                     ^~~~~~~~~~~~~
>    include/linux/mm.h:200:38: note: in expansion of macro 'page_to_pfn'
>      200 | #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
>          |                                      ^~~~~~~~~~~
>    include/linux/mm.h:221:33: note: in expansion of macro 'nth_page'
>      221 |                 if (pages[i] != nth_page(first_page, i))
>          |                                 ^~~~~~~~
>    include/linux/mm.h: At top level:
> >> include/linux/mm.h:2002:29: error: conflicting types for 'page_to_section'; have 'long unsigned int(const struct page *)'
>     2002 | static inline unsigned long page_to_section(const struct page *page)
>          |                             ^~~~~~~~~~~~~~~
>    include/asm-generic/memory_model.h:48:21: note: previous implicit declaration of 'page_to_section' with type 'int()'
>       48 |         int __sec = page_to_section(__pg);                      \
>          |                     ^~~~~~~~~~~~~~~
>    include/asm-generic/memory_model.h:53:32: note: in definition of macro '__pfn_to_page'
>       53 | ({      unsigned long __pfn = (pfn);                    \
>          |                                ^~~
>    include/asm-generic/memory_model.h:65:21: note: in expansion of macro '__page_to_pfn'
>       65 | #define page_to_pfn __page_to_pfn
>          |                     ^~~~~~~~~~~~~
>    include/linux/mm.h:200:38: note: in expansion of macro 'page_to_pfn'
>      200 | #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
>          |                                      ^~~~~~~~~~~
>    include/linux/mm.h:221:33: note: in expansion of macro 'nth_page'
>      221 |                 if (pages[i] != nth_page(first_page, i))
>          |                                 ^~~~~~~~
>    make[3]: *** [scripts/Makefile.build:98: arch/sh/kernel/asm-offsets.s] Error 1
>    make[3]: Target 'prepare' not remade because of errors.
>    make[2]: *** [Makefile:1274: prepare0] Error 2
>    make[2]: Target 'prepare' not remade because of errors.
>    make[1]: *** [Makefile:248: __sub-make] Error 2
>    make[1]: Target 'prepare' not remade because of errors.
>    make: *** [Makefile:248: __sub-make] Error 2
>    make: Target 'prepare' not remade because of errors.
> 
> 
> vim +2002 include/linux/mm.h
> 
> bf4e8902ee5080 Daniel Kiper      2011-05-24  2001  
> aa462abe8aaf21 Ian Campbell      2011-08-17 @2002  static inline unsigned long page_to_section(const struct page *page)
> d41dee369bff3b Andy Whitcroft    2005-06-23  2003  {
> d41dee369bff3b Andy Whitcroft    2005-06-23  2004  	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> d41dee369bff3b Andy Whitcroft    2005-06-23  2005  }
> 308c05e35e3517 Christoph Lameter 2008-04-28  2006  #endif
> d41dee369bff3b Andy Whitcroft    2005-06-23  2007  

Thank you. Let's move function num_pages_contiguous() below the
definition of page_to_section() to resolve this compilation error.

Thanks,
Zhe

