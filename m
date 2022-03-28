Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8274C4E8B55
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 02:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbiC1A5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 20:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiC1A5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 20:57:17 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE078FD3C;
        Sun, 27 Mar 2022 17:55:37 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22R8v3o9011100;
        Sun, 27 Mar 2022 17:53:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=AtNqP8M3yv7CZxM0IBBaLfFEnIyJT4TQeHYnONhpAC8=;
 b=o0VcDf+rmaAF+wVP88mQlIG0qUJysF1voCWBNIP9zU8SJ1jQC3Upt6wZ9HX894F2T5mX
 s65km9T93r8y2N3z8yqh/s9lA32w2SA3MhhGjAOvwaY8jThKleCkIynpH4RhjipsNRK8
 VsMETmwj1gNAPQbxfm9NeARz0qZQgsf5j7aFmAtmhbVMrBG39Uy/DC7ZGaTIITGW5tE7
 jFLH0Aj/pbRx9/iCanWQBPAogmcGFSB/5nMtj+DeS0TIPMnuMs2bHGn+iG1Z5C4V6UGM
 3DBIWIVLpUO7qPj38ezelS7Knvvbeu+XH4wq8Gtrv/8Z1zKZh2SwaYlDmeqUj288T6HE aw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3f22c0a5e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 17:53:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbuCAK0Pa957UlervRJ/QdftzG8ElKO13Yyd64p34ZGW2HIq4QXKAmoPFs6q+9jrChvlOFozuCCnBrb/8vcWB6o8JsPzzmVgHKsFPaD0eo2cxEeMpSS1Qw6UzjstPjbctFGqhdEGRbUYibAK5zK+cRaHqkQurrIF1s5zY23xuS7Mc/EHchd8h+pYj7hAnLfZ54FkxIjfReddJ1YFiS34tBO9WBy9RbtjBMxzelA8vrcXJn3vj65iHlxgHLmS1MvzMPvdF5VwiIxJn6JC/tyqnHyW25DxXgOIqjBOboIMx/aCHMnffDzbJyS0ZDFUPZA9m8xnIlSn1tzBpm+l1WJINA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtNqP8M3yv7CZxM0IBBaLfFEnIyJT4TQeHYnONhpAC8=;
 b=D66z5eMgcVg5IqZOAh+51maH3hW08Z8a/4DIeoKhSZ7exnyyczfOH9OmYZyovsyzxf/RUKhCYx1rQCg+mKMl71XfZUQwvk+mwHXnEU5atVkJBNwqqBV9podTVM7Wdl17Uhco4YcXiLSlW0/GchlJG84y8u/5dmAzHuFhXfRIL5LLv+JC/dCCHkDeE+whiQcuX+snnpt/zNUfc6ZxX7usbL95bkp9mot8+ch4rMr7Kh43kvTDGgkb3ReB3ka1AG0Q4sXbvsNftDJyTxkegmZ9b/HHSuVpD8v7wo2pc+6CbwTTtahORybHvjcNqemxRsNaO4RBpCeOAwmL3JfzzMWx6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BN7PR02MB3907.namprd02.prod.outlook.com (2603:10b6:406:f3::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Mon, 28 Mar
 2022 00:53:18 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf%4]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 00:53:18 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Jon Kohler <jon@nutanix.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: optimize PKU branching in
 kvm_load_{guest|host}_xsave_state
Thread-Topic: [PATCH] KVM: x86: optimize PKU branching in
 kvm_load_{guest|host}_xsave_state
Thread-Index: AQHYPxhn3Sr6qShuh02J8mIqjF/gfqzQzueAgAAW5YCAAisJAIAA7WaA
Date:   Mon, 28 Mar 2022 00:53:18 +0000
Message-ID: <1E31F2B6-96BF-42E0-AD41-3C512D98D74B@nutanix.com>
References: <20220324004439.6709-1-jon@nutanix.com>
 <Yj5bCw0q5n4ZgSuU@google.com>
 <387E8E8B-81B9-40FF-8D52-76821599B7E4@nutanix.com>
 <e8488e5c-7372-fc6e-daee-56633028854a@redhat.com>
