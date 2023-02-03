Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7322E689C46
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 15:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjBCOyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 09:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbjBCOyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 09:54:50 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370A0113D3;
        Fri,  3 Feb 2023 06:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675436089; x=1706972089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gEqBqRH4b3Ih32nTrATZxMZZmZwBwOWB+28BLiXYbRg=;
  b=F1tEp3mZmHIMOLpcAF/5f1lXiHbbN6s+VRM3u1zbSTZVwrBlUtHEvKDx
   zCf8Z/fCd5NAzpjLsyIBtJk8KFLf3HDlCsprocCbRY7lTkfccLKpK//6B
   /JeiTweD1jHI+EacSx0yfJDRliAx4foNNlMCm0QmJPh4tiJ/5HHo57CI0
   Y+UGYJf81pO7aMZdxHcXBSGzdpmzUfaO0OuE3q4a9ukQwrFWQO+x1O8P1
   R9noky5f31YkBi8X5yQHxCU3fsgwuiwidKJIkII032mSjE4eE4OU8AnLb
   1iXY92Prs73bmXiPFicn1mDql8UCyy4buIX3X4oC2h5L9KzUnnsSgNQLN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="309096710"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="309096710"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 06:54:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="615727662"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="615727662"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 03 Feb 2023 06:54:48 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 06:54:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 06:54:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 06:54:47 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 06:54:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VA7v5msHhP42j3hmoQQ1ONZjOWT2tsutE2p408hIEWucQkqCmN4IZtmxucoQI80bWxZQpvY6jR2P+sl8/KLwih0G2Dq22oVZuNHDGFVaJCJkQvhzSbP1BPlBoIeFNVKDPLfSzIdqMgAOQHbyJlNFZT0Y5AmnYaYBMpC1OdH6fctJVoSf9EhTH9lmGuwg1sEfYok8wVMO6XWytxyfAvdeyp9N5TXtUfmfgPD+QvXVd7WOQJ9igtkfgUYxYURUUtAf/KqCV+pYVmTsWPEtwJCcpDs/YW4zg/bbm464pIYDiawz0xwrwKuzU2x2ERUj5xEyGEIWD3+FIUS0nLAe3pZbxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEqBqRH4b3Ih32nTrATZxMZZmZwBwOWB+28BLiXYbRg=;
 b=cjXQLi7Pn341XOLaHP4v0zAVJ4VqQimLvq51oZYfKiv2Jc7W4/dUmZfVG5oZzvZ4Je4iIH43HaEPlOQIf/9V7LJqvAcgG+2ra7FXut1SMa45S+Uazo7Wav4LUKVhNkbXZX1aQIFhOh+g5M+BN0ajFisCDysQJYTvOdFweUD5Kes44sI9SAzAPHMGYj7tqpmgM095lKwkreF6xZTcaxmf1PnCRzjb/SNvN9ITKP+CkrpqiavtX4DbOyYYE6naefn9ocgl+q2TQ9eTTSYUlgA8gmL4bt2jc0mgRjgdHjYLyglt7q5Cpe6UBiJy7q1sheje047FQw5N/M1XwhYIN+MaNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6954.namprd11.prod.outlook.com (2603:10b6:510:205::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.31; Fri, 3 Feb
 2023 14:54:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 14:54:44 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNyMjAB7EXHsi0Ue5s99XWjtHT668DpoAgAA4cQCAAAKAgIAALrmAgAC0yrCAABFkAIAAEG1g
Date:   Fri, 3 Feb 2023 14:54:44 +0000
Message-ID: <DS0PR11MB75297154376388A3698C5CCAC3D79@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230202162442.78216-1-mjrosato@linux.ibm.com>
        <20230202124210.476adaf8.alex.williamson@redhat.com>
        <BN9PR11MB527618E281BEB8E479ABB0418CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230202161307.0c6aa23e.alex.williamson@redhat.com>
        <BN9PR11MB5276017F9CEBB4BAE58C40E88CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529050661FCE4A5AC4B17C3C3D79@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230203064940.435e4d65.alex.williamson@redhat.com>
In-Reply-To: <20230203064940.435e4d65.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB6954:EE_
x-ms-office365-filtering-correlation-id: 005bee8c-5ff3-448f-0b6f-08db05f6960d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eyMLzF3qIkkkuYM4AOXhJ5ieZe+cRqV9K+Zi8QKmluaF+ZmRCHa/iHu0gaPZvHiYwnj4B/hYipShwGhX7M/gye6JlznJVUyQ3ZoGOIhESNhCCCVmGWtfzgMPDM2tP9SyZrLa1J8T4Mwc9+VaZIRDDNOuNm6BbGEX6QLSrt97bFA9E69zFZR04WjyHzsvRSTcIhIHb+8KKm5tWDwTI7tAJW18E6nG8Jr9W+sEHb0tbO5yR6PI2olEYvy7AJKudvB1nis9zNeeIpCXTgc2XadR4MaYQj+Vqr9B8KCKm+nA7LhKCpfUmK3JmgO5WaW93qTKFA++zSsQHQmjYGDH1XTYX7g8Dt6sBWC4b2tWISTBOP2arTIlWsltFOyatSnaILe/XNa7jt6oKZQZWNK8qAOJmR+K7psx9Q0fjtqcRzGw5PJPZQ+iRYGvh+onp3afV78JSnQXiPr8JOCWaWrkFeem0vNLCFsF+TWk7FjFoBeYWkzVLgVu6WBWLji4nUdSugcaPf/4IfmRquh+AaZ8QqZPBO0fZdkkCSszGJfVExxmVkf6MetEfu2T7vG5iy/uA4Tfwxm+sGL3FCGhkHQGqCISqaNbNzAW0M4eltofD5rgdIpxvWiTPqfWGzfSzEuYWllpq+iicFDApizTIqF9+h5/Q8BU9cloDQhsmxXSLxpU1v/RF4J/q92G2gLnXg0kccMDrA3av9Q5XvR/EVH/tRHTepGF99LuEzwckr+uCg0JLtY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199018)(52536014)(82960400001)(54906003)(6506007)(33656002)(9686003)(55016003)(86362001)(38070700005)(2906002)(478600001)(71200400001)(38100700002)(7696005)(26005)(316002)(186003)(5660300002)(7416002)(122000001)(6916009)(66556008)(66946007)(66446008)(41300700001)(66476007)(64756008)(8936002)(76116006)(4326008)(83380400001)(8676002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NW5GdWpOQldVSW9QdjlPTFdDSDZTK0llRTgrWkR1azQwc2pyZ3lyd1JkaGtR?=
 =?utf-8?B?TzNPbEpwalRTcHhPTURVRnlSZDZzd2lBblY1VGZQdVNRSmt1eUk5aHJ0Mm1v?=
 =?utf-8?B?eThhSncyWnhydG9oeUFnTWhDRE1aRUJHaGdHRFhRazVvbFdLQUcrNWMraXdm?=
 =?utf-8?B?ZU5wTXNVNVNHYWh1RStVaklWWE5URC9OZGI0N1d6cmR0RGNhdnQvdGJZdlYz?=
 =?utf-8?B?Y0RwYzZCS1Q3c0l3Njl3Nm0yS2p1WVR6MUlaMlgwWGEydjQyRW5iNE53dk0r?=
 =?utf-8?B?ei93a3dvMThpVXQ5d1lTM244RlJCZldQQ1U2QU11NDBsbHVhdzZ5UmxaaDRj?=
 =?utf-8?B?OGdyYk5tRmpKanhVdzhmUzdnODJhc2luYktObWNYMGUvdERPdytrRUp2UVFF?=
 =?utf-8?B?a3RwRVVEV3NVcWNuUW9vcDhTTVhpNUQ2ZnlIckZWRERWZGNqUFQ3RDhRaXJn?=
 =?utf-8?B?ZHR3VjNMV3Vqa1dBd3VSNXJJUVhHN09vRDAzeDVnRWE4ZTUvdFNZQnZWdGo4?=
 =?utf-8?B?bWFzUUFJenRpcU9nK3F1SnplOUx3WGc2ajVhRkFhRXZ0OSt0TW12U2VjQ2po?=
 =?utf-8?B?OXNjUE13YWNFQS82TndFdnVFWmQ1aE1Nejhhb0QwcWxLRnZxM1ZYeHcwV3RG?=
 =?utf-8?B?Q0JKYzVsazdHdGlBTC9yU3Naa0FQVjY2NVJqWlh1RkQwUm9HT2JtYzNqSmIz?=
 =?utf-8?B?bCtOdkxWZzVmUWFMdHZJWlVGY051OVF3eVJzSGZnTnVFazdscWQyWC9vTkJi?=
 =?utf-8?B?L3EwT3hLZnRHclpmMXA3WDVmZmxEUXNGWDBjMzV2Nm1jNFpDUWN4eCtjN0ps?=
 =?utf-8?B?Mkh4dGlTZTF2SzhPNjk3L3BOVVBsdzRNZlFzbVlqalJINXZXSGhOWG9ONXZq?=
 =?utf-8?B?Ym40cUkvdk0wY3pYa2VuV2ZXb2d5SkRpejlBQUpJRG1BSFJkc3BDYUhycE9J?=
 =?utf-8?B?NmQ2Q3VDdlYvZFhyYXNIZ2pkZThBd2pXbC9FMURKY21NMGVyUkk1OEkwZ1My?=
 =?utf-8?B?K05OYkx2Z3VvVE5lZ0lNY3AzWDhjelBTZkJWaEZvenV6emovN2FXbEkxSW5X?=
 =?utf-8?B?aFZVU2t0WExMY2FUbGlqdEV2RU5QYlY2ekZxeGtsTE5JeFNteG9vL2p2T0U4?=
 =?utf-8?B?Nmg4VXY2QzZpRllaNlNtNXlSUXk1eVZnMGRVVDhhNXBLNE5GYUVnWGRYcDBO?=
 =?utf-8?B?c3FacTZ4N3Z2T3NEeWwxNHdnd1h3SjhSSFVMY3hJMDkyOTY2dG9uV0pJYUNp?=
 =?utf-8?B?cE9DRDFLeXRYQ3BKSy90TFNYYkNqTTE3QjZvbEl0a0pzb2U0YUliZVl4bUVl?=
 =?utf-8?B?K0xva1RUN3JGL0luM0llOFBxR1k3cXVEMUVJN0dUZFFVc1A3K1ZGYzd0WCtJ?=
 =?utf-8?B?MVVXTnVrTXNPeDJLTkM0UDBaZERsWWk1SE9zcXRldVMwSEZjNWNKYzVCNFVv?=
 =?utf-8?B?ZGtSOWRpc2s3U01ablNtVFJOVkZwaUhSaFBGTGVaNXNmOXl1VTZTd0FBMDAz?=
 =?utf-8?B?MlpXY3hPTkpBMDRhNkRUMlplajRtUVRCQ3h3VUdOdVh1Tmk4VVl5QXZvTVRn?=
 =?utf-8?B?UUZjbjhJR2l5SWUySnRwRGJ2V0MyaE5UU2dPTmUrK0ZzZUw5cm1ZWVU2Y0Ez?=
 =?utf-8?B?Y2tCdHNTQUFkM3cwZ0ROZGZOTFlWUWdLQU1EenFTSXRwMDgrZk9oWkRqb3Iz?=
 =?utf-8?B?MEg2SEQ2WDFzYmdZN0FDYWRRVlNsZ1dGc09kT00zSlExOEVYR0hoWXdmc0Uv?=
 =?utf-8?B?cWdtUTVJUnFieUh6NWJVd2VvR0RiZndPNi9zSTRiSW1sR3Q4QjQ2UjVUVDFh?=
 =?utf-8?B?UnZkRENGZ1Y4TGcyWHJCcGFVU2VESW9qUlAwVllvaUN6eWRpTk1EOERTNlNy?=
 =?utf-8?B?WXJBRjlQSDdtdHZWYlN1YjdoaW5odGtlbk1oRlV4ejZtSENSZ1N1UGw5SnQr?=
 =?utf-8?B?VDgvblFJUFNoSlNDY0g4REdhblNvTXB3WFN4d3RkMHJMbE1naXh5ZHNJdnRN?=
 =?utf-8?B?RThaRzczN3MxN3hkTTZpZUVSRWZERjVUaVY5aGxaZGRlZm93Z3FJVXZTeS9R?=
 =?utf-8?B?OERZdGJPMUVvOVlKTFYxZE9aYlVGVG1VTW1xWHFOVnhRKzlvM2hiMVR5TVM0?=
 =?utf-8?Q?L9/zEvUUyP7xFwQ/OAOswsu3a?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 005bee8c-5ff3-448f-0b6f-08db05f6960d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 14:54:44.0431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N+49lOjoGqKsplvF382RZ+6vJHkn28P8Js9s+5LKfvhjpEsJamtyPlwteLUU7XM/iYxXgAudilyZ4ndrlNRr1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6954
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBGcmlkYXksIEZlYnJ1YXJ5IDMsIDIwMjMgOTo1MCBQTQ0KPiANCj4gT24gRnJpLCAzIEZl
YiAyMDIzIDEzOjMyOjA5ICswMDAwDQo+ICJMaXUsIFlpIEwiIDx5aS5sLmxpdUBpbnRlbC5jb20+
IHdyb3RlOg0KPiANCj4gPiA+IEZyb206IFRpYW4sIEtldmluIDxrZXZpbi50aWFuQGludGVsLmNv
bT4NCj4gPiA+IFNlbnQ6IEZyaWRheSwgRmVicnVhcnkgMywgMjAyMyAxMDowMCBBTQ0KPiA+ID4N
Cj4gPiA+ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNv
bT4NCj4gPiA+ID4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAzLCAyMDIzIDc6MTMgQU0NCj4gPiA+
ID4NCj4gPiA+ID4gT24gVGh1LCAyIEZlYiAyMDIzIDIzOjA0OjEwICswMDAwDQo+ID4gPiA+ICJU
aWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+
ID4gPiA+IEZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+
DQo+ID4gPiA+ID4gPiBTZW50OiBGcmlkYXksIEZlYnJ1YXJ5IDMsIDIwMjMgMzo0MiBBTQ0KPiA+
ID4gPiA+ID4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBMR1RNLiAgSSdtIG5vdCBzdXJlIG1v
dmluZyB0aGUgZnVuY3Rpb25zIHRvIHZmaW9fbWFpbiByZWFsbHkgYnV5cw0KPiB1cw0KPiA+ID4g
PiA+ID4gYW55dGhpbmcgc2luY2Ugd2UncmUgbWFraW5nIHNvIG11Y2ggdXNlIG9mIGdyb3VwIGZp
ZWxkcy4gIFRoZSBjZGV2DQo+ID4gPiA+ID4gPiBhcHByb2FjaCB3aWxsIG5lY2Vzc2FyaWx5IGJl
IGRpZmZlcmVudCwgc28gdGhlIGJ1bGsgb2YgdGhlIGdldCBjb2RlDQo+IHdpbGwNCj4gPiA+ID4g
PiA+IGxpa2VseSBuZWVkIHRvIG1vdmUgYmFjayB0byBncm91cC5jIGFueXdheS4NCj4gPiA+ID4g
PiA+DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiB3ZWxsIG15IGxhc3QgY29tbWVudCB3YXMgYmFzZWQg
b24gTWF0dGhldydzIHYyIHdoZXJlIHRoZSBnZXQNCj4gY29kZQ0KPiA+ID4gPiA+IGdldHMgYSBr
dm0gcGFzc2VkIGluIGluc3RlYWQgb2YgaW1wbGljaXRseSByZXRyaWV2aW5nIGdyb3VwIHJlZl9s
b2NrDQo+ID4gPiA+ID4gaW50ZXJuYWxseS4gSW4gdGhhdCBjYXNlIHRoZSBnZXQvcHV0IGhlbHBl
cnMgb25seSBjb250YWluIGRldmljZSBsb2dpYw0KPiA+ID4gPiA+IHRodXMgZml0IGluIHZmaW9f
bWFpbi5jLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gd2l0aCB2MyB0aGVuIHRoZXkgaGF2ZSB0byBi
ZSBpbiBncm91cC5jIHNpbmNlIHdlIGRvbid0IHdhbnQgdG8gdXNlDQo+ID4gPiA+ID4gZ3JvdXAg
ZmllbGRzIGluIHZmaW9fbWFpbi5jLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gYnV0IEkgc3RpbGwg
dGhpbmsgdjIgb2YgdGhlIGhlbHBlcnMgaXMgc2xpZ2h0bHkgYmV0dGVyLiBUaGUgb25seSBkaWZm
ZXJlbmNlDQo+ID4gPiA+ID4gYmV0d2VlbiBjZGV2IGFuZCBncm91cCB3aGVuIGhhbmRsaW5nIHRo
aXMgcmFjZSBpcyB1c2luZyBkaWZmZXJlbnQNCj4gPiA+ID4gPiByZWZfbG9jay4gdGhlIHN5bWJv
bCBnZXQvcHV0IHBhcnQgaXMgZXhhY3RseSBzYW1lLiBTbyBldmVuIGlmIHdlDQo+ID4gPiA+ID4g
bWVyZ2UgdjMgbGlrZSB0aGlzLCB2ZXJ5IGxpa2VseSBZaSBoYXMgdG8gY2hhbmdlIGl0IGJhY2sg
dG8gdjIgc3R5bGUNCj4gPiA+ID4gPiB0byBzaGFyZSB0aGUgZ2V0L3B1dCBoZWxwZXJzIHdoaWxl
IGp1c3QgbGVhdmluZyB0aGUgcmVmX2xvY2sgcGFydA0KPiA+ID4gPiA+IGhhbmRsZWQgZGlmZmVy
ZW50bHkgYmV0d2VlbiB0aGUgdHdvIHBhdGguDQo+ID4gPiA+DQo+ID4gPiA+IEknbSBub3QgcmVh
bGx5IGEgZmFuIG9mIHRoZSBhc3ltbWV0cnkgb2YgdGhlIHYyIHZlcnNpb24gd2hlcmUgdGhlIGdl
dA0KPiA+ID4gPiBoZWxwZXIgbmVlZHMgdG8gYmUgY2FsbGVkIHVuZGVyIHRoZSBuZXcga3ZtX3Jl
Zl9sb2NrLCBidXQgdGhlIHB1dA0KPiA+ID4gPiBoZWxwZXIgZG9lcyBub3QuICBIYXZpbmcgdGhl
IGdldCBoZWxwZXIgaGFuZGxlIHRoYXQgbWFrZXMgdGhlIGNhbGxlcg0KPiA+ID4gPiBtdWNoIGNs
ZWFuZXIuICBUaGFua3MsDQo+ID4gPiA+DQo+ID4gPg0KPiA+ID4gV2hhdCBhYm91dCBwYXNzaW5n
IHRoZSBsb2NrIHBvaW50ZXIgaW50byB0aGUgaGVscGVyPyBpdCdzIHN0aWxsIHNsaWdodGx5DQo+
ID4gPiBhc3ltbWV0cnkgYXMgdGhlIHB1dCBoZWxwZXIgZG9lc24ndCBjYXJyeSB0aGUgbG9jayBw
b2ludGVyIGJ1dCBpdA0KPiA+ID4gY291bGQgYWxzbyBiZSBpbnRlcnByZXRlZCBhcyBpZiB0aGUg
cG9pbnRlciBoYXMgYmVlbiBzYXZlZCBpbiB0aGUgZ2V0DQo+ID4gPiB0aGVuIGlmIGl0IG5lZWRz
IHRvIGJlIHJlZmVyZW5jZWQgYnkgdGhlIHB1dCB0aGVyZSBpcyBubyBuZWVkIHRvIHBhc3MNCj4g
PiA+IGl0IGluIGFnYWluLg0KPiA+DQo+ID4gRm9yIGNkZXYsIEkgbWF5IG1vZGlmeSB2ZmlvX2Rl
dmljZV9nZXRfa3ZtX3NhZmUoKSB0byBhY2NlcHQNCj4gPiBzdHJ1Y3Qga3ZtIGFuZCBsZXQgaXRz
IGNhbGxlciBob2xkIGEga3ZtX3JlZl9sb2NrIChmaWVsZCB3aXRoaW4NCj4gPiBzdHJ1Y3QgdmZp
b19kZXZpY2VfZmlsZSkuIE1lYW53aGlsZSwgdGhlIGdyb3VwIHBhdGggaG9sZHMNCj4gPiB0aGUg
Z3JvdXAtPmt2bV9yZWZfbG9jayBiZWZvcmUgaW52b2tpbmcgdmZpb19kZXZpY2VfZ2V0X2t2bV9z
YWZlKCkuDQo+ID4gdmZpb19kZXZpY2VfZ2V0X2t2bV9zYWZlKCkganVzdCBpbmNsdWRlcyB0aGUg
c3ltYm9sIGdldC9wdXQgYW5kDQo+ID4gdGhlIGRldmljZS0+a3ZtIGFuZCBwdXRfa3ZtIHNldC4N
Cj4gDQo+IFNvdW5kcyBhIGxvdCBsaWtlIHYyIDotXCANCg0KWWVzLCBsaWtlIHYyLiDwn5iKDQoN
Cj4gSSdkIGxvb2sgbW9yZSB0b3dhcmRzIGdyb3VwIGFuZCBjZGV2IHNwZWNpZmljDQo+IGhlbHBl
cnMgdGhhdCBoYW5kbGUgdGhlIGxvY2tpbmcgc28gdGhhdCB0aGUgY2FsbGVycyBhcmVuJ3QgZXhw
b3NlZCB0bw0KPiB0aGUgYXN5bW1ldHJ5IG9mIGdldCB2cyBwdXQsIGFuZCByZWR1Y2UgYSBuZXcN
Cj4gX3ZmaW9fZGV2aWNlX2dldF9rdm1fc2FmZSgpIGluIGNvbW1vbiBjb2RlIHRoYXQgb25seSBk
b2VzIHRoZSBzeW1ib2wNCj4gd29yay4gIFRoYW5rcywNCg0KSWYgc28sIGxvb2tzIGxpa2UgTWF0
dGhldyBuZWVkcyBhIHY0LiBJJ20gd2FpdGluZyBmb3IgdGhlIGZpbmFsIHZlcnNpb24NCm9mIHRo
aXMgcGF0Y2ggYW5kIHNlbmRpbmcgYSBuZXcgY2RldiBzZXJpZXMgYmFzZWQgb24gaXQuIHdpc2gg
dG8gc2VlDQppdCBzb29uIF5fXi4NCg0KUmVnYXJkcywNCllpIExpdQ0K
