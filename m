Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE33354B587
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 18:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356426AbiFNQLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 12:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbiFNQLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 12:11:39 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9D42B1B8;
        Tue, 14 Jun 2022 09:11:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V41ByM+wt6XdBK1zsqCEaraZWICwywaScDjlBSwUpRutE+vARaCU3W3/KQgsFObCCSpf1rR0gygCY67cq15ru3IsJCOAwTVFOnVvy8xWk3Homh/lPbyRVt6QN/Pr/l7bxvZn0Bj+jxzaHYB+je2ZozPflJXq1ep076hZCHMplmieO/fp2va0f9RTBkVX0Dg+Ipt5uafsz8i/hWX6YkiNYYxtQz5lMmn8PJ+NiX3zHJqvqgZtVD5qXfNkn2n6h/WkjYrapES3zY1YVWV4Sn2CI9GXw+tvwO5towjLT7hx5YRc9WV/TAJZyNjT9ddyDKoDidsETQ9EH6nEScLwXGMKyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H5xDx09h+rP55/l7Y/Oq8Ru/n9jvVNVfMBstGaxlSEs=;
 b=Fk6BjhmkVcxcB3GStsaD6gyWX2exiHXzmA9kbaUWxubfDj5cpUtda+suFGi3yv1rT0nrdJQ4+aXBQy9k9rfRAVYGo1uGPAdbNYrvsg2uY5sQCJW886FMYR7dOE/3Ds6LpqkTWIs8ElvCbT1D4Sp4NJl9u3vNX6HKJQKgzG8WR/Hqx72hkk4GCMHb50zl60t2nuqUCN9sQr5tD38jdvnaer/3sloZuL85RLoYoWdOA15bZfkDqz2flvFKQhDS+krHeMiHqsvIEFvOt//9trKVfanp5IymThXJ0SGcqKvQxBSkY5a2VNWDE9XNwxfgMlFkQ9mzoHaro469iDWTNvZ/Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5xDx09h+rP55/l7Y/Oq8Ru/n9jvVNVfMBstGaxlSEs=;
 b=1g9F6eEqMPDJBEuvrCPC4ZwlNno48xCAnbW1MpTE19g7l4w55mUqk/7iYNrDzz/A1I0g94HmGk/Toie+52D5ckhLmDEg+UHrIXD/yW/h6ZEEOKPpTPtG3h9Bg0KVx3yomMat6T8E5p6F3Xu9lNWSDDMqWpzBbkajAbcTdyeQDfU=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2720.namprd12.prod.outlook.com (2603:10b6:805:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Tue, 14 Jun
 2022 16:11:35 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93%2]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 16:11:35 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Peter Gonda <pgonda@google.com>
CC:     Alper Gun <alpergun@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>,
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
        Wanpeng Li <wanpengli@tencent.com>,
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
        Pavan Kumar Paluri <papaluri@amd.com>
Subject: RE: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
Thread-Topic: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
Thread-Index: AQHYf2hrEdThX7LMOkaW6abY0uhVGK1NpC+AgABZDQCAAA1FAIABAAmAgAAIC4A=
Date:   Tue, 14 Jun 2022 16:11:35 +0000
Message-ID: <SN6PR12MB27671CDFDAA1E62AD49EC6C68EAA9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-24-brijesh.singh@amd.com>
 <CABpDEukdrEbXjOF_QuZqUMQndYx=zVM4s2o-oN_wb2L_HCrONg@mail.gmail.com>
 <1cadca0d-c3dc-68ed-075f-f88ccb0ccc0a@amd.com>
 <CABpDEun0rjrNVCGZDXd8SO3tfZi-2ku3mit2XMGLwCsijbF9tg@mail.gmail.com>
 <ee1a829f-9a89-e447-d182-877d4033c96a@amd.com>
 <CAMkAt6q3otA3n-daFfEBP7kzD+ucMQjP=3bX1PkuAUFrH9epUQ@mail.gmail.com>