In-Reply-To: <e8488e5c-7372-fc6e-daee-56633028854a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d36799e9-3641-421e-7729-08da10555960
x-ms-traffictypediagnostic: BN7PR02MB3907:EE_
x-microsoft-antispam-prvs: <BN7PR02MB3907B1F1DD078B39FC17AA31AF1D9@BN7PR02MB3907.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X6ldQF+BTL+sXajOI7nlFKX3vk+9p0OGRLvDxgG77LxI1l9pPXDBCAVXJ0Qgip/WOAT+sI8r/emmiQ87ze2yVVFe/vS9iXVs3OjGeSSn+RFa/wz+3GRf/ILxgOs3u0FfWLYfa71kQoylvKE7TAB+qYQTf/zkV7fis+az8LhWbeOak8epuMFdgUWuuHU05enMW26ifaNzRKv4poniQ9tZmBwx3jBSRBizI8z1HF82B2xFe2brPHzghpbJXuY0NhlEnLkNwsCL+bnq6fZsYmyXJQzhywLb5DfNmYr87DdA8OZyxitvMUtyTRMt6RCObh1FqmE4yFXJnPztG3VYP/3wgLw27+6lkutaDvzRTTMSnPD1hI3lxKBQpMRdJKxSn/5lOjp0wOHzPMVm9sIasutMlnZzS/qRalNguqFpM879Bnyv5QoJExWifg62BNw+hyOmFuOzIxuH2CDnFaG55BEjEptmngo9iJwb4hDeKiT7amBTFTZ2h2DCQW5adjg2aBPlR4mWb9PHHe5BpX1iz+L070YmGTxGc2gRK2oj/O/qw4YItaQeysoIk2TVn0TG78+UdGxjoFbn1Wm181WlQcphVAwR8ObPsJ0L0a4aYNAL+kGRhtP5Gmc9VzaJvb4JZ8if9stn/cTiPek1EgSsT7JQvkWrPyPL9MA4RG5WRa/3sXvy7wjhXcW1+qvwA7/HY0VX0qkSPGThiPoJZgWi6Z6KOl1t06KCRYxxq6s3FpDeDg0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(66476007)(66446008)(8676002)(86362001)(66946007)(66556008)(7416002)(5660300002)(54906003)(6512007)(2906002)(83380400001)(122000001)(91956017)(508600001)(64756008)(36756003)(76116006)(33656002)(8936002)(71200400001)(53546011)(38100700002)(2616005)(4326008)(186003)(316002)(6916009)(6506007)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTFkNHJFYW5mOEErdys4Ym5MQTlHWkVaZ3FMcXdjeXUrS3B5S3EwTDVrK3RG?=
 =?utf-8?B?M3FzRmNyY2NIbDBoV2h1N21HNVIyUElsZ3VvUXR6cTFhTW1uNU1oTE9jdjZR?=
 =?utf-8?B?Vkp4MkhscStRR01XU2tSaDVqbC93dDBxZUNYdUNXYXZXeHJqTnJZeWl2cld6?=
 =?utf-8?B?WndkUWhNRHF2b0hHWXkwempIdXc0RFd0UjZ3eWFZYklPd2VabllJRWsrODNs?=
 =?utf-8?B?empKNjhDL2ptdGd6enhXMlNTd1RXbEhaaXJGWTkwVXUydkIrT05Ca3FYd2hE?=
 =?utf-8?B?RFRnVEFWbG1ybTdxeDZ2eXp1aUlqM2tSYmlDVlBlY3lxeXM1MytidndLdHYy?=
 =?utf-8?B?bGhLL2EyQkRhY09NcEMySHJCWmppemVJYXVOTTF5cnI0OTFMK016M01sTVRZ?=
 =?utf-8?B?YXdYbWpISE5DUHI3T0V1cy9VR0k5Y29GNkgycktyeEt5UHlDd0trd1hzcUpY?=
 =?utf-8?B?VmJLSTJNcWx2aXlVUWN5QXRLZHUvRnRwdy9NUlpZUmFwNGVCenNQNFhjTWMy?=
 =?utf-8?B?enpzUUR5YU82RVNlTlJPcG0wd29OMGdGWG1vTkxJQnVVdy9KQlJRZDVUbFhO?=
 =?utf-8?B?aXY1R0ErYTVIM0tMbzVFVDhXYnFGUzFYRDJITGRBZU92aVY0ekNlZUlLdEJz?=
 =?utf-8?B?a09NemM3RG9XR2h2NlJqMlJKeWJwcnkrMDc5KzhzQitWOEwyYVY3L0xzUDg5?=
 =?utf-8?B?bUwvTGxzSjlzNlpteitmci9uRUk2cnZlUkJXQm4va3IzeFdKK2orMjc2M2JJ?=
 =?utf-8?B?bGd3YXpuTUkvSGlEaDdQWkxxSmJ2cVJROFg1LzdMWEFGdXkyMExmR20zb1Zt?=
 =?utf-8?B?ZFVubi8yT3h4OEpTVnFpdXdDZ1NrRGJrN1FhQ1dXUjdKWVVKQ3lOR0JlYU04?=
 =?utf-8?B?NkNZTFZtdlVEWE1VTGd3RTUvZlVXRlU1S0xuVXpPRWxod1Y0Ly9EVnROa1Bz?=
 =?utf-8?B?SDJDMEhIRytVekNNSXVkMis0bHZ5Yy8wWS9vMGJ5c0hUcXlsc0lMTXhETkY1?=
 =?utf-8?B?ZXF3Z052N3o3U0hrKzR3eXZSNlpPam9SajhJTTV3bWtNQ3VJKzFwMUxoYkxz?=
 =?utf-8?B?TzJCbk1MeEtJYVVEWnNIZ3ZLajFjYTZ3NGFyNlVQZ3YrWGM2bWJ0TjNQTUEx?=
 =?utf-8?B?S0lORHQ2VEhpMWdiZERJa0JJZnNVcnVuNEV4bFFxbk83T29abTZscVZOWnRh?=
 =?utf-8?B?NXlDSjRBdzVBUHlZdnpZVHdzRUxyZExocVlrZ2JkTzBCZ2x1TWwxMUVIVk5D?=
 =?utf-8?B?bUo2T0NvQUhERjZ5cVRaMUxFZFZWT2VTM2ROK1ZlQjgyRll2ckhzQkFrVGIy?=
 =?utf-8?B?SWt6RFNmanRrRFJzbStCSjBoWGRjNFNVZitTZTBJc2x4YTJ3RGVJeEZaUjRP?=
 =?utf-8?B?N2lWVEJOYUcwWld2dmx0TlFsT1Nhc01va1MvVjV0M3ZsbjZaZVZmV0s0WnA3?=
 =?utf-8?B?VExvV250aUd1Vm8zUWJ2ckNWclFyN2xMS0FJV01HeTBGOTRMc25FaHJFZDlW?=
 =?utf-8?B?Tk5MRXBaVENlSWEzMkxjck9KMlk2SFRiVHlxZU1rRitMUGI2VSttYTNWSUVO?=
 =?utf-8?B?RFE2Ny9ham9xZ0wra0ZSRXo5d0dtaUs2aFpQL1MrenVMemhvWFZZazh3T1V0?=
 =?utf-8?B?TlBhSi9CenE1WVp4S3B1TDh1anN3TlJ5d2NjNXhZQk1HTi9hTlNIR0N3MUxw?=
 =?utf-8?B?UEZpc0c5b3lpelYyeWQxQzNyOEhybXBVYVg2b20rU1llWWRJYWJ2WlFNaFJH?=
 =?utf-8?B?VkR2MlRNempiRHJNNkFsdVNjTi9hbys3dlJ4a3pWaG5ES3dWMms3VHpJVG9J?=
 =?utf-8?B?cXlTa1p3QlNsazBGRnpPcFY2TUFkUlJBVjJHTGNscUMwUXEySVpGdW01bWt4?=
 =?utf-8?B?NHI5bkw3ZGVBZVNNRjVXMDdiek5wUWdyMWh1Q1J5L2QzVGYyRHdsZlJDVXpr?=
 =?utf-8?B?eXRJRFVmcFdEZ3E5Q0ZmWi9Vdm5uVGZ1WWxCWWl4b3VDK0pXR0hLMDlqZTR6?=
 =?utf-8?B?QTRteW1qVisrVkgzWkRSckNwUTB5c1RRZzgremlLU0xTL21sdElpcVp6VHlT?=
 =?utf-8?B?NFlqeXBmK3ZrMGJ5STl0VzY3L0ZHNWw0cWNkc3Vab2dUU3ZEUE5BT1hZbEVQ?=
 =?utf-8?B?dmlENFhkWTA3SUdPb3hJK2dwOW5ZVUNKNXkvWEdaMnkwelFnVWU0NzBMVmhX?=
 =?utf-8?B?QW9UZWJCTFZhd1laODJXbVE5SEQ2M3oyWVZSVXMrcURuTkZoVThMbm1rT3pX?=
 =?utf-8?B?VDdPOHRCTkQvamxxTzFzdHpUWEd2T2N4RDNGWkxiZml4aGNzUVM5V3VXeE5m?=
 =?utf-8?B?QTJhZWg5WFlicVJjaGpjZS9pZG1qOFY5UVRWTjBTRW84OVA2M0NvUXBJQXpp?=
 =?utf-8?Q?LT7Iu1is4+1/SsLgvvVQ7aJjhgtSaTvylGI+Qly8m5uh/?=
