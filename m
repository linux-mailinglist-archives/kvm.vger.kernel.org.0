Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6470687606
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 07:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjBBGos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 01:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjBBGoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 01:44:44 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5AE81B10;
        Wed,  1 Feb 2023 22:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675320280; x=1706856280;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OHstDGFwDe+/ayhWanHdrJ5agJvf+TjXsiqBM6wvEjw=;
  b=FII9Ccn+UmyvsVLslpqWOsnxqSENE6UZlbJ0DNVKpU8FDF9tWUb6PyoI
   aN36qVQDaADvsE0ho/1FhtZJR4b/NZ3XwdFBlM9EaCBkUYQk0YhH8up8A
   fWnIsS6YUbMSbzX6NhUm6F15G6460R7MCQ5rXQtf/pbVoAX+aZ0OtFVgV
   f8JGrCi+3ewQ0IP1PqwldjXJK20JNt9Rnkg588NenXPUeZKRt2wh81BxN
   YtFiiNXAFHsceVWIx3H451Dd1U8k5tQ6yJ7sRudc5BLW/T1hAoZpEwkzF
   /uNca9zjUGkexShZLXBy/bx7ciNo09rNU00YO4hLQ5XlgkoZHE1pQY4bX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="330503950"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="330503950"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 22:44:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="993959536"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="993959536"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2023 22:44:38 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 22:44:38 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 22:44:37 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 22:44:37 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 22:44:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLOiEPLXRd23Rc+orWxQ8zD2f50jaYyW/2mrgA+Ufd/gbuNohZaeDtEFZ6zQePDmNa70bJYVJcMSXZkNJeRVX3Owa0w7Rx0b8zQLGewM7Xm/tRw2g4DKpPykTMCMcxhL/e4NWqNL5RPxMmgOv3QqQmx9CsNfZ+RJxc9N54YEuTOi/EJzg/GEw6olEmCAJXAF+U5hZa+h1s0a+h1TxkpRiIHgr2R5McDFvKt93nRXkjhYrpcXR//ZkMKzyt2WKX1T1RW1w7a/6auXFzLynCFh+5Dfh45uVV5YivzrEDsg/cd5HY5gQvKY/YHgmu2kqHEd+Yt/zabL0LW5SmnUHDUh2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHstDGFwDe+/ayhWanHdrJ5agJvf+TjXsiqBM6wvEjw=;
 b=TdDhNwnDwTKN45GOuEPeAL0nvGCRJxK8r3uvI3VVvykJi7VTBjvB//eibDSX9aXhgMx9fT5iWqGM4wtCklhQa18pBeb/kvzC9k3O8yPG0BHJvGRjfSLJQIHiO9y5E+Co6h7muMk7m/sUuF87OgcGS+HcWMdMR2jIACvnS3unDDZft9ZDdJ2HFG5wJBp0JdBAgEcZN1o8cMbniBkG6u03mpUPhqYrcbhn8sTI9qXrFXEMjTXHiQtHHsT4fmvJw5hS5y3t39Ob2Oh01nXH9YO3mBoRWBgzSCfbKWVYy/4NjHbObjcX7wMT3PkgArDihtzXdFX0NbgS7N0VK6QMlP7bvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5807.namprd11.prod.outlook.com (2603:10b6:510:140::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 06:44:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Thu, 2 Feb 2023
 06:44:29 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>,
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
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH v2] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNnJFDhMzPRK6pEGcr6itqpvSQ666vJwAgAA/7dCAABBdAIAAKCuw
Date:   Thu, 2 Feb 2023 06:44:29 +0000
Message-ID: <DS0PR11MB752928417AE053006DC5C254C3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230201192010.42748-1-mjrosato@linux.ibm.com>
        <20230201162730.685b5332.alex.williamson@redhat.com>
        <DS0PR11MB75298437F96D08758DB92368C3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230201211452.429c8e34.alex.williamson@redhat.com>
