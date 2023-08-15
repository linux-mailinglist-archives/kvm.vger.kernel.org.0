Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3133077CF0C
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbjHOPYU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 15 Aug 2023 11:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236518AbjHOPX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:23:57 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6645E9C
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 08:23:56 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-47-n93EMhJ-NZikTdM6_6FSgA-1; Tue, 15 Aug 2023 16:23:54 +0100
X-MC-Unique: n93EMhJ-NZikTdM6_6FSgA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 15 Aug
 2023 16:23:51 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Tue, 15 Aug 2023 16:23:51 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stefan Hajnoczi' <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alex Williamson" <alex.williamson@redhat.com>
Subject: RE: [PATCH 2/4] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Thread-Topic: [PATCH 2/4] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Thread-Index: AQHZywUc1n/Y7EJLKUyoxnVRLesskK/rgeRQ
Date:   Tue, 15 Aug 2023 15:23:50 +0000
Message-ID: <aff0d24d4bce4d34b27cfe6a76b0634e@AcuMS.aculab.com>
References: <20230809210248.2898981-1-stefanha@redhat.com>
 <20230809210248.2898981-3-stefanha@redhat.com>
In-Reply-To: <20230809210248.2898981-3-stefanha@redhat.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Stefan Hajnoczi
> Sent: 09 August 2023 22:03
> 
> The memory layout of struct vfio_device_gfx_plane_info is
> architecture-dependent due to a u64 field and a struct size that is not
> a multiple of 8 bytes:
> - On x86_64 the struct size is padded to a multiple of 8 bytes.
> - On x32 the struct size is only a multiple of 4 bytes, not 8.
> - Other architectures may vary.
> 
> Use __aligned_u64 to make memory layout consistent. This reduces the
> chance of holes that result in an information leak and the chance that
> 32-bit userspace on a 64-bit kernel breakage.

Isn't the hole likely to cause an information leak?
Forcing it to be there doesn't make any difference.
I'd add an explicit pad as well.

It is a shame there isn't an __attribute__(()) to error padded structures.

> 
> This patch increases the struct size on x32 but this is safe because of
> the struct's argsz field. The kernel may grow the struct as long as it
> still supports smaller argsz values from userspace (e.g. applications
> compiled against older kernel headers).

Doesn't changing the offset of later fields break compatibility?
The size field (probably) only lets you extend the structure.

Oh, for sanity do min(variable, constant).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

