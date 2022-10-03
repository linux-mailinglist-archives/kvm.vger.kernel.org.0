Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB08C5F34A0
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 19:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiJCRgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 13:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJCRf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 13:35:29 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11011003.outbound.protection.outlook.com [52.101.52.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6133A4BC;
        Mon,  3 Oct 2022 10:34:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6TBiDjzsKsM1MY3Cs6s/4tE58DAF+CPepSFV3fymCSqgHk11e0ze8qqgPmbqAo4QALAGSDJXV6L4PpLL9aK5AIJ38iTrSfjjyHIRrjb5RcbYLOIZtaJETjqgj5rlWJpsgHrCwOvk60SizhZC4AQkNOIvh573f34F4+gHhTGD89OMU+qa34k/AIZf5fwRkVCPpSg9lVsSsWOyGvt+dgte9Gg54NBsbAULii2sox0ncX5lF9K8oVMlxPxwy3OYTLNuDiy89BfsF4UzLhXBi3CpUNMBNVFz0oru+gNFs42OOYsLXp+9lxSYy9Ub9Y/A+FgyLNBGBm+Dupz5kCZ7bO6/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbnE7MrDWW5nQM+t2yG5rjk3HSDbCgVczShqlOfEIoc=;
 b=j0vxyCIqv3m7KPwBFomzpo6DxT27uiwOhk+lMJJq+r9tOyDT33xRxPvA414hbbpsN2DYpVrZAA9Pmp79fne/Ywf3blZW90NU2FGXRXoKq5WfoLyX9ORscA2SJ0MSFwFWBcc5yahvW6rv9YDGhKr3QA0ao5l+Ibo40QX9TsmZmUhA3IHsO3jVzkwAIVd8W7LEgCjgTK+plT3LyzIKgWF+kU3yl4GwrKDnwIlG0Kyedgo0qV7mS+o0ppr2s2EwFBN5aTaqz+51Ug077zrU7HuWK2QkHBaypdWAsvtFGZLjsmJNeErsqvgEwFNm2diTsegfUu/uJogOCj1+OxpxENERVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbnE7MrDWW5nQM+t2yG5rjk3HSDbCgVczShqlOfEIoc=;
 b=CUBLXxK1xIKpqS7IQi0reDc/3Ow9Z/9EuyWxxSRjfs3rgFjrlOwhl366ZZogpbrAtBYJLHOW/iGtVTuSDWAzrtTYvAcyf5+EyIv95xgu3f7visxqw1Y6VC7MHv0uIliVYjcWfPacZcZZagqSC2RbeBUW7KghvzgAFgeUefqqlYQ=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by SN6PR05MB4909.namprd05.prod.outlook.com (2603:10b6:805:8f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.14; Mon, 3 Oct
 2022 17:34:16 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6%7]) with mapi id 15.20.5709.008; Mon, 3 Oct 2022
 17:34:16 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alexander Graf <graf@amazon.com>
CC:     Ajay Kaher <akaher@vmware.com>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
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
        "acrn-dev@lists.projectacrn.org" <acrn-dev@lists.projectacrn.org>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Topic: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Index: AQHYx28G+J2WSwxm3kmFzqoOhSDYUK3dXFQAgBj77YCABouGgIAAKhGA
Date:   Mon, 3 Oct 2022 17:34:15 +0000
Message-ID: <04F550C5-786A-4B8E-9A88-EBFBD8872F16@vmware.com>
References: <9FEC6622-780D-41E6-B7CA-8D39EDB2C093@vmware.com>
 <87zgf3pfd1.fsf@redhat.com> <B64FD502-E794-4E94-A267-D690476C57EE@vmware.com>
 <87tu4l9cfm.fsf@redhat.com>
