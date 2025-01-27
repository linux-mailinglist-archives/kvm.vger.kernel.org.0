Return-Path: <kvm+bounces-36672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B4DCA1DB47
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 18:28:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC5C53A4F72
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 17:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ECDB18B46C;
	Mon, 27 Jan 2025 17:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NfCsmS6w"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A954D186284
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737998893; cv=none; b=brVWzlGu1IL/mSEhyFGOVMDCEOyXoXcE95GTKO6R4v9xun9ChJ+wRZXn7dIBimW1DWKmGQ4uvmOqLQm5wgqGTljde9ODP1HQvi1DE4ayO6rrkfMztcxNz3IKyZE9J+gjz5SCdjPkv1TTISZ4bO8QG74fYW/ftmFL0L4BJjU4Eh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737998893; c=relaxed/simple;
	bh=EFt13Z39VVI8xDsDxEOo+NyotttCktfDc42HBQfaI7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AxIvP2LvKjnoImCOSVwkcbs8UIrTnBQd5ywiP346lwPlK9cAnnSYBBrBs5uDTMmbBqh5cgiUJX+3V2Xv8vGO+oQeKckVSdweZVVoHsYTFZuh7hy9oNb6Lok96QaeZbmbY3fKSVqIbwUI+JTIDjjkM8gdSVfkm9m/bFE+wLwKC5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NfCsmS6w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737998890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gxt4Sn4zBUUZ86nHCOmc0z1R0OHsSAuqxQEdKHFpCkk=;
	b=NfCsmS6w3wGimEMjKWMTRXoyFLNeh7NRFKDyp2JbUAGDlFmHPdJgk7NGrPThKr3kzDW9Rc
	rbcfQOjbCHoARE9JMP+894Ez9pKI+GDKrE/JCFxHH104E6rtNYzWI3J/ECNiVd+kU2IOGD
	mu/s3+RRhIAiuu/7NBuK0NYIw21TgF8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-1xuiuScqNBWzApPMaGMpNg-1; Mon, 27 Jan 2025 12:28:09 -0500
X-MC-Unique: 1xuiuScqNBWzApPMaGMpNg-1
X-Mimecast-MFC-AGG-ID: 1xuiuScqNBWzApPMaGMpNg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4362b9c1641so21953215e9.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 09:28:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737998887; x=1738603687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gxt4Sn4zBUUZ86nHCOmc0z1R0OHsSAuqxQEdKHFpCkk=;
        b=XFKq39ej68JFKIiEv6PLZRzb0UG0EZTxDD2ROQz+JfOxpZL9tT1xST+kEN9v7F3dlg
         1KMxaqv4FKcCzXQlFNDJjkeFmT4eAQ02Nj27GvRrjMGNtOHlbaB3b6dHOxsEt1i9ucHW
         XomLsULSVmR/RTX+KfQoEV3RfajITQE59gAya8ikruyn9MiaieaNx0yDc7MFGTXXUhMg
         Pzq5D5zXrA/Amri4tHu80c8dZkCPfaMzCgUqGp7s0nOxOFNrpc2sgRBvkc4m9/GSVZx3
         /jGVSPN0FIWgnbc6g2HVSL0MzZBi7yyfBbRhAKxNgg4Am4oBcgXLezovo0jeywRz9cd8
         Hcgg==
X-Forwarded-Encrypted: i=1; AJvYcCUYsRcOpOpJDR6uguZdGidDN6jTvyNq72N0cfeGM6n78q+8KjJulclbVnVobWpHpQ+yTJA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeREpxLAAZjhn0LpU/8EtGrqCxdnj/NYxdQdB0LyEF4eIzIwd3
	IoePsWMeizn0uBX6wNVdCELozgQMP6QbUVvrPFXWzBf6KVJYLhRgz7GUR89JAoyYpTX6yPTf9JG
	KF6c31zIR6hU1xe2+nUELLwaCwZNlXZRkUdwQm06ZYOHnEN+XqHNa7SjErvnrr9EAyNhpJnA8IR
	HuS5zaLv0HHz5ISnG2mMURUFVVXe501Rou6WGSCQ==
X-Gm-Gg: ASbGnctkq+br7+psU7gttuzLuGElmdR+sOiT1yYKk+4XAdQ71D5yPOF8bmpdXH+ZwPH
	F2SKLQaYuj+vMhYI6vshfWfvdjq6x47z0B4yM4QDIufGlR1qxPNZn3MPa62hM3w==
X-Received: by 2002:a05:6000:144d:b0:385:e01b:7df5 with SMTP id ffacd0b85a97d-38bf565c2d0mr42654497f8f.14.1737998886966;
        Mon, 27 Jan 2025 09:28:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwOgi8OJJxn3gLPSb6LefB2Z1HLC/x5bIkhdR9eTLtiBIgip3YzQPlBhTeEceeAdXP/eeTDl+VChugNV3RuQ8=
X-Received: by 2002:a05:6000:144d:b0:385:e01b:7df5 with SMTP id
 ffacd0b85a97d-38bf565c2d0mr42654479f8f.14.1737998886676; Mon, 27 Jan 2025
 09:28:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124191109.205955-1-pbonzini@redhat.com> <20250124191109.205955-2-pbonzini@redhat.com>
 <Z5Pz7Ga5UGt88zDc@google.com> <CABgObfa4TKcj-d3Spw+TAE7ZfO8wFGJebkW3jMyFY2TrKxMuSw@mail.gmail.com>
 <Z5QhGndjNwYdnIZF@google.com> <0188baf2-0bff-4b08-af1d-21815d4e3b42@redhat.com>
 <Z5Qz3OGxuRH_vj_G@google.com>
In-Reply-To: <Z5Qz3OGxuRH_vj_G@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 27 Jan 2025 18:27:54 +0100
X-Gm-Features: AWEUYZlYDGhWZ58HF-dEhpFw1JzOh3dDH1dGGSjhsHpcKyBLLkcfkUBLXN7SvjM
Message-ID: <CABgObfY6C=2LnKQSPon7Mi8bFnKhpT87OngjyGLf73s6yeh5Zg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: fix usage of kvm_lock in set_nx_huge_pages()
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 25, 2025 at 1:44=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> I like the special casing, it makes the oddballs stand out, which in turn=
 (hopefully)
> makes developers pause and take note.  I.e. the SRCU walkers are all norm=
al readers,
> the set_nx_huge_pages() "never" path is a write in disguise, and
> kvm_hyperv_tsc_notifier() is a very special snowflake.

set_nx_huge_pages() is not a writer in disguise.  Rather, it's
a *real* writer for nx_hugepage_mitigation_hard_disabled which is
also protected by kvm_lock; and there's a (mostly theoretical)
bug in set_nx_huge_pages_recovery_param() which reads it without
taking the lock.  But it's still a reader as far as vm_list is
concerned.

Likewise, kvm_hyperv_tsc_notifier()'s requirement does deserve a comment,
but its specialness is self-inflicted pain due to using (S)RCU even when
it's not the most appropriate synchronization mechanism.

Paolo


