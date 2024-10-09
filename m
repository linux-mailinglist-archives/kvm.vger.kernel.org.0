Return-Path: <kvm+bounces-28287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 440F0997185
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03449284C0D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304161E32D1;
	Wed,  9 Oct 2024 16:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4spu98kA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99EF1E32B0
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491050; cv=none; b=GllkmrfXBnjNzK59T+Q4sDIxOJCu4benrU2ho7jPey0KxvOMhzDxTWKaOEA4hR6L7g6HguxzuemGcLJUDss37aaVk24ccasnbjV2LZX8pcz5Cdz/S7Zzc/PbZQuWNn6bM4DquHeRY9oBKd6gQ9wxkZwaJtsvF7iLcVBGHFY0eqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491050; c=relaxed/simple;
	bh=h9k0zHpcD4juwOszn0RrZic/tf7PxFUbrpssw/W5P2E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UIiNK61jH8g7IyL147mRlvcsoIFTTE26YqyA3ir8yqequ9ZnKCRM4V28noFedVEqMHF41Ni3IWLBVZHr2dobi92J/STcex9gb7Nb5YZ72hkElRusQbuniklHT+LTz/9q7t6/jCjrBVjTkhJ/zizFhasv5axz/dSlKz6KYB/tx8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4spu98kA; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43111d23e29so216785e9.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 09:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728491047; x=1729095847; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9D78SQ1nt3kn05K728XAvjGR1XXh8MDdwP9hLjHm5Y=;
        b=4spu98kAuT2rg6eV9Za2aKmtvitmYFFI4SBILaf19dFRZFKcJtHg4Ek3FUTqTPK8uu
         IPsKJ+Ewa4BB5EjvAlYLV50KpB0uoY8SyyAEtfTyyFND/UDI8cvvNGIgd5zdQFhrsPUZ
         +TS/oYqwUVu4cApdymgjrY0YLV2e7xXJ7EAb9Lzvzjwg36Ux2GUhWzY3Q5LkmaC/3GRh
         dRTJMAjMdoXZ0wsY8Q+sjM7RQpV/cFmPkJbwZ2txTXTiIQ3GC2wAcH9I6+XAtfnCPKH7
         8uqghKlSMamZPaBqlfD0mktFZjoXYWe3OZYxg+x5M8IUyFDzHz/dJhwEqsJo3sTUvlXw
         QU2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728491047; x=1729095847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y9D78SQ1nt3kn05K728XAvjGR1XXh8MDdwP9hLjHm5Y=;
        b=h9tKPefpnkgyZrn8IyRa6tSIfTgpOtpKe6DWcYbK43N8mlotkUKVDYoeXlNsTbKvZB
         /zHH2XptP6L4wxLKESGPAukpn+ig9DGLISRVmPLmsWpkg8Tl1gAAAlwRZN94Wf9bEzJZ
         B0MvSV4/qgacWeT0pwodQPeF+Oy/9Jh3P+lSc5CoPkGKD8+uDpi6EuewPvb2gVnkEGEk
         NnpXE5JuCT4PagX44Yu2ePqmRGm20T4XvuLAy+IPRWG5q0dpBh/MkCOrO9/nOGViOSqQ
         rwZE7/9pfvetMwks0XiH+upd1mBmFMa6I/Bvsi1ZIuTbnwe17e9BFQ0gS72KsFVtYRIq
         allA==
X-Forwarded-Encrypted: i=1; AJvYcCVa/eeYcQuyufCZM68pdMXyePqw30HiN2OZkTFT7sYj89DZcefF8/eAUCbTx2lnHIBlS9I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6LWfAyTBvaokcP7m6hXXzbokIVqxVxzumz8jKPzbO6eO0Cx3Z
	2VOIZkZ4vKw92HvkreTUajilMGc/91w2ok3aYx80JsZOcXqLJKXC/LMl3Llv2DUXK9Tes/n9bba
	STZ8H+bIzwVIr81oAjMwv+TgOHNoK0oRiUU9N
X-Google-Smtp-Source: AGHT+IGY+wGZFlC7vWa3goc6k5x5OjABWLBfgF34X62/LwcYXSTQaGtRb37xgEznOtF/nFLnrN5gnfk+MsjLQowy8T4=
X-Received: by 2002:a05:600c:cc3:b0:42c:9e35:cde6 with SMTP id
 5b1f17b1804b1-43058cee8e2mr5519105e9.2.1728491046986; Wed, 09 Oct 2024
 09:24:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com> <20240823235648.3236880-5-dmatlack@google.com>
In-Reply-To: <20240823235648.3236880-5-dmatlack@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Wed, 9 Oct 2024 09:23:29 -0700
Message-ID: <CAHVum0ffQFnu2-uGYCsxQJt4HxmC+dTKP=StzRJgHxajJ7tYoA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: Recover TDP MMU huge page mappings
 in-place instead of zapping
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2024 at 4:57=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
> +static u64 modify_spte_protections(u64 spte, u64 set, u64 clear)
>  {
>         bool is_access_track =3D is_access_track_spte(spte);
>
>         if (is_access_track)
>                 spte =3D restore_acc_track_spte(spte);
>
> -       spte &=3D ~shadow_nx_mask;
> -       spte |=3D shadow_x_mask;
> +       spte =3D (spte | set) & ~clear;

We should add a check here WARN_ON_ONCE(set & clear) because if both
have a common bit set to 1 then the result  will be different between:
1. spte =3D (spt | set) & ~clear
2. spte =3D (spt | ~clear) & set

In the current form, 'clear' has more authority in the final value of spte.

>
> +u64 make_huge_spte(struct kvm *kvm, u64 small_spte, int level)
> +{
> +       u64 huge_spte;
> +
> +       if (KVM_BUG_ON(!is_shadow_present_pte(small_spte), kvm))
> +               return SHADOW_NONPRESENT_VALUE;
> +
> +       if (KVM_BUG_ON(level =3D=3D PG_LEVEL_4K, kvm))
> +               return SHADOW_NONPRESENT_VALUE;
> +

KVM_BUG_ON() is very aggressive. We should replace it with WARN_ON_ONCE()

