Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A97340BE7
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 18:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCRRdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 13:33:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhCRRca (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 13:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616088749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QU4RVV7fUtJH9VceJCbZeXUpFYVEEHtPJQN1U4UrCYM=;
        b=DtOPr/IMg4iZv2DzQGdaAuruEonJ4Iny4x4bBl+d6yc5j0bZespx4CHorWkGia+u0MzRdN
        RkI3Z3zPHi4XZQ4O4AHNVw5d9ejM6cmFrz83xcrlDcjBzVq9gK1AtzLlLYv1QOhIaCUZTi
        srznihiBZ1EcJ+u/1bDrPbR+RDBzHaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-EcCKeTFgOLaCixJWA-QVCA-1; Thu, 18 Mar 2021 13:32:28 -0400
X-MC-Unique: EcCKeTFgOLaCixJWA-QVCA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA9FD107B287;
        Thu, 18 Mar 2021 17:32:26 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6610D60C13;
        Thu, 18 Mar 2021 17:32:26 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 0EC7A410F542; Thu, 18 Mar 2021 14:02:08 -0300 (-03)
Date:   Thu, 18 Mar 2021 14:02:08 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 2/4] KVM: x86: hyper-v: Prevent using not-yet-updated
 TSC page by secondary CPUs
Message-ID: <20210318170208.GB36190@fuller.cnet>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210316143736.964151-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316143736.964151-3-vkuznets@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 03:37:34PM +0100, Vitaly Kuznetsov wrote:
> When KVM_REQ_MASTERCLOCK_UPDATE request is issued (e.g. after migration)
> we need to make sure no vCPU sees stale values in PV clock structures and
> thus all vCPUs are kicked with KVM_REQ_CLOCK_UPDATE. Hyper-V TSC page
> clocksource is global and kvm_guest_time_update() only updates in on vCPU0
> but this is not entirely correct: nothing blocks some other vCPU from
> entering the guest before we finish the update on CPU0 and it can read
> stale values from the page.
> 
> Invalidate TSC page in kvm_gen_update_masterclock() to switch all vCPUs
> to using MSR based clocksource (HV_X64_MSR_TIME_REF_COUNT).

Hi Vitaly,

Not clear why this is necessary, if the choice was to not touch TSC page
at all, when invariant TSC is supported on the host...

Ah, OK, this is not for the migration with iTSC on destination case,
but any call to kvm_gen_update_masterclock, correct?

