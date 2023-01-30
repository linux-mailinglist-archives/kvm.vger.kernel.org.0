Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76101680A3D
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 10:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbjA3J6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 04:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjA3J6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 04:58:20 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C002C169
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 01:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675072665; x=1706608665;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DzruM4ZUYSVwAizLBIlY1cJavxx9IDwsDkaZNqV2dyA=;
  b=lw6lyOb8vewvQw8FfvubSAtotDSX/lA8LSiDYf1KqHd0x9jep92TTowU
   wYWpVTxwyXmPOCQzh7KZs++3oe411PJpBaJ7lFIqVCBugBi4HCbYmMIP0
   65Bqa5JjKZ2x6dSjJt0xgeDlq0Uy4S25l8f9o1cYe0peuSD+g97fdskMF
   2qt9SSjiVHY4CQtJwI2GP3HmVNnPoxfrTI/4uZUOGLLi8Vf2mPDtBWngI
   NtdS+u5jZlAtynFeZG2jcqut4YKXSF6ARxGOnRpCa4tbiZcQlzqD2aBx/
   etd1HBVaCz0GJrsDSVfotVDUR+WccA47BVwTdB+wy9dCev9+VupNwmGDi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="392067185"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="392067185"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 01:53:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="992837016"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="992837016"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jan 2023 01:47:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 01:47:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 01:47:11 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 01:47:11 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 01:47:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BC2aMeoNQZr4Uo9c8mmXeLOSDu8l9XLFjcnsiKfaKJn9PyF5u7PopnuO7ENQY9YRrWZEu8V5guhvQBf1+TC2yQCWDzYp8NvQp2BNofFn/F815cU/kO8aG7hHkmbXJXnRAxvJRTaLGPXhwCKb4XfT6oa8vY3CwIXdH6LrYBNLTOf51aysN99NrXax09Be6RuZQ5DKaa1eP5ECCEpi9tzqJQ2sIkUJbNOpHY0LzcDkHJZzMDWyqUNbU0xlGNh5geMckVIe5E87UfktQSuFC+6SudP4cmsc5n1GQRi9IhdGmprwnmyyXrGSNHUQug3X6/1hs6W/s6gYmuHIHxIcze4FXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DzruM4ZUYSVwAizLBIlY1cJavxx9IDwsDkaZNqV2dyA=;
 b=b3dYGmboDW+iPEqYVfuL9/NwausOvZJWJBCJBeZzI5GJdhSMa67nrfIM0CWzKvGFtKaqOpQlvcG59ouKHVOpoq/fLCKzV6uKic41xX9VMS8Ru6CTjHBLLw2laFXC6fqYY9+3qbepSIbu11KjviRqEbJPrPuDtpa2q63oC1eicxlnTPBKRJVvdhCtAPFZIja8q+B6Gxgv/p+PGYAXZTpWS7euqDaS+V8jx1Tbt3qWWFdjJ5tRHl2cK8ZqStrQXBoQO8MRO9FivrIOZB3LTCFuiG8Cn4yNicc6DjxTOReBhYB43gVeim7M91D8YBQyw+20kUuUGJslogVCdNDJzCEQrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB6574.namprd11.prod.outlook.com (2603:10b6:a03:44e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 09:47:09 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 09:47:09 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 03/13] vfio: Accept vfio device file in the driver facing
 kAPI
Thread-Topic: [PATCH 03/13] vfio: Accept vfio device file in the driver facing
 kAPI
Thread-Index: AQHZKnqWMdQKCBRGz0aiBhqkqYiNdK6kWfyAgBEdt5A=
Date:   Mon, 30 Jan 2023 09:47:08 +0000
Message-ID: <DS0PR11MB7529C43DBE880EED5A04D9E4C3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-4-yi.l.liu@intel.com>
 <6c95aefd-31f5-fc98-7a51-77f181dc6ec8@redhat.com>
