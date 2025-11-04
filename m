Return-Path: <kvm+bounces-62004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7446CC32703
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:50:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4C3134F1CC1
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B87333BBD2;
	Tue,  4 Nov 2025 17:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oWFbpxbc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C47033E359
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278456; cv=none; b=YEkyrgijultQDECtOr+CTpvtWfP3/1CSEHVvPJq5EcAo03plvxvooeXMogC7Od3pR+G3TkmVOseLkx2pEG1kz24J2mWSxwTOruI1iMh+5TfMUIruIvzPRuYZxouh1OW1tLnO07iKfAKEyD94bFlw7fAduM6p6fDg+2mLIKB3kio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278456; c=relaxed/simple;
	bh=m6iIOxVdV9xZ4R59J/j5BOZ7itRe9uWFn2gu8sIYRe8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=byRSRxtJ55wGKLXqgaOmI/xcfx2hGLIwfR1czWDL8QwhEOQG88r3aZtF0HLmOhcuD7bjQDnKu+LPmYeZEUeVoIddlV8HP1pYgJeJSOnHH4aFR35QRV90kgGZ72t5ItglgFeXCTFTIfDiRL80NloEkj+XnP5Vhr+LOdIt0Hov0+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oWFbpxbc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3407734d98bso6030991a91.3
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762278454; x=1762883254; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XPGvA3RdI0c5gQobVP2oSU68Sp+AIlD9qDBLxOUqB+Y=;
        b=oWFbpxbcZwdLESj5hbygX5KXMNrflN7sI1P7M9TXdNHN73tQReusejxAZJbnpZPSOO
         eVchRDVjIA8cKrte0dlC1Y1eKvvEWpspu12dlgS+ir8KRl6bkBy3FVLJrl0jTLsofFOH
         CaFASHHugoJqzUQXjUS4Ez7yeTTPo1fY+y2U/jEszxJnG6XVQMQZqBqD7UGN+o5lnYFo
         RHFzToJsgke5NDhrKajeKaI/7Y+CGXih3KkJo43DoMPHERCUimiNTvCMcGaplBHUkR+6
         QHAyHI5rZV+63vlR6cZ98Vfe2TNmuPsknW9j8y3SKwriuOo8fHBGOC5OI5bfn/IPKeZI
         5k7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278454; x=1762883254;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XPGvA3RdI0c5gQobVP2oSU68Sp+AIlD9qDBLxOUqB+Y=;
        b=KyX6EtD/R77kj7RYvF1FnOl9q5X2PrItfCe5ivQjgHepY2IkySWH8oTdGxGZJRPzQb
         VWnPv3RlMCR3FVsewgJTg8HrZy6AvEd1+GtXNns21hrv3irV0UNbC6czmKMc52rOLt6m
         0izRUJjzXUso20sS9QouIwdwiMI34RRciq+hb3dALDCKQHSx0nGUBrv2oTBOzsZzs3Tz
         mJriB1SM2Rt5h/btvQYh+49NM8KxLDF8k0pw/az884alxN8VLn5d7L0oK2UWYKd/4rVH
         mStZa7mz/+0fqCkzsJ2RxaPdk6R4psmfWOy1pRMK+ar9FnjTK75bPWvAgsT/GWjypKAS
         Qkfg==
X-Gm-Message-State: AOJu0YxAgI/O7OjCdvK9H3gBKvGeBXPgAILgTn1FCboA5+bepw/lUZIe
	Qf3pVgwQuXJIYLjo3KxXEbueGNnXyw+03dkzJYYzMFvmKvfE+TbJVXW/wWBQ4MVbdHTWOL1W4nv
	sT+ftEA==
X-Google-Smtp-Source: AGHT+IEXgUsBcWuuZMqpwU2yUZ0pdaTC98ExjPfngQwQ3P9JHrsrI2UqIk7JzuBp5OBgGGY6ISRc4F+NOtc=
X-Received: from pja6.prod.google.com ([2002:a17:90b:5486:b0:33d:acf4:5aac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:582e:b0:32e:6fae:ba52
 with SMTP id 98e67ed59e1d1-341a6c1e406mr59316a91.6.1762278454600; Tue, 04 Nov
 2025 09:47:34 -0800 (PST)
Date: Tue,  4 Nov 2025 09:45:14 -0800
In-Reply-To: <20251007224515.374516-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007224515.374516-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1006.ga50a493c49-goog
Message-ID: <176227807716.3935194.18291135386554722106.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Use "gpa" and "gva" for local variable
 names in pre-fault test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 07 Oct 2025 15:45:15 -0700, Sean Christopherson wrote:
> Rename guest_test_{phys,virt}_mem to g{p,v}a in the pre-fault memory test
> to shorten line lengths and to use standard terminology.
> 
> No functional change intended.

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Use "gpa" and "gva" for local variable names in pre-fault test
      https://github.com/kvm-x86/linux/commit/9e4ce7a89e0b

--
https://github.com/kvm-x86/linux/tree/next

