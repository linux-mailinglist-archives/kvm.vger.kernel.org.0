Return-Path: <kvm+bounces-8140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 066B584BE2F
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 20:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38BCD1C231BA
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E6A1805E;
	Tue,  6 Feb 2024 19:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nBK7YDWq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F4517BCF
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 19:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707248325; cv=none; b=PYL9wafllXXx8VGH5D3ate6a3WYCNsbGJddlNGWd0k+hT2gMhmperMUvy2AtU76m51M8I07rfzf8p29+DxRQ6TQquAfiyd5iWUIMuYWsoonxGdRJ69hl0WHSm6jt/K8/Knal8z/4NMMd7yNdPpt2zvELrGcMH0tJENwDb8mk/oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707248325; c=relaxed/simple;
	bh=ou9hy7iyyhAt6woH41QHtMnaC5Ky6OjjEI9+SjblzGU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b1ZeJq/HOCJWFnXHx6ailOXrP4MrqVjudbdBNS6tM0BmycPewRAe9fSs1ilnR4OZPA1T/q/rRdhE9Xq10OsWfvdKTK4hMz/2fahqhKMtcbPQM9q9OQ+i8rNhMivvgQrGsnX2X8rQxFywhM/r0XLkS663PJDBRQLEvbOhI8ryeMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nBK7YDWq; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e044d773dfso1931189b3a.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 11:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707248323; x=1707853123; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3x2t1xN7bqKMU9/2nY9jSJ9ybE1oFcWPEelXadRAJ+c=;
        b=nBK7YDWqNVQ07mq2/h2Dm7zH3sKJJPr4Cw6iPVYdl8oN1SDbtBLWKgw9HCNjiaRox0
         RM7H7Dh800uHao7ciKKCcAAw3GY/jUfw4GiaDWDsHyMEsaRDtIq71xso5sJjdC1a5CMQ
         4Q2VE13SrcKAF0KP1z8LixXg8uv0WnW0r6mSI291JkJnrouqI9oK2esEpn7OM8OiO+wd
         hTIV7yiJIVS4q3vL7M18n8fWh+R/o6x1HRM7YahY5+16CfL1I5q3STxwpb+kbnSua8cO
         DNEUIP/rzP3t+ODDZZzl9ualynYAPHQVihi84ei+gzAxFJezqALKIOvGSiLFloxZiAQf
         623w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707248323; x=1707853123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3x2t1xN7bqKMU9/2nY9jSJ9ybE1oFcWPEelXadRAJ+c=;
        b=t9sio81DQ3Xd5tii0L03TzU5l42KurgrXtB+yfzowKtRJW6jA+QqIrOE4HbXTNUS8d
         95DUvIPY/W+hKc/tgTytxQwdK/oFIBc3PMBkVgICnd0LybtjDdfM0eEk6OO5RCsh3f97
         Nn+J4ZQ2g+3W4RZIhoyi+M+AUjQVapuyd0/FOuGF8vtqkGEKTxU12cOf9F8EnL/r4kw8
         3ZEQY4F6uGSASc/Y3ZV8UjQ4Czv4nuUntD24rHMYEb0iQR009/PIC+M4D8lQCwAJpAb1
         nX2R3jKqkupU6wFB/dr2Z7SD6Y4S+LUY6hMeKP+j4605NnRrzWoqFuWnCRW6ZULuD1lU
         BR7Q==
X-Gm-Message-State: AOJu0Ywoc9mSKqSRiNA7pm6DHsr0oZQ2t0S+yV+/6yO5GyyFS28WJfb4
	lcGb2Hs9F1Ww5kb8AEz9Pe2gJfkfCP20XcO7MYlqeMv95rvhuJb8kxzHD4s8NikKvtEZUsNF3RS
	aXg==
X-Google-Smtp-Source: AGHT+IG/zPUMOj1T50ca5kmrT3DixfAhKpfo4BKcmXiVhapJvIAWonVMes199lQxUOOpJ6y5BrPT16Dah9c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1894:b0:6e0:610f:33b8 with SMTP id
 x20-20020a056a00189400b006e0610f33b8mr32712pfh.0.1707248323100; Tue, 06 Feb
 2024 11:38:43 -0800 (PST)
Date: Tue, 6 Feb 2024 11:38:41 -0800
In-Reply-To: <20231206032054.55070-1-likexu@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231206032054.55070-1-likexu@tencent.com>
Message-ID: <ZcKKwSi7FdbSnexE@google.com>
Subject: Re: [PATCH v2] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andi Kleen <ak@linux.intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

+Oliver

On Wed, Dec 06, 2023, Like Xu wrote:
> Note that when vm-exit is indeed triggered by PMI and before HANDLING_NMI
> is cleared, it's also still possible that another PMI is generated on host.
> Also for perf/core timer mode, the false positives are still possible since
> that non-NMI sources of interrupts are not always being used by perf/core.
> In both cases above, perf/core should correctly distinguish between real
> RIP sources or even need to generate two samples, belonging to host and
> guest separately, but that's perf/core's story for interested warriors.

Oliver has a patch[*] that he promised he would send "soon" (wink wink) to
properly fix events that are configured to exclude the guest.  Unless someone
objects, I'm going to tweak the last part of the changelog to be:

    Note that when VM-exit is indeed triggered by PMI and before HANDLING_NMI
    is cleared, it's also still possible that another PMI is generated on host.
    Also for perf/core timer mode, the false positives are still possible since
    that non-NMI sources of interrupts are not always being used by perf/core.
    
    For events that are host-only, perf/core can and should eliminate false
    positives by checking event->attr.exclude_guest, i.e. events that are
    configured to exclude KVM guests should never fire in the guest.
    
    Events that are configured to count host and guest are trickier, perhaps
    impossible to handle with 100% accuracy?  And regardless of what accuracy
    is provided by perf/core, improving KVM's accuracy is cheap and easy, with
    no real downsides.

[*] https://git.kernel.org/pub/scm/linux/kernel/git/oupton/linux.git/commit/?h=perf/unfudge-sampling&id=6a35fa884b378f704b485c6bf887125af5da6077

