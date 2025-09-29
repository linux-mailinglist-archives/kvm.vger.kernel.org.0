Return-Path: <kvm+bounces-58984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD70BA8F53
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 13:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EB50189F224
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 11:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1975A3002B2;
	Mon, 29 Sep 2025 11:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UJI893Zn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2722FE59E
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759143750; cv=none; b=BtK0rmr3LdFK7ouiqaYmRWXcmK6llLoUHMNA/YSP2PjR7uja71r1aKYRav0hAlfBAzEl2drp3rI+wZyWzxoaDXCbk5kGbi8pyinTGs040eS8pHo+4fdDLjnO6x5VovdYKBdME+bj/ZiPATYswCxj+XuKY7NlBu3O5Rd+bZEgwq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759143750; c=relaxed/simple;
	bh=OEUy7JaWPeXS2Ype1uvWF0qyiWgASok2ncKtO4Y4Mac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Sgblf5cUMyaJA6zKqknTqpgxTX7TdAfjmPehjAmUXKadj7UWBRljPxFlSvOsYO/72/qVGTqOqBtAYW9nzcoycVyNC/RP2VhZemgGplzFOFbnz+2dhgzTXkfZuWAgIoQXRc07n8BwkwHU3g8weJDd0axk69nw0/titL73tUdYeKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UJI893Zn; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-267fa90a2fbso54477625ad.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 04:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759143748; x=1759748548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qtXGlwWwUlaQk0BF4qliyTbm6pNsB+T8OxH6HQs+mvE=;
        b=UJI893ZnVkKqWJE+Yas7gUzYFutuvgsJ8l25v010reFjpSOYQ/YzPRqLw2uqyrHdJr
         3G9k4liKd9PkL+JBVRVX3UZb/AJDUakkrkkzZ069fn9UrpblLsINAVHt+KY/8EU+H1F4
         hG6ePKx4kHhKgy0RrnHUJWkdSjprGyUfRxte1pD35rBRSjs3qg7OkH0fcwlCRGa8kO7X
         EfWgNMO8lyoPZ9v4aXmtr8ESS9euMMZhX+WGmrdjrG6jotDads+g/KAZrCjVNG5eWGAA
         y2RDRCwUuFxpU2i2uHv18QxJqoSCgQJglt1bSM0MA6a5tYLLWe6uk41hlpt50w2coPac
         5WFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759143748; x=1759748548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qtXGlwWwUlaQk0BF4qliyTbm6pNsB+T8OxH6HQs+mvE=;
        b=h3jMYORtLPoSHnRTY6MBoNKgOBt5X0dTEFBUe8SSYynmHRHpxR82ERbDY79RkUBKUs
         AMqGVjRv9LNtlFSUKB1l3ytLnIHuJZjPnEH7EYv9UsRmtMkLH9eCkAK3J+Ua+TWOxS4n
         t96uHeobYxzW6GHnJ+dYGD+TzeLMkasXcuSRAUZSl3aVPuPhSdXVXy5PPZrBAyf0hFEc
         zxZXvLZRNGZzNN32syGnNT/N5h70mtN39jh5btHE5PJTgO5d4sDDG64mtOWzXuWiMTU0
         SX9gP/fnNmnXZHBB+JDVhDLfCT3l2oheSQuNcZx6/7akJQFE+IRo4ivAEgh92+33To8H
         GoTA==
X-Gm-Message-State: AOJu0YxZDKjXdRFH91hGTTsqn+KPFdwByfabf2jP+bYuBnxBJkaa3GfH
	bOQuxpwh1hjhyvbsl1POqim/B8lbYZUP7iabqjo3idxYzIpUQHnTcBi1+65lTJ4hJJ8HR05yMAN
	JrHgarH3XHvbrHOzuoaA5mj2VTQ==
X-Google-Smtp-Source: AGHT+IEcSQC2/7RCpSj05s6B6MxghOWFZfy3etlV42502KzdeZsbh90GRnuZksSIgdfE1mOYTr6TRXFNOOA5WMB/Hw==
X-Received: from plpm10.prod.google.com ([2002:a17:903:3dea:b0:269:8295:538d])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2ad0:b0:27c:3690:2c5d with SMTP id d9443c01a7336-28d16a45ef5mr1792685ad.0.1759143747796;
 Mon, 29 Sep 2025 04:02:27 -0700 (PDT)
Date: Mon, 29 Sep 2025 11:02:26 +0000
In-Reply-To: <20250926163114.2626257-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-4-seanjc@google.com>
Message-ID: <diqzwm5h1pz1.fsf@google.com>
Subject: Re: [PATCH 3/6] KVM: selftests: Create a new guest_memfd for each testcase
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Refactor the guest_memfd selftest to improve test isolation by creating a
> a new guest_memfd for each testcase.  Currently, the test reuses a single
> guest_memfd instance for all testcases, and thus creates dependencies
> between tests, e.g. not truncating folios from the guest_memfd instance
> at the end of a test could lead to unexpected results (see the PUNCH_HOLE
> purging that needs to done by in-flight the NUMA testcases[1]).
>

Lisa and I ran into this recently while working on testing
memory_failure() handling for guest_memfd too.

> Invoke each test via a macro wrapper to create and close a guest_memfd
> to cut down on the boilerplate copy+paste needed to create a test.
>

I introduced a wrapper function but a macro is a better idea since it
also parametrizes the test name.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

> Link: https://lore.kernel.org/all/20250827175247.83322-10-shivankg@amd.com
> Reported-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 31 ++++++++++---------
>  1 file changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 8251d019206a..60c6dec63490 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -26,7 +26,7 @@
>  
>  static size_t page_size;
>  
> -static void test_file_read_write(int fd)
> +static void test_file_read_write(int fd, size_t total_size)
>  {
>  	char buf[64];
>  
> @@ -259,14 +259,18 @@ static void test_guest_memfd_flags(struct kvm_vm *vm, uint64_t valid_flags)
>  	}
>  }
>  
> +#define gmem_test(__test, __vm, __flags)				\
> +do {									\
> +	int fd = vm_create_guest_memfd(__vm, page_size * 4, __flags);	\
> +									\
> +	test_##__test(fd, page_size * 4);				\
> +	close(fd);							\
> +} while (0)
> +
> 
> [...snip...]
> 

