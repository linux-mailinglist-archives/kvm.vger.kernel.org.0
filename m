Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E534B5554D8
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 21:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376632AbiFVTna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 15:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359558AbiFVTn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 15:43:29 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1B718348;
        Wed, 22 Jun 2022 12:43:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3gd6bUaosKPT7N3nbhapqc5UgevZqeBJ7RvIUOIqdYvocK3k5ArNF/bVgED1qFFmSHKbnSJoUfn4+O1HoN71mio6TwjG6P4RQiYbsdYWvgkoKsb+mkxz6TackUhXuLaobyLEysZVorlTippTppvmulOdanbLyMo0Ifs0icHFKUVfnnWmgeMjZIur8oYaWG7PKmXvSJUuBEWNdsnZb301BBtmuL8oKwSgUQPZCXQoYIbwLmRN2+VJmcoIqOts/M/lYY+7nFrH+wsIKOIBgJjBk4lLTRdHyTJ/2JHfiPAPWYzSM9+QVmLFNUkBS8gS48bY5tfVj1tn+0xQBRRQgfpjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Reh+w2NaKGnHQdVYnmfrOTllIZbC2+s86/g6WL/Nw/o=;
 b=hcrnX+DYeZYVAUtWDu0/URfHPeJpcHwkBuTr65FcSE1FN+dfiMZw8/qe9Jicxle0Qt3dzbWzpFafh0A+kkl6UweAgui1MkH2kJWm+nr1rTm11/vJpiO82AWKzClQmr3KFJSLP+yvXV4QdtHSdfpwBUVSXFHG9oUZ8OvdLlljV2nd2O/xkx6NXUKs472DmvO8Ln1VT0neCVCGPmtkJMU3SBjGFE5KRWz+XD0z5dPv3RrSvLdbykaO04X/JcPIpqVVktescJ3iWEdQqUUHW2kyjz0IbW5daEZbavlg1mPMVPNYNBBmUlNOyzdM+occIs5a5EgRNBWBiHzEgLQFJavHeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Reh+w2NaKGnHQdVYnmfrOTllIZbC2+s86/g6WL/Nw/o=;
 b=M4C7YwV5y754lYwK8gqQyDKkQ9diBAJ00NKvEYvzCXCibFpFG0FxnqKohgsGCp+1KApVEqjdt4Vv7MxPTdJJSM8Q8nkgcEnESZVUbkn3cjckbDiM6WOPrGd77CUWk8GTHu9+ZX1cuKlTtL8LjwFrCP84xaczSWmP3nJG6laoN80=
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by BN8PR12MB3139.namprd12.prod.outlook.com (2603:10b6:408:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Wed, 22 Jun
 2022 19:43:25 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 19:43:25 +0000
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
Thread-Index: AQHYhkJMEjVRVcpx502HVSPCQUlAqK1bejcAgAACPYCAAD2E8IAAAkWAgAAEHtCAAALbAIAAEKeA
Date:   Wed, 22 Jun 2022 19:43:24 +0000
Message-ID: <BYAPR12MB275984F14B1E103935A103D98EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
 <cc0c6bd1-a1e3-82ee-8148-040be21cad5c@intel.com>
 <BYAPR12MB2759A8F48D6D68EE879EEF648EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <25be3068-be13-a451-86d4-ff4cc12ddb23@intel.com>
 <BYAPR12MB27599BCEA9F692E173911C3B8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <681e4e45-eff1-600c-9b81-1fa9bdf24232@intel.com>
 <BYAPR12MB27595CF4328B15F0F9573D188EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <99d72d58-a9bb-d75c-93af-79d497dfe176@intel.com>
In-Reply-To: <99d72d58-a9bb-d75c-93af-79d497dfe176@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-22T19:42:23Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=a0a402b9-8dcb-48de-8b68-9dc6c48147cd;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-22T19:43:23Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: a5af06ae-2ed0-44fb-bbd8-14cf6efe9d21
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e45677dc-39ab-4ac8-0932-08da548778d3
x-ms-traffictypediagnostic: BN8PR12MB3139:EE_
x-microsoft-antispam-prvs: <BN8PR12MB31399E2A0C145A0D3C946E768EB29@BN8PR12MB3139.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a/CXtQTjHpurxX1e07quZgqgCYKWdvEenWVAHCgrvRd5O0+oJ6FI/JkIsybGxamSALlDObuKEniLaZ5EWcg/T1M+dms+8xkPtCu+Ybnb8YRx2bw8jHn38Cxhg8a4KTL+0iEaUufwSKsJNQLtB/wJiko4VCmaH8Csd5qSOgPV4x6NJwAlpq+IxyptP0H+7sHSY5buT8qQ7ZPQHvKWGFE1QEctZ0J8JmzwK4sY+UReS3WwvcjZJEwD24n5dIf/eR/drp09DtT7FLNMwThlFPyuJR+uY+u8y3APGdtznsYiURAoii2RWskThgzVnA1vAEOmj0Mf7Ge/mwJde8NDK9Q0ThYsrLTiNQ7PgmsVhg5f9cc/4va3N7tLIqaP6jywQybceKsV7E6mzkgJgZvB30OTshbE0qaGgNQiNiLprr7SRHszq2Ap2QwesUFogScLPv3AFZHXjo16LX6OShQAW47EkxbZQPPzQA6IqxfAAEPlh5vI0gEenYIFh85E7mRbQxeqeOK2F3T3VqWvAp5Z7M79o3pecs1q79Qf7FnBWLfwlyXeVnuAbWoXh/vEOsqvi0rJGYhFx0COQUrWV+qs3Uhiu0s6xNi7FWEU4aoC3GyReJ7+p2/hzN5QTWumGYfJE7bDatQp7nrLVF02TT/Go0f6ERfQrzFb7XSR443byUjj4VjKZQwdZqIZ3Ssv+jSOrDQqFBeaY/tH5m+oBEhOSeXrz8md6zf/st5oIsRtX77oe/R8UCei6TgG2dM4G8CkqXj+uHTG5N6wuQ6LwIPKdV92Zg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(83380400001)(186003)(38100700002)(122000001)(38070700005)(7406005)(7416002)(5660300002)(8936002)(2906002)(4326008)(64756008)(66556008)(66476007)(55016003)(478600001)(66946007)(41300700001)(52536014)(9686003)(76116006)(26005)(6506007)(7696005)(53546011)(316002)(71200400001)(54906003)(110136005)(86362001)(33656002)(8676002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NXRwa0VCN3prZjkySS9IRUQyUUNsdkhrYlh0a2lEb3lxSEVNVndYRGdCWjNp?=
 =?utf-8?B?d2xBbWEzaEVoMERBODkyd1c5SXNVQjUwMzFPZlZlV2JYUHZ1M1pqZFdzajlr?=
 =?utf-8?B?VFQ2QWRHRGpDaytBUXFZY1FmY3o0WXNvd05EL0JzQWI0NEFiVVhxMjVEblI0?=
 =?utf-8?B?SlYzU2M5NmFWVkdNNk5pVEVzVHNyOXdpVmVVU0RNcDhrcVhYaFlzUUdKN2tT?=
 =?utf-8?B?VWZsdUJkL0lxaXc1Wm85YmlaVWZqakl6ZXdpRGd5YVlsM083aDVPSGJaUmxM?=
 =?utf-8?B?QXhLWHh0OTBsS3VoSzJHb1hwY3BrZHJvdXRjTDJCL3A0Uk04YXBtVEF2WVhu?=
 =?utf-8?B?RVNzWis5NTNmcUlUYTRFYitOa3ZlYUhnVm5nNFlKU1FOb1N5OHc0cXhwbkpG?=
 =?utf-8?B?d2ZUYmF0RUxRblJjRnpLdEQ2L0p2NU1raWFOWDJmZWFHaktabXQ2ZkRNb0Zp?=
 =?utf-8?B?VEFQbTVKMEdFZXM0bEJyWnpmTWNZdnhabWJZdjhvc2dwREZoMmoxTm1hK1U0?=
 =?utf-8?B?QmxMVFA4WHYzcE1mYnRBMUI3M21zeHV6eWdJZkZ1ZUl2UW4vcWcrMDJheG9m?=
 =?utf-8?B?ajZYOFVzbEJLdCsyc2FMRFF2MnF1T2NqM1ZRbEE0M0s0M0RnTU92V0Q2b3Ux?=
 =?utf-8?B?VWJha2dUOW5SeVdxSGNwM0Q5TTM2cmY0VWg1cG4yY1dCQlBPNXI3MTZJRWF4?=
 =?utf-8?B?dU02bWxQMGRMV3NKWkZ0YXl3enE3emxmUTg1V2ZxOFdkQ1A5RDZHa3E3UTdO?=
 =?utf-8?B?a0N4Y1k0eVhBMXVreTZnYnZFZEVvY0t5QXFzV2dPMWhxcW1Sdy8vRjdBMUNE?=
 =?utf-8?B?VWVwMzZYUk5XcjNtY2FNV2pvMkI5ZmpXdVd4V293eFM3VmhGK0VUSkMzeVJJ?=
 =?utf-8?B?TjBMeDZRakhDSlZxNFB6SUh0QmJJN2xLTm1TNWhtZnlQMmVUYm9Gd2hESCt0?=
 =?utf-8?B?YWVqaUx6blorTUErOThTeU9LcDJWbzdxYlNQVjRLNW9lQ1BJeHlzdmt0dWdW?=
 =?utf-8?B?Sk5ObVYySmNpTURHcmpBZFRWVGpOSWU4YWpGd01ydXg1T093WkNjK2NkQU5o?=
 =?utf-8?B?aEpubEJ6UHI0cHR5YU1QTjU1Qk9ac1J6L1ZsOStzQzBnMjJVTTZLb0FDQ3Bv?=
 =?utf-8?B?c3NmSTJVN3pXeGRrc3BGMXZnWTI5R2w2TjFZWW5Odk1VdnR0UXVON0x6N21W?=
 =?utf-8?B?Mk1zNTFRZzcrdUxvbU9BRENkVnJuc3VackpnYmg1c2EyTGNpaDZxNk9VdFp6?=
 =?utf-8?B?SFlodmFseWhKZTBoSjdJS2tzUXA1MGpQa0JQT1hLNnYvTU5KdkxBTnIzQzht?=
 =?utf-8?B?L3lPd2RrMDhJZ0ZNL3FTdExzU3MyRXJmWG5UOGhZMk5PMmtyWVprOFpLQmd1?=
 =?utf-8?B?WTBxbkdSNUY5VGVGMmsxK0puaVA2S1loMk5tN1IxRFQ3MEpMVWFMNGg3bU5P?=
 =?utf-8?B?MzBzZGdzYzh4UzhTaU0xejhzOGxCVFZsRzVBQ0ErU2orTnl6bzU3SEUrcldI?=
 =?utf-8?B?c1FTdjFZbktRYTdSdXUzNG5icElsNld2Rjk0UDMwTUwzd01JK3YvVjNEL2J5?=
 =?utf-8?B?bzFneUZBaDJnNmZwcFJWU29jeXJRVVhIL2ZGbmJEL3BTSFBxNUw4S1lObzBh?=
 =?utf-8?B?YUE4VnNleWxSaHo0WWxLVW44VnU3MXR4RXV5VjJMdHlodkdhK2NPY1lSaFdh?=
 =?utf-8?B?MUQwc1VKREEwUTQwOHdyb3pNNEtUOFNDVnpuZzcvZzlkTHBDekN0RHpCZ081?=
 =?utf-8?B?WSszc3ozejY1elpGQitYWFV1RzhxRUhjNVFURERPSnNZQTJyakQ3MXZ1Ny9N?=
 =?utf-8?B?NXlsdkIzaVhvRWYxdTRlYmwwRUhTRXovd1ppY2t2UDZ3dFo1OHViVGMyWHVi?=
 =?utf-8?B?eHNBRjkrVmJoUkROSkdrQVRzSkdXeE5MQTRSUWVLR1d4U1BBb3d1dHFUWVBq?=
 =?utf-8?B?WU84VjBBbTAvdjRvR1hZT0hnQ2tRWWlIQytydmxjYkRZaFp0Ri9FQzFDZTlj?=
 =?utf-8?B?MWZEM2FGWld3V1I5UXU3WTBqSE54c3R2N1B1bERiSE9UZTV4UDJjMFVPbEQ5?=
 =?utf-8?B?enFCNUxpUTdlUDV5Z2JsdlRtWTgwUWEvdGdRWjl2aDlmMkxNRWpLRFBtalI3?=
 =?utf-8?B?bTAveUpDSXQ5K1Mza1FqM0kyVmtLdjVKd091bk0zM3QydGRCMW9rWFRoOFdU?=
 =?utf-8?B?OWJiSWlKTlhINXJWRFRrNUhJZ21Ud1EvNGdCSjdKT2lTMXB0a2hOb0pyVnlh?=
 =?utf-8?B?UFZFQUZDUjNIU1VSeVJsTEhMMjRYMW5sTG4wL25CN1BnbXJQNDhmblQwdFhP?=
 =?utf-8?Q?xMtqTJ6WbfIEOI7umn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e45677dc-39ab-4ac8-0932-08da548778d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 19:43:25.0136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P0pFD4N8ImIgaePurtIc/YhKWDEnUzyKxP6AfdfgEbgWtTw7dbOLy/xZHQxpzReadS0+8wJJzksGLGORrehkxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3139
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
YWdlLS0tLS0NCkZyb206IERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBpbnRlbC5jb20+IA0KU2Vu
dDogV2VkbmVzZGF5LCBKdW5lIDIyLCAyMDIyIDE6NDMgUE0NClRvOiBLYWxyYSwgQXNoaXNoIDxB
c2hpc2guS2FscmFAYW1kLmNvbT47IHg4NkBrZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1jb2NvQGxpc3RzLmxpbnV4LmRl
djsgbGludXgtbW1Aa3ZhY2sub3JnOyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnDQpDYzog
dGdseEBsaW51dHJvbml4LmRlOyBtaW5nb0ByZWRoYXQuY29tOyBqcm9lZGVsQHN1c2UuZGU7IExl
bmRhY2t5LCBUaG9tYXMgPFRob21hcy5MZW5kYWNreUBhbWQuY29tPjsgaHBhQHp5dG9yLmNvbTsg
YXJkYkBrZXJuZWwub3JnOyBwYm9uemluaUByZWRoYXQuY29tOyBzZWFuamNAZ29vZ2xlLmNvbTsg
dmt1em5ldHNAcmVkaGF0LmNvbTsgam1hdHRzb25AZ29vZ2xlLmNvbTsgbHV0b0BrZXJuZWwub3Jn
OyBkYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb207IHNscEByZWRoYXQuY29tOyBwZ29uZGFAZ29v
Z2xlLmNvbTsgcGV0ZXJ6QGluZnJhZGVhZC5vcmc7IHNyaW5pdmFzLnBhbmRydXZhZGFAbGludXgu
aW50ZWwuY29tOyByaWVudGplc0Bnb29nbGUuY29tOyBkb3ZtdXJpa0BsaW51eC5pYm0uY29tOyB0
b2JpbkBpYm0uY29tOyBicEBhbGllbjguZGU7IFJvdGgsIE1pY2hhZWwgPE1pY2hhZWwuUm90aEBh
bWQuY29tPjsgdmJhYmthQHN1c2UuY3o7IGtpcmlsbEBzaHV0ZW1vdi5uYW1lOyBha0BsaW51eC5p
bnRlbC5jb207IHRvbnkubHVja0BpbnRlbC5jb207IG1hcmNvcnJAZ29vZ2xlLmNvbTsgc2F0aHlh
bmFyYXlhbmFuLmt1cHB1c3dhbXlAbGludXguaW50ZWwuY29tOyBhbHBlcmd1bkBnb29nbGUuY29t
OyBkZ2lsYmVydEByZWRoYXQuY29tOyBqYXJra29Aa2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFtQ
QVRDSCBQYXJ0MiB2NiAwNS80OV0geDg2L3NldjogQWRkIFJNUCBlbnRyeSBsb29rdXAgaGVscGVy
cw0KDQpPbiA2LzIyLzIyIDExOjM0LCBLYWxyYSwgQXNoaXNoIHdyb3RlOg0KPj4+IFNvLCBpZiB0
aGUgUk1QIGVudHJ5IGZvcm1hdCBjaGFuZ2VzIGluIGZ1dHVyZSBwcm9jZXNzb3JzLCBob3cgZG8g
d2UgDQo+Pj4gbWFrZSBzdXJlIHRoYXQgdGhlIGtlcm5lbCBkb2VzIG5vdCB0cnkgdG8gdXNlICp0
aGlzKiBjb2RlIG9uIHRob3NlIA0KPj4+IHByb2Nlc3NvcnM/DQo+PiBGdW5jdGlvbnMgc25wX2xv
b2t1cF9ybXBlbnRyeSgpIGFuZCBkdW1wX3JtcGVudHJ5KCkgd2hpY2ggcmVseSBvbiB0aGlzIA0K
Pj4gc3RydWN0dXJlIGRlZmluaXRpb24gd2lsbCBuZWVkIHRvIGhhbmRsZSBpdCBhY2NvcmRpbmds
eS4NCg0KPkluIG90aGVyIHdvcmRzLCBvbGQga2VybmVscyB3aWxsIGJyZWFrIG9uIG5ldyBoYXJk
d2FyZT8NCg0KPkkgdGhpbmsgdGhhdCBuZWVkcyB0byBiZSBmaXhlZC4gIEl0IHNob3VsZCBiZSBh
cyBzaW1wbGUgYXMgYSBtb2RlbC9mYW1pbHkgY2hlY2ssIHRob3VnaC4gIElmIHNvbWVvbmUgKGZv
ciBleGFtcGxlKSBhdHRlbXB0cyB0byB1c2UgU05QIChhbmQgdGh1cyBzbnBfbG9va3VwX3JtcGVu
dHJ5KCkgYW5kIGR1bXBfcm1wZW50cnkoKSkgY29kZSBvbiBhIG5ld2VyIENQVSwgdGhlIGtlcm5l
bCBzaG91bGQgcmVmdXNlLg0KDQpNb3JlIHNwZWNpZmljYWxseSBJIGFtIHRoaW5raW5nIG9mIGFk
ZGluZyBSTVAgZW50cnkgZmllbGQgYWNjZXNzb3JzIHNvIHRoYXQgdGhleSBjYW4gZG8gdGhpcyBj
cHUgbW9kZWwvZmFtaWx5IGNoZWNrIGFuZCByZXR1cm4gdGhlIGNvcnJlY3QgZmllbGQgYXMgcGVy
IHByb2Nlc3NvciBhcmNoaXRlY3R1cmUuDQoNClRoYW5rcywNCkFzaGlzaA0K
