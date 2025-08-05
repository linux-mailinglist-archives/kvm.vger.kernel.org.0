Return-Path: <kvm+bounces-53988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7484B1B3EB
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:01:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64CAF3B788C
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44321272E5A;
	Tue,  5 Aug 2025 13:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hLE7vWa3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ABF21D3CA
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754398879; cv=none; b=LWUa4h5t7MVu/+p9R7DQ0ooVl1vlzFTAVMjV2xBmEUlM231p9bryXl7Zxls4MDZ5s5A7KxMezhbquvWkyMOAWmq8L0Jz0KUfJOH46Xe2O1o2luExd8eMLtdDusC4lPBh4QXSwqpmrD9uLR3c88l0mOaUZGnSL3aBOHzOd6KTxpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754398879; c=relaxed/simple;
	bh=jCINSY02b3VcKaYR8JyLD/p2mOf2EtH7q4vBP76L8iU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TTDKHWk/Fg+o2lcTaMuSNQ+962cxPn8rr0p2E3TV6wIwze9uP96qzba4CJLZtyMtOVBOUJyWgIFGoHv6dgCzT1J5ekhtKj8Y1YhTdvrI7xT5PAWqdVqyD1GZO2V3vma1W4OL76uhbikPro7/2hfNrXVE8WItpVAwAjOLGlH2wBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hLE7vWa3; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-615aa7de35bso11734006a12.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754398874; x=1755003674; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fjxzM+Wf4qtRYVaNCOW0++JtZ+DW7avxmv36rBvNzbg=;
        b=hLE7vWa3MJrOwJvt9i03WIhL8Iuua/dcqiqTYLFQwTWI6/34BXJZcdfZ5hY97Wa6AP
         sQft/YpIJA5RWYJDKutxow7mS4M4KiM1CSKJbu8np9YdDk4lnNSNZZDl10IE+hk/3xmz
         1GrSa+8eB5nYMrzdphnSFB4wHXXyTPwzXD0QI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754398874; x=1755003674;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fjxzM+Wf4qtRYVaNCOW0++JtZ+DW7avxmv36rBvNzbg=;
        b=maGBWUUwNQcDwefEfXVLuE1cHGyfD+lNDuYIk9+ev9mlaQknERj0XzXzxsisDBYn7E
         EZP0qATQhGI+otVyx9lbgzHEVVLsbV4IALqcHATsoG5TEPFk6W/8YYwjnT7jE3UIfrsE
         7rJhzhHXOoDFpb+gCRMognSoGa6Je8Wr7HWy/TbSzbbi7+M5y1v9C6IGRSRS7I5YCp5B
         Hnyiq0n8IUDO4t+2mDc8ja6VK8iV419nvgA6/W6lR0+vypfMUuIQqFHqBf40bPkYi6F5
         J67XtdxuUW7M+L8GcsRHMQuagR9uru45g3NAQ9owWqAIcQHulvovPsUNZsEEedPa+UbL
         eOvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsVTwts2nNTr242oA6lGA8xvCClIFwNNTLPgF/pHQHlI3XIWQ8Y6q6dn/T5Mvt5Q9sXxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YweRfE8ID9XrP9b9fEMEfyeS6hoPqdV5W7IHPqvOrHoJg3DGV3P
	3qIGh8f/I8sQNI1+KYXQCJi3BH4kV0FIQ+FL8z2Mx/dXa4wQOyGl05OfZrsGrxsMS8YtoOynWsv
	0UP3MMSqrwA==
X-Gm-Gg: ASbGncsBAZIB3x/rSrqXIkHMvylYWJqWwEwBp3I3P++9thJWX3vlF8AXngNrreYfSsL
	FkumiuK29D9td9lt4RjpEHLcCnMQfGyG4MFZOJljh1vw9ZxQ+bzGY99TSVmHag570rLNE06n29e
	JY+eIv4d6YJlgNwiPQnUQKymE9lp0pUcn+TQ6DeLTK2cN7DEKTfTusAkJVk61aqw57OI7YNCGZJ
	czd8VQMs7HYsmlYNAGGT4Fe/UIBWAvGQOWoT/1pwDlk7eQIXfigFootkD9pCkjrFPSb+qEI7OMw
	ghT3VQXQSecdiXlhKO89UXSrFYETDW4eipSD0IfOQiUSgxfWlcBo1WJ6R0l+blAGllmWmhajKD5
	4tQtslrWyh0pthVikrA5b1z+1Y8nLPNRak+DyU1L/ISn/W4c9EKtCDpqgJkQEnvESOMqY0165Z+
	8NiZHeJUs=
X-Google-Smtp-Source: AGHT+IF9KWwfXrL5KRMdjxfv1vG91VwvqmsKTwU9BnfWqymBzNhY20zWhXzUetenbY/C7SY9z4WYJA==
X-Received: by 2002:a17:907:c13:b0:ae0:a483:7b29 with SMTP id a640c23a62f3a-af94020a369mr1348972766b.49.1754398872304;
        Tue, 05 Aug 2025 06:01:12 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f2c265sm8335214a12.26.2025.08.05.06.01.10
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:01:10 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-615aa7de35bso11733784a12.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:01:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVHMCO7ZDu9k8jFiqNk1nTU+GI2XcOztJJ7gF96KEU5cC5UK3E47LBIH6nC4drciyHNZT8=@vger.kernel.org
X-Received: by 2002:a05:6402:35c9:b0:615:9fe5:f9b4 with SMTP id
 4fb4d7f45d1cf-615e6f51419mr10235333a12.20.1754398870074; Tue, 05 Aug 2025
 06:01:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com> <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
In-Reply-To: <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Aug 2025 16:00:53 +0300
X-Gmail-Original-Message-ID: <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
X-Gm-Features: Ac12FXxoX_CjIAKtjLryo0sCU8BxLl8OrhQv0TcPGjBq_s03leh63xL_WcFm2cw
Message-ID: <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Aug 2025 at 10:47, David Hildenbrand <david@redhat.com> wrote:
>
> The concern is rather false positives, meaning, you want consecutive
> PFNs (just like within a folio), but -- because the stars aligned --
> you get consecutive "struct page" that do not translate to consecutive PFNs.

So I don't think that can happen with a valid 'struct page', because
if the 'struct page's are in different sections, they will have been
allocated separately too.

So you can't have two consecutive 'struct page' things without them
being consecutive pages.

But by all means, if you want to make sure, just compare the page
sections. But converting them to a PFN and then converting back is
just crazy.

IOW, the logic would literally be something like (this assumes there
is always at least *one* page):

        struct page *page = *pages++;
        int section = page_to_section(page);

        for (size_t nr = 1; nr < nr_pages; nr++) {
                if (*pages++ != ++page)
                        break;
                if (page_to_section(page) != section)
                        break;
        }
        return nr;

and yes, I think we only define page_to_section() for
SECTION_IN_PAGE_FLAGS, but we should fix that and just have a

  #define page_to_section(pg) 0

for the other cases, and the compiler will happily optimize away the
"oh, it's always zero" case.

So something like that should actually generate reasonable code. It
*really* shouldn't try to generate a pfn (or, like that horror that I
didn't pull did, then go *back* from pfn to page)

That 'nth_page()' thing is just crazy garbage.

And even when fixed to not be garbage, I'm not convinced this needs to
be in <linux/mm.h>.

              Linus

PS. No - I didn't test the above trivial loop. It may be trivial, but
it may be buggy. Think of it as "something like this" rather than
"this is tested and does the right thing"

