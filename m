Return-Path: <kvm+bounces-31893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6FA9C9602
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 00:17:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D77321F21307
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 23:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9201B219E;
	Thu, 14 Nov 2024 23:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cie8v75h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42431AF0DA
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 23:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731626233; cv=none; b=kt7SymIy3xRHR4C9ZkxTRmDWS/m9Tfw+7imF7hfqHtOAaTmCU2ghpkHnNMh52fr80Ie8A7EiZzhgwPVWNrN7Hnh2WUAftUQgIVPng909hKgHHbAi4DXlxJMDCHGWN/RDaDWOZnuf0AVI8UrrNynoXe2hOqS6cx1UlcRNZds+OcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731626233; c=relaxed/simple;
	bh=CI1r12nNHRwypDsUYC8xY9fzjewA2c/mrZsbdnAEyB8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OjoBTo+OKji9y0R+WvVjJmXLSKNlj2nRvl0bHXKbfqwe+ZQTg5Idgg04X7KWF3TYbTEAxbGyCGga4PapPKJ/3IoaDVcwZci76Sc34GYSH/5QIQ0+PudIUhSA2I1uDE99Iq9/3WFLnge6auFVQfNuOoKk2Q96WvC5Rc/Od0Kolbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cie8v75h; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e376aa4586so26258797b3.1
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 15:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731626231; x=1732231031; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vwAzg/sQCaKfbfUxYjkIW4dK4mXFdPygldw0DR81bXI=;
        b=cie8v75h4JigBi3C9ayjkHTv1bcGaPALHy4DUS9KhfM+MJgpMavda4mB3jLzUDkXv7
         qRdyOWKgMc24sTK1gH/GWzmL3SSUHe/TEQlUhb42EUe///VOIW3hXvylnaMkwn8BB8tl
         37W0ePhSDYbJHX8NBCgX9BVK7XYxY2czsMMwe7TIjbHMMJKqOvLf+1kfD3uY0w1fvZDG
         0Mss+KFHOKqueFy9yoP/p/TGwjoxC5VXQf7yDYNcGXRfsRMc1KXOqfcOFKFojeAm/byJ
         phzV+1IrrGVIhVZylYua8kEF7pc11Qjl7ub/3DNRE1D/h4dseATKp0JAdbgKest74s5z
         7v7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731626231; x=1732231031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vwAzg/sQCaKfbfUxYjkIW4dK4mXFdPygldw0DR81bXI=;
        b=H6RWswzhKJBiad/BLLFcI6sNo3JNV0jWR2RgsgC3J5AL6Wlico9lsDLDJ9cTiUyfSx
         WzOIlgrVfIiYonLP+JxeDUoWiw4LxR0gPH1x1f6BtduX0GrAH2xjB91D8eqHOdLrCHR4
         jUXGqnUqR3VdMVpFmaiOajhX+fMKC+/Xk2I+8IBFC3/O1T/ZWWxEV9EkgRLrV7rZdgpV
         9Px8QvDzaUnMJz5a0sDstUrTJFAx8mOq0qnm65Y/p+PcKQiqSPhg5MrMeVWssP1FZdA/
         V099aeJWdhdCQtRFUQeDhd5Stj4IBLJQ4qhYeqvDPmrhHoIcEvvWAxmMQgSE0/ll44Zf
         VmTw==
X-Forwarded-Encrypted: i=1; AJvYcCU7kTleQaGNFtjvk9SbP7rqhF/DpK/iq/IAqOkv78InWlGJyoudBDhKJeI/C03WKrvJ1WY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx40wmPI3FJZtL6DHEr/fmPFKnoIaYwBw69Fl9AxdaCGb8aWgFe
	IMnjDWg9LJdxkTZd5cWkb1QaWQ1T9QQP30waMQ22Ojij+cHwXnErpwcxlB3kohLxd+Y84SgAB3B
	Bbg==
X-Google-Smtp-Source: AGHT+IGFlgWX0KKA/ZGZ5IsWUoPGyuuB/g3OCmrsFVhtApZPgZzMWdFLLtgmd2LXV8EXavHvLHIIovN59Bs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:9e0a:0:b0:e38:e8d:2c02 with SMTP id
 3f1490d57ef6-e38263a8b74mr588276.5.1731626230833; Thu, 14 Nov 2024 15:17:10
 -0800 (PST)
Date: Thu, 14 Nov 2024 15:17:09 -0800
In-Reply-To: <20241114223738.290924-3-gianf.trad@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241114223738.290924-3-gianf.trad@gmail.com>
Message-ID: <ZzaE9dYmSqg3U33y@google.com>
Subject: Re: [PATCH] Documentation: kvm: fix tipo in api.rst
From: Sean Christopherson <seanjc@google.com>
To: Gianfranco Trad <gianf.trad@gmail.com>
Cc: corbet@lwn.net, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

I must know.  Is the "tipo" in the shortlog intentional? :-)

On Thu, Nov 14, 2024, Gianfranco Trad wrote:
> Fix minor typo in api.rst where the word physical was misspelled
> as physcial.
> 
> Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index edc070c6e19b..4ed8f222478a 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5574,7 +5574,7 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA
>    in guest physical address space. This attribute should be used in
>    preference to KVM_XEN_ATTR_TYPE_SHARED_INFO as it avoids
>    unnecessary invalidation of an internal cache when the page is
> -  re-mapped in guest physcial address space.
> +  re-mapped in guest physical address space.
>  
>    Setting the hva to zero will disable the shared_info page.
>  
> -- 
> 2.43.0
> 

