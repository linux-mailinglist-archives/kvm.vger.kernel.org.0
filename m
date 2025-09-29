Return-Path: <kvm+bounces-58970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6F22BA89B4
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 11:27:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D70381672CF
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 09:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0D42C15B4;
	Mon, 29 Sep 2025 09:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J8PPtgKE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3872C1589
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759137902; cv=none; b=LeDJiS8dZfNP9ZugkRkJ+CLkSQZOClDhO+a2YmRgcACoinN/Ztgl5RnB++cvay8HZ7rWQN2lNMJKrmFlij1dsUGG4Rn3sJIlHFmhhsFAylYvUwKcsjCJ1X4tBolb70bgaRts+joJOkwoeP41BiV2qrzBR4sOju8MTbfHnK1f+D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759137902; c=relaxed/simple;
	bh=k7m4K+aJtZFLKWVc8jWQ8sr+z5w0gd2XHBXW6tMxpJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s5WDEeFxp0FDkiSsk3wST6fbVyH0OE6Nbixx+7Q7pEzmHLdeLu6/uOUTGKGlKjFlOail/iDuJfAhHRL8QMn3YX9lXH8reP2Vg0ZIl+kY9/PumaiM9mHEDjquHN5pw/kaZkde2zBCS4LxICuvJ+NBLONbAeX4IE8ceb9DXk/VrKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J8PPtgKE; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4de66881569so708341cf.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 02:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759137900; x=1759742700; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DiqZP+jaXQfPvRXvTYeDwipIZ/ZZD6l8O3Ef+Y8XAzs=;
        b=J8PPtgKEITUEYoA8u2ufEzmrwGHiS0GlQtiglK4hTaS1g85S9JISNzbJjAxeY1K1sE
         ysnhGIgFGUJq9mQBbdsDYxpIWD0rnjJ+dzASBIMPGa4uD+wlzRUodvMmFA5qh5n0olz6
         3G02vIMqUj8D7fBSCPQ+uLO5FOpnQB32NdS19P6Dp1x/FEnQvmVBORcYg4ob3f2c6d7m
         iI0pl6KTSbNmOkNNGDj5kbQz6iX5QsBhBBPCKzeRYBRPHdMy976+nILyFHCzJmNXquh0
         jPe+VexBNTt/bGDF1STP09rp7GRqAltEnRxo6T4bx2VpDj4pzip/P0LRlbsFGjCFOdmk
         22qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759137900; x=1759742700;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DiqZP+jaXQfPvRXvTYeDwipIZ/ZZD6l8O3Ef+Y8XAzs=;
        b=e09F9XMS54P58Ssvq5kD8TYMoklotVI3rb5DlEEQ8iPokrrAsI2UW9+pUVGiMANxCj
         g4nwk/hpYkeY1JM6taUSLNNWPT5NqkkGYquwN3n25Q1EaXRPjpzEJMDKmnMdWturYku3
         VBqiMk6EHEQMDxa2nmBpCGtHvMunOba1MTnSohilwp63EEhW9O3grldo944X8YBtj/+r
         20YGKyjQV+G7n56HQ/fs+ffTs9ha1HKRYBDjEpCGf8FtTKYryd2MvPKPSneRW/Fat1IQ
         RpL4hXYoIuH3OocwSg3PcNM+PzMtNDSUvhg+u/PK+72fDWHHSsJiMi+9Nd60EH2Xttjb
         NkEg==
X-Forwarded-Encrypted: i=1; AJvYcCVJu5FL26zxQ3uE43+Obmpx3xWO1JeV5sS7l+4OH5QfX1ljqnQThJ5QUwgMQdz586MGsTE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5H8XkU+mxlJIW8MX86SAp9rTR6omQSSntY7H+uWOVQwDAT022
	AfWMmGwVbUy1cqu3tnkgttHXJ/hJ0a+Jmo3cAC7GmqQSIjOJQxvd8N7/BGrU6h/CPFV+RbBMfJx
	HOdoTi4vwnQsurJmnMic82cwN48ptBWBZCiym4drQ
X-Gm-Gg: ASbGncutbePvS5jYmqJx6jKC6uJaeaQc1HxEODAFraPDP5lmk5ZGVJD8DNTk4pLmAJc
	bbum+z1FDRXrvmosWCay7pAB5ugD6PDxjX7vfsaIBN5W5Mu2zx5i1E6nY/oA8/GmWwaGq/Bkp/S
	RgcAKFwA8uEo9d92RJZRJ0ds/W8cFPgWg7tJtk9ZaUJEbA36Y7JAXUeL1ZwktMnW5mjbwbX275S
	EZa2ijRIXkADds=
