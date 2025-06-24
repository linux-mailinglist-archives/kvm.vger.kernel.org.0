Return-Path: <kvm+bounces-50583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C6AAE723D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 00:25:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEDC9172ED8
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196E125B309;
	Tue, 24 Jun 2025 22:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="buv57NB9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9DE256C8D
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 22:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750803898; cv=none; b=JqB3WlghaPnNriEt6Afp4IFrtHbWcCAiI/NtceTzol9ustW/umW0HyJmDR3H6aninuZmdX82Wy5+GkA46H/GUC/zjLMc7Ig2xk3hGfXEV6uMEwawi78HHlMBcycEB1XpE/4oxvq27b86vcSylGoUcfT4CzueNjYQj4ypzA2LQ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750803898; c=relaxed/simple;
	bh=M8tRp22/sMyuUqR+0IZG348DKuT3gZaLvfRP63Puse4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qazC718VkTbljv8Oq/gtz9CU48juZ9LIwfCMpaAJx2MD+ncgN4bNzKmxyJnahOEBdYYT+OH6knXua5yE+U37f4wJtXNYxD5CuxmCOlpLSyaIIg/WC3+C4hIXhwgIlKRsdKQ2vle20l6qb+yTmBfBJgNFupSLZRdocUWfuIEVfCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=buv57NB9; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234fedd3e51so56836315ad.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 15:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750803896; x=1751408696; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x+RRmxw0vNc+MjGHudRfd1EOnvQItAaBcR+Qj3ylW1A=;
        b=buv57NB99U4s0OTkxIRgGzq924OyhZCCxlUdP7Ez35ULEf2sdM14UnnHJxAHNtTVu0
         HAoIycv7Fh3a4zwXTwadOakNKWIUSkD7PylQ3XrVr0njV58AxPrL9+pG/yM3VUoaBlOU
         dPiySEFy6ZMPXDWuiuPFhBsGGupRxaVU+kvW7tFFSfBBL4rMiBRkMVlRo8dmCTP0T+wJ
         95Z9SjG/cqjAWa0Z0/DGWXrNLJ3Hod7UY39d1GwRbU1q+D2lwmJoabrD9dFDs2R+9how
         ENYmUOyk0oAfKRvdAGwd4epfPQ67DTFQddWqqkxotx61Y4/IouzFQSBdBea5I6XxQ/Je
         J8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750803896; x=1751408696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x+RRmxw0vNc+MjGHudRfd1EOnvQItAaBcR+Qj3ylW1A=;
        b=R1jqWwX7b4+60zmJFLfZjTQA5TzjG4D0CR2kw5NluluBLgE7oeVTARl/Ab9L9Al5UK
         1wjWOYYOzWmSHUkjxfaT7i0S2KhstC/sJUev6nt/4VjXldo9y9JLUIiI0B01IZKp6xF8
         SXYnPUYdczBka/nl87+X92EtyLQXIk46kMqTkpY1m600GmTXUu3ysIzP2Lz4hwnBEzHe
         SbyPGL82QKf0CFi4HPhJ7APCS5mHrSHhWj6J+bPycYN7yhhv5NGkF7FuR22rqZxJCn5b
         MtHUA2YV51Yq87RLgPhgbE2K5vi1Mi81UDUqDjcKJbKwH13iTmRlQD2SXlMO4BqG1tjK
         Rk0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVPi3VIK/rVxvD+f89cNyZq5/jcBLo92RM+AqvrDOU3Ly0HLcgURMf67F60950Kaf6d05U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIl5KCkCCihWQmcD0tIv8BmNm2D3jETenSpr8+YonCEzeEg/BY
	2hfwaNRhqndCkCTR+mr+hZxKpml+BxVvNFe+Fs2Z122Qrpdk1MNcS6u2Bzripkkte8RD4/mXKJo
	On6+ZAg==
X-Google-Smtp-Source: AGHT+IGBeu5ngyY1yhhSotJLBYldYv9GqeNgeeCIEhnaSUDNylXnlWXHbMuRvZbrjLbKWwSscRNgfealq/k=
X-Received: from plbix22.prod.google.com ([2002:a17:902:f816:b0:234:46ed:43f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:244d:b0:237:c8de:f289
 with SMTP id d9443c01a7336-2382404744cmr16704635ad.36.1750803896230; Tue, 24
 Jun 2025 15:24:56 -0700 (PDT)
Date: Tue, 24 Jun 2025 15:24:54 -0700
In-Reply-To: <20250530185239.2335185-4-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250530185239.2335185-1-jmattson@google.com> <20250530185239.2335185-4-jmattson@google.com>
Message-ID: <aFsltm1Ce24OA0nd@google.com>
Subject: Re: [PATCH v4 3/3] KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 30, 2025, Jim Mattson wrote:
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 5649cf2f40e8..b6c707ab92d7 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -10,6 +10,7 @@
>  #include "ucall_common.h"
>  
>  #include <assert.h>
> +#include <pthread.h>
>  #include <sched.h>
>  #include <sys/mman.h>
>  #include <sys/resource.h>
> @@ -2321,3 +2322,19 @@ bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)
>  	pg = paddr >> vm->page_shift;
>  	return sparsebit_is_set(region->protected_phy_pages, pg);
>  }
> +
> +int pin_task_to_one_cpu(void)
> +{
> +	int cpu = sched_getcpu();
> +	cpu_set_t cpuset;
> +	int rc;
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(cpu, &cpuset);
> +
> +	rc = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
> +	TEST_ASSERT(rc == 0, "%s: Can't set thread affinity", __func__);
> +
> +	return cpu;
> +}

There's already kvm_pin_this_task_to_pcpu(), which is *almost* what is needed
here.  I'll slot in a patch in v5 to expand that into a set of APIs, along with
a patch to convert the low hanging fruit (arch_timer tests).

