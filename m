Return-Path: <kvm+bounces-49582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D867ADAA28
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 10:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B86818842AE
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 08:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F973209F45;
	Mon, 16 Jun 2025 08:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQ6DkCCA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5391433AC;
	Mon, 16 Jun 2025 08:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750060899; cv=none; b=XxofqKggDnwrUg6ewa1qhogJCLimg5/OgCyaZPRm0dV8rGFT7ZVRz/DHYx2LfM77m7afQYuqm9Lze6K4LI2j6uZet0Q4G6i7ZEdOeZJ8U3jtmRLbnsuh69FTgRX1f3/P2Ot/OFT6RPH7E7EG0a6H7j4/8LHKxkzF9HvtcaIoFLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750060899; c=relaxed/simple;
	bh=qbiuABhOHw9jCScXy7wSJQIDHq9uSZO6sxDl4pZ+a4c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o3s2Bh11GByQmq+KaYPDw40Dl9XCb1s9woxFdaoAHaEKvYjeL3CNZO7s82tILxF7njHbSqVAjO8UeqR558pS4wYaCLURW6qJL8Frhtjof1ZlzSDvbKZKEpzpV9esr+iBY68S2oDqX2QJcRcdPlwEfRgaGlaJmlGT/oT81RijAmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iQ6DkCCA; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45348bff79fso10992435e9.2;
        Mon, 16 Jun 2025 01:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750060896; x=1750665696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8rjhe62crpddPisDTbWMw9CI5pB8pf5ptQA0xBtkwno=;
        b=iQ6DkCCAnRvMVRPI/cFYj68wmsbSonMgYuXVbbxRaYtWr84XrGlGEdMzDB3IdM0nbD
         3Pdt4zDOnMXiWcwjOn1lhWMwttw4cA0rjyVzCAsc6hhdHZ0IrrYHyfrAaY7DK26clmTn
         LSBvHfAWuGHvOasHSDvIHed+a+cGxdLxPN6eURHXUyCC4w0uYfvzRvVzHCv0MV+WqlvY
         cIjQqhSssgsoUzz09hwF91uVmuEpIVaTeFy26piU0mCTfNTfBtp5xOs4sAouB+1pE5Cm
         9kSJafOScQlxD9A+/wNRBAoO6zIE1ohEoQ8MxcMb1hQYvS0HSsEnA8heNAFXh6KhekI/
         3dbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750060896; x=1750665696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8rjhe62crpddPisDTbWMw9CI5pB8pf5ptQA0xBtkwno=;
        b=bPzBy27yGibfy3R7itDe1qQGab2uXwlIFuyVSC/vL6BqzjdZmbYlFtRRPn9WFXLTsu
         ILV884omU8xT3VC8V9asrb/nuGhGJrQvYyqNSC5omjfQ2D5lS6L6fDuIrie4upYsObwe
         t1lOgI9hEjMx8A28DWfP90kcKNn0yiKfWmeEF2ekC6cMJ/IWrm2jJWZ4wHdj2+ET0DhK
         tmLYa3FoGxXN3KmUTTS5qqB4AxgtdK6JYjuGnGcOvfpEr6lfTmRS1Vq4+PGc8A71OTRq
         4ePAzY3FLTk8kKh3HDAr2/2lAevPWNDRwW7GlZsRw7Ox/61wkzXO3Hb/Y3PAXnmf+z3t
         Sg/g==
X-Forwarded-Encrypted: i=1; AJvYcCU3Zgh87fI8F5nXUHhkqcrkj7OsHTWD6sY4xN6osVrbQy7mcFF2b0oRKShX3fJpvlzrE8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEC6qvmnt7Fj98wHsiiVk3AqLci1ayMFmPpPyLIorNN5S3dOvI
	wfxvuUri8UrQZ5l0Z+VsAftE/WDFThOxFAPv9xxks8NqNWLS5TBQLYNsrj2K+Q==
X-Gm-Gg: ASbGnctFxbHjt7e2cYQdXLLelI6zJ/4rWLzmbq4fGOB/MguzWi5TkC6WmveB3gGbDpA
	Ex652YeLHgIDdFfOC6jsKgPLPyH51au1klTUurjSkXcyWCFgzBIkQjot8RkEtaCUQ86q6o1IWGV
	0d1etlOfMVoDP9lT1GJzCAYmWXK+mx8m5H5pvAuA0J9kX9jS4GhFmqK2wx1YS7o4KE5AAK4xh3X
	2oK1YfyKo+XzoYB2F1aWw5a83xPJI5UiSs3esqR5/ZMEe2d2uZ5i3L4RxlFtNtaTr1dIEucuy5e
	96wFUqWZSsFVrqSmPoaTAyEb06QDMoulIMJTKDALlpr6euJf2VFLoMXDYh22Rd5Rol2BPA0fsCG
	tPNNHdj8iVShj7IwrVyf7oisc
X-Google-Smtp-Source: AGHT+IFxUzw9tvO6IMyaRp5Ig3addvgyu6ghA4/maMlkhudC6AOZXyedgOso00+fPoolrpIVZvIyoQ==
X-Received: by 2002:a05:600c:8509:b0:441:b19c:96fe with SMTP id 5b1f17b1804b1-4533caa3d54mr98453155e9.10.1750060895713;
        Mon, 16 Jun 2025 01:01:35 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b62ba7sm10525383f8f.91.2025.06.16.01.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 01:01:35 -0700 (PDT)
Date: Mon, 16 Jun 2025 09:01:34 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Alex Williamson
 <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>, Jason Gunthorpe
 <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>, David Hildenbrand
 <david@redhat.com>, Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 1/5] mm: Deduplicate mm_get_unmapped_area()
Message-ID: <20250616090134.476427c0@pumpkin>
In-Reply-To: <20250613134111.469884-2-peterx@redhat.com>
References: <20250613134111.469884-1-peterx@redhat.com>
	<20250613134111.469884-2-peterx@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 13 Jun 2025 09:41:07 -0400
Peter Xu <peterx@redhat.com> wrote:

> Essentially it sets vm_flags==0 for mm_get_unmapped_area_vmflags().  Use
> the helper instead to dedup the lines.

Would it make more sense to make it an inline wrapper?
Moving the EXPORT_SYMBOL to mm_get_unmapped_area_vmflags.

	David

> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/mmap.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 09c563c95112..422f5b9d9660 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -871,9 +871,8 @@ mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
>  		     unsigned long addr, unsigned long len,
>  		     unsigned long pgoff, unsigned long flags)
>  {
> -	if (test_bit(MMF_TOPDOWN, &mm->flags))
> -		return arch_get_unmapped_area_topdown(file, addr, len, pgoff, flags, 0);
> -	return arch_get_unmapped_area(file, addr, len, pgoff, flags, 0);
> +	return mm_get_unmapped_area_vmflags(mm, file, addr, len,
> +					    pgoff, flags, 0);
>  }
>  EXPORT_SYMBOL(mm_get_unmapped_area);
>  


