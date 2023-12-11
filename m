Return-Path: <kvm+bounces-4054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E74CC80CF42
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:15:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4EB01C212D8
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 15:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C2E4AF69;
	Mon, 11 Dec 2023 15:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zTx0JPwt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A3EDC
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 07:15:37 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1d30efd624fso3487135ad.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 07:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702307737; x=1702912537; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sHC3g9oqHOhY9P31mD7uqpVY9YS1P4PdDX2KFPVf1zA=;
        b=zTx0JPwt4SRsknaKjoDO1urk8qulLjP0JDqakqXMFWyn9PACn41WEG8GmYpgxefQcV
         wkNCudUuENTXjAiD1WGWWXfUS9octwV8ky6nVwtd39QDV4W9ohGklJeh2CeT0djrLbwH
         Zl0PtDuFyt6EG76TB3z3W9hl1X7nngCuyIAgcxee7rm2ppXpwd3z08wdMSG+/guiUXQy
         0+lrCmQuF9aJiSb5iE4KMNGuOzxteEKjB91gDhGRf7FrlBdt18oq5TadtS481wBwchhh
         ARfCpVUupGv2+xDUbDsPNyQCsmkIg8+8/ysgjADfP5EFwR+RM1YgDAulxiLK/cWicp7O
         F0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702307737; x=1702912537;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sHC3g9oqHOhY9P31mD7uqpVY9YS1P4PdDX2KFPVf1zA=;
        b=TkWna0VA0/S+cdCXqavM8/GRZFrqwbTmvlYu4ZBo9cbIa2T2vWA/bo6LAQKssi+b7S
         C59PsVAyOfGBCaixGk4u2dSUWwvGpIn+6jDCS6yq7wrpRW/9meKOX/RoCH5mfHAVUhOO
         x9FkTZGQAj4YEcx+UGSSblqESWK62ug7v0jaP0Oywv0/xNDEU1GhAbNE7A/XFXstNZnB
         y41N1V2izh3v/RhhlfxRN9PsVe9p3Whst+hiJbnKF56uDmvyL1NQnhVlulUo17a5OgZe
         SZNqg7EXno5qIU0LPk3T9B4tyOPhVmafW/lxhtuSaLaB4is1HZIANuqlB/doRq6qZTUZ
         L7VA==
X-Gm-Message-State: AOJu0YwMJNkEVJASDEk0QyBV7RLA/ULTL9RWZkTx2fDpZ3zgzf2X8C9U
	JO/3QyQlwpzpM2mDwQFWkRJNeGUbt48=
X-Google-Smtp-Source: AGHT+IFaDU/4uc5wTg26iO18XssiMZIdzHGNiwzRHnUW+Lpwc7Q7YAIcBlHKULH+qKfK92wvWEAdD99Go6Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea0d:b0:1d0:e2b:24 with SMTP id
 s13-20020a170902ea0d00b001d00e2b0024mr36521plg.11.1702307736782; Mon, 11 Dec
 2023 07:15:36 -0800 (PST)
Date: Mon, 11 Dec 2023 07:15:35 -0800
In-Reply-To: <20231211030518.2722714-1-guanjun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231211030518.2722714-1-guanjun@linux.alibaba.com>
Message-ID: <ZXcnlzDhcy8_CizZ@google.com>
Subject: Re: [PATCH 1/1] KVM: Move kvm_gmem_migrate_folio inside CONFIG_MIGRATION
From: Sean Christopherson <seanjc@google.com>
To: "'Guanjun'" <guanjun@linux.alibaba.com>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, 
	kirill.shutemov@linux.intel.com, yu.c.zhang@linux.intel.com, tabba@google.com, 
	xiaoyao.li@intel.com, pbonzini@redhat.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 11, 2023, 'Guanjun' wrote:
> From: Guanjun <guanjun@linux.alibaba.com>
>=20
> 'kvm_gmem_migrate_folio' is only used when CONFIG_MIGRATION
> is defined, And it will triggers the compiler warning about
> 'kvm_gmem_migrate_folio' defined but not used when CONFIG_MIGRATION
> isn't defined.
>=20
> The compiler complained like that:
> arch/x86/kvm/../../../virt/kvm/guest_memfd.c:262:12: error: =E2=80=98kvm_=
gmem_migrate_folio=E2=80=99 defined but not used [-Werror=3Dunused-function=
]
>   262 | static int kvm_gmem_migrate_folio(struct address_space *mapping,
>       |            ^~~~~~~~~~~~~~~~~~~~~~

Already fixed, commit 80583d0cfd8f ("KVM: guest-memfd: fix unused-function =
warning")
in kvm/next.

https://lore.kernel.org/all/20231208184908.2298225-1-pbonzini@redhat.com

