Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEE151DC64
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 17:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443071AbiEFPrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 11:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348242AbiEFPrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 11:47:04 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046C568F93;
        Fri,  6 May 2022 08:43:20 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246CsNf2010449;
        Fri, 6 May 2022 08:42:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=L/lGn5DBXYPD2RYMuk7K9ak8bv9yc29/j4kodcQMJhY=;
 b=es4olwLbXCjqqD+xB3g0LMKC/kwkvbuk0XwPp1VS9wT+WeB4oYSPr6iniZTRJx4g9/c2
 HQwi1KdwzQYC+evwncfThfAssNJd/bJ/5+LtErzwQMsIhneNPHoWOWK6Hg7s6KH+uIS/
 mX8WcwaUQTnwuSTXt48lbNf85M/ZjCxsWdVJCAm8n/eKfA1diDlfoT/xGhBKQcu4SvbJ
 3YmQCnOZF+Q7qksWQx/94MBmVnYTYwP9ssIFdL1lxdWK+5hmfYWSc1aslE+paucDxleU
 W5LNYMbAtDPDvEhw7hVx/Fwbw3+V8StNi+fBODj63qiXhjVaNEBm9UnW5zvVTrgDLVWi DA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fvjdqt7v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 08:42:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YiV24Xgb0oStSjmjCODxVn/5kIe2MWBJwal6gZ+9WSCIdUeP2zKeZdBkf3vo6+zr6NQMXkjpAjYHrk2LOHIAbUE5xvQBVZyarwJoXgQpS/KSQxe+WaLEoIISzGnpxwjbKi9oSttXxfJhSFgty/qvz5zTzrNLtJoyaeYuEzTBeCr22yysIDmwPpCeiZIUmmKBMXvoWz3+9t+Ch9qra2zkPcYnQkeIB6XgtAad1DAJDB4dEIj/QvUwvOEXbfw70rxGNDMoMJkGE4YSaDn00GTXFwn2zTSEL/tENhDYO6e2DbhkRCnkFgMUMl7iOLnZRAFwe2B04ghImYlgrWAmmqHLOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/lGn5DBXYPD2RYMuk7K9ak8bv9yc29/j4kodcQMJhY=;
 b=EU6sYc/yyGt4wpGAhLzTLhfae4GbAiGZF1LO23+qG5xoexu4VHqgJJaQ3ytR39hyq5GUA7N/BrUth17/yrn8xqfCicvr1sX/0xgugfF80ihjKpi9jHjzf8kWQ01MVh8E+lgW7CkyvmBqjaK3p4cTLOciLeKYruGKlanzafQmhOfwb6vcJnpzj5eSzKmkR4NloLtTexpjGJJI5i7oQ2sOrqFdnhK48YKBPLPWxtqhka4gTdRWarEYuP7UBxDdLZsZg/tw0wrqQeJs+RnTLoRRV7Vu/k/Mp7Ek82/IcMpAImM9FyJCXYKhv+zMBO5FCco+9v+WXMJqC4B/4yZOa9LpmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by SA1PR02MB8477.namprd02.prod.outlook.com (2603:10b6:806:1f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Fri, 6 May
 2022 15:42:01 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5206.025; Fri, 6 May 2022
 15:42:01 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     Jon Kohler <jon@nutanix.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Topic: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Index: AQHYVmUALWKOwI7bhUetXwvEOXsG/a0HKBwAgAAI9ICAACHkgIAAD+oAgAAIS4CAABD0AIAABkcAgAARGQCAAK85AIAAU8oAgAAV5oCACWZ2AA==
Date:   Fri, 6 May 2022 15:42:00 +0000
Message-ID: <9B64ECD2-2F47-40C4-8E9B-70B1A8F45BAC@nutanix.com>
References: <YmwZYEGtJn3qs0j4@zn.tnic>
 <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com> <Ymw9UZDpXym2vXJs@zn.tnic>
 <YmxKqpWFvdUv+GwJ@google.com> <YmxRnwSUBIkOIjLA@zn.tnic>
 <Ymxf2Jnmz5y4CHFN@google.com> <YmxlHBsxcIy8uYaB@zn.tnic>
 <YmxzdAbzJkvjXSAU@google.com> <Ym0GcKhPZxkcMCYp@zn.tnic>
 <4E46337F-79CB-4ADA-B8C0-009E7500EDF8@nutanix.com> <Ym1fGZIs6K7T6h3n@zn.tnic>
In-Reply-To: <Ym1fGZIs6K7T6h3n@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c043d73-8fd9-425e-9626-08da2f76f635
x-ms-traffictypediagnostic: SA1PR02MB8477:EE_
x-microsoft-antispam-prvs: <SA1PR02MB84778530F86F04A36125B294AFC59@SA1PR02MB8477.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IbiHB5BshRoQOae4iBbYbm+JUJ46L3Bh6JaD737LHU5SuJ1abokm2JDz8zO2WIMZOHrxcOYKLqZYmyX5V+dtNVqvFw1tNhumVZ+UJ2lKVTP4yjVN8/yEcU1g+vWVfe+AtF34fkRBm8sMw76JhgYNHpU+YaDf27HoTqCkQ2y2vpY/6NbF734odG6vLTMjUA26KF2WWIdjgB9/kzmPtlScCkBybLJ/1pA3TFl/KBfpXJeljGLga67ozgQBQYXfp9mAvaz7U76fedAwaExq2JWbChxPwEo9IO8F+8G3fm1dgdzWeV/PoA85HxKOr1axfguSu9/MnTP3DNwEt7WLq4JVyqoml182O81Hc1HH8Ss/JLdNoLpB7v4RPkXt0WHDxcUiSGDX8k/oazB7jZXmnurUNqXpzCVNYQrcuJmop4DMMvn6GlXGt74Vip4B7TnGtDqFct72O2xq/G+IwESu6ainFl8iy32RxjvN/mY3GtF2Vf/15r/tCV4JSFM+T4YVil/SLlXIFvtEuBajpuzKuaNHDiU2kxAi7paN3lXA0x+EHMBk83kdvWpFKxFCCY6n01LHU3BVTPNo42vTHP0CAr+52ZQWFXHIro/wCH29sz0eON6uICRhsWdM13owmwWrpeSrQif9dd98hqPsxO0q2DEbn6ZFjn8sDi2iOGAa6lESlrNXEdsW9TfpYkRk6s7v2fHaHG4rv8zt4HJPG6dRbjpwLGaC+3KqsEvIHJ2QQS4L3UQgNmPBUt2Lh7rEkq1v5UPyEGS3d9NHH0pAHTJcxtmxvbbhhUuTI5go8FQ8Mq2CVha5RK53o5FFn5Mu0BTZcdxngMp77GwsBGLIT3biNZLL/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(86362001)(76116006)(71200400001)(38100700002)(91956017)(2616005)(83380400001)(6916009)(4326008)(54906003)(8676002)(36756003)(66946007)(66556008)(66446008)(66476007)(7416002)(5660300002)(53546011)(508600001)(38070700005)(8936002)(6506007)(33656002)(122000001)(64756008)(186003)(2906002)(966005)(316002)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUZ4YnBQY1Vva3p5SG5tNXpYZlBteDFHdXN2Mk90c3djQmdSOU5EVU41b1Av?=
 =?utf-8?B?RldrVHdZTzNOdGFzMlQyazRQVzA2NlhJWGhPYnRkOC8rSW82YVJ0bGpNcHo4?=
 =?utf-8?B?UEEvZzIwYjFzWjV2ME91bmo0Mk91N1pCeDBrWllkMTM0d0YycGVmNHA5dFpX?=
 =?utf-8?B?UjluTS9sVGg3ekRjamF2aWN2cjFNbTZIeE1ZWlh0SENKMTF6NVd1ZHlyY3R1?=
 =?utf-8?B?d3hUbktWaWc4UXNaRFMrbk9zTHF1Z25pOFdBTWMvdks2NkNTK0pySmlIKzhO?=
 =?utf-8?B?TVV6bVBNMUFJU0RpUlQxbVdmV2EzRzJleWpNK09VR2FrSEIzVHNCU25TVXFU?=
 =?utf-8?B?UEFmRGZhZVNUMjUxbWVVcm56YmtrNTd1byt1aEtoUkphODRXTXRJNWdnVkh3?=
 =?utf-8?B?R2pibTBQb1RaVmpyb0c0REZuK3VWTHVTOEhQb3hjSm9JdEdMQk9KV1ArY3hz?=
 =?utf-8?B?alZwdWwwNjNZMUxsc2ZtMUdLVDZ0b1hPQUoyZW85dXlhNjNDZW0yU2E5VmFU?=
 =?utf-8?B?THdRZGI2S1RqM2h5RXFua21xc1crbUZVb3EvdkhJRXVJNnA2clI1ZENuL3h1?=
 =?utf-8?B?L1VPTWpHY2tVc1JNVkF1MFpZdUlkdkVaNzN1Mi9MZVdSckRKWk41VnIzNmho?=
 =?utf-8?B?VzVaSk1yQXFML2h1M2NNYlRId0pLejdMU2d6cUZSR0pTdmZ4SVQrSFJyUko2?=
 =?utf-8?B?V2N3S21rdGVOK3N5cW90ZkYwNk1hVGd0b0dxeFFUUitPYkhnbzJtcHQ1eTEy?=
 =?utf-8?B?VW1xcVg5dEJlVCtBVkYvaFFDbERlZEUyckxNYy95MVRSbTNjY3MxRXV5U1FQ?=
 =?utf-8?B?U1crLzRWdFpHRi9PelpucGlrc2MyN25ZVkY2Q0FFOXkvTElOWmtYN1kxV28r?=
 =?utf-8?B?T0ROaCtQZnBoRldvQmZoM2E2OGU2N3ljZGZLSkk4OStkL2szZVNuMGc2b1BU?=
 =?utf-8?B?cUtIc294WlRlZURFTXJWRnQ3eThHbEQzK0N2aG5INklFdkVKbkJlaWJ5TWU3?=
 =?utf-8?B?K2dxQ09QT0tGVmJOb1AyRE1HV2tTWjhJSy9ocStTSXFqbEFhbmg1Uml5V0J0?=
 =?utf-8?B?UTNUQ1U1aVBqRzkzckk4eVk0NVY0UlZuUDN5TlBDV09OSHVqdkZMeElkajF1?=
 =?utf-8?B?ckxXMHVEOVlobll2STJnWWpVMXFZVWV0WDQ2NzZYRkdBNkJCaFV1SkpVTVRp?=
 =?utf-8?B?ZHhBdGFtM0ZGdFN0dktoUzRPOXl0Nm5GbXh2bU9OaUZHYy9YY2hRREhWd2l1?=
 =?utf-8?B?RE55T3pmbU5IUmN4eHQwVGJQSmZPeDBMdzFFUVVnWkFxUWdZMHU4blNXRFNt?=
 =?utf-8?B?Ull0dUZtMEpyVUFsZHMraGNnTkdvMU43aC83MjlqWlRSbm5taHhyVGM1bUUy?=
 =?utf-8?B?MmsxV3VpVS9hWUEwVzVuRDdFYmI0T3ZaUkRhWktUSlpQTTZDZ1FwUnA1UTcx?=
 =?utf-8?B?VUV4bE82akhVbHBTWlhuR2tjMHNGdkdacVVaTmlJdFI4UHdKUUlrL2NENXF5?=
 =?utf-8?B?cmtTekpOTThrT2hsVU5MMXZnQzZxaFpDZ1lCL2lyTEVYenVDM2VmQjhhM2gy?=
 =?utf-8?B?eHY5OHBjeitrMUpXSzhwNjViOUNCTVpUZ29tdWs5UlM3cysxanlYL3ZCSjdt?=
 =?utf-8?B?S3lmL1l1R3pHR3Rpb2swTXBlcnBzSG9NUjBjbzdSNEJaekNlN0xmOU8waVVX?=
 =?utf-8?B?VUZqMkNDdzhKQ0hjU2pEclU4VXJaRWQ0ZGcxc2tjemU1UGRzZTF4RmFoRGJj?=
 =?utf-8?B?bTNjL3BPZ0h2T01hallDeXNqMDBpWEJPZmVWWWduN1QzOW01ZkR2U2VBaGRC?=
 =?utf-8?B?aFF4K0crTjU3WlpwbEF2eSt0bEhoeFRlVmo0VEhRaHZXKzJYU3BLdm5yRmVS?=
 =?utf-8?B?RXJKdlZFZTM3RDBEVDNOMnlrQkVCUWFKK0k1NkcvbXdaNGdzK0FRK052Q3ZS?=
 =?utf-8?B?Ykk4NWF0NkUxem1XQ3hQdFFQQ1ZKNEYzK2I0MUUzaG03c1U2UENzTzBaZ2Jy?=
 =?utf-8?B?TjA0SE1qVDhrT3JNNnhlQjBhS1MydmV0NHlzQVFLbzgvQkZHdFk3Y2wrTHd4?=
 =?utf-8?B?WVR1RWo3K3E1OVF5VWFwTHdacFl5RzJVMXNqQVdWVW9JeGVRa3dXWUlJWFRP?=
 =?utf-8?B?eXNxYlc5enVIdCszU0txMTdGZkxrM0FyVXFOV0FHb0hvT3hzY2JQOHFndlhy?=
 =?utf-8?B?RkhESmNXUUp2R0lnWGlJR0tXZEE2RE9QWlNKRUhMeXd1RWllR2RuZkVNcm91?=
 =?utf-8?B?SVYxMFJGYUU1RjNNdTV6bkhkSXBWQytySDBuaW9naUU2RjB6RUN2VWI2ZDhE?=
 =?utf-8?B?cXFjd2ZkdmxzRGlwcGdrT1VwaFhYdGxEanp2NUlHSW85Q0luWHJTcmhldEpC?=
 =?utf-8?Q?8L8ynHBxKKQfYqKGsAXIaQ5U9aXrxqe8HHFp2N3/ze1fp?=
x-ms-exchange-antispam-messagedata-1: q7+zvq00YqHA/zaEsZvirKrBZYj9aVtq+KFM0Q0VsQEqeHZq45Mp1hGP
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A5C11F1AC428047B1003FB27EFEC92C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c043d73-8fd9-425e-9626-08da2f76f635
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 15:42:00.9231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SeQ7eQTjPQP8zr26TKOE4ffbsHUn6WFLjkzsSj56uChwEC5F7kj5GFcw4zJd44HataFkhsljvoQtV4BKyF1pLKJrvJTmUcaoo4AILuq08Lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8477
X-Proofpoint-GUID: kRdAfYQRRsHd-fg0hbJLOKZ0RREt7sBA
X-Proofpoint-ORIG-GUID: kRdAfYQRRsHd-fg0hbJLOKZ0RREt7sBA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_04,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gQXByIDMwLCAyMDIyLCBhdCAxMjowOCBQTSwgQm9yaXNsYXYgUGV0a292IDxicEBh
bGllbjguZGU+IHdyb3RlOg0KPiANCj4gT24gU2F0LCBBcHIgMzAsIDIwMjIgYXQgMDI6NTA6MzVQ
TSArMDAwMCwgSm9uIEtvaGxlciB3cm90ZToNCj4+IFRoaXMgaXMgMTAwJSBhIGZhaXIgYXNrLCBJ
IGFwcHJlY2lhdGUgdGhlIGRpbGlnZW5jZSwgYXMgd2XigJl2ZSBhbGwgYmVlbiB0aGVyZQ0KPj4g
b24gdGhlIOKAmG90aGVyIHNpZGXigJkgb2YgY2hhbmdlcyB0byBjb21wbGV4IGFyZWFzIGFuZCBz
cGVuZCBob3VycyBkaWdnaW5nIG9uDQo+PiBnaXQgaGlzdG9yeSwgTEtNTCB0aHJlYWRzLCBTRE0v
QVBNLCBhbmQgb3RoZXIgc291cmNlcyB0cnlpbmcgdG8gZGVyaXZlDQo+PiB3aHkgdGhlIGhlY2sg
c29tZXRoaW5nIGlzIHRoZSB3YXkgaXQgaXMuDQo+IA0KPiBZYXAsIHRoYXQncyBiYXNpY2FsbHkg
cHJvdmluZyBteSBwb2ludCBhbmQgd2h5IEkgd2FudCBzdHVmZiB0byBiZQ0KPiBwcm9wZXJseSBk
b2N1bWVudGVkIHNvIHRoYXQgdGhlIHF1ZXN0aW9uICJ3aHkgd2FzIGl0IGRvbmUgdGhpcyB3YXki
IGNhbg0KPiBhbHdheXMgYmUgYW5zd2VyZWQgc2F0aXNmYWN0b3JpbHkuDQo+IA0KPj4gQUZBSUss
IHRoZSBLVk0gSUJQQiBpcyBhdm9pZGVkIHdoZW4gc3dpdGNoaW5nIGluIGJldHdlZW4gdkNQVXMN
Cj4+IGJlbG9uZ2luZyB0byB0aGUgc2FtZSB2bWNzL3ZtY2IgKGkuZS4gdGhlIHNhbWUgZ3Vlc3Qp
LCBlLmcuIHlvdSBjb3VsZCANCj4+IGhhdmUgb25lIFZNIGhpZ2hseSBvdmVyc3Vic2NyaWJlZCB0
byB0aGUgaG9zdCBhbmQgeW91IHdvdWxkbuKAmXQgc2VlDQo+PiBlaXRoZXIgdGhlIEtWTSBJQlBC
IG9yIHRoZSBzd2l0Y2hfbW0gSUJQQi4gQWxsIGdvb2QuIA0KPj4gDQo+PiBSZWZlcmVuY2Ugdm14
X3ZjcHVfbG9hZF92bWNzKCkgYW5kIHN2bV92Y3B1X2xvYWQoKSBhbmQgdGhlIA0KPj4gY29uZGl0
aW9uYWxzIHByaW9yIHRvIHRoZSBiYXJyaWVyLg0KPiANCj4gU28gdGhpcyBpcyB3aGVyZSBzb21l
dGhpbmcncyBzdGlsbCBtaXNzaW5nLg0KPiANCj4+IEhvd2V2ZXIsIHRoZSBwYWluIHJhbXBzIHVw
IHdoZW4geW91IGhhdmUgYSBidW5jaCBvZiBzZXBhcmF0ZSBndWVzdHMsDQo+PiBlc3BlY2lhbGx5
IHdpdGggYSBzbWFsbCBhbW91bnQgb2YgdkNQVXMgcGVyIGd1ZXN0LCBzbyB0aGUgc3dpdGNoaW5n
IGlzIG1vcmUNCj4+IGxpa2VseSB0byBiZSBpbiBiZXR3ZWVuIGNvbXBsZXRlbHkgc2VwYXJhdGUg
Z3Vlc3RzLg0KPiANCj4gSWYgdGhlIGd1ZXN0cyBhcmUgY29tcGxldGVseSBzZXBhcmF0ZSwgdGhl
biBpdCBzaG91bGQgZmFsbCBpbnRvIHRoZQ0KPiBzd2l0Y2hfbW0oKSBjYXNlLg0KPiANCj4gVW5s
ZXNzIGl0IGhhcyBzb21ldGhpbmcgdG8gZG8gd2l0aCwgYXMgSSBsb29rZWQgYXQgdGhlIFNWTSBz
aWRlIG9mDQo+IHRoaW5ncywgdGhlIFZNQ0JzOg0KPiANCj4gCWlmIChzZC0+Y3VycmVudF92bWNi
ICE9IHN2bS0+dm1jYikgew0KPiANCj4gU28gaXQgaXMgbm90IG9ubHkgZGlmZmVyZW50IGd1ZXN0
cyBidXQgYWxzbyB3aXRoaW4gdGhlIHNhbWUgZ3Vlc3QgYW5kDQo+IHdoZW4gdGhlIFZNQ0Igb2Yg
dGhlIHZDUFUgaXMgbm90IHRoZSBjdXJyZW50IG9uZS4NCj4gDQo+IEJ1dCB0aGVuIGlmIFZNQ0Ig
b2YgdGhlIHZDUFUgaXMgbm90IHRoZSBjdXJyZW50LCBwZXItQ1BVIFZNQ0IsIHRoZW4gdGhhdA0K
PiBDUFUgcmFuIGFub3RoZXIgZ3Vlc3Qgc28gaW4gb3JkZXIgZm9yIHRoYXQgb3RoZXIgZ3Vlc3Qg
dG8gYXR0YWNrIHRoZQ0KPiBjdXJyZW50IGd1ZXN0LCB0aGVuIGl0cyBicmFuY2ggcHJlZCBzaG91
bGQgYmUgZmx1c2hlZC4NCj4gDQo+IEJ1dCBJJ20gbGlrZWx5IG1pc3NpbmcgYSB2aXJ0IGFzcGVj
dCBoZXJlIHNvIEknZCBsZXQgU2VhbiBleHBsYWluIHdoYXQNCj4gdGhlIHJ1bGVzIGFyZS4uLg0K
DQpIZXkgU2VhbiAtIHRvdWNoaW5nIGJhY2sgb24gdGhpcyBvbmUgdG8gc2VlIGlmIHdlcmUgYWJs
ZSB0byBnZXQgc29tZQ0KdGhvdWdodHMgdG9nZXRoZXIgb24gdGhpcyBvbmU/DQoNClRoYW5rcyAt
IEpvbg0KDQo+IA0KPiBUaHguDQo+IA0KPiAtLSANCj4gUmVnYXJkcy9HcnVzcywNCj4gICAgQm9y
aXMuDQo+IA0KPiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0
cHMtM0FfX3Blb3BsZS5rZXJuZWwub3JnX3RnbHhfbm90ZXMtMkRhYm91dC0yRG5ldGlxdWV0dGUm
ZD1Ed0lEYVEmYz1zODgzR3BVQ09DaEtPSGlvY1l0R2NnJnI9TkdQUkdHbzM3bVFpU1hnSEttNXJD
USZtPWc4TDZ4eVY1RkRhTVQxdEpaMEdTQUZxUkFmenljd2ItS3FWR0xlRjl0dWoyZGw4VG81N0pT
UHB0dzlfUUtobjImcz1EVTRtblRyTFhibU9JdHNCMGxUSk5ONGJnUDJZQzFuMVkyV2V5c044UGhN
JmU9IA0KDQo=
