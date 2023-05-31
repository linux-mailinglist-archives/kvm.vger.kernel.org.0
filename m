Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A84718840
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 19:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjEaROK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 13:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjEaROI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 13:14:08 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178AE11D;
        Wed, 31 May 2023 10:14:03 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VETBGn004420;
        Wed, 31 May 2023 10:13:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=KNMh5jk2ZsDLcPFJYQdr+ulzcualNfI1DNWu5TK5yBQ=;
 b=UMeZ1WErFeDQbvXb0PbM9/L7oR+Qj9TS7fhXctjbpdhmYKqlgNN157pxrUz3P2zRj70Q
 Eo4LctBEO0kGZnpYAm7590MSNcFvK2yyqdAOhmWn02bHoPg5rtvFnuquBco7tUVxpm14
 QYf7HYnDttdkFe7l0VJAIFnVDuUTQtgpoKLoMGMjEk4RhQ6U47Lq3ZcrZp9rLvTk7IgP
 wfEXhOBpqMkAyiCLVFw+J43VAwCcHrEUi9Cim5KlKi2PGoMQklB5sPUzDwibVCZe2Ff3
 ZqykdAqIv2P851hfqTN1k2httR3XcomxkJhnyE3Ej/gldThg6kpvIoPabYFWO/5roZRR gQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3qufyfag4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 10:13:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5GqPbxZUAy3lNtitVaUgI1QzzUQ0/Qa6azcsTVHvQx05Xg+5CXVtYyZ8O+ouxH/T6LfisYCiMbyYI7nb0bqlpcS7olhQ0+ah/wPCgGOpqV3IU4Z1YROp/FaKtDXuHWKDqH24NbFrpvtxk/LIUFZ3SA/pEVRXWEaHjoc4zL/sY9xjbEuK8GkpeA1uUl39dEBPrMe0hlSK479/1R6LrMUwLT5O90RfwqVE954/e1pewmRvE7aUKuLC/ZK/yAFFkCiHz9Sh8jTBUV99I+0SK5PnXbfTTME5S7LIMDoVSViigaf9u0ellBQjQKEI4Yypa6RrhgYjZ0Tr0BwjYsVfKN1xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNMh5jk2ZsDLcPFJYQdr+ulzcualNfI1DNWu5TK5yBQ=;
 b=gcyg7yrwx/s+ED7n9TOz3B+33vgnhx30iQLQZifKnyFSFciTeh0g50oCQY1u+Di3BtBug8mWGBU0uhybVe6JWsbPTn29kTyyIl/cCjI4rUQaFitOpLrTKuPk5iDUY1Z9ERbKWX5IBwMTuRLCURaMac1Fb4ilc8n5gfGQC4k+25G5sR8tqbiXEPx1l8tha08itNZxmau446s/wN2dv2jA+hG2VQKvSK/k9trAxoV8v4w9ATn48hfTXueqESSmcQFgqMHODPJNEUwlj9W+1sXPCUSO4Kw2HqGta4YtNes6q1r/77sY/x+0A+f1PqVx5GL7yttFJGX9D9Mi4265YAJ0cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNMh5jk2ZsDLcPFJYQdr+ulzcualNfI1DNWu5TK5yBQ=;
 b=YsiWEhyLJYqQxTNbzpGel934C78o+rLbL48kWJGM8cnI5OMJ3fk/1Z0bxX1HpKqHNLIzkTRf9XaF/Uyi8H+fXHtaV0JB/pZxUCeqTtAyp7eE0Atu0tTW+Jz3xBrRun6Nfi6M9n8SxAg3wO/2UM63qVogEcI4OimDpx1CIuocMWEb96Knqld7lWFFETb0JmzxzdyRZ69vD9WSBq9h+ifLZ+XKuyrOlj+aK8/ntXdUoTwNIhfInNvywbRgFbSZCf2QXUx4vnHjLH5qqzT6jfFPF44STvGxMr+LQtHoqzUT6FdgBZG1zNK6lGSqz0gXGKgGI2rJnR7efv6Jao2K/xZwPA==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CO1PR02MB8395.namprd02.prod.outlook.com (2603:10b6:303:153::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 17:13:37 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 17:13:37 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Waiman Long <longman@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v4] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Thread-Topic: [PATCH v4] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Thread-Index: AQHZk84EV3citzEVL0GtWO8rgnhVn690m8GAgAADGwA=
