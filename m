Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1BB5F37DA
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 23:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiJCVdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 17:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiJCVd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 17:33:28 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11011008.outbound.protection.outlook.com [52.101.52.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A557B5A3FA;
        Mon,  3 Oct 2022 14:28:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TStowMQnvKQ0EB/QqIYKa6JYYaWMCCNXeX8X6wU4ZcaXq1XS1wLjSrgrh8ystH22teajwo7u91348AUdTvwSO0c2hIUk0dEVfnp0Rnf0QT+oXd5OzJ+cx1AbECNUCDxL5cUn9GDUb6GK2JT/hdzJMQrDtJ0rs2ZQzV3cVTJINS2RhrWe2bgpjuxqZLSmAp7s9uXfZPD7EPhsXVKdrH1odIWL0yLDzjaKF2XmdvPmzsjUerwTmxVq1YDt8VaZYvLT4JYG4S8dqMOIHonndUia4FYLbdxAYnH/k9R6xYmJgYwe4gd1b56+HFe1rZQlP93gMeNlrMmkd9KLeQVKShlkCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zw9fEnOoZeFAV82VlAHROfs2DhT1mAznnEugB9t75Rc=;
 b=SMtkNkrmfq9w6qVsf8B+F3oGVpl9Ui8pL+Zu6Opavv50m6iaRQCLYsBvn6bQtHJJhkVqVOIDtgJkrmv3Mky5iL1KBSpxvoaQilFiMcxzSKPSTFvPW9Gc2kiTUz4YqerCAM8NI0Htq26Bn5bVKs1IJ83ROSEE5fyBZrX4h8lbS7TJWQbrYeV3wjnNVOmpuOjPN3Bwmfa2iFl2G3xmy/iQeFfFRYfqKt69SRPpgdv7EnxFX0rl+UnpyjvyzEbBldov6IFIflRwJ8wd8C0N1ucFNbg/pZjtlrAr7wZDPDHMO1X6g8UysGVTVuSCg5zBK+gycDVUpeDQtkeMdDlC4A0IxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zw9fEnOoZeFAV82VlAHROfs2DhT1mAznnEugB9t75Rc=;
 b=CiVfhXyjNh0mg3nkJPsrTJ5fUgQTtweRQrEGZLu/+B8Cn2guuGolXcELjLIx5qFSlIzrx5GOhZyHicJifSv7maovlP2cg4OpYJDPd9rvNOrlDUJc5MjuP8IRCJWdvHssVoVgnbEdEOXBt1+05byZZVVNrkVbpzSlaWWt0ZJd9hY=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by DM6PR05MB5098.namprd05.prod.outlook.com (2603:10b6:5:75::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.7; Mon, 3 Oct
 2022 21:28:40 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6%7]) with mapi id 15.20.5709.008; Mon, 3 Oct 2022
 21:28:40 +0000
From:   Nadav Amit <namit@vmware.com>
To:     "H. Peter Anvin" <hpa@zytor.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Ajay Kaher <akaher@vmware.com>,
        "x86@kernel.org" <x86@kernel.org>,
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
Thread-Index: AQHYx28G+J2WSwxm3kmFzqoOhSDYUK3dXFQAgBj77YCABouGgIAAKhGAgAA7TgCAAAYigA==
Date:   Mon, 3 Oct 2022 21:28:40 +0000
Message-ID: <AD04C0EF-E3E0-4DE2-A812-B05382D6F7C2@vmware.com>
References: <9FEC6622-780D-41E6-B7CA-8D39EDB2C093@vmware.com>
 <87zgf3pfd1.fsf@redhat.com> <B64FD502-E794-4E94-A267-D690476C57EE@vmware.com>
 <87tu4l9cfm.fsf@redhat.com> <04F550C5-786A-4B8E-9A88-EBFBD8872F16@vmware.com>
 <42CFC548-F8FE-4BD9-89AB-198B2B3F1091@zytor.com>
