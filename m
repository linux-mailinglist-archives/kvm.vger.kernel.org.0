Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5304E5FA0C8
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 16:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiJJO6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 10:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiJJO6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 10:58:18 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11013000.outbound.protection.outlook.com [52.101.64.0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A2227CC5;
        Mon, 10 Oct 2022 07:58:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYj8IVbHL5TeLctsE7SNniC4FhYikkGDfbW0Rh/bWGfKp+dVSpMubwdf74yA6joIBSfDPNAaeKHB41UwmZSVt5h0p3JLVNBFWA9J2I97sR4pFQaUvDEjhzbc0T7nah5yd/6d/rZrqSv1JzFnTZKcc0UJPkVfp9CecYEpPXLz8//pAsyx2JDS0av94+AARXsuufWD/Tzdqb2u3rgTduatjT6CUQEh7C1NH+BOaquia6E5zf6daF0sSoqnL3scA1FeUFNy4Pgq0X2Lsb0mrEdBQRMgwQVMqGSveSmSTPdIuIe61D9e+3ZeFC18Ql2cbUCJPIP7aOvhZzsf4WMBoiHB9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYO8dCN0RAPjyyKUKeDabhUwzPIiWj1zLa9O3qPgnss=;
 b=hFmw2HbN2k2RgzviO6NuWIEeKI6tgcPwGAEySt3FAGZlD+HMdz/kFaUKQWX4IJX/UnUkMo8hOHpRNdJUHahnbNnS65znKX706RZgW4Ejv0sVsfywzk4sIWxjJS949KmjE2uSNI05dkL79m1o5BI5sOoTgSoV5+HfO1/v2abSXa2YFIvK2ah63AKfYThL5GQMYylFLk7AmvFx41nAlC+41DRl7QA/BUJK3kqcPKUEpaWsrmXdD2lPijeaLfNkINGBDUZblEnuw5avgI21qPcgvOirFb0kP5GfLkHLl+Ukq9o8lNc28GsiGX8QfrF6mMSqLYAS6tMk8iBVVPqHV0M9zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYO8dCN0RAPjyyKUKeDabhUwzPIiWj1zLa9O3qPgnss=;
 b=kKhFXmsgMoN4bD3ECeDgjXdJeFROVkSqpwQO96Y5dtj4F/794y7qnh+aDGwdcGfNOFn9s2KBukH+P7DQPbyuLkNSspikuxUfd37g+Ss0t+aFXcZ43bGiP1x9O/LzzeFYObQj16EmVxXL16NJRFHiNAv4GrISbJ5Ay7vyUCw3uWs=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by MN2PR05MB6269.namprd05.prod.outlook.com (2603:10b6:208:cd::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.7; Mon, 10 Oct
 2022 14:58:07 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6%7]) with mapi id 15.20.5723.013; Mon, 10 Oct 2022
 14:58:07 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Nadav Amit <namit@vmware.com>
CC:     Alexander Graf <graf@amazon.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ajay Kaher <akaher@vmware.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        "er.ajay.kaher@gmail.com" <er.ajay.kaher@gmail.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jailhouse-dev@googlegroups.com" <jailhouse-dev@googlegroups.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Topic: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Index: AQHYx28G+J2WSwxm3kmFzqoOhSDYUK3dXFQAgBj77YCABouGgIAAKhGAgAD4GgCAAK7iAIAJLbYA
Date:   Mon, 10 Oct 2022 14:58:07 +0000
Message-ID: <37B773B8-A918-45E8-9642-9F6112CDCBB6@vmware.com>
References: <9FEC6622-780D-41E6-B7CA-8D39EDB2C093@vmware.com>
 <87zgf3pfd1.fsf@redhat.com> <B64FD502-E794-4E94-A267-D690476C57EE@vmware.com>
 <87tu4l9cfm.fsf@redhat.com> <04F550C5-786A-4B8E-9A88-EBFBD8872F16@vmware.com>
 <f1a7e603-2e64-fd2a-1100-f2898060e3f7@amazon.com>
 <DF8775A4-5332-412C-9359-749E96E83907@vmware.com>
