Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309AB645060
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 01:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLGAeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 19:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiLGAeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 19:34:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CADA17A94
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 16:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670373196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NZl+Hf1IB2CG9zoSnbGugOz3yIdHJ+P71G6LngJeT/A=;
        b=bklKbQWxnjMSwkEQSHoDqMsqxWDQYvjYJOzLbuhYP4C2H+q9Zxi1FGgNCWTOpvFb2T+SuB
        Yf1LfIAgHPXmuwAs5T5pO3n9Ek10wHZm66RAgfRkEiT5WZVuI++mqGz1XtjEMNnyLbf2i0
        Ywcdcr49XbDPHAu6SrDoV2jxuDCol58=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-138-u5iR4vuYO7ud7LXRyLRyIA-1; Tue, 06 Dec 2022 19:33:14 -0500
X-MC-Unique: u5iR4vuYO7ud7LXRyLRyIA-1
Received: by mail-ej1-f72.google.com with SMTP id hp16-20020a1709073e1000b007adf5a83df7so2413188ejc.1
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 16:33:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NZl+Hf1IB2CG9zoSnbGugOz3yIdHJ+P71G6LngJeT/A=;
        b=gEDytu5Xpm3RgJz/ubgWopCybQfrr5z6ysz+JTcegGjPoNW4pTDTtor1tgOmuyD+9L
         IXD5LSSQbpltV6v3bsSxfMV1o/NdbYWaAIx/pG3pAFwlN4I6RN9ze5fSFNsoCw11kK5i
         2cp1kIg+oyEK4bM5uF35ychIFqNtpC8MFX7qm4+yf9gw+OUY6g17FSIbxpauxjnsvBYD
         dafaB5oTWcMLEmvK4wAHMbVTnL/WvfIJVmq7gb4DTDpkiiUpWUXgSrjcSFsJsxXv2dKZ
         DUNAEOS2YZJgLZJzxDUCxXD7STCPSa2iWU4pu2+3qQIPxDO73EBn79zUmPfZ/8J8P5BE
         /Dhg==
X-Gm-Message-State: ANoB5pkAJVWNhcFL3S30BvV73g8w/tSfVfPseBSkU8zG6lHxePkfkqlM
        c2AwHY3d0fvnO0WsUff3PnI2VXqo/rtSvgZP0k0rEbJMqrxZIXcH69h9UB96X7vdYQTIw/uzcFm
        c36n+fHazbUoR
X-Received: by 2002:a05:6402:2992:b0:460:12ef:cc45 with SMTP id eq18-20020a056402299200b0046012efcc45mr22630466edb.249.1670373193797;
        Tue, 06 Dec 2022 16:33:13 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4TAPRCHrT8/SPQq1PN5R701IyzQgAlgjWljvBLEL6tTqPRlkI1rDN9WpJeQU3BiKG2bx5rfg==
X-Received: by 2002:a05:6402:2992:b0:460:12ef:cc45 with SMTP id eq18-20020a056402299200b0046012efcc45mr22630455edb.249.1670373193566;
        Tue, 06 Dec 2022 16:33:13 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id l12-20020aa7d94c000000b0046b1d63cfc1sm1533413eds.88.2022.12.06.16.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 16:33:13 -0800 (PST)
Message-ID: <47b3d23b-e00e-b78f-69f4-4687f4ac607f@redhat.com>
Date:   Wed, 7 Dec 2022 01:33:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: selftests: Fix build for memstress.[ch] rename
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        Marc Zyngier <maz@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20221206175916.250104-1-broonie@kernel.org>
 <20221207074108.42477c2d@canb.auug.org.au>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221207074108.42477c2d@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/22 21:42, Stephen Rothwell wrote:
> Thanks for that.  I have added that as a merge fix patch to the kvm-arm
> merge.  I assume this will be fixed up when that tree is merged into
> the kvm tree.

Yes, I'll push as soon as I get confirmation that my own resolution is 
correct.

Paolo

