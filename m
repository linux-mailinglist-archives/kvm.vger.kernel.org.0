Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605104E26AE
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 13:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347470AbiCUMhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 08:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347471AbiCUMhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 08:37:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AA98135097
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 05:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647866182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j4mt2z8G73oPPdNS7w7kArnqN7wtglYSCD3zX7dZXXY=;
        b=Punjd72/Lb98TzzQuIlcxwt43YnZeYGmudMkifSYH7Lps6ioggHNcB7nT55p6kQUpUBEou
        2Fy/89rWYs1a96sSnMDlFb+LJYkrFDXgeTyhiH2fR4j5PmULJzmXsR6pUt9CLM5MGfGa13
        OZOMSUc/SZEpSR3tGXnk2+8JeTrBWKw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-wf39U_YGNn6jiTTENePRfQ-1; Mon, 21 Mar 2022 08:36:20 -0400
X-MC-Unique: wf39U_YGNn6jiTTENePRfQ-1
Received: by mail-ej1-f70.google.com with SMTP id gx12-20020a1709068a4c00b006df7e8181ceso6694681ejc.10
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 05:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j4mt2z8G73oPPdNS7w7kArnqN7wtglYSCD3zX7dZXXY=;
        b=uKbxu7Aw0SkI5DO2Xvl7L61R0DXcl78a20bgdtikeZKYR9/6JqmsUbACXGe6d1w2Tz
         t3bnB5OqRBOUrWXKB1nPgL0bmmhSfhnfxB+H241mvXFqXNIYqzirgQ/W79EKJ8DpvtMI
         Kr4OvYnBnZ+AMHLstJkAVm7d9BEBW+uraA41FA2yp3ju3FP/S2wmDjS+J/MCpfcrfMjl
         iKQ5p4CqcR0fHMGN0fIOz391/NB8Ut3Qv2k1wWvd2djIFv6bnm7XEWxMftHoUt3sVvUE
         dxIHibE0FvSSCW52RnNzSA5QESWKfLch6xVMJV1hfXYTufuxsy0mW6b3fQm+593679PC
         owjA==
X-Gm-Message-State: AOAM532ErH0Gbja5TTg47CsAoODkC3pku+DJ11Z1Rxy24CsNivGa6fbm
        zJguwmT64Rnieqw9PJRRmPcr1JaGEFzUDQyUH3z0/B9JDLRyf247stATijbDUdPer4Kqv5Z/76b
        xkUMiUuAKQltL
X-Received: by 2002:a17:907:7e96:b0:6da:f7ee:4a25 with SMTP id qb22-20020a1709077e9600b006daf7ee4a25mr20044599ejc.436.1647866179502;
        Mon, 21 Mar 2022 05:36:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIBV2YIUabsR7MbXueBSlyGsmrPkTf04N9CSj+jAbB+uboLmR2MrNGoeAKy67xLwBphvo8mw==
X-Received: by 2002:a17:907:7e96:b0:6da:f7ee:4a25 with SMTP id qb22-20020a1709077e9600b006daf7ee4a25mr20044578ejc.436.1647866179294;
        Mon, 21 Mar 2022 05:36:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id oz10-20020a1709077d8a00b006dd5103bac9sm6900154ejc.107.2022.03.21.05.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 05:36:18 -0700 (PDT)
Message-ID: <f780aec0-25c0-1779-f226-c4a4ce50ae5a@redhat.com>
Date:   Mon, 21 Mar 2022 13:36:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <YjTRyssYQhbxeNHA@google.com>
 <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
 <YjWNfQThS4URRMZC@google.com>
 <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
 <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
 <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
 <100b54469a8d59976bbd96f50dd4cd33.squirrel@twosheds.infradead.org>
 <9ca10e3a-cd99-714a-76ad-6f1b83bb0abf@redhat.com>
 <YjbrOz+yT4R7FaX1@google.com>
 <9afd33cb-4052-fe15-d3ae-69a14ca252b0@redhat.com>
 <YjfMBYsse95znupa@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YjfMBYsse95znupa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/22 01:51, Oliver Upton wrote:
>>
>> Right now we have guestTSCOffset as a vCPU attribute, we have guestTOD
>> returned by KVM_GET_CLOCK, and we plan to have hostTSCFreq in sysfs. It's a
>> bit mix-and-match, but it's already a 5-tuple that the destination can use.
>> What's missing is a ioctl on the destination side that relieves userspace
>> from having to do the math.
> That ioctl will work fine, but userspace needs to accept all the
> nastiness that ensues. If it yanks the guest too hard into the future
> it'll need to pick up the pieces when the guest kernel panics.

It can do that before issuing the ioctl, by comparing the source and 
destination TOD, can't it?

Paolo

