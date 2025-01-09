Return-Path: <kvm+bounces-34949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F12CA080DD
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:51:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50981188BA70
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F651D5AAC;
	Thu,  9 Jan 2025 19:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QzgVOYTQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CB21369A8
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736452274; cv=none; b=LpwLyDzb8URQy2YL10859rR7zf7xt7gOp4LMEURHFvVdoWBKhUR2VrTdHFTnPHzywUXKqmUFKfF6/S/FJNimRMgD+mNOL7bXyCgwOPZeUxpG3MslffPUfBNxVDRBvoyLn5LLS2fcHspnhOktalYVrVCG24rle2A3qIoMY9kRnZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736452274; c=relaxed/simple;
	bh=59Kf6+9iHujWqGctn8tshp/+Ti5aIhScybbzNjywegg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PguelNcfvpRu7whyY5duhH4CgbYA3pgIFE0S/OvvxElJ3PElH6bXxi3UaXZlCUVH1tX25vQbMdYpj69/+exm03xhR74ZuBHf+wEgrT/sxYrwDuXorUgY5X3+b9JALYB05TWvgLQtiAKC3yvSided5CIIg0crjBL1KBXQj990jho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QzgVOYTQ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2166464e236so36729615ad.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736452272; x=1737057072; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EvPG0G6xKcg0MqMzcRlcJeOjrQih65ooq8F4nj7UQQo=;
        b=QzgVOYTQisbTlTVMmQvZAki+h+ncPTtDXu/hrvqiUp1K1AunVSnEU3lqnjvN+NfLJq
         /4ECKg/sLsROrH11cIN2Bu4Ouk5GT/pswpAVPQkvjvvbTTJ1VbgP3reSpPQAWyahvc4+
         Sh/x2tzuTBS8h8rbIsitn6KZLq9j56tlvlyo9nBMApWoMUKr285vdgtYArH5T4qJQYvJ
         5XcJ+G3KQWWU8uQvTAyLBN/4F3s/8OYR4PvCGVBlJP2cYAPxEW65LCBXATw2APtWYBYb
         wJCdJxZ8AAZgZ+BIoGE5ykjtDhhNYUtaBJTLCtdbWC/tZ2bhb4EpIplML5j/H7+H1lFn
         OWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736452272; x=1737057072;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EvPG0G6xKcg0MqMzcRlcJeOjrQih65ooq8F4nj7UQQo=;
        b=g7w1DobG9Z5tzv0k114lFyjyYEe4RMBvPRDh+y0cCLiCp3N5/jwfMFG34UaLqNmSU2
         y1SeJG7Ndlet4MNLCL5qMkm3TNuL020rqrHnEea3/T9QAAP70zEkvkqjOd6YgsOpD1r0
         dID3JdwRyQUKtzqf3jGeqj9JYJwyFNdiUiL8ZhW8QUSK3dXtV/XPogFW0NYWVPnreWO/
         UZX73N6W6Eocl99Ia2cBUFtFeZ2UcxYF9Z/mrl9jA3GCGNqLbSuCi1+FTUPyD72EzttG
         TwFa1ciqJyC18VFqtiluFAaQ0ZK36FgHnA5fPDK10D8LsvcgPCFQwK4jvTiY0rafnhJh
         85HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCOupGgXARFTKIcKWlSCfnEG5Fhp8smdfh6oA+K93zfx/Ymm+cV+dJZ3+oxeJJmiOE5Uc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBf0knOdGe/61Uggv6iaFLtmuy1X9m2td5VXCjPmkiOLE0eygX
	V0ocZUPcm1vOxVQ7jtjsFs/XkU1nO/WIkslk/2IWGju4hoWCe0xTIry86M1N4CmT0bEc+saFz1l
	C+A==
X-Google-Smtp-Source: AGHT+IG7ANgsCvabmL6+miyctYRU7rbNdH5/lzRmjbrNPiz77Fdh18Ta8lKqNezxbuLI/0vR/j0Hf8oacAc=
X-Received: from plox12.prod.google.com ([2002:a17:902:8ecc:b0:216:3737:abb8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f68b:b0:216:32c4:f807
 with SMTP id d9443c01a7336-21a83fdea82mr118602615ad.45.1736452272036; Thu, 09
 Jan 2025 11:51:12 -0800 (PST)
Date: Thu,  9 Jan 2025 11:47:21 -0800
In-Reply-To: <20250102154050.2403-1-costas.argyris@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250102154050.2403-1-costas.argyris@amd.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173645181620.889176.12566428191805200464.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Reinstate __exit attribute for vmx_exit
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, KVM <kvm@vger.kernel.org>, 
	Costas Argyris <costas.argyris@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 02 Jan 2025 15:40:50 +0000, Costas Argyris wrote:
> Commit a7b9020b06ec ("x86/l1tf: Handle EPT disabled state proper",
> 2018-07-13) dropped the "__exit" attribute from vmx_exit because

Uber nit, the preferred format for referencing commits is:

  a7b9020b06ec ("x86/l1tf: Handle EPT disabled state proper")

> vmx_init was changed to call vmx_exit.
> 
> However, commit e32b120071ea (KVM: VMX: Do _all_ initialization
> before exposing /dev/kvm to userspace, 2022-11-30) changed vmx_init
> to call __vmx_exit instead of vmx_exit. This made it possible to
> mark vmx_exit as "__exit" again, as it originally was, and enjoy
> the benefits that it provides (the function can be discarded from
> memory in situations where it cannot be called, like the module
> being built-in or module unloading being disabled in the kernel).
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Reinstate __exit attribute for vmx_exit
      https://github.com/kvm-x86/linux/commit/b5fd06847320

--
https://github.com/kvm-x86/linux/tree/next

