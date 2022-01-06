Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8813486396
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 12:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238363AbiAFLS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 06:18:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229624AbiAFLS1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 06:18:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641467906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATADdWEWHgsDGmP6ve5kl+qqOOoCJinGEGLWTpTlcDE=;
        b=ZjyoYskIuIoXVZeRwRCC4LQzRNs2ciwHGC6YVRCCtNI/fuRdBBa2xyvhO5tsFKq60tIMKk
        9ELnbkeeyiGMKuypvkQ1pT4vMDGKNCACwfBieUzSFskjZ14q2MSYOTc5Fe2qXQbYby8NDK
        qPau52JI1F3L/zODCe/mNo7oBDJn5c4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-LJ5GlX0uOZS2wb85Wgs9wQ-1; Thu, 06 Jan 2022 06:18:23 -0500
X-MC-Unique: LJ5GlX0uOZS2wb85Wgs9wQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15172801962;
        Thu,  6 Jan 2022 11:18:22 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA5DA752AE;
        Thu,  6 Jan 2022 11:18:20 +0000 (UTC)
Message-ID: <9eb6286bf6181ec33017adb2ec95f10b8e7f1135.camel@redhat.com>
Subject: Re: [Bug 215459] New: VM freezes starting with kernel 5.15
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>
Date:   Thu, 06 Jan 2022 13:18:19 +0200
In-Reply-To: <bug-215459-28872@https.bugzilla.kernel.org/>
References: <bug-215459-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-01-06 at 11:03 +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=215459
> 
>             Bug ID: 215459
>            Summary: VM freezes starting with kernel 5.15
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 5.15.*
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: th3voic3@mailbox.org
>         Regression: No
> 
> Created attachment 300234
>   --> https://bugzilla.kernel.org/attachment.cgi?id=300234&action=edit
> qemu.hook and libvirt xml
> 
> Hi,
> 
> starting with kernel 5.15 I'm experiencing freezes in my VFIO Windows 10 VM.
> Downgrading to 5.14.16 fixes the issue.
> 
> I can't find any error messages in dmesg when this happens and comparing the
> dmesg output between 5.14.16 and 5.15.7 didn't show any differences.
> 
> 
> Additional info:
> * 5.15.x
> * I'm attaching my libvirt config and my /etc/libvirt/hooks/qemu
> * My specs are:
> ** i7-10700k
> ** ASUS z490-A PRIME Motherboard
> ** 64 GB RAM
> ** Passthrough Card: NVIDIA 2070 Super
> ** Host is using the integrated Graphics chip
> 
> Steps to reproduce:
> Boot any 5.15 kernel and start the VM and after some time (no specific trigger
> as far as I can see) the VM freezes.
> 
> After some testing the solution seems to be:
> 
> I read about this:
> 20210713142023.106183-9-mlevitsk@redhat.com/#24319635">
> https://patchwork.kernel.org/project/kvm/patch/20210713142023.106183-9-mlevitsk@redhat.com/#24319635
> 
> And so I checked
> cat /sys/module/kvm_intel/parameters/enable_apicv
> 
> which returns Y to me by default.
> 
> So I added
> options kvm_intel enable_apicv=0
> to /etc/modprobe.d/kvm.conf
> 
> 
> cat /sys/module/kvm_intel/parameters/enable_apicv
> now returns N
> 
> So far I haven't encountered any freezes.
> 
> The confusing part is that APICv shouldn't be available with my CPU

I guess you are lucky and your cpu has it? 
Does /sys/module/kvm_intel/parameters/enable_apicv show Y on 5.14.16 as well?

I know that there were few fixes in regard to posted interrupts on intel,
which might explain the problem.

You might want to try 5.16 kernel when it released.

Best regards,
	Maxim Levitsky

> 


