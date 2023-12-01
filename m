Return-Path: <kvm+bounces-3177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFBD0801643
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 23:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E11C11C20E06
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 22:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886C5619B0;
	Fri,  1 Dec 2023 22:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xAKRMNyA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2387294
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 14:24:09 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5c65e666609so52721a12.1
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 14:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701469448; x=1702074248; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/EaOyG2WIzsmtRAtj27ai8on7XhQQ3gj4a4UXCtq+eI=;
        b=xAKRMNyAvhsdmdwsxirPecuic9+vA3FGhqgLEEGD66zfKFy1JE6KnXdXVebXGH6kTI
         +bW319xynRBprHz49TYRt9f8VxgZt6C6zy7bvx9kyXJD7cMNws8GDnyJjZNa9FzM7v/f
         JRZbwdRgpCK/OCO/64BEwZOYl404E17RJ4BWzDM1yQm3eaCyeLAuNzI+22jyrYFk8j5d
         5XPMUL/gfkpfPDdkcbvD288nftmQ6USSewEbkwR1RFm87YpRIbdpRqD40RKNYSynCqq4
         K4tmixrgjYgmD/iwPM77JQhLTMwoo5TUy+JkRV3W/E9hAHKYyaYpVQnEJyuKo64FEYmv
         SKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701469448; x=1702074248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/EaOyG2WIzsmtRAtj27ai8on7XhQQ3gj4a4UXCtq+eI=;
        b=YZlQu3sgckMIhWKpq5VWgPlcXLV5LUtBVdTpwIuZjfEdQToz7EzOmE0hFnOUl0nsFl
         oqYWBaXIE9uqqWSzpQVOpNlSsDxppiifLpQCGiFzVza60XTvRDRc+6582w0ZxTExr+oH
         oLZJmgbjUc3bwPKIrSr6iZkfridG+SREdyI2F+4jgrIQrRc9eaJcATFFkTYVNekixUc7
         8sTUzcYWU4j3WJMqw1DpYaBb16LeEBo9eylZTD3KdpP7uvBTYVncfrDBf0FWsF4Vdd4R
         YuxWNO7xhal3FcYQINsl3ppBflti9lNv6SjI4J9RNHBI5B/3v7HW6abE+6T+I/XhD9va
         T5hg==
X-Gm-Message-State: AOJu0Yx1cBvXnpRXUo5f/Yb+AUwbLefFLl21x4MNF1bYlz1n4qHjwQTL
	6/PeIhPsw1McUh3bPT0LXcVwyCaoKMk=
X-Google-Smtp-Source: AGHT+IHBKsIe10IjUhxcQAtfYEI4/8c1//xFBlfVjKfiL+tnaRnVczW5eRuthcqEdiVgakMe8USSUyiLSyo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1402:0:b0:5bd:bcde:c677 with SMTP id
 u2-20020a631402000000b005bdbcdec677mr4120679pgl.2.1701469448566; Fri, 01 Dec
 2023 14:24:08 -0800 (PST)
Date: Fri, 1 Dec 2023 14:24:06 -0800
In-Reply-To: <20231129153250.3105359-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231129153250.3105359-1-arnd@kernel.org>
Message-ID: <ZWpdBtj8RIB8m_jD@google.com>
Subject: Re: [PATCH] KVM: guest-memfd: fix unused-function warning
From: Sean Christopherson <seanjc@google.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 29, 2023, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> With migration disabled, one function becomes unused:
> 
> virt/kvm/guest_memfd.c:262:12: error: 'kvm_gmem_migrate_folio' defined but not used [-Werror=unused-function]
>   262 | static int kvm_gmem_migrate_folio(struct address_space *mapping,
>       |            ^~~~~~~~~~~~~~~~~~~~~~
> 
> Replace the #ifdef around the reference with a corresponding PTR_IF() check
> that lets the compiler know how it is otherwise used.
> 
> Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  virt/kvm/guest_memfd.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 16d58806e913..1a0355b95379 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -301,9 +301,8 @@ static int kvm_gmem_error_folio(struct address_space *mapping,
>  
>  static const struct address_space_operations kvm_gmem_aops = {
>  	.dirty_folio = noop_dirty_folio,
> -#ifdef CONFIG_MIGRATION
> -	.migrate_folio	= kvm_gmem_migrate_folio,
> -#endif
> +	.migrate_folio = PTR_IF(IS_ENABLED(CONFIG_MIGRATION),
> +				kvm_gmem_migrate_folio),

I'd much prefer to just delete the #ifdef, e.g. so that we don't somehow end up
running fallback_migrate_folio().  I have no clue why I wrapped the hook with
CONFIG_MIGRATION.

