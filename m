Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3472873C8
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 14:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgJHMCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 08:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHMCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 08:02:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287E0C061755;
        Thu,  8 Oct 2020 05:02:50 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602158568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qb/eq6Tak8wrJRcU+2MP5K04KYUSw4chH4xriY/PXBA=;
        b=jNXwjis5G98TaW6vkLkpoQIXNvZ8iErdCkK5QanKNuE7U6DXwkdufP8aGFtRk7st3Pbuyq
        sz9tQGgRC7L+p2FM+50o9G5OgpANgNNFC9rakuA0Ef1G4GmRKCBY/Tfs5t8F3kJNmdgyzq
        pFRboCXhieWmTVdsx9SKtItN5sIwSWup5R8yHgmNr7ChS4fkCZAxENo1MFSTg48TGjXlpF
        WYtUdjKsqOciS3pIvqVKBKIDOS/P6hPiasbY7Ajgl8becd9/aix8SNJYAZ488Aaqp7Gja1
        dgXugwMWHy6QBeYPyevUibtdFw7AwyjUdnOM3QUlKNgGiSUo+5JU9HkE3mHJTQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602158568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qb/eq6Tak8wrJRcU+2MP5K04KYUSw4chH4xriY/PXBA=;
        b=wkBIUhQweB7qob6w8gDLd3skSnZFMI1aMhBLmWgKBzegBAna9wj7dtsCILHT5ogI/a52QI
        G2Sv9LyjfrlYJ0Bw==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] x86/apic: Support 15 bits of APIC ID in IOAPIC/MSI where available
In-Reply-To: <87h7r5vsog.fsf@nanos.tec.linutronix.de>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-4-dwmw2@infradead.org> <87h7r5vsog.fsf@nanos.tec.linutronix.de>
Date:   Thu, 08 Oct 2020 14:02:48 +0200
Message-ID: <87eem9vsbb.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 08 2020 at 13:54, Thomas Gleixner wrote:
> On Wed, Oct 07 2020 at 13:20, David Woodhouse wrote:
>> diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
>> index 2825e003259c..85206f971284 100644
>> --- a/arch/x86/kernel/apic/msi.c
>> +++ b/arch/x86/kernel/apic/msi.c
>> @@ -23,8 +23,11 @@
>>  
>>  struct irq_domain *x86_pci_msi_default_domain __ro_after_init;
>>  
>> +int msi_ext_dest_id __ro_after_init;
>
> bool please.
>
> Aside of that this breaks the build for a kernel with CONFIG_PCI_MSI=n

So this wants to be

bool virt_ext_dest_id __ro_after_init;

in apic.c and then please make the IO/APIC places depend on this as well
so any change to the utilization of the reserved IO/APIC bits in the
future is not going to end up in surprises.

Thanks,

        tglx
