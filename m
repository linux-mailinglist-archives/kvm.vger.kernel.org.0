Return-Path: <kvm+bounces-39012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07655A4297B
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F44A1680A7
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B962641CB;
	Mon, 24 Feb 2025 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EGbiGq28"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B26261370
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417848; cv=none; b=uLU8q6g2Wdl2ep4lhwLVVyfbtrqD0qvzKwNvqc0i9/vR7NbCbaIG9dSdiogD099qajYXOG9NTn77/vDRnqJKvVNsxxAdXQTo2A0ErkLSIQCT3wvgF2fcmGpxtdG8m4fmmf9kPpolFpkPew8P+zDECL+8b0QI0+V5QQDzpM8m3A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417848; c=relaxed/simple;
	bh=1FVHBn23tB0rQwYmHKEB1Ylo5s3SGKfLEmvTVgdTdZ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N8eWzkdD7lpY138gF7FOxBQE7Kd/XtEYT8V8FRxzQD2Xeau6bJNvK/ojZrdrk1Dpuxh0NM2wYxRB44Is/TmBhs2EPN/kYsBRGPFAJ2s40XvDOsFUo5d9hFgi4JBzGRltKMNifNQggUYYsWVa0zkRaRXKlS4gsRruWKO/BY8n8XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EGbiGq28; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1a70935fso9703962a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417846; x=1741022646; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S6yGacMjAHVAQBR3S7ZtK+/8LMlUXsjUPpKPbieNgj0=;
        b=EGbiGq28+XxZnvzsjkaJnXNYn9KANFCVYqUbQcw7xaivU07Wl5eRRk4q3Vjuld8nE3
         Gpi7BpEo3jYXTO7zZQ0Wo9xrv+FwYMCuY3HbsIvbOCQgZBL3h8OUxBMP8pPTej5fjHxb
         R/218xDiDhkvvIi8NJsVAao7IS3wtVCyZ4TxDTQNnja185BNq5oNdRJJ0+8XhmbEoCZF
         rICFya9W4EJMj9varLThz+f81oING+an9Po3SeovlQfAWNXi7Wom9lC373MhM9IRCsyf
         BPE+BD4C5w5Qllqr68a0H4tSLI8jMjgLzkbyX6HB6ndT6LYNCuMoQO1/WqFonHRS10/E
         klXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417846; x=1741022646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S6yGacMjAHVAQBR3S7ZtK+/8LMlUXsjUPpKPbieNgj0=;
        b=g+lKzD4zurAAeH3p7n3/HIEVRLzSRrA0ZdhDibVskK49WwKYSpAotOscb+4hCTEx9E
         mcIEhA3kd8FNKewq15qSug9q67Z3T3JOPo0Vd23TVEOdehvcg5jj1+GH1SvXETh/iITR
         3a90VRYvKzHYR7f14suqTCymBh0b8Iw2W60dmBrU1gGr26ys0NOc3Ct8GoG9OE6fghdE
         vrvK59cEkVlGTcrDcghUOR8WkxlVCAJ6GBI8nn+327vYgq9aZA1JCJzBftRYBSWAvPBY
         fi0YsHPsI4ntOjV1dmDf4MPhYT2yxrLbdS/hnX510Gs/x5njjVDuWNcq+RoRSXDb/F0s
         uukg==
X-Forwarded-Encrypted: i=1; AJvYcCVwN4VRz4mxfB3F4CPk+ttjZx6EM/idHAbkjIendOhrCTsjVvoM7DWvTb/flH/CbvVqpXU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlir0shp3flMY5eh/WPMkDIPmDu6dILvPdVvQA8vgrfeH+2aMV
	ASIJBeWuUwivaN/SInVUIKkHfLXDee6+G2Su+xKpLtqIAztTuA87WqKUMDKu5WUgBuOgHMIhzVp
	APw==
X-Google-Smtp-Source: AGHT+IFTL09cz6hxGCXclZd3xzWLMnsZM1ABe9RAGKRipaOw0uqK5fj9TZ6aZCXqfvOOJIeL8QeN0eCSDvk=
X-Received: from pjbhl14.prod.google.com ([2002:a17:90b:134e:b0:2fc:2828:dbca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5202:b0:2ee:e518:c1cb
 with SMTP id 98e67ed59e1d1-2fce789de87mr25621134a91.7.1740417846290; Mon, 24
 Feb 2025 09:24:06 -0800 (PST)
Date: Mon, 24 Feb 2025 09:23:47 -0800
In-Reply-To: <20241010153922.1049039-2-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010153922.1049039-2-aaronlewis@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041736773.2349692.11010469798708147862.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v2] x86: Increase the timeout for the test "vmx_apicv_test"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>
Cc: pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"

On Thu, 10 Oct 2024 15:39:23 +0000, Aaron Lewis wrote:
> This test can take over 10 seconds to run on IvyBridge in debug.
> Increase the timeout to give this test the time it needs to complete.
> 
> 

Applied to kvm-x86 next (and now pulled by Paolo), thanks!

[1/1] x86: Increase the timeout for the test "vmx_apicv_test"
      https://github.com/kvm-x86/kvm-unit-tests/commit/30c13080e274

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

