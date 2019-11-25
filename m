Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1C7108B2F
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 10:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfKYJtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 04:49:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44101 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727052AbfKYJtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 04:49:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574675350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LI90vjXh2HXUGcnDPIxy5xrhkGpcg6ttLKuY2YJfARU=;
        b=aIJofAWWfB45O1ifaaxgp7F/Mjy1pA1nLVDUAcyWtMsyiRe3ITdUx6z74ODSBP6PynCYGg
        eM1z+ZGaFwr3N4hMhV50tdhiULR7DbGujZAbjcREIuq90IJNcRakCl2cop7aIl7OPRYzM6
        ZrxQdxOGrQZuhqC8koLF60rIleQGw6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-8zfc_lBjPRynSK0RUXnuaA-1; Mon, 25 Nov 2019 04:49:09 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1D0E107ACE5;
        Mon, 25 Nov 2019 09:49:07 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DDD510016DA;
        Mon, 25 Nov 2019 09:49:00 +0000 (UTC)
Date:   Mon, 25 Nov 2019 10:48:59 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     gengdongjiu <gengdongjiu@huawei.com>, peter.maydell@linaro.org,
        ehabkost@redhat.com, kvm@vger.kernel.org,
        wanghaibin.wang@huawei.com, mtosatti@redhat.com,
        qemu-devel@nongnu.org, linuxarm@huawei.com,
        shannon.zhaosl@gmail.com, Xiang Zheng <zhengxiang9@huawei.com>,
        qemu-arm@nongnu.org, james.morse@arm.com,
        jonathan.cameron@huawei.com, pbonzini@redhat.com,
        xuwei5@huawei.com, lersek@redhat.com, rth@twiddle.net
Subject: Re: [RESEND PATCH v21 3/6] ACPI: Add APEI GHES table generation
 support
Message-ID: <20191125104859.70047602@redhat.com>
In-Reply-To: <20191118082036-mutt-send-email-mst@kernel.org>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
        <20191111014048.21296-4-zhengxiang9@huawei.com>
        <20191115103801.547fc84d@redhat.com>
        <cf5e5aa4-2283-6cf9-70d0-278d167e3a13@huawei.com>
        <87758ec2-c242-71c3-51f8-a5d348f8e7fd@huawei.com>
        <20191118082036-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 8zfc_lBjPRynSK0RUXnuaA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Nov 2019 08:21:18 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Nov 18, 2019 at 09:18:01PM +0800, gengdongjiu wrote:
> > On 2019/11/18 20:49, gengdongjiu wrote:  
> > >>> +     */
> > >>> +    build_append_int_noprefix(table_data, source_id, 2);
> > >>> +    /* Related Source Id */
> > >>> +    build_append_int_noprefix(table_data, 0xffff, 2);
> > >>> +    /* Flags */
> > >>> +    build_append_int_noprefix(table_data, 0, 1);
> > >>> +    /* Enabled */
> > >>> +    build_append_int_noprefix(table_data, 1, 1);
> > >>> +
> > >>> +    /* Number of Records To Pre-allocate */
> > >>> +    build_append_int_noprefix(table_data, 1, 4);
> > >>> +    /* Max Sections Per Record */
> > >>> +    build_append_int_noprefix(table_data, 1, 4);
> > >>> +    /* Max Raw Data Length */
> > >>> +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH, 4);
> > >>> +
> > >>> +    /* Error Status Address */
> > >>> +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
> > >>> +                     4 /* QWord access */, 0);
> > >>> +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
> > >>> +        ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(hest_start, source_id),  
> > >> it's fine only if GHESv2 is the only entries in HEST, but once
> > >> other types are added this macro will silently fall apart and
> > >> cause table corruption.  
> >    why  silently fall?
> >    I think the acpi_ghes.c only support GHESv2 type, not support other type.
> >   
> > >>
> > >> Instead of offset from hest_start, I suggest to use offset relative
> > >> to GAS structure, here is an idea>>
> > >> #define GAS_ADDR_OFFSET 4
> > >>
> > >>     off = table->len
> > >>     build_append_gas()
> > >>     bios_linker_loader_add_pointer(...,
> > >>         off + GAS_ADDR_OFFSET, ...  
> > 
> > If use offset relative to GAS structure, the code does not easily extend to support more Generic Hardware Error Source.
> > if use offset relative to hest_start, just use a loop, the code can support  more error source, for example:
> > for (source_id = 0; i<n; source_id++)
> > {
> >    ......
> >     bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
> >         ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(hest_start, source_id),
> >         sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE,
> >         source_id * sizeof(uint64_t));
> >   .......
> > }
> > 
> > My previous series patch support 2 error sources, but now only enable 'SEA' type Error Source  
> 
> I'd try to merge this, worry about extending things later.
> This is at v21 and the simpler you can keep things,
> the faster it'll go in.
I don't think the series is ready for merging yet.
It has a number of issues (not stylistic ones) that need to be fixed first.

As for extending, I think I've suggested to simplify series
to account for single error source only in some places so it
would be easier on author and reviewers and worry about extending
it later.


