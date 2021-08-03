Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F9F3DF322
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 18:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbhHCQst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 12:48:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234110AbhHCQss (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 12:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628009316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FUEZlzvm7AHb4iaD77qmXrudFrm+v8RIbIIzyIxC+jw=;
        b=S3afISAZ3gOaDOR1kOMMuSZoJUyrzY9ex3K//r1KL3AymrX8ImZFMDgVOzvhURckFqclDU
        1M62t+sFu1I9YoOpLsEwYDJXtIyEMhuAWiqJGXLwuLv8nORC7wjlYQeaKGIcQJzpP5NZRZ
        bMeskHupU521MKMp/uWnan/3MVWGzy8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-Vyh4Alq8NnS_8d5OmrBKeA-1; Tue, 03 Aug 2021 12:47:29 -0400
X-MC-Unique: Vyh4Alq8NnS_8d5OmrBKeA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A787B801B3D;
        Tue,  3 Aug 2021 16:47:27 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DD36226E7;
        Tue,  3 Aug 2021 16:47:19 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id C73FB41752BA; Tue,  3 Aug 2021 13:47:10 -0300 (-03)
Date:   Tue, 3 Aug 2021 13:47:10 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, Jenifer Abrams <jhopper@redhat.com>,
        atheurer@redhat.com, jmario@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: What does KVM_HINTS_REALTIME do?
Message-ID: <20210803164710.GB14442@fuller.cnet>
References: <YQlOeGxhor3wJM6i@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQlOeGxhor3wJM6i@stefanha-x1.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 03, 2021 at 03:11:04PM +0100, Stefan Hajnoczi wrote:
> Hi,
> I was just in a discussion where we realized KVM_HINTS_REALTIME is a
> little underdocumented. Here is attempt to address that. Please correct
> me if there are inaccuracies or reply if you have additional questions:
> 
> KVM_HINTS_REALTIME (aka QEMU kvm-hint-dedicated) is defined as follows
> in Documentation/virt/kvm/cpuid.rst:
> 
>   guest checks this feature bit to determine that vCPUs are never
>   preempted for an unlimited time allowing optimizations
> 
> Users or management tools set this flag themselves (it is not set
> automatically). This raises the question of what effects this flag has
> and when it should be set.
> 
> When should I set KVM_HINTS_REALTIME?
> -------------------------------------
> When vCPUs are pinned to dedicated pCPUs. Even better if the isolcpus=
> kernel parameter is used on the host so there are no disturbances.
> 
> Is the flag guest-wide or per-vCPU?
> -----------------------------------
> This flag is guest-wide so all vCPUs should be dedicated, not just some
> of them.
> 
> Which Linux guest features are affected?
> ----------------------------------------
> PV spinlocks, PV TLB flush, and PV sched yield are disabled by
> KVM_HINTS_REALTIME. This is because no other vCPUs or host tasks will be
> running on the pCPUs, so there is no benefit in involving the host.
> 
> The cpuidle-haltpoll driver is enabled by KVM_HINTS_REALTIME. This
> driver performs busy waiting inside the guest before halting the CPU in
> order to avoid the vCPU's wakeup latency. This driver also has a boolean
> "force" module parameter if you wish to enable it without setting
> KVM_HINTS_REALTIME.
> 
> When KVM_HINTS_REALTIME is set, the KVM_CAP_X86_DISABLE_EXITS capability
> can also be used to disable MWAIT/HLT/PAUSE/CSTATE exits. This improves
> the latency of these operations. The user or management tools need to
> disable these exits themselves, e.g. with QEMU's -overcommit cpu-pm=on.
> 
> Stefan

Looks good.

