Return-Path: <kvm+bounces-51929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A64AFE98D
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 15:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 869827BB12E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 13:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81262DC32C;
	Wed,  9 Jul 2025 13:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HyZ05wz3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CC81E492
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 13:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752066112; cv=none; b=TPBVkzqCoV8HFWnF2ol40K5/u5iCuRLkVQmf/yNILnIUQdm/gPhrk0niwMlgMUeF2sUXtGRkCMDxFMhwqgAw6XC/qlmc2+lt/1GJzhhXCftYFN/fziRlKfmqaR2tVOatn2GAgbVP/GYM1+bWOPleNlBmjrpJ7TOAStCsn3S9wj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752066112; c=relaxed/simple;
	bh=eiyH3L7PkijYQuy2lwj+LBn5Obme2Qi7ZnOyH2/C52s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ns+iiV5UcO85RoZXM8nT/KJZd3VaL+ZbYtr1IPgd78YpKUb5jimSSCq4DwzddBMD4HHtcW0wElma/iEsn9sXmxHbDgU2hU9x4T8iqTdVkKsc8laNzKjXaKj6e+yLuXQqbrBXHPXQOvrV4NyvnG/FSx8hMKMTC+XBMEqaRC8WLX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HyZ05wz3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752066110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eiyH3L7PkijYQuy2lwj+LBn5Obme2Qi7ZnOyH2/C52s=;
	b=HyZ05wz3BKIc50ml7b/9hLMuvE8kOwOoYS0sHMZNKNOAf40+buYmwRqrEe3D15DetrR2+5
	VSBq/plKgQfr1WrBHSZBhNHOqgQZsvuE3QeW6DRXpffTiSSrkAa+OwnM6y559+r98BlPyW
	hoa87ZTqCWORfZpyieT/tr87t1HyHZo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-8_mavmPQOomLdJ_hIUH5lA-1; Wed, 09 Jul 2025 09:01:49 -0400
X-MC-Unique: 8_mavmPQOomLdJ_hIUH5lA-1
X-Mimecast-MFC-AGG-ID: 8_mavmPQOomLdJ_hIUH5lA_1752066108
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-450d64026baso28059225e9.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 06:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752066107; x=1752670907;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eiyH3L7PkijYQuy2lwj+LBn5Obme2Qi7ZnOyH2/C52s=;
        b=q4Q/QPeLuayKP5E1uZdnBTJuzOU3uE28CHWtHAfI+fq1p9XlfQAoPXrUhE26LFtjWH
         tQO8o5dBG6srs1kJWSNlIHBZCWU7mDo0RS96jf0FuZ3vASeakdHuGg1A6fsyx678dyiu
         Ijvc4TcAyKy8Xfw+KhUo0As0nqpsgHXN19dlx4njm14IHPfxicllXmZ9sA7gqyzLdPak
         EdJmVh6pDrmpPAVcx4bflls+/ZOtyOPvJBVH7nAiuTd3CGa6hhyQ6dgwicX73Kbeti5f
         5sy4N26ilYSXsrFunEVcErQooO2SdcQFyxuENr+5VtLZWI6WEpPL5G4dRzApL0tyFBVm
         jfHA==
X-Forwarded-Encrypted: i=1; AJvYcCURX605vfp2apZ0bt+KsotdBfDFKjgDZQWK6rR+DH/6k7GiUgHpeY1ncD2XDZqncJmSNrw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRKBTQR3UgS5ZGxSr7BJbHBhQCIhbdF8bPCRw8uw5a4kVvysxZ
	hDpr2F7I78T/9X52/wq2kEvey4Xr52Tp1U+uJgFn3OOoOZEr0ZflkOAbBSFWaE04tyTPYqlOueP
	k/7525VsFMfk+11l5cWAI5iloL0pmiusv5wFqYNhrgPVl1Mm95ePdKJGm/tECzGVT/dvQ8leH9W
	HENiP6ptJ9h+pE+Yg+uFdp3sNPfp9l
