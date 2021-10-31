Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81774441140
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 23:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhJaWgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 18:36:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230125AbhJaWgo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 18:36:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635719651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8n/xhA0zJkzOmAPtQLtzvCuXP3Hx32iHbMD3xWco1s=;
        b=WqfH9IRmrLaRC+nsxZSc4B4pNPUm27BxD7rLZo5xR8aGomMZPQHyTLYYBni+ZBQchzfv++
        j9M2kQfZdpFtsY8E8k3vvKbZ10VPtw4aodyvA3xth+lzoQZyA8+Jk3oXIVRqMnOPFzwQKX
        yyVamc93JclZOKdZzOPXcPjBMsqNj6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-IUrqtT12PAernuCzxMBHeQ-1; Sun, 31 Oct 2021 18:34:08 -0400
X-MC-Unique: IUrqtT12PAernuCzxMBHeQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3A2080A5C0;
        Sun, 31 Oct 2021 22:34:04 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CB8619C59;
        Sun, 31 Oct 2021 22:33:42 +0000 (UTC)
Message-ID: <c4453a4bd13dc8120664fe0bf4db5e391d4748e2.camel@redhat.com>
Subject: Re: [PATCH v2 43/43] KVM: VMX: Don't do full kick when handling
 posted interrupt wakeup
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Date:   Mon, 01 Nov 2021 00:33:40 +0200
In-Reply-To: <01b5edae-aaa9-e96d-daaa-197c0c3a0431@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-44-seanjc@google.com>
         <01b5edae-aaa9-e96d-daaa-197c0c3a0431@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-10-25 at 16:16 +0200, Paolo Bonzini wrote:
> On 09/10/21 04:12, Sean Christopherson wrote:
> > When waking vCPUs in the posted interrupt wakeup handling, do exactly
> > that and no more.  There is no need to kick the vCPU as the wakeup
> > handler just need to get the vCPU task running, and if it's in the guest
> > then it's definitely running.
> 
> And more important, the transition from blocking to running will have 
> gone through sync_pir_to_irr, thus checking ON and manually moving the 
> vector from PIR to RVI.
> 
> Paolo
> 
I also think so, and maybe this can be added to the commit message.

Anyway, last one for the series :)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>



Best regards,
	Maxim Levitsky

