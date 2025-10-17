Return-Path: <kvm+bounces-60351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C5ACBEACE6
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 18:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9CF055C4B07
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7743D29C338;
	Fri, 17 Oct 2025 16:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="JJyDyB10"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B70929B8E8
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 16:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760718018; cv=none; b=M7WGx8CHQ7iBDstJjblzeUCN5CUCynBxGz63ybTIoi6Vesw14N8Md2+aZgiMYSntJ3NRd1zYn0IE6EaSoPCOzeVCunpSCsHG6NCM+FasgWj/ljKZ570hBiiifly/EuVYZwVTf0Swc/INj+15RcrTFNONhb98z8VSV6HnsaI+u4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760718018; c=relaxed/simple;
	bh=51ie/4+FDOx0L86siBsGLHph63M5h6PAozXIjd28edY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fwJ6kRaZNFEYk8ValHo0qIAmddGoe+GgNM+IZ/XpgiLKSZ/TeBIIXwKiwjN5ASy22EKQ9jx/+2j2V0onB3CTc+944HG/zEFooEIBo6orKVeZ2mpuRGNCgsSkjHGMkVRIp2r1/7njl0z0NvRfbXzbgwPKVWacHxM5C9FgDKxWwBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=JJyDyB10; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-93e7e87c21bso60527039f.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 09:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1760718016; x=1761322816; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GLnYMiGE1i6wdt2kWbvCEK+VTfi2UEFuvCxtEUGWUPM=;
        b=JJyDyB10ySjPrQmCjTDGOeg956v64V+nGtHBrOPGIvn5+Cp9S/eEEYcDpScMQXGhKj
         XGfoskf+cVR7t8S1CIxTHljDY7XEGhD6q51D8vLvmh30dv2Aoviu7LsOMvOYU20bYrAB
         82ui9RgONM2ckrgOBPnTt6LB2pJDGSrTDzQioKTr9eQRH8vIQ5Q7UAgbe4OIiASLx81j
         15bgG1VDel1h3wz4cQyLAHdWXajlpHl7V+d4weKWqYEa8jPWBZ4BlybctadAemFr2Lbg
         4d5O2A485feifbJ7W/g17ET6g65W44oJThMHD9g9P9i5BIZIhN+/QoFmv5dEu5QxJIzM
         FygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760718016; x=1761322816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLnYMiGE1i6wdt2kWbvCEK+VTfi2UEFuvCxtEUGWUPM=;
        b=cNpUCQc1MwdOsRbc+H21ruwpN9HLPdzHPvqsWJoh6xKEoPdbdELUO4Y5c2UgvCoUNp
         lFOcIAv2AvR9Z7GMmDWN9ij33X9gfNVpossZKRdo0q1co06JH2av/E4fEY/gWnBEC/B4
         6n8E5iaYBCp5Ln9lNoA8eAxuyU8apsgvBCUskDk7trbJVfL0ZZcGnoVrGQCf5dALLsO3
         XnL18D8r5ZUZAi6rpctk1oxJb5PH0hSCyPtnUHH3rlRJDcd2Vhl0Kfog7X1aV2XE0AJT
         Uhbb4miUqJzfTMmDuKf7m7LbzDCOGkUvITtKfMQ8Mysc7v6OMaheGTG+LWPhltX4KxOR
         k3rQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXdQegW4IhedXfWlfeWRHLlhNfNwW1c9at8HpyGNhXgperayGyaCqTKwRTv+rfPexxweQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH0qCExmSKEL/jI7OwvM/P+wNfraJVhktPyZg3N4KDO3JrP92k
	ljL5aC472Dis/wEivPA5ZIsaAZjx87o3PdzpJojFS7gQCnx6aCn1orw6vQ3KSWEBwRA=
X-Gm-Gg: ASbGnctBszD6BUPmBtHTHX7W6g1hjdYTwJ3k8eSKkppNwGp06Ss5jfengJ8F7pYRClg
	FVYYwqhuXcVqPdyaBjql9m+MEv3/H8AClXAG2WTO3n81SsO6xFDWk8Ntw9PoYWRxcjCHPSQb96w
	OFetm5wM41Ee9vhZqo09xovU85Q1Je5GVirsORXc1RW0DBfUvsMDvBfxGmwA08/Wt0YkEzge3rj
	EPAXHVrl8j4MVeaDDtp1Vy4/Y1HREUGF2vKzDnZQ0k2KHI5QQhUnYAD9P/70/grVopIjW1YRpeI
	SxwGWhQ2BSHADC20M51ue8SQBjWssTHtFTZFfQtZs+WoLZtFvaoOlEDAlh53062lyblKydo4Dw5
	0czFSlVYHclcDuUAYc8SucPfnGiinjBPgVhUXZBsGhdjL7Uk++bGWfPxOXXVgf/o8FodN64JIKD
	VEDkWEf4ZUbbuD
X-Google-Smtp-Source: AGHT+IGx0p/Murx0/nwCjsggRoQIsfWi9xXyoIzQDYLWIYmSzYKlABJ6zEfQQ5rWYKVGG7cg4jaAGA==
X-Received: by 2002:a05:6e02:1a66:b0:425:951f:52fa with SMTP id e9e14a558f8ab-430c5275304mr65365645ab.14.1760718015987;
        Fri, 17 Oct 2025 09:20:15 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a95fecfcsm22608173.13.2025.10.17.09.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 09:20:15 -0700 (PDT)
Date: Fri, 17 Oct 2025 11:20:14 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/4] RISC-V: KVM: Add SBI MPXY extension support for Guest
Message-ID: <20251017-cfdb6c77b74b87b784a3bd35@orel>
References: <20251017155925.361560-1-apatel@ventanamicro.com>
 <20251017155925.361560-4-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017155925.361560-4-apatel@ventanamicro.com>

On Fri, Oct 17, 2025 at 09:29:24PM +0530, Anup Patel wrote:
> The SBI MPXY extension is a platform-level functionality so KVM only
> needs to forward SBI MPXY calls to KVM user-space.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 1 +
>  arch/riscv/include/uapi/asm/kvm.h     | 1 +
>  arch/riscv/kvm/vcpu_sbi.c             | 4 ++++
>  arch/riscv/kvm/vcpu_sbi_forward.c     | 7 +++++++
>  4 files changed, 13 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

