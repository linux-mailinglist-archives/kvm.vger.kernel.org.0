Return-Path: <kvm+bounces-11556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 499AD8783D3
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 16:35:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0025A1F22376
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3544144C6E;
	Mon, 11 Mar 2024 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dJwcv1pR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5414043AD8
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710171209; cv=none; b=gg9MZxv3i7mSAffu/KJbqXbLC+v4STBXifcnsgzHUybsxpX4GX2zi7bzhJkrqWBoSqz9+ruDttuujs7QnmHwjoBLk6bqehkaZLHu/XdqrlArICmwqfqG4qBy7Gsg0Duh7ipe1bx1J7LqVN9+ywshDkPDbvXh7k0pV6mLANwQf9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710171209; c=relaxed/simple;
	bh=BgmEJ3rVgpfdYftpb1oT1hFKBsa+dHuEMI7KFS3YKKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fybh6qJ3ethfKNW7mUPhERF2gCSZ2AnK2kBwsRANCv5VhRPuaDhvKCjqcgAHuyX5jjfaqu5raz9knugyfOTIg3733zkrYwN8obYk4JVQsf31368wNZ/eU4oVLBjigwKTU1t9WxGI6O9PUO/ZSmv8NzEh2wC9BuL8w54lpoqkG8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dJwcv1pR; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-33e70d71756so2312034f8f.1
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 08:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710171205; x=1710776005; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BgmEJ3rVgpfdYftpb1oT1hFKBsa+dHuEMI7KFS3YKKE=;
        b=dJwcv1pRXt1NEg8C6Yi1HmGKmM1bgJHlwO3TI4MW25AMUHS8M1M5SYPW2btsBfgyh7
         mSt4zhfLAW/wjwuIXEySVOS7t/b5XIz+rRJYRAAO0ttvHXdio3VvMwqQKv8KJ48hOajd
         EvkTyEs1vfmh5GWSDZk3Ga3Y2fQ/uHIsMr5wz3kp3mL8nOTPFFnNznGbu9wIMKHCEFhV
         5MvMecm+GFcYyl5AAiY3huyliN44mQvXHWsLr3EZ2DtzKAPDc2z+Rlf52UQ5Rn+0rBEh
         wQuwihdwA44f81upfJqwQKaMsWFzt0dVwQFqX3bn4MsVTsKJK4z03LRDqpWpGL2xDwUC
         2uEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710171205; x=1710776005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BgmEJ3rVgpfdYftpb1oT1hFKBsa+dHuEMI7KFS3YKKE=;
        b=SumYH/sgpyirKR7uJyj8GRnK+FqDawUunwQhA3uCulchl+U4BYv7LKEeNNURYVWvWZ
         ui7I0oENe9lotct/okhJGJ59BaPfXB/LMwS6boQfxF6nbkaGLCDVtRKqsoBG5oO2STjC
         3g9o/nci4++sUA9czFAd/xlUxAzdmd2cmh5R28hL4cZT8agYXF5ADKV29jmjhr9TLlX4
         Z1vbely/V/6Vl1Roc8SYeKB91N47dCkcZoxtF4NYU5JwlebAj5m/S2jszZ09oitxCeLn
         x9PmBl6n6yBiOQ3pvjEOFA5NVTG1vRWtcC4q7D/F8SA9YH+yPV0Nxr/Jzgilfr2pywi5
         JrDg==
X-Forwarded-Encrypted: i=1; AJvYcCXrO9u9pgDLDi4Sr+JEYoCc4s/kVBSVMrLiaEnirLzUSm9wL+O34gRJrQAak7YOCDrXSWc+Jh5VK10Mal9Ne8LAOCZu
X-Gm-Message-State: AOJu0YygVixX7mF8MgHEt54qL27QCzH0MaqvdiEjOH5hPt6lJCbZsZrT
	GpXKzZLA4p75/axDeEafK6hxCgNmFgKCx4zjra9ZZuGWy6EdJhSsjjADFsIiTmTE8iudqvbiRt1
	iYGJdG2X0Tf38c1U29zDUzrVBbCzQ8O18zlEN
X-Google-Smtp-Source: AGHT+IE/th4Pg/GBs04QnTLC4gySgD/Ced3Hwsh9xlJGW37qnBqN80Ztb15KeaRy40uSPOSKwYSAYx2WXmVslFbnrPM=
X-Received: by 2002:a5d:6751:0:b0:33e:1f2b:8cc5 with SMTP id
 l17-20020a5d6751000000b0033e1f2b8cc5mr6816452wrw.0.1710171205375; Mon, 11 Mar
 2024 08:33:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240310020509.647319-1-irogers@google.com> <20240310020509.647319-14-irogers@google.com>
 <CANiq72=rgXk6oz65wb57ZP+jmSoD-a4SSVzU6s6SZLubV3cvBw@mail.gmail.com>
In-Reply-To: <CANiq72=rgXk6oz65wb57ZP+jmSoD-a4SSVzU6s6SZLubV3cvBw@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 11 Mar 2024 08:33:10 -0700
Message-ID: <CAKwvOdkMYnYO2hyJEFj-M_iur6BneEZjPHvsodZAGw=b7PmmzA@mail.gmail.com>
Subject: Re: [PATCH v1 13/13] tools headers: Rename noinline to __noinline
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Ian Rogers <irogers@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Kees Cook <keescook@chromium.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Liam Howlett <liam.howlett@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>, 
	David Laight <David.Laight@aculab.com>, "Michael S. Tsirkin" <mst@redhat.com>, Shunsuke Mie <mie@igel.co.jp>, 
	Yafang Shao <laoar.shao@gmail.com>, Kui-Feng Lee <kuifeng@meta.com>, 
	James Clark <james.clark@arm.com>, Nick Forrington <nick.forrington@arm.com>, 
	Leo Yan <leo.yan@linux.dev>, German Gomez <german.gomez@arm.com>, Rob Herring <robh@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Sean Christopherson <seanjc@google.com>, 
	Anup Patel <anup@brainfault.org>, Fuad Tabba <tabba@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Haibo Xu <haibo1.xu@intel.com>, Peter Xu <peterx@redhat.com>, 
	Vishal Annapurve <vannapurve@google.com>, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-hardening@vger.kernel.org, 
	llvm@lists.linux.dev, Christopher Di Bella <cjdb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 10, 2024 at 4:25=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sun, Mar 10, 2024 at 3:06=E2=80=AFAM Ian Rogers <irogers@google.com> w=
rote:
> >
> > [1] https://clang.llvm.org/docs/AttributeReference.html#noinline
> > Reported-by: Christopher Di Bella <cjdb@google.com>
>
> Out of curiosity, was this due to the `[[gnu::noinline]]` or similar
> in e.g. `src/string/memset_explicit.h`?

Yes, and in src/__support/threads/linux/thread.cpp's definition of
start_thread().

Thanks for the patch!

Acked-by: Nick Desaulniers <ndesaulniers@google.com>

--=20
Thanks,
~Nick Desaulniers

