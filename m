Return-Path: <kvm+bounces-63025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FF4C58853
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 16:56:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9AC4735EFC8
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 15:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4839D2EBDFD;
	Thu, 13 Nov 2025 15:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y78R7zn4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CA026CE2C
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763048276; cv=none; b=BlbsLVl0JWCoIG3T6JnUloGzyLNnTPRmv1nEB25/HoIrsytGI5r0vMS4/5zX3SbjukP45dIDMh5XmICSXp6FS1z0a9a/34D/8/UqOvM/+GAmYNknxG8MwJt3S4R0EKqoowKrzHi9cBpdp40Ln3c0T0A6VJxQI0A/PEchqTk2p08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763048276; c=relaxed/simple;
	bh=PVs3QA3h39OY8vELwwmKD90SEduWln4ioXy+TQYmBGI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nT/Z3RBwHTHh8q3iU/Oz4UAoJk0TTAeB4hiR+jxjsHnYuet4qjNYZtH30lHniNgaMJ8B7cs48x6S9goLVWNA61zyHzwYYpkZplbyCHFvzcv9RzDhS1PN0P++Yhyehge8yHqwFBsZ6HIfQs7OVxIJG0w3SgQ63S6FhxSMihB+Pc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y78R7zn4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3437863d0easo966017a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 07:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763048274; x=1763653074; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NanmVyWm2Vvsyfpfmbn7rPVld+ao1K4xNTswIeS43GE=;
        b=y78R7zn4VaU+R6rl5aRF9e00YJYEMbzqtwHAuWmUadXNKiMdIzMcW2SCOs8fES5HEv
         /8sV0oMasDZV9Fg/2EY/dCmSTEZSmt+HtBKQ7Gs2+zRsE3v5/+0rpxE+GU/V5qMkWdm8
         3S8RzhzIg++pHsbhr+MEEtIRaIIUFBBEXZ9LqRlTPX8JQPkur/fy7EyOUhrWKYNuurIg
         smgVzy7j73SubJRafQDMQMwvCil4f3bsRwmn8iBCrftQKdltWJb8ZtpjJro8nzq89/iR
         2JLDVTx0k2HOv2wlQOHskgjigVEGb+57iivFZF8bHZ8CWt7gDbeIEsHyNi9rKRaOPkhU
         HITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763048274; x=1763653074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NanmVyWm2Vvsyfpfmbn7rPVld+ao1K4xNTswIeS43GE=;
        b=u8FSmBWsR9dCllEE+B7l1PHSO7QfUk3ZfUgI+pYx/NhavmVK0k10gJMNU5tYI14z8x
         4iPiuTmDszRP1XkYn3rSDLHnEtiohlVQapfOBR08e6B8FXlbLEgbdmiyvxkkF+Y22+j+
         wMSr/zDIij0szQcC/GNYv292mv/d8FAliVXbKnYYubovUd8gnSGLtoIo4HN3I+O+1QIQ
         PvTIWi1IYqY8e+jLhZ9LxhpJtoYRn1dgNVRkOVmWxD7D4+DkDEKRxfT1uUdaDpOLkd/s
         VyoSGz8ctf+rcav91wlXf+DBmlFscdtMsaw5b4jcJuhqhRYkaB7LX4+QEd8EGEq1e/0f
         Z6Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWnwyheqkxPr9M70kv4uwD0FT2UKwWduPNVURrGnkWRa7STNSicc7hDtK+881+ocjfwMQg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3pJOqCigGrzYApXaUqe5yVBOWx1tR9oYAtsaQgcwhMF7zXwxQ
	9/DUCB78Gesy0y6R60TErf7bm0uN+uJQ0fojWtZB/QZnDZpKDHIjZbzf2ovr5Ws0Z6m8DF9oPFo
	l0BJzVg==
X-Google-Smtp-Source: AGHT+IHIeIOOLKjhH3nqJ8YUm1oSm40kZ4brG0JoCv7HEZPEvkLRythN5HOIeCIHT9qYrlTwuCspcZ1TEZ0=
X-Received: from pjbsf3.prod.google.com ([2002:a17:90b:51c3:b0:340:be60:931c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:b88:b0:343:e461:9022
 with SMTP id 98e67ed59e1d1-343e46191admr4812531a91.24.1763048274260; Thu, 13
 Nov 2025 07:37:54 -0800 (PST)
Date: Thu, 13 Nov 2025 07:37:52 -0800
In-Reply-To: <20251113150309.GCaRXzLS0X5lvy7Xlb@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-6-seanjc@google.com>
 <20251113150309.GCaRXzLS0X5lvy7Xlb@fat_crate.local>
Message-ID: <aRX7UDGm3LHFnPAg@google.com>
Subject: Re: [PATCH v4 5/8] x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM
 as SVM_CLEAR_CPU_BUFFERS
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 13, 2025, Borislav Petkov wrote:
> On Thu, Oct 30, 2025 at 05:30:37PM -0700, Sean Christopherson wrote:
> > Now that VMX encodes its own sequency for clearing CPU buffers, move
> 
> Now that VMX encodes its own sequency for clearing CPU buffers, move
> Unknown word [sequency] in commit message.
> Suggestions: ['sequence',
> 
> Please introduce a spellchecker into your patch creation workflow. :)

I use codespell, but it's obviously imperfect.  Do you use something fancier?

