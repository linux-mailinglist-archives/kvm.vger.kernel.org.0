Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F7B630E7F
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 12:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiKSLm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 06:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiKSLm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 06:42:56 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A49970A8
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 03:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1668858176; x=1700394176;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=YcD2QFpbUfSP7m809u20APAk8iJ7h7fiGjAllgRMbZc=;
  b=VL2iRjxxCh5vlETMLDGa2h+r/krwoalDIYa43kiUXQCN35hKK7T/lXso
   rJg0fci6XIylRofQk68B2oxYtc5j0B4tJ94onS2Uo2dFY7zkM3oSL6KZx
   9lr9qAXmbkxzxXejURTzInrHLrNZLXYUtNEyjbpkgtaGGX5ZKvaqUfaH2
   c=;
X-IronPort-AV: E=Sophos;i="5.96,176,1665446400"; 
   d="scan'208";a="152589310"
Subject: RE: [PATCH 4/4] KVM: x86/xen: Add runstate tests for 32-bit mode and
 crossing page boundary
Thread-Topic: [PATCH 4/4] KVM: x86/xen: Add runstate tests for 32-bit mode and crossing
 page boundary
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2022 11:42:53 +0000
Received: from EX13D30EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com (Postfix) with ESMTPS id 493504166F;
        Sat, 19 Nov 2022 11:42:51 +0000 (UTC)
Received: from EX19D032EUC002.ant.amazon.com (10.252.61.185) by
 EX13D30EUC001.ant.amazon.com (10.43.164.171) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sat, 19 Nov 2022 11:42:50 +0000
Received: from EX19D032EUC002.ant.amazon.com (10.252.61.185) by
 EX19D032EUC002.ant.amazon.com (10.252.61.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.20; Sat, 19 Nov 2022 11:42:50 +0000
Received: from EX19D032EUC002.ant.amazon.com ([fe80::e696:121c:a227:174]) by
 EX19D032EUC002.ant.amazon.com ([fe80::e696:121c:a227:174%3]) with mapi id
 15.02.1118.020; Sat, 19 Nov 2022 11:42:50 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mhal@rbox.co" <mhal@rbox.co>
Thread-Index: AQHY+/v2ErL6DQJ4hkaWmtuTNB8Hqq5GH/0w
Date:   Sat, 19 Nov 2022 11:42:50 +0000
Message-ID: <78e8cca3acfb443c8635a5f99ab9d845@amazon.co.uk>
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-4-dwmw2@infradead.org>
In-Reply-To: <20221119094659.11868-4-dwmw2@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.51.69]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: David Woodhouse <dwmw2@infradead.org>
> Sent: 19 November 2022 09:47
> To: Paolo Bonzini <pbonzini@redhat.com>; Sean Christopherson
> <seanjc@google.com>
> Cc: kvm@vger.kernel.org; mhal@rbox.co
> Subject: [EXTERNAL] [PATCH 4/4] KVM: x86/xen: Add runstate tests for 32-
> bit mode and crossing page boundary
>=20
> CAUTION: This email originated from outside of the organization. Do not
> click links or open attachments unless you can confirm the sender and kno=
w
> the content is safe.
>=20
>=20
>=20
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> Torture test the cases where the runstate crosses a page boundary, and an=
d
> especially the case where it's configured in 32-bit mode and doesn't, but
> then switching to 64-bit mode makes it go onto the second page.
>=20
> To simplify this, make the KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST ioctl
> also update the guest runstate area. It already did so if the actual
> runstate changed, as a side-effect of kvm_xen_update_runstate(). So doing
> it in the plain adjustment case is making it more consistent, as well as
> giving us a nice way to trigger the update without actually running the
> vCPU again and changing the values.
>=20
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Reviewed-by: Paul Durrant <paul@xen.org>
