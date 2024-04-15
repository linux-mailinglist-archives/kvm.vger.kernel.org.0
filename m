Return-Path: <kvm+bounces-14656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B8F88A51AF
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:39:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9FB16B23CFF
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0E67F495;
	Mon, 15 Apr 2024 13:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="d6kMSAdi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B7578C8C
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 13:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713187899; cv=none; b=alFrW4jME+GekiabSBaA6+1QGmPhQG+3gFGiIyDymFrb4B5NlxNXFKbrgqwcu3SRnKhjoI5XAoyfkWU1xFaWKW3Ns7e0ZC5Or+HpiB0wZsLwXfzRqSJL/46qXd0SEGVmF5O8sGTJfO1LOVul30cH+wWr5QuSSnnfZKjwx95lXSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713187899; c=relaxed/simple;
	bh=5WAhOh6+YNFbemGNWCEJZjikj9RLzeY4/BZOTZkwkkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1s0rzcGQsGDlDUa/tGPt2FAs1d4lcnORNZZl07QLVX19rS8MDRiKaoG3bLLXwSc3DTQKE+7odukD4x0ZreB+nTWgyrz1CdHWj5JwDqwW3ZLbKKd67dhl3VF5sHy4AuzVBtXqTf6gQmQyycCzMt7AyhuWcw5LeQWyhJCKziSiVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=d6kMSAdi; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-41551639550so19575745e9.2
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1713187893; x=1713792693; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KE+Cpvnrr9PFeeWoK6ioKoV8XULExBLcSObfZiwRf6E=;
        b=d6kMSAdipTxsOD4NELJ7Bq/ijvD0PfBcgTlyi1ZDl9GMAx+2ejSzqPXv22TRd1g2Bj
         +ULip5ofGCpxcEexNjLYUZ6HRUGUAHCe3Ii6GUGqEX0kAURLSQYvFL4i5DjN3DYDVuJE
         hPlcWYMVj1a7IQkBBPYRuGxFwLe0Pl5MN7Sr3fTVdEbjrH77PLtM6p7K3A5HTDhwemh4
         F63S9igtICEFu9KP7C40HOceDgbtiGqQww8dtF0f5kMlssuzsx9AmXf+NfHljt9jdrAg
         T4MpzWfz7wBbDLm982CdXWGmsEce98E/LtlvdSExzULwvxsNQ4y6TzKnvbBW+gvYVjQ6
         4mfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713187893; x=1713792693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KE+Cpvnrr9PFeeWoK6ioKoV8XULExBLcSObfZiwRf6E=;
        b=h2mZ/rNi9iJODhBdT/QmxJbyGQa5omcDlqJ74oEqM1Al1SRhAI8xDgp6DkppUQ5CVN
         8Q6Qve9C1oh4yMCYZQq0KsOlwaHEQ8WbU9TIJLXtcOyQIqVKcbWQ1miBujKSWHNfvwJG
         LLClpxzJs2L14WiZH96TTWF9gAkCc5YTeP88kfJHt6dGKpvHqePb3Dre2tiqdPQcAv8f
         ROFZMK1+hKz066z9zciZYnSw2HYYLI2R/JglM9+f30+1nOs1Qr408fkijOM1sTIxhiiG
         KA453aYCyJJPBvTj0y9At4UMw3zqmV5HKMDw8DeG0nxLNJMaRprHScEHqnLteeG/9mGU
         0wiQ==
X-Forwarded-Encrypted: i=1; AJvYcCW18fdG7k69M1DjHX/giXEtq07A3AfUtrGAnnpLeBkYdnHL+dpstSLhF646V9uMSYzXMn3koYWVQYVtTIcTbIc9cSKL
X-Gm-Message-State: AOJu0YxjRRkkqRFqAC+QyEsvaV4OT12/9R3a6KU3BNcVK3XHTkCcZLqZ
	wkevMIJI9PN/dqrdAoN5tt54IntX/3AlA4FlEmKIOCcSeFMwxjXLKpYyiibI0dk=
X-Google-Smtp-Source: AGHT+IEyD5MBvbEAjbw0tg7O5uE23K2svhSCaSMgsgY2nQ2IFrtDTCQqzK+yEHIFjtQaAGU4qZut+A==
X-Received: by 2002:a05:600c:3b98:b0:417:e00c:fdb8 with SMTP id n24-20020a05600c3b9800b00417e00cfdb8mr8462561wms.1.1713187893433;
        Mon, 15 Apr 2024 06:31:33 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id o4-20020a05600c4fc400b004170e0aff7asm19061196wmq.35.2024.04.15.06.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 06:31:33 -0700 (PDT)
Date: Mon, 15 Apr 2024 15:31:32 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Alexey Makhalov <alexey.amakhalov@broadcom.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Juergen Gross <jgross@suse.com>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, 
	x86@kernel.org
Subject: Re: [PATCH v6 21/24] KVM: riscv: selftests: Add SBI PMU selftest
Message-ID: <20240415-05af8386b8ebe9aecf37c1c8@orel>
References: <20240411000752.955910-1-atishp@rivosinc.com>
 <20240411000752.955910-22-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411000752.955910-22-atishp@rivosinc.com>

On Wed, Apr 10, 2024 at 05:07:49PM -0700, Atish Patra wrote:
> This test implements basic sanity test and cycle/instret event
> counting tests.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/riscv/sbi_pmu_test.c        | 369 ++++++++++++++++++
>  2 files changed, 370 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

