Return-Path: <kvm+bounces-60228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99FB1BE5840
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 23:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1182019C702F
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 21:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4EFC2E228C;
	Thu, 16 Oct 2025 21:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mkEcS9UA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB615229B12
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 21:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760648839; cv=none; b=ULCoTQtLTAJ8PD++wAZqBIFziI0R5LthXOAJxiS5Yf/733UanO2ENvcFmQCLqW20bn6IwzqMjIZFSBc6Ng9zRVPn5OfqgSXufgjU1Tghtctm9CXQg0tS70I17aom9ShH+JREY5WEFEdwIkKkvPrKHh6iuo9/86OO1aosz/xA6D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760648839; c=relaxed/simple;
	bh=/PZwiIAPmraOr8DU5gpdQ0hm3ySju3FqvZeZeb5sXQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q0oN6kl2uPBZeDlmquERwfCuqN6LGIQi7316d6wRZNz1mdLtQ7oHWydIy9/xdjnNSJvOZhEkbBXbHB6cbR//hEG7gfI5aHvsqKprRkQHX5U5jgxujyBag5qp+amXv46o1xGkGXuSt20LjkcAkTLe4QXz5+L5nE04q3FUMWzRs4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mkEcS9UA; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b6a42754723so20923a12.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 14:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760648837; x=1761253637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YqKLtcHyZtQvUCKV9AK34ygiWjcxKsGF+96gmD+h6kc=;
        b=mkEcS9UAJzH82Xaf3mmBYfqnCmfGhTpmNrweOOBu9Q5DZZN87AoiAo5MwCIxBJpj1S
         Ro0O1BhuInOLntLvvI1aqTZ3IK6Va+VZNhbKeHqwOmYRt+ym9MzDROkxC/rUMWAiNenV
         S+qxFcKihT8ZlTbXWFhSi5A5jRJfCgG3PbuqtWvLZWthjVWTCRxy4uXfpUfQHTG/Ha5W
         U1V0JoQwNhRKvUMwtcQRm1gqXGk83oNstsUv3C7SCiMMOYlu5j2wOQrI31B4syOibIDt
         4Vc3H+K2zNAtrYceEPWkoI3G1T5fwgTaxN4Wxli1D/Wylz5E/ukb+zCO53ZWVbL1NZKo
         vK7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760648837; x=1761253637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YqKLtcHyZtQvUCKV9AK34ygiWjcxKsGF+96gmD+h6kc=;
        b=RbkaZVpt67QSwQ7+n4uWFgGCp2LW+MVqZW7a6piO+BJl55eWbDLrynyWkjfXcK7rnr
         jkcQ+U6OINpmagPXGYzU5nPcNhyRfh9GvTQJhKAfjAJzJQGz/exjkJlUvkoJK5SZjPyO
         9lAuaOwk9cJedDr1ewL4B7L6n6MXIZgF68OpNrG1ZggH8eZka4fBZdBtu2XJJoLDZOa5
         nidXr/0upG32by6YCDNmRbHs+1CW0nqg/te9FNDEqqUvQFVkq712c6PjPokOjPJn+5Ms
         NLeQalDhKOQECLM+Ya3MrgO+4j7VEjjPX99cCMH/zh+/vAt+Qqo9iuMW2iS4WQU3RxXY
         /9Qg==
X-Forwarded-Encrypted: i=1; AJvYcCXWXxTM72/lynbhHll4aSVBLfuE6BacyVR7i3oJ/Ov0vS6am9MdCUwMjsbAOthkESLprpg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk0AL24cT40XnW0xMZH24cmc0YcGZZDJo1krEW9GiAjhmgZSt2
	U2LvL9Slzh9gKGzfWkcfJypoD14/ce8mOQpfv7NBaAtGfWSyfRIuH7NfSyJaM/+S8SN0kO+dA1d
	kSJxlRIEf34qycka/GXrKwf2Uwu8ITKQ=
X-Gm-Gg: ASbGnctPwngKIce1YfI8J5BjqEP9w+vCCYWuGHoqqCqRfwM4ZG+6QwOwSeO3BBMlh50
	we7qtqPuagVUQWHIU4+iV3pB7/kHePeVcBSgtXQ2qMkb3KLTqqG6Zg5aMMSZ7TihPdO6G7J0WM8
	89T8MlWlEMFcYjXIDg2JrluuzWH4jzkhGY3NH7dzU8gTRthcMDznf3vY+/AqKE0IbJtld0mEH0f
	AbgJB8jb4P0fYHS70Ed3e+oQSKaQHImxX288gCzlWH3O0BUdivckn4ciKJnLmiCSl5v9jvSJSpk
	7bQmSjMq/uR4z/IXgHyZHgC954QSgOxroZNZ5TXM/bUOnJbb+DRTpmydJrNRbQBQ5zhinLTpz9M
	ObKQkfqDcpFArw71+PqhIdafM
X-Google-Smtp-Source: AGHT+IEIgAYtM+PkA8oLdH6dq6tTOHVM2SK/9pf6/KLEGFt0fs1UrG1QtsI18/3/wnm81TfvgNcSQoGgwMXacG4fjDo=
X-Received: by 2002:a17:903:40ca:b0:290:55ba:d70a with SMTP id
 d9443c01a7336-290c9cf3306mr8101005ad.2.1760648836981; Thu, 16 Oct 2025
 14:07:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com> <CANiq72ntKAeXRT_fEGJteUfuQuNUSjobmJCbQOuJWAcNFb1+9w@mail.gmail.com>
 <aPFVcMdfFlxhgGZh@google.com>
In-Reply-To: <aPFVcMdfFlxhgGZh@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 16 Oct 2025 23:07:02 +0200
X-Gm-Features: AS18NWCIqm_srauk6JXkuo1Nu5EkkFsJYyp4maKnlr0nVE8sbB1v3JnElr1TnCc
Message-ID: <CANiq72m6vWc9K+TLYoToGOWXXFB5tbAdf-crdx6U1UrBifEEBA@mail.gmail.com>
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
To: Sean Christopherson <seanjc@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 10:28=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Oh, I take it .clang-format is auto-generated?  Is it a "formal" script, =
or do
> you literally just run the grep command in the comment?

I just run it and copy-paste the results there from time to time.
Yeah, a very low-tech solution :)

> I don't think I care if it's in the list?  I honestly don't know for sure=
, because
> it's entirely possible I'm consuming .clang-format without knowing it.  I=
 added
> the entry based on someone else's request.
>
> Ackerley?

If you are not relying on it, then please just skip it, yeah.

> Is it possible, and sensible, to have per-subsystem .clang-format files? =
 KVM
> (virt/kvm) and KVM x86 (arch/x86/kvm) both have has several for_each macr=
os,
> pretty much all of which are more interesting than kvm_gmem_for_each_file=
().

There is `InheritParentConfig` nowadays, but from a quick look I don't
see it supports merging lists.

So to do something fancier, we would do need something like we did for
rust-analyzer, i.e. a `make` target or similar that would generate it.

Otherwise, we can just add extra macros at the top meanwhile.

What we did last time is just to add `tools/` to that command --
increasing coverage is not an issue (I just started with `include/`
originally to be a bit conservative and avoid a huge list until we
knew the tool would be used).

Cheers,
Miguel

