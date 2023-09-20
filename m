Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCEF7A75A9
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 10:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjITITR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 04:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbjITITK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 04:19:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58620E6;
        Wed, 20 Sep 2023 01:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695197941; x=1726733941;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZhWMOChsCZxUb6si/Tzng9Pk/ALO9A+UEzdgmdBxZi8=;
  b=ZGxxypDpKFj9HtoGXCRucd8ZuNZuy/YxCfM9YJUtsXefWu+MH+/xE7qU
   NSvJKU3pdx2U1GShXFjyTVbKoqJVMf0tjQ2i6oEWLUx194cJe/eDddS/X
   eUR8ZUXCmJjAhENR8d2MVdkoHZLYo74fReeZUQVfjKQwOti9dcYsFgKaI
   JhpJmQMqR9Ecsxr5tqcl7OUm3t0hWDRkvFj3Y9NfziR9KAXTL7UV9/Naj
   egFJlcQbp0e871wI79nK8FlDMl/xdtDXkZtYxt9tYA0vYmyn7C5jc+ArK
   h8CtbRk0RVBlqmwVmUFjPhORMjVNAlYKhe9OtWc2IyNe8ZwGMA6pWmP5n
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="380064541"
X-IronPort-AV: E=Sophos;i="6.02,161,1688454000"; 
   d="scan'208";a="380064541"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 01:18:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="749800944"
X-IronPort-AV: E=Sophos;i="6.02,161,1688454000"; 
   d="scan'208";a="749800944"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Sep 2023 01:18:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 01:18:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 01:18:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 20 Sep 2023 01:18:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 20 Sep 2023 01:18:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnoQFKx4vtu/hDKNKuqIXj2lhzX0H6QDCe+LV422t4w43U1Fe7rbTGv0Jy9JA8ZlxQEqCeEcSgPGLWOrdToG0p24BlwfRpwqtoWs88gF3EiJLn91xJJnfjkDMoEflDblyP2tHky+s/H21Wqokg1gychx+tZbYvSyFJ7zxYEsPrGv7SxbdfpxSWYaj9qJCA0l6uMoKJK4je94HXYkMR8NMAeqkk22whsLSd/6NUhzeb0ybvJuDGJ42z7PVpwlXo6CHgK/lsKKOIeU1lzAiFUnZvOxmW3ehQsEG3w5hkuTGl8LSj9q+arsAze3QCQq3MdMO95Xa2ZN+93Ph922EKy+iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZhWMOChsCZxUb6si/Tzng9Pk/ALO9A+UEzdgmdBxZi8=;
 b=aR5lCQSDh5KQ6H3L5+wnl478BdMM/Rlkdi8qlTMTlyh/OCeZgEKw6nDQxitaIlYxfxXNmATCg6GHvFROzl4IGWwUpfVzxae9YkGNtCnHrRIlmHsj3ZNvRw7q6nw2S4Fy+oKmB0U0AHuW+hhCJL2XqgHhm0FsyxPV3V/aXS8l5RGoFeQFrPxSodxvNjClKlvwUG7wZxfuxsDHfYPOFtMIQu8KOdEVnXeuKPL870cgm2HJtXzLMt7wj0zJgSikMBddXKUj2+YfO5i2xvIh+vxAsIUwVCgj9CPCc9W1EUhHJ8H/+EXC4rmVK/QJ9jAfLVzshK2kjVuuZf227P1QR9xVjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH0PR11MB5659.namprd11.prod.outlook.com (2603:10b6:510:ea::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Wed, 20 Sep
 2023 08:18:44 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%5]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 08:18:44 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Nikolay Borisov <nik.borisov@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
Thread-Topic: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
Thread-Index: AQHZ5ssSXb894LHEBkqZUWtDh9samLAjYtKAgAADDuA=
Date:   Wed, 20 Sep 2023 08:18:44 +0000
Message-ID: <SA1PR11MB6734F205C2171425415E4F00A8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-4-xin3.li@intel.com>
 <dda01248-f456-d8d7-5021-ef6b2e7ade2c@suse.com>
