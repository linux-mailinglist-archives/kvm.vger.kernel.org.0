Return-Path: <kvm+bounces-66051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 08B59CC050F
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 01:12:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2C95C3002EA3
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 00:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8AD18BBAE;
	Tue, 16 Dec 2025 00:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G4zLVULW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADAB35965
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 00:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765843937; cv=pass; b=fL8bQNaysJj5+zbKg7yAcd+54q4h0VfCYR4BGCKz+mLXl2ATbO8fuNp6bY2kKh1WjB/s6rrvVH5JCe2p53DFNzyd1wf/buTve3R6zAaiYakZiDTKoCiD8U5i709hckWpyGK+mSulldd92xNUNKPR4JkjznJJHVjQ39H+ii7QyA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765843937; c=relaxed/simple;
	bh=0tv+UfE9Cjf3pcT92AawqgfgMaTHbGpjLAJBio+41P4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LTbre5ZoCzKKi7dy1JOdkF2ts2fJclEADZJ9GQESVuMqiSOf48orWLicRaAHO/BAsWnp7k5u3oKUMsFqP/SeBi2uF8bgj5u/RigaY6GnYCzYhFXxqUgWhslabu6cf8RgZFdUmKqps1AccJ0u7YrEnzOm/dcGYkMYPChr+K3viaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G4zLVULW; arc=pass smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-29e7ec26e3dso46295ad.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:12:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765843935; cv=none;
        d=google.com; s=arc-20240605;
        b=D2DMFexU7ORBLaGvo5ZyeMYR/lovb1jvGa1OSawXBNR/dwAP5jGmt9UzU06xFBeNVl
         vRHzPDksdPYof02ZiAMQ1jDOdCfESzbKYxdKT2jodIGp3BJhzt4ONG8V1cVgqSxuLYCX
         uovZCmkEeIsGkzYWzg3UPjJjxt79DNIA17J2NX3SOEYy6vSKuKvSnqHtjiPx03FMeifY
         D7W6vIUZwtWf8LSw5msfpTyMNRHMnrydHBnSxjsIVpFJLT91V3J6dp6bR2/f4/GU9rFK
         hP0fmXJRXgxlmqrtVKZ7O9+IOjuB3Bn3Cn3JSoi6v689SanbfBizSz6Qo953wq9d9BV1
         pYng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=27wQsfuOXjJhJo74CLfXwuW+WvRgdLz0XpQKIZiK7fE=;
        fh=f0Sa/Gk6aV+Q0XgvPyFCasN4iiurT6FrEyCiHiudOJM=;
        b=U1tk89Ae85aqQFR4hhmEPw1esMp9+HjXdKR23kAdrIz8zYMtFBTSnj9Dp16lEJfpFW
         PKmhEkbOjNMJQkMvZh1nZLS0hkFS0IrZ6nZrDhC3pddJIjJgy9HxH8DDjxqZKsduLgLp
         blQTtwseTVNitY+iP0g9sW9m694WFgNURI97ozj7cHY7HyO51SlPCI6Ks7CDQ3Nw/8Dq
         nvL9Yp73ji763wPIhPxlxo0QaoDtjiZM2CIaiouAY9Blz3opMqqvmMlLoFOsqCFZTMfd
         6f0CjIPKFUAsJl5gURZ7jfriCWnjEuOCeMYKlzS8uiCNBge9jKcHNNFihZuxCqkic3RQ
         jkuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765843935; x=1766448735; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=27wQsfuOXjJhJo74CLfXwuW+WvRgdLz0XpQKIZiK7fE=;
        b=G4zLVULWz6iLuzrAuxGayEyfVdvvncGfLkD+yVkaGRNpNtsGvXPikTXOKzDV4TBNij
         kpidn/WDY6inDXYSeYagliNZvo4cwyDX6xUtUGs5M/wa7W069peCWhX2h7n14KTEQef7
         0jmRZlDlC7odR+yo9OWHDPjbRcKCK4Anx4ty6yAnxhURkreyhVwIJ/5P05fZ/SwVFmWL
         tqYcOCo7GETfudj1VC6yxX8jZJ3qkxdnwQ/8f8pLYmzI3Q/zVYaAPta7uSI7P8r6wvTx
         Th7Q/bip/P29pga85c3V15iC4ut7BbUXKkWlxCAtsTL4YB57pgA75Yt8iUJjyzMInSrJ
         wErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765843935; x=1766448735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=27wQsfuOXjJhJo74CLfXwuW+WvRgdLz0XpQKIZiK7fE=;
        b=GdLTF9HPALTi+y5h7A1fIWSnLsRPZLdUq1Xa9gu8LleJ7iNmCZ6oPEO2h4suaOOiMG
         RN1Y4h2hiBI6RzyB+aNQg7MrRwXEvZvo3S8CFFjWuRg9Md8IwriWBmvbbQNuJHpOSuaz
         jMWWR+lMXf1LQcemKUybA7+pWdgEAgBzcqanT1dKmZVw2SSHjbYzkEQSV+Syu0C/Vrrj
         7D8z5U5nbDGwvyRkoP+DfxIFWAirl6J+aFBL5aj+u5ZuUzkVxeIrt2lsD4sNF4a8114P
         NQc4JXOvI0yJpJyhWFU36YaaN1kYDLSErRSPYbICCzzTOv+pU4/P9PV5JVub2UyVEWD/
         CsLw==
