Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312C8744AB5
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 19:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjGARSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 13:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjGARSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 13:18:38 -0400
Received: from DM4PR02CU002.outbound.protection.outlook.com (mail-centralusazon11013002.outbound.protection.outlook.com [52.101.64.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A8E9E
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 10:18:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SurTxzyuB6x9xciMYynpazkj+onSgHdKoFrzI7EkjcpmKEN6hRRP5uBvaz0bLKuNTIEopxVkSYlgw7g06MyE+4Pw84Re+Gsbm5ZcutJkk/NeE+1b2S+SbJMwUuRa8LL6rVLfOeFpVuEKwpPZ3CbnZAVxRST2FIPTHL+xzk/5Bz385aMd42JOsSDvS9q3gWstyIFiN+MBWXXwi8M5NU3+P7/9EOepiQtIkr77uxJXuRa3Idk5QFpT4qKOyCR7shDHBcs8phasXuo/Itxal9JL8v2jZouFur2ltsr30+L0dhR5S39AXkSvvBgOwbwLoEoiYQYLfSh78U5WKOP88zmYww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3w2RuqCs8psCJdkHTHwPX8lZx5/NhmhVE2KRjV960Y=;
 b=HobMXUyh52sov39lmaznOY5rrPhknEb4GGT0Xuz2sdMK912AMcZOuGQaXYoBlgpHy1emCNlWRXqJg1GtEytQUfmFWEjD6/yeW7yG+ad1e7CrP4GdOUVKPFwh6e1FIub49z6UhG/FOvgdPgY+QJ2hLbFU2xIN7OClL75nz9iLXVFYn/VbWquINFT3oAu0q9CcRNILwK5qYImqK9T8V9dCUr93JMXLZbVPogQkd7ILS622PJuv10YQ4OWEC/ZHT76YVxD1BnFIzmkcOADqv1SHVwBHOddFhSkFgm8JZd9quLGyYosTq5/Ycrx7Xtcovap7lGhAjHJ1gaK1xghmpBsIpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3w2RuqCs8psCJdkHTHwPX8lZx5/NhmhVE2KRjV960Y=;
 b=sANBYhjNT/0nsORzgnvCzl0doQXD1IVJPzF+eFB00aGoiUmgzaW+tS0HW9tQcC1QSBAWUu0R2/1s87Npct62nRfwS062lZI/PFpuEQ5W+qFvaHMRGxmTtCfrnrQORbtJCMcKIKUfW9PrLU331IPEeG4ykXGyP+AbD1wx1lWpHUg=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by BL0PR05MB6628.namprd05.prod.outlook.com (2603:10b6:208:92::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Sat, 1 Jul
 2023 17:18:26 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a%6]) with mapi id 15.20.6544.024; Sat, 1 Jul 2023
 17:18:25 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andrew Jones <andrew.jones@linux.dev>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/6] lib/stack: print base addresses on
 relocation setups
Thread-Topic: [kvm-unit-tests PATCH v3 2/6] lib/stack: print base addresses on
 relocation setups
Thread-Index: AQHZqVWELUuGLVOi5kCckOd0a/6tZK+kzViAgABgBgA=
Date:   Sat, 1 Jul 2023 17:18:25 +0000
Message-ID: <22AFB204-4D90-4322-8348-27DFB5E647B6@vmware.com>
References: <20230628001356.2706-1-namit@vmware.com>
 <20230628001356.2706-4-namit@vmware.com>
 <20230701-d9eb38f32bb8f376336d9443@orel>
