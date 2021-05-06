Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6A4375B7A
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 21:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhEFTMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 15:12:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29477 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234467AbhEFTMv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 15:12:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620328312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sIcICOkBVphKUKr4IS+FkpuL1PbE61VZI64xT8PgopM=;
        b=g7uNUJxBkPi6CLIBYUueBEsucEGy9hKTcyen3F2h5OrO/J3PDhuWOUNVlYB8n7bIUK57tw
        DDWz4y/Ts2dpROnMjDUtKk4RBVJfBzEDxkYRL2w13K76HySjCP+5x46oaQV4rAtKaBFM87
        4kqlGNnBHT1GjRK4QyOK00RBf5gziNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-o2ajs2F_N8iV7CgRzJPTBg-1; Thu, 06 May 2021 15:11:50 -0400
X-MC-Unique: o2ajs2F_N8iV7CgRzJPTBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 779E78B8DED;
        Thu,  6 May 2021 19:11:24 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E9FF18111;
        Thu,  6 May 2021 19:11:17 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id C5AA7418AE0D; Thu,  6 May 2021 16:11:08 -0300 (-03)
Date:   Thu, 6 May 2021 16:11:08 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 2/2] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <20210506191108.GA349654@fuller.cnet>
References: <20210506185732.609010123@redhat.com>
 <20210506190419.481236922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506190419.481236922@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021 at 03:57:34PM -0300, Marcelo Tosatti wrote:
> For VMX, when a vcpu enters HLT emulation, pi_post_block will:
> 
> 1) Add vcpu to per-cpu list of blocked vcpus.
> 
> 2) Program the posted-interrupt descriptor "notification vector" 
> to POSTED_INTR_WAKEUP_VECTOR
> 
> With interrupt remapping, an interrupt will set the PIR bit for the 
> vector programmed for the device on the CPU, test-and-set the 
> ON bit on the posted interrupt descriptor, and if the ON bit is clear
> generate an interrupt for the notification vector.
> 
> This way, the target CPU wakes upon a device interrupt and wakes up
> the target vcpu.
> 
> Problem is that pi_post_block only programs the notification vector
> if kvm_arch_has_assigned_device() is true. Its possible for the
> following to happen:
> 
> 1) vcpu V HLTs on pcpu P, kvm_arch_has_assigned_device is false,
> notification vector is not programmed
> 2) device is assigned to VM
> 3) device interrupts vcpu V, sets ON bit (notification vector not programmed,
> so pcpu P remains in idle)
> 4) vcpu 0 IPIs vcpu V (in guest), but since pi descriptor ON bit is set,
> kvm_vcpu_kick is skipped
> 5) vcpu 0 busy spins on vcpu V's response for several seconds, until
> RCU watchdog NMIs all vCPUs.
> 
> To fix this, use the start_assignment kvm_x86_ops callback to program the
> notification vector when assigned device count changes from 0 to 1.
> 
> Reported-by: Pei Zhang <pezhang@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Argh, missing setting vmx_pi_start_assignment, will resend v2.