In-Reply-To: <87tu4l9cfm.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|SN6PR05MB4909:EE_
x-ms-office365-filtering-correlation-id: f067f375-a994-4f7d-f56f-08daa5657e8e
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IaLUdvWXEsR+zuBn4vVC5O6D2aYNnOJE1YfeoCPPy/2WQ65EDfBOC5kCLgRnYVqBSyr9lfyXrxb4R14kqV/57YCijAHSuUOwokBRVa+GK3n3g2EtHU+y/G68oJQaXGA/fDnCAGVsqaNHjgIN9ON6FdDLiggoIztOyzznnccnSsaeh1cSajSQPo5SWTwEJJF8KZd2hpfqj45M9z1bvD8f/VyItjIaAL2I5T0rqiMSje4CJBBQBzZGsoDRvmFj5VdSDLowFHWnDnB3cA6oR4GfLtLiXXNvwekw8lxIn45oNkvLd6XePYVK2bUeywI66lb95zaCTM8KknTuFLH67bclG2aYVpZ0nIQVIlPseDTirUWwdiJzXN0qdhjdnV4sCMgrt0pE9Sc4noU5eT0E6bBifqma1kZuHzmWbDEl4LN04PDraWbg6MAbNdyHi72foKiPNiucmZcFvc3URmbpfNrd+NOFy1EEY11+nASkiG9ooCff/XitFaEwzakpNFwFU5Ch/w/b0vyRb+NIqrCwp9dt1B3DRMbbYkiKcaBh3y0Pnwn4qcx1Ebi/jgmTkB47obsQDk3k/IZUSrgd9/2kNmzxJ2QVn0u8fApc0S0qQpqDMdWdUqR1sWJEudqviLIEjaJ1wtTpdCr+gjzOAuf3Zz3NoLDRLbHNsSG5bQQLGya91xXFjNTD+mLx+zBvfr8EK1dVS7yiCam9MSKIsqpE/oHIdiCBTrsitNbKIAp5vK/eqUd6EbjkCyFhVoBXDVF618Dn3u8p9yLRRt+4gtCw/O4h8o5/euzeukUR22Wth3gas0c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(2906002)(5660300002)(7416002)(8936002)(41300700001)(71200400001)(36756003)(478600001)(76116006)(316002)(38100700002)(86362001)(122000001)(4326008)(64756008)(6512007)(8676002)(26005)(66556008)(66446008)(6506007)(110136005)(53546011)(2616005)(66476007)(54906003)(66946007)(6486002)(38070700005)(33656002)(186003)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SS9ZRWRva3lXQmpRcW9ZeE8rT3VZSlpRS2U0UmFMSGRBYVVoSjhSWUZVVFlW?=
 =?utf-8?B?YUpjQmZkRExYL0UwL1FOeFNvai90SmxVL3k3ZVBuWXRxK0kzZ1ZMK01sZFRi?=
 =?utf-8?B?cE9kcUw0RlRtRXQ1WmZoQmZDUlFtVGxWdDYycFJqcU9DSE1jRisrZzVIaGhK?=
 =?utf-8?B?ZEhLU3IxdHJHQ3FDRXhwUjhvMExZSWlpS0M5aXg5bVdLQXl4SWVDKytSdnZH?=
 =?utf-8?B?cWZERVVpVXdwYmJGdnlmbG1qbUZSZkwySXdZV0d6L1BSSEdZdjJ6UThpZ0pN?=
 =?utf-8?B?a0VITSt4NmJmSHJQUzFEekxaczZmclBpaFRreTFoSDFiR28zc1RlNlFOckhF?=
 =?utf-8?B?bTNUY2xBVTZBVk5Sdld1SkhYSmxOdmZQeGs5RGNMNHl0MldjeUE1dXgzd3Bz?=
 =?utf-8?B?b0lLOU1OWkpsNUdpVDgybkZvZ2pyNGlBUnUrdWpUTFBsblZhejJ6MFU0dE1o?=
 =?utf-8?B?RTBqaytjbUUybDZ3Z3Robkd5LzkvTkhlTGliREprOUxGbXVZUlFtWUZYNGpQ?=
 =?utf-8?B?T1UzR1QvZ2Y4TFZqNWZpNW5Fb3k1cDkzR0U2M1JvRUJDUkZlZDZsMUNMWjlC?=
 =?utf-8?B?SU9DdTJLdG42TStyUEQ4MUdBNFQwZmltNEVwVHBDZGNJYXg1QVM0eTRraTZB?=
 =?utf-8?B?WWIrYTZkMzlGT3NBeTlJcVRYWnZlZFBHcDBuOTgxVlBxSHdHRDMrREFzMlZL?=
 =?utf-8?B?WENuaUMvckYxOEF3ZjE5cjdidXRYdTljeGZvTlU2eUc0OG9VSytwVHVjNWZO?=
 =?utf-8?B?dVVFVnRVRWIya0xaQzJRM3pQM2k3M1Nxay9DRG56RW01cEJzZDRkQVMydG9p?=
 =?utf-8?B?ek1iRlFXenNaVHd1cXprc1VoQ2dLbHJEVjNHMktuVngwdzZOQy9TRFFLejNk?=
 =?utf-8?B?RWpFVGhYLzlhVXBoQTVRZU5CRDRIcUNIRDJoNjFxT1VjckNmRXpiTG9oR0lR?=
 =?utf-8?B?Y092MC9LL1VHa0NBVDcrNmhXNkxpVVJFTElZNll3WjRhU1Y5d2ZhMFJ3OG9o?=
 =?utf-8?B?VXh3aUZ6bkVHMXFuTDM5MmxOeHc1RkhVdWl5dnhJSThNNFd1N1JKUzZUOFZN?=
 =?utf-8?B?RzJzL25GWFJLRnNqVE9LakJOSFhEaHdZUVV4MTFXSWpSRDlGWWpHUDE2N1Ar?=
 =?utf-8?B?MERhbFB2SkRYeXRyR2pZQ3dHaE5UNVB4azFMMnJMQ1prM0dDM1BWcnFHOXl3?=
 =?utf-8?B?SHZQczU2N3Z1SlpFWFZxZGdHQUdKNTIvS0k1YWorRkx4QWsvUFBvU1dmOEor?=
 =?utf-8?B?RUk4NHMwanQ0bFpkRjhtdW1QcEtJWVJXYzNLUzdxWG42WHN2Z1p2Yk1YclNi?=
 =?utf-8?B?QVU1UDVYV1R1Q0l6eFZBR2NHcllVODNCSDdPMWdZZ3RNS0FSWXFKUEV0RmFG?=
 =?utf-8?B?R21mWGVoUGVIem5DWk95ZlNpNmJ6M285VlAyRXVHWkxGblg5MWNIaHE2dWJv?=
 =?utf-8?B?bEl2WXFkcjZKNHlJMkttQXh5YkJYd0JhU1V4bkpGaTR4VlVuNm00QVhMNThX?=
 =?utf-8?B?aU1YTmJhNUVkT3FFaG82TDQ1cTdNclcxQmFJRXByelR4MzFMZkEveCtaR2hL?=
 =?utf-8?B?eVhiSjBqOHVoU3FPTVRQM0JmM1RZZFhaTHFRbkNqWk9yWDAyUkIxMm5CRDRI?=
 =?utf-8?B?MFNLMCs4c3B1M1VMVmpsc0NwNk5GaUFtZCtqOUkrUU1BMjlLMHRkTEE4bFhD?=
 =?utf-8?B?MklNRDdlRUJwdVJjWi8yRnkvRVBObGp1YUcrSW43OUQwcngwM0g0WmsyVW1i?=
 =?utf-8?B?YjROVXpzSTRMa1poM3l2bzZFU2EzUkNVZEJkdTlzUU40b2JsUEdwRHF0bndO?=
 =?utf-8?B?TFppeFM2OVp3T055dDBWekxnVVdSZEFwS3I4NzVmUnNoTXdTbGZJakxnTTFC?=
 =?utf-8?B?eUx3dkErS0VHeGMxenpMVkdHTUZjM0tRSGJ5N0xpbXJrYkd6cE9hRWZBSjg5?=
 =?utf-8?B?bndPQ0lrMS9vak9IWVordnR4bHIrYkYyM0cwR0R5andKdmx1YnptT0pqeWxX?=
 =?utf-8?B?d3RYcmpjY3lCdlQvMjdnRmE4cGxYNEZoZlNSSGRYeUdDc0NyVE5YZE04d2pk?=
 =?utf-8?B?R3h0ZERDOVhMNFdGMWI2aDJ5V2RGVnFJTGZ4RGc4Nk5pZDNIZ1dqU2xTRmtn?=
 =?utf-8?Q?+a66uWCSsmVNdFG28Hq0rHmSH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D0FA40BBFF97F47A797D05CA1FD21C7@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f067f375-a994-4f7d-f56f-08daa5657e8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 17:34:15.9768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H7e6BrAlIbbPlhbwP3L1c1bni96047Ws6DuPb4ylCyO6F0J+GOacZaA0S6L4OAtbt+jZK+Hi+TbxT7kETvK/yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4909
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gT2N0IDMsIDIwMjIsIGF0IDg6MDMgQU0sIFZpdGFseSBLdXpuZXRzb3YgPHZrdXpuZXRzQHJl
ZGhhdC5jb20+IHdyb3RlOg0KDQo+IE5vdCBteSBidXQgcmF0aGVyIFBDSSBtYWludGFpbmVyJ3Mg
Y2FsbCBidXQgSU1ITyBkcm9wcGluZyAnY29uc3QnIGlzDQo+IGJldHRlciwgaW50cm9kdWNpbmcg
YSBuZXcgZ2xvYmFsIHZhciBpcyBvdXIgJ2xhc3QgcmVzb3J0JyBhbmQgc2hvdWxkIGJlDQo+IGF2
b2lkZWQgd2hlbmV2ZXIgcG9zc2libGUuIEFsdGVybmF0aXZlbHksIHlvdSBjYW4gYWRkIGENCj4g
cmF3X3BjaV9leHRfb3BzX3ByZWZlcnJlZCgpIGZ1bmN0aW9uIGNoZWNraW5nIHNvbWV0aGluIHdp
dGhpbiAnc3RydWN0DQo+IGh5cGVydmlzb3JfeDg2JyBidXQgSSdtIHVuc3VyZSBpZiBpdCdzIGJl
dHRlci4NCj4gDQo+IEFsc28sIHBsZWFzZSBjaGVjayBBbGV4JyBxdWVzdGlvbi9zdWdnZXN0aW9u
Lg0KDQpIZXJlIGlzIG15IHRha2UgKGFuZCBBamF5IGtub3dzIHByb2JhYmx5IG1vcmUgdGhhbiBt
ZSk6DQoNCkxvb2tpbmcgYnJpZWZseSBvbiBNQ0ZHLCBJIGRvIG5vdCBzZWUgYSBjbGVhbiB3YXkg
b2YgdXNpbmcgdGhlIEFDUEkgdGFibGUuDQpUaGUgdHdvIG9wdGlvbnMgYXJlIGVpdGhlciB0byB1
c2UgYSByZXNlcnZlZCBmaWVsZCAod2hpY2ggd2hvIGtub3dzLCBtaWdodA0KYmUgdXNlZCBvbmUg
ZGF5KSBvciBzb21lIE9FTSBJRC4gSSBhbSBhbHNvIG5vdCBmYW1pbGlhciB3aXRoDQpQQ0lfQ09N
TUFORC5NRU1PUlk9MCwgc28gQWpheSBjYW4gaG9wZWZ1bGx5IGdpdmUgc29tZSBhbnN3ZXIgYWJv
dXQgdGhhdC4NCg0KQW55aG93LCBJIHVuZGVyc3RhbmQgKGFsdGhvdWdoIG5vdCByZWxhdGUpIHRv
IHRoZSBvYmplY3Rpb24gZm9yIGEgbmV3IGdsb2JhbA0KdmFyaWFibGUuIEhvdyBhYm91dCBleHBs
aWNpdGx5IGNhbGxpbmcgdGhpcyBoYXJkd2FyZSBidWcgYSDigJxidWfigJ0gYW5kIHVzaW5nDQp0
aGUgcHJvcGVyIGluZnJhc3RydWN0dXJlPyBDYWxsaW5nIGl0IGV4cGxpY2l0bHkgYSBidWcgbWF5
IGV2ZW4gcHVzaCB3aG9ldmVyDQpjYW4gdG8gcmVzb2x2ZSBpdC4NCg0KSU9XLCBob3cgYWJvdXQg
ZG9pbmcgc29tZXRoaW5nIGFsb25nIHRoZSBsaW5lcyBvZiAobm90IHRlc3RlZCk6DQoNCg0KLS0g
PjggLS0NCg0KU3ViamVjdDogW1BBVENIXSB4ODYvUENJOiBQcmVmZXIgTU1JTyBvdmVyIFBJTyBv
biBWTXdhcmUgaHlwZXJ2aXNvcg0KDQotLS0NCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0
dXJlcy5oIHwgMSArDQogYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYyAgICAgICB8IDIgKysN
CiBhcmNoL3g4Ni9rZXJuZWwvY3B1L3Ztd2FyZS5jICAgICAgIHwgMiArKw0KIGFyY2gveDg2L3Bj
aS9jb21tb24uYyAgICAgICAgICAgICAgfCA2ICsrKystLQ0KIDQgZmlsZXMgY2hhbmdlZCwgOSBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5j
bHVkZS9hc20vY3B1ZmVhdHVyZXMuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVz
LmgNCmluZGV4IGVmNDc3NWM2ZGIwMS4uMjE2YjZmMzU3YjZkIDEwMDY0NA0KLS0tIGEvYXJjaC94
ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaA0KKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20v
Y3B1ZmVhdHVyZXMuaA0KQEAgLTQ2MCw1ICs0NjAsNiBAQA0KICNkZWZpbmUgWDg2X0JVR19NTUlP
X1VOS05PV04JCVg4Nl9CVUcoMjYpIC8qIENQVSBpcyB0b28gb2xkIGFuZCBpdHMgTU1JTyBTdGFs
ZSBEYXRhIHN0YXR1cyBpcyB1bmtub3duICovDQogI2RlZmluZSBYODZfQlVHX1JFVEJMRUVECQlY
ODZfQlVHKDI3KSAvKiBDUFUgaXMgYWZmZWN0ZWQgYnkgUkVUQmxlZWQgKi8NCiAjZGVmaW5lIFg4
Nl9CVUdfRUlCUlNfUEJSU0IJCVg4Nl9CVUcoMjgpIC8qIEVJQlJTIGlzIHZ1bG5lcmFibGUgdG8g
UG9zdCBCYXJyaWVyIFJTQiBQcmVkaWN0aW9ucyAqLw0KKyNkZWZpbmUgWDg2X0JVR19FQ0FNX01N
SU8JCVg4Nl9CVUcoMjkpIC8qIEVDQU0gTU1JTyBpcyBidWdneSBhbmQgUElPIGlzIHByZWZlcmFi
bGUgKi8NCiANCiAjZW5kaWYgLyogX0FTTV9YODZfQ1BVRkVBVFVSRVNfSCAqLw0KZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2Nv
bW1vbi5jDQppbmRleCAzZTUwOGYyMzkwOTguLmM5NDE3NWZhMzA0YiAxMDA2NDQNCi0tLSBhL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMNCisrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvY29t
bW9uLmMNCkBAIC0xMjk5LDYgKzEyOTksOCBAQCBzdGF0aWMgdm9pZCBfX2luaXQgY3B1X3NldF9i
dWdfYml0cyhzdHJ1Y3QgY3B1aW5mb194ODYgKmMpDQogew0KIAl1NjQgaWEzMl9jYXAgPSB4ODZf
cmVhZF9hcmNoX2NhcF9tc3IoKTsNCiANCisJc2V0dXBfZm9yY2VfY3B1X2J1ZyhYODZfQlVHX0VD
QU1fTU1JTyk7DQorDQogCS8qIFNldCBJVExCX01VTFRJSElUIGJ1ZyBpZiBjcHUgaXMgbm90IGlu
IHRoZSB3aGl0ZWxpc3QgYW5kIG5vdCBtaXRpZ2F0ZWQgKi8NCiAJaWYgKCFjcHVfbWF0Y2hlcyhj
cHVfdnVsbl93aGl0ZWxpc3QsIE5PX0lUTEJfTVVMVElISVQpICYmDQogCSAgICAhKGlhMzJfY2Fw
ICYgQVJDSF9DQVBfUFNDSEFOR0VfTUNfTk8pKQ0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5l
bC9jcHUvdm13YXJlLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3Ztd2FyZS5jDQppbmRleCAwMjAz
OWVjMzU5N2QuLjg5MDM3NzYyODRhNiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUv
dm13YXJlLmMNCisrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvdm13YXJlLmMNCkBAIC0zODUsNiAr
Mzg1LDggQEAgc3RhdGljIHZvaWQgX19pbml0IHZtd2FyZV9zZXRfY2FwYWJpbGl0aWVzKHZvaWQp
DQogCQlzZXR1cF9mb3JjZV9jcHVfY2FwKFg4Nl9GRUFUVVJFX1ZNQ0FMTCk7DQogCWVsc2UgaWYg
KHZtd2FyZV9oeXBlcmNhbGxfbW9kZSA9PSBDUFVJRF9WTVdBUkVfRkVBVFVSRVNfRUNYX1ZNTUNB
TEwpDQogCQlzZXR1cF9mb3JjZV9jcHVfY2FwKFg4Nl9GRUFUVVJFX1ZNV19WTU1DQUxMKTsNCisN
CisJc2V0dXBfY2xlYXJfY3B1X2NhcChYODZfQlVHX0VDQU1fTU1JTyk7DQogfQ0KIA0KIHN0YXRp
YyB2b2lkIF9faW5pdCB2bXdhcmVfcGxhdGZvcm1fc2V0dXAodm9pZCkNCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9wY2kvY29tbW9uLmMgYi9hcmNoL3g4Ni9wY2kvY29tbW9uLmMNCmluZGV4IGRkYjc5
ODYwMzIwMS4uYmM4MWNmNGMxMDE0IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvcGNpL2NvbW1vbi5j
DQorKysgYi9hcmNoL3g4Ni9wY2kvY29tbW9uLmMNCkBAIC00MCw3ICs0MCw4IEBAIGNvbnN0IHN0
cnVjdCBwY2lfcmF3X29wcyAqX19yZWFkX21vc3RseSByYXdfcGNpX2V4dF9vcHM7DQogaW50IHJh
d19wY2lfcmVhZCh1bnNpZ25lZCBpbnQgZG9tYWluLCB1bnNpZ25lZCBpbnQgYnVzLCB1bnNpZ25l
ZCBpbnQgZGV2Zm4sDQogCQkJCQkJaW50IHJlZywgaW50IGxlbiwgdTMyICp2YWwpDQogew0KLQlp
ZiAoZG9tYWluID09IDAgJiYgcmVnIDwgMjU2ICYmIHJhd19wY2lfb3BzKQ0KKwlpZiAoZG9tYWlu
ID09IDAgJiYgcmVnIDwgMjU2ICYmIHJhd19wY2lfb3BzICYmDQorCSAgICAoYm9vdF9jcHVfaGFz
X2J1ZyhYODZfQlVHX0VDQU1fTU1JTykgfHwgIXJhd19wY2lfZXh0X29wcykpDQogCQlyZXR1cm4g
cmF3X3BjaV9vcHMtPnJlYWQoZG9tYWluLCBidXMsIGRldmZuLCByZWcsIGxlbiwgdmFsKTsNCiAJ
aWYgKHJhd19wY2lfZXh0X29wcykNCiAJCXJldHVybiByYXdfcGNpX2V4dF9vcHMtPnJlYWQoZG9t
YWluLCBidXMsIGRldmZuLCByZWcsIGxlbiwgdmFsKTsNCkBAIC01MCw3ICs1MSw4IEBAIGludCBy
YXdfcGNpX3JlYWQodW5zaWduZWQgaW50IGRvbWFpbiwgdW5zaWduZWQgaW50IGJ1cywgdW5zaWdu
ZWQgaW50IGRldmZuLA0KIGludCByYXdfcGNpX3dyaXRlKHVuc2lnbmVkIGludCBkb21haW4sIHVu
c2lnbmVkIGludCBidXMsIHVuc2lnbmVkIGludCBkZXZmbiwNCiAJCQkJCQlpbnQgcmVnLCBpbnQg
bGVuLCB1MzIgdmFsKQ0KIHsNCi0JaWYgKGRvbWFpbiA9PSAwICYmIHJlZyA8IDI1NiAmJiByYXdf
cGNpX29wcykNCisJaWYgKGRvbWFpbiA9PSAwICYmIHJlZyA8IDI1NiAmJiByYXdfcGNpX29wcyAm
Jg0KKwkgICAgKGJvb3RfY3B1X2hhc19idWcoWDg2X0JVR19FQ0FNX01NSU8pIHx8ICFyYXdfcGNp
X2V4dF9vcHMpKQ0KIAkJcmV0dXJuIHJhd19wY2lfb3BzLT53cml0ZShkb21haW4sIGJ1cywgZGV2
Zm4sIHJlZywgbGVuLCB2YWwpOw0KIAlpZiAocmF3X3BjaV9leHRfb3BzKQ0KIAkJcmV0dXJuIHJh
d19wY2lfZXh0X29wcy0+d3JpdGUoZG9tYWluLCBidXMsIGRldmZuLCByZWcsIGxlbiwgdmFsKTsN
Ci0tIA0KMi4zNC4xDQoNCg0KDQoNCg==
