Return-Path: <kvm+bounces-52515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE69B0627A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 17:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A434F3B0762
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E44B1214818;
	Tue, 15 Jul 2025 15:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iXdtKS72"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA32E1E834F
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 15:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592242; cv=none; b=u7WxiR9oedoPUZMK0TGDK3KyFKt+dxRFO5bNKQ1CIDpLL+evBIfK3LHJjLzgUpNf0Fh1xaDUJGRI+/fR5Wt3F/OyjhMQy5cbo61evIaMKbBU3nXkhm0dOUh7UOPSFV7r0r/Pvs/16KqYKPm3taZCkVwn4VZ7Fh2h4lkDYHduMV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592242; c=relaxed/simple;
	bh=4VggX2D7gPOxcgo1aao/mMvKRzUYIRe+bl1k2gkC6I4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IyOMja/cu1WfhPywpVcspnq+t6jgPloFgVA5DNEWY44PxYP4Thy+vma6cN2wG/k470cBB83VHEUx8RtvkQdxSG6Gi4WlUito/iCNvZanZYHllF192pL5WeSoIe4J/fhlAJAr1/Kh68WiuzoNzjDwf1bb/75gmPH1fL42ILVDbGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iXdtKS72; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74927be2ec0so8436410b3a.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 08:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752592240; x=1753197040; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ryg0XVXx/d3QRix1Y2kL+AIJsLkxuJ3xCLHGA+yS2Dg=;
        b=iXdtKS72tYAN4sQEw/9M1xIwgl+v7lEAQmPOn7KrlSNgDdc1Km7P4LNBBM6vidyq0m
         Tsxd8fMPOMSTmnzx4C6VRW3yFNKIg2eqT+ApVv40PhhTwnZfOYIdcFYW1vGXwT1BXWwn
         2d37ED9KKQdvk3ljXl7lT8VnFBlZhCOHFUZWOHmecnetwYE6pom8/Y9nZlAaFOVcF0BM
         w3N7QBJcZmaxZgB3YVADf0ogiI0A8abpRvd70AL9OI7g34qWkWEEqZdYpuOLZsP02N3/
         0Q7UDiwPXFZTeXk8NGbIcfN3oNVfU5LK39I5WC/9Vsorkd2BrZsayQL7BHJzqROWhnfV
         rHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752592240; x=1753197040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ryg0XVXx/d3QRix1Y2kL+AIJsLkxuJ3xCLHGA+yS2Dg=;
        b=ryFdloP/eKvdxRfdaXrvqgX7eXmdLx0WI/Vsdwt2Fty/tBA/Zv15iezp6MQ3uX0ZKu
         xkKLKYCey1/EXr6SgiYZQa09l9/7tdcyhaiVd0/3/mmf3m7Qk7I3pLBbDOvMbR7xa7eL
         UILc/yhZKm0R81hh+6CtreQJW7c6CVw3yZ3tbF/Xsb7XBsrN5l/UwNQRJSTqJyvD3ekj
         hGtBLJZJZEAhWPmN4b87Xcq2haxD+KfNHW0XhjbA/Sc3IMQSuHHdh2AwD31rIUg832Dm
         dS/DqY2wLKZnsV5R+rrKH/YCfUioQn7xp9RFh0Lkbm35z602A6H/qvHF5Abc/5J3uuGT
         nZzg==
X-Forwarded-Encrypted: i=1; AJvYcCVR+EnBpzbVjG7YdVtw50m8bRHi+KYxSSOX3xTgqxn+OhLrvjCPbrp1yCfAzw/ZmKQ6fBs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTctC6eGXIY2drFUD85181EZmH8lmzaKJKyDBigEH1eXBTVS07
	En6RK+ZWbywS6F+uS35A4zcM4q48AbHVi4hD68Y6GD6/TpUhiWkfnxR8QubRE1l2ZidSGffLx+i
	yAxH/og==
X-Google-Smtp-Source: AGHT+IE8AvoOdg4HoJ39XtR7Ju366xu15Xs/lxrGtWzcB0GyotBFu+SxAx156O4/XuUxhfBVnfRu+AiVvCM=
X-Received: from pfez19.prod.google.com ([2002:aa7:8893:0:b0:746:1fcb:a9cc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:813:b0:736:35d4:f03f
 with SMTP id d2e1a72fcca58-74ee09a9561mr24411992b3a.6.1752592239880; Tue, 15
 Jul 2025 08:10:39 -0700 (PDT)
Date: Tue, 15 Jul 2025 08:10:38 -0700
In-Reply-To: <20250715091312.563773-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715091312.563773-1-xiaoyao.li@intel.com>
Message-ID: <aHZvbok0tr7U4wf1@google.com>
Subject: Re: [PATCH v3 0/4] TDX: Clean up the definitions of TDX TD ATTRIBUTES
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Kirill A. Shutemov" <kas@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang <kai.huang@intel.com>, 
	binbin.wu@linux.intel.com, yan.y.zhao@intel.com, reinette.chatre@intel.com, 
	adrian.hunter@intel.com, tony.lindgren@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 15, 2025, Xiaoyao Li wrote:
> Xiaoyao Li (4):
>   x86/tdx: Fix the typo in TDX_ATTR_MIGRTABLE
>   KVM: TDX: Remove redundant definitions of TDX_TD_ATTR_*
>   x86/tdx: Rename TDX_ATTR_* to TDX_TD_ATTR_*
>   KVM: TDX: Rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_TD_ATTRS
> 
>  arch/x86/coco/tdx/debug.c         | 26 ++++++++--------
>  arch/x86/coco/tdx/tdx.c           |  8 ++---
>  arch/x86/include/asm/shared/tdx.h | 50 +++++++++++++++----------------
>  arch/x86/kvm/vmx/tdx.c            |  4 +--
>  arch/x86/kvm/vmx/tdx_arch.h       |  6 ----
>  5 files changed, 44 insertions(+), 50 deletions(-)

Acked-by: Sean Christopherson <seanjc@google.com>

