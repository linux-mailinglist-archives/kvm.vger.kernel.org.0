Return-Path: <kvm+bounces-14153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A328A0220
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 23:30:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34488B259F1
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 21:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3451836CB;
	Wed, 10 Apr 2024 21:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JFp1xYoQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAB6181D19;
	Wed, 10 Apr 2024 21:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712784622; cv=none; b=lTLgg42KzFAluHZid+Rnm+BAuLydkteZUiLtOgWEsgNkc7RWHvBmYWvQxp0e9HqS7PEvvFOv03XVjJcP5EhYd5wliLoQ9l3H+f4/XukV21+I0unlW1ANLeOfedgqNb33YiXvTZeosuz9fEDGsXjHoscuixJ6SqX2Z0WvSut/Dtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712784622; c=relaxed/simple;
	bh=14ZzdB+5ZJ89hfQO2P/iVaITshCuwOTD8j6Uc+CSv9s=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=RVKIiybVTk8YzfeObd1QnAs+wgJbs2i4F7jdHJK59qK6ZQOu+vlq6iPQjlcyUDhVpxNj2WqOY6mgZ48+FQ/QYL7HnTw5GVE1+m+AsljUvDIsV+E5Oj/hLSNdHsuEw59IobOB/5q+4m3sA5L6mS0L2MIwWPv54WGRomc59NV1QMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JFp1xYoQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D19C433F1;
	Wed, 10 Apr 2024 21:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712784622;
	bh=14ZzdB+5ZJ89hfQO2P/iVaITshCuwOTD8j6Uc+CSv9s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JFp1xYoQBbQ39g+uTbt4JLn3SBzgRbjqJ31eyFQf9/KYKQPg93LaIEw4AqO9qBCBd
	 IaZLQJEvG3vUqIKZSLW207ouLZUCv3OzXKGTpgCVOAXkPkkakvzfiiajTuIeyu76gy
	 L/McdS+iJHvTrIxiRy4HiJClm2JWS4c9rS0J95ME=
Date: Wed, 10 Apr 2024 14:30:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Thomas
 Bogendoerfer <tsbogend@alpha.franken.de>, Nicholas Piggin
 <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, Atish Patra
 <atishp@atishpatra.org>, Sean Christopherson <seanjc@google.com>, David
 Hildenbrand <david@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM, mm: remove the .change_pte() MMU notifier and
 set_pte_at_notify()
Message-Id: <20240410143020.420cafd47bf8af257b2e647a@linux-foundation.org>
In-Reply-To: <20240405115815.3226315-1-pbonzini@redhat.com>
References: <20240405115815.3226315-1-pbonzini@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  5 Apr 2024 07:58:11 -0400 Paolo Bonzini <pbonzini@redhat.com> wrote:

> Please review!  Also feel free to take the KVM patches through the mm
> tree, as I don't expect any conflicts.

It's mainly a KVM thing and the MM changes are small and simple.
I'd say that the KVM tree would be a better home?

