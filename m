Return-Path: <kvm+bounces-60226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 71142BE566F
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 22:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3A0404E9993
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F682DF3F2;
	Thu, 16 Oct 2025 20:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f6uvRg7Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E06C14F112
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 20:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760646516; cv=none; b=A52zHh64QJZETN3vArOBzlYlZq+9eJNlpV117lmqskDyUdNSN9FfiT3RFzW3T6mQkH6Q4ZQBE7FSRnpRpaw9ENOMd9WH1ED1z0DcCcwjN26iuQm4bV06wDY90hJ4JdIbPbLgwm8AOy9qy2Vji1QoJ/qVDMGclunq67G7sUigxsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760646516; c=relaxed/simple;
	bh=0Q40eCSagH0eBhvwze/WcBTb/mvhv4ZZ3cELPBlgvGA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YIYPV+mI5Lf+xA8z28jhag+FbOlZY6LbVfAjOZ5UdZIzSj2j6ePHWRnZGn42wPxvS4Q62X1yTc+gNujKgU6rv5J9psm56o7dQPxLGVFxzqeqX8Mr9CofvEBArSUW3wDpTG3y1DQ3dEN/3TjI55ByQd8yUbokvrVw7d/gdCXG57c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f6uvRg7Q; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bc5d7c289so1171401a91.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 13:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760646514; x=1761251314; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=92VK8FOPojooOIWV+l2v1FHmJALxyLmlS2dAJ/3Uzy4=;
        b=f6uvRg7QQbShAivfWepdGkwuWfv1/xlwl8GJ/W5U9gBHGu/EbTYo6gYbdzwRff1Gpg
         q92Qp9UoC1EYYM13D0oS8pWUJzLLV6GmaMCDglMJ1Z3sUZ0BglDo3FVM7lcYjQRGQxm+
         y/rHAt6PzaLZZnezHwfgQDKzVfQV1yIx2pCrMxt2YzkjfOvAGYzYLLy0NUsg9h+OuVjh
         ImFOlNTcqDKsgWR6Jj/mQnWNFVB/CQZXSjO4wYhE+PL/WRSwLNvPOtJPhMMwtTYrJcLp
         62MFeG0zRX2KGjWsquojqKDaRpSR+x2irgd8jvH1fQzBm9lb3sjZagImQccvwbhg28g2
         1+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760646514; x=1761251314;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=92VK8FOPojooOIWV+l2v1FHmJALxyLmlS2dAJ/3Uzy4=;
        b=oDv2YQ2NX4oiKoV+NNoBinXNcctTjazR9WKTnVHKptBzNAjnCQMAAsAw/jp9YsmBj3
         6R57XqEJ1nhi4oEXRbK6jPUw0r3IE3Uwa375j3Z1PIxgbNVS9IGkDVsNu+YBydKQnVXl
         vW/MygEBbRiBfzlLYf5WHtZfP6T1B/bAC7fa6UYYMfYQ6HgvnQmT283oYxXynHkQk0Oo
         1w7p4g8wt5mEGYm65sx5QlZWPmoEDT9kiftltfp9jXSBDK1rBxRcnxtwXKmE1K94sH57
         Pwmns97HVo4klN+/74Wdfm7rhbN87V1fLs5TPLXkfVwodrlGGTYhvpjp2mCAWlBDD6GO
         hjhw==
X-Forwarded-Encrypted: i=1; AJvYcCWJhr5dIv5HiL9XwqWplaqBQ8zoMqqHEQ+htbxBmqCOxPOIg4ieOZiKmxM+F8xIgVxfHcg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhTI0ia2mKflTTu1v3LqTr+XKmmbs2bMWm+YkJwbP/3CDgBbRF
	s3zxPJKD4dRNmqUmeTDfDTux1BrdgShEvukptdhXK58keUpjJA8DJEsqj/UWldVnoHVoIoCX4CD
	MpJW63A==
