Return-Path: <kvm+bounces-34097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E6BD9F72C2
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2897160DCF
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4BB86327;
	Thu, 19 Dec 2024 02:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PkM2umIm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B394C98
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576060; cv=none; b=DaVTogguMfdhCLyWp43zOwtlKNAYAW694HAkxkcfAxjRZFpQ62HHe5YdUdfh4l/M3x2gOl85j2ifyaccbYevcL/1CONdCCxXVy7PzReu1wD+3m99klMg2ZBRGlOMzSUfZGykVwS6o/7NHb3TmX6w+pNTpogANPFXAn0fMhWStV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576060; c=relaxed/simple;
	bh=+DcBHZpNNqOm285hoPxcCIysOOvvqtDjFWcnC9l7Hxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j34wDlyRdXc6A32kIBmL+XkLtsaPJ1qVOlOt/iiCf8Vno8K87oX3gEpko/z0Df650XbutZGDjtTnnShBc4rrwUY3t3nD0+kdA+l9Us6e6r6N3JIiUdKP1TEdAHdKBYCNXU1CWDXsnh5iQnbz0xmdjCvaCbGgqKmFcOYST5ApsXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PkM2umIm; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2163dc0f5dbso3413595ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576057; x=1735180857; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3YyWPXzt5cEQ8LbwdPBgR5Uv3TNAW7IqFu7SoMnw0Mo=;
        b=PkM2umImkPYrGmwVjNA2vNfAEApjJbkZU1P6iZ2+gEu8bLlqIHk7BLoa6UgEWPzyQa
         6yELRzgDDTvHM2dz9QhTBAqmnOcj7vtnnA5eyaCOpD1jiMkCE2V7hVV/mEYQkJnWBSRt
         TU1g1ItgyCr8FhhUaFlzQ4+xnwygCfKo5rjwJzPzwjh7hTa8qnbXE5+8EYjJPHEDchQF
         gMI2YCRnwCIR+jAJD2pqL/VYbBzkE2EURyXQRSCyHfmTYqEKlF5ojXlHwdujD0i+4m8F
         ioAgLMFxmbk5qg0yQjMi88EGHwWoBH5LkfdcffZuWvvioswSEN67PMBLF7Swx6guYb+B
         JmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576057; x=1735180857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3YyWPXzt5cEQ8LbwdPBgR5Uv3TNAW7IqFu7SoMnw0Mo=;
        b=CBhz+gTW8h5qqAaR4pMaGAYAZvcyEN8mLjF2NcU6TRXcj+yx+3knYnCgiiSd3T3/y3
         iPlPxspkkeXRmjVNbnSSTmIsW5+Vrs/3tzJLdp6F5TVLEy6APU8alxCk07+24PY5PG9u
         7Nzl628odjTW54zo98Ylmz9dJQ1mZI3yMajTm1G30nCh7Ry3LSAkps8kpBBCKRYoWozc
         IKQIIcc8zMXR9UOiGZGl/2f60IlszN/WjnRwmAFOAi4RX3tBDxnnV0LZgw9OyqNfbtKs
         09J6iGJG4S1TaQNNpgn2/qOMCCExyvQcMKhP55lVrx6NxktgwI6lKhY8E6An3iFBDejQ
         HrXw==
X-Gm-Message-State: AOJu0YySx+fdQewU5cHbDd7o2IbqF41TBbmTQNePYHUbJSvTUz3eZHhU
	Ex29r4JgxHshJPFcDLyAYYpKzTEDKcF/zekJCZAZScquzUVT/bc+X2+mJk4czk36KvFSj1qfE8x
	ncw==
X-Google-Smtp-Source: AGHT+IFSqRB/jorPK12xjKa7nxtmU419TCJiC2zX6LV9UiMIGXIuBRRufnwUW0vpp/BvWMaUpKtuGFF6y+8=
X-Received: from plqw11.prod.google.com ([2002:a17:902:a70b:b0:216:1ebc:1f93])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f712:b0:216:59ed:1aa3
 with SMTP id d9443c01a7336-218d71030ddmr65136645ad.27.1734576057630; Wed, 18
 Dec 2024 18:40:57 -0800 (PST)
Date: Wed, 18 Dec 2024 18:40:38 -0800
In-Reply-To: <20241211172952.1477605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241211172952.1477605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457547595.3295170.16244454188182708227.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Simon Pilkington <simonp.git@mailbox.org>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 11 Dec 2024 09:29:52 -0800, Sean Christopherson wrote:
> Drop KVM's arbitrary behavior of making DE_CFG.LFENCE_SERIALIZE read-only
> for the guest, as rejecting writes can lead to guest crashes, e.g. Windows
> in particular doesn't gracefully handle unexpected #GPs on the WRMSR, and
> nothing in the AMD manuals suggests that LFENCE_SERIALIZE is read-only _if
> it exists_.
> 
> KVM only allows LFENCE_SERIALIZE to be set, by the guest or host, if the
> underlying CPU has X86_FEATURE_LFENCE_RDTSC, i.e. if LFENCE is guaranteed
> to be serializing.  So if the guest sets LFENCE_SERIALIZE, KVM will provide
> the desired/correct behavior without any additional action (the guest's
> value is never stuffed into hardware).  And having LFENCE be serializing
> even when it's not _required_ to be is a-ok from a functional perspective.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
      https://github.com/kvm-x86/linux/commit/2778c9a4687d

--
https://github.com/kvm-x86/linux/tree/next

