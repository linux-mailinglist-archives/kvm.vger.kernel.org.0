Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CA13F87E9
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 14:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241138AbhHZMtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 08:49:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232506AbhHZMtc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 08:49:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629982124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bUwJRAJ6EB5NdhoyuMNoCLrXGQTwaXG75pAqtPkBtiI=;
        b=WRVuWhzMUVvKaC/4Hll9dSgaI5GTKU4jAcOVnYSrZdfYttj3H4LRSHJDRi6F4E/Vygho+m
        +vkPwkjCd1HpSM31y8Cw+f1Q9KNPqH0cROHSD6Zb4LNvsWiGBXo0w6xL64N9uhNonrzeHa
        WZDs9BcR4ANT0STcZ0gufdBr6Wt0ZzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-uQCCp8p9MEGitVIWfr94Lw-1; Thu, 26 Aug 2021 08:48:43 -0400
X-MC-Unique: uQCCp8p9MEGitVIWfr94Lw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8E86190B2A0;
        Thu, 26 Aug 2021 12:48:40 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BFE1604CC;
        Thu, 26 Aug 2021 12:48:40 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 8B23F416CE49; Thu, 26 Aug 2021 09:48:36 -0300 (-03)
Date:   Thu, 26 Aug 2021 09:48:36 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 6/6] KVM: x86: Expose TSC offset controls to userspace
Message-ID: <20210826124836.GA155749@fuller.cnet>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-7-oupton@google.com>
 <CAOQ_Qsj_MfRNRRSK1UswsfBw4c9ugSW6tKXNua=3O78sHEonvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_Qsj_MfRNRRSK1UswsfBw4c9ugSW6tKXNua=3O78sHEonvA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 23, 2021 at 01:56:30PM -0700, Oliver Upton wrote:
> Paolo,
> 
> On Sun, Aug 15, 2021 at 5:11 PM Oliver Upton <oupton@google.com> wrote:
> >
> > To date, VMM-directed TSC synchronization and migration has been a bit
> > messy. KVM has some baked-in heuristics around TSC writes to infer if
> > the VMM is attempting to synchronize. This is problematic, as it depends
> > on host userspace writing to the guest's TSC within 1 second of the last
> > write.
> >
> > A much cleaner approach to configuring the guest's views of the TSC is to
> > simply migrate the TSC offset for every vCPU. Offsets are idempotent,
> > and thus not subject to change depending on when the VMM actually
> > reads/writes values from/to KVM. The VMM can then read the TSC once with
> > KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the instant when
> > the guest is paused.
> >
> > Cc: David Matlack <dmatlack@google.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> 
> Could you please squash the following into this patch? We need to
> advertise KVM_CAP_VCPU_ATTRIBUTES to userspace. Otherwise, happy to
> resend.
> 
> Thanks,
> Oliver

Oliver,

Is there QEMU support for this, or are you using your own
userspace with this?

