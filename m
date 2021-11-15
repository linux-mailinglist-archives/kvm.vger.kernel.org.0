Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7C74510D6
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 19:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242865AbhKOSzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 13:55:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243153AbhKOSwZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 13:52:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637002165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CUpVDfHC73r5/yQsY2zBw03ZHeFo5b5N2lfCLDkM3Z4=;
        b=Z88ucPitCTuoUo8VfoqdkuLnSv5jo531Ju3bOxwgrQi6g6U0uy2eYXi/h7dezJya3Y58fn
        7H8KojvdRXEZy+DbQoAubCaOQ7yYo+0O2uTk72xklBCS8mIxmxDduAiomt1eHWBGHMbaLS
        9ETgayJ8Pbgfayfhh2XwgqIlzcS5SkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-r2rWgYYTMru98kwWoPDy7w-1; Mon, 15 Nov 2021 13:49:20 -0500
X-MC-Unique: r2rWgYYTMru98kwWoPDy7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA42510144E0;
        Mon, 15 Nov 2021 18:49:18 +0000 (UTC)
Received: from [10.39.195.133] (unknown [10.39.195.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 478BA60BE5;
        Mon, 15 Nov 2021 18:49:16 +0000 (UTC)
Message-ID: <0858131c-2116-13c3-4e63-600ff2083675@redhat.com>
Date:   Mon, 15 Nov 2021 19:49:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 11/11] KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN and
 event channel delivery
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com
References: <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
 <20211115165030.7422-1-dwmw2@infradead.org>
 <20211115165030.7422-11-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211115165030.7422-11-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/15/21 17:50, David Woodhouse wrote:
> +			asm volatile("1:\t" LOCK_PREFIX "orq %0, %1\n"
> +				     "\tnotq %0\n"
> +				     "\t" LOCK_PREFIX "andq %0, %2\n"
> +				     "2:\n"
> +				     "\t.section .fixup,\"ax\"\n"
> +				     "3:\tjmp\t2b\n"
> +				     "\t.previous\n"
> +				     _ASM_EXTABLE_UA(1b, 3b)
> +				     : "=r" (evtchn_pending_sel)
> +				     : "m" (vi->evtchn_pending_sel),
> +				       "m" (v->arch.xen.evtchn_pending_sel),

These need to be "+m", I think?

And same for st->preempted actually.

Paolo

> +				       "0" (evtchn_pending_sel));

