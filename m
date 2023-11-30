Return-Path: <kvm+bounces-2834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1504E7FE660
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 02:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB724B210AD
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 01:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9AD7101EC;
	Thu, 30 Nov 2023 01:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EEarHMDJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E35510D0
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:44:52 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5c87663a873so6225837b3.2
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701308691; x=1701913491; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xub5VyLk/9hlkO52TXYo+tffXTpWrk+mVN6q+yQi2HA=;
        b=EEarHMDJEVaJYEeRMFJr12jDXevjRahydSvlpyCAsXSUvFtBsXwK2DPvjag4zsb4I5
         2hd1/SBF6VQWEV34YxGwGtsO/NWGpICPEDlhLOVCUX6VUUhI172Ha0VfxO8UILreaXSi
         3lWln/qvGMSprJhv13d7ufjX9fAh5C3a7VmKtARRY8PnK2ebyryWLMhOMP+pPuucOcht
         QXmhWcrBjHeBzDxqFyKMsHRre+Oo/HhllZgukisvc4d6KPSn0VLy3+enGAM1uTgI01gz
         OpifDbEBu9Ai37ovp6TM866m6Rn07OSBtz1Zb/kjGUbVYQfgJLnvy/GnT4h/DI8fzqTh
         wyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701308691; x=1701913491;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xub5VyLk/9hlkO52TXYo+tffXTpWrk+mVN6q+yQi2HA=;
        b=Ku+NQnAeDeuaGeM3vQfPN73fa1aqgxn+xLjezZeu5eBvF0kdlKf6Al1Hc/SAudzMQT
         bieDsvCp1HlNLNlnWvDPp3FzQui6E+FCVGCDHt4GU9qI9dIeLzNS+PvD89ZRIXWTBHvw
         KINzCiNU63Gjbk9xYtYgr4R+x+jki93H9ULxQhEiiqsTJ57kcs9OpVeQXict6dk3CALf
         OJ+8xw6tQeisyedWB4CehmFaOHgmJ1bQaFC41wFa3QC5zppN6auqmpA5LoWAJediuoCB
         kCzaccyp02fZsCnWPX3EdgOsSTQxa2M4WPj6upPl/83okXy1SGe8Lr8pfjLcGd22/rI/
         k5DA==
X-Gm-Message-State: AOJu0Yz1crx8xrwF3Z60UmST5jJRbAc6LwB7arEsuEefz9AKhhnUirY2
	6B1mZ6hxuVN/s98Ao/Rzgdql9Sh74FM=
X-Google-Smtp-Source: AGHT+IHHxILkVBPSCyrNJDZ6oTdYrXiPBvE0AM7l5jU3PrmO2ELVJgtmZPPfqmZAA5zbmyzdI66uMRXEYIw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2e05:b0:5ce:dff:f7a3 with SMTP id
 et5-20020a05690c2e0500b005ce0dfff7a3mr570394ywb.10.1701308691301; Wed, 29 Nov
 2023 17:44:51 -0800 (PST)
Date: Wed, 29 Nov 2023 17:44:13 -0800
In-Reply-To: <20231108010953.560824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108010953.560824-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <170129829007.532775.18424810252595366690.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Detect if KVM bugged the VM
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Luczaj <mhal@rbox.co>, Oliver Upton <oliver.upton@linux.dev>, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 07 Nov 2023 17:09:51 -0800, Sean Christopherson wrote:
> Teach selftests' ioctl() macros to detect and report when an ioctl()
> unexpectedly fails because KVM has killed and/or bugged the VM.  Because
> selftests does the right thing and tries to gracefully clean up VMs, a
> bugged VM can generate confusing errors, e.g. when deleting memslots.
> 
> v2:
>  - Drop the ARM patch (not worth the churn).
>  - Drop macros for ioctls() that return file descriptors.  Looking at this
>    with fresh eyes, I agree they do more harm than good. [Oliver]
> 
> [...]

Applied to kvm-x86 selftests.

Xiaoyao, I definitely want to continue the conversation on improving the userspace
experience when KVM kills a VM, but I don't see a reason to hold up "fixing" the
selftests.

[1/2] KVM: selftests: Drop the single-underscore ioctl() helpers
      https://github.com/kvm-x86/linux/commit/6542a0036928
[2/2] KVM: selftests: Add logic to detect if ioctl() failed because VM was killed
      https://github.com/kvm-x86/linux/commit/1b78d474ce4e

--
https://github.com/kvm-x86/linux/tree/next

