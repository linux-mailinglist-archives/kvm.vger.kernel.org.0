Return-Path: <kvm+bounces-35988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A112FA16BC3
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:45:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59C10188547F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 11:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A1C71DE2CC;
	Mon, 20 Jan 2025 11:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CDCLi6qZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE359A23
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 11:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737373534; cv=none; b=LXzewlFao9VOFCTKl6x1yd58BdBwPzahin6WJ2nmbsOcuz5OUovkhQKOGu0RGNFV3iqoWnBIF8iu4Ri3zNcpUQ77FRGIhLbFqhhsWpplwJCpCdMSjfk/LY/M/vQQQNFvg7H22X3BvMNZ5BfzhrhQQfA2Vq/1quZODkq5Bm3VVj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737373534; c=relaxed/simple;
	bh=8otnKBV6neN50FqRhuOHQqdZXyZ5MaH8ogqcbPYDPCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tA2wHs3WZaiqypj0a22IdQ1gNKvu5Ei1qR5kYREYX9So0u8XBa72p2jrtAk4ivdkDTQgeIuEja32/e13bEKkmwJvnXHbhPS6g01AwEqT9UvAebJgyRDVCuXLAC+MTwhXcR2LBXq8wmbYlzBJvXDc1epqeOgkWYupmMLr4aG+qgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CDCLi6qZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737373531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bN3sobdhDebg+d5fVQvugF6+GH2pEbJDP8Ne7JSGlwk=;
	b=CDCLi6qZiDIR6JKaOXkrVsYMUru52YIgTgY1QwYPAJRYVu+vF8Q/56LFFKwJQrMdIqKdP7
	1T852wyXWnR9dWMhxlLXV3o2KzdvVIpEwKkb8abp+qSqse6YSXxc5zgzcTTf7UqtRWrDlM
	MeADMt9OaOh+IOpiVtDXyskNPyPj1SQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-twXPvVpEOdi0HZzMB03fCw-1; Mon, 20 Jan 2025 06:45:30 -0500
X-MC-Unique: twXPvVpEOdi0HZzMB03fCw-1
X-Mimecast-MFC-AGG-ID: twXPvVpEOdi0HZzMB03fCw
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ef909597d9so12550998a91.3
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 03:45:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737373529; x=1737978329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bN3sobdhDebg+d5fVQvugF6+GH2pEbJDP8Ne7JSGlwk=;
        b=KqMOfK74SI3XZsDT89vj61wAGXUAi0pAUqU4OytpHhcnrJI8UBK0mPoxEpTdJAByXT
         ffm2tErRmu5QU3FV2I0cjytrU9JqAeXUUqg9QMmSCajf+qZMQzrpo2VCTV6I4sAg6Tz3
         TG/81bHw10dLG1n5LxhaHQZmQnIJ+Y23LbaUUwwzmWspydXDTWF9j4Jcng3/7KPlllRk
         uHTjBV9kjX2DeQcvqUFxhV2a9N+WYrw2dz9XUJq9YyTQueSWsXP5165qzD7XW3zC/r7O
         I3YsOdRHcj43SbbLvJKLNFGd813Do5BisTKlcOAuDZgYnW8Picab1ewiC525kjTkqg+P
         +BaA==
X-Gm-Message-State: AOJu0YwAjYBkn5L2mtzPQto4FXYiJURBBc2w3AyohryCJZl+kCA2GkpG
	ahbYL97N0isq8XXnCpc4MrpmZJYnpJFecybpz4PtkflKlbX1vIcpJa9oCDnPnyN9FI5NB2ndopo
	SOdDojiwFmiBBMYNXRaFvwgOI45HcIiMxBeb8iLrfXflnnOwBplEiFqa2J1PILSTzSv6c6VIX//
	65OxBL0nR8mYkkOB1gE4geutTx
X-Gm-Gg: ASbGncs6ig3/SQ3WPYwpsmDuR1CtuSnXdj6HvU/QMqskztEaY6+RYjCI/JkHEKsruYw
	0z4P/p97wGPraU96UZMXAwmrKTdM7ihxdsUf3s1vMTz6FMNLi3+by
X-Received: by 2002:a17:90b:258c:b0:2ee:c9b6:c266 with SMTP id 98e67ed59e1d1-2f782c71d97mr18584582a91.13.1737373529172;
        Mon, 20 Jan 2025 03:45:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHfGkNQxlGTGcU/JEiJlyyo4HX4itl+yxoBCxRyjV5YOJF4EO6YXymME2cz/lPF2AuSmjoEju+xDRgWZvErlRQ=
X-Received: by 2002:a17:90b:258c:b0:2ee:c9b6:c266 with SMTP id
 98e67ed59e1d1-2f782c71d97mr18584569a91.13.1737373528914; Mon, 20 Jan 2025
 03:45:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117010718.2328467-1-seanjc@google.com> <20250117010718.2328467-5-seanjc@google.com>
In-Reply-To: <20250117010718.2328467-5-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 20 Jan 2025 12:45:15 +0100
X-Gm-Features: AbW1kvZ49KbhlrhHDQniR2oVwVNE9sixe4ApZwbZjh64PfJs3WvI-l15Ocs_zPg
Message-ID: <CABgObfZkQ_r_QY=xREKN+EdoaMRqRjVmk5Fz7UgdDrj=kmU9tQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: Selftests changes for 6.14
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025 at 2:07=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> FYI, the "LLC references/misses" patch exposed a latent failure on SKX/CL=
X/CPL[*]
> (who's brilliant idea was it to use "CPL" for a CPU code name on x86?).  =
Dapeng
> is following up with the uarch folks to understand what's going on.  If -=
rc1 is
> immiment and we don't have a fix, my plan is to have the test only assert=
 that
> the count is non-zero, and then go with a more precise fix if one arises.

So based on the thread there is a root cause and fix---the test is
just counting on an unrelated event.

Paolo


