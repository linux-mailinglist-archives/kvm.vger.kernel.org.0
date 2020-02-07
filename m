Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF8C155BA0
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 17:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgBGQS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 11:18:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41791 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726874AbgBGQS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 11:18:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581092337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jclxcwAozM1U7HhbQOM73LDCd0RoMBSWDQazU9Vp+Ns=;
        b=N2sldZrQQ/y17ZkOh+q1ewl1bjUFuMQAkaZdFgsjaJh0K7Xz5R/IJ3MdHS0ZsMh6O1UeDm
        1Ty8gLC2afKtH2/wEG+n9m4w4f0w04cG8T8KDxi6/NCI+Tuq++oXNwcHKoI9Ql0w4+MioY
        oroxpg7fjgjPiXKS1CbIRhtT7Ycz3L8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-1V1PL6OdOgmxVHG8b8rbfg-1; Fri, 07 Feb 2020 11:18:49 -0500
X-MC-Unique: 1V1PL6OdOgmxVHG8b8rbfg-1
Received: by mail-qv1-f71.google.com with SMTP id g15so1439680qvq.20
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 08:18:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jclxcwAozM1U7HhbQOM73LDCd0RoMBSWDQazU9Vp+Ns=;
        b=mRR8r7haj3VAA57xejNcYahhc8tQmCvOoXxNL0m5cvF2zoGbHyGU1EkGbyChJtsKBb
         HplpoFvEUv8e39B6gZNLctc7W5JRUQqraUmg+Ahj87uZdOIzCGRHAQmEVrGT1+nlKiFj
         xsus7ShXdCuVRxXCMSK48gq9t4UgsdIfRkKPdt8kn5g2jXoDEbwtMFdOpHM+2K8rqHf6
         IVe11BQfsjYa9dwvm4/yyjnWgtCH97mkqeV02+VU0WZ41tU39aF85RtuPjxEH8soTzRj
         I726RfRtvSp3ZWmwH/byTXCA1zwgEoG36u4ldedy3EpBACGehK69Y2UvR2a4Hd6xIHdO
         3rOw==
X-Gm-Message-State: APjAAAUYxIvf0ICa5gfqrp9LYxdIIr++0a5Z1SSkrEM0gbqVtP6opCYG
        racQoshs5JlrO6PgTwhR11ndxYveIu65mqkTThqivH3V/WiUd6O8OxDlP2wnWBzgZ41OnBxo73l
        esGtmaOGQ84iN
X-Received: by 2002:a05:6214:a41:: with SMTP id ee1mr7489334qvb.149.1581092328319;
        Fri, 07 Feb 2020 08:18:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqxy7CZezKLhxlm/hSkDn+LBRyJvdycCSzmggJ171E3ZeERFf2xuwxzRz4plj88GUzI7cZZyjQ==
X-Received: by 2002:a05:6214:a41:: with SMTP id ee1mr7489286qvb.149.1581092327872;
        Fri, 07 Feb 2020 08:18:47 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id n32sm1616811qtk.66.2020.02.07.08.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 08:18:47 -0800 (PST)
Date:   Fri, 7 Feb 2020 11:18:45 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
Subject: Re: BUG: using __this_cpu_read() in preemptible [00000000] code
Message-ID: <20200207161845.GB707371@xz-x1>
References: <318984f6-bc36-33a3-abc6-bf2295974b06@huawei.com>
 <828d3b538b7258f692f782b6798277cf@kernel.org>
 <3e90c020-e7f3-61f1-3731-a489df0b1d9c@huawei.com>
 <f2fd3b371fda9167a02a7312cda5d217@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f2fd3b371fda9167a02a7312cda5d217@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 10:25:23AM +0000, Marc Zyngier wrote:
> On 2020-02-07 10:19, Zenghui Yu wrote:
> > Hi Marc,
> > 
> > On 2020/2/7 17:19, Marc Zyngier wrote:
> > > Hi Zenghui,
> > > 
> > > On 2020-02-07 09:00, Zenghui Yu wrote:
> > > > Hi,
> > > > 
> > > > Running a latest preemptible kernel and some guests on it,
> > > > I got the following message,
> > > > 
> > > > ---8<---
> > > > 
> > > > [  630.031870] BUG: using __this_cpu_read() in preemptible [00000000]
> > > > code: qemu-system-aar/37270
> > > > [  630.031872] caller is kvm_get_running_vcpu+0x1c/0x38
> > > > [  630.031874] CPU: 32 PID: 37270 Comm: qemu-system-aar Kdump: loaded
> > > > Not tainted 5.5.0+
> > > > [  630.031876] Hardware name: Huawei TaiShan 2280 /BC11SPCD,
> > > > BIOS 1.58
> > > > 10/29/2018
> > > > [  630.031876] Call trace:
> > > > [  630.031878]  dump_backtrace+0x0/0x200
> > > > [  630.031880]  show_stack+0x24/0x30
> > > > [  630.031882]  dump_stack+0xb0/0xf4
> > > > [  630.031884]  __this_cpu_preempt_check+0xc8/0xd0
> > > > [  630.031886]  kvm_get_running_vcpu+0x1c/0x38
> > > > [  630.031888]  vgic_mmio_change_active.isra.4+0x2c/0xe0
> > > > [  630.031890]  __vgic_mmio_write_cactive+0x80/0xc8
> > > > [  630.031892]  vgic_mmio_uaccess_write_cactive+0x3c/0x50
> > > > [  630.031894]  vgic_uaccess+0xcc/0x138
> > > > [  630.031896]  vgic_v3_redist_uaccess+0x7c/0xa8
> > > > [  630.031898]  vgic_v3_attr_regs_access+0x1a8/0x230
> > > > [  630.031901]  vgic_v3_set_attr+0x1b4/0x290
> > > > [  630.031903]  kvm_device_ioctl_attr+0xbc/0x110
> > > > [  630.031905]  kvm_device_ioctl+0xc4/0x108
> > > > [  630.031907]  ksys_ioctl+0xb4/0xd0
> > > > [  630.031909]  __arm64_sys_ioctl+0x28/0x38
> > > > [  630.031911]  el0_svc_common.constprop.1+0x7c/0x1a0
> > > > [  630.031913]  do_el0_svc+0x34/0xa0
> > > > [  630.031915]  el0_sync_handler+0x124/0x274
> > > > [  630.031916]  el0_sync+0x140/0x180
> > > > 
> > > > ---8<---
> > > > 
> > > > I'm now at commit 90568ecf561540fa330511e21fcd823b0c3829c6.
> > > > 
> > > > And it looks like vgic_get_mmio_requester_vcpu() was broken by
> > > > 7495e22bb165 ("KVM: Move running VCPU from ARM to common code").
> > > > 
> > > > Could anyone please have a look?
> > > 
> > > Here you go:
> > > 
> > > diff --git a/virt/kvm/arm/vgic/vgic-mmio.c
> > > b/virt/kvm/arm/vgic/vgic-mmio.c
> > > index d656ebd5f9d4..e1735f19c924 100644
> > > --- a/virt/kvm/arm/vgic/vgic-mmio.c
> > > +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> > > @@ -190,6 +190,15 @@ unsigned long vgic_mmio_read_pending(struct
> > > kvm_vcpu *vcpu,
> > >    * value later will give us the same value as we update the
> > > per-CPU variable
> > >    * in the preempt notifier handlers.
> > >    */
> > > +static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
> > > +{
> > > +    struct kvm_vcpu *vcpu;
> > > +
> > > +    preempt_disable();
> > > +    vcpu = kvm_get_running_vcpu();
> > > +    preempt_enable();
> > > +    return vcpu;
> > > +}
> > > 
> > >   /* Must be called with irq->irq_lock held */
> > >   static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct
> > > vgic_irq *irq,
> > > @@ -212,7 +221,7 @@ void vgic_mmio_write_spending(struct kvm_vcpu
> > > *vcpu,
> > >                     gpa_t addr, unsigned int len,
> > >                     unsigned long val)
> > >   {
> > > -    bool is_uaccess = !kvm_get_running_vcpu();
> > > +    bool is_uaccess = !vgic_get_mmio_requester_vcpu();
> > >       u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> > >       int i;
> > >       unsigned long flags;
> > > @@ -265,7 +274,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu
> > > *vcpu,
> > >                     gpa_t addr, unsigned int len,
> > >                     unsigned long val)
> > >   {
> > > -    bool is_uaccess = !kvm_get_running_vcpu();
> > > +    bool is_uaccess = !vgic_get_mmio_requester_vcpu();
> > >       u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> > >       int i;
> > >       unsigned long flags;
> > > @@ -326,7 +335,7 @@ static void vgic_mmio_change_active(struct
> > > kvm_vcpu *vcpu, struct vgic_irq *irq,
> > >                       bool active)
> > >   {
> > >       unsigned long flags;
> > > -    struct kvm_vcpu *requester_vcpu = kvm_get_running_vcpu();
> > > +    struct kvm_vcpu *requester_vcpu = vgic_get_mmio_requester_vcpu();
> > > 
> > >       raw_spin_lock_irqsave(&irq->irq_lock, flags);
> > > 
> > > 
> > > That's basically a revert of the offending code. The comment right
> > > above
> > > vgic_get_mmio_requester_vcpu() explains *why* this is valid, and why
> > > preempt_disable() is needed.

Sorry for not noticing this before.

> > 
> > I see, thanks!
> > 
> > > 
> > > Can you please give it a shot?
> > 
> > Yes, it works for me:
> > 
> > Tested-by: Zenghui Yu <yuzenghui@huawei.com>
> 
> Actually, maybe a better/simpler fix would be this:
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67ae2d5c37b2..3cf7719d3177 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4414,7 +4414,13 @@ static void kvm_sched_out(struct preempt_notifier
> *pn,
>   */
>  struct kvm_vcpu *kvm_get_running_vcpu(void)
>  {
> -        return __this_cpu_read(kvm_running_vcpu);
> +	struct kvm_vcpu *vcpu;
> +
> +	preempt_disable();
> +	vcpu = __this_cpu_read(kvm_running_vcpu);
> +	preempt_enable();
> +
> +	return vcpu;
>  }
> 
>  /**
> 
> which matches the comment that comes with the function.
> 
> Paolo, which one do you prefer? It seems to me that the intent of moving
> this to core code was to provide a high level API that works at all times.

Not sure about Paolo, but this looks better at least to me.  Shall we
also move the comment from vgic-mmio.c to here?  And we can remove the
1st paragraph:

/*
 * We can disable preemption locally around accessing the per-CPU variable,
 * and use the resolved vcpu pointer after enabling preemption again, because
 * even if the current thread is migrated to another CPU, reading the per-CPU
 * value later will give us the same value as we update the per-CPU variable
 * in the preempt notifier handlers.
 */

Thanks!

-- 
Peter Xu