Date:   Wed, 31 May 2023 17:13:37 +0000
Message-ID: <ECE9A3B4-2CF3-452A-838A-99BE075D5E68@nutanix.com>
References: <20230531144128.73814-1-jon@nutanix.com>
 <9d37ab07-97c6-5245-6939-9c1090b4b3a9@redhat.com>
In-Reply-To: <9d37ab07-97c6-5245-6939-9c1090b4b3a9@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|CO1PR02MB8395:EE_
x-ms-office365-filtering-correlation-id: 119c869c-1768-4db6-b5bf-08db61fa5f65
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v532TLcWst15nG/xM6cjqwcBFTC18ShM8vFadAhMJbldQT9L2K2y8EexJ53FuvQyCZ105oXag1KAc1SiFMFpRzAbRpM+dp3I60gr9f+RvWU+wEElThRTXr6HoaRPniIByNf2pzgZJu8AW24+tFEBd8ga2vfWg36zYVIa69HNW18JaC0N06+/vgU0jvBPfrhkK//5NMfawQTDA3ugCsuXe7wKUavsP1I7Qz+SKGLhYOvXaB9mXX3aCeRCS1y+7BxxmjhSuKq/7UevUOt7kP/cC71u531K/xKnS7uhXPRDLZjpK0zZ83+8S+IUZ21OgB252qkwDjnx1NOarv/MVhp5bZCrnHOOmORF37lDLLf0r1GUjhWZ1uymMg1pbNnelX6yVvLjhJXbWFkrSCfToVIBeZm3d25AsXMY6gYKv9+DrOjIO07AKq0sSPJ3J6JdnRjha3Uvcy82kIl/S02ncI8AHV4t1PANm+5hq0quLkZdkzcKRI0yWhCgti8g078Wq13xHy/YBKlI3c/jOmpJSuL49vAERHsEl6zVzyCGVMoxizYIajUqMK+qhHogGAuVayLRLzkn5pny3ZDDzC8ZQIRBgvIsptsj1srNEXm7GHrvXB4fIn8yrKH1fteA69iMeG/2UnuoKzlx45Hg3x36vxKxekALSyna6JP78Ljopvu/gk4SIyEBRqrj8h2qyIvr9KNN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199021)(83380400001)(33656002)(36756003)(2616005)(53546011)(86362001)(6506007)(186003)(6512007)(316002)(38100700002)(41300700001)(6916009)(64756008)(4326008)(122000001)(66476007)(66446008)(76116006)(66556008)(66946007)(91956017)(8676002)(8936002)(966005)(71200400001)(6486002)(54906003)(478600001)(38070700005)(5660300002)(7416002)(2906002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QThWcnFPSytkSGlWbG9CUmRVYXJtYUp0blBmeHVoZGNsem1UYjdNSFp0Q1B2?=
 =?utf-8?B?MitXd2s3bU1pTEhVelhaRmpYQUt4U2wzNitHNElFa1k5bG9vRzhuR1hpVHpr?=
 =?utf-8?B?dHNuOEtUU3BBaW1vaVJtdGhnVEpURm9JNFU0TlFHNlIwTE1qeGhDcW03YWI1?=
 =?utf-8?B?bExmUFlJaHN6bGhtRk1mVlFtb1MzQW5lOGJkaEZSQWR5RnRYR3ZrUjU2RCtk?=
 =?utf-8?B?OWxhVFd0TjkrVTdyNmxoRUp5NWdoK1dYOWNXcWdDa2sxNUY2TUFxVFFwVzZh?=
 =?utf-8?B?OHFaOUdOQmoxM096a2VaTTlHSkRBTEZsWWJYVTZGUVV2NUZwRFhsM01BYWhr?=
 =?utf-8?B?ZmVaVVlqaWNEMDErTnRybnovVFczbi9LS0ZRMGVpeUxYLzJqc0tNRWZoRTJT?=
 =?utf-8?B?Y01iQ0taUytZbGZtR3AyL0VCNGxOYjNPVzkzN3dhWURJYXZra2dYazllcys3?=
 =?utf-8?B?dUE3V2pYbmxib05YV2t1bFhpc1pIMGlxYk12aDllWE5IQUsxRE5TZU9Xdis1?=
 =?utf-8?B?SHN3QnFQbE1mV0ZpVWYzRGREcFZSSnJrbkwwK0hycmlkZ0syS0UySEZ5NDk4?=
 =?utf-8?B?Vk1hajZjb054dW1Kci9PQTcrYzRJV0R5aW9YVkRnY3dPM2llMmJPM3FKV3VG?=
 =?utf-8?B?ZCt2MVZnL1BCY1Byb0tFQWJPRjdISjNXakRjZGw2UHRDazBCRVNXcHNhYXZn?=
 =?utf-8?B?Wm1pNWtYT3Y0UmpZalltbi9NcXFCNXF4Y2ZNblNESkNPMk8rcW5RdmV1REc3?=
 =?utf-8?B?Smw5aWJBc3NSaE1JZDlvYTJIa0xmaWhmRHg1bmo3S1dSN1hPc1F2U1ZoWUh5?=
 =?utf-8?B?UGRtbVVWbldNSnpjSjRPb0FnbWZOOTRQdVZsT1JXMzY3VDlxMGs5QjRPVGNW?=
 =?utf-8?B?eFZ0RUYxdkVWeWt5enkzck5sUkZjaVJjK0dEOHV3ZDQ4WmhkUWsxN2p0aW5J?=
 =?utf-8?B?L0lVMU00bDNzZis0TURQQmUyK3lhbmV3MEEvYWl3QlpaWEtLS3gvTDdBblRq?=
 =?utf-8?B?L1h5OEl5UG8rU0d3dDJIK2VXYmpMZFpVRjdwUTc2WVVZRGZ3M2xtRXNCNllZ?=
 =?utf-8?B?WjVrVENVWVg5YW0rVUFjUnRqRi9SQ2pIbHQ2K0s1WlAvMW44SU1QNjlyVHhX?=
 =?utf-8?B?WjBCRi9PMWFQZVFORTZYUXE4UTNUNWIxY00va2xoSlE3VUtKb3JIdnl4OFVi?=
 =?utf-8?B?cDF3R2VEeHBKRU5rNTBqUTcvL0dpcHlia0tIQlFyZzN5WmlJbmZUNE4wc2t5?=
 =?utf-8?B?Z2s1Z1dTMFlRUGgxT2Q5b1BheHdwbFIxYVpNL2t5OVBtakp4SWRWTXVMd1BJ?=
 =?utf-8?B?SjM4aUpmdjlFZEsvUXN4MUwwbCsyQzFEY1BBMytSa3BtYkFBR2VsVDVaUzNJ?=
 =?utf-8?B?WUtyT0prUG5EZGc1Nm9URUxGZnpYOVBhOWhzNm8vdGFkYjF6R3dCVGtiRU9O?=
 =?utf-8?B?VVdIRk12ZWRpQW4zams5eHZTS0ozaDEybWcwbVMrSHhHMElwVXhlNndCOFZx?=
 =?utf-8?B?QTk2UjFWQnBVOWlHNE1meWQ5TlUxRmdyTm9UZ3NTYndxVkpmWHNKOVhBWHJ2?=
 =?utf-8?B?dU4ybk1XVlNRMUVSRUpXTGc3dENXYTMzT2tzMklUdnFJcFhySisyWGlTZG9y?=
 =?utf-8?B?bFFBeVNYUUhKOWRGa0FEcVFzT3JFVWlnQ3p6Qis1S2ZMNmlLc2FCa3ZWU2RH?=
 =?utf-8?B?ckwvSEcraVRtN2c5RDZxWGRNZjVabE5JWkVIUGNyMjBHZzc3N1krSjVLOUp6?=
 =?utf-8?B?M0QxdE4rS2VRdXFTeXIvQWFuSVIwU2hyZlRWQm1uSW0yaWZ6aFdCaUNRcG8r?=
 =?utf-8?B?SlR5WFBwb2o0QlJyMXBMb1pwMzRpM3hIQU9oT1NKcmxaampYSGd0c2tyYks1?=
 =?utf-8?B?eTlpTHQrdjl5NndjeG9lYlRyYVhObW13SEs1RGVkTjRLbE1vNTk5NzY2Y3lD?=
 =?utf-8?B?NXc2ZG5pMGYwdnRlTURwUks5VWw4YllnYkVMajRIRGZCb1puS0FJVFVFaDZ0?=
 =?utf-8?B?ZFZnaWplOVhRZ2g3cEhXeVIyeTVQWWJRckgzUHM2ZFZtMGxOZGVaYkcvSzZy?=
 =?utf-8?B?Rm53VlZQckFJZGYyWVkzbEpvVEdtK1JUbjFBaGFMWWxpUkpuMjFCSXNpOVR2?=
 =?utf-8?B?VUI1WFQveEo0dURjQks5TUdjWVB5RTdFMUhiRWVHV2syMlVETGw1S1ZWenBE?=
 =?utf-8?B?WXpZN1gvNnBxQkUrbWhDclFUc2pTR1hjVW9Xek4zKzFLT2E5cWNwdDZrdldD?=
 =?utf-8?B?aUZlUVExRkQ2WlljRWt2bFVWMjdnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2772AB1180E0A341B838F49AFCDBC8A5@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 119c869c-1768-4db6-b5bf-08db61fa5f65
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 17:13:37.3002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nddHmEE3c0zhV4nCux0jL/OWceA5JaMclpG1EAa55pNxE9dUHwMq8NaZaJimuZA/sFY0kH/jvHVG5aRvTlIjgyhrjkrhbZjheXG0M4yHgfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8395
X-Proofpoint-GUID: fvlEifDoHMynUpL9h7-vK0WlnunhTmZK
X-Proofpoint-ORIG-GUID: fvlEifDoHMynUpL9h7-vK0WlnunhTmZK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_12,2023-05-31_03,2023-05-22_02
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

