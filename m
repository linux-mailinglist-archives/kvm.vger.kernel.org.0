Return-Path: <kvm+bounces-8042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A6E84A2AD
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 19:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A76CC1C22017
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 18:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4163C481D3;
	Mon,  5 Feb 2024 18:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M8r6/oNv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B42B481AB
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 18:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707158806; cv=none; b=paUwic4jXemfoKYphsWuohgt9FXo9zwDuzTZmhF00MGgF7SaWxqHK5VxmYFm11ZnqQ9RjWnL/Rgur4reLS9UzqBYGUtjRJosNBvAbgAeidqGie6iMD1d/TtzySoKgoMBAJ4OATyRvM+ffVwScRj59MWgGxwEVgSTTP0+VaAb2zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707158806; c=relaxed/simple;
	bh=546T1LmxxB+F6JLaVkQw8lglMN9t3Waiz8hXmFlkuvI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KgBmYx9NJ2wrrxyj4f7z+skT1cJXmXmd5Sd3ezDbRAKGDrE4R1D0glkdl002GzZTsK/VFVQPbQsT397Ys3l197SD31kam96HWhDp4Kizn+1iVCHkrbtv17FHxISzcO9YpMylWJ76UTsWDofFJZjKt+O/XHsqQIueA4gcpSet2FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M8r6/oNv; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cf2714e392so2891110a12.0
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 10:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707158804; x=1707763604; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XoOGl5kFbmamboXs1v4xjzSUsRHrTuxwKEVk9yuErw8=;
        b=M8r6/oNvzOWfSFRQGK1ADsddU0qAMB/Hic1acfW0nQD9j8xbl0vDFqyoUOx80Mug5m
         Jm6BhAjyCjkCZon6vVl1eA4GYomS7zHIj82Go1e5KNC2YRii3QijlqG1NVWPCse/+q9Y
         6D17WzXNpVXhOqu/FR2LzKOYPRapbmOMAe7l68cepvVwWSjpQjfKAycF0jY/bjhl1OTk
         7mxh8pPpPfLCqAl8EMbR5K4qz/rTlZ8OHE98IUmwdpc2azoEW1bOY6AAkKEFETm7sGgt
         a9iqYWD2tD9wqbTc+FwTHlekR41uL8FnvlYrhqRgF/TyW5l834yZnqvndqn84blKTnhV
         QvZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707158804; x=1707763604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XoOGl5kFbmamboXs1v4xjzSUsRHrTuxwKEVk9yuErw8=;
        b=IoN3DvpqO10huSV15imoC1al/aej/vW0Vrf9iWwseW2nMBcddumHBFODr1CmYNnDgo
         nwkp+1xT3agnv00N+zOJscNI2MPSqO47iNodxIi/XWIbsqsbk1rV+ZWIHsxWxL/qW3a6
         Qjci978M1dnNyQEppihcr0AIB+PYE4bVQPkexxZT80gHmCOr0NRBx0UdKRzQasUWZiVE
         5OOd4cxkvD+UIhNtodce4TE6eEBIc8pzUlipFpFv3ipKgEl5Lj6aREd3nP43d1HBg+9o
         Sjm3U/ilah7af0S6yv+QmGY2mnetGQ3iXItuN4XVfPfbu5eam+I/wvvkV6kfq/mvGjgH
         Ewzg==
X-Gm-Message-State: AOJu0YwMDf+cpYyFqfaRcsWtQJ0DorFkyauB1kSDA94baifDv01tFKvw
	6ymacpjFhstyjjBU/NJePo0nY0SIvY49B0I5sb9HsBvF2ormV4C4PWc+4ofAFjSdjKS2khyWlqO
	CQw==
X-Google-Smtp-Source: AGHT+IFsfgtL8CJA51mnTj4z4y6ys6g9zq85oOHq3ACfgW6KiEBS8YUCy0bOJ4ftNGKtA0ib/GY9g5cEaYg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3382:0:b0:5dc:13cb:a914 with SMTP id
 z124-20020a633382000000b005dc13cba914mr75434pgz.5.1707158804578; Mon, 05 Feb
 2024 10:46:44 -0800 (PST)
Date: Mon, 5 Feb 2024 10:46:43 -0800
In-Reply-To: <20240203124522.592778-4-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203124522.592778-1-minipli@grsecurity.net> <20240203124522.592778-4-minipli@grsecurity.net>
Message-ID: <ZcEtExGzJKCnuRLg@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Fix broken debugregs ABI for 32 bit kernels
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 03, 2024, Mathias Krause wrote:
> The ioctl()s to get and set KVM's debug registers are broken for 32 bit
> kernels as they'd only copy half of the user register state because of a
> UAPI and in-kernel type mismatch (__u64 vs. unsigned long; 8 vs. 4
> bytes).
> 
> This makes it impossible for userland to set anything but DR0 without
> resorting to bit folding tricks.
> 
> Switch to a loop for copying debug registers that'll implicitly do the
> type conversion for us, if needed.
> 
> There are likely no users (left) for 32bit KVM, fix the bug nonetheless.

And this has always been broken, so if there were ever users of 32-bit KVM, they
obviously didn't use this API :-)

If the code weren't also a cleanup for 64-bit, I would vote to change the APIs
to just fail for 32-bit.  But there's just no good reason to assume that the
layouts of KVM's internal storage and "struct kvm_debugregs" are identical.

