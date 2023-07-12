Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71D17511B5
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 22:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjGLUMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 16:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjGLUMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 16:12:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7635210C
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 13:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689192709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Etu2k6zwAG9Me27JlIKcIeXqzfl+VhnaqZBcAwslO4o=;
        b=S7CngY5oetCPc/c5ingoFtndLVImuU4LtjucS7xSHJaiGc08kdohRrbXyvl0LQ0DrSrNzh
        AjQKnO8rEwue8wvhhFaC3obSxlc9qkZZseXGiuxroUm7CRVdd9ShTvKKEqNNhvWY0KRCR0
        dYrA1h0t4Qy5Vjz4065H7lbx4Rcgwfk=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-tzZLcLKzNOqb8ozN6TnJtQ-1; Wed, 12 Jul 2023 16:11:47 -0400
X-MC-Unique: tzZLcLKzNOqb8ozN6TnJtQ-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6b8a9860ba3so8251236a34.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 13:11:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689192707; x=1691784707;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Etu2k6zwAG9Me27JlIKcIeXqzfl+VhnaqZBcAwslO4o=;
        b=i5Bsxk57eiVD+M4TsW6XauY4VdLcyeTvtoZPV5W7NuKGC9POAkYALwy60w5NAh9zoX
         RzxAH34m72DzICff3JBAXQzSMa6/GcPZ9lMdSJR0RSqPRZwvsJU7TbjURpT9DFPHifkd
         9V5yNviV3MUzSXANGV2jopHCOBJUqOKkr1M1445e1h02V+BJk1mHPePi0VKawNNyRoQE
         i3xhR7/8+lvO4vA+i/7uGD9h6UxfSF3XjzrS37gVNY1M9m44txHPq7e21vMSe1OKsooh
         pnitsrrfMpC70VQxfC4vjaY+gLHnitejfo8TKMrutjRamAsDGcVuHI/RzaFUzNsfb6aZ
         LspA==
X-Gm-Message-State: ABy/qLYakhfdItGx0fXmxuyRSR1Sv2Th1R0iVXVTp1wK3RdpV2RgcFIl
        EALQq40e6AzYE02tIJg73wsE3ZwXJ3/bm3lPlHyFAL2DCugOtBiQRzER/ttzoh7dZWLAOQFqrkm
        9EtCtRO3T6xoG
X-Received: by 2002:a9d:6451:0:b0:6b7:54cd:2115 with SMTP id m17-20020a9d6451000000b006b754cd2115mr17043479otl.3.1689192706968;
        Wed, 12 Jul 2023 13:11:46 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH+sazM801XOOJtQYqWIKxx0R77N3fs10T9jRDTeix2fq2bXvU1kvzcIS4DHtUCKxuYz0P0uA==
X-Received: by 2002:a9d:6451:0:b0:6b7:54cd:2115 with SMTP id m17-20020a9d6451000000b006b754cd2115mr17043463otl.3.1689192706732;
        Wed, 12 Jul 2023 13:11:46 -0700 (PDT)
Received: from [192.168.8.101] (tmo-097-78.customers.d1-online.com. [80.187.97.78])
        by smtp.gmail.com with ESMTPSA id x12-20020ae9e90c000000b00767d8e12ce3sm2407027qkf.49.2023.07.12.13.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 13:11:46 -0700 (PDT)
Message-ID: <88070b30-36ea-8112-41c4-0d93fc76cf80@redhat.com>
Date:   Wed, 12 Jul 2023 22:11:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-17-pmorel@linux.ibm.com>
 <dfeeeaa1-0994-9e1e-1f10-6c6618daacff@redhat.com>
 <aa1fbe820f23bc487752ee29ee114f5d4185352a.camel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v21 16/20] tests/avocado: s390x cpu topology entitlement
 tests
In-Reply-To: <aa1fbe820f23bc487752ee29ee114f5d4185352a.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/07/2023 21.37, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-07-05 at 12:22 +0200, Thomas Huth wrote:
>> On 30/06/2023 11.17, Pierre Morel wrote:
>>> This test takes care to check the changes on different entitlements
>>> when the guest requests a polarization change.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>    tests/avocado/s390_topology.py | 47
>>> ++++++++++++++++++++++++++++++++++
>>>    1 file changed, 47 insertions(+)
>>>
>>> diff --git a/tests/avocado/s390_topology.py
>>> b/tests/avocado/s390_topology.py
>>> index 2cf731cb1d..4855e5d7e4 100644
>>> --- a/tests/avocado/s390_topology.py
>>> +++ b/tests/avocado/s390_topology.py
>>> @@ -240,3 +240,50 @@ def test_polarisation(self):
>>>            res = self.vm.qmp('query-cpu-polarization')
>>>            self.assertEqual(res['return']['polarization'],
>>> 'horizontal')
>>>            self.check_topology(0, 0, 0, 0, 'medium', False)
>>> +
>>> +    def test_entitlement(self):
>>> +        """
>>> +        This test verifies that QEMU modifies the polarization
>>> +        after a guest request.
>> ...
>>> +        self.check_topology(0, 0, 0, 0, 'low', False)
>>> +        self.check_topology(1, 0, 0, 0, 'medium', False)
>>> +        self.check_topology(2, 1, 0, 0, 'high', False)
>>> +        self.check_topology(3, 1, 0, 0, 'high', False)
>>> +
>>> +        self.guest_set_dispatching('1');
>>> +
>>> +        self.check_topology(0, 0, 0, 0, 'low', False)
>>> +        self.check_topology(1, 0, 0, 0, 'medium', False)
>>> +        self.check_topology(2, 1, 0, 0, 'high', False)
>>> +        self.check_topology(3, 1, 0, 0, 'high', False)
>>> +
>>> +        self.guest_set_dispatching('0');
>>> +
>>> +        self.check_topology(0, 0, 0, 0, 'low', False)
>>> +        self.check_topology(1, 0, 0, 0, 'medium', False)
>>> +        self.check_topology(2, 1, 0, 0, 'high', False)
>>> +        self.check_topology(3, 1, 0, 0, 'high', False)
>>
>> Sorry, I think I'm too blind to see it, but what has changed after
>> the guest
>> changed the polarization?
> 
> Nothing, the values are retained, they're just not active.
> The guest will see a horizontal polarization until it changes back to
> vertical.

But then the comment in front of it ("This test verifies that QEMU 
*modifies* the polarization...") does not quite match, does it?

  Thomas


