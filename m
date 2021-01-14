Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA3B2F6070
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 12:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbhANLnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 06:43:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726259AbhANLnp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 06:43:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610624538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ucp6GhejqK0urnC8MaE7X5oGb9T1JYi4z0u+DVIhuOM=;
        b=Dna9UnZeydB4nVgbbgt1MNATkVvrw79IuQLfHMLlUh4Iob2dIWXkNoYz031/G73+Tcp9BS
        HT30AFJPCspxtIpbTYpFlD2ql+XLLR7a9wKHv1OJPWvWkFdfQ/2V2H0XqgaoKUbioXbmsq
        XzgTsU/+gvpvHkElRU7kLTcfwYyv/7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-AQ1WT0QDMEeKcU2gJIPNaw-1; Thu, 14 Jan 2021 06:42:17 -0500
X-MC-Unique: AQ1WT0QDMEeKcU2gJIPNaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32E9C5F9CA;
        Thu, 14 Jan 2021 11:42:15 +0000 (UTC)
Received: from starship (unknown [10.35.206.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F59560657;
        Thu, 14 Jan 2021 11:42:07 +0000 (UTC)
Message-ID: <0b55adffa276851ec2c68d1c185d1581d903f2a1.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered
 by VM instructions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>, Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Bandan Das <bsd@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Date:   Thu, 14 Jan 2021 13:42:06 +0200
In-Reply-To: <0d324a3d-8c33-bb6c-13f3-e60310a54b13@amd.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
         <X/3eAX4ZyqwCmyFi@google.com> <X/3jap249oBJ/a6s@google.com>
         <CALCETrXsNBmXg8C4Tmz4YgTSAykKoWFHgXHFFcK-C65LUQ0r4w@mail.gmail.com>
         <0d324a3d-8c33-bb6c-13f3-e60310a54b13@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-12 at 23:15 -0600, Wei Huang wrote:
> 
> On 1/12/21 12:58 PM, Andy Lutomirski wrote:
> > Andrew Cooper points out that there may be a nicer workaround.  Make
> > sure that the SMRAM and HT region (FFFD00000000 - FFFFFFFFFFFF) are
> > marked as reserved in the guest, too.
> 
> In theory this proposed solution can avoid intercepting #GP. But in 
> reality SMRAM regions can be different on different machines. So this 
> solution can break after VM migration.
> 
I should add to this, that on my 3970X,
I just noticed that the problematic SMRAM region moved on
its own (likely due to the fact that I moved some pcie cards around recently).

Best regards,
	Maxim Levitsky

