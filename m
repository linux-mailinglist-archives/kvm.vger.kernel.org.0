Return-Path: <kvm+bounces-54941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8573CB2B759
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 04:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90CAE565FA1
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 02:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA1C2BE653;
	Tue, 19 Aug 2025 02:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJbd9SSZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C32D2BD030
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 02:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755572217; cv=none; b=CKXYyT2gWf0bw4nCcCAqAfH+b4erIYVy5/65H0s+0XTKy6mhqxjjM+NqVkgRc6weIVNzJeeEqwOwJJSl3zTK/g9Q7wrXSxi27p/K+DYhJcan5MGMkeMEqk72ktBq+HwtHE0JFeLbjYWOxmJAkx95zu4cosHThRMu5sbdEvHyw9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755572217; c=relaxed/simple;
	bh=vOTsLPHrmR4KWPLCxzIidma6yhGcdhM6/jmIPZ0Y6GM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HBiE9eI/6cAND/J6Kx6lPsNu8thojQkMm+gD849gK5S18jJSsROHN1xkMUXeBkIEnZOBt+E13T7nlhIXTA5zVVun0cZm70ha3zJM2ihsg9TAF+cTWyWvGgts6lWCSF+sLd2BqRP1SK6WyMx2ADOf8bUA69wwmUMnddvVOMh+4GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FJbd9SSZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755572214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=30rtf85COe0Own+57CwCTiuCFuWNx+52rsJaNL6+eGg=;
	b=FJbd9SSZ52GnLLfKuQFJL+2RjRmkwAIv274Can8xHMQkiDCr+Sd4NLqm4p2numbTxT8Mrt
	iLVOu5eza8jR3kYPLgEIjWcO20HsKpEdyMv/Dx0/eQ9gL7SShyKs0VrsthOYnL4QwgqDhh
	T+V8gZcW0W6rH3M8/pqfcxb5pwzz+E0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-UwTod7CNPQ-9syCvj9NO9A-1; Mon, 18 Aug 2025 22:56:51 -0400
X-MC-Unique: UwTod7CNPQ-9syCvj9NO9A-1
X-Mimecast-MFC-AGG-ID: UwTod7CNPQ-9syCvj9NO9A_1755572210
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b47538030bfso459960a12.1
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 19:56:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755572210; x=1756177010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=30rtf85COe0Own+57CwCTiuCFuWNx+52rsJaNL6+eGg=;
        b=kZEws1qYU2k7i8da+JEHmZUuF5T6z06xlAh+Y1C7jXXN1paA1bom4SwupmSkPvS/W+
         3gScp645U/nntWogpBHncWPcon3g+LZZ6ZOhS1NEy7sQscfyFNXrErmVfe8qD2AnOrCM
         7P/Z6mC0Ti+WvX82T5RLolXyGBrDpg4pJcEBauDAV1qy1X388E1ZwdCau6WPL1cK2Jzo
         SjA/RRtQB5Gqw+2cauH+sWLgczZmGF7pXpPGlzWYcud41Nab/rD+2gfUsQ+pXSwl4D9f
         X92koR1Y/kZpy8Lpa5szt10TQckLMfDIyjlFmTCwIebzS6QGllXJ1KB7wMOwIqrH0IQC
         jimg==
X-Forwarded-Encrypted: i=1; AJvYcCX+m+NWToe0iOkxBlG/iQqtERfKi6619WclwEGHurrivLsm8bJqEY8nhGKuRzAVm4C0BfU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNCfW0RUHc0vkL58XP4nacSjjbewNs91OzVUrQLo6mCmKeL9RK
	Zj8lJuclEA3d6HM940foKl7FnQ/hwJBS4DX9NdcGBihtP7ABXxJhWUOgSWP1mwS+pd5nP1m2byr
	/w6bCSkoXrz9nGwVsCZUutowWIF49SiTBRilQkUeUwuf6fqRvyEuf0hu0JrS4jL8gnplb7cZ/5f
	6iyeZU5nm7AOqL9/3wAa7lZ6m/sV/P
X-Gm-Gg: ASbGnctPkLUjstZbr9oHCnn1uGY7+uQ0ldUObjMtzxLs0wTa3zAkFBfVreaL6rv1hhM
	FVrJ0uemJsjwg90tDS4uLPHR/f79iq7Wz2nWhyeP0jdmZ+kSL6QPaQi/0ndVpA68dae/CSCvyv2
	fy6yi2A3Je1bHhW0iuvNEAvXY=
X-Received: by 2002:a05:6a20:6a24:b0:240:750:571 with SMTP id adf61e73a8af0-2430d4c1313mr1346436637.42.1755572209914;
        Mon, 18 Aug 2025 19:56:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnlIuMdMyqhr/p8CYdMvQzUInme5H88bLRkT2Jl0duOeXAZIWJz9QHEu8m1RFiElzvhplq7z95g+i2y/CkKNc=
X-Received: by 2002:a05:6a20:6a24:b0:240:750:571 with SMTP id
 adf61e73a8af0-2430d4c1313mr1346412637.42.1755572209496; Mon, 18 Aug 2025
 19:56:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aKOLrqklBb9jdSxF@google.com>
In-Reply-To: <aKOLrqklBb9jdSxF@google.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 19 Aug 2025 10:56:36 +0800
X-Gm-Features: Ac12FXz4QQ7I_WS0I16x3o7tcM5Be883zhtqEJVTDk_lwuE3fHpjghTmF64HFYE
Message-ID: <CACGkMEvm-wFV8TqX039CZU1JKnztft5Hp7kt6hqoqHCNyn3=jg@mail.gmail.com>
Subject: Re: [BUG] vhost: perf tools build error after syncing vhost.h
To: Namhyung Kim <namhyung@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 4:23=E2=80=AFAM Namhyung Kim <namhyung@kernel.org> =
wrote:
>
> Hello,
>
> I was sync'ing perf tools copy of kernel sources to apply recent
> changes.  But there's a build error when it converts vhost ioctl
> commands due to a conflicting slot like below.
>
>   In file included from trace/beauty/ioctl.c:93:
>   tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c: In =
function =E2=80=98ioctl__scnprintf_vhost_virtio_cmd=E2=80=99:
>   tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36:1=
8: error: initialized field overwritten [-Werror=3Doverride-init]
>      36 |         [0x83] =3D "SET_FORK_FROM_OWNER",
>         |                  ^~~~~~~~~~~~~~~~~~~~~
>   tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36:1=
8: note: (near initialization for =E2=80=98vhost_virtio_ioctl_cmds[131]=E2=
=80=99)
>
> I think the following changes both added entries to 0x83.
>
>   7d9896e9f6d02d8a vhost: Reintroduce kthread API and add mode selection
>   333c515d189657c9 vhost-net: allow configuring extended features
>
> The below patch fixes it for me.
>
> Thanks,
> Namhyung
>
>
> ---8<---
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 283348b64af9ac59..c57674a6aa0dbbea 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -260,7 +260,7 @@
>   * When fork_owner is set to VHOST_FORK_OWNER_KTHREAD:
>   *   - Vhost will create vhost workers as kernel threads.
>   */
> -#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x83, __u8)
> +#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x84, __u8)
>
>  /**
>   * VHOST_GET_FORK_OWNER - Get the current fork_owner flag for the vhost =
device.
> @@ -268,6 +268,6 @@
>   *
>   * @return: An 8-bit value indicating the current thread mode.
>   */
> -#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x84, __u8)
> +#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x85, __u8)
>
>  #endif
>

Would you want to send a formal patch for this?

Thanks

>


