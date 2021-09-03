Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8774002E2
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 18:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbhICQGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 12:06:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51818 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235714AbhICQGJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 12:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630685108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Crq/O5kiMaMeNGONePHRYFLgpeJK0HXUvN5LnBQkUM=;
        b=Dpd24sKyPC6IXyQ2jxW474eBNIyBVa3JOfG/7cOVhykKXzzrzeHnY+Fm7VZFur9k1l9lSA
        t05Wh1VpjjHqi84khlLxq+yaa+jgRnwGSI9b5Ec2P/OEEUfgo3jugVZOca+FAs5GBEi0C1
        7q0Qd9HZCy5NRCGX7SI2+5668y3PQaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179--KkRAQNaOfi3nA8IQSShcQ-1; Fri, 03 Sep 2021 12:05:06 -0400
X-MC-Unique: -KkRAQNaOfi3nA8IQSShcQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CE14DF8A5;
        Fri,  3 Sep 2021 16:05:04 +0000 (UTC)
Received: from localhost (unknown [10.22.8.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F44777718;
        Fri,  3 Sep 2021 16:05:04 +0000 (UTC)
Date:   Fri, 3 Sep 2021 12:05:03 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 3/6] x86/kvm: introduce per cpu vcpu masks
Message-ID: <20210903160503.htkifa5g5wobte5b@habkost.net>
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-4-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210903130808.30142-4-jgross@suse.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 03:08:04PM +0200, Juergen Gross wrote:
> In order to support high vcpu numbers per guest don't use on stack
> vcpu bitmasks. As all those currently used bitmasks are not used in
> functions subject to recursion it is fairly easy to replace them with
> percpu bitmasks.
> 
> Disable preemption while such a bitmask is being used in order to
> avoid double usage in case we'd switch cpus.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Note that there's another patch that will introduce another
KVM_MAX_VCPUS bitmap variable on the stack:
https://lore.kernel.org/lkml/20210827092516.1027264-7-vkuznets@redhat.com/

Considering that the patch is a bug fix, should this series be
rebased on top of that?

-- 
Eduardo

