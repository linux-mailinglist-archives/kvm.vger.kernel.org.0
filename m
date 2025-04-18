Return-Path: <kvm+bounces-43648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E7DA935FD
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 12:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2882D3B362E
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 10:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3E92741B0;
	Fri, 18 Apr 2025 10:25:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947912222A4;
	Fri, 18 Apr 2025 10:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744971916; cv=none; b=Iv3Gc04y0cNkgkaT8GdP8EP0IGrwM6oRDX1pYh5fGzyIfnDWCcI5+pOCKjuFNx6URhYXW8zS3ab4khcv2TAm/K7DPFQUbb0vko+vsFJ1a/Xk6ZAd1FGOV0Oa3P7HsrbAXwolocJYsTpJUbBlGe31PvF95aPOOThWxChr//9KkGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744971916; c=relaxed/simple;
	bh=kcuQkKYCSl4USmcoi03BAP5hQffQY2sFSoVLQiTnuR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmhnF+O8WV2zHoralKps1f+pFHNdio8f4oNoPDotOQoQ3RMhjAoUm5Q3mGqD+c9H6/joz/TkzJyYLWroTKjYnzT4SV1nRqsw6fyNalsBHIKSGZdiMHGGySGefz1/CvFOHTO5aiXVZU+ihy7NHDfV2m7KAfZbUxG6HzInJkkb7VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-476ab588f32so23483001cf.2;
        Fri, 18 Apr 2025 03:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744971913; x=1745576713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XMi6RjNLnii56OiqqTtBYh/fDGXu3JBH/VNIF3fIEn0=;
        b=kwWkuJCvvIs4cCzEyLOzU2W2KTcSpk5lic6IQtPffPaBCfV+0mCrpfQ/8oENZjKhIg
         hgMETAHD1NEv2XFFT17aN/QdcEup+GZY/Qco531lZrWzHiWaxoHPzBwsIE+CDHTN6AiR
         KCsJC0/IhuL9V/gVxhlHL4pCkx0sglvgMfPyLosSe9W8aFm1Z9UpWpDNd+EgIoYLgK/V
         Hv0CfNghJOPpOB0FEcXiUw9IFzm0hz5u8jpInN6HJIv53lXd3CSs0Cb+Wi4T0XvhWHeq
         nE+FJ867h0iNyGZLihaJQjvc2LsfZ6T0rMl+ARSS7sYxj4C/CZFZBWyq6m3ep16oN2xY
         2sEA==
X-Forwarded-Encrypted: i=1; AJvYcCV/BhyLdA8tIjWsqExgThYugoCwgStBnS2zAqKuCVa8cp2mDIuV6a6PJM1vZt4z3c4mB5lQlzMiGVYRbdgM@vger.kernel.org, AJvYcCVC9/rn9oyw2wWj3+PXx6JBa7sVAZYJjMrkOzzw8csAn8OInh7WV1oGRgxXaFBJ2pA16Avqn5gJU4UbEvCQ@vger.kernel.org, AJvYcCVqHWa8z3fRrsu41NvaKWTwq/uLIhZI/tbIfFlN3qTq5ywx6EjvxMtMD2nfhcqUaabDgcyTihAzmz4nw71/emGV@vger.kernel.org, AJvYcCXi8vpe57yLfUnMghlVHEdtgIJwa4+Mn3yM0+4AGgWuE1R01MQ931lzUDko8MrK9A2PWiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVC3TQfy44rq82yCD/zxkJ/Zyz4X4GZuZYfw7uXyV40ghgaQXU
	XKQia6F47riI4ZKipfCrpgGLVcWfUG7N/AA+wrSWLAYCJSk3QCb7
X-Gm-Gg: ASbGncuK1SGXhJPW9UDZuVeoFZtwVbhnSbeXlXrX52PhWBdvxVgnaPm/LoHY2giwDuN
	LtN8+d8lpgG7GRMyh4hlT25n1j9LiRiDgRemOCCGvgEH35lxPfky0zIq384MYxviEuyIssbTBa9
	HQGa71tF1gRTp+7iK0xlL+q0NmKlzlLlojPbxWHQNDIxaysHfyvP1xLW6nA72a+7dzn61Yw7fe5
	o5XchsTsL/WrBLzBbBGRvS2XLyp2dGhNzhMpKgoLZs1CctW0PVcXot3IiUeUIVDtzLrVinxFZ24
	G7X6Ecoczu8e9tH0Hd+l8qWodykz5GxlGpJcHIdCtI/7olxPhvgrBTiSxujB+Mhl