In-Reply-To: <DF8775A4-5332-412C-9359-749E96E83907@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|MN2PR05MB6269:EE_
x-ms-office365-filtering-correlation-id: 69df7bd8-e1bb-47a0-8da2-08daaacfd759
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3ndTD+kWc7Des/PCBwoe6WcHAIvzmJxk31e4vq8i/2to+pJZkz6An7DBSzBE20ofdGn3MEHsGiyOG9tLA+rVv1oZt+GRNHXBSL3pafvfP+6zY7bxBmE+DxxRLBgd9/leF/ExseJuB8g+ZNm+xCEFHvTKg9pLavn45NAth6JngtYblEsNaME7JDmbzm6sZejjFAPIBoxtUxIghRj2CtySG0w6Srd+h6RB8X9NeSVeqTKofwFbGckOkchJkQWMj5vkAsDpbgWFdnhK2pWTtCdP4V4/TVmgIAiyK2VVkZp6Y3znqHsVvhAhKFrc2Bl2pES/0FzWyveObNE6YSGRUIrC6e/RJLmskGBWjy4LBmibPxmv/yXd3r1hAfUNGnQJBTIPYlqY/Q+J6lRWQbjGaijmfKRX0yHCf7w/ZJt2D4Y8EBS2S3px655MbNz87Yl7U3GfyDRl4vnVyH1qLaHL3pDaph3ZZEyaVT5ioo+a8HhbkgutP3qEb/0G2N50kpXkYMucSHOq7MNi9UXL8oouvaDHJh4IxhGIarIPR6+6lCVHpDqmMy12dHa1WD1IlyP5dCRKbh1XgBKLBofxay9KuP5Fxq29AMubo+mF0QIRKfts4BXj6OHJeg/txs+bcg0xLHcGiROGIsPPd3X6LLOy+ABq8jrsavHJ7QIv6kWJKiCrYLaQhbLHCOnNrqL94BsThR9zKBzJVaOQ7yZe8EBpvHRkpEkRu/p+2b4ZNUIzzqBzy9uuOjmZpSI8HfdinzFCwFj88YM/vmw6UTpP2arHmKjv55hE7S3gz939mIAdzdPvtBY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(451199015)(4326008)(8676002)(76116006)(66556008)(7416002)(66446008)(66476007)(8936002)(38070700005)(6512007)(26005)(66946007)(83380400001)(6506007)(86362001)(64756008)(54906003)(5660300002)(33656002)(41300700001)(6486002)(2906002)(122000001)(36756003)(6862004)(6200100001)(37006003)(478600001)(38100700002)(71200400001)(316002)(53546011)(186003)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTJoNWcycWlRRSs0UzFML0kzaENSTjFPWC8wSnNYR2F2amF6bEx3M1N1eDFU?=
 =?utf-8?B?aTZqWEFSTVAxT0N5ZEp6WWpyNVlZQllwbGt6YVpLcHZIdlZkMloyMTFmM0FO?=
 =?utf-8?B?bkZtT2t6SlBadlgrRDBzU3NoUnh0MkI2RWpmNFFpS0MvMXZGSjhzblZ5Tnp2?=
 =?utf-8?B?a3F2THhycEloeVhveHRqdVowWmFmSlp2a1VZTkdyZWxCTmUrQm5NUmlIdTVN?=
 =?utf-8?B?ZVZEdm01azVlMjJqb0VCUGNtRTB3bGx2UDJ2TjR3eU42enJxejlkWkF5U2ZI?=
 =?utf-8?B?Q2JRQU8wYmY0Nkh1dGNyT0RudGg3bStnU0xYTWIrTkVLVE00dXJSdmtUMnpG?=
 =?utf-8?B?dFdMTVBmN1pVUmhlbW5NNWV3OFd1UzR6N2FKdW41bXZhd1VPOXdBN21uYXRY?=
 =?utf-8?B?RytNbmNxbjB6SU0xWW1FNFhyLy9QK251MXNZZ0piMFNyamxkRHVzREVIUHRu?=
 =?utf-8?B?RlA5TkV6aFlNY3VwZFE0MXRqa0NlM2JiUDYvV2VDenY4VHNldG1JVTNGNGly?=
 =?utf-8?B?U2dVRTZiTDl6ZHExeTFOOUFIRTFtbFZ3RkswVG84YVZ5VXhGbktqL3dKV21N?=
 =?utf-8?B?L2pyVjhZYlFOYmNsVnJyZGJTMmRzLzdkOHJQbUNkUTBRR09rZHdJUm1DZ0Qz?=
 =?utf-8?B?cGh1ckx2b3pSK0V1M090bEI5R1lkVk5EeSsvNU93dnZBLzN4MjFKUWU4akJm?=
 =?utf-8?B?SHJlZlZQTEt6b0dLSmluUEZBRUNmdmRoK211ZkFpemQyY1pCMDVlR3dhcGlS?=
 =?utf-8?B?ZGh6M3pTUVlvczVmaFQyWmQ1eGZITjRkZWxJbnNrOFY3WkxnVkRmMmQ4cVAv?=
 =?utf-8?B?Wk4wWDBJQ1BYZ3NzVVZCT1FNU2RPbmgyQ2hCUkZzcVEyZlFNclFlSkNoYjVB?=
 =?utf-8?B?UVA4dEs1NHlDYWxQUkZNSDNIcU5DdFZ6bzBHRTBRb3JlZG02cnF0R2Q1N1pS?=
 =?utf-8?B?d0NSNEV5TURHNDNrWTFQVkg0N2puVWppVmNMcVFGRFU4djdrQVNYNTRuMU55?=
 =?utf-8?B?eWNRZjZ3NXlHalJBUndtd0Jnckk0VVhmOHgveEdmSXVxdUxVckFoYXpDcys3?=
 =?utf-8?B?T1J0Z05OSHRDako3MlhZRHNISFB1dTJ3UlQrN1RKS0VqajZ3OE9nSmpwZVNE?=
 =?utf-8?B?TEN3aVFScWxqakUrV1BIR1FCa3ByakExQ2owWk1nYzBTMWFBb2tpS1BQSEVN?=
 =?utf-8?B?YzZnd1VkV213QVdxcFJ6SGhoUWVjZHNqR2RVQ2hTNENmL3RKRGgyN3hGbm12?=
 =?utf-8?B?RFR4TjhleWpiSkRZd0Y3TENTWHl4SVNTamttSC9tVVIxdGFYZkNReDRldVVt?=
 =?utf-8?B?Wnh2WUtBd0hydmJKQ0I0WHd3NDdBd3hVQTBDMzg2RURlbTRON2twdGUvNEVu?=
 =?utf-8?B?TVZ6cjJPa0c1QlhIK3JTZnZKM0FrSVF2QlVkZHljdXppdytwNVJQc2ZldEd1?=
 =?utf-8?B?dU9Cemk3MlhoZnpPRm42ZWxOZlFLbFQra3hZRzN3aUNiZ1FVNEVuTjZldHNm?=
 =?utf-8?B?NlBtVFN6amY3alVtNkh1RFE0N0lZNGhUeEkxVVc3L2RqcTRKaFo4NXkyVzJj?=
 =?utf-8?B?K1pSL3UzcjJMa0hyUUw1eStrdko2WThZaExyUy9OckNrM0lWUTQ2bmpmNmlD?=
 =?utf-8?B?ZnRGZHNFMk54cnQ3ZG9Ma0I4SXllL3RodFdPMzh2d0VzVTEyMkFka3YxcnRw?=
 =?utf-8?B?ODdFU3RYM0MxZkxJeWJwSGp0bzZJM29YL2p6WjU2NVQzYTFjMCtCejd5RjFX?=
 =?utf-8?B?aXI0SktsQWVPYTQzVWFYc0VhbERxaUE0ZGxuSUR3OGFoRE4xVUVLTy8wTUhV?=
 =?utf-8?B?OHV5cytod3VBN2JVREd6QlZsZUFYRWxydHA3alh5dEYyMFhnR2t1YzVUVDQ0?=
 =?utf-8?B?bW1rajdrRnc5RTNJR3pYZjhVUGw2aC93OGJXSlBYb2JSREM5Rkg4dnh2eXZp?=
 =?utf-8?B?SWZKazF2VlNhaHQzY3VDemRkMXkwQWJGcDNVY2ZScTNJc1RmNHJ1cEdXRjIz?=
 =?utf-8?B?MCtMN0F0VzlOSlBMeU1RV2cxbTljNndiWEF1cmtFQUZEQlJOYjA3RUYwQkVD?=
 =?utf-8?B?aU1mbGYrN1hQcXE0QVNXTTNxTDlVV3VSVGQ2ZnlkdmJIOGtzd2oxeUw1SWV4?=
 =?utf-8?Q?quyg3M4cBRrnLa5sMOx3o+wqU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9C3B43181985F4F97F91A814A79A6C1@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69df7bd8-e1bb-47a0-8da2-08daaacfd759
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 14:58:07.3956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xGHU5bIcBDSFl8n5qpOcg5QjgLSkBqoIyZVxUwqwYTGbkWdZeTV3Ie/t33RGlF1rfww1qFYruaX4UR5W2+SFBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6269
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gT2N0IDQsIDIwMjIsIGF0IDExOjQ4IEFNLCBOYWRhdiBBbWl0IDxuYW1pdEB2bXdhcmUuY29t
PiB3cm90ZToNCg0KPiBPbiBPY3QgNCwgMjAyMiwgYXQgMToyMiBBTSwgQWxleGFuZGVyIEdyYWYg
PGdyYWZAYW1hem9uLmNvbT4gd3JvdGU6DQo+IA0KPj4g4pqgIEV4dGVybmFsIEVtYWlsDQo+PiAN
Cj4+IEhleSBOYWRhdiwNCj4+IA0KPj4gT24gMDMuMTAuMjIgMTk6MzQsIE5hZGF2IEFtaXQgd3Jv
dGU6DQo+Pj4gT24gT2N0IDMsIDIwMjIsIGF0IDg6MDMgQU0sIFZpdGFseSBLdXpuZXRzb3YgPHZr
dXpuZXRzQHJlZGhhdC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+PiBOb3QgbXkgYnV0IHJhdGhlciBQ
Q0kgbWFpbnRhaW5lcidzIGNhbGwgYnV0IElNSE8gZHJvcHBpbmcgJ2NvbnN0JyBpcw0KPj4+PiBi
ZXR0ZXIsIGludHJvZHVjaW5nIGEgbmV3IGdsb2JhbCB2YXIgaXMgb3VyICdsYXN0IHJlc29ydCcg
YW5kIHNob3VsZCBiZQ0KPj4+PiBhdm9pZGVkIHdoZW5ldmVyIHBvc3NpYmxlLiBBbHRlcm5hdGl2
ZWx5LCB5b3UgY2FuIGFkZCBhDQo+Pj4+IHJhd19wY2lfZXh0X29wc19wcmVmZXJyZWQoKSBmdW5j
dGlvbiBjaGVja2luZyBzb21ldGhpbiB3aXRoaW4gJ3N0cnVjdA0KPj4+PiBoeXBlcnZpc29yX3g4
NicgYnV0IEknbSB1bnN1cmUgaWYgaXQncyBiZXR0ZXIuDQo+Pj4+IA0KPj4+PiBBbHNvLCBwbGVh
c2UgY2hlY2sgQWxleCcgcXVlc3Rpb24vc3VnZ2VzdGlvbi4NCj4+PiBIZXJlIGlzIG15IHRha2Ug
KGFuZCBBamF5IGtub3dzIHByb2JhYmx5IG1vcmUgdGhhbiBtZSk6DQo+Pj4gDQo+Pj4gTG9va2lu
ZyBicmllZmx5IG9uIE1DRkcsIEkgZG8gbm90IHNlZSBhIGNsZWFuIHdheSBvZiB1c2luZyB0aGUg
QUNQSSB0YWJsZS4NCj4+PiBUaGUgdHdvIG9wdGlvbnMgYXJlIGVpdGhlciB0byB1c2UgYSByZXNl
cnZlZCBmaWVsZCAod2hpY2ggd2hvIGtub3dzLCBtaWdodA0KPj4+IGJlIHVzZWQgb25lIGRheSkg
b3Igc29tZSBPRU0gSUQuIEkgYW0gYWxzbyBub3QgZmFtaWxpYXIgd2l0aA0KPj4+IFBDSV9DT01N
QU5ELk1FTU9SWT0wLCBzbyBBamF5IGNhbiBob3BlZnVsbHkgZ2l2ZSBzb21lIGFuc3dlciBhYm91
dCB0aGF0Lg0KPj4+IA0KPj4+IEFueWhvdywgSSB1bmRlcnN0YW5kIChhbHRob3VnaCBub3QgcmVs
YXRlKSB0byB0aGUgb2JqZWN0aW9uIGZvciBhIG5ldyBnbG9iYWwNCj4+PiB2YXJpYWJsZS4gSG93
IGFib3V0IGV4cGxpY2l0bHkgY2FsbGluZyB0aGlzIGhhcmR3YXJlIGJ1ZyBhIOKAnGJ1Z+KAnSBh
bmQgdXNpbmcNCj4+PiB0aGUgcHJvcGVyIGluZnJhc3RydWN0dXJlPyBDYWxsaW5nIGl0IGV4cGxp
Y2l0bHkgYSBidWcgbWF5IGV2ZW4gcHVzaCB3aG9ldmVyDQo+Pj4gY2FuIHRvIHJlc29sdmUgaXQu
DQo+PiANCj4+IA0KPj4gSSBhbSBhIGxvdCBtb3JlIGNvbmNlcm5lZCB3aXRoIGhvdyB3ZSBwcm9w
YWdhdGUgaXQgZXh0ZXJuYWxseSB0aGFuDQo+PiB3aXRoaW4gTGludXguIElmIHdlIGhhcmQgY29k
ZSB0aGF0IGFsbCBMaW51eCBrZXJuZWxzIDYuMisgdGhhdCBhcmUNCj4+IHJ1bm5pbmcgaW4gVk13
YXJlIHByZWZlciBFQ0FNIG92ZXIgUElPLCB3ZSBsb2NrIG91cnNlbHZlcyBpbnRvIHRoYXQNCj4+
IHN0YW5jZSBmb3IgYmV0dGVyIG9yIHdvcnNlLCB3aGljaCBtZWFuczoNCj4+IA0KPj4gKiBBbGwg
cGFzdCBhbmQgZnV0dXJlIHZlcnNpb25zIG9mIGFueSBWTXdhcmUgaHlwZXJ2aXNvciBwcm9kdWN0
IGhhdmUgdG8NCj4+IGFsd2F5cyBhbGxvdyBFQ0FNIGFjY2VzcyBmb3IgYW55IFBDSWUgY29uZmln
IHNwYWNlIHdyaXRlDQo+PiAqIE5vIG90aGVyIGh5cGVydmlzb3IgYmVuZWZpdHMgZnJvbSBhbnkg
b2YgdGhpcyB3aXRob3V0IHVwc3RyZWFtIGNvZGUgY2hhbmdlDQo+PiAqIE5vIHJlYWwgaGFyZHdh
cmUgcGxhdGZvcm0gYmVuZWZpdHMgZnJvbSB0aGlzIHdpdGhvdXQgdXBzdHJlYW0gY29kZSBjaGFu
Z2UNCj4+IA0KPj4gQnkgbW92aW5nIGl0IGludG8gTUNGRywgd2UgY2FuIGNyZWF0ZSBhIHBhdGgg
Zm9yIHRoZSBvdXRzaWRlIGVudmlyb25tZW50DQo+PiB0byB0ZWxsIHRoZSBPUyB3aGV0aGVyIGl0
J3Mgc2FmZSB0byB1c2UgRUNBTSBhbHdheXMuIFRoaXMgb2J2aW91c2x5DQo+PiBkb2Vzbid0IHdv
cmsgd2l0aCBNQ0ZHIGFzIGl0IHN0YW5kcyB0b2RheSwgd2UnZCBoYXZlIHRvIHByb3Bvc2UgYW4g
TUNGRw0KPj4gc3BlYyBjaGFuZ2UgdG8gdGhlIFBDSSBTSUcncyAiUENJIEZpcm13YXJlIFNwZWNp
ZmljYXRpb24iIHRvIGFkZCB0aGUNCj4+IHJlc3BlY3RpdmUgZmllbGQuIEZ1dHVyZSBWTXdhcmUg
dmVyc2lvbnMgY291bGQgdGhlbiBhbHdheXMgZXhwb3NlIHRoZQ0KPj4gZmxhZyAtIGFuZCBpZiB5
b3UgZmluZCBpdCBicm9rZW4sIHJlbW92ZSBpdCBhZ2Fpbi4NCj4+IA0KPj4gUHV0dGluZyBhbGwg
b2YgdGhlIGxvZ2ljIG9uIHdoaWNoIHN5c3RlbSBwb3RlbnRpYWxseSBwcmVmZXJzIEVDQU0gb3Zl
cg0KPj4gUElPIGNvbmZpZyBzcGFjZSBhY2Nlc3MgaW50byBMaW51eCBpcyBqdXN0IGEgYmlnIGhh
Y2sgdGhhdCB3ZSBzaG91bGQNCj4+IGF2b2lkIGFzIG11Y2ggYXMgcG9zc2libGUuDQo+IA0KPiBU
aGFua3MgQWxleC4gWW91IHJhaXNlIGltcG9ydGFudCBwb2ludHMuIExldCBtZSB0cnkgdG8gYnJl
YWsgZG93biB5b3VyDQo+IGNvbmNlcm5zIHNsaWdodGx5IGRpZmZlcmVudGx5Og0KPiANCj4gMS4g
RW5hYmxpbmcgTU1JTyBhY2Nlc3Mgc2hvdWxkIGJlIHNlbGVjdGl2ZSwgYW5kIHBvdGVudGlhbGx5
IGNvbnRyb2xsZWQgYnkNCj4gdGhlIGh5cGVydmlzb3IuIFRoZSB2ZXJ5IGxlYXN0IGEgImNoaWNr
ZW4tYml04oCdIGlzIG5lZWRlZC4NCj4gDQo+IDIuIFBDSSBTSUcgd291bGQgY2hhbmdlIGl0cyBz
cGVjaWZpY2F0aW9ucyB0byBhZGRyZXNzIHVuY2xlYXIgaGFyZHdhcmUgYnVnLg0KPiANCj4gSSB0
aGluayAoMSkgbWFrZXMgc2Vuc2UgYW5kIHdlIGNhbiBkaXNjdXNzIGRpZmZlcmVudCB3YXlzIG9m
IGFkZHJlc3NpbmcgaXQuDQo+IEJ1dCAoMikgd291bGQgbm90IGhhcHBlbiBpbiBhIHJlYXNvbmFi
bGUgdGltZWxpbmUgYW5kIHNlZW1zIHRvIG1lIGFzIGFuDQo+IHVubmVjZXNzYXJ5IGNvbXBsaWNh
dGlvbi4NCj4gDQo+IEJ1dCBiZWZvcmUgd2UgZGlzY3VzcyBob3cgdG8gYWRkcmVzcyB0aGUgaXNz
dWUsIHBlcmhhcHMgd2UgbmVlZCB0byBmaXJzdA0KPiB1bmRlcnN0YW5kIGl0IGJldHRlci4gSSBh
bSBub3Qgc3VyZSB0aGF0IEkgdW5kZXJzdGFuZCB0aGlzIE1NSU8gYnVnLCBhbmQgc28NCj4gZmFy
IG5vYm9keSB3YXMgYWJsZSB0byBwcm92aWRlIGV4YWN0IGRldGFpbHMuDQo+IA0KPiBTbyBJIHdl
bnQgdG8gaGF2ZSBhIGxvb2suIEl0IG1pZ2h0IG5vdCBiZSBzdXBlciBoZWxwZnVsLCBidXQgZm9y
IHRoZSByZWNvcmQsDQo+IGhlcmUgaXMgd2hhdCBJIGNvbGxlY3RlZC4NCj4gDQo+IEZpcnN0LCB3
ZSBoYXZlIGNvbW1pdCBkNmVjZTU0OTFhZTcxZCAoImkzODYveDg2LTY0IENvcnJlY3QgZm9yIGJy
b2tlbiBNQ0ZHDQo+IHRhYmxlcyBvbiBLOCBzeXN0ZW1z4oCdKS4gSXQgdHJpZWQgdG8gInRyeSB0
byBkaXNjb3ZlciBhbGwgZGV2aWNlcyBvbiBidXMgMA0KPiB0aGF0IGFyZSB1bnJlYWNoYWJsZSB1
c2luZyBNTSBhbmQgZmFsbGJhY2sgZm9yIHRoZW0u4oCdIEludGVyZXN0aW5nbHksIGl0DQo+IHNl
ZW1zIHNpbWlsYXIgdG8gRnJlZUJTRCBjb2RlIChjb21taXQgMmQxMDU3MGFmZTJiM2UpIHRoYXQg
YWxzbyBtZW50aW9ucyBLOA0KPiBhbmQgaGFzIHNpbWlsYXIgZGV0ZWN0aW9uIGxvZ2ljIGluIEZy
ZWVCU0TigJlzIHBjaWVfY2ZncmVnb3BlbigpLg0KPiANCj4gVGhlbiBjb21taXQgYTBjYTk5MDk2
MDk0NzAgKCJQQ0kgeDg2OiBhbHdheXMgdXNlIGNvbmYxIHRvIGFjY2VzcyBjb25maWcNCj4gc3Bh
Y2UgYmVsb3cgMjU2IGJ5dGVz4oCdKS4gVGhlIGNvcnJlc3BvbmRlbmNlIFsxXSBtZW50aW9ucyBz
b21lIGJ1Z3M6IEFUSQ0KPiBjaGlwc2V0LCBWSUEgY2hpcHNldCwgSW50ZWwgMyBTZXJpZXMgRXhw
cmVzcyBjaGlwc2V0IGZhbWlseSBhbmQgc29tZSByZXBvcnRzDQo+IG9uIE52aWRpYS4gSXQgdHVy
bmVkIG91dCBzb21lIGRldmljZXMgaGFkIHByb2JsZW0gcHJvYmluZyAtIHRvIGZpZ3VyZSBvdXQg
aWYNCj4gTU1JTyBpcyBicm9rZW4gLSB0aGUgd2F5IHRoZSBwcmV2aW91cyBwYXRjaCBkaWQuDQo+
IA0KPiBBbGwgb2YgdGhlc2UgYnVncyBhcmUgY2lyY2EgMjAwOCwgb2YgY291cnNlLiBBbmQgbm90
ZSB0aGF0IEZyZWVCU0QgZGlkIG5vdA0KPiB0YWtlIGEgc2ltaWxhciBwYXRoLiBUaGUgY29ycmVz
cG9uZGVuY2UgYXJvdW5kIExpbnV4IHBhdGNoIGlzIGVuZGxlc3MuIEkNCj4gYWRtaXQgdGhhdCBJ
IGRpZCBub3QgdW5kZXJzdGFuZCB3aGV0aGVyIGV2ZW50dWFsbHkgdGhlIGlzc3VlcyB3ZXJlIGZv
dW5kIHRvDQo+IGJlIHBlci1idXMgb3IgcGVyLWRldmljZS4NCj4gDQo+IA0KPiBCYWNrIHRvIHRo
ZSBtYXR0ZXIgYXQgaGFuZC4gVGhlIGJlbmVmaXQgb2YgdXNpbmcgdGhlIE1DRkcgYXBwcm9hY2gg
dGhhdCB5b3UNCj4gcHJvcG9zZSBpcyB0aGF0IGl0IGNhbiBlbmFibGUgbmF0aXZlIHN5c3RlbXMg
dG8gdXNlIE1NSU8gYXMgd2VsbC4gSG93ZXZlciwNCj4gc2luY2UgdGhlIGxpc3Qgb2YgYnVncyBp
cyB1bmNsZWFyIGFuZCB0aGUgcHJvYmxlbXMgbWlnaHQgYmUgZGV2aWNlLXNwZWNpZmljLA0KPiBp
dCBpcyBub3QgY2xlYXIgd2hhdCBpbmZvcm1hdGlvbiBCSU9TZXMgaGF2ZSB0aGF0IExpbnV4IGRv
ZXNu4oCZdC4gSW4gb3RoZXINCj4gd29yZHMsIHRoZSBiZW5lZml0IG9mIGdldHRpbmcgaXQgaW50
byB0aGUgc3BlY2lmaWNhdGlvbnMgaXMgcXVlc3Rpb25hYmxlLA0KPiBhbmQgdGhlIGNvbXBsZXhp
dHkrdGltZSBpcyBoaWdoLg0KPiANCj4gQ2FuIHdlIGFncmVlIHRoYXQgdGhlIGZlYXR1cmUgd291
bGQgYmUgZW5hYmxlZCBleHBsaWNpdGx5IGJ5IHRoZSBoeXBlcnZpc29yDQo+IGFuZCBMaW51eCB3
b3VsZCBlbmFibGUgaXQgYmFzZWQgb24gdGhlIGh5cGVydmlzb3IgaW5wdXQgKHRocm91Z2ggc29t
ZQ0KPiBjaGFubmVsPykNCg0KQWxleCwgaXMgaXQgb2sgd2l0aCB5b3U/IFdlIHdpbGwgZW5hYmxl
IHRoZSBmZWF0dXJlIChkaXNhYmxlIHRoZSBidWcpDQpleHBsaWNpdGx5IGZyb20gdGhlIGh5cGVy
dmlzb3IsIGJ1dCB3b3VsZCBub3QgcmVseSBvbiBNQ0ZHIGNoYW5nZXMsIHdoaWNoDQp3b3VsZCBl
dmVuIGluIHRoZSBiZXN0IGNhc2Ugd291bGQgdGFrZSBzb21lIHRpbWUu
