Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9C455A265
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 22:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiFXUOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 16:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiFXUOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 16:14:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B5A79288;
        Fri, 24 Jun 2022 13:14:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9mgvxkFRtvj5L7BSwklQnxNOqUopXvXgWIyULEXo+GHHFOZSeSq4RRtUh58qnFgbjZH2p4MWwLZC9MLzly5dkz32DoiDBLWQumFDdFE9wB/NOx75Z6CisfKXrLwb+Yi9+MtYRT2OuuP+0nrUYfd2vBaV4Qq/7rBvpNhxf8eqURNpckcvpv+b18AlHZ0wcLSoSJKg9K9GVSpDiF2sM58wtkwirs9gbwsbYLbYNOPr96izhJKqu+g9vAU/YACDscbJosy2Fkc8CxBTsgWkO/xRu8TEZB/1HoD6xAbDo70/u1wXx+bbPm2Uess3hqkXz4D8ll2rP7zeFN4KGs66EUthg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJe3vSX09NemgC2/Zmq6jZ7HSru6JOELhQvge0TXWOg=;
 b=SKIUKtfz2RmEA+wUPnjpxjETAxi9Mju3180OxHAqS+k9LUkwKFuasnpu1ckn+7QFz8OwBDFphLMeQB1kjdJBgC+XMo4Ty+9pGcHzIPX/XmaPLj9CrLHpqhyhEMuWYYVAjQJWVukyVCOvfpajybPP/UBeGMMNNzTG/54Akq7thlGooFLa+Z1OwqTfvQAxfhXAgwtehvPiSMfoonRfHD3NTmyEq52krF5tB8ElW2tLBv5gehj798xmP5lJrcS8uNJonVb/JfvfSl04COnEmiNzwV5ePHYKAHLIRAIQmrrlxUcT4KPs5Kb5BfsSvCsF6UGq+LxjFljSsaf8Sd3ewdDZ4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJe3vSX09NemgC2/Zmq6jZ7HSru6JOELhQvge0TXWOg=;
 b=2bxnAxe8vthAy0q3MFiYe7Lgjk80rPu5/3rG7XhTkUoXqopemStQlArnM/uY94sqSZOq+Gb1vdRt++khcJAUm08u5NWEWBc8sf40Gq8aJ/U5A2j3/77OZwTPfSVJUqI7eba3Hn9p4Ze2n99T2q1lYScSyP+qOn3j8AUbAdmeFyw=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB4778.namprd12.prod.outlook.com (2603:10b6:5:167::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19; Fri, 24 Jun
 2022 20:14:41 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5373.015; Fri, 24 Jun 2022
 20:14:40 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Peter Gonda <pgonda@google.com>
CC:     the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 35/49] KVM: SVM: Remove the long-lived GHCB host
 map
Thread-Topic: [PATCH Part2 v6 35/49] KVM: SVM: Remove the long-lived GHCB host
 map