In-Reply-To: <20230701-d9eb38f32bb8f376336d9443@orel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|BL0PR05MB6628:EE_
x-ms-office365-filtering-correlation-id: 1f0cc748-79bf-4881-7f3c-08db7a572df1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j5nibZL5o5Kg4kWvSrux4wN+UtRiuU49nf3nR8bCV2coT3vg2CF9dc+bBzSdmFfC5tPsNYAlwJRwWpKu+wPosZZpFssM51JiLvqUVArmBldU5yG2/0QqggHk6lTINd1JlqBx9ddEzaWFdcuGm+KcRPSXSi2HGgzb1srrFt/HuO+qs8Xr3XcwYJnZEXglge9ozr1Z691wPkFjYQATIeLuf7bbaC3xpdpKZnrrActJBmKv3mdyHL3yL2p2waaGkYEGoEoyp+pRBnnR4QLzGz/YU9Da7iV2Dlc0Y7M7W1OTe18g2Vt+3GbXSvDGG/HXS3kThdk6ca/ZWYN9d+3tXw8p2RfWkODruYKdDHIoLcCpjTsNOfgH+HkBzUCGXp7/ZOSWLSdq9ZM79mFYutlKYNp/C7HXq30eq3fU1FyItJLu2IQFZzlnfaJldRCxnSLQqJUOJ3sG8RrbywxoFoWjdastCm7eu7bzJ4N7oHt3pLK/cN3Vm9lRWPkQtGH93wRm+k7uXpkWnLlbtkT2mJa2g7TPJ7fFz4r/CknwknmldAF2FxmL40Zy5SLx66oaK5+uXoOA3CGiHiVyOBZ0YY/VRl91hNzOHFaNzlLrA1Jnd3/UNddq8Zp8/hVSjODKue4/WNGbvYhbM/DkFgYF8SeLY78km+eYCXFBoSBLxYHe6YOFSl356NFldOkOVA5MAMroM/BU0DQ67swauzAItudCzAKwAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39850400004)(366004)(396003)(376002)(136003)(451199021)(38070700005)(2616005)(2906002)(4744005)(122000001)(38100700002)(36756003)(8936002)(8676002)(5660300002)(86362001)(71200400001)(54906003)(6512007)(41300700001)(64756008)(6916009)(4326008)(76116006)(66946007)(66556008)(316002)(66446008)(66476007)(478600001)(6486002)(186003)(33656002)(53546011)(6506007)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bEtDZUt0VTNDSUNOVUR2cDJ0TFRpS0ZUeHE5djBDcVkwYktZditwU21ieWxp?=
 =?utf-8?B?RXFqbnNOY2VTam9SK1F6T2FHeXRqV1FJeURHd2ptelpZM0lFdGVJMW9FRk5B?=
 =?utf-8?B?UnhkdkpPK3pqS2FuNGFhWlk1L1A4VGlOSG9ZUjhLcGpWRXJrUm5qWitsZTVt?=
 =?utf-8?B?YUpMb3ZxL0FNdS9CaSsvMlhidHMwelpKZzVZWEpPcmFpcHV6c2k5b2lVZjlQ?=
 =?utf-8?B?Ykg5b0dKTDN5bTdDVDVCLzBmK0FHSFVsUnFLejZMdXE4djRuYjBubXBmR04x?=
 =?utf-8?B?UkxZMlVSUnJLZE1tYXErYUFXUXpmWHNhWENjUFRIdzF1WHBUbm5YOXJBZmZn?=
 =?utf-8?B?SUtyMWNhbDc2S2VGZ1J0T0ZrVGZRRGorWmZJUzlic3R2UHNPUzJPYVFXUzQr?=
 =?utf-8?B?cGhseGJYNmtvRVZTME9RQjJKSEVFVHQ5S1FuSHNpVjgxMzJlbEk0QUpFSjB0?=
 =?utf-8?B?QTJ1MnZWQ3BpYkJKODhHdWxKVHdZWWFTVzhUNUtsNzIxQUQvT3VpZVg4ZE1t?=
 =?utf-8?B?dDVsMWw0ZkxIblE5RHpjQUZ2VDZ1dUlMQ3RBWGVpRVRxSkx1UzN4ckRycWF6?=
 =?utf-8?B?U2hrSGRrRWtZR2g2R1ErTXZCeFc5N1hYOVpqRkYvRll4OEQ5T2dMSzFQS2Y1?=
 =?utf-8?B?V042ZmFwREQ4OTE4cmFoSWo4Sk1Qenp6MGVBR1dDU3IxdmU2L1RZRTFjRmw0?=
 =?utf-8?B?bndqS2cwR0NOV05zVkNZOGpkTVo3WTQ5RWZwZnVERk45S1VaR1pXcHorTEJG?=
 =?utf-8?B?MnpBdml0YWUvbStXTkJQZkFxOWhDVldqdUx4RDNoRVNCaDN1OFVVZFJicXBq?=
 =?utf-8?B?SjB1N2JTNEErbkhUK0dCMjJHWHdod2RpN0xVR2NhY1ltcjA1M2s3QUZHcHMw?=
 =?utf-8?B?NUZGa0NWa05YU29hejdqNUpERGltNTdwcmYzM0ZCTFVhbEpwZkUrbWc4akx4?=
 =?utf-8?B?SUJIMk55am5MT1FlajUvbUVDUUV2UllLVlFiSFdacEQzUVEzUUdhM2dFZndH?=
 =?utf-8?B?SEZpWnBoLzhPQ251a1RXWmFhaDgwdE5tZmdWY01MRUVlM25XSlpWRGswZFFa?=
 =?utf-8?B?VXU1VlgvdzFwVStobDJBZ05JR3cvYUVIYUNnOUpieWpPTUdobkVSajIzWjhT?=
 =?utf-8?B?Nk5valVJbjVrQ0ZhQVFnK0tyQklxdnk3OVlaMVlVWEp4dnVsSVpMeVI4dDBT?=
 =?utf-8?B?YVRJZzdwS3NqYjd5RSttRWtzeURlZnMrY1drTnZSb0FHbXZVWEdFSnM2TkZ0?=
 =?utf-8?B?QjJ6ZjVLVzYxbU13WStDMitqZDdKejNFOWZXMitPSWx4cXFldnNoeklqNjFY?=
 =?utf-8?B?b2p4YTlRdk1xTFB4eUU1aXBrdlZEaWp6dUticERSM3JVd2p5WkxtT1ltcEJh?=
 =?utf-8?B?blo3YUR2RlBwTG01TlJCSVV5Tk9YR21XN2ZQVWF5clN3QlBUWWpxZWRITTk0?=
 =?utf-8?B?TUV6K2IwbFlYZTdFSmVNMFNzd0NyMU9nQWFSOFpuQzVubkhDNmxhSU83NFpN?=
 =?utf-8?B?aVFwYW53c3J4ckNuNXhWTFNtWHhPd1RWWHpOVTZXUkhheGJzbkRFUDJMV2lu?=
 =?utf-8?B?cDJJQ285OXA2NllBdTFFWVZRSEVLdTYvQnBTVlpOTmtVSzRkRWhFejlYRG5U?=
 =?utf-8?B?b2lNZUl1aVNOWDY5RCtFRVdrcnIrbXZKeHg2eUY2VlZjMVhaMzRqbmZlVCtj?=
 =?utf-8?B?ZW1pRTRaUHJ2RkJ6dllFVEh6WWF6cVk1UmNQRjJlcEpOb2gyMlVpZXAwd2Ux?=
 =?utf-8?B?OGdmUXNUQjZ5UUZIZ202K1M0bTRubEJRd0ZKcEVQSGtOSEZIQzlaU3EvSzR3?=
 =?utf-8?B?ZkNkMDl5WXl5cFYycW1SOWRwOC9YOTZHdjJyUFVsc2lZTHhLczdBSnhNWS94?=
 =?utf-8?B?WWFSSmFkOEZ6MVpLbFJIYnJGZTFVMThNSDhtbzNlOHVrdThmSFc3dUprU3l3?=
 =?utf-8?B?TC9LTDhzNnk1ZnoyVnVHblF0aUNCNE9vaFdmVHB5bmo3Y293Y0xNSFkzUmZp?=
 =?utf-8?B?b2dsaWgxbWxrdGt0bzNZK2FTcHlxRTVJa0hvN3VnL0sxRXA2TnRZby9KYlNK?=
 =?utf-8?B?bUFJODk2OElKNUVaRjRNWTRQcHVTQUxNTlB6eS91b0ZKcmpzZDFTZVgyMTV3?=
 =?utf-8?Q?WFls1AasFp1+zU5AUQtHgCDQ4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E725BB24351124B8DE314315DF785E0@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0cc748-79bf-4881-7f3c-08db7a572df1
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2023 17:18:25.4543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JcuRZ2FuKaurWP03ci5lPUO5+YI2HaKziVuEQJw8C1NmHc3Fkgo5fGl1201w3N81o8CgDMJdaVk7zJp+Mach7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB6628
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVsIDEsIDIwMjMsIGF0IDQ6MzQgQU0sIEFuZHJldyBKb25lcyA8YW5kcmV3Lmpv
bmVzQGxpbnV4LmRldj4gd3JvdGU6DQo+IA0KPiAhISBFeHRlcm5hbCBFbWFpbA0KPiANCj4gT24g
V2VkLCBKdW4gMjgsIDIwMjMgYXQgMTI6MTM6NTFBTSArMDAwMCwgTmFkYXYgQW1pdCB3cm90ZToN
Cj4gLi4uDQo+PiBkaWZmIC0tZ2l0IGEvcG93ZXJwYy9NYWtlZmlsZS5jb21tb24gYi9wb3dlcnBj
L01ha2VmaWxlLmNvbW1vbg0KPj4gaW5kZXggOGNlMDAzNC4uYzJlOTc2ZSAxMDA2NDQNCj4+IC0t
LSBhL3Bvd2VycGMvTWFrZWZpbGUuY29tbW9uDQo+PiArKysgYi9wb3dlcnBjL01ha2VmaWxlLmNv
bW1vbg0KPj4gQEAgLTI0LDYgKzI0LDcgQEAgQ0ZMQUdTICs9IC1mZnJlZXN0YW5kaW5nDQo+PiBD
RkxBR1MgKz0gLU8yIC1tc29mdC1mbG9hdCAtbW5vLWFsdGl2ZWMgJChtYWJpX25vX2FsdGl2ZWMp
DQo+PiBDRkxBR1MgKz0gLUkgJChTUkNESVIpL2xpYiAtSSAkKFNSQ0RJUikvbGliL2xpYmZkdCAt
SSBsaWINCj4+IENGTEFHUyArPSAtV2EsLW1yZWduYW1lcw0KPj4gK0NGTEFHUyArPSAtRENPTkZJ
R19SRUxPQw0KPj4gDQo+IA0KPiBJIGRyb3BwZWQgdGhpcyBjaGFuZ2UuIHBvd2VycGMgZG9lc24n
dCBkZWZpbmUgX3RleHQgYW5kIF9ldGV4dC4NCj4gSSdsbCBsZWF2ZSBpdCB0byB0aGUgcHBjIHBl
b3BsZSB0byBkZWNpZGUgaWYgdGhleSB3YW50IHRoaXMgYW5kDQo+IHdhbnQgdG8gYWRkIF90ZXh0
IGFuZCBfZXRleHQgdG8gZ2V0IGl0Lg0KDQpUaGFua3MgZm9yIHRha2luZyBjYXJlIG9mIGl0LiBT
b3JyeSBmb3Igbm90IG5vdGljaW5nLiBJIGFtIGFsd2F5cw0Kbm90IGluY2xpbmVkIHRvIGNoYW5n
ZSBhcmNo4oCZcyB0aGF0IEkgZG9u4oCZdCB1c2Uu
