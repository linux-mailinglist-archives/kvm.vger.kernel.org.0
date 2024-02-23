Return-Path: <kvm+bounces-9503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 396B4860D5B
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 09:58:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F17DC281D44
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 08:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8EE01AAD4;
	Fri, 23 Feb 2024 08:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HuQgjong"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4391A1A29F
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 08:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708678689; cv=none; b=Y1CHXlKqJKteVwKZ/UEdkMynyi+lKDhSyboQjR0AijV98p5sMBehv6ME7fDVHBpCv35hKnJuFfj/qcvV8LK+qtQXL05cCGEhv9aDmhFkcacNonEnyP9WH61dc71173jvVDIt/Yp5anpje/zacCwZWLc8fqgPEL1GqRE/9gyIPPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708678689; c=relaxed/simple;
	bh=YZbhuAtP+26wSLICWdq/lyQWSLDnxV62jHh0sN94jd4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qphgOqRZC9yMqQrtmH75aYamLvlCnq7Hctea4R0XWsngQBq8JBuzymQwrWaktHN4v9qnHUu9LUr7++YOwKVCpvEgytffoP2Yuiz8ec/qpBI/EhVnVDZKMnZ0Bh0Drw6HquPyXf+AOWGC8bivs6F38Q22VbLUoUOB4LHSEx8c1fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HuQgjong; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708678686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iLQwWfoTn0xaoRpTFSAvxI7eKjXdmQ16vLaj1rspCoQ=;
	b=HuQgjong9EkSKPxnRAI95X8K2ZeKbKXU1VLL+aDA7YuZwlfoZQN6Kzjv5BYhGaqq20OmqT
	WrKYPef8fz+mhXj/wb/EzWIDlVcjTKoqss3pN6RtlwzWTjniDsrKWcaGIcCMc4CFLbhByi
	ahXNaaUiaMYc92XQcDAXrfMZ7OLLkx8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-qY8mJ0jEPg-4RgK1O08BTQ-1; Fri, 23 Feb 2024 03:58:04 -0500
X-MC-Unique: qY8mJ0jEPg-4RgK1O08BTQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-41290780cafso3055585e9.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 00:58:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708678683; x=1709283483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iLQwWfoTn0xaoRpTFSAvxI7eKjXdmQ16vLaj1rspCoQ=;
        b=pjHQke9b5GshxKIdzNIPlOAqWe49iNsc+6i+DHgo8b5C9yaFH6JT8wtKY1/vWdaiMt
         /peJQe2Xc5sgGXHAX5u4adpaTbLDGYFrGTB/EvfNj20d4tkwI6oUwI7fK7IgxWOA/Lpn
         KaElUsSUQQzlLyWByC9GuaCT3q3hRPa3ozELulr/NL+esNqoTwOQY0dMlTBxjSb0yO0X
         UP6o2jyuJu0UdPr4yAuqlH1nxP1zye+cJnaX+mpfoXWs4JxEBLbZtMP9m3C/kWsPXFtr
         rKpCXw9aX+ojo14ZeLTrDpt+gfS+/kV1wOdt31QwmHDt4JhDkj8VhIdOGvMof6DaIywI
         DGdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdnl1jKK6819v+jfMCLuyy5TCVor6bP86qtqZBPuU7dLqzY3NNx0jCI/Q+ebrbRUBNa7SvCJ6raSAaAp3dAjEpPVip
X-Gm-Message-State: AOJu0YyWd/PmKUdOLGj5rB2YYppctBak4otYpyjmVwckJCV0aBCjf01t
	NmUxTHX/w9WRYpEonMiEAYLnOPIBAFqR+Lj2Mes/CLa8yaKxOf3j8Y5h8+BTfFjmLRxDlzCtyLr
	LbPPBv64FcHWAmCUJd6oVVfCltfIwtr0fbTp0Wra7Vw/OKXGy/DZxLPgI8W64GqjfH8L0HGvypA
	Vyi2F1XNbWR4fu9wvJTNiLgmge
X-Received: by 2002:adf:eac3:0:b0:33d:71e5:f556 with SMTP id o3-20020adfeac3000000b0033d71e5f556mr1020417wrn.27.1708678683405;
        Fri, 23 Feb 2024 00:58:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE+mrCKzWAaGkT/K53qU2Sd9UG7Fu614wcbzGC+OYclult0+HHvvNnkxisAg/4y0NnQxxIN8re7HwpceFAujt8=
X-Received: by 2002:adf:eac3:0:b0:33d:71e5:f556 with SMTP id
 o3-20020adfeac3000000b0033d71e5f556mr1020407wrn.27.1708678683094; Fri, 23 Feb
 2024 00:58:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222-memfd-v1-1-7d39680286f1@linux.dev>
In-Reply-To: <20240222-memfd-v1-1-7d39680286f1@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 23 Feb 2024 09:57:50 +0100
Message-ID: <CABgObfakz1KQ==Cvrxr5wS36Lq8mvF9uJtW3AWVe9m-b+0OKYA@mail.gmail.com>
Subject: Re: [PATCH] Build guest_memfd_test also on arm64.
To: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 12:44=E2=80=AFAM Itaru Kitayama
<itaru.kitayama@linux.dev> wrote:
> on arm64 KVM_CAP_GUEST_MEMDF capability is not enabled, but
> guest_memfd_test can build on arm64, let's build it on arm64 as well.

The test will be skipped, so there's no point in compiling it.

Paolo

> Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
> index 492e937fab00..8a4f8afb81ca 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -158,6 +158,7 @@ TEST_GEN_PROGS_aarch64 +=3D access_tracking_perf_test
>  TEST_GEN_PROGS_aarch64 +=3D demand_paging_test
>  TEST_GEN_PROGS_aarch64 +=3D dirty_log_test
>  TEST_GEN_PROGS_aarch64 +=3D dirty_log_perf_test
> +TEST_GEN_PROGS_aarch64 +=3D guest_memfd_test
>  TEST_GEN_PROGS_aarch64 +=3D guest_print_test
>  TEST_GEN_PROGS_aarch64 +=3D get-reg-list
>  TEST_GEN_PROGS_aarch64 +=3D kvm_create_max_vcpus
>
> ---
> base-commit: 39133352cbed6626956d38ed72012f49b0421e7b
> change-id: 20240222-memfd-7285f9564c1e
>
> Best regards,
> --
> Itaru Kitayama <itaru.kitayama@linux.dev>
>


