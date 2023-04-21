Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1EB6EB5FA
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 01:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbjDUXxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 19:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbjDUXxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 19:53:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2823A2135
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682121110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VAFP2288uyWDKnQaDiMb9JDvr08+DkWektgG+J7MkUQ=;
        b=FAFATolsf2au/EVDZcgXfPKn73/JNIye4bl0k0wf3ZJgbxWZay6duic4W8CyDFSoT7BdMr
        fYhzdoyE3CAU03jvNddp8i7wGpUGaWChG3L5NzEbuxWyqEq68Q4+V/fH7y0uQ48zv7LSgY
        ytn/5tUNsXcRQf/NWUxxH8GhIdoUXBM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-CWdawScKNliGk6V95ALVwg-1; Fri, 21 Apr 2023 19:51:49 -0400
X-MC-Unique: CWdawScKNliGk6V95ALVwg-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-50489ad5860so2063061a12.1
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682121108; x=1684713108;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VAFP2288uyWDKnQaDiMb9JDvr08+DkWektgG+J7MkUQ=;
        b=etQ3byYUGRY8Siijy4o0jzBRwZXGX83qIXOAZGm2l0Aoyxr/B+NPfaZk/Lot2X9zzD
         cIInoY8A99Cnmv0HjOAQxudeAjcKBQ5w6aoYbYEhTBZ3GyHtvTWs3m/vtLPmBGJYQcbX
         9an1jVsjnklOjqJulmSJ2G5JqldNf9mMPJcv/WDOefVA4PGULoIbnBZpEN+k3bJw94be
         a80ZdiDncWNOsypQedbYbgUlCMZQg3bFPmknPjiL+Q+xIcnC83KKGFHmXOfM0KZlDC+f
         BSRlb5JsHAIEgnUDDBZiuB23OsfvCvAfwA3jP2ulUiTFaKFoLqksZpiB5I6oPYv/+oCl
         D99w==
X-Gm-Message-State: AAQBX9fBxBBC2OfwXclt1Ckl9Ap7+OnDPI7hIc9dBLbHDwM4U2LDJH+a
        5rkFPaEvIP7r7Q2Uh3DDSU4KpZSUVbdw1U4b38RSwpgFIGsL3532yI7ahUXfTkZgDxnE4t3PWzI
        FqVH8WpKxyHlw
X-Received: by 2002:aa7:c0c8:0:b0:508:46d4:898 with SMTP id j8-20020aa7c0c8000000b0050846d40898mr6632987edp.4.1682121107935;
        Fri, 21 Apr 2023 16:51:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350YzUsfT5OzAaPvtfkCtGstYci4TW877mQiPePfbMHufEdXmAlB27b5i/YoYiyZeasdBM4nQLw==
X-Received: by 2002:aa7:c0c8:0:b0:508:46d4:898 with SMTP id j8-20020aa7c0c8000000b0050846d40898mr6632974edp.4.1682121107624;
        Fri, 21 Apr 2023 16:51:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id f7-20020a05640214c700b004fa380a14e7sm2293807edx.77.2023.04.21.16.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 16:51:47 -0700 (PDT)
Message-ID: <417f815d-3cf1-45ea-eba7-83e42f249424@redhat.com>
Date:   Sat, 22 Apr 2023 01:51:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [GIT PULL v2] KVM/arm64 fixes for 6.3, part #4
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mostafa Saleh <smostafa@google.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
References: <ZEAOmK52rgcZeDXg@thinky-boi>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZEAOmK52rgcZeDXg@thinky-boi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/23 17:54, Oliver Upton wrote:
> Hi Paolo,
> 
> Here is v2 of the last batch of fixes for 6.3 (for real this time!)
> 
> Details in the tag, but the noteworthy addition is Dan's fix for a
> rather obvious buffer overflow when writing to a firmware register.

At least going by the Fixes tag, I think this one should have been Cc'd 
to stable as well.  Can you send it next week or would you like someone 
else to handle the backport?

Thanks,

Paolo

