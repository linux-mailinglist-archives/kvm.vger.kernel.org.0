Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30D26E0DF8
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 15:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjDMNFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 09:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjDMNFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 09:05:42 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1CF6A42;
        Thu, 13 Apr 2023 06:05:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMkASc0+lmWP1mEwKjMJcHGmHzzOtX0aHOsXXsHInCunzwfUiaibry42v0VS5cIqUCDSNl6GZuzOrg0yfOJ/dPGBfMy8aekbSgGNjWscdClWhC0QmUGUi3gVuIOQixCqG+vHbBbmx7VuVjxJKwccV8W2YktOIX2VvCcN3XJh/GLNIuNbr4pADutvw/dnOXo0o9SsJPXE+MGHcKdewoeG5ytkaqbdLNvEEKTW48iswXxFvL94LwAF04vhHQoGR6nYj26jX02O1iVAhr8cA8YU/TOVqDPX/2BX4E0gPZwQQQeJQBi+NtCqntgGu1VyfcKrOYJX9fEOc2LqVaS+8ffqSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrg3Y4p71gp1mteG59Y/PeyU2gziFtLrEUuIPIrECgI=;
 b=PYvvRryAZyLbLYEgpsGafsm7CvOsocsG+6v8IKw9dN/PeiaLBH5FQ7QdRyZpXKdzSF56nHjQ49KTOj9RdEkukPwwDtOJOPyTe5vnpw7raSceoXLzeR7qc4tvjuPvX5fhrSkfclvyYArw3yNaW0amAZl1AggkvQn/HXPeEV+HJDe5PFExj9oCSvdB7ojPUkXsCp/dGSIpTzXvymDQwAg/rmJY8Mv2iID9DGaNjDC4EO4fr+pZhzsqAz5ZA3vxroA4qvSrpz1FmfPxryV5KZ49BQIq59LptJKzQS3GoZRVwIx1A6I1jbabnHgPLnXEIBcB6gL/Vzp3Xiag2HxbL+AKdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrg3Y4p71gp1mteG59Y/PeyU2gziFtLrEUuIPIrECgI=;
 b=3pkfNOzTOVPMEhnTtqa8qdqnRrgnWnjnweGInGOda3tLWL8CXy56DvcmJ/Ejzk5nt0hbkzCRtAEFPTVggaT6Byd1WIbP2dC+AI/oHuNbDjj5SuIPODTZ7r20DL4dJFbsv0jRbLnCSrZpRXYdBJsePXnKPWyVJI5BqU7OR4i2Gz0=
