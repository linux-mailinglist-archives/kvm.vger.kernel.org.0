Return-Path: <kvm+bounces-27693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E374898AA23
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 18:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 177741C20DC9
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 16:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E251194A5A;
	Mon, 30 Sep 2024 16:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="38S5a+iq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048AA193428
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 16:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727714593; cv=none; b=MemEL9s0j2zwOVuW9PMnWPFWCsJgvP/bAl9tTUT5I4mlCtPuCdShSReMCuutt8RhvPVXGENKSgwI4tMSHJp1aaMGdyd0ENQN3pNDF6nRbxbenAU/PxzmF0tteyjwdF7HFjJ936p5Tl1xcrN71/1ZFhJsGKY1bsytqAUXLDdmvXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727714593; c=relaxed/simple;
	bh=uUp9+2GHqfEUSAMvqRv63yi6FVWRqzTwW3Zi59LbyJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tm/VVOGmd5zt8u2fdZIWxKyAAmz5FWaKjbBFpDOzcYra1wUP0iewfDAm/fkrbeSP+riquqt41ifocBTOCRfZj8k5Am1fU4rVy79tHQEfa7hCzVMXcb89s97WVTne70qvRry7uqk6kU7SLm/3f6hQb/ljnfxag+AkQKjVgOauYw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=38S5a+iq; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5398c2e4118so207e87.0
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 09:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727714590; x=1728319390; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uUp9+2GHqfEUSAMvqRv63yi6FVWRqzTwW3Zi59LbyJ4=;
        b=38S5a+iqmAhY3beiLayh2cF5MEoLmQuV/Wkx7ldxPZ4UzFZrCs5cgBBqfe7M3ifqt4
         iUturQymiTfkHza59Gnvx037ogNKDgr8RhqspoMHZYiNP7rqIzNkIcpJGXBpWK75+PLN
         +AiTlVda0g191bktQf12KtLQQMMGxK6HDql3WyFUV6R80UitcIEvW8zEgM6KtihuPB4C
         gHaZIFgLY69HIW/nwE260r2Cx74MLZqdXetCZKuqDgSzMuEBWiC7r2Mu8Vr2QjZ89e+c
         9K7bUn0THQp9vNKugyWQdiKl2MkR6fqMFp2tF3iT7onssOCWt7yIgnEg6DdmfNLAt+pD
         WkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727714590; x=1728319390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uUp9+2GHqfEUSAMvqRv63yi6FVWRqzTwW3Zi59LbyJ4=;
        b=IIVRQq28NUexqnVDJaZPGJZ3TUpo1Y5b50/4JV+3kitkS2wOQeJiXNW8pBprljzZvD
         sT5B7ZIRo+JgpClcTpWqHHL+Ux9qx784YeNdKg/+Avz8iukJsC8XphW3CeNvP1nwC28W
         HmgIveq8VPUG9oENdi6rizCFsC7uJdzTmJ8CMDORHQTDL+D0iz67sk66SsgFMI+RMj6s
         MEf9EYQl99NbvP8hegLBj55FJ8lwQKvF54LxO7B39nP2lP4mHeRVK+8GvLmzcYAGRsB4
         6nf1x+0ryY2REW3V9xsv7rENipZrwkL9c2xmCFoF0J4hrrvGosCWAzRAc4g1bZPSLfyU
         ADYA==
X-Forwarded-Encrypted: i=1; AJvYcCVsQvtUGPhQDNZacERIEigjmqdqnDiQxSnNIWOwCrdufyzJdn/1G5i0VXJS8rsmN4fm4I0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnjHGvOE9tUrPI50VtKLFXPu4O/zh6lGB6SKJdzgwjuKL1c4ts
	SUYG0eZ8Yi5yiqj5nMU3Tn550WEYbLYikAmOiLSQySO18NVfFdpJdFXPtsyWf/gXRFcowv7cAPU
	6CSjgCjXIB1IW7ZJuuzGREUzU90JFx7GnGebG
X-Google-Smtp-Source: AGHT+IGzc8wIwInlPNzGa8R/Zmet+hDPx/pHmTsXRH1wqa/wRLB4YiXpJnP5Z6BmFj40PYdhxAPJh5Q49h18p5B3R00=
X-Received: by 2002:a05:6512:a95:b0:530:ae18:810e with SMTP id
 2adb3069b0e04-5399a0addcfmr73246e87.5.1727714589838; Mon, 30 Sep 2024
 09:43:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913214316.1945951-1-vipinsh@google.com> <ZvSiCYZv5Gban0VW@google.com>
In-Reply-To: <ZvSiCYZv5Gban0VW@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Mon, 30 Sep 2024 09:42:32 -0700
Message-ID: <CAHVum0dpHrW3cDX9FCcd5wTsetFxzWP0B6WL3uXnqmwrVJnGcw@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Repurpose MMU shrinker into page cache shrinker
To: David Matlack <dmatlack@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, zhi.wang.linux@gmail.com, 
	weijiang.yang@intel.com, mizhang@google.com, liangchen.linux@gmail.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 4:51=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2024-09-13 02:43 PM, Vipin Sharma wrote:
> > This series is extracted out from the NUMA aware page table series[1].
> > MMU shrinker changes were in patches 1 to 9 in the old series.
>
> I'm curious how you tested this series. Would it be posisble to write a
> selftest to exercise KVM's shrinker interactions? I don't think it needs
> to be anything fancy to be useful (e.g. just run a VM, trigger lots of
> shrinking, and make sure nothing blows up).

My testing was dropping caches (echo 2 > /proc/sys/vm/drop_caches) in
background while running dirty_log_perf_test selftest multiple times.
I added printk in shrink_count() and shrink_scan() to make sure pages
are being reported and released.

I can write a test which can spawn a thread to drop caches and a VM
which touches all of its pages to generate page faults. Only downside
is it will not detect if KVM MMU shrinker is being invoked, counting
and freeing pages.

>
> There appears to be a debugfs interface which could be used to trigger
> shrinking from a selftest.
>
> https://docs.kernel.org/admin-guide/mm/shrinker_debugfs.html

This is interesting and it does what is needed to test KVM MMU
shrinker. However, this needs CONFIG_DEBUG_FS and
CONFIG_SHRINKER_DEBUG. I think using shrinker_debugfs will be better,
selftest can just skip if it cannot find shrinker_debugfs files. One
downside is that this test will not run if these configs are not
enabled.

Which one do you prefer? I am preferring shrinker_debugfs but
concerned about its dependency on those two configs, not sure if it is
okay to have this kind of dependency in a selftests.

