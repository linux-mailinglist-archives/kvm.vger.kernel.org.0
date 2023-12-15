Return-Path: <kvm+bounces-4578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1031814D37
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 17:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E39A21C23754
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 16:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59FDD3EA96;
	Fri, 15 Dec 2023 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b="FMziPy5F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F803DBAB
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 16:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=networkplumber.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-28b0def5d30so406703a91.1
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 08:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20230601.gappssmtp.com; s=20230601; t=1702658207; x=1703263007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aJvYVagYHhoUh6izHlhrfd4VlIqIxeyLW6YH9/IOyR8=;
        b=FMziPy5F0KuuWbuqia792leGIkEYU7QDEsuclB9QFip9dubN5SF+2PDn8809rmnxjK
         wMl4/DjHttWumZ8JNKgouE6nNNdjGPJbkUWzvuTrg7izvDguTeO22lhyWP4d5F6NUjjv
         WEnEVqSnaCtRLYN8UOKJcTytt4fPr0Fz1+SfOKCSELF8j7CNdjAy+ttS3Iu9ENbaJSTR
         c/WyjxpScQosXyDYH82FyxqAlfLw3qFVra0/rKsTvt07kgX3Oh+qYC1v2wLwcPlTrten
         Dfzn9qqzinuyvyPsX24hjsF3Meu6uw+htdB5Zs/puf76TwPgA4A0cs+j1hWs8w44Ejcq
         liBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702658207; x=1703263007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJvYVagYHhoUh6izHlhrfd4VlIqIxeyLW6YH9/IOyR8=;
        b=hr7G6Q6Of705EO8e+88ee5NUjEl8DykwJx4GiMO/8wKwS5aKciHI1MGj/03LZpb0Ym
         XMunFw/3GwRyPWF4UXEJ1fn2Sw712/7WK7mpo4HbrFF2V2fZdQVLihWat4U2gj4H/wDX
         8mIYYtI91IIMkIZmvKshOjAZDKqz9dAXyD2CBikMT35T41/83+7UMZinX9syM3xAu+0E
         a3KxgloEUvtaF6GO8rOm/kkiOw/MOuPT+Xy2+kcMHFF7pAdSe/LJAQ6bYZCo+TDfirY2
         h9evj5AeeRnC4X5Dmbw4yucMs5Pjjl2btkf71eXYilpfddvDm0VtjDxYKj8VUDo0iEYE
         wx9A==
X-Gm-Message-State: AOJu0YyYCpvwxWDEWRkdFUE5M5i5K4qXCLO3s7CoyYFBnC3gWCYKY1hr
	1yyYoKl8cTzGZLWExFGaMlvigQ==
X-Google-Smtp-Source: AGHT+IFeZMff91cUpMEe/cVJxJ+9czTxTnqQpAPTa8UZm78P42ynaIIY0rSElsDc43O0h3A+3heBEQ==
X-Received: by 2002:a17:90a:4687:b0:28a:efa3:682f with SMTP id z7-20020a17090a468700b0028aefa3682fmr2312037pjf.74.1702658207601;
        Fri, 15 Dec 2023 08:36:47 -0800 (PST)
Received: from hermes.local (204-195-123-141.wavecable.com. [204.195.123.141])
        by smtp.gmail.com with ESMTPSA id h5-20020a17090a9c0500b0028ad273525dsm6353303pjp.25.2023.12.15.08.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 08:36:47 -0800 (PST)
Date: Fri, 15 Dec 2023 08:36:44 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>, Alexei Starovoitov
 <alexei.starovoitov@gmail.com>, Jason Wang <jasowang@redhat.com>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Yonghong Song <yonghong.song@linux.dev>, John
 Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa
 <jolsa@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Mykola Lysenko <mykolal@fb.com>, Shuah Khan
 <shuah@kernel.org>, Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew
 Melnychenko <andrew@daynix.com>, Benjamin Tissoires <bentiss@kernel.org>,
 bpf <bpf@vger.kernel.org>, "open list:DOCUMENTATION"
 <linux-doc@vger.kernel.org>, kvm@vger.kernel.org, LKML
 <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 Network Development <netdev@vger.kernel.org>
Subject: Re: Should I add BPF kfuncs for userspace apps? And how?
Message-ID: <20231215083644.4dd9a323@hermes.local>
In-Reply-To: <72b8e198-7058-469a-a1e0-17f48330deca@daynix.com>
References: <2f33be45-fe11-4b69-8e89-4d2824a0bf01@daynix.com>
	<CAO-hwJJhzHtKrUEw0zrjgub3+eapgJG-zsG0HRB=PaPi6BxG+w@mail.gmail.com>
	<e256c6df-0a66-4f86-ae96-bff17920c2fb@daynix.com>
	<CAO-hwJKMrWYRNpuprDj9=k87V0yHtLPEJuQ94bpOF3O81=v0kA@mail.gmail.com>
	<0d68722c-9e29-407b-9ef0-331683c995d2@daynix.com>
	<20231214094042.75f704f6@hermes.local>
	<72b8e198-7058-469a-a1e0-17f48330deca@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 Dec 2023 14:49:56 +0900
Akihiko Odaki <akihiko.odaki@daynix.com> wrote:

> >> It is exactly what BPF_PROG_TYPE_SOCKET_FILTER does, but it lacks a
> >> mechanism to report hash values so I need to extend it or invent a new
> >> method. Extending BPF_PROG_TYPE_SOCKET_FILTER is not a way forward since
> >> CO-RE is superior to the context rewrite it relies on. But apparently
> >> adopting kfuncs and CO-RE also means to lose the "we don't break user
> >> space" contract although I have no intention to expose kernel internals
> >> to the eBPF program.  
> > 
> > An example is how one part of DPDK recomputes RSS over TAP.
> > 
> > https://git.dpdk.org/dpdk/tree/drivers/net/tap/bpf/tap_bpf_program.c
> > 
> > This feature is likely to be removed, because it is not actively used
> > and the changes in BPF program loading broke it on current kernel
> > releases.  Which brings up the point that since the kernel does
> > not have stable API/ABI for BPF program infrastructure, I would
> > avoid it for projects that don't want to deal with that.  
> 
> It's unfortunate to hear that, but thanks for the information.
> I'll consider more about the option not using BPF (plain ioctl and 
> in-kernel implementation).

With libbpf, things are much better. It is just that projects like
DPDK have to support wide range of kernels including older versions of RHEL.

