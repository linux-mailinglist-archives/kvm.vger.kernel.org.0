Return-Path: <kvm+bounces-38475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F240BA3A741
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 20:21:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72048164EC9
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 19:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A498417A308;
	Tue, 18 Feb 2025 19:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ieluvBNw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D69521B9C4
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 19:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739906503; cv=none; b=PB72Ek2lzR61FnuRkc7b4mKePlNq+AWHjK5puKPa4g+yMYT3wLPxxPbcwpj1GEpvgUhdLLlNWEPkGHYVZoVxOrZUlDW/uA6revYEk+8qsOwxL2cBOrf+NKdO/bNzPs63mYXDF9i12iltvYwOpRMp+dnEdCaY6yk8xRi3y8waVmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739906503; c=relaxed/simple;
	bh=bkvmNuJeLETBECOiqWk9MtjZR6ThiLMHRWdbZO/TdrY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=uAh1F+SBq/6b51YW9MlYCg9PvOqpCaoEk7XPU8OJw+BH4tPUk3emFMxuLu35D5K3NKwG6cB/YMAYGLUuT5XJWwIDVYbtEzD64efJcECJ6jQVZcFuELJSbo+i2LlNsMEDUlq1I9+PXhzjvvGrXA9eGXadewcBjFdmOLBbZR4qfHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ieluvBNw; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-436ce2ab251so40926685e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 11:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739906499; x=1740511299; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yeownKEZiIC47+N7MKi3dyYleDIO1KUAMDqBvvd4FqQ=;
        b=ieluvBNwWwgRtPmrRTNQBo3NQrkMT4ZWVwkKy3sEEQ+EIJARtomfK0R54c2l5PG63b
         B2qyAEXyTBn+B6t3IK0GU9ZY1+WbMXcLroaAkWfEoYX5QyRyc6rvrtxD3/oIxbm1kReW
         iiBPyDI3207veM6IgGOiorGPTnGW2mZvQCWjy6FbYEXnUx7iCHbdMaJUI5A9KopQ3wku
         BSPTgXdfLTgq+6HiBHoRRpyaU/IXr6Qj7oozOvf/Zpc/By789A5kjdX+HXtnkeYhu5Yk
         Typn7YD0MURV5TUOPutXnD75c+J4wcQYvfXJfUSBbUYRGIw/H60aXTkh/UE99gTFcySL
         /64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739906499; x=1740511299;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yeownKEZiIC47+N7MKi3dyYleDIO1KUAMDqBvvd4FqQ=;
        b=uGlIbwenlJU4hXxzWLLM/J/qH6WyVzy2swuEeFNcvmw0tAfbVk3RNQmSEwx4Gu770r
         EsKekt6vGjLiEoZGYdMzVnGXqz5azj9S+yFpOSAEAtpOPsMypB0838C35ohzfQplqhIh
         BpWsb/yHteD0eWkSealICve7CCCzJhRLtEYjHMcVdUGTgEynvk5YNwOFjai/lzPERsda
         vHHWntsXJh5erWnlUMuwtXvw8lf+kk2Ho4vcsn/S9ryvhnCkT71+hoDpGZgzkA/fpU9H
         5NfwhtVxcqKRkajUkDntgU+1oWKNyAJ8c48kk85rhe2FVagBbJYtYp8OQQ+B7S8zv5be
         asyA==
X-Forwarded-Encrypted: i=1; AJvYcCUxPKUw+sPf1KV0QC/9Z55AEwDSm1PQ08ipxE0J3zNORjJQIySlarGTg0+mSwXeiaNfBVM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9dLMmANoY/3k7v/hAlMClLAj9jqYgrrGQe3X+1FFHiW3RpECM
	52c4QWlUWsdkdFY48A2TcXfXnbB7yyuhS6v9wI9ejCoejHN5dIud
X-Gm-Gg: ASbGncuiVkdeFJhRafD18OTEVV/0NChGna0soVYWyM8Izgop78Obfp9k/Mcu3k41S7D
	8VS/Te+FkZOt71hODnSxPIUt0HUTLJPrUTFYPhTC0+EPf03xCNPcEJaQChgHF8MYYeVkkCWCjAo
	Hdb+tRm1784QzB2k5TYVG8Ef3QS9Or7O5PzYRnXKdnZgYQJli4+FavpoWbV1waWTt1zJ2LcalYp
	/fnySLM+E20cjoYwb5vkrQ7WsT87E43u4pzy1WX2hfjV+eGOIaXRLf0YNsKiBr0zUCWA4XLTwO9
	8pxrn4sHG1Une2b8yNL56xe7OwbauUh7s/JYZEsN0JECkpO1fjlafRyD9XTag1n/iBlXnw==
X-Google-Smtp-Source: AGHT+IHPqTa+zTfXkXh4LXzcP3343zLQclkxofCCboW6w8kCrp+5klrwxGvzJ1HyUAjEAhqNN/AXYg==
X-Received: by 2002:a05:600c:19c9:b0:439:6a24:1067 with SMTP id 5b1f17b1804b1-4396e6fae48mr154981015e9.16.1739906499229;
        Tue, 18 Feb 2025 11:21:39 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:5912:494:2baa:19e8? ([2001:b07:5d29:f42d:5912:494:2baa:19e8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43989087517sm57185545e9.8.2025.02.18.11.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 11:21:38 -0800 (PST)
Message-ID: <08bf7f3061459af5f05fabf0d3796b77d8034587.camel@gmail.com>
Subject: Re: [PATCH v7 05/52] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: xiaoyao.li@intel.com
Cc: armbru@redhat.com, berrange@redhat.com, chenhuacai@kernel.org, 
 eblake@redhat.com, francescolavra.fl@gmail.com, imammedo@redhat.com, 
 kvm@vger.kernel.org, mst@redhat.com, mtosatti@redhat.com,
 pbonzini@redhat.com,  peter.maydell@linaro.org, philmd@linaro.org,
 qemu-devel@nongnu.org,  rick.p.edgecombe@intel.com, zhao1.liu@intel.com
Date: Tue, 18 Feb 2025 20:21:37 +0100
In-Reply-To: <20250124132048.3229049-6-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 24 Jan 2025 08:20:01 -0500, Xiaoyao Li wrote:
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 4ff94860815d..bd212abab865 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -10,17 +10,122 @@
>   */
> =20
>  #include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "qapi/error.h"
>  #include "qom/object_interfaces.h"
> =20
>  #include "hw/i386/x86.h"
>  #include "kvm_i386.h"
>  #include "tdx.h"
> =20
> +static struct kvm_tdx_capabilities *tdx_caps;

Instead of a static variable, this should be a member of the TdxGuest
struct.

