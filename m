Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F58A15021B
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 08:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbgBCHvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 02:51:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21764 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727339AbgBCHvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 02:51:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580716312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=shrxJcLWYa5dcYmO7shA/1HAHpE7/18QYuBpgSLW+Y0=;
        b=BG+gPlFvXR9u5TTU+6jDQOSSbi+zenA67zz62B4k6BxdS46+2O66XbZosTcEbzW/2GySIR
        jr0QhKDpvO5cCxD35UijNDAUbctXjoKZZASRQfO+8w5bBVt4qWIYK5qn/QZ41W0+NBIX2v
        nqa2aoQx0gCmEInvSzDbxBTR9Y5Qu3s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-QSFWe5ESNBOfXFi1a38mKw-1; Mon, 03 Feb 2020 02:51:50 -0500
X-MC-Unique: QSFWe5ESNBOfXFi1a38mKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86F1D1800D41;
        Mon,  3 Feb 2020 07:51:48 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC52960BE2;
        Mon,  3 Feb 2020 07:51:41 +0000 (UTC)
Date:   Mon, 3 Feb 2020 08:51:40 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <xuwei5@huawei.com>,
        <jonathan.cameron@huawei.com>, <james.morse@arm.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, <zhengxiang9@huawei.com>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH v22 5/9] ACPI: Record the Generic Error Status Block
 address
Message-ID: <20200203085140.2e7ab793@redhat.com>
In-Reply-To: <02a78eff-865c-b9e0-6d5f-d4caa4daa98d@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
        <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
        <20200128154110.04baa5bc@redhat.com>
        <02a78eff-865c-b9e0-6d5f-d4caa4daa98d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2 Feb 2020 20:44:35 +0800
gengdongjiu <gengdongjiu@huawei.com> wrote:

> sorry for the late response due to Chinese new year
> 
> On 2020/1/28 22:41, Igor Mammedov wrote:
> > On Wed, 8 Jan 2020 19:32:19 +0800
> > Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> > 
> > in addition to comments of others:
> >   
> >> Record the GHEB address via fw_cfg file, when recording
> >> a error to CPER, it will use this address to find out
> >> Generic Error Data Entries and write the error.
> >>
> >> Make the HEST GHES to a GED device.  
[...]
> >> @@ -831,7 +832,9 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
> >>      acpi_add_table(table_offsets, tables_blob);
> >>      build_spcr(tables_blob, tables->linker, vms);
> >>  
> >> -    if (vms->ras) {
> >> +    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
> >> +                                                       NULL));
> >> +    if (acpi_ged_state &&  vms->ras) {  
> > 
> > there is vms->acpi_dev which is GED, so you don't need to look it up
> > 
> > suggest:  
>    Thanks for the suggestion.
> 
> >  if (ras) {
> >     assert(ged)  
>       assert(vms->acpi_dev), right?

yes, something like this.

 
> >     do other fun stuff ...
> >  }  
> 
> >   
> >>          acpi_add_table(table_offsets, tables_blob);
> >>          build_ghes_error_table(tables->hardware_errors, tables->linker);
> >>          acpi_build_hest(tables_blob, tables->hardware_errors,
[...]