Thread-Index: AQHYh9zZ2YXyQRnTe0iEslSS4jvfv61e+v3w
Date:   Fri, 24 Jun 2022 20:14:40 +0000
Message-ID: <SN6PR12MB2767CC5405E25A083E76CFFB8EB49@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <7845d453af6344d0b156493eb4555399aad78615.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6oGzqoMxN5ws9QZ9P1q5Rah92bb4V2KSYBgi0guMGUKAQ@mail.gmail.com>
In-Reply-To: <CAMkAt6oGzqoMxN5ws9QZ9P1q5Rah92bb4V2KSYBgi0guMGUKAQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-24T20:02:40Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=2ef10887-ca66-4852-ae99-7e06ef825bbb;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-24T20:14:36Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: c0bfd36f-7cab-482e-9f9e-9ab3247d8bb3
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d67ff486-0a2d-4cc7-4bfe-08da561e2bb9
x-ms-traffictypediagnostic: DM6PR12MB4778:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R6i7eoQjLTwiBITiw+fzgvfByciboAEVx/3tWCT9mXoDrafaiqoJsHO/FeAegTrZuGj/hp4LmZfvyRCxqkjF7v/a0LW4jyeH6GP59UOhUPLXd3v9XliUT+lIGbjobBZMlA+ID464iBIEKP4oltSxGR6kkhkopq/YSOxivjhIIAUyRs3L2M/Nd8vX5bJCi4N3PZ8R46KYpJgAD1AtfZGPuCcSFrUvQfrHpaqznaeABtxpqlQz+h5OeehyXnbUY1PoV2G1WW3aUJ6ldoouTS0GzDHESkpXDokaazIi96lzdhTOnxa2z8nW26ZmkMed/zYVGU3p7Eu3jKOrfYHyuWHf6Te8fRyV0EgLohxKjeetr6KzI0Z+DguIboe6f8kOMoisnoy/Qkxbc1l1r2qUq6+i4KcuOCWTnpS3gas/vi1BnPDwLQ2WzpOCNBhCuZmkq8H+6NStIb0YMf31FWwDoLM0x2oCC1458lXa/SiyJX03a61BVg0MlDOKUoeLLzCcmkM1/h/3/VD6Fv8sdHk3UhcZxHaZ7cT2qbjduSanvwu5Dn6tWgo27cLvyNgHQh5V4VnbAMR3BpD+fSAQP3sNDnzUz02u0g8h171lJw2gUa0leCmdi1R/9bXxp7LNiMGdqd3FngohuFnbwjQ/DqIeKC6OFOozORV+HUAG4mCFbZXp2MqpPoDfYYqYxNVrQPKGXwM4HGW7Anf97g2nEqGlcQLGQcrEBvgbk4RBtArSOMSlSd7cITL8HjggEsANVs3SrZJMv/wn/pm+Ox5sAZYd8fGc4kd03pHMRpGk4yCwfRN/RgwMD79A9Rs8cb11h3Zh8l/y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(38100700002)(66476007)(6506007)(66946007)(66556008)(66446008)(9686003)(186003)(86362001)(26005)(5660300002)(55016003)(316002)(7416002)(83380400001)(478600001)(54906003)(33656002)(52536014)(8936002)(2906002)(71200400001)(6916009)(7696005)(41300700001)(122000001)(76116006)(4326008)(8676002)(38070700005)(7406005)(64756008)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aU0vUFFvUjB4MVRNalRtQjh2VGprQjdLQUl3Qzl5cmh0ek9oVjIvdUM2bGY2?=
 =?utf-8?B?OVZYVmtyNUV1TWxDcG15WGNQUFJGVHVDem1ZSXJrUlZmZ2w4Nnhid3g1ZmZO?=
 =?utf-8?B?UzNpQys5ekh5OVlxM29EZ2ZCZk4rZDVwblFvbW84eGJ6d1p4YUt4NUZ3eXk2?=
 =?utf-8?B?V21CSTdDV3pGVElLZzc2a3d3NmMwUWxJdjBwNDRXblVSSG8zazJpU1FOY0Ft?=
 =?utf-8?B?djg1UG1CZGs2eVN0ZFN0Ny9CVDlDTnV2SkRBM0JIZ3ZiZTlUZUJQc3o5S2tE?=
 =?utf-8?B?R0QydkpVM3EySTZpSk1QVGlqd1A4NUdqS1FjMG5KQ3poVXJhTXhDZkplWGZy?=
 =?utf-8?B?Ylg5K3J4WHBwbG5kaElNMU9vci9TMFR3NWdWMVdxWEI1MGtwbGFXYUpCWlF5?=
 =?utf-8?B?S1ZiQ0ROQ3R2MW9wZkl3NWdwbnVVNVZtSDZBcEJBdGpGYTZaL3NudklKUnpC?=
 =?utf-8?B?b2lOc1VvSVVhMWxYWEpOUW1lNzd3eWNzYzdLb0xwM2NtV0VqcS85Y3NNNy8z?=
 =?utf-8?B?TkptRXdneTcwbmpIeVdJNzNtWDkwOXdqZ0Z4bk05SEZwdU5tTDNWWllUeUZY?=
 =?utf-8?B?S2R3ZHF6WS92Sk1XM0FEajV4TkZ1L3JFTVU2ZzJGZTQrSlBLTEptQmlYcHFQ?=
 =?utf-8?B?ZGZQLzdpZG4vcm5TcXRGRE8rY0hQS1hGaDQyaGRXNXBoc1Bua2NEQ0VuKzFz?=
 =?utf-8?B?Ymhkd2UzNlQ1eHlVd1NHYTRiOFYyZTRjTSt4Y0tqM0ZySlkvWVcvcmt5Rkdi?=
 =?utf-8?B?ZmJqSk04SjhUbEtGMEFScmxLZVZ4cmRlYlNtR1BVaTI1c1ZUdXExdGVlNTZB?=
 =?utf-8?B?SlNYM2wrTlp6cmhOeldMcWF2djlRSkx5M0ZtMk04S2lOUDhCaU9Ka1BYQ2FM?=
 =?utf-8?B?eWhDd3IyZ3FqOThmY250U3llNUpnZmcrejgyWFZIY29RTlIwaDBTQVlzMlY3?=
 =?utf-8?B?VUM3cTMzTFFZUWJTejJxYnczT2ladVdXTVNPTGVHSXZXdXFwRXBOYm01OXRQ?=
 =?utf-8?B?Qk55R29OeHcxMEMrSFB3bFZZNDI0aS9RSmxnS1R2K1JUR2pyM01RLzFZSGZH?=
 =?utf-8?B?aGErdHFjRXBpK0taM0oxYXNPRmhQanJjRERiajcrQlBPYXpSak0xUm8xNnFh?=
 =?utf-8?B?TDZIN1Z3R0QxVUhkR2dIM1pENjYxbHZGdzM3UmV0enQ4NEdQK1ZVZHVXdHlp?=
 =?utf-8?B?dVdYaDVMTFVycWU3a3gxbGZYWDdKUFA5N3ltQWh3bHR0Qi94dGdDdUNKT2Fa?=
 =?utf-8?B?RTVOUkx1MkFSMjN4TElJWnMzVFh0eTg5T0ZFUHdhMGhHTzRnSmdCUUlCc1FB?=
 =?utf-8?B?UXc4MjZmbVdSSzl2MjE2K28zS3dCSFBSZmVlWklhbTNIMEhvdG93NkFqWFU3?=
 =?utf-8?B?Z2c2UmcxQ2xKeEpFT25wUDB4Qm1xb2NMM1pMY2FpWTJzY21Tb2tjbmw3TUdC?=
 =?utf-8?B?dFZzaHFqZkt0bE9RcmRDV2R0MW41blVJUHlCTHFCM1lUVitkQklYbTd1QjVu?=
 =?utf-8?B?R29oeDBQRVVDSWFwWEE5R2NUNCt1cjBMUFNXVGk3V3h6WC9WYm9LeGY2MkxO?=
 =?utf-8?B?UXliRE9Ua3pyUVhHVFpMZDM3bGJYTm1Zc2swZW41by9ESFF4cGwwdE01eThG?=
 =?utf-8?B?L216OEVIQXo3eWFiQXNuZ0tXdUJ3MmVWaitoTTA5emlWU3Jvb0txYVJ2Y2Vj?=
 =?utf-8?B?SXA2ZkxqQ2pQbkR3QXh4cUQvWnc4eXhjNXNlVDFsMlFSZ2lXQ05WcEc2bnhB?=
 =?utf-8?B?RjdiZDg4UVdQUGVqK0R6OXFoSUxJYnh5Z25xSUdKM3JhOURiRkxvQzA5aW1y?=
 =?utf-8?B?ek9GZ2VRZ0VhNU81TURaSUNYZ1U5Y1RxMG1sc29FQnFCNEZLcWVJNzJYSi9O?=
 =?utf-8?B?Q0RKM2RaTlV0cXJydXpKSjlDZXM4eGQ4TXYrRXFaVHdLbVhqQlZndkxiRWRS?=
 =?utf-8?B?S2IzRDBmQ3NVcnFQb2hZKzJ4bEZUeFVtSFZReXlESGxMVXNrekRVMHFNNzFO?=
 =?utf-8?B?WUoxTDQwejNxSE5pQnltbmRLcFE5c3FXRTdNNGpoN0g1ak5nUW1zN3A0cys2?=
 =?utf-8?B?RUVzcXk2QnUrcGd3cU02VGJwQWxsT05rSEc4R3lVd1VHd05qbEJiT2xqLzJ4?=
 =?utf-8?Q?95zg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d67ff486-0a2d-4cc7-4bfe-08da561e2bb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2022 20:14:40.8605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KyOSyRjf1y//RPZWDt8Ca5L1ydjWHXNig0f1b7o/R+ufes2OttlylGjREzER2fqcDroAYZxg5n22Nr426HB24w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4778
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhlbGxvIFBldGVyLA0KDQo+PiBG
cm9tOiBCcmlqZXNoIFNpbmdoIDxicmlqZXNoLnNpbmdoQGFtZC5jb20+DQo+Pg0KPj4gT24gVk1H
RVhJVCwgc2V2X2hhbmRsZV92bWdleGl0KCkgY3JlYXRlcyBhIGhvc3QgbWFwcGluZyBmb3IgdGhl
IEdIQ0IgDQo+PiBHUEEsIGFuZCB1bm1hcHMgaXQganVzdCBiZWZvcmUgVk0tZW50cnkuIFRoaXMg
bG9uZy1saXZlZCBHSENCIG1hcCBpcyANCj4+IHVzZWQgYnkgdGhlIFZNR0VYSVQgaGFuZGxlciB0
aHJvdWdoIGFjY2Vzc29ycyBzdWNoIGFzIGdoY2Jfe3NldF9nZXR9X3h4eCgpLg0KPj4NCj4+IEEg
bG9uZy1saXZlZCBHSENCIG1hcCBjYW4gY2F1c2UgaXNzdWUgd2hlbiBTRVYtU05QIGlzIGVuYWJs
ZWQuIFdoZW4gDQo+PiBTRVYtU05QIGlzIGVuYWJsZWQgdGhlIG1hcHBlZCBHUEEgbmVlZHMgdG8g
YmUgcHJvdGVjdGVkIGFnYWluc3QgYSBwYWdlIA0KPj4gc3RhdGUgY2hhbmdlLg0KPj4NCj4+IFRv
IGVsaW1pbmF0ZSB0aGUgbG9uZy1saXZlZCBHSENCIG1hcHBpbmcsIHVwZGF0ZSB0aGUgR0hDQiBz
eW5jIA0KPj4gb3BlcmF0aW9ucyB0byBleHBsaWNpdGx5IG1hcCB0aGUgR0hDQiBiZWZvcmUgYWNj
ZXNzIGFuZCB1bm1hcCBpdCBhZnRlciANCj4+IGFjY2VzcyBpcyBjb21wbGV0ZS4gVGhpcyByZXF1
aXJlcyB0aGF0IHRoZSBzZXR0aW5nIG9mIHRoZSBHSENCcyANCj4+IHN3X2V4aXRfaW5mb197MSwy
fSBmaWVsZHMgYmUgZG9uZSBkdXJpbmcgc2V2X2VzX3N5bmNfdG9fZ2hjYigpLCBzbyANCj4+IGNy
ZWF0ZSB0d28gbmV3IGZpZWxkcyBpbiB0aGUgdmNwdV9zdm0gc3RydWN0IHRvIGhvbGQgdGhlc2Ug
dmFsdWVzIHdoZW4gDQo+PiByZXF1aXJlZCB0byBiZSBzZXQgb3V0c2lkZSBvZiB0aGUgR0hDQiBt
YXBwaW5nLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEJyaWplc2ggU2luZ2ggPGJyaWplc2guc2lu
Z2hAYW1kLmNvbT4NCj4+IC0tLQ0KPj4gIGFyY2gveDg2L2t2bS9zdm0vc2V2LmMgfCAxMzEgDQo+
PiArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KPj4gIGFyY2gveDg2
L2t2bS9zdm0vc3ZtLmMgfCAgMTIgKystLQ0KPj4gIGFyY2gveDg2L2t2bS9zdm0vc3ZtLmggfCAg
MjQgKysrKysrKy0NCj4+ICAzIGZpbGVzIGNoYW5nZWQsIDExMSBpbnNlcnRpb25zKCspLCA1NiBk
ZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS9zZXYuYyBi
L2FyY2gveDg2L2t2bS9zdm0vc2V2LmMgaW5kZXggDQo+PiAwMWVhMjU3ZTE3ZDYuLmM3MGYzZjdl
MDZhOCAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0vc2V2LmMNCj4+ICsrKyBiL2Fy
Y2gveDg2L2t2bS9zdm0vc2V2LmMNCj4+IEBAIC0yODIzLDE1ICsyODIzLDQwIEBAIHZvaWQgc2V2
X2ZyZWVfdmNwdShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiAgICAgICAgIGt2ZnJlZShzdm0t
PnNldl9lcy5naGNiX3NhKTsNCj4+IH0NCj4+DQo+PiArc3RhdGljIGlubGluZSBpbnQgc3ZtX21h
cF9naGNiKHN0cnVjdCB2Y3B1X3N2bSAqc3ZtLCBzdHJ1Y3QgDQo+PiAra3ZtX2hvc3RfbWFwICpt
YXApIHsNCj4+ICsgICAgICAgc3RydWN0IHZtY2JfY29udHJvbF9hcmVhICpjb250cm9sID0gJnN2
bS0+dm1jYi0+Y29udHJvbDsNCj4+ICsgICAgICAgdTY0IGdmbiA9IGdwYV90b19nZm4oY29udHJv
bC0+Z2hjYl9ncGEpOw0KPj4gKw0KPj4gKyAgICAgICBpZiAoa3ZtX3ZjcHVfbWFwKCZzdm0tPnZj
cHUsIGdmbiwgbWFwKSkgew0KPj4gKyAgICAgICAgICAgICAgIC8qIFVuYWJsZSB0byBtYXAgR0hD
QiBmcm9tIGd1ZXN0ICovDQo+PiArICAgICAgICAgICAgICAgcHJfZXJyKCJlcnJvciBtYXBwaW5n
IEdIQ0IgR0ZOIFslI2xseF0gZnJvbSBndWVzdFxuIiwgZ2ZuKTsNCj4+ICsgICAgICAgICAgICAg
ICByZXR1cm4gLUVGQVVMVDsNCj4+ICsgICAgICAgfQ0KPj4gKw0KPj4gKyAgICAgICByZXR1cm4g
MDsNCj4+ICt9DQoNCj5UaGVyZSBpcyBhIHBlcmYgY29zdCB0byB0aGlzIHN1Z2dlc3Rpb24gYnV0
IGl0IG1pZ2h0IG1ha2UgYWNjZXNzaW5nIHRoZSBHSENCIHNhZmVyIGZvciBLVk0uIEhhdmUgeW91
IHRob3VnaHQgYWJvdXQganVzdCB1c2luZw0KPmt2bV9yZWFkX2d1ZXN0KCkgb3IgY29weV9mcm9t
X3VzZXIoKSB0byBmdWxseSBjb3B5IG91dCB0aGUgR0NIQiBpbnRvIGEgS1ZNIG93bmVkIGJ1ZmZl
ciwgdGhlbiBjb3B5aW5nIGl0IGJhY2sgYmVmb3JlIHRoZSBWTVJVTi4gVGhhdCB3YXkgdGhlIEtW
TSBkb2Vzbid0IG5lZWQgdG8gZ3VhcmQgYWdhaW5zdCBwYWdlX3N0YXRlX2NoYW5nZXMgb24gdGhl
IEdIQ0JzLCB0aGF0IGNvdWxkIGJlIGEgcGVyZiA/PmltcHJvdmVtZW50IGluIGEgZm9sbG93IHVw
Lg0KDQpBbG9uZyB3aXRoIHRoZSBwZXJmb3JtYW5jZSBjb3N0cyB5b3UgbWVudGlvbmVkLCB0aGUg
bWFpbiBjb25jZXJuIGhlcmUgd2lsbCBiZSB0aGUgR0hDQiB3cml0ZS1iYWNrIHBhdGggKGNvcHlp
bmcgaXQgYmFjaykgYmVmb3JlIFZNUlVOOiB0aGlzIHdpbGwgYWdhaW4gaGl0IHRoZSBpc3N1ZSB3
ZSBoYXZlIGN1cnJlbnRseSB3aXRoIA0Ka3ZtX3dyaXRlX2d1ZXN0KCkgLyBjb3B5X3RvX3VzZXIo
KSwgd2hlbiB3ZSB1c2UgaXQgdG8gc3luYyB0aGUgc2NyYXRjaCBidWZmZXIgYmFjayB0byBHSENC
LiBUaGlzIGNhbiBmYWlsIGlmIGd1ZXN0IFJBTSBpcyBtYXBwZWQgdXNpbmcgaHVnZS1wYWdlKHMp
IGFuZCBSTVAgaXMgNEsuIFBsZWFzZSByZWZlciB0byB0aGUgcGF0Y2gvZml4DQptZW50aW9uZWQg
YmVsb3csIGt2bV93cml0ZV9ndWVzdCgpIHBvdGVudGlhbGx5IGNhbiBmYWlsIGJlZm9yZSBWTVJV
TiBpbiBjYXNlIG9mIFNOUCA6DQoNCmNvbW1pdCA5NGVkODc4YzI2Njk1MzJlYmFlOGViOWI0NTAz
ZjE5YWEzM2NkN2FhDQpBdXRob3I6IEFzaGlzaCBLYWxyYSA8YXNoaXNoLmthbHJhQGFtZC5jb20+
DQpEYXRlOiAgIE1vbiBKdW4gNiAyMjoyODowMSAyMDIyICswMDAwDQogICAgICAgIA0KICAgIEtW
TTogU1ZNOiBTeW5jIHRoZSBHSENCIHNjcmF0Y2ggYnVmZmVyIHVzaW5nIGFscmVhZHkgbWFwcGVk
IGdoY2INCiAgICAgICAgDQogICAgVXNpbmcga3ZtX3dyaXRlX2d1ZXN0KCkgdG8gc3luYyB0aGUg
R0hDQiBzY3JhdGNoIGJ1ZmZlciBjYW4gZmFpbA0KICAgIGR1ZSB0byBob3N0IG1hcHBpbmcgYmVp
bmcgMk0sIGJ1dCBSTVAgYmVpbmcgNEsuIFRoZSBwYWdlIGZhdWx0IGhhbmRsaW5nDQogICAgaW4g
ZG9fdXNlcl9hZGRyX2ZhdWx0KCkgZmFpbHMgdG8gc3BsaXQgdGhlIDJNIHBhZ2UgdG8gaGFuZGxl
IFJNUCBmYXVsdCBkdWUNCiAgICB0byBpdCBiZWluZyBjYWxsZWQgaGVyZSBpbiBhIG5vbi1wcmVl
bXB0aWJsZSBjb250ZXh0LiBJbnN0ZWFkIHVzZQ0KICAgIHRoZSBhbHJlYWR5IGtlcm5lbCBtYXBw
ZWQgZ2hjYiB0byBzeW5jIHRoZSBzY3JhdGNoIGJ1ZmZlciB3aGVuIHRoZQ0KICAgIHNjcmF0Y2gg
YnVmZmVyIGlzIGNvbnRhaW5lZCB3aXRoaW4gdGhlIEdIQ0IuDQogICAgICAgIA0KVGhhbmtzLA0K
QXNoaXNoDQoNCj5TaW5jZSB3ZSBjYW5ub3QgdW5tYXAgR0hDQnMgSSBkb24ndCB0aGluayBVUE0g
d2lsbCBoZWxwIGhlcmUgc28gd2UgcHJvYmFibHkgd2FudCB0byBtYWtlIHRoZXNlIHBhdGNoZXMg
c2FmZSBhZ2FpbnN0IG1hbGljaW91cyBndWVzdHMgbWFraW5nIEdIQ0JzIHByaXZhdGUuIEJ1dCBt
YXliZSBVUE0gZG9lcyBoZWxwPw0K
