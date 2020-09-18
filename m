Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6586326F95C
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 11:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgIRJd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 05:33:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgIRJd3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 05:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600421607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YyxvQapKO8cJ+h1msTh4Bn1k/c9vh0JXpNMN+TtY/Sw=;
        b=hS30hk44dDPtX0/QM1kelRC1xzRMujbBwk3YRPFV5eRDMXNVKZhsPxAWWnCUPrRccJvyme
        6PRrFe1/Dh5ClFVpxUrZafA1EBkTufJrcRXx8BjPDzfqk5Y6NDrJrbXxpRF91NA+7quxlz
        OqcQEN5Az+zEXJMwCbic2mlE/l2HaAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-DO35AFk4Nsq_aFG1fRQDGA-1; Fri, 18 Sep 2020 05:33:22 -0400
X-MC-Unique: DO35AFk4Nsq_aFG1fRQDGA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AB5F1091066;
        Fri, 18 Sep 2020 09:33:21 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 672E519D6C;
        Fri, 18 Sep 2020 09:33:14 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 943F516E0A; Fri, 18 Sep 2020 11:33:13 +0200 (CEST)
Date:   Fri, 18 Sep 2020 11:33:13 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200918093313.7qfsgi7o46imqunc@sirius.home.kraxel.org>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200825212526.GC8235@xz-x1>
 <87eenlwoaa.fsf@vitty.brq.redhat.com>
 <20200901200021.GB3053@xz-x1>
 <877dtcpn9z.fsf@vitty.brq.redhat.com>
 <20200904061210.GA22435@sjchrist-ice>
 <20200904072905.vbkiq3h762fyzds6@sirius.home.kraxel.org>
 <20200907065054-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907065054-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > We could probably wire up ecam (arm/virt style) for pcie support, once
> > the acpi support for mictovm finally landed (we need acpi for that
> > because otherwise the kernel wouldn't find the pcie bus).
> > 
> > Question is whenever there is a good reason to do so.  Why would someone
> > prefer microvm with pcie support over q35?
> 
> The usual reasons to use pcie apply to microvm just the same.
> E.g.: pass through of pcie devices?

Playground:
  https://git.kraxel.org/cgit/qemu/log/?h=sirius/microvm-usb

Adds support for usb and pcie (use -machine microvm,usb=on,pcie=on
to enable).  Reuses the gpex used on arm/aarch64.  Seems to work ok
on a quick test.

Not fully sure how to deal correctly with ioports.  The gpex device
has a mmio window for the io address space.  Will that approach work
on x86 too?  Anyway, just not having a ioport range seems to be a
valid configuation, so I've just disabled them for now ...

take care,
  Gerd

