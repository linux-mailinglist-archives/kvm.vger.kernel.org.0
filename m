Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1E4157491
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 13:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgBJMbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 07:31:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48513 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726950AbgBJMbe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 07:31:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581337893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z1Vu1maQTpBDvCRALrAvpDS5q5kK3fJYx8cOOVPbIT0=;
        b=iw8AhcHkWjaRZRqPITj5Su+3ebLGEfT5v2kBontwAxY5f8eNver640vGPLEBakpzrTju0b
        HYywFMzy8oXxrX37phKsC1JdBSEUnYrTd8B6LkdSiRdydSyg/PxvN+399ffxG/cRKV+3uu
        gN7iTQJPrL+//Yp8Vipq541Oo/qWcEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-RDZeIp7TO6-PEAwLNX4XAQ-1; Mon, 10 Feb 2020 07:31:31 -0500
X-MC-Unique: RDZeIp7TO6-PEAwLNX4XAQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9D8DA0CC0;
        Mon, 10 Feb 2020 12:31:29 +0000 (UTC)
Received: from gondolin (ovpn-117-244.ams2.redhat.com [10.36.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 463EF10013A7;
        Mon, 10 Feb 2020 12:31:25 +0000 (UTC)
Date:   Mon, 10 Feb 2020 13:31:22 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 03/35] s390/protvirt: introduce host side setup
Message-ID: <20200210133122.2a5a799c.cohuck@redhat.com>
In-Reply-To: <f8175088-2041-46ac-dee7-8d0e7b22863d@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-4-borntraeger@de.ibm.com>
        <20200210125452.7f66706d.cohuck@redhat.com>
        <f8175088-2041-46ac-dee7-8d0e7b22863d@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Feb 2020 13:14:03 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 10.02.20 12:54, Cornelia Huck wrote:
> > On Fri,  7 Feb 2020 06:39:26 -0500
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> From: Vasily Gorbik <gor@linux.ibm.com>
> >>
> >> Add "prot_virt" command line option which controls if the kernel
> >> protected VMs support is enabled at early boot time. This has to be
> >> done early, because it needs large amounts of memory and will disable
> >> some features like STP time sync for the lpar.
> >>
> >> Extend ultravisor info definitions and expose it via uv_info struct
> >> filled in during startup.
> >>
> >> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> >> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> ---
> >>  .../admin-guide/kernel-parameters.txt         |  5 ++
> >>  arch/s390/boot/Makefile                       |  2 +-
> >>  arch/s390/boot/uv.c                           | 21 +++++++-
> >>  arch/s390/include/asm/uv.h                    | 46 +++++++++++++++--
> >>  arch/s390/kernel/Makefile                     |  1 +
> >>  arch/s390/kernel/setup.c                      |  4 --
> >>  arch/s390/kernel/uv.c                         | 49 +++++++++++++++++++
> >>  7 files changed, 119 insertions(+), 9 deletions(-)
> >>  create mode 100644 arch/s390/kernel/uv.c  
> > 
> > (...)
> >   
> >> diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
> >> index e2c47d3a1c89..30f1811540c5 100644
> >> --- a/arch/s390/boot/Makefile
> >> +++ b/arch/s390/boot/Makefile
> >> @@ -37,7 +37,7 @@ CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
> >>  obj-y	:= head.o als.o startup.o mem_detect.o ipl_parm.o ipl_report.o
> >>  obj-y	+= string.o ebcdic.o sclp_early_core.o mem.o ipl_vmparm.o cmdline.o
> >>  obj-y	+= version.o pgm_check_info.o ctype.o text_dma.o
> >> -obj-$(CONFIG_PROTECTED_VIRTUALIZATION_GUEST)	+= uv.o
> >> +obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_PGSTE))	+= uv.o  
> > 
> > I'm wondering why you're checking CONFIG_PGSTE here...  
> 
> It was just simpler for a Makefile, because CONFIG_KVM can be m or y.
> PGSTE is always y when CONFIG_KVM is set. Suggestions welcome.

My only complaint is that it is a bit non-obvious at a glance... but
yeah, I don't have a better suggestion, either.

> 
> [...]
> 
> >> +		prot_virt_host = 0;
> >> +		pr_info("Running as protected virtualization guest.");
> >> +	}
> >> +
> >> +	if (prot_virt_host && !test_facility(158)) {
> >> +		prot_virt_host = 0;
> >> +		pr_info("The ultravisor call facility is not available.");
> >> +	}  
> > 
> > What about prefixing these two with 'prot_virt:'? It seems the name is
> > settled now?  
> 
> It is not settled, but I can certainly do something like
> 
> #define KMSG_COMPONENT "prot_virt"
> #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> 
> 
> to prefix all pr_* calls in this file.

That would make it easier to associate any messages (especially the
second message here) with this feature, I think.

