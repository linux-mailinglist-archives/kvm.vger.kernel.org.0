Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABFB671761
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 10:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjARJVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 04:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjARJU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 04:20:29 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C7E470AF
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 00:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674031085; x=1705567085;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aCjlJ+lVidmbQiwHgtbQI3oyzxQjLrub4avcV8lq7iE=;
  b=hBXCMpbE0teaYEK4kQiRF7sMyEb04s6SiKU4tH/UAKP4HKkUpDTcBmWp
   9kQnei0c4B/j6rT5hggkLQDRcD7tPSrZJye9eQ1wisj4oj1s/ESMtV9x0
   EyInm0jrtMyDhqucmcl3+IaT8gKijKWFxTIDX/sNg040yYk01OTmVjTe8
   OIOeF09XCARzW2MExED0HKqKqNbNZWj7TL4UHZMfbK51zbhBeqqezIs/r
   PEP1rhbIVg5tUnkj7VHCJRG5s1rCH0cjgE2bp4Tiah9/wHMzUUgzpLY89
   jaQxjvgfil8RhjRdC6ivg+yefiGk8ItjrO3LIlolu+7LRdSQdvKQpswW7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="324984287"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="324984287"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 00:38:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="783589526"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="783589526"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2023 00:38:02 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 00:38:02 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 00:38:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 00:38:01 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 00:38:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMbjZio1MwTJPZzgDcuj5E61twOOCSlha7fysMmaYURG8NAOEXf9w+aO2flAy0fzNqnQhU4F86Gll8p9pmtfcQH/rUSieJmL2axmk4YvY1J7asIAU9DujgEm5L6KfYyXu1Rv2TEDtyRO7SGVcZusEQhK7uILurabzp8SiggLjIkxBjTxSh7zglJ7CP2Jp0LuuXP+8lVLNjQ5ixrTpx5BNMtb2/xBksNYkJZ5E+wNY8Y4DnhgqKo/RS0J3qoS9xJ4m6+C8eyNZZDYFPB8dFEtX93cVYsyPTT+fhuPjX4YUOm9RlxhMy9YedEZBXtMHpQfBtZi2/LssDmDV1fmVRHu+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+IDuDEO0BK1yfLKfurwsFmpR3axwPNL0pt6/aJgTFA=;
 b=c9LgMfgk8VrSZwpN6iYAcYSULsEZAUBxijc5SLXUcuHZYRDLSchFiGPB7bMhqh34P1gH1gx+BYa3mn11Bgnju6Lm3WvSKntlCD7uz5tRU3QfHtmitKB3ntvd3GSmYkK1qk29p/g8W5mbip1XWkvE8elDDZdyOPduHAKgezJn5hRMnoR8f/qbl0O7jBFCPzcJiETe2h3zFSDiZ5GPJ3od7bYK5JrdMcilBwfbP9KhLu0igilMbkz0NmsKrYmjIn8z9Z879nf8y6CHD65Q8bPUE1DhPb5Ooaz7BZHqYDCg8l/7Z1ObZu6Mk7PX4LHY5a6gkUl2BGwBF6stwvp3rbnvTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB6051.namprd11.prod.outlook.com (2603:10b6:208:393::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Wed, 18 Jan
 2023 08:37:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 08:37:59 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 01/13] vfio: Allocate per device file structure