X-Google-Smtp-Source: AGHT+IFQ8iNdUJ/dn+yIiOcLsPfIuYTxVBZMj9zcBbHfuvDp4OaYAp+Q0ZEit2myRaH+SsdB8/8MgG6EEwxeeHMQElY=
X-Received: by 2002:a05:622a:19a5:b0:4b4:979d:8764 with SMTP id
 d75a77b69052e-4e25aa46050mr395441cf.19.1759137899306; Mon, 29 Sep 2025
 02:24:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-5-seanjc@google.com>
In-Reply-To: <20250926163114.2626257-5-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 29 Sep 2025 10:24:21 +0100
X-Gm-Features: AS18NWAfMEoxah-rFAx3xJCHDi1Byeb9O7GetwQJkuNlfKVEYgWFg6vx0NLG2ec
Message-ID: <CA+EHjTzntT9idx56RB8XuD+5Ja=3jmfNRiqfh79aQqm0kzNDrA@mail.gmail.com>
Subject: Re: [PATCH 4/6] KVM: selftests: Add test coverage for guest_memfd
 without GUEST_MEMFD_FLAG_MMAP
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Sept 2025 at 17:31, Sean Christopherson <seanjc@google.com> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> If a VM type supports KVM_CAP_GUEST_MEMFD_MMAP, the guest_memfd test will
> run all test cases with GUEST_MEMFD_FLAG_MMAP set.  This leaves the code
> path for creating a non-mmap()-able guest_memfd on a VM that supports
> mappable guest memfds untested.
>
> Refactor the test to run the main test suite with a given set of flags.
> Then, for VM types that support the mappable capability, invoke the test
> suite twice: once with no flags, and once with GUEST_MEMFD_FLAG_MMAP
> set.
>
> This ensures both creation paths are properly exercised on capable VMs.
>
> test_guest_memfd_flags() tests valid flags, hence it can be run just once
> per VM type, and valid flag identification can be moved into the test
> function.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> [sean: use double-underscores for the inner helper]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 30 ++++++++++++-------
>  1 file changed, 19 insertions(+), 11 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 60c6dec63490..5a50a28ce1fa 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -239,11 +239,16 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>         close(fd1);
>  }
>
> -static void test_guest_memfd_flags(struct kvm_vm *vm, uint64_t valid_flags)
> +static void test_guest_memfd_flags(struct kvm_vm *vm)
>  {
> +       uint64_t valid_flags = 0;
>         uint64_t flag;
>         int fd;
>
> +       if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
> +               valid_flags |= GUEST_MEMFD_FLAG_MMAP |
> +                              GUEST_MEMFD_FLAG_DEFAULT_SHARED;
> +
>         for (flag = BIT(0); flag; flag <<= 1) {
>                 fd = __vm_create_guest_memfd(vm, page_size, flag);
>                 if (flag & valid_flags) {
> @@ -267,16 +272,8 @@ do {                                                                       \
>         close(fd);                                                      \
>  } while (0)
>
> -static void test_guest_memfd(unsigned long vm_type)
> +static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>  {
> -       uint64_t flags = 0;
> -       struct kvm_vm *vm;
> -
> -       vm = vm_create_barebones_type(vm_type);
> -
> -       if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
> -               flags |= GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_DEFAULT_SHARED;
> -
>         test_create_guest_memfd_multiple(vm);
>         test_create_guest_memfd_invalid_sizes(vm, flags);
>
> @@ -292,8 +289,19 @@ static void test_guest_memfd(unsigned long vm_type)
>         gmem_test(file_size, vm, flags);
>         gmem_test(fallocate, vm, flags);
>         gmem_test(invalid_punch_hole, vm, flags);
> +}
>
> -       test_guest_memfd_flags(vm, flags);
> +static void test_guest_memfd(unsigned long vm_type)
> +{
> +       struct kvm_vm *vm = vm_create_barebones_type(vm_type);
> +
> +       test_guest_memfd_flags(vm);
> +
> +       __test_guest_memfd(vm, 0);
> +
> +       if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
> +               __test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
> +                                      GUEST_MEMFD_FLAG_DEFAULT_SHARED);
>
>         kvm_vm_free(vm);
>  }
> --
> 2.51.0.536.g15c5d4f767-goog
>

