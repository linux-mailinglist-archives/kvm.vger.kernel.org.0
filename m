Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22396A21B4
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 19:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBXSqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 13:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBXSqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 13:46:10 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2101.outbound.protection.outlook.com [40.107.223.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E453168293;
        Fri, 24 Feb 2023 10:46:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tk/vnDzEY0uWhix+zmMbwNV+6Mqt+LXi/2Oen1hQ7RHBA7SrYucKDbgro16rrHfnR7+FigllStlc8Kj8QoKgMLZlL/2tkwgkqgRXaa13v4GXmVHvhvGodMI9gV5I6eg+p72JBKFHgVUMcnTQdxUyeAEu73g+dH8PCY68b4zq/pdw6+Tjf4LQS05BvbULr4zXS+WkpWGUiRX5Z5t9DAxp305G36/i/ALMSpKP5Ptrm2KfPye2QZB/j59dd2U1fjqONk7SzzeuN8GGYjdB+/fWOZIG31EzYI6Gwt5fPxoKL35+Cb2fIvyADfh0rFfo9vByMYT0voBgClhsw05R8Ke/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LOl/3RaS+C5nmDsYjy9Drzj2DpJNuEQFkHzZjBGqX7A=;
 b=fgzo+7G8jC9/HEHTNskUjwxeatWSqFy3t2cpcxTQsLklddAJqcmta+ZDQ3m7rEvDzIlwhESmkxcsybgBpbnihU3U8CUIYTAt7v0u/2/1a4D8xmUPWJTN7gy5xCIUHtjxm8yRXAYznyCGnN9ml8pZLJ3R4RZzErTSz4SCh2ZrrEJkj5xf0URE/V+MzC/yuMNvkCu2N6VpY7mflvCc3/2xlcCAB4nbg3jlUsM88c+0Lpz1bbLk8FN/ghmM29FTX9jCFQOBrR/dTs8FrRAWZisVikHIwuc6rBuM9z+1wGUOOcZIkKNSNUojL60T9SJwii/CgGMCoKihjK+8kFuwT7gMjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOl/3RaS+C5nmDsYjy9Drzj2DpJNuEQFkHzZjBGqX7A=;
 b=BqzlDasdOUsmOtIgxb/8GeNjKfLgJjhS9Mo6vRcJriCROLpg0LpJCp3QUN3aArAmVYQx1iOOPk39iF5BU3bpdau2RPr/FPziQ+2rq64qWE00AN7NaMS75Q0g+HeUHzcJZBfC4oWMjDAAtgYd4HUIzMwiVkvzEHdljHpTZK3vxk8=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DM4PR21MB3056.namprd21.prod.outlook.com (2603:10b6:8:5c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.7; Fri, 24 Feb 2023 18:46:06 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a%5]) with mapi id 15.20.6156.005; Fri, 24 Feb 2023
 18:46:06 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Usama Arif <usama.arif@bytedance.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kim.phillips@amd.com" <kim.phillips@amd.com>,
        "brgerst@gmail.com" <brgerst@gmail.com>
CC:     "piotrgorski@cachyos.org" <piotrgorski@cachyos.org>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: RE: [PATCH v11 07/12] x86/smpboot: Send INIT/SIPI/SIPI to secondary
 CPUs in parallel
Thread-Topic: [PATCH v11 07/12] x86/smpboot: Send INIT/SIPI/SIPI to secondary
 CPUs in parallel
Thread-Index: AQHZR7r/6OCj/agkrUuXPSCA1yHYm67eaxzA
Date:   Fri, 24 Feb 2023 18:46:06 +0000
Message-ID: <BYAPR21MB16881C7140FEA56F5CE66851D7A89@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230223191140.4155012-1-usama.arif@bytedance.com>
 <20230223191140.4155012-8-usama.arif@bytedance.com>