DQoNCj4gT24gTWF5IDMxLCAyMDIzLCBhdCAxOjAyIFBNLCBXYWltYW4gTG9uZyA8bG9uZ21hbkBy
ZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIDUvMzEvMjMgMTA6NDEsIEpvbiBLb2hsZXIgd3Jv
dGU6DQo+PiBBdm9pZCBleHBlbnNpdmUgcmRtc3Igb24gZXZlcnkgVk0gRXhpdCBmb3IgTVNSX0lB
MzJfU1BFQ19DVFJMIG9uDQo+PiBlSUJSUyBlbmFibGVkIHN5c3RlbXMgaWZmIHRoZSBndWVzdCBv
bmx5IHNldHMgSUEzMl9TUEVDX0NUUkxbMF0gKElCUlMpDQo+PiBhbmQgbm90IFsxXSAoU1RJQlAp
IG9yIFsyXSAoU1NCRCkgYnkgbm90IGRpc2FibGluZyBpbnRlcmNlcHRpb24gaW4NCj4+IHRoZSBN
U1IgYml0bWFwLiBOb3RlOiB0aGlzIGxvZ2ljIGlzIG9ubHkgZm9yIGVJQlJTLCBhcyBJbnRlbCdz
IGd1aWRhbmNlDQo+PiBoYXMgbG9uZyBiZWVuIHRoYXQgZUlCUlMgb25seSBuZWVkcyB0byBiZSBz
ZXQgb25jZSwgc28gbW9zdCBndWVzdHMgd2l0aA0KPj4gZUlCUlMgYXdhcmVuZXNzIHNob3VsZCBi
ZWhhdmUgbmljZWx5LiBXZSB3b3VsZCBub3Qgd2FudCB0byBhY2NpZGVudGFsbHkNCj4+IHJlZ3Jl
c3MgbWlzYmVoYXZpbmcgZ3Vlc3RzIG9uIHByZS1lSUJSUyBzeXN0ZW1zLCB3aG8gbWlnaHQgYmUg
c3BhbW1pbmcNCj4+IElCUlMgTVNSIHdpdGhvdXQgdGhlIGh5cGVydmlzb3IgYmVpbmcgYWJsZSB0
byBzZWUgaXQgdG9kYXkuDQo+PiANCj4+IGVJQlJTIGVuYWJsZWQgZ3Vlc3RzIHVzaW5nIGp1c3Qg
SUJSUyB3aWxsIG9ubHkgd3JpdGUgU1BFQ19DVFJMIE1TUg0KPj4gb25jZSBvciB0d2ljZSBwZXIg
dkNQVSBvbiBib290LCBzbyBpdCBpcyBmYXIgYmV0dGVyIHRvIHRha2UgdGhvc2UNCj4+IFZNIGV4
aXRzIG9uIGJvb3QgdGhhbiBoYXZpbmcgdG8gcmVhZCBhbmQgc2F2ZSB0aGlzIG1zciBvbiBldmVy
eQ0KPj4gc2luZ2xlIFZNIGV4aXQgZm9yZXZlci4gVGhpcyBvdXRjb21lIHdhcyBzdWdnZXN0ZWQg
b24gQW5kcmVhJ3MgY29tbWl0DQo+PiAyZjQ2OTkzZDgzZmYgKCJ4ODY6IGNoYW5nZSBkZWZhdWx0
IHRvIHNwZWNfc3RvcmVfYnlwYXNzX2Rpc2FibGU9cHJjdGwgc3BlY3RyZV92Ml91c2VyPXByY3Rs
IikNCj4+IGhvd2V2ZXIsIHNpbmNlIGludGVyY2VwdGlvbiBpcyBzdGlsbCB1bmlsYXRlcmFsbHkg
ZGlzYWJsZWQsIHRoZSByZG1zcg0KPj4gdGF4IGlzIHN0aWxsIHRoZXJlIGV2ZW4gYWZ0ZXIgdGhh
dCBjb21taXQuDQo+PiANCj4+IFRoaXMgaXMgYSBzaWduaWZpY2FudCB3aW4gZm9yIGVJQlJTIGVu
YWJsZWQgc3lzdGVtcyBhcyB0aGlzIHJkbXNyDQo+PiBhY2NvdW50cyBmb3Igcm91Z2hseSB+NTAl
IG9mIHRpbWUgZm9yIHZteF92Y3B1X3J1bigpIGFzIG9ic2VydmVkDQo+PiBieSBwZXJmIHRvcCBk
aXNhc3NlbWJseSwgYW5kIGlzIGluIHRoZSBjcml0aWNhbCBwYXRoIGZvciBhbGwNCj4+IFZNLUV4
aXRzLCBpbmNsdWRpbmcgZmFzdHBhdGggZXhpdHMuDQo+PiANCj4+IE9wcG9ydHVuaXN0aWNhbGx5
IHVwZGF0ZSBjb21tZW50cyBmb3IgYm90aCBNU1JfSUEzMl9TUEVDX0NUUkwgYW5kDQo+PiBNU1Jf
SUEzMl9QUkVEX0NNRCB0byBtYWtlIGl0IGNsZWFyIGhvdyBMMSB2cyBMMiBoYW5kbGluZyB3b3Jr
cy4NCj4+IA0KPj4gRml4ZXM6IDJmNDY5OTNkODNmZiAoIng4NjogY2hhbmdlIGRlZmF1bHQgdG8g
c3BlY19zdG9yZV9ieXBhc3NfZGlzYWJsZT1wcmN0bCBzcGVjdHJlX3YyX3VzZXI9cHJjdGwiKQ0K
Pj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KPj4gQ2M6IFNl
YW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPj4gQ2M6IEFuZHJlYSBBcmNh
bmdlbGkgPGFhcmNhbmdlQHJlZGhhdC5jb20+DQo+PiBDYzogS2VlcyBDb29rIDxrZWVzY29va0Bj
aHJvbWl1bS5vcmc+DQo+PiBDYzogSm9zaCBQb2ltYm9ldWYgPGpwb2ltYm9lQHJlZGhhdC5jb20+
DQo+PiBDYzogV2FpbWFuIExvbmcgPGxvbmdtYW5AcmVkaGF0LmNvbT4NCj4+IC0tLQ0KPj4gdjEN
Cj4+ICAtIGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0z
QV9fbG9yZS5rZXJuZWwub3JnX2FsbF8yMDIyMDUxMjE3NDQyNy4zNjA4LTJEMS0yRGpvbi00MG51
dGFuaXguY29tXyZkPUR3SUNhUSZjPXM4ODNHcFVDT0NoS09IaW9jWXRHY2cmcj1OR1BSR0dvMzdt
UWlTWGdIS201ckNRJm09UFQxUWpCOExrX2EzYmFET3dIQmZlZFFHNjdIc1ZEbU9kbWNXSGxyNVBy
VDhXeXVTOWU2UGZIRjVKeEx4RDB6dyZzPWpObmxvWlFnaDBLRy1uMzZ1d1ZDMGRKVG1va3Zxc1Fk
WVFDV1lJOGhWdk0mZT0gdjEgLT4gdjI6DQo+PiAgLSBodHRwczovL3VybGRlZmVuc2UucHJvb2Zw
b2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2xvcmUua2VybmVsLm9yZ19hbGxfMjAyMjA1MjAx
OTUzMDMuNTg2OTItMkQxLTJEam9uLTQwbnV0YW5peC5jb21fJmQ9RHdJQ2FRJmM9czg4M0dwVUNP
Q2hLT0hpb2NZdEdjZyZyPU5HUFJHR28zN21RaVNYZ0hLbTVyQ1EmbT1QVDFRakI4TGtfYTNiYURP
d0hCZmVkUUc2N0hzVkRtT2RtY1dIbHI1UHJUOFd5dVM5ZTZQZkhGNUp4THhEMHp3JnM9UndpNU5v
SHdhZXpsbXp6TGlHR0N1STZRSHVHUVoxQlZLMmhzNi1TWnZ6VSZlPSAgIC0gQWRkcmVzc2VkIGNv
bW1lbnRzIG9uIGFwcHJvYWNoIGZyb20gU2Vhbi4NCj4+IHYyIC0+IHYzOg0KPj4gIC0gaHR0cHM6
Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19sb3JlLmtlcm5l
bC5vcmdfa3ZtXzIwMjIwNTIwMjA0MTE1LjY3NTgwLTJEMS0yRGpvbi00MG51dGFuaXguY29tXyZk
PUR3SUNhUSZjPXM4ODNHcFVDT0NoS09IaW9jWXRHY2cmcj1OR1BSR0dvMzdtUWlTWGdIS201ckNR
Jm09UFQxUWpCOExrX2EzYmFET3dIQmZlZFFHNjdIc1ZEbU9kbWNXSGxyNVByVDhXeXVTOWU2UGZI
RjVKeEx4RDB6dyZzPVIyWWt4ZHYtRHllVkdMV2Q4X3BMcHU0M3pFc25XenB5dnZCUEVaOWx6LVkm
ZT0gICAtIEFkZHJlc3NlZCBjb21tZW50cyBvbiBhcHByb2FjaCBmcm9tIFNlYW4uDQo+PiB2MyAt
PiB2NDoNCj4+ICAtIEZpeGVkIGlubGluZSBjb2RlIGNvbW1lbnRzIGZyb20gU2Vhbi4NCj4+IA0K
Pj4gIGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCAzNSArKysrKysrKysrKysrKysrKysrKysrKyst
LS0tLS0tLS0tLQ0KPj4gIDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspLCAxMSBkZWxl
dGlvbnMoLSkNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9h
cmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+PiBpbmRleCA0NGZiNjE5ODAzYjguLjVlNjQzYWM4OTdi
YyAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4+ICsrKyBiL2FyY2gv
eDg2L2t2bS92bXgvdm14LmMNCj4+IEBAIC0yMjYwLDIwICsyMjYwLDMzIEBAIHN0YXRpYyBpbnQg
dm14X3NldF9tc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QgbXNyX2RhdGEgKm1zcl9p
bmZvKQ0KPj4gIAkJCXJldHVybiAxOw0KPj4gDQo+PiAgCQl2bXgtPnNwZWNfY3RybCA9IGRhdGE7
DQo+PiAtCQlpZiAoIWRhdGEpDQo+PiArDQo+PiArCQkvKg0KPj4gKwkJICogRGlzYWJsZSBpbnRl
cmNlcHRpb24gb24gdGhlIGZpcnN0IG5vbi16ZXJvIHdyaXRlLCBleGNlcHQgaWYNCj4+ICsJCSAq
IGVJQlJTIGlzIGFkdmVydGlzZWQgdG8gdGhlIGd1ZXN0IGFuZCB0aGUgZ3Vlc3QgaXMgZW5hYmxp
bmcNCj4+ICsJCSAqIF9vbmx5XyBJQlJTLiAgT24gZUlCUlMgc3lzdGVtcywga2VybmVscyB0eXBp
Y2FsbHkgc2V0IElCUlMNCj4+ICsJCSAqIG9uY2UgYXQgYm9vdCBhbmQgbmV2ZXIgdG91Y2ggaXQg
cG9zdC1ib290LiAgQWxsIG90aGVyIGJpdHMsDQo+PiArCQkgKiBhbmQgSUJSUyBvbiBub24tZUlC
UlMgc3lzdGVtcywgYXJlIG9mdGVuIHNldCBvbiBhIHBlci10YXNrDQo+PiArCQkgKiBiYXNpcywg
aS5lLiBjaGFuZ2UgZnJlcXVlbnRseSwgc28gdGhlIGJlbmVmaXQgb2YgYXZvaWRpbmcNCj4+ICsJ
CSAqIFZNLWV4aXRzIGR1cmluZyBndWVzdCBjb250ZXh0IHN3aXRjaGVzIG91dHdlaWdocyB0aGUg
Y29zdCBvZg0KPj4gKwkJICogUkRNU1Igb24gZXZlcnkgVk0tRXhpdCB0byBzYXZlIHRoZSBndWVz
dCdzIHZhbHVlLg0KPj4gKwkJICovDQo+PiArCQlpZiAoIWRhdGEgfHwNCj4+ICsJCSAgICAoZGF0
YSA9PSBTUEVDX0NUUkxfSUJSUyAmJg0KPj4gKwkJICAgICAodmNwdS0+YXJjaC5hcmNoX2NhcGFi
aWxpdGllcyAmIEFSQ0hfQ0FQX0lCUlNfQUxMKSkpDQo+PiAgCQkJYnJlYWs7DQo+PiANCj4+ICAJ
CS8qDQo+PiAtCQkgKiBGb3Igbm9uLW5lc3RlZDoNCj4+IC0JCSAqIFdoZW4gaXQncyB3cml0dGVu
ICh0byBub24temVybykgZm9yIHRoZSBmaXJzdCB0aW1lLCBwYXNzDQo+PiAtCQkgKiBpdCB0aHJv
dWdoLg0KPj4gLQkJICoNCj4+IC0JCSAqIEZvciBuZXN0ZWQ6DQo+PiAtCQkgKiBUaGUgaGFuZGxp
bmcgb2YgdGhlIE1TUiBiaXRtYXAgZm9yIEwyIGd1ZXN0cyBpcyBkb25lIGluDQo+PiAtCQkgKiBu
ZXN0ZWRfdm14X3ByZXBhcmVfbXNyX2JpdG1hcC4gV2Ugc2hvdWxkIG5vdCB0b3VjaCB0aGUNCj4+
IC0JCSAqIHZtY3MwMi5tc3JfYml0bWFwIGhlcmUgc2luY2UgaXQgZ2V0cyBjb21wbGV0ZWx5IG92
ZXJ3cml0dGVuDQo+PiAtCQkgKiBpbiB0aGUgbWVyZ2luZy4gV2UgdXBkYXRlIHRoZSB2bWNzMDEg
aGVyZSBmb3IgTDEgYXMgd2VsbA0KPj4gLQkJICogc2luY2UgaXQgd2lsbCBlbmQgdXAgdG91Y2hp
bmcgdGhlIE1TUiBhbnl3YXkgbm93Lg0KPj4gKwkJICogVXBkYXRlIHZtY3MwMS5tc3JfYml0bWFw
IGV2ZW4gaWYgTDIgaXMgYWN0aXZlLCBpLmUuIGRpc2FibGUNCj4+ICsJCSAqIGludGVyY2VwdGlv
biBmb3IgdGhlIHZDUFUgb24gdGhlIGZpcnN0IHdyaXRlIHJlZ2FyZGxlc3Mgb2YNCj4+ICsJCSAq
IHdoZXRoZXIgdGhlIFdSTVNSIGNhbWUgZnJvbSBMMSBvciBMMi4gIHZtY3MwMidzIGJpdG1hcCBp
cyBhDQo+PiArCQkgKiBjb21iaW5hdGlvbiBvZiB2bWNzMDEgYW5kIHZtY3MxMiBiaXRtYXBzLCBh
bmQgd2lsbCBiZQ0KPj4gKwkJICogcmVjb21wdXRlZCBieSBuZXN0ZWRfdm14X3ByZXBhcmVfbXNy
X2JpdG1hcCgpIG9uIHRoZSBuZXh0DQo+PiArCQkgKiBuZXN0ZWQgVk0tRW50ZXIuICBOb3RlLCB0
aGlzIGRvZXMgbWVhbiB0aGF0IGZ1dHVyZSBXUk1TUnMNCj4+ICsJCSAqIGZyb20gTDIgd2lsbCBi
ZSBpbnRlcmNlcHRlZCB1bnRpbCB0aGUgbmV4dCBuZXN0ZWQgVk0tRXhpdCBpZg0KPj4gKwkJICog
TDIgd2FzIHRoZSBmaXJzdCB0byB3cml0ZSwgYnV0IEwxIGV4cG9zaW5nIHRoZSBNU1IgdG8gTDIN
Cj4+ICsJCSAqIHdpdGhvdXQgZmlyc3Qgd3JpdGluZyBpdCBpcyB1bmxpa2VseSBhbmQgbm90IHdv
cnRoIHRoZQ0KPj4gKwkJICogZXh0cmEgYml0IG9mIGNvbXBsZXhpdHkuDQo+PiAgCQkgKi8NCj4+
ICAJCXZteF9kaXNhYmxlX2ludGVyY2VwdF9mb3JfbXNyKHZjcHUsDQo+PiAgCQkJCQkgICAgICBN
U1JfSUEzMl9TUEVDX0NUUkwsDQo+IA0KPiBJIGhhdmUgMiBjb21tZW50cy4NCj4gDQo+IDEpIEJl
c2lkZXMgdGhlIElCUlMsIFNUSUJQICYgU1NCRCBiaXRzLCB0aGUgU1BFQ19DVFJMIE1TUiBtYXkg
aGF2ZSB0aGUgUlJTQkFfRElTX1MgYml0IHNldCBpbiB0aGUgZnV0dXJlLiBJIGFtIG5vdCBhd2Fy
ZSBvZiBhbnkgY3VycmVudCBJbnRlbCBwcm9jZXNzb3JzIGhhdmluZyB0aGlzIGNhcGFiaWxpdHkg
eWV0LCBidXQgYSBmdXR1cmUgSW50ZWwgcHJvY2Vzc29yIG1heSBoYXZlIHRoaXMgYW5kIHRoZSBh
Ym92ZSBwYXRjaCB3aWxsIGhhdmUgdG8gYmUgbW9kaWZpZWQgYWNjb3JkaW5nbHkuIEl0IGxvb2tz
IGxpa2UgdGhhdCB0aGUgUlJTQkFfRElTX1MgYml0IHdpbGwgYmUgc2V0IG9uY2UuDQoNCkFncmVl
ZC4gT25jZSB0aGF0IGJlY29tZXMgcHViaWMgd2l0aCBmdXR1cmUgcHJvY2Vzc29ycywgdGhpcyBj
b2RlIGNhbiBiZSBmaXhlZCB1cCBpbiBhIGZhaXJseSB0cml2aWFsIG1hbm5lci4gSSBkb27igJl0
IGhhdmUgYW55IGFjY2VzcyB0byBzYWlkIGZ1dHVyZSBwcm9jZXNzb3JzLCBzbyBJ4oCZZCBsaWtl
IHRvIGtlZXAgaXQgYXMtaXMgdG9kYXkgcmF0aGVyIHRoYW4gcHJvamVjdCBpdCBvdXQgdG9vIGZh
ci4gSXMgdGhhdCBvaz8NCg0KPiANCj4gMikgQU1EIGhhcyB0aGVpciBvd24gQXV0b0lCUlMgY2Fw
YWJpbGl0eSBpbiBHZW5vYSB3aGljaCBpcyBzaW1pbGFyIHRvIGVJQlJTIGJ1dCBpcyBub3QgaWRl
bnRpZmllZCBieSB0aGUgQVJDSF9DQVBfSUJSU19BTEwgYml0LiBJbnN0ZWFkIGl0IGlzIGlkZW50
aWZpZWQgYnkgdGhlIEFVVE9JQlJTIGJpdCBpbiBNU1JfRUZFUi4gQXJlIHlvdSBwbGFubmluZyB0
byBzdXBwb3J0IHRoYXQ/DQoNClRoaXMgaXMgYSB2bXgtb25seSBvcHRpbWl6YXRpb24uIEFNRCBv
cHRpbWl6YXRpb25zIGNhbiBjZXJ0YWlubHkgYmUgcGlja2VkIHVwIHNlcGFyYXRlbHkgaWYgdGhl
eSBzdWZmZXIgZnJvbSBzYW1lIGludGVyY2VwdGlvbiB0eXBlIGlzc3VlIHRoYXQgaXMgY2FsbGVk
IG91dCBoZXJlLCBidXQgdGhhdCBpc27igJl0IHNvbWV0aGluZyBJ4oCZbSBsb29raW5nIGF0IHRo
aXMgdGltZS4gDQoNCj4gDQo+IENoZWVycywNCj4gTG9uZ21hbg0KDQo=
