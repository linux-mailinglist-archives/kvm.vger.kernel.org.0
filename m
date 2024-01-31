Return-Path: <kvm+bounces-7590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BACDA844200
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 15:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECEAA1C218EA
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 14:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628BC84A4D;
	Wed, 31 Jan 2024 14:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ejwWVEbo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0041284A2E
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 14:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706711980; cv=none; b=Jq1UmPpMl5MXh9r1QmPEuXHrzHBn1fLK+++X1BXcf4/BQ5QSQwAjXi6H4P5XZyc/XbvQFMSKmRLPmAX36grE6NieTVi0mJvr5MVU9aHQKY+1Xkhkf/wXFPsW908Fe1Zj/mlALJX3LbEgAIu/NkYX2MtmIgYJs7OCEsJqVO3dLr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706711980; c=relaxed/simple;
	bh=MrKfgk26qxBJnNcLDFPDF4DUaUF80LiDpqyjHXVjBrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MV4R7RvnWNa6b5GD6z18YwuOXLNECxEWOlkWBsOilPTMzmwuiS90hU2B/B+sS9MGgGk9YXXBRsrzynGbaoHEa85JFx6dv6mXvirQqFvd4+GkaKfWVYiXI3BRT59NY13kkl+N6AqmZ/mhuH1Xcc8R9yXd91m9EGdLsJIpbzPT/sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ejwWVEbo; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2142ef4a7feso3332222fac.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 06:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706711978; x=1707316778; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5aaFoAo6yHIEQXEMEH+9qzGfghoVpdZE0vIfZZ7ypDk=;
        b=ejwWVEbozYTeSnlH6H0uj4LqEBccSbjHRBzU1CHn9+dqOql2p1aRdUBMSFHzNLPdNV
         EqOMtEX6CXyLjSFtw8Dq97ymRUCd2+tm7ZCEABNLtZc1sG1WX0363d9Z6X5nFptcfdao
         DPYFuaE2y29OEHFo82cmOiWAA3kX1ae8wRWYpcwkroiy3lz3SYe+c1ZkQjSbbY2wy8b8
         AiTlKCi22CmNkz2wjEPqQR8gs4444tCkDVwS/rXVWnQwVU8QsKHX3+JJt4Cl2+guyi7C
         UYbk9jqfLm6+HNFGWSEoHs3kEXGK2VUdoABQYFHsfiHKHlLzEDvkghPX/SZ1D28p6B2x
         V5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706711978; x=1707316778;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5aaFoAo6yHIEQXEMEH+9qzGfghoVpdZE0vIfZZ7ypDk=;
        b=Jj3zZcEjAhLRs/d/huNV+vFA3ryXj9KLu6ZvP5CpJzT9xW8h8rBFloz22x7u9tM122
         Ie08oI8qhDd8laM7/6hM3iXYy8XAJjAaFmuUxr+Wj9zdva8197FqHIZ+sldpDG/S5S5z
         2577WJllrWcUE29tji1ScT/kiMBizb7WPykyaJLf9smw3kKPcGG2Vaqwun0w8TCODhUe
         Ed/MDebYgGCEB1FOpJv31NYTRd0sD8cd8oxVZR+3zMD0hwUh3hzaN5TaFpMbYBgbYI2g
         Fp9hRR+tMVH4/J30BRGVY9LU9UkHMJLQOEVjdXqwc+3vlf4jToKL25q7BGnGQXkxldvg
         /lPg==
X-Gm-Message-State: AOJu0Ywr4PJKiDx/NDR5keQcCa8Gf7caWqrQU9N9tugV5ciFKQljWzpj
	CZyYVXEILXciorOlm/4SVWnmscy2fYegQUhH3nmduaQhI8ogHOMABehwk3gGKn+3A/Dlv3I1RR7
	Hlp1NniZovgIQpMjNJQw1/cisAJA=
X-Google-Smtp-Source: AGHT+IFElWLLXQwef+7+fERmu7M4ME7jfoUL9BSEfQuPDKqElQIyuSJN5FKJdmp4ApM6HgZX0Ll8uj+vLtevJufb5Gg=
X-Received: by 2002:a05:6870:6e12:b0:214:fd96:486c with SMTP id
 qt18-20020a0568706e1200b00214fd96486cmr2051195oab.9.1706711977915; Wed, 31
 Jan 2024 06:39:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
 <mhng-bcb98ddd-c9a7-4bb9-b180-bf310a289eeb@palmer-ri-x1c9a>
In-Reply-To: <mhng-bcb98ddd-c9a7-4bb9-b180-bf310a289eeb@palmer-ri-x1c9a>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 31 Jan 2024 09:39:25 -0500
Message-ID: <CAJSP0QWE8P-GTNmFPbHvvDLstBZgTZA7sFg0qz4u28kUFiCAHg@mail.gmail.com>
Subject: Re: Call for GSoC/Outreachy internship project ideas
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Alistair Francis <Alistair.Francis@wdc.com>, dbarboza@ventanamicro.com, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, afaria@redhat.com, 
	alex.bennee@linaro.org, eperezma@redhat.com, gmaglione@redhat.com, 
	marcandre.lureau@redhat.com, rjones@redhat.com, sgarzare@redhat.com, 
	imp@bsdimp.com, philmd@linaro.org, pbonzini@redhat.com, thuth@redhat.com, 
	danielhb413@gmail.com, gaosong@loongson.cn, akihiko.odaki@daynix.com, 
	shentey@gmail.com, npiggin@gmail.com, seanjc@google.com, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 30 Jan 2024 at 14:40, Palmer Dabbelt <palmer@dabbelt.com> wrote:
> On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
> I'm not 100% sure this is a sane GSoC idea, as it's a bit open ended and
> might have some tricky parts.  That said it's tripping some people up
> and as far as I know nobody's started looking at it, so I figrued I'd
> write something up.

Hi Palmer,
Your idea has been added:
https://wiki.qemu.org/Google_Summer_of_Code_2024#RISC-V_Vector_TCG_Frontend_Optimization

I added links to the vector extension specification and the RISC-V TCG
frontend source code.

Please add concrete tasks (e.g. specific optimizations the intern
should implement and benchmark) by Feb 21st. Thank you!

Stefan

