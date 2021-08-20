Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8233F2C69
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 14:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbhHTMrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 08:47:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231685AbhHTMrB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 08:47:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629463583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ec6wyQR9c8nnL/eIyo5QCfAh05t7TesL5t+9W2wsXXM=;
        b=FvcHvQA6fo6ksT5XEGmfTBj6aW/UO+C+0oUYQv2N1L/EimzlCubrI0JFvAQ/PkGvrQumpN
        WXT8V/dqvdyzdbGl7iM3QHTTgaIbupXeDcAeNlalmPY/SQXr32RstBrIMPpMfY6bYN3d+7
        vPXBMtFbjLHOA5Gh7liCUY7ZJS2kH3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-FblG6u4AP4KYVzcnF4xSJQ-1; Fri, 20 Aug 2021 08:46:19 -0400
X-MC-Unique: FblG6u4AP4KYVzcnF4xSJQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7A0D1018F74;
        Fri, 20 Aug 2021 12:46:16 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-5.gru2.redhat.com [10.97.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 602BD69CBC;
        Fri, 20 Aug 2021 12:46:16 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id AEDE0418AE12; Fri, 20 Aug 2021 09:46:11 -0300 (-03)
Date:   Fri, 20 Aug 2021 09:46:11 -0300
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
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 3/6] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
Message-ID: <20210820124611.GA77176@fuller.cnet>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-4-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816001130.3059564-4-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 12:11:27AM +0000, Oliver Upton wrote:
> Handling the migration of TSCs correctly is difficult, in part because
> Linux does not provide userspace with the ability to retrieve a (TSC,
> realtime) clock pair for a single instant in time. In lieu of a more
> convenient facility, KVM can report similar information in the kvm_clock
> structure.
> 
> Provide userspace with a host TSC & realtime pair iff the realtime clock
> is based on the TSC. If userspace provides KVM_SET_CLOCK with a valid
> realtime value, advance the KVM clock by the amount of elapsed time. Do
> not step the KVM clock backwards, though, as it is a monotonic
> oscillator.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

This is a good idea. Userspace could check if host and destination
clocks are up to a certain difference and not use the feature if
not appropriate.

Is there a qemu patch for it?

