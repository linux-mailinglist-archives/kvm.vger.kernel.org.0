Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535716F11DC
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbjD1GnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345360AbjD1GnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:43:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF774213;
        Thu, 27 Apr 2023 23:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682664184; x=1714200184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qb448O13JImRWDN4t3Y3+z0HmVtRUFVM4M3BLQAFf5Y=;
  b=PX9cm+blimKfGhJOx3kEtsCME9CagTmwK+KvBUux5kfvzk/mi/2hgo9A
   lsfOAE66FQv0RPKoUSn2AJJ9lXnxLFKcv2OoF8n8Fmj5mYZ/o1oBGL0F0
   adQC4x2B7dMEPpGqyXUhRPmhnTHhQ9Zqs2NeT2FGK9GiEdLQvAu5Kje68
   59E/H6ZzDdfEsETEjPY88R9pPNWv+O9u/pQp1mnSOTmz0ZZ+HsKpayZS4
   /uEWI0ticaz+DqBxxQ31Fzy2QM2/IxlsdYxmMzbpHIPK6cie2iuFfSiyK
   REd6/cVjXpa8ZrKBtDDbtyx0GTZvo5MZ9vAECxZbZaJVn5SNvs7b9/s5j
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="327287533"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="327287533"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:43:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="784076703"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="784076703"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Apr 2023 23:43:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:43:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:43:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:43:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:43:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJaYyRz9LnRQODaP1Ogj0Eu+WF+BeijrfyfVLdc6apiOfH4bi2rijRWXSQI5Kjuq6Bcfl+OLNjfcunGZguZi/XKcwD7Rravl2RNH7XEL3Q0LtUcMhne8nx+mi+PvQsYwSnFbvX8PoCb0ULIoILGa9/F/nFz0JGDL55zJuquTUxSKsvi/qjcTowquu7SGFKmppGLZEdlcpWZCRUyGbR3zoXU3e0HCIhazkH3sOF+fDQcpm2AM1C1YxwJ1K8gGTNb4ylTjuoQNuIQs0j70GYFCTq/JGw2NszDy6QaG+yoRL3XmKS9xj4udL9FFv1Dh6Uc0/gc3X2sD7HExtca10RWMeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qb448O13JImRWDN4t3Y3+z0HmVtRUFVM4M3BLQAFf5Y=;
 b=cvBqkNKAUDkwuhGdHQX81ui6eYoHKUss3EqKty/UZZrzUPoFPBYwkJt6Qj60fN3kJtO0SNlKrNyefYtosHlvEiKvMXhgGjN2cB277ZaGPOwK7SAopPES76z8w5pSu1mdiQPCUqUzYZM3EiHvh4GZfkqhO9DfIBXtSUebfTbsUYjUgAhYezpD62BG//k4DjUrhlBRvliVpaFVVmkmFChjJWP+naGdHXG7WxFmxHYrrCyqAJ90xBSiz6QVlZvBL3ESXRBIptOv/zTgiuLNMAg/S3YHVtj1Z99LPtk8lpjSkZiW9Jctv+RsXcO4PCByxRjJsaXcD1712agmeU2FMxwo9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 06:43:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 06:43:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 08/11] vfio/pci: Use bitfield for struct
 vfio_pci_core_device flags
Thread-Topic: [PATCH V4 08/11] vfio/pci: Use bitfield for struct
 vfio_pci_core_device flags
