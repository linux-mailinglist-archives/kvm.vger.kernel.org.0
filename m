Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE25E62B2A4
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 06:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiKPFTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 00:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKPFT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 00:19:28 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2047.outbound.protection.outlook.com [40.107.113.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FF12F394;
        Tue, 15 Nov 2022 21:19:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9RngyUNk45cdtwfPjc7kUTv0eVmq/sDo0w12Lnml5ZFn19ziq7aE4HZcS0wMWW7gogp+PIBbby3EyhXaH5e/odmDDe6D4spIYn5OGkIIn3UKMVs3ChkRxZT9lWRFjsh4cgQZHXZeWMJK8YotaQFfrozCvDrmMG/DnsCPxpNKJf9UizXJRcPLL+jLMo8Q8kNrCUgFYlnxC+2Yzecu4xv0bOPQS5ZWAJoSmwRESK6NOa22YlL3TstgrX21FCNyDWn+oKiEm6FzPvGVMPnixzWb/JVmrh8uw/dQJh3Wv+Xd6CNyyrNZx+3iPCOIQPZsIm+owX9+juT3IVQVxaNfckLzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTD/sgtgdd5mM+EbSm0O+GAEvaG6PtSZqpPNNqyhr3M=;
 b=bEGFl/kerhAMh1fiGGZoF5yJVXTihaan/32l73up9Kjc/m1TZ5X2FPJOTeNpwNgwg0mAgEQJsax5FkoqkG8BETACjQv73qm9SnNY+SzbH18fGvGiMeXl6swtUM+ftdeDhHoKyLBYJsjtAVEfh6dpT4s2kEgK9oN/W3NZ+zVeDCS29vQ+9JTbWbuJnk1Io5MOmlTouOpLjAbdc1v9BKU0E/3xc7gcxR/FMv+j307M16qFluB5pLy7ketiLzInlClPVcO9iKFz5xIlYTRRdNDsX+W64T+85m78cCdkEeWL6TdBEdvqdGOdEtYixmTat9Sig0walXXPUIdvcyUYbEt6iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTD/sgtgdd5mM+EbSm0O+GAEvaG6PtSZqpPNNqyhr3M=;
 b=aoKwHJBJlHAtn9Oqz4iqlJUljQF38RwnDRhwtyfC/DB+a098qRq8bT6XK3lxaqD3KswbrybpMR3X+mF87L/g8jlQrRjRvqkZZjBs4YcKg/OGl+jp1PKhrO78d61BvMgscTRdF9aIO49Vzl0j/iQwzFbWh3wJKbSjXikxq8rEkNU=
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com (2603:1096:400:13c::10)
 by TYAPR01MB5466.jpnprd01.prod.outlook.com (2603:1096:404:803b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 05:19:25 +0000
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::9f34:8082:cd2f:589c]) by TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::9f34:8082:cd2f:589c%8]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 05:19:24 +0000
From:   =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPo+OAgOebtOS5nyk=?= 
        <naoya.horiguchi@nec.com>