X-Google-Smtp-Source: AGHT+IEKJZWW+CA0u03L2I1YwGaBuPS3Jq/Tgj4wyFEY1P0tyWIjeS90rjHfjPUoep1kge+Jl0aKkA==
X-Received: by 2002:ac8:5807:0:b0:47a:e6e1:c04f with SMTP id d75a77b69052e-47aec4cb1fdmr34086211cf.46.1744971913152;
        Fri, 18 Apr 2025 03:25:13 -0700 (PDT)
Received: from localhost.localdomain (ip170.ip-51-81-44.us. [51.81.44.170])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47ae9c17673sm9266701cf.13.2025.04.18.03.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 03:25:12 -0700 (PDT)
From: Chen Linxuan <me@black-desk.cn>
To: bvanassche@acm.org
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	axboe@kernel.dk,
	changbin.du@intel.com,
	chenlinxuan@uniontech.com,
	hch@lst.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	justinstitt@google.com,
	kbusch@kernel.org,
	kevin.tian@intel.com,
	kvm@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	llvm@lists.linux.dev,
	masahiroy@kernel.org,
	morbo@google.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	nicolas.schier@linux.dev,
	peterhuewe@gmx.de,
	sagi@grimberg.me,
	shameerali.kolothum.thodi@huawei.com,
	virtualization@lists.linux.dev,
	wentao@uniontech.com,
	yishaih@nvidia.com
Subject: Re: [PATCH RFC v2 5/5] lib/Kconfig.debug: introduce CONFIG_NO_AUTO_INLINE
Date: Fri, 18 Apr 2025 18:24:53 +0800
Message-ID: <20250418102453.982042-1-me@black-desk.cn>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <bb713790-0b68-4d91-831c-b18fa1ea01a9@acm.org>
References: <bb713790-0b68-4d91-831c-b18fa1ea01a9@acm.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 4/17/25 5:04 PM, Bart Van Assche wrote:
> On 4/16/25 2:44 AM, Chen Linxuan via B4 Relay wrote:
> > 2. Make it depends on X86 and LOONGARCH,
> >     as I haven't test other architectures
> 
> That sounds weird to me. Shouldn't this option be made architecture-
> independent?

It should, but I have only tested it on X86 and LOONGARCH.

> 
> > +config NO_AUTO_INLINE
> > +	bool "Disable compiler auto-inline optimizations (EXPERIMENTAL)"
> > +	default n
> > +	depends on CC_IS_GCC && (X86 || LOONGARCH)
> 
> Why "depends on CC_IS_GCC"? Please make sure that both gcc and clang are
> supported.

I make it depends on CC_IS_GCC because

1. Clang do not have `-fno-inline-small-functions`
   and `-fno-inline-functions-called-once`.

2. If we wrap those options with cc-option,
   Clang 18.1.3 fails to compile test_bitmap_const_eval(),
   with config KASAN and TEST_BITMAP is enabled.

   Comments above test_bitmap_const_eval() says that:

   > /*
   >  * FIXME: Clang breaks compile-time evaluations when KASAN and GCOV are enabled.
   >  * To workaround it, GCOV is force-disabled in Makefile for this configuration.
   >  */

   It seems there are some issues with Clang's compile-time evaluations.

So I think there are some ways to workaround this problem:

1. Make NO_AUTO_INLINE depends on CC_IS_GCC;
2. Make NO_AUTO_INLINE depends on KASAN=n;
3. Disable NO_AUTO_INLINE for TEST_BITMAP
   like how we handle CC_IS_CLANG && KASAN && GCOV in lib/Makefile:

   > ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_KASAN),yy)
   > # FIXME: Clang breaks test_bitmap_const_eval when KASAN and GCOV are enabled
   > GCOV_PROFILE_test_bitmap.o := n
   > endif

Which one do you prefer or do you have any other suggestions?

> 
> Thanks,
> 
> Bart.

