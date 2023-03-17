Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9448D6BDE1C
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCQBTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCQBTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:19:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076241FCE;
        Thu, 16 Mar 2023 18:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679015974; x=1710551974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uVF1ZQhtLM7PtbOZ2Cueb7mGR6f7luGv8ySfdjaRLkY=;
  b=OnwDGCcsrRBvYvCbmT3nd9EsM4Ja4gFTPHT48tgIeAKOgvKVV3fhmTZH
   XFqT1300CGX1qHkt2duVXP7FCvo1ZOiUyWMJUcet1iSBSf5CVcVD8T4UN
   2E2VfEeJwHQs6YRmutaC9WzB4/FbeGHoqGlDyWWtZmMaZqCQdDjImxYtf
   CfZMzuYpCCAEZkKW9kkeQYWJ3Scp3CaTCaaKeDpYrR/GxoOOBFE6rlZga
   SfoQBAZGIG7JjeEft+fKdiZfYQ9tyiQ+n154f0ZjPdH/GzGosedhTRoQO
   eUwtge+p9yIEEMLH4bKkkv61AD7Rk5zVKxMU89Etl4juqGz/3PW7zrUXK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="365849427"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="365849427"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:19:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="680102523"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="680102523"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 18:19:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:19:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:19:32 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:19:32 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:19:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqqpqF5OPfJ2mPUoJww120wg3dv+Ztpj7UkAR8GbRC03MO/Hx59/SU0sOgmRMAXKj4DHLni6tKlSxzldWGYuparko5JGqGLzd3OBIQJ8GFVjHNvJUFJ2iHX7Kdm9xhhdOMrgLf/zZMbiwAR/0fOKP6slIb0nlQ3ZOspf2MKeJ3aCumZh9iOD9HvHUW/5Ra+Q3+9BHvZ3zJrwWDzT4C8PWe5OK0uY46Pxd/s+cVs4UaQXI7ByRoNIFhLCD8IF39B7oGaOVw93Dh0mhIO62sLbHSeHCgM3Hns5cNtOyXkZ1wfoMpO2T+WqNhT+2jstwSl984Xrvn3g7JA5X7eLbBbbWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVF1ZQhtLM7PtbOZ2Cueb7mGR6f7luGv8ySfdjaRLkY=;
 b=hipPQVA8HHhgQ17lXKR04Vbz0VJbkaz5X5BWBCvub1/gesRyIjjt1qXqPXF1HiFmNbWGomiFK+uZC/H+3tlZ/RZ868SpY9LzDY28zpQ7SkUcD1h2MhaNm2D3Oc9Gptx4E+me7/MwkAG5mcmSziSjRJLmXsMScF7SRJ34MzAXNSidFw8zLJNHCguHrSrRr1Csib/qjqMpITfB7QS/9rie1tDkONpZW0HqD0AwN2eNfZsYowfoIddpZfrbLdnkVhZV9TXzEApO8R4jEGm37kVp85INWUmaLJCW5KVQXZ/3cGqQRzTvz/feAwiWarP85lWrw+r+D2hS+LUE1Tn29Pcvjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Fri, 17 Mar
 2023 01:19:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:19:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH 7/7] vfio/pci: Accept device fd in
 VFIO_DEVICE_PCI_HOT_RESET ioctl
Thread-Topic: [PATCH 7/7] vfio/pci: Accept device fd in
 VFIO_DEVICE_PCI_HOT_RESET ioctl