Thread-Index: AQHZeS7PmQqzYDHQq0qJjERkHaB3kq9ARu/w
Date:   Fri, 28 Apr 2023 06:43:00 +0000
Message-ID: <BN9PR11MB52768311F5FA320283B06C358C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <42397f8cd0419694797c6c5cf65ed715117fc760.1682615447.git.reinette.chatre@intel.com>
In-Reply-To: <42397f8cd0419694797c6c5cf65ed715117fc760.1682615447.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BY1PR11MB8126:EE_
x-ms-office365-filtering-correlation-id: dfa89b4e-6164-4111-8b76-08db47b3cf5d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 95Daxlrffw3iE/D3WeMlJ6n11NKfSSOBuv1LmSXZg3ojHQ2pi4HrkPBLTjHnZ7CA8HXnBl945nhwD0erVXLBGl2wqWlZJ08FazViE3cqdtoHEkMzhGWQgmQyHcti03Nf/9VDo2Q3LCCW8v0srkDo0PU+nfHFG7BIl0c2GBONsofXz+sefBPxnnCBeWLc9OJ+KgDfOJ4hWEgi5B7kLuH2StGD9lLyXNRpnbOReAAW18YcoNaDOPH8e+GRt13EZuAd2Qp2C8zs5joIVLewswp0PMZU5c9dpsFapw1bbKo/yTkyTF6NQf2560y8sCD/QA8cDEC4NPT+jQItsGaCzsl9hKNg59kqXJGXg4uvpfi86K1BHoMFChgT1pbzte1wXbsn6CB3YNEALYSowaRmXE5mmZB54/A3VRGahzFJj5fDeUuE7MZPiyxPal8CVUzDjt94LJWh9ey6eLKA1c/4/LfnmxRh5EpWkYXzkdLvB0+cAmimytH/bSeCWSQrKwtTOw/1EdrAnQRpS77HHx1tv6QBu5GVHIEJbUMrdH2UWt6on536JzwO2VLlUdOWpYr5bOYTMhSztvcx3HUt1kbwBx98d2H6BEmvwSg7tKNwgy8h5oaBTeCajR8Sq7capOxziaQK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199021)(66446008)(66556008)(316002)(66476007)(4326008)(110136005)(76116006)(66946007)(54906003)(55016003)(5660300002)(82960400001)(52536014)(41300700001)(8936002)(64756008)(8676002)(38070700005)(2906002)(38100700002)(122000001)(4744005)(186003)(26005)(6506007)(9686003)(33656002)(86362001)(478600001)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8kpzyND6oDtmF1mMVUWLo0JyRNfkHSyK8PuZe64wd1HPojFb5hSuK/xmvptK?=
 =?us-ascii?Q?Zq26HqnNOWTPMMtcSsuEJjPYX+r5alljrUjbJTzJsHkjhaGrbql2pP65SKhV?=
 =?us-ascii?Q?UwPnvjm3Zj5osM1PbfF8OduMefxJ0UAX68V9mA+phL9ErFjOn/tmK6XrhcI/?=
 =?us-ascii?Q?Kzw2FO9Rr5O6znJL+577Mgt4DRyhDVHYiroTzIY6PV4plOADtVyerYOTzV44?=
 =?us-ascii?Q?MLWXd3DMY/mm9Lx3xKglLAbFgHcxvu4ahsFUKczX8pgle9Rmg+FFvJoHaWWg?=
 =?us-ascii?Q?e/oieX2hD51+M388iEBLlRAX+5KODeInux3uSg5/Lvifi80zVtNsz2dlamBP?=
 =?us-ascii?Q?T8e9C20Juqkrtx6Zy3TbiaVy7zuuh2WUoesB89BUE0OxqsWyHXBa5spBvDug?=
 =?us-ascii?Q?Z6zQX/PEU0AiLT/fQps3ukPkDGVHxm9XseMppSI4N2tyUCMOO6IvjiVbeMS2?=
 =?us-ascii?Q?nkgMWcWtQBU8gwDkEiMDtk6AF2jiKKw5hAnLWVPUpqFFd/6cI5uHISEe+x6d?=
 =?us-ascii?Q?ObpEuA0BqPMpcOuuWjCySGsbh4zwsPB1y+RVJL9T3HSq9WXOnTLQeiSg3jVe?=
 =?us-ascii?Q?HgfCoQ0p1KUP7EzzhLwRmQwccycDzbJCGnoT09mfhgPZ4usiciFtAkCsT9J6?=
 =?us-ascii?Q?lt1rdyoalG5hE/r+h6VaA6AYE04z4f6TvSW4tLFzEonoVh/Wslk9ibJ7iVB5?=
 =?us-ascii?Q?UoHF4HWagHYgxK+o2nwn1n5XndQPmpsHk+VFAI48G0c+YMoiLhFbGA9K649y?=
 =?us-ascii?Q?3VCKHPZa/qz/2H7vQdjOpbO/lGfMs/VuuTAhtmIN7xqNhKtZn/28ofLBw/ZI?=
 =?us-ascii?Q?3C6AtotvwNkCqxOpa+SzYow0hQzRsZXBuIgo5IlVc4QPjNav35tOa8irwR1B?=
 =?us-ascii?Q?B3JlgW8vT4edbG7tFvRRzDa+Jg+3LC6fwlQXNDfzGjvZAKgdYCTapXLGBBNy?=
 =?us-ascii?Q?hmGIhzStBbsMDYmuPShre95+a8iYaTijDwdS6mrjfLHyLSnNb2jmJMzGqCg5?=
 =?us-ascii?Q?rCDizw00udm8C3EpWUQ2ymD79lwSxjp7ZPuAIqKH8j+vxBBc/R5MBmU2d+X4?=
 =?us-ascii?Q?1rlbXdAeY6dsLPAUE/AmEWm6+zqwdYf3+AOwjQ8cOY6kgsEjbeoRy7sXvtRB?=
 =?us-ascii?Q?XvzRbjWk4yg+scWQIxwF+Gt57XqqVPfD/JJM4lkjNFbjkuM/wEuf9oTZ4QPX?=
 =?us-ascii?Q?VrpzP0cqdpmGg9D4wHTl5C4JBRd/MQsi+q1OVfKcbTUSrOto5UO0DmBzlD7Y?=
 =?us-ascii?Q?QD4oVPKEVgXQKOIhhxZMB5lm72tKaeNvzaN9woGXKCdEoexDT6+gFZfDjWZr?=
 =?us-ascii?Q?vBEpevYdBTPDF//0Vs+4pltYg/Keq3Yv9e5JzHnCfyiMH0mj0MR3DYBvQOAO?=
 =?us-ascii?Q?SW80PzZkzJvoF08M+md+VUtdxOhikXC+nBsTHUbS0Pqa90mpMip90HbCEDEB?=
 =?us-ascii?Q?7ZPnrgJstvgxHgPS15s1oQ1I+cznCQZVfjisa7PjjDQbcMe9MuqxZa9ntwoE?=
 =?us-ascii?Q?CBsJ5BbRWyz3PWR4tfn59klLnsqwTSxkxw5H8uQ5mKuHsorJEExPQBz+59Mv?=
 =?us-ascii?Q?rsX3XSAPogEoqkZUC1DoGU70ScihSzkwWW+P2Ezv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfa89b4e-6164-4111-8b76-08db47b3cf5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 06:43:00.6726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0d3OylSc11gQRk/kfsdIjBgkBQNCcAgMuuppSXUXO2f8mHa3VlJnAaedHuLKBCvjgaxIQmTflThXcfjS/OZOKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8126
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Friday, April 28, 2023 1:36 AM
>=20
> struct vfio_pci_core_device contains eleven boolean flags.
> Boolean flags clearly indicate their usage but space usage
> starts to be a concern when there are many.
>=20
> An upcoming change adds another boolean flag to
> struct vfio_pci_core_device, thereby increasing the concern
> that the boolean flags are consuming unnecessary space.
>=20
> Transition the boolean flags to use bitfields. On a system that
> uses one byte per boolean this reduces the space consumed
> by existing flags from 11 bytes to 2 bytes with room for
> a few more flags without increasing the structure's size.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
