Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367C45897FB
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 09:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbiHDHAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 03:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238670AbiHDG7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 02:59:55 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDF761B28
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 23:59:53 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2740t6XC011247;
        Wed, 3 Aug 2022 23:59:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=OshWilqwg6mXDFmbboQ8xtjkk3vD0OL3volY4zheFQU=;
 b=johDD4vhCYOBKdB5IbYgPT1qW9AFUt0l95rZvxc6MgAWKqr8k/X2XzcuGGkwqEQtpk82
 0ThcYxTp5XwyXcFE8REJV+1ozGZKI+0xokEVmQzfqU8LQQD/B4aAjWEoZvCjKAqPVzaJ
 QT1lHPUU2ZGejAMlLTdH7iTddqpwfFnSNZpCut+IcR6WFHSn9QqX4ytJArf93keq6cPo
 7AP3TZbL7y8Y7/7Iq9nNmWcCIOppQ3bqLj/oRZEMOLhS2VLsGICG4bjin/Rt++U2PUsY
 0q1KbAaiUSdsbyhOARtDfmRd0ST5vmIgShHKbnGi2bTtNDHhfB0p7ZSjWH701euDieW2 zw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3hn4613hxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 23:59:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtxMCCrUG1rD85IuKW57HEShFruogOl+ng7FSTkGF1TXGAPyW6O62/FzRjore5kLZ0m5eKIJ5TnXPad6qACo3FcyDJG3Epc7oQbyLXWFIK4G4IWwEKLaDEYdWdQ/2+PYqFF72D/pjMnzUFUR86fZX+24j4xM93dZFFyOaYGKp4STm7iztWeMBaL4tJMKJw0Kldjw5/z2ZReSkHmSlOypx5JnyoZ720ASNNgIjdrFoJDzpOIGmUc83HRssEc9SlivxgxbRqPpGiWBeethoC6k/XSct3gxQ0GGnATrvSnf5LaGsZwCgZAvCvhmg7HhSSSFRnPPz5+rkRCuPezMRs1fDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OshWilqwg6mXDFmbboQ8xtjkk3vD0OL3volY4zheFQU=;
 b=Jj1Vss1eQ9SeOYdCNTxZfxNcIXcoZwaRammbMn71gf6uWYAGp+F5qGm8EnwGeZNiuxwgZ6syYE3OPhzHV5qKfQ7UFtn/Mlfk0gCfygW6VKbhlsDUFd/08cmgxfSRgErQoaCe8VH6mTqTd9l1RRd5L2jNFQGmKsx5gaBrUpEW30CjMs1N/mc7MmxNeOEzikVpccO1b23HlFM/qMzcTlnZG/5BwwAHxSNikpIOfujWvamD5w+aKZoH9ezfygj2UOfyIJdG00srLZXvlyC/pDP0EMVlzA58sNk6gFu1/9dZHATPQrwSPMZysAOBPA8ukcSkt/J/mXxuddrtrOeTZH3a8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by PH0PR02MB7717.namprd02.prod.outlook.com (2603:10b6:510:58::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 06:59:42 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::75ec:a5f:965d:b7cd]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::75ec:a5f:965d:b7cd%5]) with mapi id 15.20.5504.015; Thu, 4 Aug 2022
 06:59:42 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>
Subject: Re: PING: [PATCH] KVM: HWPoison: Fix memory address&size during remap
Thread-Topic: PING: [PATCH] KVM: HWPoison: Fix memory address&size during
 remap
Thread-Index: AQHYVIOHWS5LNxGEWEOaxAb7LYqksq0PhlCAgI9wMIA=
Date:   Thu, 4 Aug 2022 06:59:42 +0000
Message-ID: <713249DB-CCBE-402D-96CE-447250FFDA42@nutanix.com>
References: <20220420064542.423508-1-pizhenwei@bytedance.com>
 <527342ea-ad25-6f66-169d-912a6d75ae54@bytedance.com>