X-Gm-Gg: ASbGnctvItdonM42ej6ohW3Z6ONcxXUXI7N+di4qUqg1nMjg2veVyRZEvCX8xz3fWxN
	ZXZf6ZUcAaJ6ceTa2BLDmovgLWmU5uJNMbrvGT4llFAXAKZ7gA/xDcMyu4/MGH2Z4/rs1TWEatw
	leN0rZ
X-Received: by 2002:a05:6000:2584:b0:3a4:d6ed:8df8 with SMTP id ffacd0b85a97d-3b5e4533bfbmr2032631f8f.39.1752066107160;
        Wed, 09 Jul 2025 06:01:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFARDLdqg2tz5961d2aQtC0kYqwNWKO8nVx+Yu/WEo7+ZJo65HQhq27gzmpbKCeWarSuvm0r+WJ/hL4MtT85rQ=
X-Received: by 2002:a05:6000:2584:b0:3a4:d6ed:8df8 with SMTP id
 ffacd0b85a97d-3b5e4533bfbmr2032568f8f.39.1752066106520; Wed, 09 Jul 2025
 06:01:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <32045ab842954dd5867b55ee965ffcc7@huawei.com>
In-Reply-To: <32045ab842954dd5867b55ee965ffcc7@huawei.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 9 Jul 2025 15:01:34 +0200
X-Gm-Features: Ac12FXwatrB--9KQo-YJgLj3vSbfF0I9bp9UaU-RUh_KY7dTRJTq6UwkjzJxyTU
Message-ID: <CABgObfYi2uM9Ek8pPrHXzeuzXd_9p_sL=0WckWnyOmtuJnj_ug@mail.gmail.com>
Subject: Re: [v2] KVM: x86: Question on lock protection in handle_ept_misconfig
To: "zoudongjie (A)" <zoudongjie@huawei.com>
Cc: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	"Anvin, H. Peter" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, "Chenzhendong (alex)" <alex.chen@huawei.com>, 
	luolongmin <luolongmin@huawei.com>, "Mujinsheng (DxJanesir)" <mujinsheng@huawei.com>, 
	"chenjianfei (D)" <chenjianfei3@huawei.com>, "Fangyi (Eric)" <eric.fangyi@huawei.com>, 
	"lishan (E)" <lishan24@huawei.com>, Renxuming <renxuming@huawei.com>, 
	suxiaodong <suxiaodong1@huawei.com>, "caijunjie (A)" <caijunjie15@h-partners.com>
Content-Type: text/plain; charset="UTF-8"

Il mer 9 lug 2025, 08:50 zoudongjie (A) <zoudongjie@huawei.com> ha scritto:
>
> Resending as plain text to fix formatting issues.
> ---
>
> Hi all,
>
> I noticed that in handle_ept_misconfig(), kvm_io_bus_write() is called. And
> within kvm_io_bus_write(), BUS is obtained through srcu_dereference(). During
> this process, kvm->slots_lock is not acquired, nor is srcu_read_lock() called
> for protection.


Hi, srcu_read_lock() is guaranteed by the caller (see vcpu_enter_guest
in arch/x86/kvm/x86.c).

In fact, almost all of KVM_RUN is covered by a SRCU read critical
section, except for:

1) the part where the processor is in guest mode and the nearby
preparations (that's vcpu_enter_guest)

2) when the vCPU goes to a non-runnable state, for example waiting for
an interrupt (search for kvm_vcpu_block and kvm_vcpu_halt)

Thanks,

Paolo

> If another process is synchronizing BUS at the same time,
> synchronize_srcu_expedited() cannot safely reclaim space(it cannot protect
> srcu_dereference() outside the critical section?), how can we ensure that BUS
> obtained by kvm_io_bus_write() is the latest?
>
> Thanks,
> Junjie Cai
>
> Reported by: Junjie Cai <mailto:caijunjie15@h-partners.com>
>


