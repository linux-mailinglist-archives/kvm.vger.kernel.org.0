Return-Path: <kvm+bounces-7593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AADCC844386
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 16:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F7ECB2376C
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 15:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852A312A148;
	Wed, 31 Jan 2024 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="ae7lyquR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9042112AAC0
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706716758; cv=none; b=LQlloZTnP/WsXU09s8m1vj+KsxzCgPklc6lCpKORRBMqyjLOHzVM08uH5kqtZKaIsG6MfMw45uWVUUziyCVRqWYMCA32Txok6uslNVjJM9W+k4xP3B3YwwW9xgc0VZ6n6GUAI+mxDtfdDzP36gF+LtTh4mVOCwGTI6amYPaAJd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706716758; c=relaxed/simple;
	bh=Vbm4TiQOZt1Jz7l+uCpvtUon0P9dYsflBJizTapbuB4=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=gT8mVdWteTUHvguX9ovkos6ZQeNZWOA43vUk/BcG4WNqJXd7hCPtDFoIlJ5vhhDClCSE99xZZL1O5lfcx0f968ezVNa14TE0I+yNb7QqBZWjvp2DenMev2Sn8cIqD3XaIJV2AJhhvLGCfd4wsfIgjPhrhKG7qsvAMfq2qsMLa9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=ae7lyquR; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-295d22bd625so925815a91.1
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 07:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1706716756; x=1707321556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2tYCQRNgAZqwKRtR7jgxEs9S4CMjsHb/RcxjBFK8bE4=;
        b=ae7lyquRle9vZh5m9fNP/HZQh1XC57fnPgB51cqXUB0cpPC2swudkdff/Me8AbCH1w
         w5nukJvvg0/RsAcEXfujR7dvKOV8x9pih1nj3t87N6s/zHs2Ez0jBwRaJygA2bJnuvpa
         cXNQt0hMHWxeSGKCuI6HB6Fs6LN+hoVVYlDxAFaQvmXvd6rjSXDx0jHz69CeiOIuysHb
         WP195p4Bu4x55l5Gwx+ux9a3Exf07mBXkSc6lnGx4NaBEktM6/hrrHF0V8z9U0diz9HE
         ujcyd7bdjRO6hc6TfGGf0dQbfJXsSmmlFZe+QHwq3YlDdQHbTbEEZ0VnaIr6zlGfVqmy
         XMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706716756; x=1707321556;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tYCQRNgAZqwKRtR7jgxEs9S4CMjsHb/RcxjBFK8bE4=;
        b=JXnKyTfrlq9R2yuVpeUF2Xr8gVOF4Yk32CgaVUOhYoWl6zE5VPj4nztxaizjcKULSp
         xHeI8aEpvWT6ylpQqb+LFL/wxWa1ZVvXc/1YEiRVp5DTGLXEQmZ+KjLfmr3EXSIpGgNv
         o+9+pCyRfy9x2HkHr1h6BiQuhdCElO/s8+E2mv90FC2NSYn7cfLGvqixQDMtVI6b6XsK
         g9ahUrANLAbCxscFa2L1tNZFW6ACcv3Qyc2m8W166F1Hnr0XdTz3ca2VJ4K2s6pcAti9
         s167LQYwF6YKVzTZLMD+nrzKzwoKOjWvctaQAqzx7pw1yqj2byNCOmpeY9e5yNNqACF8
         srXg==
X-Gm-Message-State: AOJu0YwebMHGyKCjP+L7lZ091TNDrI0bWe9R5VksuRm36bDSsjgWfAtg
	Hi4zb+p532WIdvnJ6Ya08l4pGlAmSw4WaeR5QyK5gZJp5fPjnE1iTA5DvpVHA+Q=
