Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1875726F8A9
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 10:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgIRIu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 04:50:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbgIRIu0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 04:50:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600419025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/QfTiUWUoHzQknijYTUbsX5+5g78epx3oQpvxWAg6QE=;
        b=YrtKcNXBkpPUecoteyao8ZPXiFQsCFuvS102Fsgge4+rJksxwvSm1EuUqrn6oq1AU2ZvE9
        RaWDh4smenUzkQnbycuc1uT4hHf+dFCYolITvMg+qpxDpZPmoNUJsOlTOnRe23zz6+AdNu
        RUbMP1UNa6Z8a+RqqYpSMyb5nYY7dNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-De-04fBRN2mwIgOqXJGzFA-1; Fri, 18 Sep 2020 04:49:15 -0400
X-MC-Unique: De-04fBRN2mwIgOqXJGzFA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C7C71084C92;
        Fri, 18 Sep 2020 08:49:14 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55F311002D68;
        Fri, 18 Sep 2020 08:49:07 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 721CD16E16; Fri, 18 Sep 2020 10:49:06 +0200 (CEST)
Date:   Fri, 18 Sep 2020 10:49:06 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200918084906.ja5elzh5zli47mg3@sirius.home.kraxel.org>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200825212526.GC8235@xz-x1>
 <87eenlwoaa.fsf@vitty.brq.redhat.com>
 <20200901200021.GB3053@xz-x1>
 <877dtcpn9z.fsf@vitty.brq.redhat.com>
 <20200904061210.GA22435@sjchrist-ice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904061210.GA22435@sjchrist-ice>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> I see a similar ~8k PCI hole reads with a -kernel boot w/ OVMF.  All but 60
> of those are from pcibios_fixup_peer_bridges(), and all are from the kernel.

pcibios_fixup_peer_bridges() looks at pcibios_last_bus, and that in turn
seems to be set according to the mmconfig size (in
arch/x86/pci/mmconfig-shared.c).

So, maybe we just need to declare a smaller mmconfig window in the acpi
tables, depending on the number of pci busses actually used ...

> If all of the above is true, this can be handled by adding "pci=lastbus=0"

... so we don't need manual quirks like this?

take care,
  Gerd