In-Reply-To: <527342ea-ad25-6f66-169d-912a6d75ae54@bytedance.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a624b42-cd0e-4761-639e-08da75e6e7f9
x-ms-traffictypediagnostic: PH0PR02MB7717:EE_
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PggjQhKKYsjPq7pWQNHOyU2vqmY7bCL7ObEU738qtRWpUFMI2E9YRAtyXjwGcqIW3UfRTHIolONU6nQv4kA5loq7r154kjCjX8FvucruEjXJ5YfuW7KAPXYK4fml0Z26vAnjopp3DkcroItKyMrj8sdKzBh23UbllD9WdzpcJNyWCM6I9pwR1cQI4xwa5TL0WN5JJoT79t6a6D+JoAXpWLHBMKbHD1hO1xOkQygCX3SrSFhvpL4RL8NUWmQqlS8Llj6BxTcYxcCeoMWppAf+aP/5teSNu1cygPprIbXvcQSrh76JMRLCReibmDhqAskQGW8XoOLXE3rJTfB2HVBQCjUsx7CBNDVJP0cVZy7e/CBZitkIeZ7OH32fLqQImoiiqEoLKPq90uDEWcMYZZY+BIf7zzI6oTRSRO/bO+bZtTiWwMoYBx3WTFG6occdzdY7iQYUtyMcb1EmQe+M1mlQcYJemmCX9KMYBK/CkPTNNcV0LJNYOirBNPe5fN0uvCwKYBtpwkepNW3XRP9lQlC7C2wyWNjMi1ozJLhr179T4EgXJ33/Ngg137XE77uIIvjP7ol0xlBiHU7ie+ic7LDqTceWbiadMhIKkSPaa6TjdKooW9SPSAKCDIgbq6CM1GWFvOUkodeQviw6roww8JlAiykXcCSm3ceUfbjYDaQkyERhvG1jCYYE6QM/ifwV1IhwjzLDsZ4QUC8n3PirZGDzxJCW7ot4J0yy2wMJxYEJbCRGMO7pjnXehb5PQK4yfFfZAwHwksneQlHdAnRhqVeMy8r6trCq8XLGZaFB/AaeNNy2OdObeYIjoRGCxJ5rCzBLUhcQy4dhxGtMsrcBblcEmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(376002)(366004)(39860400002)(136003)(54906003)(2616005)(36756003)(122000001)(6916009)(86362001)(38100700002)(316002)(26005)(38070700005)(66946007)(76116006)(6512007)(64756008)(66556008)(8676002)(66446008)(66476007)(4326008)(91956017)(186003)(33656002)(5660300002)(44832011)(6486002)(71200400001)(478600001)(53546011)(8936002)(83380400001)(41300700001)(2906002)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUhaWkxKVWFzUjh1KzF3N3pqRkkzUzlBaFExQm5OQnEwYllPY2gzVlRHZ3FH?=
 =?utf-8?B?Q0lETkZic3FHOEZoZnBCNmxmWlI1NGl5clhEbG1IVUQwVWhXM0VEak42TnBr?=
 =?utf-8?B?RTY3Zm4ySXAveWg4UjJUMHk4dFBBdTBpN1l5NmFpaG96MkpkSGE1aU12TUZx?=
 =?utf-8?B?eWlIYTMrNzFlc3ZWdmNONmpEbm9oWTdkUGZaV2dJWWpWdDFhblVrUFd1TS9Z?=
 =?utf-8?B?QmphbnlRUVhkeXBRMWVlaUg5YWlSWHFhQWxrSWxKR1dIaGpPT1oweE9oWFox?=
 =?utf-8?B?ejd0WHlyNnppN3RzRUp6WUxIZGhkMFQzNXlYa292UG1SYnhRUHNPbklEOENZ?=
 =?utf-8?B?b3FFY3B5QXZXelFFTGJsRU00WVVTcnBLb3NMTzd5QW53RlVEZUpZeHlEWEdC?=
 =?utf-8?B?M1NJKzBhZElYZjFHdGE3VEhENVBnUTdMemlyMU9JSGMzVmxVQ1hhZ2pmR0FV?=
 =?utf-8?B?WG1kUDhEd0VkMFpWNVBDZUU1d2hudXM2ZUJsLzRUWmhibzMwN3lHZ1VxRkNt?=
 =?utf-8?B?ZVV1OExmWDA1UjdQakFXdGZyaWRHZ1hEamJCMXF5U0VhWFNjaExMV3A5Vi81?=
 =?utf-8?B?dGpCZzEyeWE1OGt5aXpOZWJ3MlBzNFBXQXJSMDl6ak1XSmMwdW5qdmhKcjZG?=
 =?utf-8?B?UWJEeWQwVURsRzBaTmh2UDdtRHZvVElmNVYwTmY4Ymd2ajVodGpDd0hRSUtF?=
 =?utf-8?B?djRDVjNpVWV5ZU5kS0dwT0FKTG5XODJsVDA5b1RZMGExd0tseldtb1UvV256?=
 =?utf-8?B?MEY0ZGRwR0Y5eWRFSGdkMHl1Wkl1bjJsYmJPa0IyR1hCUTNwVTJaV3VVTGtU?=
 =?utf-8?B?aWIwZ0t0Z0tnZjVRRlFGaEI1a2V2OGxCdVRpejRzeUo1c1dLZ1hwZzUwaXRP?=
 =?utf-8?B?YUNjbFJnWFNjM042RUpiaEtDT1VOaU5iWERqVmIvaXhBMnpnSlozUzhsSEQ4?=
 =?utf-8?B?REtuTktSa2haK2RlRlpYV3g2c05kWVZndnhXZVBDanY1bHFRRFVoNE5uSkRE?=
 =?utf-8?B?SVk4dkRNa1BqalFrMG5wYk13QzdSVW9GaDZ5TmZzM09ET0oxM0hQd3RtU0hw?=
 =?utf-8?B?S2xkeXBGVzc1Y2lDYnFtSXk4Nkk4YlhMc1BiS0ZDZDZkM2RWUTR4NHJ5SDVh?=
 =?utf-8?B?WGRtVkJNaEt3aG4rb0RIUDdGeWIrUmp6YTVRMDN0aktyMEVUeHg5MHNmRFI0?=
 =?utf-8?B?ZmcvSDJwRkFLK3dBaHR3SHVRK0c3WjRNS1ZTNGd4dDBGeWV1RVpXUjRlUmVC?=
 =?utf-8?B?a3hQRzc5MFhReDhERmkwL2xyZGVSWFZzTXFwT3VTcG9yZjRsVkpzdnFkd0th?=
 =?utf-8?B?UE5VTlJWK21tTGhPNTBFUFpyRUg3SHZKTlVBSXZucnpwaGsrL2lLK0NGNXpp?=
 =?utf-8?B?L1E5UVNib2RacEhBNXNrK1RHZGtRZ0FJTm5NVkV4b2F2MU44ZjJZbXljRXdv?=
 =?utf-8?B?S2dWRXFVM2phNHFFOS9sME1TVnFhSUxGSlVOemloTjF6b0ZHUjhKQlVjcjFh?=
 =?utf-8?B?RVdoeGVMUUk2V3ZoUHZ1OTF5YjFMZmJ0WHpvZ0RyRXRjdXVkTjE3azVvbzdN?=
 =?utf-8?B?bis3MW03Z25ia3ZrS2owOUw5TWk4NElxR3NhSWdDbE04NHZlRTZRcURydEha?=
 =?utf-8?B?OU5qeFlXVURHc1QzR0NoZXAxakVSc2JEWVBYSVF4NVd6K1J3Y2tObE5CRnl2?=
 =?utf-8?B?ZjIrVWNZRW14V2lyK0VaTkFYL1RFU2lBSjRXeTNEWlJkVnBwV2p3VUdwdkQ3?=
 =?utf-8?B?SjRCbm5IQWV0d3VlTlJ3L1REQ2VmbTFXc3h1UmFRUGRHcUhvZTVPekh4bU1D?=
 =?utf-8?B?TTBYbnQxem1NcklkS2NxUnNDdU5ZdEF2bGZGdDlieHVtTGo5YnhwbXJHeEZP?=
 =?utf-8?B?NlUyVVNZMnpyZDhiSlBpOVVBMWlReUZvRzlKdVY2M0JyRmxENThDNkpqa2hX?=
 =?utf-8?B?eWgyT2pLdzN3Q0xJTnl6WFQ5Z0toaXBUVFZxRFhING5LTWh6dXpCWkErVmph?=
 =?utf-8?B?bFlncmJPRFFpcmpjcGlFU21ybStVc2FyWSt3eXZlRlJoVk9VKzdKbzBLZUEz?=
 =?utf-8?B?WTdGYUJCQTZHVG9ja29LRkFlZWlXY09IRVpjRnFsTFNPYk42UnZ0TUNyNXlE?=
 =?utf-8?B?S1FxWCtLMkwvRVRrUTE4bmkyVXBSNjl4czhIdGh3dVBmbm5ZdVZIcWlxUTE0?=
 =?utf-8?B?M1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAE926E248E5ED49BF172E66826F338D@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a624b42-cd0e-4761-639e-08da75e6e7f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 06:59:42.0686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oTV/Bc0N3Rf7kKhVW4I7etVc3+f0uMJVeoP/jEGf40wZCtga31sjHF2beu3BEO3b0ymYjYxItEommcZx+zEJFUW2Zme8ATgaoiRZKegD5CI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7717
