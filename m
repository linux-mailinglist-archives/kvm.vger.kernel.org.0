Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB0C50CFF0
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 08:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238308AbiDXFyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 01:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiDXFyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 01:54:16 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C28D17068
        for <kvm@vger.kernel.org>; Sat, 23 Apr 2022 22:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650779476; x=1682315476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FIm7CinVOm+oCgRucIMdUf9degCIWzog4tLC4EwdrE4=;
  b=dHDw+P1nouFt1Ce3jTTZAlYUZyrV2Eqi13G04eZQlK2eABJ2Lj47zk9h
   smfNuDSvjJHLo6Fx/3df6NqPFpY1Hrxe+YyLBzWBzNEMN9uI8EjSOTJo2
   H/08uyA5QyqsKATjFttpgmouIT6FDHUAoohV0a/yxS5jGMasCEsXiJkYm
   a/cbdrke9mOrh4M4m1vnDzlS5hFuO083jcly2BnyrImq4+742Dg2KmEIW
   fOlaUV5Xm87Kr9LM9UUb8DyOgslFzHfh5R2IE3fWJL5r3bPsnXaMed6Li
   tgGgBAnfcGFR8gFG4eG7+RXwwvXyApRPPkSLS2o3J3jOfHfF4yPQlgc2v
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="351449386"
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="351449386"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 22:51:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="531551818"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 23 Apr 2022 22:51:15 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sat, 23 Apr 2022 22:51:15 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sat, 23 Apr 2022 22:51:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sat, 23 Apr 2022 22:51:14 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sat, 23 Apr 2022 22:51:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiLgYusrMIhNHw4SbwAk3i6EDDcw2edMM73MedUWJsWHv0QZanwgAeQYVubdPSCJ7MLOjj27lHog885/3SEbNKLdkpBw1DNF/RMdXehP9yA+VsWPGs29aNkqTEAfoMb6XEhEBAPvfVEYVPqJWFvmvpgDCwPlvDyA09SrkaS0r1Ghp+v0smMiW6p3Kq48ovRk8qRhCW8GZP5oVuOYzdo+bPtlgsXyPKka2HUxvCIxnKa60aBi5nH3DhyTKOQwT/fc2CrREmxkA1PTEEDE4NXpVBXXKMTXj4OgSu4QVvi+2smnLHOwxF5QqW67lO6oiQfzF2I1HTq7gbbcbHG/Qhggww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIm7CinVOm+oCgRucIMdUf9degCIWzog4tLC4EwdrE4=;
 b=iw4wv8vjTS6XpzJB7EEtVY3R3Rk2r+UOym5B+qbqt7Zu3RfKqB02iSh8+F3Xgb7fXnJyrfS9APv2f3KaXnE7rhZVEV93cfamx86hIOkUEjvuxpBpydBGOGLb39GVIEA4Eo5mIcyIDo9wdNAhapHDt1zR2Nbr3sAtQFlKjKbJggsVNi2x1KoIBDCOAHsX7QT5UHCL1RmRj7QfBl8IlK5nc+iihRh+rqvFJC9UwSPAQtFVNKuIa9AnFMYhZk3UbgWaPFj4ou4FnTKGcaUQeNe8c8fb8kmsU35kaYFWODPdYq8f28kIihgAolBZgpHy3Jknt9OwnWWwGwI8PEd35ixgTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM8PR11MB5637.namprd11.prod.outlook.com (2603:10b6:8:33::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Sun, 24 Apr 2022 05:51:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5186.020; Sun, 24 Apr 2022
 05:51:07 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 5/8] vfio: Change vfio_external_check_extension() to
 vfio_file_enforced_coherent()
Thread-Topic: [PATCH v2 5/8] vfio: Change vfio_external_check_extension() to
 vfio_file_enforced_coherent()
Thread-Index: AQHYVOwc8QHMMV75gUKPqgPshj3xIaz52v0AgAEzw8CAAAguEIABE54AgAJNcEA=
Date:   Sun, 24 Apr 2022 05:51:07 +0000
Message-ID: <BN9PR11MB527672EDE6097DFDBA2C4AF38CF99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <5-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <20220421054116.GC20660@lst.de>
 <BN9PR11MB5276CFD31471D4EE85DD705A8CF79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <BN9PR11MB527616A86D88299C7E5F4B598CF79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220422165832.GA1951132@nvidia.com>
