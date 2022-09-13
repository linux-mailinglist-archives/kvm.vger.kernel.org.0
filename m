Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130F15B6D90
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 14:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiIMMsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 08:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIMMsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 08:48:12 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazlp17010000.outbound.protection.outlook.com [40.93.6.0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F190D4F6B8;
        Tue, 13 Sep 2022 05:48:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtJpkbfq49CR2jtKrSjJ/4RMcsn+F8k2+MFY5KM6Wm0timcEqozRLg8BfpTtl8W+PkMYcqSoAE+hIVToQEycYt3ajw5aS/xzKn18Y5ySX2RBL6LnvuzubfBJRDdoio7LGn/1GMDwVIvnhxr5f2umJVyirZ6G/zZUR9b3gzWUZWos6V79HdPrf2BlT2mb7nOeNgb0KvHw5zkC1/e6SzMZiq7exopADAYb7ckrOf5MHx+AypAvGBefvKntMLjrGTy4DDmR0auy63slDvbGUQM/3HQ+bXOCzSrX3TtmxeST5qgqcN4YqTciCuzhDdKD3pGLmgDAQEO6fFoLkGju+UmjDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1kM91Agf12XoqrQQtWbE4p8Mh3i7XKkWF6wocbZT10=;
 b=AhfBu1t1gCQfhnwpkv5AWFm1CCwEindEAB+3yav0C2Ic7Cm4xM0V5jjkPKdV/bLus2PPqnbZo7yDxrnsO6TRbIzGdzWpDuhVLxmIz7Pyl53v2Nb8p/Yo/nUaJULKSaX1S82HaE6iUMJejT1C2v/CkmskwZZOAWVPOLi0pzf3vf4AvVS0PukuYlS+DJKPNi6iA2unz41thbmC3Gw0AVYhSWgKaHVCT5+ejQMmyxxOGREGzSUTuROBcyoPNXj3YGpMUJAVyCRYOS+k1et+Iz7e/9awHxdp99PTBj5Ooepg/ZndWFB+93kpjvulDTQX+ynKsAsir9M63NRwQ0BbUeszDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1kM91Agf12XoqrQQtWbE4p8Mh3i7XKkWF6wocbZT10=;
 b=0wkubBF3Ansn8Y0O/MeQTiMdpckfPpNT6Dv1kPwH/kyooSDlHiZC0q3kwSmYFiEwGr2vXPMni/j8QtDghz+nnWyR4lHU4+6CJqrxS3Srr485d/RNMrX9EvtbWpe+8eeN0p9Ac5TIBuhHinOdWM26etEDrZOr1VQ3p1mNykoEKFs=
Received: from PH0PR05MB8703.namprd05.prod.outlook.com (2603:10b6:510:bd::5)
 by BN6PR05MB3571.namprd05.prod.outlook.com (2603:10b6:405:3d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Tue, 13 Sep
 2022 12:47:47 +0000
Received: from PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::ae59:5c22:5ddd:bec8]) by PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::ae59:5c22:5ddd:bec8%7]) with mapi id 15.20.5632.012; Tue, 13 Sep 2022
 12:47:47 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        "er.ajay.kaher@gmail.com" <er.ajay.kaher@gmail.com>,
        "willy@infradead.org" <willy@infradead.org>,
        Nadav Amit <namit@vmware.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jailhouse-dev@googlegroups.com" <jailhouse-dev@googlegroups.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "acrn-dev@lists.projectacrn.org" <acrn-dev@lists.projectacrn.org>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Topic: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Index: AQHYx28G+J2WSwxm3kmFzqoOhSDYUA==
