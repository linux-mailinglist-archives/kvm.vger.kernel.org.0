Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54117BA2F9
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 17:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbjJEPuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 11:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbjJEPtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 11:49:08 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71986A3B0
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 08:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1696518506; x=1728054506;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=NRJkIYREiRN6DDp/h9F1KVXYksGJMDPWo0HtS5yLaHc=;
  b=YfdUXY0UHhJtPcofGZTg6k77F/m1cRPn2eE1haXvFZQ9qhF8lh5JYUjz
   z07DbajyEEGneU0LEcYN34fQHCv5QZ2CQ4k1lxB35dw2KNFHan3F14rUa
   L3ZVFG6qBKeblWaknqPd5qBfCyqvlAAkGeoVT1gmUKuRmKx6fgum3i4yi
   M=;
X-IronPort-AV: E=Sophos;i="6.03,203,1694736000"; 
   d="scan'208";a="355134685"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 15:08:23 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
        by email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com (Postfix) with ESMTPS id 61E7F80581;
        Thu,  5 Oct 2023 15:08:22 +0000 (UTC)
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:2407]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.6.59:2525] with esmtp (Farcaster)
 id 77fc0a34-7c6c-4ef6-a167-0a5183ffb41d; Thu, 5 Oct 2023 15:08:21 +0000 (UTC)
X-Farcaster-Flow-ID: 77fc0a34-7c6c-4ef6-a167-0a5183ffb41d
Received: from EX19D026EUB003.ant.amazon.com (10.252.61.39) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Thu, 5 Oct 2023 15:08:20 +0000
Received: from EX19D047EUB002.ant.amazon.com (10.252.61.57) by
 EX19D026EUB003.ant.amazon.com (10.252.61.39) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Thu, 5 Oct 2023 15:08:20 +0000
Received: from EX19D047EUB002.ant.amazon.com ([fe80::a00c:a6ac:280e:2ca7]) by
 EX19D047EUB002.ant.amazon.com ([fe80::a00c:a6ac:280e:2ca7%3]) with mapi id
 15.02.1118.037; Thu, 5 Oct 2023 15:08:20 +0000
From:   "Mancini, Riccardo" <mancio@amazon.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Teragni, Matias" <mteragni@amazon.com>,
        "Batalov, Eugene" <bataloe@amazon.com>
Subject: Bug? Incompatible APF for 4.14 guest on 5.10 and later host
Thread-Topic: Bug? Incompatible APF for 4.14 guest on 5.10 and later host
Thread-Index: Adn3nVldZ3tGzH5GSXezpqAV5T2/pw==
Date:   Thu, 5 Oct 2023 15:08:20 +0000
Message-ID: <9d5ddfbe407940afa02567262a22fa4c@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.50.216]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

when a 4.14 guest runs on a 5.10 host (and later), it cannot use APF (despi=
te
CPUID advertising KVM_FEATURE_ASYNC_PF) due to the new interrupt-based
mechanism 2635b5c4a0 (KVM: x86: interrupt based APF 'page ready' event deli=
very).
Kernels after 5.9 won't satisfy the guest request to enable APF through
KVM_ASYNC_PF_ENABLED, requiring also KVM_ASYNC_PF_DELIVERY_AS_INT to be set=
.
Furthermore, the patch set seems to be dropping parts of the legacy #PF han=
dling
as well.
I consider this as a bug as it breaks APF compatibility for older guests ru=
nning
on newer kernels, by breaking the underlying ABI.
What do you think? Was this a deliberate decision?
Was this already reported in the past (I couldn't find anything in the mail=
ing list
but I might have missed it!)?
Would it be much effort to support the legacy #PF based mechanism for older
guests that choose to only set KVM_ASYNC_PF_ENABLED?

The reason this is an issue for us now is that not having APF for older gue=
sts
introduces a significant performance regression on 4.14 guests when paired =
to
uffd handling of "remote" page-faults (similar to a live migration scenario=
)
when we update from a 4.14 host kernel to a 5.10 host kernel.

Thanks,
Riccardo
