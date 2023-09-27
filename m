Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585C77AF84E
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 04:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbjI0Cu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 22:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbjI0Cs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 22:48:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0924572BA
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 19:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695780984; x=1727316984;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rMqQrXcvWUZHXKchK6qkpxb7E+mUwkun21yp6VA+6iM=;
  b=YOwvyix2vd7/Vo+WrE6EZNuvw8QQFbktK7AKz7GpASC7MFhSouIxaDsg
   GErJ7joENi9Rns9isZWP1fjdZgj14iTqRj9NSsBbkOJrRnBj4tASJQDxY
   Ck4dSXvShO8PcIa8jTh/13hDlBa6diYiGwR8MYm8RVT5cekZPmnJ3BB4A
   KYsKcF52QJ2ip5i9sPVbUBGoXE1akpG6I5bnpnpOfJO3B1nyMaNq8Ddsl
   SRNoqJkfSwiahJhpMFYwXRW7LAUHMqY9ehGrJgYUyP6eutQ/aq7UxKe5x
   1IqweUs79Wio5nhXROQSzDnBT4bo66aho0Y6g7eBhfNLFdH9mkWQvw2I8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="381610843"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="381610843"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 19:16:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="864615372"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="864615372"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Sep 2023 19:16:24 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 26 Sep 2023 19:16:23 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 26 Sep 2023 19:16:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 26 Sep 2023 19:16:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 26 Sep 2023 19:16:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibG211E5l2qVJ0MVhQQi/sbrONOncJhyE6IiEckdPigUocze+Wvc8TP5s1iiXroavLBsK65nr/W73nhqZTkxbUf9EVjcnuZvuPbVVqMXbNqtzlB2Hzlq3L8nEwPLHuX4q6KJHxexshke0JDmcMjS/GrQmCC8l66yxrhkcjmrwYkyyk4EIVnyr1ruF732sOgq2DX1dJkfI50TEuZoX8noKwmhCo2nuqeIQrYNLv3KZiIBE1vFugTczzf6cYWigTPaKqqWvh6vGKZoSvT5u/PyQvoPTExpur291i0EufOaogmCICMAacdmDWt8zB6AKsxF4Bu1qiYRpUGkqf9J03W8AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMqQrXcvWUZHXKchK6qkpxb7E+mUwkun21yp6VA+6iM=;
 b=fVuvSN33m0b8nQouiatWS9ecJycD+PZ/NEZa6878Htv9+JJf5AXz+VxDThV1Q4CSRtsRLT8BXtCAlHe/buF8qo29YZdW/Fn3dsm1JAiSPA3Mqh5N3Yi/c/yBTjOB2c/C/e0BJY1mpnQUGL534MxPyhnBRKekWSSf3kKnNkj1phKBwSE/dUwC1GaRr1usFJu2y0J6dn4Wws1f1NUZoB1RqTNy4chw2eS0YKBU4l5nnUxwDW9Ld+t7oYUnaXdtvPVa47CGnbu20IdvPLqD3i0Slk1KG0qIePaNr7DvvIAuhEyOBF4pAO9RVufxEINUnkmYL+HQQx0tcQjjU1VQoCIJfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by SN7PR11MB8041.namprd11.prod.outlook.com (2603:10b6:806:2ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.21; Wed, 27 Sep
 2023 02:16:13 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::4e4:7eee:356e:cfb7]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::4e4:7eee:356e:cfb7%6]) with mapi id 15.20.6813.017; Wed, 27 Sep 2023
 02:16:13 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Liang, Kan" <kan.liang@intel.com>
Subject: RE: [PATCH v2 2/9] KVM: x86/pmu: Don't release vLBR casued by vPMI
Thread-Topic: [PATCH v2 2/9] KVM: x86/pmu: Don't release vLBR casued by vPMI
Thread-Index: AQHZ7GYPUWiX28CTBUKwNxfmzL3KErArOgeAgAFsXPA=
Date:   Wed, 27 Sep 2023 02:16:13 +0000
Message-ID: <MW4PR11MB5824D8F5C5F539FE8500B280BBC2A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230921082957.44628-1-xiong.y.zhang@intel.com>
 <20230921082957.44628-3-xiong.y.zhang@intel.com>
 <b1d50ec7-9e49-4796-9236-38f63f196f67@linux.intel.com>