Date:   Tue, 13 Sep 2022 12:47:47 +0000
Message-ID: <9FEC6622-780D-41E6-B7CA-8D39EDB2C093@vmware.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.61.22050700
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR05MB8703:EE_|BN6PR05MB3571:EE_
x-ms-office365-filtering-correlation-id: 83ae9ce5-2764-4abe-962c-08da95862952
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S6okgQKDNU7YC6DCZz5r6q/JLVAi66A29Certi1a09DKAj2U3ScSe2Wqij6E4e5JZKVxIpBVgRWP372d2SOH23IWP+PfLx8NbboCkx7XRJIMZK2WOcHHkEu5acp3GMBkoRHzvwwoLj3h0neERprKGcRT70J3BzEC2KCxnTySsn5WymAl4TFbDwVW0FAdncvJNMEh75iBO32pFAlx342ZZF2cer8V9ZSrLC8jTKDS8rK0A/KZZVO333EVrrykBqMrnfMwPteQFiI4jxOZQx+fH/WXDq3XDq/+j/ATqtDzG6uK/33Iz9kvtEonWN9xV3USsFW9qfzuiRATZqO03QxE40CteHP4ef8EdciZ5v836sf/Ku9WBftBrvcbjX8MLFsblowncAMPFZBbgs2QMXzXTcpV22ZCy2MFLNfPdDfFmVaL2k8i+efjoLqc3DzNqOscEkOKQC8S4U4u7hlr1Uyp6M0AUoUZLusdEtwfUIyCZsWNdZplRLOSH+EgWCEYWkFpNKlMzoOcGsek9cVXCOw6ZmMgyYHnKvbmMM5pnwwveGAl5BoLI0epv6GSQf77+2OXYbCOmVBulRy2QbpvwZuZXI6NoLgUuucAh31a9XhZu018PfgMLC35ntX+frT5AG2e7Z5fusDx96LvWjldRv5XX0KdV1ruzSMSOt1Mwe/J4DH9C3XKt+EohDBHbTqe+pzm9Dyq17deniBTyQv590MjEs/dDqK9Ou4mj0UAAvBOLUkyssc0WSYKk9R9P2JX+Nn6f/lOxSoxiTrdyD50qFHwjanm1pMronbvUHrjKILE9ibRgGS/9XA3u4NzXi/kPThNsQm6emcAHnqosETKogacvWPec//5mcTCyYr/bTcGYnY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR05MB8703.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199015)(6916009)(71200400001)(6506007)(478600001)(186003)(66946007)(6512007)(41300700001)(86362001)(38070700005)(8676002)(26005)(2616005)(33656002)(6486002)(91956017)(36756003)(2906002)(66446008)(7416002)(8936002)(122000001)(54906003)(66476007)(64756008)(66556008)(76116006)(38100700002)(316002)(5660300002)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1JWM2JXVDFVaGl1SDlUand5UXZJNG9ZczIwWmdyVjQ2a21PZjBtdDhudkI4?=
 =?utf-8?B?RlN1SmpzallyOTg4SGdkb1A0cGdRRUhPS0R1eDBoZlhHTTFqVExsckE2OWFi?=
 =?utf-8?B?N004dC9tT001VVd1M3Btc2RPT3I5Z1NBN0hZZUJYMHdGWG1mZjhwSHFDUnRa?=
 =?utf-8?B?ZXJFdis5WGJqQXM0d2xBR0FEdmx0YnlOS3RyRk5mbnFjVVJoNXlaTmIxMERt?=
 =?utf-8?B?eHl3SDhTVFdJK1RVd1cwb21aSEN4VWdVeDJQaVVJeVpLbkFVdDkxcng2RXBD?=
 =?utf-8?B?eXZISnhkakhXRUFkWnJlWW1POHNaZ2hOSWdocGJWV3R4dTV0b285ZjVXM3lN?=
 =?utf-8?B?ZWZPbjAxeEVqSFlHaUNza1JzcUhXR3lTbWlYaXNsVmk4MzVRMytjaTQzU0Fn?=
 =?utf-8?B?eWt4MTJEZXlBV1pzaEFMOHhFQ3dKZUVpdHNOdVBVeTdMcEZFOXBSM0Z5cnU0?=
 =?utf-8?B?Y2lxdkRUUkM3RVN5NlhHL045SEV5eUw1U3kzK0FVNkp2NjhDNFFMcXU2RzNR?=
 =?utf-8?B?dGNlS0xIU1IzUEIzbFVjTm5OQ0lJeW1UR081NWRVWkZNbWhJMVFTZ1kvdkJQ?=
 =?utf-8?B?eUhWak5MeVJ6ZFpMMGI2Q2o1MDNydFhKQTNZQ0ZkVnhHS2JHUVJNR2lTM0Zs?=
 =?utf-8?B?aG1JWnNIcStZNnIwVkZ5anVHWFczaTVJaHBuODlJTGdETkFkczM3cWJtc3dh?=
 =?utf-8?B?cHVSa3A4bjBVeFI5aFBGQytNb1lLZ29RVnhlOC9CYjRjYkRIa3VKbUJ1Mmp1?=
 =?utf-8?B?WkN6NEt1Z1QyajJLOUJYTjg1NlpkZm0zVWFHcGxLanE1ZHB2dnJVcnZGM3pk?=
 =?utf-8?B?ZTE4ZzdyeWRvazRUSGVZWmE5amJKVkgzUjZKOFpDenVmRi8waisyQ0FtRE04?=
 =?utf-8?B?aFBvR3Eway9vZEMvekJRYndFVUNyR0hkWTFndVdBNUg3cHpMUXRRN01ybTB3?=
 =?utf-8?B?b2ZOdGtSaXZoNlhGVWJzOUcrbTVZN2hvVjZpRlJoT2ptSWNhdEdxdWxsN3d3?=
 =?utf-8?B?UkptQ3NHSWlIcVdVS3J5emNLT1NtTHF5bFdMNmlKSDhPNk4wUmFhMEUwazQz?=
 =?utf-8?B?TUtrek5CUDVFZi9VRG5PQzVPaUtNREZJcGpjL3VTSjZNVnRLS2N2bWl3MThR?=
 =?utf-8?B?Q3ZBUHJ2a0I1U2pRVUxZM0ZaZ1lrNmJKUnRxZ2lyTUdaL2NiVUpzYjNFait2?=
 =?utf-8?B?Z2V0YkZuUEVqTXRoMTNLT2F3S3JhQmhoMGdyUlVQT2RaM1VndGtVZ3dyd0ow?=
 =?utf-8?B?bVNPWlRLSlJGV1dJdE5tTUpMNWxJaDcvajNSMHU1NFdSMzNIeWhTQnY5eDN2?=
 =?utf-8?B?RDBqbWdMSHFNYy9sZHZsYktVVE9kc0hYY1MwVSs4KzUrcjJ0em9EeE0wNXpj?=
 =?utf-8?B?TW80V3RZMkVmUGRKTUkwVVRkaW0vcHY1VXRQY0hpQWVsUzRKbTJIektwNnJ2?=
 =?utf-8?B?MnR5MkNtdFVSVVhYS2ZvRUUyY01SM05kUytvZXpkOGVXZU1YTnRldDZQbE9T?=
 =?utf-8?B?ODBZZXEybzJGVjNGcVdaamVITFNVOGZpRmlId08xNXNPTURJOURVM0Q4QmJh?=
 =?utf-8?B?NEdwTVBtamhZbkVLYjhuWHlwY0lybldSSm9aUkI1UXdWOUxoczAyaW56am9s?=
 =?utf-8?B?RnowNERhZzNHeStCb3R6UjFUdGpHSlQ5aDZ6TDc0MWZNSXdHOC84RlNZa2NV?=
 =?utf-8?B?NVhtbzJkcjBySXdoN2lxMzMwNnlmM1RuN3RhdFVTOWFOTFA2R1pubElmN1pF?=
 =?utf-8?B?UGFSaEtZSXRSTG5YOGI3SkFHVlRhS1oyQndZT1RDbXhpVllMTDNBZERIYU5Y?=
 =?utf-8?B?cjZOY0JMbzVuL09TL045a01rbWF5SGtDa1AyL1dZTDBTM2xmQmFvQi9MN1Iw?=
 =?utf-8?B?eTZqRmduM0tyZHhnT3pBL016M1A2MWptRnUzZW5EU3FJRXFJaU50dTd2KzJ4?=
 =?utf-8?B?K0dFcEJoYnY0QzcvRGJSUU9jNmI2V2JnbFplbFdsS25RUlIvVXVLQkNXOHJG?=
 =?utf-8?B?cjFleXdQUXZvZnUrS0s2MlVjcENCTDJUU2Z1VGU1VW1vaU1LWGx2Q2tqWWxv?=
 =?utf-8?B?NGZlL3RSMTJFWFJmZGwwY3QwWk9NS3VmL1RXc0xKNVJzdVJWSnRMNldSSFBi?=
 =?utf-8?Q?Ou47ZUQSWaVMRp/nDBS9keO0v?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A385F7222B4BAC40BABEE0DFB865A604@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR05MB3571
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQpOb3RlOiBDb3JyZWN0ZWQgdGhlIFN1YmplY3QuDQoNCj4g77u/T24gMDcvMDkvMjIsIDg6NTAg
UE0sICJWaXRhbHkgS3V6bmV0c292IiA8dmt1em5ldHNAcmVkaGF0LmNvbT4gd3JvdGU6DQo+DQo+
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvcGNpL2NvbW1vbi5jIGIvYXJjaC94ODYvcGNpL2NvbW1v
bi5jDQo+PiBpbmRleCBkZGI3OTg2Li4xZTVhOGY3IDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYv
cGNpL2NvbW1vbi5jDQo+PiArKysgYi9hcmNoL3g4Ni9wY2kvY29tbW9uLmMNCj4+IEBAIC0yMCw2
ICsyMCw3IEBADQo+PiAgI2luY2x1ZGUgPGFzbS9wY2lfeDg2Lmg+DQo+PiAgI2luY2x1ZGUgPGFz
bS9zZXR1cC5oPg0KPj4gICNpbmNsdWRlIDxhc20vaXJxZG9tYWluLmg+DQo+PiArI2luY2x1ZGUg
PGFzbS9oeXBlcnZpc29yLmg+DQo+Pg0KPj4gIHVuc2lnbmVkIGludCBwY2lfcHJvYmUgPSBQQ0lf
UFJPQkVfQklPUyB8IFBDSV9QUk9CRV9DT05GMSB8IFBDSV9QUk9CRV9DT05GMiB8DQo+PiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBQQ0lfUFJPQkVfTU1DT05GOw0KPj4gQEAgLTU3LDE0
ICs1OCw1OCBAQCBpbnQgcmF3X3BjaV93cml0ZSh1bnNpZ25lZCBpbnQgZG9tYWluLCB1bnNpZ25l
ZCBpbnQgYnVzLCB1bnNpZ25lZCBpbnQgZGV2Zm4sDQo+PiAgICAgICByZXR1cm4gLUVJTlZBTDsN
Cj4+ICB9DQo+Pg0KPj4gKyNpZmRlZiBDT05GSUdfSFlQRVJWSVNPUl9HVUVTVA0KPj4gK3N0YXRp
YyBpbnQgdm1fcmF3X3BjaV9yZWFkKHVuc2lnbmVkIGludCBkb21haW4sIHVuc2lnbmVkIGludCBi
dXMsIHVuc2lnbmVkIGludCBkZXZmbiwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBpbnQgcmVnLCBpbnQgbGVuLCB1MzIgKnZhbCkNCj4+ICt7DQo+PiAr
ICAgICBpZiAocmF3X3BjaV9leHRfb3BzKQ0KPj4gKyAgICAgICAgICAgICByZXR1cm4gcmF3X3Bj
aV9leHRfb3BzLT5yZWFkKGRvbWFpbiwgYnVzLCBkZXZmbiwgcmVnLCBsZW4sIHZhbCk7DQo+PiAr
ICAgICBpZiAoZG9tYWluID09IDAgJiYgcmVnIDwgMjU2ICYmIHJhd19wY2lfb3BzKQ0KPj4gKyAg
ICAgICAgICAgICByZXR1cm4gcmF3X3BjaV9vcHMtPnJlYWQoZG9tYWluLCBidXMsIGRldmZuLCBy
ZWcsIGxlbiwgdmFsKTsNCj4+ICsgICAgIHJldHVybiAtRUlOVkFMOw0KPj4gK30NCj4+ICsNCj4+
ICtzdGF0aWMgaW50IHZtX3Jhd19wY2lfd3JpdGUodW5zaWduZWQgaW50IGRvbWFpbiwgdW5zaWdu
ZWQgaW50IGJ1cywgdW5zaWduZWQgaW50IGRldmZuLA0KPj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGludCByZWcsIGludCBsZW4sIHUzMiB2YWwpDQo+PiAr
ew0KPj4gKyAgICAgaWYgKHJhd19wY2lfZXh0X29wcykNCj4+ICsgICAgICAgICAgICAgcmV0dXJu
IHJhd19wY2lfZXh0X29wcy0+d3JpdGUoZG9tYWluLCBidXMsIGRldmZuLCByZWcsIGxlbiwgdmFs
KTsNCj4+ICsgICAgIGlmIChkb21haW4gPT0gMCAmJiByZWcgPCAyNTYgJiYgcmF3X3BjaV9vcHMp
DQo+PiArICAgICAgICAgICAgIHJldHVybiByYXdfcGNpX29wcy0+d3JpdGUoZG9tYWluLCBidXMs
IGRldmZuLCByZWcsIGxlbiwgdmFsKTsNCj4+ICsgICAgIHJldHVybiAtRUlOVkFMOw0KPj4gK30N
Cj4NCj4gVGhlc2UgbG9vayBleGFjdGx5IGxpa2UgcmF3X3BjaV9yZWFkKCkvcmF3X3BjaV93cml0
ZSgpIGJ1dCB3aXRoIGludmVydGVkDQo+IHByaW9yaXR5LiBXZSBjb3VsZCd2ZSBhZGRlZCBhIHBh
cmFtZXRlciBidXQgdG8gYmUgbW9yZSBmbGV4aWJsZSwgSSdkDQo+IHN1Z2dlc3Qgd2UgYWRkIGEg
J3ByaW9yaXR5JyBmaWVsZCB0byAnc3RydWN0IHBjaV9yYXdfb3BzJyBhbmQgbWFrZQ0KPiByYXdf
cGNpX3JlYWQoKS9yYXdfcGNpX3dyaXRlKCkgY2hlY2sgaXQgYmVmb3JlIGRlY2lkaW5nIHdoYXQg
dG8gdXNlDQo+IGZpcnN0LiBUbyBiZSBvbiB0aGUgc2FmZSBzaWRlLCB5b3UgY2FuIGxlYXZlIHJh
d19wY2lfb3BzJ3MgcHJpb3JpdHkNCj4gaGlnaGVyIHRoYW4gcmF3X3BjaV9leHRfb3BzJ3MgYnkg
ZGVmYXVsdCBhbmQgb25seSB0d2VhayBpdCBpbg0KPiBhcmNoL3g4Ni9rZXJuZWwvY3B1L3Ztd2Fy
ZS5jDQoNClRoYW5rcyBWaXRhbHkgZm9yIHlvdXIgcmVzcG9uc2UuDQoNCjEuIHdlIGhhdmUgbXVs
dGlwbGUgb2JqZWN0cyBvZiBzdHJ1Y3QgcGNpX3Jhd19vcHMsIDIuIGFkZGluZyAncHJpb3JpdHkn
IGZpZWxkIHRvIHN0cnVjdCBwY2lfcmF3X29wcw0KZG9lc24ndCBzZWVtcyB0byBiZSBhcHByb3By
aWF0ZSBhcyBuZWVkIHRvIHRha2UgZGVjaXNpb24gd2hpY2ggb2JqZWN0IG9mIHN0cnVjdCBwY2lf
cmF3X29wcyBoYXMNCnRvIGJlIHVzZWQsIG5vdCBzb21ldGhpbmcgd2l0aC1pbiBzdHJ1Y3QgcGNp
X3Jhd19vcHMuDQoNCkl0J3MgYSBnZW5lcmljIHNvbHV0aW9uIGZvciBhbGwgaHlwZXJ2aXNvciAo
c29ycnkgZm9yIGVhcmxpZXIgd3JvbmcgU3ViamVjdCksIG5vdCBzcGVjaWZpYyB0byBWTXdhcmUu
DQoNCkZ1cnRoZXIgbG9va2luZyBmb3IgZmVlZGJhY2sgaWYgaXQncyBpbXBhY3RpbmcgdG8gYW55
IGh5cGVydmlzb3IuDQoNCi1BamF5IA0KDQoNCg0K
