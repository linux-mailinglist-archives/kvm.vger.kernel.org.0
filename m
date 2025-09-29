Return-Path: <kvm+bounces-58983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BD5BA8EE4
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 12:57:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E04B51C12EF
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 10:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1402FDC42;
	Mon, 29 Sep 2025 10:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Et05Pa/X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36572FE05C
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 10:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759143414; cv=none; b=B5mwjzxZ1komyUTuS6CP1l3+b0lyoG8CoZp8dlE41wGewUDkL+8Ju2PtTHWU2WzcV7q+8NPM7b5omsY+Im9KGnhcuR9nRqUx+e0QgYVhpJvaRnBVh0mJZWLWceDVS60Wh6DA7EG1HqysQjclhPIFQYHqPpDzMWClvALIpEfgYeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759143414; c=relaxed/simple;
	bh=Dke5jhzsmCxDfN+1PMDq1SfW1G4fUtvUQCDvbzw0SzU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=imHODhrmsvrv//QO2vJyN1QSY6H2hhQM2w7/8yTGwsXkKoCewiJMwRf4NLKfJFFKIYzu2P+MsALOm6qOykDnOrzWMLMlGz6ZMn0EMd66suoa9glE4+AsdiFB0stVWKvyTw+3ehviWOSEhTKAc6b/t1x3/jGtaoEA7YjLdNmRoGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Et05Pa/X; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b59682541d5so3578657a12.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 03:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759143412; x=1759748212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jnlF0eFQWr0BxLvIHq4uqg9GVwgOdVNiok3YvVZbq0c=;
        b=Et05Pa/XyOm8/6EFW8JWsJsgPjHG8izacmTd59GETQLnaoyCvFDn6hF/Uj1Ry8p3y6
         nj7k/qR/+nGpqJG5Ii48O4hI2h+uafd4p1q+Erk3q7t7+uPhE+sdBhC/SqoUFZVgDqml
         bmnEOzvvB5clxTSNdkb91zY/dru/sI6ZmjJj/XhH5CczypyLvenPSKqrH7ftKrPYf1S+
         koHU30LXRbM1oSYudki4Yq/GaC3tU5ueLikV8nYJf6VrUnzNSpA4gfrlLid4ffHbPk9D
         fosxFiGxgU5KwWvbWrQxd/1Vcf0NtEVED0ae5qM9qVm8fnBj7DLqolapz5Z8Lp/gKvxm
         vCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759143412; x=1759748212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jnlF0eFQWr0BxLvIHq4uqg9GVwgOdVNiok3YvVZbq0c=;
        b=MqYkrlZRFx5uYOUSbFu9Z/IIi38q89zws3oJcGNXzcz4IyAVvnsjk/EQ5BFNiEtpES
         Xl+s3NONuXmSY1Glh8FQuDCSFCE67f+HtDVMDfFQlpW2K2/f8pwKd2HaDIMjEOEk4vO/
         KhJ4MXBrKHG5eWSbC8PVgcVKwfLI6kOCoCdpa5MOTlmOmsezchNbn5N0d0fqTSghsWoj
         1DQhCZHQ4Z2lrwZevGQPLcqRytYmqjbpUfOceLVu2x73PTiFRaxCL7KEG6aXodiSmi0C
         4KtAYnyBHms8zL5cCiKhUNUhX/AxSAWMNAakpGUBOJndKQYxfc7iZ0i+vcmvi/BjL+hD
         kwVQ==
X-Gm-Message-State: AOJu0Yzw3ysmKGPE4AQPNW9bqNFnJ8DePwL6gN3PeZLBxNqsreWeK4NA
	su8QSTTvl8EcBGhDMppOLSi+lVGb2ZTVFZ0VOAlCZCyfDZxehyFSbKPA0jLhx3WFhaPaV7p7F4U
	BmYq6FpbFlH8ybRK4av2jbawadw==
X-Google-Smtp-Source: AGHT+IGVa3dr0UfHdFFHv7a2nhejmco2UUe8ClD2YEi2nAiUc0fVQ4XataHCX+47Wk38A2rAeoA+fcK1m/NCoi2faA==
X-Received: from pjok1.prod.google.com ([2002:a17:90a:9101:b0:330:55ed:d836])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1d87:b0:329:f535:6e48 with SMTP id 98e67ed59e1d1-3342a30be1amr15992420a91.36.1759143411908;
 Mon, 29 Sep 2025 03:56:51 -0700 (PDT)
Date: Mon, 29 Sep 2025 10:56:50 +0000
In-Reply-To: <20250926163114.2626257-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-3-seanjc@google.com>
Message-ID: <diqz1pnp34st.fsf@google.com>
Subject: Re: [PATCH 2/6] KVM: selftests: Stash the host page size in a global
 in the guest_memfd test
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Use a global variable to track the host page size in the guest_memfd test
> so that the information doesn't need to be constantly passed around.  The
> state is purely a reflection of the underlying system, i.e. can't be set
> by the test and is constant for a given invocation of the test, and thus
> explicitly passing the host page size to individual testcases adds no
> value, e.g. doesn't allow testing different combinations.
>

I was going to pass in page_size to each of these test cases to test
HugeTLB support, that's how page_size crept into the parameters of these
functions.

Could we do a getpagesize() within the gmem_test() macro that you
introduced instead?

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

> Making page_size a global will simplify an upcoming change to create a new
> guest_memfd instance per testcase.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 37 +++++++++----------
>  1 file changed, 18 insertions(+), 19 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 81b11a958c7a..8251d019206a 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -24,6 +24,8 @@
>  #include "test_util.h"
>  #include "ucall_common.h"
>  
> +static size_t page_size;
> +
>  static void test_file_read_write(int fd)
>  {
>  	char buf[64];
> @@ -38,7 +40,7 @@ static void test_file_read_write(int fd)
>  		    "pwrite on a guest_mem fd should fail");
>  }
>  
> -static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
> +static void test_mmap_supported(int fd, size_t total_size)
>  {
>  	const char val = 0xaa;
>  	char *mem;
> @@ -78,7 +80,7 @@ void fault_sigbus_handler(int signum)
>  	siglongjmp(jmpbuf, 1);
>  }
>  
> 
> [...snip...]
> 

