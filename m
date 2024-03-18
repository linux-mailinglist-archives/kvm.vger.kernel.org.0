Return-Path: <kvm+bounces-12041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A31CE87F3C6
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AE93282F9D
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727945C05F;
	Mon, 18 Mar 2024 23:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M+pym+28"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A674B5BAE0
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710803099; cv=none; b=iACXG6yh769C+rmd6+4AmTIAnZfjL+657fzBj3h+KulUq+QVkt6JcI9CvP2eSi7U7fHERQtFySEjFd2JeAIAi6ZAUwDzZTj+Ivdg4zKSNP5iO2LKkI8v1jD6N/JXN4npdn3eR+98eL3KBL1Hr5xvNY3HCkgQVG8hfa12Z0f6kfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710803099; c=relaxed/simple;
	bh=2bls1+H3PwlfTa0W9+dh+wYPbk/Ifn6qBH+g0WFfirc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I7JKwDTnbdMCQBAy3f6of3CX7yYDZ13QuS+R58MKHvLHxlb9UUPzW0RJ5ATa9QNyJKnvgoccYL1xHFO9LbHod/VaEGpnrkZEBSffAL0fWo1f+d+Sxm9imJ58S9mBvHvjcyZNSMOXcIN68nT+3diNbV7yfQS/frQ07cpbwraYfxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M+pym+28; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710803094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2bls1+H3PwlfTa0W9+dh+wYPbk/Ifn6qBH+g0WFfirc=;
	b=M+pym+28U1slqrHaJl2QZlfzyM+n8fw9RcaG3fAPrSwI3LF8zQfWfssDxJic7ryU2gdrH3
	18yinj+iaXdxW3MiKzEQH6Kb85PzYTHn7WSFQDO1wc0BfnO/nv9cFALFSiIlS29Tt8gOXv
	wZiExeqlC+lQYqfhjXWoztGKvQutbpo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-n_alCyCPMKuu7Ba65gcmcQ-1; Mon, 18 Mar 2024 19:04:52 -0400
X-MC-Unique: n_alCyCPMKuu7Ba65gcmcQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40fb505c97aso33183975e9.3
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 16:04:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710803091; x=1711407891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2bls1+H3PwlfTa0W9+dh+wYPbk/Ifn6qBH+g0WFfirc=;
        b=OF0UB84LkS7cwo84v7cUw9ulR/+h6FrghYxGGAIMwv+TDGrubWPapM1a+R7a7nyzEq
         W3fnu7jG7chgwakb+Ln4lVw+Lz56RL9ZED2N19Z+r5KoI+R1b7lx2DXCbs3ebfdr73Gq
         UpkB4Jb4vK2OrOH2ix1J9rIhsXRklbP75ESvkZzr18MmwdveGvp/zIDZ0y8AHczPlljx
         8qwUM9zlASQXj2TjvzxKoWWL33MfAy5F1QytqXMv/wUCg10JPYxJ1jdVd5MHOtecVBmU
         5/ClHPt6PE6RUxO1BtoA9o09nYrEUkluEOJGFuvLp7EU8EDS4YDpc0Ivbu6VrtccH0q+
         KFCw==
X-Forwarded-Encrypted: i=1; AJvYcCUJE/r8fCcyvdnrv2x5Q+YfmHkmxJSNNebLKuJuylYwYgjrRxNJyI8F5ny+dMsmfSVGVsNpTDVCZp1TKj0VKsZP+V9a
X-Gm-Message-State: AOJu0YydRxozebUa7mZNbQ0y7tf4hwfNtHa73enySvGshuT5E+ZOx+Jn
	LZzaoQ13HplU8qYjdXu+uljyQ793UwAU5u0+XbyoKBpm0/hMjopA5OYqIQVJZWwApOXpK08iXUl
	Zz1q6slIeY2oT5gcADXzttRWeaDHe6Q2alwJhGNg3xCDYwbWDSGWpa49HzRS+6XkUbsMSHVFrgS
	RGM7oZM1WL/IB3aNYUwPvQQHzF
X-Received: by 2002:a05:600c:1546:b0:412:d68c:8229 with SMTP id f6-20020a05600c154600b00412d68c8229mr7351761wmg.39.1710803091811;
        Mon, 18 Mar 2024 16:04:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEsz9jEEavSJxI8HdinJ0wgKyMLykG+kV8xTe/yLnKDFS+ZJFJrYGYQ0faj3UkXxqFRkIIeBEd9y/uXD7OpJkc=
X-Received: by 2002:a05:600c:1546:b0:412:d68c:8229 with SMTP id
 f6-20020a05600c154600b00412d68c8229mr7351749wmg.39.1710803091498; Mon, 18 Mar
 2024 16:04:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240318221002.2712738-1-pbonzini@redhat.com> <ZfjHKdx3PNqQfkne@google.com>
In-Reply-To: <ZfjHKdx3PNqQfkne@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 19 Mar 2024 00:04:39 +0100
Message-ID: <CABgObfY-w8uK+Ra8tK0e8xFDQYA68V0Jb0SrLmoM72yxgp-2eA@mail.gmail.com>
Subject: Re: [PATCH 0/7] KVM: SEV fixes for 6.9
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 18, 2024 at 11:58=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, Mar 18, 2024, Paolo Bonzini wrote:
> > A small bugfix and documentation extract of my SEV_INIT2 series, plus
> > 4 patches from Ashish and Sean that I thought would be in the 6.9 pull
> > requests.
>
> Heh, they were in the 6.9 pull requests, but I sent the SVM PR early[1]. =
 Looks
> like another small PR for an async #PF ABI cleanup[2] got missed too.
>
> [1] https://lore.kernel.org/all/20240227192451.3792233-1-seanjc@google.co=
m
> [2] https://lore.kernel.org/all/20240223211621.3348855-3-seanjc@google.co=
m

Duh. Pulled both now.

Paolo


