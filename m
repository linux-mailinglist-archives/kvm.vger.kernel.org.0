Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AC81D17AA
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 16:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388777AbgEMOeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 10:34:06 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45512 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728345AbgEMOeG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 10:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589380444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m+PEhgzHkVIBbDAnTZLgSwPrQQ+EJMVpFOwB8+yQloY=;
        b=ASyf/iwIgJgAHpd3hvAzWUXXRABI7Bq5XCtobsNudr4BxnEjA273o19rmYXCbe+iooKy8n
        Kmg/4w2WbRt1UyxGEYLdpB/jIqrJhW6afRYAVdii74RLK6OpNm9QBmDN/z3H8PGJrdlHLP
        5Md/VjW5xjeZD3vQ1FQ2PpBa+icbolU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-2y-yEMzsOjuf51o8K2Yo7g-1; Wed, 13 May 2020 10:34:03 -0400
X-MC-Unique: 2y-yEMzsOjuf51o8K2Yo7g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EEF8461;
        Wed, 13 May 2020 14:34:02 +0000 (UTC)
Received: from x1.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F005A61548;
        Wed, 13 May 2020 14:34:01 +0000 (UTC)
Date:   Wed, 13 May 2020 08:34:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Micah Morton <mortonm@chromium.org>, kvm@vger.kernel.org,
        jmattson@google.com
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
Message-ID: <20200513083401.11e761a7@x1.home>
In-Reply-To: <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com>
References: <20200511220046.120206-1-mortonm@chromium.org>
        <20200512111440.15caaca2@w520.home>
        <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 May 2020 09:02:16 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 12/05/20 19:14, Alex Williamson wrote:
> > But why not assign the individual platform devices via vfio-platform
> > rather than assign the i2c controller via vfio-pci and then assembling
> > the interrupts from those sub-devices with this ad-hoc interface?  An
> > emulated i2c controller in the guest could provide the same discovery
> > mechanism as is available in the host.  
> 
> I agree.  I read the whole discussion, but I still don't understand why
> this is not using vfio-platform.
> 
> Alternatively, if you assign the i2c controller, I don't understand why
> the guest doesn't discover interrupts on its own.  Of course you need to
> tell the guest about the devices in the ACPI tables, but why is this new
> concept necessary?

The i2c controller is a PCI device, it can be assigned with vfio-pci
and we can use it to probe the i2c bus and find the sub-devices.
However the interrupt for this sub-device is unrelated to the PCI
controller device, it's an entirely arbitrary (from our perspective)
relationship described via ACPI.  So the guest needs an ACPI blob to
describe the interrupt and then access to the interrupt.  This is
what's new here.

We could potentially use device specific interrupts to expose this via
the controller device, but then vfio-pci needs to learn how to
essentially become an i2c controller to enumerate the sub-devices and
collect external dependencies.  This is not an approach I've embraced
versus the alternative of the host i2c driver claiming the PCI
controller, enumerating the sub-devices, and binding the resulting
device, complete with built-in interrupt support via vfio-platform.
Thanks,

Alex

