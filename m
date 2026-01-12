Return-Path: <kvm+bounces-67798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 51FB1D14713
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:43:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E05F43016205
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E779537BE8B;
	Mon, 12 Jan 2026 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bj8toxuJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192C7283FD8
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239583; cv=none; b=cAn6GwhcXhVslGz6uMmqqJDyvsdespDHZT8QwlGwPZdpGNd33t654lvBd8zy1eWbpFfmMetTzfWZxH3y1FKVm9NMHVNz2TUpIrnLV8jM/mWQW6aXFQpp7CwU5sxp0tzJaFWNJx38dQOYnFiBkUqTPGFazq2EDlxZFDbf1ROPMiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239583; c=relaxed/simple;
	bh=ud7E3JyfKtNeS9XbwbpACySiyHYX/osdjmtSmj/9fbc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tEYB9zdnYm3r7QvbL3PASlDTr1vUFQ1ADt7TChbf8/ef9cN4rM4WkulhhyU65JSAEndZGT5MFvvVHvIQ9c58BgVLvW1mf2koKFH/+u/PLDfVP93MVbVc2cCg/F9stbOD8jSgF4sx6mNK3gdvpZ8SK2XitIYthKO05JbnJYvgh48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bj8toxuJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34eb6589ed2so6989795a91.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239581; x=1768844381; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uLoZ69d2BhEfk6FG6qzqG+j7J29DwSqZa37fouhKsT4=;
        b=Bj8toxuJVa8WYk/5DJOy6TO1tbQLr5bHfri3uaYL5s8FJ+K5+hUzbmov0Z/GwgPE9o
         T1XuSsp9Npotq6I7WtlIuptegkb6caT7SMivsCvUPRS1XLll4X+NfcB4blNSS4RbbeiT
         vB41fG3gieGKsdiikqt7YfXd/xqpUoe6R76ulEXG1rmG/v4NWn8aLaScDQesIy9dcP7y
         NHNoTpXSMDEk1ygflsNJNJqhdw+gHl50dP54FSM4mpYBsqD4g4WWFVCxBJqMAkacXz3I
         oGSebvZ25hy1hZ7pr5BcTCWhaPLaKfL5k+RtiKRQQlbeyAUZOrO1ZUzTu4PA1eoQw40H
         USNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239581; x=1768844381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uLoZ69d2BhEfk6FG6qzqG+j7J29DwSqZa37fouhKsT4=;
        b=jjlffDlYTen5lPtrVairnLnjbG43xj8apctiG0kb0iaW0T5U9QVvSEA++VtuTfxCl/
         GJHesAs7YdmOrN8aZZ0x8+99tB8ujL+PNnJPta6oFJXGjosmN2quGxtb0bMlwaIxPM2Z
         g3j8tWM7S9mJ9u21vGQ2lFM00RFE9UPSyP+xcKJIIfzq+qfvJ+9jMQeUnBqMCFdP1ebD
         aQNmryEJJ2MC6IERUjZXiyHv3LFM3Xw5Jwk+44YJbt3xDqjHymxOwSHa742VmvyVOExm
         Blh5IzkFOaQzoAWMOMAtOvU3qH8VpbU/YYrEeAS2h4MjWedPw0VMmDm9nCMddiCfwjDS
         qsug==
X-Gm-Message-State: AOJu0YxSz156RNkDE8tsAblb9yQtn6mJiGy7zlzPhDUMwgZ42aicayLa
	ArxkY2Pcc7G/K7Bb2G+0FAIuHJotKFKWUbvx1zlYkT1xI8xJbPcEIRzq+iNPBdJBaQRW3Vg8OnU
	ib5jdsw==
X-Google-Smtp-Source: AGHT+IFUrOBrgUh1CxsPvcRzuutSfCbaaPL8yZ8SQzbWTVj7EMYH3TepTiXVByvAaKJFP/Xu5AfbOmDMzn8=
X-Received: from pjbfv11.prod.google.com ([2002:a17:90b:e8b:b0:34c:2f02:7f5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e0a:b0:34c:e5fc:faec
 with SMTP id 98e67ed59e1d1-34f68c3367fmr16127936a91.2.1768239581531; Mon, 12
 Jan 2026 09:39:41 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:36 -0800
In-Reply-To: <20251016235538.171962-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016235538.171962-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823892636.1370730.5324133186861069066.b4-ty@google.com>
Subject: Re: [PATCH] Documentation: KVM: Formalizing taking vcpu->mutex
 *outside* of kvm->slots_lock
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Thu, 16 Oct 2025 16:55:38 -0700, Sean Christopherson wrote:
> Explicitly document the ordering of vcpu->mutex being taken *outside* of
> kvm->slots_lock.  While extremely unintuitive, and arguably wrong, both
> arm64 and x86 have gained flows that take kvm->slots_lock inside of
> vcpu->mutex.  x86's kvm_inhibit_apic_access_page() is particularly
> nasty, as slots_lock is taken quite deep within KVM_RUN, i.e. simply
> swapping the ordering isn't an option.
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/1] Documentation: KVM: Formalizing taking vcpu->mutex *outside* of kvm->slots_lock
      https://github.com/kvm-x86/linux/commit/98333091750d

--
https://github.com/kvm-x86/linux/tree/next

