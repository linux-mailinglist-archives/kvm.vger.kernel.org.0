Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF36E69B7CC
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 03:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBRCys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 21:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBRCyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 21:54:46 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021024.outbound.protection.outlook.com [52.101.57.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2236969297;
        Fri, 17 Feb 2023 18:54:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCkHATfcVLYKJoFwuqFKaNFr3cff7SWSV1JXGQI2rbP8F4jmdRJMr/Nl4seX/qb4e7YbI3iMpNV564ke7/hut8JK2pWve2+P1XXx6fUCKr/zb5Mad2u0QNvf6uwz5FnUBvyt9/gRFInlmDT8Hup74bkgNb2PuSpiPP0AaBTRk50cZrdc1AgaC6DAMkt3FzUx0cpjanEkoW8O1bPV+tBUZnryx3NEkkYo5faq25H7wXtLaICDohtotmt+OXprO0n5zArV7Hnw68mmgDRcQp3FClQstD7GwHSaBaPgVXT+PfqBpo7VE5iiPySZlK3H0GlFw3+9Qo8qdHjxo5muQnO7+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQpVpCuOQmpustvFDFM9G9GgAuR3/AU4nhx8R45MGoY=;
 b=bz/WZ019PgYBxBIIAu0RpAeO8N+FLelz2pFf3dVaydQgmSMkax6YQ06I2MliQ81xf4sO1Vcb9YUXstnZIZ5QS3onLS6X5R8bksNY8SugxfikFFlwUGlj5W/aaF4/eIAN+kNgTk45CagEIXogK1QVwxJgZDtQyYZCnyD5L+n+TCjmWeYMETtcQ0uSqNBnchwz8H7Ov9ewjNtkq2kv6zJktwPwpd00DGw2v53K4ktKw00XA/1GJMBoZZSV+2C2VSdAUIqwb7KYCtuCIh21Cb+QpV76I370GG5gklv7EByWyzSnQ++I7odypbzFGFZFm7IXnzF4ISDV00WTb4Vt+qMJZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQpVpCuOQmpustvFDFM9G9GgAuR3/AU4nhx8R45MGoY=;
 b=F85z6Dixtj3TBJukGL48u4v2JNQR3Lsq2o/PwPsH7oHH+THQt3RnQ5RqYr5LsXzsqJvX1HmxblrG26okp/RX1xpJwx4SLcFxQmVauPN80xGWIPYNhdan6isLNFUPbANPzpr1UmUfrnU7+dC2dmbZzf85xZMdQ5eXUygxNQlcgJE=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by LV2PR21MB3303.namprd21.prod.outlook.com (2603:10b6:408:14f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.6; Sat, 18 Feb
 2023 02:54:38 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::3747:daf4:7cc9:5ba2]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::3747:daf4:7cc9:5ba2%3]) with mapi id 15.20.6134.013; Sat, 18 Feb 2023
 02:54:37 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
CC:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "sandipan.das@amd.com" <sandipan.das@amd.com>,
        "Gupta, Pankaj" <pankaj.gupta@amd.com>,
        "ray.huang@amd.com" <ray.huang@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Does earlyprintk=ttyS0 work for an AMD SNP guest on KVM?
Thread-Topic: Does earlyprintk=ttyS0 work for an AMD SNP guest on KVM?
Thread-Index: AdlBv/2siHbGoHczQeyMVKtAUkBIZwAJxYmAABIBUjAAJ9tUgAAcDwZg
Date:   Sat, 18 Feb 2023 02:54:37 +0000
Message-ID: <SA1PR21MB13352DCAA7371B90CB8A637CBFA69@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <SA1PR21MB13359DBABC5625368E369A42BFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
 <20230216091431.GA10166@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <SA1PR21MB13358707043E2901958819AEBFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
 <e06d90cc-544b-5280-f8cd-b25684214b4a@linux.microsoft.com>
