Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E140555889C
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 21:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiFWTXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 15:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiFWTWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 15:22:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C035377043
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:29:44 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25NHup2Y016263
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:29:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : cc : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fqEc+ATFxdUylCCuEj0rETWEKR7pBTQIHllcdaO0vNI=;
 b=ItdPkNhSYVjG38HwEcRR8+cEim74ANFd51fkZ0fj8c6hdQQewNK2Ckwes+2Mh1mfA9so
 4dNQW4b8Q44iJ5MmabvkdxBxccOpe+W6FMuicBkdMDnYB9W5xsLo5ZYPNohDlg+KblYD
 JPNPO759WXhFFVbd9EeyyIPelTM9kxF6Nxs= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by m0001303.ppops.net (PPS) with ESMTPS id 3gvqwxjfue-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:29:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxaRnRWy+RzVvnoUINAJsG5XmyJJ6ITG3eC4WDy6oob4PKIvruroIF5Q9ASXh7nEU5KvS57eAKK3SAuDSeb4ZCyVhYLb7De37iEjEn3FMB+QwtvcC3POhkda9SZYzhCAXDk0gac82AUJU9HfbT35NJndq/kbuRe1YmxKaaBvXw0dC3+9l9dTTniYHYSQ9rP/lQHp7ZD5ON6pzReUI9Cslf+k0/rr6ZosIUfne/iftgkodLw1BCQ8A6q9C5sgy68GUVzF6skYEIK+Db0OY3UYVDtpuVylHb0tScnMH1DRS/OMiXgNs00OOpneEqUNRvwdHNQbsk/bsFOlXTs1xpFNDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqEc+ATFxdUylCCuEj0rETWEKR7pBTQIHllcdaO0vNI=;
 b=neKnLxtdE7Yqv5fcR6CWqvY+CyPh4Dz/sJIj8oMd/yAJ0Wx68c7gM+Yccv5gLsUvDiBdX2F3hVmM20pppncw/G06zpZcOU/C7sNkqcxAiy0dApGrVqCEGJ3vzqvc+NOyZmwVmwdFm1I70fCpNEi+rQRvDTT85TjkWe9Sh/51yU3QzmLO1qwTjrXkScEZiLFF8W8mXW3uxtRHsoz2KyHMmEPKpauI60TW6VSpAEtoyDMOiin3Zc0NpRjig/1icfhIUTQ53IwydwIu0DX+PrANOb3eWuqsIraCjugK1oJ75uh9pDL502rGQ/yVtWFqVHRaSLcLxkhLricy62jL+vn0zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB3032.namprd15.prod.outlook.com (2603:10b6:a03:ff::11)
 by BN6PR15MB1236.namprd15.prod.outlook.com (2603:10b6:404:e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 18:29:41 +0000
Received: from BYAPR15MB3032.namprd15.prod.outlook.com
 ([fe80::70d0:8133:42cc:f134]) by BYAPR15MB3032.namprd15.prod.outlook.com
 ([fe80::70d0:8133:42cc:f134%6]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 18:29:41 +0000
From:   Peter Delevoryas <pdel@fb.com>
CC:     Peter Delevoryas <pdel@fb.com>,
        =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@kaod.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "eduardo@habkost.net" <eduardo@habkost.net>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        "ani@anisinha.ca" <ani@anisinha.ca>,
        Cameron Esfahani via <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 04/14] sysbus: Add sysbus_mmio_map_in
Thread-Topic: [PATCH 04/14] sysbus: Add sysbus_mmio_map_in
Thread-Index: AQHYhu/tx3ghfCqXU0G9TvPcb9gJIK1c5/iAgABoj4A=
Date:   Thu, 23 Jun 2022 18:29:41 +0000
Message-ID: <01540BC0-096F-4054-8BC5-DBA978276D79@fb.com>
References: <20220623102617.2164175-1-pdel@fb.com>
 <20220623102617.2164175-5-pdel@fb.com>
 <CAFEAcA9zmmaUth+9k82+ZrhAMOmsmttq2HOKs+DVNx0L1dx6=w@mail.gmail.com>
In-Reply-To: <CAFEAcA9zmmaUth+9k82+ZrhAMOmsmttq2HOKs+DVNx0L1dx6=w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aca006d0-67dd-468f-5d89-08da5546569b
x-ms-traffictypediagnostic: BN6PR15MB1236:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pq58RarMvJYgtQwWsze8wkHH0NF0go1+ukd6BAGpshw/BW0VGZRsE64bO7kyR2gWDvNdqfZcw8ysv/7obCJrAA6DxxBT/FtaGLX7uvAoUekL4wLpq24vOlHfwuU9SDZyP1wlvVTpPC6nRvMm9gzU/9MW2DA0Idm2LzyuNxZGZVvLaQ9QVXlsLlu3L9hawomRcweioHafJl1ci32D03EUfQ2Kza5QD4Hzp8j5eZRwoQl6wgiiMZkiyCgh2zfzpLNUQ4wTGyO/tMBDRvq2il9f/TP54FoZXVfRLWtVdKlTAIuuSrraAKyu5kMOrWWKd2Jag9lQe4OtOUWcWyH0tNiJXGgd2Rkv7WoUTchPboLZdFiYHQOW7eA21XPfeiZppXl2zVllSud6wSPAJcbP1H0iHwHtcUmaIRnUqk8yJ6PqE60IuBiV6OtbIE0wMR6unLKRp668PpYUgJfttvVQhHZ4BMXhP3JkB8LDXs7wgCGWSyQPFlk0MKi28HcPsQ8fek10JGafH+cjpSLO/kHBgcg/LNTgKHRxELGS8cMEjQSL3F/2Sn3WkfL2fd8rcGy8fUiZccL7bZnd7I9x1XjadK5Zakck2Wi5iaukHv727KWynOL61YuqiwK2cMREmo7LR6r8+mIafFW7LqHs16Ogd55gkY/c0Nr7nGl5QFilMl57pLKMfZ3A3HWdh0Bo+G9p1Vw7cK+Wi1ZK5ggXZYagl1ng7P4SOYDjcOoK+1eSjCgkubyyJ0uv4smDc0pUqfBhkIhbTLSjcYDeGCetlvmNXyd3XYbcAA9DtCIkMsc7Mo60QkAWkcAsr87ZlQFFFvihpMcfYO39Erx6hwcEflpExqTezA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB3032.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(316002)(41300700001)(54906003)(6486002)(478600001)(36756003)(66556008)(53546011)(71200400001)(76116006)(6512007)(66476007)(7416002)(8936002)(64756008)(66446008)(4326008)(33656002)(66946007)(2906002)(2616005)(8676002)(186003)(5660300002)(6506007)(86362001)(38070700005)(109986005)(38100700002)(122000001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXJ4SHhxYU1lQlVaMElXUDhxcCtHdnphQll5MUNJenIxTlJBZVNhTGV1NHNY?=
 =?utf-8?B?TUpmclJlRGRCanVsTmxMMWVaNXp0VzYvbVZCY005ZUVhUUlJY0lvK0hDeThT?=
 =?utf-8?B?ajBsVmJwNGN3dWdyRGJ0cE56UUkyYno2Mi91czE5UUtWNFpiaDgwaHdnY1dG?=
 =?utf-8?B?MHZZdVZQbXNXbnNPeUdtTUdidUY1eDMvdFJ2TEtRUzg5VHJVY2tUTit4RHZt?=
 =?utf-8?B?MVc3U0xTbEdBSGJCU285bTdQcXRJWnhJRjRTTHBJNmRvcGp2QnlBb2xTdEtl?=
 =?utf-8?B?SkVLdjh3Nm5zSnoxNW1RQWcyS0Y5NmxDcXc3TzVhQyswc2R5YXhxQ1pUODUy?=
 =?utf-8?B?WTE4d2pkTjFVdWVvNzBWMmp2bmRHSDNnOWRYWnRMbE14ckg4K0pEclROU21t?=
 =?utf-8?B?VGV6ZGJoSU1BdmpzOEphbEFpOGd2SStuaW5haElUWWQ0NTJaRStkU1V2alAy?=
 =?utf-8?B?SFlzQnJPaE9zQU96MGdOUWFuZGxkUzFqMFFCcis2dDBwN2RXQ0g4RVk4ajBM?=
 =?utf-8?B?Qm5Bb1k3aGVvQkdrUlh2cGxVUWhnZFdVcDFlbzJEZndCOTJBMzlmb294Yzdh?=
 =?utf-8?B?cXpEOWc0UE04T2JTUkNnbWM5Q1YyUjF2Q2d5eTRjQmR4bzFvMlZmelZINk91?=
 =?utf-8?B?eWtGcDNYNGxkMHk4VFhGUCtoenRya0IxTHZPbHlLY2FlTFZLN0pIM0tCRUxC?=
 =?utf-8?B?SVVRUHJDclh1OERlbFUwZjhoK0hiWVBnWC80NDlPMVpObDVhV0Noam81eXVT?=
 =?utf-8?B?aGN0ekJGeVRtdlFEYjNTYUgvaGhTMHVHUk9JUWVGSXZReUJ2VndGSkZEbzF1?=
 =?utf-8?B?ZjNWTVVpQnY1YXd0TkZxTnVwUmp5STY2ZGtGQSs1Ymc5eGdPRkhZY0lTVzJY?=
 =?utf-8?B?QllGdFA0OERlTGhGNktVZytKaDBVaU9WZUptOXdiMkxrZ3VDZUNWMVZkZUJu?=
 =?utf-8?B?NnIreWdoQTYwSEdKeVIyaUJoem5mNXJHRDlEUGllZXJ5UFRMRTlBMjIxUUha?=
 =?utf-8?B?N2RwZ3FXdE02SEFqc25ncUdXL1hyeGJyWDBQaVRzUWRaeDk0MDhTQ3FGbzRw?=
 =?utf-8?B?VlpPcEpPdXd6SXZsaEloWW9XZHdvczVpeEJHTU5ZcHA4TXlWRXdtam5aRDA4?=
 =?utf-8?B?V0NDdUxXaG4vRWQzVEdMT1ZLNnl3cTZ1ZHdoV0xGSmRQNG0vYkVFS2ZIQnZD?=
 =?utf-8?B?U1YxRkRBNk5raXg1YUZpZUtoRXVQSkYxVk9MWEVGbDNsZGZEMU1ZWjVnakhu?=
 =?utf-8?B?MitzbzJ0WEVVbUJYK3owOUpESmtlcjZSN1RPZFBaS05CNkhQejBnZmh6bWxa?=
 =?utf-8?B?cG9QMHBmbjg0QkVIakpMYzdEcW9nTnp6bnp3aVA2V2ttRkd0d3lCeHF6RE1W?=
 =?utf-8?B?Y1E1cXlZeFNkTCticE9FbzE1bXRKOGRNUEE2WEhlcDl1UmloQ1RremVMSnhv?=
 =?utf-8?B?Rzkrb29mTzRsNENjbUYvQnBvZHYzSVRDVTU5enk3dDZHd1VoNCtCbHlpWHZQ?=
 =?utf-8?B?Z0hHNEFCL0drZERiWVFKMk1jUGJzRnpqaVNRODJSbEs5TFk5b25aTCszRXJv?=
 =?utf-8?B?cFVHUDUwY1NOeVJzQ1R4QmNEUGY2VkVIQ0dMOEJUS2dFQWh0Y2FjbFRIeCt2?=
 =?utf-8?B?amE4emVxVkpPUllPNkhkSkJuUlRXV3ZTcHNjUEtOb25MRy9uTzZBNDM5ZWJh?=
 =?utf-8?B?ODlQTXRkNWpONTVvVk52aFAwR0ZaUSt5SWxUNGpiY25NWWkyMklOcU4rdmN1?=
 =?utf-8?B?eVVvd3pFcFdmSnMxSUo3QkJka0NpNHpidVJSQy9TSEMrZlJ5bnhyZkQreHhX?=
 =?utf-8?B?RjJ1MjBGa3RyVml1bXVaNUx3ZnhrMmZ2eEU1UEthT3pKZ0plNzJsQ21CK2Zu?=
 =?utf-8?B?YzhsRjU1cllrWkpWZkZzcExKWmJoaStUZWwxTG5rUUlWU2IydWtmVjBjZG8x?=
 =?utf-8?B?b3lkT3VGL05vam5GTTcwOTFyRnZuMlEyWWtpbUQ2cE5JaDJoaUNNcTBXMEh1?=
 =?utf-8?B?dVVCRlViN3RrUUd1cnVaWXp0Vnc5OGtCMHdjWEJpVktTMDVCaU9aSnVVVElv?=
 =?utf-8?B?dWpGdUYrNkpldDlYOGhicnQyeFpsY1F4RXJ0SlQ5dG9LYk1wbjEzRThYdkxa?=
 =?utf-8?B?U2YwczRnOXVrUWVjSCtIbEpGT1psUVZjQlExemFOQVVqekREa2t5Wmh6clZP?=
 =?utf-8?B?ejh4SWtYaDZYWEorckMrcG85Ujd3YWNkdGp1OXdhUjAvVS80S0l1TVdxK0lO?=
 =?utf-8?B?bE1ucm50L0NHdDdHOFd6Y2ozell2Y2ZPMHZEMGxwNHBuMmtNOWtjWEV1ekJT?=
 =?utf-8?B?UlZhWDNwYnI2RCt1c3ZwUE1odkFUUW9FZUJkRXNBbi9STGJ2TkNscmw1NDl6?=
 =?utf-8?Q?6gFlYsDnGOCtWXa8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69B51ABF18F6EA41B28151D5B4E0C5CD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB3032.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca006d0-67dd-468f-5d89-08da5546569b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 18:29:41.4972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o1WdiF3Nm2V0Sb5R11Bm8EuwNVOnM2o9YVgLUyLQvEzvQFr724FqGJxwz4ljkqSL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1236
X-Proofpoint-ORIG-GUID: 4_Mrr9CdKnM4Ax3PDCd8h-LnKiALXuWU
X-Proofpoint-GUID: 4_Mrr9CdKnM4Ax3PDCd8h-LnKiALXuWU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_07,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVuIDIzLCAyMDIyLCBhdCA1OjE1IEFNLCBQZXRlciBNYXlkZWxsIDxwZXRlci5t
YXlkZWxsQGxpbmFyby5vcmc+IHdyb3RlOg0KPiANCj4gT24gVGh1LCAyMyBKdW4gMjAyMiBhdCAx
MTo1NiwgUGV0ZXIgRGVsZXZvcnlhcyA8cGRlbEBmYi5jb20+IHdyb3RlOg0KPj4gDQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBQZXRlciBEZWxldm9yeWFzIDxwZGVsQGZiLmNvbT4NCj4+IC0tLQ0KPj4gaHcv
Y29yZS9zeXNidXMuYyAgICB8IDYgKysrKysrDQo+PiBpbmNsdWRlL2h3L3N5c2J1cy5oIHwgMiAr
Kw0KPj4gMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCj4+IA0KPj4gZGlmZiAtLWdp
dCBhL2h3L2NvcmUvc3lzYnVzLmMgYi9ody9jb3JlL3N5c2J1cy5jDQo+PiBpbmRleCBjYjRkNmJh
ZTlkLi43YjYzZWMzZmVkIDEwMDY0NA0KPj4gLS0tIGEvaHcvY29yZS9zeXNidXMuYw0KPj4gKysr
IGIvaHcvY29yZS9zeXNidXMuYw0KPj4gQEAgLTE2MCw2ICsxNjAsMTIgQEAgdm9pZCBzeXNidXNf
bW1pb19tYXAoU3lzQnVzRGV2aWNlICpkZXYsIGludCBuLCBod2FkZHIgYWRkcikNCj4+ICAgICBz
eXNidXNfbW1pb19tYXBfY29tbW9uKGRldiwgbiwgYWRkciwgZmFsc2UsIDAsIGdldF9zeXN0ZW1f
bWVtb3J5KCkpOw0KPj4gfQ0KPj4gDQo+PiArdm9pZCBzeXNidXNfbW1pb19tYXBfaW4oU3lzQnVz
RGV2aWNlICpkZXYsIGludCBuLCBod2FkZHIgYWRkciwNCj4+ICsgICAgICAgICAgICAgICAgICAg
ICAgICBNZW1vcnlSZWdpb24gKnN5c3RlbV9tZW1vcnkpDQo+PiArew0KPj4gKyAgICBzeXNidXNf
bW1pb19tYXBfY29tbW9uKGRldiwgbiwgYWRkciwgZmFsc2UsIDAsIHN5c3RlbV9tZW1vcnkpOw0K
Pj4gK30NCj4+ICsNCj4+IHZvaWQgc3lzYnVzX21taW9fbWFwX292ZXJsYXAoU3lzQnVzRGV2aWNl
ICpkZXYsIGludCBuLCBod2FkZHIgYWRkciwNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgaW50IHByaW9yaXR5KQ0KPj4gew0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvaHcvc3lzYnVz
LmggYi9pbmNsdWRlL2h3L3N5c2J1cy5oDQo+PiBpbmRleCBhN2MyM2Q1ZmIxLi5mNDU3ODAyOWU0
IDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS9ody9zeXNidXMuaA0KPj4gKysrIGIvaW5jbHVkZS9o
dy9zeXNidXMuaA0KPj4gQEAgLTgwLDYgKzgwLDggQEAgdm9pZCBzeXNidXNfY29ubmVjdF9pcnEo
U3lzQnVzRGV2aWNlICpkZXYsIGludCBuLCBxZW11X2lycSBpcnEpOw0KPj4gYm9vbCBzeXNidXNf
aXNfaXJxX2Nvbm5lY3RlZChTeXNCdXNEZXZpY2UgKmRldiwgaW50IG4pOw0KPj4gcWVtdV9pcnEg
c3lzYnVzX2dldF9jb25uZWN0ZWRfaXJxKFN5c0J1c0RldmljZSAqZGV2LCBpbnQgbik7DQo+PiB2
b2lkIHN5c2J1c19tbWlvX21hcChTeXNCdXNEZXZpY2UgKmRldiwgaW50IG4sIGh3YWRkciBhZGRy
KTsNCj4+ICt2b2lkIHN5c2J1c19tbWlvX21hcF9pbihTeXNCdXNEZXZpY2UgKmRldiwgaW50IG4s
IGh3YWRkciBhZGRyLA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgIE1lbW9yeVJlZ2lvbiAq
c3lzdGVtX21lbW9yeSk7DQo+PiB2b2lkIHN5c2J1c19tbWlvX21hcF9vdmVybGFwKFN5c0J1c0Rl
dmljZSAqZGV2LCBpbnQgbiwgaHdhZGRyIGFkZHIsDQo+PiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGludCBwcmlvcml0eSk7DQo+IA0KPiBXaGF0J3MgdGhpcyBnb2luZyB0byBiZSB1c2Vk
IGZvcj8NCg0KQXQgdGhlIG1vbWVudCwganVzdCBmb3IgU29DJ3MgdG8gbWFwIHBlcmlwaGVyYWxz
IGludG8gaXRzIG1lbW9yeSByZWdpb24uDQoNCj4gDQo+IFRoZSBjdXJyZW50IHN0YW5kYXJkIHdh
eSB0byBtYXAgYSBzeXNidXMgTU1JTyByZWdpb24gaW50byBzb21ldGhpbmcNCj4gb3RoZXIgdGhh
biB0aGUgZ2xvYmFsIHN5c3RlbSBtZW1vcnkgcmVnaW9uIGlzIHRvIGRvOg0KPiAgIG1lbW9yeV9y
ZWdpb25fYWRkX3N1YnJlZ2lvbigmY29udGFpbmVyLCBhZGRyLA0KPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBzeXNidXNfbW1pb19nZXRfcmVnaW9uKHNiZCwgMCkpOw0KDQpPaCEhIFdh
aXQgYSBtaW51dGUuIEkgc2hvdWxkIGp1c3QgY2hhbmdlIHRoZSBBc3BlZWQgU29DIGNvZGUgdG8N
CmRvIHRoYXQuIEkgd2FzIGtpbmRhIHRoaW5raW5nIHRoYXQgd2Ugd2FudGVkIGFsbCB0aGUgU29D
IGNvZGUNCnRvIGdvIHRocm91Z2ggc3lzYnVzX21taW9fbWFwX2NvbW1vbiwgYnV0IEkgcmVhbGl6
ZSBub3cgdGhhdA0KaXTigJlzIHJlYWxseSBqdXN0IGEgc21hbGwgaGVscGVyIHRoYXQgZG9lcyBz
b21lIGVycm9yIGNoZWNraW5nLA0KYW5kIHdlIGNhbiBqdXN0IGltcGxlbWVudCB0aGF0IGluIGFu
IGFzcGVlZC1zcGVjaWZpYyBoZWxwZXIgaWYNCm5lY2Vzc2FyeS4NCg0KPiANCj4gSSdkIHJhdGhl
ciBub3QgaGF2ZSB0d28gd2F5cyB0byBkbyB0aGUgc2FtZSB0aGluZzsgd2UgaGF2ZQ0KPiBmYXIg
dG9vIG1hbnkgb2YgdGhvc2UgYWxyZWFkeS4NCg0KVG90YWxseSBhZ3JlZSwgSSB3YXNu4oCZdCB2
ZXJ5IGNvbmZpZGVudCBpbiB0aGlzIHBhdGNoIGFueXdheXMuDQpJ4oCZbGwgcmVtb3ZlIGl0IGZy
b20gdGhlIHNlcmllcyBhbmQgcmVmYWN0b3IgdGhlIFNvQyBib2FyZA0KcGF0Y2ggZm9sbG93aW5n
IHRoaXMgdG8gZG8gd2hhdCB5b3Ugc3VnZ2VzdGVkLg0KDQpUaGFua3MhIQ0KUGV0ZXINCg0KPiAN
Cj4gdGhhbmtzDQo+IC0tIFBNTQ0KDQo=
