Return-Path: <kvm+bounces-61997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E87DC326A9
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:46:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3B2B234B8FD
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D6E33BBDB;
	Tue,  4 Nov 2025 17:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O8YCkQaV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C972236FD
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278375; cv=none; b=FkHhTjqfIkuMT2XkeMuR2nuNFnCE6lj2ElspUH1N4BbEdOiX0atF726EXnHES0Ctl3XulODTp+Nnx+Fd5kU7yf+nKGWFrP/OSrUsIvIcemr4NNlOPha0Xx8ZCINDyzfWbyY/ThxKkpvZM5DVZ2tYELmGwES96yVN7Zm6/2AYAGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278375; c=relaxed/simple;
	bh=zvK3AGR/wfWblYlZlGaB0GtsE5DjaYWmJ5QCpM+ehoo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E3g4pX4nieKAbyMWImNuaLBkdIAS6Y6HbV8NHW3sk7b7uYjvZ4L1retSC3HlH5ew7zlk8eT26EuUbCHnN2E/dxzMiZVQzD4wcsg/C4hKlvt6s5Vzwr9qodyUMBr/THXjbiFKQcPJB8/t3v5mG1Z4Uxr5ANPw1Z8fr/gcFp18LbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O8YCkQaV; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2954d676f9dso28427095ad.0
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762278372; x=1762883172; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H0VNiWAjsdYdl3WJhMa7XY5d4qYfHVmup3jEU4PY9Ko=;
        b=O8YCkQaVyBTVgmZ69hk/Ntw8BmTzQPm8lnNTOQmaI/i/9BYhGTiS6/kO/eyq5tEP0W
         JGUd3uLVSJk4MWUU/8T0pni+fi2x52RzC8uY2YF3Dsy8tTKaInUFQtkc8LXARLP4Yrrn
         ZCVwYHw5RvcdTsYex0Le3SdbTnhCk0F6MYQ3RYaGZpCMrrskhALnaMeUiLR9l1//gEdq
         EVEeC0Kx1da8xAWgpgWOmobSsvEkdOtlGHYBfmCzayHi8m5n1o4km9wgBelHZdtzspgq
         YvBGSbJ250uta8u5eQeqbr7mtXZrCpyIVxY3AVaY+uYm/k62giCiZUp7/fB/GigYRv38
         ax5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278372; x=1762883172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H0VNiWAjsdYdl3WJhMa7XY5d4qYfHVmup3jEU4PY9Ko=;
        b=dLPs+aYcEyEz2Lt+vl5ZV8cLK3lsQMSc8+MbLzYtEQw88EraBSiRx1YfrO20Qxz601
         G2fRGB/ML4G99f7nq5pltqABLvNC7v9gXT1A0qvbXCDtHwSii9soFiVdwRK3Af2PxlaP
         p67m9vHxP4ttXVV8aw7AUVWvDjEifrbc2EQ8Bus8DbnU3QNhroCopfCSmZ7FFsCl3PXn
         mmSzO3u2K7hDJYDYdlIgYp0loWRVq+Zes1PtCtb6hDchyC7zweGLgyaRCxqmoLS+Dyeb
         EtFQ898JfOZWed7hwpKnABgYF+Fn421v/HS9hGn1v9sTXkLwN2M3Numzauc1r4jAjJ0F
         Jn7Q==
X-Gm-Message-State: AOJu0YyGVKM87M43/us3Bs7oN4t8EB5kQLSXwj/nb92ZOSrXmuU7XN67
	gCYaBHDJqR+XQGc6b1N8+7C0Q+jBrdBzhsOxKijrsPYJznUvaKGmPOrVoL+Nk5ZjpZL1dmT/64R
	dHRANFA==
X-Google-Smtp-Source: AGHT+IH/4RfaWZuPZrBPg1BQIo1EQLknH0ihFneDscbhHvDFB4mHizM2ii7GyfQACuJRrOjP8M7SvfZf+R0=
X-Received: from pldr17.prod.google.com ([2002:a17:903:4111:b0:27e:ed03:b5a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:94b:b0:295:8dbb:b3cd
 with SMTP id d9443c01a7336-2962adf009fmr5333595ad.27.1762278371863; Tue, 04
 Nov 2025 09:46:11 -0800 (PST)
Date: Tue,  4 Nov 2025 09:45:00 -0800
In-Reply-To: <20251030185802.3375059-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030185802.3375059-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1006.ga50a493c49-goog
Message-ID: <176227794415.3934259.3450243632077976793.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix an FPU+CET splat
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 30 Oct 2025 11:58:00 -0700, Sean Christopherson wrote:
> Fix a explosion found via syzkaller+KASAN where KVM attempts to "put" an
> FPU without first having loading the FPU.  The underlying problem is the
> ugly hack for dealing with INIT being processed during MP_STATE.
> 
> KVM needs to ensure the FPU state is resident in memory in order to clear
> MPX and CET state.  In most cases, INIT is emulated during KVM_RUN, and so
> KVM needs to put the FPU.  But for MP_STATE, the FPU doesn't need to be
> loaded, and so isn't.  Except when KVM predicts that the FPU will be
> unloaded.  CET enabling updated the "put" path but missed the prediction
> logic in MP_STATE.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/2] KVM: x86: Unload "FPU" state on INIT if and only if its currently in-use
      https://github.com/kvm-x86/linux/commit/8819a49f9ff8
[2/2] KVM: x86: Harden KVM against imbalanced load/put of guest FPU state
      https://github.com/kvm-x86/linux/commit/9bc610b6a2a7

--
https://github.com/kvm-x86/linux/tree/next