In-Reply-To: <20230223191140.4155012-8-usama.arif@bytedance.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a8888a72-de74-4680-aa91-7e17469f06f4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-24T18:24:52Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DM4PR21MB3056:EE_
x-ms-office365-filtering-correlation-id: be0a3635-2b4f-451d-7470-08db1697631c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IvXYxL8u1HIFlO3mhOTOzpqPzr+sqQ83wqiqR8ttVbeZ+mpR8fDov7LNenqycmF/7iH4BCNd/aDQGQSZE2MkntY9914Mz4YwqQjtpUNds+vykwWmOk6u/3pTsvbnW7H9HMYh/meC+bJDN6q5ei3K8iOZ2H2OmJ75Lft9Dal26vpSR7TEDJB7VUiULOKLhPDmZr3FZklXHyJnSRnYK5KmiVMb39fd07rZN9XRobfcEwcBB8rueFvr+IIK42G46j8xSm9tx3j0cm5OBGxtwzgw42RUXhyhZsC71YMu/LxOCz8MS5NhJ6OoK4NwDiv8dRtoIkilzkOoVkaT7sODE5goi828jSq6l7C4b8tJUWvh4SKLFb9a0ihKpCPegzGuBnYyjUy4F0xp6oIK1/yJ9goKhc0f3xRpwa2XBQMrxpfwEUrzOpuyTqz+qrptWmLtOL7dGUaHCiaT/Y3s97Qqlc4PFEaMf4W2moTmr63n3Xq1CoSZahfTUjAaQAY9vdsITBvVwBdKXOJAOLPvroljdWAZFluegDjvVQCDCYIKmrqwEZYdIdtxknaCHvV3yNH+C5+sV4Ju474SWqFJg+1EUEuAPtUi6R/uO4odnn3f7v8lW0HesZ3aNfuS6e0X6Puu6GN63CaN5P4NqVKx83LOpJEQ9BbmX1/iaOfIiQk1xH6OlKzUvxZL4o0XdAf0TDXCVl7JL9Fxd57+GtAR7GFc6f4pC91yUCT7Q9kOV69lxI9Jf4vTUcsEM2jwd5Qf56/dF6W0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199018)(2906002)(41300700001)(8990500004)(52536014)(8936002)(54906003)(316002)(110136005)(4326008)(8676002)(7416002)(7696005)(5660300002)(10290500003)(71200400001)(478600001)(6506007)(9686003)(26005)(186003)(76116006)(64756008)(66556008)(66446008)(66946007)(66476007)(122000001)(86362001)(55016003)(82950400001)(82960400001)(38070700005)(83380400001)(33656002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXgzbTFIT2Rab1I1UkhtejlmYU9zQ2JsRlVTMExjSjlqQ3JVS0s5Yzd5WlNx?=
 =?utf-8?B?MHJOc2hoYURRaGpFOXFkSG1pVjlYR3ovMnZvamNVNUxyZzZFbW5nR25jY2xv?=
 =?utf-8?B?clZtc2M3M3NzMUVSMitRTElKdmxSTGJPckNjcEdURzRmNkNOaXpiOUIxaVBM?=
 =?utf-8?B?Mmg3NzRibzBZRkhDclRSRy8wZ21Td2c0UGxieEVzT2JGdk5IOEgwY1RSd2dr?=
 =?utf-8?B?bTBGUzJBQ0dlQXBBZDFENUNZUllsQ2JQdUJzdWo2MmxWSlZYSFJKVS9EWDRY?=
 =?utf-8?B?QmEydGZHUzdFMjgzRFJVTm51RXdnSW9oemkrMmdJWjlHZ1NBWmtOd2l2RSth?=
 =?utf-8?B?NGlGdkFOSDR1VDhzWWFnTDdHZzdvUFMwZ1pDKzNBK01NL2E4VFRnUkUvd0dF?=
 =?utf-8?B?N3JGd21LS1JtanAyREowclpSWU1QKzRrZEY2Q3FieHhYdklCZ3RvUDVzeXg5?=
 =?utf-8?B?RSt1bm5vMXRGeld4bFQxSlo4b1EyL1ZNb1BxN1ZNK1ZucGJOSDFYM3kwM0o5?=
 =?utf-8?B?SXF1VURXVkZiM2JxekhKUUg4UnlOT0gwdW1PdVVXU1RNQ3EyTElEbFdFS1ZY?=
 =?utf-8?B?d1hyVUZBR0I0b3B3c3d3bGRzSjRGZVRSUElUVmtrSVlheTc5bWtBY0VTN2ZC?=
 =?utf-8?B?SDduYTRYZTEvN2VLN2YvemVHOHBjd3NUTllRUmNDVzZxcGJTRU41eTVVR3hU?=
 =?utf-8?B?OGFiaVcwUnpZNEF4aUk4OTJHdVh4SXM3WUxiRG5VUFpTcjV0dFhSS2tiT3Ra?=
 =?utf-8?B?ZDIxV21EZDhaeVRIZ09ONnNNSGdIbXNVbzltbWZuY0J1V2pkWUwrajg4YVla?=
 =?utf-8?B?TE9xNzlhRStrYlpwblc5UlZzbHlOdEZXVm9adXRKRUtzM1Z0bGJGSSt0bmNr?=
 =?utf-8?B?SXJkVzhRaFRlSmhHZGdxOU5pL3A2T1FwU1Znd1JrUVVkRk9sUDlGb2tVTDM3?=
 =?utf-8?B?UHFmWDJHMzBQenY0UzBLSENZbjltMHlvRXQ2U2tkTERITEFKZVhCZzBGN0FS?=
 =?utf-8?B?VmZFd2RGalVHTWpCV3kvbWFpOGgrNGpRL0h1S0VQekhjUGVkcDBSNjE2Ui80?=
 =?utf-8?B?WmdhSG5PRXAxRlhyVW5vZEI4K0xQNXBXRFpHRnp2WGNPTEhtcGltaFJwV2xm?=
 =?utf-8?B?QjI2MzRZcG5yYmJ2L0ExNHc0Wm9qMUViaWEzQ20vZStyOEQ0azRuYVhjL2x4?=
 =?utf-8?B?VXlVeGVpR0l4NytFUzJGb2ZCMVo3R1R2VWY3WkNLQ1VBQ1YxV3l4QUdBYUpq?=
 =?utf-8?B?UEM1YnY3cllDcmJmOEdlMmEzVk45RnFuVUt2VzJuNFFXWVVxS3lDa0hDYzI5?=
 =?utf-8?B?a2JyemlOVENzblpOQUpKb2ZyMklyRDFNVTgrUVFBbmVBUElScmJwbG5NUkR1?=
 =?utf-8?B?QndZOEs0UzlNcXRaSFVjMTI4R2hYR0twQlVkbmliNzBTUW9GZUtNZ0pxZVRF?=
 =?utf-8?B?dWdBbHFoeFZHRE1KL3M3RUVrbnErNXdHVEF5dVA4eG5LV0tQdkdOWEJiT0h1?=
 =?utf-8?B?TlRFdyt2Q0N4ektzS2UxNW5Ga2prdHNXU21tSTM0azZUSjJlUGNRRFRBdmxN?=
 =?utf-8?B?MFBvbjRPL1dlTC9xR25rZ2ExRDZTOXAwaXdQM3VnZ29KZURqcTQvbFhnNE9w?=
 =?utf-8?B?YUhYb2VJVFRsdllWcy81YkYwVVlFTElsZDlNZXkwTE1XZjA0N2xYMkZ6ZUMz?=
 =?utf-8?B?OVdEVFpjbDJ6c2tYTWJIVTgyd1JNdlpjR2ZVL0t2WlEzaDBzWnFWZzlUWDhx?=
 =?utf-8?B?N2NCdWRqUGxjM1BUOTlEY2lYZ0RiQ2E5NmFqWlNkN3JCS0VuSTlpOUY0b3VG?=
 =?utf-8?B?ZFJ4T1c2R3doTElGZ1ZVbkx1ZkhxTXdNb1IrOTRpak1zdDhqa3g3bUJQSDVC?=
 =?utf-8?B?eUNtS2RQREMxUVk1dnVDdHBuZ09TdTc2QmZ3QTJnYXh1SDN0d09ObkZRU0Jp?=
 =?utf-8?B?NXd0YzB6dVZtZFlQMW5rWFVoemdoRXBjU1NjRTk4dkJBdXUwaVZoWUxkYURL?=
 =?utf-8?B?OUMvZUo3S1R1NzdJWDl6cmpoZVhNbnlST1BBbGNMM1ZIemN2TTRqTWpTckpq?=
 =?utf-8?B?b2lZWGlpNkd5d3BRNm41SXdjM1J2YzZRWHJCRi9OYTNLVFk5OUhzQ2xTZklC?=
 =?utf-8?B?cGo0WlhlRWFlRU93ZjBrdEFKdGEvcGYrckRNUG54QmRKaERIVVhqVkRXNWVw?=
 =?utf-8?B?c2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be0a3635-2b4f-451d-7470-08db1697631c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 18:46:06.1426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SnDXEajRdB7tvzYOeipIK4kbasmoqfbrbsu0yI2FOdhyQMnYSFCg+UFVzcSmofGw8rstRaiinPGsF0fPMHLWc7dpUIeApJNu+NcQqhh1ZGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3056
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogVXNhbWEgQXJpZiA8dXNhbWEuYXJpZkBieXRlZGFuY2UuY29tPiBTZW50OiBUaHVyc2Rh
eSwgRmVicnVhcnkgMjMsIDIwMjMgMTE6MTIgQU0NCj4gDQo+IEZyb206IERhdmlkIFdvb2Rob3Vz
ZSA8ZHdtd0BhbWF6b24uY28udWs+DQo+IA0KPiBXaGVuIHRoZSBBUHMgY2FuIGZpbmQgdGhlaXIg
b3duIEFQSUMgSUQgd2l0aG91dCBhc3Npc3RhbmNlLCBwZXJmb3JtIHRoZQ0KPiBBUCBicmluZ3Vw
IGluIHBhcmFsbGVsLg0KPiANCj4gUmVnaXN0ZXIgYSBDUFVIUF9CUF9QQVJBTExFTF9EWU4gc3Rh
Z2UgIng4Ni9jcHU6a2ljayIgd2hpY2gganVzdCBjYWxscw0KPiBkb19ib290X2NwdSgpIHRvIGRl
bGl2ZXIgSU5JVC9TSVBJL1NJUEkgdG8gZWFjaCBBUCBpbiB0dXJuIGJlZm9yZSB0aGUNCj4gbm9y
bWFsIG5hdGl2ZV9jcHVfdXAoKSBkb2VzIHRoZSByZXN0IG9mIHRoZSBoYW5kLWhvbGRpbmcuDQo+
IA0KPiBUaGUgQVBzIHdpbGwgdGhlbiB0YWtlIHR1cm5zIHRocm91Z2ggdGhlIHJlYWwgbW9kZSBj
b2RlICh3aGljaCBoYXMgaXRzDQo+IG93biBiaXRsb2NrIGZvciBleGNsdXNpb24pIHVudGlsIHRo
ZXkgbWFrZSBpdCB0byB0aGVpciBvd24gc3RhY2ssIHRoZW4NCj4gcHJvY2VlZCB0aHJvdWdoIHRo
ZSBmaXJzdCBmZXcgbGluZXMgb2Ygc3RhcnRfc2Vjb25kYXJ5KCkgYW5kIGV4ZWN1dGUNCj4gdGhl
c2UgcGFydHMgaW4gcGFyYWxsZWw6DQo+IA0KPiAgc3RhcnRfc2Vjb25kYXJ5KCkNCj4gICAgIC0+
IGNyNF9pbml0KCkNCj4gICAgIC0+IChzb21lIDMyLWJpdCBvbmx5IHN0dWZmIHNvIG5vdCBpbiB0
aGUgcGFyYWxsZWwgY2FzZXMpDQo+ICAgICAtPiBjcHVfaW5pdF9zZWNvbmRhcnkoKQ0KPiAgICAg
ICAgLT4gY3B1X2luaXRfZXhjZXB0aW9uX2hhbmRsaW5nKCkNCj4gICAgICAgIC0+IGNwdV9pbml0
KCkNCj4gICAgICAgICAgIC0+IHdhaXRfZm9yX21hc3Rlcl9jcHUoKQ0KPiANCj4gQXQgdGhpcyBw
b2ludCB0aGV5IHdhaXQgZm9yIHRoZSBCU1AgdG8gc2V0IHRoZWlyIGJpdCBpbiBjcHVfY2FsbG91
dF9tYXNrDQo+IChmcm9tIGRvX3dhaXRfY3B1X2luaXRpYWxpemVkKCkpLCBhbmQgcmVsZWFzZSB0
aGVtIHRvIGNvbnRpbnVlIHRocm91Z2gNCj4gdGhlIHJlc3Qgb2YgY3B1X2luaXQoKSBhbmQgYmV5
b25kLg0KPiANCj4gVGhpcyByZWR1Y2VzIHRoZSB0aW1lIHRha2VuIGZvciBicmluZ3VwIG9uIG15
IDI4LXRocmVhZCBIYXN3ZWxsIHN5c3RlbQ0KPiBmcm9tIGFib3V0IDEyMG1zIHRvIDgwbXMuIE9u
IGEgc29ja2V0IDk2LXRocmVhZCBTa3lsYWtlIGl0IHRha2VzIHRoZQ0KPiBicmluZ3VwIHRpbWUg
ZnJvbSA1MDBtcyB0byAxMDBtcy4NCg0KSSBidWlsdCBhbmQgdGVzdGVkIHRoaXMgc2VyaWVzIGlu
IGEgSHlwZXItViBWTSB3aXRoIDY0IHZDUFVzIHJ1bm5pbmcNCm9uIGFuIEFNRCBFUFlDICJNaWxh
biIgcHJvY2Vzc29yLiAgIFRoZSBWTSBoYXMgYW4geGFwaWMsIG5vdCBhbiB4MmFwaWMuDQoNClRo
ZSBwYXRjaCBzZXQgd29ya3MgY29ycmVjdGx5LCB3aXRoIGFuZCB3aXRob3V0IHRoZSBub19wYXJh
bGxlbF9icmluZ3VwDQprZXJuZWwgYm9vdCBvcHRpb24uICBJbiBhIHJ1bm5pbmcgTGludXggaW5z
dGFuY2UsIEkgd2FzIGxvb2tpbmcgZm9yIGEgd2F5IHRvDQpjb25maXJtIHdoZXRoZXIgaXQgdXNl
ZCBwYXJhbGxlbCBicmluZ3VwLiAgSSBjb3VsZCBvbmx5IGZpbmQgY2hlY2tpbmcgZm9yIHRoZQ0K
Ing4Ni9jcHU6a2ljayIgc3RhdGUgaW4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvaG90cGx1Zy9z
dGF0ZXMuICBBbHdheXMNCm91dHB1dHRpbmcgYSBib290IG1lc3NhZ2UgdG8gaW5kaWNhdGUgdGhl
IGFwcHJvYWNoIG1pZ2h0IGJlIGhlbHBmdWwuDQoNCkludGVyZXN0aW5nbHksIEkgZm91bmQgbm8g
cmVkdWN0aW9uIGluIGVsYXBzZWQgdGltZSB0byBicmluZyB1cCB0aGUgNjQgdkNQVXMuDQpEZXBl
bmRpbmcgb24gZXhhY3RseSB3aGVyZSB5b3UgbWVhc3VyZSwgaXQgaXMgODAgdG8gOTAgbWlsbGlz
ZWNvbmRzDQpiZWZvcmUgYXBwbHlpbmcgdGhlIHBhdGNoIHNldCwgYW5kIGFmdGVyIGFwcGx5aW5n
IHRoZSBwYXRjaCBzZXQgKHdpdGggb3INCndpdGhvdXQgbm9fcGFyYWxsZWxfYnJpbmd1cCkuICBF
dmlkZW50bHksIFZNcyBhbHJlYWR5IGF2b2lkIGEgZ29vZA0KcGFydCBvZiB0aGUgb3ZlcmhlYWQg
aW4gdGhlIGV4aXN0aW5nIHNlcmlhbGl6ZWQgYXBwcm9hY2guDQoNClsgICAgMS41MDM2OTldIHNt
cDogQnJpbmdpbmcgdXAgc2Vjb25kYXJ5IENQVXMgLi4uDQpbICAgIDEuNTA3MzM5XSB4ODY6IEJv
b3RpbmcgU01QIGNvbmZpZ3VyYXRpb246DQpbICAgIDEuNTExMTkyXSAuLi4uIG5vZGUgICMwLCBD
UFVzOiAgICAgICAgIzEgICMyICAjMyAgIzQgICM1ICAjNiAgIzcgICM4ICAjOSAjMTAgIzExDQoj
MTIgIzEzICMxNCAjMTUgIzE2ICMxNyAjMTggIzE5ICMyMCAjMjEgIzIyICMyMyAjMjQgIzI1ICMy
NiAjMjcgIzI4ICMyOQ0KIzMwICMzMSAjMzIgIzMzICMzNCAjMzUgIzM2ICMzNyAjMzggIzM5ICM0
MCAjNDEgIzQyICM0MyAjNDQgIzQ1ICM0NiAjNDcNCiM0OCAjNDkgIzUwICM1MSAjNTIgIzUzICM1
NCAjNTUgIzU2ICM1NyAjNTggIzU5ICM2MCAjNjEgIzYyICM2Mw0KWyAgICAxLjU4ODAzOV0gc21w
OiBCcm91Z2h0IHVwIDEgbm9kZSwgNjQgQ1BVcw0KWyAgICAxLjU5NTUxM10gc21wYm9vdDogTWF4
IGxvZ2ljYWwgcGFja2FnZXM6IDENClsgICAgMS41OTkxODZdIHNtcGJvb3Q6IFRvdGFsIG9mIDY0
IHByb2Nlc3NvcnMgYWN0aXZhdGVkICgyNTU1MjQuMjIgQm9nb01JUFMpDQoNClRoZSAieDg2L2Nw
dTpraWNrIiBzdGF0ZSB3YXMgcHJlc2VudCBmb3IgdGhlIHBhcmFsbGVsIGJyaW5ndXAgY2FzZSwg
c28NCnByZXN1bWFibHkgdGhlIHBhcmFsbGVsIGJlaGF2aW9yICpkaWQqIGhhcHBlbiwgdW5sZXNz
IHRoZXJlIGlzIGxhdGVyDQpiYWlsb3V0IHBhdGggdGhhdCBJIG1pc3NlZC4gIEJ1dCB0aGVyZSB3
ZXJlbid0IGFueSBib290IG1lc3NhZ2VzDQppbmRpY2F0aW5nIHN1Y2guDQoNCk1pY2hhZWwNCg0K
Rm9yIHRoZSBzZXJpZXMsIG9uIEh5cGVyLVYgZ3Vlc3RzOg0KVGVzdGVkLWJ5OiBNaWNoYWVsIEtl
bGxleSA8bWlrZWxsZXlAbWljcm9zb2Z0LmNvbT4NCg0KPiANCj4gVGhlcmUgaXMgbW9yZSBzcGVl
ZHVwIHRvIGJlIGhhZCBieSBkb2luZyB0aGUgcmVtYWluaW5nIHBhcnRzIGluIHBhcmFsbGVsDQo+
IHRvbyDigJQgZXNwZWNpYWxseSBub3RpZnlfY3B1X3N0YXJ0aW5nKCkgaW4gd2hpY2ggdGhlIEFQ
IHRha2VzIGl0c2VsZg0KPiB0aHJvdWdoIGFsbCB0aGUgc3RhZ2VzIGZyb20gQ1BVSFBfQlJJTkdV
UF9DUFUgdG8gQ1BVSFBfT05MSU5FLiBCdXQgdGhvc2UNCj4gcmVxdWlyZSBjYXJlZnVsIGF1ZGl0
aW5nIHRvIGVuc3VyZSB0aGV5IGFyZSByZWVudHJhbnQsIGJlZm9yZSB3ZSBjYW4gZ28NCj4gdGhh
dCBmYXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBXb29kaG91c2UgPGR3bXdAYW1hem9u
LmNvLnVrPg0KPiBTaWduZWQtb2ZmLWJ5OiBVc2FtYSBBcmlmIDx1c2FtYS5hcmlmQGJ5dGVkYW5j
ZS5jb20+DQo+IFRlc3RlZC1ieTogUGF1bCBFLiBNY0tlbm5leSA8cGF1bG1ja0BrZXJuZWwub3Jn
Pg0KPiBUZXN0ZWQtYnk6IEtpbSBQaGlsbGlwcyA8a2ltLnBoaWxsaXBzQGFtZC5jb20+DQo+IFRl
c3RlZC1ieTogT2xla3NhbmRyIE5hdGFsZW5rbyA8b2xla3NhbmRyQG5hdGFsZW5rby5uYW1lPg0K
PiAtLS0NCj4gIGFyY2gveDg2L2tlcm5lbC9zbXBib290LmMgfCAyMSArKysrKysrKysrKysrKysr
KystLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9zbXBib290LmMgYi9hcmNoL3g4
Ni9rZXJuZWwvc21wYm9vdC5jDQo+IGluZGV4IDc0Yzc2Yzc4ZjdkMi4uODVjZTZhODk3OGZmIDEw
MDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvc21wYm9vdC5jDQo+ICsrKyBiL2FyY2gveDg2
L2tlcm5lbC9zbXBib290LmMNCj4gQEAgLTU3LDYgKzU3LDcgQEANCj4gICNpbmNsdWRlIDxsaW51
eC9wZ3RhYmxlLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvb3ZlcmZsb3cuaD4NCj4gICNpbmNsdWRl
IDxsaW51eC9zdGFja3Byb3RlY3Rvci5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L3NtcGJvb3QuaD4N
Cj4gDQo+ICAjaW5jbHVkZSA8YXNtL2FjcGkuaD4NCj4gICNpbmNsdWRlIDxhc20vY2FjaGVpbmZv
Lmg+DQo+IEBAIC0xMzI1LDkgKzEzMjYsMTIgQEAgaW50IG5hdGl2ZV9jcHVfdXAodW5zaWduZWQg
aW50IGNwdSwgc3RydWN0IHRhc2tfc3RydWN0DQo+ICp0aWRsZSkNCj4gIHsNCj4gIAlpbnQgcmV0
Ow0KPiANCj4gLQlyZXQgPSBkb19jcHVfdXAoY3B1LCB0aWRsZSk7DQo+IC0JaWYgKHJldCkNCj4g
LQkJcmV0dXJuIHJldDsNCj4gKwkvKiBJZiBwYXJhbGxlbCBBUCBicmluZ3VwIGlzbid0IGVuYWJs
ZWQsIHBlcmZvcm0gdGhlIGZpcnN0IHN0ZXBzIG5vdy4gKi8NCj4gKwlpZiAoIWRvX3BhcmFsbGVs
X2JyaW5ndXApIHsNCj4gKwkJcmV0ID0gZG9fY3B1X3VwKGNwdSwgdGlkbGUpOw0KPiArCQlpZiAo
cmV0KQ0KPiArCQkJcmV0dXJuIHJldDsNCj4gKwl9DQo+IA0KPiAgCXJldCA9IGRvX3dhaXRfY3B1
X2luaXRpYWxpemVkKGNwdSk7DQo+ICAJaWYgKHJldCkNCj4gQEAgLTEzNDksNiArMTM1MywxMiBA
QCBpbnQgbmF0aXZlX2NwdV91cCh1bnNpZ25lZCBpbnQgY3B1LCBzdHJ1Y3QgdGFza19zdHJ1Y3QN
Cj4gKnRpZGxlKQ0KPiAgCXJldHVybiByZXQ7DQo+ICB9DQo+IA0KPiArLyogQnJpbmd1cCBzdGVw
IG9uZTogU2VuZCBJTklUL1NJUEkgdG8gdGhlIHRhcmdldCBBUCAqLw0KPiArc3RhdGljIGludCBu
YXRpdmVfY3B1X2tpY2sodW5zaWduZWQgaW50IGNwdSkNCj4gK3sNCj4gKwlyZXR1cm4gZG9fY3B1
X3VwKGNwdSwgaWRsZV90aHJlYWRfZ2V0KGNwdSkpOw0KPiArfQ0KPiArDQo+ICAvKioNCj4gICAq
IGFyY2hfZGlzYWJsZV9zbXBfc3VwcG9ydCgpIC0gZGlzYWJsZXMgU01QIHN1cHBvcnQgZm9yIHg4
NiBhdCBydW50aW1lDQo+ICAgKi8NCj4gQEAgLTE1NjYsNiArMTU3NiwxMSBAQCB2b2lkIF9faW5p
dCBuYXRpdmVfc21wX3ByZXBhcmVfY3B1cyh1bnNpZ25lZCBpbnQNCj4gbWF4X2NwdXMpDQo+ICAJ
CXNtcGJvb3RfY29udHJvbCA9IFNUQVJUVVBfU0VDT05EQVJZIHwNCj4gU1RBUlRVUF9BUElDSURf
Q1BVSURfMDE7DQo+ICAJfQ0KPiANCj4gKwlpZiAoZG9fcGFyYWxsZWxfYnJpbmd1cCkgew0KPiAr
CQljcHVocF9zZXR1cF9zdGF0ZV9ub2NhbGxzKENQVUhQX0JQX1BBUkFMTEVMX0RZTiwNCj4gIng4
Ni9jcHU6a2ljayIsDQo+ICsJCQkJCSAgbmF0aXZlX2NwdV9raWNrLCBOVUxMKTsNCj4gKwl9DQo+
ICsNCj4gIAlzbnBfc2V0X3dha2V1cF9zZWNvbmRhcnlfY3B1KCk7DQo+ICB9DQo+IA0KPiAtLQ0K
PiAyLjI1LjENCg0K
