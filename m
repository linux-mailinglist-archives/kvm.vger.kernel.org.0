Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A067AE38A
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 04:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbjIZCBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 22:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjIZCBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 22:01:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21A4D8;
        Mon, 25 Sep 2023 19:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695693666; x=1727229666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aaOIlDErUKwkyThwXY5NPDDFIXiEJZZrW3t/x4aQzCU=;
  b=FBYB9cAaptYSRnYWxPK9iQFwB2uwhnTnzoEgIlM8ELAaqAI8Xs0uwgdV
   na0zAeE9Bd3R3ecEyAmPzG57ZgWsFcBi9nUC6zc/BW2wlPXR5S+yLynXT
   rtuQCbtfONLTsjxb3Hw/bJKvzZzzJ+t/UOQcweVSTSEIVY3hn94rgbsK4
   X35B7/yG/mjU1r458l7+MIs6AUIl1wFPZ2mEFLpmo7d8E9V7kdko3RpqY
   njTT+J5/RLfPmAF7nr7vS0m4wi3u0QPT5/YQCrjI9sVb6A1khLQXYksZj
   7eAThnimGmmD0KUX7ZSz8XLBQXJ+0lW/0WeWf5auca5r/b9xWRn3EHcFQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="361704484"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="361704484"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 19:00:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="1079514194"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="1079514194"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2023 19:00:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 19:00:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 19:00:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 25 Sep 2023 19:00:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 25 Sep 2023 19:00:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2hgjk8c3tI1pfCk15dvqizqK8DZPc8GBW+h8Kz74mzqXjei39iYa9W5xHmOtzYcjZ06Ab/FPaVOp8TGcRy4AEwSgoFyA2GcRv9m1WDCHrPGLonoBDQEObKQJAblUR4rcv8UQ3zsgPTldIHnK4yr/fwpkHr4n9gFMCjILRoA2JMNWhY1ndKQ4q2tdQeqr3ZQBUiVnabnWsd96XBDvd7OOwWi6uiJYkDpwQ2CXFPhrrq4Je0teJrXFSUNI25uHG8qdCiMknQGgtaBF5eE8bJ6TEcHSVU8S+x/wptqc1LSX5i6+cmAU7XnYxaJPC4zMT7ep+orhmEZxIn+UYJ+7IMD2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aaOIlDErUKwkyThwXY5NPDDFIXiEJZZrW3t/x4aQzCU=;
 b=Ljcdjb4wZzLlVwqXSEgqcQGwcGwJ5p41nMIzXcgdZP1CFtHnvc6gtC78SiVqACE/UnIB0vTCzLtBe9oyluR1j0mX8Tlz3MuYZMdnuxG4VwjuPVc5qje1EBt5ivyqoHUXKooAJLZPTI5EBkye3ZfdPO3K0xLAATNV/6wzQjXg3QnslFo7io1q8FyZvpAhvrtZklUFpzRtU62K268oZOHz2qmGpkC9ZX/GRTDTkj87SK3HChMH6n6U42guKKT8H/xYXCZGT876z4Eh6Wscz8qOi4ORGETQkXAdpSPXQ/YR8wpXBxlr2um69aDRvk6CSj7bSOZ0Wz96lq3t4VeP9xn2hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB8210.namprd11.prod.outlook.com (2603:10b6:610:163::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Tue, 26 Sep
 2023 02:00:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d%4]) with mapi id 15.20.6813.017; Tue, 26 Sep 2023
 02:00:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 12/12] iommu: Improve iopf_queue_flush_dev()
Thread-Topic: [PATCH v5 12/12] iommu: Improve iopf_queue_flush_dev()
Thread-Index: AQHZ5un40D2tpmzdOUyPzVi0H1ZCHLArLI+QgAE85gCAAALqMA==
Date:   Tue, 26 Sep 2023 02:00:06 +0000
Message-ID: <BN9PR11MB527645101D044AF7BE193D898CC3A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
 <20230914085638.17307-13-baolu.lu@linux.intel.com>
 <BN9PR11MB5276E30109C63D06675042758CFCA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <b5d52bd4-7cb7-24b5-72d3-b5018306e352@linux.intel.com>
