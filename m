Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB83441132
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 23:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhJaWW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 18:22:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230346AbhJaWW2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 18:22:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635718795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9lPPZrT4HkW0yreYUc+o8IFGdpWCwnC6KSSIpRHe7JA=;
        b=bczl6QSYJwgEbkcwUvqt3ED0xgsNb7n2e1zrqWGBHE8xuExiSOKeV5/cj3wKzx5oPrEDH4
        oJE5K0zh8o8E1M1sno1LCqxbWlMDskzHy1l1VCFG8isD5iF7zWqZsDIS14Bnnp06eRwrJP
        HuQh/cbcBcj7nUPRQ4//qO9Y7FJQOQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-B-0MMCdFPt2mLeVjPh4hvA-1; Sun, 31 Oct 2021 18:19:50 -0400
X-MC-Unique: B-0MMCdFPt2mLeVjPh4hvA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADDEB80668E;
        Sun, 31 Oct 2021 22:19:46 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F213B19C59;
        Sun, 31 Oct 2021 22:19:32 +0000 (UTC)
Message-ID: <1f2fb5f18b0f0bcee71c9d506769dd1357273444.camel@redhat.com>
Subject: Re: [PATCH v2 40/43] KVM: VMX: Wake vCPU when delivering posted IRQ
 even if vCPU == this vCPU
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
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
Date:   Mon, 01 Nov 2021 00:19:31 +0200
In-Reply-To: <YXlwmrrRVIoaU2kG@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-41-seanjc@google.com>
         <a2a4e076-edb8-2cb5-5cb2-6825a1a4559a@redhat.com>
         <YXlwmrrRVIoaU2kG@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-10-27 at 15:30 +0000, Sean Christopherson wrote:
> On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> > On 09/10/21 04:12, Sean Christopherson wrote:
> > > Lastly, this aligns the non-nested and nested usage of triggering posted
> > > interrupts, and will allow for additional cleanups.
> > 
> > It also aligns with SVM a little bit more (especially given patch 35),
> > doesn't it?
> 
> Yes, aligning VMX and SVM APICv behavior as much as possible is definitely a goal
> of this series, though I suspect I failed to state that anywhere.
> 

Looks reasonable to me.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitky

