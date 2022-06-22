Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6976955559F
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 23:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349453AbiFVU6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 16:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354836AbiFVU6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 16:58:24 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2082.outbound.protection.outlook.com [40.107.101.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DFD15A3D;
        Wed, 22 Jun 2022 13:58:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcnraIM1k0kqGubyrhE+eNSjZCIcx0IPV4u79zQppxEAbqIsKuRpdpZzB5Db6nCSnigKG7VdRhOKwh1XKqYHG7WEhheD24FIL8Po6ycrB0Tfnbkh4nF+oEim3R8JZ1gAcoodCZBax9pdRReW7RtlWpfTY1EOde5FR1vOrKcMHllrCotmWOm4JmPN2Zpzj3W9dTk7BzQmy5zOZMo4lipJbR3w15TFgm6ANIfngLJcyg7ov+aQhKB3ES4VI6Su5qhVCmgJY0J720uFCfuYS/x4SdTxiMl07atEx3ZHfXk0glIJbl0wiM+Bv/YMZ5zVxaJyigkCJhtUF7wyM3jeEcFg4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ilFKp6l5J8nl+35HUp8u8cJWuoPfWIwNg069MGnmvo=;
 b=nsuvw78cXhQ3l3x+e2noCwl236WttkhGs/5gsmld8C0CgOoz5rHX6VT8rT8TQctfDhwkjfqYhMTlLIQDJn4NGxT9olMGxLvGQr0oGlmVtwgi6Fr3nm2XBdBhk3wnJ9I6fX9l630WrHtEKbx8VJPr7Voqn1ZEHUOv/BM2Q3M0MQMhW3pUhiA64/cT8PT6iTDBqw7Y0rhDHGhz1WT/jk+1ejWcdLiA/pWCfscxxtgIKFOyvHw2SLzutcgNcrCebwa+yR/bqc8/r4OPekjRRZcW/TE6Cz6jq3PLz6GpYZmLLyto3OyFXDecAqEN8mzVaRj17Tln4o/2dlPTY0ZAZTAT3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ilFKp6l5J8nl+35HUp8u8cJWuoPfWIwNg069MGnmvo=;
 b=wPPXJpIH/RgVkDc4vUdyVWK3L8IZAOAg/APFKK+y16eXsdeh+tG0vH5JUW0rp35ArUK++u2IHJFCcEcRt4jHJhnfF+xglbVbd1a6lckyIOtd851cEykN34/gOY7ZTLZqsrU1Z3RtRi7FGgaFrtmZXQ5TfPfReA616NKXRIrXT2Q=
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by DS7PR12MB5887.namprd12.prod.outlook.com (2603:10b6:8:7a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.22; Wed, 22 Jun 2022 20:58:18 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 20:58:18 +0000
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
Thread-Index: AQHYhkJMEjVRVcpx502HVSPCQUlAqK1bejcAgAACPYCAAD2E8IAAAkWAgAAEHtCAAALbAIAAEKeAgAACGACAAAZmMIAACaIw
Date:   Wed, 22 Jun 2022 20:58:18 +0000
Message-ID: <BYAPR12MB2759B4A927143CAC45B49E1C8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
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
 <BYAPR12MB2759AA368C8B6A5F1C31642F8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
In-Reply-To: <BYAPR12MB2759AA368C8B6A5F1C31642F8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-22T20:47:44Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=fda49e09-35d6-472c-8ade-863650d37082;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-22T20:58:15Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: bb17edb1-54b1-443a-8f22-701dadf10731
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fdf86356-2912-441b-d627-08da5491ef00
x-ms-traffictypediagnostic: DS7PR12MB5887:EE_
x-microsoft-antispam-prvs: <DS7PR12MB588713FF33CC296DB7B92C618EB29@DS7PR12MB5887.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hR8vASI2TWcT8hwEpLbUMVOL7Rmi6eVjHiQScJNpTbicOLjlXwe0b+cdjYePtyh1JLHbcNAYKMS7P8zTBzLGJkd4cVfZpEgm4+l6096nYhlDJUgucpmHvsecHRZapjXquZ4jVL0SQ2lRgFehw8RgjkUrsdq3a2jGzLQGVXUmZ5tTuxtQFejm0ahWaqqf3Q2Yi7zijc24KjIF2Qk6l13dd1ntITm/FyZ4QmjQIR7rrXBvkIedrY4jSGHv8E14bKOaNbBjiQPhBqyKjI1E0CQpVwB9RsCyfBkOq7Ykq0O8VSrUPcEBWxG6h9afpEkf46LZ+qR86cv62Zust3yCIva8UH/fgGYXtC01ZJvTr2iM9OyJpZp5iIe0XG++GydrK8pmSvgnuvLjtPGBRiPwfosGZFam2BZINp89NycrVJraEW0jKDDWp/3PWTU3BTumsXlStKCIyolUn7GpzuhVefOFuo1xrKWdtjiq14Imp7nfV61N88EdxxyrcOB6fInK+mNP2X78VzwEtVpcLugmNJTzkidKlzybKHoTBZkGLIR8xocHm4eMSyIq8csgCu27qE8PP6w91dlwXKN17YWLAAF8XSHSafvpsQfxsMe/TwZpI9MAEA3tkY3CEdkNnDudEnBsXXdd841YHnHXoucltiYKVyoLWa+PjxvcC3/SRTCn/KXbERQUSv9sWOOWpPdMZDYRiR2iByMVPbNfy7tgjFzoUIBoroqJoCFHOL75TxCdbRlwT6se/37yXusNiNVNEqxFuECnuLoStTXnXCvjghju7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(41300700001)(7696005)(26005)(186003)(9686003)(122000001)(38100700002)(2940100002)(53546011)(86362001)(6506007)(38070700005)(76116006)(64756008)(71200400001)(4326008)(52536014)(33656002)(66476007)(54906003)(66946007)(66556008)(8676002)(2906002)(5660300002)(7406005)(478600001)(7416002)(55016003)(83380400001)(66446008)(8936002)(110136005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blBXbFVyRW84RWsxQ2R3QUxYdndIeU9BMFZnZCtFZ1JBTFo0MDBQS3d1Yzlp?=
 =?utf-8?B?Y1ZjRXFmOUUxaUExK280b2RoWS9FbGlJdzdBUU94NTdTaU5BVnN2T3d0Z2pC?=
 =?utf-8?B?QXRvTUVWZWJYT1hxWmZKUjdyVlhsbG9TMjRFeFlXQjBTTm9SajdNL2VjY2lk?=
 =?utf-8?B?Q2tmV1ZCTDhjS0s4YTROZ0oySXBtcGpXcXdNa3dwMkxzeUR5dFdCZ2sreUoy?=
 =?utf-8?B?MDVORWRwUkRMN0czcE5mNFg1amx3eGF1SEVUSXJTVzhUTlFjYXBGYTdtc2ZL?=
 =?utf-8?B?WU9oTWVhVlVhUmkwOWduTFhWdHJmejZvcFN2bTBBUTdjMDN3UHF4emRDRXRN?=
 =?utf-8?B?bXNFb2NNUENVRzZhS3VkdklscUNtaGJFR1VYTjJJN0FKWWJxdE12aW5lTEdI?=
 =?utf-8?B?bHZPTDNqNlZvK0NmOEV4R0NxUXlMUGRxdXc1MnF0MjJrR25zYXRwU3lVT0pB?=
 =?utf-8?B?MHEzdDVvZ0dtVFZiVTBMMkdvTjB6TlI0eFBDQzVwbnZ2Y3pjb01NcjlDTjRX?=
 =?utf-8?B?aFErOUFwSWIyZ2pxMWdCdDRMc0w1T1lRQ1VZQTRLN1E0L0pQUWp5Y2pDQUV4?=
 =?utf-8?B?YzJOUzlIbWRoU1JYWDdjRDRxTm1rSTNFTmV3OGxNUnBxUTJuclFEbHdTQmJE?=
 =?utf-8?B?a0J0WmVoUGpYcXBMOVg4eUN1bXNTS1JWM1JPbnNKOEVjZExpWXVsaFBYaGF0?=
 =?utf-8?B?YXZCVEZQVFJaRVVuVGVYZmRHRXZ1Z2FBRXlSR3ZZU2EvNjRZelhnS0g0d0Rv?=
 =?utf-8?B?NFNTaWd0RnBuUWFDWXNrZ20zMWh0MlozaEMzRkZKNW5naFlsd0dDT1RwczM0?=
 =?utf-8?B?cC9HcGd4WXpMMXRlZHdTUmMrZU1jNTdkZGtVVXpQUGdSVU1NdlZIcHRvUzhD?=
 =?utf-8?B?Qkt5TDlYRDN2YUlHRVZNOFg5TXZqN1F5QVVKWEdPTVZ6NE9IMzJrZUt1WGtV?=
 =?utf-8?B?cWNrWVBrdVJvR3Eza0FPellyS1VMVWFGcXBBazAva2tMVmhoc2diV2U2QU9C?=
 =?utf-8?B?TjZnM1pSanVmcHRNRnlWUDZkK1hITStzaVFQaGNOOXZiWFBxbi9kaWozOEQ4?=
 =?utf-8?B?MzcyMGdQN2xaT0pEUElacHdWQW1oam9sdmxWeUQwYjU5MVNNdUdHa1Y4eG9D?=
 =?utf-8?B?RExLdmpOMkJZd2p1VzY2UVFKaHhpRjBlYlYraDRuUEhCOGYxSDVTSThzOUxr?=
 =?utf-8?B?Ynp6UUhxLzd4N21MQkNMRUhuWlJ6Wm9LbXd6a0JFQ091b3BNTjQwY1pRNlVI?=
 =?utf-8?B?VG5nRkJ0NzltZmIrVzhPeGZQdnVSKzRFSDVDSEF1bkI2MDIybGM1RTgxSDhS?=
 =?utf-8?B?cTkxYnhBUElGRVU4akdkdjBURW1ZVk1oSXM0SUZQeDduU1dtQXNvWWIzV3NE?=
 =?utf-8?B?T3dlZDl1ZW12U29hUDEwMHVKdkZadTRNTXVyQ0dnSGplT0t3Rk0xUThVOFJM?=
 =?utf-8?B?VXozdmtHYy9RT1E4WXA3OWtRM0duWkg3SWpLVTk2RUhXUnFIMHVydGU5R0J2?=
 =?utf-8?B?WlhJcmhTMkMzUUZrMDhiTlo3WElxVTIrWkw4SStodHlQbm1yMzB2anNUT1RF?=
 =?utf-8?B?OHM2M3FiVmVZSlozTjZtQnRGb0RJQ2V4YmdmUGowRkpNaXNwQXZJZHpSRkg3?=
 =?utf-8?B?a2kyY1NFcFZoZGs2Y0cwZUdSM1JlUERoLzl2QnRMRE1QSk1WZnFtZWhCOUlL?=
 =?utf-8?B?Y2JMNFJvU1VIOHhsZDhjQW1oVGZTOWxQVmFLOFZxZVNmT29Ua3RhUUk5Q2lG?=
 =?utf-8?B?Y0E4VHVnVFUyUWl1UkQ4RXFLNkUwU1VYUlY4TUVTQWlxOU1lcll4bGliajBQ?=
 =?utf-8?B?bVFRcmplUlh3MHFIQ21ST2NESjBhRGlBT1FFdTByTUlkcFdPR0FtQlJvWS9t?=
 =?utf-8?B?NWlhdHJHNVBlMS9wMDk4c0dQV1lPRTVBeW1OajhzMkZueHA3UEc3Y2FTdWVC?=
 =?utf-8?B?YXVzR0M5V3VTV2lwU29hUEkyb2JhZGNWVUU1UzBxV2tGTEJIZGtJcE9KMkVn?=
 =?utf-8?B?TkdVRGZjRXM3bkduQ2hvcUlkU2hab3dmbGFuSy9RWCtYSWwySW42TmlOcjdu?=
 =?utf-8?B?a3ZieWxqdUsrWjdPZXpCUDhhMWd0RzdqWit5UGQzT05ua1RUNW45ZlEyOGZE?=
 =?utf-8?B?QUFOVmM4ZUd4bFo3U2YraWlVVkp0OEwzYUNSb3lXWVVEMXRkN3Y2SkxxajlI?=
 =?utf-8?B?U2hUMUJ3QWluSWw3NDluQmdValVLNXlLQ29wUlRDaHZxdnNPdFRzV2NMR3dX?=
 =?utf-8?B?RHFCdE5BMW1xb3paWHBnNlJuZjBJOWFYNHBTNFlzYnZBckpYTjlNT0xDZ1B0?=
 =?utf-8?Q?+18hA7VuZ+lzV+1NkD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdf86356-2912-441b-d627-08da5491ef00
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 20:58:18.2834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DowxfwaLjf8en60MXuAQGqQdgrPXQ1xd3PEmn1RO6oqE+hMxQy6JOg7uzWldBSG+oWrGWBpRRrh1JW4Egr1TXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5887
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W1B1YmxpY10NCg0KRnJvbTogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4NClNl
bnQ6IFdlZG5lc2RheSwgSnVuZSAyMiwgMjAyMiAyOjUwIFBNDQpUbzogS2FscmEsIEFzaGlzaCA8
QXNoaXNoLkthbHJhQGFtZC5jb20+OyB4ODZAa2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsgbGludXgtY29jb0BsaXN0cy5saW51eC5k
ZXY7IGxpbnV4LW1tQGt2YWNrLm9yZzsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KQ2M6
IHRnbHhAbGludXRyb25peC5kZTsgbWluZ29AcmVkaGF0LmNvbTsganJvZWRlbEBzdXNlLmRlOyBM
ZW5kYWNreSwgVGhvbWFzIDxUaG9tYXMuTGVuZGFja3lAYW1kLmNvbT47IGhwYUB6eXRvci5jb207
IGFyZGJAa2VybmVsLm9yZzsgcGJvbnppbmlAcmVkaGF0LmNvbTsgc2VhbmpjQGdvb2dsZS5jb207
IHZrdXpuZXRzQHJlZGhhdC5jb207IGptYXR0c29uQGdvb2dsZS5jb207IGx1dG9Aa2VybmVsLm9y
ZzsgZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tOyBzbHBAcmVkaGF0LmNvbTsgcGdvbmRhQGdv
b2dsZS5jb207IHBldGVyekBpbmZyYWRlYWQub3JnOyBzcmluaXZhcy5wYW5kcnV2YWRhQGxpbnV4
LmludGVsLmNvbTsgcmllbnRqZXNAZ29vZ2xlLmNvbTsgZG92bXVyaWtAbGludXguaWJtLmNvbTsg
dG9iaW5AaWJtLmNvbTsgYnBAYWxpZW44LmRlOyBSb3RoLCBNaWNoYWVsIDxNaWNoYWVsLlJvdGhA
YW1kLmNvbT47IHZiYWJrYUBzdXNlLmN6OyBraXJpbGxAc2h1dGVtb3YubmFtZTsgYWtAbGludXgu
aW50ZWwuY29tOyB0b255Lmx1Y2tAaW50ZWwuY29tOyBtYXJjb3JyQGdvb2dsZS5jb207IHNhdGh5
YW5hcmF5YW5hbi5rdXBwdXN3YW15QGxpbnV4LmludGVsLmNvbTsgYWxwZXJndW5AZ29vZ2xlLmNv
bTsgZGdpbGJlcnRAcmVkaGF0LmNvbTsgamFya2tvQGtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBb
UEFUQ0ggUGFydDIgdjYgMDUvNDldIHg4Ni9zZXY6IEFkZCBSTVAgZW50cnkgbG9va3VwIGhlbHBl
cnMNCg0KT24gNi8yMi8yMiAxMjo0MywgS2FscmEsIEFzaGlzaCB3cm90ZToNCj4+PiBJIHRoaW5r
IHRoYXQgbmVlZHMgdG8gYmUgZml4ZWQuICBJdCBzaG91bGQgYmUgYXMgc2ltcGxlIGFzIGEgDQo+
Pj4gbW9kZWwvZmFtaWx5IGNoZWNrLCB0aG91Z2guICBJZiBzb21lb25lIChmb3IgZXhhbXBsZSkg
YXR0ZW1wdHMgdG8gDQo+Pj4gdXNlIFNOUCAoYW5kIHRodXMgc25wX2xvb2t1cF9ybXBlbnRyeSgp
IGFuZCBkdW1wX3JtcGVudHJ5KCkpIGNvZGUgb24gDQo+Pj4gYSBuZXdlciBDUFUsIHRoZSBrZXJu
ZWwgc2hvdWxkIHJlZnVzZS4NCj4+IE1vcmUgc3BlY2lmaWNhbGx5IEkgYW0gdGhpbmtpbmcgb2Yg
YWRkaW5nIFJNUCBlbnRyeSBmaWVsZCBhY2Nlc3NvcnMgDQo+PiBzbyB0aGF0IHRoZXkgY2FuIGRv
IHRoaXMgY3B1IG1vZGVsL2ZhbWlseSBjaGVjayBhbmQgcmV0dXJuIHRoZSANCj4+IGNvcnJlY3Qg
ZmllbGQgYXMgcGVyIHByb2Nlc3NvciBhcmNoaXRlY3R1cmUuDQoNCj5UaGF0IHdpbGwgYmUgaGVs
cGZ1bCBkb3duIHRoZSByb2FkIHdoZW4gdGhlcmUncyBtb3JlIHRoYW4gb25lIGZvcm1hdC4NCj5C
dXQsIHRoZSByZWFsIGlzc3VlIGlzIHRoYXQgdGhlIGtlcm5lbCBkb2Vzbid0ICpzdXBwb3J0KiBh
IGRpZmZlcmVudCBSTVAgZm9ybWF0LiAgU28sIHRoZSBTTlAgc3VwcG9ydCBzaG91bGQgYmUgZGlz
YWJsZWQgd2hlbiBlbmNvdW50ZXJpbmcgYSBtb2RlbC9mYW1pbHkgb3RoZXIgdGhhbiB0aGUga25v
d24gZ29vZCBvbmUuDQoNCj5ZZXMsIHRoYXQgbWFrZXMgc2Vuc2UsIHdpbGwgYWRkIGFuIGFkZGl0
aW9uYWwgY2hlY2sgaW4gc25wX3JtcHRhYmxlX2luaXQoKS4NCg0KQWxzbyB0byBhZGQgaGVyZSwg
IGFkZGl0aW9uYWxseSB3ZSBtYXkgY3JlYXRlIGFuIGFyY2hpdGVjdHVyYWwgd2F5IHRvIHJlYWQg
dGhlIFJNUCBlbnRyeSBpbiB0aGUgZnV0dXJlLg0KDQpUaGFua3MsDQpBc2hpc2gNCg==
