Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02BAD560D3
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 05:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfFZDsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 23:48:54 -0400
Received: from mail-eopbgr680052.outbound.protection.outlook.com ([40.107.68.52]:63875
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfFZDsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 23:48:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MipVIl/vK4jT6xfDxXZnl22+gCgO6Ner30cT/dH+FYA=;
 b=XC+xHE8mDv2cKU9kwuQMb6VQg0eKbWnjkIk5SsfB0kSFU6ULjTRlUEqFWgmQz7a3Q9kmvR/84s4vmm/7KHXrf1VEfLvCmLPxwYjh6pwTI5XdghYKz6BtechdSpjdRTe4tw0uOepeVhFRAbM9c820ZvwzV2NyforHfSAJ8DOR4Yg=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB4918.namprd05.prod.outlook.com (52.135.235.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Wed, 26 Jun 2019 03:48:49 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58%7]) with mapi id 15.20.2008.007; Wed, 26 Jun 2019
 03:48:49 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH 4/9] x86/mm/tlb: Flush remote and local TLBs concurrently
Thread-Topic: [PATCH 4/9] x86/mm/tlb: Flush remote and local TLBs concurrently
Thread-Index: AQHVIbQneqvfvnASJUSZoJZyXs9UlaatXWmAgAADTQA=
Date:   Wed, 26 Jun 2019 03:48:49 +0000
Message-ID: <28C3D489-54E4-4670-B726-21B09FA469EE@vmware.com>
References: <20190613064813.8102-1-namit@vmware.com>
 <20190613064813.8102-5-namit@vmware.com>
 <CALCETrXyJ8y7PSqf+RmGKjM4VSLXmNEGi6K=Jzw4jmckRQECTg@mail.gmail.com>
In-Reply-To: <CALCETrXyJ8y7PSqf+RmGKjM4VSLXmNEGi6K=Jzw4jmckRQECTg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [204.134.128.110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb2700b8-7c95-44a7-7ea3-08d6f9e932f9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR05MB4918;
x-ms-traffictypediagnostic: BYAPR05MB4918:
x-microsoft-antispam-prvs: <BYAPR05MB4918241570189A72A62A0AD6D0E20@BYAPR05MB4918.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(346002)(136003)(376002)(199004)(189003)(76116006)(102836004)(33656002)(91956017)(81156014)(76176011)(446003)(2616005)(316002)(11346002)(6486002)(73956011)(7736002)(6116002)(6916009)(36756003)(229853002)(54906003)(305945005)(66066001)(81166006)(66556008)(6506007)(8936002)(14454004)(7416002)(476003)(256004)(86362001)(4326008)(2906002)(53546011)(64756008)(6512007)(8676002)(26005)(6436002)(6246003)(4744005)(66946007)(71190400001)(66446008)(53936002)(186003)(25786009)(486006)(68736007)(478600001)(66476007)(71200400001)(3846002)(99286004)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4918;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: my4KTkN3aqGXmWhsjfVVxjr2Sm5jxWwCaMIuqKK1SsSqfx8cHPx4n7R/9FEhekYtgpGmPoA2h6nrHG+Rz9L+JQsOqVLuwNvdEQaMWrCZP5qmj2mkG2t8zspoeNUHe6nCs4Y376EXS5L+59rbBaGcI7/Uh5HlOSRZEGrZdEiUA+DWcY+l2XlRv9JlVTF/g2eykA/66MtRJsOCSLrhfyecmaFOXkw9qYctXE2l1tb4y03sQ948HXUHOY4Sm2rNKOqk6IcdUuaYwgu2eYDCUjv3QsrQk85ptyza2hGIyDPYsJNr/D2fB3z+zk1AWlB0T9oDTOsQLCVM30dXJaJTr6JzyyuaVbSXADluDzrGIjHaSB+X+uG1sYe+/Oz6VFJpDdB7qrQQOhC59RFt//fXiwkrodWD5nTlq09DMzrcv+Fmdyo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E62AD8D44ED93F48AE881F9F9D2418DD@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb2700b8-7c95-44a7-7ea3-08d6f9e932f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 03:48:49.6652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4918
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 25, 2019, at 8:36 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Wed, Jun 12, 2019 at 11:49 PM Nadav Amit <namit@vmware.com> wrote:
>> To improve TLB shootdown performance, flush the remote and local TLBs
>> concurrently. Introduce flush_tlb_multi() that does so. The current
>> flush_tlb_others() interface is kept, since paravirtual interfaces need
>> to be adapted first before it can be removed. This is left for future
>> work. In such PV environments, TLB flushes are not performed, at this
>> time, concurrently.
>=20
> Would it be straightforward to have a default PV flush_tlb_multi()
> that uses flush_tlb_others() under the hood?

I prefer not to have a default PV implementation that should anyhow go away=
.

I can create unoptimized untested versions for Xen and Hyper-V, if you want=
.

