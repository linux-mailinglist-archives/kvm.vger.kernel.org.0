Return-Path: <kvm+bounces-25932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B116A96D3FA
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 11:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62D962886DC
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 09:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE041993B0;
	Thu,  5 Sep 2024 09:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2mWxN5f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB87A1991D6;
	Thu,  5 Sep 2024 09:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529610; cv=none; b=RBffo0l8pVyLfyvkWoJGyJ7VbnH0i60rwq1B0UU/tsbJ1XHmnR6I4bTruMVGp0GIJ/ERdr3bI8rdRkR7hw/NVOoXZPlf4qf4QAxjxR1L2DE2PnmSZ5gLOMxtt3vdxl9ulpmaMu+qe0eqorYo5xiVl9yuVkQeGeYicZftx7PraLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529610; c=relaxed/simple;
	bh=ooTxRmy9CNhI0QBGKGov1IP8Ny/IFn2b7BpJAt+pUGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dEM0Hp0PY7etwJDHiW6mrMp7ueJv4R5fHcNyRK3mlfEpa592qa7Wd7oww4n0pVWCo0MGDRQNCwWaKTQdALZbAWJF+Y3BTTePehAPc7+Z9oRyy+hDLXCfScMQB+OhHsdqvaEOYp7ti6elwvfyvr4U+lb8wnTw34FhiSL2eQroZBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2mWxN5f; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3780c8d689aso313753f8f.0;
        Thu, 05 Sep 2024 02:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725529607; x=1726134407; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a3A+0OEpset36zqQ8dSnuPMDIA8aciodye1/vukDHAs=;
        b=R2mWxN5fjYaJm2yNUzLJXoHE924sOE1VUSro0LKCnvz2Ik+75SdTlPFDxzRNFjvME0
         C3UZu2s88Bnr/gVo9mkH5l1DHarPD4NXMIIuo59SAiVTw+JqRRFnbP5Jn9LZBGkHiVw5
         4dQ0mFHEf1+0U9P1adjDD5Gwfx15q3seAWKvbZ67P2etyT/xs/6J1gCC3yN6hmZp4/P6
         BQklv1cUXsVgcqrPm93Z+5Qc7FqbxwHgG+FFtgA7BqlhiY5TZ1DW8q8W1pc12tN4GmlZ
         5osWYmaCHx6xKiyQxN6/KOQ1RtmbnX/nKvezhlZ3sqQajSNxPxYcu+aJHpvW8YBwpaSG
         C10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725529607; x=1726134407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a3A+0OEpset36zqQ8dSnuPMDIA8aciodye1/vukDHAs=;
        b=U3Ix0QOyEAwi0c13MD2bVok++PsFIHcHnoWKKyHLp0khYhw3dtw/+rvDUFnnV5/XEb
         WaslydGFtk5l6MAU3NsHOF4aB+VcA1sLEB1NqePwA0iVPz8Q+N3NPHAHNM32KJgWavQi
         OvFpiIe7O3j4l+f0JIp6j96GdXBdHaJ36ehGcDyiEpB0eyewuUhmjGPUWQuKRq1pjEZN
         eOVrSM/YEHWzsk9qoIDhTNQNJD+0ZS3ZD5L6/ekUuBtbHgikqR44SurpOYcjtZ2beEow
         we8pzIrfwsI6xUvMV7vYrLCzWjJ2SojILTspL6hl65qTp0wc7b0MDy64k+wVvBUpTOxQ
         G5Yg==
X-Forwarded-Encrypted: i=1; AJvYcCU7a/tO0oOyg56ndYbkbH/F76WR9zWMIEwD/vun3dYazbTORYRalRbqjzyzpiAD3DToJYzXCxqLfFsXii4=@vger.kernel.org, AJvYcCVsstE8OTxLCN1eqbh73sZmGaRJFRvzGXHmzv0bzHd8MKQbX2b3fLlSH3t3VXDP0HBePL8O03NjnlmD/Q==@vger.kernel.org, AJvYcCXYo67GQdOQSSmnCjdD/0BGT0j84y13CnkCvg32FxDa0cvLyt7ybJrfvfqhuc/JPk8Ci9/ZaI8J7clwZkNo2e1JmQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRDPTcuHR8C1qZMh9egyYtS+EpAaN7npKdbR8kouPWyS/W0vSf
	Xv/G3QiWrHlEWEdOWgR+MFKCkKdLsWOffq0yO8W97G8f6MKqY8uZ
X-Google-Smtp-Source: AGHT+IGwAx2QSUfLDZ+tfaLzM6jDxYn1gijqzhfBCWl8wJV2u0GTNpP6gbYbb2bM1aZJ2WyRNkSboA==
X-Received: by 2002:a05:6000:1f8d:b0:374:c29f:8ddc with SMTP id ffacd0b85a97d-376dea47192mr5800262f8f.40.1725529606275;
        Thu, 05 Sep 2024 02:46:46 -0700 (PDT)
Received: from gmail.com (1F2EF525.nat.pool.telekom.hu. [31.46.245.37])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374c1de81b2sm13382624f8f.30.2024.09.05.02.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 02:46:45 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 5 Sep 2024 11:46:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Will Deacon <will@kernel.org>, Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/5] perf: Hoist perf_instruction_pointer() and
 perf_misc_flags()
Message-ID: <Ztl-AjEEbIbX4lnm@gmail.com>
References: <20240904204133.1442132-1-coltonlewis@google.com>
 <20240904204133.1442132-3-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904204133.1442132-3-coltonlewis@google.com>


* Colton Lewis <coltonlewis@google.com> wrote:

> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6915,6 +6915,16 @@ void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>  EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
>  #endif
>  
> +unsigned long perf_misc_flags(unsigned long pt_regs *regs)
> +{
> +	return perf_arch_misc_flags(regs);
> +}
> +
> +unsigned long perf_instruction_pointer(unsigned long pt_regs *regs)
> +{
> +	return perf_arch_instruction_pointer(regs);
> +}

What's an 'unsigned long pt_regs' ??

Thanks,

	Ingo