In-Reply-To: <42CFC548-F8FE-4BD9-89AB-198B2B3F1091@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|DM6PR05MB5098:EE_
x-ms-office365-filtering-correlation-id: 72cd9929-8a82-4b42-8be7-08daa5863d7a
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tnFanJPohSoePytddyFCICLAU5UCXtmRioLvACI55Lor7zciBPZ9/1NdW+XWDO7RHDh3qnYRn0RYr8QS3xUXOaDwjYI9pDeM/rBMNNl4ZeJ9A+jrSil8I4aMYuw6iran/lL/9tvHThmPf/qSrklTIf6iuOfHSK9p5AeEKMXICgDfSyx3wBualqXqAXuRfjTU1xpJQAMCT2rfaxKewhz87JzLyYazvaAIybB0Gdqa6MxCsOnNhCvjT7aI86zjbPJTYrFd80Trb7vliWXSV5r8OsBye7piAJcrbFEvfhuUUC15EstMTrtY/rubTpeHzZrpRMDd+7W2rIogl67ZuzpKO0xvcPllUW/6UhdQIi533FJ0whRR1XRyhBihnVftZHIlpBB7vb15EYIt668N3E/wBDzgJFPta7HpJHai09JhhUEQ43HtBExbGrJhHLCk8x8wtDpflr+89VA6PiBMn7XHEYveEgZICm7d3ebtpIjCsoIxRJPnmVBRStgKgcBfuzUaNuokOBZN64d2HfHZqvogZiRppe63PQSLAbxPFyLYOMn5cG3DzDe7uDgqAo34CoHMlkm+ExknubRx1NUptdM6CzYozLG3CyK/KSrZ2ehGx702jRoHfSOC3YvwsI/AVQzgIKRvRxUOAj3OsnE4ZuVHdR7PqKhNnqwLozsSrmdr8KgWwlek3wVF+fFJ7ri1FBwqibp+4sdlz1cjUw40QZnusZ/+0lZu22TRznok/UtlnWWeYvh3hld3op4InwCS7PDudYYT3MunSmprSDaszO4uUKWNt+bjp/gHTh8xJmNk3mwRKs9Ei/fXTC9T8paFQtNhI23LKa7y8AHut4wXmgAgG8o/jN4SUdYpBYunjLVN8eA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199015)(38100700002)(122000001)(33656002)(38070700005)(36756003)(86362001)(6506007)(71200400001)(41300700001)(26005)(5660300002)(4326008)(8676002)(6512007)(53546011)(8936002)(64756008)(7416002)(6916009)(316002)(66556008)(66476007)(76116006)(54906003)(66946007)(66446008)(478600001)(83380400001)(6486002)(2906002)(186003)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0FQZ3VJeDBnaHVWV0MwTUlFZ3BGUHRJcUdGTHNpQ3U1eE5kQjQ0a1pyMEcz?=
 =?utf-8?B?SElTNWZTQW9xdzBpWG0zVS9TYUpXTlZCRWFaaU54c2orOTRyOStTUE5ZSkw3?=
 =?utf-8?B?NmY5ZklyL0E5MG4wWGxuMmlIMDhSSGNyQmRjV2NVWnhpaXB4ZVN2RGhhWmtm?=
 =?utf-8?B?OFZha3hzbkZFeUpFb0JnVXBVSS9XdFp1eGtGWEVWNFZxWnNXU1hQWFpFY1Qx?=
 =?utf-8?B?VEU3ZytkdGZSbnJnN2x0SFhtS1pvYnNxcnVnS3dKcHBMUjJLWktlRmszN3J6?=
 =?utf-8?B?Ty9IeUtvWC9tanBrdHZDSW9KUmg2Y2FQYThxRytYN1FweWZzUk9YTjR2VVlx?=
 =?utf-8?B?WjF6cmNTS0x0Wk9KNFQ4QXZjTzdWek9HQ3pBODZkZG1nMmNWK3dmc3hIRENq?=
 =?utf-8?B?alJMZ1JsNXBmempzWTFhVldvdklxR3Vhd1RyTE0wdVRaZUpDWU5Xa1RBTmxW?=
 =?utf-8?B?V3NrQStsNERwdmJKdGNKSFdmaWw0QW03T0NyVlkvblpCQzNPR1Z4THBrSlVo?=
 =?utf-8?B?ZXJVamloR29VTzlNRVlBTG1jZGlrK2NuODJsRUorbGVUOGx4NW04bkNKQXNR?=
 =?utf-8?B?U1RPS1pTWXB2RVNUbkVST2RZVkpYQW5WLzNLYTZQZzBJMnQ3RHpkcFloZmJV?=
 =?utf-8?B?c0E2alpsell3WWxJMG5nU1NGbTNLZ3g4bVRBVkxDWWY2RkRNaVY3MUpabmNT?=
 =?utf-8?B?R3lTZ3NRM1MrMjFvaEVVcXRiN3gwVUpsa0sxWGtyRHEwK3U3MDJyR1hwUTJI?=
 =?utf-8?B?QkxLb1ozb2NtY2RRWEtLeEViNHdKTjhXWC9XYjNXa2w0NU5hWmJqNHdnWEdE?=
 =?utf-8?B?YmkrNXBuRVZON1hqeENrbnkzbEFqb3RuY0NENGVJNEZMS09BNTRldk1GeDdP?=
 =?utf-8?B?dWp3M3ZwdUphMDEydVZlQlZIVnRydWJ5VmdvL3VuWFB2cHBTNWZZcDlMb0Fw?=
 =?utf-8?B?VS96UTV6T0dXbTlwc3Jua0VhTlNMTzZka0VHTnVPb0tYMjVPNlFMMTJkWklO?=
 =?utf-8?B?ek1zdmRmZVJsN1VrQ08rRGhPOE1UNG1FUytET2dtYk9TTk5rZTFzQU1SUE5w?=
 =?utf-8?B?UlVGN0VxeFhYOSsyejVOdUNvcnJSc0UzbDdzVEJOYjJ4R3pPaDR1blIrdzZI?=
 =?utf-8?B?MmlOM3pBa1RYckt4bzY0KzF0a3o2UVIzT0hQRDFvdzFuVGF3Sk9iWW1QR01N?=
 =?utf-8?B?WnIvdVhkR1NYcFl0RHFLZEMrTGs2MW9JLytscWtIdmR0ZnhvRTdRcWtHYm5Q?=
 =?utf-8?B?Z3BjL2FvNkxNOHpQZTYwaFRmM0tveW4zT0Q4aU5VN2VWNm4rRzN4WUVBaHFa?=
 =?utf-8?B?VnBYOW81akpFZzZBK3J4WERjcnhqbGQ1aXFlTVVCU2hob2tzbHNWVXhXb094?=
 =?utf-8?B?NlVTV2VYQkErcWxaYmNsQ0lSSWVJNkZPdTNqTk9EOVgreEpuQXZzUlhLYy81?=
 =?utf-8?B?OEp1UTlKZUZCU0FOOVVHOEpRQnVYZm1mV29hOHhXQk9haHlEN2tTOEtZRnZB?=
 =?utf-8?B?SHYxMlptemJFclUwb3M2ZzIrTkVvc0FlVlUwekdRS3k3Q3JUZjdqYlZiMTdK?=
 =?utf-8?B?ZTJEakkzelNoem1wcXBDbVMxcnUvRGhOT081YzBCd1ZpYm40VDE3UUVmaHJi?=
 =?utf-8?B?SWRnTlNhRm9XRzdrUzVGUDJvWDNiUUdKV0pMSEF0aVNYbzg5L0o2RGZxdE0x?=
 =?utf-8?B?dkVZN25aOFhpSitXK2d4dWJOVGkrSkNFN01HUnRsbi8zOUdWRCtSWUlvQTVB?=
 =?utf-8?B?dXVrRHFjSjVpckYzQ1BaWU5jcXFvRlhVelhBT3c0V0hGSXA1WG5haDRiN3c0?=
 =?utf-8?B?SUI3WkVIU2FnZXJXNHZ2UVJBM0hBbFJjeTJyTU40cFlqMDVQVkpHK2c1VXor?=
 =?utf-8?B?OUlZenE2Yytlb0pPZGxiMDJvcTgxQVpSemVLQzJiNXFUUUViK3R2ZWt5ZWE4?=
 =?utf-8?B?YUlnTE1KNnR0NUMrWjFDckcvYkU0WTRpRXRZWHE2M0VneHUwU1dIZ2RCaTBK?=
 =?utf-8?B?SVo5OG9GR2lBSXZHTngvVVJkWHZOQTdscWtERU5HcUEyZVdzUnl3V3UyNmUy?=
 =?utf-8?B?SXllWmlpRVFkUWlqVHJqKzBZcCsxMW5JYmluS1ZJQ3haV1pnU1Q2K01jTFNH?=
 =?utf-8?Q?bWfe7MwPlORs4W3hise5UaANb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10DBB0F4E3015E4FADD93889218F2547@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72cd9929-8a82-4b42-8be7-08daa5863d7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 21:28:40.1676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v8YAGeIDx3nMpzt8RA+oD/cKtQXqSKyjJ7koJdre6pIQTblAHZgmuE5rpBGkhTzYRTO5VpWnIx7pTk5AbBwRIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB5098
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gT2N0IDMsIDIwMjIsIGF0IDI6MDYgUE0sIEguIFBldGVyIEFudmluIDxocGFAenl0b3IuY29t
PiB3cm90ZToNCg0KPiDimqAgRXh0ZXJuYWwgRW1haWwNCj4gDQo+IE9uIE9jdG9iZXIgMywgMjAy
MiAxMDozNDoxNSBBTSBQRFQsIE5hZGF2IEFtaXQgPG5hbWl0QHZtd2FyZS5jb20+IHdyb3RlOg0K
Pj4gT24gT2N0IDMsIDIwMjIsIGF0IDg6MDMgQU0sIFZpdGFseSBLdXpuZXRzb3YgPHZrdXpuZXRz
QHJlZGhhdC5jb20+IHdyb3RlOg0KPj4gDQo+Pj4gTm90IG15IGJ1dCByYXRoZXIgUENJIG1haW50
YWluZXIncyBjYWxsIGJ1dCBJTUhPIGRyb3BwaW5nICdjb25zdCcgaXMNCj4+PiBiZXR0ZXIsIGlu
dHJvZHVjaW5nIGEgbmV3IGdsb2JhbCB2YXIgaXMgb3VyICdsYXN0IHJlc29ydCcgYW5kIHNob3Vs
ZCBiZQ0KPj4+IGF2b2lkZWQgd2hlbmV2ZXIgcG9zc2libGUuIEFsdGVybmF0aXZlbHksIHlvdSBj
YW4gYWRkIGENCj4+PiByYXdfcGNpX2V4dF9vcHNfcHJlZmVycmVkKCkgZnVuY3Rpb24gY2hlY2tp
bmcgc29tZXRoaW4gd2l0aGluICdzdHJ1Y3QNCj4+PiBoeXBlcnZpc29yX3g4NicgYnV0IEknbSB1
bnN1cmUgaWYgaXQncyBiZXR0ZXIuDQo+Pj4gDQo+Pj4gQWxzbywgcGxlYXNlIGNoZWNrIEFsZXgn
IHF1ZXN0aW9uL3N1Z2dlc3Rpb24uDQo+PiANCj4+IEhlcmUgaXMgbXkgdGFrZSAoYW5kIEFqYXkg
a25vd3MgcHJvYmFibHkgbW9yZSB0aGFuIG1lKToNCj4+IA0KPj4gTG9va2luZyBicmllZmx5IG9u
IE1DRkcsIEkgZG8gbm90IHNlZSBhIGNsZWFuIHdheSBvZiB1c2luZyB0aGUgQUNQSSB0YWJsZS4N
Cj4+IFRoZSB0d28gb3B0aW9ucyBhcmUgZWl0aGVyIHRvIHVzZSBhIHJlc2VydmVkIGZpZWxkICh3
aGljaCB3aG8ga25vd3MsIG1pZ2h0DQo+PiBiZSB1c2VkIG9uZSBkYXkpIG9yIHNvbWUgT0VNIElE
LiBJIGFtIGFsc28gbm90IGZhbWlsaWFyIHdpdGgNCj4+IFBDSV9DT01NQU5ELk1FTU9SWT0wLCBz
byBBamF5IGNhbiBob3BlZnVsbHkgZ2l2ZSBzb21lIGFuc3dlciBhYm91dCB0aGF0Lg0KPj4gDQo+
PiBBbnlob3csIEkgdW5kZXJzdGFuZCAoYWx0aG91Z2ggbm90IHJlbGF0ZSkgdG8gdGhlIG9iamVj
dGlvbiBmb3IgYSBuZXcgZ2xvYmFsDQo+PiB2YXJpYWJsZS4gSG93IGFib3V0IGV4cGxpY2l0bHkg
Y2FsbGluZyB0aGlzIGhhcmR3YXJlIGJ1ZyBhIOKAnGJ1Z+KAnSBhbmQgdXNpbmcNCj4+IHRoZSBw
cm9wZXIgaW5mcmFzdHJ1Y3R1cmU/IENhbGxpbmcgaXQgZXhwbGljaXRseSBhIGJ1ZyBtYXkgZXZl
biBwdXNoIHdob2V2ZXINCj4+IGNhbiB0byByZXNvbHZlIGl0Lg0KPj4gDQo+PiBJT1csIGhvdyBh
Ym91dCBkb2luZyBzb21ldGhpbmcgYWxvbmcgdGhlIGxpbmVzIG9mIChub3QgdGVzdGVkKToNCj4+
IA0KPj4gDQo+PiAtLSA+OCAtLQ0KPj4gDQo+PiBTdWJqZWN0OiBbUEFUQ0hdIHg4Ni9QQ0k6IFBy
ZWZlciBNTUlPIG92ZXIgUElPIG9uIFZNd2FyZSBoeXBlcnZpc29yDQo+PiANCj4+IC0tLQ0KPj4g
YXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaCB8IDEgKw0KPj4gYXJjaC94ODYva2Vy
bmVsL2NwdS9jb21tb24uYyAgICAgICB8IDIgKysNCj4+IGFyY2gveDg2L2tlcm5lbC9jcHUvdm13
YXJlLmMgICAgICAgfCAyICsrDQo+PiBhcmNoL3g4Ni9wY2kvY29tbW9uLmMgICAgICAgICAgICAg
IHwgNiArKysrLS0NCj4+IDQgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVh
dHVyZXMuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4+IGluZGV4IGVm
NDc3NWM2ZGIwMS4uMjE2YjZmMzU3YjZkIDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20vY3B1ZmVhdHVyZXMuaA0KPj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVh
dHVyZXMuaA0KPj4gQEAgLTQ2MCw1ICs0NjAsNiBAQA0KPj4gI2RlZmluZSBYODZfQlVHX01NSU9f
VU5LTk9XTiAgICAgICAgICBYODZfQlVHKDI2KSAvKiBDUFUgaXMgdG9vIG9sZCBhbmQgaXRzIE1N
SU8gU3RhbGUgRGF0YSBzdGF0dXMgaXMgdW5rbm93biAqLw0KPj4gI2RlZmluZSBYODZfQlVHX1JF
VEJMRUVEICAgICAgICAgICAgICBYODZfQlVHKDI3KSAvKiBDUFUgaXMgYWZmZWN0ZWQgYnkgUkVU
QmxlZWQgKi8NCj4+ICNkZWZpbmUgWDg2X0JVR19FSUJSU19QQlJTQiAgICAgICAgICAgWDg2X0JV
RygyOCkgLyogRUlCUlMgaXMgdnVsbmVyYWJsZSB0byBQb3N0IEJhcnJpZXIgUlNCIFByZWRpY3Rp
b25zICovDQo+PiArI2RlZmluZSBYODZfQlVHX0VDQU1fTU1JTyAgICAgICAgICAgICBYODZfQlVH
KDI5KSAvKiBFQ0FNIE1NSU8gaXMgYnVnZ3kgYW5kIFBJTyBpcyBwcmVmZXJhYmxlICovDQo+PiAN
Cj4+ICNlbmRpZiAvKiBfQVNNX1g4Nl9DUFVGRUFUVVJFU19IICovDQo+PiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9u
LmMNCj4+IGluZGV4IDNlNTA4ZjIzOTA5OC4uYzk0MTc1ZmEzMDRiIDEwMDY0NA0KPj4gLS0tIGEv
YXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYw0KPj4gKysrIGIvYXJjaC94ODYva2VybmVsL2Nw
dS9jb21tb24uYw0KPj4gQEAgLTEyOTksNiArMTI5OSw4IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBj
cHVfc2V0X2J1Z19iaXRzKHN0cnVjdCBjcHVpbmZvX3g4NiAqYykNCj4+IHsNCj4+ICAgICAgdTY0
IGlhMzJfY2FwID0geDg2X3JlYWRfYXJjaF9jYXBfbXNyKCk7DQo+PiANCj4+ICsgICAgICBzZXR1
cF9mb3JjZV9jcHVfYnVnKFg4Nl9CVUdfRUNBTV9NTUlPKTsNCj4+ICsNCj4+ICAgICAgLyogU2V0
IElUTEJfTVVMVElISVQgYnVnIGlmIGNwdSBpcyBub3QgaW4gdGhlIHdoaXRlbGlzdCBhbmQgbm90
IG1pdGlnYXRlZCAqLw0KPj4gICAgICBpZiAoIWNwdV9tYXRjaGVzKGNwdV92dWxuX3doaXRlbGlz
dCwgTk9fSVRMQl9NVUxUSUhJVCkgJiYNCj4+ICAgICAgICAgICEoaWEzMl9jYXAgJiBBUkNIX0NB
UF9QU0NIQU5HRV9NQ19OTykpDQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS92
bXdhcmUuYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvdm13YXJlLmMNCj4+IGluZGV4IDAyMDM5ZWMz
NTk3ZC4uODkwMzc3NjI4NGE2IDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS92
bXdhcmUuYw0KPj4gKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS92bXdhcmUuYw0KPj4gQEAgLTM4
NSw2ICszODUsOCBAQCBzdGF0aWMgdm9pZCBfX2luaXQgdm13YXJlX3NldF9jYXBhYmlsaXRpZXMo
dm9pZCkNCj4+ICAgICAgICAgICAgICBzZXR1cF9mb3JjZV9jcHVfY2FwKFg4Nl9GRUFUVVJFX1ZN
Q0FMTCk7DQo+PiAgICAgIGVsc2UgaWYgKHZtd2FyZV9oeXBlcmNhbGxfbW9kZSA9PSBDUFVJRF9W
TVdBUkVfRkVBVFVSRVNfRUNYX1ZNTUNBTEwpDQo+PiAgICAgICAgICAgICAgc2V0dXBfZm9yY2Vf
Y3B1X2NhcChYODZfRkVBVFVSRV9WTVdfVk1NQ0FMTCk7DQo+PiArDQo+PiArICAgICAgc2V0dXBf
Y2xlYXJfY3B1X2NhcChYODZfQlVHX0VDQU1fTU1JTyk7DQo+PiB9DQo+PiANCj4+IHN0YXRpYyB2
b2lkIF9faW5pdCB2bXdhcmVfcGxhdGZvcm1fc2V0dXAodm9pZCkNCj4+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9wY2kvY29tbW9uLmMgYi9hcmNoL3g4Ni9wY2kvY29tbW9uLmMNCj4+IGluZGV4IGRk
Yjc5ODYwMzIwMS4uYmM4MWNmNGMxMDE0IDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYvcGNpL2Nv
bW1vbi5jDQo+PiArKysgYi9hcmNoL3g4Ni9wY2kvY29tbW9uLmMNCj4+IEBAIC00MCw3ICs0MCw4
IEBAIGNvbnN0IHN0cnVjdCBwY2lfcmF3X29wcyAqX19yZWFkX21vc3RseSByYXdfcGNpX2V4dF9v
cHM7DQo+PiBpbnQgcmF3X3BjaV9yZWFkKHVuc2lnbmVkIGludCBkb21haW4sIHVuc2lnbmVkIGlu
dCBidXMsIHVuc2lnbmVkIGludCBkZXZmbiwNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGludCByZWcsIGludCBsZW4sIHUzMiAqdmFsKQ0KPj4gew0KPj4g
LSAgICAgIGlmIChkb21haW4gPT0gMCAmJiByZWcgPCAyNTYgJiYgcmF3X3BjaV9vcHMpDQo+PiAr
ICAgICAgaWYgKGRvbWFpbiA9PSAwICYmIHJlZyA8IDI1NiAmJiByYXdfcGNpX29wcyAmJg0KPj4g
KyAgICAgICAgICAoYm9vdF9jcHVfaGFzX2J1ZyhYODZfQlVHX0VDQU1fTU1JTykgfHwgIXJhd19w
Y2lfZXh0X29wcykpDQo+PiAgICAgICAgICAgICAgcmV0dXJuIHJhd19wY2lfb3BzLT5yZWFkKGRv
bWFpbiwgYnVzLCBkZXZmbiwgcmVnLCBsZW4sIHZhbCk7DQo+PiAgICAgIGlmIChyYXdfcGNpX2V4
dF9vcHMpDQo+PiAgICAgICAgICAgICAgcmV0dXJuIHJhd19wY2lfZXh0X29wcy0+cmVhZChkb21h
aW4sIGJ1cywgZGV2Zm4sIHJlZywgbGVuLCB2YWwpOw0KPj4gQEAgLTUwLDcgKzUxLDggQEAgaW50
IHJhd19wY2lfcmVhZCh1bnNpZ25lZCBpbnQgZG9tYWluLCB1bnNpZ25lZCBpbnQgYnVzLCB1bnNp
Z25lZCBpbnQgZGV2Zm4sDQo+PiBpbnQgcmF3X3BjaV93cml0ZSh1bnNpZ25lZCBpbnQgZG9tYWlu
LCB1bnNpZ25lZCBpbnQgYnVzLCB1bnNpZ25lZCBpbnQgZGV2Zm4sDQo+PiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgcmVnLCBpbnQgbGVuLCB1MzIgdmFs
KQ0KPj4gew0KPj4gLSAgICAgIGlmIChkb21haW4gPT0gMCAmJiByZWcgPCAyNTYgJiYgcmF3X3Bj
aV9vcHMpDQo+PiArICAgICAgaWYgKGRvbWFpbiA9PSAwICYmIHJlZyA8IDI1NiAmJiByYXdfcGNp
X29wcyAmJg0KPj4gKyAgICAgICAgICAoYm9vdF9jcHVfaGFzX2J1ZyhYODZfQlVHX0VDQU1fTU1J
TykgfHwgIXJhd19wY2lfZXh0X29wcykpDQo+PiAgICAgICAgICAgICAgcmV0dXJuIHJhd19wY2lf
b3BzLT53cml0ZShkb21haW4sIGJ1cywgZGV2Zm4sIHJlZywgbGVuLCB2YWwpOw0KPj4gICAgICBp
ZiAocmF3X3BjaV9leHRfb3BzKQ0KPj4gICAgICAgICAgICAgIHJldHVybiByYXdfcGNpX2V4dF9v
cHMtPndyaXRlKGRvbWFpbiwgYnVzLCBkZXZmbiwgcmVnLCBsZW4sIHZhbCk7DQo+IA0KPiBBbHNv
Li4uIGFueSByZWFzb24gd2UgY2FuJ3QganVzdCBzZXQgcmF3X3BjaV9vcHMgPT0gcmF3X2V4dF9w
Y2lfb3BzIGZvciB0aGUgY2FzZSB3aGVuIHRoZSBsYXR0ZXIgaXMgcHJlZmVycmVkLCBhbmQgZGlz
cGVuc2Ugd2l0aCB0aGUgY29uZGl0aW9uYWxzIGluIHRoZSB1c2UgcGF0aD8gU2ltaWxhcmx5LCBy
YXdfZXh0X3BjaV9vcHMgY291bGQgYmUgcG9pbnRlZCB0byBlcnJvciByb3V0aW5lcyBpbnN0ZWFk
IG9mIGxlZnQgYXQgTlVMTC4NCg0KSSB1bmRlcnN0b29kIGZyb20gQWpheSB0aGF0IHRoZSBpbml0
aWFsaXphdGlvbiBvZiByYXdfZXh0X3BjaV9vcHMgY2FuIGJlDQpkb25lIGFmdGVyIHRoZSBoeXBl
cnZpc29yIGluaXRpYWxpemF0aW9uIHRha2VzIHBsYWNlLCBzbyBkb2luZyB3aGF0IGV4YWN0bHkN
CndoYXQgeW91IHByb3Bvc2VkIGJ5IGlzIG5vdCBwb3NzaWJsZS4gSXQgY2FuIHByb2JhYmx5IGJl
IHJlc29sdmVkLCBidXQgSSBkbw0Kbm90IHRoaW5rIHRoZSBlbmQgcmVzdWx0IHdvdWxkIGJlIHNp
bXBsZXIgb3IgY2xlYW5lci4gSSB0aGluayB0aGF0IHRoZSDigJxidWfigJ0NCnNvbHV0aW9uIHJl
YWxseSBjb252ZXlzIHRoZSBiZWhhdmlvci4NCg0KSUlVQyBwZXJmb3JtYW5jZSB3b3VsZCBub3Qg
YmUgbm90aWNlYWJsZSBhZmZlY3RlZCBieSAyIG1vcmUgY29uZGl0aW9uYWwNCmJyYW5jaGVzLg0K
DQo=
