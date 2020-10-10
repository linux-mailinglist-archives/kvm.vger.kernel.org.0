Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A0728A1A0
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgJJVxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731197AbgJJTxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 15:53:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783CCC0613B3;
        Sat, 10 Oct 2020 04:44:15 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602330250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N1SBsytax/FJJ63UuUy61d7oPnuBmwnuAFt8dWJDPIY=;
        b=wAtldDLOX6giKCz7dGGhSXozepspB6Z5q/gsjMmYzjA0Z5/Tl+2bYBKvPAhBkt+l+tCg/+
        YceoJzi5VgGAyUnjrH9Wiloj7m7gotU9rzErupjj0zw0E6cDQbpMiI9kCJnY4C965fTiSf
        vfXrIOldKpqzaXAqe50obgHfmo6Co+88KTwBGs1ffV3UJTYTBfLT8dtbnXwIkWKMrO20q7
        MisAG/rGkTNX3uHxjPja4Og/aOkoR19w4rvVEe1d19NG25lyOOhzVNos5p81hoqQEK5iU5
        8h1yOxorYGhD57Gnt2j6bsTnmHcRql2BkZmf2uuxJp+Uopwxy/QG5bizUMQ8hg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602330250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N1SBsytax/FJJ63UuUy61d7oPnuBmwnuAFt8dWJDPIY=;
        b=rYPtLdNnBXpCcz5l4C7q/3Nqs9/82l0nQU39pU9MjbzTL3QAqR5yiCMt+uqYlFTQsWCpd5
        g3buI2njI1c3W+AA==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
In-Reply-To: <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-5-dwmw2@infradead.org> <87blhcx6qz.fsf@nanos.tec.linutronix.de> <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org> <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org> <87362owhcb.fsf@nanos.tec.linutronix.de> <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org> <87tuv4uwmt.fsf@nanos.tec.linutronix.de> <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org>
Date:   Sat, 10 Oct 2020 13:44:10 +0200
Message-ID: <874kn2s3ud.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 10 2020 at 11:06, David Woodhouse wrote:
> On Fri, 2020-10-09 at 01:27 +0200, Thomas Gleixner wrote:
>> On Thu, Oct 08 2020 at 22:39, David Woodhouse wrote:
>> For the next submission, can you please
>>=20
>>  - pick up the -ENODEV changes for HPET/IOAPIC which I posted earlier
>
> I think the world will be a nicer place if HPET and IOAPIC have their
> own struct device and their drivers can just use dev_get_msi_domain().
>
> The IRQ remapping drivers already plug into the device-add notifier and
> can fill in the appropriate MSI domain just like they do=C2=B9 for PCI and
> ACPI devices.
>
> Using platform_add_bundle() for HPET looks trivial enough; I'll have a
> play with that and then do IOAPIC too if/when the initialisation order
> and hotplug handling all works out OK to install the correct
> msi_domain.

Yes, I was wondering about that when I made PCI at least use that
mechanism, but had not had time to actually look at it.

Thanks,

        tglx
