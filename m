Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211C650996
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 13:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbfFXLQk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Jun 2019 07:16:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbfFXLQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 07:16:40 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0EC0A4D29;
        Mon, 24 Jun 2019 11:16:39 +0000 (UTC)
Received: from localhost (unknown [10.43.2.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67D2D1001DD5;
        Mon, 24 Jun 2019 11:16:33 +0000 (UTC)
Date:   Mon, 24 Jun 2019 13:16:29 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
Subject: Re: [Qemu-devel] [PATCH v17 02/10] ACPI: add some GHES structures
 and macros definition
Message-ID: <20190624131629.7f586861@redhat.com>
In-Reply-To: <ec089c94-589b-782c-1bdc-1b2c74e0ea46@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
        <1557832703-42620-3-git-send-email-gengdongjiu@huawei.com>
        <20190620141052.370788fb@redhat.com>
        <f4f94ecb-200c-3e18-1a09-5fb6bc761834@huawei.com>
        <20190620170934.39eae310@redhat.com>
        <ec089c94-589b-782c-1bdc-1b2c74e0ea46@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 24 Jun 2019 11:16:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Jun 2019 01:17:48 +0800
gengdongjiu <gengdongjiu@huawei.com> wrote:

> On 2019/6/20 23:09, Igor Mammedov wrote:
> > On Thu, 20 Jun 2019 22:04:01 +0800
> > gengdongjiu <gengdongjiu@huawei.com> wrote:
> >   
> >> Hi Igor,
> >>    Thanks for your review.
> >>
> >> On 2019/6/20 20:10, Igor Mammedov wrote:  
> >>>> + */
> >>>> +struct AcpiGenericErrorStatus {
> >>>> +    /* It is a bitmask composed of ACPI_GEBS_xxx macros */
> >>>> +    uint32_t block_status;
> >>>> +    uint32_t raw_data_offset;
> >>>> +    uint32_t raw_data_length;
> >>>> +    uint32_t data_length;
> >>>> +    uint32_t error_severity;
> >>>> +} QEMU_PACKED;
> >>>> +typedef struct AcpiGenericErrorStatus AcpiGenericErrorStatus;    
> >>> there shouldn't be packed structures,
> >>> is it a leftover from previous version?    
> >>
> >> I remember some people suggest to add QEMU_PACKED before, anyway I will remove it in my next version patch.  
> > 
> > Question is why it's  there and where it is used?  
> sorry, it is my carelessness. it should be packed structures.
> 
> I used this structures to get its actual total size and member offset in [PATCH v17 10/10].
> If it is not packed structures, the total size and member offset may be not right.
I'd suggest to drop these typedefs and use a macro with size for that purpose,
Also it might be good to make it local to the file that would use it.

> > 
> > BTW:
> > series doesn't apply to master anymore.
> > Do you have a repo somewhere available for testing?  
> 
> Thanks, I appreciated that you can have a test.
> 
> I still do not upload repo, you can reset to below commit[1] in master and apply this series.
> 
> BTW：
> If test series, you should make an guest memory hardware error, let guest access the error address, then it will happen RAS error.
> I provide a software hard code method to test this series, you can refer to https://www.mail-archive.com/qemu-devel@nongnu.org/msg619771.html
> 
> 
> [1]:
> commit efb4f3b62c69383a7308d7b739a3193e7c0ccae8
> Merge: 5f02262 e841257
> Author: Peter Maydell <peter.maydell@linaro.org>
> Date:   Fri May 10 14:49:36 2019 +0100
> 
> 
> 
> >   
> >>  
> >>>     
> >>>> +
> >>>> +/*
> >>>> + * Masks for block_status flags above
> >>>> + */
> >>>> +#define ACPI_GEBS_UNCORRECTABLE         1
> >>>> +
> >>>> +/*    
> >>  
> > 
> > .
> >   
> 

