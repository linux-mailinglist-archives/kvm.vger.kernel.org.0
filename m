Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF636BD9C2
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 21:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjCPUC5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 Mar 2023 16:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCPUCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 16:02:54 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EEBE6DB2;
        Thu, 16 Mar 2023 13:02:29 -0700 (PDT)
Received: from lhrpeml500002.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PcylF2PMlz6J9fJ;
        Fri, 17 Mar 2023 03:59:21 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500002.china.huawei.com (7.191.160.78) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 20:02:27 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.021;
 Thu, 16 Mar 2023 20:02:27 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "maz@kernel.org" <maz@kernel.org>
Subject: RE: [PATCH] KVM: Add the missing stub function for
 kvm_dirty_ring_check_request()
Thread-Topic: [PATCH] KVM: Add the missing stub function for
 kvm_dirty_ring_check_request()
Thread-Index: AQHZWB65hkIreZwmx0eOO2ggOjI5jq79oegAgAArQ8CAAAWkAIAAACPw
Date:   Thu, 16 Mar 2023 20:02:26 +0000
Message-ID: <a026b6ddf62843129193842d80edd182@huawei.com>
References: <20230316154554.1237-1-shameerali.kolothum.thodi@huawei.com>
 <ZBNLnp7c1JvDsmHm@google.com> <6b9e8589281c4d2bae46eba36f77afe7@huawei.com>
 <ZBN0pFN/nF8G3fWl@google.com>
In-Reply-To: <ZBN0pFN/nF8G3fWl@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.195.246.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson [mailto:seanjc@google.com]
> Sent: 16 March 2023 19:57
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; gshan@redhat.com;
> maz@kernel.org
> Subject: Re: [PATCH] KVM: Add the missing stub function for
> kvm_dirty_ring_check_request()
> 
> On Thu, Mar 16, 2023, Shameerali Kolothum Thodi wrote:
> > > From: Sean Christopherson [mailto:seanjc@google.com] On Thu, Mar 16,
> > > 2023, Shameer Kolothum wrote:
> > > > The stub for !CONFIG_HAVE_KVM_DIRTY_RING case is missing.
> > >
> > > No stub is needed.  kvm_dirty_ring_check_request() isn't called from
> > > common code, and should not (and isn't unless I'm missing something)
> > > be called from arch code unless CONFIG_HAVE_KVM_DIRTY_RING=y.
> > >
> > > x86 and arm64 are the only users, and they both select
> > > HAVE_KVM_DIRTY_RING unconditionally when KVM is enabled.
> >
> > Yes, it is at present not called from anywhere other than x86 and arm64.
> > But I still think since it is a common helper, better to have a stub.
> 
> Why?  It buys us nothing other than dead code, and even worse it could let
> a bug that would otherwise be caught during build time escape to run time.

Agree, it buys nothing now:) It just came up while I was playing with a custom
build without HAVE_KVM_DIRTY_RING. Since all other functions there has a stub
just thought it would make it easier for future common usage. We could very well
leave it till that comes up as well.

Thanks,
Shameer
