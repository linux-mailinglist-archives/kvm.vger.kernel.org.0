Return-Path: <kvm+bounces-67787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F3C7D143D6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 177BA30158E6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F02BC37F0E5;
	Mon, 12 Jan 2026 17:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EN/mLACy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kdgC398W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99AD379973
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237357; cv=none; b=NkWKDwIQtETVqt5JpTHp0miwUiBei5WJNhkRc3dYmkrrd22IFZBHpFv+Y5sCkoRpX/e6yMO7wGFTBhJAEUL0cQDJWP34Zimf3r4LKXKYGYD1qZebYlnUEKnzf/DHU8GlHSbXpsiFBh9eJD1LDMvQVMjSIPDZFUL8BASDKMtXj3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237357; c=relaxed/simple;
	bh=7rKFUdQx23abFlJVm0uQPQFiuDu8lmtmxqOTgmBnKZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AEp9D5m2F/LZGHSYF05r839Dh3edM89X+6eBbyUNT5z8pvarnCaPP2he1GwslsLcg+bjw6dlnr7SXf2nJwZXb1g/92U9ucFjjB3n/EwLUjzwfwhSZAVqp+VRDtggAlNPdr/Cs8q5G2fgU8UK3d52D3ZV/lmlkqVAQixOt4uKXo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EN/mLACy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kdgC398W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768237352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7rKFUdQx23abFlJVm0uQPQFiuDu8lmtmxqOTgmBnKZI=;
	b=EN/mLACyTo+RJ0aTPAg/BTaaoffKHpDROrgzsFWCRx+SC4kzGwHwUTCV2JrHXjYYs9sgEr
	aI+aGphlzu/dAKt3G2LOiPzJIWqBqJWc+mGonaY66E8pus/BeKXJICXscKVWmkrY2BxQoD
	WlweRHOvyeDh8DMAige+YldLgvxFcUk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-V4s3_QN2OZSPK_atpHUyQA-1; Mon, 12 Jan 2026 12:02:30 -0500
X-MC-Unique: V4s3_QN2OZSPK_atpHUyQA-1
X-Mimecast-MFC-AGG-ID: V4s3_QN2OZSPK_atpHUyQA_1768237349
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477bf8c1413so44795605e9.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768237349; x=1768842149; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7rKFUdQx23abFlJVm0uQPQFiuDu8lmtmxqOTgmBnKZI=;
        b=kdgC398W0e/9IAD/vF5M5Z+vE8UItEPfbHXm1uqC1KbdoUg5eeJnK4lNWuPlRuX5Ru
         ZIqCMPpBjw0XY2C/qAO7+5Q5jgPRVC8vmM4GYkYaKYHHCXUnznz7NEymOAXIa64wapu3
         p84mdYGxWrBTq05mwJ8GC07wtRuaP5CuLiblD/BVHdHavC8H8xG8Lt+EZT/KNNvTV/tJ
         PQmJQCg7GxrmiHk6VeWmRhHO0scsWxnv0JZOwAjxHFqxzpf0V1el6eJLYfXVTCrL1muB
         +PBIUov1rZMGS4LCQb66mnOATETvcx6f68Dxz0HjZyQVfbnvDyzh04H+kiVwEoHxXlk7
         OPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768237349; x=1768842149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7rKFUdQx23abFlJVm0uQPQFiuDu8lmtmxqOTgmBnKZI=;
        b=StCOoXVneRSfY+Pd/CBeJydpmz6Z0p+JCUohsZnIY6BKnkNnkvmWG2rWq/OtD8vs5m
         6od/r7zgXQIRtigkZwMvXO4iFkI7kihL+dyAL8BkH8ObpbeNXPr6V5bUEUDOGjf9amNr
         nEEiDwjWLxh9icMNfByA08MYGmjidQ858cS5K57q3YFQGWw6QpJkJsDmpdvQc1MWr1N6
         AWh78s93szi/UWVe6FOIcZkQAsmPkiKH1L3k61h/TEz2FxPkrz0WG1jyUMQ6gcGpWjQ0
         XVyd2Jhr3T8xXULkM+EKSYGERU7PegoHp6rDBPfnHEnW56yjJL7miT3/5joqyDmq5H+9
         vGyg==