X-Google-Smtp-Source: AGHT+IG21/MmBPeuGnH22iEw5Q/v7OFmPy0dksEdBEvBnL6MuloU0P55WAZNWStQXjZRcej0BNndSKWVUlQ=
X-Received: from pjbgz13.prod.google.com ([2002:a17:90b:ecd:b0:33b:51fe:1a72])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f:b0:330:6c5a:4af4
 with SMTP id 98e67ed59e1d1-33bcf93fbd3mr1383934a91.35.1760646514081; Thu, 16
 Oct 2025 13:28:34 -0700 (PDT)
Date: Thu, 16 Oct 2025 13:28:32 -0700
In-Reply-To: <CANiq72ntKAeXRT_fEGJteUfuQuNUSjobmJCbQOuJWAcNFb1+9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com> <CANiq72ntKAeXRT_fEGJteUfuQuNUSjobmJCbQOuJWAcNFb1+9w@mail.gmail.com>
Message-ID: <aPFVcMdfFlxhgGZh@google.com>
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025, Miguel Ojeda wrote:
> On Thu, Oct 16, 2025 at 7:30=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Miguel, you got pulled in due to a one-line change to add a new iterato=
r
> > macros in .clang-format.
>=20
> Thanks!
>=20
> The macro is not in `include/`, right? That means that, currently,
> when I rerun the command to update the list it will go away.

Oh, I take it .clang-format is auto-generated?  Is it a "formal" script, or=
 do
you literally just run the grep command in the comment?

  # Taken from:
  #   git grep -h '^#define [^[:space:]]*for_each[^[:space:]]*(' include/ t=
ools/ \
  #   | sed "s,^#define \([^[:space:]]*for_each[^[:space:]]*\)(.*$,  - '\1'=
," \
  #   | LC_ALL=3DC sort -u

> If that is correct, and you want to have it in the list,

I don't think I care if it's in the list?  I honestly don't know for sure, =
because
it's entirely possible I'm consuming .clang-format without knowing it.  I a=
dded
the entry based on someone else's request.

Ackerley?

> then we should add e.g. `virt/` there or similar, or we could have a few
> separate lines at the top that are independent of the ones generated
> by the command.

Is it possible, and sensible, to have per-subsystem .clang-format files?  K=
VM
(virt/kvm) and KVM x86 (arch/x86/kvm) both have has several for_each macros=
,
pretty much all of which are more interesting than kvm_gmem_for_each_file()=
.

Adding arch/x86/kvm to the "script" in .clang-format feels wrong.

E.g.

$ git grep -h '^#define [^[:space:]]*for_each[^[:space:]]*(' arch/x86/kvm/ =
| \
  sed "s,^#define \([^[:space:]]*for_each[^[:space:]]*\)(.*$,  - '\1'," | \
  LC_ALL=3DC sort -u
  - '__for_each_rmap_spte'
  - '__for_each_tdp_mmu_root'
  - '__for_each_tdp_mmu_root_yield_safe'
  - 'for_each_gfn_valid_sp_with_gptes'
  - 'for_each_rmap_spte'
  - 'for_each_rmap_spte_lockless'
  - 'for_each_shadow_entry'
  - 'for_each_shadow_entry_lockless'
  - 'for_each_shadow_entry_using_root'
  - 'for_each_slot_rmap_range'
  - 'for_each_sp'
  - 'for_each_tdp_mmu_root_rcu'
  - 'for_each_tdp_mmu_root_yield_safe'
  - 'for_each_tdp_pte'
  - 'for_each_tdp_pte_min_level'
  - 'for_each_tdp_pte_min_level_all'
  - 'for_each_valid_sp'
  - 'for_each_valid_tdp_mmu_root'
  - 'for_each_valid_tdp_mmu_root_yield_safe'
  - 'kvm_for_each_pmc'
  - 'tdp_root_for_each_leaf_pte'
  - 'tdp_root_for_each_pte'

