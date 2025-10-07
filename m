Return-Path: <kvm+bounces-59615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D3CBC2E72
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1A793C8492
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A8ED25A2DD;
	Tue,  7 Oct 2025 22:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Xz+mr3W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCD2255222
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759877703; cv=none; b=TTjMoBkIBVphCwqn9uor/wur5+cLMBE1RlTTZvaD3ag7cg2e9xHF/o+0yKlMzrqtv7qRlL5jhP0wNHBs8LjxFuvZc7FB656zJOKshKWa3IH56zn+fZb+eXBpt2PHtGAzAAw7G4ffkMaTAqLk9CnSRddtlVJdXXGhuztUB9E+6Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759877703; c=relaxed/simple;
	bh=8oNP3BZbf1btZ1468oDc50oyYmgfiFq9VwACSNKV4IY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eRk8pS+a76BwivzX7M5SLb4/o6V+Lp3OfK+ACo7FNXCczyw7i0hk0tKxWt0pftOQmkOM95SQfy+aLmLR92SXLZB4gGWLoBlnN3koFzpJjl2BwXyAm+cEv5oL5AuC4Kku8nJ3hIFxxzr4B6tgYRT8yZKaHM3PbFWm6i59IPwIKjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Xz+mr3W; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2731ff54949so44145ad.1
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759877700; x=1760482500; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QMvzl2nrbvAe4h4fchRl02Iz4TUcxMlupJfG41EnDNM=;
        b=2Xz+mr3WLHKRL80v4EP+LIq4071Q7FIzPZjJRV9unaZ+ScsW8H1A306ewURzpI6j13
         atw7SqO+oxmFft72mnxzyPSBmlYfnMr6SL3guva73UY6ZdGiJDaKkYqldC6p5SQJxi10
         7I3e7EsuFjdjQ1LjwupvKNFjAelTd5jQ2z9XsSnZvy6ehJiZbg2MA6TKm2OJ00YumkkV
         TYFzIshJmQQcWOylJul5j3IVDnYusRK7gatZRrjo5sSXrcVcUvU2tPCRfx+aQuO0Rmky
         X7ewB7Md7ndW4vdD2kNgc/IkhwFQ7ffBIUbrbxVwMHfFZ1FCjIeEkc2WuFRuJxPxgdG8
         hRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759877700; x=1760482500;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QMvzl2nrbvAe4h4fchRl02Iz4TUcxMlupJfG41EnDNM=;
        b=Zk/mfrAWLVnbtclYtHc1FWtJoFjMGm0r+X+CbbhIwPRX0lhlVxX4atThx4uTTBkgCH
         f71S/BfznHJzF5sLr9PJ4s/zN8UdklUVbhR3S7FL/8msS2Qadpwy5WVtQBC2ITZ3H3ej
         JjY+eoVNRRbVaTR5RCKqXAsairMRwJ5fKlyPqZ8/BNQ+cE1CCl2TUHoCWswPbkA6Pz4O
         TokewiPJtzkX66tKRRlS8idMzyY9OexZIvnkEmdANifk8bYh2bjbf5gLl14D7ZAv1fc/
         3mpHykWT3jzxJZDe0gl9YvdQZnPdEkt0UnJCWzlBvXxGEqGxbiv1dvwqsFzERWHNuTJt
         ZvwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwE46S7Qv39yQ/M/ABiYUWrIbxtxUD7cSsdBvvNZqS1U0KSn4X/tLo7UanOzqFAjZgzKs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxItlvBUiQSZzWXlnSg7dmxTIyY0rGE25irxry+82bFJ4Id6CNU
	b9AzDSyWAYTzM+7zjtMr5oinSC9LG/WgU7TwApelrB6M1+zu/20TR+fPu+5d4330Ww==
X-Gm-Gg: ASbGnctEPE+5YHZWGaILDG0HeEEokVQO7RGZdhDKb+JA43g5twWN/WxgK3l/Hd4HdHz
	k2Zd40XlMBQDwNVWQ35jZlaQWvXBNSgRVHpov9PPb0LPHuxfTIX47kMFNXsSwwPyM4JB2yMgI9m
	PSEQ+raQyPR8YvngKy23z4szdlcX8LWFul9jX9RJOwWrFuDdtkeGpaUInLzUAkO5U+duqG6xheV
	cB+lgmL7duRc+1XznUfmuw1Vp8dDxYY4dvGi3hmJ2orjOmHGCO7Xa1wC1ZJeGHEUAldzidowZZK
	T0swvErzLcbSz4toboyMCEiPYX6e4bCbXa+4WxpCuw6zAVb3PsFHuPAT3oWMbq6LcTEergdSBpD
	90itRfbv7Xr8sDR0OoxWBf/dbdoIcyYjTRx7fclmyTFk3A1UmPc5R0EV4wbxR5jMMJ9k8df4JpY
	gxvbe6hqPFE3GIfIPi7B6BZwhyHUFl
X-Google-Smtp-Source: AGHT+IG8Nm6+KKK6nouMNhSocbt9fiuZN24e9MLJcH0B6n9gn4kwDgKajjlNaGGEjtfG0qL6q/cyxg==
X-Received: by 2002:a17:902:d4d0:b0:265:e66:6c10 with SMTP id d9443c01a7336-290275dda96mr2685295ad.4.1759877699504;
        Tue, 07 Oct 2025 15:54:59 -0700 (PDT)
Received: from google.com (115.112.199.104.bc.googleusercontent.com. [104.199.112.115])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d12807csm177505315ad.52.2025.10.07.15.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 15:54:58 -0700 (PDT)
Date: Tue, 7 Oct 2025 22:54:55 +0000
From: Lisa Wang <wyihan@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
	Fuad Tabba <tabba@google.com>,
	Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH v2 07/13] KVM: selftests: Create a new guest_memfd for
 each testcase
Message-ID: <aOWaP4n7wsTfySHk@google.com>
References: <20251003232606.4070510-1-seanjc@google.com>
 <20251003232606.4070510-8-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003232606.4070510-8-seanjc@google.com>

Fri, Oct 03, 2025 at 04:26:00PM -0700, Sean Christopherson wrote:
> Refactor the guest_memfd selftest to improve test isolation by creating a
> a new guest_memfd for each testcase.  Currently, the test reuses a single
> guest_memfd instance for all testcases, and thus creates dependencies
> between tests, e.g. not truncating folios from the guest_memfd instance
> at the end of a test could lead to unexpected results (see the PUNCH_HOLE
> purging that needs to done by in-flight the NUMA testcases[1]).
> 
> Invoke each test via a macro wrapper to create and close a guest_memfd
> to cut down on the boilerplate copy+paste needed to create a test.
> 
> Link: https://lore.kernel.org/all/20250827175247.83322-10-shivankg@amd.com
> Reported-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 31 ++++++++++---------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> [...snip...]
> 

Reviewed-by: Lisa Wang <wyihan@google.com>
Tested-by: Lisa Wang <wyihan@google.com>


