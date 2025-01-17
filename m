Return-Path: <kvm+bounces-35826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 897FBA1546A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:32:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0F807A3241
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9ED1A23A6;
	Fri, 17 Jan 2025 16:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iyYRqjzB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F6B1A2388
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131507; cv=none; b=pvycBfS6W+9D1AijYnvtWrEB04RBg/CT5BuhYL7o8ecos9EAYIPRtCkCYL3iI+y+tZ8bCs7Fdi8bRwNckc1ui1yyrWHSRn5dCGs031Q3NhIAJURBBjD2Hbh3wXUXJYCIPyssILT9JuM9SwJiGnpdfYqGEjOM7mYh586RfoHuqf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131507; c=relaxed/simple;
	bh=WztnRYS3SHfqd24LqnEIzWOB8UahJSVf2y0QXe0PqfQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ss5Q3/AkqDBJmJIvpeA+CuLYs8+UderQM2l/ENTzKapdmWZyco47PADiXYi7T45L7xtLbAkygFnhYEaIUMzVyTehCzWoQA2YNijqy7qXGyV4OgWRtB6lA6oCNlua38CMrQh0HQbBhE8uKB9ivtJXEsD+ZSCXYYGoo8r5AV96PTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iyYRqjzB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737131504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PO7Vp/9rycoIjRaujSsXUtjeQeNilIlBSnpxR2h4ix4=;
	b=iyYRqjzBjoShwphmXfX3xvHQdjA86LNK547DuZ7nJuUmjW7CJ2QSxjVDu9CSywz8NlJmn8
	DzoDVgl0FBp1lBifhnWcQz5vF5QgEGB2ER21dJkYHXUDqcqf+oGZDYsXEMe+5vAiTfxE6R
	kC9GNHkCoqqi7nggt2WT5kqsn71Repo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-aqQB4WgJOGKPXlnhk9dIJA-1; Fri, 17 Jan 2025 11:31:42 -0500
X-MC-Unique: aqQB4WgJOGKPXlnhk9dIJA-1
X-Mimecast-MFC-AGG-ID: aqQB4WgJOGKPXlnhk9dIJA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43626224274so12206265e9.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:31:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737131501; x=1737736301;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PO7Vp/9rycoIjRaujSsXUtjeQeNilIlBSnpxR2h4ix4=;
        b=W+rf4uQLUz2LOR96hjCSTZmOJ43OzqN612ZxurapHKLLpEnRDO+30CRUQAxUZlA8Pu
         ejNNNEIwU4OW1NcmLpGiy8o1vtH45/EF2grs3SQ6qHdwG5obV5jHA6b3QqUrybfS4cK+
         ru9/kvIPN1Saa+bWNF4pZQp2v7ifq+KYH29f4zfvQqN905m8+cbwhPeRWv+Ltjnj4dLJ
         JP86KvDSKo8kwZxktAABsXD1na3S7TDrk1Z5NCRhvYhuxQ8+3IzMtiW3Qdm8husmVi1h
         LJ+9ecBZ9LpxsEU+Ph3xmKOkMLWIK1I4nVKvZuMVaqToRIttCjVxigUbw7eUUBCnJA1w
         X5gg==
X-Gm-Message-State: AOJu0YwrQeqmDIEqO7eExxR5pq1MK1e9iYdRkcLwwbQjM3MtqJM9m6jq
	cUyRtjXCM+VYsAmnUIIQ9AdL0pwcJtHthBgH60i6QggI0aRK/GfZw5sxJSQGcIt7I1Bs5FfvO6+
	+MN/FK9AaQBjgQhWDJnW66nucbaD6yBTy2zMKnfCosVp4udr4zQ==
X-Gm-Gg: ASbGnctyTdkvfiEkBd9bEsHQDYsCFa69Thvx9It2dyfFRxEqLXSHLbQdpasy4QpujCJ
	UbdiJGnRkZqwLxLweeRVO50gvESOiEqbobx6xkJWLli6gm92SXQVNYhAcyVeVgxlM/R/4AWGIWc
	QkZlN7JIxa6pxq/NAHSdtulyVeIY/ymSJbu2QjPIK6UZSidnzZlwEdvc/Vidk1+49cNU5Hq1xYP
	xFSXN6OWFqvles84j2HFgvWKanz9rQHQqLynuzggxrIyrN/U84=
X-Received: by 2002:a05:600c:4ed4:b0:434:feb1:adae with SMTP id 5b1f17b1804b1-438913c8604mr33777285e9.3.1737131501382;
        Fri, 17 Jan 2025 08:31:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7yqnGbLCm33qy20LN561ANPRSjGH5vrUeYQY0yeDItL/1QpZAkKqPioghVTCaGkuubyJg5Q==
X-Received: by 2002:a05:600c:4ed4:b0:434:feb1:adae with SMTP id 5b1f17b1804b1-438913c8604mr33776875e9.3.1737131501038;
        Fri, 17 Jan 2025 08:31:41 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438904084e7sm38322605e9.6.2025.01.17.08.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:31:40 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Dongjie Zou
 <zoudongjie@huawei.com>, stable@vger.kernel
Subject: Re: [PATCH 2/5] KVM: selftests: Mark test_hv_cpuid_e2big() static
 in Hyper-V CPUID test
In-Reply-To: <20250113222740.1481934-3-seanjc@google.com>
References: <20250113222740.1481934-1-seanjc@google.com>
 <20250113222740.1481934-3-seanjc@google.com>
Date: Fri, 17 Jan 2025 17:31:39 +0100
Message-ID: <87frlh8kr8.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Make the Hyper-V CPUID test's local helper test_hv_cpuid_e2big() static,
> it's not used outside of the test (and isn't intended to be).
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> index 4f5881d4ef66..9a0fcc713350 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> @@ -111,7 +111,7 @@ static void test_hv_cpuid(const struct kvm_cpuid2 *hv_cpuid_entries,
>  	}
>  }
>  
> -void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> +static void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  {
>  	static struct kvm_cpuid2 cpuid = {.nent = 0};
>  	int ret;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