In-Reply-To: <20230201211452.429c8e34.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB5807:EE_
x-ms-office365-filtering-correlation-id: a3da16cd-c622-4584-1658-08db04e8eef7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sjhqUSLvLBhQczXREwPtH6Qn17ayM8H7bR5bD6Y+yB+rbUlXdEZix7p92Ix/Fpu9eTX4R/T9hmb9nQjqneV4zJkAr1jeRFYSIRqWOQ2b47jaxec6Zn5SKDS2nYCyhnwWcpRS4GRTDg7GpNWoVWNm12tdNZaBiSvr/TjcYayk+cMsvquvayheh2Zeeo7Y7Ji88a5EUa+P1mKDK+AKA4FeeW51il0fzLXLhNbrXONxqXLPv0B/wehNP2Edsdu5vTMCG7rsU3OSO6e4Y6JjfDqnZNlRjQBrp9k/H90VnYTAQDtkwlm7/5FMBAJ122Bg4YqLChVKSe4rgPOIByMHwMl08FQkKUkQEmAGnu2FHzbgm9qPBTj6+6rW61QP/kjX4GLSbReNW8ULYH3h6V+fqMhBJzm3sC+sMm5SHtZw3ck9pj1G48AY0DvJI/qkqeB+hw7rW84qtbAxWYX/dDfNB6BHPfEYQ8CrwRxh7Usm2QEPN98OLUrWLrH5ilf0NBq6vRB9vlUxS+VUoUobV8A1+WxTlWlKxYgy7fubP4NoyQVYSrJwpBY7NrOd5Sz8qxvwz0fB2ZwQdClvPfhsiDyJBQs2QcUUCJZgr6QkaTzV+iveNsRyT/K8y04dNF/YCyN1X+2CfY9kbVqnPl/6W1NZMZuLC7BaWUxO0rbvtqjG7exFms2WIfR8H70Uz/V2DchUeF6bsnIu6Npl0uKBXs50wmgZk3Ij5hP0cGZE+bHkSZT5i/Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199018)(33656002)(2906002)(7696005)(54906003)(478600001)(316002)(71200400001)(83380400001)(66446008)(26005)(38070700005)(66476007)(186003)(9686003)(6916009)(76116006)(4326008)(6506007)(66556008)(53546011)(7416002)(8936002)(5660300002)(52536014)(55016003)(64756008)(86362001)(8676002)(41300700001)(66946007)(82960400001)(38100700002)(122000001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUtHQkljRGUzQWU4a3VzMGhLeVIxZ095RWVTQUxRVXBNKzZDbW1uanhZdmQ2?=
 =?utf-8?B?dGsxS3dpN2swczlRcmlVYWZzaHJQYzZuVkZwTkNYWGlNWnBCK0pqeHNTY2M1?=
 =?utf-8?B?aFllc09sd3k0OCswU3VaTXR2VFhzVXM5UzUrVTNPRFdhRmZXR3dsczVUK0NK?=
 =?utf-8?B?akNSM3huaDhCS0xnRTRDM3c4R0JYZnVibVpFRDNWSXRrMEVPcUdnZmJLOFBk?=
 =?utf-8?B?Z2dNMUdSZ29SRXdOWkNDVmhLcmVSd0x2R1R1QzVoQTFPRHFPVzhyajJ5dGxG?=
 =?utf-8?B?TjdRN0lEbGpiMm94TWhBOWlJZnNpWGFKQytWK0g1MVRNbjhGV0IxdHJRL3V5?=
 =?utf-8?B?dDNUSGc3ajFsZC90dUVhTGFaWURiTlI5cEEyZ3hkQUlWbGQvVldGUUJGcmN3?=
 =?utf-8?B?YWY3M3FlSGtTaWQ3eXV6Y1hSZlhSNGVmWmhWeVZxaXpNUlN3a25wWXlNNGFl?=
 =?utf-8?B?ZkJhcVJpK1pJWnRpUER4Z2NFUzNDSXZPT2JUeHRIdnF3L2ZEVVNtd0U1Yjdp?=
 =?utf-8?B?anpSVHhlZ3UxaHJTNmJ3M0p5SnNVOEZMMW5RRUpQbDZYc09xaEVyWkVwV1hR?=
 =?utf-8?B?Z0hxVDVWSXE3VGJGMFR0SXluWlQ0QjE4dDh3WFd1eGYxS1dZMFM0SEMxMEps?=
 =?utf-8?B?eXpJNmIyOW1qN0crVHpNSUNHMDUwT2pSeFAvd2FSVWNobXdRcVNGcXA3cEtl?=
 =?utf-8?B?eEdmczFIenpuZGkyclNKS1JDemhYa2pzWFlTR2dMUWVhYU5nMmJXS2ptUFJz?=
 =?utf-8?B?VzMzRHdRVUJaeTNKeHRhL3NCeHhwYjZvZzRycWFSY2FucklLekh6UTFDZ0Zs?=
 =?utf-8?B?TWJDZm5QSXoxZWlTL0dJK3cxSVowZ2U3Nk9GUzZOa1JRS2VVODZYQnVIZzlZ?=
 =?utf-8?B?Vlc5TjR5RWc3ME5WM2RpZlF0WThNeldyZTNtcHQrazZmekhONWp3STdIQmk1?=
 =?utf-8?B?UmlDclRReEM0TnNySXNHendjNWhSdzFTdFl6Mmw2WEpDVCtnUHZYcXd3V3hM?=
 =?utf-8?B?TjFSSWZ1NHBZcC9jZEt5YkVQcy9RUjhBWFh2d01MU3E0ZzF1WGdiZmpNSmJO?=
 =?utf-8?B?UytwQ1B4NExnRjF0MmhLTVU4QnY0UXpFbExmS1IzeXVqT3JJcllCeWdMRGsv?=
 =?utf-8?B?YVRFV0pFZjhtWEJueHkrZE5PZy9yTFIvQkhmTERocm4zTTQ3S0szcE1kTGZk?=
 =?utf-8?B?SnEzVDY1dXljeXlhQnI3SlUvNUpFT0VxckRiaVpJeENtUDh2UThGZW9ISmY3?=
 =?utf-8?B?Q3djRFRLTVQ4WmkyWHJFR1VmUktxWlIzSWJ4Um9VU3dtSGVOQzZPd01MQlZM?=
 =?utf-8?B?MExxUmU0aU9xaVpLcjM0WGJqaGtldjhMajNnT1VGejduc1ZKN01jQnBReVZT?=
 =?utf-8?B?M1B3SzE1OEFoZ2NYZmxPUmFtellqV2dLNzl5L21NeWQwOG4zTEJhWnR5ays5?=
 =?utf-8?B?bEg0Qm93T2c0TkJMd2YxRitpWjdLNDljVXZFY0J2WWtSelJUU2VFT3Z6cHUz?=
 =?utf-8?B?WE1aeXRXUmZ4Ynk4U0pxUmFVT3JYM3U3ZWV4UkIvcHgvdnVPdjYrTVpxNDZs?=
 =?utf-8?B?YkdjTGRYRi9vNmdXN0dhN3JPWmlnaUJhNldLbllUMmdFVlFTRlI3QlB6WjNn?=
 =?utf-8?B?TzlxaUIrZUF2V1d3dHo3ZGxnQlFZYU0vM3dUNE5heFYvRHhsSW9obFprdlRj?=
 =?utf-8?B?WGJKSGU1UkswUG55OXBkZ0NZYkNhRnZEL2ZhVHorUVU4YXBYZkc5dWpDVG5O?=
 =?utf-8?B?SndYazB5NHVlOS9wTVFZNzFCZFY0bUsvQkRGRUNLM28yZkE0OTFkaHk3QmJV?=
 =?utf-8?B?eUlHOS9mUUFjNGdhWndqUUZvRjJiUE0xdWtpUHNPYjIrWWVaaE0xREtpT3du?=
 =?utf-8?B?dFJ5RlFTTGU1OTE3RkFXMkxnNkZpZGF5NVlnMWR6Wm9TMnFpVUNUVlZwcHpR?=
 =?utf-8?B?emo4Szc3TlNIazgzL2RLMElFZzFuenpGVVY5M0FwRGxPZ2tmdkhYU25VVFpS?=
 =?utf-8?B?WGNZWS83V2NEcHlnTFduNG9SOUlBZUU2c01vbE1JbWJBQlBKQi9GcXppNUxi?=
 =?utf-8?B?RDZwUVZDYzhtS1UxUXQxOGNrbVhjU1RyTk9ZNXJvd0lHY0pDelQ1bHlWeEZs?=
 =?utf-8?Q?0Zf3BbeM+0ytE+s4tevFKMXyo?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3da16cd-c622-4584-1658-08db04e8eef7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 06:44:29.0526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6eijlNf5EWoWg/6sEvHiUW4vOSUPdIqglcDgBT3Crz4aXBL2NXvqEJEiArMmzj+TQCehFSV+JOnZ8xJJJcHHsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5807
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleCBXaWxsaWFtc29u
IDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5
IDIsIDIwMjMgMTI6MTUgUE0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0K
PiBDYzogTWF0dGhldyBSb3NhdG8gPG1qcm9zYXRvQGxpbnV4LmlibS5jb20+OyBwYm9uemluaUBy
ZWRoYXQuY29tOw0KPiBqZ2dAbnZpZGlhLmNvbTsgY29odWNrQHJlZGhhdC5jb207IGZhcm1hbkBs
aW51eC5pYm0uY29tOw0KPiBwbW9yZWxAbGludXguaWJtLmNvbTsgYm9ybnRyYWVnZXJAbGludXgu
aWJtLmNvbTsNCj4gZnJhbmtqYUBsaW51eC5pYm0uY29tOyBpbWJyZW5kYUBsaW51eC5pYm0uY29t
OyBkYXZpZEByZWRoYXQuY29tOw0KPiBha3Jvd2lha0BsaW51eC5pYm0uY29tOyBqamhlcm5lQGxp
bnV4LmlibS5jb207IHBhc2ljQGxpbnV4LmlibS5jb207DQo+IHpoZW55dXdAbGludXguaW50ZWwu
Y29tOyBXYW5nLCBaaGkgQSA8emhpLmEud2FuZ0BpbnRlbC5jb20+Ow0KPiBDaHJpc3RvcGhlcnNv
biwsIFNlYW4gPHNlYW5qY0Bnb29nbGUuY29tPjsgVGlhbiwgS2V2aW4NCj4gPGtldmluLnRpYW5A
aW50ZWwuY29tPjsgbGludXgtczM5MEB2Z2VyLmtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5v
cmc7DQo+IGludGVsLWd2dC1kZXZAbGlzdHMuZnJlZWRlc2t0b3Aub3JnOyBpbnRlbC1nZnhAbGlz
dHMuZnJlZWRlc2t0b3Aub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBT
dWJqZWN0OiBSZTogW1BBVENIIHYyXSB2ZmlvOiBmaXggZGVhZGxvY2sgYmV0d2VlbiBncm91cCBs
b2NrIGFuZCBrdm0gbG9jaw0KPiANCj4gT24gVGh1LCAyIEZlYiAyMDIzIDAzOjQ2OjU5ICswMDAw
DQo+ICJMaXUsIFlpIEwiIDx5aS5sLmxpdUBpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiA+IEZy
b206IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gPiBT
ZW50OiBUaHVyc2RheSwgRmVicnVhcnkgMiwgMjAyMyA3OjI4IEFNDQo+ID4gPg0KPiA+ID4gT24g
V2VkLCAgMSBGZWIgMjAyMyAxNDoyMDoxMCAtMDUwMA0KPiA+ID4gTWF0dGhldyBSb3NhdG8gPG1q
cm9zYXRvQGxpbnV4LmlibS5jb20+IHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4gQWZ0ZXIgNTFjZGM4
YmMxMjBlLCB3ZSBoYXZlIGFub3RoZXIgZGVhZGxvY2sgc2NlbmFyaW8gYmV0d2VlbiB0aGUNCj4g
PiA+ID4ga3ZtLT5sb2NrIGFuZCB0aGUgdmZpbyBncm91cF9sb2NrIHdpdGggdHdvIGRpZmZlcmVu
dCBjb2RlcGF0aHMNCj4gYWNxdWlyaW5nDQo+ID4gPiA+IHRoZSBsb2NrcyBpbiBkaWZmZXJlbnQg
b3JkZXIuICBTcGVjaWZpY2FsbHkgaW4gdmZpb19vcGVuX2RldmljZSwgdmZpbw0KPiA+ID4gPiBo
b2xkcyB0aGUgdmZpbyBncm91cF9sb2NrIHdoZW4gaXNzdWluZyBkZXZpY2UtPm9wcy0+b3Blbl9k
ZXZpY2UgYnV0DQo+ID4gPiBzb21lDQo+ID4gPiA+IGRyaXZlcnMgKGxpa2UgdmZpby1hcCkgbmVl
ZCB0byBhY3F1aXJlIGt2bS0+bG9jayBkdXJpbmcgdGhlaXINCj4gb3Blbl9kZXZpY2UNCj4gPiA+
ID4gcm91dGluZTsgIE1lYW53aGlsZSwga3ZtX3ZmaW9fcmVsZWFzZSB3aWxsIGFjcXVpcmUgdGhl
IGt2bS0+bG9jayBmaXJzdA0KPiA+ID4gPiBiZWZvcmUgY2FsbGluZyB2ZmlvX2ZpbGVfc2V0X2t2
bSB3aGljaCB3aWxsIGFjcXVpcmUgdGhlIHZmaW8gZ3JvdXBfbG9jay4NCj4gPiA+ID4NCj4gPiA+
ID4gVG8gcmVzb2x2ZSB0aGlzLCBsZXQncyByZW1vdmUgdGhlIG5lZWQgZm9yIHRoZSB2ZmlvIGdy
b3VwX2xvY2sgZnJvbSB0aGUNCj4gPiA+ID4ga3ZtX3ZmaW9fcmVsZWFzZSBjb2RlcGF0aC4gIFRo
aXMgaXMgZG9uZSBieSBpbnRyb2R1Y2luZyBhIG5ldw0KPiBzcGlubG9jayB0bw0KPiA+ID4gPiBw
cm90ZWN0IG1vZGlmaWNhdGlvbnMgdG8gdGhlIHZmaW8gZ3JvdXAga3ZtIHBvaW50ZXIsIGFuZCBh
Y3F1aXJpbmcgYQ0KPiBrdm0NCj4gPiA+ID4gcmVmIGZyb20gd2l0aGluIHZmaW8gd2hpbGUgaG9s
ZGluZyB0aGlzIHNwaW5sb2NrLCB3aXRoIHRoZSByZWZlcmVuY2UgaGVsZA0KPiA+ID4gPiB1bnRp
bCB0aGUgbGFzdCBjbG9zZSBmb3IgdGhlIGRldmljZSBpbiBxdWVzdGlvbi4NCj4gPiA+ID4NCj4g
PiA+ID4gRml4ZXM6IDUxY2RjOGJjMTIwZSAoImt2bS92ZmlvOiBGaXggcG90ZW50aWFsIGRlYWRs
b2NrIG9uIHZmaW8NCj4gZ3JvdXBfbG9jayIpDQo+ID4gPiA+IFJlcG9ydGVkLWJ5OiBBbnRob255
IEtyb3dpYWsgPGFrcm93aWFrQGxpbnV4LmlibS5jb20+DQo+ID4gPiA+IFN1Z2dlc3RlZC1ieTog
SmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTog
TWF0dGhldyBSb3NhdG8gPG1qcm9zYXRvQGxpbnV4LmlibS5jb20+DQo+ID4gPiA+IC0tLQ0KPiA+
ID4gPiBDaGFuZ2VzIGZyb20gdjE6DQo+ID4gPiA+ICogdXNlIHNwaW5fbG9jayBpbnN0ZWFkIG9m
IHNwaW5fbG9ja19pcnFzYXZlIChKYXNvbikNCj4gPiA+ID4gKiBjbGVhciBkZXZpY2UtPmt2bV9w
dXQgYXMgcGFydCBvZiB2ZmlvX2t2bV9wdXRfa3ZtIChZaSkNCj4gPiA+ID4gKiBSZS1hcnJhbmdl
IGNvZGUgdG8gYXZvaWQgcmVmZXJlbmNpbmcgdGhlIGdyb3VwIGNvbnRlbnRzIGZyb20NCj4gd2l0
aGluDQo+ID4gPiA+ICAgdmZpb19tYWluIChLZXZpbikgd2hpY2ggbWVhbnQgbW92aW5nIG1vc3Qg
b2YgdGhlIGNvZGUgaW4gdGhpcyBwYXRjaA0KPiA+ID4gPiAgIHRvIGdyb3VwLmMgYWxvbmcgd2l0
aCBnZXR0aW5nL2Ryb3BwaW5nIG9mIHRoZSBkZXZfc2V0IGxvY2sNCj4gPiA+ID4gLS0tDQo+ID4g
PiA+ICBkcml2ZXJzL3ZmaW8vZ3JvdXAuYyAgICAgfCA5MA0KPiA+ID4gKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKy0tLQ0KPiA+ID4gPiAgZHJpdmVycy92ZmlvL3ZmaW8uaCAg
ICAgIHwgIDEgKw0KPiA+ID4gPiAgZHJpdmVycy92ZmlvL3ZmaW9fbWFpbi5jIHwgMTEgKystLS0N
Cj4gPiA+ID4gIGluY2x1ZGUvbGludXgvdmZpby5oICAgICB8ICAyICstDQo+ID4gPiA+ICA0IGZp
bGVzIGNoYW5nZWQsIDkxIGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQ0KPiA+ID4gPg0K
PiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL2dyb3VwLmMgYi9kcml2ZXJzL3ZmaW8v
Z3JvdXAuYw0KPiA+ID4gPiBpbmRleCBiYjI0YjJmMDI3MWUuLjUyZjQzNDg2MTI5NCAxMDA2NDQN
Cj4gPiA+ID4gLS0tIGEvZHJpdmVycy92ZmlvL2dyb3VwLmMNCj4gPiA+ID4gKysrIGIvZHJpdmVy
cy92ZmlvL2dyb3VwLmMNCj4gPiA+ID4gQEAgLTEzLDYgKzEzLDkgQEANCj4gPiA+ID4gICNpbmNs
dWRlIDxsaW51eC92ZmlvLmg+DQo+ID4gPiA+ICAjaW5jbHVkZSA8bGludXgvaW9tbXVmZC5oPg0K
PiA+ID4gPiAgI2luY2x1ZGUgPGxpbnV4L2Fub25faW5vZGVzLmg+DQo+ID4gPiA+ICsjaWZkZWYg
Q09ORklHX0hBVkVfS1ZNDQo+ID4gPiA+ICsjaW5jbHVkZSA8bGludXgva3ZtX2hvc3QuaD4NCj4g
PiA+ID4gKyNlbmRpZg0KPiA+ID4gPiAgI2luY2x1ZGUgInZmaW8uaCINCj4gPiA+ID4NCj4gPiA+
ID4gIHN0YXRpYyBzdHJ1Y3QgdmZpbyB7DQo+ID4gPiA+IEBAIC0xNTQsNiArMTU3LDU1IEBAIHN0
YXRpYyBpbnQNCj4gdmZpb19ncm91cF9pb2N0bF9zZXRfY29udGFpbmVyKHN0cnVjdA0KPiA+ID4g
dmZpb19ncm91cCAqZ3JvdXAsDQo+ID4gPiA+ICAJcmV0dXJuIHJldDsNCj4gPiA+ID4gIH0NCj4g
PiA+ID4NCj4gPiA+ID4gKyNpZmRlZiBDT05GSUdfSEFWRV9LVk0NCj4gPiA+ID4gK3N0YXRpYyBi
b29sIHZmaW9fa3ZtX2dldF9rdm1fc2FmZShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSwNCj4g
c3RydWN0DQo+ID4gPiBrdm0gKmt2bSkNCj4gPiA+DQo+ID4gPiBJJ20gdGVtcHRlZCB0byBuYW1l
IHRoZXNlIHZmaW9fZGV2aWNlX2dldF9rdm1fc2FmZSgpIGFuZCBvbmx5IHBhc3MNCj4gdGhlDQo+
ID4gPiB2ZmlvX2RldmljZSwgd2hlcmUgb2YgY291cnNlIHdlIGNhbiBnZXQgdGhlIGt2bSBwb2lu
dGVyIGZyb20gdGhlDQo+IGdyb3VwDQo+ID4gPiBpbnRlcm5hbGx5Lg0KPiA+ID4NCj4gPiA+ID4g
K3sNCj4gPiA+ID4gKwl2b2lkICgqcGZuKShzdHJ1Y3Qga3ZtICprdm0pOw0KPiA+ID4gPiArCWJv
b2wgKCpmbikoc3RydWN0IGt2bSAqa3ZtKTsNCj4gPiA+ID4gKwlib29sIHJldDsNCj4gPiA+ID4g
Kw0KPiA+ID4NCj4gPiA+IFdlIHNob3VsZCBhc3NlcnRfbG9ja2RlcF9oZWxkKCZkZXZpY2UtPmRl
dl9zZXQtPmxvY2spIGluIGJvdGggb2YNCj4gdGhlc2UNCj4gPiA+IHNpbmNlIHRoYXQgc2VlbXMg
dG8gYmUgd2hhdCdzIHByb3RlY3RpbmcgZGV2aWNlLT5rdm0gYW5kDQo+ID4gPiBkZXZpY2UtPnB1
dF9rdm0uDQo+ID4gPg0KPiA+ID4gSWYgd2UgY2hhbmdlIGFzIGFib3ZlIHRvIGdldCB0aGUga3Zt
IHBvaW50ZXIgZnJvbSB0aGUgZ3JvdXAgd2l0aGluIHRoaXMNCj4gPiA+IGZ1bmN0aW9uLCB3ZSBj
YW4gYWxzbyBtb3ZlIHRoZSBrdm1fcmVmX2xvY2sgaGVyZSwgd2hpY2ggc2VlbXMgdG8NCj4gPiA+
IHNpbXBsaWZ5IHRoZSBjYWxsZXIgcXVpdGUgYSBiaXQuDQo+ID4gPg0KPiA+ID4gPiArCXBmbiA9
IHN5bWJvbF9nZXQoa3ZtX3B1dF9rdm0pOw0KPiA+ID4gPiArCWlmIChXQVJOX09OKCFwZm4pKQ0K
PiA+ID4gPiArCQlyZXR1cm4gZmFsc2U7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlmbiA9IHN5bWJv
bF9nZXQoa3ZtX2dldF9rdm1fc2FmZSk7DQo+ID4gPiA+ICsJaWYgKFdBUk5fT04oIWZuKSkgew0K
PiA+ID4gPiArCQlzeW1ib2xfcHV0KGt2bV9wdXRfa3ZtKTsNCj4gPiA+ID4gKwkJcmV0dXJuIGZh
bHNlOw0KPiA+ID4gPiArCX0NCj4gPiA+ID4gKw0KPiA+ID4gPiArCXJldCA9IGZuKGt2bSk7DQo+
ID4gPiA+ICsJaWYgKHJldCkNCj4gPiA+ID4gKwkJZGV2aWNlLT5wdXRfa3ZtID0gcGZuOw0KPiA+
ID4gPiArCWVsc2UNCj4gPiA+ID4gKwkJc3ltYm9sX3B1dChrdm1fcHV0X2t2bSk7DQo+ID4gPiA+
ICsNCj4gPiA+ID4gKwlzeW1ib2xfcHV0KGt2bV9nZXRfa3ZtX3NhZmUpOw0KPiA+ID4gPiArDQo+
ID4gPiA+ICsJcmV0dXJuIHJldDsNCj4gPiA+ID4gK30NCj4gPiA+ID4gKw0KPiA+ID4gPiArc3Rh
dGljIHZvaWQgdmZpb19rdm1fcHV0X2t2bShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSkNCj4g
PiA+ID4gK3sNCj4gPiA+ID4gKwlpZiAoV0FSTl9PTighZGV2aWNlLT5rdm0gfHwgIWRldmljZS0+
cHV0X2t2bSkpDQo+ID4gPiA+ICsJCXJldHVybjsNCj4gPiA+DQo+ID4gPiBJdCBzaW1wbGlmaWVz
IHRoZSBjYWxsZXIgaWYgd2UgY2FuIHVzZSB0aGlzIGV2ZW4gaW4gdGhlICFkZXZpY2UtPmt2bQ0K
PiA+ID4gY2FzZS4NCj4gPiA+DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlkZXZpY2UtPnB1dF9rdm0o
ZGV2aWNlLT5rdm0pOw0KPiA+ID4gPiArCWRldmljZS0+cHV0X2t2bSA9IE5VTEw7DQo+ID4gPiA+
ICsJc3ltYm9sX3B1dChrdm1fcHV0X2t2bSk7DQo+ID4gPiA+ICt9DQo+ID4gPiA+ICsNCj4gPiA+
ID4gKyNlbHNlDQo+ID4gPiA+ICtzdGF0aWMgYm9vbCB2ZmlvX2t2bV9nZXRfa3ZtX3NhZmUoc3Ry
dWN0IHZmaW9fZGV2aWNlICpkZXZpY2UsDQo+IHN0cnVjdA0KPiA+ID4ga3ZtICprdm0pDQo+ID4g
PiA+ICt7DQo+ID4gPiA+ICsJcmV0dXJuIGZhbHNlOw0KPiA+ID4gPiArfQ0KPiA+ID4gPiArDQo+
ID4gPiA+ICtzdGF0aWMgdm9pZCB2ZmlvX2t2bV9wdXRfa3ZtKHN0cnVjdCB2ZmlvX2RldmljZSAq
ZGV2aWNlKQ0KPiA+ID4gPiArew0KPiA+ID4gPiArfQ0KPiA+ID4gPiArI2VuZGlmDQo+ID4gPiA+
ICsNCj4gPiA+ID4gIHN0YXRpYyBpbnQgdmZpb19kZXZpY2VfZ3JvdXBfb3BlbihzdHJ1Y3QgdmZp
b19kZXZpY2UgKmRldmljZSkNCj4gPiA+ID4gIHsNCj4gPiA+ID4gIAlpbnQgcmV0Ow0KPiA+ID4g
PiBAQCAtMTY0LDE0ICsyMTYsMzIgQEAgc3RhdGljIGludCB2ZmlvX2RldmljZV9ncm91cF9vcGVu
KHN0cnVjdA0KPiA+ID4gdmZpb19kZXZpY2UgKmRldmljZSkNCj4gPiA+ID4gIAkJZ290byBvdXRf
dW5sb2NrOw0KPiA+ID4gPiAgCX0NCj4gPiA+ID4NCj4gPiA+ID4gKwltdXRleF9sb2NrKCZkZXZp
Y2UtPmRldl9zZXQtPmxvY2spOw0KPiA+ID4gPiArDQo+ID4gPiA+ICAJLyoNCj4gPiA+ID4gLQkg
KiBIZXJlIHdlIHBhc3MgdGhlIEtWTSBwb2ludGVyIHdpdGggdGhlIGdyb3VwIHVuZGVyIHRoZSBs
b2NrLiAgSWYNCj4gPiA+IHRoZQ0KPiA+ID4gPiAtCSAqIGRldmljZSBkcml2ZXIgd2lsbCB1c2Ug
aXQsIGl0IG11c3Qgb2J0YWluIGEgcmVmZXJlbmNlIGFuZCByZWxlYXNlIGl0DQo+ID4gPiA+IC0J
ICogZHVyaW5nIGNsb3NlX2RldmljZS4NCj4gPiA+ID4gKwkgKiBCZWZvcmUgdGhlIGZpcnN0IGRl
dmljZSBvcGVuLCBnZXQgdGhlIEtWTSBwb2ludGVyIGN1cnJlbnRseQ0KPiA+ID4gPiArCSAqIGFz
c29jaWF0ZWQgd2l0aCB0aGUgZ3JvdXAgKGlmIHRoZXJlIGlzIG9uZSkgYW5kIG9idGFpbiBhIHJl
ZmVyZW5jZQ0KPiA+ID4gPiArCSAqIG5vdyB0aGF0IHdpbGwgYmUgaGVsZCB1bnRpbCB0aGUgb3Bl
bl9jb3VudCByZWFjaGVzIDAgYWdhaW4uICBTYXZlDQo+ID4gPiA+ICsJICogdGhlIHBvaW50ZXIg
aW4gdGhlIGRldmljZSBmb3IgdXNlIGJ5IGRyaXZlcnMuDQo+ID4gPiA+ICAJICovDQo+ID4gPiA+
ICsJaWYgKGRldmljZS0+b3Blbl9jb3VudCA9PSAwKSB7DQo+ID4gPiA+ICsJCXNwaW5fbG9jaygm
ZGV2aWNlLT5ncm91cC0+a3ZtX3JlZl9sb2NrKTsNCj4gPiA+ID4gKwkJaWYgKGRldmljZS0+Z3Jv
dXAtPmt2bSAmJg0KPiA+ID4gPiArCQkgICAgdmZpb19rdm1fZ2V0X2t2bV9zYWZlKGRldmljZSwg
ZGV2aWNlLT5ncm91cC0+a3ZtKSkNCj4gPiA+ID4gKwkJCWRldmljZS0+a3ZtID0gZGV2aWNlLT5n
cm91cC0+a3ZtOw0KPiA+ID4gPiArCQlzcGluX3VubG9jaygmZGV2aWNlLT5ncm91cC0+a3ZtX3Jl
Zl9sb2NrKTsNCj4gPiA+ID4gKwl9DQo+ID4gPiA+ICsNCj4gPiA+ID4gIAlyZXQgPSB2ZmlvX2Rl
dmljZV9vcGVuKGRldmljZSwgZGV2aWNlLT5ncm91cC0+aW9tbXVmZCwNCj4gPiA+ID4gIAkJCSAg
ICAgICBkZXZpY2UtPmdyb3VwLT5rdm0pOw0KPiA+ID4NCj4gPiA+IFdlJ3JlIHVzaW5nIGRldmlj
ZS0+Z3JvdXAtPmt2bSBvdXRzaWRlIG9mIGt2bV9yZWZfbG9jayBoZXJlLCBpdA0KPiBzaG91bGQN
Cj4gPiA+IGJlIHVzaW5nIGRldmljZS0+a3ZtLg0KPiA+DQo+ID4gRXhpc3RpbmcgY29kZSBzZXQg
ZGV2aWNlLT5rdm0gaW4gdGhlIHZmaW9fZGV2aWNlX2ZpcnN0X29wZW4oKSB3aGljaCBpcw0KPiA+
IGNhbGxlZCBieSB2ZmlvX2RldmljZV9vcGVuKCkuIEFmdGVyIGFib3ZlIGNoYW5nZSwgc2VlbXMg
bm90IG5lY2Vzc2FyeQ0KPiA+IHRvIHBhc3Mga3ZtIHBvaW50ZXIgaW50byB0aGUgY2FsbCBjaGFp
bi4gSXNuJ3QgaXQ/DQo+IA0KPiBZZXMsIHdlIGNhbiBnZXQgaXQgZnJvbSB0aGUgZGV2aWNlLiAg
SSBkaWRuJ3QgY2hlY2sgaG93IG11Y2ggdGhpcw0KPiBibG9hdHMgdGhlIHBhdGNoIHRob3VnaC4g
IEFzIGEgZml4LCBpdCBtaWdodCBtYWtlIHNlbnNlIHRvIHNhdmUgdGhhdA0KPiByZWZhY3Rvcmlu
ZyBmb3IgYSBmb2xsb3ctb24gcGF0Y2guICBUaGFua3MsDQoNCjY1IGxpbmVzIGRpZmYgZmlsZS4g
8J+YiiBmb2xsb3ctb24gcGF0aCB3b3JrcyB3ZWxsLg0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy92
ZmlvL2dyb3VwLmMgYi9kcml2ZXJzL3ZmaW8vZ3JvdXAuYw0KaW5kZXggYmIyNGIyZjAyNzFlLi45
ZTA0ZTU1YzgzOGYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3ZmaW8vZ3JvdXAuYw0KKysrIGIvZHJp
dmVycy92ZmlvL2dyb3VwLmMNCkBAIC0xNjksOCArMTY5LDcgQEAgc3RhdGljIGludCB2ZmlvX2Rl
dmljZV9ncm91cF9vcGVuKHN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNlKQ0KIAkgKiBkZXZpY2Ug
ZHJpdmVyIHdpbGwgdXNlIGl0LCBpdCBtdXN0IG9idGFpbiBhIHJlZmVyZW5jZSBhbmQgcmVsZWFz
ZSBpdA0KIAkgKiBkdXJpbmcgY2xvc2VfZGV2aWNlLg0KIAkgKi8NCi0JcmV0ID0gdmZpb19kZXZp
Y2Vfb3BlbihkZXZpY2UsIGRldmljZS0+Z3JvdXAtPmlvbW11ZmQsDQotCQkJICAgICAgIGRldmlj
ZS0+Z3JvdXAtPmt2bSk7DQorCXJldCA9IHZmaW9fZGV2aWNlX29wZW4oZGV2aWNlLCBkZXZpY2Ut
Pmdyb3VwLT5pb21tdWZkKTsNCiANCiBvdXRfdW5sb2NrOg0KIAltdXRleF91bmxvY2soJmRldmlj
ZS0+Z3JvdXAtPmdyb3VwX2xvY2spOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby92ZmlvLmgg
Yi9kcml2ZXJzL3ZmaW8vdmZpby5oDQppbmRleCBmODIxOWE0MzhiZmIuLjRlY2U2Y2I0Y2YyZSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvdmZpby92ZmlvLmgNCisrKyBiL2RyaXZlcnMvdmZpby92Zmlv
LmgNCkBAIC0xOSw3ICsxOSw3IEBAIHN0cnVjdCB2ZmlvX2NvbnRhaW5lcjsNCiB2b2lkIHZmaW9f
ZGV2aWNlX3B1dF9yZWdpc3RyYXRpb24oc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UpOw0KIGJv
b2wgdmZpb19kZXZpY2VfdHJ5X2dldF9yZWdpc3RyYXRpb24oc3RydWN0IHZmaW9fZGV2aWNlICpk
ZXZpY2UpOw0KIGludCB2ZmlvX2RldmljZV9vcGVuKHN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNl
LA0KLQkJICAgICBzdHJ1Y3QgaW9tbXVmZF9jdHggKmlvbW11ZmQsIHN0cnVjdCBrdm0gKmt2bSk7
DQorCQkgICAgIHN0cnVjdCBpb21tdWZkX2N0eCAqaW9tbXVmZCk7DQogdm9pZCB2ZmlvX2Rldmlj
ZV9jbG9zZShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSwNCiAJCSAgICAgICBzdHJ1Y3QgaW9t
bXVmZF9jdHggKmlvbW11ZmQpOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby92ZmlvX21h
aW4uYyBiL2RyaXZlcnMvdmZpby92ZmlvX21haW4uYw0KaW5kZXggNTE3N2JiMDYxYjE3Li40NWE3
ZDZkMzhlMmUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3ZmaW8vdmZpb19tYWluLmMNCisrKyBiL2Ry
aXZlcnMvdmZpby92ZmlvX21haW4uYw0KQEAgLTM0NSw3ICszNDUsNyBAQCBzdGF0aWMgYm9vbCB2
ZmlvX2Fzc2VydF9kZXZpY2Vfb3BlbihzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSkNCiB9DQog
DQogc3RhdGljIGludCB2ZmlvX2RldmljZV9maXJzdF9vcGVuKHN0cnVjdCB2ZmlvX2RldmljZSAq
ZGV2aWNlLA0KLQkJCQkgIHN0cnVjdCBpb21tdWZkX2N0eCAqaW9tbXVmZCwgc3RydWN0IGt2bSAq
a3ZtKQ0KKwkJCQkgIHN0cnVjdCBpb21tdWZkX2N0eCAqaW9tbXVmZCkNCiB7DQogCWludCByZXQ7
DQogDQpAQCAtMzYxLDcgKzM2MSw2IEBAIHN0YXRpYyBpbnQgdmZpb19kZXZpY2VfZmlyc3Rfb3Bl
bihzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSwNCiAJaWYgKHJldCkNCiAJCWdvdG8gZXJyX21v
ZHVsZV9wdXQ7DQogDQotCWRldmljZS0+a3ZtID0ga3ZtOw0KIAlpZiAoZGV2aWNlLT5vcHMtPm9w
ZW5fZGV2aWNlKSB7DQogCQlyZXQgPSBkZXZpY2UtPm9wcy0+b3Blbl9kZXZpY2UoZGV2aWNlKTsN
CiAJCWlmIChyZXQpDQpAQCAtMzk2LDE0ICszOTUsMTQgQEAgc3RhdGljIHZvaWQgdmZpb19kZXZp
Y2VfbGFzdF9jbG9zZShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSwNCiB9DQogDQogaW50IHZm
aW9fZGV2aWNlX29wZW4oc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UsDQotCQkgICAgIHN0cnVj
dCBpb21tdWZkX2N0eCAqaW9tbXVmZCwgc3RydWN0IGt2bSAqa3ZtKQ0KKwkJICAgICBzdHJ1Y3Qg
aW9tbXVmZF9jdHggKmlvbW11ZmQpDQogew0KIAlpbnQgcmV0ID0gMDsNCiANCiAJbXV0ZXhfbG9j
aygmZGV2aWNlLT5kZXZfc2V0LT5sb2NrKTsNCiAJZGV2aWNlLT5vcGVuX2NvdW50Kys7DQogCWlm
IChkZXZpY2UtPm9wZW5fY291bnQgPT0gMSkgew0KLQkJcmV0ID0gdmZpb19kZXZpY2VfZmlyc3Rf
b3BlbihkZXZpY2UsIGlvbW11ZmQsIGt2bSk7DQorCQlyZXQgPSB2ZmlvX2RldmljZV9maXJzdF9v
cGVuKGRldmljZSwgaW9tbXVmZCk7DQogCQlpZiAocmV0KQ0KIAkJCWRldmljZS0+b3Blbl9jb3Vu
dC0tOw0KIAl9DQo=
