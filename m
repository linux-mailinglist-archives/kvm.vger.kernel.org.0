Return-Path: <kvm+bounces-2788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 591637FE041
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 20:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0FDFB211EB
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 19:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8B35DF3D;
	Wed, 29 Nov 2023 19:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VvkVbyMZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238E71A8
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 11:22:12 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5be39ccc2e9so92905a12.3
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 11:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701285731; x=1701890531; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zm+VmJgtsDhhnZtgTitQtOHEZp/dUiGbrU1wdemhaX4=;
        b=VvkVbyMZpBIEHXoL/pz/DHyw9r5iis0kPlBeiktc/qjUOAquMjPHnDDW0h3+A1HlId
         Qvg8IT6YTjCsMbAi/0jFCzTFE/Yav5PcHo4MketSk+ZVMrFHEO/d0GYwwlKgyXGCTo9V
         v/B/U8rnd80ng3HIeewZOyyk+bkB5eTUuCyKXWq6Rf9lu+m53FE8q5rLXxyjKXIFDo65
         WHL1iDw1SgCveKuL8Tg7YPSvU1mf/5seObuRHPAnxxCumnj6NNX0WJac1I3VB4UrLkrB
         bbaEEUBDGdSlZECaiqZTlkhUlugC1jgUufGDEUVA1/cBCMw8SgocvYS22IijyKcT8Int
         RYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701285731; x=1701890531;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zm+VmJgtsDhhnZtgTitQtOHEZp/dUiGbrU1wdemhaX4=;
        b=wFM2TnVd0Raxlx0PLAtfVf451gjI5eP6DampvBU/DkXHgOYWd/0vVw+wa8L6fx/D8A
         aOjaUqaVX5htwSMzLVikMEHi+PFwlSYuCBJnsVjLyJqb4ofUmqc2WmTs0AUZOp920r+L
         Dh3r368DoT4X/C6dVHQtg+POPP416FXM8N86IYrgY88WjPABmG0Spua3+b3bQiJCk743
         VEl/+ohEnx5wMtNyPNP5/yeXN3tEXMCMCfH0QuS+rWawYLILLTh7Sf+/ZnlleSkquUDO
         V1s28lKTCNk3jCoMzFbfccMC94/+tPLTOeiaJ58c6pTlkBXIzXnpVjHGFBNQ8P91fKz1
         zhnA==
X-Gm-Message-State: AOJu0Yw0kmbXI1ZgYJqxK5vLdithOJNcCa+BnJWTmVPWyrl3c0BjmZn6
	cETM6s3Gj5DXBKCmh3ZhCY/aKnkMN30=
X-Google-Smtp-Source: AGHT+IFbnamXd5HIGOk9ycysykN0hM1eotS+NZRkIrasluqPuu9nCw73/x2uc9oduuUnuHto7tym2AJtkoA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ef09:0:b0:5be:71:f35d with SMTP id
 u9-20020a63ef09000000b005be0071f35dmr3359653pgh.1.1701285731587; Wed, 29 Nov
 2023 11:22:11 -0800 (PST)
Date: Wed, 29 Nov 2023 11:22:10 -0800
In-Reply-To: <22c602c9-4943-4a16-a12e-ffc5db29daa1@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108010953.560824-1-seanjc@google.com> <20231108010953.560824-3-seanjc@google.com>
 <0ee32216-e285-406f-b20d-dd193b791d2b@intel.com> <ZUuyVfdKZG44T1ba@google.com>
 <22c602c9-4943-4a16-a12e-ffc5db29daa1@intel.com>
Message-ID: <ZWePYnuK65GCOGYU@google.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: Add logic to detect if ioctl()
 failed because VM was killed
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Luczaj <mhal@rbox.co>, Oliver Upton <oliver.upton@linux.dev>, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 13, 2023, Xiaoyao Li wrote:
> On 11/9/2023 12:07 AM, Sean Christopherson wrote:
> > On Wed, Nov 08, 2023, Xiaoyao Li wrote:
> > > On 11/8/2023 9:09 AM, Sean Christopherson wrote:
> > > > Add yet another macro to the VM/vCPU ioctl() framework to detect when an
> > > > ioctl() failed because KVM killed/bugged the VM, i.e. when there was
> > > > nothing wrong with the ioctl() itself.  If KVM kills a VM, e.g. by way of
> > > > a failed KVM_BUG_ON(), all subsequent VM and vCPU ioctl()s will fail with
> > > > -EIO, which can be quite misleading and ultimately waste user/developer
> > > > time.
> > > > 
> > > > Use KVM_CHECK_EXTENSION on KVM_CAP_USER_MEMORY to detect if the VM is
> > > > dead and/or bug, as KVM doesn't provide a dedicated ioctl().  Using a
> > > > heuristic is obviously less than ideal, but practically speaking the logic
> > > > is bulletproof barring a KVM change, and any such change would arguably
> > > > break userspace, e.g. if KVM returns something other than -EIO.
> > > 
> > > We hit similar issue when testing TDX VMs. Most failure of SEMCALL is
> > > handled with a KVM_BUG_ON(), which leads to vm dead. Then the following
> > > IOCTL from userspace (QEMU) and gets -EIO.
> > > 
> > > Can we return a new KVM_EXIT_VM_DEAD on KVM_REQ_VM_DEAD?
> > 
> > Why?  Even if KVM_EXIT_VM_DEAD somehow provided enough information to be useful
> > from an automation perspective, the VM is obviously dead.  I don't see how the
> > VMM can do anything but log the error and tear down the VM.  KVM_BUG_ON() comes
> > with a WARN, which will be far more helpful for a human debugger, e.g. because
> > all vCPUs would exit with KVM_EXIT_VM_DEAD, it wouldn't even identify which vCPU
> > initially triggered the issue.
> 
> It's not about providing more helpful debugging info, but to provide a
> dedicated notification for VMM that "the VM is dead, all the following
> command may not response". With it, VMM can get rid of the tricky detection
> like this patch.

But a VMM doesn't need this tricky detection, because this tricky detections isn't
about detecting that the VM is dead, it's all about helping a human debug why a
test failed.

-EIO already effectively says "the VM is dead", e.g. QEMU isn't going to keep trying
to run vCPUs.  Similarly, selftests assert either way, the goal is purely to print
out a unique error message to minimize the chances of confusing the human running
the test (or looking at results).

> > Definitely a "no" on this one.  As has been established by the guest_memfd series,
> > it's ok to return -1/errno with a valid exit_reason.
> > 
> > > But I'm wondering if any userspace relies on -EIO behavior for VM DEAD case.
> > 
> > I doubt userspace relies on -EIO, but userpsace definitely relies on -1/errno being
> > returned when a fatal error.
> 
> what about KVM_EXIT_SHUTDOWN? Or KVM_EXIT_INTERNAL_ERROR?

I don't follow, those are vcpu_run.exit_reason values, not errno values.  Returning
any flavor of KVM_EXIT_*, which are positive values, would break userspace, e.g.
QEMU explicitly looks for "ret < 0", and glibc only treats small-ish negative
values as errors, i.e. a postive return value will be propagated verbatim up to
QEMU.

