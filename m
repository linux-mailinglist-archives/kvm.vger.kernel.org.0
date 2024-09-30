Return-Path: <kvm+bounces-27694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B022298AA4B
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 18:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 634C2282D9E
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 16:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D8A1990A7;
	Mon, 30 Sep 2024 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X8qcnoAu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E453192D68
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727715072; cv=none; b=Wa2K7DM2jiITuyVdSLzwI2M8s4+HDtl7D1Ed+LzZBhuY/eZa2CljOgl1eU+PGbqT9gM2iWutenCiUIU5ljh/gJQY/Xq4sYxYZlWCoMJAbUvRWffJtXS/zMBlaTlT1VmU44U6ho/zDcuuO8OiIr8VthmvzaXYHksri28nbqpwQLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727715072; c=relaxed/simple;
	bh=Sj7JFYd945j6IHRijQpRLIAWRofqJPTr17Y9N8BVeEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=STTtXn2hNMUHG1QOVBWk4f4gnrYLQrE5uvqGJr6ZUTn++gUTmm3on5tJ+nnx5DE+Ww7n/Uv8Ndk8SKua8/OnpCX1aHRsvCX8ILAmyBEOJ++ccrcZcpPfU9BNIJPgy/0x/1dw/x3eSxBKW2aHiKmI+hmLMF+tnbBXW0c1JuWuPq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X8qcnoAu; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53988c54ec8so3430536e87.0
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 09:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727715069; x=1728319869; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sj7JFYd945j6IHRijQpRLIAWRofqJPTr17Y9N8BVeEA=;
        b=X8qcnoAuX08d+0XtO+3Jthqplc7lCKv4PI22oDmHB61WqbFLBE5GMjLCxjBqglt3Br
         Rtyi9WJsu/Iia5O4IGYdVXeiRGmml5UGwaL0y8eqiV69r2l/u90AbwVjuvZcFVpGZXAQ
         f6QWoYYJgaVF7qWtTpFC+hhZHf7h3PZZTIp7q34V2h1wKmZ530dg6seAv6qWArYtPbot
         P3uUnnr25ENMbimRfVKnjw9eM3RLlP0GLkqlY7FwWTmzBCJty7+GHPPSQRojRf9uBKi0
         h+CGUsbySgPnL9gnHdOfTKicnvzFrUgNufFJRBhf0xnKRXU2m4cs/dqrYXwt7LDxORPG
         ln2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727715069; x=1728319869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sj7JFYd945j6IHRijQpRLIAWRofqJPTr17Y9N8BVeEA=;
        b=G/YSymjgtretth6BDpg54VVIjTY8lUYErLJstJSwmr4Uc9ksLV3bbDb+id+0S875zg
         T8vN16NL5crXKFwfQKFXI/Ixh7BLscuxvVvAGLkiajLcTDEmIDHwmFFgzH8NnX1YGnle
         TSf4BB4lASTQEUTktOpvucbjn3KPzxrMO/as/qWI7jegSjk4Bw9NE+CIvORzKzVBg1JV
         ijrJkBxmuXXK8lhOgXU/dC+VnfeBix5bso3755yX0L+FnJ1NF/gEBymJuvbrpQgnbKn2
         6AChqWC+73lyc5g0ORCR9/J/FSLxqIsMZRt450KTZ9Cwnd1HvmcLGQF2gvUDYldl9eZG
         RM8w==
X-Forwarded-Encrypted: i=1; AJvYcCV0AZXC9m8zGS/bofjYPsb9/Ax6vBcx1lOA8BG1+JIPdOZLnOU88AWv8Bvp9XY1nHplRcA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY5nTCrNKKG8ro9QMovWsol8LIhdrRDyBF2vGZizZ3PIjpU0uX
	xU77Ndhok/ym7naFvlRAGt0r2sgZ4z/7ydBujN7kkzVIVWflxgNB5C+plyMwoMaN00YZIFQBTCQ
	0iygXfIgqKHAKkdJgVEL/Jox1j6zqLP1xTFfaBBzYZAFMDqKNnrs8
X-Google-Smtp-Source: AGHT+IGt9nS7r3XQNTCdU3DUtjAMuOjHQE8h8bN9HqFFWlLuCm3zXtWDU2M0+sBMpgx07rporX8sPdXigossegPag0c=
X-Received: by 2002:a05:6512:3e24:b0:539:8f68:e037 with SMTP id
 2adb3069b0e04-5398f68e09amr3293661e87.48.1727715068525; Mon, 30 Sep 2024
 09:51:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913214316.1945951-1-vipinsh@google.com> <ZvSiCYZv5Gban0VW@google.com>
 <CAHVum0dpHrW3cDX9FCcd5wTsetFxzWP0B6WL3uXnqmwrVJnGcw@mail.gmail.com>
In-Reply-To: <CAHVum0dpHrW3cDX9FCcd5wTsetFxzWP0B6WL3uXnqmwrVJnGcw@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 30 Sep 2024 09:50:40 -0700
Message-ID: <CALzav=dmv8U8O6cFnyXNbUeTDrLs5Wj-ufYHNxDEJ14UZqrL9A@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Repurpose MMU shrinker into page cache shrinker
To: Vipin Sharma <vipinsh@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, zhi.wang.linux@gmail.com, 
	weijiang.yang@intel.com, mizhang@google.com, liangchen.linux@gmail.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 9:43=E2=80=AFAM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> On Wed, Sep 25, 2024 at 4:51=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On 2024-09-13 02:43 PM, Vipin Sharma wrote:
> > > This series is extracted out from the NUMA aware page table series[1]=
.
> > > MMU shrinker changes were in patches 1 to 9 in the old series.
> >
> > I'm curious how you tested this series. Would it be posisble to write a
> > selftest to exercise KVM's shrinker interactions? I don't think it need=
s
> > to be anything fancy to be useful (e.g. just run a VM, trigger lots of
> > shrinking, and make sure nothing blows up).
>
> My testing was dropping caches (echo 2 > /proc/sys/vm/drop_caches) in
> background while running dirty_log_perf_test selftest multiple times.
> I added printk in shrink_count() and shrink_scan() to make sure pages
> are being reported and released.
>
> I can write a test which can spawn a thread to drop caches and a VM
> which touches all of its pages to generate page faults. Only downside
> is it will not detect if KVM MMU shrinker is being invoked, counting
> and freeing pages.
>
> >
> > There appears to be a debugfs interface which could be used to trigger
> > shrinking from a selftest.
> >
> > https://docs.kernel.org/admin-guide/mm/shrinker_debugfs.html
>
> This is interesting and it does what is needed to test KVM MMU
> shrinker. However, this needs CONFIG_DEBUG_FS and
> CONFIG_SHRINKER_DEBUG. I think using shrinker_debugfs will be better,
> selftest can just skip if it cannot find shrinker_debugfs files. One
> downside is that this test will not run if these configs are not
> enabled.
>
> Which one do you prefer? I am preferring shrinker_debugfs but
> concerned about its dependency on those two configs, not sure if it is
> okay to have this kind of dependency in a selftests.

Configs are there to be enabled. If shrinker_debugfs is the right way
to test this, I don't see any reason to shy away from using it.

