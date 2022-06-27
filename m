Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518F455DC11
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbiF0P1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 11:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238076AbiF0P1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 11:27:45 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C482B18E2D;
        Mon, 27 Jun 2022 08:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1656343663; x=1687879663;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=YEgapIC6vw4gM3xTcvv8zbRwoB5EdirAlDgdpfFvDmI=;
  b=HWYTG1vAw/a/bCVys46MZt4O6f8JZZ+GB+GZKhEyjKqKqD426hp6pPNO
   PyGs21h3uZ2lZI88AiJ6EuBAvgEf9l9hgZQH0Xok9cSAc9qdyyyyMM6XA
   PPFk1NA7Ghgv8Uav1vGxqAHo1zvk7d1YE+kFM/BT4fV3tVY0DYupT2g8e
   M=;
X-IronPort-AV: E=Sophos;i="5.92,226,1650931200"; 
   d="scan'208";a="1028517709"
Subject: RE: [PATCH v4] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Thread-Topic: [PATCH v4] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-c275e159.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 27 Jun 2022 15:23:55 +0000
Received: from EX13D32EUC004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-c275e159.us-west-2.amazon.com (Postfix) with ESMTPS id 6A41C814F0;
        Mon, 27 Jun 2022 15:23:55 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC004.ant.amazon.com (10.43.164.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 15:23:54 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.036;
 Mon, 27 Jun 2022 15:23:54 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     Sean Christopherson <seanjc@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Thread-Index: AQHYhkt9PlSgQj3r2kG3c5Kzi5Ybkq1jZe+AgAAAylA=
Date:   Mon, 27 Jun 2022 15:23:54 +0000
Message-ID: <91a4b01e8d9b4b3c9ed43614810e75ce@EX13D32EUC003.ant.amazon.com>
References: <20220622151728.13622-1-pdurrant@amazon.com>
 <YrnKc6RoqDM/At3T@google.com>
In-Reply-To: <YrnKc6RoqDM/At3T@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.192]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-12.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: 27 June 2022 16:19
> To: Durrant, Paul <pdurrant@amazon.co.uk>
> Cc: x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Da=
vid Woodhouse
> <dwmw2@infradead.org>; Paolo Bonzini <pbonzini@redhat.com>; Vitaly Kuznet=
sov <vkuznets@redhat.com>;
> Wanpeng Li <wanpengli@tencent.com>; Jim Mattson <jmattson@google.com>; Jo=
erg Roedel <joro@8bytes.org>;
> Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Bor=
islav Petkov <bp@alien8.de>;
> Dave Hansen <dave.hansen@linux.intel.com>; H. Peter Anvin <hpa@zytor.com>
> Subject: RE: [EXTERNAL][PATCH v4] KVM: x86/xen: Update Xen CPUID Leaf 4 (=
tsc info) sub-leaves, if
> present
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open
> attachments unless you can confirm the sender and know the content is saf=
e.
>=20
>=20
>=20
> On Wed, Jun 22, 2022, Paul Durrant wrote:
> > The scaling information in subleaf 1 should match the values set by KVM=
 in
> > the 'vcpu_info' sub-structure 'time_info' (a.k.a. pvclock_vcpu_time_inf=
o)
> > which is shared with the guest, but is not directly available to the VM=
M.
> > The offset values are not set since a TSC offset is already applied.
> > The TSC frequency should also be set in sub-leaf 2.
> >
> > Cache pointers to the sub-leaves when CPUID is updated by the VMM and
> > populate the relevant information prior to entering the guest.
>=20
> All of my comments about the code still apply.
>=20
> https://lore.kernel.org/all/YrMqtHzNSean+qkh@google.com
>=20

Apologies. Not sure how I missed them; I'll send a response shortly.

> > Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> > ---
> > Cc: David Woodhouse <dwmw2@infradead.org>
>=20
> Cc: can go in the changelog, it's helpful info to carry with the commit a=
s it
> documents who was made aware of the patch, e.g. show who may have had a c=
ance to
> object/review.
>=20
> >
> > v2:
> >  - Make sure sub-leaf pointers are NULLed if the time leaf is removed
> >
> > v3:
> >  - Add leaf limit check in kvm_xen_set_cpuid()
> >
> > v4:
> >  - Update commit comment
>=20
> Please start with the most recent verison and work backardwards, that way=
 reviewers
> can quickly see the delta for _this_ version.  I.e.
>=20
>=20
> v4:
>=20
> v3:
>=20
> v2:
>=20
> v1:

Ok.

  Paul