In-Reply-To: <b1d50ec7-9e49-4796-9236-38f63f196f67@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|SN7PR11MB8041:EE_
x-ms-office365-filtering-correlation-id: c0cedff9-ab1b-406b-64dd-08dbbeffb952
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bPn4vznzr4v6sGySD50v9jgvR/mrvBgw5pIGMQl+7I5VWgguxBl/0zXj4i8o/y7/0+z1ByZKvVMGLm8rqf/di3uU+r3Z9sV5JEC6kVkIVEnF6YSX1m/2zK0qhuAv7Jbg6A424643cLlUk1Jss9WRt8Oda0GGbvEGd9o3CxvZsqND8lWqrDPnuyBmJcfBxMAriMHCGtIVxsgA/TyVZmwo6ehSg8UxInncQ8Zu/WlKGKLOpblFQOYC+QjzWw0VbtLvDYqCKdskW5ozOkUfydBbXv3eU19v9N3lMDR16BoVGa3P7haCONVcQe+Yw6fhy1jFNB6wXxMvULhGBMmShbwYzCwjqZxxsgDdB1wZ9DgheMvCawktDhANdZVdylIweu8MGKPsi+X/ySYf8Is4dBhVQIy22+W1hfKvls+Kotz5wLL94RAVzLb+cMoFsjhP+MMvMprOTP8l4EN+z4Dvj5RLSQsqOSdBnVOxTu2PiazIQfAUiacZqlLhKhsJFJGAXNyjhLPE0cYGauDWH7NbDBrWIxilTQ8IbfEZNR2ecAvone2JEt4js6uaPHWVBDVnzD7hTwzZFGmzmTn/X1EsR8XYbVMedPu2//BDqSkWe/HdVCCZ2WmLfLoITtTQuEETRZPk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(136003)(346002)(396003)(230922051799003)(186009)(451199024)(1800799009)(6506007)(53546011)(9686003)(7696005)(82960400001)(122000001)(66946007)(86362001)(26005)(110136005)(478600001)(71200400001)(38070700005)(76116006)(66556008)(66446008)(66476007)(33656002)(5660300002)(52536014)(2906002)(38100700002)(64756008)(4326008)(54906003)(55016003)(8936002)(41300700001)(316002)(8676002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWkxYklybEJpU01YbnAzdktsUThSN1Rua3Q0eXVYbUJVcDJQb3ViNFlyK0Rz?=
 =?utf-8?B?SlFtWUEyME11YXFTTFJFOUdVb0pnT1JTdzFOa3BIRmgvZXVTQlg4a1YwbTBP?=
 =?utf-8?B?VG5Od0FzRHowTHZTQTVLRVNlTDlVRWpHNlRnVTJWY0lKdWNCY0dBblUvSmoy?=
 =?utf-8?B?L1VjQ3lJQ2VPTFpwWTY1SzRlaEUySnp2RERheUZVaUNnQkE4N0JmbHR4Lzc1?=
 =?utf-8?B?ek9WeGEzS0YrU2hjQ0IrbHIxRGRFVEhXU2srRTE0OTlYQjBYUllseTRySlh0?=
 =?utf-8?B?a3JvY1Z5b1pyQ0kxU3FMTEY4clVCYS9uMUpxYTlQK1BQRmRGckpRRGpDd3NY?=
 =?utf-8?B?TU4xSXpHNkFFNWxBWHJKdDhyYVJPMGswOHFQalBtMW5YUGZqRzY2ZFEzNXp4?=
 =?utf-8?B?dEdwdG5ubkpOdGFkRmE0WWtMU09IUCt4dmN5WWV4OHdKTUdBZGUxcUdlb2Y0?=
 =?utf-8?B?ZXBnU01sMUd2WmNiMTd4VEFseDNxSjFkaFRxOXk2TkdhckpvbEdYK1VzZHZn?=
 =?utf-8?B?MVVqb0EzUmpLemJER1QreW9JZE93UjVIRmpMc3lXd25LeHlVNFUwSlp2SVJp?=
 =?utf-8?B?YVBweVRvRS9meUp0Z21XTFNubE4vWm1qM3MwUVRsaStwZGlmNytka29yMmdE?=
 =?utf-8?B?Vll3aFdqWTlTTGtnWXo2aG1YZlpJdU9KU2JZaHJEZ29OSnNER0h0YVcydUx3?=
 =?utf-8?B?ZEdRMzdFVkQwU3BnMHlQODZrcnlEd3RpbW5GVUJ4cGxDRnRtWEdPNUJKWVA5?=
 =?utf-8?B?RUl5YWtlcVNEMEhGb202aXBUeWVJSW1IMHZYYlRISzBoTkpHVTBYUVd2cWpn?=
 =?utf-8?B?NEY1ZXovSFFWRkU1dlgwOVVrTjFBUmVSWS9WdHVlcWRpWG9URTBpT3BoRFpW?=
 =?utf-8?B?TGhXbmdaa0oxbncvL0djbEYrdUJscEZudW5BQVpXbmNsWE8vaHR1Zmg1NHpJ?=
 =?utf-8?B?emRRNnlwbjVzOTQwUElEcFlXRmdBZEQ1UnJsQ28vSVB6MGUwTGQ3MXR4dEQv?=
 =?utf-8?B?azZxVFFUN3hOb2hkWmxzU0VIVGdsQXFKZ3lJK2cyTnlmc0NjbGVkQVYwUWJV?=
 =?utf-8?B?elBHOXRNMEVEdUhhdW9BSmt1K3h4eS9uL1NsQ0tDK1hEeFVvM0hGMmhEYm94?=
 =?utf-8?B?cVBZZXl6WDdzRXV3NlpsaVljblpxUlRDVDRSNTVBUEtvcFE0Z0VSTkdUbzB4?=
 =?utf-8?B?cnhnQU5YZTlLUHd2Z2NYYUt1dmRka1Bwci96WG1oV2JUMkR1Y0tmSERjdU5M?=
 =?utf-8?B?TzR1SWRoWXMwU0lVdkZDTHNmOExJdXBRQy9KaWx4S2YvL1NuY0lydmozMWpk?=
 =?utf-8?B?aUN4WnVyTjc2M3JFMnZQeGdoQXMrSUdaNFM1U3BsbENKUWI1MFFzaS9EeEFq?=
 =?utf-8?B?Ym9LQmY5blBGTlZFRGxkUXB2aURKN1Z2TzFqOW9obnZqdDhYc01KRWlGYWZK?=
 =?utf-8?B?TUttbUN1SVI2eVNUL0g4bHhHa0o4Z21SUjk2T09xekl1VXpKSDJBWGRSVTBW?=
 =?utf-8?B?aERlb0ZmeXpXQ2VlWDdyKzVSYlRCNUpnVmZISEtERUlzNmgzM1hzUHNOUzJ1?=
 =?utf-8?B?akRUSmdGeU5vL3JySFRLMjNPcXRnbDFFNFhmNlgrRWVRd0F6dXBKcGltT0ZQ?=
 =?utf-8?B?N0NEVjkwYmdobjJLYXc2TEduc0FtaExqRk5JTFdYWmRXYTIzeUR2Z0JsTUx1?=
 =?utf-8?B?SnFWWWpseWd5TnErRlpESEpWZ1hkSVVxeUEwS2dTYThIWXhuNCswcGJxSld1?=
 =?utf-8?B?L1F2SWdlNFpjT3VGL0h3SjllU2l1bG8wQ3JtMUhRNHRGWVBGWjFRRFMvYWtY?=
 =?utf-8?B?YmI0T0xLZGtZbnVGaFF1c1Y2K2xsdmpsVTdFRzdrWDlJMENlQ0ovS1crVjEx?=
 =?utf-8?B?VE9SbGJDdlJYM3d1U1RyMi9ENExlNDJZaEdoN0FRRklmRjIveVVUeUhQVHhl?=
 =?utf-8?B?TjhxaWdSdUQwME5IL1hlRExnYkpwRlR2Y25oY0lnMGQvR0c4Z0sySVBPREJm?=
 =?utf-8?B?Uk5NM3dFRm90NmZnQjErQ0JQclVzNXR5RlFLbkZES0xVNWFEVVBKTEZQZ0Fn?=
 =?utf-8?B?VmRkRGRhbTJHRTVzdWg3bU5NaEh0R1dmczE1SjNCb2VqMUk0QnFBZUV5VFlq?=
 =?utf-8?Q?jN9Ex3GSF6rjVbASi8afVVl4o?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0cedff9-ab1b-406b-64dd-08dbbeffb952
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2023 02:16:13.7752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eUiO62fhv3YfisTqRCWW4dLEOwBMs84RQlD+rHbUvUZ8hBfrUEUMvTgQuepIZnHFAoLgfiINbAWPXGwLS3JOQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8041
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IE9uIDkvMjEvMjAyMyA0OjI5IFBNLCBYaW9uZyBaaGFuZyB3cm90ZToNCj4gPiBUbyBlbXVs
YXRlIEZyZWV6ZV9MQlJfT25fUE1JIGZlYXR1cmUsIEtWTSBQTVUgZGlzYWJsZXMgZ3Vlc3QgTEJS
IGF0DQo+ID4gUE1JIGluamVjdGlvbi4gV2hlbiBndWVzdCBMQlIgaXMgZGlzYWJsZWQsIHZMQlIg
ZXZlbnQgbWF5IGJlIHJlbGVhc2VkDQo+ID4gYXQgdHdvIHZDUFUgc2NoZWQtaW4gbGF0ZXIuIG9u
Y2UgdkxCUiBldmVudCBpcyByZWxlYXNlZCwgS1ZNIHdpbGwNCj4gPiBjcmVhdGUgYSBuZXcgdkxC
UiBldmVudCB3aGVuIGd1ZXN0IGFjY2VzcyBMQlIgTVNScyBhZ2Fpbi4gRmlyc3QgdGhpcw0KPiA+
IGFkZHMgb3ZlcmhlYWQgYXQgdkxCUiBldmVudCByZWxlYXNlIGFuZCByZS1jcmVhdGlvbi4gU2Vj
b25kIHRoaXMgbWF5DQo+ID4gY2hhbmdlcyBndWVzdCBMQlIgY29udGVuZCBhcyB2TEJSIGV2ZW50
IGNyZWF0aW9uIG1heSBjYXVzZSBob3N0IExCUg0KPiA+IGRydmllciByZXNldCBodyBMQlIgZmFj
aWxpdHkuDQo+ID4NCj4gPiBUaGlzIGNvbW1pdCBhdm9pZHMgdGhlIHZMQlIgcmVsZWFzZSBmb3Ig
RnJlZXplX0xCUl9Pbl9QTUkgZW11bGF0aW9uLg0KPiA+IEl0IGNoYW5nZXMgYm9vbGVhbiBsYnJf
ZGVzYy0+aW5fdXNlIGludG8gZW51bSBsYnJfZGVzYy0+c3RhdGUsIHNvIGl0DQo+ID4gY291bGQg
ZXhwcmVzcyBtb3JlIExCUiBzdGF0ZXMsIEtWTSBzZXRzIGxicl9kZXNjLT5zdGF0ZSBhcw0KPiA+
IEZSRUVaRV9PTl9QTUkgYXQgdlBNSSBpbmplY3Rpb24sIHNvIHRoYXQgdkxCUiByZWxlYXNlIGZ1
bmN0aW9uIGNvdWxkDQo+ID4gY2hlY2sgdGhpcyBzdGF0ZSB0byBhdm9pZCB2TEJSIHJlbGVhc2Uu
IFdoZW4gZ3Vlc3QgZW5hYmxlcyBMQlIgYXQgdGhlDQo+ID4gZW5kIG9mIHRoZSBndWVzdCBQTUkg
aGFuZGxlciwgS1ZNIHdpbGwgc2V0IGxicl9kZXNjLT5zdGF0ZSBhcyBJTl9VU0UuDQo+ID4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBYaW9uZyBaaGFuZyA8eGlvbmcueS56aGFuZ0BpbnRlbC5jb20+DQo+
ID4gLS0tDQo+ID4gICBhcmNoL3g4Ni9rdm0vdm14L3BtdV9pbnRlbC5jIHwgOCArKysrKy0tLQ0K
PiA+ICAgYXJjaC94ODYva3ZtL3ZteC92bXguYyAgICAgICB8IDIgKy0NCj4gPiAgIGFyY2gveDg2
L2t2bS92bXgvdm14LmggICAgICAgfCA4ICsrKysrKystDQo+ID4gICAzIGZpbGVzIGNoYW5nZWQs
IDEzIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva3ZtL3ZteC9wbXVfaW50ZWwuYw0KPiA+IGIvYXJjaC94ODYva3ZtL3ZteC9wbXVf
aW50ZWwuYyBpbmRleCA3NmQ3YmQ4ZTRmYzYuLmM4ZDQ2YzNkMWFiNiAxMDA2NDQNCj4gPiAtLS0g
YS9hcmNoL3g4Ni9rdm0vdm14L3BtdV9pbnRlbC5jDQo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3Zt
eC9wbXVfaW50ZWwuYw0KPiA+IEBAIC02MjgsNyArNjI4LDcgQEAgc3RhdGljIHZvaWQgaW50ZWxf
cG11X2luaXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ICAgCWxicl9kZXNjLT5yZWNvcmRz
Lm5yID0gMDsNCj4gPiAgIAlsYnJfZGVzYy0+ZXZlbnQgPSBOVUxMOw0KPiA+ICAgCWxicl9kZXNj
LT5tc3JfcGFzc3Rocm91Z2ggPSBmYWxzZTsNCj4gPiAtCWxicl9kZXNjLT5pbl91c2UgPSBGQUxT
RTsNCj4gPiArCWxicl9kZXNjLT5zdGF0ZSA9IExCUl9TVEFURV9QUkVESUNUX0ZSRUU7DQo+ID4g
ICB9DQo+ID4NCj4gPiAgIHN0YXRpYyB2b2lkIGludGVsX3BtdV9yZXNldChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpIEBAIC02NzEsNiArNjcxLDcNCj4gPiBAQCBzdGF0aWMgdm9pZCBpbnRlbF9wbXVf
bGVnYWN5X2ZyZWV6aW5nX2xicnNfb25fcG1pKHN0cnVjdCBrdm1fdmNwdQ0KPiAqdmNwdSkNCj4g
PiAgIAlpZiAoZGF0YSAmIERFQlVHQ1RMTVNSX0ZSRUVaRV9MQlJTX09OX1BNSSkgew0KPiA+ICAg
CQlkYXRhICY9IH5ERUJVR0NUTE1TUl9MQlI7DQo+ID4gICAJCXZtY3Nfd3JpdGU2NChHVUVTVF9J
QTMyX0RFQlVHQ1RMLCBkYXRhKTsNCj4gPiArCQl2Y3B1X3RvX2xicl9kZXNjKHZjcHUpLT5zdGF0
ZSA9IExCUl9TVEFURV9GUkVFWkVfT05fUE1JOw0KPiA+ICAgCX0NCj4gPiAgIH0NCj4gPg0KPiA+
IEBAIC03NjUsOSArNzY2LDEwIEBAIHN0YXRpYyB2b2lkIGludGVsX3BtdV9jbGVhbnVwKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSkNCj4gPiAgIAlzdHJ1Y3QgbGJyX2Rlc2MgKmxicl9kZXNjID0gdmNw
dV90b19sYnJfZGVzYyh2Y3B1KTsNCj4gPg0KPiA+ICAgCWlmICghKHZtY3NfcmVhZDY0KEdVRVNU
X0lBMzJfREVCVUdDVEwpICYgREVCVUdDVExNU1JfTEJSKSkgew0KPiA+IC0JCWlmICghbGJyX2Rl
c2MtPmluX3VzZSkNCj4gPiArCQlpZiAobGJyX2Rlc2MtPnN0YXRlID09IExCUl9TVEFURV9QUkVE
SUNUX0ZSRUUpDQo+ID4gICAJCQlpbnRlbF9wbXVfcmVsZWFzZV9ndWVzdF9sYnJfZXZlbnQodmNw
dSk7DQo+ID4gLQkJbGJyX2Rlc2MtPmluX3VzZSA9IGZhbHNlOw0KPiA+ICsJCWVsc2UgaWYgKGxi
cl9kZXNjLT5zdGF0ZSA9PSBMQlJfU1RBVEVfSU5fVVNFKQ0KPiA+ICsJCQlsYnJfZGVzYy0+c3Rh
dGUgPSBMQlJfU1RBVEVfUFJFRElDVF9GUkVFOw0KPiA+ICAgCX0NCj4gPiAgIH0NCj4gDQo+IA0K
PiBJJ20gY29uY2VybmluZyB3aGV0aGVyIHRoZXJlIGlzIGEgcmlzayB0aGF0IHRoZSB2TEJSIGV2
ZW50IGNhbid0IGJlIHJlbGVhc2VkDQo+IGZvcmV2ZXIuIEJhc2Ugb24gdGhlIGxvZ2ljLCB0aGUg
c3RhdGUgbXVzdCBiZSBzZXQgdG8gTEJSX1NUQVRFX0lOX1VTRSBmaXJzdGx5DQo+IGFuZCB0aGVu
IGNvdWxkIGJlIGZyZWVkIGluIG5leHQgY3ljbGUuIEFzc3VtaW5nIHRoZSBndWVzdCBQTUkgaGFu
ZGxlciBkb2Vzbid0DQo+IGVuYWJsZSBMQlIgYWdhaW4gYXMgc29tZSByZWFzb24sIHRoZSBMQlIg
c3RhdGUgd291bGQgc3RheSBpbg0KPiBMQlJfU1RBVEVfRlJFRVpFX09OX1BNSSBzdGF0ZSBhbmQg
dGhlIHZMQlIgZXZlbnQgd291bGQgbm90IGJlIHJlbGVhc2VkDQo+IGFuZCBMQlIgc3RhY2sgd291
bGQgbm90IGJlIHJlc2V0LiANCj53aGVuIGd1ZXN0IGVuYWJsZXMgTEJSIGluIG5leHQgdGltZSwg
Z3Vlc3QNCj4gbWF5IHNlZSB0aGUgc3RhbGUgTEJSIGRhdGEuIA0KUHJvY2Vzc29yIHdvbid0IHJl
c2V0IExCUiBzdGFjayBieSBpdHNlbGYsIExCUiBkcml2ZXIgcmVzZXRzIExCUiBzdGFjay4gU28g
Z3Vlc3QgTEJSDQpkcml2ZXIgY291bGQgcmVzZXQgdkxCUiBiZWZvcmUgZW5hYmxlIGl0LiAgDQoN
Cj5JIHRoaW5rIHdlIG1heSBhZGQgYSBiYWNrdXAgbWVjaGFuaXNtIHRvIGVuc3VyZQ0KPiB0aGUg
dkxCUiBldmVudCBjYW4gYmUgZnJlZWQgaWYgdkxCUiBpcyBkaXNhYmxlZCBhZnRlciBzZXZlcmFs
IHNjaGVkdWxlIHNsb3RzLg0KV2l0aG91dCB0aGlzIGNvbW1pdHMsIGRpc2FibGVkIHZMQlIgd2ls
bCBiZSByZWxlYXNlZCBpbiBuZXh0IHR3byBzY2hlZHVsZSBzbG90LiBUaGlzDQpjb21taXQgaXMg
YW4gb3B0aW1pemF0aW9uIHRoYXQgdkxCUiBkaXNhYmxlZCBieSBLVk0gbGJyX2ZyZWV6ZV9vbl9w
bWkgZW11bGF0aW9uDQpuZXZlciBiZSByZWxlYXNlZCBkdXJpbmcgZ3Vlc3QgUE1JIGhhbmRsZXIu
IENvbXBhcmVkIHdpdGggdGhlIHN1Z2dlc3RlZCBiYWNrdXANCm1lY2hhbmlzbSwgSSBwcmVmZXIg
dG8gZHJvcCB0aGlzIG9wdGltaXphdGlvbi4NCg0KdGhhbmtzDQo+ID4gZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jIGluZGV4DQo+ID4g
NDA1NmUxOTI2NmI1Li41NjVkZjhlZWI3OGIgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3Zt
L3ZteC92bXguYw0KPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gPiBAQCAtMjI0
Miw3ICsyMjQyLDcgQEAgc3RhdGljIGludCB2bXhfc2V0X21zcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsDQo+IHN0cnVjdCBtc3JfZGF0YSAqbXNyX2luZm8pDQo+ID4gICAJCWlmIChpbnRlbF9wbXVf
bGJyX2lzX2VuYWJsZWQodmNwdSkgJiYgKGRhdGEgJg0KPiBERUJVR0NUTE1TUl9MQlIpKSB7DQo+
ID4gICAJCQlzdHJ1Y3QgbGJyX2Rlc2MgKmxicl9kZXNjID0gdmNwdV90b19sYnJfZGVzYyh2Y3B1
KTsNCj4gPg0KPiA+IC0JCQlsYnJfZGVzYy0+aW5fdXNlID0gdHJ1ZTsNCj4gPiArCQkJbGJyX2Rl
c2MtPnN0YXRlID0gTEJSX1NUQVRFX0lOX1VTRTsNCj4gPiAgIAkJCWlmICghbGJyX2Rlc2MtPmV2
ZW50KQ0KPiA+ICAgCQkJCWludGVsX3BtdV9jcmVhdGVfZ3Vlc3RfbGJyX2V2ZW50KHZjcHUpOw0K
PiA+ICAgCQl9DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmggYi9hcmNo
L3g4Ni9rdm0vdm14L3ZteC5oIGluZGV4DQo+ID4gNTQ3ZWRlYjUyZDA5Li4wY2I2OGEzMTlmYzgg
MTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC92bXguaA0KPiA+ICsrKyBiL2FyY2gv
eDg2L2t2bS92bXgvdm14LmgNCj4gPiBAQCAtOTMsNiArOTMsMTIgQEAgdW5pb24gdm14X2V4aXRf
cmVhc29uIHsNCj4gPiAgIAl1MzIgZnVsbDsNCj4gPiAgIH07DQo+ID4NCj4gPiArZW51bSBsYnJf
c3RhdGUgew0KPiA+ICsJTEJSX1NUQVRFX1BSRURJQ1RfRlJFRSA9IDAsDQo+ID4gKwlMQlJfU1RB
VEVfSU5fVVNFID0gMSwNCj4gPiArCUxCUl9TVEFURV9GUkVFWkVfT05fUE1JID0gMg0KPiA+ICt9
Ow0KPiA+ICsNCj4gPiAgIHN0cnVjdCBsYnJfZGVzYyB7DQo+ID4gICAJLyogQmFzaWMgaW5mbyBh
Ym91dCBndWVzdCBMQlIgcmVjb3Jkcy4gKi8NCj4gPiAgIAlzdHJ1Y3QgeDg2X3BtdV9sYnIgcmVj
b3JkczsNCj4gPiBAQCAtMTA4LDcgKzExNCw3IEBAIHN0cnVjdCBsYnJfZGVzYyB7DQo+ID4gICAJ
LyogVHJ1ZSBpZiBMQlJzIGFyZSBtYXJrZWQgYXMgbm90IGludGVyY2VwdGVkIGluIHRoZSBNU1Ig
Yml0bWFwICovDQo+ID4gICAJYm9vbCBtc3JfcGFzc3Rocm91Z2g7DQo+ID4NCj4gPiAtCWJvb2wg
aW5fdXNlOw0KPiA+ICsJZW51bSBsYnJfc3RhdGUgc3RhdGU7DQo+ID4gICB9Ow0KPiA+DQo+ID4g
ICAvKg0K
