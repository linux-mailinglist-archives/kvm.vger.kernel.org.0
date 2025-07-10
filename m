Return-Path: <kvm+bounces-52066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45DE1B00F47
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 01:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDE4B542339
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 23:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1CD2C031B;
	Thu, 10 Jul 2025 23:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fbhICAJS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B659291142
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 23:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752188964; cv=none; b=MmheCYRTrBheJY41YLl995IqjClc7dpMvv8qfEzeim3XISwzbs5Hdww+ATKJo0x29PoOdfB28dEXLZxqhNkrlsrBsBMslFHKt1fnQq+t1OYHUlP25bsN6ogpVKB8Ig2vk0cCu3I8jKC2fJolGAefSpDelWRZ0GqqANp9/sJowP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752188964; c=relaxed/simple;
	bh=9lxY70yNwaUfxPRmm/LKZgcMGtuSY1GvdoO/acP8ucY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B2S7Y3OouL7KaNeUTdFAX4JNDUpGKD+F1Qr7epzBS0qJylpjWXLzGisl+50/qsz3GBOc7o9+wRndfhVfwxWdiS69YQhxPmMblDIj4lAlc6trVQNpTmCSYgL6g2sViTXKZSszSW3cOOoIi9Cw1QNAUF5XXkk4Z11sTyaK8JG/2BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fbhICAJS; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b00e4358a34so1070075a12.0
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 16:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752188963; x=1752793763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xt7t5G8OeVYwSzp5fzQ+a5eZavVGVQjGekilFzhtdwk=;
        b=fbhICAJSPYBT+z70CHdHJIicz7fz6948D5uj44a40rSaUHC/QPjHquG8VQQJZDYp6f
         cpvfiEMpi5i89MC9OhQx0yYv3XF6ej8qwVds3JkjrkQsftuFNbJriaz8b2IP2W2ek4rp
         SPBvSNGxPdWXJ8FuRUfrazvliPAOap4KZqYyb7Rw6roKM86VSYArKv3f4ZyfOGuw5498
         I3r77+xaXtzOf94gIlWBjYC6w0i62xTvbhxUuzOXpoUF5WIyOI3yvT6LrvtHeFBfuyaw
         5xal5QCb6iURnaSynXz8MhSfT2HC0ltyNIkTnmCvW0hVMI7ZFQP3tfbQNgVB1DbgFX5N
         NnFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752188963; x=1752793763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xt7t5G8OeVYwSzp5fzQ+a5eZavVGVQjGekilFzhtdwk=;
        b=sInniVuL+FgMJB37wDmr3cJOwWj0FGHBZ11ny7MSDuerlPC6EGFwaB1TOfqDPGjzO5
         c5GM56wcQYG8OJZ++9ZjeZ2V4biRP1tsZ78M0hh0YUCnwPn8l6Y3BOZ9R9ljdUMJpju1
         yshDmUd7IQJ1wJXotv4ETExQBtfi+ScrwvsPyeRBqDMP0VzomAJ5MjvxQ/nN9cQkbo18
         qDl1ZTRoIrcCwaFdeEJxv2vsGq/6Dp9LX6yfoOpnFl0n1CQuamNTeAPNzpUV1HOy5V7G
         erzpM0W4fQS+V5qjHp1sRf+CeZviG/ZNi+Ximj8sBEThzv6zKOwnNFbzL3/FinI1ckAE
         84DQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYpGgFd2f93VyJcSfcuCLZMy/knoqXP5Ue/ZnnjNYBXZGfv2qkaVqGntxqWOcfZDRHneY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLWy+L6axUnWbEw3imbSMBTTjvJciczu8lZ4+Tf/yu1y9K4txy
	D/fJhkwaicJAMqyBEj3EsgZxSmTWLoEmKGKd70QoAk8qRffePrdcgiRn/45pa7aFV10znugBIKx
	mB0e+Ug==
X-Google-Smtp-Source: AGHT+IHRG3Qs4CaTcbmVyBLUOQi3Rxi6ZHjB5Dwd9IWOeVhcwM8/7NxYvP5HPsj1sxTpjYfbwhDZxFmR8IU=
X-Received: from pjbqa3.prod.google.com ([2002:a17:90b:4fc3:b0:31c:2fe4:33b3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:514d:b0:31c:203f:cacd
 with SMTP id 98e67ed59e1d1-31c4f53f721mr446809a91.22.1752188962755; Thu, 10
 Jul 2025 16:09:22 -0700 (PDT)
Date: Thu, 10 Jul 2025 16:08:46 -0700
In-Reply-To: <20250701012536.1281367-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250701012536.1281367-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175218136095.1489449.11699515140849916042.b4-ty@google.com>
Subject: Re: [PATCH next] Documentation: KVM: Fix unexpected unindent warning
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Binbin Wu <binbin.wu@linux.intel.com>
Cc: sfr@canb.auug.org.au, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="utf-8"

On Tue, 01 Jul 2025 09:25:36 +0800, Binbin Wu wrote:
> Add proper indentations to bullet list item to resolve the warning:
> "Bullet list ends without a blank line; unexpected unindent."
> 
> Closes:https://lore.kernel.org/kvm/20250623162110.6e2f4241@canb.auug.org.au

Applied to kvm-x86 fixes, thanks!

[1/1] Documentation: KVM: Fix unexpected unindent warning
      https://github.com/kvm-x86/linux/commit/073b3eca08f9

--
https://github.com/kvm-x86/linux/tree/next

