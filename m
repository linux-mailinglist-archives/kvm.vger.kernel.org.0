Return-Path: <kvm+bounces-27313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B90DF97EFBC
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 19:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F5C2B20D47
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 17:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EEF419F138;
	Mon, 23 Sep 2024 17:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1lh51dFR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C5019E99B
	for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 17:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727111097; cv=none; b=TWaJso2my7d54XP18mTuCim919OJpLsxnid8XIwL81z/Hx5tWbNfYQ47jISK4fvSAKBt6m18VY1d8DSEQ9LlyQgMInC4eXCLTyGA6LM6yFvgccl9fw1eKkhkHWo4QL5ZR6ZQzvubARbayIm/c+OSTaFHidD/QlCYWLoPaYfOan0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727111097; c=relaxed/simple;
	bh=vJbtWKItKqWE14H3NBVh/niuTdcSm9we5iEkrkOBEac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ltLZT3wBb+cruA0rwMSpQk8tyqC1yOAMQltw5ZiXE+/lOmAnCDxaNHwtsOj6sZA55ERwo4JG3psZWFjyXz8VaiX84k10tDawPJw4kYo0n+JHTs3DPQPzc1A6OrTOznD0zEKzvokjVi1abaJ7uPEHGiuypiiHXlRet8Qglec1M5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1lh51dFR; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-719918ba482so3425070b3a.1
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 10:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727111095; x=1727715895; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0LTC4QqKWucxBxnk1ZrnUFF7oEi+VhIK6z7a3jLf3KE=;
        b=1lh51dFRBOCPVwpfUnOQMu53PXfEZ1yoG6AD8RODpHlRqc8xusjrfPdFJukDYMMg0Y
         w0fvGlogUtjfFxbsZgfeBsu0OskjjnnwLRRiuPCmbIgTS+4Qpy5R7BEz467KaGQXNx8C
         IhOXNCotukd1+t14ItEKgVTBRYvWRAT+NyBby1hWp/OluFE+GjD5wpWcvNImh/ZRk44C
         FpVLXtcvJ1cm/wN4bfb85D9nuqOBuRgY/UzB0tGsfuG0sPmtu9yW2eyFDJgc6PYPtCMk
         /qC/BUVRTLPLqoPsDFWo8eM5T+jtbO9KznoJrqSyZyFpvq9Oqgh+jm1Lw7OpcMku/REZ
         EjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727111095; x=1727715895;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0LTC4QqKWucxBxnk1ZrnUFF7oEi+VhIK6z7a3jLf3KE=;
        b=bIp4K4XqmzGwauB+O9+dco4x8+XD2wuH12jAuDHFraDqFfXJp1P70iQU1DnfpAVo3C
         0oWw+ExEtDPXa0uljpwvR2uKImkucogb3t2b/tdBHwR+Q/8yQBpezHUQr+Vw/5Bgd2L0
         K2AlWYP4EuDdrdENW4uhl6c3gxOKVvA8sn830j2aLb508MBK+ggFCUjqKy3rCJZ+MW5b
         A5gFtoppXwSFBhqUBu6rkxtqYmys9Rq+d2a4156T5E4I1Ol3WEqO8u76Sh8TSDpTnA2d
         cVO/La8WCoYvIbP6vXsrK8dnhaA8g6UHXL0Q1hHMy/0emGXt6aQkjXBPmx+N20qIZbup
         3Wrg==
X-Forwarded-Encrypted: i=1; AJvYcCWJls8JYIHqzusFkqyEa65cy+Dh5R+2vRiXPWxAVYgw9u25BTi26MBig/UdYxBWC+MHfdE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxS4UNs9TEuRmkPPe8uMP4uV9Isp7TdP0yNKledqQFjS4yDKbYR
	hbIctHAHcpt1BR/gaYaBuA7teJpJfL4cEZiTy9QfpExdXPnbb0jqTFtxmbpVEiJY84kjM0Tm/Cv
	8rg==
X-Google-Smtp-Source: AGHT+IGIWxxwhZLXYVP88tODSZuBGhUt9N+COq1mKE0YgBtKzP2xBkCYCTi8v8lqsj5RFPeLr3njweGVXgo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1d0a:b0:718:de57:dd29 with SMTP id
 d2e1a72fcca58-71afa20c38amr561b3a.3.1727111095079; Mon, 23 Sep 2024 10:04:55
 -0700 (PDT)
Date: Mon, 23 Sep 2024 10:04:28 -0700
In-Reply-To: <20240923141810.76331-1-iorlov@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240923141810.76331-1-iorlov@amazon.com>
Message-ID: <ZvGfnARMqZS0mkg-@google.com>
Subject: Re: [PATCH 0/4] Process some MMIO-related errors without KVM exit
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <iorlov@amazon.com>
Cc: hpa@zytor.com, bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, 
	jalliste@amazon.com, nh-open-source@amazon.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 23, 2024, Ivan Orlov wrote:
> Currently, KVM may return a variety of internal errors to VMM when
> accessing MMIO, and some of them could be gracefully handled on the KVM
> level instead. Moreover, some of the MMIO-related errors are handled
> differently in VMX in comparison with SVM, which produces certain
> inconsistency and should be fixed. This patch series introduces
> KVM-level handling for the following situations:
> 
> 1) Guest is accessing MMIO during event delivery: triple fault instead
> of internal error on VMX and infinite loop on SVM
> 
> 2) Guest fetches an instruction from MMIO: inject #UD and resume guest
> execution without internal error

No.  This is not architectural behavior.  It's not even remotely close to
architectural behavior.  KVM's behavior isn't great, but making up _guest visible_
behavior is not going to happen.