To:     Vlastimil Babka <vbabka@suse.cz>
CC:     "Kalra, Ashish" <ashish.kalra@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Thread-Topic: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Thread-Index: AQHY+QUKixDhQnL6BEGWafa4FSvWmK5BA+sA
Date:   Wed, 16 Nov 2022 05:19:24 +0000
Message-ID: <20221116051920.GA821796@hori.linux.bs1.fc.nec.co.jp>
References: <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic> <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic> <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic> <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
In-Reply-To: <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nec.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYWPR01MB8591:EE_|TYAPR01MB5466:EE_
x-ms-office365-filtering-correlation-id: e0f2ca86-8425-468b-40d9-08dac792206e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WePBDjPklTOjhAtW9ZiO61uRvqdNYX/scbnHIoOBa+1SfMe2zKm9JuRZEOUIwnRijWz6/3UdpcEDBpmAB5+gW6gJTYBeaaqQDy3oGmCZORuR1KcmAEyaF6BQznqSitzzOJaslIbMcnyBIWmlLBlZuzIjHikSlCJ2bYL+0lKSXnf8YXRe1XoQSOo+5ESzQobBE2qp6YhrtVieBBLNTpQ0tp3mzMCaeWc8Jplc9Hn0YQet3iuQxufJT6EZ6CASTyWE69/NLbgPLxKi3PicvXqJGIcMjwzQOVBGyEbpZ3Ehwcr56K5oJKvVZPG4JzuLWbAcbl7QTFgBo99EqYdQlWkvfsu1U0pIiVdZvbMwjpoBLqrP+FlbE3hAM0NfeXXKZin8+/LBopywyrH5T/k8tbaIKfQNLJFYntPNlmVjMasfIu+vh66MOhgGhwZmgmsLy0nNDSKUyHbesJkkRXRa0FreJUjJdD5VeQEvojt6zYAaPzZRm6aEGeZDQRFHn2vkTcAWpzOsEdh9BXCl1P5s6wJtNJz8NCCfIcvNXEhrLaXEPpYsb7LUYToRWKwWNPzjFqhlpd2A3irNbDGjO/icopLfY7xeuOn3DjHLr2LBZ3Mm5Kbq6uxbMd3/H4UhCBs34M+S/PE/6xwLUdju+dTS4c2BwGCIYHy+5erN2RVBvuc2P78vDksupxOxq6rZ26auGptTSeEDwPI7Hhyv0mHIvbFdQqz8cE0ArbW0eY7r0XuFEzz36epC7wDWrozYwvE+/LSZ9+WXU9vM9lnY6TR3IfxKi+TJh4AbX9Scvk5zi5UHLOs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB8591.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199015)(86362001)(83380400001)(33656002)(8936002)(85182001)(66476007)(66446008)(66556008)(76116006)(41300700001)(66946007)(64756008)(186003)(8676002)(4326008)(5660300002)(26005)(966005)(1076003)(7416002)(7406005)(6512007)(316002)(9686003)(71200400001)(478600001)(6486002)(6916009)(53546011)(54906003)(38100700002)(82960400001)(6506007)(38070700005)(122000001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3BPSm5EYllETTB4QUFYcWUvYklWemxTc0RwN2tyKzlxejhrUUlNWjROaWRF?=
 =?utf-8?B?VEZFaXpVdDVsQ0U3NkhyUGdrdE1uM2d4T1pKcVFRcnFUTHFNemJSVU1pNjEr?=
 =?utf-8?B?YkVVajA3cDV6aVlxcmdSWmJISFdnUWJvVEoybk9RMGsxbS84Y2d6YjBYM3VB?=
 =?utf-8?B?TGxWbFNaMkkyWjdUMGNLUCtyQVIvK2lya1N5RFVSVWlDdUV5OW4zcWUrdGpp?=
 =?utf-8?B?RHpqcVJieGNlQ2FZSlJTRzFxY0FLeFRVeXE2TThUNVpGUUw3QktBM2lVaXNk?=
 =?utf-8?B?bWh1eXJVcnk3eXpsbzZQVU5uVGorbERicElYZGJFU0JFRWNnZUg0M2E4REln?=
 =?utf-8?B?L056S2xzNTJ0K0JWT3dkeG1PYkxDY3grbCt6WDN1bEhVQWs4UmxERlpydjNP?=
 =?utf-8?B?UFRCWm1RNEJuWmZPZmkyeG9QcTRoRVRSUnQ2aUpPRkNoakdJTkxyQ3hvSER2?=
 =?utf-8?B?akpNd1l0bkZscUxtUHJWYXgwdVZESmtYNlVVV0hpcG5TOHV2SVQwSWx5bitR?=
 =?utf-8?B?bXhHYng2LzZvdFYramhVMnV2b0M2cks4YUpDWHgzSTE4Qk94R3RlR0g0TFd1?=
 =?utf-8?B?N3N5aHpXOUNjUjV6cUliOTRZOVlFdlc0bTU2Y0ZGVUt5REp0TWY0bkJSc0M5?=
 =?utf-8?B?bmhKR1ArUU0vcStSODNZMG1Pcmh5dmNDUW5qRTNJWWJhNExYdm9JNlhOU0N3?=
 =?utf-8?B?b3VOYlEvU0VoRFhNOWxIbEowanZ2K0Y3MStxdEUvVjAzMUY3d0FqKzFPcDZy?=
 =?utf-8?B?Kzk3LzZOUFZHZGViR0hyYU9EOXBESTNZN1NkR2xvMERuTW5CZ05vU00zMG1i?=
 =?utf-8?B?NSt4ZUhDMlNQQk9nMTkrWFdnaGZHZ3FnaGNueU5iY2FYK2tMK0VNUmdnejNm?=
 =?utf-8?B?cFJnWGd6K2hFWDU2ZU0wbjhxRG5WV1c3Qm5MQytpdCtmWlBoOFBqZ3Z0QXBm?=
 =?utf-8?B?S2l3dlYxSG5lOGlzcTlBaHJ0c0pIYXYvSkp5a2RmQzR2UDVXZWYrcDFXY3Ir?=
 =?utf-8?B?RS8rYW9TRXYrVTFIRmZwNko2Sk9IM1l0QUhGRENjY3ArWnJ0UmRJc1h6ZlR5?=
 =?utf-8?B?NkduQnpKNTI4Njd0RVczRnRPZUFCZS9UbUN6bCtsRlNKb2lHWXI2angwSFdm?=
 =?utf-8?B?cTd2aUxKRWI3dXI1ZE90NTIzZFRucXZOcmZtVWZpZ2NXZVB1YnBjZTJZMnJo?=
 =?utf-8?B?Z1VoaXlGZGhjQkJqd3I5OXB0K3R5S2twWCtZa1huTEMwd3ZvcmNXb1V1M3px?=
 =?utf-8?B?Q3Z0ZjRFV09yZ0M5ZFlFZmJUWE5MUWtjd0tTeDNFc2RqbU1VTzl0V1lZcGtn?=
 =?utf-8?B?aU5pY2FWMGUzSmhIT3l1RVdOdkhvS1J6OThiM25nL1V0RzFBaTVPYlZJMzln?=
 =?utf-8?B?NmxXYnF5M01uaDhqWGRKdGlIWWg2SXV5YTE1ODVxUXkvRG1xdG5rRjZjN1NZ?=
 =?utf-8?B?eDB2TEYrMXhaNVJtVGV0QkZpTTZUZGlpMFl1QllhNkgvS1VlSzdSN0xRWi9G?=
 =?utf-8?B?K3VDUDFpODJady9hMHVIOFRJTlIvNFRpYmZBRkJYeHo2d0lSQjl6VGRLZnpR?=
 =?utf-8?B?ckZXRDZ1TGg0QjJJM2JtQmNYTmNHUmFrM1NqcHZSUEFHZDlHbmEwejdMVVlG?=
 =?utf-8?B?VGRrUTNHMEFtNVhPTC84b3pFclJCV3VQMlNVb3ZVdFNlalNhN3dRUS9yMTJm?=
 =?utf-8?B?Y1hKa3AvRGtHaHUwazhXUDNYMnBXSlFTeFJnUktlOWs3NkZxcUdId0k4aUx5?=
 =?utf-8?B?a3J3OVBMNllFZFJPMmNpTjRmbUtCUWl3Q2JBUnNscGdIbGl6YjZxQVBnNTE0?=
 =?utf-8?B?UkFVdDF4bHNVdUV5VUhrMjVlSW1FVmtvUU5aT3NPamZyaWlpRVRJQlZGMHpB?=
 =?utf-8?B?RmRrNDJWQjVCQjRVNG9mL2EwOUZxWkU2aGZZOCtDcE1Pd2dPVVc1dithaDhx?=
 =?utf-8?B?cXdoSnhTZ0xoWURxaG5xQ3VqQjFJTVVXWFRUbHRBdnlMSkJ2THFPVzE3cnZt?=
 =?utf-8?B?UkZ3RTVyRjJYN2xsWGVZTW1WZlJrMkFUbG1mVmxiZG5nMjE0V1RRUHo1WDB6?=
 =?utf-8?B?TUg0RjQzWWpLRlBMZFJ4dlFNN2x3TExQN3doZVJBbTdjTERESUhOUTVBSmtR?=
 =?utf-8?B?RGh3N2NKTmp3TmRiU2I3VkVwWkFqbGJWM1Q2OFFiV0pNTjVEdjVCVytiKzN0?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1A23C77B138174DA0754F11C16E0B4C@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB8591.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f2ca86-8425-468b-40d9-08dac792206e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 05:19:24.9126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 724NT/PLWbvZSHPKN9rfyrfi09JI76q/WgisynY45LhxwsXZhpMeDddK4eEHeJ1SLE92O5ZNFNZTt5fHYGkzVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5466
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCBOb3YgMTUsIDIwMjIgYXQgMDQ6MTQ6NDJQTSArMDEwMCwgVmxhc3RpbWlsIEJhYmth
IHdyb3RlOg0KPiBDYydpbmcgbWVtb3J5IGZhaWx1cmUgZm9sa3MsIHRoZSBiZWlubmluZyBvZiB0
aGlzIHN1YnRocmVhZCBpcyBoZXJlOg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxs
LzNhNTE4NDBmNmE4MGM4N2IzOTYzMmRjNzI4ZGJkOWI1ZGQ0NDRjZDcuMTY1NTc2MTYyNy5naXQu
YXNoaXNoLmthbHJhQGFtZC5jb20vDQo+IA0KPiBPbiAxMS8xNS8yMiAwMDozNiwgS2FscmEsIEFz
aGlzaCB3cm90ZToNCj4gPiBIZWxsbyBCb3JpcywNCj4gPiANCj4gPiBPbiAxMS8yLzIwMjIgNjoy
MiBBTSwgQm9yaXNsYXYgUGV0a292IHdyb3RlOg0KPiA+PiBPbiBNb24sIE9jdCAzMSwgMjAyMiBh
dCAwNDo1ODozOFBNIC0wNTAwLCBLYWxyYSwgQXNoaXNoIHdyb3RlOg0KPiA+Pj4gwqDCoMKgwqDC
oCBpZiAoc25wX2xvb2t1cF9ybXBlbnRyeShwZm4sICZybXBfbGV2ZWwpKSB7DQo+ID4+PiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgZG9fc2lnYnVzKHJlZ3MsIGVycm9yX2NvZGUsIGFkZHJlc3Ms
IFZNX0ZBVUxUX1NJR0JVUyk7DQo+ID4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJu
IFJNUF9QRl9SRVRSWTsNCj4gPj4NCj4gPj4gRG9lcyB0aGlzIGlzc3VlIHNvbWUgaGFsZndheSB1
bmRlcnN0YW5kYWJsZSBlcnJvciBtZXNzYWdlIHdoeSB0aGUNCj4gPj4gcHJvY2VzcyBnb3Qga2ls
bGVkPw0KPiA+Pg0KPiA+Pj4gV2lsbCBsb29rIGF0IGFkZGluZyBvdXIgb3duIHJlY292ZXJ5IGZ1
bmN0aW9uIGZvciB0aGUgc2FtZSwgYnV0IHRoYXQgd2lsbA0KPiA+Pj4gYWdhaW4gbWFyayB0aGUg
cGFnZXMgYXMgcG9pc29uZWQsIHJpZ2h0ID8NCj4gPj4NCj4gPj4gV2VsbCwgbm90IHBvaXNvbmVk
IGJ1dCBQR19vZmZsaW1pdHMgb3Igd2hhdGV2ZXIgdGhlIG1tIGZvbGtzIGFncmVlIHVwb24uDQo+
ID4+IFNlbWFudGljYWxseSwgaXQnbGwgYmUgaGFuZGxlZCB0aGUgc2FtZSB3YXksIG9mYy4NCj4g
PiANCj4gPiBBZGRlZCBhIG5ldyBQR19vZmZsaW1pdHMgZmxhZyBhbmQgYSBzaW1wbGUgY29ycmVz
cG9uZGluZyBoYW5kbGVyIGZvciBpdC4NCj4gDQo+IE9uZSB0aGluZyBpcywgdGhlcmUncyBub3Qg
ZW5vdWdoIHBhZ2UgZmxhZ3MgdG8gYmUgYWRkaW5nIG1vcmUgKGV4Y2VwdA0KPiBhbGlhc2VzIGZv
ciBleGlzdGluZykgZm9yIGNhc2VzIHRoYXQgY2FuIGF2b2lkIGl0LCBidXQgYXMgQm9yaXMgc2F5
cywgaWYNCj4gdXNpbmcgYWxpYXMgdG8gUEdfaHdwb2lzb24gaXQgZGVwZW5kcyB3aGF0IHdpbGwg
YmVjb21lIGNvbmZ1c2VkIHdpdGggdGhlDQo+IGFjdHVhbCBod3BvaXNvbi4NCg0KSSBhZ3JlZSB3
aXRoIHRoaXMuIEp1c3QgZGVmaW5pbmcgUEdfb2ZmbGltaXRzIGFzIGFuIGFsaWFzIG9mIFBHX2h3
cG9pc29uDQpjb3VsZCBicmVhayBjdXJyZW50IGh3cG9pc29uIHdvcmtsb2FkLiAgU28gaWYgeW91
IGZpbmFsbHkgZGVjaWRlIHRvIGdvDQpmb3J3YXJkIGluIHRoaXMgZGlyZWN0aW9uLCB5b3UgbWF5
IGFzIHdlbGwgaGF2ZSBzb21lIGluZGljYXRvciB0bw0KZGlzdGluZ3Vpc2ggdGhlIG5ldyBraW5k
IG9mIGxlYWtlZCBwYWdlcyBmcm9tIGh3cG9pc29uZWQgcGFnZXMuDQoNCkkgZG9uJ3QgcmVtZW1i
ZXIgZXhhY3QgdGhyZWFkLCBidXQgSSd2ZSByZWFkIHNvbWVvbmUgd3JpdGluZyBhYm91dCBzaW1p
bGFyDQpraW5kIG9mIHN1Z2dlc3Rpb24gb2YgdXNpbmcgbWVtb3J5X2ZhaWx1cmUoKSB0byBtYWtl
IHBhZ2VzIGluYWNjZXNzaWJsZSBpbg0Kbm9uLW1lbW9yeSBlcnJvciB1c2VjYXNlLiAgSSBmZWVs
IHRoYXQgaXQgY291bGQgYmUgcG9zc2libGUgdG8gZ2VuZXJhbGl6ZQ0KbWVtb3J5X2ZhaWx1cmUo
KSBhcyBnZW5lcmFsLXB1cnBvc2UgcGFnZSBvZmZsaW5pbmcgKGJ5IHJlbmFtaW5nIGl0IHdpdGgN
CmhhcmRfb2ZmbGluZV9wYWdlKCkgYW5kIG1ha2luZyBtZW1vcnlfZmFpbHVyZSgpIG9uZSBvZiB0
aGUgdXNlciBvZiBpdCkuDQoNClRoYW5rcywNCk5hb3lhIEhvcmlndWNoaQ==
