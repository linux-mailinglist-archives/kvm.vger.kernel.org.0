Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD121F7253
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 05:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgFLDBZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 11 Jun 2020 23:01:25 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2519 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbgFLDBZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 23:01:25 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 69D336AFA63EBD4CDCDE;
        Fri, 12 Jun 2020 11:01:20 +0800 (CST)
Received: from DGGEMM508-MBX.china.huawei.com ([169.254.2.47]) by
 DGGEMM401-HUB.china.huawei.com ([10.3.20.209]) with mapi id 14.03.0487.000;
 Fri, 12 Jun 2020 11:01:11 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wangxin (Alexander, Cloud Infrastructure Service Product Dept.)" 
        <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: RE: [PATCH] kvm: support to get/set dirty log initial-all-set
 capability
Thread-Topic: [PATCH] kvm: support to get/set dirty log initial-all-set
 capability
Thread-Index: AQHV8dBzPdW/4AkL+0GBczXBKqWav6hNu5OAgIcppiA=
Date:   Fri, 12 Jun 2020 03:01:10 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BD26B9F@dggemm508-mbx.china.huawei.com>
References: <20200304025554.2159-1-jianjay.zhou@huawei.com>
 <18e7b781-8a52-d78a-a653-898445a5ee53@redhat.com>
In-Reply-To: <18e7b781-8a52-d78a-a653-898445a5ee53@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.149.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> Sent: Wednesday, March 18, 2020 6:48 PM
> To: Zhoujian (jay) <jianjay.zhou@huawei.com>; qemu-devel@nongnu.org;
> kvm@vger.kernel.org
> Cc: mst@redhat.com; cohuck@redhat.com; peterx@redhat.com; wangxin (U)
> <wangxinxin.wang@huawei.com>; Huangweidong (C)
> <weidong.huang@huawei.com>; Liujinsong (Paul) <liu.jinsong@huawei.com>
> Subject: Re: [PATCH] kvm: support to get/set dirty log initial-all-set capability
> 
> On 04/03/20 03:55, Jay Zhou wrote:
> > Since the new capability KVM_DIRTY_LOG_INITIALLY_SET of
> > KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 has been introduced in the kernel,
> > tweak the userspace side to detect and enable this capability.
> >
> > Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
> > ---
> >  accel/kvm/kvm-all.c       | 21 ++++++++++++++-------
> >  linux-headers/linux/kvm.h |  3 +++
> >  2 files changed, 17 insertions(+), 7 deletions(-)
> >
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c index
> > 439a4efe52..45ab25be63 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -100,7 +100,7 @@ struct KVMState
> >      bool kernel_irqchip_required;
> >      OnOffAuto kernel_irqchip_split;
> >      bool sync_mmu;
> > -    bool manual_dirty_log_protect;
> > +    uint64_t manual_dirty_log_protect;
> >      /* The man page (and posix) say ioctl numbers are signed int, but
> >       * they're not.  Linux, glibc and *BSD all treat ioctl numbers as
> >       * unsigned, and treating them as signed here can break things */
> > @@ -1882,6 +1882,7 @@ static int kvm_init(MachineState *ms)
> >      int ret;
> >      int type = 0;
> >      const char *kvm_type;
> > +    uint64_t dirty_log_manual_caps;
> >
> >      s = KVM_STATE(ms->accelerator);
> >
> > @@ -2007,14 +2008,20 @@ static int kvm_init(MachineState *ms)
> >      s->coalesced_pio = s->coalesced_mmio &&
> >                         kvm_check_extension(s,
> KVM_CAP_COALESCED_PIO);
> >
> > -    s->manual_dirty_log_protect =
> > +    dirty_log_manual_caps =
> >          kvm_check_extension(s,
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> > -    if (s->manual_dirty_log_protect) {
> > -        ret = kvm_vm_enable_cap(s,
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0, 1);
> > +    dirty_log_manual_caps &=
> (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
> > +                              KVM_DIRTY_LOG_INITIALLY_SET);
> > +    s->manual_dirty_log_protect = dirty_log_manual_caps;
> > +    if (dirty_log_manual_caps) {
> > +        ret = kvm_vm_enable_cap(s,
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0,
> > +                                   dirty_log_manual_caps);
> >          if (ret) {
> > -            warn_report("Trying to enable
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 "
> > -                        "but failed.  Falling back to the legacy mode. ");
> > -            s->manual_dirty_log_protect = false;
> > +            warn_report("Trying to enable capability %"PRIu64" of "
> > +                        "KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
> but failed. "
> > +                        "Falling back to the legacy mode. ",
> > +                        dirty_log_manual_caps);
> > +            s->manual_dirty_log_protect = 0;
> >          }
> >      }
> >
> > diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> > index 265099100e..3cb71c2b19 100644
> > --- a/linux-headers/linux/kvm.h
> > +++ b/linux-headers/linux/kvm.h
> > @@ -1628,4 +1628,7 @@ struct kvm_hyperv_eventfd {
> >  #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
> >  #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
> >
> > +#define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
> > +#define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
> > +
> >  #endif /* __LINUX_KVM_H */
> >
> 
> Queued, thanks.
> 

Hi Paolo,

It seems that this patch isn't included in your last pull request...
If there's something else to be done, please let me know.

Regards,
Jay Zhou
