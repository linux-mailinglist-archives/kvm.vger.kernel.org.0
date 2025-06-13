Return-Path: <kvm+bounces-49344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C15EEAD7FCC
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DDC41897C09
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4822B1C84D3;
	Fri, 13 Jun 2025 00:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HeNZTI3F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141FB191F8C
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 00:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749776040; cv=none; b=utJP63q+S1ajNpK9khcptpCzccjTQqobjIc2FpX1ywmpYkmCWdtR69biGVU7i72lTlhk6o920mR+hH8e5nna9BoFK2VunS6XL2oWXz6RK1qFLBrn+iH0Tseu5UGS5NSWoQ8UnT+qqXt5gdgNlvLHdgSG+J/RA0V6lzPS/GrITRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749776040; c=relaxed/simple;
	bh=/Q9h3H5ufPDxJ9IRGHfHjeJSiedw9DUTIyBbkfL9iQQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ciKBDo42b+d6ypzMhqzdQX1tKUjn8n6EpmgI6SfahqNvrzijqoKDawNMD9fzIi2YJ36TlRtJTg12ZzRSMJ7Ybnls8jLao6I7OVtHKqTE2REwbcq1Xlyyw1yxiLw3L4wTlS+J0CqZ5JBTIAq0Yv/gcBPfZZrey5l78E8cPZ08Gkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HeNZTI3F; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2fa1a84565so980793a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 17:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749776038; x=1750380838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7w4k58YWznvMshNuutdWHXlSrz7i5+GgLwpYq+uVRJo=;
        b=HeNZTI3FcRNUggEROCoJD2Ij1bCtKcisgBtlzLuxm7H4vhGAzsP4QYZ0q0m092mfkw
         +dZqPXWDnrips37yld2Xqob1iLgRZ3u2oC23/r1oeGtXwZ0sQEJeUkW6fKOQrJIWiSdL
         rOSO4QV6izfBc54AieeJ6KYRNcZx1Mivh/6dgl11Vywfx/DQxeucbEdwsNS8Ls2o53WU
         wbkbENxf3o6kY/BzpPb6cciBQROAow0X4UVnCNuSuGPDAS9Quek7t7dir0HnQLaM0VNG
         OTlWpgUperaDud2UHdGfI0TGmjgd2n8L8yCIms/QTul6wCW2aBiw8e3jZ0FoJPBLauQU
         a7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749776038; x=1750380838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7w4k58YWznvMshNuutdWHXlSrz7i5+GgLwpYq+uVRJo=;
        b=FY1QhQjx+qM8eXuDgqLVkCWX97m/G6oldrPUlDiKCAT8sr3WAKe9L42MyACWUzNWXC
         L94oDkyu9wHc8H+C3ImFMG4ig2Xc5BpJG8FpfuzCr7vhPzqWAJKpLM317aGv378ppxmZ
         BjDUINtFFVDZPl0MRr8Jg7GTAbgyPHFBRY7IqGlN5Nr6q1zQoIUKVly27af2SATxBVkq
         EycEAzqirCVUQnwaB0aVstxGGn6KUZ/gMmUXQzcUVkcHAXOPEoY/pWShi2xD4NH4U4Ck
         w355/Oj47XXZ7msFkgcu9n8bfmbfLJf97mAkmQXNDYK1m3KChqS8G1cFZvBehqnsll2M
         88Bg==
X-Forwarded-Encrypted: i=1; AJvYcCXkF3Vo5bLluTn02EFHAMPYu5iROjqr8uIViARiBtE3cwX82z3n2e+ONeop04xfT8c+lxg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuziPkJU1GLDdtKpDd8peoFpc4OEkJMBrZzOA9Ne3wwlAjr5r/
	JnEFYxqrRUgnaSNlpnxT70X92QhpUFjx4UFH9n/mJdQ6C5LHbKuozNtRQ4jydGNfo7XO7ZQrxb0
	GB4rIOg==
X-Google-Smtp-Source: AGHT+IF8Mo8opBC+4oS6SvfRC+Uv35PNMIQW6VHTy6RRYqEJO0V9Hwf1DFEODNFIFbIkKRwUONFfUilYd+w=
X-Received: from pgar23.prod.google.com ([2002:a05:6a02:2e97:b0:b2c:4a89:4b36])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:8093:b0:21a:e091:ac25
 with SMTP id adf61e73a8af0-21fac8e62b3mr995660637.6.1749776038391; Thu, 12
 Jun 2025 17:53:58 -0700 (PDT)
Date: Thu, 12 Jun 2025 17:53:56 -0700
In-Reply-To: <dd5fbd5bcc0e7ae9ac60a39a93ca8b747e5daeac.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com> <20250611213557.294358-8-seanjc@google.com>
 <dd5fbd5bcc0e7ae9ac60a39a93ca8b747e5daeac.camel@intel.com>
Message-ID: <aEt2pLgmIUuRJvDa@google.com>
Subject: Re: [PATCH v2 07/18] KVM: x86: Rename irqchip_kernel() to irqchip_full()
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 12, 2025, Kai Huang wrote:
> On Wed, 2025-06-11 at 14:35 -0700, Sean Christopherson wrote:
> > Rename irqchip_kernel() to irqchip_full(), as "kernel" is very ambiguous
> > due to the existence of split IRQ chip support, where only some of the
> > "irqchip" is in emulated by the kernel/KVM.  E.g. irqchip_kernel() often
> 
> "is in emulated" -> "is emulated".
> 
> Or did you mean:
> 
> "is emulated in the kernel/KVM"?

Heh, both?  I'll go with "is emulated".  IIRC, I was trying to choose between
the two options you listed, and didn't quite get the cleanup right.

