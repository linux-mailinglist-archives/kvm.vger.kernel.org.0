Return-Path: <kvm+bounces-34950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41AB4A080DF
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:51:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00C74188434F
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F4C1FCCF3;
	Thu,  9 Jan 2025 19:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="13erquFF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FE11F8F08
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736452285; cv=none; b=bMiNhVVGW32p4e0IkykTMZuHM+IHyGVpN+GHbDzEPzeMnWZ2EGn4C0kTNVz9JGQHUpijWcAj3IFKzRK++Ko+m6I4+HESSmfQar3K0iWLZsU2N6aotWZKq0CptBqC0pqOpyNjsAhONoNhCIIX6cE3llYQgtvAGpc9nlGUOghFq3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736452285; c=relaxed/simple;
	bh=MdodIniv1E57aryMr3ZvoafrGD5cSo648TrJJMZCMSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q+6oHkl8pGSljA5gnnmIbphxBk/YgpMITP4z3KdH9gB71vokMlx+l09/qKWSVG4LxRzFr0uXL2d64vqHv+gsvZo8RfEFeiD4qeiuFdytrRlh7ucWViFIo9OEo2pQps7wfVJNxW2Igz2pIwUzyuI/8vvPFVc/If12uhSG9KesW9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=13erquFF; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21640607349so26875065ad.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736452283; x=1737057083; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P6s/398TzelSMmGJDSt9MXWMZ6WtDv11apSqpmsXFts=;
        b=13erquFFQihzSRvYfk8hSgbJolwrxIkQf8ylwsYpmoXNfZ9J5eNEBFww0Vt8NEZm8F
         wulEfJAwnnZeEnwFv7B7TJ0aRDjt79A6tuD4vEy1VrNeoOMIsjFGCZyrlpvuIOrnrRig
         VKh2oJvqU07NCm6xEK8Znk4wMTT/PmiMZlXuTx30i35iadVfOtTAG8SxX+/u9j0j08Gu
         bF/a4NMx8ay2O76HiDzDlOZexo6SOb2pvX6QNbyNTlkm1Xox6S9TEUCRHcGiVDYDeFz3
         HxKZV0E0XZlIR7aFCUtoGlzYS925PugA+U7yxMYHy2whTbxHcWpdDLhS/un06ckyR+Eq
         WDEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736452283; x=1737057083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P6s/398TzelSMmGJDSt9MXWMZ6WtDv11apSqpmsXFts=;
        b=aACwSJNjiEHqTIdWkhbCBF1Fc5kDbcT133eVAhPBNa1sAHLZPiJtk6aai28hFC5Te2
         HmV3G4GHyKF67BGTBxZWWwTDcAuKgrcJdzt9qyVDOrjC/vKI9yZWwCQv4fX8rpZo1/Vt
         HErJ1lBeuBDEcphIhSFiQMrEts97jRB2l3rG7wHdTr76eZanvyTMoeeodvfJ8ERFpO01
         9TfCBf7B6hI7SZZrkez33ZXXlAgd+DslrTcY/UNG3t2SO3H0qw1OntEiPhM03VrWY2T8
         kdu2Pvy2y3UUsoUdJR0368at4FhNMjQNBRGbRA2bzUOGKBgKrl9oVg76XfGRLm7oWIWA
         Shhw==
X-Gm-Message-State: AOJu0Yysi8gLdxBEXnRDuNa2y3kFXIQV99xFGBn5iVt1O0P9IrIfufh0
	rIGfYxdbBrNxM3BJB4ZoRrkZUCzPJwk+EN0iqkdpIfbK89L0dXcxOD0ithAhGAwol5+XoS8R4gG
	zGA==
X-Google-Smtp-Source: AGHT+IGTokLpYpcB3WqB1NOn/4yPGBLwh39ztD5jlILIvm08a89UWMzXWXUyfPiSyqXcG4HOAYyFgpLkdm4=
X-Received: from pgpt3.prod.google.com ([2002:a65:4083:0:b0:7fd:5739:a1e2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c890:b0:1e1:a647:8a3f
 with SMTP id adf61e73a8af0-1e88d1d5a8dmr14946790637.22.1736452283302; Thu, 09
 Jan 2025 11:51:23 -0800 (PST)
Date: Thu,  9 Jan 2025 11:47:23 -0800
In-Reply-To: <20250103153814.73903-1-gaoshiyuan@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250103153814.73903-1-gaoshiyuan@baidu.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173645183550.889475.2249096799180200711.b4-ty@google.com>
Subject: Re: [PATCH 1/1] KVM: VMX: Fix comment of handle_vmx_instruction
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, mingo@redhat.com, 
	dave.hansen@linux.intel.com, Gao Shiyuan <gaoshiyuan@baidu.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 03 Jan 2025 23:38:14 +0800, Gao Shiyuan wrote:
> There is no nested_vmx_setup function.

When referencing function, add parantheses, e.g. nested_vmx_setup(), so that it's
super obvious that you're talking about a function.

> It should be nested_vmx_hardware_setup overwrite the VMX emulate handler
> when nested=1.

Embarassingly, the comment was always wrong.  I added a paragraph to the changelog
to explain as much, e.g. so that we aren't as tempted to try and reword the comment
to avoid explicitly referencing function names so that it can't become stale.

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Fix comment of handle_vmx_instruction
      https://github.com/kvm-x86/linux/commit/4d141e444e26

--
https://github.com/kvm-x86/linux/tree/next

