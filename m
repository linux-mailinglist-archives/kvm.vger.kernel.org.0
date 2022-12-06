Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BC66444FF
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbiLFNyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiLFNyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:54:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959C32B600
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 05:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670334788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3ECE0g7YbfMnTJuWIRmn1xP32SqigQ6zugR1ek2C/cw=;
        b=gIoK2Sv1XLB31lvryXFeBV7cwknc0iAyKipNJszmh/8dNcXZt4f7zrp+ryq7ou2OHmkWFV
        XoiY8yj0SXZCSQ9vapiRIRQVPcjcvqd8Uibz5Qu81TV6Jq3IFMciEeqFUqnARoBlNSttMg
        +2go88SA9PDQyS6eiqvpEwFYhYgoiE0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-376-c--faAUuPsyR3tMc_zsHAQ-1; Tue, 06 Dec 2022 08:53:07 -0500
X-MC-Unique: c--faAUuPsyR3tMc_zsHAQ-1
Received: by mail-wr1-f69.google.com with SMTP id v14-20020adf8b4e000000b0024174021277so3241793wra.13
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 05:53:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ECE0g7YbfMnTJuWIRmn1xP32SqigQ6zugR1ek2C/cw=;
        b=fosnmcF+UEw5c07boV2OKowNRJ/ed+URhGdHuiZ6aACQF1cJqSPpL78yJbuojUabVl
         KtUChndXAw+elkraZNpRwZ/WLnO7HTGZLV+x1r6l9l5eIX022nBXRxfkL1/gMHkG2IYI
         p1JIbh+3QQx4MLqX31alYqRSRkofiuC+4GkOse85XwOvrnFElxjttY8OTCpqSDA2lzFY
         UrE7DeWflVKOU7L9pxSQvAp8sBUYqCHGyo6vCPvox3SuKFLzqfIlsr35JSnHQ3PzLQmC
         rqG/lk7m4Eqke3GTIxilwUlKJhnn4tLlXBlbPgfybBr5snZzGi3PoxxbBqhwrUGIyyjh
         7U3Q==
X-Gm-Message-State: ANoB5pnizjnRHKaZ9hoIvti0jSqp7V5h+CgwP6coa1NvebZiKrOflcOk
        fZQ4RrbGxtP4rxNuhPqRYegAY7Ib93e7NCgQ8NR0opGhujyYKDNNPmqw4y4/IsaBxEOP5tSMo/Y
        J6tvhYsTg/QWg
X-Received: by 2002:a7b:c315:0:b0:3cf:ca62:7ab with SMTP id k21-20020a7bc315000000b003cfca6207abmr334258wmj.23.1670334786624;
        Tue, 06 Dec 2022 05:53:06 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4Arxt6oofscVN8skgdjZ/sDcuxwWiozQstiNdWtSwlkiStCmejQeNBgbSlwRCno3PPgyy0+A==
X-Received: by 2002:a7b:c315:0:b0:3cf:ca62:7ab with SMTP id k21-20020a7bc315000000b003cfca6207abmr334256wmj.23.1670334786383;
        Tue, 06 Dec 2022 05:53:06 -0800 (PST)
Received: from ovpn-194-152.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j4-20020a05600c410400b003cfbbd54178sm2937311wmi.2.2022.12.06.05.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 05:53:05 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        coverity-bot <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: hyper-v: Fix 'using uninitialized value'
 Coverity warning
In-Reply-To: <Y4odRLlFRj17tUNE@google.com>
References: <20221202105856.434886-1-vkuznets@redhat.com>
 <Y4odRLlFRj17tUNE@google.com>
Date:   Tue, 06 Dec 2022 14:53:04 +0100
Message-ID: <87pmcwd4fz.fsf@ovpn-194-152.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Dec 02, 2022, Vitaly Kuznetsov wrote:
>> In kvm_hv_flush_tlb(), 'data_offset' and 'consumed_xmm_halves' variables
>> are used in a mutually exclusive way: in 'hc->fast' we count in 'XMM
>> halves' and increase 'data_offset' otherwise. Coverity discovered, that in
>> one case both variables are incremented unconditionally. This doesn't seem
>> to cause any issues as the only user of 'data_offset'/'consumed_xmm_halves'
>> data is kvm_hv_get_tlb_flush_entries() ->  kvm_hv_get_hc_data() which also
>> takes into account 'hc->fast' but is still worth fixing.
>
> If those calls aren't inlined, then 32-bit Hyper-V will be "consuming" uninitialized
> data when pushing parameters onto the stack.  It won't cause real problems, but
> checkers might complain.
>
> What about shoving this metadata into "struct kvm_hv_hcall" as a union?  That'd
> help convey that the two are mutually exclusive, would provide a place to document
> said exclusion, and would yield a nice cleanup too by eliminating multiple params
> from various functions.

"struct kvm_hv_hcall" used to hold raw data from the guest and
'consumed_xmm_halves'/ 'data_offset' are rather our implementation
details, how we consume these data. I don't see why we can't re-purpose
it a little bit to hold both, let me try that in v2.

-- 
Vitaly

