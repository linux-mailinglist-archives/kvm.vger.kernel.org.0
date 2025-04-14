Return-Path: <kvm+bounces-43280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73D89A88CFF
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 22:26:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 307683B3EEE
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 20:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131871DF759;
	Mon, 14 Apr 2025 20:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KRKKA9KT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840C1CEAB2
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 20:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744662369; cv=none; b=DGkY0FV9lfc9ZnFVJV9V2HjNjfC4y74P3EBLZBG1glpSG3eCnuXR20RGJTXhGDAbdZvpf8f8Fn+la4pj21yyKaG8L0Zu4vdb/TLAubL31FdeeRf2FXBlyKShBIeiql8NDEgx+ZKM70K6Z6rxzJroURwuD+eEbqkcO5h2zZW11YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744662369; c=relaxed/simple;
	bh=e8RuQjvX7EC8rJIFazxow+KpM5ax/UsWJUoMj3kPKTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z8qj1pd+i0od5mdm8/38+8bicMpqjvt3uW99rFTkAPTJgqjvLixlO2VJV6/OnxwAouH4v4Lja8P9kDI0g2oydIarU3zrwPUonpipvM4Kbak8VKaH7QEw0YAD7sb5qgyIY5BMKye3oekztMBcYvrFALSL0zaHBOOILalgPy7CXlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KRKKA9KT; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e455bf1f4d3so3601063276.2
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 13:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744662366; x=1745267166; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8RuQjvX7EC8rJIFazxow+KpM5ax/UsWJUoMj3kPKTI=;
        b=KRKKA9KTJLwDOv/j85iqeAteHbnRRThNrFG1v9dr9pIvRgMvzICKCPFyrZO2Y3oUbR
         tutVDXS0X/8k1V/4dWxHPiqLZFSVfQGhXEAZZPdhCBUkYHOVKkeK5iwBWHcAYPZXLikA
         CECW1DqWpq6jcDUMFF4GbmIZB+PxBz32qmragIPXFTGnZR3L2FlhKqTPwjIPAYBinGpo
         HaxzZKEF/kHKeMFxWhs+woabXNqxnUrmYd7pe7DE20q/ldq+337zRrgGacCLMNKRVk9a
         EnHhVWJeMir1zo60IwygqgZrRKwHeHf56sqyKN2fxMcM28nLHSQKQW22TnzpAHrH5PI9
         8PkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744662366; x=1745267166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8RuQjvX7EC8rJIFazxow+KpM5ax/UsWJUoMj3kPKTI=;
        b=Xj6Vp4tcEcvPfpjG9+GlS6ZDuQuDtwn4EwWwQYcE6SAwkyg3w6aXc1zaeH0nk3bWaA
         kNXRe9byDxvOGAlV5uGDWmhMKjzCrAv40jVQG8D6R4RVQ1sZ4TPyqNHXrV9Mzt+/4fCL
         xjVTpwMk0b8/kAdemZDsQAIR9SY522l3arMkLcTb9aML4rB6cxV3DcFytEuIdtdyZp0F
         NrzzbKRpfAqoCLHlv8J4KmcRLsKDFPRN4ovzWTPHBjMGIeXX78kHogkZwS4euJnwi8ru
         334jl/GO952MfbqovLH2I/46atb+xNNUdWikXr9MtK0bagNZDWcYoMNmeh5OwAdoJLjo
         6Ywg==
X-Forwarded-Encrypted: i=1; AJvYcCUssBaH0Z1ykuvdpW6My8Vdsck/Liqf7RkohbjDwkUHGYkwRXs8szbTpw45wG2w1+F6nh0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDs704Ew8F8KJ5xifpNmkVc+WdbcfUQVyox9QQay7nwEFaNAT0
	VZojkmaC7flCMNmJhLihDbYMQq7sJAQ/uEPUJ0dGU/vNiXMpsrMC69iOE8kcFLkX8RqSWMiGfCf
	p8mZahTmX3iLpbn2dCJdk31tRGr96iv4MH9+Dp4QKQyiGEQ6bI2yG
X-Gm-Gg: ASbGncu8jkoVwQcKWGx2NBvi2IJPhp3v8dR9r7Pbe+rENcstX/DW3cyZ38Z5MdcDicN
	WjVstOYGpniQh7WipYtpYcg49SeCLHWGmdgDxWWwUbVBsfRKcJfpLFOkNmzoiIKjzh1ZihgY/Cc
	CMNJLqD6/bi+Qvr7lKQw8YrGP6zzXqURxjtljd553whti/iviM22v+z8nsCjCnIg==
X-Google-Smtp-Source: AGHT+IHim7LKMVAssyTOnOfMgHoryUchjWHO0ARJ2hg5JmtdO8AhbqOEh3YOdPUF47H4HZYQwddbnu499M0vFJgq5eU=
X-Received: by 2002:a05:6902:4912:b0:e58:a25c:2787 with SMTP id
 3f1490d57ef6-e704df84608mr21722964276.38.1744662366434; Mon, 14 Apr 2025
 13:26:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414200929.3098202-1-jthoughton@google.com> <20250414200929.3098202-4-jthoughton@google.com>
In-Reply-To: <20250414200929.3098202-4-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 14 Apr 2025 13:25:30 -0700
X-Gm-Features: ATxdqUGwhQ01tB21e31AgRtLSVaaR6Jizfi-T6B2oRJ8KFk1W8QQrgJ2NgNsjhU
Message-ID: <CADrL8HWfF84VLmrVkzXTdwi-xxbUTPRUBDx1URZOsYv1DuB1-Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] cgroup: selftests: Move cgroup_util into its own library
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Yu Zhao <yuzhao@google.com>, 
	David Matlack <dmatlack@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2025 at 1:09=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> KVM selftests will soon need to use some of the cgroup creation and
> deletion functionality from cgroup_util.
>
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>

Tejun had provided his Acked-by[1] and I somehow forgot to include it.
(I know I should just use b4 and redownload the series with
everything...) Sorry about that.

[1]: https://lore.kernel.org/kvm/Z-sQ76PG14ai9jC0@slm.duckdns.org/

