Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5D856ACC0
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 22:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiGGUbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 16:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbiGGUbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 16:31:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302B3C42;
        Thu,  7 Jul 2022 13:31:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaPshUQ/iW5pSQ6MWCKNbBd6sL0iSsMlRMSHvDjG7pN5VecfFKSvtxyA8JJqCMnlEOzuX74YozHVpHfGH+1q42JeU200ZuNZ0FxnyG6qcicrEWinyU+Ftr3b3ybRqwKVKnkH8aIKbfXVw7GsiiYYDbnSHkW7Dax77vxTLwy1poWezBmdpfD84RsP1vKsJGOJMa9v4gjjpXGUOV3QD0h2FcG5huF3GGkm7XCc7lpiu74w8Viz6ktr0RlkRQDhUrfpvRyZewC3gZZR9hj+1DRV3DQgMWoi/cAOjgvY7tGa00GfoCRbVR7GkdwwQabayUS4hUkoRwnQHfxjxtN7ec+hnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+q8dyXTLHAKhJzM7jxrXnKA5MNEm0sw+62YBP62+CKU=;
 b=mTmnJdmhfqVmd7QxbCf47zmWtOfQ1CroVyZF8LSDnsKaegOr9iyA7B0VhMDm77rBMjKcOO8kjUx2g9AI1JKSt5sUolPtvjTFOS22DXKasb0evCxQj6U2BITLu/OJNTkHa3sAg6hJoC7DxToArNIySDK+af1U2U0f5PLdr8gK7D5MEFqgCrMIAWEyrmlAe8kxJ0P19IqyPApgmz6tvsqkf/z8vKqiX53CXLDf8jX5JrcqsWKvlvepx4UOkBG3TLEYAFN8J/wDMD40mkL6MLY0HbIQlsIGOSRsc//mYwGBiV3+PJ2ELKoyMQuWd7b8Z/8SFtyniuAnVLeL+c7Ky81kEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+q8dyXTLHAKhJzM7jxrXnKA5MNEm0sw+62YBP62+CKU=;
 b=VK5zXUPE/TG22ghbYoEHybBja5O8UCje5sKOnTCPQ4MJ/Ys25PS03zVFeLPqO3bPdOdxOEEPhRsm+f+ts9R97nuCLqZB9KuIfrWx8JKLHzxLgQIZ/o9qxjrzyX2c2aIsVPTMk6uolIGZYZe6PKB+PsbLoim/70hskzFKQksDYmU=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by LV2PR12MB5845.namprd12.prod.outlook.com (2603:10b6:408:176::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 20:31:05 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 20:31:05 +0000
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
Thread-Index: AQHYh9zZ2YXyQRnTe0iEslSS4jvfv61e+v3wgBRvg4CAAAHU4A==
Date:   Thu, 7 Jul 2022 20:31:04 +0000
Message-ID: <SN6PR12MB276787F711EE80D3546431848E839@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <7845d453af6344d0b156493eb4555399aad78615.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6oGzqoMxN5ws9QZ9P1q5Rah92bb4V2KSYBgi0guMGUKAQ@mail.gmail.com>
 <SN6PR12MB2767CC5405E25A083E76CFFB8EB49@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6pdoMY1yV+kcUzOftD2WKS8sQy-R2b=Aty8wS-gGp-21Q@mail.gmail.com>
In-Reply-To: <CAMkAt6pdoMY1yV+kcUzOftD2WKS8sQy-R2b=Aty8wS-gGp-21Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-07-07T20:13:32Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=29f25908-6d30-43b6-9863-d9fb77535b36;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-07-07T20:31:02Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 44e57c3d-f44a-41de-b48d-b5fb9ebae463
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c042ffb-1d09-48ce-05c9-08da60579da4
x-ms-traffictypediagnostic: LV2PR12MB5845:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CSgfg+F2OuYpR9A4ZQRKlGUVTJrRRYhTW0vFmtjFbJDdcrqbg2iReo805A0C26cVnLiw8DZBmmS6aiqtJAOH3NmIdXunD3TX1/SMbJIW9MVw34wUQNghmCply4pAyyXr7rwl5x41Jn15+Dllh6bIUloaH0mhxnMPxshKfBFY76U62yrS4gzZnsute87geFTrDgLMuTaVjVOYgw0X+JDCTyopD0aNil4NODdhEge7qavMGOPZR7b6mAv3LTi3OENry2EkYk3h1AJvLBxeDu1xHR+8kqhsMwR8p0Lu4MqMpTpzcD1gM7EsQ8pU6Iu1yhVmYT7THOXZdCoxgp+1sJA7vzPA8KGC1TZecZ3p2Nk4ep4RsYRa86XF3OpK8Ekz6WIIKMGtzYBJdoI+yFtshyse7H1mekOhUHyARyuQw4mfcPTmZEuYMkG9MEYrW1yBlR7VXIUQlxWchEJ3xbnwZDUzcjQJ3KfApaZbcC0GcR2nleVfpxhgPk+OsNnkOERbsBqny7i96nK9ZMHPsuVG0QYlOG9DgSG9RfhJWkf9disoy6am1//86/E0hKPdXcORAMKRPETrPDRHKQ9RIhzJLuVhOwVFju83vtW8HbmgzcQjOwnqGIGGsvbEz+EWo8ePfibmoWoi1FUy9lVJPUffM3fsXl8GHYW1VCWRNfDwp+eK/gtTTk3RzKh9v8Tez1SmPusmj8yMYaxgLT1LmjRH9jDywbjgz4TX3cDSZWddsw/A5v7YNGJL6+HcAK/X1Gwnbfzqqqd0WqHJf778C2aIm4c9fGM3ekEygCoPewvHbU85AmB8gdD0k4hSP0g6jy7/I09J0w0yycyXFNkxiO5faI0/uivgVAA7er7ydY8YwM04x14=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(41300700001)(33656002)(38070700005)(26005)(71200400001)(7696005)(83380400001)(6916009)(316002)(54906003)(9686003)(6506007)(7406005)(38100700002)(52536014)(8936002)(966005)(2906002)(5660300002)(8676002)(66446008)(186003)(86362001)(66556008)(55016003)(122000001)(478600001)(66476007)(4326008)(64756008)(66946007)(76116006)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3BtS1dWbDNOckxoaGFPeHpKQTlHQzhBWXVkSlB5U3VTc1MzZDRJMGlaRmNI?=
 =?utf-8?B?S3VRNFZVNkxUOFdlN3d0QzhwbkFGVDJZYW5PV0JTUDdvblNLd2dzVFJ1aWRU?=
 =?utf-8?B?aEQyeFNFcjNLbWpFb21yL002ZE9KZjFJemFZcG43cXp6TUtQZWw1akRsWTJK?=
 =?utf-8?B?VUtCNkxxdEVSZzJ2OEl3R3NsVE01bFhxSE5rdWlsZ2UvMEtNalE4SDJPczRD?=
 =?utf-8?B?MjlhUTJVNklWc3pFWVIzdy9jZ2N6UStkSGlNTlBxNzZWUVpubWNCSEhEVmJZ?=
 =?utf-8?B?RjUzZmdsN2doWlJpVjFNV1Z4a0lpbW8zcXVtbVpaeENCRFdYVXUzMlFBQVlQ?=
 =?utf-8?B?YzFOcDFwb2JhQTFzaHZqRmwzNGxveEtMWXFsUDhNOXpFaXE5OGpQR2QyZlA3?=
 =?utf-8?B?MDUzN1ExaGxFbTNJdkJpdUt0Q0VOZno5REtHOHp2S0xQbXpUamhtYVA4ejR0?=
 =?utf-8?B?cjloSDJaUWJ5S2ltOGVWM2hCbmxFSjM1bHBiVHNVWlVGWEpGNDlidVhJcW1Z?=
 =?utf-8?B?VUtHZElLNnN0M2U4QklQUTl4eTFoSlcwYmU1SmNiRTdCTGlBZGlxVjgyWlpr?=
 =?utf-8?B?eG9yZnZJMnE4N3ZhU0RHbVVDa29jZnA2Z1ZVcXdxSUtTZ1ZRVitEZUFoSlU2?=
 =?utf-8?B?OUZkbkxnRlF4c1RvdFhxMVl5Q3Q5NjZ6MnRGZS9vTWs2M1NFMndNMENnRk8v?=
 =?utf-8?B?cCtIQmZIU00zZEk0NGpMcXhnK0VhSmxRZitncVJUdDZqWFJrc3VtTklicDdZ?=
 =?utf-8?B?WmJXRVp5QVZ4VllXWnB5TnB4b3lUd1R2SnpLZEpjREhWcEgvU0hNd2RWaGto?=
 =?utf-8?B?OTE1bFJGb2RvR3IzNVRLVGtwSkdrR1VuRUMxaXFnSnA3OVZmdEFMTlhQMDJN?=
 =?utf-8?B?YmlKY1FNdzVrVjhuYURTeDhSMkJYZnJwN2pVVHcwWGxUK2ZlZ1VsSEJHcjdS?=
 =?utf-8?B?TlJ4MEk1SnlQVjN5MkJ6alpNTEMrRGk1VGgxWkpPQ0dTcGhneVBtYlBteXFH?=
 =?utf-8?B?YzZCK280Wm0rWVFuajNmeXU3cjN4dWg1eXRuZDZZS2o0Z09QQmpyYlpIbXU3?=
 =?utf-8?B?TSsrbEJzNzhHR3FKc3oyWEh5SUd1NVQyRzc2RFhmZ3NmT2VBYWkwOVRHcXdt?=
 =?utf-8?B?czJnVCt2cW5WUzAxOEZkVEVyaG0rRnZCZ2gveDZmb0k1dlFNa3EyaGNTejdk?=
 =?utf-8?B?YnVHaEdZSE5Bc2QyUVhuUzhJYUxudWdCQlYvcURESkZkbnJQSjJYeDVJcEY4?=
 =?utf-8?B?UzgzWndJTjdXUS9KdExiUDM1WTRlMTZKL0ZGQXlSNzdGUUZ2ZnBPL3VLei9S?=
 =?utf-8?B?TkVnT1Y2WUl6MjJVREpIdkRkTkhjckh4VEoza2trN1diZEt3RUh4OTV4UnlX?=
 =?utf-8?B?dzhQaGRoaCt2bmhZSk1Pb3ZRbFhpVktKMHpUMjFxQlhRRlppWGdGZHZqdnVS?=
 =?utf-8?B?ZzBTWU5lR3U3QzIvWWNyZis0WWMvZzFENXhSMkY1VUs4alZBV1R1Sk0vT0J1?=
 =?utf-8?B?ZWlhczI1YktNR1YzdVBmOThTRWJwVGtiUGdoRHhRU0NLR0ZZTzRxcG5WTjU1?=
 =?utf-8?B?U1hjU3M3SWcrbE9ZSmdKNW1vdnM1dmsrdTYvWEhHL2tuVHNKK0phT0VMQmJE?=
 =?utf-8?B?c0kzeXVMRzM0QUpTZGo5ZHgwWUdSeGlDVjRXYU4zV0lsc3dkRDl0WVRqL0RC?=
 =?utf-8?B?VVJKZlVOM1Z6NXhicjZycWRzdnhJS3lVWUZVMExVeHlUTndZNDg5NnJJa3Fp?=
 =?utf-8?B?c0NsSlJ4SjZScnFGVG9SajVMVXZIY3RWQ291MVY0ZmJDMzF0dVZGWWUzUGhD?=
 =?utf-8?B?Q2FvL3FSZ0R0a0Y1MkJlOFFLa0VkeHNGeEgxb3dKdnREWHlmSkk3VnBTdUcx?=
 =?utf-8?B?TEdqdUQwSEdwN3RwN0t0YUVPeC9sc1plY0tiMHdnMCtDY1lBZVgySlNJVDRX?=
 =?utf-8?B?U0RrM2c1YWpPaFB6V1Ezb3FSU0JIK2dBWmpLeWk0bmF2NUE3N2krOHNqM2FS?=
 =?utf-8?B?SWNMRXQxa08wVHRIOGN4N3R0b00wS2dHWEE4MEpqMjdieDRVeWxmUkJ3RG1l?=
 =?utf-8?B?UTNaWWFTY3VGYjkwZnd4ZmF2a21Pb2t2amRiemdMQmw2THRDWlAzMm9yYXly?=
 =?utf-8?Q?ayAw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c042ffb-1d09-48ce-05c9-08da60579da4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 20:31:04.9071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bXVaFvd89J/rpIAP3wv/HLJrV2jN69HP31qCJEcRb9ep7VULNh0qZTZoJLlKfeQMfGyszkUBijsdcx3fbLZy5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5845
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhlbGxvIFBldGVyLA0KDQo+PiA+
VGhlcmUgaXMgYSBwZXJmIGNvc3QgdG8gdGhpcyBzdWdnZXN0aW9uIGJ1dCBpdCBtaWdodCBtYWtl
IGFjY2Vzc2luZyANCj4+ID50aGUgR0hDQiBzYWZlciBmb3IgS1ZNLiBIYXZlIHlvdSB0aG91Z2h0
IGFib3V0IGp1c3QgdXNpbmcNCj4+ID5rdm1fcmVhZF9ndWVzdCgpIG9yIGNvcHlfZnJvbV91c2Vy
KCkgdG8gZnVsbHkgY29weSBvdXQgdGhlIEdDSEIgaW50byBhIEtWTSBvd25lZCBidWZmZXIsIHRo
ZW4gY29weWluZyBpdCBiYWNrIGJlZm9yZSB0aGUgVk1SVU4uIFRoYXQgd2F5IHRoZSBLVk0gZG9l
c24ndCBuZWVkIHRvIGd1YXJkIGFnYWluc3QgcGFnZV9zdGF0ZV9jaGFuZ2VzIG9uIHRoZSBHSENC
cywgdGhhdCBjb3VsZCBiZSBhIHBlcmYgPz4+aW1wcm92ZW1lbnQgaW4gYSBmb2xsb3cgdXAuDQo+
Pg0KPj4gQWxvbmcgd2l0aCB0aGUgcGVyZm9ybWFuY2UgY29zdHMgeW91IG1lbnRpb25lZCwgdGhl
IG1haW4gY29uY2VybiBoZXJlIA0KPj4gd2lsbCBiZSB0aGUgR0hDQiB3cml0ZS1iYWNrIHBhdGgg
KGNvcHlpbmcgaXQgYmFjaykgYmVmb3JlIFZNUlVOOiB0aGlzIA0KPj4gd2lsbCBhZ2FpbiBoaXQg
dGhlIGlzc3VlIHdlIGhhdmUgY3VycmVudGx5IHdpdGgNCj4+IGt2bV93cml0ZV9ndWVzdCgpIC8g
Y29weV90b191c2VyKCksIHdoZW4gd2UgdXNlIGl0IHRvIHN5bmMgdGhlIHNjcmF0Y2ggDQo+PiBi
dWZmZXIgYmFjayB0byBHSENCLiBUaGlzIGNhbiBmYWlsIGlmIGd1ZXN0IFJBTSBpcyBtYXBwZWQg
dXNpbmcgaHVnZS1wYWdlKHMpIGFuZCBSTVAgaXMgNEsuIFBsZWFzZSByZWZlciB0byB0aGUgcGF0
Y2gvZml4IG1lbnRpb25lZCBiZWxvdywga3ZtX3dyaXRlX2d1ZXN0KCkgcG90ZW50aWFsbHkgY2Fu
IGZhaWwgYmVmb3JlIFZNUlVOIGluIGNhc2Ugb2YgU05QIDoNCj4+DQo+PiBjb21taXQgOTRlZDg3
OGMyNjY5NTMyZWJhZThlYjliNDUwM2YxOWFhMzNjZDdhYQ0KPj4gQXV0aG9yOiBBc2hpc2ggS2Fs
cmEgPGFzaGlzaC5rYWxyYUBhbWQuY29tPg0KPj4gRGF0ZTogICBNb24gSnVuIDYgMjI6Mjg6MDEg
MjAyMiArMDAwMA0KPj4NCj4+ICAgICBLVk06IFNWTTogU3luYyB0aGUgR0hDQiBzY3JhdGNoIGJ1
ZmZlciB1c2luZyBhbHJlYWR5IG1hcHBlZCBnaGNiDQo+Pg0KPj4gICAgVXNpbmcga3ZtX3dyaXRl
X2d1ZXN0KCkgdG8gc3luYyB0aGUgR0hDQiBzY3JhdGNoIGJ1ZmZlciBjYW4gZmFpbA0KPj4gICAg
IGR1ZSB0byBob3N0IG1hcHBpbmcgYmVpbmcgMk0sIGJ1dCBSTVAgYmVpbmcgNEsuIFRoZSBwYWdl
IGZhdWx0IGhhbmRsaW5nDQo+PiAgICAgaW4gZG9fdXNlcl9hZGRyX2ZhdWx0KCkgZmFpbHMgdG8g
c3BsaXQgdGhlIDJNIHBhZ2UgdG8gaGFuZGxlIFJNUCBmYXVsdCBkdWUNCj4+ICAgICB0byBpdCBi
ZWluZyBjYWxsZWQgaGVyZSBpbiBhIG5vbi1wcmVlbXB0aWJsZSBjb250ZXh0LiBJbnN0ZWFkIHVz
ZQ0KPj4gICAgIHRoZSBhbHJlYWR5IGtlcm5lbCBtYXBwZWQgZ2hjYiB0byBzeW5jIHRoZSBzY3Jh
dGNoIGJ1ZmZlciB3aGVuIHRoZQ0KPj4gICAgIHNjcmF0Y2ggYnVmZmVyIGlzIGNvbnRhaW5lZCB3
aXRoaW4gdGhlIEdIQ0IuDQoNCj5BaCBJIGRpZG4ndCBzZWUgdGhhdCBpc3N1ZSB0aGFua3MgZm9y
IHRoZSBwb2ludGVyLg0KDQo+VGhlIHBhdGNoIGRlc2NyaXB0aW9uIHNheXMgIldoZW4gU0VWLVNO
UCBpcyBlbmFibGVkIHRoZSBtYXBwZWQgR1BBIG5lZWRzIHRvIGJlIHByb3RlY3RlZCBhZ2FpbnN0
IGEgcGFnZSBzdGF0ZSBjaGFuZ2UuIiBzaW5jZSBpZiB0aGUgZ3Vlc3Qgd2VyZSB0byBjb252ZXJ0
IHRoZSBHSENCIHBhZ2UgdG8gcHJpdmF0ZSB3aGVuIHRoZSBob3N0IGlzIHVzaW5nIHRoZSBHSENC
IHRoZSBob3N0IGNvdWxkIGdldCBhbiBSTVAgdmlvbGF0aW9uIHJpZ2h0PyANCg0KUmlnaHQuDQog
DQo+VGhhdCBSTVAgdmlvbGF0aW9uIHdvdWxkIGNhdXNlIHRoZSBob3N0IHRvIGNyYXNoIHVubGVz
cyB3ZSB1c2Ugc29tZSBjb3B5X3RvX3VzZXIoKSB0eXBlIHByb3RlY3Rpb25zLg0KDQpBcyBzdWNo
IGNvcHlfdG9fdXNlcigpIHdpbGwgb25seSBzd2FsbG93IHRoZSBSTVAgdmlvbGF0aW9uIGFuZCBy
ZXR1cm4gZmFpbHVyZSwgc28gdGhlIGhvc3QgY2FuIHJldHJ5IHRoZSB3cml0ZS4NCg0KPiBJIGRv
bid0IHNlZSBhbnl0aGluZyBtZWNoYW5pc20gZm9yIHRoaXMgcGF0Y2ggdG8gYWRkIHRoZSBwYWdl
IHN0YXRlIGNoYW5nZSBwcm90ZWN0aW9uIGRpc2N1c3NlZC4gQ2FuJ3QgYW5vdGhlciB2Q1BVIHN0
aWxsIGNvbnZlcnQgdGhlIEdIQ0IgdG8gcHJpdmF0ZT8NCg0KV2UgZG8gaGF2ZSB0aGUgcHJvdGVj
dGlvbnMgZm9yIEdIQ0IgZ2V0dGluZyBtYXBwZWQgdG8gcHJpdmF0ZSBzcGVjaWZpY2FsbHksIHRo
ZXJlIGFyZSBuZXcgcG9zdF97bWFwfHVubWFwfV9nZm4gZnVuY3Rpb25zIGFkZGVkIHRvIHZlcmlm
eSBpZiBpdCBpcyBzYWZlIHRvIG1hcA0KR0hDQiBwYWdlcy4gVGhlcmUgaXMgYSBQU0Mgc3Bpbmxv
Y2sgYWRkZWQgd2hpY2ggcHJvdGVjdHMgYWdhaW4gcGFnZSBzdGF0ZSBjaGFuZ2UgZm9yIHRoZXNl
IG1hcHBlZCBwYWdlcy4gDQpCZWxvdyBpcyB0aGUgcmVmZXJlbmNlIHRvIHRoaXMgcGF0Y2g6DQpo
dHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL2NvdmVyLjE2NTU3NjE2MjcuZ2l0LmFzaGlzaC5r
YWxyYUBhbWQuY29tL1QvI21hZmNhYWM3Mjk2ZWI5YTkyYzBlYTU4NzMwZGJkM2NhNDdhOGUwNzU2
DQoNCkJ1dCBkbyBub3RlIHRoYXQgdGhlcmUgaXMgcHJvdGVjdGlvbiBvbmx5IGZvciBHSENCIHBh
Z2VzIGFuZCB0aGVyZSBpcyBhIG5lZWQgdG8gYWRkIGdlbmVyaWMgcG9zdF97bWFwLHVubWFwfV9n
Zm4oKSBvcHMgdGhhdCBjYW4gYmUgdXNlZCB0byB2ZXJpZnkNCnRoYXQgaXQncyBzYWZlIHRvIG1h
cCBhIGdpdmVuIGd1ZXN0IHBhZ2UgaW4gdGhlIGh5cGVydmlzb3IuIFRoaXMgaXMgYSBUT0RPIHJp
Z2h0IG5vdyBhbmQgcHJvYmFibHkgdGhpcyBpcyBzb21ldGhpbmcgd2hpY2ggVVBNIGNhbiBhZGRy
ZXNzIG1vcmUgY2xlYW5seS4NCiANCj5JIHdhcyB3cm9uZyBhYm91dCB0aGUgaW1wb3J0YW5jZSBv
ZiB0aGlzIHRob3VnaCBzZWFuamNAIHdhbGtlZCBtZSB0aHJvdWdoIGhvdyBVUE0gd2lsbCBzb2x2
ZSB0aGlzIGlzc3VlIHNvIG5vIHdvcnJpZXMgYWJvdXQgdGhpcyB1bnRpbCB0aGUgc2VyaWVzIGlz
IHJlYmFzZWQgb24gdG8gVVBNLg0KDQpUaGFua3MsDQpBc2hpc2gNCg==
