Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2225554CCA
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357879AbiFVOXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355627AbiFVOWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:22:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0BA1AC;
        Wed, 22 Jun 2022 07:22:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoQ6LLYna3/YlOswVjYOBrPmLV/pQWn3lJSmuqlasu08iaDTsHGX6ArlW55HG/EZdOB7iTErNJm8RoCthdcj9lhm4Da6d85Ku1P0gdA1E7htj1Jd54bDZCs24aoPPksiARLMeVSLCxfue5rFSdBU2j/rS0qcYKjaOfS+sO30k0Fr2XpZWAym8VdWd2k/K+28qxddGIHMMl8IMtCcNgk2yqZIKqSnuX3SMKuG7AlqBtCX2blJ2VKoOlajrfgUHKTrpWJQ3rdHWTR0AwOdvzT7zSa1HqG7+N6LBxnFn0DebB0WIf1HUZwdxbxuCEZ31TmaFLT++VvVx+q2Jd1Z5QTEFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38fY2JiiyDDhnVfwc9tIo9qDOgGsmAxrBg4U6NCTmSg=;
 b=XWyAL7ta9wCOrGe7HNj64mqfQSKFEIvsgDSDE3/gjhffpcgYO4SfUbiCdoHkl96IZsLFGUqY+ShJxmJn0d8JET7wFaaZAh6jO/2joqvJmZiW4u9B7rwFPs0SLMD24UHHzwyUvmNLcHLiVAcfq+vPTttsdtROAvMPv++VwhsTPCWmh+RVtsx3oxORgFyOmedqt0a6iRZFErG3Vodx2uSEbrafcs/kwLOheAHlN9G0kpIdm0B9xZ2ptMyZeEr0V5KnawTPerwWt9hGlD6k3BAaDASbMGje+7o66SxUa/z5ElIQkvoGFzLb3A8dQjf/K4mHPGAK8/theq2tpMEvw6gt+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38fY2JiiyDDhnVfwc9tIo9qDOgGsmAxrBg4U6NCTmSg=;
 b=bekhtOZsczCzclJA7HAQeM4SnGLPAzzyaD5JaeypvxDvG0gk6DidgfrjQ21m8vrfvik9xeJ7ZZO3G1IXFooHQjU6vthNyGBF2rDJj/CQZ3+9bJNsRaj32TrRCFWdPvtD74n06kK38wCL7w6CEUJ7O5X5tMD660kZ0CsElave5uc=
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by BYAPR12MB3046.namprd12.prod.outlook.com (2603:10b6:a03:aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Wed, 22 Jun
 2022 14:22:49 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 14:22:49 +0000
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
Thread-Index: AQHYhkJMEjVRVcpx502HVSPCQUlAqK1bejcA
Date:   Wed, 22 Jun 2022 14:22:48 +0000
Message-ID: <BYAPR12MB2759A8F48D6D68EE879EEF648EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
 <cc0c6bd1-a1e3-82ee-8148-040be21cad5c@intel.com>
In-Reply-To: <cc0c6bd1-a1e3-82ee-8148-040be21cad5c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-22T14:21:31Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=682e1a34-0c84-4483-bca8-6e16b766328e;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-22T14:22:47Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: cb933796-75e4-422d-a6dc-bdf8a9daa4f5
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d8cba71-03a6-49de-414c-08da545aaf44
x-ms-traffictypediagnostic: BYAPR12MB3046:EE_
x-microsoft-antispam-prvs: <BYAPR12MB304608F0097AA0286138E3A28EB29@BYAPR12MB3046.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ha028hFOvr7ee9zyPZuxUzvAv8Ew5FwCmn3AkTDF2TRs3AAyBYtC786xOukPWeW/fQc4Vx103S6B+lytoJeyVPyMIHI7sZy2hK/N0e/pcKZ6Ek2epgyvskYK6NL5Lw9u9cxn1WpnG8wBWjiFjEHfej2cbY0DSwkKS69uyat+pR4vREyD83lkqYa7t3muircWX6Y0y7qPFly//KE2GXyFhA2Ws2PNgFWMPBFQ0iAy/DebDCMI7In8MHvQ9IUkT4MlxnPzombK1GOVDAPKu91nr6Z9U2sbKt6t/885roIU+nOBvHgWyEamSXgdx1JRj7TTeD0E5QZfG9gex6L5Int71JbGNSJQ1dD7rxIsPIUqFx0qLWaEcBD56+ONHZwdatF8imelc964twOmCI8lfBLJ31qbQlKHYyONPDLth4MxDp5CG5Fue/58ZBoUhffMPk4ES6WY7aFqqwQ7j/aXIXIUasrbbSaJa1Rzr2YcsxJyaV27SAnenAbEJx2BnntGSkWFEKTWF9UlVbQU+XPtKObsX24ITqrdPkUOQ+4rjaj6poPYQhfgKkK0rKrZ2MX9Oujr+R9lGjZ+CrMiahNe0tgBNbPVuKGnKW6IvK05EqPBhOgWkZm5F+eQHL+k6Nw2L8pLp+VRtEVBCiw3N7bRPGJml2qrFom9y4ApV3kKB2rw14bbk8UjSwpqLGh6VIbXc+r5OBq1gayF4Easpwp0dENca78xrm0Z0qhmVyAXoove+U22Ozoq9VtMGKSGeJa0BxB9kI45DUrVxIMhemWgb/tgFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(4744005)(52536014)(7416002)(5660300002)(478600001)(8936002)(186003)(55016003)(7406005)(7696005)(6506007)(86362001)(26005)(9686003)(33656002)(41300700001)(2906002)(316002)(76116006)(66476007)(66946007)(64756008)(4326008)(8676002)(66446008)(66556008)(38070700005)(38100700002)(71200400001)(54906003)(110136005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFQ0MzZJNTFESVpWclljTDFTQlgrQlJMWjY3K09uQkpYMmpKSEdFaDFERVhP?=
 =?utf-8?B?UmpneXY0Vk80aTVYbFN2MWR2b1lrc01uMUdMUy91ME1ocGtkYWxUVHZmTE94?=
 =?utf-8?B?Ti9nN2g0bmZySkErMzF1d04zSStURm5TbmkvK3U5RjF4VENZakp6bXlkT0o3?=
 =?utf-8?B?WnA5MzIyRVNxcnEyN3A2bEVybkFQaGJidmZtUmRXVzZvYVlMcWdvMUxHRUtK?=
 =?utf-8?B?akgrQVh0ZStTWStOOUcxUkRUYitLeU4zNVQxbUtkczBMWUxUR1NWaXpabWhn?=
 =?utf-8?B?OS8wMW1wVFFGSVFnOUQrR2dFQVhoUTJ6aEpqdXJjRmNhOE51cGNlaXhleXVu?=
 =?utf-8?B?TDgzalZ6RVVtQVVkZnBNRUpZYm9jNVovYkpiV1NtQ0VrMWpCTk14UEUzZTFZ?=
 =?utf-8?B?TndjTXVicnM4UkRmQ1V3UXJFd2JCUWZGZ3JQcWJ0SDVvVTIyeGovUkJRRWlK?=
 =?utf-8?B?eGRWSDlPLzFWcjQ1MDkxdDMyQUh1MzJubzhtUkdlNDFLUlRpUDdPQ1dkUi85?=
 =?utf-8?B?L29KL0ZNWkNSd3kzQXFWTGFUZEJxUUJQV3V0OUYxMWxOVVhlSElHUS9yYkRW?=
 =?utf-8?B?eG5WbjF3MGR4T2FwMXdMUThXUkM0SFpXTFdyTm1ETVVtSmM5dC9PUXZPRk1u?=
 =?utf-8?B?Unc4ZzhheDRHNWlaM1ZEQWliempiNGZ2bDNEcUNYdHhBUkdTRk04ZVpVQ1Fm?=
 =?utf-8?B?aWo1NXQ1YlBjQThpak9RdDBINUpOZm83WGdLNHpoYkFIa3VGM1hjeFIxWkI4?=
 =?utf-8?B?MnNqczk5bkhocElSWDJoS1ZZcTFqOXEydGJzNHVsOCsyZ2poVnNLNjY5eWpO?=
 =?utf-8?B?Yjd6UVI2U3dIUXF0OHJuZk9RM1RBY3NFVG1ReFB2UmdUN2RpQ1BqcVF4Zi9W?=
 =?utf-8?B?bklrb2VncjF5dkd1SytlS1Y0aVFxZkxFQ0RpLzhGb29jMjI3T0VaQ3VGVmlZ?=
 =?utf-8?B?a05lTmt1THVkNVVGRXJxSUhGMklSWTBIVGhsL2pmaEwvTG1hRnpSajRzTUpF?=
 =?utf-8?B?THRONmR1cFBpUmpLRDM5bGNzMTB5dDUzRVVTSWZlT3o4NFRXQkJDa0JveFM0?=
 =?utf-8?B?dzh5aEwyZS9aZm1tWDlWMVhZcDY3Y25KMEJXQWJxK25RN09GTEJrbHRsUFdr?=
 =?utf-8?B?WmJsd0Irb2NPY3E2VC9aVTlYYkhsRDlJODd1Q2tXQVh3a1phMms2bWJINkhu?=
 =?utf-8?B?YTNOOHpIdDhuaktpbHdrcks3NnZiSUJGU21tRThiTkU3RGM4NUdLUFVaQm0w?=
 =?utf-8?B?V3dqK3c3N1BaM3hyQWFGN3FxZkk5b01VUlJqTVFiNmk2Qkw5ZkZJSUJIU3dQ?=
 =?utf-8?B?bzZqSndEbW5kSEFISElMdVB0am9RdnhBb2Z4MTljSllWa0FRZG5XU1IvY3Q5?=
 =?utf-8?B?NENRdFZWSHB4d2lvR1RYQnE5ZmUzUjhtcmxrOFNPZXFHc1UwM3B3SDMvVmVQ?=
 =?utf-8?B?eHhpQ2ZITktUYUR6bkUzU2lCRk9URTJRWW5vSktaQ1N3TmN0U0kwZi80d0JU?=
 =?utf-8?B?aURZWlhSUDVXWmlsWWZ5UE5SQVcvQU93UEFqVDhwY2c0Ym1XL2lEQjduSVBR?=
 =?utf-8?B?dmx0QkRyTVZVYjZ1L0NQcm94OXlCZlUrRGRFWmhxNUwvTS8yQWNCekd6SWFB?=
 =?utf-8?B?VVJlMnFORDUySWc2cFNQdWVxd1JMcWx2WVNUcWo5N0IwcmhERHZOdCsvNjVj?=
 =?utf-8?B?TFZNbUJ5SkJ3eEVGaGNYM1VwZUxmU2R3bGFFREUzZDlUMEVObEdPZ2V3dkM0?=
 =?utf-8?B?b3drRWFlaUlYVFN1L3M5dWl4U1VJRlJTM0NwSmJwSHdrK3JpRTMwQk8xMC9u?=
 =?utf-8?B?cHV6dHN4TTNMbmhDWGlub3gxbFR5Yy9POGMvNythN0JQSkVHZTNwTVNZZmxn?=
 =?utf-8?B?TDVTbnk3bHZLczJaZElKVzQzSXdUL21YWWdOenB2a3dzbmxNWUZsQ1o3eXBm?=
 =?utf-8?B?Q2NmMldJdVRsOGJMUnUzNDhNRW85QXhnQ3k1MER3Mm1lcU1BNCtHNG8wT0p0?=
 =?utf-8?B?aytMMFNiUkc2Sk84UlVCc3E4cU5wd3lGM1JhcHgrOUhKNWhHQUFDVXAvMk91?=
 =?utf-8?B?WEtiZWozTW5hOUgwQmVpMS9QY0ZYYjhVeEZxWVd1R2tTYm9nTDNlOGlHK3Nl?=
 =?utf-8?B?eC9pTXd1MDZ6cVVYc3ArK1QzYTE5SVNkT3M0eklsMG9sd0N3MFpDOVBGUGMv?=
 =?utf-8?B?Z2RtbFVYSWoxdHoyRjNjc1dkVDgvU0hUcDg5UEJubCthY2dPeTFXNjcxZ3BR?=
 =?utf-8?B?RnRwTFJxUE5KWS9FV1hqbDE3a25SVzREU2lJdVordW1zRVBITUUxVkZZaG1i?=
 =?utf-8?Q?QVykA1djoBDPaivBhP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d8cba71-03a6-49de-414c-08da545aaf44
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 14:22:49.0153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BEfjmAysSKPIs+tP5x0fNbvup2q74Y2vA66oo7wDAyPxRIIweKcW1hRVI5oTvCJyyXwzwXor+T+rbaxQUGPF3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3046
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCj4+ICsvKg0KPj4gKyAqIFRoZSBS
TVAgZW50cnkgZm9ybWF0IGlzIG5vdCBhcmNoaXRlY3R1cmFsLiBUaGUgZm9ybWF0IGlzIGRlZmlu
ZWQgDQo+PiAraW4gUFBSDQo+PiArICogRmFtaWx5IDE5aCBNb2RlbCAwMWgsIFJldiBCMSBwcm9j
ZXNzb3IuDQo+PiArICovDQoNCj5MZXQncyBzYXkgdGhhdCBGYW1pbHkgMjBoIGNvbWVzIG91dCBh
bmQgaGFzIGEgbmV3IFJNUCBlbnRyeSBmb3JtYXQuDQo+V2hhdCBrZWVwcyBhbiBvbGQga2VybmVs
IGZyb20gYXR0ZW1wdGluZyB0byB1c2UgdGhpcyBvbGQgZm9ybWF0IG9uIHRoYXQgbmV3IENQVT8N
Cg0KQXMgSSByZXBsaWVkIHByZXZpb3VzbHkgb24gdGhlIHNhbWUgc3ViamVjdDoNCkFyY2hpdGVj
dHVyYWwgaW1wbGllcyB0aGF0IGl0IGlzIGRlZmluZWQgaW4gdGhlIEFQTSBhbmQgc2hvdWxkbid0
IGNoYW5nZSBpbiBzdWNoIGEgd2F5IGFzIHRvIG5vdCBiZSBiYWNrd2FyZCBjb21wYXRpYmxlLiAN
CkkgcHJvYmFibHkgdGhpbmsgdGhlIHdvcmRpbmcgaGVyZSBzaG91bGQgYmUgYXJjaGl0ZWN0dXJl
IGluZGVwZW5kZW50IG9yIG1vcmUgcHJlY2lzZWx5IHBsYXRmb3JtIGluZGVwZW5kZW50Lg0KDQpU
aGFua3MsDQpBc2hpc2gNCg==
