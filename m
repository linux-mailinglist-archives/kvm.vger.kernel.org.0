Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0851C52F473
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 22:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351107AbiETUeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 16:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbiETUeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 16:34:17 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51D618E07;
        Fri, 20 May 2022 13:34:15 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KEZAjw006879;
        Fri, 20 May 2022 13:33:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=4rjVSIbTQvhZ7y+H4MMXrIwRDtre5FQjO82Q+wd6zak=;
 b=vVwyOKVcHw9Hm1J+jWqP9u8uKpAAG7jMWtiyogS3ALYsWBG9c06WNJwUci/WqRFv7yiP
 tu0Vau7ZtY5VSjQ8ozGzgPoKJIDgYiQ9vfzzmPsVXvu2sF/4vl9/+Dhv3UygloLDlVKZ
 DEcchIcl87ykfCbehmG1satcJDmXm30LlJYjjH/O1j80FfUA6msxCFwa6gKZjj/eEwag
 jdfY61qMxqhs+tJsK8ThXxx3a2n4hqCM6Cjam1cddaRduSgeYGYkOOEqqg60GpRqRBTW
 3yOENv5366cAJn7+3j36CBiB53IjBDnOAqB014v6c5eFoAafx1Jp4QAym/s1wP8cwI92 FQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3g28b9ede7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 13:33:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eAcnUrHtqWSzFQHuRKINvoGxESsJm8D6MvX5GAiRVigp4gVufCqk8sWBtFVYqzvKk0yWucVWwt5Pcuqu5Gzga2NYU3nF97Hbiqu+3aX4kcyt/oIm2lz5/LBnYmPBNHa0MKQGArw20/xx+Zl00eVVFE3PlolVPJ8QgG29kWO7VzW2z7nk5wdFZartA6JtBaOJuPc05/IE+JG/AXeiwmarWNht0g3gtohh3vX+P2qj/42KiM0iHkthZvoS92BxwqpIhXXB7fqWNAfCMTpzHsYwGKvULxdgxnc+2SGuS12yreHqkpnapn404mUPtxsS18YZbcnJDB5g6uKcsAg45zv+nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rjVSIbTQvhZ7y+H4MMXrIwRDtre5FQjO82Q+wd6zak=;
 b=j27sHq3RBqw0Kti2RjYmQ9dhEpn2AWxkw8YvsHNNe6L8lnC4zFbMk0ELgbVqDJkq4lkXbiJlzBWxq+dUP8b3pDBh1mBlBj27AC6mn1SGt4V0mHnNQDOfuoXSnwhh+mmWIJfsBeTV2Sj0c8vAPOvMP3gUU55iQRUCOkDIgSX7RBILUnTKpwMSZ3h/qn+EOyWFcOEsJtK0jmh99gSatIXjGSp91c3/90F9jbV8toAjX/uyBExsPDY/P3j+zzNV3SH+GPLjFU78Mj191E2IKyAdowFq8ZHHY1eleadc6bvWXMLnZ/W/ILtlurCFPDsJFq1hjRFeyw5y94NCc6GlTrcnuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CH0PR02MB8212.namprd02.prod.outlook.com (2603:10b6:610:eb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Fri, 20 May
 2022 20:33:32 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 20:33:31 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Thread-Topic: [PATCH] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Thread-Index: AQHYZigD50jTp0T7q026slKeRH2Mca0j5MwAgADUdACAA4GpgIAAAt6AgAACMQCAAASaAIAAANkA
Date:   Fri, 20 May 2022 20:33:31 +0000
Message-ID: <8E168064-3044-43DE-A22D-60D683108E12@nutanix.com>
References: <20220512174427.3608-1-jon@nutanix.com>
 <YoRPDp/3jfDUE529@google.com>
 <29CDF294-5394-47C7-8B50-5F1FC101891C@nutanix.com>
 <732266F9-9904-434A-857F-847203901A0C@nutanix.com>
 <Yof0sSy/xKrCY5ke@google.com>
 <13E3F717-2938-430F-BA8B-70DD87962344@nutanix.com>
 <Yof6ZE0IjSAL+iO8@google.com>
In-Reply-To: <Yof6ZE0IjSAL+iO8@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf297671-7f0e-45e4-ff2e-08da3aa00168
x-ms-traffictypediagnostic: CH0PR02MB8212:EE_
x-microsoft-antispam-prvs: <CH0PR02MB82124B2CF3CCF5528F168B95AFD39@CH0PR02MB8212.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H7zyBMQ5LtbKtCcqB4+YjkhtkFHdfKolAVLBqR60QGomRKG75y80Sgg4SYmAORs8rkeprOzmggfwm3KT7K779YJccbWKSdXr4TcXlAT9laN8EsXbQy8D9mNXDyd/xJwrzjGqP5fEV0eqK6zEnmd8m/nL2tfK0FGi2MBPsNvGlGQQFLkj6w1wBn4O1Z3LPp6afA+5T2p2vZl2lAK/HpCa7tG9FyGd/Sd50Ad0WkuqHjjWwYkCsTe2MKyDxnJymVWxmF7sWqKEc6DxwQsUCzQptiZ3bESZNXsihIwZ3OfgWhC/a/81S7+HYt2359WbhrkLLVvgaiJeKgX5B5is/GytU1OGW77fRHJHoSG0bNum4vrxqZwlWZr+rnlTCs32b+/4eLMikhhsvJuPoxI5rsUqvZVWTOvOmVJKCtQiwDvRoI5Lmhz9BhAwUrg0TU6hJfuCjYDTuZO/eZktZIvHIJg/gvFimIkaa+7AYLG6VSHdRUyNTlYOa8ZbkPlDRlmJexuHZrVyv2XMc9JcX2qi1rAx6Nue4AgPdW5MFyX3Dr2Mxof3z0yauVl4FkoXarmpIuJvz3dznVjj+LQyFQofUuKoXCYdB96LqSJPiwB9/W7VpylBTHryQgX12BQD7bE9Ma+QEJylvXESart0eZlTsFeLqb+mBRdIT9hSX9pEQ/DOtURy8kwshDOxUis3vx8Sh7s0uOSWx3peoXzd8tVu9EDYdx9Ok/TcP7ga+SUvs0B4NBk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(6486002)(38070700005)(122000001)(8676002)(66946007)(66446008)(76116006)(33656002)(66476007)(66556008)(64756008)(38100700002)(71200400001)(5660300002)(508600001)(6512007)(91956017)(86362001)(186003)(83380400001)(316002)(7416002)(6916009)(36756003)(54906003)(8936002)(53546011)(6506007)(2906002)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MEpuZVF5enBENC9IaW1MSWxzSzUwWnJaVWxQMzRVMWpYZ0tqMEFic21iVnRS?=
 =?utf-8?B?K1dPV08rN1J1RFVZbEhVeGkwUnlxZ1R4cVNzU1FLTTRZeCtKaEp5WWZTQkY5?=
 =?utf-8?B?M2Q1cXF0ZnRNTGU3WHJvSE13NnNPdi9Bc3oxaWhPRlVpaW1pSXJlRDJrWXhx?=
 =?utf-8?B?c2I2UXRsUm9NUExESWRJVjFNM3VOS2FqMDNNNEorb1BhNWk0Zko1TFRBbjhF?=
 =?utf-8?B?SU9zb244d1o2U0hQQ3JVR0wvQmpGRktlay80YnU2bkFsTmJiRFNhUEhzRVQv?=
 =?utf-8?B?RStJR1VjN2xoT05RaVZpZlFxSVVOUjYzR1JXOWNWTHBoQ3I5TG9qVWhza2s0?=
 =?utf-8?B?ckJ5NTEwdG04YUgrRlh5dFlGaHhNZFdTMGR1UjhjUkJwMk9WMHQ0VVlaQlVp?=
 =?utf-8?B?NlVyUHI5OVdlQ1p4UUw0c1VEQkltQ3JnZ0JDOEZmdmVZYjl3eTVrVFBQSlps?=
 =?utf-8?B?V0cxdUV4dmtSVnQzdndsTWQ2ZUZDa3orazNNZlVCc1lSczB4TXV1dWJHVG1H?=
 =?utf-8?B?MVhFZitFSXJxelpla2NVMnhTeDREaDZjcW1GeXhXczlZcXBjeHYvN3dzQjZB?=
 =?utf-8?B?ZHloemkyVVpLdnZXa1ZPWUJRNWhSa0lMclZJVmlaOVFucmFrKzc0UndTWVBr?=
 =?utf-8?B?NmxpeHkxc1hQc1J0TGxMSllFaUMySURWeWVpMTV1cW53UStVM1c0M1pwUmlC?=
 =?utf-8?B?dzQ3eWpoVTJrWTNLSG5TUlJpYWM3TmNQakFsVENuY1lSOVV0YmxFbkYyczVq?=
 =?utf-8?B?Tk0xc3VwaFN4SzJXd2NlUkxnTlkxMGNseXhDVytmVUdkOTd2S0ZKcExxVUR4?=
 =?utf-8?B?dm5WL0NzSGo3dEpsTjV1cVR5SDBnZFZHdmEzelMrMUZnSXNJUDhpbFRxWE1s?=
 =?utf-8?B?M1pOL0UrQ2daRnl6Nmp6MmtmV1A5dDROTlJQb0dOMjhVQ09KU0EzSlRjMkVl?=
 =?utf-8?B?SXgxcTBBZ3Ayc25oZGR6aTM1UGQ2OHh3SVBGbjZ4RUxsQ2NzTkZYQng3VUZ6?=
 =?utf-8?B?VGJyb1BEYldHczFFdkdUb2lOWGN0SnV2VGkwRy9Xd0krNEh4TkhGVWFnc0tk?=
 =?utf-8?B?NzdHR09XZGhTOGZiM2hHTlZDZGtQZWdiSzB0K2FId0JwZW1CbzJaR1lqWHpy?=
 =?utf-8?B?THhUaVJKemZ0VU9sMzQwQm15ZE1jcVVQaTZoN3lLdGJ4RWdmRlNYclFGSGpW?=
 =?utf-8?B?RWxwcnpmQkZXTzVMMkZvR1JJM25zU1B3QkdLS1NHclFEUnQxbzdwdExVRm16?=
 =?utf-8?B?dEQzbkNUb2xxNUNEUC9XMGtlMmIyb01yb2RVTHgxaGdDWFN2TVVIZkF5Ukl0?=
 =?utf-8?B?SFBwMmNHRVJLU0d6VFQ4RXR2TUhYVC8rNVdRczRwV3JsZXdOOENhbHN0MHN4?=
 =?utf-8?B?U09ZSmxMT3pyT1BhbGIzNW1JTmNBazgvaXJXL0JYWjNQL2hxYytzaXJuZmVQ?=
 =?utf-8?B?ODdHRVhPTWwxR3ZwZDROR2dTb1Z5SVg5K1A1T0xjenpGcmowNzA1Umo1UEpn?=
 =?utf-8?B?S1RVN09pcms1TDVNZk45dmI3NEVNYWx0OFMxUmRuMS9DY1hFZVFoOGVSWTho?=
 =?utf-8?B?MmozRDVTdzBlUXFEVjl6R1ZLcGo2aHJCWVFGYnI0L2pIU3d6TndjUWxMT0t6?=
 =?utf-8?B?V0hMdVc3RHZQcmdRMFRQRFlTTkZwZHUyWWk2L2hHUkdhRGJRelVRRDFJYjdu?=
 =?utf-8?B?dWNlalNVZVRHWGFsWjdjR2tYOXh1UGxjWFdnbkhGUGtQSlZhbDFoU2xkNy96?=
 =?utf-8?B?anlkTThkMFdROXB1clRiSS9rR1NQVXQwRDBZOTluQzZROHNpYzJRS3pCeDNt?=
 =?utf-8?B?dFRmOUcxemkxaC9ZQlppVDF1OWRReVIvbW81VlRRS1pZRklHd1VFTndoNGFZ?=
 =?utf-8?B?YzdVMlN3VHFxYlhtZ1Q2VStvVDYwRWxvdWhJWVEvRUp5QXJTNEpVRGlNYk9K?=
 =?utf-8?B?dFlKVmRWdk9scXVVQkpRRlVRQUE4cVF5RHFSbndzbUgwMVRleWFBQzVrWEwv?=
 =?utf-8?B?QTNSbDZuOFBNdmJzT1BQTi9IVWZ2OTRMbmRaelhzaFhyNnJqdmVraTB4OW1W?=
 =?utf-8?B?dnFXSDF4aTJXYUdaM3ErNnM2bm40N29BcWZHQi84cG1MRFJoRlV4cCtCSFFh?=
 =?utf-8?B?aFByalV2eTlVZFlwZXd0QWNRcVV5SXlPanZ5SUkvMis5SXlOdXNzYTM0MnZB?=
 =?utf-8?B?WEF4THlQRWZPb3N1TTFRdW85Q04zMnhCZnl1dXV3OFdtRnJqMEhiVXltd2dQ?=
 =?utf-8?B?ZXBUVVVpUE5JZVJEdXY1RUFzUFRQcU1RcG9XVjFVRUFjN2hMMXFxN3l4TzJj?=
 =?utf-8?B?RmZjVjBueHlOVXVBSFdHNnBScWU5YXNxc2FmNllENGdCZ1p0Q2RXVHcwTTE4?=
 =?utf-8?Q?D1+zi8JfRMlnGMWEQz1Nj3Vs4eW25INX343M05O8gbP75?=
x-ms-exchange-antispam-messagedata-1: JbDvwnoMskNuWsZLh8lS1maqVZ9i356q9O2N82anKHkG6XUKRavQ1ejh
Content-Type: text/plain; charset="utf-8"
Content-ID: <89D95C6D19564243BAA8D1B6BDD71F2A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf297671-7f0e-45e4-ff2e-08da3aa00168
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 20:33:31.8558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2fmLGDMvaemO+aVMUxpHwN9EF/eCKtIyUmg+1VNfkPf2o01aYwOjD19HAsJ5wTrb7ueWwMdw0dnVxhyRVITR2ncgtQbQqdwosKJyzfR5vsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8212
X-Proofpoint-GUID: jaJnDraNrn0NOE7np-FxtdFYPftPULYZ
X-Proofpoint-ORIG-GUID: jaJnDraNrn0NOE7np-FxtdFYPftPULYZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDIwLCAyMDIyLCBhdCA0OjMwIFBNLCBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIE1heSAyMCwgMjAyMiwgSm9u
IEtvaGxlciB3cm90ZToNCj4+IA0KPj4gDQo+Pj4gT24gTWF5IDIwLCAyMDIyLCBhdCA0OjA2IFBN
LCBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+Pj4gDQo+
Pj4gT24gRnJpLCBNYXkgMjAsIDIwMjIsIEpvbiBLb2hsZXIgd3JvdGU6DQo+Pj4+IA0KPj4+Pj4g
T24gTWF5IDE4LCAyMDIyLCBhdCAxMDoyMyBBTSwgSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29t
PiB3cm90ZToNCj4+Pj4+IA0KPj4+Pj4+IE9uIE1heSAxNywgMjAyMiwgYXQgOTo0MiBQTSwgU2Vh
biBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPj4+Pj4+PiArCQlp
ZiAoYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX0lCUlNfRU5IQU5DRUQpICYmIGRhdGEgPT0gQklU
KDApKSB7DQo+Pj4+Pj4gDQo+Pj4+Pj4gVXNlIFNQRUNfQ1RSTF9JQlJTIGluc3RlYWQgb2Ygb3Bl
biBjb2RpbmcgIkJJVCgwKSIsIHRoZW4gYSBjaHVuayBvZiB0aGUgY29tbWVudA0KPj4+Pj4+IGdv
ZXMgYXdheS4NCj4+Pj4+PiANCj4+Pj4+Pj4gKwkJCXZteC0+c3BlY19jdHJsID0gZGF0YTsNCj4+
Pj4+Pj4gKwkJCWJyZWFrOw0KPj4+Pj4+PiArCQl9DQo+Pj4+Pj4gDQo+Pj4+Pj4gVGhlcmUncyBu
byBuZWVkIGZvciBhIHNlcGFyYXRlIGlmIHN0YXRlbWVudC4gIEFuZCB0aGUgYm9vdF9jcHVfaGFz
KCkgY2hlY2sgY2FuDQo+Pj4+Pj4gYmUgZHJvcHBlZCwga3ZtX3NwZWNfY3RybF90ZXN0X3ZhbHVl
KCkgaGFzIGFscmVhZHkgdmVyaWZpZWQgdGhlIGJpdCBpcyB3cml0YWJsZQ0KPj4+Pj4+ICh1bmxl
c3MgeW91J3JlIHdvcnJpZWQgYWJvdXQgYml0IDAgYmVpbmcgdXNlZCBmb3Igc29tZXRoaW5nIGVs
c2U/KQ0KPj4+PiANCj4+Pj4gSSB3YXMgKGFuZCBhbSkgd29ycmllZCBhYm91dCBtaXNiZWhhdmlu
ZyBndWVzdHMgb24gcHJlLWVJQlJTIHN5c3RlbXMgc3BhbW1pbmcgSUJSUw0KPj4+PiBNU1IsIHdo
aWNoIHdlIHdvdWxkbuKAmXQgYmUgYWJsZSB0byBzZWUgdG9kYXkuIEludGVs4oCZcyBndWlkYW5j
ZSBmb3IgZUlCUlMgaGFzIGxvbmcgYmVlbg0KPj4+PiBzZXQgaXQgb25jZSBhbmQgYmUgZG9uZSB3
aXRoIGl0LCBzbyBhbnkgZUlCUlMgYXdhcmUgZ3Vlc3Qgc2hvdWxkIGJlaGF2ZSBuaWNlbHkgd2l0
aCB0aGF0Lg0KPj4+PiBUaGF0IGxpbWl0cyB0aGUgYmxhc3QgcmFkaXVzIGEgYml0IGhlcmUuDQo+
Pj4gDQo+Pj4gVGhlbiBjaGVjayB0aGUgZ3Vlc3QgY2FwYWJpbGl0aWVzLCBub3QgdGhlIGhvc3Qg
ZmxhZy4NCj4+PiANCj4+PiAJaWYgKGRhdGEgPT0gU1BFQ19DVFJMX0lCUlMgJiYNCj4+PiAJICAg
ICh2Y3B1LT5hcmNoLmFyY2hfY2FwYWJpbGl0aWVzICYgQVJDSF9DQVBfSUJSU19BTEwpKQ0KPj4g
DQo+PiBTbyBJIG9yaWdpbmFsbHkgZGlkIHRoYXQgaW4gbXkgZmlyc3QgaW50ZXJuYWwgcGF0Y2g7
IGhvd2V2ZXIsIHRoZSBjb2RlIHlvdSB3cm90ZSBpcw0KPj4gZWZmZWN0aXZlbHkgdGhlIGNvZGUg
SSB3cm90ZSwgYmVjYXVzZSBjcHVfc2V0X2J1Z19iaXRzKCkgYWxyZWFkeSBkb2VzIHRoYXQgZXhh
Y3QNCj4+IHNhbWUgdGhpbmcgd2hlbiBpdCBzZXRzIHVwIFg4Nl9GRUFUVVJFX0lCUlNfRU5IQU5D
RUQuIA0KPj4gDQo+PiBJcyB0aGUgYm9vdCBjcHUgY2hlY2sgbW9yZSBleHBlbnNpdmUgdGhhbiBj
aGVja2luZyB0aGUgdkNQVSBwZXJoYXBzPyBPdGhlcndpc2UsDQo+PiBjaGVja2luZyBYODZfRkVB
VFVSRV9JQlJTX0VOSEFOQ0VEIHNlZW1lZCBsaWtlIGl0IG1pZ2h0IGJlIGVhc2llcg0KPj4gdW5k
ZXJzdGFuZCBmb3IgZnV0dXJlIG9ubG9va2VycywgYXMgdGhhdHMgd2hhdCB0aGUgcmVzdCBvZiB0
aGUga2VybmVsIGtleXMgb2ZmIG9mDQo+PiB3aGVuIGNoZWNraW5nIGZvciBlSUJSUyAoZS5nLiBp
biBidWdzLmMgZXRjKS4gDQo+IA0KPiBDb3N0IGlzIGlycmVsZXZhbnQsIGNoZWNraW5nIFg4Nl9G
RUFUVVJFX0lCUlNfRU5IQU5DRUQgaXMgc2ltcGx5IHdyb25nLiAgSnVzdA0KPiBiZWNhdXNlIGVJ
QlJTIGlzIHN1cHBvcnRlZCBpbiB0aGUgaG9zdCBkb2Vzbid0IG1lYW4gaXQncyBhZHZlcnRpc2Vk
IHRvIHRoZSBndWVzdCwNCj4gZS5nLiBhbiBvbGRlciBWTSBjb3VsZCBoYXZlIGJlZW4gY3JlYXRl
ZCB3aXRob3V0IGVJQlJTIGFuZCB0aGVuIG1pZ3JhdGVkIHRvIGEgaG9zdA0KPiB0aGF0IGRvZXMg
c3VwcG9ydCBlSUJSUy4gIE5vdyB5b3UgaGF2ZSBhIGd1ZXN0IHRoYXQgdGhpbmtzIGl0IG5lZWRz
IHRvIGNvbnN0YW50bHkNCj4gdG9nZ2xlIElCUlMgKEkgYXNzdW1lIHRoYXQncyB0aGUgcHJlLWVJ
QlJTIGJlaGF2aW9yKSwgYnV0IGJ5IGxvb2tpbmcgYXQgdGhlIF9ob3N0Xw0KPiB2YWx1ZSBLVk0g
d291bGQgYXNzdW1lIGl0J3MgYSBvbmUtdGltZSB3cml0ZSBhbmQgbm90IGRpc2FibGUgaW50ZXJj
ZXB0aW9uLg0KDQpBaGhoaGhoLCBnb3RjaGEsIG9rIEkgdW5kZXJzdGFuZCB0aGUgbnVhbmNlIGhl
cmUuIE9mZiB0byB2MyBJIGdvLiANCg0KVGhhbmtzIGFnYWluIQ0KDQo=
