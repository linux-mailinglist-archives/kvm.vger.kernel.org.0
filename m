Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B606D59FCC2
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 16:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbiHXOI0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 24 Aug 2022 10:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238947AbiHXOIX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 10:08:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2B980B52
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 07:08:21 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mtapsc-6-ghGUv7j0O3m0zh5AFDe3JQ-1; Wed, 24 Aug 2022 15:08:18 +0100
X-MC-Unique: ghGUv7j0O3m0zh5AFDe3JQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.38; Wed, 24 Aug 2022 15:08:16 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.040; Wed, 24 Aug 2022 15:08:16 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Dapeng Mi' <dapeng1.mi@intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>
Subject: RE: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Thread-Topic: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Thread-Index: AQHYt5jew4bd/Wm5HEGEwtUmwJqWVq2+FJOw
Date:   Wed, 24 Aug 2022 14:08:16 +0000
Message-ID: <66ba8291b33e440280ead8418b8b21ee@AcuMS.aculab.com>
References: <20220824091117.767363-1-dapeng1.mi@intel.com>
In-Reply-To: <20220824091117.767363-1-dapeng1.mi@intel.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dapeng Mi
> Sent: 24 August 2022 10:11
> 
> TPAUSE is a new instruction on Intel processors which can instruct
> processor enters a power/performance optimized state. Halt polling
> uses PAUSE instruction to wait vCPU is waked up. The polling time
> could be long and cause extra power consumption in some cases.
> 
> Use TPAUSE to replace the PAUSE instruction in halt polling to get
> a better power saving and performance.

What is the effect on wakeup latency?
Quite often that is far more important than a bit of power saving.

The automatic entry of sleep states is a PITA already.
Block 30 RT threads in cv_wait() and then do cv_broadcast().
Use ftrace to see just how long it takes the last thread
to wake up.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

