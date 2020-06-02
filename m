Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CA21EC164
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 19:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgFBRwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 13:52:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25132 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726019AbgFBRwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 13:52:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591120339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=URgOspDtaF5Lg52G4wR8tB6sjeqRqyEK+U8R2hZLan4=;
        b=KqRreJtk+qWsQ/MnOMRPUFjaxU+puZDIWSvOwCg8Gw91JbPXD7dz98atc7P5YjZDMSlb1E
        tuqBNFPx3HwuJWcmFApf/x/Q7E+hOfHSNNak86A9ZnSx4UKh3GbvMM6Lx92+mIol5eXtvx
        KjtIBsInLBD/8z9mT2dS8RkE0lBerXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-A4xhvWFMOUS5cvkMeNxwzw-1; Tue, 02 Jun 2020 13:52:17 -0400
X-MC-Unique: A4xhvWFMOUS5cvkMeNxwzw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68B4E872FE2;
        Tue,  2 Jun 2020 17:52:16 +0000 (UTC)
Received: from localhost (ovpn-113-102.phx2.redhat.com [10.3.113.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2032278EF6;
        Tue,  2 Jun 2020 17:52:12 +0000 (UTC)
Date:   Tue, 2 Jun 2020 13:52:12 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     mst@redhat.com, marcel.apfelbaum@gmail.com, pbonzini@redhat.com,
        rth@twiddle.net, mtosatti@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, kash@tripleback.net, geoff@hostfission.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v13 1/5] i386: Add support for CPUID_8000_001E for AMD
Message-ID: <20200602175212.GH577771@habkost.net>
References: <1528498581-131037-1-git-send-email-babu.moger@amd.com>
 <1528498581-131037-2-git-send-email-babu.moger@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528498581-131037-2-git-send-email-babu.moger@amd.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 08, 2018 at 06:56:17PM -0400, Babu Moger wrote:
> Add support for cpuid leaf CPUID_8000_001E. Build the config that closely
> match the underlying hardware. Please refer to the Processor Programming
> Reference (PPR) for AMD Family 17h Model for more details.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
[...]
> +    case 0x8000001E:
> +        assert(cpu->core_id <= 255);

It is possible to trigger this assert using:

$ qemu-system-x86_64 -machine q35,accel=kvm,kernel-irqchip=split -device intel-iommu,intremap=on,eim=on -smp 1,maxcpus=258,cores=258,threads=1,sockets=1 -cpu qemu64,xlevel=0x8000001e -device qemu64-x86_64-cpu,apic-id=257
qemu-system-x86_64: warning: Number of hotpluggable cpus requested (258) exceeds the recommended cpus supported by KVM (240)
qemu-system-x86_64: /home/ehabkost/rh/proj/virt/qemu/target/i386/cpu.c:5888: cpu_x86_cpuid: Assertion `cpu->core_id <= 255' failed.
Aborted (core dumped)

See bug report and discussion at
https://bugzilla.redhat.com/show_bug.cgi?id=1834200

Also, it looks like encode_topo_cpuid8000001e() assumes core_id
has only 3 bits, so the existing assert() is not even sufficient.
We need to decide what to do if the user requests nr_cores > 8.

Probably omitting CPUID[0x8000001E] if the VCPU topology is
incompatible with encode_topo_cpuid8000001e() (and printing a
warning) is the safest thing to do right now.



> +        encode_topo_cpuid8000001e(cs, cpu,
> +                                  eax, ebx, ecx, edx);
> +        break;
>      case 0xC0000000:
>          *eax = env->cpuid_xlevel2;
>          *ebx = 0;
> -- 
> 1.8.3.1
> 

-- 
Eduardo

