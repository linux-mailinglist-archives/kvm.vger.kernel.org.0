Return-Path: <kvm+bounces-10564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA5286D790
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 00:13:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F1A6B21ECE
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 23:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3D26D528;
	Thu, 29 Feb 2024 23:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ThlMwWWL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFA41DFCF
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 23:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709248373; cv=none; b=spp9MD4ofe2mQ7mPKc//vwrmC1R2oelnhJs3eZqasMRb/RF/F0ccCM9wBIE/O1IqaTWUUlE0smq63TdhHwbnF9fG0nY6ur4Z+OQrXlQJ6YfHsJt1cp7oytJp0lU2SQj6iEgyKBUEkdCtcDO2TsFA3atTDFLZsWSSM5eACqzyLBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709248373; c=relaxed/simple;
	bh=zdxPd8dyQ1ZY0YzppH0DB9bu/rDZym4gvhH+TFmDv7M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O6wiU2SBFmOA6JP4bglkV5VXmGhQQYjw/G3xrwDjeLkErKFpU2nPKmvW1YeLj1uO6Ezx8mquTVGQRNK2nfWWbyYW+Mzmr7Em1oSga2mzAFgdeNcSAqsqt7fbutXSFdYsZhhgi7SM/Fqz0rRTvRUDeazwPFMRPLQCEtUaRhC1N2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ThlMwWWL; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so2222230276.3
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 15:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709248371; x=1709853171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PLOzB45jjWM/AB8EVwjpG+k2OUVhgoW2eKlxq/9jk60=;
        b=ThlMwWWLoy4iR/59Y5CprZyxl/bEfXRcU+rpIJGYtQwMcfhjeT9zGJ1/f99RInaOqW
         TCq6Xciv2+QXdEw3iCsRwylxm/UlTDkYqpfaKyc52eE9IcRUbdaQbNEZBvVwkcjFPoWw
         tMrb8tWxeRPll4c+pPhyoLHnngHMtMTmVheqYAC2SuZ0ZURswYeR8zj6g+s9JxhFlCoH
         ZYKvOMmWqFWFJ+PRHdk3mwrHX7U4S9/qEgA1TEeMpm8AgCrC4U/KjEmMpi1rTWJHbv1a
         UpN8eRZUP5OMyF3uWHrwG7bh/s5TcqGy0p2oiS/qoscC4e0bmaE/NC+KGfQq2Gc2mQAq
         IQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709248371; x=1709853171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PLOzB45jjWM/AB8EVwjpG+k2OUVhgoW2eKlxq/9jk60=;
        b=eNCIjEdMh7bTGCZANoZLc60341hOmC/C/mVN0cPm9M3PbGc5StgZ5FrOk3EPoV37VJ
         SgFvUWKvcQVLU28vpLmJ8g8IU8IMH3sWqi3uXb8GlWTqOxUtWHkbys/iVWjYXEFcfxVz
         9GTz5T1nQNOCSDh77W7bdnnamaxQ15xSVztqlumbzXK/A81NQuucXC1shSNQHxtG+3u/
         TwtnaXieJA9dPJ6Ifu97O4IaAh0Dm1vY0GJu02uF/uNc06t3tLWw77CwMc+8j5+jFSUe
         zllmBkbZ54dWqnU9lduFVvmZiv6xfZeK61KessMpWpjsA7SLw8joK2JVO8RnzfdVh/qW
         VjVA==
X-Gm-Message-State: AOJu0YzNMTlOnEfMAIz6TAET+Xl2+oL+rL6PjPAT2lKNdTBLgb+Sv9fw
	JOShajEmWjW3HE4NLGCG5VnQAv104ohCN07wKUa1zL0uWOwDMFaaUVa7ww8nHha+iXUCeq+25jA
	TfA==
X-Google-Smtp-Source: AGHT+IEhgP6y8T6cjljxlZS1XKjSKVttHQMFr+J0SH8K8Y1alhnLGKm9EwccOsB8I38uwFrCz8Fcqm94iY0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b220:0:b0:dc7:6f13:61d9 with SMTP id
 i32-20020a25b220000000b00dc76f1361d9mr168088ybj.4.1709248371264; Thu, 29 Feb
 2024 15:12:51 -0800 (PST)
Date: Thu, 29 Feb 2024 15:12:49 -0800
In-Reply-To: <20240227115648.3104-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227115648.3104-1-dwmw2@infradead.org>
Message-ID: <ZeEPcYL0pc0zJQKZ@google.com>
Subject: Re: [PATCH v2 0/8] KVM: x86/xen updates
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, David Woodhouse wrote:
> David Woodhouse (6):
>       KVM: x86/xen: improve accuracy of Xen timers
>       KVM: x86/xen: inject vCPU upcall vector when local APIC is enabled
>       KVM: x86/xen: remove WARN_ON_ONCE() with false positives in evtchn delivery
>       KVM: pfncache: simplify locking and make more self-contained
>       KVM: x86/xen: fix recursive deadlock in timer injection
>       KVM: pfncache: clean up rwlock abuse
> 
> Paul Durrant (2):
>       KVM: x86/xen: split up kvm_xen_set_evtchn_fast()
>       KVM: x86/xen: avoid blocking in hardirq context in kvm_xen_set_evtchn_fast()
> 
>  arch/x86/kvm/lapic.c |   5 +-
>  arch/x86/kvm/x86.c   |  61 +++++++++-
>  arch/x86/kvm/x86.h   |   1 +
>  arch/x86/kvm/xen.c   | 327 +++++++++++++++++++++++++++++++++------------------
>  arch/x86/kvm/xen.h   |  18 +++
>  virt/kvm/pfncache.c  | 216 +++++++++++++++++-----------------
>  6 files changed, 403 insertions(+), 225 deletions(-)

FYI, I'm planning on grabbing at least the first 3 for 6.9, but I'm off tomorrow
and don't want to risk having to fix breakage in -next, so it won't happen until
next week.

I might also grab 4 and 5, I just need to stare at that locking code a bit.

