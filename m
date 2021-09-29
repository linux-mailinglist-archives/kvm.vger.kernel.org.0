Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E6641C5B7
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 15:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344235AbhI2NfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 09:35:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344237AbhI2NfT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 09:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632922413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dp0Dog3coHxj0QgucUNcGEsig+2bXpk05DYt8z5lf/4=;
        b=NjYHkJ4JIGSL1q6IGflR6PociCOKT0Kn2Xasp+HaZ/chkqhvYVnFjIE4gSlDEdOoREiOCB
        x3tdPccb9oHeq7Is28hatUqUQ4cRHX2hy0SfMowC67QBiZgWsrko5A4kWTaXstFlE+KHnC
        ftZbJx+5CQ0cGduMSm4wRwF6BZSnD50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-OXt1m0ehMUuS71XL86bDog-1; Wed, 29 Sep 2021 09:33:31 -0400
X-MC-Unique: OXt1m0ehMUuS71XL86bDog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51C2B1B2C980;
        Wed, 29 Sep 2021 13:33:25 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C26219C79;
        Wed, 29 Sep 2021 13:33:24 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 0A35F416CE5D; Wed, 29 Sep 2021 10:33:21 -0300 (-03)
Date:   Wed, 29 Sep 2021 10:33:21 -0300
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
Subject: Re: [PATCH v8 3/7] KVM: x86: Fix potential race in KVM_GET_CLOCK
Message-ID: <20210929133320.GA10977@fuller.cnet>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-4-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916181538.968978-4-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021 at 06:15:34PM +0000, Oliver Upton wrote:
> Sean noticed that KVM_GET_CLOCK was checking kvm_arch.use_master_clock
> outside of the pvclock sync lock. This is problematic, as the clock
> value written to the user may or may not actually correspond to a stable
> TSC.
> 
> Fix the race by populating the entire kvm_clock_data structure behind
> the pvclock_gtod_sync_lock.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

ACK patches 1-3, still reviewing the remaining ones...

