Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7042F108B06
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 10:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfKYJhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 04:37:20 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25421 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727052AbfKYJhT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Nov 2019 04:37:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574674638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PiqjedxAFN+dSi/udCuMYwMO1iGMtAE7u2HqW+1iDsw=;
        b=MxtuzZw5NL03FbM1TZmzrCMsI9B+zKBv7AMa7WQyFnKHK2+IGNEEm67AJnfti1um6rERMJ
        BzGcmNRuKI3g4VPw+mVUKyfnvNvHyL/XqGCBO8lMNfF736rPGlCvtYa1eQ/MUm6flRAanU
        LhbM7CjykuSwiennrERXZzNrucaThPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-LZIhOXWON6yAqii7gehcAg-1; Mon, 25 Nov 2019 04:37:16 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93B7B801E5E;
        Mon, 25 Nov 2019 09:37:14 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DA585C1D4;
        Mon, 25 Nov 2019 09:37:08 +0000 (UTC)
Date:   Mon, 25 Nov 2019 10:37:06 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Beata Michalska <beata.michalska@linaro.org>
Cc:     Xiang Zheng <zhengxiang9@huawei.com>,
        Peter Maydell <peter.maydell@linaro.org>, ehabkost@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, wanghaibin.wang@huawei.com,
        mtosatti@redhat.com, linuxarm@huawei.com, qemu-devel@nongnu.org,
        gengdongjiu@huawei.com, shannon.zhaosl@gmail.com,
        qemu-arm@nongnu.org, james.morse@arm.com, xuwei5@huawei.com,
        jonathan.cameron@huawei.com, pbonzini@redhat.com,
        Laszlo Ersek <lersek@redhat.com>, rth@twiddle.net
Subject: Re: [RESEND PATCH v21 5/6] target-arm: kvm64: handle SIGBUS signal
 from kernel or KVM
Message-ID: <20191125103706.46300ff1@redhat.com>
In-Reply-To: <CADSWDzsg9aMCbbLadmc+twmJw3dZvRYgqKKWsDQRiJSRS7=GDQ@mail.gmail.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
        <20191111014048.21296-6-zhengxiang9@huawei.com>
        <20191115173713.795e5f63@redhat.com>
        <CADSWDzsg9aMCbbLadmc+twmJw3dZvRYgqKKWsDQRiJSRS7=GDQ@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: LZIhOXWON6yAqii7gehcAg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Nov 2019 15:47:24 +0000
Beata Michalska <beata.michalska@linaro.org> wrote:

> Hi,
> 
> On Fri, 15 Nov 2019 at 16:54, Igor Mammedov <imammedo@redhat.com> wrote:
> >
> > On Mon, 11 Nov 2019 09:40:47 +0800
> > Xiang Zheng <zhengxiang9@huawei.com> wrote:
> >  
> > > From: Dongjiu Geng <gengdongjiu@huawei.com>
> > >
> > > Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
> > > translates the host VA delivered by host to guest PA, then fills this PA
> > > to guest APEI GHES memory, then notifies guest according to the SIGBUS
> > > type.
> > >
> > > When guest accesses the poisoned memory, it will generate a Synchronous
> > > External Abort(SEA). Then host kernel gets an APEI notification and calls
> > > memory_failure() to unmapped the affected page in stage 2, finally
> > > returns to guest.
> > >
> > > Guest continues to access the PG_hwpoison page, it will trap to KVM as
> > > stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
> > > Qemu, Qemu records this error address into guest APEI GHES memory and
> > > notifes guest using Synchronous-External-Abort(SEA).
> > >
> > > In order to inject a vSEA, we introduce the kvm_inject_arm_sea() function
> > > in which we can setup the type of exception and the syndrome information.
> > > When switching to guest, the target vcpu will jump to the synchronous
> > > external abort vector table entry.
> > >
> > > The ESR_ELx.DFSC is set to synchronous external abort(0x10), and the
> > > ESR_ELx.FnV is set to not valid(0x1), which will tell guest that FAR is
> > > not valid and hold an UNKNOWN value. These values will be set to KVM
> > > register structures through KVM_SET_ONE_REG IOCTL.
> > >
> > > Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> > > Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> > > Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >  hw/acpi/acpi_ghes.c         | 297 ++++++++++++++++++++++++++++++++++++
[...]
> > > +static int acpi_ghes_record_mem_error(uint64_t error_block_address,
> > > +                                      uint64_t error_physical_addr,
> > > +                                      uint32_t data_length)
> > > +{
> > > +    GArray *block;
> > > +    uint64_t current_block_length;
> > > +    /* Memory Error Section Type */
> > > +    QemuUUID mem_section_id_le = UEFI_CPER_SEC_PLATFORM_MEM;  
> >                                ^^
> > UEFI_CPER_SEC_PLATFORM_MEM is defined as BE, so _le here is wrong
> > and then later you use qemu_uuid_bswap() to make it LE.
> >
> > Why not define it as LE to begin with, like it's been done for NVDIMM_UUID_LE?
> >  
> Is there a chance to make it common for both ?

sure, it just should be a separate patch.

Maybe put it in include/qemu/uuid.h
or maybe make qemu_uuid_parse() return QemuUUID
so we could initialize like this:
  QemuUUID mem_section_id_le = qemu_uuid_parse("00000000-0000-0000-0000-000000000000", &error_abort);
where used UUID value is easy to read and compare with spec.

[...]

