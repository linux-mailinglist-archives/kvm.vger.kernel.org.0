Return-Path: <kvm+bounces-8698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B4485506E
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 18:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28C6E1C20D15
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 17:35:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3323839F9;
	Wed, 14 Feb 2024 17:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LpF3+4hV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9515C6087B
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 17:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707932132; cv=none; b=rdoUoUZpr9A4Y9WlEh9tzfCgMWE5aVbac60HZUS1jN0tW+Kun8dsMpl6jXPvcbT+33zLJpPO1BqKvtjzrw2Y5VS2JAYvO32VBOZ4n3gXcwwyKdM/GuReHCMHs5i13+5FOdLR1Iy+DS/G6TgBybTlGJrCbhhPxsusbiYj6ZNJU4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707932132; c=relaxed/simple;
	bh=UnEKkjF6H+Xa0wreu/FcqnmqSNSg7820UxEfXya2RYQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bJzmYghMZbK0PPv8a/81mfVMHR2D4/UtO9kZEpTYZvuQOC3+bFGyuhRYX24J9Qbq08w7gdC5WTuRw9wi2yp6jHErCVW4QadeQS1pzGP19jvq6NwVLPE11NXANFE6tolEJxJn/jpWIDXrvSUMRaGJIADW4fctZF7oB+4MrGfIUS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LpF3+4hV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707932128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wjcv8N+9j2c+EZOw13h4nVBpRY6k3b6dKwafPGeLn/g=;
	b=LpF3+4hVUnCTYXa8ElxhcVbOOj1+5qAoyDZz+QCE8qgf7c5uyCtKr+2CVa25/TXaGXufUI
	5/QYXRaJTcZxLN4LV6c2PF8vZf/TJrLCk9/XJduZCFv7XQAUWM/qFInPh/n5A3F1CC9iJV
	FA0BXM4f/fnexH+jSgIwtloy40CAu3I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-o0u64Yv8PCiz9fnC9WvuoA-1; Wed, 14 Feb 2024 12:35:27 -0500
X-MC-Unique: o0u64Yv8PCiz9fnC9WvuoA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33cf46a8932so189186f8f.1
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 09:35:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707932125; x=1708536925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjcv8N+9j2c+EZOw13h4nVBpRY6k3b6dKwafPGeLn/g=;
        b=q9EizPEK4uGqs1dXjEvDii+qLkyMs7oGnuWTAG798cdRz8uRwyUv+j3F/SjNWnJQFp
         hwVk7PBxWDSiptRkwrwnmP7OkOxo/hhGU2QNGUEmFOqTprUod0z/xwDgIkTF3L2MrfZt
         ZkcIV4tz4BJpmQF3NCxulxMXwpclwDb2JiTRwB/z+8vRoTrFzPgypw2xwY7njiqObLV/
         uiQH2ytqVvudapvbKkATkUC9po3fIDk6Lrsvbhq24eoJu6j+yCFugB1Oap7u5LNZ8Kme
         PUqE9lv/QI/pg5R4EkHGn0dOGhBMAV067yFNy7hqnXG8Lc8Q90BFALPL7mYdQXlbXC3D
         KMgA==
X-Gm-Message-State: AOJu0YxQXnfZmZcwpmWl47UxmOxKcwc+v971I0zfvHkUUaD8WLzkzKJx
	XE0hk6IrEzFMGfXUU7hbN9FHYGV4EndN5k1QH3rBvUxEAnySBHaXUnp/AwtqMN1t/O6T73FzKSv
	DsQ5pht20EkRJuwVkjWCrNfkN+JwuaN1icDd0006t9kIK9Mo4PJRGaZ5BVO4eQUjKh5v09sGrln
	IqY3pzLoPO2q4Bo2uzmf2nWnNGrx2x+gYn0MY=
X-Received: by 2002:a5d:4c41:0:b0:33c:e327:9f96 with SMTP id n1-20020a5d4c41000000b0033ce3279f96mr2217145wrt.60.1707932125332;
        Wed, 14 Feb 2024 09:35:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHT5FtDGTQYbOYd0BkdVNsDSLM18V6qXnPo6Kdk33MxvhDPJAB0o35DCnQlFDaFL+MTifSp+WH5IFgS5xX4lsU=
X-Received: by 2002:a5d:4c41:0:b0:33c:e327:9f96 with SMTP id
 n1-20020a5d4c41000000b0033ce3279f96mr2217132wrt.60.1707932124993; Wed, 14 Feb
 2024 09:35:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240213005710.672448-1-seanjc@google.com>
In-Reply-To: <20240213005710.672448-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 14 Feb 2024 18:35:12 +0100
Message-ID: <CABgObfbQqVOsH0imHWc938n48TdkD8xFPO4CnwS0EM4oQZAxog@mail.gmail.com>
Subject: Re: [GIT PULL (sort of)] KVM: x86: fixes and selftests fixes/cleanups
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 1:57=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> I have two pull requests for 6.8, but I goofed (or maybe raced with you
> pushing to kvm/master), and based everything on 6.8-rc2 instead of 6.8-rc=
1 as
> you did.  And so of course the pull requests would bring in waaaaay more =
than
> just the intended KVM changes.
>
> Can I bribe you to do a back merge of 6.8-rc2, so that my pull requests d=
on't
> make me look like a complete idiot?

Ignoring the fact that kvm/master is currently a subset of Linus's
tree (so I can just fast forward to -rc4 before merging your stuff),
that's absolutely not a problem and it happens all the time during the
merge window. The way to handle that is to forge the diffstat in the
pull request, replacing it with the diffstat of the test merge commit
that I do anyway. It's a known issue with git-request-pull and pretty
much all maintainers do it.

But for -rc pull requests what I do is just base the PR on the latest
-rc, and in fact I've started doing something similar recently since I
have very few commits of my own in kvm/next. I always start with a
very late -rc and merge in all the topic branches one by one. Instead
of starting from kvm/next, I checkout -rc6 or so, then merge in the
contents of kvm/next with a "Merge branch 'kvm-6.9-paolo" commit
message (important: git sees this as a fast forward!!), and then apply
submaintainer trees on top. This results in no back merges, and it's
only cheating a little bit.

> It's not the end of the world for me to rebase, but I'd prefer not to thr=
ow
> away the hashes and the time the commits have spent in -next.
>
> FWIW, the two tags are:
>
>  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.8-rcN
>  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.8-rcN

Pulled (but not pushed), thanks.

Paolo


