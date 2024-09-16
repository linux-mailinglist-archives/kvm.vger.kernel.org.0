Return-Path: <kvm+bounces-26997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1FB97A26E
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 14:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 722E028B08A
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 12:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F3119BBC;
	Mon, 16 Sep 2024 12:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Jqmv/nfq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932561553AB
	for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 12:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726490291; cv=none; b=VZ8ItayTsVmyEe+QzEX8Zrzme5HSVnqCj1pfq8/Pd9r2J3ehVTGpI5d0rM72vMxhm4TguC8oqd8bTBcrpsNPnYQvpnjyHOyNhxhO+W/yL2O35B4JVdZO/ysU1xGHBOrmw6o9qSd1jXUZ8tDMPmE+NMjWxOxn9+jFPypBkI6G2Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726490291; c=relaxed/simple;
	bh=7EhG9EbVTGqEsiK8x+VNzz9p7fj5lCIpORxLSBcfrP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hbwFp3wYVDJmTv6l+P3iVDHYIIRvemCHPi0FE/qfxlnL/X8wElsKwiuqnKSy51S+IGWAlENtUMWUCBeKJ6+3aj2rQNlaNI9hOqDo4N3/gMlSrFZ3fQGAMTd2x72KhnRFx8MdkmKConSGEIlbfUuNAARhA1hNjjfMGz+tHVYRyuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Jqmv/nfq; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a7a843bef98so420343066b.2
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 05:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1726490287; x=1727095087; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KNBeOEHGq7Pser7VzvbTspy/A3zYw7bZRrBFbZEGNjk=;
        b=Jqmv/nfqpoO2L99oG2ltOBigQGM4qVA/mZLBR5mir4GfsVpT1NXcdXPfR517WwhlMS
         0zdoO2HUJU6MPwnk+eLaUW2YxD8PxPN8mKjEqf0DoU1mwP5wYHtGRLE67AI+FlDPuQws
         p6BuvD4CzCfG6IO/F+Ul8QdysdDIzmEBzh88JXJTsuCkZbyEfvtHYyFa9C9HZCM/TzNx
         2CfzOqsik9zVHNDVhXtie+F8RZTeAXuCgV9OzhTAiUPKOPpU/q4FMRe74FXApG8qVuvG
         9nrwhNlxU1B1VYIzD01NPjymKACYwEdEa0T45FdgCqNyRAjPUAb3vE0vuhjchAbfXiGY
         ZsZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726490287; x=1727095087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNBeOEHGq7Pser7VzvbTspy/A3zYw7bZRrBFbZEGNjk=;
        b=nwW9PlIgAfksItsNwNNVYea0GrO7OUJlX6i/++IKHSQLAUls3PwjPcmBPVOFUt98P6
         nGxwUlDugnB1oSdM5Pb+T0D18s+IABZjwT13zUbSwsL45+14PUgP6XNjrixmpfBLjwwy
         AQ8WTJnzTnTANjijhmn9vMAhLneiPzRWXSjEg6N93+j04QUKK2tgMrcY3ti1SpuMW9zX
         gFCz8IXtC5/kiizugIGdh01frVTwd+4PpbIr67ZRQtI7nUwbxhTN3NPZj4tyqWGmpwqE
         DmUJ+AfF7Vk/fE9VFDPmTfTucDH8uECn34HjyJCZMV2JLDllWDXYAYb8kPb2iYcPWhjW
         EFOA==
X-Forwarded-Encrypted: i=1; AJvYcCW3wAcM+SnRchnp+daFiE0PUcREgsKUZEpWGGyk6hKtwQ0wWC2Ewma9i4yr0u7CvtvL1W0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjwHdEOt1Z8Sddbi4X6GDlNEsW5HXAccCIS3Ik7W7R6hpiOfMp
	QnVvqZnLuFa1xktwvLKlx/5NBEx+KbJ7w6LPXMbXoYIL+uXrG2XkpMmMuNkqG5g=
X-Google-Smtp-Source: AGHT+IGOZcpAXmdIVEV2vYM9IhWJaJecvzLcXzXO10w2tECmYppWvm9paxVvWFyfXx7MUbTlLrDpRQ==
X-Received: by 2002:a17:906:f5a9:b0:a8d:51a7:d5ec with SMTP id a640c23a62f3a-a9047b4af68mr1200972366b.13.1726490286251;
        Mon, 16 Sep 2024 05:38:06 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612b3a0fsm308834866b.117.2024.09.16.05.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2024 05:38:05 -0700 (PDT)
Date: Mon, 16 Sep 2024 14:38:04 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 1/2] riscv: perf: add guest vs host distinction
Message-ID: <20240916-6f21ff3d12224f366ccaac6e@orel>
References: <cover.1726126795.git.zhouquan@iscas.ac.cn>
 <c62057d587f075a64442df1038fe27b52b89c997.1726126795.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c62057d587f075a64442df1038fe27b52b89c997.1726126795.git.zhouquan@iscas.ac.cn>

On Thu, Sep 12, 2024 at 04:00:29PM GMT, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Introduce basic guest support in perf, enabling it to distinguish
> between PMU interrupts in the host or guest, and collect
> fundamental information.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/include/asm/perf_event.h |  7 ++++++
>  arch/riscv/kernel/perf_callchain.c  | 38 +++++++++++++++++++++++++++++
>  2 files changed, 45 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

