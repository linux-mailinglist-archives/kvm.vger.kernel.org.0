Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF645129ED
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 05:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242099AbiD1DZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 23:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiD1DZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 23:25:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29429968D
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 20:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651116113; x=1682652113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t84mGOrNC2+5DtBh4ZuZa+Zbr61ysMjNwT+qf4CEhfk=;
  b=YHgiE1+e2m+XtGPYd7LD7pRVO9jFBtv5aoLfRTKgOe3LkdA/d68i4fuA
   kjZmtpl6soOG2m+VCty5yxzWLOaKqBN/uz6Djbjp63h8PZXZpfAj/KY8W
   Xg13Jknd2gipIsMk/nfNeEqf8pns+AlnhPnCMPBtA3D3zz697kJECir+j
   PNe0tEBkO8wwE/BmH+xs1bDXS+ljtCoB/AwCuEDl8wIXP1P2jIH8/H/5i
   iUBmTsCxlUt+DYtIFXMc/SqA7svSO/3QQbToEIO/npAQ9hKpb8XEr39YI
   wsWe4U1PEKKxQZzMyLhSTDTBgI4BVtLnzZUiZQBlXGN6jZgN0+WCjBiFq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="266304616"
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="266304616"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 20:21:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="651025361"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Apr 2022 20:21:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 27 Apr 2022 20:21:47 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 27 Apr 2022 20:21:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 27 Apr 2022 20:21:47 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 27 Apr 2022 20:21:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/gvfK+ehIfmyTNvwyJKwNp84lXPwzvyzJ3H7QbLzWEMYy3+Z6W67irkavHIV1M2BMdJTFjY6PBfHcOB2FMG3U9T040XcSqTfDDvJOnhsPDvLrFLU8sFXulxh+90gwUwZAzEaAOcmcwpsaxePvf+b5TCdVkuMLWm9qvAI33CTblVcvwtGU2uN2FG2z6PeL5QIVs/+gtn1uRXWQxYxvisnFSBuiuNMGTgtjclTc8fISBETsjnOS9xTPLK9Oyk9XRAxYGuDlq1WkoYRMlcPCRCvoWuQPRebgXHPR3SA0ATRWLQv+RkpsMQLu7WdRUG3APigmHAQD/9sETMs1YspxfTzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t84mGOrNC2+5DtBh4ZuZa+Zbr61ysMjNwT+qf4CEhfk=;
 b=LD32lUDSjlEXCV+1DGMOvFXqMKMLVAWSumS43/A4/8kyT/XDtCKnYnzxaoAusthz6ZOSbWRWiZAFFO1rxEISZiGLxPQdlVaGt7pfqbxo3lN5SNv0chGs50iGFT8OYF7oipareExYRsBZwhMQLhnhquOUA0KXc64tIKaxjrEVfLPpZXnLC6awgK3mAAiYkosxdBEtsPcJoadJ4+y7Oubp+59ePtXkgaMR9cZUvzYO1Ft6H5W+4H8E5150B6+DfAUiCB4OEiUSv2ovvmhWB54UbqTC6uTfOlYSYTACyihQBiSq0JKPTbw8QZzKKY7tjXFpSM0Wxg3xnDCBYxifTsg3Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5185.namprd11.prod.outlook.com (2603:10b6:303:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 28 Apr
 2022 03:21:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 03:21:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?= <berrange@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Laine Stump" <laine@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: RE: [RFC 00/18] vfio: Adopt iommufd
Thread-Topic: [RFC 00/18] vfio: Adopt iommufd
Thread-Index: AQHYT+0D1ejJho1As0eoIzmf/Uaf8qz8i3yAgAPt+QCAAErCAIABIpyQgACM1ICAAkSwEA==
Date:   Thu, 28 Apr 2022 03:21:45 +0000
Message-ID: <BN9PR11MB5276189A2A8EACFBF75B22238CFD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <20220422160943.6ff4f330.alex.williamson@redhat.com>
        <YmZzhohO81z1PVKS@redhat.com>
        <20220425083748.3465c50f.alex.williamson@redhat.com>
        <BN9PR11MB5276F549912E03553411736D8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220426102159.5ece8c1f.alex.williamson@redhat.com>
In-Reply-To: <20220426102159.5ece8c1f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5197d08-eed2-4f5e-e91c-08da28c6391b
x-ms-traffictypediagnostic: CO1PR11MB5185:EE_
x-microsoft-antispam-prvs: <CO1PR11MB5185078D9B81512E0E0F00B58CFD9@CO1PR11MB5185.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yXvllX9bNiQc4wGavYFz48Ik0rXOnta+nZZCnKfKb5E6jvt+AhYFinFUax8U6ofvPLzcTSoZd/9Nmw+DqcKalBe8+0zWim4jIiHykczfGFA7Dr6NkLUf9diHrKlWl6FSkg9lubcepmrxqRFCnR3aWt/oIFRLNHJAjTfxmdP9g//yzkCRkFIlbEVSqoj6QVLPG9x9DGJPXZiCoVF0+sCeIE9tLT6JnvdOTmUaMsmJ/D+Da0FOF8rNvXAvjGjkZUJhi68g0W23iY06cwBGwQAxtXBFf0NK16tmAcfwghpiorLgG1widgdvfOx7f/W2KcpjLZACvKPgAQ2AWDSLNVQzYnentiJPBskDnAlWjf7dotgkWcQzCnfqxXlNqHJ7dCYcklJvGdIOLSHJaK3xaFvIm1CG5inN0qZGzjBhW+z1tVTgVfqMNlR4u3mIa5eHg6HYoFiT0ZUY5m/GHrl0sL53+A/4OmJlAqWVStbXEy1VsN2woqsecVW7iy+h9Im/INSvj16xcqeuL4PNJA/7Zt1xhgCCCAICe7tkL8i7LQxCXzkdA1a0fVyR8vUoSMtrgAqYUAN63JqBUtZUbO1UaqIvVJ0ocZ1tYpC7Rr6Wey0nRndrI7uaKCbwl0nMcw9Ryk6Btk7roRsnPg6mldjOk/5nTJKGYJ7wCIf/NmlKrXC2tHMBDS9j6HI8hy7zIgmCktz7zR/xBt1i40910Z5DfvZimA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(7696005)(26005)(76116006)(66946007)(66556008)(6506007)(71200400001)(54906003)(9686003)(316002)(6916009)(86362001)(508600001)(82960400001)(186003)(122000001)(38070700005)(38100700002)(66446008)(83380400001)(64756008)(55016003)(52536014)(7416002)(2906002)(4326008)(33656002)(8936002)(5660300002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnZLR3ZUaGxBNUZUS2o5UHNCMVVFTTN5dFZZd29UOTA0SWlnaVo2Wkg4RDZi?=
 =?utf-8?B?Uk44UlQ3L1dKNGgyR0YyZVBackRCc1BLbytIR21pZnJkUEJNQ1JZaHZPVm1M?=
 =?utf-8?B?MjNzM2o4WFJMNHViRFQrZUN4cGU1K1drZ1p1Z21RclMxOEFNVTFGQk9QaXhQ?=
 =?utf-8?B?YmdiallBSXNUR3kzR2FRR3VKNm5LR1dGOFdzYXdoK3hZc0l5Zy9rbGloTk5a?=
 =?utf-8?B?dXY1U3djZ2YrN1NuNXhtYXZRZW51c2RWem0zU2VsZGNPMzI1T2ZONklMNnkr?=
 =?utf-8?B?MHlGelQ4TitjL2xoZHNlTi8weGViemdBakFkYmNhTUtkbHFTT0w5ZnRGWURV?=
 =?utf-8?B?VmhseW5WSmhHRHpZSzFUNHdnZ1VtZmFCYVB0ZnBCMUVtcUxRT3NraVBkT0Fr?=
 =?utf-8?B?aVBENFdMYUVZTFNYWSs1NzFaMkFFVzNyVGI3dHNTbEJnbnFYbmpxMW1hWmZm?=
 =?utf-8?B?RUZEUTh2R0FrVmQxdDZMZzJQZ005T1RkTGRTK2Nybm9jd2ZoMGsvQ25LWUZr?=
 =?utf-8?B?Q2RwVG1WVkNhaVBvZENhVmFPSUcxS0ZDYUF2K3Zoa3Fqejh6WHUwMlBwdVJa?=
 =?utf-8?B?bXlFdnl3TjBBcG9MeEJaVUcwZjd1YnNaOXpjc0NtMFlKbHB4bmtLNUllZ2ZZ?=
 =?utf-8?B?U0p1RGlHYTNERVFlNFlCbVRaVTNaY25zRy9vQWVMcGJOYTBtMHIvaEdnV0sy?=
 =?utf-8?B?Y3VJcjNrbG5rTVdVRmtGTlF4RWJTTzY4Yk1FSG5wTUlCdXhKbW9lUjhQYURl?=
 =?utf-8?B?eElKQXNPUElCZ2pwekJjT1d0N2dMNmtEaEFodkFoNVJib20zemE4MWEvV1V6?=
 =?utf-8?B?cGR3dEpINWptVGE5YUwvclp4N3ZTd2lrL2ZZd3NqTk4xd2ljbW91T3lTeVlS?=
 =?utf-8?B?SHlkbkdzckFRVUN6b3BLTjd4ZW1ETWowK1FDMDRTbS9Eb1NSZEx1UG5mbTkz?=
 =?utf-8?B?NXZKd1ZuaFZrMDYxYXVvUDNYYzFtMGhYZW5EKzRhMU5KMzZ4NGhZZTBoNVpp?=
 =?utf-8?B?cHJqNDZJMndwU29sditoUGlaT0hUN2RCT3FmUFJiK0NOZ3FEZnlwVEd0Z0xS?=
 =?utf-8?B?Z1FvY3NVbWVBYWtUNy8wMzFZVDZYVDVSdkRlL1R1VWRlOHlHMVptcDFoNmY1?=
 =?utf-8?B?T3k4WkJHMXE1ajdVR2JHN2FaampZYWZucEFVbVZYbzEvNGhMZ25XOW5PZWdw?=
 =?utf-8?B?blFUR01tS04yVVJ5dWNqcUc5M3Q2ZHA5dnA0ZFpBRWt6MHlUWHpqb1oxQklX?=
 =?utf-8?B?WTVjZG9qTUhVK2EvaUN3dEdiZDJjWmcva3ZMd090eUxxcVdDQk5TaVBGSzlS?=
 =?utf-8?B?QTFQcE14dFB4d3dEbXlQczdRbEp0VVIzOHFXZDRYMmlZcU9qb0ZFU3dJeDdC?=
 =?utf-8?B?UVM5djBHaVRRWnRydHVrcHhMbjVLN0N4a1FXTHZHVnc5UloxVmFzTTdxU2VC?=
 =?utf-8?B?cVBnSmdPTStpd0l1UEs4bnpYdi9Jcy9iZC9CdnF5aUh2M1B1ZHBKY1pRVUNn?=
 =?utf-8?B?elh2TkU5Ti9jVWlyV283MWU5WWdlbHVnNDNNOFFTcDhxbjRmNXdhUU5PK1Q0?=
 =?utf-8?B?VmlTeEcxNnJ1ZEw3c2hINTQxTENDTHdERVNzYUZMU1loQm0rWEFWZzhYZ2hr?=
 =?utf-8?B?ZjFZWFNDQnFrdEZVdTlsMERSWElGcVc1b0FmVWRBYU5ZeHo5L1N1Wi9VdU1N?=
 =?utf-8?B?RG1saE5ibE5hQWluQnlsUVYvN0NBencySXFxQnRYR1JxbWd1dnRpVkdhZGI1?=
 =?utf-8?B?MnBCMWsrelU4UTNtNkVncUYzNXhaOFpZeCtKeGpTL3o5alJ3VFdPR1JMOE96?=
 =?utf-8?B?ZUJKQUM4b01PZ25uV1J2bkJYa1ZzRWpjUjNwTytha25xdEx2Slo2azU3NTFl?=
 =?utf-8?B?UGxhMzlla2dCQzlhVDVFOHlFSUFodnpaaG8xRXVzQ2czR0NLSjEvNjE1STRk?=
 =?utf-8?B?cXRtNmxFZUhwQU5OR1pPYnlGN3g3TENLYi9tVzBIQmpTVjFhOWpWYmluNzJX?=
 =?utf-8?B?TWVadFFVUGNoaXZSaXBzN3FtZnZqNmdMS3hRdmt1WkgvZnhtbUdNbkRsenMz?=
 =?utf-8?B?TkZiUDNsazNRcmF6M0pLNDZEMGk0eWVLVnNvLy9HdEljMXBsSHJiUDZTRHdp?=
 =?utf-8?B?WmphbFJYbjNZKzQ2VXNVY1B1bUJ5dy94ZWZCdEZpYUpzcThrUzFvZk0xVi85?=
 =?utf-8?B?R3pjdSsxbm1qZ2NoeHc2cCtUYkQ0bzVSYVRaWW52Ui9vUWlSUkdnakdCK2Ir?=
 =?utf-8?B?UDFCdVN3SHNOSTFlYnVpSnhvalZJdUhpeWlpVjZWcEdaUGMxWEJ3amdUdnlr?=
 =?utf-8?B?dk82LzVBeWVuRU5JdVIzYlZhUW5IMSs4V3l3NGh6blpJMVhyYXBZUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5197d08-eed2-4f5e-e91c-08da28c6391b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 03:21:45.2956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QvGcoPu8guUxppcKxCAnYsqU6fUeA4QG3JKFKOFP/xbhnSRSX3xyiqyqV9gQNCRxTGkx8NsrGP1qFxyvZ4G81g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5185
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIEFwcmlsIDI3LCAyMDIyIDEyOjIyIEFNDQo+ID4gPg0KPiA+ID4gTXkg
ZXhwZWN0YXRpb24gd291bGQgYmUgdGhhdCBsaWJ2aXJ0IHVzZXM6DQo+ID4gPg0KPiA+ID4gIC1v
YmplY3QgaW9tbXVmZCxpZD1pb21tdWZkMCxmZD1OTk4NCj4gPiA+ICAtZGV2aWNlIHZmaW8tcGNp
LGZkPU1NTSxpb21tdWZkPWlvbW11ZmQwDQo+ID4gPg0KPiA+ID4gV2hlcmVhcyBzaW1wbGUgUUVN
VSBjb21tYW5kIGxpbmUgd291bGQgYmU6DQo+ID4gPg0KPiA+ID4gIC1vYmplY3QgaW9tbXVmZCxp
ZD1pb21tdWZkMA0KPiA+ID4gIC1kZXZpY2UgdmZpby1wY2ksaW9tbXVmZD1pb21tdWZkMCxob3N0
PTAwMDA6MDI6MDAuMA0KPiA+ID4NCj4gPiA+IFRoZSBpb21tdWZkIG9iamVjdCB3b3VsZCBvcGVu
IC9kZXYvaW9tbXVmZCBpdHNlbGYuICBDcmVhdGluZyBhbg0KPiA+ID4gaW1wbGljaXQgaW9tbXVm
ZCBvYmplY3QgaXMgc29tZW9uZSBwcm9ibGVtYXRpYyBiZWNhdXNlIG9uZSBvZiB0aGUNCj4gPiA+
IHRoaW5ncyBJIGZvcmdvdCB0byBoaWdobGlnaHQgaW4gbXkgcHJldmlvdXMgZGVzY3JpcHRpb24g
aXMgdGhhdCB0aGUNCj4gPiA+IGlvbW11ZmQgb2JqZWN0IGlzIG1lYW50IHRvIGJlIHNoYXJlZCBh
Y3Jvc3Mgbm90IG9ubHkgdmFyaW91cyB2ZmlvDQo+ID4gPiBkZXZpY2VzIChwbGF0Zm9ybSwgY2N3
LCBhcCwgbnZtZSwgZXRjKSwgYnV0IGFsc28gYWNyb3NzIHN1YnN5c3RlbXMsIGV4Lg0KPiA+ID4g
dmRwYS4NCj4gPg0KPiA+IE91dCBvZiBjdXJpb3NpdHkgLSBpbiBjb25jZXB0IG9uZSBpb21tdWZk
IGlzIHN1ZmZpY2llbnQgdG8gc3VwcG9ydCBhbGwNCj4gPiBpb2FzIHJlcXVpcmVtZW50cyBhY3Jv
c3Mgc3Vic3lzdGVtcyB3aGlsZSBoYXZpbmcgbXVsdGlwbGUgaW9tbXVmZCdzDQo+ID4gaW5zdGVh
ZCBsb3NlIHRoZSBiZW5lZml0IG9mIGNlbnRyYWxpemVkIGFjY291bnRpbmcuIFRoZSBsYXR0ZXIg
d2lsbCBhbHNvDQo+ID4gY2F1c2Ugc29tZSB0cm91YmxlIHdoZW4gd2Ugc3RhcnQgdmlydHVhbGl6
aW5nIEVOUUNNRCB3aGljaCByZXF1aXJlcw0KPiA+IFZNLXdpZGUgUEFTSUQgdmlydHVhbGl6YXRp
b24gdGh1cyBmdXJ0aGVyIG5lZWRzIHRvIHNoYXJlIHRoYXQNCj4gPiBpbmZvcm1hdGlvbiBhY3Jv
c3MgaW9tbXVmZCdzLiBOb3QgdW5zb2x2YWJsZSBidXQgcmVhbGx5IG5vIGdhaW4gYnkNCj4gPiBh
ZGRpbmcgc3VjaCBjb21wbGV4aXR5LiBTbyBJJ20gY3VyaW91cyB3aGV0aGVyIFFlbXUgcHJvdmlk
ZQ0KPiA+IGEgd2F5IHRvIHJlc3RyaWN0IHRoYXQgY2VydGFpbiBvYmplY3QgdHlwZSBjYW4gb25s
eSBoYXZlIG9uZSBpbnN0YW5jZQ0KPiA+IHRvIGRpc2NvdXJhZ2Ugc3VjaCBtdWx0aS1pb21tdWZk
IGF0dGVtcHQ/DQo+IA0KPiBJIGRvbid0IHNlZSBhbnkgcmVhc29uIGZvciBRRU1VIHRvIHJlc3Ry
aWN0IGlvbW11ZmQgb2JqZWN0cy4gIFRoZSBRRU1VDQo+IHBoaWxvc29waHkgc2VlbXMgdG8gYmUg
dG8gbGV0IHVzZXJzIGNyZWF0ZSB3aGF0ZXZlciBjb25maWd1cmF0aW9uIHRoZXkNCj4gd2FudC4g
IEZvciBsaWJ2aXJ0IHRob3VnaCwgdGhlIGFzc3VtcHRpb24gd291bGQgYmUgdGhhdCBhIHNpbmds
ZQ0KPiBpb21tdWZkIG9iamVjdCBjYW4gYmUgdXNlZCBhY3Jvc3Mgc3Vic3lzdGVtcywgc28gbGli
dmlydCB3b3VsZCBuZXZlcg0KPiBhdXRvbWF0aWNhbGx5IGNyZWF0ZSBtdWx0aXBsZSBvYmplY3Rz
Lg0KDQpJIGxpa2UgdGhlIGZsZXhpYmlsaXR5IHdoYXQgdGhlIG9iamVjdGlvbiBhcHByb2FjaCBn
aXZlcyBpbiB5b3VyIHByb3Bvc2FsLg0KQnV0IHdpdGggdGhlIHNhaWQgY29tcGxleGl0eSBpbiBt
aW5kICh3aXRoIG5vIGZvcmVzZWVuIGJlbmVmaXQpLCBJIHdvbmRlcg0Kd2hldGhlciBhbiBhbHRl
cm5hdGl2ZSBhcHByb2FjaCB3aGljaCB0cmVhdHMgaW9tbXVmZCBhcyBhIGdsb2JhbA0KcHJvcGVy
dHkgaW5zdGVhZCBvZiBhbiBvYmplY3QgaXMgYWNjZXB0YWJsZSBpbiBRZW11LCBpLmUuOg0KDQot
aW9tbXVmZCBvbi9vZmYNCi1kZXZpY2UgdmZpby1wY2ksaW9tbXVmZCxbZmQ9TU1NL2hvc3Q9MDAw
MDowMjowMC4wXQ0KDQpBbGwgZGV2aWNlcyB3aXRoIGlvbW11ZmQgc3BlY2lmaWVkIHRoZW4gaW1w
bGljaXRseSBzaGFyZSBhIHNpbmdsZSBpb21tdWZkDQpvYmplY3Qgd2l0aGluIFFlbXUuDQoNClRo
aXMgc3RpbGwgYWxsb3dzIHZmaW8gZGV2aWNlcyB0byBiZSBzcGVjaWZpZWQgdmlhIGZkIGJ1dCBq
dXN0IHJlcXVpcmVzIExpYnZpcnQNCnRvIGdyYW50IGZpbGUgcGVybWlzc2lvbiBvbiAvZGV2L2lv
bW11LiBJcyBpdCBhIHdvcnRod2hpbGUgdHJhZGVvZmYgdG8gYmUNCmNvbnNpZGVyZWQgb3IganVz
dCBub3QgYSB0eXBpY2FsIHdheSBpbiBRZW11IHBoaWxvc29waHkgZS5nLiBhbnkgb2JqZWN0DQph
c3NvY2lhdGVkIHdpdGggYSBkZXZpY2UgbXVzdCBiZSBleHBsaWNpdGx5IHNwZWNpZmllZD8NCg0K
VGhhbmtzDQpLZXZpbg0K