X-Google-Smtp-Source: AGHT+IHkLqmeGopJwus/JjJcG+C3kOqqtllRCvELNYYwCNkT3Oml8KMueADzCsoiV4D/rVxVuAdu4g==
X-Received: by 2002:a17:90a:c7d2:b0:295:eeb7:c53f with SMTP id gf18-20020a17090ac7d200b00295eeb7c53fmr1418541pjb.5.1706716755728;
        Wed, 31 Jan 2024 07:59:15 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWrNcIeUGJOTfQmB+PDhthnU0br0AGbtk4a6ou4Op9RvT/6EO5sV47AXaCjah6VOgKXMjp03JwJSGmQ+Qz2+Ogkth74YAWUv5uSBhSV0PbzuvEu3akAQmCzLpS2UKadLpOTD9gyxCK0unPXGXZhs1UckYsonAkZtmGTuw8IJyU9B0NShYMIpaXahpFiHQvHSJvPjL9qPZVZBCVp3AOkk2EBw34T8C+jboe5koJgqRO875alxLiUVG/w0vV9nVfd+t/+LzRwFa9xHLTcHwreKC2ygFjwPr1wUmvQ/Lze+EjeUoiAadEX5TLEWuG9AEZUHbhMVaNxtt8KbHqlNs5YBAG4u2gxGaQrH5/FMdQlM8um0tqJbqReMbdXbmx5LefN7pkVjC3yL9zO/U7Rk9lZMgJzcSV42o1ilbZwSY/y92lC2ugJ6SoUNabz0IpQmwu+Ui4trayE/rZlHY/NuRlEdO8zO9vx2EcwQpTiYflYzTRHqY+rRDwqLxaivGe7u9IkGPYts39TjlfxCa9FxZ/o/KblS2QRdXxGev3Pt6NHQTEG4DROCglxId90tnIXH9O/PXDW4lY60Qa1x7LlG/igclHsJUbZAyw8QPcuoAPXdxgNiSnnZSrjSeukzzo5EIZ6K2I/qjY0JRe6fL4=
Received: from localhost ([12.44.203.122])
        by smtp.gmail.com with ESMTPSA id nb4-20020a17090b35c400b00293d173ccbasm1679314pjb.52.2024.01.31.07.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 07:59:15 -0800 (PST)
Date: Wed, 31 Jan 2024 07:59:15 -0800 (PST)
X-Google-Original-Date: Wed, 31 Jan 2024 07:59:13 PST (-0800)
Subject:     Re: Call for GSoC/Outreachy internship project ideas
In-Reply-To: <CAJSP0QWE8P-GTNmFPbHvvDLstBZgTZA7sFg0qz4u28kUFiCAHg@mail.gmail.com>
CC: Alistair Francis <Alistair.Francis@wdc.com>, dbarboza@ventanamicro.com,
  qemu-devel@nongnu.org, kvm@vger.kernel.org, afaria@redhat.com, alex.bennee@linaro.org,
  eperezma@redhat.com, gmaglione@redhat.com, marcandre.lureau@redhat.com, rjones@redhat.com,
  sgarzare@redhat.com, imp@bsdimp.com, philmd@linaro.org, pbonzini@redhat.com, thuth@redhat.com,
  danielhb413@gmail.com, gaosong@loongson.cn, akihiko.odaki@daynix.com, shentey@gmail.com,
  npiggin@gmail.com, seanjc@google.com, Marc Zyngier <maz@kernel.org>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: stefanha@gmail.com
Message-ID: <mhng-125f45c7-5a14-4c91-af16-197a4ad2f517@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Wed, 31 Jan 2024 06:39:25 PST (-0800), stefanha@gmail.com wrote:
> On Tue, 30 Jan 2024 at 14:40, Palmer Dabbelt <palmer@dabbelt.com> wrote:
>> On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
>> I'm not 100% sure this is a sane GSoC idea, as it's a bit open ended and
>> might have some tricky parts.  That said it's tripping some people up
>> and as far as I know nobody's started looking at it, so I figrued I'd
>> write something up.
>
> Hi Palmer,
> Your idea has been added:
> https://wiki.qemu.org/Google_Summer_of_Code_2024#RISC-V_Vector_TCG_Frontend_Optimization
>
> I added links to the vector extension specification and the RISC-V TCG
> frontend source code.
>
> Please add concrete tasks (e.g. specific optimizations the intern
> should implement and benchmark) by Feb 21st. Thank you!

OK.  We've got a few examples starting to filter in, I'll keep updating 
the bug until we get some nice concrete reproducers for slowdows of 
decent vectorized code.  Then I'll take a look and what's inside them, 
with any luck it'll be simple to figure out which vector instructions 
are commonly used and slow -- there's a bunch of stuff in the RVV 
translation that doesn't map cleanly, so I'm guessing it'll be in there.

If that all goes smoothly then I think we should have a reasonably 
actionable intern project, but LMK if you were thinking of something 
else?

> Stefan