In-Reply-To: <dda01248-f456-d8d7-5021-ef6b2e7ade2c@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH0PR11MB5659:EE_
x-ms-office365-filtering-correlation-id: c5cfb639-8560-47d4-801b-08dbb9b23499
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kj++hWDUjB1kERo6XUk7wmzS/0+HA2vnsL9f0LradaEmCvTZkosNoNTBm55tU1kxGglrFClquIRjFCD185l6yBZc1cbhz6MCiHRMzTTH5iYNsk4NcvYlrkQOxbne8Q7lpopPc9yDroTCdV3pqO54ABa6MP6DCwEU7S467fGNdaPoTq6/Um9vVy4CXwvayVEtt/eS2i9v/YF7KljEYvfYWWEcqpqW0WtejZhk5nrMeu++rHyUCFWLytnMNJfGi/mbMe/FDe/CSGAKveUrO7t0MPqTbZwI4VoP1Hr7sk4j5b/0mP+ef/RbWh1B/i2DAF72PWrIMmM7xL8z42Nt2Q9UUPcmctZ+m3bN/XXA2UXDPpnt+gSbfF036m1RE8Wmy1sUKgH/AM19cANDg4yEwxxsEO3qDFFwDvAUrNRzkL11JZfQZe23yx52OvAAIVjGfDZYp0crD2gWKWi51iL2IbCMIzN6CeIiKUjQfpyzZqNKALnWIi/X/tQnNGHV1qH0IdO8Qs5xyKbFj1YD8ObZ1y5XmdLMHPEd2TDgJQnyuBXE8eINDugjMrO+Ga/p7dpIzO4a7kNhfZTbZatXPr8211+0cuK20LS501JHU5siobdAWAjhKvHDkf2M1lw6j0h5gfIu4oaE/TJbTK/5YJ+zDgU9mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199024)(1800799009)(186009)(316002)(4326008)(5660300002)(6506007)(9686003)(7696005)(41300700001)(110136005)(2906002)(64756008)(8676002)(8936002)(54906003)(66446008)(66556008)(66476007)(66946007)(76116006)(4744005)(52536014)(7416002)(478600001)(33656002)(55016003)(86362001)(122000001)(71200400001)(26005)(38100700002)(38070700005)(82960400001)(133343001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjhVVHB3aUpiU0huVk1oMXJwWll3dHFvenRDYmZqWW5waEpGeG5CUC94WGNF?=
 =?utf-8?B?aWdhOU8vUldrRzJibW0vZk9TWXVrNjkwZnVmbU50ZFVyQmNjbEZaWDVDMnlw?=
 =?utf-8?B?cktDeEIxaUcvVWVxZ3RWWjBBWGNLN05lSWhuOFJzaytYallrSDlDQWRaY1Zq?=
 =?utf-8?B?TjB1bHlQRXQ0VlpBcW9iVjloMzZna09RVmdWSUNQRnF1aXllWUlZMkk5SHlq?=
 =?utf-8?B?dHdHa0tTL1lhSCt5V0xmUENNb2xEbmMvUS9QU08yZTl1YUR2MTdHWGN0cllZ?=
 =?utf-8?B?YVdnUElmTVJSMmhBVHZncGU4T0hwSFo5ajlsT2tVU01ORExGaEdsYzdlNkh4?=
 =?utf-8?B?UUNleFRMQ1RSYkVndnhxa0lRK1FTU0s2Y1puMGw0bmFxdU8wZEQrY1dtSnBK?=
 =?utf-8?B?Y2dZU2Rhd1pNM25aSVBQUFlmSFBla0dqN2tYSlgvazlmN0dicHhYb0lhOTF5?=
 =?utf-8?B?VGorUjNjZldVY0M5aGJYYlpDVnRQKzBFQkcrN05nelhYd29JeFRQNng3NkMx?=
 =?utf-8?B?ckxIUjNORFNCZ1IvRDRoSzltcXhPL0hwaUg5T1Qvd0ZxNFdDbExyZGRybkVu?=
 =?utf-8?B?dnhFWGNrTnZXNzB5UnN2bDNnY05zeENBZFlvNHplcEdnUDlUZTFrckRBWlRh?=
 =?utf-8?B?Q2dhWG4xbFNwNGFGMWk1WENIV1RRWGJmNzBzYU5nVmpXWEFOaHNSMVROMXZn?=
 =?utf-8?B?a05DMGY5UkVTakxQNGxQdjcwaHVFYWprK3lmTHNtUHY0VHN4VUs1cnhIMW81?=
 =?utf-8?B?VnJpNDU1b3EwOWozK2tzMW9YLzMxT0s4V3JCMWN5OGxNTldIT3oyLzFxcERo?=
 =?utf-8?B?YjNPckpBZlFSb3hBL0hEM3dNSUNkSWRPN1ZkVEV5QTZJRHl0UnMrZGJqSTdj?=
 =?utf-8?B?NTRBRlgxbHpFNE4wdkJuUUt5dzBQNmk1MlFwL3o3QVBJUVhRcXFOZHB5ZnBx?=
 =?utf-8?B?MzZFNXBZbFN1M2NRZXl6ZWk1RHEzaXg5TGlKbnFiVHZJMzFXSk9uSlhDUkdS?=
 =?utf-8?B?ZEwvdHI5dEVYc2dNUG04bm1ubWh4dWZTRzBzSHVUNUFGaFFIMGhJWGsvQ3JN?=
 =?utf-8?B?NW8rNERsM01zOTJKdk1SdHB1U1Vka0pVTXZrTG1YQWVXTm9CK1dyQXRQQ2NC?=
 =?utf-8?B?NmhycUVxZTdQZXhjK0gxRVF2MTBZV0Q5K3EvUG1ISkxXWkZmSG5XZVV1amFE?=
 =?utf-8?B?NSt3UzNmdnhYbUZ3eVZmU3VSTnNmVVFVNlFoSHd2UHJaMGM4c000ZHUvWU1v?=
 =?utf-8?B?MkdkdTJQVHZIQzloaWNXbm9Dc1hOcXV6bGFmVVVUNjdqWEZsOWI4ajlSTWV3?=
 =?utf-8?B?aFpERkFKc3hvcEFqSWtuSTJkUmFibkpXK2tYSmdzWjVGYWdMTnZoZGU3YzNp?=
 =?utf-8?B?SDgxR3lMTzd5TGlzOVFmOFV6WVZSUFJUMHdZcm1rS0NaU3ZuSUh4SnJkQWc0?=
 =?utf-8?B?ZGtFdC9mRHJ6SzFtUWtoL2dNN3pETW5BbnhIUW5rMWozSGlTUVMyR0I0VHFQ?=
 =?utf-8?B?VUc4cE1zbWNld3ZhVFRZWGRyVWJPVVlpVXdoeXpIUmwvb2hGOWkySmtGZTJX?=
 =?utf-8?B?Z01GZ1BrOCtXZ2t2NWYyTDNaNGtxOTFrcVJxM0VyNCtKQU5OeWZ1T3RRRVdq?=
 =?utf-8?B?ZG1vb2d4ODlFd2NRcmtObDVQaWdTM1hXUU5EZVI3TUZCWVd1d3Y0bDUvcE1a?=
 =?utf-8?B?MHRkL1Y5YzI3aUZ2RUdmaThOdjNCUy9udWw4c0RBVUhMZWFvRGFNaEZybms2?=
 =?utf-8?B?R2ExQmgvMmo4Q3JMNENFNDdIZlNoeitBdFViUERuVHVmakZBQjJOQ1FHL3hu?=
 =?utf-8?B?a0xkaG0weVp3cms2Ulc1dzlrRlk4ZHNCVG9KZVJodlpheDIra1Rxa09ZY01z?=
 =?utf-8?B?enBrcHZpYm1aL2xjeEw4VVpmak9aTTkrZ1RrNk0rWjB0cG9SbGs3TnJROEo1?=
 =?utf-8?B?SkI1Q1RPUmJVcFl6T3prbGc0WXUyODNhMXBaVnBpeFgyVXVSaGxteTdxVGhw?=
 =?utf-8?B?VVVrWkxCOFl6ejVqRnY4U282RG04Z0Q0Y1VyT0o5ZlRQeWhBYWJLNDNqTVA4?=
 =?utf-8?B?NmFlakNLTU51Y1RzRjdicWVxRHN0WWxrTzBlWlU3d0RnRk5SK0ZCOVR6L3FS?=
 =?utf-8?Q?UWubnnhQrK7EkXs4bODhpyjbF?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5cfb639-8560-47d4-801b-08dbb9b23499
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 08:18:44.0368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wWT6le60h0yJoVf/hI2kPwb+KN8e3Tczz+1WKb9BSIm/CXNBdBXjgCcrsV+R9F4aI+QS0GNR5pdDw7HTmC/vyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5659
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ICtzdGF0aWMgX19hbHdheXNfaW5saW5lIHZvaWQgX193cm1zcm5zKHUzMiBtc3IsIHUzMiBs
b3csIHUzMiBoaWdoKQ0KPiANCj4gU2hvdWxkbid0IHRoaXMgYmUgbmFtZWQgd3Jtc3Juc19zYWZl
IHNpbmNlIGl0IGhhcyBleGNlcHRpb24gaGFuZGxpbmcsIHNpbWlsYXIgdG8NCj4gdGhlIGN1cnJl
bnQgd3Jtc3JsX3NhZmUuDQo+IA0KDQpCb3RoIHNhZmUgYW5kIHVuc2FmZSB2ZXJzaW9ucyBoYXZl
IGV4Y2VwdGlvbiBoYW5kbGluZywgd2hpbGUgdGhlIHNhZmUNCnZlcnNpb24gcmV0dXJucyBhbiBp
bnRlZ2VyIHRvIGl0cyBjYWxsZXIgdG8gaW5kaWNhdGUgYW4gZXhjZXB0aW9uIGRpZA0KaGFwcGVu
IG9yIG5vdC4NCg0KRXhjZXB0aW9uIGhhbmRsaW5nIGlzIGEgbXVzdCBmb3IgV1JNU1IvUkRNU1Ig
YW5kIHJlbGF0ZWQgaW5zdHJ1Y3Rpb25zLg0KDQpUaGFua3MhDQogICAgWGluDQo=
