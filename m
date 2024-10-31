Return-Path: <kvm+bounces-30229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D889B83BC
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:54:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A37C0B21BE0
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B101CCB4D;
	Thu, 31 Oct 2024 19:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bmvs2Agb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D751CC153
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404452; cv=none; b=IifCEBBEfj/yocmxgnic3cVztcpC8687pPF62RZrO6xdpRA+tS7NYD+1bj2X1JtyFL4danh7YWZh/ge9NEFvW6cHoixtHdiZLGgeUzFI70px91OsLvLKDg307r4Y4Gy8u6tVh9RlgzxXKLr28oQkx0lBEEuSO/EHuM7CcicDjOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404452; c=relaxed/simple;
	bh=vtNLCvHSOz5OW9Rj6pJW4QW9GRZQA42+oyDqraBAoo0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CRiCsKDb+FmGiLx4XuBAPooTB0zv5Ot316RqmFOwVSJG52l76Avzk6VEgFMH0YTpGMZSE9e4Zh8CCvl4fsoJdg0Ww51vKddWiyfUTenu+KSqbbti2AdFwQt105zNwS9IMeCUqiwOSUF9qRaQi8Sc1sm1Dbo+4ZzTmblX+wnI3wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bmvs2Agb; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-72065695191so1609834b3a.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404450; x=1731009250; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ao7m5UrdzMSA/gFts/DCaKr0oZLkSvtF6nXSbmAQ+u8=;
        b=bmvs2AgbCCgenXqyHGACyuMBQ/+nGVhf2uzMmNb2C2VG0tusBqbPOoO2rSPElidTF+
         yTdbp0DVHwHhvVvPSLyVAbf48jFLrSodUdJUOfHThNljHoxMnHc+itu8I/C4fBHm3VUJ
         eol6rGKIfPw2bMLkGAXMHLYmNquTuML0X9wTjZ0hILC0yvoLoMSVQ3XdOpkJmuVhwQrR
         TjWiprivU3IMpOBj0XkcjgqJKvflbtzI0+bWwyEZfppz6TqPjnbsVYYdGaM9N+5muSJi
         r8fjWHQlJ7ehvbfdY/NMlH5AmCWs26KVDhowXsgrpyGnfLuYvnO82k5zfL3QLnaVr4km
         8TRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404450; x=1731009250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ao7m5UrdzMSA/gFts/DCaKr0oZLkSvtF6nXSbmAQ+u8=;
        b=vcwLa0gtQtAIYcV9T1HSaQ+ViQAMmoYrubwgo/9Acs/TItDNBFV9c8hpPfgoF+CY+4
         YD3ZhcM5tWWyMI6y2E8bvmjfzVel9EdrxmOjSzeQLp5G1nco48BBJo1BNjS3usaMGwa9
         WEV8vN+hkdUcuR6WL4hbHUl9A1kI1OOb/21KPvt2296wW3aMhbqEeGptV9UAGt09BN1C
         jqvSP2mzjxrRJboTyLE64+eoSNe7pw4T3uZV/VafTmwz/TbCv3eKUr1ioI3G5pSjXAJP
         rxndioFLqONrFEUBaECbeR8Jlj/vRL5ZK2YdHVlG4G1pBYxlZnxMbuc2SzqkhJ0/r6ur
         UqdQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2ha4UsCDedAlhC/+pv086q0cAcVEg3/QuisCQ0ZG9ZqYoeq+lR60yd2IbfVIKc7WxvrI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz20ayphN0NnQiq/uMKjFBoDo29Mqa0TaYZBAO498JaM9QMBXJH
	UCG4xwab0Dp7eJ6w9qgSh88x1KeMlX7OzmeKkVfyWgDqDsl2BdSlnDvskKx7P0sTR1Rrv4fmFoH
	sPQ==
X-Google-Smtp-Source: AGHT+IGg9SZrqGC9nR5gnjnV1+lkFYdqvXhAliK/DvT9N0Afr2oLfQ1iaydUFMimjFf+NizW2H3rRsyiQRQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1414:b0:71e:5b2b:9918 with SMTP id
 d2e1a72fcca58-72062ed3f67mr54313b3a.1.1730404450178; Thu, 31 Oct 2024
 12:54:10 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:35 -0700
In-Reply-To: <cover.1728383775.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1728383775.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039499504.1507535.6500285672510733682.b4-ty@google.com>
Subject: Re: [PATCH 0/2] Fixup two comments
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 08 Oct 2024 23:45:12 +1300, Kai Huang wrote:
> Spotted two nit issues in two comments of the apicv code (if I got it
> right) which probably are worth fixing.
> 
> Kai Huang (2):
>   KVM: x86: Fix a comment inside kvm_vcpu_update_apicv()
>   KVM: x86: Fix a comment inside __kvm_set_or_clear_apicv_inhibit()
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/2] KVM: x86: Fix a comment inside kvm_vcpu_update_apicv()
      https://github.com/kvm-x86/linux/commit/e9e1cb4d5502
[2/2] KVM: x86: Fix a comment inside __kvm_set_or_clear_apicv_inhibit()
      https://github.com/kvm-x86/linux/commit/8eada24a8e83

--
https://github.com/kvm-x86/linux/tree/next

