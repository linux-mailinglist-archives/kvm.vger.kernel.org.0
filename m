Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A0457A60B
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 20:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbiGSSEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 14:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239797AbiGSSEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 14:04:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4136952E40
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 11:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658253873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OMC1Nve8Ww8I2o5thOFNVtOQDQm1fu5RR9KZiFlM7/Q=;
        b=I5dIkXM4UyBk85S6+zHWE0mrscwoET+AltZ67Ue/aAxKPyPmxxj0E7fL0ngsdAymjNdlgi
        AWZW5BIbX1c6/E5FTnahAr3+WHg7Jii6FudwE48ME44S3loTX+XpekjiDky7q8j7h16V9u
        arKUbhkO6WC39XnImqBt5H29/6A7lDo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-gT3PZHqRNaWrkN8DrU8D4A-1; Tue, 19 Jul 2022 14:04:32 -0400
X-MC-Unique: gT3PZHqRNaWrkN8DrU8D4A-1
Received: by mail-ed1-f72.google.com with SMTP id b7-20020a056402350700b0043baadc4a58so312784edd.2
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 11:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OMC1Nve8Ww8I2o5thOFNVtOQDQm1fu5RR9KZiFlM7/Q=;
        b=FsEaW7917Ky76cTt9TenKmOzG1DXlKMEWL7/DOTQwSVCr1PLZgKRw6IjrjjSvQvHqw
         qdX0ypIi6BANrphdCoWTlMc1LOq2Hj8UDOMpNvTEUPBkxiMzLHTpHFFIf1YsrZqm4q3l
         zZXW7+x21Kj+jK7s1LOrwrfaeDJ/ES/HUzLTmmr+TQ4xK0tIXcRinD/iK93F+JZGbKbO
         74WoG5J7bKZI9T0QYD96lo947tvK7y2LXU9N3fhW39XNGCqJOHRbQOmCyF3jiVqOsGjh
         L1KxWDmyOWltbuH1KX6N34TRKRI1vyhWxCfNYpoNS1Wj3S4bzypArptsjGXgmgd+/gN9
         1weA==
X-Gm-Message-State: AJIora/p6jH0vQGflrMi6C9bh9DrZscwDpRlOfPuFVIVb5SWuSYQZW1f
        cVNgjHwLbmnyNXshCFNVzBWC/C+zhp9ITxBzk9ikgLjbuze6ihzh1mssdF1dlGzJE5L6Xqoxdm7
        9OYAWdb1QrhRP
X-Received: by 2002:a05:6402:158b:b0:43a:6cae:a029 with SMTP id c11-20020a056402158b00b0043a6caea029mr45930707edv.201.1658253870945;
        Tue, 19 Jul 2022 11:04:30 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sUFo7dnG5EMCTCD88JxrsB40zI8MBMig1ggUUq+7mBvnc+s7IAGolpOf1UgQc8HozmKOgx+A==
X-Received: by 2002:a05:6402:158b:b0:43a:6cae:a029 with SMTP id c11-20020a056402158b00b0043a6caea029mr45930679edv.201.1658253870704;
        Tue, 19 Jul 2022 11:04:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id c7-20020aa7df07000000b0043a7c24a669sm10777699edy.91.2022.07.19.11.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 11:04:30 -0700 (PDT)
Message-ID: <8da08a8a-e639-301d-ca98-d85b74c1ad20@redhat.com>
Date:   Tue, 19 Jul 2022 20:04:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH] KVM: x86: Protect the unused bits in MSR exiting
 flags
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20220714161314.1715227-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220714161314.1715227-1-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/22 18:13, Aaron Lewis wrote:
> ---
> 
> Posting as an RFC to get feedback whether it's too late to protect the
> unused flag bits.  My hope is this feature is still new enough, and not
> widely used enough, and this change is reasonable enough to be able to be
> corrected.  These bits should have been protected from the start, but
> unfortunately they were not.
> 
> Another option would be to correct this by adding a quirk, but fixing
> it that has its down sides.   It complicates the code more than it
> would otherwise be, and complicates the usage for anyone using any new
> features introduce in the future because they would also have to enable
> a quirk.  For long term simplicity my hope is to be able to just patch
> the original change.

Yes, let's do it this way.

Paolo

