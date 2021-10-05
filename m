Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFC3422F82
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 19:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhJESAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 14:00:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhJESAx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 14:00:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633456740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nuw43x0U3vDkxdS/rYgw2/JnjgAfFVN927udMy2kobw=;
        b=bSDbDlGJ54whMHQNgXKDXom2g8lMNZvVfS60gGNkS0toQNrZzunZDG3cyMtCM4H/BOf8xN
        QlFhG1cCp/qGggkedAUWzFVLRQR8chwPO4gkqnGR5aZpAP7OcAOTmkE1I8rDeWcco1yL57
        y9Efb3l7rqL8r1u7xk6Bo6jcF7L8V8Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-rWUJ-gcUPAW3O-sUhKoVOg-1; Tue, 05 Oct 2021 13:58:57 -0400
X-MC-Unique: rWUJ-gcUPAW3O-sUhKoVOg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42E18BAF81;
        Tue,  5 Oct 2021 17:58:00 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 83EEA652AB;
        Tue,  5 Oct 2021 17:57:51 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 88BD2416D862; Tue,  5 Oct 2021 14:57:47 -0300 (-03)
Date:   Tue, 5 Oct 2021 14:57:47 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com, tglx@linutronix.de,
        frederic@kernel.org, mingo@kernel.org, nilal@redhat.com,
        Wanpeng Li <kernellwp@gmail.com>
Subject: Re: [PATCH v1] KVM: isolation: retain initial mask for kthread VM
 worker
Message-ID: <20211005175747.GA167517@fuller.cnet>
References: <20211004222639.239209-1-nitesh@redhat.com>
 <e734691b-e9e1-10a0-88ee-73d8fceb50f9@redhat.com>
 <20211005105812.GA130626@fuller.cnet>
 <96f38a69-2ff8-a78c-a417-d32f1eb742be@redhat.com>
 <20211005132159.GA134926@fuller.cnet>
 <9c1fa821-2eaf-7709-7bd2-be83f92d2ee5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c1fa821-2eaf-7709-7bd2-be83f92d2ee5@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 05, 2021 at 07:15:43PM +0200, Paolo Bonzini wrote:
> On 05/10/21 15:21, Marcelo Tosatti wrote:
> > > The QEMU I/O thread is not hogging the CPU 100% of the time, and
> > > therefore the nx-recovery thread should be able to run on that CPU.
> > 
> > 1) The cpumask of the parent thread is not inherited
> > 
> > 	set_cpus_allowed_ptr(task, housekeeping_cpumask(HK_FLAG_KTHREAD));
> > 
> > On __kthread_create_on_node should fail (because its cgroup, the one
> > inherited from QEMU, contains only isolated CPUs).
> > 
> > (The QEMU I/O thread runs on an isolated CPU, and is moved by libvirt
> > to HK-cgroup as mentioned before).
> 
> Ok, that's the part that I missed.  So the core issue is that libvirt moves
> the I/O thread out of the isolated-CPU cgroup too late?  This in turn is
> because libvirt gets access to the QEMU monitor too late (the KVM file
> descriptor is created when QEMU processes the command line).

Actually, what i wrote was incorrect: set_cpus_allowed_ptr should 
succeed (kthread creation), but cgroup_attach_task_all will
override the kthread mask with the cgroup mask
(which contains isolated CPUs).

Paolo: about your suggestion to use the same CPU for nx-recovery thread
as the I/O thread one: I believe the cpumask of the userspace parent (QEMU I/O
thread) is not inherited by the kernel thread.

We will resend the patchset once more data to justify this is available
(or will if an userspace solution is not possible).