Received: from DS7PR12MB8322.namprd12.prod.outlook.com (2603:10b6:8:ec::20) by
 SJ2PR12MB7800.namprd12.prod.outlook.com (2603:10b6:a03:4c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 13:05:35 +0000
Received: from DS7PR12MB8322.namprd12.prod.outlook.com
 ([fe80::4c72:689e:3319:5cc]) by DS7PR12MB8322.namprd12.prod.outlook.com
 ([fe80::4c72:689e:3319:5cc%7]) with mapi id 15.20.6277.042; Thu, 13 Apr 2023
 13:05:35 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Jansen Van Vuuren, Pieter" <pieter.jansen-van-vuuren@amd.com>,
        "okaya@kernel.org" <okaya@kernel.org>
Subject: RE: [PATCH] vfio/cdx: add support for CDX bus
Thread-Topic: [PATCH] vfio/cdx: add support for CDX bus
Thread-Index: AQHZZjgu99pMGcPq7E+6pUQoMP4HuK8c24yAgAJ0lQCACe7dIA==
Date:   Thu, 13 Apr 2023 13:05:35 +0000
Message-ID: <DS7PR12MB8322000C7A4F92872BE035BDE8989@DS7PR12MB8322.namprd12.prod.outlook.com>
References: <20230403142525.29494-1-nipun.gupta@amd.com>
 <ZC2U0/v0toRVSWhf@ziepe.ca> <74b2dad2-1165-9509-111a-48407e2a1319@amd.com>
In-Reply-To: <74b2dad2-1165-9509-111a-48407e2a1319@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_ActionId=e125449e-5062-4746-9faa-e330efa9398a;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_ContentBits=0;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Enabled=true;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Method=Privileged;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Name=Non-Business-AIP
 2.0;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_SetDate=2023-04-13T12:44:55Z;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR12MB8322:EE_|SJ2PR12MB7800:EE_
x-ms-office365-filtering-correlation-id: 3ad7ed3d-154a-48bd-53c6-08db3c1fc508
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mPXyKlto6UaJc+m8mtfiBTzXUCUCCKPk9gzIaO+Vs0Ep+t9aL141l0qbXFAK7MHVytmWD6peCeHb4bJpls14ZRP4FZSCDPmN1mWAt1l5mI5cFqTA7eX3WrRfafeFZR5Cpdiomp+S+vhAcjWVJx8CnikNPGVpBBzQaBZnNBcVr8CTIPLmJvhjgoqcprGh7Bk4GtRbZTx/cnmmBN/KwvQIcln467eonxkpM2MAdzlCA/HdhQnyODx3hNCqVD+I3aZDvqGznYrkhPS/t2Yr7nPwjIA7KO6bsDL0gb57Z0PfvlHRlUPXUpXQ7OH/aHOyweBpj1uaLchnaODL+iSuwtlM4t9dSnjlMNrrKYC0MC5CSkeii5a/Csh3ffjfuAWe4lJUEMcSKy5Wp1AgN1oUyz1k9GlQ+QEo6Q+3cjA0GQfDkWTgbT2g+4P2Qu5+fl6bBTnHaHR3UqU8PpwPvliJdxig1Xo8ZZmgCVHR1n7FXNgOQ46Y+LkUoocLIAkyhB3tJDe2Gg0jYWSMOxH5GG4GJsHZgkORpHq8mP4a/+76vkrFVuuKz3BG4upPJdXr/qDfDMlCQjUCD0haRV9qCa4dMV93BnOSG/uHUrgi1IsGNkx4es5duuspLpJiYEw3Eu9ZxbGX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(71200400001)(7696005)(6916009)(64756008)(66446008)(66476007)(66556008)(66946007)(4326008)(76116006)(2906002)(38070700005)(86362001)(122000001)(41300700001)(33656002)(5660300002)(52536014)(8676002)(8936002)(316002)(38100700002)(478600001)(55016003)(54906003)(53546011)(9686003)(6506007)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXNjNmM1d0ptTUhGUVdHN24xdTc2NnQyS2FGUklKZTgxZWxiUXZjZ1IzeEJY?=
 =?utf-8?B?KzlXd3NVVUQvdFZxc1Rmb2dFK2o5dDUyMkNVRmw1anphcUcySVZGY1ZvbDh3?=
 =?utf-8?B?MUVtbGtndXNXaVBZb0dlMnMrZ0NDclJzODhZZ0RPRkdQaHN1YlUyMmpSTkdv?=
 =?utf-8?B?NHU5Y1JRR1RLVC9LcGdBanFBbU1VY3JHVmwweWJBSWFKZi9ub1VhM0cyNGIr?=
 =?utf-8?B?b2pQc3VQc2lDcTR6VlJ0SnJFQjhNd0I4TFNqVmM1M1BvZnB1VmZacTNsM0JN?=
 =?utf-8?B?MEN3NE9FTkRVQi9sQTdrQk9CWUFkUkhLRzdNdGdyU0VVVmV4eXVWdzl2K0tH?=
 =?utf-8?B?dmN1KzFzbGhTL0NrbWV2Qm1QWW5ua00rU3JQd09ZSGw4eTFTOGcyMjA1bStH?=
 =?utf-8?B?emRJWGZBTDdQeWZTNzZENlZhQ05UcHFJbzB0K1V4TWFGR1ZnUFg0SFNLeC9y?=
 =?utf-8?B?N1BwalZsQzU4N0E1eGcrczk4YVB6dCszR3RJT1g5MmRadXJmM0VxNitPVzl6?=
 =?utf-8?B?ZTVRbnBNd2FTRzc3WlVhS2J5RXFQQ2FyWDQ4V0VsLzV0S2lkZ3FubXBEZ3Ux?=
 =?utf-8?B?MjUvQzBLVDIyZmJ2eE1BMGNSRGpjdHdVV2N6aEZzRUorWWh3RG5BaDUrTFR5?=
 =?utf-8?B?TTBxOWpCZXp5enJKU0ZSOTJLLzRZNnNOVnAwVFh3ekg1ZGsvWDFDZUI0YnZM?=
 =?utf-8?B?QWxlQVJhd2lhN3pLbEJRN05nTEsva3VTQnh1N1VmSzNTbXI4RTJvdjFteGdX?=
 =?utf-8?B?WUxKdFpscTlhUlVMNjV1VzZob0lnMC9zWkRLMXpoRVcrcllEbnVFTFhOUnZw?=
 =?utf-8?B?V1l2YUswMnVGR2NQdno4ckIrWEcvYmlGM2NCN21mZ0NDdjcvdVo5a0QvVnBH?=
 =?utf-8?B?WlNVcVlCcXYvZlZBZmV1TWdoUktuNzFPN1UzWDF6YlU5dGZER0pkTkJJZXJy?=
 =?utf-8?B?M0gzNkFPWEt5NmorcUJLUVkrWXhJYS9CYVY1YmRQQUFkYlpBNWRZalZyOUR3?=
 =?utf-8?B?NXMrckRmRmZPbkZpQzJaemM2OGtITTRKdUJ1bWV0VUE4ZjF1VDkzT3JraVpD?=
 =?utf-8?B?aWUyL3JnemtaVzdsdFB1bkdZckNPdXhBQm5nalE0RmYzT3Fwd1JwSHAxUkJt?=
 =?utf-8?B?Ui9tZWZVN3RxZFBKVE1jbEtZbCttaVFVWUxBMEwxczBFdXpnNm5iWlYxN0NK?=
 =?utf-8?B?cDNUY3pibnJuM3FPdmpyTEJjV29VTG5XTHk1N1oyRFJmeGRmZ2MwNmVteDFp?=
 =?utf-8?B?WHRiYjRoN0haZzFpSmhxWnVHdWlmQTg5QUFjcEVkOHNoRzg3cFFyQkpVcWsv?=
 =?utf-8?B?RUhXZmdsY1U1azVVWTM1UHI3T3Bmc0Y0VFRNejA0amRlY1R3eklGVWU3NjN1?=
 =?utf-8?B?ZWNJaTJaN1pScDF3TlltR2p4WUM1ekRBaFF1b2ZNNnlGUnhPZ0JTdEI0aFM4?=
 =?utf-8?B?WStPT0lkWGEwdjlsVVZsc0FUMzB2V0k4Z2NabFYrTmRaUjk2RWtFcFZzNjh4?=
 =?utf-8?B?dEtVU09LNFhXVTR1a2QzSTVWRDZuSkg5VHJGcmNCLzhucTRycWkxdDhTdjMy?=
 =?utf-8?B?Q3lHZ0FWY0dnRGlxSms1VlhDT0h6VDFqcW9iaGwweTdOUFBiU0ppcVIvZHk5?=
 =?utf-8?B?a0pDY2w4UGFsV0JQQnQyaUord3I0S1gyQ082Nno0eVNjK25Ma3BPdmtUeWxC?=
 =?utf-8?B?TmpNRXRWcGlhekxRYlVSVWVOcUM5YTdRNm91ZklOSFVyeU5aSEJUcXNRZkYx?=
 =?utf-8?B?SnFrdDFyMFoyeFQ1T2thSUxQbmttbG5Sdkp2ZE9SUHVuc1l0Vkl6cEhYNHhG?=
 =?utf-8?B?QzUvNlpzNnZ5UWszanlPT01XZUQvS0lIeVNUTm8zRUxmVG1KNzdwTm4vUHdJ?=
 =?utf-8?B?SkVXOWhUcWd1U0hpSUN2dzFOT2djQ0lQTFJOR0JlUXhkS2o4MkgzZ1JsZE5T?=
 =?utf-8?B?bWhHTmNkcHBrUzR0UGlWK3p5MUdKcE56SkdLT3ZZYzlGRzFQOWhLTUNvWCto?=
 =?utf-8?B?TE9zdG5RM2t0UUpnUzFkY1dmSWZuTDBvK3E3djJhcFRMaXJNb0ZhZnZBZE9j?=
 =?utf-8?B?dloxK216QWcwdzVGRWpDU05jSU0xWU9Wc2dTTEJWME5yWVkwL0NUcVhpRlZE?=
 =?utf-8?Q?qqmo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad7ed3d-154a-48bd-53c6-08db3c1fc508
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 13:05:35.0304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ke0jmh/bSojfsfUh6qn0/XvE3/0BlHFaj5qXo8SpY5ey2FgTzJN1GTi7yHEpCIrj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7800
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR3VwdGEsIE5pcHVuDQo+
IFNlbnQ6IEZyaWRheSwgQXByaWwgNywgMjAyMyAxMDozNSBBTQ0KPiBUbzogSmFzb24gR3VudGhv
cnBlIDxqZ2dAemllcGUuY2E+DQo+IENjOiBhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbTsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgZ2l0IChB
TUQtWGlsaW54KSA8Z2l0QGFtZC5jb20+OyBBbmFuZCwgSGFycHJlZXQNCj4gPGhhcnByZWV0LmFu
YW5kQGFtZC5jb20+OyBTaW1laywgTWljaGFsIDxtaWNoYWwuc2ltZWtAYW1kLmNvbT47DQo+IEFn
YXJ3YWwsIE5pa2hpbCA8bmlraGlsLmFnYXJ3YWxAYW1kLmNvbT47IEphbnNlbiBWYW4gVnV1cmVu
LCBQaWV0ZXINCj4gPHBpZXRlci5qYW5zZW4tdmFuLXZ1dXJlbkBhbWQuY29tPjsgb2theWFAa2Vy
bmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSB2ZmlvL2NkeDogYWRkIHN1cHBvcnQgZm9y
IENEWCBidXMNCj4gDQoNCjxzbmlwPg0KDQo+IA0KPiA+DQo+ID4+ICtzdGF0aWMgdm9pZCB2Zmlv
X2NkeF9jbG9zZV9kZXZpY2Uoc3RydWN0IHZmaW9fZGV2aWNlICpjb3JlX3ZkZXYpDQo+ID4+ICt7
DQo+ID4+ICsgICAgIHN0cnVjdCB2ZmlvX2NkeF9kZXZpY2UgKnZkZXYgPQ0KPiA+PiArICAgICAg
ICAgICAgIGNvbnRhaW5lcl9vZihjb3JlX3ZkZXYsIHN0cnVjdCB2ZmlvX2NkeF9kZXZpY2UsIHZk
ZXYpOw0KPiA+PiArICAgICBpbnQgcmV0Ow0KPiA+PiArDQo+ID4+ICsgICAgIHZmaW9fY2R4X3Jl
Z2lvbnNfY2xlYW51cCh2ZGV2KTsNCj4gPj4gKw0KPiA+PiArICAgICAvKiByZXNldCB0aGUgZGV2
aWNlIGJlZm9yZSBjbGVhbmluZyB1cCB0aGUgaW50ZXJydXB0cyAqLw0KPiA+PiArICAgICByZXQg
PSB2ZmlvX2NkeF9yZXNldF9kZXZpY2UodmRldik7DQo+ID4+ICsgICAgIGlmIChXQVJOX09OKHJl
dCkpDQo+ID4+ICsgICAgICAgICAgICAgZGV2X3dhcm4oY29yZV92ZGV2LT5kZXYsDQo+ID4+ICsg
ICAgICAgICAgICAgICAgICAgICAgIlZGSU9fQ0RYOiByZXNldCBkZXZpY2UgaGFzIGZhaWxlZCAo
JWQpXG4iLCByZXQpOw0KPiA+DQo+ID4gVGhpcyBpcyBwcmV0dHkgcHJvYmxlbWF0aWMuLiBpZiB0
aGUgcmVzZXQgY2FuIGZhaWwgdGhlIGRldmljZSBpcw0KPiA+IHJldHVybmVkIHRvIHRoZSBzeXN0
ZW0gaW4gYW4gdW5rbm93biBzdGF0ZSBhbmQgaXQgc2VlbXMgcHJldHR5IGxpa2VseQ0KPiA+IHRo
YXQgaXQgY2FuIGJlIGEgd2F5IHRvIGF0dGFjayB0aGUga2VybmVsLg0KPiANCj4gV2Ugd2lsbCB1
cGRhdGUgdGhlIGNvZGUgdG8gZGlzYWJsZSB0aGUgZGV2aWNlIGluIGNhc2Ugb2YgZmFpbHVyZXMu
DQoNCldlIGRvdWJsZSBjaGVja2VkIHdpdGggZmlybXdhcmUvaGFyZHdhcmUgdGVhbSwgd2hlbiBk
cml2ZXIgc2VuZHMgQ0RYDQpkZXZpY2UgcmVzZXQgY29tbWFuZCB0byBmaXJtd2FyZSwgaXQgYWN0
dWFsbHkgcXVpZXNjZSBhbmQgdGhlbiByZXNldCB0aGUgZGV2aWNlLg0KU28sIHRoZSBkZXZpY2Ug
cmVtYWlucyBkaXNhYmxlZCBpbiBjYXNlIG9mIGZhaWx1cmVzLg0KDQpSZWdhcmRzLA0KTmlwdW4N
Cg==
