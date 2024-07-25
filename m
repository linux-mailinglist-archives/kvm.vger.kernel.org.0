Return-Path: <kvm+bounces-22230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA4F93C1FC
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78F531C20E06
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 12:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A374199E98;
	Thu, 25 Jul 2024 12:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aiJu5ROU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DE7199E8A
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 12:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721910450; cv=none; b=bxAT11bxVEdUuSHiXVYeNYKWTPvxSEOi95ga3/1+D9TYQPZFpxe4n8TDb7ocl03hxDLIbK3GLyXpic0obs5Js0l8sN4F9OiAZbqv2W8mzC+1lNjpMJktNb3ejkAmSB28NqDiqJ2YpHZgbk4GVaCrUNHG5AIVjMCizkuKsIvr6fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721910450; c=relaxed/simple;
	bh=gCf1amWzOCQCij+FS+XWJYW3/P98s9uMsTpIpA7xptE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YN6VSnwOi9nVBOro5rWu6WRbBj66HJdiNfKpwU2pY4tnyInosTjF9jk8HC/Hb8vrO+iG91N+01a004DfH97TxzVkrGQPCNHwnIU/jHCbq4POnWXXhSdvRbK+VFg5iuWoEnV+BKIsQF3NeMm5AgF6N4Injc3qaJQIL8E2kdM/H4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aiJu5ROU; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5a20de39cfbso1077275a12.1
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 05:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721910447; x=1722515247; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GOh6PKdCbaMoUdlPd1L+eg1JAZ26MYlPj4SLk05TsGk=;
        b=aiJu5ROUiqEZiWoYDnVMjy0fMs/WRAQ8CtPLhAf04zywwrwvUFdLks1Q4A4MlNGwO6
         jIpy//AJ3qtvjbltG557sBf87cVXtI+KAuAvLMAIx+zif0y5fAWzHE5LJ6z1McJH+xBP
         7F7PAU794cNPUHzaghEGqavPCcRGgYZXEfjrb+mmNtr5u4xh+U1vJmPxHxzqOdJOErcW
         xoPWKpbPK93v6MdTWT76p0VeEJw8B70TAdEBxbp2gDVovEnMR2hIuNJsfPztOsuT9KxZ
         che9XiMb5BSQOelhhW7dRAtnuFHbv2yt9KDKUTrp2+RjGF6h+Sl7aOVPTOulMNlcpSH0
         iP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721910447; x=1722515247;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GOh6PKdCbaMoUdlPd1L+eg1JAZ26MYlPj4SLk05TsGk=;
        b=aLf+JNur3GPzK3QFxnYBVXl8VZbmS/QgIHFqmpArERKeIeSYErdEfP14tHtR/wOIdS
         EdM7v660cDXPGxYPiJi6xGXY7+xYnH52nMut5B31gV8JSzZbbwZnE//gFXz4kci/XtL7
         Xcqufam1TLgEITk46jluBcKdwAL/oAPvVAAUMYj2L/WpuP2Cq4SaE6i2ZP7YyJXhUrcQ
         wgc68DVQJI/74jh6o7R6LVwN27RWoN7K4A5c0DWORrD5GIQa3bsjSb2MgukamZyMCXOg
         hAXEhuyPKPN5NXRUoo8WsiBeaO8XWRePyWYQiR6YKSi8en2NC0ivhoLjaZJUt7MtzzXS
         2fpg==
X-Forwarded-Encrypted: i=1; AJvYcCWhtnuK6osjcBq5/ZcCIolY8S3178IzlTFrz4aemJfFW575YzhmgqJp8UXyhrGbJ2eFk2yQfpHUdKaoDhjDYfqUdMk4
X-Gm-Message-State: AOJu0YwJtz/xK7e5rc0pa3j5qur10HiiPZBjY33Ebp+uMJp7cpqu44Kg
	CS2t2hioCPOt+W4Vd9iajQCUnKqGx/mR+tqOF8d7jqauNDfX8hTVotO1R5GPPjKZ73cPPfeGj5B
	wW4omtHAcCLLAmdObqg4c/869J6BAn2ykmRo28Q==
