Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CF1607340
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 11:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiJUJID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 05:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiJUJIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 05:08:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A588F251D55
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 02:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666343278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MNw8AC5b+llDM1gmU2HXsAh1LFF65S14nk18Zclt7ao=;
        b=Ph35VijTKqOWctbLqwtRCYDuTZhPx4qCwTPZxqPclQk6BlZ/r/swpDIaEZDEsUHV/N1JhS
        JHysJ/imN4wh/+pEti7ODfiKsvQR/hVpxBxnuN7OpKDaSu9rEQpQxGTHCgg16sTG1PF7Z1
        gJaH1I5EmPEaGuZMG78nI+Ka/bfEYNk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-543-J2i4nhM3P9e9i9AV1e-5Vg-1; Fri, 21 Oct 2022 05:07:57 -0400
X-MC-Unique: J2i4nhM3P9e9i9AV1e-5Vg-1
Received: by mail-ed1-f72.google.com with SMTP id z20-20020a05640240d400b0045cec07c3dcso1700669edb.3
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 02:07:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MNw8AC5b+llDM1gmU2HXsAh1LFF65S14nk18Zclt7ao=;
        b=jiiEQo7ux8WxBShotnTcRVjYvRsQjJxzy8VIYEWFutsWtc2kW8FrxPL6T34JeBF9gi
         eMgLKZVXk13sybtZ6eM5m76W1e34gioHIaXMnXqzc0sBmZla5sBDfNLJ6W4CesrnL34I
         82gJgHQSKm1A+sjRRYKQ9cipXzX011KEIEGPkdej+AwAm3eVn+WES1aSVehPAFE1MWyi
         xqRMwUDhwZum2VBxzvsOhCvtP04rC8m/g/+Ytw7Jddqd+VcNOtIf8Ok9Kj1jIhy3qvza
         W3QoMflDHXChuXYRbUcBfPesMd68NPYkAuieQfHpBea8mPNAkuXeSffAb91gWyfyfjkk
         wotw==
X-Gm-Message-State: ACrzQf3h9bvFqmby+6B4+vHxZnNTff+ciPxE6BVeqoDbBKtElXpJvOky
        ryB+PU1a1H0HtcjmF1hN3n3z5qPaEW5vAr4cOX//XvbarucQUGivx6qgsWBRa69Baz7GFJhGniC
        OTXQF9pcu0Gi9
X-Received: by 2002:aa7:c04f:0:b0:457:1b08:d056 with SMTP id k15-20020aa7c04f000000b004571b08d056mr17007036edo.146.1666343276113;
        Fri, 21 Oct 2022 02:07:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM69NlpmYvYv3ssSGswnUuzLIS1UqmQvOGi0GdebezUPqC7rmqfHYelpVj4T6cq0qaion/WYLw==
X-Received: by 2002:aa7:c04f:0:b0:457:1b08:d056 with SMTP id k15-20020aa7c04f000000b004571b08d056mr17007008edo.146.1666343275745;
        Fri, 21 Oct 2022 02:07:55 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g12-20020a1709061e0c00b0079d7ec3b211sm73622ejj.150.2022.10.21.02.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 02:07:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 16/46] KVM: x86: hyper-v: Don't use
 sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
In-Reply-To: <Y1BahCzO4jxFC9Ey@google.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
 <20221004123956.188909-17-vkuznets@redhat.com>
 <Y1BahCzO4jxFC9Ey@google.com>
Date:   Fri, 21 Oct 2022 11:07:53 +0200
Message-ID: <87czalczo6.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Oct 04, 2022, Vitaly Kuznetsov wrote:

...

>>  
>> -	if (all_cpus) {
>> -		kvm_send_ipi_to_many(kvm, vector, NULL);
>> -	} else {
>> -		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
>> -
>> -		kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
>> -	}
>> +	kvm_hv_send_ipi_to_many(kvm, vector, all_cpus ? NULL : sparse_banks, valid_bank_mask);
>
> Any objection to not using a ternary operator?
>
> 	if (all_cpus)
> 		kvm_hv_send_ipi_to_many(kvm, vector, NULL, 0);
> 	else
> 		kvm_hv_send_ipi_to_many(kvm, vector, sparse_banks, valid_bank_mask);
>

Not at all,

> Mostly because it's somewhat arbitrary that earlier code ensures valid_bank_mask
> is set in the all_cpus=true case, e.g. arguably KVM doesn't need to do the var_cnt
> sanity check in the all_cpus case:
>
> 		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
> 		if (all_cpus)
> 			goto check_and_send_ipi;
>
> 		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
> 		if (hc->var_cnt != hweight64(valid_bank_mask))
> 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>
> 		if (!hc->var_cnt)
> 			goto ret_success;
>

I think 'var_cnt' (== hweight64(valid_bank_mask)) has to be checked in
'all_cpus' case, especially in kvm_hv_flush_tlb(): the code which reads
TLB flush entries will read them from the wrong offset (data_offset/
consumed_xmm_halves) otherwise. The problem is less severe in
kvm_hv_send_ipi() as there's no data after CPU banks. 

At the bare minimum, "KVM: x86: hyper-v: Handle
HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently" patch from this
series will have to be adjusted. I *think* mandating var_cnt==0 in 'all_cpus'
is OK but I don't recall such requirement from TLFS, maybe it's safer to
just adjust 'data_offset'/'consumed_xmm_halves' even in 'all_cpus' case.

Let me do some tests... 

-- 
Vitaly

