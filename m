Return-Path: <kvm+bounces-9394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B1B85FBD1
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:04:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B873B1F2503A
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 15:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A413714901F;
	Thu, 22 Feb 2024 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E1OCiMUn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3B5482D4
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708614288; cv=none; b=HRJ6R8wqq0IjimQDUigFRR+pOX6+mbK0T4NtNfgHs4WhVK/vCsMSo1XmEQJdIJ2mLkNGYNdmDH2DkorVxsSLTBjBzxKwM84QV4De18HRPq15AOfbk8qg+UUoa3EHOrte0GHpQ60p/g91J8kA2zgrG4kttN1WdQkr2KrkJ/yUst8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708614288; c=relaxed/simple;
	bh=QyQ8Hs/9cOFc3/EVyHCVJmCChnrYQ6OCQihzLDwqsoY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WWtP2UTXVkAhQFy8P3EeyQKabKgKFssdCLDhFX7NXa8/H9puxOMdOBad9ya1rhFWRQ34awBfo0h43tVYaiB/G8m4032wFkCDtqvA2rAeEjgcRAfDKiGTTqX/pTUmx1no1K7wo0Kcd/RzVtIRpS6AFEKp7JU6/kmwNBMb5MMk+Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E1OCiMUn; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26eef6cso11663676276.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 07:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708614286; x=1709219086; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z/iYiJ+7TFli2f3JsUK+qy0WxM4Y33Yr3gEgMfzxYgQ=;
        b=E1OCiMUnx5SanbackOg1n7qpTvJdusU/kwNPgBnuo1f8s5I+CA2U5dQJAadzwkCtWt
         Q4c/tSsgQ3AMdzFej6qYn1u93pWF6nMJITXduAPlkU5+7+y4ABEEuKutqV4GsOh/pP5E
         w0BqIoBcaoWuVfpfB+V7lgZ1kuRclYC7rM7KAiUOJ0YfqBibUQ3XFGzh694cQe55hKTS
         nwI7kWjD4mZKvBNt86j9JFPoWkcsRdbiVsXNEoMQwWsznxwtXhlnEsk+GD8Y47hIIp05
         hVzEu/1EBkzVYmreSxQYve8qQgmNvClQAVwJWgt6CGMyMYcqV7QnUNd1nO53bJIVpELB
         OMhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708614286; x=1709219086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z/iYiJ+7TFli2f3JsUK+qy0WxM4Y33Yr3gEgMfzxYgQ=;
        b=nKrJ8NY9MJWnbyh2ke5lCxyXXy7SfYKDRNj3tV0TDOz40eDmvz1BkQ+rbZ+9JhvNkl
         6+/AwuJuFbcvGjeUKXPptpAEs9ZqUna8JoKdPPIUiKb/d2UgxQrGDRqQ6xNGyrQ/huOT
         ELfuTGoT4qGZfR7mxu6E+Bir0X+hPjaYIoi7HaeRI+DdDnlRsa1b9ETwiAB9jJXiq4Zj
         LskOQVlUvB36eBk92vwQVEH4NbmTm+8XBg8wFpKr0ScCC5im3JNqh1hd7h9ccqK6cfeT
         HkAo9yRg7er7AK8dwxLZFKeT3kAduc7m7S/Vr2IMKnH+FvLjZpbZ0rufQChtTcp/wlPr
         FCMg==
X-Forwarded-Encrypted: i=1; AJvYcCVnZHn7zunh5evWcqqWpGsRMrg2bJtDLlhUUw4IRTG04iCiA001MhLSByNmCCN2Ivd0IgMZzh2qoUjiB63UEyzSmjPJ
X-Gm-Message-State: AOJu0YyPVAxue7BSrR50ohQqSwKH2TaW3x/A89UpmOd0Cnwhoum7gCex
	8G5PIpDRMTKFo0OAvaHj2Ns2BXgVWIPxh9y0SB7H1eoR8rO5pGcJhx+7uJXZJbhbJdA3UZSNI8e
	Eag==
X-Google-Smtp-Source: AGHT+IHooslmJai+EOheQ0H5t3h6KvQduhgxHrEfBv/XJ327uTFnVL1/dQvOjGkq8HhKJXpBhl9cTVHMDrs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce0b:0:b0:dc2:5456:d9ac with SMTP id
 x11-20020a25ce0b000000b00dc25456d9acmr77928ybe.5.1708614286362; Thu, 22 Feb
 2024 07:04:46 -0800 (PST)
Date: Thu, 22 Feb 2024 07:04:44 -0800
In-Reply-To: <c8c37018-8681-458f-96b7-82bae88ebcd3@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222100412.560961-1-arnd@kernel.org> <c8c37018-8681-458f-96b7-82bae88ebcd3@xen.org>
Message-ID: <ZddijN0ShU23sdJw@google.com>
Subject: Re: [PATCH] KVM: x86/xen: fix 32-bit pointer cast
From: Sean Christopherson <seanjc@google.com>
To: paul@xen.org
Cc: Arnd Bergmann <arnd@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, 
	Christian Brauner <brauner@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 22, 2024, Paul Durrant wrote:
> On 22/02/2024 10:03, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > shared_info.hva is a 64-bit variable, so casting to a pointer causes
> > a warning in 32-bit builds:
> > 
> > arch/x86/kvm/xen.c: In function 'kvm_xen_hvm_set_attr':
> > arch/x86/kvm/xen.c:660:45: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
> >    660 |                         void __user * hva = (void *)data->u.shared_info.hva;
> > 
> > Replace the cast with a u64_to_user_ptr() call that does the right thing.
> 
> Thanks Arnd. I'd just got a ping from kernel test robot for lack of __user
> qualifier in the cast
> (https://lore.kernel.org/oe-kbuild-all/202402221721.mhF8MNVh-lkp@intel.com/),
> which this should also fix.

Ya, 'tis a good bot.  I squashed this in.   Paul/David, new hashes for the
affected commits are below.

Thanks Arnd!

  KVM: x86/xen: allow shared_info to be mapped by fixed HVA
  https://github.com/kvm-x86/linux/commit/b9220d32799a
  KVM: x86/xen: allow vcpu_info to be mapped by fixed HVA
  https://github.com/kvm-x86/linux/commit/3991f35805d0
  KVM: selftests: map Xen's shared_info page using HVA rather than GFN
  https://github.com/kvm-x86/linux/commit/9397b5334af1
  KVM: selftests: re-map Xen's vcpu_info using HVA rather than GPA
  https://github.com/kvm-x86/linux/commit/b4dfbfdc9538
  KVM: x86/xen: advertize the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA capability
  https://github.com/kvm-x86/linux/commit/615451d8cb3f
  KVM: pfncache: check the need for invalidation under read lock first
  https://github.com/kvm-x86/linux/commit/9fa336e343b2
  KVM: x86/xen: allow vcpu_info content to be 'safely' copied
  https://github.com/kvm-x86/linux/commit/003d914220c9