X-Google-Smtp-Source: AGHT+IEDyBxEvxBsN9vTBlpY82wdgrQiPGM2Bk6P5qhTyE3mo4k/VO1Rtgxf/JjCjs5r4jLmFPukfq3rbKZL28GZa7s=
X-Received: by 2002:a50:ab55:0:b0:57d:456:e838 with SMTP id
 4fb4d7f45d1cf-5ac6519c7d8mr1304019a12.31.1721910446680; Thu, 25 Jul 2024
 05:27:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1721731723.git.mst@redhat.com> <08c328682231b64878fc052a11091bea39577a6f.1721731723.git.mst@redhat.com>
 <CAFEAcA-3_d1c7XSXWkFubD-LsW5c5i95e6xxV09r2C9yGtzcdA@mail.gmail.com> <8f5fcf0c1deb4f199d86441f79298629@huawei.com>
In-Reply-To: <8f5fcf0c1deb4f199d86441f79298629@huawei.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 25 Jul 2024 13:27:15 +0100
Message-ID: <CAFEAcA9-gVBLAH9PaFrPmBLD5tHXMZ+-2m+pRvtjodOBaBa0GQ@mail.gmail.com>
Subject: Re: [PULL v2 37/61] accel/kvm: Extract common KVM vCPU
 {creation,parking} code
To: Salil Mehta <salil.mehta@huawei.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Gavin Shan <gshan@redhat.com>, 
	Vishnu Pajjuri <vishnu@os.amperecomputing.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Xianglai Li <lixianglai@loongson.cn>, 
	Miguel Luis <miguel.luis@oracle.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Harsh Prateek Bora <harshpb@linux.ibm.com>, Igor Mammedov <imammedo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 25 Jul 2024 at 13:05, Salil Mehta <salil.mehta@huawei.com> wrote:
>
> HI Peter,
>
> >  From: Peter Maydell <peter.maydell@linaro.org>
> >  Sent: Thursday, July 25, 2024 11:36 AM
> >  To: Michael S. Tsirkin <mst@redhat.com>
> >
> >  On Tue, 23 Jul 2024 at 11:58, Michael S. Tsirkin <mst@redhat.com> wrote:
> >  >
> >  > From: Salil Mehta <salil.mehta@huawei.com>
> >  >
> >  > KVM vCPU creation is done once during the vCPU realization when Qemu
> >  > vCPU thread is spawned. This is common to all the architectures as of now.
> >  >
> >  > Hot-unplug of vCPU results in destruction of the vCPU object in QOM
> >  > but the corresponding KVM vCPU object in the Host KVM is not destroyed
> >  > as KVM doesn't support vCPU removal. Therefore, its representative KVM
> >  > vCPU object/context in Qemu is parked.
> >  >
> >  > Refactor architecture common logic so that some APIs could be reused
> >  > by vCPU Hotplug code of some architectures likes ARM, Loongson etc.
> >  > Update new/old APIs with trace events. New APIs
> >  > qemu_{create,park,unpark}_vcpu() can be externally called. No functional
> >  change is intended here.
> >
> >  Hi; Coverity points out an issue with this code (CID 1558552):
> >
> >  > +int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id) {
> >  > +    struct KVMParkedVcpu *cpu;
> >  > +    int kvm_fd = -ENOENT;
> >  > +
> >  > +    QLIST_FOREACH(cpu, &s->kvm_parked_vcpus, node) {
> >  > +        if (cpu->vcpu_id == vcpu_id) {
> >  > +            QLIST_REMOVE(cpu, node);
> >  > +            kvm_fd = cpu->kvm_fd;
> >  > +            g_free(cpu);
> >  > +        }
> >  > +    }
> >
> >  If you are going to remove an entry from a list as you iterate over it, you
> >  can't use QLIST_FOREACH(), because QLIST_FOREACH will look at the next
> >  pointer of the iteration variable at the end of the loop when it wants to
> >  advance to the next node. In this case we've already freed 'cpu', so it would
> >  be reading freed memory.
> >
> >  Should we break out of the loop when we find the entry?
>
>
> Thanks for identifying this. Yes, a  break is missing. Should I send a fix for this
> now or you can incorporate it?

The code is already in upstream git, so please send a patch
to fix the bug.

thanks
-- PMM