X-Proofpoint-GUID: BteBM0tmoU8QmZ02BzY5A4BUyb6_mmsB
X-Proofpoint-ORIG-GUID: BteBM0tmoU8QmZ02BzY5A4BUyb6_mmsB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_01,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgDQoNCldl4oCZdmUgYWxzbyBoaXQgdGhpcyBjYXNlLg0KDQo+IE9uIE1heSA1LCAyMDIyLCBh
dCA5OjMyLCB6aGVud2VpIHBpIDxwaXpoZW53ZWlAYnl0ZWRhbmNlLmNvbT4gd3JvdGU6DQo+IA0K
PiBIaSwgUGFvbG8NCj4gDQo+IEkgd291bGQgYXBwcmVjaWF0ZSBpdCBpZiB5b3UgY291bGQgcmV2
aWV3IHBhdGNoLg0KPiANCj4gT24gNC8yMC8yMiAxNDo0NSwgemhlbndlaSBwaSB3cm90ZToNCj4+
IHFlbXUgZXhpdHMgZHVyaW5nIHJlc2V0IHdpdGggbG9nOg0KPj4gcWVtdS1zeXN0ZW0teDg2XzY0
OiBDb3VsZCBub3QgcmVtYXAgYWRkcjogMTAwMEAyMjAwMTAwMA0KPj4gQ3VycmVudGx5LCBhZnRl
ciBNQ0Ugb24gUkFNIG9mIGEgZ3Vlc3QsIHFlbXUgcmVjb3JkcyBhIHJhbV9hZGRyIG9ubHksDQo+
PiByZW1hcHMgdGhpcyBhZGRyZXNzIHdpdGggYSBmaXhlZCBzaXplKFRBUkdFVF9QQUdFX1NJWkUp
IGR1cmluZyByZXNldC4NCj4+IEluIHRoZSBodWdldGxiZnMgc2NlbmFyaW8sIG1tYXAoYWRkci4u
LikgbmVlZHMgcGFnZV9zaXplIGFsaWduZWQNCj4+IGFkZHJlc3MgYW5kIGNvcnJlY3Qgc2l6ZS4g
VW5hbGlnbmVkIGFkZHJlc3MgbGVhZHMgbW1hcCB0byBmYWlsLg0KDQpBcyBmYXIgYXMgSSBjaGVj
a2VkLCBTSUdCVVMgc2VudCBmcm9tIG1lbW9yeV9mYWlsdXJlKCkgZHVlIHRvIFBSX01DRV9LSUxM
X0VBUkxZIGhhcyBhbGlnbmVkIGFkZHJlc3MNCmluIHNpZ2luZm8uIEJ1dCBTSUdCVVMgc2VudCBm
cm9tIGt2bV9tbXVfcGFnZV9mYXVsdCgpIGhhcyB1bmFsaWduZWQgYWRkcmVzcy4gVGhpcyBoYXBw
ZW5zIG9ubHkgd2hlbiBHdWVzdCB0b3VjaGVzDQpwb2lzb25lZCBwYWdlcyBiZWZvcmUgdGhleSBn
ZXQgcmVtYXBwZWQuIFRoaXMgaXMgbm90IGEgdXN1YWwgY2FzZSBidXQgaXQgY2FuIHNvbWV0aW1l
cyBoYXBwZW4uDQoNCkZZSTogY2FsbCBwYXRoDQogICAgICAgQ1BVIDEvS1ZNLTMyODkxNSAgWzAw
NV0gZC4uMS4gNzExNzY1LjgwNTkxMDogc2lnbmFsX2dlbmVyYXRlOiBzaWc9NyBlcnJubz0wIGNv
ZGU9NCBjb21tPUNQVSAxL0tWTSBwaWQ9MzI4OTE1IGdycD0wIHJlcz0wDQogICAgICAgQ1BVIDEv
S1ZNLTMyODkxNSAgWzAwNV0gZC4uMS4gNzExNzY1LjgwNTkxNTogPHN0YWNrIHRyYWNlPg0KID0+
IHRyYWNlX2V2ZW50X3Jhd19ldmVudF9zaWduYWxfZ2VuZXJhdGUNCiA9PiBfX3NlbmRfc2lnbmFs
DQogPT4gZG9fc2VuZF9zaWdfaW5mbw0KID0+IHNlbmRfc2lnX21jZWVycg0KID0+IGhhbmRsZV9h
Ym5vcm1hbF9wZm4NCiA9PiBkaXJlY3RfcGFnZV9mYXVsdA0KID0+IGt2bV9tbXVfcGFnZV9mYXVs
dA0KID0+IGt2bV9hcmNoX3ZjcHVfaW9jdGxfcnVuDQogPT4ga3ZtX3ZjcHVfaW9jdGwNCiA9PiBf
X3g2NF9zeXNfaW9jdGwNCiA9PiBkb19zeXNjYWxsXzY0DQoNCg0KSW4gYWRkaXRpb24sIGFsaWdu
aW5nIGxlbmd0aCBzdXBwcmVzc2VzIHRoZSBmb2xsb3dpbmcgbWFkdmlzZSBlcnJvciBtZXNzYWdl
IGluIHFlbXVfcmFtX3NldHVwX2R1bXAoKToNCg0KICBxZW11X21hZHZpc2U6IEludmFsaWQgYXJn
dW1lbnQNCiAgbWFkdmlzZSBkb2Vzbid0IHN1cHBvcnQgTUFEVl9ET05URFVNUCwgYnV0IGR1bXBf
Z3Vlc3RfY29yZT1vZmYgc3BlY2lmaWVkDQoNCg0KVGhhbmtzDQoNCkVpaWNoaQ==
