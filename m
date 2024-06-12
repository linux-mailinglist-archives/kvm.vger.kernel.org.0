Return-Path: <kvm+bounces-19448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B32905373
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1B591F244C5
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 13:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A56178398;
	Wed, 12 Jun 2024 13:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLGVTC9l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18C5155726;
	Wed, 12 Jun 2024 13:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718198193; cv=none; b=pCa9Rs86TDNGpZFKs/zl+ic0Z37B1WClBNdX8rUhtlgeV4J1N47l11fU98uyrUGz0VkNY6uYs7n/67LZwyUplO3JtQU/0dgqCBwbz08YYqHdcpbmPrTJ3IH115/DLRn10BKGHyhPamFGfTQBjaOiHwyOvV2/7+GI20AXfguHR7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718198193; c=relaxed/simple;
	bh=l9y/Z4x7QkAaJVs49JxA/qmda+ddIvT15VdLqZyHLj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hEFF6MDF63Y/Kt2sT3GFeS2Pai+NoIcO4E30XwzwHIiAk+XLPHBJiBtFo3QOHcZxxiUgV2uQdpV2f2nK68AFHU4LLNzWGwOhYr3Rtmd3RFAOmmNq29neCNX+F6j7pjTiIgk7x/kQSEeobrvzhCR+EjP1zGiMD2nh0gLAs4rIFZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dLGVTC9l; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-dfefd03184cso35881276.0;
        Wed, 12 Jun 2024 06:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718198191; x=1718802991; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PwMZw8SNDy2rDcIYySUqCvaJTgpGfRRKM+xvQfmuCPI=;
        b=dLGVTC9l8Wo+kejdXrHbDrVsNtNbZrNMx9KF0+RcwEyJdW53bH4wgazykrPTyd9Qpe
         hCecMQV49M9IXRfB1VeLLcUU1QHw2JGdGu1lnGMHnTBzgUYaCivL4f2V9LySu+VLN7TW
         QP76gDMYXwwPyX8TFQOZI7pYigLviXcRa6KMhTQmFC026IwxSKgapWhZdz17Eezc+L/C
         MwRWmdwjDqYG5QZEQycri/hA/WQ6vydm1IsKn8RHTOYI12orFttfPrgjG1U6Mknuoq2a
         XzsPL4XaQIhHsONem1tVx1RxK4pRVkjT7Uey6dXZQU/NYn1ntJStVNx3VRmla7KvcF8J
         z8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718198191; x=1718802991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PwMZw8SNDy2rDcIYySUqCvaJTgpGfRRKM+xvQfmuCPI=;
        b=SJ665ToWosAvTKJ1dSj9+i+iTpFdzKiKJK93rzFu/WTwXrqzokZAjSwr9UM0gBqK5W
         +X1Ru1P4SJakaJbQUzwBb7kRzK0HsUfIyX4VwbOVGsQuCkgO8hiXOyAZ/sGb0uogIcG3
         jMaNnGpR/BV8lqCTT/kALD7BjmQYFnZNHAFRFAttlJdxCXUrlagASPWKrMFio2u0mHPc
         xOrVrR9qKJV090Kv8K138OOJnIAireTQDOVbLELVMyg8UGLdSsrT/oYlb2OHq6zyRS9n
         FHK6I/MJpHTQU/jedjNGZjo4rPNIaCwPMMs0fs9myoWKDGmfhDUsHo+k9V3OsaoHspi2
         tfIg==
X-Forwarded-Encrypted: i=1; AJvYcCV2XIXNJUssili+pnhyxNoI1qz9k4rjO01jysCWjZNSkeze2bQADD1VcID4AWEi+SmtwHlE8vMZdE0M4HrIcmNCVL5bjFf2OrbYKqREQ9i7FAUcfdcwbOzw20ji19Mhx+xj
X-Gm-Message-State: AOJu0YwQ0E+xlO3NXACd5n80ze4Q6LI7V502xwDa8MACbMmpJgRx/n4n
	zYfhVQPH3Bpfj9sIqrIX5uzIntgn2G3M+XXMYE7Dvh25Tk0PXtUmREWgQPdTDrVG9GstsYn5lam
	Hy4SVNpGwAy7k88mFxmVOeCqv74E=
X-Google-Smtp-Source: AGHT+IGac1DxLcW4ENRJWP0/8CZJFTAkydRmsecEhQ/UfDQDK02+6RMljRoqimNvIXiTHvSy6ELFXLH6zeThxyPDmuI=
X-Received: by 2002:a25:4cc9:0:b0:dfb:1b5:6e6a with SMTP id
 3f1490d57ef6-dfe68b15119mr1416360276.43.1718198190771; Wed, 12 Jun 2024
 06:16:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240506101751.3145407-1-foxywang@tencent.com> <171803642381.3355478.4236692282060742412.b4-ty@google.com>
In-Reply-To: <171803642381.3355478.4236692282060742412.b4-ty@google.com>
From: Yi Wang <up2wing@gmail.com>
Date: Wed, 12 Jun 2024 21:16:18 +0800
Message-ID: <CAN35MuRr64-0iJvmX6=kn8QVH_KJnhtwyaF+_MFJv3MgRe7xkw@mail.gmail.com>
Subject: Re: [v5 0/3] KVM: irqchip: synchronize srcu only if needed
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, wanpengli@tencent.com, 
	foxywang@tencent.com, oliver.upton@linux.dev, maz@kernel.org, 
	anup@brainfault.org, atishp@atishpatra.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2024 at 9:19=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, 06 May 2024 18:17:48 +0800, Yi Wang wrote:
> > From: Yi Wang <foxywang@tencent.com>
> >
> > We found that it may cost more than 20 milliseconds very accidentally
> > to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
> > already.
> >
> > The reason is that when vmm(qemu/CloudHypervisor) invokes
> > KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
> > might_sleep and kworker of srcu may cost some delay during this period.
> > One way makes sence is setup empty irq routing when creating vm and
> > so that x86/s390 don't need to setup empty/dummy irq routing.
> >
> > [...]
>
> Applied to kvm-x86 generic, with a lot of fixup.  A sanity check on the e=
nd
> result would be much appreciated.  Thanks!

The code LGTM. I did some tests in my Intel machine and found no problems.

Thanks for your work :)

>
> [1/3] KVM: Setup empty IRQ routing when creating a VM
>       https://github.com/kvm-x86/linux/commit/fbe4a7e881d4
> [2/3] KVM: x86: Don't re-setup empty IRQ routing when KVM_CAP_SPLIT_IRQCH=
IP
>       https://github.com/kvm-x86/linux/commit/e3c89f5dd11d
> [3/3] KVM: s390: Don't re-setup dummy routing when KVM_CREATE_IRQCHIP
>       https://github.com/kvm-x86/linux/commit/c4201bd24f4a
>
> --
> https://github.com/kvm-x86/linux/tree/next




---
Best wishes
Yi Wang

