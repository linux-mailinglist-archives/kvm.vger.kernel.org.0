Return-Path: <kvm+bounces-34948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59B0BA080DC
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:51:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D562C3A1777
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7F9205AD6;
	Thu,  9 Jan 2025 19:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qYS3iom4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096841FF60F
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736452147; cv=none; b=GUDdoxsmsW2psNuxKpURA4MhtJCCCZBqzUJAzXARAHqj+Uvwp0sdxb8oCz99uZcxAlEAuH+kwdesAjdp841WcGBIpJiSKDBvnh2RNmIn5dsL/zspgQJLnQyBImYIuftso0nibeeUuGpHiatWFCYANF8Y6oamTwGO7Ex8GG3+LD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736452147; c=relaxed/simple;
	bh=l+6I326cyv2z/V6Bv9iX/H2iItT3zKr3BKr1V2p0JKY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j5/6mNK+c33PH/HRV3V6dqaXL4hcN9fr4qVws6UhTcYpuSMqMoJuVHnU0qkPJg/6FMKiKU/6Ltzr47BqOAggTy8eNNQZ+4RaiqS2UvWcFPhJMBFY6jxmbLCJgdDLHesZPCJZeLuwKygvjh6VpAysLuKCEfuh/OKTqDUmSLI1xek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qYS3iom4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso2358675a91.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736452145; x=1737056945; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEH4IlkHEegdNcZuLRoF8zPCf8n2JIPy6tw18UJ/3z4=;
        b=qYS3iom48D2AH0GrU+BzNPzzrLUv+lhe99zFsdKwh9ZdFR+eqjxjBGirPktgFzs0OI
         njF9vkXadU1vdtxM6K2h+ErgAdE4WvcYTsSp4J0+We6qffqdhgdFeOVHMuW/k8lOnLOY
         wanC2+M0I/1Aew/Hylx2z3LjvmyvdJBy8L3hxXr3PqKm8kSJ0HkXPn4JRyYOvBV3dIdO
         zG1pkrG2mCsJ7AB9HhVSQBYOk+DEcXkR5R+CLyYA43taN6s5fAjkvvqtzVQFdhumXOVq
         OZwvCbugoZfWpdQjLSeGyEhI0TiDLD2TklqRXm/RFr3FFy9JfYWD4mgV+NohVf9N+mmp
         x4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736452145; x=1737056945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEH4IlkHEegdNcZuLRoF8zPCf8n2JIPy6tw18UJ/3z4=;
        b=ivX+Jbman8Y2Qg8RowGXQQHCylIeg3wQje05AIASeL8W9tOX/peShaMWSmJnjtCJ/l
         vkkiwuYyuKpG/zwCqHDYMVA2R6fED32KyxxxbJzlBbOIcb7avFOg87eaaWethmDyHEB+
         OPDhXxoW5TMqHlG2IHh8ekRZqj8t0pywUq4sTvfsh++0WgImoYDpiXs1Ib5kPRg0+Q6+
         Fm1XgqDuUUiH/Qa4dIba1EA6ypcr9Fq9pUV73hakbrQkQ/hu81gcF8L9TX7qllgE6EAU
         PtJxpDXOMs35732pAj6xbLoUUzSC+q4fX56c04B3lOkfRp8spa7JjmbOgm22DaoX28+b
         cXGA==
X-Gm-Message-State: AOJu0YwGKu+7xgF7j01nabextFwYuWTVPdpJ/4qYiyArdW7E2z2DvVtP
	7aN4V4uR9PENzPaL24BI7w9l14pnY//n5bpGt6f7ySdnK7++jE+Bx1OJvmXOR4GjDr7dSh2S14c
	MLQ==
X-Google-Smtp-Source: AGHT+IHuJ2oQZhLdpoLlUuttYteOGCv15Z6/ikQBCMwuVnUIPK89csqsddp9L/RvAJMz5RGgy1SEuDVE1m8=
X-Received: from pjx15.prod.google.com ([2002:a17:90b:568f:b0:2ea:931d:7ced])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfcc:b0:2ee:ad18:b30d
 with SMTP id 98e67ed59e1d1-2f548e98f31mr11019431a91.6.1736452145377; Thu, 09
 Jan 2025 11:49:05 -0800 (PST)
Date: Thu,  9 Jan 2025 11:47:19 -0800
In-Reply-To: <20241227094450.674104-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241227094450.674104-2-thorsten.blum@linux.dev>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173645178211.889021.11894617530623151610.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Use str_enabled_disabled() helper in sev_hardware_setup()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Thorsten Blum <thorsten.blum@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 27 Dec 2024 10:44:51 +0100, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_enabled_disabled() helper
> function.

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Use str_enabled_disabled() helper in sev_hardware_setup()
      https://github.com/kvm-x86/linux/commit/800173cf7560

--
https://github.com/kvm-x86/linux/tree/next

