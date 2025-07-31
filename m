Return-Path: <kvm+bounces-53816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73EDEB17A11
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 01:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 225F3586B59
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 23:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DBF28934A;
	Thu, 31 Jul 2025 23:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uKPRRf/T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AC5288CB6
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 23:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754004676; cv=none; b=EEjqqAyDav72vU26+yJiKqu5Fq/6XNWy8qeKyCSySxn82+2wOtUDeD5T4l6hHZCdFBGjZk8kRLG+/dwTh6raD9dk9c/yDt8BaAffQSHReoL7MkBKPnqn9RWttfO9ctCyYMbTYTRdYKBTGfT8IAC/fxb9/T3oo+3Hv2u+CqEQkdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754004676; c=relaxed/simple;
	bh=2NaScNcdaGcrj1b9CsW2e7a605w4dLrZuMpOBsYF0u8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ssJHFhYESiwl3geQM3vUcn8KTxgkrMVOin5AFt1CywfO+kuICjcDEkKBoxYVNTyEsX4yqH2VKsIi0UFJbk7dXhNW5nMKVc8wEaMhCrY6VAHgdw+3HZkK/+v6f+H/hQTKVRcmsIKBOe57KlDBDRWJ8HkjrljKx4TaUxOyAH7Y/6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uKPRRf/T; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23fc5b1c983so29447525ad.0
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 16:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754004675; x=1754609475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2NaScNcdaGcrj1b9CsW2e7a605w4dLrZuMpOBsYF0u8=;
        b=uKPRRf/T84txVo+TPHddoYsuYZS4+PQXNSrI0WHD+ZgXjG/oabPB0oMpGcc9g3rh3L
         Sblhc74/6P9JeUCumgsdH/8fZ0hv7Nx5pHj9WyZO3rLINCqrGEzsvzchxWsH0g8Hdaad
         CgefxOTYzRfQsK99+Cg5DrS7qYF1HFOV7BQrlhdi2mEf+5DVYlD/1DSRxchjKzYdZn8i
         +4kdwYKG8YUOK8gJL92D564UGjQxXkG/IOgItJiX6UKP2n8QbGHaaGQv7SgFreWBysTc
         IZb3rhUHOrObLdnk6y0Sst7pBaJO766jzoIfx+AJeJOm9rhQ9XZZiidAe3YB/mmVDB2w
         lIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004675; x=1754609475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2NaScNcdaGcrj1b9CsW2e7a605w4dLrZuMpOBsYF0u8=;
        b=ZBB8VJ89u+GZYRLq9m7bMLNSL3c5HcY4asNrw3CsPsSX1/+vlSg+3FmYQkMDL5STZG
         51wtP+MJREqG3HgrCuMPJDA2mJqlvkXDPUx7svyWVqFpT6O9buYjDvj16OvTWPHAS7tG
         5sBsNSv49F+Me3N8JoCb9Qhsd2X9z4EEcIeZ/GUIoUC2xGKm9IzDFoLk7td28GVQQuE0
         VWEIlgmEy0n7fU2SQgiJ+QK+i7CPxx9g4tsHqZIqoc073Wr7NrUZUmIoHUioQR6kOsXV
         RoNXUsqf8Z+OzM+R0xn9fZT+eNHdGAkI8qBi4gK2dep9vArBA3eMliwBHUPnmPLEmC8+
         ODJA==
X-Forwarded-Encrypted: i=1; AJvYcCXQMuRhLs84M73gZ6HgVaRah0f7A6vuH/mB7otVyvM0beIxiDR23YtxONjUpDb1cRqO3W0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrz+VnGGNq89b+KL+oTKlKNA149C0FrqoOFUQ3Al9w/sGDj+1I
	8SosQ68x5Nef9Ydo8n/f/Mnus6hWr87nWHQLAiTgKFdfI+32MXj+SeN/38/kPvgwruvEBD7y2go
	eiIbULQ==
X-Google-Smtp-Source: AGHT+IGryvmAT3lqluwhQwi1mQ7FX1BibAY6piThiCuH2qx4zB0PIPWm+u9AgX1LOvUYyklReyoB9RUyx2Y=
X-Received: from pji15.prod.google.com ([2002:a17:90b:3fcf:b0:311:ef56:7694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1cb:b0:23f:fa47:f933
 with SMTP id d9443c01a7336-24200a5a8aamr57745545ad.8.1754004674734; Thu, 31
 Jul 2025 16:31:14 -0700 (PDT)
Date: Thu, 31 Jul 2025 16:31:13 -0700
In-Reply-To: <70484aa1b553ca250d893f80b2687b5d915e5309.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-2-kirill.shutemov@linux.intel.com>
 <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com> <d897ab70d48be4508a8a9086de1ff3953041e063.camel@intel.com>
 <aFxpuRLYA2L6Qfsi@google.com> <vgk3ql5kcpmpsoxfw25hjcw4knyugszdaeqnzur6xl4qll73xy@xi7ttxlxot2r>
 <3e55fd58-1d1c-437a-9e0a-72ac92facbb5@intel.com> <aF1sjdV2UDEbAK2h@google.com>
 <1fbdfffa-ac43-419c-8d96-c5bb1bdac73f@intel.com> <70484aa1b553ca250d893f80b2687b5d915e5309.camel@intel.com>
Message-ID: <aIv8wZzs1oXDCXSU@google.com>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Chao Gao <chao.gao@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, 
	Kai Huang <kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 30, 2025, Rick P Edgecombe wrote:
> So STATUS_OPERAND_BUSY() seems like an ok thing to try next for v3 of this
> series at least. Unless anyone has any strong objections ahead of time.

Can you make it IS_TDX_STATUS_OPERAND_BUSY() so that it's obviously a check and
not a statement/value, and to scope it to TDX?

