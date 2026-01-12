Return-Path: <kvm+bounces-67809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14118D14716
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:43:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 12B4C30A15AF
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6763B37F0E5;
	Mon, 12 Jan 2026 17:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ONQu/2IK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9211437E2F9
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239710; cv=none; b=Vp8lcAORiz3/AdWRiNWmvIj9WxxXdty2KBwOGdwKK2VpsqCR5D8ojr/W6T/10UHrAuDgfNROc+OF8eCSvOL7x0G+ewKXam8isO1zU31OugplonjnCW5Ucx3pghvKYgcPBBh/O+cnQ1rPeb1oxClDa7zCVEnygcSqTgC//iqq/jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239710; c=relaxed/simple;
	bh=IN9oPN1vXZbpcR2vz0Dd4fnZMUOOoYvfAM7Ab9jHc10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CYUfs/+FsyNfHTA2I0+ctMIx1Qz1nMgvg46RmuP1NOfOkl+gaUX2djub8NmpAwz8E5LJhgxKmIwijfGS6OUTFTy54AwFM36jCDl6+HgaoWfYWfJbzJ+F32rf8RaxR03Y29wKKrRP4tKJ2i8fuNI1lg6ojTYNgb+Cq8tBdt81nJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ONQu/2IK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c314af2d4so5415776a91.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239708; x=1768844508; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fjt02/b1VuBuSk+xDeFvO3JyVZAEhaBhrJ2tDPDu7dk=;
        b=ONQu/2IKyabFabqwfoNn7Gb/InAdCsQUbEjb6oekwNLF9LCQyVP72t57B5YN5+dsVu
         t6TGx+vkURc/V6NVcXVA1xeqimGqKM5i5kbtWAWspFb8B68ozbAkGrrCUFVBT9daVPM6
         5ws3DGOpUdH1qUeM+4d3S92dtNudy9MMDCiSgduz3HyJoz+jsA8t6WVoyc6HlXAuCPkO
         hGXGpvOTQH1xP3whbzHRReHZFyHQHhQCMMbrGHi9+H3w1lG+tC1rsgB8CZlA8Lea+nkJ
         1vtT70KiNPwYY0knghCd5f5++GgNVQU1fm4+5Yz0E1/U4vLnsDEcJ7Moj5U8s5GTwqMs
         8w5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239708; x=1768844508;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fjt02/b1VuBuSk+xDeFvO3JyVZAEhaBhrJ2tDPDu7dk=;
        b=vgRXAvUpW58VatkjJLupxENvO2xv5i1XnfxKjd5QmkvP9jFB8DIPh4iupaGEcK0eLn
         YLM6fLbE+1mHtLNzEPJ5jtcypTvs23BGRr8Mznpt57IIxGMpjYshB7jNScqfF+ITdzuG
         5NfSRZPaTU7+6ymg7BLFyIOCTh7IYVtjNNhDjWg8tDXSOdHnmb5W7tFTpTB3enak/XuT
         DpzBTf4Uuc+fvYolI711veRDFPRtQ/FmTfOOLAtKYTckSEsRJx21zPaIhpx9ZYW6NFbz
         IYVP+gT2DNJ2MqY9yQXbeEjTx9vSf5kILNtr82wyexRoYgNgDiy9dIXoKYJ+GSCaN6gs
         SxOA==
X-Gm-Message-State: AOJu0YzFNFNQyPrGQIAzZ1YJUeKl1PjqtQBXQcCGj0F+O1sG/YoulicU
	FMnLz2SXqA99RhDU4+tx7bhwn7QnttgCnD3FMFMb+hSDwneQsGMl2cVrK3qJBCQPv2/eiPKXsMU
	B99WO3Q==
X-Google-Smtp-Source: AGHT+IENKjcIdEGcGHg//2lKH4q3iFswDnPs/g3DnsXhOsWYIlrLK2upmufXPjIKKsi+UrYMKB0Kqrk/aug=
X-Received: from pjyj20.prod.google.com ([2002:a17:90a:e614:b0:34c:f8b8:349b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ecc:b0:340:bb56:79de
 with SMTP id 98e67ed59e1d1-34f68cddd79mr15903418a91.30.1768239708076; Mon, 12
 Jan 2026 09:41:48 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:58 -0800
In-Reply-To: <20251216161755.1775409-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251216161755.1775409-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823878206.1368770.15606306361125405997.b4-ty@google.com>
Subject: Re: [PATCH] KVM: nSVM: Remove a user-triggerable WARN on
 nested_svm_load_cr3() succeeding
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"

On Tue, 16 Dec 2025 08:17:54 -0800, Sean Christopherson wrote:
> Drop the WARN in svm_set_nested_state() on nested_svm_load_cr3() failing
> as it is trivially easy to trigger from userspace by modifying CPUID after
> loading CR3.  E.g. modifying the state restoration selftest like so:
> 
>   --- tools/testing/selftests/kvm/x86/state_test.c
>   +++ tools/testing/selftests/kvm/x86/state_test.c
>   @@ -280,7 +280,16 @@ int main(int argc, char *argv[])
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: nSVM: Remove a user-triggerable WARN on nested_svm_load_cr3() succeeding
      https://github.com/kvm-x86/linux/commit/fc3ba56385d0

--
https://github.com/kvm-x86/linux/tree/next

