Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509FB10AFE1
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 14:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfK0NDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 08:03:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46720 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726520AbfK0NDD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 08:03:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574859782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MhNCOsvJPMtp9M0w6J6gP6EZj9Mvu/pSvuBtYlRmiWQ=;
        b=cXs7Tm5icyoV1X/5u+jhD+OFa1hDogwmNfQIFaBJMPDQAvyOwJeEzikrMFgDoyc9J0YmiQ
        Cd0m2Jy0EK0JUQVqlY+mY5nooDnKULp+ndz4apQ50QPpyrT3/ahfOwVhBm5q1U+Mk+UlTU
        Rf7MjdJm8HBfmD5kTGA1+++FRpnOu7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-_aY8ewblOoSi9eA6JHseFw-1; Wed, 27 Nov 2019 08:02:59 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7594A107BABB;
        Wed, 27 Nov 2019 13:02:57 +0000 (UTC)
Received: from localhost (ovpn-204-134.brq.redhat.com [10.40.204.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 401495C219;
        Wed, 27 Nov 2019 13:02:25 +0000 (UTC)
Date:   Wed, 27 Nov 2019 14:02:23 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     Beata Michalska <beata.michalska@linaro.org>,
        <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        "Laszlo Ersek" <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <jonathan.cameron@huawei.com>,
        <xuwei5@huawei.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <linuxarm@huawei.com>, <wanghaibin.wang@huawei.com>
Subject: Re: [RESEND PATCH v21 5/6] target-arm: kvm64: handle SIGBUS signal
 from kernel or KVM
Message-ID: <20191127140223.58d1a35b@redhat.com>
In-Reply-To: <22a3935a-a672-f8f1-e5be-6c0725f738c4@huawei.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
        <20191111014048.21296-6-zhengxiang9@huawei.com>
        <CADSWDztF=eaUDNnq8bhnPyTKW1YjAWm4UBaH-NBPkzjnzx0bxg@mail.gmail.com>
        <22a3935a-a672-f8f1-e5be-6c0725f738c4@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: _aY8ewblOoSi9eA6JHseFw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Nov 2019 20:47:15 +0800
Xiang Zheng <zhengxiang9@huawei.com> wrote:

> Hi Beata,
> 
> Thanks for you review!
> 
> On 2019/11/22 23:47, Beata Michalska wrote:
> > Hi,
> > 
> > On Mon, 11 Nov 2019 at 01:48, Xiang Zheng <zhengxiang9@huawei.com> wrote:  
> >>
> >> From: Dongjiu Geng <gengdongjiu@huawei.com>
> >>
> >> Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
> >> translates the host VA delivered by host to guest PA, then fills this PA
> >> to guest APEI GHES memory, then notifies guest according to the SIGBUS
> >> type.
> >>
> >> When guest accesses the poisoned memory, it will generate a Synchronous
> >> External Abort(SEA). Then host kernel gets an APEI notification and calls
> >> memory_failure() to unmapped the affected page in stage 2, finally
> >> returns to guest.
> >>
> >> Guest continues to access the PG_hwpoison page, it will trap to KVM as
> >> stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
> >> Qemu, Qemu records this error address into guest APEI GHES memory and
> >> notifes guest using Synchronous-External-Abort(SEA).
> >>
> >> In order to inject a vSEA, we introduce the kvm_inject_arm_sea() function
> >> in which we can setup the type of exception and the syndrome information.
> >> When switching to guest, the target vcpu will jump to the synchronous
> >> external abort vector table entry.
> >>
> >> The ESR_ELx.DFSC is set to synchronous external abort(0x10), and the
> >> ESR_ELx.FnV is set to not valid(0x1), which will tell guest that FAR is
> >> not valid and hold an UNKNOWN value. These values will be set to KVM
> >> register structures through KVM_SET_ONE_REG IOCTL.
> >>
> >> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> >> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> >> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> >> ---
[...]
> >> diff --git a/include/hw/acpi/acpi_ghes.h b/include/hw/acpi/acpi_ghes.h
> >> index cb62ec9c7b..8e3c5b879e 100644
> >> --- a/include/hw/acpi/acpi_ghes.h
> >> +++ b/include/hw/acpi/acpi_ghes.h
> >> @@ -24,6 +24,9 @@
> >>
> >>  #include "hw/acpi/bios-linker-loader.h"
> >>
> >> +#define ACPI_GHES_CPER_OK                   1
> >> +#define ACPI_GHES_CPER_FAIL                 0
> >> +  
> > 
> > Is there really a need to introduce those ?
> >   
> 
> Don't you think it's more clear than using "1" or "0"? :)

or maybe just reuse default libc return convention: 0 - ok, -1 - fail
and drop custom macros

> 
> >>  /*
> >>   * Values for Hardware Error Notification Type field
> >>   */
[...]

