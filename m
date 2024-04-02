Return-Path: <kvm+bounces-13385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7C28959E5
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 18:42:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A6301F20F9F
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 16:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84135159907;
	Tue,  2 Apr 2024 16:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EPl203Ig"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045231598F6
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 16:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712076145; cv=none; b=dTJkL915NFRwHXWUwdby8bur5hZbioQ5fH74i8jdqR9LC6BTqSqbTlOPputxARlwXUMpHybqzF8jwdxBT2VbolFbldH5CTSV0m2vqU+dv+YTTL67SrmvP4zKffGumF92yiiCMk1e1a+Qy48+ac0nruMAH/CoypiuvWmAMlfyavE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712076145; c=relaxed/simple;
	bh=qimNIwQamzjuECOZVcUyxBah+GkMuK8cDzVdhTDCQHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V/CnA7SAGR7SFa4WocjD/XOHdGydRfd460GTlICoJJzEGgHIfbNytprhSp9/mLJP7umAYS1Pj4qfQig6+UO62sJznenzs3vbwwQ06jxdkyPqMHCDWeZufEbWtGtgyVjB1Az/vWXVZrTLeXfwL9boHWEYpFkXg+YO/VqCYzqhE8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EPl203Ig; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-56c0bd07e7bso5689105a12.1
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 09:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712076142; x=1712680942; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qimNIwQamzjuECOZVcUyxBah+GkMuK8cDzVdhTDCQHk=;
        b=EPl203Ig3q3s7OHORGgqNRc08FQvj7EvY1Fo6+qPEAziacYvAd+SD/kKK3Fz8cN1tQ
         llTmQlexJCFlStZjTkusm9uqbtkD4S3eM4uHuxqzFacHXC+qELNU8MpRUCBxY4zLRag6
         FNtE3yhRq1MiYx4JLL1dE2OmlUQrmdan7jifhgCLvh4M1co56iEqk0ob1YsLSu9Q/mNx
         5LA/CbKjsaIlprRRRkritbtqtowoQZuYhc1g48LVvx0z5mc5nOXMw+NfhfgEqpp/yK+s
         rj/uhUPYfhVBZ/KYQaWkv09zSA/mqfGQCdEBSI1AADFzbpCUmkoUNZzU72dwJEJJRkrz
         Y4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712076142; x=1712680942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qimNIwQamzjuECOZVcUyxBah+GkMuK8cDzVdhTDCQHk=;
        b=MXOJz1f1foAG5LjiqXh8Za+v7ORmI+2uY4qgIdTejg9/vjdHyvIdG6EUvJdtnbDB9C
         cFrxTuiqDQ6q+O1jM9ilA54krvTbaY9VqljkDuUn1XWFqDWaFjzEREBatCGASkbxYzyK
         JfOjLxAr82u4lIuI9HLaVK1McXs/A/JNTwDLwFqQ2YceMXPOMTPanqqllF+x7b4YMilh
         P851RTZfXS8Lap0G7EZtn0XTDXvC9cbchr17MSLBUra46wdKrcKhzW2TfrNIdWPA6vdF
         wnkB48LEDrR1JR5E2Arou8DLUnrlFzkSi65g/XW65hU1qe/Mq8LPLW80b/oCeS16etOE
         pTPQ==
X-Gm-Message-State: AOJu0Yw2uAtQ2J3rbWbFIKSBwCxNSYc9OiYpTGadgnWg20pMSut3KE0a
	o7c9cNfeEQvHP3YZ7eFI8Y/mWgs2pQiHuU8VhsTf3Lvdf/y+rhF1AQ0dZuJHy9I/HAxczkhnl0i
	HdiMJWYqp8jCgWk2vFy2E4+kNk5mNqSB1HFux/Cy28oHCXlCVgg==
X-Google-Smtp-Source: AGHT+IECWrrGFSMrbDwOfdYpMDM/mkRkgXxYGdKpQqfTwF2XqKG2x5N1Jo1uFVKtIwbuqsijpCcAp6L9J4wyq6s2rcI=
X-Received: by 2002:a17:907:780e:b0:a47:340b:df71 with SMTP id
 la14-20020a170907780e00b00a47340bdf71mr7552635ejc.2.1712076142222; Tue, 02
 Apr 2024 09:42:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307163541.92138-1-dmatlack@google.com>
In-Reply-To: <20240307163541.92138-1-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 2 Apr 2024 09:41:54 -0700
Message-ID: <CALzav=f_7t7a-yY3Ppyu+VbBnDiNCkvep1VvfmSnNbuS3JNQ7g@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: Mark a vCPU as preempted/ready iff it's scheduled
 out while running
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 7, 2024 at 8:35=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
>
> Mark a vCPU as preempted/ready if-and-only-if it's scheduled out while
> running. i.e. Do not mark a vCPU preempted/ready if it's scheduled out
> during a non-KVM_RUN ioctl() or when userspace is doing KVM_RUN with
> immediate_exit.
>
> Commit 54aa83c90198 ("KVM: x86: do not set st->preempted when going back
> to user space") stopped marking a vCPU as preempted when returning to
> userspace, but if userspace then invokes a KVM vCPU ioctl() that gets
> preempted, the vCPU will be marked preempted/ready. This is arguably
> incorrect behavior since the vCPU was not actually preempted while the
> guest was running, it was preempted while doing something on behalf of
> userspace.
>
> This commit also avoids KVM dirtying guest memory after userspace has
> paused vCPUs, e.g. for Live Migration, which allows userspace to collect
> the final dirty bitmap before or in parallel with saving vCPU state
> without having to worry about saving vCPU state triggering writes to
> guest memory.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Gentle ping.

