Return-Path: <kvm+bounces-60239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D92CBE5D5A
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 01:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 114CE5826E5
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 23:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1702E7653;
	Thu, 16 Oct 2025 23:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aHniw2w2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3412405E8
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 23:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760659063; cv=none; b=RorewWudHcrd/4gsiZZDFAjJ0nuCxpOWbBLHuxYn1OcfU1b5lNU7sr8QKcC3TAmQXWI86hzLfxm2GuVrNjN0VZXQkIUkFhLYgWDkzl8CLIHqcLVhBlCGzzbDu8uoSQ9JfRqrIPK8fY3ITbEC3DHt6Yvdn1LeopFx405lXN0NcM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760659063; c=relaxed/simple;
	bh=vOAdDSYX83kzIXZY6k7808Nqc/n1Jrd8SmNl/kz/Z8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=io5no29qakhSJXHbz414xkEyth0zSvbZIqcppZli2y12k3nXFo2B+hWuR6aULcb3V3fooVabUhDvMzvPvYBzYAM2DgwOtfloEkh3yVT8gcD2WmFK/syFv82W5Ap0XeKWvI/dBX79tpsBBizXysB2zlSfOEFoOLDYoSiLA4zAwjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aHniw2w2; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7810912fc31so1358112b3a.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760659062; x=1761263862; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W+gFerwj7sc87prcy/GQMGpAh3zQW+FK7X8HO9E9Qn8=;
        b=aHniw2w2SDaL4IJxRvGmkLFIsclKYQemiQ+qGd6tcbSvVkcwfX46Crd1eSwE2wnbtv
         MeR2UOnx64hZ4IM6GvsQUB9FKFcHQgvTklIT3F3OBy0LqXoifHJTJbGP2zTG1huG3rl6
         mKUdN32w+KN8E8S9+OOGPXD6xLnKhEfkMbpANWoUM2FFNp7X8ZeTaaAXoSRaRTaE3mpL
         VGIS7qkPs5ZxbTlcoj3IdBZb8x7A2jNo84m0EQpkViYAZu9RlNtzoDCv1QASHbOzdF6M
         3E/12nUQ42WGc2ByF7X/a8sZHDPaEaaIakHXGNc5kXU2VPzU/ebsmZiT7IvUiJouzM8J
         z+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760659062; x=1761263862;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W+gFerwj7sc87prcy/GQMGpAh3zQW+FK7X8HO9E9Qn8=;
        b=gsz9cfYfT81NEKCfAUtsVKfpNF+zryNOcrTKMhfI0Nx0H4UeNJPcdz6wFL0/NoDeVJ
         8KK93nKJis+DyGkbVjwpqJS/2uJLavkHgbgB/yyTKPPCG1aVDEsJnLMaay/41WIuNE9D
         zrFtMwOht+fnBYRQnwx31auoUEnvdsYd5HwQtNCzbKxYGXLdkfjC/WShkLZLr79+GES+
         3NO5eSTOeWwyjc02oAGgzlAUVi/2Gyx8YWCSbjlhq0BsTFFsOyfSWgHeD7CAR6n1r4eF
         HsvKQs6orKC+oc22LV8lKBhxaVDbRXmHJ+2HQaTkGBp4iMnmQXf5zM5dFM2dl8AJoMsM
         wzhA==
X-Forwarded-Encrypted: i=1; AJvYcCVUDfuiQlvtK64E4kzAhq27wVb8xakZErtEExvaGzQHwfjpfbn2vNXhNaysipz+eH1Bt5E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkKyaEG0eyLf5YyNkZSq+XC1bFd4bzKLiWuTba/kdHYwv+UWFL
	MAtbZKX0rjJK7tikgvi3gPmGTUMUWhlGlSiX392VQsASBsZKvmMvh7TwY//v9WRbUZjdy7saVMl
	8xoCtlIySwS5Hiej0Wk0wG/wDhw==
X-Google-Smtp-Source: AGHT+IE2GZ6bYZtCSD13nlTnA7H2MPbbvOsHzo3LQjiehRmABnDXMBoSAsb+4L5uxVyy1gpfUlSoXNG9qcSb1xRc+Q==
X-Received: from pjyj8.prod.google.com ([2002:a17:90a:e608:b0:33b:9959:6452])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3992:b0:334:a99f:926 with SMTP id adf61e73a8af0-334a99f0c06mr1602497637.11.1760659061843;
 Thu, 16 Oct 2025 16:57:41 -0700 (PDT)
Date: Thu, 16 Oct 2025 16:57:40 -0700
In-Reply-To: <CANiq72m6vWc9K+TLYoToGOWXXFB5tbAdf-crdx6U1UrBifEEBA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com> <CANiq72ntKAeXRT_fEGJteUfuQuNUSjobmJCbQOuJWAcNFb1+9w@mail.gmail.com>
 <aPFVcMdfFlxhgGZh@google.com> <CANiq72m6vWc9K+TLYoToGOWXXFB5tbAdf-crdx6U1UrBifEEBA@mail.gmail.com>
Message-ID: <diqzqzv2762z.fsf@google.com>
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
From: Ackerley Tng <ackerleytng@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Shivank Garg <shivankg@amd.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> writes:

> On Thu, Oct 16, 2025 at 10:28=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
>>
>> Oh, I take it .clang-format is auto-generated?  Is it a "formal" script,=
 or do
>> you literally just run the grep command in the comment?
>
> I just run it and copy-paste the results there from time to time.
> Yeah, a very low-tech solution :)
>

I assumed someone was doing this from time to time, and I ran the grep
command in .clang-format but IIUC it only reads tools/ and include/
(which doesn't cover this new macro) and so I thought the "automation"
would miss this new macro, hence I suggested to manually add the macro.

Using the command on virt/ would pick it up. Would it be better to add
"virt/" to the "automation" + update .clang-format while we're at it?

$ git grep -h '^#define [^[:space:]]*for_each[^[:space:]]*(' virt/ | sed "s=
,^#define \([^[:space:]]*for_each[^[:space:]]*\)(.*$,  - '\1'," | LC_ALL=3D=
C sort -u
- 'kvm_for_each_memslot_in_hva_range'
- 'kvm_gmem_for_each_file'

>> I don't think I care if it's in the list?  I honestly don't know for sur=
e, because
>> it's entirely possible I'm consuming .clang-format without knowing it.  =
I added
>> the entry based on someone else's request.
>>
>> Ackerley?
>
> If you are not relying on it, then please just skip it, yeah.
>

I'm using it, I believe clangd (my lsp server) uses it to reflow correctly.

>> Is it possible, and sensible, to have per-subsystem .clang-format files?=
  KVM
>> (virt/kvm) and KVM x86 (arch/x86/kvm) both have has several for_each mac=
ros,
>> pretty much all of which are more interesting than kvm_gmem_for_each_fil=
e().
>
> There is `InheritParentConfig` nowadays, but from a quick look I don't
> see it supports merging lists.
>
> So to do something fancier, we would do need something like we did for
> rust-analyzer, i.e. a `make` target or similar that would generate it.
>
> Otherwise, we can just add extra macros at the top meanwhile.
>
> What we did last time is just to add `tools/` to that command --
> increasing coverage is not an issue (I just started with `include/`
> originally to be a bit conservative and avoid a huge list until we
> knew the tool would be used).
>
> Cheers,
> Miguel