Thread-Topic: [PATCH 01/13] vfio: Allocate per device file structure
Thread-Index: AQHZKnqUfas0a/KuZEq5mvH75NwRFq6j2xyA
Date:   Wed, 18 Jan 2023 08:37:59 +0000
Message-ID: <BN9PR11MB52769F1EBACA0FA567DF7D2A8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-2-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-2-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB6051:EE_
x-ms-office365-filtering-correlation-id: 98ea2abf-055d-4bdb-3afe-08daf92f4e47
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2ZHX+32sCJjdr878Z1CHMwzfAH/1DPlE8xaqkT47l5Jh4FR1n7afGIE/4ypFhZu/sNTi4SUd1Dcy11bLtyZl//6LlhLZZx1fZOyFTdq/8eMSd+B/P2TVeYi/O/tWf5AhhN/OYR2KYvZFOgvkOJJQ+8aOWJYFfX+mUTmbQ/Iv5jiTxt6Aps5SMHVzJF0wvr2HSmHBzrF6c22ZMIaPTSyhVBfDbaueqmYoavN6lbe7FyZq3u6vqbvDZhtJRFdqHDmcYUFkdwjzAD6pcsvCxhd9PTQfFhvhwsewXzAw6J5MfBuM2XQaOaK5nsTuiJevqbJY3Rsg/Noo76xRku4Yynu1VyXmPpv1Q6jpK9oveqbhwHwSysUcYG6rfoEelkzpUhulMub6WzK4nVwiFHjmPM8s2dl5hryr5xVDKP48DO/3K+rCWrDlpYmDfPLNOnexGSSDUGs4LAO9R2cfr98EjwAR7/pkeot0tx/EsO/8yxTU6yIYbaRMc0hkBY3N/e9DSYdYLzJq4ShgjcN05HbxCNcH5B0Rw+7mr7AdDZhBtQWyaTH7XfXCsS6/yxN7IJo+KY8D3K5R1EPbFkGUpjWJ2C9HIChO2gGThS2aXJ5AEpiue6cjeNeCvesDnWFjasCRpQgw1Rg3P+01qwXKS/OM7IOFSYdHfy9rjjZMThFTyvsrFXXgcV7NHfwVg/j0sjl3x/vOxc8dUlxC2upgoRM+aSYrBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(4326008)(64756008)(41300700001)(5660300002)(7416002)(66556008)(8936002)(4744005)(66446008)(8676002)(76116006)(54906003)(66476007)(110136005)(66946007)(478600001)(7696005)(71200400001)(186003)(26005)(9686003)(6506007)(2906002)(52536014)(55016003)(83380400001)(82960400001)(86362001)(33656002)(38070700005)(38100700002)(316002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hzdIg9xSwEcLxAiQayXaj8MdPLbqpXycXcngBac5C7Wrw51c+prnbhwZwIlo?=
 =?us-ascii?Q?4JiwPjdgR0IqK2BxRddFObGqZdecz3umIEIiu2iMpZxpx5pEZVfi5EvfaQXS?=
 =?us-ascii?Q?GoOJqiokTbKCS7W/SqVXCuFgt+VHqh53gknrweGO938ayP1OyZFEtVJQ06Go?=
 =?us-ascii?Q?/dqeP+pCT2aujQzGAZsvxIT31KsRG+R03JyJ5HJ37Ycim6IfJMecGhqOIaUp?=
 =?us-ascii?Q?j47pM2GKfJJMe9q1cm6isuTB9K+c7qnHIK3PfFwssqmJXLMcqzrm+J5mpfQe?=
 =?us-ascii?Q?rdg38x+Xwez8m4g/az0tcgk0Sznyhw+VL2f3V6HVU5msDt0zDOUxSOtohFTo?=
 =?us-ascii?Q?kjoaw7Y35ycfBJLiVyWzwXISaLUmLnUVk9B5vYzqRrQ9y/7zNnDddLTWZz3e?=
 =?us-ascii?Q?BXBwLEGoz3TSujTHQIrvrI0KHYN145Xi7kNf3JnO4Vr0sZKUWJeese+Nhzby?=
 =?us-ascii?Q?a9wDrxjSgh4TD+EuRfi1sbCeIDbMpzw5uCGGBaSxGUIJl50ubAs3hV8wffVn?=
 =?us-ascii?Q?F+ntc/dAEAusee/fGl6Rmb5UxbuDJ07xrj4AQ71Spyr6JKB/V/aTyyLMtrXu?=
 =?us-ascii?Q?ej/HvZ8fsJvx6DuzBImB/n85nbcmUuohjcu/LEsgAcURhmTPaSbVov/x3FgJ?=
 =?us-ascii?Q?TefbSg2EgBK/UpCtu6ZsGt7RyO4Ejja8Js4MxnXIjcq5Szxcndzuzf2QPJSX?=
 =?us-ascii?Q?rOnLX5PJlrdZ/M25LbfNXF+/pX3w/2LZzsHzE+22MpCaJMRTadJ95YYidHGh?=
 =?us-ascii?Q?ZenNS1gxeHMlYWBzHECeLh5XrqD1TSsjaize2lEto1Lh9FNsgT/2WpKmCg2S?=
 =?us-ascii?Q?UB/X6bo3dUkwA/2x7xdMey3YUWj+FPDVs7s18NYKRzpXk4v59ZTXB2EaIKmv?=
 =?us-ascii?Q?xmnW+Z+VUgi/go3NAYdAn1/Bhu4NBsYzhzGWtTDSwkW3b9nCMG3+79krOM9U?=
 =?us-ascii?Q?WhvrQjfIZG7dmBrHsgTs+JsVMf65YnV32TH1V5kTWcCAr9bZKke3nGvmZ+tm?=
 =?us-ascii?Q?wQpl1ENDyDT+ZoIZIy44UbXR1Jd3+3iR/0oyQZgau3sSsy9nC6ahsGJSI+YZ?=
 =?us-ascii?Q?a3uW6eB3OSEjdGhkbqhnKTWKlKqOO/JNrVG0WVN49xkNGvNnBVyGi+Lmyh7c?=
 =?us-ascii?Q?qbexkbXWl8AMmALYDKLtHrGqLaKMOLkWwERqxWshYXV2f1/sZaYHBFi/GVR1?=
 =?us-ascii?Q?gwZeuBOX3lx4IM4anFWaOxHxkiuaB+rawo1rm8nwJa35Ry97p4ES4RaKgUSZ?=
 =?us-ascii?Q?5WuEhLc65VNWWcdpmI0WodyS99lVVHNJY9k7dd9wCo2y8dRwryjN2DXoHp1g?=
 =?us-ascii?Q?cDrd9z+5LpnrqtsK6KWfRI5WHtiiH9hU0jK2RnrECVHW+cqRnwlnPhVA0lxF?=
 =?us-ascii?Q?Yym5zJtwiG8CvS6iq9aoQ335uAcVqSFrE3Fzzths1Vu5KGR8usRxVr9VeVw9?=
 =?us-ascii?Q?RViEZU1NrLtt5fOEoghyjUIA/MUBf1E/WutM0l5wk91Hink3k8fckYmiQVVB?=
 =?us-ascii?Q?O5MJ0QTyjQjg+XPYtmVpu4sb3w5l9zs5rE3Qo+gRGP+ZeGm4yZZ2kUEi3jw4?=
 =?us-ascii?Q?Y8mUY/9jHEwxAXISneZwZ2jYXTPMcZeQyjXHnYLT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ea2abf-055d-4bdb-3afe-08daf92f4e47
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 08:37:59.7947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eYpvMhXbSN6DQzM/crr34tulYbO6Knf2xuBXveOTt8XZH8aaS32tjsctJeuOZ/l/3GT4qaCW4T26NobgY4aCbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6051
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, January 17, 2023 9:50 PM
>=20
> This is preparation for adding vfio device cdev support. vfio device
> cdev requires:
> 1) a per device file memory to store the kvm pointer set by KVM. It will
>    be propagated to vfio_device:kvm after the device cdev file is bound
>    to an iommufd
> 2) a mechanism to block device access through device cdev fd before it
>    is bound to an iommufd
>=20
> To address above requirements, this adds a per device file structure
> named vfio_device_file. For now, it's only a wrapper of struct vfio_devic=
e
> pointer. Other fields will be added to this per file structure in future
> commits.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
