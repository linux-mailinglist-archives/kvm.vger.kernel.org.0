Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4081F53F1B0
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 23:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbiFFV1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 17:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234787AbiFFV1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 17:27:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08E5F1D0F5
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 14:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654550863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0gHafx1/UEiuRTrmu2J/TCDpx54W1WkTUpOQaQflrmc=;
        b=XuTdQo5LrImIrqd7LEYALjuvh5hQT+B26Dpweq+g+/v6T8K3mpBZZAh5+k/Pyj3pAdzNmf
        OnSdI5qAWvux48QVDnPJnAR8kPgd/hvNspm7cf+AIC/g5lbhjMJTmATaDITFI6Fnh0dPEq
        vppyu1i5+yWg8ACzJ+bacAvTUnUTIZg=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-TSo88qUSP3GQ07ZY_vew1Q-1; Mon, 06 Jun 2022 17:27:42 -0400
X-MC-Unique: TSo88qUSP3GQ07ZY_vew1Q-1
Received: by mail-il1-f200.google.com with SMTP id p12-20020a056e02144c00b002d196a4d73eso12428705ilo.18
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 14:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0gHafx1/UEiuRTrmu2J/TCDpx54W1WkTUpOQaQflrmc=;
        b=JQWjNYX4plPLPIDTIp9kPPF64C4JmYaEzQAPBpsGHhzTi7elMRA0qNqXgzg6zrxOlW
         BPWPuHeOC5gVVTScECS02G67wv1fHOeJay5XqZPeMLhDNASFl8C8eP8lXdGxCUG7KzmB
         syq1dyzHQUkbOyueHMgzeBXN0u2zzUwrGB3EpxwBRaifIZKWnr9J2fwVEFAzlKT4WhuH
         qU03u0nciKdii8qNslDSeYmQlgsjxVF+6lUwMFf/NH/kw4AUZlFk7ynqaLq5qfjAq7Wr
         YQ09zlzWLu3QhlonDOKRP9gGu+b6afdBZd1LkpBJAab3XHrYZx03i0bjA6uNxb1lrt7S
         93Og==
X-Gm-Message-State: AOAM532d6XVPkgn3v+qqjIeWXaqugYZoRNSZy3IMGbMmlJHKzwkrcN5W
        OwsU5cy5zflODFgw1Eh57xQWLfy8gIkojfTRCIr8nFVwFNyXhqPmuS2O7FNS+nWMQETfcJTcHSb
        oDoxREYB1d97o
X-Received: by 2002:a6b:b552:0:b0:668:9215:a4a1 with SMTP id e79-20020a6bb552000000b006689215a4a1mr12207347iof.20.1654550861291;
        Mon, 06 Jun 2022 14:27:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygrthUv4dmOMiSXgg0nazpIEw06i7aozoK5SHLCqqaTiiH6rk/o1epUh6iMKjf5nK+vVWocQ==
X-Received: by 2002:a6b:b552:0:b0:668:9215:a4a1 with SMTP id e79-20020a6bb552000000b006689215a4a1mr12207339iof.20.1654550861051;
        Mon, 06 Jun 2022 14:27:41 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id a1-20020a056e0208a100b002d53ade2fffsm1449802ilt.85.2022.06.06.14.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 14:27:40 -0700 (PDT)
Date:   Mon, 6 Jun 2022 17:27:38 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Leonardo Bras <leobras@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        chang.seok.bae@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH AUTOSEL 5.16 07/28] x86/kvm/fpu: Limit guest
 user_xfeatures to supported bits of XCR0
Message-ID: <Yp5xSi6P3q187+A+@xz-m1.local>
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-7-sashal@kernel.org>
 <5f2b7b93-d4c9-1d59-14df-6e8b2366ca8a@redhat.com>
 <YppVupW+IWsm7Osr@xz-m1.local>
 <2d9ba70b-ac18-a461-7a57-22df2c0165c6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2d9ba70b-ac18-a461-7a57-22df2c0165c6@redhat.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 06, 2022 at 06:18:12PM +0200, Paolo Bonzini wrote:
> > However there seems to be something missing at least to me, on why it'll
> > fail a migration from 5.15 (without this patch) to 5.18 (with this patch).
> > In my test case, user_xfeatures will be 0x7 (FP|SSE|YMM) if without this
> > patch, but 0x0 if with it.
> 
> What CPU model are you using for the VM?

I didn't specify it, assuming it's qemu64 with no extra parameters.

I just tried two other options with: (1) -cpu host, and (2) -cpu Haswell
(the choice of Haswell was really random..), with the same 5.15->5.18
migration scenario, both of them will not trigger the same guest kernel
crash.  Only qemu64 will.

Both hosts have Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz.

> For example, if the source lacks this patch but the destination has it,
> the source will transmit YMM registers, but the destination will fail to
> set them if they are not available for the selected CPU model.
> 
> See the commit message: "As a bonus, it will also fail if userspace tries to
> set fpu features (with the KVM_SET_XSAVE ioctl) that are not compatible to
> the guest configuration.  Such features will never be returned by
> KVM_GET_XSAVE or KVM_GET_XSAVE2."

IIUC you meant we should have failed KVM_SET_XSAVE when they're not aligned
(probably by failing validate_user_xstate_header when checking against the
user_xfeatures on dest host). But that's probably not my case, because here
KVM_SET_XSAVE succeeded, it's just that the guest gets a double fault after
the precopy migration completes (or for postcopy when the switchover is
done).

Thanks,

-- 
Peter Xu

