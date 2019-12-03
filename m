Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C310FAB0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 10:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfLCJZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 04:25:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32085 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725773AbfLCJZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 04:25:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575365117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/I8RoZB7HxxHtNAPWRVDK9HEHCVNsmOjnJke2ajqDM0=;
        b=iTkUhZcwz8LQ3STqwWTH5bDwzm2zpwkt3NcjetvUpAolmMK8ogF28J7Ikr5fgdyXb2U+XF
        PGbNDFRebuWKNMbcrMpwKqtYNRPDC2XbkNsWAjgkSdY7s/fdAH97npVV8HMY1J7i0GBkeJ
        YN516g1jCk85mQfH8B6KETf4c+Nme/M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-e7uRcGKjPaOxvPPgXrAveA-1; Tue, 03 Dec 2019 04:25:16 -0500
Received: by mail-wr1-f72.google.com with SMTP id d8so1451387wrq.12
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 01:25:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0g5Aa2bIudfU/XFfP7AfbfIOG+59B11fV9VXQfZXGs4=;
        b=XjmWK1BC3gJoecpLsZncNwNIUJyIQwCl7+m/0GLNYVkE2rQDlFr7gEhYYfGLq/UDBL
         xfAwssNdAu4JZkfy94DWKHbfzY35M/iQO/lasC/CI+F8cP7yzwtEiCRprvWZYFE5dTUf
         Q3yzmXPB4yTrX4huLFSP6R6UiO2NljoR/HuoJ7C3lwX++dbFT1IFuJtoyTczunnHlttp
         L/nmzFtEBYv++rqV8RmETre5QijD2hALpVcikw39UKi+V++VUe2paaEqPUkHtsD0AI6s
         aCJ92Ew7ZidOSx1n9/2f3pm28dMDvunWCcNswDjcXYGy1EvdJ/dRgY93OyG5G4iTAVwu
         ibJA==
X-Gm-Message-State: APjAAAWaJDRASuhPVbVZcw+iQrSnaMRWNpGnihqo/2jeqUWadbkVnuSN
        Bm7rJPgqHw3ONm1BBjWZqkSoh7iXWt8+a9nOAgj7S9EBL9pNZId0t8KsL18eLqEt+sHIPDzHQDG
        eIGQOLE1rAE/P
X-Received: by 2002:a5d:438c:: with SMTP id i12mr4123166wrq.196.1575365114862;
        Tue, 03 Dec 2019 01:25:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqzzEWXwWzryTExqHKw8nJKWRk8EEzSfa7nZJtQ7apF/mzzDLVtxzY2DrxKGbUUeWpobgKr7ug==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr4123146wrq.196.1575365114666;
        Tue, 03 Dec 2019 01:25:14 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id u10sm2196064wmd.1.2019.12.03.01.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 01:25:14 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] KVM: X86: Fix kvm_bitmap_or_dest_vcpus() to use irq shorthand
In-Reply-To: <20191202201314.543-2-peterx@redhat.com>
References: <20191202201314.543-1-peterx@redhat.com> <20191202201314.543-2-peterx@redhat.com>
Date:   Tue, 03 Dec 2019 10:25:13 +0100
Message-ID: <875zixdame.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: e7uRcGKjPaOxvPPgXrAveA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> The 3rd parameter of kvm_apic_match_dest() is the irq shorthand,
> rather than the irq delivery mode.
>
> Fixes: 7ee30bc132c683d06a6d9e360e39e483e3990708

Better expressed as

Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target v=
CPUs")

> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index cf9177b4a07f..1eabe58bb6d5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1151,7 +1151,7 @@ void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, stru=
ct kvm_lapic_irq *irq,
>  =09=09=09if (!kvm_apic_present(vcpu))
>  =09=09=09=09continue;
>  =09=09=09if (!kvm_apic_match_dest(vcpu, NULL,
> -=09=09=09=09=09=09 irq->delivery_mode,
> +=09=09=09=09=09=09 irq->shorthand,
>  =09=09=09=09=09=09 irq->dest_id,
>  =09=09=09=09=09=09 irq->dest_mode))
>  =09=09=09=09continue;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

--=20
Vitaly

