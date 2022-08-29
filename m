Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF815A4060
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 02:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiH2Afe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 20:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiH2Afc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 20:35:32 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB2213F11
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 17:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661733331; x=1693269331;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=s+geTB283YtOZzVmXk/IskMTAfZxF1Ja6GqDYIUDm/w=;
  b=BoiFVELL9/oaqTZPFAqCZJqzzaVp7uUVyakSevurcN9Spx+HPSe4d234
   NvDMLzIogOII9jTmzmKsonYsGKkD2LPwI/owM1KZmJGxsrEdP2uOWLJTJ
   a+X37zhn0hCN70MIosYWhCZgsiWwg/QlmxYLCirpKKha38CHzxIuOCymj
   X4cty6nYIhGtXjnXC7zAtPKa875FBZ1QZmM+0QAvKCPTVTfqH7BKKaJCK
   W4/z25wmmsSV6t2AADxAw0rIpEFx3AGiHGQRG+8EkKU3BSlKFUUNpuzOJ
   Zm75giIszn5/Iu+Lu08NScXbItdpZU0Q3gYfwg1V0Qn+fLPyqwzZO/vRb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="295558526"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="295558526"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 17:35:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="672179383"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 28 Aug 2022 17:35:30 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:35:30 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:35:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 17:35:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 17:35:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+IdABt4KzCybVzL4DxE9v8OOrEhr7vDDhCWyv/3fa6MfSAnZlCRgJirAlFIfiXnnj9UOHAmCK15W4AYEnVuLMMpJ+rwM2LGExFagLbkieGxmyTIyXjhz3vMsm8Tnz+ImDmXEb5WKjoc0W+z2KaLsbDJQbw5gXFzJWazclJReNWuRkUMfHUp+gYGzHowz30CI2LVhfD2d1y1wY5QQcmIvLKdoilCtHDWOtOUP5VaWT+aqHcm4CDf7xHTjbJWd7dD9saII1i1mjx/vFA7gftAo0ABSvu3HKBO70N8tXuTOQF/+kJ68fyS4wTdcIBMhBFKLoUELj5g+QoYCEhBUQyZLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+geTB283YtOZzVmXk/IskMTAfZxF1Ja6GqDYIUDm/w=;
 b=aX/bJ4iJsdHH6gCK6H+RLwAqrEQ3A6wL+XpT8e/5ZAu8rSA/2DH70jjrivslMtfAzmoH97N8J/k3by3DBkC6sjGoQTe6ZhVj8NmJOxf8eZ3Ud26rmUxDaZkflMcNe/YtZxthxBAV/+93qCCC9A70Glppr2LW7rVEd5Pb8w0UC0XGKS8yISe34/XwbSiCIm8sSHIsNF9L+DXDrVv59ZOoZuzF3/o15Zyj4kCjiC8usySdlGUIklPz4RqToz9bIvVFd3P9JeleFg7iduoLaslcsphvA2NA3ypNEWhl6+qA7YLuiPCkOrPTfTImajGHfm0cyhXwKjrwlLRL/1L7qOOd8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB0053.namprd11.prod.outlook.com (2603:10b6:910:77::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 00:35:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 00:35:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: RE: [PATCH 4/8] vfio-pci: Replace 'void __user *' with proper types
 in the ioctl functions
Thread-Topic: [PATCH 4/8] vfio-pci: Replace 'void __user *' with proper types
 in the ioctl functions
Thread-Index: AQHYslOeOAAkLUZUFEmOZAUT5d3I863FGTyQ
Date:   Mon, 29 Aug 2022 00:35:21 +0000
Message-ID: <BN9PR11MB52763CB2081A17466DEA61E48C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <4-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <4-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04375cd5-a258-44fc-aba9-08da89565b6d
x-ms-traffictypediagnostic: CY4PR11MB0053:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pSsPgnX1qXxGIAshn/LgTewIgMqwqm06y+S7JJu4GLO42+YRcTg8hypGfMglNhK3yvWR0VH1CxT0fWLBf9LBFvGtGQvciByO3vTgeVWl6UB6wI/5HGAE0rJ/A0+JHAIq31iHZ2Vx2VpzhLvjK3Z7kf+hjZi2l31ezwLw+LDCFsOCx6rbKDoVPeCu2HYk5RFA927+NgrokUKvM4x0UWEkMrKHzKZRmlMta/2vEHY7YYAHe9Exe8fLcH60VfZhuK6oc1o53OCTUuXHA6Hwk1RAhedZlrQ4OpcVQRAFcMxZvm2rOTg+VBKMc5VyOav4D+qD0Z6DiafAR0ekV6Q0VfF5YAO70kEHt6MdeU1d3CuD5gODCbTnJrW6DJTYd4WiY4cDwtqGaigWZsYfs+ZHl7EyPSCpscvSy6HQ4ZuX+nlGfUuIkcvvdBvoXAnMDLMyEWZWmc5YBgMhBmF9nlArUcYHt82iNVi9dkHPg97t3N8u6Fvg9pfPXzgkin5arldbxv+uMva1LIU/mxtWbpV93YpvY5wfaMTDj9rQuJ2L9JkWmJZZQAqo6J5ImFsdVv+gdZTkWYn9o2/dmWWCZO5z2IQATxPkP7gTNdhiOV7SqsLzxd5Jz6YovXgtnTE28J0gQ3w0IYXd2Bel8VJzHTJhNlOv8WHgR7lm0wzqkHufu2Ka2lJtbGqCKuGFSeiki9bMOyNU5pvc8VKOKbJhMhnIjVxdeCTWMGscGGIdN+i/+r03ci0cV3hCfUPY7o9JB/0HV55S+TOM5Q26L/lxZjqW+dK6Og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(396003)(39860400002)(346002)(41300700001)(8936002)(5660300002)(122000001)(52536014)(110136005)(66446008)(316002)(38100700002)(478600001)(71200400001)(64756008)(66946007)(66476007)(66556008)(8676002)(76116006)(6506007)(186003)(33656002)(7696005)(9686003)(26005)(83380400001)(2906002)(38070700005)(55016003)(82960400001)(558084003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Isze1nUW8bdxTxpwGu2IDgp4mhV9pPeRYHw3M0+eQ7kGLX+8hAnm5+/NLzJj?=
 =?us-ascii?Q?hqNXOzpV2Jy7NHfLE5Ji5BVgTjHPv2zt7wyFb5CUCvzv//u6IOOHOKP5BU2d?=
 =?us-ascii?Q?Zc8Z+aHAoN9AkjcBnSc03nZL8xKBH2MJo06KpKixHMgBxIhAyvmYN8VYILFs?=
 =?us-ascii?Q?01ruzD5UDGXdUvWP1Tm4QOb5WZK2MzZzKO+m5qTSj80+67+1WyvLWb6xRR8o?=
 =?us-ascii?Q?3Y8+dnRIhG8kZ2KjNQvYoUQ2aVtuNruo7PcfyxdBFLEn5Azmg2jBiTdof7ya?=
 =?us-ascii?Q?0j98+GN0iy/FV8uLZx7WTsLdOjr+aGutxXRD94eMD14ZrDvREQ6qg9H6/Nwd?=
 =?us-ascii?Q?D5eFcml7JHM645OWcoKXvuvgehrVNsyh6++Ti1NWGPVnqa07bDINNYsy5q2q?=
 =?us-ascii?Q?V3uo1T+O0G94L+hklfR8POZPesVesZAemfZzPTJ8VV3/TBP3uM36DnMyNCY5?=
 =?us-ascii?Q?JXfqx/N0SU59GsfLGgM/rNy8CZMp/Bbr2lGs8ERBXogMl5mf//clEoUgrYjm?=
 =?us-ascii?Q?CebIzARa7QSjCHPjkosLiYxrYaX8tY7Nme7Hhq7XmCmyLkD2jy4e6ckO91rE?=
 =?us-ascii?Q?ggxBghkjQiheEhd1uAN81jdDwNEUMW2CXsHeqhLixTdHEJOJtNnXhs0i7RjQ?=
 =?us-ascii?Q?3iYpsblugeatXGIy+hlrNauqoa5ryCB5E1KHPqqnLACHCO8q9E5dWAwVxSj7?=
 =?us-ascii?Q?ORLYCE0thXppY/XnvwFcl+wRP3Ll5uCihZ4VagwM9CrAkfiDKfrTs0eUfC/7?=
 =?us-ascii?Q?QlU2gPxlz7TaGq8SYkjUpD8czI2p+GWQdRqGUUtlvcHlzjH2lR8ubhYpOvCi?=
 =?us-ascii?Q?ZTkpQTGsjPCwV3kXtgChsy38RN32h6OdTnzudub7JkZyYPJ3o0vAeN+lqoWK?=
 =?us-ascii?Q?XrekT47Ye0lDw1Ul1yCipmuB5pjz8z6+Dsyd7VOaTsSWAWcvE5rlLYCHY+3i?=
 =?us-ascii?Q?Rf7B+Y4qoK23qj1dFT/34enCiTDFdDcRQzfUC40zgi/nw9GF6u8H9Qn3ONB1?=
 =?us-ascii?Q?d/VPAZ8iMI3csWd5v/7ETJgWuh4EtGYxmGxug0KY9JfR9zv/zaNOSxzIPN3z?=
 =?us-ascii?Q?FhzaXPAFlsm1SMRaIo9DJw0iOXRrncGTNJqLw1/pg3w/lNKDsp+eBmesMUV7?=
 =?us-ascii?Q?O6CmgWD28P31fiAnkSi9uW7cFCb0DD6vGqGwqN3xrYhBVNmCaCd4QhIpHFx6?=
 =?us-ascii?Q?iB5rIg58dbu/UlAtTQ812WQPMh9v3MU0z+HEWIO2bt3t5DV0U+lnecMjO1iA?=
 =?us-ascii?Q?mryGSr85EkZnNO7DzIbCEJXIW0p3o5ALZgrOzQsvHgMuCXuIXVbH+C7GK0VO?=
 =?us-ascii?Q?jgQCFzDwI3tP9GVWsEQ4gjFgApgojWz+eES0RX9KmWyRHMpPq+GHeX9SEFPa?=
 =?us-ascii?Q?vZCIj4f10AW3LanZCTO5bwss77UGC1D31jtcni20kHujdORah9NpAycbktgx?=
 =?us-ascii?Q?lQnWtkUcmptZjc5eR23kD/lOlgtwT1hV33kDJjk2IZ24d6r1HCoK3PR0pysl?=
 =?us-ascii?Q?1W2rQG3nRZgU35I5XDOMJ+Goc3nJKTVqOa6WVhsiB0jDpXAh+wNPHFTPb7+C?=
 =?us-ascii?Q?ZU50fzW4WfNPbMG/mkQCobe2r+7kB9lDvRUd73JP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04375cd5-a258-44fc-aba9-08da89565b6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 00:35:21.9828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SR1PTaIBeL2tewplZQSnEMFtaJfMozL6Wj9TSs5+cx3RztNX9Rj9AcZzgGWB0JcvMreJ9dnsgmX5vnMenbbvpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0053
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, August 18, 2022 12:07 AM
>=20
> This makes the code clearer and replaces a few places trying to access a
> flex array with an actual flex array.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
