Return-Path: <kvm+bounces-55061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E276B2CFB7
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F1687BCA91
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0460327978D;
	Tue, 19 Aug 2025 23:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LYzAJuIz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18192765FB
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645365; cv=none; b=GYPKRehHASC+EP3ZGf7K9fER7SFhqpNtCaWhDpLmedkAcaNHp/QO6DVPLMlieR4JWEntG8Mhhxzuzie3d02DMsBjm9GZ2FGQ4ZnRAUEVGnyuvKi2Ylnv2xJnclXrkE+5O1uZJQ+C+1b7EMbZA0pynBC3fNwddsmlRRp5YBAM0pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645365; c=relaxed/simple;
	bh=t6zdWM2bsN7syimTNLlTh+lX9TIPmx5tJBfcvKP9gwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cxwygcpOw7sP9c21Uvx/gX9jSLDG/2Dl1xvhMf403JDd4Er7pLAz9LpoxbfrgqN7tOsX4otMTBezUdXuCEyTZg7nQQQh9hb6CaqlHawxsD1KNu1Aj4aixV/DJwx+oOISIilgFbicqrI5KqPZyi3VslVM4KyStEFPGDXQzed65C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LYzAJuIz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-323267b6c8eso12633090a91.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645363; x=1756250163; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gOCEj0Sd3vi45MPFSxHRHcrtxNDXmfbcmaod73l7pOI=;
        b=LYzAJuIz4WZZ+x7Zpfv4cBWO0wxEDM4sM1WdPUb9CyRrUOie4cvqTPJG9+lsKIEOzH
         z24val3nRGv6cyXTVoJnIu9N4KOxkn0GV4dn7nHiuPzpBYn0eZJcKOBCmPM6KlKEye9I
         8PApyaYF1RsvRlP9NfRr7Nt5qNQrhdUJAUcRmVS2lYn+/dzT4q22vEaExNDQvSh1gqWJ
         PEqE/bk+yxtltpYrNVTHoHGfykrPvyJknxVnXQZMNXWSsUdsQFYYa/HKFqLPG3IovRoG
         gkz1/gdmGvad01EOeC8I1cY7Z5BqZCdrzNY+6IbSKs4GZNyGQLXQK5YD01/am2lmEVM7
         Vm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645363; x=1756250163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gOCEj0Sd3vi45MPFSxHRHcrtxNDXmfbcmaod73l7pOI=;
        b=CBvBS4nLAeF8oQ2PHI/OPWIPo5qQ+KfUTv7Rbg4puehkFyugAyK8HfGD4yXO9N2rw2
         unJJhOG21Rx+U9n+oz5/oHJuY1manUWSnbefQRfpqfG1FzsYgZeonCScnBfpq+iZQeyP
         wXZ1yoVh/5D5eWPdyxspE4TFTvWHbKq1tJ7mBr4TF1DoTlrL2U+DCcWl8AinhvTYEBQS
         YsOHIIPll+Q6FJiHP1YMEFx5ExzBpOn84M2SBd+04wkOlfFab0QdNi6SCXHNCFJiIl4G
         fa65IfulyZ1EqGVXvowZVkuXxEiBiuCgIgIutVDKl9AwztZi7PC916Blnx2I8/1EKlBi
         48NA==
X-Forwarded-Encrypted: i=1; AJvYcCV3tSBHGa5ZlKRCsZeitX2ZEjYFHn8Xb4Ad45dfsnehUgE4Y9CSvaBPBi1oedgKcCRzBEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMbzf21A/oI95CiE335PA1IFsoCRRsmjNzoJ5sOmAct4EMCs1m
	pTcbCdtPsGQhpMA67wE1Pv8npXw+8uQ3iUoOtW2v7fi+5yUZS20j6Nhn4yWRwVJL1/j/JX5370U
	7c+TjmA==
X-Google-Smtp-Source: AGHT+IH55yKj/asM/dF5IW71P/4TSe9iUPcNLhQwqlGc+rTlfRaLoW9o/9bP72sbhNmd9zw32MuV7YFI3Co=
X-Received: from pjl11.prod.google.com ([2002:a17:90b:2f8b:b0:313:551:ac2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fc7:b0:323:7e81:7faa
 with SMTP id 98e67ed59e1d1-324e14557e7mr920085a91.36.1755645363192; Tue, 19
 Aug 2025 16:16:03 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:12:09 -0700
In-Reply-To: <20250707224720.4016504-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564472259.3066755.1319859221527663753.b4-ty@google.com>
Subject: Re: [PATCH v5 0/7] KVM: x86/mmu: Run TDP MMU NX huge page recovery
 under MMU read lock
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Houghton <jthoughton@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 07 Jul 2025 22:47:13 +0000, James Houghton wrote:
> I'm finishing off Vipin's NX huge page recovery optimization for the TDP
> MMU from last year. This is a respin on the series I sent a couple weeks
> ago, v4. Below is a mostly unchanged cover letter from v4.
> 
> NX huge page recovery can cause guest performance jitter, originally
> noticed with network tests in Windows guests. Please see Vipin's earlier
> performance results[1]. Below is some new data I have collected with the
> nx_huge_pages_perf_test that I've included with this series.
> 
> [...]

Applied 1-3 to kvm-x86 mmu, with the fixups described (hopefully I got 'em all)

Thanks!

[1/7] KVM: x86/mmu: Track TDP MMU NX huge pages separately
      https://github.com/kvm-x86/linux/commit/6777885605e1
[2/7] KVM: x86/mmu: Rename kvm_tdp_mmu_zap_sp() to better indicate its purpose
      https://github.com/kvm-x86/linux/commit/62105564226e
[3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU read lock
      https://github.com/kvm-x86/linux/commit/a57750909580

--
https://github.com/kvm-x86/linux/tree/next

