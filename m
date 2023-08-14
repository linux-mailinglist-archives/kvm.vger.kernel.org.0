Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA2C77B3A8
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 10:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjHNIQD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 14 Aug 2023 04:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbjHNIP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 04:15:58 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3564BE4
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 01:15:57 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-66-vUa4Y5K3O7uPj-d0aCKPEA-1; Mon, 14 Aug 2023 09:15:52 +0100
X-MC-Unique: vUa4Y5K3O7uPj-d0aCKPEA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 14 Aug
 2023 09:15:42 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Mon, 14 Aug 2023 09:15:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jordan Niethe' <jniethe5@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC:     "mikey@neuling.org" <mikey@neuling.org>,
        "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "amachhiw@linux.vnet.ibm.com" <amachhiw@linux.vnet.ibm.com>,
        "gautam@linux.ibm.com" <gautam@linux.ibm.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>,
        "kconsul@linux.vnet.ibm.com" <kconsul@linux.vnet.ibm.com>
Subject: RE: [PATCH v3 4/6] KVM: PPC: Book3s HV: Hold LPIDs in an unsigned
 long
Thread-Topic: [PATCH v3 4/6] KVM: PPC: Book3s HV: Hold LPIDs in an unsigned
 long
Thread-Index: AQHZyNG7ikdvGXAAREO0SOjaRIAWw6/pfTeA
Date:   Mon, 14 Aug 2023 08:15:41 +0000
Message-ID: <014488c6d90446f38154a2f7645aa053@AcuMS.aculab.com>
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-5-jniethe5@gmail.com>
In-Reply-To: <20230807014553.1168699-5-jniethe5@gmail.com>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jordan Niethe
> Sent: 07 August 2023 02:46
> 
> The LPID register is 32 bits long. The host keeps the lpids for each
> guest in an unsigned word struct kvm_arch. Currently, LPIDs are already
> limited by mmu_lpid_bits and KVM_MAX_NESTED_GUESTS_SHIFT.
> 
> The nestedv2 API returns a 64 bit "Guest ID" to be used be the L1 host
> for each L2 guest. This value is used as an lpid, e.g. it is the
> parameter used by H_RPT_INVALIDATE. To minimize needless special casing
> it makes sense to keep this "Guest ID" in struct kvm_arch::lpid.
> 
> This means that struct kvm_arch::lpid is too small so prepare for this
> and make it an unsigned long. This is not a problem for the KVM-HV and
> nestedv1 cases as their lpid values are already limited to valid ranges
> so in those contexts the lpid can be used as an unsigned word safely as
> needed.

Shouldn't it be changed to u64?

	David
 

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

