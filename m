Return-Path: <kvm+bounces-25430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 271AF96554C
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D160D285AF5
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 02:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3ADF1292CE;
	Fri, 30 Aug 2024 02:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SfF9H34v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B892C18C
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 02:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724985420; cv=none; b=DqESsPNVu68HLobkihOXRcc9QTuJrF6KsRVIqW52+e4V/KtXTjmtsqO8PxMeaZ5IWhAw7PRNomxbrWgT+1DQC1XZrCDVXqHlGK/KeImshmwQ8rybs5g8atVlXimMIHovfET5s87PvNczsMz0kcmoyKBGMNlHhfoRrM8eFYn/AAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724985420; c=relaxed/simple;
	bh=fM1UXiA75lC0t62D2dla1o8lILo9Q8CRSahRviWi5ew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oVkTWVxcyYYKEDeB6yiTHRdRFxRffJt9+7ezigq/vDBYBvFlFQ2zJbAhl/Ydv0A9SbY3PXgnrtOTsN6iTVpQZ3t/l+wO/LJz+SjWDJEETvoWzoKfLVLz1Vxn8rjdxmNWs1MIovXWSPN05VJoykaEF1KLwrkw8+9Zbafcf1qopIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SfF9H34v; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7d2159ebf3dso1321727a12.2
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 19:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724985418; x=1725590218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VD3hQvDktv/EfnTYCms5ZPCRMMvQU2Cc7a/RkZOAue0=;
        b=SfF9H34vOIFf8JUJwMvAfOVu3Jekf8PvLLDe5I5ww29wYnZDFIMywUogFIh30dwcpp
         B81/UrJ4Rq4p1Jk15jKc4WV2hfUYTNXiYoIpuXv+Q+UhNYEIFlEsCW92ZZJTuKTIpumq
         jDemMUDuHwE9ff7p3RDE/mPTlbUgbHZvnGIMTwrYSmvado93KtUd3zDbJp83SbjKlaO8
         z1s8GSxgs6WNZxszsxOEKLQOCjLhc6VZR1h8eq3izjYVDTLIuj3XuG162eXp3EqOSfiV
         R7CY7oli1MM4suBl2IdPSjdR7+oEw62gZbZCbYSQARpIODcajSri8lIFhRLydPaIQtf5
         613A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724985418; x=1725590218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VD3hQvDktv/EfnTYCms5ZPCRMMvQU2Cc7a/RkZOAue0=;
        b=LS7gZdHtRiTBwfjE3Z3vj5adizZbmrcOhF/banqiLd3OmbMf9+VImlaqX5KTcurF/Y
         Wob2QzFg3+IL9hkinIzBScL68YniWhZyg9dthKdJupSqjppeprlvzptOufAjRwg+RhIh
         eVYkiG0wPtPQnqaQgkyd8mO0i1fVnlJZsy5U5wI/j+LxZ+0V/61nKq7qhCUFPG5BRFdK
         txZMKM4X5EokZ4RXRWu4V0/KN19vdJ4DqiFFcr71KThR9ECQB7UqCau66YrNM1EelO+m
         joY6drWEy0l4fJt/uNMF8KKvEDplI4ug0lMyVnK1yRzAZZ6AY1xcMkLy54GeHUNUYVhF
         yR8g==
X-Gm-Message-State: AOJu0Ywjqj4CroISgDHPDiav+KI5Dl+kVSSSV2uIvWsJBNLiPSCdukuZ
	Pl1ChqzzcZaSOaWwCPZRDP66rm0WdCbVmZNlLreg/XsRpYaUa/mGFIuqVhR02QRWXtDDjQv65Qm
	4lQ==
X-Google-Smtp-Source: AGHT+IH+k6HDIiN1o48889VDXAYhz766twpv53PBiB56DU6qPBsCvgJbnTcPhbmOP8hjIhMw1MR9kn8C2m4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f906:b0:201:cd7c:c0da with SMTP id
 d9443c01a7336-20527f74b42mr271205ad.6.1724985417882; Thu, 29 Aug 2024
 19:36:57 -0700 (PDT)
Date: Thu, 29 Aug 2024 19:36:56 -0700
In-Reply-To: <20240709182936.146487-1-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240709182936.146487-1-pgonda@google.com>
Message-ID: <ZtEwSOzeAEuzpLpy@google.com>
Subject: Re: [PATCH] KVM: selftests: Add SEV-ES shutdown test
From: Sean Christopherson <seanjc@google.com>
To: Peter Gonda <pgonda@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Alper Gun <alpergun@google.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 09, 2024, Peter Gonda wrote:
> Regression test for ae20eef5 ("KVM: SVM: Update SEV-ES shutdown intercepts
> with more metadata"). Test confirms userspace is correctly indicated of
> a guest shutdown not previous behavior of an EINVAL from KVM_RUN.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Alper Gun <alpergun@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kselftest@vger.kernel.org
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> ---
>  .../selftests/kvm/x86_64/sev_smoke_test.c     | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
> index 7c70c0da4fb74..04f24d5f09877 100644
> --- a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
> @@ -160,6 +160,30 @@ static void test_sev(void *guest_code, uint64_t policy)
>  	kvm_vm_free(vm);
>  }
>  
> +static void guest_shutdown_code(void)
> +{
> +	__asm__ __volatile__("ud2");

Heh, this passes by dumb luck, not because the #UD itself causes a SHUTDOWN.  It
_looks_ like the #UD causes a shutdown, because KVM will always see the original
guest RIP, but the shutdown actually occurs somewhere in the ucall_assert() in
route_exception().

Now that x86 selftests install an IDT and exception handlers by default, it's
actually quite hard to induce shutdown.  Ok, not "hard", but it requires more
work than simply generating a #UD.

I'll add this as fixup when applying:

diff --git a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
index 04f24d5f0987..2e9197eb1652 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
@@ -162,6 +162,12 @@ static void test_sev(void *guest_code, uint64_t policy)
 
 static void guest_shutdown_code(void)
 {
+       struct desc_ptr idt;
+
+       /* Clobber the IDT so that #UD is guaranteed to trigger SHUTDOWN. */
+       memset(&idt, 0, sizeof(idt));
+       __asm__ __volatile__("lidt %0" :: "m"(idt));
+
        __asm__ __volatile__("ud2");
 }

