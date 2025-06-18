Return-Path: <kvm+bounces-49904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF30ADF801
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 22:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 592BA7A9D20
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 20:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23497221F14;
	Wed, 18 Jun 2025 20:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1pA0vGZB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25490221DA6
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 20:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750279352; cv=none; b=MGvxpC0AgkhxQTZ3dNxFZSD+F6Smjq7D1mmrWc2CiDmNy5ENxNe/WApcTxnzr3pBfh0tBNTWym5AjrQMe6CES2wDDGZyCHdA3kEhi9D7OQKvGHVkm8euYAubjuORf57st1p8bLkMaO9zXJaiFTR+anIb8unf3sLkOTS0bdMDMoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750279352; c=relaxed/simple;
	bh=ocgAC9TbfdSQHxFe/9Wrs8l8/UPeshbSR2dH6VLKoU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iTC+EUbcr4PXBUFs8CVaPdg3zbuY2F1BxDe8LI+A42XQiQO/Fa+usC24ikM7RKHpYNKvKGYEuyqXHOyQ4EbN3hO05Tl6bHy3wNwA1ALzPf2qkOiU6YqzrSdI4J+dH5eA+BsLWkpdN7hj4AR6wojELKthCFgmx6r1VHxVPgqoi08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1pA0vGZB; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e81a7d90835so162102276.1
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 13:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750279349; x=1750884149; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocgAC9TbfdSQHxFe/9Wrs8l8/UPeshbSR2dH6VLKoU4=;
        b=1pA0vGZBaxa6Xp7IPRsntHX51R8AhhCExokOkTgsRl97Z7Z/nDbnBvejcqdYgGH7Ra
         pFPb5hIgHFxuD+bZY2a3UVaxkCC+W11wAQOdlD5QEG4TpQt3cmi8U8kMWkT6saZvyiMx
         8ih9OlRvF69x9aVLg3lKGgDd7Sfj5MYJAdz6eEkdV6/KIfK5qM6KJXxHqS4BIaFs8GmG
         JJpjHAja3LgWr2wNEEAbTVV3gVxv+SeidVljLd6PBuKDWZomirPkRWltRMF0zmFlk4va
         XMeEVNqdurji9yoi7q4OuN03NEMb46jfDgI1vkPQi3ixuf4p1XHdkwZer3OA3GCoyu59
         j+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750279349; x=1750884149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ocgAC9TbfdSQHxFe/9Wrs8l8/UPeshbSR2dH6VLKoU4=;
        b=wgBTKoLVLlF2tEb9jSLnJtGIEaInKNNM/qRdRKR4pcHOsagAHv3goXax9XZ3KdRh6a
         Tgoc2hWwM14Jiv5JftBcIK/Bt7zTfyYTXVR5xWk6hVYPu5GIS8HZzeB+/OTrVF6rgGdb
         mAeYkH4pLoxA/S0jH9tnkNZ3lUVfcTMqGA2Oja1K2E+LDr0YTpDBrfmZzkHNoLQ3GuM4
         RGsWfjb9P8inWMELh1gCOYj9HO5il096fdFvHW9eVEdDCegksB2UlOfU9Q3AQCzBKa2m
         KHU3maniy0I3ZEUl/QQyXhf0ztoczHEThKTZZq13fUHV4bpq19KA+C8R1I/uMpMjXYQp
         C5jg==
X-Forwarded-Encrypted: i=1; AJvYcCXLFRz+miH4g6lT/0qoh6l+BtiFKnj21p6RBn1nNhaZStY/cGbbaY+GwbQkWjlIau9I3BU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpgUN+UFlp5GCdAlOeY91MQWE1bDdC7t9adTXKjsWcvhmE5PiN
	9XbH3cHP+p/+JiWxsV45Snf2TLSgEXJqYGMbenWv+EGvGMCvihlZF9mJN2lwYpiygw1l13fE4Zk
	QSRd5U6GuJxf53ECXQ5QT+9zcqPgxqTd76RnsM5t1
X-Gm-Gg: ASbGncuOouFgmYKDy0piXGuut4a75oKKmfhskYkovQDH2A9J9eqy1a0Cr7AH2EsMkqi
	iUCECdmZv+VPn8QBPeF8TfcyLWrRUFzDieyJtXj6/5uRWeRJ+S34Tzen4ECqsb7jBj32eOlODfu
	dAzKcVWTL8TjV0I7TE18RZlrHhewczGyT2t5PmgkuCaAn2mk7tM1u2DWxEtx2bxyp/uyWDeLgM
X-Google-Smtp-Source: AGHT+IGcEUDnd4GOH82HX0lZBlNqLdPHex042iyWzP+top4zuE3jGLedRPqyTacYh4EfWqEYfTdFMF3OiZxJDn9T9t0=
X-Received: by 2002:a05:6902:1384:b0:e81:f864:133a with SMTP id
 3f1490d57ef6-e822acab4dcmr25869982276.7.1750279349015; Wed, 18 Jun 2025
 13:42:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-5-jthoughton@google.com> <aFMWQ5_zMXGTCE98@linux.dev> <aFMh51vXbTNCf9mv@google.com>
In-Reply-To: <aFMh51vXbTNCf9mv@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 18 Jun 2025 13:41:52 -0700
X-Gm-Features: AX0GCFvXF0fglyYJXBw3pBR88VTwnhV-AWZMFY-OnV-bZ0m2KXl_JUKDh5V8wUI
Message-ID: <CADrL8HUeS2HNu7ufQzq6FkgBAsruTok_rkr=ydsGBPgUNjgUUg@mail.gmail.com>
Subject: Re: [PATCH v3 04/15] KVM: Add common infrastructure for KVM Userfaults
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2025 at 1:33=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Jun 18, 2025, Oliver Upton wrote:
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
>
> No need for my SoB.

Would you like me to drop your SoB from all of the patches that are
not From: you (patches 4-7)?