In-Reply-To: <6c95aefd-31f5-fc98-7a51-77f181dc6ec8@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ0PR11MB6574:EE_
x-ms-office365-filtering-correlation-id: a0c47abe-c1ce-4b7c-0f68-08db02a6f459
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YFN4+pGqsCG5Fabstm4xzzlQ2wKykcPs5e3IKhbTroyI0Zzf6PQKOCUH5SVKrvo+DleXFLUp/H+j3lqTWUpbxbJfJkbLhHCgS7s4QuQacpgQBDZrphY7rCkAYqW3AB48mG6XDuEYuxUGjT9x97SWqeWLfqp/7RsCKX3eODbHcfGTH9/mCr5JukAQ84c3TZp0AQ0BqGme2kRRUFswmiY6MOCInm1m42v8wOd2Q3SC6vjpjZJLwllFTN/yfOqlzRhNuk5GhaCFc3kC8EijF5zAvCSpcYmWUInQVETydfQOhwBDkHGdeFwssc8cGxHg2LrYLduPgML7dHYOaHezkWtxr6gQV2ko2cImM76aR3qWTXtlCQcYO3UBLf3jOiSxgJ9nt3RhJ1kaXF8Bsao5R411HTCcuvZ4ZCuXCmVBvbn1JHpaKS9Vg73ENE7pjypG02fq3K3nRJ/3Pjuyp7zynEdMnyIbfR20i8aCkUNgGtu/bP0YtSSL2g/bKVlow7vy2UKnYhnJGSeKBY2kaUrQiFxsh3MaJVl6yno9k1rZzXIKdNIR633NBBDctay5EKmSaaizqh4iQhzb9t1QFgKWDkKzFGmVs104p0oYI9Cj5uH6aefAdUIbt0U97RXzeJBTP/llU6CDAYSBrz9lUzqh5JES0eaeTjeVxqQw3GlUkKFeWJy7xzbnVOHKabDacGawRtuiaMLeUTFJt93NFx5HfdPPffEdu415C/Na1ahoUZLhe+r5w+cAY3AL8EzIo9eEzfZ+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199018)(86362001)(38070700005)(82960400001)(38100700002)(122000001)(33656002)(478600001)(2906002)(54906003)(110136005)(7696005)(7416002)(966005)(41300700001)(55016003)(26005)(71200400001)(52536014)(8936002)(5660300002)(66946007)(316002)(66446008)(8676002)(76116006)(4326008)(83380400001)(66556008)(66476007)(64756008)(9686003)(186003)(6506007)(53546011)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1Q2eVZLOE4wRFkzamhKU1NUYjFmcFl3bWtsZ0ZLUG1aeFFDN1hYQ2NtNVQ4?=
 =?utf-8?B?cHNRYnpoVndOU2I3QnlmNitpemoydE11OGdQTmZBQ2x1VWhtRCtwS1pEUXpM?=
 =?utf-8?B?aHFuUi9mV2w4b3pZL0VZbjViTDRrZ2V3ZU5TZlRxRkNSQzBpUWM3Q3VCS1pw?=
 =?utf-8?B?aS9UcllZb1hsM3dITFE1elM5Z3dzelFGbmI4Z1I0cVp0TnR0NTJUeGF2dDBa?=
 =?utf-8?B?K050NjU4WnZYMHMrTElJK3ZObFFJZzJPa3ZoWnJNTnpZNTIxbHpqL2Y3UGxR?=
 =?utf-8?B?R2VPQ0U0eUwrckREZGxFS1lDSXVIcFpLRFFoUXFqamlGbkYyOGNSWkpUY29s?=
 =?utf-8?B?ekxFTXBzYW9FZzNqYW84K25waUNFZ0pYYUtlbTJwSlZNYVNWQ1Q1Q0tWL3JC?=
 =?utf-8?B?eFR3OXBWaUI0YkREZkN3SUlidlpwakozZmRQWSs2SVpCUHNHUzNWUjAzZytE?=
 =?utf-8?B?bU12N2xkZ1ZEOFA3NDk3ZHYvS2I1S0pMVVEyWGkxSkR5OVdpV3FjS3Vna2Z0?=
 =?utf-8?B?am1LRERZcGlubXU3T2hvQXFqT3ZtQmlpQVpVM0JzVGNDc1hyN0ZDRFA5UG5V?=
 =?utf-8?B?MitKWVdUaHJ5MWwvemRGRVFvNFdNNTg0dk9aV0RER3IrZ3Rrd1lUVEs4RXhm?=
 =?utf-8?B?b0N5V3BnS2tReGhPQ0RLZnREMGtPVk9iQ3Vid25MTithNkQ5N0gxODZTditP?=
 =?utf-8?B?NFBmaTdENk9nMW43bXlJc1NyaitRZUcrQ3ZmOGxNUGJLMVphclEyNWRqaTZ4?=
 =?utf-8?B?SEVjQVpheGR5a1l4bFhwd3ByUVkrN0RBSzRUZ0tuUk5zd1FLQWVXUW4zZUFF?=
 =?utf-8?B?VWp6WGlQR2IrZ05tOGgvK3JxMTFncEZzbVZUZG1qSVFGQkdDQ25lRkFKM3o2?=
 =?utf-8?B?QlZsY3NYRy96VUQxMlRFS0Z0OGVSaTYvTWRRNXpBRFlNVG1ZSkYvQjJ3V2Nr?=
 =?utf-8?B?UkpWaktHU0lEU1Fmb3hSYjF2TS9JNUxlTG5mYS9FaGFTanBtNjM0UlNpY0lZ?=
 =?utf-8?B?M0ZleDd1SmlnZzA2WEZ2c3d0ZHdHaUVKQ3Y4Sk9mMVZVNElLKzhvMGlxKzVJ?=
 =?utf-8?B?OWJOMHg4U3Mra21hcmloQm1Qd0pZdnRCOHVzZVY2T1pOdXhSek45OG0vd3FC?=
 =?utf-8?B?Nml2dUhxR3NhTkx2ak9ObEJVUVZubStJS2w1TnpiOFNqTVNiYmZBZis4WlJx?=
 =?utf-8?B?YVEwbjVIZDBoK2Zha0hqbkZIbk5zeCtHNSszSFBHandjZTRwSDFJVSttL0Uz?=
 =?utf-8?B?MnJ5MnlJN09CbGJySEFJTzFJNEhmckxxWUduSzBPOG81c0VSREdlUnYxelA1?=
 =?utf-8?B?UE8xYmZUOGJmS2kycWNEL3RPem9TdEVUM2pDN3lGMnJRZUp5QUo3dWtSNmp5?=
 =?utf-8?B?Qm1XNDlPbW5QVW9ibUNodjRJbU8vSjNvNHFVL1RXQ09TVm1pbXFIcHd5azJX?=
 =?utf-8?B?Y29BZS83anlEL3pzekhySHNncnA1ZGErZ0xqdnNxc1BHa3FLdjd2ZE90TTRQ?=
 =?utf-8?B?NEZtQWdwa3VBZFFoUFIrNXRFYzNKMktrUUNJMVQ1RndtT201WFV4M08xdllV?=
 =?utf-8?B?OU84amJhUnZ5dEtjRExrVUYxZ1FRQXhvdUJRQmRSbFlIZUFSR0Z3enZzUHp2?=
 =?utf-8?B?NlAvMkZ2UkJRRHo4eHNHa0tzc24zdGZJOGpLOUFJODExbGhOQlpJVm9DZ2NI?=
 =?utf-8?B?YktnaWg2TzlFVUdiOG9zQWhFT01zb2xXeVdsVlM2a1dIUG9KTDJrWnRsN2FD?=
 =?utf-8?B?UkpsY0NKeVJIZ1hHeXVHNEVYNlZwdWYzdXFKdWhWNFJuTUJHUkpNZkloQkxM?=
 =?utf-8?B?Qm9ZTFc1eitDb25nV1pibWw0T3ltb2NaMjFrVy90aElHbGFybWp0dVYxV2FX?=
 =?utf-8?B?QnRRcXlMMlJraTZzQUZSUzJZMzFhMU1RL2cvYkZZc2cxZk1FQXpGcGFWV09B?=
 =?utf-8?B?eGtMQzUwelUvaDJkNExJbWNoc1RwcURjYk1obTJYV2kxL1JibmM1OHhpVjVN?=
 =?utf-8?B?WTBkLy9VSElBbmkwTFp4L1JKU201OC8rOE83TVBaU0JmNlFxQ0hSQWdkNUhW?=
 =?utf-8?B?UUF5QUljOE9rSWxlcFVlQ2txWUliaXk3WFpUOW5ISW1rU29KWnozYUgvaFV0?=
 =?utf-8?Q?LRxvshxV1yPcS0VPRs7CQVHUY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c47abe-c1ce-4b7c-0f68-08db02a6f459
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 09:47:08.9892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xda/LlqBy6Vq4MOxzvmRJ7C3vPXvXJIkeL16PaeqKQE6ggyqTSFlJGmAeQj4Dn2GjRBHh6czNxXyUNN46/aBDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6574
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFRodXJzZGF5LCBKYW51YXJ5IDE5LCAyMDIzIDEyOjExIEFNDQo+IA0KPiBIaSBZaSwN
Cj4gDQo+IE9uIDEvMTcvMjMgMTQ6NDksIFlpIExpdSB3cm90ZToNCj4gPiBUaGlzIG1ha2VzIHRo
ZSB2ZmlvIGZpbGUga0FQSXMgdG8gYWNjZXB0ZSB2ZmlvIGRldmljZSBmaWxlcywgYWxzbyBhDQo+
ID4gcHJlcGFyYXRpb24gZm9yIHZmaW8gZGV2aWNlIGNkZXYgc3VwcG9ydC4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBk
cml2ZXJzL3ZmaW8vdmZpby5oICAgICAgfCAgMSArDQo+ID4gIGRyaXZlcnMvdmZpby92ZmlvX21h
aW4uYyB8IDUxDQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0NCj4g
PiAgMiBmaWxlcyBjaGFuZ2VkLCA0OCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby92ZmlvLmggYi9kcml2ZXJzL3ZmaW8vdmZp
by5oDQo+ID4gaW5kZXggZWY1ZGUyODcyOTgzLi41M2FmNmUzZWEyMTQgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy92ZmlvL3ZmaW8uaA0KPiA+ICsrKyBiL2RyaXZlcnMvdmZpby92ZmlvLmgNCj4g
PiBAQCAtMTgsNiArMTgsNyBAQCBzdHJ1Y3QgdmZpb19jb250YWluZXI7DQo+ID4NCj4gPiAgc3Ry
dWN0IHZmaW9fZGV2aWNlX2ZpbGUgew0KPiA+ICAJc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2U7
DQo+ID4gKwlzdHJ1Y3Qga3ZtICprdm07DQo+ID4gIH07DQo+ID4NCj4gPiAgdm9pZCB2ZmlvX2Rl
dmljZV9wdXRfcmVnaXN0cmF0aW9uKHN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNlKTsNCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3ZmaW9fbWFpbi5jIGIvZHJpdmVycy92ZmlvL3ZmaW9f
bWFpbi5jDQo+ID4gaW5kZXggMWFlZGZiZDE1Y2EwLi5kYzA4ZDVkZDYyY2MgMTAwNjQ0DQo+ID4g
LS0tIGEvZHJpdmVycy92ZmlvL3ZmaW9fbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy92ZmlvL3Zm
aW9fbWFpbi5jDQo+ID4gQEAgLTExMTksMTMgKzExMTksMjMgQEAgY29uc3Qgc3RydWN0IGZpbGVf
b3BlcmF0aW9ucyB2ZmlvX2RldmljZV9mb3BzDQo+ID0gew0KPiA+ICAJLm1tYXAJCT0gdmZpb19k
ZXZpY2VfZm9wc19tbWFwLA0KPiA+ICB9Ow0KPiA+DQo+ID4gK3N0YXRpYyBzdHJ1Y3QgdmZpb19k
ZXZpY2UgKnZmaW9fZGV2aWNlX2Zyb21fZmlsZShzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gPiArew0K
PiA+ICsJc3RydWN0IHZmaW9fZGV2aWNlX2ZpbGUgKmRmID0gZmlsZS0+cHJpdmF0ZV9kYXRhOw0K
PiA+ICsNCj4gPiArCWlmIChmaWxlLT5mX29wICE9ICZ2ZmlvX2RldmljZV9mb3BzKQ0KPiA+ICsJ
CXJldHVybiBOVUxMOw0KPiA+ICsJcmV0dXJuIGRmLT5kZXZpY2U7DQo+ID4gK30NCj4gPiArDQo+
ID4gIC8qKg0KPiA+ICAgKiB2ZmlvX2ZpbGVfaXNfdmFsaWQgLSBUcnVlIGlmIHRoZSBmaWxlIGlz
IHVzYWJsZSB3aXRoIFZGSU8gYVBJUw0KPiA+ICAgKiBAZmlsZTogVkZJTyBncm91cCBmaWxlIG9y
IFZGSU8gZGV2aWNlIGZpbGUNCj4gPiAgICovDQo+ID4gIGJvb2wgdmZpb19maWxlX2lzX3ZhbGlk
KHN0cnVjdCBmaWxlICpmaWxlKQ0KPiA+ICB7DQo+ID4gLQlyZXR1cm4gdmZpb19ncm91cF9mcm9t
X2ZpbGUoZmlsZSk7DQo+ID4gKwlyZXR1cm4gdmZpb19ncm91cF9mcm9tX2ZpbGUoZmlsZSkgfHwN
Cj4gPiArCSAgICAgICB2ZmlvX2RldmljZV9mcm9tX2ZpbGUoZmlsZSk7DQo+ID4gIH0NCj4gPiAg
RVhQT1JUX1NZTUJPTF9HUEwodmZpb19maWxlX2lzX3ZhbGlkKTsNCj4gPg0KPiA+IEBAIC0xMTQw
LDE1ICsxMTUwLDM3IEBAIEVYUE9SVF9TWU1CT0xfR1BMKHZmaW9fZmlsZV9pc192YWxpZCk7DQo+
ID4gICAqLw0KPiA+ICBib29sIHZmaW9fZmlsZV9lbmZvcmNlZF9jb2hlcmVudChzdHJ1Y3QgZmls
ZSAqZmlsZSkNCj4gPiAgew0KPiA+IC0Jc3RydWN0IHZmaW9fZ3JvdXAgKmdyb3VwID0gdmZpb19n
cm91cF9mcm9tX2ZpbGUoZmlsZSk7DQo+ID4gKwlzdHJ1Y3QgdmZpb19ncm91cCAqZ3JvdXA7DQo+
ID4gKwlzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZTsNCj4gPg0KPiA+ICsJZ3JvdXAgPSB2Zmlv
X2dyb3VwX2Zyb21fZmlsZShmaWxlKTsNCj4gPiAgCWlmIChncm91cCkNCj4gPiAgCQlyZXR1cm4g
dmZpb19ncm91cF9lbmZvcmNlZF9jb2hlcmVudChncm91cCk7DQo+ID4NCj4gPiArCWRldmljZSA9
IHZmaW9fZGV2aWNlX2Zyb21fZmlsZShmaWxlKTsNCj4gPiArCWlmIChkZXZpY2UpDQo+ID4gKwkJ
cmV0dXJuIGRldmljZV9pb21tdV9jYXBhYmxlKGRldmljZS0+ZGV2LA0KPiA+ICsNCj4gSU9NTVVf
Q0FQX0VORk9SQ0VfQ0FDSEVfQ09IRVJFTkNZKTsNCj4gPiArDQo+ID4gIAlyZXR1cm4gdHJ1ZTsN
Cj4gPiAgfQ0KPiA+ICBFWFBPUlRfU1lNQk9MX0dQTCh2ZmlvX2ZpbGVfZW5mb3JjZWRfY29oZXJl
bnQpOw0KPiA+DQo+ID4gK3N0YXRpYyB2b2lkIHZmaW9fZGV2aWNlX2ZpbGVfc2V0X2t2bShzdHJ1
Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGt2bSAqa3ZtKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgdmZp
b19kZXZpY2VfZmlsZSAqZGYgPSBmaWxlLT5wcml2YXRlX2RhdGE7DQo+ID4gKwlzdHJ1Y3QgdmZp
b19kZXZpY2UgKmRldmljZSA9IGRmLT5kZXZpY2U7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAq
IFRoZSBrdm0gaXMgZmlyc3QgcmVjb3JkZWQgaW4gdGhlIGRmLCBhbmQgd2lsbCBiZSBwcm9wYWdh
dGVkDQo+ID4gKwkgKiB0byB2ZmlvX2RldmljZTo6a3ZtIHdoZW4gdGhlIGZpbGUgYmluZHMgaW9t
bXVmZCBzdWNjZXNzZnVsbHkgaW4NCj4gPiArCSAqIHRoZSB2ZmlvIGRldmljZSBjZGV2IHBhdGgu
DQo+ID4gKwkgKi8NCj4gPiArCW11dGV4X2xvY2soJmRldmljZS0+ZGV2X3NldC0+bG9jayk7DQo+
IGl0IGlzIG5vdCB0b3RhbGx5IG9idmlvdXMgdG8gbWUgd2h5IHRoZQ0KPiANCj4gZGV2aWNlLT5k
ZXZfc2V0LT5sb2NrIG5lZWRzIHRvIGJlIGhlbGQgaGVyZSBhbmQgd2h5IHRoYXQgbG9jayBpbiBw
YXJ0aWN1bGFyLg0KPiBJc24ndCBzdXBwb3NlZCB0byBwcm90ZWN0IHRoZSB2ZmlvX2RldmljZV9z
ZXQuIFRoZSBoZWFkZXIganVzdCBtZW50aW9ucw0KPiAidGhlIFZGSU8gY29yZSB3aWxsIHByb3Zp
ZGUgYSBsb2NrIHRoYXQgaXMgaGVsZCBhcm91bmQNCj4gb3Blbl9kZXZpY2UoKS9jbG9zZV9kZXZp
Y2UoKSBmb3IgYWxsIGRldmljZXMgaW4gdGhlIHNldC4iDQoNClRoZSByZWFzb24gaXMgdGhlIGRm
LT5rdm0gd2FzIHJlZmVyZW5jZWQgaW4gdmZpb19kZXZpY2VfZmlyc3Rfb3BlbigpIGluDQp0aGUg
YmVsb3cgY29tbWl0LiBUbyBhdm9pZCByYWNlLCBhIGNvbW1vbiBsb2NrIGlzIG5lZWRlZCBiZXR3
ZWVuIHRoZQ0Kc2V0X2t2bSB0aHJlYWQgYW5kIHRoZSBvcGVuIHRocmVhZC4gRm9yIGdyb3VwIHBh
dGgsIGdyb3VwX2xvY2sgaXMgdXNlZC4NCkhvd2V2ZXIsIGZvciBjZGV2IHBhdGgsIHRoZXJlIG1h
eSBiZSBubyBncm91cF9sb2NrIGNvbXBpbGVkLCBzbyBuZWVkDQp0byB1c2UgYW5vdGhlciBvbmUu
IEFuZCBkZXZfc2V0LT5sb2NrIGhhcHBlbnMgdG8gYmUgdXNlZCBpbiB0aGUgb3Blbg0KcGF0aCwg
c28gdXNlIGl0IGF2b2lkcyB0byBhZGRpbmcgYW5vdGhlciBzcGVjaWZpYyBsb2NrLg0KDQpodHRw
czovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyMzAxMTcxMzQ5NDIuMTAxMTEyLTgteWkubC5saXVA
aW50ZWwuY29tLw0KDQo+ID4gKwlkZi0+a3ZtID0ga3ZtOw0KPiA+ICsJbXV0ZXhfdW5sb2NrKCZk
ZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
