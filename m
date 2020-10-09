Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81AF288D9F
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 18:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389518AbgJIQCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 12:02:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58854 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389135AbgJIQCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 12:02:53 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602259371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZHt8XKpvOg8gA4nFcOb4ywxF5VhRSTiXsFiBgkwu8B8=;
        b=PZXU42J+noDD0cxK0VwzkFTB1O1ZMlVR4ciJrWmGNNjCW7z+U6/fPdM/VrIK5jn891zfRF
        zsZySS/8mYik/JuGzKmmWWbEya2Zwm3ZS4siFcm+rWM0kbLOX2SVR0ClM3ytOeJvQr7QZh
        dAcxQ5R6F6FknxrG9JuOt07A8eUCSza53Cv5AuC+hlpDhlrxB51jXTgZVtlzqteqGKToAP
        AP/Y2z83BB+TMGZL6Bs2yRDuYy581E6ItMpfV1UcXhLxmcNOEf/iGEWUwFN4Cxv135AYmk
        FTgQgJNVyUhJD+vIFuFMk2+g0f9SGIOwu6wLNAJ/T5b2Qfyths1T+PSzw1DNXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602259371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZHt8XKpvOg8gA4nFcOb4ywxF5VhRSTiXsFiBgkwu8B8=;
        b=w1fJ/MJLSeMBuSGG0nDlKWfzrPoFMaZhljKfwDjF06uVySTctoTPsdDTaJTQNfblBx2kFS
        umsjrxsBGffaBqDw==
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
In-Reply-To: <20201009145236.GM4734@nvidia.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com> <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com> <87mu17ghr1.fsf@nanos.tec.linutronix.de> <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com> <87r1q92mkx.fsf@nanos.tec.linutronix.de> <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com> <87y2kgux2l.fsf@nanos.tec.linutronix.de> <20201008233210.GH4734@nvidia.com> <87v9fjtq5w.fsf@nanos.tec.linutronix.de> <20201009145236.GM4734@nvidia.com>
Date:   Fri, 09 Oct 2020 18:02:51 +0200
Message-ID: <87d01rtmj8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09 2020 at 11:52, Jason Gunthorpe wrote:
> On Fri, Oct 09, 2020 at 04:44:27PM +0200, Thomas Gleixner wrote:
>> > This is really not that different from what I was describing for queue
>> > contexts - the queue context needs to be assigned to the irq # before
>> > it can be used in the irq chip other wise there is no idea where to
>> > write the msg to. Just like pasid here.
>> 
>> Not really. In the IDXD case the storage is known when the host device
>> and the irq domain is initialized which is not the case for your variant
>> and it neither needs to send a magic command to the device to update the
>> data.
>
> I mean, needing the PASID vs needing the memory address before the IRQ
> can be use are basically the same issue. Data needs to be attached to
> the IRQ before it can be programmed.. In this case programming with
> the wrong PASID could lead to a security issue.

Yeah. I looked at doing it similar to the callback I added for
retrieving the shadow storage pointer, but the PASID is not necessarily
established at that point.

>> I agree that irq_set_auxdata() is not the most elegant thing, but the
>> alternative solutions I looked at are just worse.
>
> It seems reasonable, but quite an obfuscated way to tell a driver they
> need to hold irq_get_desc_buslock() when touching data shared with the
> irqchip ops.. Not that I have a better suggestion

It's an obfuscated way to make obfuscated hardware supported :)

Thanks,

        tglx