X-Gm-Message-State: AOJu0YzUoIg5I9R4EVlFE4h5V6zuVqcaXBOU+XZwv76wUHtcFJ8mBbsE
	+v/h9f4Cco8UNSEku28rgg/5mkXP1RKgdkA+W45VL1mapjz+HthWszo0UWzCCwrm/f7GRXM1qy7
	WmiyIlScD1VNW82ns0NGXk5PbDviq83rUMCHVi1g7
X-Gm-Gg: AY/fxX7jKSr5LEZ/s7PG5QyjnrZU7AKrDbrLTRQ50GncwNpX6LpHJndJlj/JilogttZ
	lp4vdZwKSky8WqrGgIwNFl0qVxXyukn2eagQP12a5VoiGRfsVJCy+qhjsIfHaG+xXeB/feiUM5i
	Y/hFSZyITF/hWmrTayIRy7CpKDzRGcAJOgJQ1uyGiIihgfrBysrc3uN2CUHJU7N+NQeQ3NbxD85
	8IWpPkhDJf5QQ8/QZkJPemwEWlb7V8o8+YMmzK3+Qv2XOj1/ptlZZbRv8xu4IiQsb+IXxg/2Fzi
	WCnjHGFEd/y7W43oEhUXPZB1Ii6d
X-Google-Smtp-Source: AGHT+IFYx2fqkqoq7nwgp8s1TBunZASqxOa+paDvYopFfRkFHpqotvWma1Omazh+JGGMYTXawA8rx1OS57mP9gGziPM=
X-Received: by 2002:a05:7022:68a1:b0:120:5719:6249 with SMTP id
 a92af1059eb24-1205719637fmr3220c88.16.1765843934179; Mon, 15 Dec 2025
 16:12:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com> <20251215153411.3613928-2-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-2-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 15 Dec 2025 16:12:00 -0800
X-Gm-Features: AQt7F2ra9396Gr4eNuUU-K7XtTwtvJ-rm6VSQCRwWNTFPqW7whDLIsPPpRjnSlU
Message-ID: <CAGtprH95s5wL1=rSSpG7Cmj5HhJOftwJY7CP27WE-qmq7hr+XA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] KVM: guest_memfd: Remove partial hugepage handling
 from kvm_gmem_populate()
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 7:35=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> kvm_gmem_populate(), and the associated post-populate callbacks, have
> some limited support for dealing with guests backed by hugepages by
> passing the order information along to each post-populate callback and
> iterating through the pages passed to kvm_gmem_populate() in
> hugepage-chunks.
>
> However, guest_memfd doesn't yet support hugepages, and in most cases
> additional changes in the kvm_gmem_populate() path would also be needed
> to actually allow for this functionality.
>
> This makes the existing code unecessarily complex, and makes changes
> difficult to work through upstream due to theoretical impacts on
> hugepage support that can't be considered properly without an actual
> hugepage implementation to reference. So for now, remove what's there
> so changes for things like in-place conversion can be
> implemented/reviewed more efficiently.
>
> Suggested-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Tested-By: Vishal Annapurve <vannapurve@google.com>

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fdaea3422c30..9dafa44838fe 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -151,6 +151,15 @@ static struct folio *kvm_gmem_get_folio(struct inode=
 *inode, pgoff_t index)
>                                          mapping_gfp_mask(inode->i_mappin=
g), policy);
>         mpol_cond_put(policy);
>
> +       /*
> +        * External interfaces like kvm_gmem_get_pfn() support dealing
> +        * with hugepages to a degree, but internally, guest_memfd curren=
tly
> +        * assumes that all folios are order-0 and handling would need
> +        * to be updated for anything otherwise (e.g. page-clearing
> +        * operations).
> +        */
> +       WARN_ON_ONCE(folio_order(folio));

I am not sure if this WARN_ON adds any value. i.e. The current code
can't hit it. This note concerns future efforts to add hugepage
support and could be omitted altogether from the current
implementation.

> +
>         return folio;
>  }
>

