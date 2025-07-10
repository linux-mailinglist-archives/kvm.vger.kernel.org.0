Return-Path: <kvm+bounces-52067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8ABB00F4B
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 01:09:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6BFF5C4CBB
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 23:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4AE42C15B5;
	Thu, 10 Jul 2025 23:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PLOacKNv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD242BEC4A
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 23:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752188971; cv=none; b=LbirO8GteSUj+l9T5L4RIZDBq/Ku+poIgWhRJZXLu0ILrLdpsGzPS/Ix4HGvdz7CxwD4GTKqLMw28fmkou1Wg1HUS3oM/QRfmPOB14K1tGPT1/jIF4qkZzdIrWHu+YPPjJMVk04QP0rHP2OjWxWUmOVC4tLaKB9H/VwYVhrqoXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752188971; c=relaxed/simple;
	bh=hPmoK18pg5iLY83A+rbNr0eXxFJUmHHV+34ar6KDHI8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PgdQdY1qE3quLGvoDQ9uZjfDOMVRvXwROTMC1ImoB5vbJpWC6eWOV7xtWbZoN2dvH4mWkg5zJd51qlPkt2+mtvszWEW0rvxM1gKRaYAOm7ZaOY7UC8aVAkMC5SlyLYVaB6w3sJZe9rRZpRGOUAArxGdlU+cMuXkIEHwbsLa4BIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PLOacKNv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313fb0ec33bso1447723a91.2
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 16:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752188969; x=1752793769; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pTOjUgZ+jlqnvf94jkmtcbiRBK+z9uxeasDSIpxLc3E=;
        b=PLOacKNvVTO5EX6BnPQtnbFFsJ3GjDr59eUiJ6Ri6nmA5aY+lOwUmzFwgn1mvkOAZY
         UtrLtTfAdFpV6ENFKPF4mETpWyq8Su3VzX9elREijDoDx1RgEGwOiA+CE72hfSFcWNbc
         deM5JeHhbIJ63PJt9BJmul/dXYSfma323pl2KjlCWNT6uESfHITz2PZXYzi/6OXmHQne
         SSSv6KBZqseA8kOYNl+LERTsIu/D12ZpEz0Suwlc4huDtPl/MJmN2VxHfhOiUn4oEe2Z
         3KSl8fYEZLMP3VUbWzRpL4nMKlxJwfnrTeEE+czOiGZivUY3mJExkc507jIJ3fwqn64r
         dDrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752188969; x=1752793769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pTOjUgZ+jlqnvf94jkmtcbiRBK+z9uxeasDSIpxLc3E=;
        b=is9BSE+VYdLws/3Gaxtn/zQrJswafz/pOTn9mICRfOwxTH6ZJKR5R4PB4v6l+d0E4T
         nSIpllWQE8ryNnBSGlzv/YSwRGqYS8g7zWjb1txIamyBgb93ZgP/16yKehrKOamfkkbg
         bGijpBFEEAYCWDVrpukwprdxVhWMh3IyjbjKRHwnXOcEMT2A4UzQMrFUOmLm0dJoqnrE
         dpz9DgcO1fVG1cGpf2lTDNdn2ghGD2PBXD0IWuOgOeRia5g0n5wW/ZDDp57CBunV2pxO
         LwEO5ZwqM6xAwdHE2QslxA95yWPb59MJ9a3LeJiLep3DPoNOHLnU7BD7x6sc5PzPoAXM
         Oz9Q==
X-Gm-Message-State: AOJu0YyiNMLEIN2IO9LL/UXgY0LQxIZfsdMPT+Ez5HKu2WydQPovHjqk
	mMayZBFwpyNJtTLIWLmdW6h8Z+WgYFxq23rRblPhCuIotPAzOIVLkkbpPm9cwsGF6hQHubEBBfI
	TH9NarA==
X-Google-Smtp-Source: AGHT+IE5qplA6OlFk8T7yH4h0UYvRJy0Sx+PveuccgpHAv26S7kZa5gKLhMTgKXx1QLGSTPoNXD53rWofSA=
X-Received: from pjblk18.prod.google.com ([2002:a17:90b:33d2:b0:31c:2fe4:33bc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e4f:b0:313:271a:af56
 with SMTP id 98e67ed59e1d1-31c4cdad83emr1515086a91.30.1752188969037; Thu, 10
 Jul 2025 16:09:29 -0700 (PDT)
Date: Thu, 10 Jul 2025 16:08:48 -0700
In-Reply-To: <20250710-kvm-selftests-eventfd-config-v1-1-78c276e4b80f@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250710-kvm-selftests-eventfd-config-v1-1-78c276e4b80f@kernel.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175218119916.1488306.933221879584328516.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Add CONFIG_EVENTFD for irqfd selftest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Mark Brown <broonie@kernel.org>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 10 Jul 2025 12:12:20 +0100, Mark Brown wrote:
> In 7e9b231c402a ("KVM: selftests: Add a KVM_IRQFD test to verify
> uniqueness requirements") we added a test for the newly added irqfd
> support but since this feature works with eventfds it won't work unless
> the kernel has been built wth eventfd support.  Add CONFIG_EVENTFD to
> the list of required options for the KVM selftests.
> 
> 
> [...]

Applied to kvm-x86 irqs, thanks!

[1/1] KVM: selftests: Add CONFIG_EVENTFD for irqfd selftest
      https://github.com/kvm-x86/linux/commit/81bf24f1ac77

--
https://github.com/kvm-x86/linux/tree/next

