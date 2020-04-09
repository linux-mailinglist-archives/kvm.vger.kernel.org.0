Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0337D1A2D48
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 03:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgDIBUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 21:20:17 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54226 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726552AbgDIBUR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Apr 2020 21:20:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586395216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N9F88D41AN3wkh0UGnOOoypW5BsejuARZQ7sojSiFhI=;
        b=eQTwJJf6vWYRqr1nzT8kIWwddtBy5j+h7gtwcjKgEG+CD9JICWPryRI0pw6jHua3Ck0bvV
        MVTzX2me4DOwRwtwBPR8n6BCyuA1yrK65bXSp0/hX37SlpVNoEZa0clNA8NQnFvcNQJwyh
        ldyN/bf7/JD+BoKbrwTgM3sk9aqh2Bs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-7q_H4IkgPEqEfQbfQ1clSg-1; Wed, 08 Apr 2020 21:20:10 -0400
X-MC-Unique: 7q_H4IkgPEqEfQbfQ1clSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0826E8017F5;
        Thu,  9 Apr 2020 01:20:09 +0000 (UTC)
Received: from localhost (ovpn-12-133.pek2.redhat.com [10.72.12.133])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7725B9DD78;
        Thu,  9 Apr 2020 01:20:05 +0000 (UTC)
Date:   Thu, 9 Apr 2020 09:20:02 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        dzickus@redhat.com, dyoung@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 0/3] KVM: VMX: Fix for kexec VMCLEAR and VMXON cleanup
Message-ID: <20200409012002.GT2402@MiWiFi-R3L-srv>
References: <20200321193751.24985-1-sean.j.christopherson@intel.com>
 <20200407110115.GA14381@MiWiFi-R3L-srv>
 <87r1wzlcwn.fsf@vitty.brq.redhat.com>
 <20200408151808.GS2402@MiWiFi-R3L-srv>
 <87mu7l2256.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mu7l2256.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/08/20 at 09:44pm, Vitaly Kuznetsov wrote:
> Baoquan He <bhe@redhat.com> writes:
> 
> > On 04/07/20 at 02:04pm, Vitaly Kuznetsov wrote:
> >> Baoquan He <bhe@redhat.com> writes:
> >> 
> >> >
> >> > The trace is here. 
> >> >
> >> > [  132.480817] RIP: 0010:crash_vmclear_local_loaded_vmcss+0x57/0xd0 [kvm_intel] 
> >> 
> >> This is a known bug,
> >> 
> >> https://lore.kernel.org/kvm/20200401081348.1345307-1-vkuznets@redhat.com/
> >
> > Thanks for telling, Vitaly.
> >
> > I tested your patch, it works.
> >
> > One thing is I noticed a warning message when your patch is applied. When
> > I changed back to revert this patchset, didn't found this message. I didn't
> > look into the detail of network core code and the kvm vmx code, maybe it's
> > not relevant.
> >
> >
> > [ 3708.629234] Type was not set for devlink port.
> > [ 3708.629258] WARNING: CPU: 3 PID: 60 at net/core/devlink.c:7164 devlink_port_type_warn+0x11/0x20
> > [ 3708.632328] Modules linked in: rfkill sunrpc intel_powerclamp coretemp kvm_intel kvm irqbypass intel_cstate iTCO_wdt hpwdt intel_uncore gpio_ich iTCO_vendor_support pcspkr ipmi_ssif hpilo lpc_ich ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter pcc_cpufreq i7core_edac ip_tables xfs libcrc32c radeon i2c_algo_bit drm_kms_helper cec ttm crc32c_intel serio_raw drm ata_generic pata_acpi mlx4_core bnx2 hpsa scsi_transport_sas
> > [ 3708.640782] CPU: 3 PID: 60 Comm: kworker/3:1 Kdump: loaded Tainted: G          I       5.6.0+ #1
> > [ 3708.642715] Hardware name: HP ProLiant DL380 G6, BIOS P62 08/16/2015
> > [ 3708.644222] Workqueue: events devlink_port_type_warn
> > [ 3708.645349] RIP: 0010:devlink_port_type_warn+0x11/0x20
> 
> What's in the patchset you're testing? Is it Sean's series + my patch,
> or just my patch? In case it's the later I'm having hard times trying to
> see how this can be related, but in case it's the former the fact that
> we do stuff a little bit differently on kexec may actually be triggering
> the issue above. I still think that it's not causing it, just
> triggering.

I am testing on Linus's tree, this patchset is already there. I just
reverted these patchset, or apply your patch on top of it. Both of them
works. The devlink warning message is not related to this issue because
I found it too when this patchset are reverted.

While I would suggest adding kexec@lists.infradead.org when code changes
are related to kexec/kdump since we usually watch this mailing list.
LKML contains too many mails, we may miss this kind of change, have to
debug and test again. Thanks.

Baoquan

