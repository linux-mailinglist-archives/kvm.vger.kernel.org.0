Return-Path: <kvm+bounces-16194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A218B63DF
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 22:53:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA83E2872E6
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 20:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D68A178CE7;
	Mon, 29 Apr 2024 20:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FZpvgPwX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741111E886
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 20:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714423977; cv=none; b=Pn2BYhOTvqPs5epz4BcMUrXg3bYhg4KVWlXw9NEG1/r48Ni51zSOQxs7QEkRSRarNJ3QXXkiejJWMJtKtgtHe3iNX4N9rDgRB9GhkGzpodpbm9+1AfyfCtt3qwdsPp8/7zpp6x0kIgfaBUb4NlYk3VU1o1LbmF9d6NmDtFfp0dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714423977; c=relaxed/simple;
	bh=UpUN2rwjLf659AcafVLpWvlNcu6x9dCG2IlXIBX+s+g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oEXggOU+E5wrwC1sy+xXs+UonXKDopnQHHOt49DW9jvBg7BOT5aC5S5sw/PPEW6/1z3GNPZ5uFgYCKx1Xgx5L9qSyWnefpjNUIuU23FU1V7Bd3j54HrVZXPQQJU/WEIGPJlvMfHQlFajam7E+w20C5lF8so9pkxKUyS482YSlKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FZpvgPwX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2abc5b4f3c7so5635101a91.0
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 13:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714423975; x=1715028775; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eS9bDnNYR0i7bDleN6uI0tYnAF3Eg0gr8512SJl4Pd8=;
        b=FZpvgPwXbXXuDcfyLHBbSuaef+BKOURxur3wgh6OI+1W4o1zCGgHmbcRXMN9qdizhN
         X6ohK1kP+0v3wEUw6yo4pAnCpVcSQA9SCk+L8gkbjzaKcybEB77cYP7AXWGq5dUtgGLQ
         Yd/gPGTUqmYK83HqcYdgqPrQWAOkdMFZm0HP2hC0HPFoJainGSvQHwvhKZKI+QPRG0QX
         1hg+y9L6X4BshqYEzjY549fJinuH13aTfNG0UIg9IzoF+TnJyL6uEJqhPBVrwFp8uNOU
         DLMOFFu05qTiOFiA3sFTsWsPtyrLwstOZ2dDWKK5RV2djLaeOcye9z4EHwNQLGaV7gcZ
         xd5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714423975; x=1715028775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eS9bDnNYR0i7bDleN6uI0tYnAF3Eg0gr8512SJl4Pd8=;
        b=sHo+X6+/68hEHRqJqSytGMa8GnYPRBR6EOp2nWwGbVtafxDp6zqHGzMQsSRx/p8xFZ
         N+wiGcMuhif92AH28rliVCenRh79zyM2d/XoBUw0GF+eu+HMlGB3mbE8qATOE4GyGi/m
         oXZ54oHMtAfDFytqmTQfKDQzJArKBRzizOc+kxk2fAY/zvkDxrIeFM1207CmstCB/Jsc
         AACYAJ/3PiwoBEz+/3n/PyzBjpSWRO5/z6mSJdOGKJ1+wKcSgZlyBDSn46F1JEDxp6YF
         oDb6oyFnEvNrgS/Ve/N2E/LEmwg7iInv4876feAo9fC3XR0qBqH3L9deVY7YuwMwynWO
         XwCA==
X-Gm-Message-State: AOJu0YzKTJDCeDn2/xb6rBDH26T7JDTQC08QnVaablUbuB8ettEiFvrN
	NiJsn7IvmqNkSnkhqlBPCbQHpjV1fu0mPINFVvjh+ZJgAMyvEoqrErHSy3xWOi6VPqcDQCRB+Or
	9OA==
X-Google-Smtp-Source: AGHT+IHTY5xUolNNOP6k40P/rJk1g/KMaLEHKLUM2u8kGshvCzzPYWYeuVGenmRNekiVuKGsgfB/AAzStbo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4617:b0:2b1:6447:32df with SMTP id
 w23-20020a17090a461700b002b1644732dfmr14064pjg.4.1714423974848; Mon, 29 Apr
 2024 13:52:54 -0700 (PDT)
Date: Mon, 29 Apr 2024 13:45:19 -0700
In-Reply-To: <20240415-kvm-selftests-no-sudo-v1-1-95153ad5f470@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240415-kvm-selftests-no-sudo-v1-1-95153ad5f470@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <171441964028.77008.6546831449113890396.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Avoid assuming "sudo" exists
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Brendan Jackman <jackmanb@google.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 15 Apr 2024 14:43:54 +0000, Brendan Jackman wrote:
> I ran into a failure running this test on a minimal rootfs.
> 
> Can be fixed by just skipping the "sudo" in case we are already root.

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Avoid assuming "sudo" exists
      https://github.com/kvm-x86/linux/commit/0540193614eb

--
https://github.com/kvm-x86/linux/tree/next

