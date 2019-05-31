Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458AE3158F
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 21:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfEaToq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 15:44:46 -0400
Received: from mail-eopbgr720066.outbound.protection.outlook.com ([40.107.72.66]:51090
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727147AbfEaTop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 15:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fhf9yg12FYwPe3trfsjjhu4+MxOB+vRFhpqtdNhWi8k=;
 b=ipKZwRiUyYBdAvKtxV9TBNrqnmqAzQhF2KGzWhK8G3aNB7PD/Je1lEFQIwvXEeeKuRqSBawmyjVQWTRWu4a5mWLnOJEvyW+FLCYF+pH0/gM2oij6T33gSEcRt+MNkid9t4ph1bQY1TunTAYKDiY9CD6nXZdu8sAxm7YRyRc30Q8=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB6694.namprd05.prod.outlook.com (20.178.235.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.13; Fri, 31 May 2019 19:44:41 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::2cb6:a3d1:f675:ced8]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::2cb6:a3d1:f675:ced8%3]) with mapi id 15.20.1943.016; Fri, 31 May 2019
 19:44:41 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Juergen Gross <jgross@suse.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [RFC PATCH v2 04/12] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Thread-Topic: [RFC PATCH v2 04/12] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Thread-Index: AQHVF3tF8UKMn76vfUO/W6G8mcgAUaaFHqkAgACE8gA=
Date:   Fri, 31 May 2019 19:44:41 +0000
Message-ID: <1DEA29A7-D033-4816-876C-05E7D77F0437@vmware.com>
References: <20190531063645.4697-1-namit@vmware.com>
 <20190531063645.4697-5-namit@vmware.com>
 <a847ee9c-4faf-c8b4-43bb-cc30e0980796@suse.com>
In-Reply-To: <a847ee9c-4faf-c8b4-43bb-cc30e0980796@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ff6d24d-760f-4cf1-93a5-08d6e6006cb9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR05MB6694;
x-ms-traffictypediagnostic: BYAPR05MB6694:
x-microsoft-antispam-prvs: <BYAPR05MB6694A02D23273C4945DC9657D0190@BYAPR05MB6694.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(39860400002)(376002)(199004)(189003)(5660300002)(6246003)(33656002)(66946007)(4744005)(99286004)(25786009)(54906003)(316002)(2906002)(66476007)(64756008)(66446008)(76116006)(73956011)(68736007)(66556008)(4326008)(7416002)(476003)(66066001)(229853002)(8936002)(14454004)(6512007)(6506007)(2616005)(8676002)(53546011)(446003)(76176011)(11346002)(486006)(81156014)(82746002)(305945005)(6436002)(186003)(6116002)(3846002)(71190400001)(26005)(71200400001)(6916009)(256004)(83716004)(6486002)(81166006)(7736002)(102836004)(478600001)(53936002)(86362001)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB6694;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8vzZaIBhzD6qajL16JVgIzMw6d4O8dWiIxREAOQKbgqx7lEuupRTbVsCWDWGr93Cy3VSBBjH9syRZNtEOL2Zn3yu900mPiwa0bKgWpELQ92Kgd+f+yFap9jSai30Wt6Rrty57+qNsl1IxGpoSlhyf2+xWjes0o+DnUjIaSZ98myWf1POpTCv7F33sZvFvqqdwRs0v7NUGH4nU5wNF3zlFeLEkI6JZazDoVWpK8Nue3QyZSGFKToCmGgBGgJCd23hd5SE1uycaK+bcxzgfV7IKBe3+pEjxkkzXyZGsVlqdwMnDt6WsLZhRG0ykA2UQBHZ2hbrzyyPJNDOstW+Ts7fvhlKEIrwSC0yzt47CNLxFXisPrf0Sw1xRTXcchSxXACzzDoEiPd97LOyc/Ym/LvwpxmDnM3oKBVb5zbXtveRK2I=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <498DEB6111D0B64C9D5657F78CFDD0EF@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ff6d24d-760f-4cf1-93a5-08d6e6006cb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 19:44:41.6564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6694
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 31, 2019, at 4:48 AM, Juergen Gross <jgross@suse.com> wrote:
>=20
> On 31/05/2019 08:36, Nadav Amit wrote:
>>=20
>> --- a/arch/x86/include/asm/paravirt_types.h
>> +++ b/arch/x86/include/asm/paravirt_types.h
>> @@ -211,6 +211,12 @@ struct pv_mmu_ops {
>> 	void (*flush_tlb_user)(void);
>> 	void (*flush_tlb_kernel)(void);
>> 	void (*flush_tlb_one_user)(unsigned long addr);
>> +	/*
>> +	 * flush_tlb_multi() is the preferred interface. When it is used,
>> +	 * flush_tlb_others() should return false.
>=20
> Didn't you want to remove/change this comment?

Yes! Sorry for that. Fixed now.
