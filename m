Return-Path: <kvm+bounces-42137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 974C0A73E08
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:27:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DE1F17949D
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 18:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69FB21A928;
	Thu, 27 Mar 2025 18:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ygaDaSyp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99216128816
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 18:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743100056; cv=none; b=B9q2ZvSxPRo+WVtMQ75nGpDX3lbC/LMo0a9DK2E9qzAa9WX7Fu5PuamCZCJlEC8Yqzbjm4UsPAwCMY98eO20i0erUXXuI5/orYHBHykfdDXHLT5EYVE77IwarzuE8NW2f3Y/U/kuPSTxce8KG1T9OtYZMYh5fCXr8aL73/TkRzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743100056; c=relaxed/simple;
	bh=H4SQq9c3BG+BGZJq2PWQ9+OGqdEw1bMbKxYbAWHmA4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cyk8qxuGRmcxZgHrGHHf3m+9y0XoER9cMJVyg4ty+S4re4CWn7H9P/fBAkf5mwKevKg/AOiCQ2G2VgWd0DJ43joZ1/BIKpS4GqTgDG2vNrpyWR2LJbaX0QzfxJLZe50FmutPLNcwMbh9wRpKEpbnvMsaW05HadHNRpFRxR9qdCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ygaDaSyp; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6fead317874so11417717b3.0
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 11:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743100053; x=1743704853; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1T0t+yj48XDj+5N7Hw5aN1g6zWRep2KUB4u7M34BaQ=;
        b=ygaDaSyphWrgV9ZgaBaidTyOsALtv0f19PaseZzJpqNOhTNCae0WMunumzlZLFNN+4
         agvcaf4ECu7QYgIVcow3d4t3+mbe7KfdEG0cm64qJuXmHmxzbE0yM1uodNa26UEMukN6
         d57UPCcWAmUg8uO1wxpqOWP/XT3K9Bb4qj1OcGV7C4l/bSET9G6MX7nX9G8HFraubn4m
         g2TL9jCYWyh3IA+8TJcw3iIsdWvTIHtq/vAM8OsFU4LMCpqSPnUZpe7EC2pQpRV/MjZj
         ZGh08tdAR6OwSuQH3WU/N5UhRfb767liMWztu/cCX63rCoAxGS6NTxZ3WJ+tPTrSUhaT
         Fayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743100053; x=1743704853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1T0t+yj48XDj+5N7Hw5aN1g6zWRep2KUB4u7M34BaQ=;
        b=Zm00uZyCLNvl8Km0u4nbwnUKigZhcc8g+VU7JDF/a8/L0WQtA25n1CwKI0wm6I7uis
         R5yxu8ZVXBHDrYTXaP9fBxaXn5AmBhCEnXisAaYO/jdpG8zkAWXqNM9JfiyUfSArrneQ
         MDEctCrAJ311Ts2yu65xdzZqRNfnbmchMdgiSy90ZFuzUMN0y07kXl1LEjXsobfCtzAC
         3N0ugjBF+PUNPh66L3Wvw/DyXzzaIDfunZzrwOfcmG/XVeaalrIXCeLl1VknLeKNHmtf
         eUtf0X1cOQlSjtH2+p9/ixLWgUF0PuShBwz0eCd8iQy0rMh1VWil4BUKz6ZSBi6Ebmv9
         u+PA==
X-Forwarded-Encrypted: i=1; AJvYcCWDfhS/AdOC1QOpswPHIHAwopZN36diEE6N23C6i/HxYnCEpGSxVIXq+ffe0MFA0+TWxaE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvDaxMRKbq53KbOkXlMV7f1E7HzaJkukaEZyqP2A2oSGwe1HH2
	1gv65nRsLkU4bzjKvXSeAmOKG//hGt7DHibFy5abLa7fYqcUgT9cPiSfX7wzwA5tAclmZ4HeFJZ
	a0T+5WWA/vVWlpeT0BRTy+jdmN/RSFKPki5w6
X-Gm-Gg: ASbGnctlJIu1TnHWIev5xlEaB5MqyDJDffSGPJwPaUqjuB+q8xXaKDT45IW3qwSaHvM
	lC3MRAbj994P8XKj5Kvv1RPJBIU35k9zrAghYmydvOwr82OtKJShQLU6neEnsDt6NP1VvVy7UCW
	9eDK+0zucadI5rOw9A6/6sOkIEfj8NWGiIbj77nyBtdp6kSUqIldjAmyPw
X-Google-Smtp-Source: AGHT+IF9r5WJAzdfDcQntbLZwhD5EGz+o+pnNk64HYaUbkhC9xRE3GDrX1KAucYtv+JfqlvbFLsjF4WRjfPT9DtRnoM=
X-Received: by 2002:a05:690c:6f92:b0:6f7:55a2:4cf5 with SMTP id
 00721157ae682-70224efddf4mr69462527b3.2.1743100053279; Thu, 27 Mar 2025
 11:27:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250327012350.1135621-1-jthoughton@google.com> <20250327012350.1135621-6-jthoughton@google.com>
In-Reply-To: <20250327012350.1135621-6-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 27 Mar 2025 11:26:57 -0700
X-Gm-Features: AQ5f1Jqui55DD7gnN51tyeqg8zK6HJAcKnkL3KKDypvtSprHeM9DbaOlKdOqBZo
Message-ID: <CADrL8HXEb0r8sRie_q48ry8r30LpBZqAs4a1iN8N9BZ09FZzUw@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: selftests: access_tracking_perf_test: Use MGLRU
 for access tracking
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yu Zhao <yuzhao@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2025 at 6:25=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/to=
ols/testing/selftests/kvm/access_tracking_perf_test.c
> index 0e594883ec13e..1c8e43e18e4c6 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -318,6 +415,15 @@ static void run_test(enum vm_guest_mode mode, void *=
arg)
>         pr_info("\n");
>         access_memory(vm, nr_vcpus, ACCESS_WRITE, "Populating memory");
>
> +       if (use_lru_gen) {
> +               struct memcg_stats stats;
> +
> +               /* Do an initial page table scan */

This comment is wrong, sorry. I'll just drop it.

I initially had a lru_gen_do_aging() here to verify that everything
was tracked in the lru_gen debugfs, but everything is already tracked
anyway. Doing an aging pass here means that the "control" write after
this is writing to idle memory, so it ceases to be a control.

> +               lru_gen_read_memcg_stats(&stats, TEST_MEMCG_NAME);
> +               TEST_ASSERT(lru_gen_sum_memcg_stats(&stats) >=3D total_pa=
ges,
> +                           "Not all pages accounted for. Was the memcg s=
et up correctly?");
> +       }
> +
>         /* As a control, read and write to the populated memory first. */
>         access_memory(vm, nr_vcpus, ACCESS_WRITE, "Writing to populated m=
emory");
>         access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from populated =
memory");

