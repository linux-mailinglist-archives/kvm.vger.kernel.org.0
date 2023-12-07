Return-Path: <kvm+bounces-3821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE775808231
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 08:55:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7233F1F21A3B
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2295D1B29C;
	Thu,  7 Dec 2023 07:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nT42EeU9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AE0110;
	Wed,  6 Dec 2023 23:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701935720; x=1733471720;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JHXr0kyHX3nkMaGBOMvRA7B/B6Csr66MON3MkLJViXw=;
  b=nT42EeU9IcahF1iohflhOBJ+rGuhr2XveuCl5hlOGaoIr0PItSc7L0EC
   PrynVRSBk83fg54OWxf3LZUPOLfE6ePfV9HiFfFURxpzZyHgwPGJjp0TE
   z/xwOPlrEbdEyRwc1EtCDL+j4vYI12NHgMjeEMIBHAJNXwxFKvOwKi87O
   WNBoMxRsMojmS7/anOtyWzsw5TL+X7drUca+WMCXMI59+Q0M2aFZ8ncyG
   CsKIhv9CBVBC5YYbdIACb44IaDhAz5EteC/CazMDU0VNZvwu2Hayg1bOW
   hn5KwFxnM4A2vsQWkFBalQMmLTcqWSczFuib7mT1HuXMcn+I+HzBGjMMN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="398075673"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="398075673"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 23:55:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="13019623"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2023 23:55:19 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 23:55:19 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Dec 2023 23:55:19 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Dec 2023 23:55:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4v3xCP9YUpIMCfojxiHWs2grZg0+Apro9oSrp7WfaNzIAO/vLEB9LFvTcmP/EAh2WTnZoKl0EFdUuUTNPWOC1rqfuMriQaqFep8X3vRBfSCh5gS/1Ql2QsFNl4AD0ViuMk6MNLzLIcN/lcOAs8l3XUV41WbdiVJfak+k5Ls58ra6aULNEVloiWtd/Nt4HTGW25hNnmm6I8IkTW++a4B4L6CVFjK7eIapiZkOSfsrjQuvwPVshbNh1aNZJ34oVb2zv+J9HKDx02BygZOJL8/hVmUDZDw4k12HszudkDJ3I4UZy3HklxGfdJ2bWz0I3V2G4b+6TQFafyJd33HdHVDBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPBVSudZ3HFlgSCBPEE2ftKIy/pCctenRBWulqduimc=;
 b=QsadEsNOsWCU+8vG1SWY80l1fAspgsimEIpwswvc5tRfzwvuzkbHYvKp0fsydiAjGqAUlXVyLqN5sZx1llEK8TfzjJ8gIGV+FQ0KQzwVZ56KqH2IEsXo37b8NOHpCzW4Dq4cOo/+ZTzP0El7ynytfhYMJxNF2CT8/pM/sE20lU5m1b8EUL0wGGBCbDyElAE4kbboOtUWht+HLohxL5COtjrgLdOGaeP3gIuGEqI804BsOxGLLVZytp6VZrq+jCYYUHYY9D/UIeL+exY7w8rPJjHHCm8Lu4DXRUgnLh6hHwRp+Nu7enzEyJcjETxEsMu83YcC+0kGIe/d1rSk4SP9xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB8261.namprd11.prod.outlook.com (2603:10b6:806:26f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 07:55:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7068.025; Thu, 7 Dec 2023
 07:55:17 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Cao, Yahui" <yahui.cao@intel.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Liu, Lingyu" <lingyu.liu@intel.com>, "Chittim,
 Madhu" <madhu.chittim@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH iwl-next v4 08/12] ice: Save and load RX Queue head
Thread-Topic: [PATCH iwl-next v4 08/12] ice: Save and load RX Queue head
Thread-Index: AQHaHCV/OCOKlQEK7EeTKXfnKkai+7CdigMg
Date: Thu, 7 Dec 2023 07:55:17 +0000
Message-ID: <BN9PR11MB5276DFED75FE8F9372B7A3CE8C8BA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-9-yahui.cao@intel.com>
In-Reply-To: <20231121025111.257597-9-yahui.cao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB8261:EE_
x-ms-office365-filtering-correlation-id: 64ce6a8f-c666-4da4-8f73-08dbf6f9da51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uVTja2kDummJ8nAqgIU7pEDajzm4IszhFcrIabH4vJi57+Njqt4hN3n60q/Qxh+1BGjvXuDKirGHvpvVmtq8y0RZACav3A8oCUtR8MEFDy6PaUOkZQ0qne5rGj105CSkS1Cd1usTeDHpIiqMKkntPBynP/Apr41YBxSMEv6ux1i3CHafWaIJyDNIXHhqdPaejxgFdPI40CdGPajf5P70g1v3S89uTvZZpUz4rHXhE/bJXOpXZ1nWneimNn7UYDLmkTqlgi1pP2hrJru0lAbp05uNYyuL34zv8rsCUDlUN7zcVHlYCrwi+xOd3iNNkWA1XwV8YeF0ncPqXlWPi9D9H236iZuABHok+YLlnwOAFv37SFNv/qifdKd9ncj+V8L/7tvULBxnuajcP9ieqr7DLHNcWfr6j5gczyzNSJNpjpQUaOJFJGYQX7eBho6BgFnOoD5MvmFuP+J08T9FLRQ8zK8u6IZCifQsEKOOSRSZYooxF/EYz5DBOMdkaZn+wFwx1EZO2BxcF/6v/TlNaDVzpKcO61gPZVkvjjNupkTTW9e+wDPxlrHocrZfSnTOXyyanAzKjRr7OkBAsupvIiNntOxD4eIRw1urFUXQDYZVjNY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(136003)(366004)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(7416002)(33656002)(2906002)(64756008)(316002)(110136005)(66556008)(54906003)(66476007)(66446008)(76116006)(66946007)(38070700009)(4326008)(8676002)(86362001)(55016003)(52536014)(8936002)(41300700001)(5660300002)(122000001)(38100700002)(82960400001)(83380400001)(478600001)(26005)(71200400001)(7696005)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qD4UPa7avKciTl2bhhKALy1cye1LlhImwQGtx6E2vptgqHKY+KQuWGRvpROY?=
 =?us-ascii?Q?rn5kUnE9zRMjB+lINV9LYEAs3SQ0tI5G+OBYOBc8xBqE4mrRVUftOWMGNxfw?=
 =?us-ascii?Q?2nTp1hEQabS2ZZtGE0LfK6KmnAoiIaI71lhHKzXl8RTzcMeDK/PBiDbqVgao?=
 =?us-ascii?Q?2KiuIsiy2VmcJIzOWc66Y7ktho/zfAx+VSfAtXObs5QEaUFD2IorF2RZc+dn?=
 =?us-ascii?Q?9mAsjQLxdBQEPsH/5BTkya7n7J3MfXNQIDftlDratvuFnLmDHTEdJV4tNxGy?=
 =?us-ascii?Q?z7NiWIN0yoDjoa7gCysWinOEEy7KeqE5ERzthvddRmVCpgBbv4f95UAoHwtJ?=
 =?us-ascii?Q?jPR/K2wb4VpAwy4PCE8w51rLht7uAtWbtajDEaxeBRP/Yv4Gcw93dW4X0MdA?=
 =?us-ascii?Q?S9rGI/EXEYmVmnTae5Da1Xm56HxJfMcmG3xqHn3+VMq0PaNzfg5YUZSJou5P?=
 =?us-ascii?Q?/9UyDo+quggjDGUwMephycsT9XGdOTZ1s+BZYzcMpccY3bfo7or4iIVWyQHq?=
 =?us-ascii?Q?5Bf4V0qcXqz14PZXgc/z6wVKGyjMj9I/2dNnWINx9pKi22S2zhe78OhMBOPZ?=
 =?us-ascii?Q?w6wVWjoQ3TUicIl9dXNiFUeGWKfY7MLXEmlwJcagdijKudpKCYiVrD8BdBlT?=
 =?us-ascii?Q?BhPDm+ECtfo2wX8LDNO7XB5iiMoFEP00XYmW5CMiv0HhDCbPsbEYoFwsz4Qh?=
 =?us-ascii?Q?XTHw6B21EBKp3kPOPLHPN4pY3wv7YnHRUKmVpIdoWMwloyu4SSaC7QMoB6ar?=
 =?us-ascii?Q?KvU5u9Glm6+Vi+04dsW2wzwIUylcG2XAZJ27AJWSVSiSmu03/4em1362EwKJ?=
 =?us-ascii?Q?IY4iyUjwF54tKoZK2tm+gfOU23paAvByKvv58x2dbtSlNwkug0Sj5ZcF56Ql?=
 =?us-ascii?Q?zmvYooLEB0wYLqsqFkjxO5Yxwn6pRiMrFULh46PGtLZsMVGnIEcFhMrptb3m?=
 =?us-ascii?Q?TUlRAFBbejUp3rXt3pox39MCLjdVIo27AjzfJZl1QKVQ9D63oDts5C/FV5dM?=
 =?us-ascii?Q?Ni8M5YKj2IDYIyEJGowWllQWQzwxYOI/vN5r67zJguQFVaVXNMDZUWb2TJI6?=
 =?us-ascii?Q?e5zvXUJzpvqJpv2whH8Qf6e0CNrW3vnC+VS+EOawzi12/JYru2nK7GzHHp2T?=
 =?us-ascii?Q?Z7hxn/9IucDkM4ucgqiWpYPUVVgnVfCwA1erVl7wIB69daFh+WPwyDS+GjWM?=
 =?us-ascii?Q?F70/PeEh8Vg8g4gEbnBR7VqOtjChXrZNt+GfutAaZrpEXvRoTwkFpMCJ+jfg?=
 =?us-ascii?Q?5SM7GT+FEMEubGrjeKDPVO1NCX3JBaqMz2qsyloUthQbXKHS0DCEOyAsExoW?=
 =?us-ascii?Q?sFc231pHQkyHUHBB8m+W583WVaQSnIID11Ana/LRxzV07ml7w7zfHWkpw9ju?=
 =?us-ascii?Q?sFkK9DmMbt47lzvV6wW8wfebHaOsFw0fM10+co5XTrd5rvK6LjOf+m/1wjKU?=
 =?us-ascii?Q?rFasM39M6xm/64UcsZBNw/JHDGVeQ0nSHA/QNDb9P2DqNACDiOZwj514jiFw?=
 =?us-ascii?Q?KJJsS2H2BK5uKWQdqpFkM7G89n0sAQx2BpaL9zHol8wbKYQ7GF28cVn4v3oQ?=
 =?us-ascii?Q?J6+j8lQqNce8h1srNm2R57QQvtOGlpdazDTv7Luc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ce6a8f-c666-4da4-8f73-08dbf6f9da51
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 07:55:17.2969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s3ZLjWqPl+3qhxLGc/uMNz7YumvmEQZKrBoR5yCy93XD4MZm1O8VtTD9pKh0OOzUNpK8BX5+y60kzqz6JJxENg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8261
X-OriginatorOrg: intel.com

> From: Cao, Yahui <yahui.cao@intel.com>
> Sent: Tuesday, November 21, 2023 10:51 AM
>
> +
> +		/* Once RX Queue is enabled, network traffic may come in at
> any
> +		 * time. As a result, RX Queue head needs to be loaded
> before
> +		 * RX Queue is enabled.
> +		 * For simplicity and integration, overwrite RX head just after
> +		 * RX ring context is configured.
> +		 */
> +		if (msg_slot->opcode =3D=3D VIRTCHNL_OP_CONFIG_VSI_QUEUES)
> {
> +			ret =3D ice_migration_load_rx_head(vf, devstate);
> +			if (ret) {
> +				dev_err(dev, "VF %d failed to load rx head\n",
> +					vf->vf_id);
> +				goto out_clear_replay;
> +			}
> +		}
> +

Don't we have the same problem here as for TX head restore that the
vfio migration protocol doesn't carry a way to tell whether the IOAS
associated with the device has been restored then allowing RX DMA
at this point might cause device error?

@Jason, is it a common gap applying to all devices which include a
receiving path from link? How is it handled in mlx migration
driver?=20

I may overlook an important aspect here but if not I wonder whether
the migration driver should keep DMA disabled (at least for RX) even
when the device moves to RUNNING and then introduce an explicit
enable-DMA state which VMM can request after it restores the
relevant IOAS/HWPT...
with the device.