In-Reply-To: <b5d52bd4-7cb7-24b5-72d3-b5018306e352@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB8210:EE_
x-ms-office365-filtering-correlation-id: ffbb609e-4d1a-4ce8-927c-08dbbe344e3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CH+7osyKlnd/KnVvMziub6rBMPXyiH7exb/pQ/gndICBqZU2bdn6nFtw50tXee9klnvMd/bvI8gzzu5QtpQOABppMMwp2z9DlQMK6zZ0d2DB0MaNwyr+4lwuKVd8afQ4VmG2cP74KP3od7Wlx9VPJ+H4Lb9VceoHtMq35HRzGBds/3clseolYAu56gPvQ+BW/35CrYL1HIl/fvIwUHFRMp6rqYj5OOIpr7EqdQ/FwZnULFDxI02taM/5n0e7gVbYBjwbpB9L2FEmHaUVUPf/83muOfnBzmZNfmtIcA/sqbNDRVQNXCccARW/koxAU1oY5dya80GoC+VurNdhFl77JiCRpQjvh/v5i3wwTO3xyqNUAJllH/K0DEDCSWVrCAzsJNU+QUnoZtY6tGBg9h4t3SSiAfIwYOMgg9aKHYpwAsdMe0pGdKppA3kQLo8gY8MBYWzzaPnubuXF5SBKe4j9RQp/zC4XunP7RIODpWHgz6+RMe7X5XLBnpTYyaEKfvq7vH8Ytk2cD+0Nyet3tPXAuYf70F63Zmd7pQNzTtjQzVJYFyHXXiTwUu1/cudrbjVMiyucyezHAExzAEIB7f8QXnQOVB4mPLswAtNJALbVJJqBq7QNMm58kVu3hUaIko2B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(376002)(366004)(136003)(230922051799003)(1800799009)(186009)(451199024)(86362001)(66946007)(33656002)(66476007)(316002)(64756008)(76116006)(41300700001)(66446008)(66556008)(110136005)(7416002)(8936002)(8676002)(4326008)(122000001)(5660300002)(52536014)(54906003)(83380400001)(2906002)(478600001)(38070700005)(38100700002)(26005)(71200400001)(53546011)(55016003)(9686003)(6506007)(7696005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QU5ZV3ArS29vVnVoSXhqSzZSK1hjcUt6TVRsb0RnZkpiQk10dWhFOTFIeXhI?=
 =?utf-8?B?Wk5UeGpjbUFXdkRYb2ZSWlRicFprZjFpM01KT1cxVmZLNC9Ud3lwMTUrOW9k?=
 =?utf-8?B?aVk1NjVPK2V2b2xheFhWYWovNkdvNy9WLzNFcWFXbDZMN0RibFBhbktCYVBs?=
 =?utf-8?B?elZOZ1ZwTGc1N0JiZmd6WkhLdGtjSzFIV084MGJRWjhYdDZxbUhQMUc1WnZt?=
 =?utf-8?B?bEp2T3BtL3RTcWRaTGUvZG5vQzcwUFBiczdGckczTDRCazREVElBSlhoUEJx?=
 =?utf-8?B?Q1JhK2VUUlNWZmNad2RpdmJ1aEo5U1lTQ2FFelJUZFNtQ1ZOSFJza1AwWEtk?=
 =?utf-8?B?TExMRFZ5YW5lUk1GNEhZK2tSSXZmSTBFQjFHeWRCdFFoR09oM0xIWk1tWFpD?=
 =?utf-8?B?YUdyKzVMR2ErMDd1TjNWSm45ODZJeEpvajkwK3lSclBOMWFyMGxwUTVxOWts?=
 =?utf-8?B?c21WdTM4RTBLaTdsbjc4c0hvMm1lcnVXWnhWUy9MK2UrdldycS9VMUxVZkwx?=
 =?utf-8?B?eVEwQlhYSVljYWhJeGZ1Q3lvTDhySnBWcTVBejFYdUVIZ0FKcWhiWW00MTc5?=
 =?utf-8?B?R29uMGg0cFY3aXJXb0Q4dnRRcExZR0o5SWNWVkZhbkVkR1NlLzNRbm9vSTNh?=
 =?utf-8?B?VEhLVDlnNENndFJ0U0JNa0lieUs5Y3dKZTl6WWdHRVh4ZUFCMFBraDZCYzFt?=
 =?utf-8?B?WktvRk0yOTVveHlVc2xPU0FsaStmaElkcUl4MnlsdHlMV3AyME5lMUd5VDRt?=
 =?utf-8?B?VElMZ0IwUXA4OFJlbFhkSUdoY0hHWVBTN1B6ZHVYUWJ2QWtsRkIzMm0xZEhJ?=
 =?utf-8?B?eFlzeHZTcDJFcDhqQTdaZkk2SUY2RktoL0VRUk1mK0VQV1dwVnBWSWtSa0hM?=
 =?utf-8?B?WnMrM01OaHp3WlkzbUtYMnU1NGdOd2duMTMvZnk3RUJqbk9CNFpJRmlUaTZj?=
 =?utf-8?B?dlZKSk13UTJwVUsySHJ3dHVxWW9PRGVsZStYbGVnSWlwdTNDalYrWGZwRTZy?=
 =?utf-8?B?NDUyTFBkdjM5WjJmMkIrd3ZVR1l1VGU2TUdlSmIxVTNYT3RaelRFWlVHRnFD?=
 =?utf-8?B?NnhSelVUNmh6SHVoVk5DSFVZQnVDMFN6NXMxZ1hxT09hM0N3aGdWTGtuZDlO?=
 =?utf-8?B?MjhDOXk1U1NvbWxPSHVmMFZJaXRKN1RDWkNvWG1BTzZrZUJDNy91cWJYVlRN?=
 =?utf-8?B?SVcyNElCVjJia3BiVmdSdEc1SUFDRFhIZngvU0lzRVM1anROWW9jcVU1S3M3?=
 =?utf-8?B?bDFSdjZmMUxVYVVHV3JTOWQybWYwam1haldEaE1ZSndoRlRVSWJtU0pQQlRO?=
 =?utf-8?B?ZGZTdERyQVlxeHZoY0s2YzRNQWtrak12bWhGZC93N2tLWStNZklDUStlc09I?=
 =?utf-8?B?VGxGbVZBZlNIR3BEZ3dRaC9PWEJGWGlhanhqK0piMXp3V3A2UjVGMGMxejht?=
 =?utf-8?B?UDFjV29MQ3FSamdkaGVrTnVYWDVJNTgvcUVMMENXK3BDeGJMZDlLdDBvbE90?=
 =?utf-8?B?T2FoRHkrRkxNdGc5SWN3bndEUEVUNEhQQVFQV3V1b2JXOTRsTnRMNHQ4WFRI?=
 =?utf-8?B?cVJGR0h0VmFWRk1majZzYzJBSS9JcVVvYzBvcDBtNFlIbkNEanhUMkQ4cVFv?=
 =?utf-8?B?MmJ4cjhOazdhNGtwdFNJb2FRVkZteVhTYkJReTFZeTYyK3pFbkVMaUdCTjVF?=
 =?utf-8?B?N3lBWmRJVlFLOXhUaDRZODE1UTIvbTN4U0liZmp1cjQxc0QyYThPeFJlR08r?=
 =?utf-8?B?Nk9pMkxsbm9MMmljV25KQWhHNXNaMlgycHhENFI0TDFJQXd5KzVvUllHKzRl?=
 =?utf-8?B?dGRsYU5qeU9CQzhBQ3Z1eEwrUS9ocFdJU08wbENseFpleitmdWNjdm5vVmJU?=
 =?utf-8?B?dURjVzI1cFl0S1orWjh6VXNuL1AyY1I0QVVEb0pDS3E1ZENRMEs5N1prNEU1?=
 =?utf-8?B?K2xOWHhjVTF4UkxDazR0cFBxdFQ5K3hxN042bTIyMURDbzdwQjkyMy9QOStB?=
 =?utf-8?B?YjQwVHRUOHZrOTVKd0Q2SWV2VjdUUjY5aWY3UW5mcXhFb1BwSE5xS1Nsb0R1?=
 =?utf-8?B?WUxEWXhzVUYwMCsxRFF0U1REZEk0azFMYzlGcUt5aHNGNEtXa2VlMloyb3ZZ?=
 =?utf-8?Q?OTr3gx36TUE0SqOsF6tSAtdIo?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffbb609e-4d1a-4ce8-927c-08dbbe344e3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2023 02:00:06.2975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6DkppmCy3Cmat86IlT0NOR5HQP4jKbzIlngbwJBmMK/mDtjj0GIMuhCheBPCVZtEtdN59d0q6DnrCNQW1KJ/Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8210
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

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBTZXB0ZW1iZXIgMjYsIDIwMjMgOTo0OSBBTQ0KPiANCj4gT24gOS8yNS8yMyAzOjAwIFBN
LCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogTHUgQmFvbHUgPGJhb2x1Lmx1QGxpbnV4
LmludGVsLmNvbT4NCj4gPj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAxNCwgMjAyMyA0OjU3
IFBNDQo+ID4+IEBAIC0zMDAsNiArMjk5LDcgQEAgRVhQT1JUX1NZTUJPTF9HUEwoaW9tbXVfcGFn
ZV9yZXNwb25zZSk7DQo+ID4+ICAgLyoqDQo+ID4+ICAgICogaW9wZl9xdWV1ZV9mbHVzaF9kZXYg
LSBFbnN1cmUgdGhhdCBhbGwgcXVldWVkIGZhdWx0cyBoYXZlIGJlZW4NCj4gPj4gcHJvY2Vzc2Vk
DQo+ID4+ICAgICogQGRldjogdGhlIGVuZHBvaW50IHdob3NlIGZhdWx0cyBuZWVkIHRvIGJlIGZs
dXNoZWQuDQo+ID4+ICsgKiBAcGFzaWQ6IHRoZSBQQVNJRCBvZiB0aGUgZW5kcG9pbnQuDQo+ID4+
ICAgICoNCj4gPj4gICAgKiBUaGUgSU9NTVUgZHJpdmVyIGNhbGxzIHRoaXMgYmVmb3JlIHJlbGVh
c2luZyBhIFBBU0lELCB0byBlbnN1cmUgdGhhdCBhbGwNCj4gPj4gICAgKiBwZW5kaW5nIGZhdWx0
cyBmb3IgdGhpcyBQQVNJRCBoYXZlIGJlZW4gaGFuZGxlZCwgYW5kIHdvbid0IGhpdCB0aGUNCj4g
Pj4gYWRkcmVzcw0KPiA+DQo+ID4gdGhlIGNvbW1lbnQgc2hvdWxkIGJlIHVwZGF0ZWQgdG9vLg0K
PiANCj4gWWVzLg0KPiANCj4gICAgICAuLi4gcGVuZGluZyBmYXVsdHMgZm9yIHRoaXMgUEFTSUQg
aGF2ZSBiZWVuIGhhbmRsZWQgb3IgZHJvcHBlZCAuLi4NCj4gDQo+ID4NCj4gPj4gQEAgLTMwOSwx
NyArMzA5LDUzIEBAIEVYUE9SVF9TWU1CT0xfR1BMKGlvbW11X3BhZ2VfcmVzcG9uc2UpOw0KPiA+
PiAgICAqDQo+ID4+ICAgICogUmV0dXJuOiAwIG9uIHN1Y2Nlc3MgYW5kIDwwIG9uIGVycm9yLg0K
PiA+PiAgICAqLw0KPiA+PiAtaW50IGlvcGZfcXVldWVfZmx1c2hfZGV2KHN0cnVjdCBkZXZpY2Ug
KmRldikNCj4gPj4gK2ludCBpb3BmX3F1ZXVlX2ZsdXNoX2RldihzdHJ1Y3QgZGV2aWNlICpkZXYs
IGlvYXNpZF90IHBhc2lkKQ0KPiA+DQo+ID4gaW9wZl9xdWV1ZV9mbHVzaF9kZXZfcGFzaWQoKT8N
Cj4gPg0KPiA+PiAgIHsNCj4gPj4gICAJc3RydWN0IGlvbW11X2ZhdWx0X3BhcmFtICppb3BmX3Bh
cmFtID0NCj4gPj4gaW9wZl9nZXRfZGV2X2ZhdWx0X3BhcmFtKGRldik7DQo+ID4+ICsJY29uc3Qg
c3RydWN0IGlvbW11X29wcyAqb3BzID0gZGV2X2lvbW11X29wcyhkZXYpOw0KPiA+PiArCXN0cnVj
dCBpb21tdV9wYWdlX3Jlc3BvbnNlIHJlc3A7DQo+ID4+ICsJc3RydWN0IGlvcGZfZmF1bHQgKmlv
cGYsICpuZXh0Ow0KPiA+PiArCWludCByZXQgPSAwOw0KPiA+Pg0KPiA+PiAgIAlpZiAoIWlvcGZf
cGFyYW0pDQo+ID4+ICAgCQlyZXR1cm4gLUVOT0RFVjsNCj4gPj4NCj4gPj4gICAJZmx1c2hfd29y
a3F1ZXVlKGlvcGZfcGFyYW0tPnF1ZXVlLT53cSk7DQo+ID4+ICsNCj4gPj4gKwltdXRleF9sb2Nr
KCZpb3BmX3BhcmFtLT5sb2NrKTsNCj4gPj4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoaW9w
ZiwgbmV4dCwgJmlvcGZfcGFyYW0tPnBhcnRpYWwsIGxpc3QpIHsNCj4gPj4gKwkJaWYgKCEoaW9w
Zi0+ZmF1bHQucHJtLmZsYWdzICYNCj4gPj4gSU9NTVVfRkFVTFRfUEFHRV9SRVFVRVNUX1BBU0lE
X1ZBTElEKSB8fA0KPiA+PiArCQkgICAgaW9wZi0+ZmF1bHQucHJtLnBhc2lkICE9IHBhc2lkKQ0K
PiA+PiArCQkJYnJlYWs7DQo+ID4+ICsNCj4gPj4gKwkJbGlzdF9kZWwoJmlvcGYtPmxpc3QpOw0K
PiA+PiArCQlrZnJlZShpb3BmKTsNCj4gPj4gKwl9DQo+ID4+ICsNCj4gPj4gKwlsaXN0X2Zvcl9l
YWNoX2VudHJ5X3NhZmUoaW9wZiwgbmV4dCwgJmlvcGZfcGFyYW0tPmZhdWx0cywgbGlzdCkgew0K
PiA+PiArCQlpZiAoIShpb3BmLT5mYXVsdC5wcm0uZmxhZ3MgJg0KPiA+PiBJT01NVV9GQVVMVF9Q
QUdFX1JFUVVFU1RfUEFTSURfVkFMSUQpIHx8DQo+ID4+ICsJCSAgICBpb3BmLT5mYXVsdC5wcm0u
cGFzaWQgIT0gcGFzaWQpDQo+ID4+ICsJCQljb250aW51ZTsNCj4gPj4gKw0KPiA+PiArCQltZW1z
ZXQoJnJlc3AsIDAsIHNpemVvZihzdHJ1Y3QgaW9tbXVfcGFnZV9yZXNwb25zZSkpOw0KPiA+PiAr
CQlyZXNwLnBhc2lkID0gaW9wZi0+ZmF1bHQucHJtLnBhc2lkOw0KPiA+PiArCQlyZXNwLmdycGlk
ID0gaW9wZi0+ZmF1bHQucHJtLmdycGlkOw0KPiA+PiArCQlyZXNwLmNvZGUgPSBJT01NVV9QQUdF
X1JFU1BfSU5WQUxJRDsNCj4gPj4gKw0KPiA+PiArCQlpZiAoaW9wZi0+ZmF1bHQucHJtLmZsYWdz
ICYNCj4gPj4gSU9NTVVfRkFVTFRfUEFHRV9SRVNQT05TRV9ORUVEU19QQVNJRCkNCj4gPj4gKwkJ
CXJlc3AuZmxhZ3MgPSBJT01NVV9QQUdFX1JFU1BfUEFTSURfVkFMSUQ7DQo+ID4+ICsNCj4gPj4g
KwkJcmV0ID0gb3BzLT5wYWdlX3Jlc3BvbnNlKGRldiwgaW9wZiwgJnJlc3ApOw0KPiA+PiArCQlp
ZiAocmV0KQ0KPiA+PiArCQkJYnJlYWs7DQo+ID4+ICsNCj4gPj4gKwkJbGlzdF9kZWwoJmlvcGYt
Pmxpc3QpOw0KPiA+PiArCQlrZnJlZShpb3BmKTsNCj4gPj4gKwl9DQo+ID4+ICsJbXV0ZXhfdW5s
b2NrKCZpb3BmX3BhcmFtLT5sb2NrKTsNCj4gPj4gICAJaW9wZl9wdXRfZGV2X2ZhdWx0X3BhcmFt
KGlvcGZfcGFyYW0pOw0KPiA+Pg0KPiA+PiAtCXJldHVybiAwOw0KPiA+PiArCXJldHVybiByZXQ7
DQo+ID4+ICAgfQ0KPiA+DQo+ID4gSXMgaXQgbW9yZSBhY2N1cmF0ZSB0byBjYWxsIHRoaXMgZnVu
Y3Rpb24gYXMgaW9wZl9xdWV1ZV9kcm9wX2Rldl9wYXNpZCgpPw0KPiA+IFRoZSBhZGRlZCBsb2dp
YyBlc3NlbnRpYWxseSBpbXBsaWVzIHRoYXQgdGhlIGNhbGxlciBkb2Vzbid0IGNhcmUgYWJvdXQN
Cj4gPiByZXNwb25zZXMgYW5kIGFsbCB0aGUgaW4tZmx5IHN0YXRlcyBhcmUgZWl0aGVyIGZsdXNo
ZWQgKHJlcXVlc3QpIG9yDQo+ID4gYWJhbmRvbmVkIChyZXNwb25zZSkuDQo+ID4NCj4gPiBBIG5v
cm1hbCBmbHVzaCgpIGhlbHBlciB1c3VhbGx5IG1lYW5zIGp1c3QgdGhlIGZsdXNoIGFjdGlvbi4g
SWYgdGhlcmUgaXMNCj4gPiBhIG5lZWQgdG8gd2FpdCBmb3IgcmVzcG9uc2VzIGFmdGVyIGZsdXNo
IHRoZW4gd2UgY291bGQgYWRkIGENCj4gPiBmbHVzaF9kZXZfcGFzaWRfd2FpdF90aW1lb3V0KCkg
bGF0ZXIgd2hlbiB0aGVyZSBpcyBhIGRlbWFuZC4uLg0KPiANCj4gRmFpciBlbm91Z2guDQo+IA0K
PiBBcyBteSB1bmRlcnN0YW5kaW5nLCAiZmx1c2giIG1lYW5zICJoYW5kbGluZyB0aGUgcGVuZGlu
ZyBpL28gcGFnZSBmYXVsdHMNCj4gaW1tZWRpYXRlbHkgYW5kIHdhaXQgdW50aWwgZXZlcnl0aGlu
ZyBpcyBkb25lIi4gSGVyZSB3aGF0IHRoZSBjYWxsZXINCj4gd2FudHMgaXMgIkkgaGF2ZSBjb21w
bGV0ZWQgdXNpbmcgdGhpcyBwYXNpZCwgZGlzY2FyZCBhbGwgdGhlIHBlbmRpbmcNCj4gcmVxdWVz
dHMgYnkgcmVzcG9uZGluZyBhbiBJTlZBTElEIHJlc3VsdCBzbyB0aGF0IHRoaXMgUEFTSUQgY291
bGQgYmUNCj4gcmV1c2VkIi4NCj4gDQo+IElmIHRoaXMgaG9sZHMsIGhvdyBhYm91dCBpb3BmX3F1
ZXVlX2Rpc2NhcmRfZGV2X3Bhc2lkKCk/IEl0IG1hdGNoZXMgdGhlDQo+IGV4aXN0aW5nIGlvcGZf
cXVldWVfZGlzY2FyZF9wYXJ0aWFsKCkuDQo+IA0KDQp5ZXMuICdkaXNjYXJkJyBzb3VuZHMgYmV0
dGVyLg0K
