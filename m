Return-Path: <kvm+bounces-8060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A654984AAD8
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 00:50:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8ED31C239B2
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E2A4F602;
	Mon,  5 Feb 2024 23:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xfo7zHy4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8B64F5E4;
	Mon,  5 Feb 2024 23:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707177008; cv=none; b=ZBRkmciJWHbHUTSxnZ4HvqYUsc73B2zQh1idDjyTN8fgHk8FNlXFd63vnoHHi2bIKwey4cUKEFDLgVUo2c4S4RKe26J1ZElgvIzGB0UWRLMCIT/oNUCWbRpRkyfzjWOWK5TLV2++h6621v2TxGgpQw5aXGa2IleXsGlKMSxuQYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707177008; c=relaxed/simple;
	bh=eMP+pBzXjOisnrJFlhbgFG68K3/hBnqXW+IrLBhZ78k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uaBc8YDj5+F45jb9I9xKF56UoPKKQSYTNEuFmr0l8xMNCUWNDrniWRR2WPQYOaGqFy3CCU33wZaLHeDezTW8cikkHQFJF9NOZJxvx56CMdLVphBz/AVHRqaaFovjkoAdodgNi/x8BQeDdSPcu7y7expJoh7uQsSrtSodFFXKwJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xfo7zHy4; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d09faadba5so27570711fa.1;
        Mon, 05 Feb 2024 15:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707177005; x=1707781805; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CLaCt86KE4z7cIgRB82YaYKlIDPGoF1DhNw2e1I2B8M=;
        b=Xfo7zHy4QNPRqvIQPzIzSZW7Vlr/zp2/WqQibZpgYzXebE5wMsF2OIyrKirBsyLk3+
         yv4VI4V0GgRevNlv1xNiLHkNqkjkIdz4iLotXPu2INRUy/l1nKV6y3s7tsDLpSIiDu3I
         hrNq5il9AFQwRXw0P4iJYIDeAPQruKtpP3GDSequBpaRn5LmmpMfcj2eDMmR/dnNCmWT
         f6mfnF8WgACGCBdZB53Hb2esBkBBpfMPNh7Xxoa86tnDZhL1NVJqs7+cc6fiifoVyJjZ
         pNFM3ZKrK3Ejig4P2c3ZvLvNABJ49VYjW4De4cX7ygmqfdrrZYfws2rmLLqlDJsR77fA
         ygmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707177005; x=1707781805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CLaCt86KE4z7cIgRB82YaYKlIDPGoF1DhNw2e1I2B8M=;
        b=JdI0YlnlScyAxNsfxgkkrJl4duYfQ+vxgA1UYFCKqV/KTOlm9NJvYO1ZQRJIyeDTwT
         A9PjWYOZn1nIAy25/p8lUjJNqHVv17LgJbYyRwYn0wfj5UzeHHgJx50zi5ih0u3lH6bB
         LCZ6YvLqC7JdLPG2nb4DPBEQ/6YUtEvD4Pq1f5Bu80kzFUXd80Nb3RtsCF0YNDj59cAN
         Z7V5ymIHDtJk1FL2H3c1+sggAwDCfX4B5o2gBpl0mvANFx6EAkbz/bBRZ+RnzUjV9Ew4
         r0gEM2yQzHJ3tdzX0qAGEnybUoJUmUyYdsscL8IHK2WO6cP8jugr+6RXIv9+BZRGkjhh
         W8ag==
X-Gm-Message-State: AOJu0Yxfx/7LSb1G0civGrg5vxltlPZlllNdS7Bt56El75kx+9X7fMaS
	h1pM8lJegjYp6eexIq5xbuADtZfKfSPgIG6815xrGY3ZCfswXCTs2fItg+1Uj/4QT9ZcE+Kzdjg
	3L3PBXOXrZ/nQtewu3aGsMt8sHVlvWXftwhU=
X-Google-Smtp-Source: AGHT+IFYE1LZhi/E5sYl/Oz0mrw3UbzWRJkr47ZufZVv/ndYuIglX10ppT+lRtcfqSkpvWzpqKfM3tFQsAq3pkgWi4Q=
X-Received: by 2002:a2e:7d0d:0:b0:2d0:b291:d017 with SMTP id
 y13-20020a2e7d0d000000b002d0b291d017mr699202ljc.15.1707177004526; Mon, 05 Feb
 2024 15:50:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240205173124.366901-1-avagin@google.com> <ZcErs9rPqT09nNge@google.com>
In-Reply-To: <ZcErs9rPqT09nNge@google.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Mon, 5 Feb 2024 15:49:53 -0800
Message-ID: <CANaxB-yAJf4wFyRgkc+XzAdkC9JUKtx-BoZ=eCV7jRSagjsv0g@mail.gmail.com>
Subject: Re: [PATCH] kvm/x86: add capability to disable the write-track mechanism
To: Sean Christopherson <seanjc@google.com>
Cc: Andrei Vagin <avagin@google.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, kvm@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhi Wang <zhi.a.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 5, 2024 at 10:41=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Feb 05, 2024, Andrei Vagin wrote:
> > The write-track is used externally only by the gpu/drm/i915 driver.
> > Currently, it is always enabled, if a kernel has been compiled with thi=
s
> > driver.
> >
> > Enabling the write-track mechanism adds a two-byte overhead per page ac=
ross
> > all memory slots. It isn't significant for regular VMs. However in gVis=
or,
> > where the entire process virtual address space is mapped into the VM, e=
ven
> > with a 39-bit address space, the overhead amounts to 256MB.
> >
> > This change introduces the new KVM_CAP_PAGE_WRITE_TRACKING capability,
> > allowing users to enable/disable the write-track mechanism. It is enabl=
ed
> > by default for backward compatibility.
>
> I would much prefer to allocate the write-tracking metadata on-demand in
> kvm_page_track_register_notifier(), i.e. do the same as mmu_first_shadow_=
root_alloc(),
> except for just gfn_write_track.
>
> The only potential hiccup would be if taking slots_arch_lock would deadlo=
ck, but
> it should be impossible for slots_arch_lock to be taken in any other path=
 that
> involves VFIO and/or KVMGT *and* can be coincident.  Except for kvm_arch_=
destroy_vm()
> (which deletes KVM's internal memslots), slots_arch_lock is taken only th=
rough
> KVM ioctls(), and the caller of kvm_page_track_register_notifier() *must*=
 hold
> a reference to the VM.
>
> That way there's no need for new uAPI and no need for userspace changes.

I think it is a good idea, I don't know why I didn't consider it.
Thanks. I will prepare a new patch.

Thanks,
Andrei