In-Reply-To: <e06d90cc-544b-5280-f8cd-b25684214b4a@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8c4a6c41-b57a-4645-8ee7-c521905b2604;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-18T02:14:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|LV2PR21MB3303:EE_
x-ms-office365-filtering-correlation-id: 6d6fb674-0db6-486c-def6-08db115b7949
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vwr7PAYRj+MHeM8FN+jfGyQoGJHcyYWnvbBsOK2iCwYOnf0IGTjUpx5apNPHxSLmmebzenJfFrutxxjCYwJWF6U74Oh5ucWheXBH4UciMRvD42kxXG4ofIXh98BDH9w2XWbYnYMdg6EV5bY7sIVnCmV9uvg2Mvy7qVg0uSurfjTelSM8G3dVyJbvo9GeyRAqJkBdv/0i9rBjEkhohS1nW9uhAIrc2utbTC/HFDDKR3UVHPWYMfcoo0WBsjQDx7rO+EfyoVFxL9s6r8dYSONsca25aHS204P2zk9OzoGDbgObsYW3SZAbZa4vlVXUa6N3EXMPaEi3AZ/8VSLqctlaTLkLw05mi6bru1KhwIgsn7W8POJGuwp2IBSg0hXRL/ueNO5BvmTopm+a0EYG7bKstPg4aoHx/2p0jnEL00yCfnzjtnz38htneD9/zmjeXZqm1JRIHGFIIYtr6T9Q+NtUT6dwbXIxKGAxhVEQM1ZfvrkPwaXNu/htM7oGO6m/eGEpv55dHeHWae0rEFcuE00lGvV8Lz+ERdDzORgGTcbQQPc+e8hi9L7TnRePH9DxWw0I3Qkdl/PwyGVcWNL+O/K8YpuL54fOKoyINbtw7jTVE6O+CvT2bhy91pm1/oNnqQMvjtO3zYzV/y+Lo+3MncSZdL88/oCVBehRP2UG9b6dh/fGrQ70zSqhjm4WcXXAOz9vGxqImYTU7UZo9IeXSx0lfS3MQJOpxYXTNUa0tv3bleTXcbZtY1/83rFxAp/bQYPW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199018)(26005)(9686003)(186003)(478600001)(7696005)(4326008)(66556008)(66476007)(66446008)(64756008)(8676002)(71200400001)(10290500003)(54906003)(53546011)(6506007)(76116006)(66946007)(316002)(52536014)(7416002)(82950400001)(82960400001)(5660300002)(41300700001)(8936002)(2906002)(6862004)(122000001)(38100700002)(8990500004)(38070700005)(86362001)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHc3SDZKaENnVi9SZGE0RStFMHo5VEh2emJubHJPK3JlSWFBYVBYK09XdnRn?=
 =?utf-8?B?clU4Nkc1dDduRWkzajcrbU9xeVNlVEIzZ3lhYVVjbUQ1a3JkdGxjZTB5ZG9S?=
 =?utf-8?B?eTg2RWNGVk9xbnIyVU9aUlhoVTJUQ2Yvb1dYV1JTdmRWSnZIY2RZZnMwYUxu?=
 =?utf-8?B?SHpjSDFVNVA1NHBlSVJnT2ZhN1BXUW1nd2gyenpZQmd6RmhWN0FILzU4OWRx?=
 =?utf-8?B?eXJqbTVtNUlkdCtHd3BzRnRlcEs5OXJpcjNFOTJjZ3Jpd0VlRXhpNDdqbEti?=
 =?utf-8?B?cTNrdmt1eUJCZXNHajA4TXBXbER3RnhKeVQ0NXk0VExHNTdpeXRtRHFuOVNj?=
 =?utf-8?B?K3NHcGxHWUp6d3VIQXNRcGtPRGZ0V096emRDdVozSW5IOVdlOXpnd2RqYWJB?=
 =?utf-8?B?Y05UaVJzczFGWTNOdTltY1BEZWpVTDMyeXVQcllTT2s5dlArRHJEV2xXemN4?=
 =?utf-8?B?Qm91OXltekMvTWcwNjJlRHdnaFNwcFNWQXFtNXI5eTR6cWlhUkVkTHBteDN2?=
 =?utf-8?B?VnFVWVFRdVlXUHM5SjNjNTNuemo4cnhIc29DWHJqcGJRcENuTU9NWituM0ht?=
 =?utf-8?B?anYvK1BuNTI3NUJ4emVYcnRmNndudGlzTEt2UEZ3bzlJdGQ2Sk92ZzE4WmJY?=
 =?utf-8?B?VWp5eDNJeU43NmN1OVQzWFRYRmREZnRoSjB0V1kvRS9zNm1HQTZ0RFJ2aS9w?=
 =?utf-8?B?TjlUTkFRS0ZqQ3FTcEdJQjRKNytCdnRpQmRUMzU1ZUJqZHA1WVhJT0k0bjRM?=
 =?utf-8?B?VnJtdThZR0M5WmtpR21hN2QxWG5YVWpuUVFOY29HRXkvODltRjdqNk92aVVm?=
 =?utf-8?B?VmlnS2dTZENqTkkreWs3ZzF4bzR1SlpldU9SSlZBTEF6ZEVWWThyUWlnTlJI?=
 =?utf-8?B?TDNscWE5bS85Vi9TRUJVQW1XaWpxN3I1K1V0SHNNeGNGbmszQlpsSmdQYldF?=
 =?utf-8?B?VUNHcmdhNXgrNGNiQUpyN0NKeG5JN1h2a0Y3OElIbFk1RHNBTUVIL29mVk1Z?=
 =?utf-8?B?TTBaMVdXU2Rsd3ZVdHZ6OHRWSWRiRDBKQU51KzFvNWJiYlpWMlZaYmlZU1ZS?=
 =?utf-8?B?SXpDbU51TU9OZjdyb1kzYzB6UDZodlBmdDN1d091ajg1azU3aDdhYW1SakRr?=
 =?utf-8?B?M1M1UWhBWndSMDl2RThhVmJYSWRzS2lZa2lIZlFsMitsUzFHUmc3OXJsc0Rq?=
 =?utf-8?B?dU1jWFZHRkxrTWxqTjN4eEJoSXJNQnpnMHZud2xpRDR2M2R3YVM5VkxVSnpw?=
 =?utf-8?B?b20rZXppK1gxaTgvMWZFdDkyOWo1V2VSKzhiNmRMVTFCTDFuTUZuaUl6YTFm?=
 =?utf-8?B?QVBPY2ltcXp6T2c3Q2pBa3d5NGtjcDZ0cXNweHpRaVFPRGR4QkdVanRseS9H?=
 =?utf-8?B?R0pBdmVDNkFGamFPNWQ5T1BsRElmeWIwV3VDVitOU2MwWXE5Ui95aXRybWs4?=
 =?utf-8?B?ZERtSmJhVU55T1BreGJOMXZlSmZvU1JFaUhZTWl1MlVMRWp5eDVGZWM0cFZ1?=
 =?utf-8?B?SEhrREMwYW9yRzdqOTV1QUp2a0NsaXZWTjBEcGZNUDJLNDBudko5akZHbWhy?=
 =?utf-8?B?bHpzMnNvU3c0N1NCbFRNZE8xWFhqb1pKWlpzaHEyQTdla2hiSXVYUm80MXVa?=
 =?utf-8?B?MkVUTHJIeXF2akZlaHova1VFSkpUQkxPZFRiL2o0S29JRDlBME9aMTRYeEJK?=
 =?utf-8?B?ZGN5MzRmbHQvUU4rUTdvK0xzOENWNXJYQUNTNDFLT0h1cFdmbUtYTDVvRUVM?=
 =?utf-8?B?MjNyMXFGelNFeCs3OW1EczhIek9xcGQ1b0xBK2Z5OXF2OXd4WG9RWXdodk5h?=
 =?utf-8?B?Ui96UTJnc0ZVaFM5cTFkcm9jTGllL1RVbDFnNmJhVVpxbWtXQzU2RzZnM1h4?=
 =?utf-8?B?T05ySWczdDd3VnFtN05YQm80NnB2RHMzT3d1dEJIcHY5UTRJOU5tVE15OXI3?=
 =?utf-8?B?eXo0YjdTNk93a0tvS3N0ME9lUUdnZnptU2xiMjd3R1pTc1JBSGYzc1lzWkVv?=
 =?utf-8?B?Uk9ZdjZhZlQwUmtLaHZaSDd6WWRZSmlVcVFVQkpxc1Nickdzd1l2aVBkdkEr?=
 =?utf-8?B?RWV3STQ0c3RVS2wrQjNGTWtPTVFzQTJpVlJKcEEvcmdUdmhLeGRva0I0Qytu?=
 =?utf-8?Q?Ns92dyJQQgPDKnZ1YYBxWhnW8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d6fb674-0db6-486c-def6-08db115b7949
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2023 02:54:37.7169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iey+ZKVKQZoStsThfEpmg65+yUWAku8hlEYEcSP52QjRUuQ/jdjHwNLKVQl7J0X6f+6un/RFzPM66osHtkvnWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3303
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKZXJlbWkgUGlvdHJvd3NraSA8anBpb3Ryb3dza2lAbGludXgubWljcm9zb2Z0LmNv
bT4NCj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAxNywgMjAyMyA0OjUxIEFNDQo+IFRvOiBEZXh1
YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPg0KPiA+IFsuLi5dDQo+ID4gVGhlIGNvbW1lbnQg
YmVmb3JlIHRoZSBmaXJzdCBicmFuY2ggc2F5czoNCj4gPiAgIE9uIDQtbGV2ZWwgcGFnaW5nLCBw
NGRfb2Zmc2V0KHRvcF9sZXZlbF9wZ3QsIDApIGlzIGVxdWFsIHRvICd0b3BfbGV2ZWxfcGd0Jy4N
Cj4gPg0KPiA+IElJVUMgdGhpcyBtZWFucyAndG9wX2xldmVsX3BndCcgaXMgZXF1YWwgdG8gJ19w
Z3RhYmxlJz8gaS5lLiB3aXRob3V0DQo+ID4gQ09ORklHX1JBTkRPTUlaRV9CQVNFLCBwZ3RfZGF0
YS5wZ3RfYnVmX3NpemUgc2hvdWxkIGJlIDAuDQo+ID4NCj4gPiBOb3Qgc3VyZSB3aHkgaXQncyBu
b3QgZ2V0dGluZyBpbnRvIHRoZSBmaXJzdCBicmFuY2ggZm9yIHlvdS4NCj4gDQo+IFNvcnJ5LCBJ
IGdvdCB0d28gdGhpbmdzIGNvbmZ1c2VkIGhlcmUuIFRoZSByZWxldmFudCBwYXJ0IG9mIHRoZSBj
b21tZW50IGlzIHRoaXM6DQo+ICJJZiB3ZSBjYW1lIGhlcmUgdmlhIHN0YXJ0dXBfMzIoKSwgY3Iz
IHdpbGwgYmUgX3BndGFibGUgYWxyZWFkeSIuDQo+IA0KPiBCb290aW5nIGEgKG5vbi1TTlApIGd1
ZXN0IHZpYSBCSU9TIEkgZW5kIHVwIGluIHRoZSBmaXJzdCBicmFuY2guIFVwc3RyZWFtIFNOUA0K
PiBzdXBwb3J0IHJlcXVpcmVzIE9WTUYgKFVFRkkpIHNvIHdlJ2xsIGFsd2F5cyByZWFjaCB0aGUg
a2VybmVsIGluIDY0LWJpdCBtb2RlDQo+IChzdGFydHVwXzY0PyksIGFuZCBlbmQgdXAgaW4gdGhl
IHNlY29uZCBicmFuY2guDQo+IA0KPiBKZXJlbWkNCg0KSGVyZSBJJ20gcnVubmluZyBhIEMtYml0
IG1vZGUgU05QIGd1ZXN0IG9uIEh5cGVyLVYgdmlhICJkaXJlY3QtYm9vdCIgKGkuZS4gDQpJIHJ1
biBTZXQtVk1GaXJtd2FyZSB0byB0ZWxsIEh5cGVyLVYgdG8gYm9vdCB0aGUga2VybmVsIGRpcmVj
dGx5IHdpdGhvdXQNClVFRkkpLiBMb29rcyBsaWtlIGFyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9o
ZWFkXzY0LlM6IHN0YXJ0dXBfMzIgcnVucw0KZmlyc3QgYW5kIGNhbGxzIHN0YXJ0dXBfNjQgbGF0
ZXIgKD8pIFRoaXMgbWlnaHQgZXhwbGFpbiB3aHkgSSdtIGdldHRpbmcgaW50bw0KdGhlIGZpcnN0
IGJyYW5jaCwgd2hpY2ggSSBob3BlIGNvdWxkIGJlIGZpeGVkIGJ5IHNvbWVvbmUuLi4NCg==
