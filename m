Return-Path: <kvm+bounces-59537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11DF8BBEEE9
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 20:22:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF76D3AD304
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 18:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC372DF717;
	Mon,  6 Oct 2025 18:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WLu6zL4h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A13E27A12B
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 18:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774965; cv=none; b=tYFaUcsYxkxlNmUsytkokDQBGgEVGvS1XrwJiRT3vIrIJRB/eQtdzwn4pj4suoF5LPDN1IdaJ8vUBi1m2S73u2xj5ZF8sP8LmNGWKenpbVMmL/tbXzHMldcOKmI/csbV8ZI1Q00jZpfRKNuYYiN9mTAYvEqsMUw79ab2rNB/coI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774965; c=relaxed/simple;
	bh=m7paGbWFFBSImtX6nHJNm0p7ZiwLv+r3xgGqbIaxnZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GYahxwiQVy2inWgqQfiYyvXsU3yZKJ7FE7SAfVO4PYuglC+0tdk95ZnoZTGh1CAhLlFuhquPlw1zXiQpJgfD2vMCpgLcwh48ALFUsXfqHbPP1aEfoO1FdUxlYBMQLomJHbkUgwDHzCPynYp7Ix26Scj9cSL/13859P9d74TKTt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WLu6zL4h; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eae48beaaso4673192a91.0
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 11:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759774963; x=1760379763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YN0oMwvKdUWgqAuB19e9YFtlf2v/xKc04bK+lsGf56U=;
        b=WLu6zL4haK923ijbGCGrBakcJCIBcYV+fr08zvzjSVYVap//YGxvZDw67cqvLUfVyV
         ayYf6OIifBbJ4c7XicKrxEdkoCnaCyo8uaTvKh6zmbWttxWQmE2k5Z8aOjLhULOL9nTk
         pzCKGieI4MmuN1hOH8TtX9ZPGkCXRALVXD5S7FFGDZoG8eRy/6FB+mbCYtUrnfZyVTGQ
         3QshBAvoDSwkOz0FSYYAHcL6SnmqMawmA4rNTcl/aQ0kCceqbHx34xJueHMzyNckh2OI
         F0N6DoW+SsuJND/pjOqua4o3j+Vc1C7vcEkyM59gYO7QVV7AXDnhJkf6MHM2KmaGL12o
         oxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759774963; x=1760379763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YN0oMwvKdUWgqAuB19e9YFtlf2v/xKc04bK+lsGf56U=;
        b=hP+0JNI3A5R6UFrkXec6U8PfPu3lG6Ait8z9TTa3gtMQHvYTlZL9dZWVRD4kl53A9u
         1y/AUWhJ2fnXVUmU0m5Wnpls3xr8BlvfIS4NflqqGFOuePTDMu2BFznAWYVaUCZFRAfI
         G27un6KcqZ2fCV6StZU7akIIxrLM3sAGFlSs6suAUw4/gTD0d+DJUfAfBfSTf8RjrOWU
         zYPTEh2XXyysQqHf4lL0VQHU+2sJ5t3q3BpojFm90PH2RlslskrTGolKzUatHZ/irs3W
         aWOlLW+Acrzzb9GfF1bbp+f3oDbb0id8kXG31FcwtyjU4xlIgLbwV+2QzpVU7OjnkZF/
         eiSw==
X-Gm-Message-State: AOJu0Yx4FbqIc3q7QbOSkX4FCburPvK6j2W7J1HuVjIbSqOVgqymciy3
	2rSAdsb9yPewdgymwzeKrlMnwe9X7+cbs+AhN/ddRvvfFS7hXdJao2hYMCZaei6OGG3LK6r43C7
	7HcQJQNJ2tIsu5W5xJvnpn9Dgxw==
X-Google-Smtp-Source: AGHT+IHFncbPWDhVRLIgPUtpUh3hqv+dcSxTiha2K3meOqKbz/8kUQgGm6FLuTXkR5xpnKPelQkZBZJkQVo0GM3Z6w==
X-Received: from pjbpx12.prod.google.com ([2002:a17:90b:270c:b0:329:ccdd:e725])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ec5:b0:32e:1b61:309 with SMTP id 98e67ed59e1d1-339c27865b8mr18152084a91.23.1759774963468;
 Mon, 06 Oct 2025 11:22:43 -0700 (PDT)
Date: Mon, 06 Oct 2025 11:22:42 -0700
In-Reply-To: <20251003232606.4070510-14-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com> <20251003232606.4070510-14-seanjc@google.com>
Message-ID: <diqz5xcrgaa5.fsf@google.com>
Subject: Re: [PATCH v2 13/13] KVM: selftests: Verify that reads to
 inaccessible guest_memfd VMAs SIGBUS
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Expand the guest_memfd negative testcases for overflow and MAP_PRIVATE to
> verify that reads to inaccessible memory also get a SIGBUS.
>
> Opportunistically fix the write path to use the "val" instead of hardcoding
> the literal value a second time, and to use TEST_FAIL(...) instead of
> TEST_ASSERT(false, ...).
>

The change the use "val" isn't in this patch, and I think the
TEST_FAIL() change was intended for another earlier patch.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/guest_memfd_test.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index f5372fdf096d..e7d9aeb418d3 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -84,6 +84,7 @@ static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
>  	mem = kvm_mmap(map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
>  
>  	TEST_EXPECT_SIGBUS(memset(mem, val, map_size));
> +	TEST_EXPECT_SIGBUS((void)READ_ONCE(mem[accessible_size]));
>  
>  	for (i = 0; i < accessible_size; i++)
>  		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> -- 
> 2.51.0.618.g983fd99d29-goog

