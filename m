Return-Path: <kvm+bounces-2247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C497D7F3D69
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 06:37:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 549EFB219B2
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 05:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C89156CF;
	Wed, 22 Nov 2023 05:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="em2DzhAj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F101818C
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 21:36:39 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6c4eaa5202aso6439963b3a.1
        for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 21:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1700631399; x=1701236199; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OPmH0R/ZGatN6+UwwJY3MEok1l+rZDRi+gW+Psbpgp4=;
        b=em2DzhAjzA6+M6CAZujzfRwbEZCqdGSRYk74aXSfvrwfC9i0A5Oyz+J+5tXb6LB8dK
         pb1g2PGElnuo2VdvsfPqhH/zL4esxIz8rbH83DzmAT67TQcpdWYKKVZUIut7hb1C1Dbk
         SSU7+oZWwp6PD3mXy/vhPNk2gTDZAD15xboH/Ew9BYswQvTRf1/GEiDSNQyn9VaGj5b4
         uApyRPYUw0IJVUcMc8WuX08ZPTfmQ8+6n3cXr8qZCA5fJ6k/UaM5+Ibswq/4Y3EzKHvu
         R9g/W7fzIJjmilMuHgWda6NsgQYaM4/F5jzzQu3bTAx4UkOXhFHVQUVBoyK2tkqx17Ww
         LxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700631399; x=1701236199;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OPmH0R/ZGatN6+UwwJY3MEok1l+rZDRi+gW+Psbpgp4=;
        b=OC1jE8MnDdZiQ9zj6C+sAdOQeH+tp7zleMVssgejFDzhddfTK2N9KRxPSjCkoijHXq
         LXPTXhp3v/B5UQDIHbBsl9XmEV0/XPEFhSwquPw3toDn+jytxhl44+ViWfWhMdzpsDtI
         d+q0XSiUyMOETNy2uQgM2FvptiTGCx00i37VdsqvkAYgM2RF+y1dCv5Jw/JxM41xm3t8
         a5aCQ7ecXZSnMhT5d8ynoOg6CZxgHa6m5Jb5D1FUBEcTvcr04cwSdAWiSkvQZIFqNRN5
         ORz5cLdyILHifKzAHsnjdwk1bd8+wmbP5BtUnHIlbdurEfQrht8PEJ6LBY//EzdqOvfE
         C5MA==
X-Gm-Message-State: AOJu0YyGREZ9BWU67RNczgvpr17vzw+M/Kc00YBEJvZGOivuGZEwXL8K
	tAyz5JV6v/OCyp3vRkNqOsZrHA==
X-Google-Smtp-Source: AGHT+IE67Eq9oO1uEot/zjxOXNvgyCk21nCZbXVKotApAyu3bet6Avb8lU17DWWWT9joNIuvOnZhJw==
X-Received: by 2002:a05:6a20:8f1d:b0:17a:e941:b0a3 with SMTP id b29-20020a056a208f1d00b0017ae941b0a3mr1395905pzk.39.1700631399364;
        Tue, 21 Nov 2023 21:36:39 -0800 (PST)
Received: from [157.82.205.15] ([157.82.205.15])
        by smtp.gmail.com with ESMTPSA id gj13-20020a17090b108d00b002839a4f65c5sm454781pjb.30.2023.11.21.21.36.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Nov 2023 21:36:39 -0800 (PST)
Message-ID: <664003d3-aadb-4938-80f6-67fab1c9dcdd@daynix.com>
Date: Wed, 22 Nov 2023 14:36:32 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/7] bpf: Introduce BPF_PROG_TYPE_VNET_HASH
To: Song Liu <song@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Jason Wang <jasowang@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Yonghong Song <yonghong.song@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>,
 Jiri Olsa <jolsa@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Mykola Lysenko <mykolal@fb.com>,
 Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Network Development <netdev@vger.kernel.org>, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>
References: <20231015141644.260646-1-akihiko.odaki@daynix.com>
 <20231015141644.260646-2-akihiko.odaki@daynix.com>
 <CAADnVQLfUDmgYng8Cw1hiZOMfWNWLjbn7ZGc4yOEz-XmeFEz5Q@mail.gmail.com>
 <2594bb24-74dc-4785-b46d-e1bffcc3e7ed@daynix.com>
 <CAADnVQ+J+bOtvEfdvgUse_Rr07rM5KOZ5DtAmHDgRmi70W68+g@mail.gmail.com>
 <CACGkMEs22078F7rSLEz6eQabkZZ=kujSONUNMThZz5Gp=YiidQ@mail.gmail.com>
 <CAADnVQLt8NWvP8qGWMPx=12PwWWE69P7aS2dbm=khAJkCnJEoQ@mail.gmail.com>
 <9a4853ad-5ef4-4b15-a49e-9edb5ae4468e@daynix.com>
 <6253fb6b-9a53-484a-9be5-8facd46c051e@daynix.com>
 <CAPhsuW5JYoM-Mkehdy=FQsG1nvjbYGzwRZx8BkpG1P7cHdD=eQ@mail.gmail.com>
 <dba89d4b-84aa-4c9f-b016-56fd3ade04b2@daynix.com>
 <CAPhsuW5KLgt_gsih7zi+T99iYVbt7hk7=OCwYzin-H3=OhF54Q@mail.gmail.com>
 <a1f09866-a443-4f74-8025-6cdb32eb1d2c@daynix.com>
 <CAPhsuW4o5o41a+jVjgGP+Ck3eUD8w6coLXMTYewXKJYmciLLnQ@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAPhsuW4o5o41a+jVjgGP+Ck3eUD8w6coLXMTYewXKJYmciLLnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2023/11/22 14:25, Song Liu wrote:
> On Mon, Nov 20, 2023 at 12:05 AM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> On 2023/11/20 6:02, Song Liu wrote:
> [...]
>>>> In contrast, our intended use case is more like a normal application.
>>>> So, for example, a user may download a container and run QEMU (including
>>>> the BPF program) installed in the container. As such, it is nice if the
>>>> ABI is stable across kernel releases, but it is not guaranteed for
>>>> kfuncs. Such a use case is already covered with the eBPF steering
>>>> program so I want to maintain it if possible.
>>>
>>> TBH, I don't think stability should be a concern for kfuncs used by QEMU.
>>> Many core BPF APIs are now implemented as kfuncs: bpf_dynptr_*,
>>> bpf_rcu_*, etc. As long as there are valid use cases,these kfuncs will
>>> be supported.
>>
>> Documentation/bpf/kfuncs.rst still says:
>>   > kfuncs provide a kernel <-> kernel API, and thus are not bound by any
>>   > of the strict stability restrictions associated with kernel <-> user
>>   > UAPIs.
>>
>> Is it possible to change the statement like as follows:
>> "Most kfuncs provide a kernel <-> kernel API, and thus are not bound by
>> any of the strict stability restrictions associated with kernel <-> user
>> UAPIs. kfuncs that have same stability restrictions associated with
>> UAPIs are exceptional, and must be carefully reviewed by subsystem (and
>> BPF?) maintainers as any other UAPIs are."
> 
> I am afraid this is against the intention to not guarantee UAPI-level stability
> for kfuncs.

Is it possible to ensure that a QEMU binary with the eBPF program 
included works on different kernel versions without UAPI-level stability 
then? Otherwise, I think we need to think of the minimal UAPI addition 
that exposes the feature I propose, and the two options I presented 
first are the candidates of such: the stable BPF change or tuntap 
interface change.

Regards,
Akihiko Odaki

