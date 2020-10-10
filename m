Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D2A28A19B
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgJJVvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730835AbgJJTwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 15:52:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDEEC0613BE;
        Sat, 10 Oct 2020 04:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=ksA/3tnpu0dYCPO3zTCXUMlcX+49fWBvwjzs6N5Liuw=; b=dpNvY/Z/uih/9ryvOeF+8pAqf6
        eSF2KctXnj2z347+v/mIhsgbFXMBSTZBjqfLObk47eSggqLkdcam8IyMk+gOQksMQkUgk1gFILTBu
        3NtmObKPlRxwMJZh1S3RZXIk/KGlI3NmmpvhbWYO6r7Km4Zc0a6+9+EEEI3rS27Z+B6BHpQF27BxM
        0jdIO4Xg7ZA/6T0fE6FIyQhtTtxvB3N2rv1f+vCtLxh2ycq5g1aujLWoV391tzAtGctBTy5mLIrbd
        xc97osXT5a/2ZOubBuP7hJgVNiRFOPCC6DltY+5UXWZbK3WvZxE9i1e/UZM6jAs/Jq0qC1t6cYxCx
        xCZ94YnQ==;
Received: from [2001:8b0:10b:1:ad95:471b:fe64:9cc3]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kRDWG-0004VV-Dj; Sat, 10 Oct 2020 11:58:36 +0000
Date:   Sat, 10 Oct 2020 12:58:34 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <874kn2s3ud.fsf@nanos.tec.linutronix.de>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-5-dwmw2@infradead.org> <87blhcx6qz.fsf@nanos.tec.linutronix.de> <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org> <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org> <87362owhcb.fsf@nanos.tec.linutronix.de> <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org> <87tuv4uwmt.fsf@nanos.tec.linutronix.de> <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org> <874kn2s3ud.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
CC:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <0E51DAB1-5973-4226-B127-65D77DC46CB5@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10 October 2020 12:44:10 BST, Thomas Gleixner <tglx@linutronix=2Ede> wr=
ote:
>On Sat, Oct 10 2020 at 11:06, David Woodhouse wrote:
>> On Fri, 2020-10-09 at 01:27 +0200, Thomas Gleixner wrote:
>>> On Thu, Oct 08 2020 at 22:39, David Woodhouse wrote:
>>> For the next submission, can you please
>>>=20
>>>  - pick up the -ENODEV changes for HPET/IOAPIC which I posted
>earlier
>>
>> I think the world will be a nicer place if HPET and IOAPIC have their
>> own struct device and their drivers can just use
>dev_get_msi_domain()=2E
>>
>> The IRQ remapping drivers already plug into the device-add notifier
>and
>> can fill in the appropriate MSI domain just like they do=C2=B9 for PCI =
and
>> ACPI devices=2E
>>
>> Using platform_add_bundle() for HPET looks trivial enough; I'll have
>a
>> play with that and then do IOAPIC too if/when the initialisation
>order
>> and hotplug handling all works out OK to install the correct
>> msi_domain=2E
>
>Yes, I was wondering about that when I made PCI at least use that
>mechanism, but had not had time to actually look at it=2E

Yeah=2E There's some muttering to be done for HPET about whether it's *its=
* MSI domain or whether it's the parent domain=2E But I'll have a play=2E I=
 think we'll be able to drop the whole irq_remapping_get_irq_domain() thing=
=2E

Either way, it's a separate cleanup and the 15-bit APIC ID series I posted=
 yesterday should be fine as it is=2E=20

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
