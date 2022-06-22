Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B473055534F
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 20:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352029AbiFVSem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 14:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbiFVSek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 14:34:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0043219F9E;
        Wed, 22 Jun 2022 11:34:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQprE6nqLTh6ms49RkEAzaxjxnJnZSgeEWC08cmj+fMHgdCdUoxlUhldfzbSoRcFWzrenRBwaEYYfQ2Y2+uiyJazHjMg95YISRxkVPIh1OevibCKxGIjneX/cjNfhbQjDxHz2tPtWz5Rd1lJYYlfMMMNF4BtN0a4R4Sy2QueZWDOyrKRrI6amfSFc4Ux9+qsnJaR735f7OCinobqDjjb38+1YEZ8XLzNuw65CxO6e3J72rGIb3KRuw3CauTdtJv2OZGCllESgbIM6yTbosoMc1FSUs0tXeMWrjSADlF7QFpWoaemK/Lha5w5yEUvEgblli+qVqtkYNdIADaEeZv/2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lmWbZgJyuse3aWy/xbsKRRApq1aDc/m9nUesJ01+lzY=;
 b=i7cO+IeBPn54nPrMedeD1GeZz/qDEE6Kd12IB5p1/wfqAoBU9XapRHzs7eWnABS2j31GhsWBUMtYOfmdOq7wDPbjUFG1ZDRu17dO9J9BFice+8mDC0kwvKl43vake3rnqRhDLbW6W091lZrbovjuPDKltz+p9gpVqVhe9MsHkP7Kp1zHDgw2FlXzcPWF6W9BsqCoeInjPY1+K5O5RvjCsT2Wqb4TgcEY/WtqyKdPfwRNV+I/BjuPf4EjQczqVYzogPhLhD1zzW4F0E05DAuU7Q9I0oGg6bbUC/HYUyV8gKRdESFcely391WlZ3+mCPeXbphu511BexCHkcJWVTjcbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmWbZgJyuse3aWy/xbsKRRApq1aDc/m9nUesJ01+lzY=;
 b=CdflVEQE/Oayejj9KekJSK3IMDhGqYrGlNpmiRfBBLP8eKN4r73sPkljQXCdz8xRyyYVJeF7+FcJyhMMzuarlTXBAgifuKZTQPn7Nb6ijCGaOGGgwcKJSh+gD0ubutjGn2M7mLIE15z9g1GZxGfvXTejgfARx/zdXjJ2EV6vYbk=
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by MN2PR12MB4408.namprd12.prod.outlook.com (2603:10b6:208:26c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Wed, 22 Jun
 2022 18:34:35 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 18:34:34 +0000
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
Thread-Index: AQHYhkJMEjVRVcpx502HVSPCQUlAqK1bejcAgAACPYCAAD2E8IAAAkWAgAAEHtA=
Date:   Wed, 22 Jun 2022 18:34:34 +0000
Message-ID: <BYAPR12MB27595CF4328B15F0F9573D188EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
 <cc0c6bd1-a1e3-82ee-8148-040be21cad5c@intel.com>
 <BYAPR12MB2759A8F48D6D68EE879EEF648EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <25be3068-be13-a451-86d4-ff4cc12ddb23@intel.com>
 <BYAPR12MB27599BCEA9F692E173911C3B8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <681e4e45-eff1-600c-9b81-1fa9bdf24232@intel.com>
In-Reply-To: <681e4e45-eff1-600c-9b81-1fa9bdf24232@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-22T18:32:33Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=a20dbf1c-58a0-4fd6-a667-cdca5a3b0f21;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-22T18:34:32Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 641ad002-68fd-4cea-a347-3a842b25a4ba
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a362229-d015-4317-3afe-08da547ddafa
x-ms-traffictypediagnostic: MN2PR12MB4408:EE_
x-microsoft-antispam-prvs: <MN2PR12MB4408424739AC95CBED3E48FE8EB29@MN2PR12MB4408.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eqKK5R5L6hLB7U1fyFiaZECj0gSx+zMybKN6amMdcOIcttP/gAmUDUlH1mypPQs8mvqLC6/LoOpYIDqT5hh1xHJ4qZUNAZflJu2Je6c6C3J81OmkbZg6yDLi/m5sENh8ebZYZlsBa6UTA4cf+/X5g18h0krAK5B0Kz15rQhPtIYWPijjvuUtN1k2BYrVI2wpxj0bqoD06hAksv2qp+ydOmX1XH0TfWu6RL4Qp0G1NjD0v5Cbe2riakN4HfRn7GAnLUYHkzY4+HKGaiZjrxdmMTmWKm6M8rwe4Xjb6GRtP2XB6bllhxdlah1B5/ukYcUiBvJGrXXdb2VpZar501BC1bC00hyokpUyTvkvYNQFOP4niCBQAh+X1LmkxYC9Rgy0nZryCBf3uwpRJqxGglJu58eirjz/pnoEZGIqa/M64A8mp+nNcllR53hYwAxhf9Gepg4v5ImLlTJGR+DrPBdwaUldUrgGLmTSHVxMEHKJeVv+A2F6g+Y5f27ZtTDXB1Hhil20j5SBt5RLYDLE+sUhqbQ6A/TBQhOH6/uwe7yYbAXFOrPcVHwtG9T1+8GahBIcNAxByOrjrvxZLb/haBGxNCJ/AoZtPlO0BOrQ60hbzlTyIsVoSIh7ZhYDu+B6NaN2/zk/K1X2xHjB9z7XJToKGnFcrv4ujbNJW381vANAxocllJzNiZQz0zcUWJ5Al+0tP8hjXX+7tFjfBb4SMnfj0WnyVnEr0pFyHb0LZNU+1oOie8vCMJpUUOQeN73Myq+Zug+0xTWIZa5OTfgKDIFuJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(54906003)(4326008)(122000001)(7416002)(5660300002)(52536014)(66946007)(55016003)(478600001)(38070700005)(316002)(71200400001)(110136005)(7406005)(186003)(33656002)(8936002)(38100700002)(64756008)(86362001)(53546011)(83380400001)(41300700001)(66476007)(2906002)(7696005)(66446008)(8676002)(66556008)(9686003)(26005)(6506007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnVCL1BFTVhRUURJS0lxM1NwMGNzWW9PUmpSRGhhbjRvMUJqd2lvc21jQ3p4?=
 =?utf-8?B?RjFSSUJOR2t0Mk1Hb1Q1VzBlTjJ6dlZTdlowSGppWE9CcHJXaEpPVk1acTBZ?=
 =?utf-8?B?RlRMUzFrR2ZYY3NXUSs1M25pUkFTM0dwb21QUmhvMFJvMXlvNFdVc2ZZZzhB?=
 =?utf-8?B?dkltQkM4Tmt6U1luQkp0TTM2V2QrejRudVp0RnNaNG9NTkZpNUdORWFtOHJX?=
 =?utf-8?B?NGxVdXdaU0x3M04yZ1h6bEN4M1FFNW5oVy9mc2lCNEtGMHJydFpVTmlXVkhh?=
 =?utf-8?B?a1BPVjA1Ykg0TlVDWDVoenVYR0dmVlJMUnNGNFllZk50bFAycFV0Um1CODR3?=
 =?utf-8?B?cDhJeGZrZG42cFh1YnJGOVZFQ2MvVDh2MnN6ekw1VCs5dTdxQzNLY1R6bG9K?=
 =?utf-8?B?SGxCT3VOYnlHM2VaVmo3M3BoYXpzSlBkb1RuV1pSSzh3U1BONkx0bjVScGN4?=
 =?utf-8?B?RERZWXN5cW1wMzIwdzlqM0c1aENaSW9IeEczK3NnNUhiaDhrSkxGSERxemNP?=
 =?utf-8?B?dlNxRjN6T21uTHpsUkNNMmY5RUpTMVZVRGlaQnhCcUhwSzhCbSt2VjVLVVow?=
 =?utf-8?B?SFNNMDR1SHZTdTRxTkZQY1Z3a3VpMkRacTJ2SE12S0xsMndkTWdZUkY4OE9v?=
 =?utf-8?B?dmNKV0tzZVd3OVdIeHJ2MzdUbzRlWVBMdkZEeU1oMWxzZDcxOUI5eEdxY2lR?=
 =?utf-8?B?TVVRYnlqdGVUc1dNTmx0dFhaYTBKUmVUZzk5UE52SDZEdnRvRXBZS3g4SW9p?=
 =?utf-8?B?SjdnWUtUS3pLbjBnZzAva1JnZU9Hd3J1UEIxTzJGTkxhWGk4Z21yUjNWVy9E?=
 =?utf-8?B?MVl4YUptelUwNU5WMGsrT014TEpxVWRCWGJBbFc2TzNIN2pJZFU4anFJODhI?=
 =?utf-8?B?TlNYMVh5cHRsNE8wbXhpUzJmaFNoZitwazZONUUrNDVJMWhRRFFZejBjMHEx?=
 =?utf-8?B?Sy9BanZBalBNQ3JDdFU3UHN3ampscTdRRDczem5VWTRhUGxCWWFPVjVTalhF?=
 =?utf-8?B?ckg3SHNSQjUwVU9ydmxmVks3b2NJb2psb3hOZmZzSmxQanpoN3hXMWYydnpy?=
 =?utf-8?B?TFlkR1dpYkY2ZWMyTGFoOTVIZisyZlQzUHAzTEJ6akh2eEpmbXUxMW83amIz?=
 =?utf-8?B?UFQzek4vd0dyYTdXY3I2RUY3K1NDUzFyVjVpbkpRajA0Q0JmdVZyL1orSUFI?=
 =?utf-8?B?U0sxaEtFcUJlTVNmbzRaNVNlRlN0WXFZcENCd0oyTEt0VG42aGl6MnNjYUpD?=
 =?utf-8?B?OXd2aXh6V1hKMHJDS205ZGpQc0lPZHAreCsyT0JHS3NwRnFPNFZtckViVk1x?=
 =?utf-8?B?M3pFSmprYzJPSEt5TFVLNHdyNFg0c3FEdGtBQUVMMERxZ1ZpMFpycmRTRzQ1?=
 =?utf-8?B?RVVGS1Y1OGEyZGNDRFU2Y1VSdTNQY2J4RUJRRmZMYzV6RjlKLzZwWXdkOW1X?=
 =?utf-8?B?anJIWXVQWFgwKzArYW9hRUhVVWJnSWpyUXhaSG1iVHY2OE4ra3cxTHNlYXky?=
 =?utf-8?B?Ni8zRnRKbG54ZzNicjJFaVlLb3RJWCt0cGNXMUVzRkNoUnF6Q0Qwb01jZC9i?=
 =?utf-8?B?Y2c1R0doelBWOGdDRlZ6cWlzN0t4cDV5N2RyWUcydTE5U1dyTEVhYnZiSFc2?=
 =?utf-8?B?cHFRRmEva01tZzJsMG54NC9jQ3EvRldVRXkvb29uV3hKZWNKSHR0bHJTbHRT?=
 =?utf-8?B?UXZacHVTeVpvY0tzYnRDc1hUUXYwQVAvZTB4Qmk1aU9XM05INXJVTDZKL3lX?=
 =?utf-8?B?RHJQSnJnbkZvVXYvL2pQSU10emVIRG1EWnNTY1k3SEVhT1g2TGo1MXB5MU82?=
 =?utf-8?B?L3grTHpLNDdURW9CZlBPd1prbmZNZGdMQVJSYUdNM2VSeHVFaStHWVlWUEk3?=
 =?utf-8?B?UnowWjlveXErY0NFS2p4bnVJYnJzbnZZQStESnI5bnE5ZzRHK2Fwa2dlQUpB?=
 =?utf-8?B?OHNQQXdNYUdGbUJVWlZScEM2OGRNb0s2S2pFNlFsZkhNNXRjWG9mdjNyTmJK?=
 =?utf-8?B?VW1wTFJrbXQxL2d1S3NjU1VaWGw3N01rYVpjeGtmbEdyZWdWeUFkMjNKSkJP?=
 =?utf-8?B?UWFBRmM5bDZnN0p4cGFvUFFvY3J5eFFOcWluTWlXbVp0RHl1WUIwRG9IR0dQ?=
 =?utf-8?B?Ni9IWjJhNHFzUVcxNWRlTkJhT0V0Y3I2Q21SOFFaellyTUNCY3FtYmRvcmxR?=
 =?utf-8?B?dkErZXByWkdpUlBuWjF4dXd1SExOaFBsaGsxTlVhS0VpTGErY1pUdVhoeXhJ?=
 =?utf-8?B?ZFhxWGFBVEpVb2dDdlNhZ1I1dkpjcTNFTVo0T0lObU5EWk1HZFBzR0Z3THpw?=
 =?utf-8?Q?B26vJfWD0o5ytr1h6y?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a362229-d015-4317-3afe-08da547ddafa
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 18:34:34.7355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ekqK85lxuzq4tUXo+ERRvn6Zb2w4UXLfCJeBOBdyDdUMOm78/GlzkXkRS+VJRmLmv27PjHNwLtBbufdn9WrlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4408
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQpGcm9tOiBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPiANClNlbnQ6
IFdlZG5lc2RheSwgSnVuZSAyMiwgMjAyMiAxOjE4IFBNDQpUbzogS2FscmEsIEFzaGlzaCA8QXNo
aXNoLkthbHJhQGFtZC5jb20+OyB4ODZAa2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsgbGludXgtY29jb0BsaXN0cy5saW51eC5kZXY7
IGxpbnV4LW1tQGt2YWNrLm9yZzsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KQ2M6IHRn
bHhAbGludXRyb25peC5kZTsgbWluZ29AcmVkaGF0LmNvbTsganJvZWRlbEBzdXNlLmRlOyBMZW5k
YWNreSwgVGhvbWFzIDxUaG9tYXMuTGVuZGFja3lAYW1kLmNvbT47IGhwYUB6eXRvci5jb207IGFy
ZGJAa2VybmVsLm9yZzsgcGJvbnppbmlAcmVkaGF0LmNvbTsgc2VhbmpjQGdvb2dsZS5jb207IHZr
dXpuZXRzQHJlZGhhdC5jb207IGptYXR0c29uQGdvb2dsZS5jb207IGx1dG9Aa2VybmVsLm9yZzsg
ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tOyBzbHBAcmVkaGF0LmNvbTsgcGdvbmRhQGdvb2ds
ZS5jb207IHBldGVyekBpbmZyYWRlYWQub3JnOyBzcmluaXZhcy5wYW5kcnV2YWRhQGxpbnV4Lmlu
dGVsLmNvbTsgcmllbnRqZXNAZ29vZ2xlLmNvbTsgZG92bXVyaWtAbGludXguaWJtLmNvbTsgdG9i
aW5AaWJtLmNvbTsgYnBAYWxpZW44LmRlOyBSb3RoLCBNaWNoYWVsIDxNaWNoYWVsLlJvdGhAYW1k
LmNvbT47IHZiYWJrYUBzdXNlLmN6OyBraXJpbGxAc2h1dGVtb3YubmFtZTsgYWtAbGludXguaW50
ZWwuY29tOyB0b255Lmx1Y2tAaW50ZWwuY29tOyBtYXJjb3JyQGdvb2dsZS5jb207IHNhdGh5YW5h
cmF5YW5hbi5rdXBwdXN3YW15QGxpbnV4LmludGVsLmNvbTsgYWxwZXJndW5AZ29vZ2xlLmNvbTsg
ZGdpbGJlcnRAcmVkaGF0LmNvbTsgamFya2tvQGtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBbUEFU
Q0ggUGFydDIgdjYgMDUvNDldIHg4Ni9zZXY6IEFkZCBSTVAgZW50cnkgbG9va3VwIGhlbHBlcnMN
Cg0KT24gNi8yMi8yMiAxMToxNSwgS2FscmEsIEFzaGlzaCB3cm90ZToNCj4gU28gYWN0dWFsbHkg
dGhpcyBSUE0gZW50cnkgZGVmaW5pdGlvbiBpcyBwbGF0Zm9ybSBkZXBlbmRlbnQgYW5kIHdpbGwg
DQo+IG5lZWQgdG8gYmUgY2hhbmdlZCBmb3IgZGlmZmVyZW50IEFNRCBwcm9jZXNzb3JzIGFuZCB0
aGF0IGNoYW5nZSBoYXMgdG8gDQo+IGJlIGhhbmRsZWQgY29ycmVzcG9uZGluZ2x5IGluIHRoZSBk
dW1wX3JtcGVudHJ5KCkgY29kZS4NCg0KPlNvLCBpZiB0aGUgUk1QIGVudHJ5IGZvcm1hdCBjaGFu
Z2VzIGluIGZ1dHVyZSBwcm9jZXNzb3JzLCBob3cgZG8gd2UgbWFrZSBzdXJlIHRoYXQgdGhlIGtl
cm5lbCBkb2VzIG5vdCB0cnkgdG8gdXNlICp0aGlzKiBjb2RlIG9uIHRob3NlIHByb2Nlc3NvcnM/
DQoNCkZ1bmN0aW9ucyBzbnBfbG9va3VwX3JtcGVudHJ5KCkgYW5kIGR1bXBfcm1wZW50cnkoKSB3
aGljaCByZWx5IG9uIHRoaXMgc3RydWN0dXJlIGRlZmluaXRpb24gd2lsbCBuZWVkIHRvIGhhbmRs
ZSBpdCBhY2NvcmRpbmdseS4NCg0KVGhhbmtzLA0KQXNoaXNoDQo=
