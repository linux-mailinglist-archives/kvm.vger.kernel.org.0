Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B75554050
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 03:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355902AbiFVB6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 21:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243534AbiFVB6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 21:58:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46ADA2184;
        Tue, 21 Jun 2022 18:58:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFxNPFUUJGN810M+SH5rScsmR+GLKnzCX15N4NzhItVk7jmenvMKCmZaU9gISL5yq5LIwpXlxVkvZNRmzwvjI5TkHpgsRG+CmKGGFtyYNJ0S0jMnC3J0LlT9nxaMDHwYfYacAoBNfz2KJGpOQhTb9IJoIxeQCEOYsYV1LaBl9tE/hEhyyr7J2Xw0mpG/JMQujVcC6fW7pokHdZ8aQ/s2vV2EmeyNhIdnQGv3+ZUPu9M/Fs9l/505+dBUITP36BS5JJbUo6dkZhxvbM7IAgEU5DGdE+aLiPeYX8FgIyNN/MMZS2GSY82T2uL7YA4zkLLsjxhzv2xlKu62v1ANgEyx9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEdhM9XPdodfnnYRdAdFVaU7YeKv4Gg4Irgbl6SHkJw=;
 b=n1SLgMFlN4PU4f/ttnpC5r5w6DrrEgkvQ3ML3bSa0WmjHK8279Lj58VolqPSTChNnd2GeCNNtiH/icOKKHpn9k27WKIgO+0V2g7YF9hL54w1qA7GGVQJggNnkPN+FYtiw2Y490fZ/kUqvmBWHaqJXYh7Cp6bI9GzNUTtoQmYwh8+SEGF55s1sysNAYWuue6bpRwlOh4hKrEVBwI8cUcuCNkkTsuOE9U1O+m9b6gflzN+GZKQlut8UlmSfFTwmFz7USQOYlMGrGmjQ9gIgwVREkoIkp31SEH5paLSj7Y6QvCNmrK62XxHeaD/SELgLDV4HPRZ3o/f4CoEIDmoxNg8/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEdhM9XPdodfnnYRdAdFVaU7YeKv4Gg4Irgbl6SHkJw=;
 b=hQTe9vdtNtffpiutPWTg4NiekxpJ0H3mZPnjkOOR9ZqIuzZ8EOH9ZriegoeQS6aTwNlm/df/ynlwGfnb1iJCNOokgAqn+Duj/LMjfh67kekJmtm8aumklyksa7oi7vTD/87Rq8neS4HxafDpeLJsYQtRQ/PldI89VgIHCMN32n4=
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by DM4PR12MB6376.namprd12.prod.outlook.com (2603:10b6:8:a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 22 Jun
 2022 01:58:09 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 01:58:09 +0000
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
Subject: RE: [PATCH Part2 v6 17/49] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
Thread-Topic: [PATCH Part2 v6 17/49] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
Thread-Index: AQHYhbwsbvDGyyiSDkCM6GjVJd5Ffq1an6vw
Date:   Wed, 22 Jun 2022 01:58:09 +0000
Message-ID: <BYAPR12MB2759B6CBC481A4A45167589A8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <d325cb5d7961f015400999dda7ee8e08e4ca2ec6.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6okrB57pwWu1RCRA1BqTzosD52KFHn7XD6DoJNFo1N72A@mail.gmail.com>
In-Reply-To: <CAMkAt6okrB57pwWu1RCRA1BqTzosD52KFHn7XD6DoJNFo1N72A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-22T01:15:33Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=76e8e682-2682-47e5-913e-504191e61cb2;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-22T01:58:07Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: b7d8afff-ac92-4727-838f-089f6f8b2972
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8293cff7-bdf0-4088-feb4-08da53f2a80d
x-ms-traffictypediagnostic: DM4PR12MB6376:EE_
x-microsoft-antispam-prvs: <DM4PR12MB6376D336C88F78048E284A818EB29@DM4PR12MB6376.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y+8/wHc7Q0NwblFzDThiOYLGZmsfdvz24LLUpoVYpjnBvICVLw468pI7vewiTemJ2g02WDvIKBdIN/cxgTu0K4v6kwct6JIoIrhdWwJtXUSHdMYQlD9s1B9w5kXGtZcGJZrLhIA0n1Eh8gY+MfT6m8MxYAxnISdFhxUv72aoj7dcAzfJIhQyDtB9fluLYcrmFdecsBMiocb3SUiwHaUnZFCzdqwXFGohpvHFX9UTWTElnwWJNP4klgq4S42xv7JrWc3WqSJWnCBW/XEIuAO1XMAdMNSgCPpwyzWNwgrQsZLszKuO0MydRin4A4orHaFQKbpi1FDcYYsFighFSsVPprVMwMDDTHi5f9Sb3gdXx2zyNZOEbRtNXPaEwopGDTkKub4TrznCgGocT2Syak1rrRsodMXyfE4jEdn2AP0xO+5WXI7QS0AjielSK+FwuUbR0pzvXHn6ZnLx7Tv84PA9VgWYUUOHcjqfp1xtOjYRFz2HoaTb2zvPNjfVrI9J68FFwsvn2vfMaEAbIT0qfFBO9cBuzTgkIuacunbf5Y1Z6qZJedujL5AuyHdOwMPTyjc1fVkPi7GFyKeu8I99NOboy80qtIi3NAy1o0aIvKCCvT7P13Nn7OmCHOJ0z3PeHkVTDyX0SH2p82y+8ctpsbtiW31IQ2xN42X+ALyQ0p4fPfsR4rkTbvUcR7pkmbUxva9ihb/UomIjy/5oFHg0wgASGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(33656002)(26005)(7416002)(6916009)(66446008)(54906003)(86362001)(2906002)(186003)(66556008)(55016003)(7406005)(5660300002)(7696005)(122000001)(64756008)(38070700005)(66946007)(66476007)(52536014)(316002)(8676002)(4326008)(41300700001)(6506007)(478600001)(9686003)(71200400001)(8936002)(76116006)(83380400001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjArak5JY2JYWHVFS1VnU3FscDVMblA4eW9ZU3F6eG9CcHVTRVN6c0ZodjZ6?=
 =?utf-8?B?YUhwK3JMQisrUGFUN3RHT1RyVE5pajNackFHNnFnQ3RPZlN4QUpUV3JSZVJF?=
 =?utf-8?B?Rk5VcXJmeTB4a3lnSWRGcG9vREJPN1BFRnVaZWhHU2IvU3dFTnpaMXpDVVNK?=
 =?utf-8?B?M3d5SmVnbEpGM2lqeGEzNElOWklaNXZhRnFPaitZd3BQMGYwM2tCejM4TG5H?=
 =?utf-8?B?NkZ6OWowcWpwcnFUK1I4RGtRQkMzdWZTUEM1UUFCM2VyWnpZL29CcmpEbmRO?=
 =?utf-8?B?N0Z1aXU3Q0pqWndiekU3K08yZkNQMkRkcnVhMWtpa1RWR1ZxdHVtcXovSmcz?=
 =?utf-8?B?bG9jSXRLNnNnd1hKa0xENWlzY0toWVBLL3hMdTBYODRqb0VTQm1uWFdtVlVa?=
 =?utf-8?B?Z1pJYmJmN3pHUm5oZzYrL0lPUkVNNGdkV2tsL3dOeitNSDgzQzlxMzZNZmxt?=
 =?utf-8?B?NDkwaGJUYWs3cFNVMlA3TVlwVTk3QzFqQVVacmFSUXZJdnJtdlE5VzJXVld6?=
 =?utf-8?B?ck5BekZ4ZkxKRk4xWFBVNmFXZmo2TGtZdll3ekcwUzhCWlptMmZtTzQwRkhs?=
 =?utf-8?B?bFo1WjhmSGNKaTgwM2NKNGl6MHFLTDhFdG8ybjEwaFVtaTZpc00xSW90eG96?=
 =?utf-8?B?ckxaSFFsWHF2eS9TUnJQQ3dkdno0dDVMZE1qcHpkYVZCYWdNTXFYUkU3K1Rn?=
 =?utf-8?B?R2FqYW1QM210ZE85NHBNa25qRno2S0dvdWgwREhncFo3OUhBQVVWNmtWSUtN?=
 =?utf-8?B?cnJvVEdSUzRjTW53aVRWWnc2RTZBYlIyNlR0OE5pcmpvdi8vdHlvdU43UHNu?=
 =?utf-8?B?QVJhbVk5dlc3ZGFRMFZpOGErLzl3bVhOREJGdFN6aGszQVVETnVLRkVab2pB?=
 =?utf-8?B?NXpubEM1dWUxY1BZQ2d1dU5WMTgvK3ZFM2RpNDd1TTFXb2J5Z3hxMm5IRVVu?=
 =?utf-8?B?Z0RPODdyaFFSVDk3R2piTUxuKzBhaElsRHhMQzQ3WGx2eHBiZXdVOXdUV0ZD?=
 =?utf-8?B?aS9UMm93TXVDZGZpS2FmWVQ4UkZOb2x5Y2dCYWQxb3hIVzZYZ0o3enJ0OEV0?=
 =?utf-8?B?RFdRUTBoZzBsenI1TFl5MERPLzdIQ3NVZjJzOGJEUCtrcUZCQzQvODNPd3VW?=
 =?utf-8?B?c001TnR1WWpLWnowMXhHVXZJM29oR0wxT3BrdWVQNE1Bc1RqdkZPaDRSUE0w?=
 =?utf-8?B?Y2REWGt3RU5oNk94SExJRFl6SFBZZDQ3YnQwSUlKQ1FwNFlnZ2dNdWxDM1BH?=
 =?utf-8?B?d2lMdWs1NlNmQ2wwaWpXM0l4Zzh3djFCSVEyV3ZJc1NtYUVpV3ZUVllwdkhh?=
 =?utf-8?B?OUVSUlp6V3lRNTQwZDByU0NpdFMrczNRWExES2VEb2RCNXZ3Tmg4eGRRbklR?=
 =?utf-8?B?SC81WlV0czVyUFlXVytzRlpoSzgvNlBQYmJERlE1SGZ3UjZQRitrRjlSUC85?=
 =?utf-8?B?ekNkdit1UlQvdWxkRDlPaStWVHRHaFVDNG04YnZQV25nZE56VENQZEd4SXJJ?=
 =?utf-8?B?K2FNL1dEZUgzVHY4NVN5YjlsNG94SHVVc2Ntb1pGOU1yekJ0RlRoQ2pFTmxP?=
 =?utf-8?B?UU1zRmo5YzBqZCt5YXJYS01UQU9sYTByVmZMeE1jN2F3cE41UGMzVmhXWnFr?=
 =?utf-8?B?VERyc2FBR0JaY3pxYWFmZTgxQnZ6cG1CbVpINWhLZHo1YlhSY0dPS3lHUzha?=
 =?utf-8?B?WEVxVnFwR2IyN3pzYlJNakdQWGJYVmcrQXJvdmZFMnlUYWFlcVQ0dnQ4aU93?=
 =?utf-8?B?ZHZTMVV0d3pzSG5RZElmK2grQmJPM2s0djJQeW82VENkeC8xSTZvZENaaDVI?=
 =?utf-8?B?VTVHMmpsdnQzRmo1aFk5SVlobFdHUlg1RUpYNEJNZlo4NkNWbkt4R1VsTmkx?=
 =?utf-8?B?a1A4TjR4MGVEWklTSVZ4bzlQQXV1SEVHck5kUEd0NUYzQUpOSlVqbWpDbUly?=
 =?utf-8?B?aGwzUEhuMVpVVFZOL1N1UWdJbkNsc0RpRU8zcUg5Z0xBYWxjSzF4b3hmbzZR?=
 =?utf-8?B?cFJlbjY3R3JhOW9MaXM2OW1oTndXNmZvS1VxVGcwYmFKVXNpeWxoWEJ0RnFR?=
 =?utf-8?B?YXAxK1NCUExKRUExcUYxdk9ndUZ5VkJ0bkg0TGN4Nzk1Z1hyV1hnVHlzTExU?=
 =?utf-8?B?OFNuTS8rc0FpSzNYcWtnNFFZYStScUU3ckxJbEdCbDNDd2dLR1dBL0tabVlE?=
 =?utf-8?B?ZEdTSWVSbEhwc3lqM2V3a3ppLytyeWJiUndTMEpBNEpxU0tTTUEweER0aXdT?=
 =?utf-8?B?MkFXS24yYW1BZzZrUlNzb0VGeW4yc2VSQXpkc3ROZk41RmhlQ1pzQVN5NGNy?=
 =?utf-8?Q?MVa+cOG3rgV3CMhMng?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8293cff7-bdf0-4088-feb4-08da53f2a80d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 01:58:09.2870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vvwlDWunyF2NN7yOkKo8qVqnpusayk8suaB57Dp80QAppVu14xmRCNkF29zd/58Kd1oUc05TLgSI+8qcNjLvOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6376
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhlbGxvIFBldGVyLA0KDQo+PiAr
c3RhdGljIGludCBzZXZfaW9jdGxfc25wX2dldF9jb25maWcoc3RydWN0IHNldl9pc3N1ZV9jbWQg
KmFyZ3ApIHsNCj4+ICsgICAgICAgc3RydWN0IHNldl9kZXZpY2UgKnNldiA9IHBzcF9tYXN0ZXIt
PnNldl9kYXRhOw0KPj4gKyAgICAgICBzdHJ1Y3Qgc2V2X3VzZXJfZGF0YV9leHRfc25wX2NvbmZp
ZyBpbnB1dDsNCg0KPkxldHMgbWVtc2V0IHxpbnB1dHwgdG8gemVybyB0byBhdm9pZCBsZWFraW5n
IGtlcm5lbCBtZW1vcnksIHNlZQ0KPiJjcnlwdG86IGNjcCAtIFVzZSBremFsbG9jIGZvciBzZXYg
aW9jdGwgaW50ZXJmYWNlcyB0byBwcmV2ZW50IGtlcm5lbCBtZW1vcnkgbGVhayINCg0KWWVzLiAN
Cg0KPj4gK3N0YXRpYyBpbnQgc2V2X2lvY3RsX3NucF9zZXRfY29uZmlnKHN0cnVjdCBzZXZfaXNz
dWVfY21kICphcmdwLCBib29sIA0KPj4gK3dyaXRhYmxlKSB7DQo+PiArICAgICAgIHN0cnVjdCBz
ZXZfZGV2aWNlICpzZXYgPSBwc3BfbWFzdGVyLT5zZXZfZGF0YTsNCj4+ICsgICAgICAgc3RydWN0
IHNldl91c2VyX2RhdGFfZXh0X3NucF9jb25maWcgaW5wdXQ7DQo+PiArICAgICAgIHN0cnVjdCBz
ZXZfdXNlcl9kYXRhX3NucF9jb25maWcgY29uZmlnOw0KPj4gKyAgICAgICB2b2lkICpjZXJ0cyA9
IE5VTEw7DQo+PiArICAgICAgIGludCByZXQgPSAwOw0KPj4gKw0KPj4gKyAgICAgICBpZiAoIXNl
di0+c25wX2luaXRlZCB8fCAhYXJncC0+ZGF0YSkNCj4+ICsgICAgICAgICAgICAgICByZXR1cm4g
LUVJTlZBTDsNCj4+ICsNCj4+ICsgICAgICAgaWYgKCF3cml0YWJsZSkNCj4+ICsgICAgICAgICAg
ICAgICByZXR1cm4gLUVQRVJNOw0KPj4gKw0KPj4gKyAgICAgICBpZiAoY29weV9mcm9tX3VzZXIo
JmlucHV0LCAodm9pZCBfX3VzZXIgKilhcmdwLT5kYXRhLCBzaXplb2YoaW5wdXQpKSkNCj4+ICsg
ICAgICAgICAgICAgICByZXR1cm4gLUVGQVVMVDsNCj4+ICsNCj4+ICsgICAgICAgLyogQ29weSB0
aGUgY2VydHMgZnJvbSB1c2Vyc3BhY2UgKi8NCj4+ICsgICAgICAgaWYgKGlucHV0LmNlcnRzX2Fk
ZHJlc3MpIHsNCj4+ICsgICAgICAgICAgICAgICBpZiAoIWlucHV0LmNlcnRzX2xlbiB8fCAhSVNf
QUxJR05FRChpbnB1dC5jZXJ0c19sZW4sIFBBR0VfU0laRSkpDQo+PiArICAgICAgICAgICAgICAg
ICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4+ICsNCj4+ICsgICAgICAgICAgICAgICBjZXJ0cyA9
IHBzcF9jb3B5X3VzZXJfYmxvYihpbnB1dC5jZXJ0c19hZGRyZXNzLCANCj4+ICsgaW5wdXQuY2Vy
dHNfbGVuKTsNCg0KPkkgc2VlIHRoYXQgcHNwX2NvcHlfdXNlcl9ibG9iKCkgdXNlcyBtZW1kdXBf
dXNlcigpIHdoaWNoIHRyYWNrcyB0aGUgYWxsb2NhdGVkIG1lbW9yeSB0byBHRlBfVVNFUi4gR2l2
ZW4gdGhpcyBtZW1vcnkgaXMgbG9uZyBsaXZlZCBhbmQgbm93IGJlbG9uZ3MgdG8gdGhlIFBTUCBk
cml2ZXIgaW4gcGVycGV0dWl0eSwgc2hvdWxkIHRoaXMgYmUgdHJhY2tlZCB3aXRoIEdGUF9LRVJO
RUw/DQoNCkJ1dCB3ZSBuZWVkIHRvIGNvcHkgZnJvbSB1c2VyIHNwYWNlIGFkZHJlc3MsIHNvIHdo
YXQgaXMgdGhlIGFsdGVybmF0aXZlIGhlcmUgPw0KDQo+PiArICAgICAgIC8qDQo+PiArICAgICAg
ICAqIElmIHRoZSBuZXcgY2VydHMgYXJlIHBhc3NlZCB0aGVuIGNhY2hlIGl0IGVsc2UgZnJlZSB0
aGUgb2xkIGNlcnRzLg0KPj4gKyAgICAgICAgKi8NCj4+ICsgICAgICAgaWYgKGNlcnRzKSB7DQo+
PiArICAgICAgICAgICAgICAga2ZyZWUoc2V2LT5zbnBfY2VydHNfZGF0YSk7DQo+PiArICAgICAg
ICAgICAgICAgc2V2LT5zbnBfY2VydHNfZGF0YSA9IGNlcnRzOw0KPj4gKyAgICAgICAgICAgICAg
IHNldi0+c25wX2NlcnRzX2xlbiA9IGlucHV0LmNlcnRzX2xlbjsNCj4+ICsgICAgICAgfSBlbHNl
IHsNCj4+ICsgICAgICAgICAgICAgICBrZnJlZShzZXYtPnNucF9jZXJ0c19kYXRhKTsNCj4+ICsg
ICAgICAgICAgICAgICBzZXYtPnNucF9jZXJ0c19kYXRhID0gTlVMTDsNCj4+ICsgICAgICAgICAg
ICAgICBzZXYtPnNucF9jZXJ0c19sZW4gPSAwOw0KPj4gKyAgICAgICB9DQoNCj5EbyB3ZSBuZWVk
IGFub3RoZXIgbG9jayBoZXJlPyBXaGVuIEkgbG9vayBhdCAxOC80OSBpdCBzZWVtcyBsaWtlDQo+
c25wX2d1ZXN0X2V4dF9ndWVzdF9yZXF1ZXN0KCkgaXQgc2VlbXMgbGlrZSB3ZSBoYXZlIGEgcmFj
ZSBmb3INCj58c2V2LT5zbnBfY2VydHNfZGF0YXwNCg0KVGhlIGNlcnRpZmljYXRlIGJsb2IgaW4g
c25wX2d1ZXN0X2V4dF9ndWVzdF9yZXF1ZXN0KCkgd2lsbCBkZXBlbmQgb24gdGhlIA0KY2VydGlm
aWNhdGUgYmxvYiBwcm92aWRlZCBoZXJlIGJ5IFNOUF9TRVRfRVhUX0NPTkZJRy4gVGhlcmUgbWln
aHQgYmUgYSBwb3RlbnRpYWwgDQpyYWNlIHdpdGggdGhlIFNOUCBleHRlbmRlZCBndWVzdCByZXF1
ZXN0IE5BRSwgbGV0IG1lIGhhdmUgYSBsb29rIGF0IGl0Lg0KDQo+PiAgICAgICAgIGJvb2wgc25w
X2luaXRlZDsNCj4+ICAgICAgICAgc3RydWN0IHNucF9ob3N0X21hcCBzbnBfaG9zdF9tYXBbTUFY
X1NOUF9IT1NUX01BUF9CVUZTXTsNCj4+ICsgICAgICAgdm9pZCAqc25wX2NlcnRzX2RhdGE7DQo+
PiArICAgICAgIHUzMiBzbnBfY2VydHNfbGVuOw0KPj4gKyAgICAgICBzdHJ1Y3Qgc2V2X3VzZXJf
ZGF0YV9zbnBfY29uZmlnIHNucF9jb25maWc7DQoNCj5TaW5jZSB0aGlzIGdldHMgY29weV90b191
c2VyJ2QgY2FuIHdlIG1lbXNldCB0aGlzIHRvIDAgdG8gcHJldmVudCBsZWFraW5nIGtlcm5lbCB1
bmluaXRpYWxpemVkIG1lbW9yeT8gU2ltaWxhciB0byByZWNlbnQgcGF0Y2hlcyB3aXRoIGt6YWxs
b2MgYW5kIF9fR1BGX1pFUk8gdXNhZ2UuDQoNClllcy4NCg0KVGhhbmtzLA0KQXNoaXNoDQo=
