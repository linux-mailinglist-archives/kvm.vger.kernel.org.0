Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B58B5588B8
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 21:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiFWT0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 15:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiFWT0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 15:26:15 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B152D5535A
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:43:29 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NHuqXS025943
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:43:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : cc : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=FlRvYJWq5pEOW93kGjvH2UhgHnJ4lBMYdZsKAN8lrYU=;
 b=kVsNAYdOFtMkph03CPemGDVChNC0+j8llBCdYiR7mwco/39ZJ6ArksBP8iV+LGE4hrht
 rswsN9VJgS5L0oWZHXva0GP2wXJQCFHxFnGTtlj+eGMEucGSx4CEYKmQUa24vf4Wg9qI
 TJVJM8dj2tZnw2FjvWVUnc4Em9K9vszWdUc= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gvn943c30-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:43:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWmytUsJzsJ769vdZ79QlzxcutRVtESQrEufzTOLvDRegb0JaKQC/wDrgfPf00G/EnOg+87Xm8PhvCVAUenvioxX+GskDVWZhyOxW+lGDFnqrSGLVDUGKTbLSAF3mugRMKtCuY9pIdj6Q3RIVNBWH2KJ8r0lVBFouCM/hHlcD4WjqyJl7YoiZxNQCpc+v8jh+EAsGyPldMShuCaSRHzVy6K68ADQidNgF8KJGMZHxfwljpb4vSq8U2Nup/Orlu9UJ+Loc5AVEmDhOHPmM6D1JXG2SPX8uubvdzbYrAPBOidiiSmPH/9jqUvzCkmiC3HBtWpWyTmDIOUGS9JpzxokJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlRvYJWq5pEOW93kGjvH2UhgHnJ4lBMYdZsKAN8lrYU=;
 b=EN23SQoMh1VgeaDcNPG0HcOVXrgzEbQLl4D07PdRES/vk8/XMmqLSRBcTCjBEVblzDUPPoMJg+96uH66cIRS5S5lBtWuIcaxP4V6YpTL+MZeBDn/ncHwB/cqFOXEBc4NLtNgzLGhC68XdZL+pCaAdQ3X/UR2h9yxBPa2uAltsh9Cv2yGpk7LmNvB/4B1ZQY+rR+giGTZWwoX20Z1VuniARhSPsxUwloGqvu+51m5yzw2VZeqBFkfg3qYmLENC/agU5OWNpNONc/45v3SP92L4qo+S78ArbSKA43C8kiavl9Dd/ohFtLtJhp6CM5leh0E+oExEoajh0qXI1q+C+jTDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB3032.namprd15.prod.outlook.com (2603:10b6:a03:ff::11)
 by MWHPR15MB1151.namprd15.prod.outlook.com (2603:10b6:320:23::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 18:43:26 +0000
Received: from BYAPR15MB3032.namprd15.prod.outlook.com
 ([fe80::70d0:8133:42cc:f134]) by BYAPR15MB3032.namprd15.prod.outlook.com
 ([fe80::70d0:8133:42cc:f134%6]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 18:43:26 +0000
From:   Peter Delevoryas <pdel@fb.com>
CC:     Peter Delevoryas <pdel@fb.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "eduardo@habkost.net" <eduardo@habkost.net>,
        "\"i.mitsyanko@gmail.com.mst\"@redhat.com" 
        <"i.mitsyanko@gmail.com.mst"@redhat.com>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        "ani@anisinha.ca" <ani@anisinha.ca>,
        Cameron Esfahani via <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@kaod.org>
Subject: Re: [PATCH 12/14] aspeed: Make aspeed_board_init_flashes public
Thread-Topic: [PATCH 12/14] aspeed: Make aspeed_board_init_flashes public
Thread-Index: AQHYhwLRYpn4RsTCd0GyQjZay2Vuh61dGJGAgAA7p4A=
Date:   Thu, 23 Jun 2022 18:43:26 +0000
Message-ID: <EC44C0BD-7BC0-4BDE-9A41-CB1EAA90EC87@fb.com>
References: <20220623102617.2164175-1-pdel@fb.com>
 <20220623102617.2164175-13-pdel@fb.com>
 <e5f51f14-fe75-0d55-6588-a3ca2565f760@kaod.org>
In-Reply-To: <e5f51f14-fe75-0d55-6588-a3ca2565f760@kaod.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 426086d0-b8fa-4296-9f61-08da55484217
x-ms-traffictypediagnostic: MWHPR15MB1151:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GnkRsi4OGe8quqbwxwKH6EYDwd11vup0KXeAksXIrALDkSNHIvLqw7ZqeUodJ+5MFKYxvtaoU95Ds4H0ifx/3Tm/+afq+bM5bZc3A9UOWITkCYSYceKEzo0lFMLi3snV9LB+loI3ZSyjpUFaH2wZd36sLBAC82y3A1O/06hhPzGn9avyg2RI4d4guCu0HPUWr37nAh4CiteuR0Lm3gB5dxgXMyKe7v0i0AMVLG2YtQFCGzcsPwWCkLXiXgAr5WEnTYa5IhDzjDeBIiWrfttoPdVSbNd1164dFCFbkJZ6rJXoHVXR86gsJivEmLYOsMeK6ezcyHicV1U+2FrCMoHdL3yi7++zA9ONurftQGnKZ1V23BsxsvuDaVLnJB/HMSS2IWwhoNY39h0XqSobsUCZ3OgdQoYQ6kg2KB7UHoNYgLZV7Nyl7aousbDIu/qZGxOhAe1qLpanX3pke91KFLj2tYesE8vpE0UKUWw89v+zQat3dWNu/eVrqcusEtx7OPYArESSBjDZEdl9Wa9y/uufu2u+22kTgrqxqR4n5tgo/1xy497FW0RzGn6BGRDQWE60Pj2G3Do4Q8SwYpeEMwYXxn01jK4I0qjMszPk4nwrdZcJ9YpAdIavr3LIQ3t3OVPK+X+QiVamWIzGX2NwxXYEo7GAmF8AOnuwhnFfy/mnJ06fjmpwylshApgWgOyY4E3hk6iJxZLnAyj257o0Hdnf0Hr7+8xnjxh/z8sDJ0qd/slehocOTeA8NBhEyFX3YOCL+uMJwcyzXIs2Wf2y6Ag/Sg1H6waFplQz/y3Jx3JsWaSW1xAYge9MxUUNXKYVje4/Rcsl8Qt3A/MMnMXX81WZgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB3032.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(316002)(5660300002)(7416002)(8676002)(71200400001)(4326008)(33656002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(478600001)(8936002)(86362001)(6486002)(36756003)(6512007)(83380400001)(186003)(2616005)(41300700001)(109986005)(66574015)(2906002)(38070700005)(122000001)(53546011)(6506007)(38100700002)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0lQdXAwZHhQS1QvTERhZUFYcVpiU0hCOUtHNklYNysvMEh3UTBkWFUvRzl6?=
 =?utf-8?B?eENMUUFpWFlWYnRBOXcveEJYMXViVTk2WWtjZ1VETDdjbWJRa01lUWNtTDEr?=
 =?utf-8?B?ZGhNbWU4eVovSG93OWsrNDRHTys5b1lESkRWdjBLZkFObzBYREhxeDF2aFFY?=
 =?utf-8?B?aU1TWkNYZHVFMC83M1I3RVMzWHNWYzVNOFU5UDU2Tk9tRFJsVmlhWFcwNWlu?=
 =?utf-8?B?TjlUNXhCd2RGbERMWmF6ZXEva3RsRU1TYTdJZ0VXNTVYS1RrYlRvZGRRRjk4?=
 =?utf-8?B?SkZaWW9Ba2k4L2J5Rko1NkR3N3FrVGFUdEoxcXpDeTJONFFEcVRuaDBTdGhP?=
 =?utf-8?B?dmh6SFoxcTcwNGdmdWI5N3JDWlc2Y0VQbXQ2MDFxeFNFSTFiQ2VScVNpV3Nh?=
 =?utf-8?B?S3dtVC95UU5oWEF3OGNqQ24vd2VHc0tKVWN2a0ZDZzdpeDY4RmZXQ3EzMG43?=
 =?utf-8?B?ZmE2T3hsYXpRTGtrRSt6dE5vbnM4a2M0VGhmY3ROQ3JubXJRMk0vcUVsSm9o?=
 =?utf-8?B?M3NhU2NGbGgyZUt1SGRKeXRRZ1BiL2pRMWhqN2NWbUVCbGQxb01EMS9rWndR?=
 =?utf-8?B?TWtIYXc4b1pxY3l4L0lDNTZmNWxrVHBPc1MvMnFtUGdZbytvREh2blZRYWh3?=
 =?utf-8?B?eHRtNXBIcENRTUJER2pyT2MrUFhnbVRRV1N1TkUyZkh3QmZYcWJSY0YxWGZU?=
 =?utf-8?B?TTgxdDV4eUFHNlY2UVl0RlY1YndXakdad0V0aldrV0FSWC9DWGhaNFpqWThY?=
 =?utf-8?B?YTViOHdGS3pHK1RWUERFUlZtNEg0Y1RhZEs5R3dBU3N4SFNZdDd1bVhpbUlE?=
 =?utf-8?B?OUVJS2FGckdRbHBzb2JYYWhQcmNkWENqMnVUd1BQc21TVXNqQW11N2hJNGF6?=
 =?utf-8?B?SkJ5S3JqcWtNRlM5dTFkZm9iTDlISVY0ZkVld3NIajRMZ09NQ1NjYlgzS1E1?=
 =?utf-8?B?UEp3eDE4aVFlR3poRUc2MUZzOXpRQzdVRGtRSHFsVC94TTFlbGNkQnN1MndT?=
 =?utf-8?B?YS8yd3NuOVZSL0RBVTVIYVFnQWFkbW82OXI1bW9ISHBaS0NaWnYwR3BHTFdh?=
 =?utf-8?B?K2pNSTNHcVhISUF1bjgxL0FsZXJBVkk1VC91ajN1T2FMVnNxOUpVcTZyTFV0?=
 =?utf-8?B?ckladTRINlhKenQwVWFyRFdUZmlDUzQwUkJLakpCckRVTXY2V0xHbktrNU9V?=
 =?utf-8?B?dm0rL1orSDZRVE92N1VWNTJtSHB2VXpYdWZZSHdqMXkyTVVDUlFESisrM1Q5?=
 =?utf-8?B?YXNUanBMeDB5VkwwSm9mUW00VWFQVlBGRWZDTlpsSnJrQXhURlNBZll2bFVx?=
 =?utf-8?B?cnVpbDU4Vzg3L2czZmlzTWc1TXY5ZDNEb3lwSlJraEF6d3REMERTeHk4ZnIx?=
 =?utf-8?B?RldodEtISkJ3YzZBVWZVdUxNZm1XZWNXZ1hQRW9YNnpiNmViM2VibW8xZllu?=
 =?utf-8?B?RXFrMUxjblJnMTZCdXRNL3BjY2RmWVdQSUJtYXBKYk83SmcvcHEvMjRwdUh2?=
 =?utf-8?B?RWJBQ01qeTY2NGdmTzU3Q2Ezd25HVHhGWmxkK20xTGFnaXlEMEQybkRBUmxQ?=
 =?utf-8?B?QUdYTUc0akFqbDRSVHBqQzRQekhDcjkrcGo0dkVTQVFkZGxZNTNDZ3huV3Iv?=
 =?utf-8?B?SENBdXIyQ3l0ODh2UnQzaDROQ2U4cDhPVjhLeUs5ME8rM0h0aTBmcHhMY2NH?=
 =?utf-8?B?b1Y5UnFaQ05SSXptektEZ2lSbHphSkxlOTRpNXVRV2hwMmRiT0R3Q1NjUmNj?=
 =?utf-8?B?dmE5Wloxc3JTR3N1T1RrY0Rib3FIUXhkK1h5dUgySlFqanZSMFN2VndVaE1z?=
 =?utf-8?B?eDJHdGxxZ2p6MlpXZlVjWVU5MkRFZ0MyRUpDUkZFb2ZRcGtDZkFLaXRwcENP?=
 =?utf-8?B?L0hGU2p5STRzbWJtQUpQZlpXaWI1NmxRSGN1SCtBQUMwVUpjUWNaL05RbjZH?=
 =?utf-8?B?RE5mUEJuOVp5YUd2MU8yT3EzTUFsRUM3VlY5KzVRTDFwRStNcXFxcXo0S0FY?=
 =?utf-8?B?aW1lVm5aN0RGNEJTa0Jla2VPV0xuK1ZkaWFOeE1aSVFGMWI4b0dMVm9oRFJz?=
 =?utf-8?B?YTdLOUkyVmh0OUVpdFF1S0dGUFg0RHNCa1ZzelltemQwYVp0eGRzVk9MQTZP?=
 =?utf-8?B?MzVLL2txWGdVL25DVWNGaHJmTnR0SFcyeDg1c3pqTFE1OEhCdEo0Vm5XVzBl?=
 =?utf-8?B?NDdBaSt5WloxajhyNGRlUjlYZ1hGaGFCUlRodUJySEs4a2s1QXJ4YUFEdHJQ?=
 =?utf-8?B?MEphVVUrcEZ0WURUSWtHTnVrdTErZGs5eU5mN2pxUWlnWklwSXdPajNJUzhh?=
 =?utf-8?B?TXI5YjA1bjZrbW94TmEySFhSMDZuRlhsTFJOQTRvUVlYV3ZnVDZWbGc3SUNE?=
 =?utf-8?Q?OHs+FmRB/8GBCYBY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F542F1253C6EA643A3EE3BFA10173BF6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB3032.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426086d0-b8fa-4296-9f61-08da55484217
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 18:43:26.1040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4RzTlzSuscm8Ui1RKOV69+Pm9LnSdhFUPYdGUnEdzMZocg4gvr9v9shyatsrOCOH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1151
X-Proofpoint-ORIG-GUID: Ni__1FMeEResmQg0ohujsdtYZpx5hxfs
X-Proofpoint-GUID: Ni__1FMeEResmQg0ohujsdtYZpx5hxfs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_08,2022-06-23_01,2022-06-22_01
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

DQoNCj4gT24gSnVuIDIzLCAyMDIyLCBhdCA4OjA5IEFNLCBDw6lkcmljIExlIEdvYXRlciA8Y2xn
QGthb2Qub3JnPiB3cm90ZToNCj4gDQo+IE9uIDYvMjMvMjIgMTI6MjYsIFBldGVyIERlbGV2b3J5
YXMgd3JvdGU6DQo+PiBTaWduZWQtb2ZmLWJ5OiBQZXRlciBEZWxldm9yeWFzIDxwZGVsQGZiLmNv
bT4NCj4gDQo+IExldCdzIHN0YXJ0IHNpbXBsZSB3aXRob3V0IGZsYXNoIHN1cHBvcnQuIFdlIHNo
b3VsZCBiZSBhYmxlIHRvDQo+IGxvYWQgRlcgYmxvYnMgaW4gZWFjaCBDUFUgYWRkcmVzcyBzcGFj
ZSB1c2luZyBsb2FkZXIgZGV2aWNlcy4NCg0KQWN0dWFsbHksIEkgd2FzIHVuYWJsZSB0byBkbyB0
aGlzLCBwZXJoYXBzIGJlY2F1c2UgdGhlIGZiIE9wZW5CTUMNCmJvb3Qgc2VxdWVuY2UgaXMgYSBs
aXR0bGUgd2VpcmQuIEkgc3BlY2lmaWNhbGx5IF9uZWVkZWRfIHRvIGhhdmUNCmEgZmxhc2ggZGV2
aWNlIHdoaWNoIG1hcHMgdGhlIGZpcm13YXJlIGluIGF0IDB4MjAwMF8wMDAwLCBiZWNhdXNlDQp0
aGUgZmIgT3BlbkJNQyBVLUJvb3QgU1BMIGp1bXBzIHRvIHRoYXQgYWRkcmVzcyB0byBzdGFydCBl
eGVjdXRpbmcNCmZyb20gZmxhc2g/IEkgdGhpbmsgdGhpcyBpcyBhbHNvIHdoeSBmYiBPcGVuQk1D
IG1hY2hpbmVzIGNhbiBiZSBzbyBzbG93Lg0KDQokIC4vYnVpbGQvcWVtdS1zeXN0ZW0tYXJtIC1t
YWNoaW5lIGZieTM1IFwNCiAgICAtZGV2aWNlIGxvYWRlcixmaWxlPWZieTM1Lm10ZCxhZGRyPTAs
Y3B1LW51bT0wIC1ub2dyYXBoaWMgXA0KICAgIC1kIGludCAtZHJpdmUgZmlsZT1mYnkzNS5tdGQs
Zm9ybWF0PXJhdyxpZj1tdGQNCg0KVS1Cb290IFNQTCAyMDE5LjA0IGZieTM1LWUyMjk0ZmY1ZDMg
KEFwciAxNSAyMDIyIC0gMTk6MjU6MjUgKzAwMDApDQpTWVNfSU5JVF9SQU1fRU5EPTEwMDE2MDAw
DQpDT05GSUdfU1lTX0lOSVRfU1BfQUREUj0xMDAxNTAwMA0KQ09ORklHX01BTExPQ19GX0FERFI9
MTAwMTIwMDANCmdkID0gc3AgPSAxMDAxMWYxMA0KZmR0PTAwMDE4MmI0DQpTZXR1cCBmbGFzaDog
d3JpdGUgZW5hYmxlLCBhZGRyNEIsIENFMSBBSEIgNjRNQiB3aW5kb3cNClNldHVwIEZNQ19DRV9D
VFJMID0gMHgwMDAwMDAzMw0KV2F0Y2hkb2c6IDMwMHMNCmh3c3RyYXAgd3JpdGUgcHJvdGVjdCBT
Q1U1MDg9MHgwMDAwMDAwMCwgU0NVNTE4PTB4MDAwMDAwMDANCkJlZm9yZTogQ0UwX0NUUkw9MHgw
MDAwMDYwMCwgQ0UxX0NUUkw9MHgwMDAwMDAwNA0KY3MwX3N0YXR1cyA9IDEsIGNzMV9zdGF0dXMg
PSAxDQpBZnRlcjogQ0UwX0NUUkw9MHgwMDAwMDQwMCwgQ0UxX0NUUkw9MHgwMDAwMDQwMA0KdmJv
b3RfcmVzZXQgNTA0DQpTUEwgQ291bGQgbm90IGZpbmQgVFBNIChyZXQ9LTUpDQpCb290aW5nIHJl
Y292ZXJ5IFUtQm9vdC4NCkJsaW5kbHkganVtcGluZyB0byAweDIwMDQwMDAwDQpRRU1VIDcuMC41
MCBtb25pdG9yIC0gdHlwZSAnaGVscCcgZm9yIG1vcmUgaW5mb3JtYXRpb24NCihxZW11KSB4cCAv
eCAweDIwMDQwMDAwDQowMDAwMDAwMDIwMDQwMDAwOiAweGVhMDAwMGMwDQoocWVtdSkgeHAgL3gg
MHgwMDA0MDAwMA0KMDAwMDAwMDAwMDA0MDAwMDogMHhlYTAwMDBjMA0KKHFlbXUpIHhwIC94IDB4
MDAwMDAwMDANCjAwMDAwMDAwMDAwMDAwMDA6IDB4ZWEwMDAwMWYNCihxZW11KSB4cCAveCAweDIw
MDAwMDAwDQowMDAwMDAwMDIwMDAwMDAwOiAweGVhMDAwMDFmDQoocWVtdSkgcQ0KcGRlbEBkZXZ2
bTkxOTQ6fi9sb2NhbC9xZW11ICgoNzljMTk2Yi4uLikpDQokIC4vYnVpbGQvcWVtdS1zeXN0ZW0t
YXJtIC1tYWNoaW5lIGZieTM1IC1kZXZpY2UgbG9hZGVyLGZpbGU9ZmJ5MzUubXRkLGFkZHI9MCxj
cHUtbnVtPTAgLW5vZ3JhcGhpYyAtZCBpbnQNCg0KVS1Cb290IFNQTCAyMDE5LjA0IGZieTM1LWUy
Mjk0ZmY1ZDMgKEFwciAxNSAyMDIyIC0gMTk6MjU6MjUgKzAwMDApDQpTWVNfSU5JVF9SQU1fRU5E
PTEwMDE2MDAwDQpDT05GSUdfU1lTX0lOSVRfU1BfQUREUj0xMDAxNTAwMA0KQ09ORklHX01BTExP
Q19GX0FERFI9MTAwMTIwMDANCmdkID0gc3AgPSAxMDAxMWYxMA0KZmR0PTAwMDE4MmI0DQpTZXR1
cCBmbGFzaDogd3JpdGUgZW5hYmxlLCBhZGRyNEIsIENFMSBBSEIgNjRNQiB3aW5kb3cNClNldHVw
IEZNQ19DRV9DVFJMID0gMHgwMDAwMDAzMw0KV2F0Y2hkb2c6IDMwMHMNCmh3c3RyYXAgd3JpdGUg
cHJvdGVjdCBTQ1U1MDg9MHgwMDAwMDAwMCwgU0NVNTE4PTB4MDAwMDAwMDANCkJlZm9yZTogQ0Uw
X0NUUkw9MHgwMDAwMDYwMCwgQ0UxX0NUUkw9MHgwMDAwMDAwNA0KY3MwX3N0YXR1cyA9IDEsIGNz
MV9zdGF0dXMgPSAxDQpBZnRlcjogQ0UwX0NUUkw9MHgwMDAwMDQwMCwgQ0UxX0NUUkw9MHgwMDAw
MDQwMA0KdmJvb3RfcmVzZXQgNTA0DQpTUEwgQ291bGQgbm90IGZpbmQgVFBNIChyZXQ9LTUpDQpC
b290aW5nIHJlY292ZXJ5IFUtQm9vdC4NCkJsaW5kbHkganVtcGluZyB0byAweDIwMDQwMDAwDQpU
YWtpbmcgZXhjZXB0aW9uIDEgW1VuZGVmaW5lZCBJbnN0cnVjdGlvbl0gb24gQ1BVIDANCi4uLmZy
b20gRUwzIHRvIEVMMw0KLi4ud2l0aCBFU1IgMHgwLzB4MjAwMDAwMA0KUUVNVSA3LjAuNTAgbW9u
aXRvciAtIHR5cGUgJ2hlbHAnIGZvciBtb3JlIGluZm9ybWF0aW9uDQoocWVtdSkgeHAgL3ggMHgy
MDAwMDAwMA0KMDAwMDAwMDAyMDAwMDAwMDogMHhmZmZmZmZmZg0KKHFlbXUpIHhwIC94IDB4MjAw
NDAwMDANCjAwMDAwMDAwMjAwNDAwMDA6IDB4ZmZmZmZmZmYNCg0KPiANCj4gVGhhbmtzLA0KPiAN
Cj4gQy4NCj4gDQo+PiAtLS0NCj4+ICBody9hcm0vYXNwZWVkLmMgICAgICAgICAgICAgfCAyNSAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+PiAgaHcvYXJtL2FzcGVlZF9zb2MuYyAgICAgICAg
IHwgMjYgKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+ICBpbmNsdWRlL2h3L2FybS9hc3Bl
ZWRfc29jLmggfCAgMiArKw0KPj4gIDMgZmlsZXMgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwg
MjUgZGVsZXRpb25zKC0pDQo+PiBkaWZmIC0tZ2l0IGEvaHcvYXJtL2FzcGVlZC5jIGIvaHcvYXJt
L2FzcGVlZC5jDQo+PiBpbmRleCAzYWE3NGU4OGZiLi5jODkzY2U4NGQ3IDEwMDY0NA0KPj4gLS0t
IGEvaHcvYXJtL2FzcGVlZC5jDQo+PiArKysgYi9ody9hcm0vYXNwZWVkLmMNCj4+IEBAIC0yNzgs
MzEgKzI3OCw2IEBAIHN0YXRpYyB2b2lkIHdyaXRlX2Jvb3Rfcm9tKERyaXZlSW5mbyAqZGluZm8s
IGh3YWRkciBhZGRyLCBzaXplX3Qgcm9tX3NpemUsDQo+PiAgICAgIHJvbV9hZGRfYmxvYl9maXhl
ZCgiYXNwZWVkLmJvb3Rfcm9tIiwgc3RvcmFnZSwgcm9tX3NpemUsIGFkZHIpOw0KPj4gIH0NCj4+
ICAtc3RhdGljIHZvaWQgYXNwZWVkX2JvYXJkX2luaXRfZmxhc2hlcyhBc3BlZWRTTUNTdGF0ZSAq
cywgY29uc3QgY2hhciAqZmxhc2h0eXBlLA0KPj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgdW5zaWduZWQgaW50IGNvdW50LCBpbnQgdW5pdDApDQo+PiAtew0KPj4gLSAg
ICBpbnQgaTsNCj4+IC0NCj4+IC0gICAgaWYgKCFmbGFzaHR5cGUpIHsNCj4+IC0gICAgICAgIHJl
dHVybjsNCj4+IC0gICAgfQ0KPj4gLQ0KPj4gLSAgICBmb3IgKGkgPSAwOyBpIDwgY291bnQ7ICsr
aSkgew0KPj4gLSAgICAgICAgRHJpdmVJbmZvICpkaW5mbyA9IGRyaXZlX2dldChJRl9NVEQsIDAs
IHVuaXQwICsgaSk7DQo+PiAtICAgICAgICBxZW11X2lycSBjc19saW5lOw0KPj4gLSAgICAgICAg
RGV2aWNlU3RhdGUgKmRldjsNCj4+IC0NCj4+IC0gICAgICAgIGRldiA9IHFkZXZfbmV3KGZsYXNo
dHlwZSk7DQo+PiAtICAgICAgICBpZiAoZGluZm8pIHsNCj4+IC0gICAgICAgICAgICBxZGV2X3By
b3Bfc2V0X2RyaXZlKGRldiwgImRyaXZlIiwgYmxrX2J5X2xlZ2FjeV9kaW5mbyhkaW5mbykpOw0K
Pj4gLSAgICAgICAgfQ0KPj4gLSAgICAgICAgcWRldl9yZWFsaXplX2FuZF91bnJlZihkZXYsIEJV
UyhzLT5zcGkpLCAmZXJyb3JfZmF0YWwpOw0KPj4gLQ0KPj4gLSAgICAgICAgY3NfbGluZSA9IHFk
ZXZfZ2V0X2dwaW9faW5fbmFtZWQoZGV2LCBTU0lfR1BJT19DUywgMCk7DQo+PiAtICAgICAgICBz
eXNidXNfY29ubmVjdF9pcnEoU1lTX0JVU19ERVZJQ0UocyksIGkgKyAxLCBjc19saW5lKTsNCj4+
IC0gICAgfQ0KPj4gLX0NCj4+IC0NCj4+ICBzdGF0aWMgdm9pZCBzZGhjaV9hdHRhY2hfZHJpdmUo
U0RIQ0lTdGF0ZSAqc2RoY2ksIERyaXZlSW5mbyAqZGluZm8pDQo+PiAgew0KPj4gICAgICAgICAg
RGV2aWNlU3RhdGUgKmNhcmQ7DQo+PiBkaWZmIC0tZ2l0IGEvaHcvYXJtL2FzcGVlZF9zb2MuYyBi
L2h3L2FybS9hc3BlZWRfc29jLmMNCj4+IGluZGV4IGI3ZTg1MDZmMjguLjMzYmZjMDZlZDggMTAw
NjQ0DQo+PiAtLS0gYS9ody9hcm0vYXNwZWVkX3NvYy5jDQo+PiArKysgYi9ody9hcm0vYXNwZWVk
X3NvYy5jDQo+PiBAQCAtMjAsNiArMjAsNyBAQA0KPj4gICNpbmNsdWRlICJody9pMmMvYXNwZWVk
X2kyYy5oIg0KPj4gICNpbmNsdWRlICJuZXQvbmV0LmgiDQo+PiAgI2luY2x1ZGUgInN5c2VtdS9z
eXNlbXUuaCINCj4+ICsjaW5jbHVkZSAic3lzZW11L2Jsb2NrZGV2LmgiDQo+PiAgICAjZGVmaW5l
IEFTUEVFRF9TT0NfSU9NRU1fU0laRSAgICAgICAweDAwMjAwMDAwDQo+PiAgQEAgLTU3OSwzICs1
ODAsMjggQEAgdm9pZCBhc3BlZWRfc29jX3VhcnRfaW5pdChBc3BlZWRTb0NTdGF0ZSAqcykNCj4+
ICAgICAgICAgICAgICAgICAgICAgICAgIHNlcmlhbF9oZChpKSwgREVWSUNFX0xJVFRMRV9FTkRJ
QU4pOw0KPj4gICAgICB9DQo+PiAgfQ0KPj4gKw0KPj4gK3ZvaWQgYXNwZWVkX2JvYXJkX2luaXRf
Zmxhc2hlcyhBc3BlZWRTTUNTdGF0ZSAqcywgY29uc3QgY2hhciAqZmxhc2h0eXBlLA0KPj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBpbnQgY291bnQsIGludCB1bml0
MCkNCj4+ICt7DQo+PiArICAgIGludCBpOw0KPj4gKw0KPj4gKyAgICBpZiAoIWZsYXNodHlwZSkg
ew0KPj4gKyAgICAgICAgcmV0dXJuOw0KPj4gKyAgICB9DQo+PiArDQo+PiArICAgIGZvciAoaSA9
IDA7IGkgPCBjb3VudDsgKytpKSB7DQo+PiArICAgICAgICBEcml2ZUluZm8gKmRpbmZvID0gZHJp
dmVfZ2V0KElGX01URCwgMCwgdW5pdDAgKyBpKTsNCj4+ICsgICAgICAgIHFlbXVfaXJxIGNzX2xp
bmU7DQo+PiArICAgICAgICBEZXZpY2VTdGF0ZSAqZGV2Ow0KPj4gKw0KPj4gKyAgICAgICAgZGV2
ID0gcWRldl9uZXcoZmxhc2h0eXBlKTsNCj4+ICsgICAgICAgIGlmIChkaW5mbykgew0KPj4gKyAg
ICAgICAgICAgIHFkZXZfcHJvcF9zZXRfZHJpdmUoZGV2LCAiZHJpdmUiLCBibGtfYnlfbGVnYWN5
X2RpbmZvKGRpbmZvKSk7DQo+PiArICAgICAgICB9DQo+PiArICAgICAgICBxZGV2X3JlYWxpemVf
YW5kX3VucmVmKGRldiwgQlVTKHMtPnNwaSksICZlcnJvcl9mYXRhbCk7DQo+PiArDQo+PiArICAg
ICAgICBjc19saW5lID0gcWRldl9nZXRfZ3Bpb19pbl9uYW1lZChkZXYsIFNTSV9HUElPX0NTLCAw
KTsNCj4+ICsgICAgICAgIHN5c2J1c19jb25uZWN0X2lycShTWVNfQlVTX0RFVklDRShzKSwgaSAr
IDEsIGNzX2xpbmUpOw0KPj4gKyAgICB9DQo+PiArfQ0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
aHcvYXJtL2FzcGVlZF9zb2MuaCBiL2luY2x1ZGUvaHcvYXJtL2FzcGVlZF9zb2MuaA0KPj4gaW5k
ZXggYzY4Mzk1ZGRiYi4uMjcwZDg1ZDVkZSAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvaHcvYXJt
L2FzcGVlZF9zb2MuaA0KPj4gKysrIGIvaW5jbHVkZS9ody9hcm0vYXNwZWVkX3NvYy5oDQo+PiBA
QCAtMTY2LDUgKzE2Niw3IEBAIGVudW0gew0KPj4gICAgcWVtdV9pcnEgYXNwZWVkX3NvY19nZXRf
aXJxKEFzcGVlZFNvQ1N0YXRlICpzLCBpbnQgZGV2KTsNCj4+ICB2b2lkIGFzcGVlZF9zb2NfdWFy
dF9pbml0KEFzcGVlZFNvQ1N0YXRlICpzKTsNCj4+ICt2b2lkIGFzcGVlZF9ib2FyZF9pbml0X2Zs
YXNoZXMoQXNwZWVkU01DU3RhdGUgKnMsIGNvbnN0IGNoYXIgKmZsYXNodHlwZSwNCj4+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgaW50IGNvdW50LCBpbnQgdW5pdDAp
Ow0KPj4gICAgI2VuZGlmIC8qIEFTUEVFRF9TT0NfSCAqLw0KPiANCg0K
