Return-Path: <kvm+bounces-55607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86294B33D7D
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 13:02:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3389F487D28
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 11:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702602E1EF3;
	Mon, 25 Aug 2025 11:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nCOJKiJs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8FC2D6E51
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 11:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756119763; cv=none; b=h49CvbSkUOGbuy/xEiHdYLuegmWMP7NLhkYMshqQHzOdVkxkkTbWzGPSRznmg/KNVTGF7LBXKaQ00LROw/g61Z5pw90SeZyZ8VS9x+LQdcLeVjcCnWY5uay13ZH4R1toQRbtKHQVyJoY+mCvsrx3MmfxlTRlvx3WjKmpoCiCvvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756119763; c=relaxed/simple;
	bh=HHzUYhwlozHgD2yKHCQ6VbSRe+a2+HdrK8dJd5Ripyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfD1nqJa23EUSulvf70l8SXxFO/G6L2ksQVI2ARVVjl+lMbs4BtbFJyQZvkwph6Q8loLXTsDo/61qAAgpyMT/dQ7e7UFNCt1XTgRMJeV3uifrnvNZyvSOZw0gTvn6vVuWXApWnGK++Dd/Jz4cIFIP/nV0f3qU2V2vZqb0rg1FCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=nCOJKiJs; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7e8704c52b3so497268685a.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 04:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1756119759; x=1756724559; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1KrFoOnuL5GMtaq0YKgHhpMxoakpxp6Ykplg7n1PuXc=;
        b=nCOJKiJsZqcFQH/AmZkScDKmKRWRzDLZdsPQaFWNFZDkkzMRzsuzju2xqCln4JaCB9
         1gRqLx8b5agj3dsGsJjY/9lGxMAqqmb9ZGc0IcujP+EkB0IRbKXzwx3c9SkD6TX0h2GL
         dzA4Yae7x1pIAbdhwQm142mVWaoDw+r6qJz8xdljck+vQNRtXYF0ej8ugScchJKfrGDs
         Vi9udMyTphgwv1k15grZTH8c6W2QkVmdfMBTLJ+fg1WqQcWgrioUFoHJXiu800XH+Ta4
         yTPTPOjwqmBuAnCzZOqobMNpnqbmZ6hdNbvD23HzjPb+P9W/CltOFmKxFIr4zNWTrQo7
         dolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756119759; x=1756724559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1KrFoOnuL5GMtaq0YKgHhpMxoakpxp6Ykplg7n1PuXc=;
        b=M9HZDI58nEvYOGRbuWYZJXAQyBq556kc2DlMg4RdcYjEzPt5NYA4IhIjuvcnmxQy87
         Qt3ulSKWpZ+Lv6KHyr0FZqDokkJn5FhLRAeCzuIXCR9DTh2Xo7WZJ6uxyOi51cIGCC2o
         es59uNIhhKgAEMhMRsUhDaQU2DIFOq5RGNgchFQHCkofdO/Mr+gp6kLxTgQcRJWT3nCW
         lEhSCBwy8SD4IjhLBNrGWd2foNHihzvKHWD9X4TkLv/WP4uKVkvFfC467AE/A/ZEsA63
         RBBrrWSRgp0ZbrYhImJxD56gkcCn0qyAdojWcPswzMwBGTJ+pLLmBQCew8UCbaxpWYJo
         anOg==
X-Forwarded-Encrypted: i=1; AJvYcCUyQAVGjI2MkX6yVKT9b57EQRp3JM0ySh0woV3C66hhx2yHPDci5HPpkocouF5MSN0bSQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaMB6XzTHzprRMH/CJYGWoE2SwC/uImuSqniEraolkfuedjNTS
	62xlZ9Y2+9LPKjUP6yRi4bTo+yuo4kspLsnk/7we4QqXlhglnNpIJtbMlkAtIWT6lAw=
X-Gm-Gg: ASbGncu/2/BRh13ggQleaspw/GWPLINJOoIe7O66Xv5LLHQnGg2C/e/qUPjF6GYIjJh
	2BuwLHzK4dXDs8INOa9/L8ooRDhRL8vHzg/QRhfYr/miPFJij7gf5pHSENgpvA1srfEFtKRsJf0
	3+CwpBKUKm3/mWa99dcNLPUOZfm28xlzHMfJ5jU/ejw0MRAl4lb2txHr2Fv1Flo4GBcBQncZ1gt
	o6f2wkAPdxkG3dkH6X+nEv+VFQqMIdo4Lrv+C1PuwcMarGRDOM4H2D75Zc7mrFmGiwhlpVfpzBX
	+0b7Er/wbUxIl4jglZLO1dQ4yRkf44xq1tFyxoswAyajfVM9Jd3oP4nPK3LQgkQUAejEOdXExCM
	BsncURVxAfC8WYZe16m8MXFKqtQ==
X-Google-Smtp-Source: AGHT+IF+Xp2kSkiYMs9XH9xufQw3bih7peJ51tO8RYHjQC3ESxBEZ2qFaKuTNArd2lSB1l4CzhQLSQ==
X-Received: by 2002:a05:620a:1a98:b0:7e9:f820:2b46 with SMTP id af79cd13be357-7ea11082af5mr1233715085a.82.1756119759186;
        Mon, 25 Aug 2025 04:02:39 -0700 (PDT)
Received: from localhost ([138.199.100.237])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ebf3bb4e4bsm463662185a.60.2025.08.25.04.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 04:02:38 -0700 (PDT)
Date: Mon, 25 Aug 2025 06:02:37 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 6/6] KVM: riscv: selftests: Add SBI FWFT to
 get-reg-list test
Message-ID: <20250825-5f0ede7adacb9fcc102d6cca@orel>
References: <20250823155947.1354229-1-apatel@ventanamicro.com>
 <20250823155947.1354229-7-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250823155947.1354229-7-apatel@ventanamicro.com>

On Sat, Aug 23, 2025 at 09:29:47PM +0530, Anup Patel wrote:
> KVM RISC-V now supports SBI FWFT, so add it to the get-reg-list test.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  .../selftests/kvm/riscv/get-reg-list.c        | 32 +++++++++++++++++++
>  1 file changed, 32 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

