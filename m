Return-Path: <kvm+bounces-34357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 037F89FBF39
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 15:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28AD51884DB1
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 14:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABCC21D63F3;
	Tue, 24 Dec 2024 14:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PUz+qWUO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A8E1991DD
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735050798; cv=none; b=VDR5kaX7kpeMOfrdg27eVYgZeVQcGo54rlXWVruzIUyq8Bex4w+Z9pUK/ZAivgU7CZ4jOVyfgURy5d0d1ehtyHbCVNnP9r37OT9xtzQrqLIS7TJd71+lkyHyQA6dj6Iqd7cMjacl67ca5p5M93IqMSlS7BrV1eutJtlfpfmIebM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735050798; c=relaxed/simple;
	bh=7JUSGGoHV2rxyC/AQK5IzXSTKsOdEgHfyOQu4Tuc3XU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xsr9kjagBVjv2DmnZzO0GDzFxbRY08kW82kHBAoS6mTpz029wzk2ccPhSa9tfTr5553eQTVnE+Yj0OAyYtJ7ncoprX8Ddx222zDxIe93/5f3tKC25+ppT3OBd+dkK+BomG9aWCPoykuWIDR+yI3dfcU0ItMzN1v8OmZf/D4sbPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PUz+qWUO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735050796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=32Eol34l3XxYmjJ0B9XcwZyf4vPC3+f8itKhD7UVmHE=;
	b=PUz+qWUOls588j6RuqhLtpldvoHtWe2u7Q7GATHF49KLMhHANTre8npwB8zZ48vBGeAfar
	es/2njA+sKfsTWow9nkh1EE8uKh6HsDGkZZGGy/TtLx5nA4QmusAC4FTDPJkaB4Jd3jlJS
	3rlvIQMS9gfKzYpzXW44C/3ubuoBNQE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-Do7sKu8vOg66-xqRBnSncg-1; Tue, 24 Dec 2024 09:33:14 -0500
X-MC-Unique: Do7sKu8vOg66-xqRBnSncg-1
X-Mimecast-MFC-AGG-ID: Do7sKu8vOg66-xqRBnSncg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361eb83f46so38968225e9.3
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 06:33:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735050793; x=1735655593;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=32Eol34l3XxYmjJ0B9XcwZyf4vPC3+f8itKhD7UVmHE=;
        b=iYL0I4V3aAOKvYPQR29RhPFMHwzJWrmEhE7kWcR26Gve5gays4y37CJV4LzYd/V0PS
         KDNG1qbdI8lEML4YV5PikNI52nfP7Zwp6RY6WVy4eBMzeWIOddhJXiVP+i8LheIn+TBZ
         G9uz6DvH5YNTPjEDtJEAFIzK59STsjFeSSJofo0cFqiyIVeGCAFrHzfu+x+18F7CDbw6
         pp75BJXW+tTiDrP8qu6WasGJPcY5YMWEhFJxQ0BU5JeNCF6jpRp4w3gf+97NL++YMqaq
         HLkvJNheKO6f+3lbZVvxR7NpRDHyp7lmsxbaqz+0YzKqooBoUoBMAPk6b3oAHkohwjp6
         WELg==
X-Forwarded-Encrypted: i=1; AJvYcCUxPbsIOgBla6DhkNXUGbtLQa6YLEjf0LgwvkBVVDP39pYlglHqKaacPB+QoG82rnz3ar0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeAeDLQXzkfKl6Kg2uq66lNMZvbDOzz2oHI4MWAg8HwR7sv3h3
	RFjYk8zpk6yBnm3UQih8TPYzEE1/jFA74vwM88fthvGFtbzJJM2rPnEOZ4W33H4LjSwZIw85Rrm
	pJtfxL126zgJ+lDyssZsT7ZuXeOX235FcMFFWvZQTYtmktBBXVg==
X-Gm-Gg: ASbGncs0j+1ZSiuUht9qUb/owaSylUvxEcUfRbhLsbKvPMwyebDBYRfMMhuGh9UCuw1
	QV4eC+VJAmcHCW3lxyDZaqx0Axug9KejRDgdGowViMWVwUVhN72Trf6ZYuSqR7x4pyqZZ/1277i
	grEn0u/GO0FV/MSfr7t4paEwGgwR29C2HCHxSGts3Sp52aoQYUJG1nRg5WsUereyEd11ygD1SXc
	KQCi/LX8Re5RC2q6gV9QvPRue5ruAll7Es8NgZvMqn6gtr7KYftwWPnWAIH
