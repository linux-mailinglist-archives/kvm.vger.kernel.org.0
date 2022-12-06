Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0A8644ABB
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 19:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiLFSAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 13:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiLFSAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 13:00:51 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F0331224;
        Tue,  6 Dec 2022 10:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670349649; x=1701885649;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fyB/aFWq90Bxw+lvrllH61zUb7mk4R/S0I+MXeLYWnA=;
  b=JIw+yZptFn2a49qpwhuGJjzf8GwYalt5UGSsmN1hGsEuzMEXkUuxsn9r
   y7bBPAcwwHziK96kjqy395oNhfIOz/5BJiDHrPviSYe/d7xg/WHeRO+Jh
   RMSCO8X7G34ZLDAEs61JN9cbsN2PblfMfhOFjv7goEA8bvfjICyVqsRvh
   9SE1iwSxAZzi8+JG924/L9Ueysf2bYJFjuaFWDfKIlxMcLTxkhQvwKPFt
   /d+EZuEhgbI3m+vTxyIIwU27b1euwWnaLwTh6Y9qKRuxCtoWAl+w4UrM4
   Apm6gRpzp8lsnNSaSZWstuOKbHkBNJE5Yo0ihuf/KJ6Yu1yXMTRuNa3ia
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="317830384"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="317830384"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 10:00:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="648422088"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="648422088"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 06 Dec 2022 10:00:46 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 6 Dec 2022 10:00:45 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 6 Dec 2022 10:00:45 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 6 Dec 2022 10:00:45 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 6 Dec 2022 10:00:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VS6cn7XrEL1luAz5P8LH7wHzgjMCz5TIoVowhEOSkya8WsRzjzt7DQpi7R9STp28OhSvgfTjd1dlA47nD0vVdFSXEbYj7dS/SIbuQfNQpnQfgwe1kXJ8vcVa8raBWacieaTZoUegOwqnNQwVWv0DLmGcmOsdYWNJMY9Ri9RZE18sm3Qp0olVDUKejW/OYkdW7ynBv5deAHjGu8CVeJiPR73sORzpyiDgoDeihwjaMF+qQk/ytuC86eYFKKOGSTGyn+rXxjQMZtjCPYn36OzsY7BmRYzIaV7fCKW+A/qaqvFAxVICUAoYoXiVCJ5XRWOWPZFfMQq8rojJcAxdfQjIjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyB/aFWq90Bxw+lvrllH61zUb7mk4R/S0I+MXeLYWnA=;
 b=G738UEb+FXES9CeGgcop4UV36uUqFN5lkZFVoj5L73otkwILS6uLvlRdl2yseTrfEo3DftSj1qWRH4W6IgeU7OASyV7kEQzU0clYtzX3AFxH6/VmDhn6um13au040aEh54RRdJ+6QlStl+raZF2VxZJOujxkQNlviQDcTcNqAQqcTSTL2GNMJBg63IcwzxEodNRgBFulnnOtGtKo+AZbBz2b8XMDbxSTTBD6pds5ixNficyoYriPNYDHnmdWTUIix990JLnxY8hLJiqXMiigIcZdSoffpSeVUxnyHrpYLKElNVBymQ9C+McN0sqD+0EiH+kG5loRmuSFLRugK3faxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by MW3PR11MB4602.namprd11.prod.outlook.com (2603:10b6:303:52::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 18:00:28 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::bf35:8df2:dcf2:1232]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::bf35:8df2:dcf2:1232%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 18:00:27 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     "Rao, Lei" <lei.rao@intel.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "kch@nvidia.com" <kch@nvidia.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Li, Yadong" <yadong.li@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        "stephen@eideticom.com" <stephen@eideticom.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: RE: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Thread-Topic: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Thread-Index: AQHZCXNosqFTJfydg0+OZdpafJHfL65g1OqAgAAMQgCAAAH/AIAABbMAgAADEgCAAAS8AIAAA6yAgAAHdQCAAAIdAIAAJEEQ
