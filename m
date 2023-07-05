Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95618748206
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 12:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjGEKXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 06:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjGEKXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 06:23:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F405122
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 03:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688552575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eYAoDgqG5yTL6DKSA2l6Eg5bMpx7MIVjW+RNb0aXYqA=;
        b=H8j/q3PW2ECHMs4GIRb0hKKVt7eW8x0v+4pv9u8GTEV/u223kpqe+waqDbKpM0ska778tp
        YJasulWG0A1XQ//raKssJqmXcgv9qRQsXuswReVHXL7H6k8vKy6FTxsNZq7TMRuvahPuk7
        +GIcuxV/fFI0HANxI5rc4Nh0CyJ7P04=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-CjoYd023P36T-bCu7MgjOA-1; Wed, 05 Jul 2023 06:22:54 -0400
X-MC-Unique: CjoYd023P36T-bCu7MgjOA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6238c3bf768so65342316d6.0
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 03:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688552574; x=1691144574;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eYAoDgqG5yTL6DKSA2l6Eg5bMpx7MIVjW+RNb0aXYqA=;
        b=T7p3LQKai5xG4mF8pHgRQav/MoGX6q/4D6xpKX8qLUUY88Y6WH52pLxYObxFDD8gOK
         Jo5TYz6f4HyVKq6r/Qyz5PV1n/WF4dEiMQ2ikubdrS4l0feqt31hAFyUmINGt/YnctBo
         EpJvUilnAKSQ7o79fNqBWkmUyLsseeExFH3jFu3Xd8dIdup2XEHKlqEXvOdULMYxiqdF
         7pp6Zw1eftYplk1U8nbg7JgY3XEcOm8quhw0NTtMJq3P+5FlHQfaJiPOcTtYu2rv7gAU
         ENTqT55mqMNm7uHPrxVKRM3egwHCfB4Mc/VtPhMsYkU1wbNqKrfih25FDhlsdlf9v7P0
         /EBw==
X-Gm-Message-State: ABy/qLakRlDyJ+e68rj5E/Mw9keDB+zW3RfzE58RD+ZzfJVLQTU05Cb8
        fRZ3jFRUZU2uWFo11ejTsQ/+Ig1CyqzhLGJq2JJwZYW3aZ+0t/ydCIXIsi9fJATyhgsrxlEZpet
        TVDiPvP9a0sxL
X-Received: by 2002:a05:6214:2aab:b0:632:32ce:7947 with SMTP id js11-20020a0562142aab00b0063232ce7947mr15924649qvb.28.1688552573935;
        Wed, 05 Jul 2023 03:22:53 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH/+9TE2hrEG1oXksRbybS1ZXPdsjMo4JpFFl21cSp3oQfVTKVMBUx1/UbAW7HT8lkP3N+k4g==
X-Received: by 2002:a05:6214:2aab:b0:632:32ce:7947 with SMTP id js11-20020a0562142aab00b0063232ce7947mr15924627qvb.28.1688552573635;
        Wed, 05 Jul 2023 03:22:53 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id cj25-20020a05622a259900b00401e04c66fesm11317353qtb.37.2023.07.05.03.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 03:22:52 -0700 (PDT)
Message-ID: <dfeeeaa1-0994-9e1e-1f10-6c6618daacff@redhat.com>
Date:   Wed, 5 Jul 2023 12:22:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 16/20] tests/avocado: s390x cpu topology entitlement
 tests
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-17-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-17-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2023 11.17, Pierre Morel wrote:
> This test takes care to check the changes on different entitlements
> when the guest requests a polarization change.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   tests/avocado/s390_topology.py | 47 ++++++++++++++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
> 
> diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
> index 2cf731cb1d..4855e5d7e4 100644
> --- a/tests/avocado/s390_topology.py
> +++ b/tests/avocado/s390_topology.py
> @@ -240,3 +240,50 @@ def test_polarisation(self):
>           res = self.vm.qmp('query-cpu-polarization')
>           self.assertEqual(res['return']['polarization'], 'horizontal')
>           self.check_topology(0, 0, 0, 0, 'medium', False)
> +
> +    def test_entitlement(self):
> +        """
> +        This test verifies that QEMU modifies the polarization
> +        after a guest request.
...
> +        self.check_topology(0, 0, 0, 0, 'low', False)
> +        self.check_topology(1, 0, 0, 0, 'medium', False)
> +        self.check_topology(2, 1, 0, 0, 'high', False)
> +        self.check_topology(3, 1, 0, 0, 'high', False)
> +
> +        self.guest_set_dispatching('1');
> +
> +        self.check_topology(0, 0, 0, 0, 'low', False)
> +        self.check_topology(1, 0, 0, 0, 'medium', False)
> +        self.check_topology(2, 1, 0, 0, 'high', False)
> +        self.check_topology(3, 1, 0, 0, 'high', False)
> +
> +        self.guest_set_dispatching('0');
> +
> +        self.check_topology(0, 0, 0, 0, 'low', False)
> +        self.check_topology(1, 0, 0, 0, 'medium', False)
> +        self.check_topology(2, 1, 0, 0, 'high', False)
> +        self.check_topology(3, 1, 0, 0, 'high', False)

Sorry, I think I'm too blind to see it, but what has changed after the guest 
changed the polarization?

  Thomas