Thread-Index: AQHZWATCLtCa/E11N06ytTusoHlf/q7+LKPA
Date:   Fri, 17 Mar 2023 01:19:26 +0000
Message-ID: <BN9PR11MB527608FE2A8B0A9C569994118CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-8-yi.l.liu@intel.com>
In-Reply-To: <20230316124156.12064-8-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB6077:EE_
x-ms-office365-filtering-correlation-id: 74bb2dbc-6008-47f0-e599-08db2685a641
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j7jqumvD1Q7hlVwyzmgyP3cxJ7roLfUTfr5DM65c/jGJpBtjPGlsbqZx05Z7sWNPk7fgmSMRQwvwP987OsdpkatUBrwkC49Un/RiWdAmq5nDber81QnRPOe+Idr/eb9kUxN2x949YjQb55+6oMHKY/M+TAIdEU1jTEU56UjHjdUzUdGBs771QoRXB55ZxhHPfbt++scWg7iyUxEK8YuDYaRt66Lq4TQfU9fqW2GU67C3yUbbVlZKAkIjYONsJ/GhzasxWrcZZ/eCDg+yJNzuMOj7959o+CZMxkdE8ycRBFh16qaR3anbx4m9nrU+AMruUAvq4w/ELXm/oIFJeV4rImaNIlrEsjbGiUOflGiQsrnNHRfYB2blz3eE67/4+BMw/qeVvW0XCMWYQ3oaKybTaWAS8b71GCba299LJzxmsDIwyftT4/fNNQIcAm7WEDjKgJYKg+j5+cI7a4hi1RXUBkM79nrIqNdLnRxJkYdWULqg/2eXyj+aZ503VmijJDJokOuxPvFyss7DOqR2HWjGrWcfvkMSqLWCxNO2MYkRepHZNFuh72KsSVhyZVprz5j9rL8xl7rm63OwBu9cWALvcL7ebPYorBuL0Tv9ucCkFais/qik22fMyaIUaJLP0FUBmPoyQU8rHI9tOwR3/a6CB90GQQ7dSrhlK3Ab0U76jVFaTt69aT+3r1s58fTykNASjOAJdvar0jD+/97Sfx+VPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199018)(7416002)(5660300002)(8936002)(4744005)(83380400001)(41300700001)(52536014)(55016003)(122000001)(38100700002)(82960400001)(33656002)(38070700005)(86362001)(2906002)(26005)(6506007)(71200400001)(7696005)(54906003)(110136005)(9686003)(316002)(478600001)(186003)(4326008)(66946007)(8676002)(66446008)(66556008)(64756008)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jaCmZ07gP9dohLz0eqP/roggtlUY2xsDvgf+YQr/vnOVbfOGH4OeaHu/SsLP?=
 =?us-ascii?Q?oDjmZ9cG4/yN4uOSl8PK1ha/7vzsdXY6yE3Xd+Hxl+uQZ95dlgxJ14Ro/Trj?=
 =?us-ascii?Q?oU18k5LkzdIneXLBUS2vyGsi9GejdIfwOqH7XfmikKa3klZiOEXbC5N6i/24?=
 =?us-ascii?Q?YDIi2ioCnyE+9OPqM81IFi1fGrVrJnPF5MfXRE7ley4ogg/Avv7qeiVl5ViD?=
 =?us-ascii?Q?8dOXP17OvkcPKNMpfXMKfez3B7Sfl7cVdhBcPbRd19DlsYSPGsGRs2FkeEW3?=
 =?us-ascii?Q?V46pI6CHqK6CzcNxLyaex7Ah3ry0YLN0YMtrZ5r9jioaF0IOODOitW8z5kT8?=
 =?us-ascii?Q?/u8Qrc+QEpdwtE5ltT84xNoR+WY47itj3RTScDU9tK9wNIt5dK2J1kog3x9+?=
 =?us-ascii?Q?nGR4kem4vLN/yBSFWrT6KowG47WNjUbdUMy5GWZnPYMePpoQxWiCee0yHK/y?=
 =?us-ascii?Q?MMlELY63Ofozb+bl/DsjaK6okmhKF0YwTnIXnrvZq0BZqcBwWDhG748vARha?=
 =?us-ascii?Q?Qh+83uhwXBF3kL73fe0HXccwhJ8i/qgF5JdO71z/+KZ/AdcfklwoTO+PYpxW?=
 =?us-ascii?Q?AByZ+KhPSrnduqRLWes/B2f2CRFqkLWMSWTgQe3SxwzQdN8vPtqqbyCJwpeK?=
 =?us-ascii?Q?tF4Aaktp/CpOgP9e4qedHTGdY9HtN8uIPtVlzL6E1xikRg5Ge5ubu0b3TN2m?=
 =?us-ascii?Q?9Y3Hn1RXBhuTcFVUSyzItFQmUEahh4d+ofLuvNUL1KWgM6D0RaWSJFCGv2Gf?=
 =?us-ascii?Q?qNFyMVkYNcXzUgJtcjoo+9OcreZtsgf95N9KatYzPy+d5A1FduZGGFAkqRES?=
 =?us-ascii?Q?KG1DGVkNrc/lDqnT9OOoi79V8wme3e9Hv2Sd7pWgcZYBY0QDRKHRCKoEKDaU?=
 =?us-ascii?Q?7Z7m4WvhHw8cPC6QsluUwFiMrQXCMPkvYxlgazUbd8OG/iBcjFH52QtcHVAx?=
 =?us-ascii?Q?OZO91MqrVcQf7uBhnT5dxsp91yxBCxJctl5OQVrSXGdC58e5VZeOYLKZFG9W?=
 =?us-ascii?Q?XjRyfRuyPWtQ11a3GghkgABoxigr83xXE0WXca9S/3Gp1IRGHkSKZ4mR2tlu?=
 =?us-ascii?Q?8QoXGSq95rj8XmZoybRASoGTztvm7qj6TqaDd2nN385fZ+vH6Jz065AE3GAJ?=
 =?us-ascii?Q?OBYtkG9pRT5J/mDnTsOO5okH9yaF3Z6z0pNxd+Sz4YPfZedF0/4JO1w+0St6?=
 =?us-ascii?Q?omoZmbgk+aBYMHDkrn128ROwwqjxOUEP0+dB40Qu5Elq9wLtB11PHj3ViekZ?=
 =?us-ascii?Q?WfXA3i6a0eA/27Wh0DdHCD+3I8922rd2BpXRMh/BhfU3xlcIFLQ8S+XgepYo?=
 =?us-ascii?Q?1PqhdJQhs3IPMNvoxbQXr4WRAGiLqZrhMU/i7FqE7QMT1QQrPQTg1Nm9rhG7?=
 =?us-ascii?Q?Lrnx+XkUvj/JhnE+riMw/GbJoLfMod0IKBUK4sWF6zEVxaWkMFeLr7+TXlwY?=
 =?us-ascii?Q?3rMCgKQjr5akN974igQcZw+tOz6cArSLBF4PPrm/1eVUUIY/cwrCA7ACVHv9?=
 =?us-ascii?Q?uj6BEk63dv56xfZ+CQTWUa6yH3vSSn2Ly4XJqi619Wu80X4dka9XbaC0aC+3?=
 =?us-ascii?Q?lvkfl30lP05tTXnBJ4uBsya00QpCpzy9dPqX65fd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74bb2dbc-6008-47f0-e599-08db2685a641
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:19:26.4587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzAIlG+PGme2K9f8wmVz4KabDe8PAvIKRzH6p1rQ/FTee5tggrKhrg4JgyD+8hhn00q+9bMyhnXwv2f5ChjT9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6077
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:42 PM
>=20
> Now user can also provide an array of device fds as a 3rd method to verif=
y
> the reset ownership. It's not useful at this point when the device fds ar=
e
> acquired via group fds. But it's necessary when moving to device cdev whi=
ch
> allows the user to directly acquire device fds by skipping group. In that
> case this method can be used as a last resort when the preferred iommufd
> verification doesn't work, e.g. in noiommu usages.
>=20
> Clarify it in uAPI.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

this may be adjusted upon whether zero-length approach will be included
finally.

but on its own:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
