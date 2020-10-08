Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE80287F17
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 01:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730993AbgJHX1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 19:27:09 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53588 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgJHX1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 19:27:09 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602199626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mCF0g/+MND1nwyGx+3yFFM5NagyeBqr5yClJxHT9QEA=;
        b=Swp8IJ+Dgcfzc0AiaM09Ka+XguUbPbdks8xUopa30a0QG9VTUz1p8OEM/pGJUj68R66uKo
        3BNSmfCEhBPwkb8gb5JL4X55GCeGTMuIK1C1gxHhGqSuscAuXf8wAkIfOwuc+l67uhL3Xe
        BqUhMtEBt3gBjhNjB+VlWJuFDj9QSipDsfeTtxaYo7SEDz1Go6f4eLWBGNVolW/TsKzcAx
        ydm1GNGRt4oEliwJTKULEbyOwkKClOsukVdfspauVbOvwTZbIA9O7efNhcV6ZK2tGqNIwt
        MftjjoJYadRztuHmP53tOwnPCc2E7z5TtmehSD/jmszTLaRQy/YjrMb2cJsBnQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602199626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mCF0g/+MND1nwyGx+3yFFM5NagyeBqr5yClJxHT9QEA=;
        b=p20GZo4A08k/MQ9YpJFZ8xL4ZpcN/OzaBgyB0Z6JYGu3goDxY7suWz1HdpJ6zXE5AO7QvB
        KZHAotM6g3c4ycCw==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
In-Reply-To: <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-5-dwmw2@infradead.org> <87blhcx6qz.fsf@nanos.tec.linutronix.de> <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org> <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org> <87362owhcb.fsf@nanos.tec.linutronix.de> <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org>
Date:   Fri, 09 Oct 2020 01:27:06 +0200
Message-ID: <87tuv4uwmt.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 08 2020 at 22:39, David Woodhouse wrote:
> On Thu, 2020-10-08 at 23:14 +0200, Thomas Gleixner wrote:
>> > 
>> > (We'd want the x86_vector_domain to actually have an MSI compose
>> > function in the !CONFIG_PCI_MSI case if we did this, of course.)
>> 
>> The compose function and the vector domain wrapper can simply move to
>> vector.c
>
> I ended up putting __irq_msi_compose_msg() into apic.c and that way I
> can make virt_ext_dest_id static in that file.
>
> And then I can move all the HPET-MSI support into hpet.c too.

Works for me.

> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/ext_dest_id

For the next submission, can you please

 - pick up the -ENODEV changes for HPET/IOAPIC which I posted earlier

 - shuffle all that compose/IOAPIC cleanup around

before adding that extended dest id stuff.

Thanks,

        tglx