In-Reply-To: <CAMkAt6q3otA3n-daFfEBP7kzD+ucMQjP=3bX1PkuAUFrH9epUQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-14T16:06:26Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=09f886f0-1bc6-4da2-a3e7-0ba8d62741b7;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-14T16:11:33Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 7df0138a-a3d1-4f07-b6b0-72779db877bd
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6a5fc02-7017-43d2-65b3-08da4e208e25
x-ms-traffictypediagnostic: SN6PR12MB2720:EE_
x-microsoft-antispam-prvs: <SN6PR12MB2720DCF3E7BD1645A565F2248EAA9@SN6PR12MB2720.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y3cwSHJdgnz3ASauZ3+iRcnnzG9nVqhgVn390z3F44agMYzu85pT1mLPxPB4yLYEBiku9CdImBbn8Fw867ruI7fx5AzDTHej9NN0FDJr6NfzTQDSTjZhlhvJeaJw6Qquoc/mBremXp6mQEkASK7VinYHsNEp4e6KqAqyV5dJbW+7vVLN1z6yN1Lf9uPQUQS6eV3218ths5roBV7X7v+FJi+QZ+zkrwuPGotDfcc/zT3CFplWew2GlDTAKGEG7tCCb1SfBDqPFYop5/ENySKRGAavTI2X3Ug/lt7cP/28gCOKRxRdCgIWFhh3d9KTCP/wMyqqeAxxv279LQF0xTJ1cSfXIIYiDHba9mAsZPzayagGFdeYt909USotFpALY1V684fjW3AUI67sRODYJ/cuV4berJojWwO9H37n3/+wKjMSVBL6cbujjsdroMZ5Sj0tZkFyFKod1jXOH/FXXuSRZv9/k11Xlo1eAhdJsySKyRs0gZNJXHgYh1S8MGHOg96lbwfPNOW2nluU3Tu4hVShOzVGTU7DzvmeXIneH9K+OvgP+X9veNd/Q4i0IRlD/16qlX0Eb9YKkDf3oLCi2Flb8immnAKPx21vcW0tUTrGDRPpdJ0bvumgWHYABNB4zWM5vaDYjHMgWXp0sv7OadMRlEMbaQswt/xpyUlOCo5tkRehsLrA0UVjcMFVuGUS36fHXZnJMnXXV911/sqQJiWbwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(26005)(86362001)(53546011)(7696005)(9686003)(38070700005)(6506007)(122000001)(186003)(64756008)(66446008)(38100700002)(83380400001)(76116006)(7406005)(6916009)(8936002)(54906003)(4326008)(66556008)(33656002)(5660300002)(316002)(66946007)(66476007)(8676002)(508600001)(55016003)(7416002)(52536014)(2906002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2ZZaFMvbHBoQjdFQVVTbXB2bG84M1RtcHNNVmFJV0hIVWFVdWdzN1owL2Zj?=
 =?utf-8?B?VW5JTzFYRVFBVXFhYW1iT1Fpc0NQUzhXWnp6Z1VBMm1yQjlwWVFPTzNBOUZw?=
 =?utf-8?B?QjRSaTdXQTNSSG5Gb3VxKzZxZkgrUTBaWVdpY1RQTmhaZXdUczFNL2lmMmxz?=
 =?utf-8?B?cXltSGdSMWRGRHUzWFZiTng3YlBKeVpqZ1NQTE5oWVFTNmU5QWd6bjlLc1V5?=
 =?utf-8?B?aXZ1RHF6Y2NtcUFJQ3lVaE9kWEJrR0diV0xHVFptVFY3dFpwRnJXSDhvTnd5?=
 =?utf-8?B?NmpVaVFWK3U0cG1TcmxHb3NIekpYUnRGREc2OFJWZVFrQ0UyTlJsWFIrYzVu?=
 =?utf-8?B?bEtQQXAwNGZScitkdmtoQjFobGxSSXQ0SG53MUlmdDZrTzJscnBicHkwNTVB?=
 =?utf-8?B?cTNjaFVNZCtzQXR1bElzN3RoamNWbkJPMmg3dFZkUGRNc1NvMTFQajFYeEJ1?=
 =?utf-8?B?RkJsSXY3cmhoMGh3NVB3NTg4U3J1b1o0WTd2ZlBVMXh5Tm03ckJJeHovaE81?=
 =?utf-8?B?L1dDblREVS85dVA1VG1ibDlpSjVuZUN0c1FjeW50elhDc2E0YUdINmNPekdx?=
 =?utf-8?B?a24yaGhDT3pJL3V4bVJkS3JhT2RGc3JUQ21vM3dmUjBIa2wzcDN6T2M1OHhy?=
 =?utf-8?B?QXJpWjNyQkIzY1N2RU84OUFwdGFPR0d6NkhnTHp1VGJoZFc5NnhBWHQ5S1Y3?=
 =?utf-8?B?VFJKQ0NGU2Fja2lyUXNzbmxTRDM4MlpUY2JiejBmUkhCeTJ2ZVJFLzg4d0JX?=
 =?utf-8?B?M01NY1IwMi83eFNLSUxNRjREYzZiMGJXTlZ6cUVZQlNkSldHQnVLaUh5NlBl?=
 =?utf-8?B?emRRU3JhOFArVy9sY2ovR1ZiS2RyMWdMSXV1c2hXVW55bFJVYSsyVmVGMkZ5?=
 =?utf-8?B?T0xXMmQxUk1NVENseDdDdGwrY0toUUJERW55T3dTajhVcEpib1ZFcDVCRTNP?=
 =?utf-8?B?QWQ1MWdjTDcwbWdXSVgzZFUySmZDZjA0LzA2V0QxTzJwUUFacTRQUitRZUx4?=
 =?utf-8?B?TDlFWlRXU3Yzc1VLN3paYmR1SVBWRWhMN1h5NDJHdXpFT3BobnptUythNjZN?=
 =?utf-8?B?UVVGbjQ3M0dTb2dIbUhSVmJFdVRKTFlCQ0dTczBlV2MxTzRKenhPbVpxK2hs?=
 =?utf-8?B?aFBmOEpOY1lSMDBncjcvTHh1Q0I3aVNHZ29XOEthT1NHUm9qYkR3NmFzdTl2?=
 =?utf-8?B?OTJXaXQ5VCtEeEtOKzRDemRDWEI5RFQ3amJHN3R0c1lDVDk5UDNaVVBLWjMr?=
 =?utf-8?B?Mm9rU3pwTXYyRkVwaVJWbTEyV0NPUW5NelgwZ0RESE9WdVpMbXFVNTZhL0xD?=
 =?utf-8?B?NFVzc0duMWtSQTF2bm9DOVlWV2JZRVlBcUxPSWpueVhiU2QyUHVMalRSY3Y1?=
 =?utf-8?B?OXNDRXlMWlhKRWpwbDhvWndRNm9va3BhR0s4N1VvTkZQT1dVQlNyY0xFM1dY?=
 =?utf-8?B?Vys1WStJYW9QSXF5aGxGQ0kzY28reG9ia1ZGaXBtbkVxZE1Eb1N1N3BZZlVN?=
 =?utf-8?B?VkZ3TzJUVXhNWUUwbWdIZUdYTGg4K0FWb3lMTVVWZ3BCd2xZZWExRHF4Mi9X?=
 =?utf-8?B?OTY4eHFEdDFXWEM4NW04MktzbFB3eGZNbkozVEljWkQrSzNVOTN4OEhJVzU4?=
 =?utf-8?B?NStua0lZWGJEK0wyd0Y3TnN5cFRxdnpyK0g1dXkvaFhXWndsNDhpQllBbERi?=
 =?utf-8?B?d3o5cWtRSVRwdEdaZURmN0JkSzVEMU4rOFZ1enJUeG5TVEt1NHZ2Q3U2aXdL?=
 =?utf-8?B?c0lHSm5iL1FXVkVLZTJUMXkvMERnOWpETC8xSkloTmhvQkNoNTNIQTBndDha?=
 =?utf-8?B?R25YWDAveE5SYVBCNFY0VUVmSy9BVnJoVHI1aS94ak5IZ0tQS0xpdXRLWHR4?=
 =?utf-8?B?WUtlWHF1dFh0dXVOSlplcXdwUGc4Q0xvUXRQYUJLY1RvdnNlNWpsSUZGd2xV?=
 =?utf-8?B?YVNnTVdvMk5wM0N6OXhhSDhIRG9rRmFTRXhMeitBc1F4RElhZlBUZnJrdllq?=
 =?utf-8?B?UWlhN04rZERhdWd5VnFxaVAvRFdnMGlCdCtrcmkxVlJoekZaZDkxb0tQYm96?=
 =?utf-8?B?N3NyNDhwSndQTnRXWk9RWXphK0JJU29POU5ERU03ZGdUbGxYK0gva3ZOVVdG?=
 =?utf-8?B?Y0lmUkRmMzUvZmNZNnh5RzI0UkRpZVVrcGw3QXBmdDE2ZVhHVVdPTmRaOU5G?=
 =?utf-8?B?MEduTE1LQnI1MHQ5L0FKV1U2dzRXS21uem5nYzlKeGdLT0NHVmtDNGl3dzFO?=
 =?utf-8?B?ZzcxK1lSQUlEOExXTm5rSGZBaWZjM3pLNnczVWZZbVZBazRteWdUQk5VZ2Yx?=
 =?utf-8?Q?lT1jc5mnXiaAHi0yYl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a5fc02-7017-43d2-65b3-08da4e208e25
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 16:11:35.6925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lGNFHRdKvVRA1JKqtFK0mA5Y0DLk9qChEk4hZy30AfJx2k7O7TeQZZ6E8AQTRZE39sOrTzJAdjFIPt5vsySYRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2720
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCg0KLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCkZyb206IFBldGVyIEdvbmRhIDxwZ29uZGFAZ29vZ2xlLmNvbT4gDQpTZW50OiBU
dWVzZGF5LCBKdW5lIDE0LCAyMDIyIDEwOjM4IEFNDQpUbzogS2FscmEsIEFzaGlzaCA8QXNoaXNo
LkthbHJhQGFtZC5jb20+DQpDYzogQWxwZXIgR3VuIDxhbHBlcmd1bkBnb29nbGUuY29tPjsgQnJp
amVzaCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPjsgS2FscmEsIEFzaGlzaCA8QXNoaXNo
LkthbHJhQGFtZC5jb20+OyB0aGUgYXJjaC94ODYgbWFpbnRhaW5lcnMgPHg4NkBrZXJuZWwub3Jn
PjsgTEtNTCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IGt2bSBsaXN0IDxrdm1Admdl
ci5rZXJuZWwub3JnPjsgbGludXgtY29jb0BsaXN0cy5saW51eC5kZXY7IGxpbnV4LW1tQGt2YWNr
Lm9yZzsgTGludXggQ3J5cHRvIE1haWxpbmcgTGlzdCA8bGludXgtY3J5cHRvQHZnZXIua2VybmVs
Lm9yZz47IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPjsgSW5nbyBNb2xuYXIg
PG1pbmdvQHJlZGhhdC5jb20+OyBKb2VyZyBSb2VkZWwgPGpyb2VkZWxAc3VzZS5kZT47IExlbmRh
Y2t5LCBUaG9tYXMgPFRob21hcy5MZW5kYWNreUBhbWQuY29tPjsgSC4gUGV0ZXIgQW52aW4gPGhw
YUB6eXRvci5jb20+OyBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPjsgUGFvbG8gQm9u
emluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT47IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bn
b29nbGUuY29tPjsgVml0YWx5IEt1em5ldHNvdiA8dmt1em5ldHNAcmVkaGF0LmNvbT47IFdhbnBl
bmcgTGkgPHdhbnBlbmdsaUB0ZW5jZW50LmNvbT47IEppbSBNYXR0c29uIDxqbWF0dHNvbkBnb29n
bGUuY29tPjsgQW5keSBMdXRvbWlyc2tpIDxsdXRvQGtlcm5lbC5vcmc+OyBEYXZlIEhhbnNlbiA8
ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tPjsgU2VyZ2lvIExvcGV6IDxzbHBAcmVkaGF0LmNv
bT47IFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5mcmFkZWFkLm9yZz47IFNyaW5pdmFzIFBhbmRy
dXZhZGEgPHNyaW5pdmFzLnBhbmRydXZhZGFAbGludXguaW50ZWwuY29tPjsgRGF2aWQgUmllbnRq
ZXMgPHJpZW50amVzQGdvb2dsZS5jb20+OyBEb3YgTXVyaWsgPGRvdm11cmlrQGxpbnV4LmlibS5j
b20+OyBUb2JpbiBGZWxkbWFuLUZpdHp0aHVtIDx0b2JpbkBpYm0uY29tPjsgQm9yaXNsYXYgUGV0
a292IDxicEBhbGllbjguZGU+OyBSb3RoLCBNaWNoYWVsIDxNaWNoYWVsLlJvdGhAYW1kLmNvbT47
IFZsYXN0aW1pbCBCYWJrYSA8dmJhYmthQHN1c2UuY3o+OyBLaXJpbGwgQSAuIFNodXRlbW92IDxr
aXJpbGxAc2h1dGVtb3YubmFtZT47IEFuZGkgS2xlZW4gPGFrQGxpbnV4LmludGVsLmNvbT47IFRv
bnkgTHVjayA8dG9ueS5sdWNrQGludGVsLmNvbT47IE1hcmMgT3JyIDxtYXJjb3JyQGdvb2dsZS5j
b20+OyBTYXRoeWFuYXJheWFuYW4gS3VwcHVzd2FteSA8c2F0aHlhbmFyYXlhbmFuLmt1cHB1c3dh
bXlAbGludXguaW50ZWwuY29tPjsgUGF2YW4gS3VtYXIgUGFsdXJpIDxwYXBhbHVyaUBhbWQuY29t
Pg0KU3ViamVjdDogUmU6IFtQQVRDSCBQYXJ0MiB2NSAyMy80NV0gS1ZNOiBTVk06IEFkZCBLVk1f
U05QX0lOSVQgY29tbWFuZA0KDQpPbiBNb24sIEp1biAxMywgMjAyMiBhdCA2OjIxIFBNIEFzaGlz
aCBLYWxyYSA8YXNoa2FscmFAYW1kLmNvbT4gd3JvdGU6DQo+DQo+DQo+IE9uIDYvMTMvMjIgMjM6
MzMsIEFscGVyIEd1biB3cm90ZToNCj4gPiBPbiBNb24sIEp1biAxMywgMjAyMiBhdCA0OjE1IFBN
IEFzaGlzaCBLYWxyYSA8YXNoa2FscmFAYW1kLmNvbT4gd3JvdGU6DQo+ID4+IEhlbGxvIEFscGVy
LA0KPiA+Pg0KPiA+PiBPbiA2LzEzLzIyIDIwOjU4LCBBbHBlciBHdW4gd3JvdGU6DQo+ID4+PiBz
dGF0aWMgaW50IHNldl9ndWVzdF9pbml0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9zZXZf
Y21kIA0KPiA+Pj4gKmFyZ3ApDQo+ID4+Pj4gICAgew0KPiA+Pj4+ICsgICAgICAgYm9vbCBlc19h
Y3RpdmUgPSAoYXJncC0+aWQgPT0gS1ZNX1NFVl9FU19JTklUIHx8IGFyZ3AtPmlkIA0KPiA+Pj4+
ICsgPT0gS1ZNX1NFVl9TTlBfSU5JVCk7DQo+ID4+Pj4gICAgICAgICAgIHN0cnVjdCBrdm1fc2V2
X2luZm8gKnNldiA9ICZ0b19rdm1fc3ZtKGt2bSktPnNldl9pbmZvOw0KPiA+Pj4+IC0gICAgICAg
Ym9vbCBlc19hY3RpdmUgPSBhcmdwLT5pZCA9PSBLVk1fU0VWX0VTX0lOSVQ7DQo+ID4+Pj4gKyAg
ICAgICBib29sIHNucF9hY3RpdmUgPSBhcmdwLT5pZCA9PSBLVk1fU0VWX1NOUF9JTklUOw0KPiA+
Pj4+ICAgICAgICAgICBpbnQgYXNpZCwgcmV0Ow0KPiA+Pj4+DQo+ID4+Pj4gICAgICAgICAgIGlm
IChrdm0tPmNyZWF0ZWRfdmNwdXMpIEBAIC0yNDksMTIgKzI2OSwyMiBAQCBzdGF0aWMgDQo+ID4+
Pj4gaW50IHNldl9ndWVzdF9pbml0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9zZXZfY21k
ICphcmdwKQ0KPiA+Pj4+ICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ID4+Pj4NCj4g
Pj4+PiAgICAgICAgICAgc2V2LT5lc19hY3RpdmUgPSBlc19hY3RpdmU7DQo+ID4+Pj4gKyAgICAg
ICBzZXYtPnNucF9hY3RpdmUgPSBzbnBfYWN0aXZlOw0KPiA+Pj4+ICAgICAgICAgICBhc2lkID0g
c2V2X2FzaWRfbmV3KHNldik7DQo+ID4+Pj4gICAgICAgICAgIGlmIChhc2lkIDwgMCkNCj4gPj4+
PiAgICAgICAgICAgICAgICAgICBnb3RvIGVfbm9fYXNpZDsNCj4gPj4+PiAgICAgICAgICAgc2V2
LT5hc2lkID0gYXNpZDsNCj4gPj4+Pg0KPiA+Pj4+IC0gICAgICAgcmV0ID0gc2V2X3BsYXRmb3Jt
X2luaXQoJmFyZ3AtPmVycm9yKTsNCj4gPj4+PiArICAgICAgIGlmIChzbnBfYWN0aXZlKSB7DQo+
ID4+Pj4gKyAgICAgICAgICAgICAgIHJldCA9IHZlcmlmeV9zbnBfaW5pdF9mbGFncyhrdm0sIGFy
Z3ApOw0KPiA+Pj4+ICsgICAgICAgICAgICAgICBpZiAocmV0KQ0KPiA+Pj4+ICsgICAgICAgICAg
ICAgICAgICAgICAgIGdvdG8gZV9mcmVlOw0KPiA+Pj4+ICsNCj4gPj4+PiArICAgICAgICAgICAg
ICAgcmV0ID0gc2V2X3NucF9pbml0KCZhcmdwLT5lcnJvcik7DQo+ID4+Pj4gKyAgICAgICB9IGVs
c2Ugew0KPiA+Pj4+ICsgICAgICAgICAgICAgICByZXQgPSBzZXZfcGxhdGZvcm1faW5pdCgmYXJn
cC0+ZXJyb3IpOw0KPiA+Pj4gQWZ0ZXIgU0VWIElOSVRfRVggc3VwcG9ydCBwYXRjaGVzLCBTRVYg
bWF5IGJlIGluaXRpYWxpemVkIGluIHRoZSBwbGF0Zm9ybSBsYXRlLg0KPiA+Pj4gSW4gbXkgdGVz
dHMsIGlmIFNFViBoYXMgbm90IGJlZW4gaW5pdGlhbGl6ZWQgaW4gdGhlIHBsYXRmb3JtIHlldCwg
DQo+ID4+PiBTTlAgVk1zIGZhaWwgd2l0aCBTRVZfREZfRkxVU0ggcmVxdWlyZWQgZXJyb3IuIEkg
dHJpZWQgY2FsbGluZyANCj4gPj4+IFNFVl9ERl9GTFVTSCByaWdodCBhZnRlciB0aGUgU05QIHBs
YXRmb3JtIGluaXQgYnV0IHRoaXMgdGltZSBpdCANCj4gPj4+IGZhaWxlZCBsYXRlciBvbiB0aGUg
U05QIGxhdW5jaCB1cGRhdGUgY29tbWFuZCB3aXRoIA0KPiA+Pj4gU0VWX1JFVF9JTlZBTElEX1BB
UkFNIGVycm9yLiBMb29rcyBsaWtlIHRoZXJlIGlzIGFub3RoZXIgDQo+ID4+PiBkZXBlbmRlbmN5
IG9uIFNFViBwbGF0Zm9ybSBpbml0aWFsaXphdGlvbi4NCj4gPj4+DQo+ID4+PiBDYWxsaW5nIHNl
dl9wbGF0Zm9ybV9pbml0IGZvciBTTlAgVk1zIGZpeGVzIHRoZSBwcm9ibGVtIGluIG91ciB0ZXN0
cy4NCj4gPj4gVHJ5aW5nIHRvIGdldCBzb21lIG1vcmUgY29udGV4dCBmb3IgdGhpcyBpc3N1ZS4N
Cj4gPj4NCj4gPj4gV2hlbiB5b3Ugc2F5IGFmdGVyIFNFVl9JTklUX0VYIHN1cHBvcnQgcGF0Y2hl
cywgU0VWIG1heSBiZSANCj4gPj4gaW5pdGlhbGl6ZWQgaW4gdGhlIHBsYXRmb3JtIGxhdGUsIGRv
IHlvdSBtZWFuIHNldl9wY2lfaW5pdCgpLT5zZXZfc25wX2luaXQoKSAuLi4NCj4gPj4gc2V2X3Bs
YXRmb3JtX2luaXQoKSBjb2RlIHBhdGggaGFzIHN0aWxsIG5vdCBleGVjdXRlZCBvbiB0aGUgaG9z
dCBCU1AgPw0KPiA+Pg0KPiA+IENvcnJlY3QsIElOSVRfRVggcmVxdWlyZXMgdGhlIGZpbGUgc3lz
dGVtIHRvIGJlIHJlYWR5IGFuZCB0aGVyZSBpcyBhIA0KPiA+IGNjcCBtb2R1bGUgcGFyYW0gdG8g
Y2FsbCBpdCBvbmx5IHdoZW4gbmVlZGVkLg0KPiA+DQo+ID4gTU9EVUxFX1BBUk1fREVTQyhwc3Bf
aW5pdF9vbl9wcm9iZSwgIiBpZiB0cnVlLCB0aGUgUFNQIHdpbGwgYmUgDQo+ID4gaW5pdGlhbGl6
ZWQgb24gbW9kdWxlIGluaXQuIEVsc2UgdGhlIFBTUCB3aWxsIGJlIGluaXRpYWxpemVkIG9uIHRo
ZSANCj4gPiBmaXJzdCBjb21tYW5kIHJlcXVpcmluZyBpdCIpOw0KPiA+DQo+ID4gSWYgdGhpcyBt
b2R1bGUgcGFyYW0gaXMgZmFsc2UsIGl0IHdvbid0IGluaXRpYWxpemUgU0VWIG9uIHRoZSANCj4g
PiBwbGF0Zm9ybSB1bnRpbCB0aGUgZmlyc3QgU0VWIFZNLg0KPiA+DQo+IE9rLCB0aGF0IG1ha2Vz
IHNlbnNlLg0KPg0KPiBTbyB0aGUgZml4IHdpbGwgYmUgdG8gY2FsbCBzZXZfcGxhdGZvcm1faW5p
dCgpIHVuY29uZGl0aW9uYWxseSBoZXJlIGluIA0KPiBzZXZfZ3Vlc3RfaW5pdCgpLCBhbmQgYm90
aCBzZXZfc25wX2luaXQoKSBhbmQgc2V2X3BsYXRmb3JtX2luaXQoKSBhcmUgDQo+IHByb3RlY3Rl
ZCBmcm9tIGJlaW5nIGNhbGxlZCBhZ2Fpbiwgc28gdGhlcmUgd29uJ3QgYmUgYW55IGlzc3VlcyBp
ZiANCj4gdGhlc2UgZnVuY3Rpb25zIGFyZSBpbnZva2VkIGFnYWluIGF0IFNOUC9TRVYgVk0gbGF1
bmNoIGlmIHRoZXkgaGF2ZSANCj4gYmVlbiBpbnZva2VkIGVhcmxpZXIgZHVyaW5nIG1vZHVsZSBp
bml0Lg0KDQo+VGhhdCdzIG9uZSBzb2x1dGlvbi4gSSBkb24ndCBrbm93IGlmIHRoZXJlIGlzIGEg
ZG93bnNpZGUgdG8gdGhlIHN5c3RlbSBmb3IgZW5hYmxpbmcgU0VWIGlmIFNOUCBpcyBiZWluZyBl
bmFibGVkIGJ1dCBhbm90aGVyIHNvbHV0aW9uIGNvdWxkIGJlIHRvIGp1c3QgZGlyZWN0bHkgcGxh
Y2UgYSBERl9GTFVTSCBjb21tYW5kIGluc3RlYWQgb2YgY2FsbGluZyBzZXZfcGxhdGZvcm1faW5p
dCgpLg0KDQpBY3R1YWxseSBzZXZfcGxhdGZvcm1faW5pdCgpIGlzIGFscmVhZHkgY2FsbGVkIG9u
IG1vZHVsZSBpbml0IGlmIHBzcF9pbml0X29uX3Byb2JlIGlzIG5vdCBmYWxzZS4gT25seSBuZWVk
IHRvIGVuc3VyZSB0aGF0IFNOUCBmaXJtd2FyZSBpcyBpbml0aWFsaXplZCBmaXJzdCB3aXRoIFNO
UF9JTklUIGNvbW1hbmQuDQoNClRoYW5rcywNCkFzaGlzaCANCg==
