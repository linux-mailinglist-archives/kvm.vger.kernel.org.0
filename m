Return-Path: <kvm+bounces-54924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED1BEB2B32A
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 23:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BC0F163D81
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 21:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD06266EE7;
	Mon, 18 Aug 2025 21:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ant9n3My"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FCB22D7A5
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 21:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755550880; cv=none; b=lnuEGpcyC4tGSNKqMKpzN+dagjsMCctBUjaBB07rxMFAST3oqMjKm2Hog3H7ypF71cj5ORjBFx4VGjDDpgRhnObOLUSZkf9CQFdzcE8PG3RauwBJSR975zzRbYKaanIuCq0w5aAlzvho3566ECYJo7zCJgTQk7SVEyQ9kbi7XX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755550880; c=relaxed/simple;
	bh=94V2oxncUNCGGpu+Iq+45gM38Y+E66NCd49Ad/nyJWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJ8J1EVKZSLOwA2hFZfeMM6g2PIlZlGfhOd8UKEGO9h0gE9R4+/bhz4qW/peTCuygdaUstIv/kA/IqzNNXJ7mXMuCa0sF/XBBGFWc3KvXT4UxctCahZmRP1Mr5hP5iQvaMfp7iAZioSsv1H2uolYqOUPZQNef+CGEG20nM8NNIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ant9n3My; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-88432e29adcso112961739f.2
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 14:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755550877; x=1756155677; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3nZTzF2lhsZGOWdY8YDL7P1nyHVBb5WBP5wnL3mixY4=;
        b=ant9n3MyhidCzVK4theaKTpSBYdHnNf1AlnxKN4VruncyD/QKO5lRVnBcJxRRl18Ep
         dBvUXCgywKh9f+pydfPoIDRfvxntqWL62fPbARpVwlr4aVNp1sZ1VJfXMuz3qzWY48Fs
         eSzlQ29YVxyFrHBjB5v+owui42xEfoMVri60nVnNc+ehIe4FPjwFR29l7g6aMg1dlr3O
         JJmfTlZdu7td/3gija5voI7T12pTQFtwEJcVXJhzmmyPcgUOd3rLkSaqmrsp+6QcB+vN
         rPX4i1OKaaZc/D2aztEsXR9WQN/dREWhFlGe2JTd+7GJP2bxZvfqkoMwYSjh/TBsFrj9
         d3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755550877; x=1756155677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3nZTzF2lhsZGOWdY8YDL7P1nyHVBb5WBP5wnL3mixY4=;
        b=dtDALQ5TYReUfWT+9QHc9bjqrRS+spmrGGCfsiH7WYpgA3qXblhXXSOl4xHAd1otGe
         TQ5/l2mhbKt3ca9pRljmcsu2xSB25IgtYZ9APQC2UfCWoRpbpW+8KnlnBMi9GNtpWWhK
         uhS4Gnrdu5nLc627FlB96gmcMXdnF2ZmxDbE20qaZb8j6B4iCsQFdf0WiDzUMbuFdEiC
         KhHAd65r3u8ZA6oARazDdBTnyziuek5pSqYx21Adh068bFc5+vEJ4WqhLUN1yLoKZL4q
         iV92B24Ln8r1esnkdJyNKV+RmyaRzWFQe4aS8YMOOtgTIA8BfYK4N/K5PbjHiVqCiC/B
         FQAQ==
X-Gm-Message-State: AOJu0Yz3FecLNMTmW7rqnyun5bCx8sqK+oDmwAneHYHfjz7Pt7Ww3bL3
	69oK4AZPzu/vW6wl3VcIYa3zZ6eWXbwrJXQVApg+rVr2YOwxue6d6SjMnPte2aiqtEg=
X-Gm-Gg: ASbGnctfAYp8b6LEn5C9hi5BLx8HOe/7YyM0CiraUxpcSNObrl7OsogMdF7RG6fzMqf
	lstEPSlyoh1CVe4rrAyrMycckgd6XFbc3QIEvIQjxH9qxVqIhoRYCna/Rq+h6rKRlbOTcPM60He
	B5sQPkdr2wL95ChvKL/fSUf5JazGTVckZMs1IG/UkX3tuUiadDjQsx28NjZhq/kPE/mFLHER24b
	jtvUV7EMfKgv8OqXAnyk5pjEvN52iL/Q6Ka7KRj+3qgVAy1iy8xpsRjoTGf0R2Fzl1wDA5Fjm7E
	kGwcSoaW9qJmkcQX6I1nzZbqyA7XNPrQHyW8vbPM3XnV015uTGOPFsAECfuBz2WAGsJpyRnPBh+
	aRqsQwyvboUZuFUfk3K01dhbf
X-Google-Smtp-Source: AGHT+IFFpFqrnNZItu3L5GNLWSB269pADqOsIU+gIQEJhNsMNbkPMIMecR7fgqDGFDi8X/YtnL7Gbg==
X-Received: by 2002:a05:6602:2cd1:b0:881:87ac:24a with SMTP id ca18e2360f4ac-88467ecf75amr19364539f.7.1755550877544;
        Mon, 18 Aug 2025 14:01:17 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8843f9c47f5sm345226739f.20.2025.08.18.14.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 14:01:16 -0700 (PDT)
Date: Mon, 18 Aug 2025 16:01:16 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: dayss1224@gmail.com
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Quan Zhou <zhouquan@iscas.ac.cn>
Subject: Re: [PATCH v2 3/3] KVM: riscv: selftests: Add missing headers for
 new testcases
Message-ID: <20250818-4672b703d0bf9518ee1d4162@orel>
References: <cover.1754308799.git.dayss1224@gmail.com>
 <cafaa0b547d4a1fc45a38753038c011ea7201d04.1754308799.git.dayss1224@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cafaa0b547d4a1fc45a38753038c011ea7201d04.1754308799.git.dayss1224@gmail.com>

On Thu, Aug 07, 2025 at 10:59:30PM +0800, dayss1224@gmail.com wrote:
> From: Dong Yang <dayss1224@gmail.com>
> 
> Add missing headers to fix the build for new RISC-V KVM selftests.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> Signed-off-by: Dong Yang <dayss1224@gmail.com>
> ---
>  tools/testing/selftests/kvm/include/riscv/processor.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
> index 162f303d9..4cf5ae117 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -9,7 +9,9 @@
>  
>  #include <linux/stringify.h>
>  #include <asm/csr.h>
> +#include <asm/vdso/processor.h>

This is fine, but...

>  #include "kvm_util.h"
> +#include "ucall_common.h"

...this isn't correct. We should instead add this include line to all the
source files that need it:

access_tracking_perf_test.c
memslot_modification_stress_test.c
memslot_perf_test.c


Thanks,
drew

>  
>  #define INSN_OPCODE_MASK	0x007c
>  #define INSN_OPCODE_SHIFT	2
> -- 
> 2.34.1
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