Date:   Tue, 6 Dec 2022 18:00:27 +0000
Message-ID: <BL0PR11MB3042F27C99080E4B51318B338A1B9@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20221206062604.GB6595@lst.de> <Y48+AaG5rSCviIhl@ziepe.ca>
 <20221206130901.GB24358@lst.de> <Y49JNvdmRPNWw26q@ziepe.ca>
 <20221206140002.GB27689@lst.de> <Y49PqoAhZOeraLVa@ziepe.ca>
 <20221206143126.GB30297@lst.de> <Y49WNo7XWZ2aFfds@ziepe.ca>
 <20221206150131.GA32365@lst.de> <Y49fjFD6foGorhmp@ziepe.ca>
 <20221206153546.GA2266@lst.de>
In-Reply-To: <20221206153546.GA2266@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3042:EE_|MW3PR11MB4602:EE_
x-ms-office365-filtering-correlation-id: 94c349a3-1b7f-45ae-8a12-08dad7b3c1b1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QzJ0PlQjA4uM4uVoNJyybpxstmeUABZ4VG/DlrpttTS02m0Dyq5O2dyZYqfJ1pypW9CHKnXcUlLnMOHfeDsg9eK0xniSEtiTnq5eVgUdxuhB8yZvkAafyzY766yY1/RUZA4iIcSaP89IotXFeNj8Ian8DDnhyS/iKMUzW2EKRbmWn2vjp0PrsIKNgPgbt39EsYPigAVShOXjY2yzyvWdH7YkyVTnMW8PL920J0QJqEqIrGbr1bil0gFnNuk8WNEMeKH+NCZ8SSRtoQhI5S8MKNxEhzXfLqCeEaiPROvJwBTh7ultZKYb71paoLxENNgT2uRqD0sln2LcagCZP3ESOfYw5kKo7r1PXxjLKpz+eiis4BuOB2mxYWCF5LFlW8Et/mCk7edFci05u/pmX+8GkOBeVgoaf5XaaP9gB2Eh/Bpe54bRZAXkZBwkxtQ84Ps36tkHdJHe9XpQFA8yIsivrO+VGtImhG8hsg3FqUFbwVGsyTJ40XcrnWC8sq82i6b3aAhbv9DqKz/FnkUtios/NQEa8f2vlspMk/3M97Ug46cR5r1c5/T9ynUIFh9CbAwI85eQNQmyrtONA4yKFu81tbAjDBcfzgSPUP1foRBCvwzBmHBu8o+UWaCBOXaBwVw6sJJ1S0cBvqz37POr51D631lD2JAr+zwSZYo/0s49bjrY30jklxHnHL6Vbv7i+0JDWrx6LLpK/xtEC69TGpcTew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199015)(83380400001)(122000001)(82960400001)(86362001)(8936002)(5660300002)(33656002)(2906002)(38070700005)(7416002)(4326008)(41300700001)(52536014)(478600001)(8676002)(55016003)(186003)(26005)(53546011)(7696005)(64756008)(9686003)(107886003)(6506007)(110136005)(66556008)(66946007)(54906003)(66446008)(66476007)(316002)(76116006)(38100700002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjZiQVZIMzRzSzFiNXJQUFJZcEF2NjhaMk1oTEd5R3FRZ2FHODcwQ3cvaDM1?=
 =?utf-8?B?eW9OSEFSREJXc2xZcTNucEl6dithVUZUY3B2NlluVVB4cFRTQlRGZHBJcDJz?=
 =?utf-8?B?Wm1HQkp2QVdzbkx0c1VIc3YyRXRrUjMyeklvaERhckZkOHZKRGZrSnZ2Umtx?=
 =?utf-8?B?aFkwUjZSSkRzdklXL3NGWXlMUWg5ajJKYVZJeDFaK0lRdy9mSWF3QkdMZXZR?=
 =?utf-8?B?aElwSWQrVTNleWlCZDh1WHVIdjZBSWowQ2RLN2Y3V2l6cWNvYjVLTHdlVWpj?=
 =?utf-8?B?WWVEdzgwVUJKeGYxY1oxa1pUdmtsN3pmUi9CSXN3clQwQ2xQSjk1QmZvVEQ2?=
 =?utf-8?B?TnFBY1VmTzdwS3N2ZnY0NHpHcEFXdi9PT3gyS2cxTWF2MkhPelBPQis0dDRK?=
 =?utf-8?B?VDdRS3kwT0Z1VkVvd05LQXhqVXlERkluRTZCeHhTanUvM2pJWE0xbWdtNlQ3?=
 =?utf-8?B?b2lTbUhzdmx5dE9RWmJmNkFDSDlUSXNETWtKdWdIdmZLNHBMSm9DY3dxd1pB?=
 =?utf-8?B?YTBPTXk3Q0RZTlZRNGxScUtIcGJON1RjNXZ4b0lMblBkSDZad0hCRUZJNW82?=
 =?utf-8?B?VmFVMFV1OUhYR0JOb2tuZk9abDNLUWlQYTY1MTZ3WTBZc0pINVNwUGJyV3Qx?=
 =?utf-8?B?SXpZK2pzbklpZUpucEUwYTJrNXl6VHZkd1JlZG9OdjFqMTEwWm5NZE00eHJx?=
 =?utf-8?B?dnVuM2ppWkp5aVl3TTloU2gzbmJPTlk1SU9HcEdzVXRWMm8rbWJnTHB3ME9P?=
 =?utf-8?B?RUozRWJkSk5UWGNPeXVLckw5WEJGb3Y1L2gzb0Z3RXY3bFVpVXpKWmM5d001?=
 =?utf-8?B?Zy81U1o4aVRXTTcyVmt6YTEvbGQySWJzMW5jakQrVFdFY3g4T1RwTE1WdkNC?=
 =?utf-8?B?WjU3bk5OSURnUXk5UEVReFNKRXBZcDBRL09tRWFaaGtjMXFxRWFsVU5lN203?=
 =?utf-8?B?V0tzb29IdVVaNm9KUzU2T1NyWXVNNWF4cUFZR0R5OTB6M1VLMVJoSU9xakNG?=
 =?utf-8?B?dTFReEowOEcweE5ic3lCaTA0YmZ4QlBoS0NjNDdwTk9JdW5aaHNEVzQyOTZE?=
 =?utf-8?B?Znlna0k0cnlwZlR5Z1VveFZOMDhDOG9TWTl6aFhOZzFFYWp6VFdEOEJGSXNy?=
 =?utf-8?B?TkZIK2wrcmNiN2hZUjBhbEpVcjd1cFpHaGhLNEVQcDBSU0l5YWhkNzNZNXkr?=
 =?utf-8?B?bFkzYlFDeUhPNFFUSXlOMUxyS2ZibjZQSU04YTFFSkVsODNYNHgzbWtCcDh4?=
 =?utf-8?B?dW8wUUt1UnNGYmtxZHVFbXhpdVd2UGlzQlZleFFaKzhHdi94U3Q0cXZNcXVZ?=
 =?utf-8?B?a0xGUzVFQ2NzQ3dldUJ4bHlwVSs5YkVVdEI0L1NPQzBzNDQ3aldOSnlXTmY0?=
 =?utf-8?B?Q2pVRC9vckFnbFh0TWRRM3pvNGFVa2xocHNieDBIaEdvbkhodktXenR1UGdR?=
 =?utf-8?B?WjBWOUhrZ3lnSXh0Uis1T1Z3U3ArSjdSbFpkWGVrMnduV1p4aGp3RTdmL29p?=
 =?utf-8?B?alBRYkxYcWZTTTd4YVBzTmxQeE1UcmVVVlNuTGd0aCtPZHBZeFJrZktJS2ZN?=
 =?utf-8?B?WDF5R1g0K1g3Zlo3dXlHVWJYWDNEMnVYd2FNRXZzdjV0cS82b2FlQXp5MmtP?=
 =?utf-8?B?dlBSWmtFaHFIZmd5UHRmZmpvNkVzM3ZBNGNnZlZmRWJmQ3JQQnJmTUI3OU1n?=
 =?utf-8?B?UjBUd0toZWVvY0F0RFNZVmMwQmtJS016enVrU3hHSnJiNUU5K25SVmNWenlx?=
 =?utf-8?B?anBFalgydWhxbVNSRVA1ajFsbFNZelp5SXQ2NWtMQm1sQ2I0ZENMdFNaanNX?=
 =?utf-8?B?d1g1YkdFWWtRV2JENjFNeVBPRUN5S1pnb0J3NFdxWUpIenp1UDgwWnR1MlNG?=
 =?utf-8?B?a2xQZ1dyWlgrWTRlUnpFcExJS0ZHNWc1NFFJVFk1cHJBbWpXSlJYdzlqeFh0?=
 =?utf-8?B?YnNGMlJibDlxTXZkRlU4NE96aE5UZk9UbVlxazVITm4rSERDVC83U0ZSem81?=
 =?utf-8?B?T0E0bzcwZkF5RUZxOExLMkFXQXJVdnJyNXo0UmdEQVAxYmFqODFLT2QzRjJq?=
 =?utf-8?B?UzkyTHA2b2dmSW5xeFA0aEhTQXpYdVdNK3dkN2hOdUVBaUVtUGhJQktJQWs0?=
 =?utf-8?Q?cspxiMMzYNlw6rir3ky4sfO2V?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c349a3-1b7f-45ae-8a12-08dad7b3c1b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 18:00:27.4477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /SrAs2qtuC0rxQ8FDcngEmPfbi8CQYjm6N7zfr9qWT6GDWqkwnWHByZVvegymM7gt2l/ju/7IZBUmVCGk/c9og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4602
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2hyaXN0b3BoIEhlbGx3
aWcgPGhjaEBsc3QuZGU+DQo+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDYsIDIwMjIgNzozNiBB
TQ0KPiBUbzogSmFzb24gR3VudGhvcnBlIDxqZ2dAemllcGUuY2E+DQo+IENjOiBDaHJpc3RvcGgg
SGVsbHdpZyA8aGNoQGxzdC5kZT47IFJhbywgTGVpIDxMZWkuUmFvQGludGVsLmNvbT47DQo+IGti
dXNjaEBrZXJuZWwub3JnOyBheGJvZUBmYi5jb207IGtjaEBudmlkaWEuY29tOyBzYWdpQGdyaW1i
ZXJnLm1lOw0KPiBhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbTsgY29odWNrQHJlZGhhdC5jb207
IHlpc2hhaWhAbnZpZGlhLmNvbTsNCj4gc2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWku
Y29tOyBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+Ow0KPiBtanJvc2F0b0BsaW51
eC5pYm0uY29tOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gbnZtZUBs
aXN0cy5pbmZyYWRlYWQub3JnOyBrdm1Admdlci5rZXJuZWwub3JnOyBEb25nLCBFZGRpZQ0KPiA8
ZWRkaWUuZG9uZ0BpbnRlbC5jb20+OyBMaSwgWWFkb25nIDx5YWRvbmcubGlAaW50ZWwuY29tPjsg
TGl1LCBZaSBMDQo+IDx5aS5sLmxpdUBpbnRlbC5jb20+OyBXaWxrLCBLb25yYWQgPGtvbnJhZC53
aWxrQG9yYWNsZS5jb20+Ow0KPiBzdGVwaGVuQGVpZGV0aWNvbS5jb207IFl1YW4sIEhhbmcgPGhh
bmcueXVhbkBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIDUvNV0gbnZtZS12
ZmlvOiBBZGQgYSBkb2N1bWVudCBmb3IgdGhlIE5WTWUgZGV2aWNlDQo+IA0KPiBPbiBUdWUsIERl
YyAwNiwgMjAyMiBhdCAxMToyODoxMkFNIC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+
ID4gSSdtIGludGVyZXN0ZWQgYXMgd2VsbCwgbXkgbWVudGFsIG1vZGVsIGdvZXMgYXMgZmFyIGFz
IG1seDUgYW5kDQo+ID4gaGlzaWxsaWNvbiwgc28gaWYgbnZtZSBwcmV2ZW50cyB0aGUgVkZzIGZy
b20gYmVpbmcgY29udGFpbmVkIHVuaXRzLCBpdA0KPiA+IGlzIGEgcmVhbGx5IGJpZyBkZXZpYXRp
b24gZnJvbSBWRklPJ3MgbWlncmF0aW9uIGRlc2lnbi4uDQo+IA0KPiBJbiBOVk1lIHRoZSBjb250
cm9sbGVyICh3aGljaCBtYXBzIHRvIGEgUENJZSBwaHlzaWNhbCBvciB2aXJ0dWFsDQo+IGZ1bmN0
aW9uKSBpcyB1bmZvcnR1bmF0ZWx5IG5vdCB2ZXJ5IHNlbGYgY29udGFpbmVkLiAgQSBsb3Qgb2Yg
c3RhdGUgaXMgc3Vic3lzdGVtLQ0KPiB3aWRlLCB3aGVyZSB0aGUgc3Vic3lzdGVtIGlzLCByb3Vn
aGx5IHNwZWFraW5nLCB0aGUgY29udGFpbmVyIGZvciBhbGwNCj4gY29udHJvbGxlcnMgdGhhdCBz
aGFyZWQgc3RvcmFnZS4gIFRoYXQgaXMgdGhlIHJpZ2h0IHRoaW5nIHRvIGRvIGZvciBzYXkgZHVh
bA0KPiBwb3J0ZWQgU1NEcyB0aGF0IGFyZSB1c2VkIGZvciBjbHVzdGVyaW5nIG9yIG11bHRpLXBh
dGhpbmcsIGZvciB0ZW50YW50IGlzb2xhdGlvbg0KPiBpcyBpdCBhYm91dCBhcyB3cm9uZyBhcyBp
dCBnZXRzLg0KDQoNCk5WTWUgc3BlYyBpcyBnZW5lcmFsLCBidXQgdGhlIGltcGxlbWVudGF0aW9u
IGRldGFpbHMgKHN1Y2ggYXMgaW50ZXJuYWwgc3RhdGUpIG1heSANCmJlIHZlbmRvciBzcGVjaWZp
Yy4gSWYgdGhlIG1pZ3JhdGlvbiBoYXBwZW5zIGJldHdlZW4gMiBpZGVudGljYWwgTlZNZSBkZXZp
Y2VzIA0KKGZyb20gc2FtZSB2ZW5kb3IvZGV2aWNlIHcvIHNhbWUgZmlybXdhcmUgdmVyc2lvbiks
IG1pZ3JhdGlvbiBvZiANCnN1YnN5c3RlbS13aWRlIHN0YXRlIGNhbiBiZSBuYXR1cmFsbHkgY292
ZXJlZCwgcmlnaHQ/DQoNCj4gDQo+IFRoZXJlIGlzIG5vdGhpbmcgaW4gdGhlIE5WTWUgc3BlYyB0
aGF0IHByb2hpYml0cyB5b3VyIGZyb20gaW1wbGVtZW50aW5nDQo+IG11bHRpcGxlIHN1YnN5c3Rl
bXMgZm9yIG11bHRpcGxlIGZ1bmN0aW9ucyBvZiBhIFBDSWUgZGV2aWNlLCBidXQgaWYgeW91IGRv
IHRoYXQNCj4gdGhlcmUgaXMgYWJzb2x1dGVseSBubyBzdXBwb3J0IGluIHRoZSBzcGVjIHRvIG1h
bmFnZSBzaGFyZWQgcmVzb3VyY2VzIG9yIGFueQ0KPiBvdGhlciBpbnRlcmFjdGlvbiBiZXR3ZWVu
IHRoZW0uDQoNCkluIElQVS9EUFUgYXJlYSwgaXQgc2VlbXMgbXVsdGlwbGUgVkZzIHdpdGggU1It
SU9WIGlzIHdpZGVseSBhZG9wdGVkLg0KDQpJbiBWRnMsIHRoZSB1c2FnZSBvZiBzaGFyZWQgcmVz
b3VyY2UgY2FuIGJlIHZpZXdlZCBhcyBpbXBsZW1lbnRhdGlvbiBzcGVjaWZpYywgDQphbmQgbG9h
ZC9zYXZlIHN0YXRlIG9mIGEgVkYgY2FuIHJlbHkgb24gdGhlIGhhcmR3YXJlL2Zpcm13YXJlIGl0
c2VsZi4NCk1pZ3JhdGlvbiBvZiBOVk1lIGRldmljZXMgY3Jvc3NpbmcgdmVuZG9yL2RldmljZSBp
cyBhbm90aGVyIHN0b3J5OiBpdCBtYXkNCmJlIHVzZWZ1bCwgYnV0IGJyaW5ncyBhZGRpdGlvbmFs
IGNoYWxsZW5nZXMuIA0K
