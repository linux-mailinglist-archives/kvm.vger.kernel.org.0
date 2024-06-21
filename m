Return-Path: <kvm+bounces-20240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DF659124A6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D77F5288852
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411F5174ED2;
	Fri, 21 Jun 2024 12:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OlF4+vvR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73F0172761
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 12:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718971372; cv=none; b=l71yzAAqI46OXTlGAcQwmyVQ1ZPVDI7ql6x7BI0qGmmqmZ4apdz+PgJui/xodurJK8oWmL7ApC2nvCcIhmLea1bjKOlRpYjEKxZXMoBy2Ea/DFDL40DRZ0QmyJmSZC98oe5il/8xYlWoZRGMd5vkLJ8pi4DDfHDlA7+dLA3bXZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718971372; c=relaxed/simple;
	bh=YrVPACoGs6F9RM7iXfCYIgQQgvdRy4TLIXLBJDf39bw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CV2U+oz6xY2V9hH7DJMhm5VuvcagqgqfKSR9X01DrFeM+gbDI7YbOPdOzZ0it1Sw2mWGKHFZtOJ+UO5aZ6oMPnYHa5V0ewRI5KE+RwYhExbDkouHas7o9sJJ5ym/P3oNDHmEwuy9YW3KOTqBtL5xEm5ApG88QjT6dyAzE9irZX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OlF4+vvR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718971369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RaC3XUj/H3n8k9zuBXjy56bPOXJzKVVYdQ6M+wMxpXE=;
	b=OlF4+vvRgmNGspAOzt3ZN13GIckDJtCeO6L5m0mjnChVdFrQ+BiynP3Pj+PRIQAS5q/9uL
	TCEu+c/R4nWxQ3z3kDNJwVnwqt7H5K695mbX0lF8IYwIVVVOeHJZK9XfBwLwBoVFnbUVFL
	eR/PeZHU2Id7BMSqWTxaMLXiy5YUEwQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-PmvcINFDPLixTn1rGHLMEQ-1; Fri, 21 Jun 2024 08:02:48 -0400
X-MC-Unique: PmvcINFDPLixTn1rGHLMEQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-36250205842so1583126f8f.1
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 05:02:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718971367; x=1719576167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RaC3XUj/H3n8k9zuBXjy56bPOXJzKVVYdQ6M+wMxpXE=;
        b=dbAlOWN6VyjOSrfB7PKhdgEpvxmL2nDNqPPPBmXyayrmYREzeLvWbXx7Qkou5iubBB
         IAG7Qk2cW+R0Wq9/eKWz4cuQSqrd6/dnIlCGPpSvaYDoQBeJtxz6FfChkunOGsBtEECZ
         8KN2Wb5WlVQ/2z6ISXguh8Pf8FxoOph1PDYj7Y5iItDQbKg6wFI0qP4We9fKVYsQb18w
         9Mxda6aC0CEFydI55oVV1XsJQGGhT3F/Turfw+AhRvFUXA+jiSyF8g24Hq4/DQPDXcgi
         gPvKfoX9PVrbaTID/qrI1cKbGHVC9QIdBbQs6ED/Zps1RpxmD2wdzUQ5JKl5wT8IYg8m
         2ajA==
X-Gm-Message-State: AOJu0Yy+3H8K+gpjPZqeRQMoGaL0HotiUky9jg6d5H2j3qdlgBQwYryT
	zWzCWmi/gGwvxKcgflwpwKNPG+p5V8GGwZRU5jmNR/URyz1QswFChrwIbYlUwvQDob15/6yMU5t
	k8HPcr81fj4OYJ5QKRmJH8q7gPnby3PDPV5tCkMMNmgwDq9KhFpl9CCHsaSNhnT7LVfhKJU28mi
	o5slrYWoOd/4ZDJvGodGWhMMz8
X-Received: by 2002:a5d:45cf:0:b0:364:8f54:e0ec with SMTP id ffacd0b85a97d-3648f54e17dmr4437222f8f.19.1718971367412;
        Fri, 21 Jun 2024 05:02:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7Uy0v4KWO0svAsTDFJlHJfB0t0EciGHY8TEYjVilsP8uRQyyaac8NBovUn5NOt8GET7g2E70ZfYL6B1us2tk=
X-Received: by 2002:a5d:45cf:0:b0:364:8f54:e0ec with SMTP id
 ffacd0b85a97d-3648f54e17dmr4437200f8f.19.1718971367031; Fri, 21 Jun 2024
 05:02:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240620230937.2214992-1-seanjc@google.com>
In-Reply-To: <20240620230937.2214992-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 21 Jun 2024 14:02:35 +0200
Message-ID: <CABgObfYODQ2v5Jvmau==MCzo_rovarLpyz=UFPAo=_+APuvDKA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: Fixes for 6.10-rcN
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 1:09=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Two selftests fixes and two KVM fixes for 6.10.  Only the kvm_vcpu_on_spi=
n()
> fix is tagged for stable@.  I deliberately didn't tag the mmu_notifier is=
sue
> for stable@ as I'm 99.9% certain it can't actually cause problems (other =
than
> making UBSAN sad).
>
> Sorry for the late-in-the-week request, I have a feeling I missed your wi=
ndow
> where you're working on stuff for this week's KVM pull request.  :-/

Nope, I read that you were going to send something.

Pulled, thanks.

Paolo

> The following changes since commit c3f38fa61af77b49866b006939479069cd4511=
73:
>
>   Linux 6.10-rc2 (2024-06-02 15:44:56 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.10-rcN
>
> for you to fetch changes up to c3f3edf73a8f854f8766a69d2734198a58762e33:
>
>   KVM: Stop processing *all* memslots when "null" mmu_notifier handler is=
 found (2024-06-18 08:51:03 -0700)
>
> ----------------------------------------------------------------
> KVM fixes for 6.10
>
>  - Fix a "shift too big" goof in the KVM_SEV_INIT2 selftest.
>
>  - Compute the max mappable gfn for KVM selftests on x86 using GuestMaxPh=
yAddr
>    from KVM's supported CPUID (if it's available).
>
>  - Fix a race in kvm_vcpu_on_spin() by ensuring loads and stores are atom=
ic.
>
>  - Fix technically benign bug in __kvm_handle_hva_range() where KVM consu=
mes
>    the return from a void-returning function as if it were a boolean.
>
> ----------------------------------------------------------------
> Babu Moger (1):
>       KVM: Stop processing *all* memslots when "null" mmu_notifier handle=
r is found
>
> Breno Leitao (1):
>       KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()
>
> Colin Ian King (1):
>       KVM: selftests: Fix shift of 32 bit unsigned int more than 32 bits
>
> Tao Su (1):
>       KVM: selftests: x86: Prioritize getting max_gfn from GuestPhysBits
>
>  tools/testing/selftests/kvm/include/x86_64/processor.h |  1 +
>  tools/testing/selftests/kvm/lib/x86_64/processor.c     | 15 ++++++++++++=
+--
>  tools/testing/selftests/kvm/x86_64/sev_init2_tests.c   |  4 ++--
>  virt/kvm/kvm_main.c                                    |  8 +++++---
>  4 files changed, 21 insertions(+), 7 deletions(-)
>


