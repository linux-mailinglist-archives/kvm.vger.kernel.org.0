Return-Path: <kvm+bounces-21580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90471930289
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:57:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B28B91C21102
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 23:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4B5136986;
	Fri, 12 Jul 2024 23:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gyqAPOKt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EF4133291
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 23:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720828628; cv=none; b=enDEjYa1nvrd4+OEx2LnZEsytndUtTHxfYZtYcK6zlyXbdVJZbiZTx0HpxPuvF129sRn6MlojgR65TYgIIBQHazkDAKeIJ/DFxgDiQpdUKUfrZEbE2D0PpFLqlzY4I4iFwwrstbX/K9xF6hnRe87CiYQBLrbBNnl0BK3ajD7Jkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720828628; c=relaxed/simple;
	bh=PPbs85Xr93LPkWh/ukScSpYJTvw+/60F8PPXDJV6wTk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W0FiWW4SByhh2UJ9BEOlXLAN8Mh/UWEhvWb6T6sZlqi/5qZq88GDcYDBGvnfgcmuwPlmWl3ZTuxBXtV70FQeMx0ABzpenHTj6c3dkZKwF3WJvW35x2mKrYl2kxLuXoJ/Dt0YvvKC07kxwHYLGJ+hWz9Dzr6N8Wc3r2c7wSn3chY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gyqAPOKt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fb168d630cso16364385ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720828626; x=1721433426; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iyA9y22et3aPVofN6lk67YcTJqeYEQiTdMNcp/wmhvw=;
        b=gyqAPOKtSPxy21aWvNUdf1hGdMIqvSoEzJjVeljuLyE7mkxZZd2Ds3Ry57r0O66mVO
         9wzKdUlwPC3dcYRZeApui5PzcoHAQQ+EscsNkKDJjgaHeXE02let6hIWz6KFuPjOr74r
         xupIkz+x/NpMEJKUg2e4CKKmKKVw7fZ55QMORlc5FxO+PaSK3pMj96PW9YD9OJwQpSXd
         kLZCzPQHFKxocEoSN3UY/UNg0HfGSlqpDMyPw5pxVAK056ZvcTIMNKyLytkEkqsOgFjO
         ZuipoJYrdeDd0QFuk9hKgOE9IuPqTZoxCeel1iEtzcni1T5UEzdhk0uhmW5NXyRZg5CC
         RDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720828626; x=1721433426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iyA9y22et3aPVofN6lk67YcTJqeYEQiTdMNcp/wmhvw=;
        b=rC9FpE1yqRpMYNmRgaR0J3t5ygv97hUHw+vqT8q7XvGX8qv1DgzP5amUbkaX+b1dU1
         ooxLhYro1tt7MCIJPCwvG9JCwwqNlxy7FO0gqU3yqEl9/eU/tfCAcAHa318OHUy426Bg
         eIpkfWx3CukTuKi0dSWgIcHtI+qtMS/zRu+Jiaj6Xg1ZJsEotPd0EtFvIpPShZIumAgp
         p8FbOPjnSExFRblW1k/cKV3Iic7GmpQlUHGDHfzehNMTrLTzIeQj0nP6ounlfXF7f0IZ
         pxd2WB+qqLxsj5FcddPih6ASj6gEzsxlGBGX/pZwnf8XYK1jeyIdyR0BctiVp41qBMXT
         yw5g==
X-Gm-Message-State: AOJu0YzRuw8XAiFZvfr//1ff7+m7KB/eN7HY/Cy9lO3oFX+Q1XpiAD90
	+7qQ804s1WAUwByvosfPU32/wonvyFAl4IZMHHKWmPpKLoRROI+U95Gl5zNlOqs2SN1WNaTvoOr
	8ig==
X-Google-Smtp-Source: AGHT+IF+0/8XomBseSBMK9G+u6kE65Tl8v0FbPTZLVI1QaezRaJexDr9SlJqqLHb0tJvQTQ9+A9QFXADn/w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da89:b0:1fb:90d7:a35a with SMTP id
 d9443c01a7336-1fbb6d66842mr8187915ad.11.1720828626343; Fri, 12 Jul 2024
 16:57:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jul 2024 16:56:51 -0700
In-Reply-To: <20240712235701.1458888-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712235701.1458888-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240712235701.1458888-2-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Single Xen fix for 6.10 or 6.11
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A one-off fix for KVM Xen.  This pull request is built on kvm/master, and
tagged somewhat ambiguously in case you deem it worthy of 6.10.

The following changes since commit dee67a94d4c6cbd05b8f6e1181498e94caa33334:

  Merge tag 'kvm-x86-fixes-6.10-rcN' of https://github.com/kvm-x86/linux into HEAD (2024-06-21 08:03:55 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.10-11

for you to fetch changes up to ebbdf37ce9abb597015fa85df6630ebfa7d0a97f:

  KVM: Validate hva in kvm_gpc_activate_hva() to fix __kvm_gpc_refresh() WARN (2024-06-28 08:31:46 -0700)

----------------------------------------------------------------
KVM Xen:

Fix a bug where KVM fails to check the validity of an incoming userspace
virtual address and tries to activate a gfn_to_pfn_cache with a kernel address.

----------------------------------------------------------------
Pei Li (1):
      KVM: Validate hva in kvm_gpc_activate_hva() to fix __kvm_gpc_refresh() WARN

 arch/x86/kvm/xen.c  | 2 +-
 virt/kvm/pfncache.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)


