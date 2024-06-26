Return-Path: <kvm+bounces-20513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12ABE917584
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 03:22:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAB0F1F236FB
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 01:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFEB0EEDD;
	Wed, 26 Jun 2024 01:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GkZGMvfg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A85428FA
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 01:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719364919; cv=none; b=OMFQhqeYVAkuOKAC72qV4AKVdmN8wES6FoYavoVSL6zAwywRg91bh5jSer/BuWN3Sf+xfrCJXEm/Qt/3TAuCcxwvxJLnj5hQSyEhnwqXRia/a0yHc6nFOKBH7jH8KaOdGVcelkNlMDvd1J08oHI/bSz4SS4FgplZomhBPVMkI9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719364919; c=relaxed/simple;
	bh=UFZ9PY+GDSA9BNrYdHIS8Xjr5b2tAoCZFEY+1AZ/7t0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IuMdv7PLg0D0Zleo/NpJji7kiMZTQchK1fhcKaHt6P7Lq4QQa10DukRcYWvNYXkdI47TFZl0XsElcC40SuHw3/afGDpTZliU1LktLu72Ayz3k2ugBA2WBoTm9m5rAVnvUpgQGKDCD9JFE0nn4RWnurTsvdE66OPID0hk1TIjasw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GkZGMvfg; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57a16f4b8bfso4220a12.0
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 18:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719364916; x=1719969716; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDXzXy/x3VAMGE4telAkJ0AkS3Dvfn3YkfUIsKfqDwQ=;
        b=GkZGMvfgAI49yVVsmSpWIGoHLaoP/xV0isZn8oFvvVPA44TeI1mDa1usl22SkfHZ5u
         rlwjzez2s5Df+2/G4Vf7lu2vyZ/iisy8LiJV1I9erVTdIHEFXRnxZ8I+4dWrqGNHjuw7
         jO39BrsSc7a2cIgXC7p9iMGXIjfPj3a1BT4s2AMEe65QaIBvLYZdOrxFhpAS1J6X1pbQ
         m5ejjxU4byMZ4LXZWwQB/7al2dMMBjxdTKIRiCSplmiyBBe1T/IMGbjmbNV4o82WFwPP
         /8mU5irTWLC/SkU4NuLkCICMOwlvFMZWvKMPrH8QH4JS63Fss+k/0yLJGiCeb5YeZWV4
         RQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719364916; x=1719969716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MDXzXy/x3VAMGE4telAkJ0AkS3Dvfn3YkfUIsKfqDwQ=;
        b=gw10CGB0bKUz4ED8d5/lbLgPa8fvrwO83Qm3fqYVZ7fS9HKAvKQ46Gi3OFEf6K8IQm
         QQPt7DgKTa2ukdJql82++3IxIPpBHfnCrFblLkSI9y+dXHWb9D5gjPCjJF69YF2EFNYN
         pO1kpCuG8MGs4Pn5bdz2qoTYG2x2NBLpYHCO7JQf5I+pbhCpF1ZuEx+UQhWGwwHm912p
         ZbgIG8b7OMfmN+6QPupUgWT/JiCmh5IZswPz6XIRoMAK9b5Qryq0kUN4G+unbQbHxJ1s
         pw71fda1xPdpx3/ZBMPAyXpYZMtl//6bggEYJVgYKZCfTXupXK2NwogfVck2I/+c9awT
         P80w==
X-Forwarded-Encrypted: i=1; AJvYcCUPHSc9pbjmDUNSn21PCirj574YFdfZyQNxCXn3O6sMXh5HQdX7091gW/6UEJMAaBxb3k4UUaJlI4Lo8prGIzuO5hSI
X-Gm-Message-State: AOJu0Yw2J+Mxu7xOSPptuQqeNUWLTkABzTCmL47ckkPSu3Fv8GJ4rwTT
	28pcahud6SVCHDwfNtilMZV8Q1uCezMZxu3GzQN+hIxm0KQbBJyGh8XpZ6ibq4Yj/ilmPLqax6A
	P88HTOv9EUODekb3D4UiTLud6vbo7UvZ3a7kI
X-Google-Smtp-Source: AGHT+IHX6Dw13lvp9tA5r1Nr3EDVBrqZjzt46+AZrMqkD9VDrFcqyfsc9zQwLVqS3nH7c8fc7LBij/O5GqbVZ/GRwBU=
X-Received: by 2002:a05:6402:350c:b0:582:f117:548e with SMTP id
 4fb4d7f45d1cf-5832c353bf0mr116598a12.0.1719364915083; Tue, 25 Jun 2024
 18:21:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240624232718.1154427-1-edliaw@google.com> <20240625135234.d52ef77c0d84cb19d37dc44f@linux-foundation.org>
 <f975fe76-92f4-4af0-a91d-0f3d8938f6b2@linuxfoundation.org> <CAG4es9V0XAqe-eqPgjU+sdRS00VOEr0Xda1Dv-gtfEvqsODjiw@mail.gmail.com>
In-Reply-To: <CAG4es9V0XAqe-eqPgjU+sdRS00VOEr0Xda1Dv-gtfEvqsODjiw@mail.gmail.com>
From: Edward Liaw <edliaw@google.com>
Date: Tue, 25 Jun 2024 18:21:27 -0700
Message-ID: <CAG4es9WHUSC7qm_6fJjQm5nM_iYEjXO75DWC8e5tzqc7fLEtfw@mail.gmail.com>
Subject: Re: [PATCH v6 00/13] Centralize _GNU_SOURCE definition into lib.mk
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kselftest@vger.kernel.org, 
	Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, usama.anjum@collabora.com, seanjc@google.com, 
	kernel-team@android.com, linux-mm@kvack.org, iommu@lists.linux.dev, 
	kvm@vger.kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2024 at 5:41=E2=80=AFPM Edward Liaw <edliaw@google.com> wro=
te:
>
> On Tue, Jun 25, 2024 at 4:34=E2=80=AFPM Shuah Khan <skhan@linuxfoundation=
.org> wrote:
> >
> > On 6/25/24 14:52, Andrew Morton wrote:
> > > On Mon, 24 Jun 2024 23:26:09 +0000 Edward Liaw <edliaw@google.com> wr=
ote:
> > >
> > >> Centralizes the definition of _GNU_SOURCE into lib.mk and addresses =
all
> > >> resulting macro redefinition warnings.
> > >>
> > >> These patches will need to be merged in one shot to avoid redefiniti=
on
> > >> warnings.
> > >
> > > Yes, please do this as a single patch and resend?
> >
> > Since the change is limited to makefiles and one source file
> > we can manage it with one patch.
> >
> > Please send single patch and I will apply to next and we can resolve
> > conflicts if any before the merge window rolls around.
>
> Sounds good, I sent:
> https://lore.kernel.org/linux-kselftest/20240625223454.1586259-1-edliaw@g=
oogle.com

I realized that in this v6 patch, I had accidentally sent it in the
middle of a rebase, so it's missing the last change to
selftests/tmpfs.  I've fixed it in v7.

>
> >
> > thanks,
> > -- Shuah