x-ms-exchange-antispam-messagedata-1: GncxHJeCtWH5JILxB4v3ckzGJq/gOjI+KxU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0E9D4E90067CB49AAD0A1C170DE1F13@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d36799e9-3641-421e-7729-08da10555960
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 00:53:18.3636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NoXtWbdGfJY2c9Q8NuPVNnEkfzB9hcfZYmxmbmyR7v2ZnGwVnMflot++FWaz5ei89JCyDWZ+jFlTxiYjpfLMq3GxF9dGFg1WX/hMj8morTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB3907
X-Proofpoint-GUID: LcEofahgj5r_5RoUTBO5vD6VIlPmFq7k
X-Proofpoint-ORIG-GUID: LcEofahgj5r_5RoUTBO5vD6VIlPmFq7k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-27_09,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWFyIDI3LCAyMDIyLCBhdCA2OjQzIEFNLCBQYW9sbyBCb256aW5pIDxwYm9uemlu
aUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIDMvMjYvMjIgMDI6MzcsIEpvbiBLb2hsZXIg
d3JvdGU6DQo+Pj4+ICAgIEZsaXAgdGhlIG9yZGVyaW5nIG9mIHRoZSB8fCBjb25kaXRpb24gc28g
dGhhdCBYRkVBVFVSRV9NQVNLX1BLUlUgaXMNCj4+Pj4gICAgY2hlY2tlZCBmaXJzdCwgd2hpY2gg
d2hlbiBpbnN0cnVtZW50ZWQgaW4gb3VyIGVudmlyb25tZW50IGFwcGVhcmVkDQo+Pj4+ICAgIHRv
IGJlIGFsd2F5cyB0cnVlIGFuZCBsZXNzIG92ZXJhbGwgd29yayB0aGFuIGt2bV9yZWFkX2NyNF9i
aXRzLg0KPj4+IA0KPj4+IElmIGl0J3MgYWx3YXlzIHRydWUsIHRoZW4gaXQgc2hvdWxkIGJlIGNo
ZWNrZWQgbGFzdCwgbm90IGZpcnN0LiAgQW5kIGlmDQo+PiBTZWFuIHRoYW5rcyBmb3IgdGhlIHJl
dmlldy4gVGhpcyB3b3VsZCBiZSBhIGxlZnQgaGFuZGVkIHx8IHNob3J0IGNpcmN1aXQsIHNvDQo+
PiB3b3VsZG7igJl0IHdlIHdhbnQgYWx3YXlzIHRydWUgdG8gYmUgZmlyc3Q/DQo+IA0KPiBZZXMu
DQoNCkFjaywgdGhhbmtzLg0KDQo+IA0KPj4+IE5vdCB0aGF0IGl0IHJlYWxseSBtYXR0ZXJzLCBz
aW5jZSBzdGF0aWNfY3B1X2hhcygpIHdpbGwgcGF0Y2ggb3V0IGFsbCB0aGUgYnJhbmNoZXMsDQo+
Pj4gYW5kIGluIHByYWN0aWNlIHdobyBjYXJlcyBhYm91dCBhIEpNUCBvciBOT1Aocyk/ICBCdXQu
Li4NCj4+IFRoZSByZWFzb24gSeKAmXZlIGJlZW4gcHVyc3VpbmcgdGhpcyBpcyB0aGF0IHRoZSBn
dWVzdCtob3N0IHhzYXZlIGFkZHMgdXAgdG8NCj4+IGEgYml0IG92ZXIgfjElIGFzIG1lYXN1cmVk
IGJ5IHBlcmYgdG9wIGluIGFuIGV4aXQgaGVhdnkgd29ya2xvYWQuIFRoaXMgaXMNCj4+IHRoZSBm
aXJzdCBpbiBhIGZldyBwYXRjaCB3ZeKAmXZlIGRydW1tZWQgdXAgdG8gdG8gZ2V0IGl0IGJhY2sg
dG93YXJkcyB6ZXJvLg0KPj4gSeKAmWxsIHNlbmQgdGhlIHJlc3Qgb3V0IG5leHQgd2Vlay4NCj4g
DQo+IENhbiB5b3UgYWRkIGEgdGVzdGNhc2UgdG8geDg2L3ZtZXhpdC5jIGluIGt2bS11bml0LXRl
c3RzLCB0b28/DQoNClN1cmUsIEnigJlsbCBjaGVjayB0aGF0IG91dCBhbmQgc2VlIHdoYXQgSSBj
YW4gZG8uIA0KDQpIZXJl4oCZcyBhIHByZXZpZXcgb2YgdGhlIGxhcmdlciBpc3N1ZTogIHdl4oCZ
cmUgc2VlaW5nIGEgcmVncmVzc2lvbiBvbiBTS1gvQ0xYDQpob3N0cyB3aGVuIHN1cHBvcnRpbmcg
bGl2ZSBtaWdyYXRpb24gZnJvbSB0aGVzZSBvbGRlciBob3N0cyB0byBJQ1ggaG9zdHMNCmluIHRo
ZSBzYW1lIGxvZ2ljYWwgY29tcHV0ZSBjbHVzdGVyLiBPdXIgY29udHJvbCBwbGFuZSBhdXRvbWF0
aWNhbGx5IG1hc2tzDQpmZWF0dXJlcyB0byB0aGUgbG93ZXN0IGNvbW1vbiBkZW5vbWluYXRvci4g
SW4gc3VjaCBjYXNlcywgTVBYIGlzIG1hc2tlZA0KYXdheSBmcm9tIHRoZSBndWVzdHMgb24gdGhl
IG9sZGVyIHN5c3RlbXMsIGNhdXNpbmcgdGhlIHhzYXZlIHN0YXRlIHRoYXQNCnRoZSBndWVzdHMg
c2VlcyB0byBiZSBkaWZmZXJlbnQgdGhhbiB0aGUgaG9zdC4gV2hlbiB0aGF0IGhhcHBlbnMsIG9u
IGVhY2gNCmxvYWQgZ3Vlc3Qgb3IgbG9hZCBob3N0IHN0YXRlLCB3ZSBzcGVuZCBxdWl0ZSBhIGJp
dCBhbW91bnQgb2YgdGltZSBvbg0KeHNldGJ2LiBUaGlzIGhhcHBlbnMgYW55IHRpbWUgdGhlIGhv
c3QgYW5kIGd1ZXN0IGRvbuKAmXQgbWF0Y2guIFRoaXMgaXMNCkV2ZW4gbW9yZSBleHBlbnNpdmUg
d2hlbiB0aGUgZ3Vlc3Qgc2VlcyBQS1UsIGFzIHdlIHNwZW5kIHRpbWUgb24NCnhzZXRidiBmb3Ig
TVBYIG5vdCBtYXRjaGluZyBhbmQgc3BlbmQgdGltZSBvbiBhbGwgdGhlIHJkcGtydS93cnBrcnUg
c3R1ZmYuDQoNClR1cm5zIG91dCwgdGhlIHhzYXZlIGJyaW5ndXAgY29kZSBvbmx5IGNoZWNrcyBy
dW5uaW5nIGZlYXR1cmVzLCBhcyB3ZQ0Kc2VlIHRoZSBzYW1lIGJlaGF2aW9yIGlmIHdlIGNvbXBp
bGUgb3V0IFBLVSB0b28sIHNvIHRoZSBwYXRjaGVzIHdl4oCZdmUNCmNyZWF0ZWQgYWRkIGEga25v
YiBmb3IgTVBYIGluIGRpc2FibGVkLWZlYXR1cmVzIGFuZCBhZGQgdGhlIGFiaWxpdHkgZm9yIA0K
dGhhdCBlYXJseSBjb2RlIHRvIHJlc3BlY3QgdGhlIGRpc2FibGVkIGZlYXR1cmVzIG1hc2suIFRo
YXQgd2F5IGl0cyBlYXN5DQp0byBtYWtlIHRoZSBob3N0IGFuZCBndWVzdCBtYXRjaCB3aXRob3V0
IGRvaW5nIEJJT1MgbGV2ZWwgdGhpbmdzLiANCg0KSW4gYmV0d2VlbiB0aG9zZSBwYXRjaGVzIGFu
ZCB0aGlzIG9uZSwgdGhlc2UgdHdvIGNvZGUgcGF0aHMgYXJlIHByZXR0eQ0KY2hlYXAgbm93LiBJ
4oCZbGwgbWFrZSBzdXJlIHRvIGNvcHkgdGhlIGxpc3Qgd2hlbiB0aG9zZSBwYXRjaGVzIGdvIG91
dCwgYW5kDQpoYXZlIGEgZGV0YWlsZWQgY292ZXIgbGV0dGVyIGZvciB0aGUgaXNzdWUuDQoNCj4g
DQo+IFRoYW5rcywNCj4gDQo+IFBhb2xvDQo+IA0KDQo=