X-Forwarded-Encrypted: i=1; AJvYcCW41HFgFF52CP/87LW1H2Ezvu2LOe4VJ/uKCP1Uc7bkXPQu6mZTlwVAb13RSyc3JwSGVJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE344gmQamCdlE2WQN4T/OqfEw2yGlEEaoYXjOZg18uOL90aJ7
	gHPrjmZ6rXqOJH3B/Yvgpv3R1itd1b3wten2LtFo+mc3K6+48kaWavqSo+iTLboAzRgENJ53Xdp
	Jf5A4xpzX2UxkzCI8DWLHNLoxDAc0vYOz5bOcK3zsQk+zL6Hund08RB6JiDeH0DIjvyuEdbfR2r
	xuirumX1e352Cq/IVXtPUiIfSMI+JR
X-Gm-Gg: AY/fxX6txIYjcLBeSIUanKetfFSzrOqpo2rxPBcVKi/wNwQBczJxjUnZe0hyur5Api9
	RS2sTTyWb5XfthpXQttstXFergTZ+/h93dYs80mW71hJfZ/XwROn7od6xA7Xrd4vK6eRY/AKo/Q
	C5ESJOSASLOeiGVjOU73ViJ0sgaKn3MAqwbuhAcuh7UoeH4ZZeDox3a4pTLxlqi6X0cAtCIoAUl
	F1DW01PwBj/3sga5rJdu5vxcXm4I0ECJQbC9znXa5Aq/w3+DtiM4KyvdLaclVJjgkn4xA==
X-Received: by 2002:a05:600c:4e8a:b0:479:2a09:9262 with SMTP id 5b1f17b1804b1-47d84b18037mr244900345e9.9.1768237349449;
        Mon, 12 Jan 2026 09:02:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHUkrA/EFIxVDM9YasT0A251/Gyn1594BDFpmWhdj7boyiZzv/zO4AO7cbSLgAcvcRPwuDBrYXkZ0Raazwm8y8=
X-Received: by 2002:a05:600c:4e8a:b0:479:2a09:9262 with SMTP id
 5b1f17b1804b1-47d84b18037mr244899935e9.9.1768237349058; Mon, 12 Jan 2026
 09:02:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112132259.76855-1-anisinha@redhat.com> <20260112132259.76855-5-anisinha@redhat.com>
In-Reply-To: <20260112132259.76855-5-anisinha@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Jan 2026 18:02:17 +0100
X-Gm-Features: AZwV_QiPnwcipYRTdzj7RyQ4o9zK-24ynHKg3jtYwESKklZ6rTj1MR4pRLLSp6w
Message-ID: <CABgObfbDTAvm6E0imC=HSm2=BAC4rzUDmuHcoUbVjJ-YeXFw-w@mail.gmail.com>
Subject: Re: [PATCH v2 04/32] accel/kvm: add changes required to support KVM
 VM file descriptor change
To: Ani Sinha <anisinha@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Song Gao <gaosong@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Aurelien Jarno <aurelien@aurel32.net>, Jiaxun Yang <jiaxun.yang@flygoat.com>, 
	Aleksandar Rikalo <arikalo@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Harsh Prateek Bora <harshpb@linux.ibm.com>, Chinmay Rath <rathc@linux.ibm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alistair Francis <alistair.francis@wdc.com>, 
	Weiwei Li <liwei1518@gmail.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Ilya Leoshkevich <iii@linux.ibm.com>, 
	David Hildenbrand <david@kernel.org>, kvm@vger.kernel.org, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, 
	qemu-s390x@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 2:23=E2=80=AFPM Ani Sinha <anisinha@redhat.com>:
 > +int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)

Weird name since there are no "operations". Maybe kvm_arch_on_vmfd_change?

Paolo