X-Received: by 2002:a05:600c:3110:b0:434:ffb2:f9df with SMTP id 5b1f17b1804b1-43668646bb5mr153945795e9.17.1735050793610;
        Tue, 24 Dec 2024 06:33:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3Dxq/wTpCZqD+m/hiojMwzuC6mW10QZL9Dt26LbWGEIYT+VdbH1oqFRSrPOLix2e7yllvZQ==
X-Received: by 2002:a05:600c:3110:b0:434:ffb2:f9df with SMTP id 5b1f17b1804b1-43668646bb5mr153945495e9.17.1735050793222;
        Tue, 24 Dec 2024 06:33:13 -0800 (PST)
Received: from [192.168.10.27] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c832b32sm14063269f8f.23.2024.12.24.06.33.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 06:33:12 -0800 (PST)
Message-ID: <1b12843f-6476-44ff-aebf-41939499e6f9@redhat.com>
Date: Tue, 24 Dec 2024 15:33:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/24] TDX MMU Part 2
To: Yan Zhao <yan.y.zhao@intel.com>, seanjc@google.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 isaku.yamahata@gmail.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/12/24 08:33, Yan Zhao wrote:
> Hi,
> 
> Here is v2 of the TDX “MMU part 2” series.
> As discussed earlier, non-nit feedbacks from v1[0] have been applied.
> - Among them, patch "KVM: TDX: MTRR: implement get_mt_mask() for TDX" was
>    dropped. The feature self-snoop was not made a dependency for enabling
>    TDX since checking for the feature self-snoop was not included in
>    kvm_mmu_may_ignore_guest_pat() in the base code. So, strickly speaking,
>    current code would incorrectly zap the mirrored root if non-coherent DMA
>    devices were hot-plugged.
> 
> There were also a few minor issues noticed by me and fixed without internal
> discussion (noted in each patch's version log).
> 
> It’s now ready to hand off to Paolo/kvm-coco-queue.
> 
> 
> One remaining item that requires further discussion is "How to handle
> the TDX module lock contention (i.e. SEAMCALL retry replacements)".
> The basis for future discussions includes:
> (1) TDH.MEM.TRACK can contend with TDH.VP.ENTER on the TD epoch lock.
> (2) TDH.VP.ENTER contends with TDH.MEM* on S-EPT tree lock when 0-stepping
>      mitigation is triggered.
>      - The threshold of zero-step mitigation is counted per-vCPU when the
>        TDX module finds that EPT violations are caused by the same RIP as
>        in the last TDH.VP.ENTER for 6 consecutive times.
>        The threshold value 6 is explained as
>        "There can be at most 2 mapping faults on instruction fetch
>         (x86 macro-instructions length is at most 15 bytes) when the
>         instruction crosses page boundary; then there can be at most 2
>         mapping faults for each memory operand, when the operand crosses
>         page boundary. For most of x86 macro-instructions, there are up to 2
>         memory operands and each one of them is small, which brings us to
>         maximum 2+2*2 = 6 legal mapping faults."
>      - If the EPT violations received by KVM are caused by
>        TDG.MEM.PAGE.ACCEPT, they will not trigger 0-stepping mitigation.
>        Since a TD is required to call TDG.MEM.PAGE.ACCEPT before accessing a
>        private memory when configured with pending_ve_disable=Y, 0-stepping
>        mitigation is not expected to occur in such a TD.
> (3) TDG.MEM.PAGE.ACCEPT can contend with SEAMCALLs TDH.MEM*.
>      (Actually, TDG.MEM.PAGE.ATTR.RD or TDG.MEM.PAGE.ATTR.WR can also
>       contend with SEAMCALLs TDH.MEM*. Although we don't need to consider
>       these two TDCALLs when enabling basic TDX, they are allowed by the
>       TDX module, and we can't control whether a TD invokes a TDCALL or
>       not).
> 
> The "KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT" is
> still in place in this series (at the tail), but we should drop it when we
> finalize on the real solution.
> 
> 
> This series has 5 commits intended to collect Acks from x86 maintainers.
> These commits introduce and export SEAMCALL wrappers to allow KVM to manage
> the S-EPT (the EPT that maps private memory and is protected by the TDX
> module):
> 
>    x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT
>      pages
>    x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
>    x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking
>    x86/virt/tdx: Add SEAMCALL wrappers to remove a TD private page
>    x86/virt/tdx: Add SEAMCALL wrappers for TD measurement of initial
>      contents

Apart from the possible changes to the SEAMCALL wrappers, this is in 
good shape.

Thanks,

Paolo


