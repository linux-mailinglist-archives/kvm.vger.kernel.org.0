Return-Path: <kvm+bounces-40685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81FE2A59ACD
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 17:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D8D63A9FF8
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF2A22FE06;
	Mon, 10 Mar 2025 16:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AY+q+Fix"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9820422F155
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741623431; cv=none; b=N8x2HaxTDDiLqepXad1rgubaJR8RxzrXtETVqSlknr6gcubD0tHALT+5nP2caFFD/1I5R6860BVqWaYKfAiwyPZbb2sxHFyp07/lySVEjQK8ckiamMqdVvVcgtOH190E8LaE7sQsOaugfCGdxnFuhBdnGjBLMwT1y3otw9yR788=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741623431; c=relaxed/simple;
	bh=E5gkLF4efJbEakqe2LCyGh3dRXBQKFkQyAgDGFFrD/E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=X5cSEOgGSOXN+Vua54ZAkvfSK/55WVSa2tYuyEYETmLjEtYQ3XIRe5pHr1Sws1kj2+AQde5veLSeu5wdmaXxPtcdWJEU2zNxpR+1rlpsGbz8boxp3TPM/A/rlYS0bzX3KnbxCSP7sLL3+kBPOPp1a2rtoZLUef8F0BlbJamCcZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AY+q+Fix; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff798e8c93so6547870a91.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 09:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741623430; x=1742228230; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5gkLF4efJbEakqe2LCyGh3dRXBQKFkQyAgDGFFrD/E=;
        b=AY+q+Fixb/TovXaeoNGX4yu2G3DhjbwDs2qV2dHdvU0GZ6/81XD9YQQfkwbTzdV+Hq
         uDe+zEKR5jjRxka1ut4ObLgqPo8gFKj1eKJQPIJNKU7TBhhnYjGXt3zM0zpe1tfP7aWZ
         ppNTtLynMqw0DiIoEZJ1gsUjQVPFvKLTPKt4B4qWkI4H8oxAwTSu9XdFUz7MeQ+EqSNP
         EcOqGiuFaWZ09PatCYsPRvQ1s7iUE1EnZ2aQ8gePwMeN5fGtz86foUQ/2twMJcU3kNLi
         aQFRzTOKIeaFmpUEgRwQkORItGCGYZFlmQpwm1F69SaPBHgrjBw5nrGKjxqe9dR4pRNE
         ejwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741623430; x=1742228230;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E5gkLF4efJbEakqe2LCyGh3dRXBQKFkQyAgDGFFrD/E=;
        b=JtUckoH8GLKcvk7+7xkMEjIHPlgQOpdl736kPZCRNIdkJCJFSHxnTuIAWH5Dxrhasz
         /2ENs0opSHTC2jSw/cHTaiPLBXiv3EvEOzt0Oe1i79m7QuBREKWxtfRASPDkqEOE3tQK
         67uDTN7N52u8FlvY0Wh9BZ3xKgmVoOtHZoBeRTEqd8Sf97PJqbYKZ2Y9b840Rvo7xMYw
         /LK1KPxycIGZe5HJ6pQq1lzmiI8kJQhoUvJslBiiJmAFr0gtN4+ZuYwd6WwKSc4OdVLL
         fo8NoJv15Qo2dlaQAtqko0j91dhN4ksqDHU10sspsz2USQ4SySV0ic+a5bmi6ct8mzPe
         dmyw==
X-Gm-Message-State: AOJu0YxNOORuqmmZ+sqkZ17WAceyQB2jIMPL2bLmtVoqtPwcy4YoaDT5
	Rv5i53cslqy/pmSV6XKArQOHXznq1vwjXsXzQNW7/65UBL25N5TY1l+rgatw+VwhkhVs7vQESwx
	8Rg==
X-Google-Smtp-Source: AGHT+IEvtopbnUmeWsy/nIhJXSJwmRVRXafyvQtfaSeezEXN0bryU3yMD0urwCDwgpBZydAdDQCaU98xn/I=
X-Received: from pfbde10.prod.google.com ([2002:a05:6a00:468a:b0:736:48e7:45b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3994:b0:1f3:32c1:cc5d
 with SMTP id adf61e73a8af0-1f58cb3fe00mr534312637.21.1741623429907; Mon, 10
 Mar 2025 09:17:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 10 Mar 2025 09:16:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250310161655.1072731-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2025.03.12 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

In protest of Daylight Savings Time, a.k.a. the worst idea ever, PUCK is
canceled this week.

Paolo and other folks in Europe, would you prefer to cancel PUCK for the rest
of March (until Europe joins the US in DST), or deal with the off-by-one error?

