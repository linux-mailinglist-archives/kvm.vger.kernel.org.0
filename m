Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A63867189D
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 11:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjARKMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 05:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjARKLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 05:11:24 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F789AAB0
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 01:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674033534; x=1705569534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NAhsnNmcLS5Y/ljlvXftN9Cb/MyFKLTGQcMqubHXlho=;
  b=am8QBN0456ByhZuVCiTPKJMdFnvZMBiN+QtvXDoYOCpYzLHW+Lm91gw8
   Bk3fecNkiRRwII0+1XjhfmRAf5r1/j2Ypl6hlK6xQrpweO+RFA787XLX3
   jeoq95KEA/xaOJfUrnrO0CjU0Ndo4zQmnLznAIKwKkJWwq6bWHIUz5KWY
   mWgS3J2viI0lm3ev2Lym4gKRVLtStzCW69j63zpLDPceoFpYYiuT98pc4
   VGkjJIR/lTa6r5BUTptI55xd1P/pypVKW0WBmMBOzOyRcP+aIPHh2+DKQ
   8rMiodJfVl1fnKrpjoRSC2bOz1wfjJ5l70/DCBbqIP5Iy0S8Z6VSXlSOT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="326209440"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326209440"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 01:18:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="833494776"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="833494776"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 18 Jan 2023 01:18:43 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 01:18:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 01:18:42 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 01:18:42 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 01:18:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgL7iLJs0t4+SdU3GidfWqMPU2Ni1KpYPW6YZaDtsa0KLuOKgbiIsgn1DgtdRYqSBcIHL4ivCkMLEmYjJTXCp/pw++i8BGQyTdnSL/AREmJJXXH+uZfGmNt7pq86XMpCAhoFKcWelOI+5NP6Z3oyy3iPXgv+b4cE2h2U6GR7Ts+NUFMa0paXv9qw0J2Up5HZ0GsnjCV/JARmtYsTdfSSNAlnseQ+F9YYOaGJ9BJK2VypjZcH8CJxhCfqJYTJ7n802mgfHEC+shBFAHDsOTFPtjpNAuZO7wUd1wZ91RfrFQ/sfOLYopjrmALrJcoNVyJX0VitHqFjsRqZYr0znctgvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhYKBW/LozmYnVU79it6t/g7UUmerA5NQH4MAiK8ry4=;
 b=aSh4iUXQEX5bY4dqeEJ6NoIF5191Nhp2CxF4cpx9cvViCVA+pnYdP7whIdfO4rLR1CUiBsqQZgH27Qss8IenOqROHUlki/6AIb0CzIDatgQFDUi9YlrBcqdq9a6Qh95BurKFqAEY69akb5WTrS2s2zhOdwG1JS7kDWGahZHmpI/JzgSbM1LyrdiRTWvKxxdghTCcXhNUHzQLquQTjZRNzI7eUpPrZdYoW8InLCbo/2gU783ALBfPXGjRCW2pIfxspeVtbm8zs0hRZQ3ArQy8fDeXROLpJ8RoOCarEwlsp9ISLMufnqa3Fe4mVwMUUECH0mVdbEeoAE2G1V912alQFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4614.namprd11.prod.outlook.com (2603:10b6:208:268::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 09:18:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 09:18:40 +0000
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
Subject: RE: [PATCH 06/13] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [PATCH 06/13] kvm/vfio: Accept vfio device file from userspace
Thread-Index: AQHZKnqWjkov/f1R+k+x5z2xYZF/c66j5a4w
Date:   Wed, 18 Jan 2023 09:18:40 +0000
Message-ID: <BN9PR11MB527677D162561B79BBAEE3DD8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-7-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-7-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4614:EE_
x-ms-office365-filtering-correlation-id: 9d277c1b-23dd-4d44-4f82-08daf934fcc6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f9fbLznhTSmD/5S8QQpQ0evGR0kLt66bGGXcjauIJmGtkPBJfn+JSjMaUafjB4Olvxyxn1FnkCO7Swbm9IWOva5q1mJ3LGFxYpkZRxRa2/BH+uErglKtW6GSTrS6Kgwmo0GsHF6Lt8pax9L8KGFBpf/uHtnlADGxxs+IMn/9g4BZoyt4F7F6HOUieEo7P7dgFeCEWnjPF4hOrz53di0qRt3hdDjhQ0a2kbHrKOC0QVJty/So9O3Y5ttS+vC54yz52T2PRPACgQTAauJ1Yd7lunbkJWa1bbdOvmPQVAIaBew347BVwK15TGf1XTXotxw6dlVveqxeZczGLFZeh2AVSyhykROtLvnK2pdIFgLxc5G4omO0UDkRS3Yp7w2lHiYb/BZ0P2/AZa/wUmPkHYZHr9aBKb4caec3Gwo1uBvfrxXZKXVSyiYRVA+mE3yQaE12QHj7D+GukBUZ/wKoEZydx4JSbN9WNahVWqp8XDi2JdJ7s1jMaMmfieywWwEiUs3p635AmemsBnhM4R+auc3mEwU6X2/gURgw9ybNVr3KAj61Vz5OVo0QQBdc9QXMUtP4LIgPfx9Wdj9R4BhOhHbtyzum264D/UAGrtFQ532i1wXHgE1jxvKwAyOKtRXQbYfT92l5gzQVAL7YCZduO9Us5Kg4xgb7Grbps1hEjqS2jZYEXq+Dj7ei0TdCwHxjvJoW1H+p7sLul/mex5WlooENjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199015)(26005)(4326008)(66446008)(86362001)(76116006)(55016003)(64756008)(186003)(9686003)(8676002)(66556008)(41300700001)(66476007)(66946007)(71200400001)(316002)(54906003)(478600001)(7696005)(6506007)(110136005)(122000001)(38070700005)(38100700002)(2906002)(7416002)(82960400001)(5660300002)(83380400001)(52536014)(33656002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?va/7mpEXWfr9M8hKQjLMxjkv2FDWYrDLQvw1klx5Gh/+iFcAxoD73Lou82u/?=
 =?us-ascii?Q?bMxuO7x47gLTbtK3eAsibtmFFBPIdilRcpOa6X4GenyyLSrj8P3j10QrCL28?=
 =?us-ascii?Q?HoclMgOHFAjXtOqSCbViFFB9c2BtdxAzRakuUZgGdozrajNdMbExoboE1lY5?=
 =?us-ascii?Q?ErnfzNVcESTelmYILm74WfdNUz4UcZo/OQVgvIAIg8WCYDrcOVUjOA8je4Lh?=
 =?us-ascii?Q?p6xjTiY5Oj1ZbPYR8GgQSi4z6eREuSKuXC+WBFA4nZ8fi514sz99bAIMrg7Y?=
 =?us-ascii?Q?XFLw2wiVcu2zZS+u3d+DDj1BL/SxnhOE3299WTZBAIS8ViuzkUmUNUJ5rcWL?=
 =?us-ascii?Q?8C5WuXkr3+Y6HMDF0/cj99HNvH0eFFJyOoBIk02pz7EtY0HHR0EKd3bOREU9?=
 =?us-ascii?Q?LDPcPtBvOp8s4R3dcRxpxs3UB7sg1zjhwjIIBaA3P4ad5UAiF1zyIVUcau2r?=
 =?us-ascii?Q?JzEMauXBoMEbEhpki2iGtGX+50WkrPpks3eTdOPJo5D+QZg+i2NQHYYxK0QD?=
 =?us-ascii?Q?iw/eMDA9gg40g4JKO8iAUfN4p6rZcsv32cpqDJoPOTyeYjqgeZeIRc/DtMTa?=
 =?us-ascii?Q?OvOohd43+LncJkJ5Yocb69cCve3ux9m7BoFD+EfwXYFxAPV5XHFqrD0zPnZE?=
 =?us-ascii?Q?iqGLsJ+VbZGY8Knl/ajeKos+EKjYn2YK10o6GjDsDd1yes0lmvYrcgX4eGKt?=
 =?us-ascii?Q?GV+5aqyqmsJyhGUK27fhBwq02G5eMs8zf9OX691P5tywUcSfn0b6o31iQcgU?=
 =?us-ascii?Q?yfrk7ZfzcgezDWqNfmnbVdFtRSIe3UwT6T4o1JRzCRCCqnwAIsosSulOE6qm?=
 =?us-ascii?Q?VSS3K0M43QiZ+lSygDw9bFiM8tCPQyOZigjHjHSuL7KnsMAsXO81r19fwAVk?=
 =?us-ascii?Q?Svh3k/0mNvkigkJEkoBEmTam27Hl7KEWWV9qar2PycWB2kPxIjmTvMq1Apxn?=
 =?us-ascii?Q?XKgd67cl/Kp9GP2+KQtFB+Akysbxmb9OwX9ZD0ugp3ciyp3Ij0AIfg/GmyKC?=
 =?us-ascii?Q?JpcKYJKvJQrQurvTz5XSBh7/BudBTBvu8gaplDPn2sMrfXobfHB07qcXF6j0?=
 =?us-ascii?Q?6HeqtDrpAyAAdBLL8T0P16L/JwCZDRnHb2Rb/Ew9FkdKOp2ZxHZDSImKP0re?=
 =?us-ascii?Q?7cPx35Cs8+/ZHNemwgpFKXTtYGr8Gj5NpdzpOnogFeapMkcKxo/wEGLiE68E?=
 =?us-ascii?Q?/dCRJHvWFEFFDLVeY81FoejSZeDslnGGs0iJ0wRlMVNpUcc8zBg90DD0HvNp?=
 =?us-ascii?Q?6CvfUmDz1C5izRZ3mUA1fFO0j+LJOvUjn6R00VqBSx/yKHIhpfVS7CLk3vzC?=
 =?us-ascii?Q?+fFxqnakjuz4Eu0qQpo5JXcl7uxjt9AUfxIS7DdF9c/0PvC7ek+diG0jXjgJ?=
 =?us-ascii?Q?g4fnMu3VA5JkjWcE5AZJn1gNvaL4YyczFnO/jjAQS+q0cbsrFHiOsSSt1dtB?=
 =?us-ascii?Q?F6qSmZ+W4kFimSUgx3tCZJjJefzpI6/fbwBnHOSzuVaPbyBPlwTkQVwVDBRv?=
 =?us-ascii?Q?Y0ZoL/u0veXIe49fRCSNx7fzj/emHWwZHZmxQPwMoakPLD6U9maIDJdhFEIV?=
 =?us-ascii?Q?NrRfNbyVtdYMnggl+WQCTz2rz/9oDrtX8f+s85sZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d277c1b-23dd-4d44-4f82-08daf934fcc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 09:18:40.0504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mDhlzTj7EL7UjFF9n+H+izooZNeSiF0E3wEoXfwBafs2PWIor5xJLIZnyMsa/Zp1DNXMrlIfcHAS+7hD7KyJLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4614
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

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, January 17, 2023 9:50 PM
>=20
> +tracks VFIO files (group or device) in use by the VM and features
> +of those groups/devices important to the correctness and acceleration
> +of the VM.  As groups/device are enabled and disabled for use by the

"groups/devices"

> +  KVM_DEV_VFIO_FILE_DEL: Remove a VFIO file (group/device) from VFIO-
> KVM device
> +	tracking kvm_device_attr.addr points to an int32_t file descriptor
>  	for the VFIO group.

"for the VFIO file"

> -  KVM_DEV_VFIO_GROUP_DEL: Remove a VFIO group from VFIO-KVM
> device tracking
> -	kvm_device_attr.addr points to an int32_t file descriptor
> -	for the VFIO group.
> -  KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: attaches a guest visible TCE
> table
> +  KVM_DEV_VFIO_FILE_SET_SPAPR_TCE: attaches a guest visible TCE table
>  	allocated by sPAPR KVM.
>  	kvm_device_attr.addr points to a struct::

btw do we want to mention the GROUP cmd alias here instead of
simply removing them?

> @@ -1396,15 +1396,26 @@ struct kvm_create_device {
>=20
>  struct kvm_device_attr {
>  	__u32	flags;		/* no flags currently defined */
> -	__u32	group;		/* device-defined */
> -	__u64	attr;		/* group-defined */
> +	union {
> +		__u32	group;
> +		__u32	file;
> +	}; /* device-defined */
> +	__u64	attr;		/* VFIO-file-defined or group-defined */

remove "VFIO-"

