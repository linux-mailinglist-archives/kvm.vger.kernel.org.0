Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447CD155461
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 10:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgBGJTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 04:19:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgBGJTn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 04:19:43 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C315120726;
        Fri,  7 Feb 2020 09:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581067182;
        bh=bZEWvTQZLdRaUy7USHrKkNVLaz2p4VjHYMUiR5XFHGI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bEZssog5Lu0LD2CLPpRPFa6dcDoegk2X8wydtKr2IINy7OlvDX2u5NbeCKpVmNJSi
         U/deL5YoCOyKkoOZ7+0F+yLCNWP6qq4xKyaN6tR6rjr1LP13XDIdfF4W3+VyhCZ6Dt
         mJjjyi3qQpOOOsEGoa+GY/8YBQ3aVUopcU6ADCk4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1izznZ-003UlP-3F; Fri, 07 Feb 2020 09:19:41 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 07 Feb 2020 09:19:40 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, peterx@redhat.com
Subject: Re: BUG: using __this_cpu_read() in preemptible [00000000] code
In-Reply-To: <318984f6-bc36-33a3-abc6-bf2295974b06@huawei.com>
References: <318984f6-bc36-33a3-abc6-bf2295974b06@huawei.com>
Message-ID: <828d3b538b7258f692f782b6798277cf@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, peterx@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 2020-02-07 09:00, Zenghui Yu wrote:
> Hi,
> 
> Running a latest preemptible kernel and some guests on it,
> I got the following message,
> 
> ---8<---
> 
> [  630.031870] BUG: using __this_cpu_read() in preemptible [00000000]
> code: qemu-system-aar/37270
> [  630.031872] caller is kvm_get_running_vcpu+0x1c/0x38
> [  630.031874] CPU: 32 PID: 37270 Comm: qemu-system-aar Kdump: loaded
> Not tainted 5.5.0+
> [  630.031876] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58
> 10/29/2018
> [  630.031876] Call trace:
> [  630.031878]  dump_backtrace+0x0/0x200
> [  630.031880]  show_stack+0x24/0x30
> [  630.031882]  dump_stack+0xb0/0xf4
> [  630.031884]  __this_cpu_preempt_check+0xc8/0xd0
> [  630.031886]  kvm_get_running_vcpu+0x1c/0x38
> [  630.031888]  vgic_mmio_change_active.isra.4+0x2c/0xe0
> [  630.031890]  __vgic_mmio_write_cactive+0x80/0xc8
> [  630.031892]  vgic_mmio_uaccess_write_cactive+0x3c/0x50
> [  630.031894]  vgic_uaccess+0xcc/0x138
> [  630.031896]  vgic_v3_redist_uaccess+0x7c/0xa8
> [  630.031898]  vgic_v3_attr_regs_access+0x1a8/0x230
> [  630.031901]  vgic_v3_set_attr+0x1b4/0x290
> [  630.031903]  kvm_device_ioctl_attr+0xbc/0x110
> [  630.031905]  kvm_device_ioctl+0xc4/0x108
> [  630.031907]  ksys_ioctl+0xb4/0xd0
> [  630.031909]  __arm64_sys_ioctl+0x28/0x38
> [  630.031911]  el0_svc_common.constprop.1+0x7c/0x1a0
> [  630.031913]  do_el0_svc+0x34/0xa0
> [  630.031915]  el0_sync_handler+0x124/0x274
> [  630.031916]  el0_sync+0x140/0x180
> 
> ---8<---
> 
> I'm now at commit 90568ecf561540fa330511e21fcd823b0c3829c6.
> 
> And it looks like vgic_get_mmio_requester_vcpu() was broken by
> 7495e22bb165 ("KVM: Move running VCPU from ARM to common code").
> 
> Could anyone please have a look?

Here you go:

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c 
b/virt/kvm/arm/vgic/vgic-mmio.c
index d656ebd5f9d4..e1735f19c924 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -190,6 +190,15 @@ unsigned long vgic_mmio_read_pending(struct 
kvm_vcpu *vcpu,
   * value later will give us the same value as we update the per-CPU 
variable
   * in the preempt notifier handlers.
   */
+static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
+{
+	struct kvm_vcpu *vcpu;
+
+	preempt_disable();
+	vcpu = kvm_get_running_vcpu();
+	preempt_enable();
+	return vcpu;
+}

  /* Must be called with irq->irq_lock held */
  static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq 
*irq,
@@ -212,7 +221,7 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
  			      gpa_t addr, unsigned int len,
  			      unsigned long val)
  {
-	bool is_uaccess = !kvm_get_running_vcpu();
+	bool is_uaccess = !vgic_get_mmio_requester_vcpu();
  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
  	int i;
  	unsigned long flags;
@@ -265,7 +274,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
  			      gpa_t addr, unsigned int len,
  			      unsigned long val)
  {
-	bool is_uaccess = !kvm_get_running_vcpu();
+	bool is_uaccess = !vgic_get_mmio_requester_vcpu();
  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
  	int i;
  	unsigned long flags;
@@ -326,7 +335,7 @@ static void vgic_mmio_change_active(struct kvm_vcpu 
*vcpu, struct vgic_irq *irq,
  				    bool active)
  {
  	unsigned long flags;
-	struct kvm_vcpu *requester_vcpu = kvm_get_running_vcpu();
+	struct kvm_vcpu *requester_vcpu = vgic_get_mmio_requester_vcpu();

  	raw_spin_lock_irqsave(&irq->irq_lock, flags);


That's basically a revert of the offending code. The comment right above
vgic_get_mmio_requester_vcpu() explains *why* this is valid, and why
preempt_disable() is needed.

Can you please give it a shot?

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
