Return-Path: <kvm+bounces-42365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FEE0A78050
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36F5716E6E1
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232C820E33E;
	Tue,  1 Apr 2025 16:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xTEbOMbw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E749720D4EB
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743524195; cv=none; b=nUbq3bEBllzZnzkAVEZpYqBu5giM/OnuUCI8VJphrivB6hIcQ31P2CPtrNm2YfPuOhx+fVy5PUwm/DGlAJ4nb0ueUw8txev2gM5MUPXY16DhyfIbNmB549Yq/8hvTAfTzUPi9jn7sTonzW0rGnQrBElBTvUXMAIXxhkGq9R6gAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743524195; c=relaxed/simple;
	bh=ACojNPPcLx+riOgoNOBywycd9KS0V2VINRTWkpxHi/Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FkfujjW+6W3vVCZNO5oqSGY2BjtFK+cXrxtUf9VDKbOYUC2oRFxFewXyEKzTeNAxm97ptZPHDOI/dPI29mjz3dzSk6+CldHSomLyPaAzzaDh9nSLnKxATdHGLd9eGVCQc0T4uRPZPlhQ3yXUcpm26RK2HF+UD62ir3/gMjtQ+qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xTEbOMbw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff7cf599beso10733112a91.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743524193; x=1744128993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ACojNPPcLx+riOgoNOBywycd9KS0V2VINRTWkpxHi/Q=;
        b=xTEbOMbwOMOxUWy0QipHbk/hHo014Ndrc3rYa4NRxRTfww5Q5CgGT3dgmFaVdDDB6V
         p7y4/yb/4Gha1JB6JE5wuB9AygbCrExj4WX7zfqnyytW1zwFmLkJWbphwrmlhQyNmdsC
         1dgajP70/Afl26qlrbjgU9x3aH+uVGmNrSf+Rhmiop7aDacPQ3sdGcGexKaR6OIIcmg2
         T4nW9UXbP34y8W/nRLNkN0kJ5UesAkck5qcyouGboYckl9YfUQjHnME4iku2PR+9gG0T
         nUOKCikQv6xQi26m5RE3xcl6OGmUbsKPL7xYyqBAXmiuc/85xL1abIF6/mmtCMqZAHL0
         nzNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743524193; x=1744128993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ACojNPPcLx+riOgoNOBywycd9KS0V2VINRTWkpxHi/Q=;
        b=m5fl0TPrqTvbQsgDxmpZIQ10HC5dJZiOTNpFskoWgC/GI/Xa6FUwdxPEthPv2YIUjV
         y4yivGrvB8IZS5MSEdaFe9DIRIZZT8Y0bZkeaERBYJR5qSeOKQ1U7dAEPLw3NUklMEPr
         fvgAQ7WBy7Dq+xDugMx4Jgjz+VZklCKKKJ5wozQU6aPHdkCJtQkIp7iKTmfP8S5H8gDP
         lhriFCEIcW//+ZrQ2TIXLGY/bEQBkySJmmJHN5e6YMKSQA/iKorHgvDaHtr/JR3TPddH
         5IyEux/VlHNDTrioW1OcwKZpcuQqnwlI/PYkgx/uX0ut9O23WIFursA0IasCwkaXz3bE
         wLrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmnE5wMXaNdOryuBhDuXV7q0HsAgrB360UWo3xq4m4N2xDwkLaV2L5/7SVrvPJI8HDmzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGPFHI+SP1Lc+3CQPtr9OBv6zWPGtWLWC3bGdZAschc3YS1YKJ
	LpqzMAanNKKE1nWBmlq/1vWcUS/JFlea70DiG3AuUCf06DucQoIam+Dcmp16CIFXN8y4J8jMDnF
	4tw==
X-Google-Smtp-Source: AGHT+IHJPhtYxZuKDmgPcRQkJsHfOASSMbRV5HJyG+H3tF3h3o6vlYLvER6i1U7FUEsFVIndNR6h+3JOSiY=
X-Received: from pjkk7.prod.google.com ([2002:a17:90b:57e7:b0:2ff:6e58:8a03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d007:b0:2fa:157e:c790
 with SMTP id 98e67ed59e1d1-30531f71811mr20666131a91.5.1743524193217; Tue, 01
 Apr 2025 09:16:33 -0700 (PDT)
Date: Tue, 1 Apr 2025 09:16:31 -0700
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401161106.790710-1-pbonzini@redhat.com>
Message-ID: <Z-wRXy4ajK79pxKH@google.com>
Subject: Re: [RFC PATCH 00/29] KVM: VM planes
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, roy.hopkins@suse.com, 
	thomas.lendacky@amd.com, ashish.kalra@amd.com, michael.roth@amd.com, 
	jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de, 
	James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 01, 2025, Paolo Bonzini wrote:
> I guess April 1st is not the best date to send out such a large series
> after months of radio silence, but here we are.

Heh, you missed an opportunity to spell it "plains" and then spend the entire
cover letter justifying the name :-)

