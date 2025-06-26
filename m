Return-Path: <kvm+bounces-50851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E4DAEA2FE
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1309F4A8205
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 15:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2A32ECD16;
	Thu, 26 Jun 2025 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0TlJG0G2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295DD2EBBB8
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 15:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750953105; cv=none; b=bzOZn7JRvErKfv8+w+kttn+s7N0my2BanzqlNx+l6+8S43iucza5H6QXHUWQsi7kDhbna09QJa0GzJn4QBOwg9W4k3MFJEgFDCsOjF8LW3b48H4VnZkNfU1kh+8h7b5p2n6ODXQOVHp/W99eRLcbsrA4P6DibkfAjSZx9I7phxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750953105; c=relaxed/simple;
	bh=qXV8ywuWUNO49dqW9kDZJmUe/jHnv66YbBB23QyjjcQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RSWLFJgAwwdF1Zw9h4vD0du3ZkHKUOvojhqMT0c8PL1vuRJjSiZ7QDmwsKfnW4ydwGXUlwg96t5e3IOH6W/24bRQ4vG4Q20wEsZmpr46fqp5P1DrsmJlxlm0t8TtAck+ZDZF9bCJtAAl8p7tvojdUtz+9bxu9nhVk7xcRUbv6Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0TlJG0G2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so1123538a91.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 08:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750953103; x=1751557903; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6XW/EqCp3j1f6URWJ4aPoUkrvR+g0bF0hMVqo50f2oY=;
        b=0TlJG0G2Ulbt9WcYt+XBbiMec6yqrNNuUDH1ht3jWjzYS48U+nQ0A9JJT+kCd5GtJP
         qOMxVMEZvol2zU6B9h9SWtid971GM1XuCozTgkRC2KToxHV8WkoswBOQTLxi9Bn8IFTu
         AWd2YQwWsiagm37Es5aJ0mJV0tCnvoeppKyUctKZmHLfqkRsuvVzqZfrU8PytTB+qPS+
         nFANq6jrccPylwpDxHLPQyc25T7VaGGvmYJ5UDZVkKJRbcKTTIqfNZYmYj4jQ/hf1Wep
         Mfzw/eWruFsm2cD/uIBoRMFZNNgABTGsc3teBTRojpmCKYOodQ3MhOqd5d7H+VpCaH41
         qL9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750953103; x=1751557903;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6XW/EqCp3j1f6URWJ4aPoUkrvR+g0bF0hMVqo50f2oY=;
        b=hELb96tmORguJ3VCX8KkUEQzSD0ggp/FtOv1N/yDPTWINOGqtogFEAbOLAxhTd9Zil
         LqeMIcYaRFs7jYr02We4ff46sFopiRINlYtNlOqVPmS7NgeSdZRt7xvcegl1NJnD1rB+
         SEycXdkj7sjy6TZQYwq8slRt0RTYIgQQDpTfo1CqDNV9FuU104LzgNjFVPtn2UahfLI/
         kUPOChr8EkNkdPhAmtzfWC3X+X3Mz/qvjjqnsrPE3jpmIvYHR3AFgMztdKaUoyTKSHR9
         dj156q9Y5hXO8JN/jSD2u2aTY5eQ17uNT4VfAO3qBduiVsuJ5KERM5aWvmTxqQkTThRa
         hbCg==
X-Forwarded-Encrypted: i=1; AJvYcCUDm46xb2Ze94Lp+7THg4my9lnYB0FQijYWxZHGgRZp3ZKB732+3qar3juALXUGCcqYiyU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLXz9vI4jBibRcg7XGPwmmgX3Qxk/l7mL5PpZ/JMmJ2aMQ8vVD
	FloSfqJNs+MWQL20RcGDkDZ09o/M7qTrqd8iukzrwBErtmPDd/oSsA+q/K/FfHIO8yakbsZpJ01
	a14mn3Q==
X-Google-Smtp-Source: AGHT+IHC4Drqm7qwalhYbpaZ/EdYOOM+E4RS7ozoWgmrUjHrOdSo3e5wVygc5jxLIu3LTaQIMJLPkowy/94=
X-Received: from pjbso15.prod.google.com ([2002:a17:90b:1f8f:b0:313:274d:3007])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5210:b0:312:e9bd:5d37
 with SMTP id 98e67ed59e1d1-315f2613846mr10091013a91.6.1750953103423; Thu, 26
 Jun 2025 08:51:43 -0700 (PDT)
Date: Thu, 26 Jun 2025 08:51:41 -0700
In-Reply-To: <3e55fd58-1d1c-437a-9e0a-72ac92facbb5@intel.com>
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
 <3e55fd58-1d1c-437a-9e0a-72ac92facbb5@intel.com>
Message-ID: <aF1sjdV2UDEbAK2h@google.com>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, Chao Gao <chao.gao@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, Kai Huang <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 26, 2025, Dave Hansen wrote:
> On 6/26/25 02:25, kirill.shutemov@linux.intel.com wrote:
> >> Can we turn them into macros that make it super obvious they are checking if the
> >> error code *is* xyz?  E.g.
> >>
> >> #define IS_TDX_ERR_OPERAND_BUSY
> >> #define IS_TDX_ERR_OPERAND_INVALID
> >> #define IS_TDX_ERR_NO_ENTROPY
> >> #define IS_TDX_ERR_SW_ERROR
> >>>> As is, it's not at all clear that things like tdx_success() are
> >> simply checks, as opposed to commands.
> > I remember Dave explicitly asked for inline functions over macros
> > where possible.
> > 
> > Can we keep them as functions, but give the naming scheme you
> > proposing (but lowercase)?

I don't care about function versus macro, but I'd prefer uppercase.  As Linus
pointed out[*], upper vs. lower case is about the usage and semantics as much as
it's about whether or not the thingie is literally a macro vs. function.

[*] https://lore.kernel.org/all/CAHk-=whGWM50Qq3Dgha8ByU7t_dqvrCk3JFBSw2+X0KUAWuT1g@mail.gmail.com

> Macros versus function isn't super important. I think Sean was asking if
> we could do:
> 
> 	if (err == IS_TDX_ERR_OPERAND_BUSY)
> 		...
> 
> instead of:
> 
> 	if (tdx_operand_busy(err))
> 		...

No, I was thinking:

	if (IS_TDX_ERR_OPERAND_BUSY(err))

e.g. to so that it looks like IS_ERR(), which is a familiar pattern.

