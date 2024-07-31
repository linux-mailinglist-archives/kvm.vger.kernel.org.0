Return-Path: <kvm+bounces-22748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D179942B4B
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 11:54:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 323A41F223D7
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBDF3CF73;
	Wed, 31 Jul 2024 09:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zr+Cax4o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DDF1AAE00
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 09:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722419659; cv=none; b=cvEj1ainfP2+EUX8SDNpV+32tn1fBjt9TxRKH0PIn357ZcKxBmiH+MK+wqpOX/9ay/PDQmtQHAy6CoixW0aK7XjonjD1jkLMdaXEt63EXwh4nbV7i+HqyVQAI434D8hIeaTT228OI7us2ytZm09ZuTyAXs7AnGMeMag1hMaAy2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722419659; c=relaxed/simple;
	bh=3ix6EzniPhHd9wbiJNnCXpra5s9X3tWtFg5FSJ6/Ack=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kWl8aAd7C4imVuRvIa33TH7KyTlleBPcudPQJlhfu/5W7Ycg3b+N3U1J3on8/xGVpOJbQ0M5B8OLhLAZ//KBeo5lPfywnwz4vsozRO65yOlHFJRqvs4U3aRWbo3RaV4uQ0twO2sz9Iuf2qxQQvKlN+WqRYdSEyIjmUGP9DnpquM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zr+Cax4o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722419656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sv0GyEWMsnJWVZfKz3ATuKSCuaKPcxlgzQgnNdoKxLk=;
	b=Zr+Cax4oU0IL7vgor+TYka0jmxW84F7xhtDkIl32/Dy4HZ3ODDVLbA//VimkSRa3QY2yUS
	0k7mJ7kiLMo1VB/oKyB0zeuxwHbNMzy3xmMN+ZErmx7mNFq/Dd35Qmtj1qTBa4JQjRHFOY
	nIhOWMQ7ZRF3OgbqlfouferIJQYUwik=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-NH57EUAZN_CLzuDEBi1-3w-1; Wed, 31 Jul 2024 05:54:13 -0400
X-MC-Unique: NH57EUAZN_CLzuDEBi1-3w-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-36871eb0a8eso2768729f8f.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 02:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722419652; x=1723024452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sv0GyEWMsnJWVZfKz3ATuKSCuaKPcxlgzQgnNdoKxLk=;
        b=ZuZZq2RJ3Pwvjlx6THAWekGNe8buEx+MhmnlwR+Gd5sivWyglEV6CyCrwA9eRF7LbA
         dft2fFhUsbLAXpw+C4u6IkaQgsWUeEOnEsXsQYHJ+BoIQh+9N0JfSa9cdFg/RkZOxKYl
         U7Kkhixkayh2biQLwxamiE+SbAW1ANOB/+D8lrOHqtcLTpv7ADhh3au0N5H5tbsmVOmi
         4PcMnHEFwGqQeaumVlHmCNlo3G2L8DqteCHn3gYjK2XjYPO/qoflnHZDIAk5qIIighgh
         NqWattf53i0npIuAXhf87oxNyMy8DJ8d4WWptAFZYZDSR51cwlgfxCTdPTal6yYMv+2Y
         D3dw==
X-Forwarded-Encrypted: i=1; AJvYcCWRvy8DyOLBzFZSEaaTM+x+ST7GbMSBw3SSNPu7Lmti7MvYNJUYWOsZjTT1W6BLPdKa55dbBrxaSOrvPqPWeGYehbKD
X-Gm-Message-State: AOJu0YwxiZvXGJvOG049oAMFQSIu4gh0f3XCmS/uUPU/UfZ/2BbRSP1j
	+q/RJyoncjDmCqxrTRnVkJz0akyDjV24uci6lOUF2eADGrUiZMFnFrQoV1Mk0KH4j7Wvsexpdhx
	KTdgE6vnwTr3myfdoTw/IxE4ncWt8kJgWwW5PXrn+ss32D3MRFn8f2PxfRMj5ePryCT9B4VIpF8
	MCD2hcUtk/nJY1GyQRYL1kJ+AgbkQGfC9k2o4=
X-Received: by 2002:a5d:6d82:0:b0:36b:a2bb:b374 with SMTP id ffacd0b85a97d-36ba2bbb660mr220369f8f.52.1722419652244;
        Wed, 31 Jul 2024 02:54:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmxG5YgpDk8aZ2On73jVJi/Gy3ZWCK6AV6rNhjl0p9LXy3rgA0+3uKFEgx/PBBgyzpKoWYj+in4L6HT6vjE5w=
X-Received: by 2002:a5d:6d82:0:b0:36b:a2bb:b374 with SMTP id
 ffacd0b85a97d-36ba2bbb660mr220356f8f.52.1722419651850; Wed, 31 Jul 2024
 02:54:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240731093129.46143-1-flyingpeng@tencent.com>
In-Reply-To: <20240731093129.46143-1-flyingpeng@tencent.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 31 Jul 2024 11:53:59 +0200
Message-ID: <CABgObfbro7=yG1ZVugan+ggWYBVf+RVVoRJKa9hPhYnUAN9K2A@mail.gmail.com>
Subject: Re: [PATCH RESEND] KVM: X86: conditionally call the release operation
 of memslot rmap
To: flyingpenghao@gmail.com
Cc: seanjc@google.com, kvm@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 11:31=E2=80=AFAM <flyingpenghao@gmail.com> wrote:
>
> From: Peng Hao <flyingpeng@tencent.com>
>
> memslot_rmap_alloc is called when kvm_memslot_have_rmaps is enabled,
> so memslot_rmap_free in the exception process should also be called
> under the same conditions.
>
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>

The cost of this is basically irrelevant; in fact the same
unconditional call is present in kvm_arch_free_memslot().

However, changing kvm_alloc_memslot_metadata's out_free label to call
kvm_arch_free_memslot(slot) could be a small but valid cleanup.

Paolo

> ---
>  arch/x86/kvm/x86.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index af6c8cf6a37a..00a1d96699b8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12947,7 +12947,8 @@ static int kvm_alloc_memslot_metadata(struct kvm =
*kvm,
>         return 0;
>
>  out_free:
> -       memslot_rmap_free(slot);
> +       if (kvm_memslots_have_rmaps(kvm))
> +               memslot_rmap_free(slot);
>
>         for (i =3D 1; i < KVM_NR_PAGE_SIZES; ++i) {
>                 vfree(slot->arch.lpage_info[i - 1]);
> --
> 2.27.0
>


