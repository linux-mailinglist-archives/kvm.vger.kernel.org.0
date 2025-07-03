Return-Path: <kvm+bounces-51480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77E22AF7284
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:37:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D4541C844A6
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF0AB2E5421;
	Thu,  3 Jul 2025 11:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Vp/ex/Fc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C4C2E3B02
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751542523; cv=none; b=jSyt5T+7npYHaddvW3ZyIsZZzzaqDKXgCl3+4kvGQB+ARb7fjUrdVGpRFhAJhWx2N/OjFVRFlqCFwT7vVsHv9N/GrwNNME8XxLLEycl2FsiDBKwZzJXofGrlOw3S2RlyVj416sS2YP+CgHX2UkWaH69QnczEB1sMb6ikpZppjPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751542523; c=relaxed/simple;
	bh=49LA24cLdBXtfBo2L/H078CwoY9pwKgiR1lZ6ffAE8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBdfxQ0xmblB9WHjymt8oBpbaytdrGy0YfV1dKpyT8qUcbKfLhpcvT3gDmKdH6ZDvpuAQVr0HSECmOVsymE28cft67rX+QIEW5iJd3xyVCQV1DZmL44AYHXsYlL7l4iKJjJpKu4/M6xE0IedL2LgZZ5VpK0iPiQ6IdKW1bt7bYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Vp/ex/Fc; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-23508d30142so65744695ad.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751542522; x=1752147322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIC4vniCF6Jqd7vCiFRupPwWt+zfgF+lY4LJeYjZ13c=;
        b=Vp/ex/FceUlpkTv2zGSo1C/R119wc2WGt5NcZ8K0AcE5w0x75eSzzraltS5NKp1d6T
         TXaNS6bsuCMj5wQHTYQdjKRbJ7I4CZFhu4ltEMmEH4RLRdwsblO89PwHDFqe6hOx4TPT
         tkrydgbxQ4i1XUBioAxPUQ0u5/VSklhf+Ok6FmFJ9cZGyQTlPOnfMuNFXSb+CU5Y/JrV
         jogtqivkN7GaLdP7+aBhSSTQAf+q7xbmqYTGXFipdgbfc6FM54rb5/UyEx49Jt3JUd75
         0+4lRWnLA6z2liwZVAvdhvN+583iBiYY1z50OgI1Zq3mzE9l8BocLcPfDXok8mQcsj7J
         oQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751542522; x=1752147322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIC4vniCF6Jqd7vCiFRupPwWt+zfgF+lY4LJeYjZ13c=;
        b=MXbCJUUaLgfQ1TIdnrfpgJ/vu9SAZ/TrK6zoREudd07qhAWYGZoAJOgdxHd9eDgJoc
         kAE+IEzWZ4oc/MPbedL8GeLpBC8nOcqE5ZQVUoq9PfscMDL1Qxp/M8rrScltmrPs+H/J
         N+88C9FUjxk7L1NeNgnosGt3ly4exHWz5XpB6ZjtZHp6zloZejIuuf0+F7qMcN4YkPWH
         K9OaHMs7eS95SkYpTb+aKUrhXROKoAwG4YdDwFHFDTSpZzrC5ttstW3/UmquifXn3SKL
         wEgwLLXST6dzdmwOE5PaTsvwNxrwiZ55W6hR4GKqv7D5aHLPFWXCREDJVSBuH/1SOqR+
         SfXA==
X-Forwarded-Encrypted: i=1; AJvYcCWHJBcUZCKKutGp8cAFTVen/iTWrfIretf1BA1sg9mMM8mbLOzImtVbOK7CWAxmFFAyImA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8kSyQYOsBjuhAeM7mxgCoSuYiqjIDwDSNeiUitXqBG4r16+3A
	ol6Ac3gLjXtIsl9zot/w+50zXaNHEDW9hd/2cQH7+PHjrnCbnE9nHbKKbPh+HqmZ2a8=
X-Gm-Gg: ASbGncuFEYkBlQUv+wO373VRDaKobli3jQNXAqU9Q+nu4kyFjnmAF2vx8d/WXRkcZCu
	sTZv5SwGNSejbSCRG1OqMoxo4sNmXxpiZc4UAeebLlDkGAud5HR7RwlmBTiBpmnr0Yuj+0jHlP8
	X6U1FdjKToQNrkWELKrEn2uVRkU6K0ZVggc8lIYf8JEY2M4xk7c6mNXQ3XpppDUHq4L6NPE0o6v
	4dqPiPE2U1WlbES27RSRUnxONmtQdIzTFAJdA0+dPomka5CWXr45BCipLpngwsd/JXBnQaaGXAD
	BFL2d+8ihYLEPBNpSAyyel6lK00ndcwf71a+R6rkmsk2X9i1XhAYLHvVvNKD8+0b9MEtGjYP8W3
	5kWZ4jHRXD+zc9tnZM43aSUE=
X-Google-Smtp-Source: AGHT+IH36VF/CIGqz+2J2aqsF/vYGGyR1x2CSKcSaVSwMlw7fNYhqdolTNSbc3ljFBefYDzlONxU4g==
X-Received: by 2002:a17:903:1b2f:b0:21f:1202:f2f5 with SMTP id d9443c01a7336-23c79624058mr36281695ad.8.1751542521730;
        Thu, 03 Jul 2025 04:35:21 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31a9cd0ba3dsm2094455a91.36.2025.07.03.04.35.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:35:21 -0700 (PDT)
From: lizhe.67@bytedance.com
To: jgg@ziepe.ca
Cc: alex.williamson@redhat.com,
	david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH 0/4] vfio/type1: optimize vfio_pin_pages_remote() and vfio_unpin_pages_remote() for large folio
Date: Thu,  3 Jul 2025 19:35:15 +0800
Message-ID: <20250703113515.66745-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250703111216.GG904431@ziepe.ca>
References: <20250703111216.GG904431@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 3 Jul 2025 08:12:16 -0300, jgg@ziepe.ca wrote:

> On Thu, Jul 03, 2025 at 01:06:26PM +0200, David Hildenbrand wrote:
> > > +{
> > > +	struct page *first_page = pages[0];
> > > +	unsigned long i;
> > > +
> > > +	for (i = 1; i < size; i++)
> > > +		if (pages[i] != nth_page(first_page, i))
> > > +			break;
> > > +	return i;
> > > +}
> > 
> > LGTM.
> > 
> > I wonder if we can find a better function name, especially when moving this
> > to some header where it can be reused.
> 
> It should be a common function:
> 
>   unsigned long num_pages_contiguous(struct page *list, size_t nelms);

I fully agree with you.

Thanks,
Zhe

