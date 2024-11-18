Return-Path: <kvm+bounces-32018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B1A99D1488
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 16:36:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC3511F232AB
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 15:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1C11C1F07;
	Mon, 18 Nov 2024 15:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4AggMtFd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588D91AAE33
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731944069; cv=none; b=hg6i9qU4pmj/TO8x72fIH9xfnOGv2E5x4eu6NKytpEzOGcoR0nis/O6SPHJvh6qcI62pBXUP1EwLZqO+QXP4OmhM3t4B2v8eaAFeOMhLOFN6E4+ONsQDekLMEmMzNuKLm2RqCHjZXknCpfdffz0359BydkY6nJ0FotcYDyNKWxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731944069; c=relaxed/simple;
	bh=IzZ8vrLDeheWfdUYDbyaJVPjAgEM3gmJvyf15rXhHCI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jxmrBXm6+DKH2QD7MmFo9Eb+vuER06tWjSMc8T9O9ZScx2kiAXHHOtkKNyxDgIi08j0EPdCpFaKNfsiPKo1Q+E9MsmdwWNfTp1EZzWupeXlN10m65PfcfGNg2q6ZeJzEy685j+c4Ypqx6b1zVGHXAgsB82gLYUYv+siAYIwOvfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4AggMtFd; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6eae6aba72fso36073777b3.2
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 07:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731944066; x=1732548866; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a7K6U0T/XQ8gx+tHZUWr2faguGniMnPfsq2eZoyEnrU=;
        b=4AggMtFdv+qaXVV9v8HNVQaB5u1tFZxwWz0nyCrvOrK4qgWl/5Rj3r7o3AVy0XhejV
         9P7Ebs1tEZmtB/moDX49rAi23AiLC48T2+A1MuhmEVamzlaAxlwn8g9rEqAf9rUZ0sxX
         r30BUIJBLQNuaB3IYyuNQmBdvzl5FWUId/xtR1Ly9whJACbjlxECABtCDXryU3CdNWlh
         Hp7dCUmZuVEGrDGfM9hgKBssvO7vU+hNnVjk3av3EiN47GTGn/jddnhwlXiZTJsNXYnm
         EnoqF+u+vL+tChtpoHk0yYUn7NUPs+CpSwADYwFviEvneXQulB77RVyEXW61zWn3yu4w
         PmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731944066; x=1732548866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a7K6U0T/XQ8gx+tHZUWr2faguGniMnPfsq2eZoyEnrU=;
        b=ECs23riAfP8GXe7gOgkyn0KPpK+oq3jUIHFRvZL/HN/kYawqcEnLnu4xDulE5dXAIk
         A0R6+pS9MrxO7Q/OluFLyYiKfbHQ/WNa7Aq0PJR1LDpMdLWQkvZGgOg+WMLyz+V8IewW
         5DDYmRx9nzf1sD41FZ86Al+oB8rmSTxCi/anh6lQZvACEmwcuUM00T/kh7nkZa+GL1Mo
         /Ar5iIZLZfsdEfF4qQUCJokJd3f90Ii/LZHm0DaMxvRuCosFrHHcP7R5Y5ixikVDBErc
         BjZl8r7i9rR2MO0cUHAoNLKzkQgMYI/FH20l1tXB6cQfuAwyG6gfbBjGJ/VKwmWpAKxD
         jfdg==
X-Forwarded-Encrypted: i=1; AJvYcCWSxaPwiMoWQZQZ0BGUQEQVpC4y7/JM/dch4L9v7YYSeHhnI4mlAcTyoXopoh4d7SX6sWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzhloG9PZscCNpsBAgd+f1qrp6t53kePxXhf8zIttFB9nXHTer
	UW+I6Oj2XrY6aFVSiZG0JEAR0rwvl3jMOemW5p+EkqdaXbqbITq94lA32ft+OQ6omDf18W4YdRN
	PcQ==
X-Google-Smtp-Source: AGHT+IG53BeA5Fnt7TchljlmDo3D4tY72ogWA2od7hmQmMsBLO0ga3hzcJvpmUfayiR1at+ew1OgbLok9Wc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:424a:b0:6e2:1ab6:699a with SMTP id
 00721157ae682-6ee55ccc2e3mr1066877b3.7.1731944066382; Mon, 18 Nov 2024
 07:34:26 -0800 (PST)
Date: Mon, 18 Nov 2024 07:34:24 -0800
In-Reply-To: <20241118031502.2102-1-bajing@cmss.chinamobile.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241118031502.2102-1-bajing@cmss.chinamobile.com>
Message-ID: <ZztRPUTWm5K1bsgJ@google.com>
Subject: Re: [PATCH] kvm: hardware_disable_test: remove unused macro
From: Sean Christopherson <seanjc@google.com>
To: Ba Jing <bajing@cmss.chinamobile.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 18, 2024, Ba Jing wrote:
> After reviewing the code, it was found that the macro GUEST_CODE_PIO_PORT
> is never referenced in the code. Just remove it.
> 
> Signed-off-by: Ba Jing <bajing@cmss.chinamobile.com>
> ---
>  tools/testing/selftests/kvm/hardware_disable_test.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
> index bce73bcb973c..94bd6ed24cf3 100644
> --- a/tools/testing/selftests/kvm/hardware_disable_test.c
> +++ b/tools/testing/selftests/kvm/hardware_disable_test.c
> @@ -20,7 +20,6 @@
>  #define SLEEPING_THREAD_NUM (1 << 4)
>  #define FORK_NUM (1ULL << 9)
>  #define DELAY_US_MAX 2000
> -#define GUEST_CODE_PIO_PORT 4

You already sent this patch, albeit with a slightly different shortlog+changelog,
and said patch was applied.

https://lore.kernel.org/all/20240903043135.11087-1-bajing@cmss.chinamobile.com

