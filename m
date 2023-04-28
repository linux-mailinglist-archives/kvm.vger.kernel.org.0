Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B556F11DA
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345207AbjD1GnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjD1GnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:43:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757FE30E8;
        Thu, 27 Apr 2023 23:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682664178; x=1714200178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XNaE2/Py+/jBkAdS5OT8ou5BiJzgYSCMgA8NUdIc5LY=;
  b=axbFSXyiPifSlyfSvgo3HcymfHOfqs9CWgHfSlbbltm6ggrKtxRYDgbw
   /itGywcQ5Jain1fyqunejOYNUFr0bFg+ZqZCBupBxGmJa9/bOpzbG5EzW
   dPzKxzpLuJchwv/EEm4yhmgI/FubgbaGSh2V3PatWQPv74MKAJbFnH41R
   UxXB0F09WEYqILanu4f5OdJJPNhyAI/zpU3AaonJm/PiYnh49Y/ZJ4bsI
   +fnrK8TMeljUKIhEsHWxxMoMU/wUhcYAHzt3YqXM/Gx7YVZNofUkJ8Y0z
   Jklu1GZRRyWVWliSSBoIbYf9sxi7MU3eNVDyzDeJonumBv7sN6so9M4cB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="410750938"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="410750938"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:42:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="838743974"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="838743974"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 27 Apr 2023 23:42:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:42:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:42:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:42:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:42:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpVifH07bt3HNkuB4uzrhU5vLW2loNTgflscAmCQYbQy+h2DqWzO1VcHyMYLDbNfSl0vhddIvP42PkIFjBeEhiDSlnp5QoSlrNsDoAvRWf27f5VDZA6vW8K8FlJM3zMymhxjuXMRTN7BkfgcfQaSfMGa7SUBMeiIzV5UK/poRSfeA1uAvBOHQqkF4OyWXdoJlQor7Tqjop497OgUY29Q4thKNKLaWod0+a+9LouTDc7Y+VPJaETmF2eCisXW2qam47zRvHCYIbax8zegIBtAn9LT/Hsrj4LdhQ5yFfCqTL7iWKt4IMYEKm0bp0u6NNlzIDVMxiaDnZFQNE/Zovsh2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OexcSK8sn6kriWJnfXxbfb3T6pM2d2yMI4X0srdv+5E=;
 b=dHOKb+ZHNn3OZdTH6/jAIU8Qeb1E5zFDXN9+HTFi5MZcf1HymSbSrpfcabteIA8Wavz8WrwNKRqzIuYrk2kEFLjY8zFltC7kPk1k6FTZsnkCDOq3NLn1zGteLaHOodli86AdVzNQGmDey3uSAa3daNIPvGHStcu77gb1owgBSeHs3w0G68St+R1lA8J4d6g7r+qCo0/3qYTUKIn9L/OwlrPze7aJ80jJtJrIQUknE+qBNxyVLjPXZKPPo3TwtCoFa/f58feNBAD9eL9Xc642SJRFL0i+kBHR2PucQDF4S8f84ggg41rhteyLj9eQvnw0av2PjbQaBfI9KiaEUKHeOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 06:42:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 06:42:49 +0000
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
Subject: RE: [PATCH V4 07/11] vfio/pci: Update stale comment
Thread-Topic: [PATCH V4 07/11] vfio/pci: Update stale comment
Thread-Index: AQHZeS7OdjCZc/1V50izazr3xzJnga9ARQ7g
Date:   Fri, 28 Apr 2023 06:42:49 +0000
Message-ID: <BN9PR11MB5276651EF3C7A11C2D60BB8D8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <f16872889aed9a7b042a7e53722b9ae83430a126.1682615447.git.reinette.chatre@intel.com>
In-Reply-To: <f16872889aed9a7b042a7e53722b9ae83430a126.1682615447.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BY1PR11MB8126:EE_
x-ms-office365-filtering-correlation-id: ba79e7d2-0112-4f9a-adac-08db47b3c889
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4jkHUHJ+kXpsQvi/thTWcgHUDjeeivc7TyICOAp4mCq4iwRVts2EQJbWjy/JtVwQNUnUhN3YEYdhYo2oxc9rmz1yiciu9gDMfFsdcxiT5VeOWcsvjrhW4GvVjsz+piw9rFGBXlUfjGHju5s5KjjSbFnjxrSdzV2sRLoauK1IcVYD6lcZ5WfjlsDd6rvB1ZMfgWfMNapWOaCKNRdgCSRCZZLTREk4m6wXug7ryct/mIy5Ck6gV3t8iTSh+BsIWXu5gHsb1euWmQrz+Z39oVVI4SeLFNC8JHvZz1D7Rx4/bx2NV8csePIcH8GT4Yj6ryIolEol7K2oRR2+f1n992occrufB6xv1NFCR9chxgm8qA3wkPucGA3iRjsJe5kFL86cuRLRFIo3WpEpByqC0FiO+3c5ReoW5+1B3z/RUtLHCUPF15zwq7QkoGvshUB2FlS6MtpksSRgbbRrBXzA0nK1nyDCjvBFfA7RoqfxGfMpW7VXDtanDpyg1eH42BZgVxEpgEPDJfa9nbRh/DrioSY4mJ323Q1FAjIVS1k3h+oTRXjN55Jsl9LPnM4NBeaAY7mT+NRbX2AZMKVK9HAv8ci8fa7QsaopOUi6FVr37FKnMUCKHnEtoPaRlW29L4lf6o2z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199021)(66446008)(66556008)(316002)(66476007)(4326008)(110136005)(76116006)(66946007)(54906003)(55016003)(5660300002)(15650500001)(82960400001)(52536014)(41300700001)(8936002)(64756008)(8676002)(38070700005)(2906002)(38100700002)(122000001)(186003)(26005)(6506007)(9686003)(83380400001)(33656002)(86362001)(478600001)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CItE0vGx1X/cRllYZMp5JbJhq739b3y3Z+6Zg+1JHdBynd3JcpB4oZrtoR9e?=
 =?us-ascii?Q?XvIp71m/3mmwkqva3Ekhp08JKPqTok+g45AWxpHAviRWScX3AHTdZISX4NMA?=
 =?us-ascii?Q?D5q+mBft6d2Fzdt+JFAiDHb1NU0dHJGtUh3mr6u5PF0dcAk0tgaFPZQTK+RC?=
 =?us-ascii?Q?Fn9jDeuf6LfZslWGoq5J/XNoiCzrr4txJtUeNIwwv5y06G1En7z+RWx1TgN0?=
 =?us-ascii?Q?GAaAKpU1rxog8pLhogKnO6po7KGxDBW9yg6QRSWuFqbBZd7JQxQtcdj4AbiK?=
 =?us-ascii?Q?ZwoQBLIE6E/tqndgJGq7WudV3hj72vsuyDOYa0DoLrG5VdlyV2tHUJtQiPxf?=
 =?us-ascii?Q?LSstPuhSJpSYB4NGU00Iuk+X5XW0Bsx4EtzqCvD0uLPD+EiJKHUzpMrG7cgC?=
 =?us-ascii?Q?PkCaTiGQvQ6IH9XvwF7XXlwPwiaA3tyDB67TiX1r1Ggq3d7JaJKe2ZXM1maf?=
 =?us-ascii?Q?yLrT7jiUEV8d78qR+Q+FwNq5VfRkrcJ71Jq4YbXIdNTiOOltA1tr1an3wnkF?=
 =?us-ascii?Q?v5t0DzopZdoyGASSKxa5ZrC4eMtroEBDUBlFoU/PI1PHkMc3sJVyQ9D5JH6B?=
 =?us-ascii?Q?soyFApPsD9SDGNcUwzc4y498fM91pVOg37KX4XUwPGmrw0y1h6iRehtkne+E?=
 =?us-ascii?Q?MIUzU6j5zwmfLTolXYaXlYBjGjFp1eZNQ6Eq5Y53PWvepXk5myRbQAihjaXZ?=
 =?us-ascii?Q?Cde8zfPLub2yhgFuv/sqBcx++Clgp1BsIEdTzzTCbR0DIpvRVBjIcBJ0A1gU?=
 =?us-ascii?Q?zEVKAkn8W6t8DU21P53OpzIsJLBoTeg7wD3kQ9DAy5Oz6mSNqALVbejR/M5j?=
 =?us-ascii?Q?g7ng8n2YjISJ+YAVBMlY/t8izdnR7s9ZpaAcoq/czGovnxCTO0WN2Jat9CS9?=
 =?us-ascii?Q?bXycOXsu9GV/J4iVbkHNLgXvepnXInFvjcVNgV4tivzMTofgTf6Md1ZW04Mc?=
 =?us-ascii?Q?ftwOj7+EfRZER40CquF6gokKDtERkbRQ6Pi94Xnhg1Js9ALJTwTySt1F3pzW?=
 =?us-ascii?Q?4M4gWBiZlXX9EtYOgn/7TzFn1jtGzg+XSOWp9+Yq8H7vtYJVgQnivpDJwdug?=
 =?us-ascii?Q?SvQYB6WvznxKPnv4Hrm5fP+DoO91xaGsBJ0xbp3+frv7saNqCBD8cfZaLCdX?=
 =?us-ascii?Q?VSvb76uXmSarGVb1/gIvgCCx2GjdD59PezgmBZhIc1JIEqYBX54M2XvDSHNH?=
 =?us-ascii?Q?FaOzcvNh5d7MgJlxeRqIuDrGSsKxtvBMjhy4YaXk/2YUclHaJI6pDPkFZlAB?=
 =?us-ascii?Q?d5fAXLgZgzDGNLD+pYrnCInOI4d+9qoelIyF4rYZju1A+gupXl1qrtOqS6F6?=
 =?us-ascii?Q?LcUZ3NVSzkWtwC6yXW7AyPwX5/aQ/9wXeHTXDTmBmZEPx0XMa++rPfjS0Itu?=
 =?us-ascii?Q?ucIwQohZz7B2AWV/SSHW9oMnBcl9M7yeV30gvE+Igevg7BI0j0TGgsOldOWS?=
 =?us-ascii?Q?dGoxMJKma7F3Byp6oYP5Wwz0MKaiLXFjQQt1FJXkPwpcyPqNaUnKpaXcn+wU?=
 =?us-ascii?Q?2Whm9eqlDSOkXOi3DDPJp9pw33OUpkOJzUjsbShm8RHyOOZd08gznPd0mm4E?=
 =?us-ascii?Q?bquHw7WLYW4VM79TGYloxnfOWm+qThMPxVzB6KAH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba79e7d2-0112-4f9a-adac-08db47b3c889
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 06:42:49.1689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u1u8QAX9pkj6ffEFIunvHgi7pynif6Njyme7VVGKyv4QspikhNadMMFp84MOlysE4tsL35Wid7L3gZdlIiiZ/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8126
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Friday, April 28, 2023 1:36 AM
>=20
> @@ -419,11 +419,9 @@ static int vfio_msi_set_vector_signal(struct
> vfio_pci_core_device *vdev,
>  	}
>=20
>  	/*
> -	 * The MSIx vector table resides in device memory which may be
> cleared
> -	 * via backdoor resets. We don't allow direct access to the vector
> -	 * table so even if a userspace driver attempts to save/restore
> around
> -	 * such a reset it would be unsuccessful. To avoid this, restore the
> -	 * cached value of the message prior to enabling.
> +	 * If the vector was previously allocated, refresh the on-device
> +	 * message data before enabling in case it had been cleared or
> +	 * corrupted since writing.
>  	 */
>  	cmd =3D vfio_pci_memory_lock_and_enable(vdev);
>  	if (msix) {

What about keeping backdoor reset as an example, e.g.

"in case it had been cleared or corrupted (e.g. due to backdoor resets) ...=
"

otherwise one may doubt whether it is a more severe problem causing
the corruption inadvertently w/o userspace driver's awareness and then
whether just restoring the data is sufficient to move on.
