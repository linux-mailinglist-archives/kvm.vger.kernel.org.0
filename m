Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A030E555544
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 22:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiFVUPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 16:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiFVUPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 16:15:46 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2075.outbound.protection.outlook.com [40.107.101.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F1B33EA3;
        Wed, 22 Jun 2022 13:15:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XzgOmBMDEnJiOfiz0ukaMdTZNgBtRtOujMf817nY2HNWaLz+PYX0/7Rd6rtCOutLgkm3Oe9OunUz/8ZgJC7sx+11FxO33ztDOz0l2aNocI0kxc+ZXYQXwpzNJOd1dQHNH1YXYlCWl44Nuf5A2Zh1Of6a4Bh5V7wT3ZPrNHxw10+NVKECA2qXIr7SOZBSbgtPDatWzULC0WSTNCROlLdY4X9z2Gk+barglywXKoTZgPkFWJI5TD44pVRfbBDa37WQmmy7D11Iog+iT5yV189kiHNcJzz8idjJCK3N7IE73er66hy2q8gk+7ko+4NkGls6Moc0MzqpH9SmzH3Cquv7WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6rHcCCLh4pKkdffi8vouW7+cvBgUl6mnoes1m8RQrA=;
 b=ltdv2JPafi4L08IrRpqAArlJ/Yx8FgXyUEAN2KiHG8wTsOtCo2M2HhcK9Faf/6mBLYivrW76/6zvLcH/gKTcKONE0kdgAtp5lSm07/lKNlNG5ZS/d3Jl9yQOPAWuJ8S+Ojl53ZhuIm5fYId6Dg+gqa/rzCmSKlzNomYrZ/8hd4zc9P2xJk06YQe2fIM33QBLi/aLmROGRL2OO0lQo9yUhcvR/tp/9LUPntWnOm7Bjpv8sgYOst6+armrEeD9RYPwnu8KZ3LlU/CXhkv+QjOpxI6H4j4i9lYpbO/2J2S4d7aFr2tCfqT+WgvgeNTs+tNw7xv5q4iEtP+9VnXQSuYLjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6rHcCCLh4pKkdffi8vouW7+cvBgUl6mnoes1m8RQrA=;
 b=GArrHt58LEc/utFQKicRFFa38byXBfhBiL/GhZtsp41ONkboBkcUco7Ym/Y9jCQ0zBbh9x/lcHIjnhhIamuDHJfOFVPv9K8KN+uCFF6lfhIO1lXxb3u1OcdqPcpXSRVTaawN8jEqg46aFqjKwrKqxdXKQpI03o9VOX0uBrKfczY=
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by BN8PR12MB3380.namprd12.prod.outlook.com (2603:10b6:408:43::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Wed, 22 Jun
 2022 20:15:43 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 20:15:43 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
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
        "tobin@ibm.com" <tobin@ibm.com>, "bp@alien8.de" <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Topic: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Index: AQHYhkJMEjVRVcpx502HVSPCQUlAqK1bejcAgAACPYCAAD2E8IAAAkWAgAAEHtCAAALbAIAAEKeAgAACGACAAAZmMA==
Date:   Wed, 22 Jun 2022 20:15:43 +0000
Message-ID: <BYAPR12MB2759AA368C8B6A5F1C31642F8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
 <cc0c6bd1-a1e3-82ee-8148-040be21cad5c@intel.com>
 <BYAPR12MB2759A8F48D6D68EE879EEF648EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <25be3068-be13-a451-86d4-ff4cc12ddb23@intel.com>
 <BYAPR12MB27599BCEA9F692E173911C3B8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <681e4e45-eff1-600c-9b81-1fa9bdf24232@intel.com>
 <BYAPR12MB27595CF4328B15F0F9573D188EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <99d72d58-a9bb-d75c-93af-79d497dfe176@intel.com>
 <BYAPR12MB275984F14B1E103935A103D98EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <5db37cc2-4fb1-7a73-c39a-3531260414d0@intel.com>
In-Reply-To: <5db37cc2-4fb1-7a73-c39a-3531260414d0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-22T20:12:46Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=e585947e-3d32-4071-be4e-4f7c6e546644;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-22T20:15:41Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 09cd3c12-070d-4b31-bebf-5d665c5a4940
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbc0b2e6-61fe-49c8-2972-08da548bfc15
x-ms-traffictypediagnostic: BN8PR12MB3380:EE_
x-microsoft-antispam-prvs: <BN8PR12MB3380C3DB98B1223B79F6FCFA8EB29@BN8PR12MB3380.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bNjq+EW23NDWYPyPyXpqN707OMPk5frMcMAOWzuvUAULg6myoOTPyN7KKeB4MCih24C+jKiGKYBW3EposZcZc3Ij4VKSqWZrcy6dGlh33XFmcgKEnf7ImiWlVjgoEL3DR6QX5ZN78As6tg//H/W0/wBwDuDUyqqciumg0mo+g0kiJ7cLV0hRd7Mw5aaGwfNMSitQXR7w7lyB/fMdlmULvsWr3qY+8vzQoPS7FqQqIBGNyARWsvEDZEfJ0CZxaY2Jdp3gRDciMUwZ8ZmaNHZjuMSsIWf5XtQxXTV40zebWAVUGGpq00QPTErHaWiAp2RU4owArMPDvwjHPlSxIA7AEMuShZVGTAxbIrE++mAT2MvToJXHTh7Eufq3UT8Y81fkyM0L7FT03bVu7Kp32+1HK3ql7eF2ATnapVNg35/4mw5peQCbnDDJrzpOrW6pfMW4iQdFch90Z2FcX8CmKr5UvqRUZc97yeRZhjdmCbUVl/Ow8zQYAbmDaHXzSGpeDB3lPHUglfrUyjoHVhOKDWz8qbZS9gPycNjvhhgSk6czXMjHP3kRX9LDfa0n55jW2sc4sJzfKW4/I/C/mFEQA4KSXoWDfJIwr5JdDXd+sNZ8aVC2sl06Ed22jRnuMqTukswcuBepGlykHRdNas2iPG86fKQVZ4Rrly/jCUHUgY/zDKIKOM89xdTT0gz64FK5VVlCLVZvIS71HIfoqJdUep9StOuRYRWI/IE8JnBSiIQpXNZ0J7NxdcqPP2l5oJzrh/ZUMJUAnvnnGVAvfows6rPXyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(38100700002)(316002)(5660300002)(38070700005)(8676002)(66946007)(7406005)(7416002)(122000001)(71200400001)(54906003)(83380400001)(52536014)(8936002)(55016003)(110136005)(64756008)(86362001)(76116006)(66556008)(4326008)(66446008)(66476007)(7696005)(478600001)(6506007)(2906002)(9686003)(41300700001)(33656002)(186003)(26005)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bElGTlNGMWdBMzZ1aWdsVUxuRnpNQnBXbnV6QjJGdXVyaTlvaFl4Q2xSTnFG?=
 =?utf-8?B?djlBTzY2ejNWRmc2Z1RSQVVGUGJ1bVkybmxSeEFZWTJtMVBseDNDb1pvdVJr?=
 =?utf-8?B?MUJveEN0eUh3eDJHV05Gdm1CN1p6b1B3SGYrdmh4cFVxNXZ0MWZlVWI0Y1Zp?=
 =?utf-8?B?bmEvMWphbHY4M0IzLy9RdzFhSDJTN3ZTN3kxVTR1RWhQbjFpN21GWTNuYkZ5?=
 =?utf-8?B?ZzBIczhCaEV1SWpET3Njejc0YnhVcW1xWTU5VzJpZllZS3Z2RU9CWCtwNGtK?=
 =?utf-8?B?M0owZFBLMEVSS29sNlg0VmMwd0l4K0ZXQjVpejdCZnIwZXdoOURQQysxT0s3?=
 =?utf-8?B?UHBuR0xkVWkyQk9XMkdHSlA3S0tWOW9rUEUvMXc5WC9CWmFCMmNqTHE0MGhH?=
 =?utf-8?B?V2gxTjRjdUJVQlAyOTRsTHVGeW1URU9ZWUNLYUpmcnNTYU1HTEZBWlpRZFdZ?=
 =?utf-8?B?dEVORTVRcTQvTkZmS0E3cnBPZzQxSFE0aFVTSDBVK0FxRjN4VEtrZmVPWko4?=
 =?utf-8?B?czMxMDJNOG9HZzIrWldWOWZ4ZUxpMkpVcnFBay8rTU9lM2s0MThiRXovN1I5?=
 =?utf-8?B?ZU80bHQ2SXVaY3pWdUdNQ2RSVGEwYW5STUFLV2o2NFdkaUtkU2NZSUVlVExT?=
 =?utf-8?B?SVVqUjhMQ2JYVDJpRDljK1VTbkJodU9heDRSV2haS3ROVE5QRU1nR2JYVHdt?=
 =?utf-8?B?d2VWUFFwNytkMTBTNkEyTGxnS0E2cHhVVk5VaERIZHlQMVRMdlpLOU01bXpw?=
 =?utf-8?B?anNmL3FGbmFjWENYM0plc0k0N29SYVV0UzEzTFBkaUJXbSt1VDdjTkFocCtr?=
 =?utf-8?B?cmw2bVhyR0xaR1FzZXV1Zy9lUHQyc3N5TEVERGtKK1lWVUFValMxcktsT0dw?=
 =?utf-8?B?YTBJaWJ5cGxvbEdndjRJYW1ZazRLS01ZdDBodzgyM2E3bGlvV3kxdkVMS2U3?=
 =?utf-8?B?dk1DeG5iSDg1bWtTajFTazR2ZEtkQzNLQThsVTRLR0grbEtSNVlUQUFPVUox?=
 =?utf-8?B?Y1RmdWE2ZkdScHA0ckpuaEFNU1JnWW9ETVNVamt5WEx6UFc0VzVOKzR0T1dY?=
 =?utf-8?B?WXA5TkJWejdFZVhrQTFzdXF5dE1NK2ViNVZkcFZjemlCL1EvRDYzV2V4NlZz?=
 =?utf-8?B?TDhUbXFielcvRDMzN3lnaERlS3NiOUlrQTFONXZVVVY5TlhpWndiZkpJalRN?=
 =?utf-8?B?KzdXdHd6UFFxbkNYWS9PM0ZSQmVQVHFHL3lMejlpVGY1N0xlbTUxaVhKS01s?=
 =?utf-8?B?QmNlUDlaWWxIY0hFVmpLNWlnckF3Z1dPc0dsUmI4NXhRMWxTVjF5R1dhYVZC?=
 =?utf-8?B?WUFMMzljQ0xibHdNbVM5M2xpcWNGTEsyM2ZuOWdIS0J0RUxRSVlGU3ZJWS94?=
 =?utf-8?B?OUllWTFVVXIvb005WnlzZ1R2MHJsWGRsd3FIUCt4SlJpSnNhWXdnNmFVQi9x?=
 =?utf-8?B?TnhtOFNVWFFrb2RPVjI5bG5uVUI3enhSNnRQVmt3K21DUWNtQm9hd1J5aGxX?=
 =?utf-8?B?RUh1ekUvOEl5bzBTWnRySEo2YWdXUlVJb0ZYMGNSaCtXajNiMklZcmcvYzhI?=
 =?utf-8?B?cE9wQWpWcW1SM2k5OERuYlRwVnBsbEFycEhENUg0NHZUR3lDTHQra0taMGxP?=
 =?utf-8?B?MEx3ZDZkVVFJQmhCaVhDZGVqSE8yR1pCeXREczMrb05sZmc5bXFmajVtY3dI?=
 =?utf-8?B?a1JvOUV3b2plcXdnZWlSVUx0b0g1YStNZE01dU9IK3lkYjZzZFdXZ012VGhX?=
 =?utf-8?B?Q1pmUmdIZEluSkpWcEl3U2ZWTjlPcTJlajc0OXlzT3E5QUY4SUlNN2NJVHhl?=
 =?utf-8?B?N3F3aWs5My95NWUzU3lhZEFWK0Z2alllbnYrUFFDVGF5SDAxelVuOHFDS1B5?=
 =?utf-8?B?WUMzNkNxZ3ppYjB4TVFuWWgxcm81d2RjWCt3MmVRQnQweENxNnlWK3RGT3hE?=
 =?utf-8?B?UVJtM09PMUJHN29UQW5PckN0bFJZZTFsbHFzZVNQRzUrMTdLZnlMbGt6M0w5?=
 =?utf-8?B?V2hORzZ1a3A2M0RmV3V0NSs3dTZnK1JOT2FIUW1YODlIejd4dzcrNVBJTGlM?=
 =?utf-8?B?enZCaGd0YnF6NDFJclR5ZERnRnFBR2E4dzhmZVpLdWRFaUZqdHo1UmN3RmMz?=
 =?utf-8?B?dkF4cm9XOVlyTVhGSmZTVmFVakpCS3M2R2liR2NPUndrOHpKUjNlMmZtelZ1?=
 =?utf-8?B?dVZwM1N6TS9RRVF1NnhsTGtxb0VIYVJOV0UyQ3o3dEIxK21rYm1obmd1OWJt?=
 =?utf-8?B?Z2dIa2JIeXorR1EzL3orbTFERnhXcXlDWVBWUjdkL2s1WXRIZnJlZGJYbUcr?=
 =?utf-8?Q?OzByPKzTSMfHmVBisC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc0b2e6-61fe-49c8-2972-08da548bfc15
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 20:15:43.2310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cQdoPX5WB8IyKoTe65uxOprothNUIfDKHKGFUAZ5lA8r9GyPR6KfqsVD0Li+RR0gBVBTrLfVAWC9lTZATlQGVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3380
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCg0KRnJvbTogRGF2ZSBIYW5zZW4g
PGRhdmUuaGFuc2VuQGludGVsLmNvbT4gDQpTZW50OiBXZWRuZXNkYXksIEp1bmUgMjIsIDIwMjIg
Mjo1MCBQTQ0KVG86IEthbHJhLCBBc2hpc2ggPEFzaGlzaC5LYWxyYUBhbWQuY29tPjsgeDg2QGtl
cm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5v
cmc7IGxpbnV4LWNvY29AbGlzdHMubGludXguZGV2OyBsaW51eC1tbUBrdmFjay5vcmc7IGxpbnV4
LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCkNjOiB0Z2x4QGxpbnV0cm9uaXguZGU7IG1pbmdvQHJl
ZGhhdC5jb207IGpyb2VkZWxAc3VzZS5kZTsgTGVuZGFja3ksIFRob21hcyA8VGhvbWFzLkxlbmRh
Y2t5QGFtZC5jb20+OyBocGFAenl0b3IuY29tOyBhcmRiQGtlcm5lbC5vcmc7IHBib256aW5pQHJl
ZGhhdC5jb207IHNlYW5qY0Bnb29nbGUuY29tOyB2a3V6bmV0c0ByZWRoYXQuY29tOyBqbWF0dHNv
bkBnb29nbGUuY29tOyBsdXRvQGtlcm5lbC5vcmc7IGRhdmUuaGFuc2VuQGxpbnV4LmludGVsLmNv
bTsgc2xwQHJlZGhhdC5jb207IHBnb25kYUBnb29nbGUuY29tOyBwZXRlcnpAaW5mcmFkZWFkLm9y
Zzsgc3Jpbml2YXMucGFuZHJ1dmFkYUBsaW51eC5pbnRlbC5jb207IHJpZW50amVzQGdvb2dsZS5j
b207IGRvdm11cmlrQGxpbnV4LmlibS5jb207IHRvYmluQGlibS5jb207IGJwQGFsaWVuOC5kZTsg
Um90aCwgTWljaGFlbCA8TWljaGFlbC5Sb3RoQGFtZC5jb20+OyB2YmFia2FAc3VzZS5jejsga2ly
aWxsQHNodXRlbW92Lm5hbWU7IGFrQGxpbnV4LmludGVsLmNvbTsgdG9ueS5sdWNrQGludGVsLmNv
bTsgbWFyY29yckBnb29nbGUuY29tOyBzYXRoeWFuYXJheWFuYW4ua3VwcHVzd2FteUBsaW51eC5p
bnRlbC5jb207IGFscGVyZ3VuQGdvb2dsZS5jb207IGRnaWxiZXJ0QHJlZGhhdC5jb207IGphcmtr
b0BrZXJuZWwub3JnDQpTdWJqZWN0OiBSZTogW1BBVENIIFBhcnQyIHY2IDA1LzQ5XSB4ODYvc2V2
OiBBZGQgUk1QIGVudHJ5IGxvb2t1cCBoZWxwZXJzDQoNCk9uIDYvMjIvMjIgMTI6NDMsIEthbHJh
LCBBc2hpc2ggd3JvdGU6DQo+Pj4gSSB0aGluayB0aGF0IG5lZWRzIHRvIGJlIGZpeGVkLiAgSXQg
c2hvdWxkIGJlIGFzIHNpbXBsZSBhcyBhIA0KPj4+IG1vZGVsL2ZhbWlseSBjaGVjaywgdGhvdWdo
LiAgSWYgc29tZW9uZSAoZm9yIGV4YW1wbGUpIGF0dGVtcHRzIHRvIHVzZSANCj4+PiBTTlAgKGFu
ZCB0aHVzIHNucF9sb29rdXBfcm1wZW50cnkoKSBhbmQgZHVtcF9ybXBlbnRyeSgpKSBjb2RlIG9u
IGEgDQo+Pj4gbmV3ZXIgQ1BVLCB0aGUga2VybmVsIHNob3VsZCByZWZ1c2UuDQo+PiBNb3JlIHNw
ZWNpZmljYWxseSBJIGFtIHRoaW5raW5nIG9mIGFkZGluZyBSTVAgZW50cnkgZmllbGQgYWNjZXNz
b3JzIHNvIA0KPj4gdGhhdCB0aGV5IGNhbiBkbyB0aGlzIGNwdSBtb2RlbC9mYW1pbHkgY2hlY2sg
YW5kIHJldHVybiB0aGUgY29ycmVjdCANCj4+IGZpZWxkIGFzIHBlciBwcm9jZXNzb3IgYXJjaGl0
ZWN0dXJlLg0KDQo+VGhhdCB3aWxsIGJlIGhlbHBmdWwgZG93biB0aGUgcm9hZCB3aGVuIHRoZXJl
J3MgbW9yZSB0aGFuIG9uZSBmb3JtYXQuDQo+QnV0LCB0aGUgcmVhbCBpc3N1ZSBpcyB0aGF0IHRo
ZSBrZXJuZWwgZG9lc24ndCAqc3VwcG9ydCogYSBkaWZmZXJlbnQgUk1QIGZvcm1hdC4gIFNvLCB0
aGUgU05QIHN1cHBvcnQgc2hvdWxkIGJlIGRpc2FibGVkIHdoZW4gZW5jb3VudGVyaW5nIGEgbW9k
ZWwvZmFtaWx5IG90aGVyIHRoYW4gdGhlIGtub3duIGdvb2Qgb25lLg0KDQpZZXMsIHRoYXQgbWFr
ZXMgc2Vuc2UsIHdpbGwgYWRkIGFuIGFkZGl0aW9uYWwgY2hlY2sgaW4gc25wX3JtcHRhYmxlX2lu
aXQoKS4NCg0KVGhhbmtzLA0KQXNoaXNoDQo=
