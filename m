Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6640E43CC56
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 16:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242583AbhJ0OjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 10:39:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237738AbhJ0OjQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 10:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635345410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0gXXVZ1M1SPzD/8mviUXXiKMlrNVIcsqsHOKxhlwRek=;
        b=c4F+9GIthu5ISpXu3Nm2pmZ/veI+Hq1JYJWG1+Eh9JjFtthMAsuzAdi585aR4TosBzppBa
        1pdyaOJsfWTwOxT9C96H8Z7e+EDVAB4MHTvsVIjqaNu29Md1CeLZqs3ckV4JiXvTD7rTJQ
        m71vTaLzaMK+EnDIS7DpxH2KvOudwjU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-UU3N_ykSOO6SiL7u12Utfg-1; Wed, 27 Oct 2021 10:36:46 -0400
X-MC-Unique: UU3N_ykSOO6SiL7u12Utfg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1095C112C391;
        Wed, 27 Oct 2021 14:35:56 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83585794A9;
        Wed, 27 Oct 2021 14:35:46 +0000 (UTC)
Message-ID: <3a0c3397302d59ea313e079435a18bf1b9a43474.camel@redhat.com>
Subject: Re: [PATCH v2 16/43] KVM: Don't redo ktime_get() when calculating
 halt-polling stop/deadline
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
Date:   Wed, 27 Oct 2021 17:35:45 +0300
In-Reply-To: <0072221e-02e8-4d60-9b0f-80d8c423bf4e@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-17-seanjc@google.com>
         <0072221e-02e8-4d60-9b0f-80d8c423bf4e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-10-25 at 16:26 +0200, Paolo Bonzini wrote:
> On 09/10/21 04:12, Sean Christopherson wrote:
> > Calculate the halt-polling "stop" time using "cur" instead of redoing
> > ktime_get().  In the happy case where hardware correctly predicts
> > do_halt_poll, "cur" is only a few cycles old.  And if the branch is
> > mispredicted, arguably that extra latency should count toward the
> > halt-polling time.
> > 
> > In all likelihood, the numbers involved are in the noise and either
> > approach is perfectly ok.
> 
> Using "start" makes the change even more obvious, so:
> 
>      Calculate the halt-polling "stop" time using "start" instead of redoing
>      ktime_get().  In practice, the numbers involved are in the noise (e.g.,
>      in the happy case where hardware correctly predicts do_halt_poll and
>      there are no interrupts, "start" is probably only a few cycles old)
>      and either approach is perfectly ok.  But it's more precise to count
>      any extra latency toward the halt-polling time.
> 
> Paolo
> 
Agreed.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


