Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C62A3F2012
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 20:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbhHSSo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 14:44:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233713AbhHSSo1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 14:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629398629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H/wl8m/9lH1CHxbJFAhOGRrmreud5t/3OP9MGx3avmE=;
        b=dAC8u1rKWgjYZd3Y0bZiWOXawetYoyWTTQHLE/4lY2X56wAQCyyO3lgtws91fiHJLEK4L5
        RXACFtLKwVmO9eGYcL+slmc0iqcsdLHtLZ0Y6n7308y8hMVKhWa7ygBF41T5ic5339IPts
        rgThp6AvS0NCJ1l9kbPHjrIFJHAl2Nc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-aKQUDwrROzmaDp7OcHlfzA-1; Thu, 19 Aug 2021 14:43:46 -0400
X-MC-Unique: aKQUDwrROzmaDp7OcHlfzA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58EA1107ACF5;
        Thu, 19 Aug 2021 18:43:44 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-6.gru2.redhat.com [10.97.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1C3F188E4;
        Thu, 19 Aug 2021 18:43:43 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 054DB434F000; Thu, 19 Aug 2021 15:24:22 -0300 (-03)
Date:   Thu, 19 Aug 2021 15:24:22 -0300
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
Subject: Re: [PATCH v7 1/6] KVM: x86: Fix potential race in KVM_GET_CLOCK
Message-ID: <20210819182422.GA25923@fuller.cnet>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-2-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816001130.3059564-2-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 12:11:25AM +0000, Oliver Upton wrote:
> Sean noticed that KVM_GET_CLOCK was checking kvm_arch.use_master_clock
> outside of the pvclock sync lock. This is problematic, as the clock
> value written to the user may or may not actually correspond to a stable
> TSC.
> 
> Fix the race by populating the entire kvm_clock_data structure behind
> the pvclock_gtod_sync_lock.

Oliver, 

Can you please describe the race in more detail?

Is it about host TSC going unstable VS parallel KVM_GET_CLOCK ? 