In-Reply-To: <20220422165832.GA1951132@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7171c968-b50f-45bd-a804-08da25b66d58
x-ms-traffictypediagnostic: DM8PR11MB5637:EE_
x-microsoft-antispam-prvs: <DM8PR11MB5637B8BB5D41E500C6DDE9158CF99@DM8PR11MB5637.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o1RTaHbQ8Oqlc3Fn3NEwoD0KnSvN1vMbiKTOiaD5kVJ9jgqomv3yJQZP6KbY1kDPwZd2t3ndf4jc5dhg3IAh8UfCDNnMYM7qUdYx08Q6XWRJ8QBEzFwSfTO2LarljTTVDEKrOjFE6A8x7y7qAsVKfpdsfYe1FkLofx0JOK10dXkc4Peqj+wjXG7b+mBQtPRcRzmgadErQL68JDMV3o1Jh3Ytk7wIyE6vgUNgCguvi4PCQphFjdvwakLo1+LbtTOyx6AixRauayWv/FIqKlSsfchjWT1pmGafuHVHg9CHSO4vCSCuXNdbEWNhUPzUtu11pDk6ELH4WK/31QNTK8Eed/clsvPRD39HzB9D6delWgQLMJHwYF97vonOGjJu1AWslN0IViiNOpd/HuNm3qSROBlLI6pRvphrqTRnrtkioy76nUW5b2W8A5yu8CiN9NvL1gLOMFt0Dov7pHEw7zXNGJm1BwbEHxnCNFjseq1rrVbvFKivz0ZIV0/9ZxYpfIuK9SkhW+uiYSEL0Zb76lw84uL8XqAGtLvk1jTJ7zZKMpBhrT2UTlYS5uM72gae/8W1pNDnewpvTGen2Ptsh1IGwu42g/txRPUvIMWfgyj4OoFfJmW1plWeD4UvoO53mu/JZ5FL3GRn/AvNgx033cWimKMIb/ukWVcCxC82BORBFbEOgC+dEw0iDIX/doAHYXwWWI0Z8TkhzuMdsNT9nlKMLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66446008)(82960400001)(122000001)(64756008)(8676002)(316002)(76116006)(66476007)(66946007)(4326008)(26005)(9686003)(186003)(107886003)(6506007)(33656002)(55016003)(2906002)(38100700002)(38070700005)(5660300002)(7696005)(83380400001)(6916009)(54906003)(508600001)(71200400001)(8936002)(86362001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzNSa1Mwb1pDYTdXYnFuS256TmtzdlFaRmJPeGgvS0hMZzBSOGloYjhqa0F0?=
 =?utf-8?B?OG5PVVBJWnh3K3lVRlBBRGR4SURGZC85VWRSOFZPY1pEQUVramE1Qit0L1FY?=
 =?utf-8?B?dFJIa2RLUGF2U3hGZ0FCU1NaOGdTS0liWVhQa0JnYzhudHdyQlYrL1NxNkh5?=
 =?utf-8?B?UFlmVnA2VU9pZFFuVk1HeU5vK09vdVE5T3BVaERFcFhQSXhPclRvNE53Umsz?=
 =?utf-8?B?WHY1Mi9IdTc2QWR0T3hSK2tvSml5VXNZVUJ6WGQ1Y2l4UEVZOGJEMVNMNzBn?=
 =?utf-8?B?aGZvdVQ1VFNZYW9ncEt5ZEwwT05PN1JjVk1nTERjNzBseE1KTFVCRU1mcXZZ?=
 =?utf-8?B?NlhPMy9XSFE4UTZqVUJtWGg1Yi9Nb01SRmxUNFJzL21tMGErcHIwNmd6T3Jz?=
 =?utf-8?B?MUhDRTJ5SmZmWFV2Y3VHR09KRTRGS1loKzN4cE1EMnhJYmVjZUdzL09zOVFD?=
 =?utf-8?B?VVFQRmFaL0JKbldWK0FrdnJ1Y1JrbGVRSEJpRkpuWDk1bkpGVFhpRzZJTERO?=
 =?utf-8?B?SjVrQ0NJVzAzRjZ6RE5uQ2lOZXhkRnpwcUZmb1VrQXJFYUtWUWtjeTRoRVI1?=
 =?utf-8?B?UE93TFZuSkVqaEFsVitsVmJob1d3TDQwY1VLT2poTUdVc2M1QkR2clhqL25W?=
 =?utf-8?B?RHpuenJSNGY5aU1UV3YzRWhlMkpSbVdaamZiWWRwQUpsVWhQZSt6c214K2t6?=
 =?utf-8?B?aTdkd3RYbEhzMGU5bnhhZ1phcVlEVjNReDlUOExZYTVLd2E3UzJqSXNxK0xp?=
 =?utf-8?B?a1ZxL3JCcStLajFNTGk0VXBYSjZqWlFCSWJzbkV5bHNZTGgycEpTeVRDUlZ5?=
 =?utf-8?B?bUMzRVo3OE9OazVKMlVkcm9SZDR3aW9Hc1ZDUVRyWkNSTzZLckVOZlJFbk1C?=
 =?utf-8?B?N0Z0L0hwR3RpUjYxNzlDZFVaeEcvb0x6cjZuZTlQQ0ZXTEVjK2Vwc01KL0FW?=
 =?utf-8?B?UGpGRTFDUUlVelFPMnRxdmh4UFhpNmtzQWZQVGxqVkhoVko2MEYva2ZSbHdQ?=
 =?utf-8?B?bm9VYWlJOXdKa3N2emhHNU9acVNQdnBKR0xWV3lsZURqb0IvY3FpblB2akJo?=
 =?utf-8?B?bFhJR0I3bVUySWdhcUg1NHFFNmpEbEFEa0crTDdoUVEyZjlTdGJSTWZIYStt?=
 =?utf-8?B?T1Fac2RkeklGS1BMd2ppc244R1dpNnhPTzVtdXVjcFR5Z0MyRE81RUdtYUk5?=
 =?utf-8?B?dnNZY0NOSmZIOXIvazFkdE5rUEg2Y042L2xGMnBmWjFkSWkxQWN5SGIzc1Q1?=
 =?utf-8?B?L3ZIbnVyY0RSWERTaDU1ZFdPbnVJRVRJTkVtTUZtaTUrbDQ1QUlLQzluN3NX?=
 =?utf-8?B?S3hibGdSZEM2S05nZ2todlJ1Z2dFU082RldxVXVjMC9NU0kxbm9jcFVoQXhC?=
 =?utf-8?B?UTFSTkw1cU93MlNJMlU1TUZBT2ZWWDgyRWV6aUJmTzg1SmN5bUtKcUdtelRJ?=
 =?utf-8?B?NlRBSEJyd2Z2OUkxKzhkZEtEK0JDRzIzVUxDUU5UbnhMN3ZnblBvVG5QaUFJ?=
 =?utf-8?B?ZEdtczFBSmZHQ2xyTktFYmxBeWp6cmpGSzBOamZ6MXptTitIU2VxV05RUmJo?=
 =?utf-8?B?a3A3aWJqUGJUUXdsd3AxakVwbnBlKzBQcllZQ21RRUNhUFlYUkQ4c3ZCUWVV?=
 =?utf-8?B?MDl6SnlQaDRtL0M3NTdQMzJnY1AwRnBsMjV0WUZ2aWg2NkVVcFVHL3BDM2hp?=
 =?utf-8?B?M1JYdjNKL3gvdDJVdzFpem1HZk00NlZ2YVVabG9PY0ZuY2taVDdQVnJ4NU5q?=
 =?utf-8?B?dXk0RzZsY3M2K2lSQUloUzNwWGFuQzVDZlQvZUl1NnFQbkdhZ0tmc2RYc0dn?=
 =?utf-8?B?cVlTRHoxcjQ4RU5JeFhESFNtVVJoWXdWQzkrKzYwdUdRd2JqN2o1SnUwQWF0?=
 =?utf-8?B?VlEyMW1DeTRmQ1hHYlJVQis3L1JQRTEvZnE0L3Z4ZUF0cGNNdHVuLzJnY3Fk?=
 =?utf-8?B?NDFDWFg3bG8rdThPQ1hEeTh1OG10RjNpamNMQkk5OUtDRUR0OEx2emk4R1VH?=
 =?utf-8?B?SVJqUHhINnVOQWlvMkxSWkJXdTF1QVZEWEFveGgvNGg2VmR0T2VRS2FhNHdI?=
 =?utf-8?B?SGtLd3ZNYzN4SmRjZ3NFWUJHSFduRHc2NjBsc1RrTTlmcHRGUFpyM25OZVBZ?=
 =?utf-8?B?Qys0N1JsQnRxV1hMYUl1Lzd3KzJET0pzZWdBOEQ2akRxQURlQkw1VmRDTkZZ?=
 =?utf-8?B?Ymw0MjU1SXNORWV1N0JqRHNKRXBqcWJLYmc2ajNSODZFRHl2NlMxa0czcnQw?=
 =?utf-8?B?czhBQ2lTWkJPZytNWmNCMmdhdVJIbjlPMGJIMEQrN1l5ellwR041NjQzZy9q?=
 =?utf-8?B?MmVnYktuMlJjN0dzY29rc3pXZFF5bEtuM3hFck13ek8rc0o2ZGQ5dz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7171c968-b50f-45bd-a804-08da25b66d58
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2022 05:51:07.4680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x/17uZ3sfzMQsKhSTd6jgQ3HRpxMAkgdeZd2uTPtvcWEbrU7Rt6AXXO3/a7MM6LTaOp9nPHkVEcp4/RFkDcCCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5637
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBTYXR1cmRh
eSwgQXByaWwgMjMsIDIwMjIgMTI6NTkgQU0NCj4gDQo+IE9uIEZyaSwgQXByIDIyLCAyMDIyIGF0
IDEyOjMyOjU4QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gRnJvbTogVGlhbiwg
S2V2aW4NCj4gPiA+IFNlbnQ6IEZyaWRheSwgQXByaWwgMjIsIDIwMjIgODoxMyBBTQ0KPiA+ID4N
Cj4gPiA+ID4gRnJvbTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+ID4gPiA+IFNl
bnQ6IFRodXJzZGF5LCBBcHJpbCAyMSwgMjAyMiAxOjQxIFBNDQo+ID4gPiA+DQo+ID4gPiA+IEkg
Y2FuIHNlZSB3aHkgYSBzcGVjaWZpYyBlcnJvciBtaWdodCBiZSBuaWNlIGZvciBzb21lIGNhc2Vz
IGFuZCBhbQ0KPiA+ID4gPiBvcGVuIHRvIHRoYXQsIGJ1dCBhcyBhIHNpbXBsZSB0cmFuc2Zvcm1h
dGlvbiB0aGlzIGFscmVhZHkgbG9va3MgZ29vZDoNCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBUaGVy
ZSBpcyBhIHNsaWdodCBzZW1hbnRpY3MgY2hhbmdlIHRvZ2V0aGVyIHdpdGggcGF0Y2g3Lg0KPiA+
ID4NCj4gPiA+IEJlZm9yZSBwYXRjaDcgdGhlIGNvbnRhaW5lciBtdXN0IGJlIGF0dGFjaGVkIGJl
Zm9yZSBjYWxsaW5nDQo+ID4gPiBLVk1fREVWX1ZGSU9fR1JPVVBfQURELCBvdGhlcndpc2UgdmZp
b19ncm91cF9nZXRfZXh0ZXJuYWxfdXNlcigpDQo+ID4gPiB3aWxsIGZhaWwuIEluIHRoaXMgY2Fz
ZSB0aGUgcmVzdWx0IG9mIGNhY2hlIGNvaGVyZW5jeSBmb3IgYSBncm91cCBpcw0KPiA+ID4gZGV0
ZXJtaW5pc3RpYywgZWl0aGVyIHRydWUgb3IgZmFsc2UuDQo+IA0KPiBObywgaXQgaXNuJ3QuIFRo
ZSBjb2hlcmVuY3kgaXMgYSBwcm9wZXJ5IG9mIHRoZSBpb21tdV9kb21haW4vY29udGFpbmVyDQo+
IGFuZCBpdCBjYW4gY2hhbmdlIHdoZW4gbW9yZSBncm91cHMgYXJlIGF0dGFjaGVkIHRvIHRoZSBz
YW1lDQo+IGRvbWFpbi4gVGhlIGJlc3QgS1ZNIGNhbiBzYXkgaXMgdGhhdCBpZiBpdCBpcyByZXBv
cnRpbmcgY29oZXJlbmN5DQo+IGVuZm9yY2VkIGl0IHdvbid0IHN0b3AgcmVwb3J0aW5nIHRoYXQg
LSB3aGljaCBkb2Vzbid0IGNoYW5nZSBpbiB0aGlzDQo+IHNlcmllcy4NCg0KWW91IGFyZSByaWdo
dC4gSSB0aG91Z2h0IHRoaXMgaW50ZXJmYWNlIHJldHVybnMgdGhlIGRvbWFpbiBwcm9wZXJ0eQ0K
d2hpY2ggc2hvdWxkIGJlIGxvY2tlZCBkb3duIG9uY2UgYmVpbmcgYXR0YWNoZWQgYnkgYSBncm91
cCBidXQNCml0IGFjdHVhbGx5IGNoZWNrcyB0aGUgY29udGFpbmVyIHByb3BlcnR5IHdoaWNoIGlz
IGR5bmFtaWMgYXMgeW91DQpwb2ludGVkIG91dC4NCg==
