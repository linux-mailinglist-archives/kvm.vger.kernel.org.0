Return-Path: <kvm+bounces-30233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 206889B83CB
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF6D71F22693
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D6A1CEEB0;
	Thu, 31 Oct 2024 19:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k3he1NXT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526C31CC89A
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404511; cv=none; b=f4YJUZIgmePAizO71NzA4GGJNHIm5M1I2/YleGGZ2Er6BZXRl84UoStMUyuE0igVpr8zz2T9O35fSpDpT1PMjKLM5vZaSim173wcjpAenxK7romLNy5HqMNLbLKZqU7ibQKWUIcIeAmCTNVCK3ImM7esCLgCX9EB0avOpwE1THw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404511; c=relaxed/simple;
	bh=tnRFYQsiNKJRRAJpeqTO7/ZYdjCKlIkedKEGMns0Rpw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=thW2cU4/XTCiVQggbT7CbmjZw0lyg181DDdViE/XNtm9BKAeGr20YjB+uVsZvtNsoYmGk1ubUg6HItFBSaZTIMdzayh/o+XtP8feocKKSEmieeSr4rmaH8BtCnWo0fDWDLu8KaaH88a+e2gl0uWIiOGUvjnj/tP1+uI/V9tAt+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k3he1NXT; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02b5792baaso2238963276.2
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404508; x=1731009308; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wyzFnHlxzBwqMD4Ozvjay5ZNMPU7sJsmztOxAT9avE4=;
        b=k3he1NXTEW/koC7lJ9+q6mpmgMjn59nL4LzpIIsX/ndjBv5mUxoGRk5+0NBFxIWmaF
         uITLSEklaV482eeROFCL8LLzwwikXfYI+NM+jQ6mmMBRYh5w0gOEmAVqpSrA9zi8wiee
         LiUyI57u6+mi6KplBtTap7AT3T4+hIsA3lAS8LKfCWAu2JNGouhWJ3sVsUXjK1zk/Qxp
         9TdegL2vyo+BnHpLNQoGjmPSc551IGpqX4WsGuGN62K+dwC0DWuiOdGYp88FCrwsBfCC
         3hSIAU20oJAKlIw62sqFrhR1DLxkdYCiRPYmMnNJC0A1wTSz26CStMuDPbw1fzck+ZMp
         SPOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404508; x=1731009308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wyzFnHlxzBwqMD4Ozvjay5ZNMPU7sJsmztOxAT9avE4=;
        b=tBzK1w+Nylg0WZcQGEDDBH/0e2H1rJQ/rDnH7i4xRmMU0KlijC09yztuzNytIl2rfe
         9WAIdCpByaz6zH1+sxRpM5BQ6XJ6lDRtxz1/lgycoQaAUrmW2rxME7ArHdFqtMuB7pE+
         xSBKcMYsRGTVCNeNC4YVu4b8nXyQWB0O4NRbCfpyBWRk53sIf40luCggR810AFD65q0K
         2Jd8vo4S0mD+kbWTWiYzJCDrk8m9Q+wDUubFlPWxujNcmvWxhRyG1qwpuzCX3nEUmcJU
         qv1w0lF3On8+9TiUZGj9RkBx0BFb3oBu6gQr4GliRdFZoL17nAazMn8m+ihxO6n6CZua
         cjJQ==
X-Gm-Message-State: AOJu0YwZi4P6qdp4R4pMdbNejSrEoXB1vetFl3NrzGPAd8uzG+gmEJzf
	MoYDhZ/mb2IJ4PhiMzjmwyIULJvvySIhep+CHgxIPeO5Hm5kJSveDZQDifsXcmQaA/WdIgoRhGa
	ZrA==
X-Google-Smtp-Source: AGHT+IGs9TTObWInmuio3rurJ5t64zcQFKVLX6LflIOytK2a8hqQCUBCeAzAMfYBYfs+MNCxmHQ+TrGz7CQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:c78c:0:b0:e30:cdd0:fc0e with SMTP id
 3f1490d57ef6-e30cdd182bamr16577276.5.1730404508254; Thu, 31 Oct 2024 12:55:08
 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:44 -0700
In-Reply-To: <20240828232013.768446-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240828232013.768446-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039505425.1508775.86255062373291663.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Ensure vcpu->mode is loaded from memory in kvm_vcpu_exit_request()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 28 Aug 2024 16:20:13 -0700, Sean Christopherson wrote:
> Wrap kvm_vcpu_exit_request()'s load of vcpu->mode with READ_ONCE() to
> ensure the variable is re-loaded from memory, as there is no guarantee the
> caller provides the necessary annotations to ensure KVM sees a fresh value,
> e.g. the VM-Exit fastpath could theoretically reuse the pre-VM-Enter value.

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Ensure vcpu->mode is loaded from memory in kvm_vcpu_exit_request()
      https://github.com/kvm-x86/linux/commit/ba50bb4a9fb5

--
https://github.com/kvm-x86/linux/tree/next

