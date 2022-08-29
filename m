Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B895A4063
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 02:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiH2Ah2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 20:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2Ah1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 20:37:27 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652BE30F53
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 17:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661733446; x=1693269446;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=sLn8jlbbwhaFSbrTb5qqqnYNYbBvI+qky9r/Aarv7NQ=;
  b=XRmkntEnUH1hUGGTKbUP2t5Ksfn1dPjzPzQrjKIXrShv3sqb6zxQQfhT
   XSyq92TGk2CEtfVJRDwgYgmVptSbQ/0H2XrrrJG46FHkfYdkaKFDBdZNV
   8W0cRPvjcUJFkBwrYgo+bE3Tq1QFnXVcME1kbOPbmTfT/JRcf92WibeE7
   9k+gSJNx+aFjsmE4GH1+jZ8tAg199CpHpPNlCwy9Wt3h6wCl7HXEd5xg4
   rVLVFhFMpq86rIEsoxtENPfHqNxMTdmS7ELLImZMg2u03hWhKvKtaqWXn
   vHEtllHkAGeL9MJ4fvRIkDcO9w0OmdXA9j2s4QggPHUp+UZbIISLtkzR4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="294790071"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="294790071"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 17:37:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="644243073"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 28 Aug 2022 17:37:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:37:25 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:37:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 17:37:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 17:37:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxabKZUC74L5TXGPmJ/ZEWYm2nBhHr9saCxIABXpDXRb1gqMPNWg67fqUZukv8gBBZBlBjMTX/B241Dsvf5zIMqHIAWi910geOs2wuVG3MrZZVmKUTlZbxKXcH3v3nU2IwLYeZfsds2rfOaIo1wZsVsYRKQ+5MIyKxHE3xz9lWj+qbZhiRWQHnEtlhWtn5scAScF+qO+WBR5RoCyiGhjjpvBnkPLSJXgQuSK1LaH06V3KsW6OZVjm0J8irL7uF1cOCKy7aTF/fJD8nxHoyaIPc964J0Op2dxftjG57Ew9Mroswr+ZaIZWt+dUejrZbgERCVl8uTJZA6kG8+rWcf4bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sLn8jlbbwhaFSbrTb5qqqnYNYbBvI+qky9r/Aarv7NQ=;
 b=cZCJpIPAmXh9AL+qvRkJCrCgod7ZvnXMnFra3gyZw0tcdFmQ8OKhq/tpQpwKf0zBG/ZiMCxeV5HL4OVnXVeddxZ4ATGm8evwmzDi4GGZWd8P31ux616qeOUORTZHUqfL9avZAiCsOcgMdRssqFH272EMvX1sDEMPzEDyNjbM/xc5afIe+dy/j96DM+kjctpaaF47r+u+OMQdROl61vFUnFNbBc+hmyIwuor7AvUNlvgBUXzFmfXp8iaVko9Ba7whaI/CPeyZsF4VXVVJTrn9btbItFPuNxXFOsAWUKxiKVkGo9z2wEplSCTd1VQu27G5dW8CbWuvajLY/MaIWUdo2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB3968.namprd11.prod.outlook.com (2603:10b6:208:151::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 00:37:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 00:37:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: RE: [PATCH 2/8] vfio-pci: Break up vfio_pci_core_ioctl() into one
 function per ioctl
Thread-Topic: [PATCH 2/8] vfio-pci: Break up vfio_pci_core_ioctl() into one
 function per ioctl
Thread-Index: AQHYslOeZNnKdFSOxEKW4qbWWSNmxa3FGIkggAABrhA=
Date:   Mon, 29 Aug 2022 00:37:23 +0000
Message-ID: <BN9PR11MB5276C7F8B0CB3DEF980AF2A78C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <2-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c4dcc43-7782-43c2-cd51-08da8956a412
x-ms-traffictypediagnostic: MN2PR11MB3968:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LgfjxUns7rY9c4Byu5AyJztN1VMzLfom9GOshxepVgTwD8E9IkXP6yMu5dejQJEfI9d73DKKHgEVrb43iMsM+7f5MC/ddQ4pYhGtcrwGVea2hO1WNetWOgy4c5iHcg+w0mCkmZF1jsL/Sx45u/pdqMQmViQMfCywb5NbaCxXLs1dTeJ6OiMYZYcPD7QkXY7W4T2KbuTeYGb5XHZnn/XYub2DDd547IR0wBqyPXdNe5U9ps1ZYzNx7O1z5zlb8aSb/c8nrZyuHpLH/iAUTuKIdfA0/z2a1kIxm7OEE8tnYCzEgJHB/K5gh+UxcwG01hHmRtZfYj5zmi2wNusiFh3R8FzpW7ndQU9PSmxKCpZtVUc3MbttlPcWmXJPPtMdRA/PuqLtNThSmmw/F5yepKnIvPnM8KtUIopu7tlrGPfiQmjjXAh4fIyyoiBI0HzlOkiUlJsitHpX8pTcx/LcGJf/F1wb3zm+ldxI5t+QSq/11jlxZ07QHfiLJHGhaBiDI7yTA+a90UiySiU2Gbc+L+b/wyEyHUGhj2evBSLXhxVjyr272IxWMMbd6IAEVxZu1mWQuGAPKCanNxVfU3z25uN+PX9rFwFcVaRbewXSb3+iMBgumBcnlHVwTQmx2mCLt3goBY8ehHAG7TP1B1Edc3NzanVTqBM2+z7BSdpZ8byoFoCIa0R25UztcDK8USIUL3EDAHCANZ40D3ff/DbPqTCfmmB4AFoAbECC46H7VH5XN2e9vnqjN8BpEwKiHEN/aNI+0S4sDBuiGcxPkIiPOimE/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(376002)(136003)(39860400002)(7696005)(9686003)(82960400001)(86362001)(38070700005)(6506007)(26005)(33656002)(122000001)(83380400001)(186003)(478600001)(41300700001)(71200400001)(55016003)(66446008)(8676002)(66476007)(64756008)(316002)(110136005)(76116006)(66556008)(52536014)(66946007)(5660300002)(8936002)(4744005)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aDYGvFXrZA7wB7rvzwQr8TnUxGTpLHjI7BtyYJuT89EdmKHPcfKfCenaRrHi?=
 =?us-ascii?Q?0ItlS+CCF42FSJSGEl5qn2xt8QGCeMM+DYSsSzBJDwstlNpXHwZJM7nSFfZH?=
 =?us-ascii?Q?O9FflUOMZ5IFrWZ7+cL5sYuNfTcmm9kuH+Hpcaor1IrVQEZY2Bib1dOr1i3u?=
 =?us-ascii?Q?cRdFtT8Xfki4o0/o0YoGx1jii00paDxl/GbDOvv+qar1M0uZG1gQZFSbSSsW?=
 =?us-ascii?Q?UN3sME+RV2pjlkb+UhLhMQqIu+SHqczVwpbVziTZPGGJzwOMzkBpBa2c6aFE?=
 =?us-ascii?Q?vneTsiqQWFEnXUMvmXOxY7bJnqpLUC+pPjdOxr4CtA1KDwPdSLQg1IcAh3kE?=
 =?us-ascii?Q?LCmLgWdP2SD+xWTgjtF8ww6CLoUjFayXkDGoj33nRrRcYv4AsTsGvJgL6DVu?=
 =?us-ascii?Q?R5xtoNXFlk001mdMRBm4nrG2pQDn+SNiW2UsHgG/O2eS583oUdSBul101/XD?=
 =?us-ascii?Q?ZJ4hqBvZ5EALUx5QcMXH2hjCV2Sx/QkmTtouhpxlqxd8baZNSOGglt/JugZ/?=
 =?us-ascii?Q?1AgbRrX7u0ObS+fETjTnqhOIiO8e0srDIQjD9GMDxnsxzNgwDLXSD4MBStA2?=
 =?us-ascii?Q?1ivz7Lp0rEH5Soe43l3sEHAgq7NImybYlxbC2o79X0wa/zRPNJQyPDTwHTDB?=
 =?us-ascii?Q?LIktIRvfniDOrIm8KDIhDwlGrKMyhdxYdn0r0buOLNUTwZ8tiZwJbRzFNztV?=
 =?us-ascii?Q?JS1YAPRr7lPurKpIZ/j8nE8ygruDwjG3jI4niwn/SDTG1/xufgC2KoGe3gJk?=
 =?us-ascii?Q?MPVXrNpGa0jjUzMxN3jtcFcZUNNMm5jxCzrAOmRDaRwX4Aap7FQC18RAxYZv?=
 =?us-ascii?Q?vBlL/IJC8T+QSw8+AZPGcgPj9i9WJrm7DyCIroqYCFGP52VgiB6l60xpVKX3?=
 =?us-ascii?Q?s3dfAaIjA2i1LCqBAgXC4YdFu4T8abK0HjFuaKpCIdcbj+0Tr18XDPbxPbAM?=
 =?us-ascii?Q?xCifHaCpjhWcigp1DbOi3N9OG6jHKCRln8qocA9JnyWmwVxLznFd8kGTB1ja?=
 =?us-ascii?Q?GXXUiUZbJOzkuXHV76RNB7WZZ1qztcMEkJ47RGJ6q66OuaOU5K7wfdQfc4fS?=
 =?us-ascii?Q?La+7xSqYQ4pFNT73tr71j0gYGbHYdYxbFE93V5h/MxKVQm87ne1fbKT4v8Lw?=
 =?us-ascii?Q?CuFS23xOgo5fXChXqse/bRkmpJI7I9b5W+9SlZ14Eo7EIlvGkNY2rpveELg5?=
 =?us-ascii?Q?JJu3Lw/WxZMUllWs8ZZ4OM0r5GGQuPJB4sPUaGhr5oS9cYI6fFX7iYm14zCG?=
 =?us-ascii?Q?VBnAIjpWaYxy7SIAisEBM/h8WxUGCccC/XbMrPy6qDy3VKsgj8bW7C/xk402?=
 =?us-ascii?Q?dHaPTk0F6Pty3YdpOMuAgqq0PdIy0a5d8oTdUlb3uN8IGTfgJCYRqgbz4c8k?=
 =?us-ascii?Q?5F5BjREw+CNMGxXk/nlLrFIiYK8M3JgsgWxTvl83jsqaAfNHl35Iz0lS8UwY?=
 =?us-ascii?Q?t5wzFNqXBqtGvE1EZU460f20UVaHEz+J5xwG9wom9VHPuLXJ+sfHvGjHppVu?=
 =?us-ascii?Q?AJbn+uZQK5et6DRVWBL1sWR1Oe8/HYiyGoqwRzn+ujGvlJIgubhpYtK1FvEv?=
 =?us-ascii?Q?FixEwiTmF8tOa9ZsyJkV6otkgLFoPxf9QY/6x6zw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c4dcc43-7782-43c2-cd51-08da8956a412
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 00:37:23.8766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ptBVIK7eS0ZbKyFvk8EIykZZ0paH6xQH2tDyOrtR6J3dFQOLmUMXsgrd6HEgYWBFjtKsKdXYYizzGh5t7NeG3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3968
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Monday, August 29, 2022 8:31 AM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, August 18, 2022 12:07 AM
> >
> > 500 lines is a bit long for a single function, move the bodies of each
> > ioctl into separate functions and leave behind a switch statement to
> > dispatch them. This patch just adds the function declarations and does =
not
> > fix the indenting. The next patch will restore the indenting.
> >
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>

Ah, quick typo. Should be:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
