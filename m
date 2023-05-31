Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740E1718A66
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 21:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjEaTp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 15:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjEaTpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 15:45:54 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E6A9D;
        Wed, 31 May 2023 12:45:53 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VJN39e015035;
        Wed, 31 May 2023 12:45:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=dQkYQWhxQlncNQgrX8dQdNhwkN7JRa0V6p04B9V1cXA=;
 b=DbKQujKWc67wwacaSPMBsfSTjG5+pAJbVbslxlY4YZEOz80MyGSRU5LeTIZXcEIrRS+Z
 Gdv674iVo6gRL2nhxoHDobEg7Aa5mGz+/JvWgAdrJUB8QU9Kja7bRjFGn/kO/55g63no
 BpjMVkXw2KrEViuXHyHa7SEBxw26YE5T45lpjEy2ctodL35wxKOK/3BD4/pa6uXvG+uW
 PI3wdxnUusPEgxepC/6/0Bw2MB1VciCL55wzZGwSei/yqjNqAqmeZfz5yl+aKb0nRDJ/
 CctfDoDzKJ0J7Mw7OHkFAsR+Mkp5YkWC7zM6cjj38Q3cNCHQa6LYuO0vkZgFLK+9uVIB 1A== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3que6rrbkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 12:44:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftEMwV7kfv+ZwA6s/sgH/ZyfPsKbFDfxVW4O8yxdQ9L7O+le716bf2eBGu3JRAD4rX3j5zAzvWXEMw0L6py32LIQzcgBhX6Uq5wxs+OI3QZqb84koJn9ngxkm4nZuY4MH8VugG40BCqeC4IGluGS7gLDs/+Wa0zf4oRuOWPOAa1omkhzTl2sF7J5lSf3TqoAkNzOQv9lWue9ebuG4xdh+AX55pVJ0RGNH8QxdL1M+0iDC0EXRjWAGcXEROVaCM73DMbAsejl1zQrTpAtNjjF16Kt2bVR6RZNPGbQTKz7MumISGj87yvq0oyhzzuPRmjOQUb/t5fjDYK5LLTlQC4WRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQkYQWhxQlncNQgrX8dQdNhwkN7JRa0V6p04B9V1cXA=;
 b=hgVDFcYLS3dh+GzBXH8DZtBb6dHds2Agz+lKn6oa1AJ7xsBrz/Lvgfyief/vTNpIzPXDMBOmIlaEPtZXJfWk0lCfiZH4MObV3NDEoLOrU7XCTWip/++smglQT0zYyJVFm+rKKALW3AGSeam/uX7Zq38Nh9Aeadbtn+w5iwSWinQ80wC5pSp3nS9ImU4RJ9uGte7VxR11CaJCDOg19O8IgaR4jW2KbDveCQI4GLozcDqFloq7y6O5jcuuAjwlf0e19J09u1I5o03cWlWc/f1/GQKXQ4fzgL8No2lI9M+d/SVsb/tvdthTVWb51p3okhMuw+7AbmEh58FtLyqrhCsB/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQkYQWhxQlncNQgrX8dQdNhwkN7JRa0V6p04B9V1cXA=;
 b=NhLS+ARd/qxMY41yXjs+KlQ3nXpjMMcX8HNL7Lcba8NTyb83etEd2xaff2V3zVb79Pi2tHpqaPbtNOoXIlJxfQ40GdEgItul8ocvhUpWcVV4IOuSuXDKnt66feSsnGa36kINjD4ff221B4JjC6GLqOx1TNQKmXFh5eIIHORCxeEhcRk/llzC3Owz/gV3KfqNUl4AAHhyuQu5AVlO64oLdAaPhcF0S6xYOi94NZe/1nWCgGFGC3XRyGJRK/2oRasCfap0OMdTPm7BIWc8JPuCN7Sqpeou5KtrMKZoAF9KwPonl7dlVx+lDbUiSfO2AuJU6Yfr1FeCRA4gBJr8Zlc4mQ==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CYYPR02MB9842.namprd02.prod.outlook.com (2603:10b6:930:bb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 19:44:46 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 19:44:46 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: restore vmx_vmexit alignment
Thread-Topic: [PATCH] KVM: VMX: restore vmx_vmexit alignment
Thread-Index: AQHZk9jCQoRbw9yyaUe0SKmRorIndq90sXmAgAAWyoCAAAC+gA==
Date:   Wed, 31 May 2023 19:44:46 +0000
Message-ID: <2A2A9B8D-6941-49D3-87F8-4AAE09E6F5C3@nutanix.com>
References: <20230531155821.80590-1-jon@nutanix.com>
 <ZHeP75vG8xA+UeHt@google.com> <047566b9-c2ef-40c7-9a76-caa8607b3f6b@p183>
In-Reply-To: <047566b9-c2ef-40c7-9a76-caa8607b3f6b@p183>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|CYYPR02MB9842:EE_
x-ms-office365-filtering-correlation-id: 94fc6c8c-2e4d-4452-c0ef-08db620f7d1a
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6LF+HQMeSq+RARooOlxYbpeOPb38JB5gppOQONI/A2V8lzpDoqsoSVbB/Cn04FFEEqCtsfDVKFyeoD3jbeAc9YzqoimyZGFgYI57Fqzez1y4eQO6rzV5qalEsm+BTGcFuC+6L5dvK9QhvAapK5dkkZbnf64JIwbA/7TS39hXhhfPfW9VJsaF508g8CMFIQ0bFKR60Ap2Dd6OoMJQFLDV6giBV5O/e4oV1lbwRbC6EESva37rxuIl+7nEtjnhL4SrCv6vZHoHOdpFfk0wIKMngtyCAh4/+NgLH7Z4X//dFc7CGTDrnERg4LINg9hYfH9gJqpHSQ23FYH/C/SbT82LIKmB1rEndDI+TrCnUavBRA3BOYNNm7b+bGQ2JuU99h8+XhW8MMqOMAOLDh8eN2PCl957vqlUBTB3A+UEKJJ49UjVfLsUXT/XrOnP3L8tTgvpS/i+S8puGEu7PVxDmKY6UqlAWQV4rTjYNThDUU2MFzCL4Z0AU/kwypgFeBstJ0AXCUUyQqkzVmNQrWUBc7rFhScKTm2KKtbeQYBRpIBwIdLUjdMRmyhZlU52K8lpmGyBm+QJLX9RuSOU+BX6d8TL9Dq9Sy+W6HCfPRF9yHqjpjMpQtDgQ5LNzVEP30LrO0Qn15vfygYQhDOP8iD8U9vOdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199021)(8936002)(64756008)(66946007)(4326008)(6916009)(66476007)(66556008)(66446008)(5660300002)(8676002)(91956017)(76116006)(71200400001)(54906003)(478600001)(6486002)(316002)(41300700001)(38100700002)(122000001)(6506007)(6512007)(36756003)(53546011)(38070700005)(86362001)(2616005)(7416002)(186003)(4744005)(2906002)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUx2NDZOUGFpeDJhWklKVGs3K2lRWWdFREIzS0lrbkttTUozbGV5aE5MSEg2?=
 =?utf-8?B?V0Q5V0wvWWZ5S1pNaUJBZlA4ZHk1QjltNHRBZEpwNnAzaTlZZjJZOWViKzhU?=
 =?utf-8?B?UkhmcU5Pdjd1Z2FPUWtIMFZJd1JXeUZpcDZRN001ZzN0dG1MMWJCSEtzeWV0?=
 =?utf-8?B?Z1o3OE8yR2lUL0tIb1JWaW5BV1owc0FLNW9EcWdtQUk2VGtMTlAxK0RkK2lM?=
 =?utf-8?B?Q1FQalpQS3BhSFdBR3pRWXM2Vm5MN0c5dmJuMmxpS3gwTjYxMnRFM2xDTXZU?=
 =?utf-8?B?WmdxTUdhY2x5ajg5ZVFvbmJadlhZcDZKVXNWeVArZGpIN2g0eCtvTUZneVpQ?=
 =?utf-8?B?MC85QjF0OWVhZCtPTjBzRi93aU5BWDF6UUI3b2tIK0gwNlY5bWhsdWhlcmg5?=
 =?utf-8?B?Z1RFZWNoRzRMdGs2bWdGVkFmZld4TGg3aElIb1p2dTVFVTNYeTh6WGFRK3JK?=
 =?utf-8?B?SW12c1J4NHBvb3QxRUI1bFEwLzk0NFlWcHNQNkU5anJaMk9mS2NMZVgwZStS?=
 =?utf-8?B?WFl1U2FQSVlycFlaTVlERlY1SnN2dU4vVURWU3ljOUdKK1p0MmhvRTdGc2V3?=
 =?utf-8?B?SWxUalR5cDVSMnpUcmI2MVdaNVNZcUpjbUtBYlJNUFd6bHF3Q2RDdFZ4SXNL?=
 =?utf-8?B?VVFOMnRSTXRnRHRDOEZYU01DMnlyaS81L2JXeXBmeE1UWldmR3RMTnhVR3hW?=
 =?utf-8?B?ejlTUjl4ZVpGUiszdWdJdUVYTGwrNlFSeEhOZWNleUZ1bzVxL1E2WlhUeC9i?=
 =?utf-8?B?YnFwQXNJbWhjcDRIcUFPV25BeFVLcTlITkIwenhOWkd3NHVObE5jRlVMT0Ns?=
 =?utf-8?B?MkxxRU5VOTU1QzY5dXVyeW55VEVsQWNCSHplckkreWZVeDg3c1Fybk1wOHdR?=
 =?utf-8?B?cnNPQTlxdmdNczBpNXA1OHAvTU8vdFhSdDBKZFRFVklUd3g2VVBSUmx4S0N1?=
 =?utf-8?B?SGc1TldVcGxUZGhSN05LNlVtdnh1aEtTVkd5Vy9hYys0VjBIMDBzNEFXcHYz?=
 =?utf-8?B?UkJpeGhqczdFdWxGVWJFMGQvRmNkNUpEOWlRZkFXRWhxZi9PNWVGTHIwdGd0?=
 =?utf-8?B?bWdHcVVab2JVdysvWTRNYTM2elVSKy9VMVBjaEY5dzBvakhPTDNrNmdITWZh?=
 =?utf-8?B?bkpOb290NVY5UjA1WGYxREF5QUpuaStMRURpb0ZnRlN6bW5DSFk1MVZieG5D?=
 =?utf-8?B?WE5zeUNYZ0JiU3hrdElxK3JSZHh3KytYd1hjWCtXMDFFZG5iYzZuckd1VEFJ?=
 =?utf-8?B?OHEvSms0VHZVOVJVMUw5WHpYNFk3L3d2U2lOWDFTdmJqTk5HWER4ZmVDeXd6?=
 =?utf-8?B?TTIzQUh5YWsva3hub3pOUkRLQ0xYNEFEWkFNUk9GY1JtTjVRbE5JTUVNRWVh?=
 =?utf-8?B?dnZWWnNqbjFoS1ZrZHltUmo2NUJaWlpvWjMvS1RFWERVZWcrMlRFZE5vZnZH?=
 =?utf-8?B?ODlZT09mZ2xpUGdmNU9TbkhlSnAwWGJLdFFvK2NDYTFTaGg4NThMcXF0cG1D?=
 =?utf-8?B?RWlyT051NXpHWFZ3dVZQZzRXcUxRaDlVblVxL2k2amFVYkUrcVY3dE9XN21Q?=
 =?utf-8?B?QWs5enlIT2xRREJYdVBzOUtCa2VoUTZBT2xXTVZFZUEzZ3dQaXN0eVVjeEpv?=
 =?utf-8?B?cXgzK2ZlVWMrVVUvMG9UUm1ZaHFmZE0wZTRjUVBnc3VRd1BCSFNqVzdyUzBR?=
 =?utf-8?B?NzZ1b2w1aEJCZk8xQWpZdmF2UWFnLzd0MXpBNlhMbEdrN1ZCRWplNDJNdzZ3?=
 =?utf-8?B?VFh6czlZMW1RQ2YzYnJCWXVxbm10Q0JESWE1K0FHaHpJZFZCSGZ4MFRlc1J4?=
 =?utf-8?B?eGFFYkxtMDF2RGtGaXB6MXJrUGNkaEM3V2UzN2hEdlU3TkxidjJLcjFFNTBp?=
 =?utf-8?B?dkE0Ni95dWpsVlN1Y1VrZVFzSWNjcE9kakdyK0JaYzJPdDJEQVQ0UlZ3QW9D?=
 =?utf-8?B?U2Jubk0zTlVMeHFaOWdrcG1rOElpVDRqaHhTVjlBSmxYVzRmOFVGVm5yMEJh?=
 =?utf-8?B?N3IrL3FHb3J1Uy9TaTZ0VHFxWHFPVWJ6SldzZ3Y3ajNnVVUyZnVRYlpsUlN6?=
 =?utf-8?B?bVR5aGZ5Q2FLT3NkZTBtVVpoNHVKZHkrU0JtL2NLSzlRSnVUeHA5UkdlcFdo?=
 =?utf-8?B?UGYwZVh4YUhCNFdnZC9rYXhoQ0sxQlVhYzNJK3ZjUys1L2NXMDdMUTR6RmxO?=
 =?utf-8?B?YVplRG9KVzM0bGlIcGsrWmZNS01qUEJuSlViOVBNTFJ4MDArd1g3S2dBL05q?=
 =?utf-8?Q?X8tvIXb1Qk/LI4234Y1165rjQ/LOuAW+0Kac8tGIZY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D092441868CDF43A603EAB9D4937155@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94fc6c8c-2e4d-4452-c0ef-08db620f7d1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 19:44:46.5774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZRN0wGx+rNqGMcuvk9Y9GVBG0ZQDTUuBNgTgvSlhPszJld2C2bOSDSlAN+yUmWT+lzyMcgPu86YFT/9fevHGwDY7df5gF8Hf84TXDGxGtcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR02MB9842
X-Proofpoint-ORIG-GUID: g2ZoXNZzjC1LsqDX_T4ACouJBKVKwlY5
X-Proofpoint-GUID: g2ZoXNZzjC1LsqDX_T4ACouJBKVKwlY5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_14,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDMxLCAyMDIzLCBhdCAzOjQyIFBNLCBBbGV4ZXkgRG9icml5YW4gPGFkb2Jy
aXlhbkBnbWFpbC5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBNYXkgMzEsIDIwMjMgYXQgMTE6
MjA6MzFBTSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4+IE9uIFdlZCwgTWF5
IDMxLCAyMDIzLCBKb24gS29obGVyIHdyb3RlOg0KPj4+IENvbW1pdCA4YmQyMDBkMjNlYzQgKCJL
Vk06IFZNWDogRmxhdHRlbiBfX3ZteF92Y3B1X3J1bigpIikgY2hhbmdlZA0KPj4+IHZteF92bWV4
aXQgZnJvbSBTWU1fRlVOQ19TVEFSVCB0byBTWU1fSU5ORVJfTEFCRUwsIGFjY2lkZW50YWxseQ0K
Pj4+IHJlbW92aW5nIDE2IGJ5dGUgYWxpZ25tZW50IGFzIFNZTV9GVU5DX1NUQVJUIHVzZXMgU1lN
X0FfQUxJR04gYW5kDQo+Pj4gU1lNX0lOTkVSX0xBQkVMIGRvZXMgbm90LiBKb3NoIG1lbnRpb25l
ZCBbMV0gdGhpcyB3YXMgdW5pbnRlbnRpb25hbC4NCj4+IA0KPj4gQW55b25lIGtub3cgaWYgdGhp
cyBpcyB0aGlzIHN0YWJsZSBtYXRlcmlhbCwgb3IganVzdCBuaWNlIHRvIGhhdmU/DQo+IA0KPiBD
YW4gdGhpcyBpbXByb3ZlIHZtZXhpdCBsYXRlbmN5PyBJIGRpZG4ndCBtZWFzdXJlIGl0Lg0KDQpF
eGl0IGxhdGVuY3kgKmFwcGVhcmVkKiB0byBiZSB0aGUgc2FtZSBiZWZvcmUvYWZ0ZXIsIG1pZ2h0
IGJlIGEgbGl0dGxlIGJpdCBiZXR0ZXIgYnV0DQphbnkgaW1wcm92ZW1lbnQgYXBwZWFyZWQgdG8g
YmUgbG9zdCBpbiB0aGUgbm9pc2UuIEkgZGlkbuKAmXQgc2VlIGEgcmVncmVzc2lvbiB0aG91Z2gs
DQpzbyB0aGF0cyBuaWNlLiBUaGF0IHB1dHMgaXQgaW4gdGhlIG5pY2UtdG8taGF2ZSBjYW1wIGZv
ciBtZS4NCg0KSm9u
