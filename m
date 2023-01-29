Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4F667FD8C
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 09:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjA2IMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 03:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjA2IMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 03:12:03 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A8418B1D;
        Sun, 29 Jan 2023 00:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674979922; x=1706515922;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OB0K3dnMMDIfCUzS3arXQJXhSo/lZrEYNeBQPVp5arQ=;
  b=OhHZ9JM9K5X4MXZQJu4HM7cDTIOA9mPJoojaO38qE0jDb0SDYFqTwq4j
   cELBGm42UrbjnjcSNLUmqq+hNC0tZnZbFeuGlXUr+oBoxPu9hsu2xM+zK
   R4eA/h3qYB40CQPkOuryZv1EeR1pPHqAq1kW2eBe1qK+OxDeU2UBZo0qK
   qPt+vStqGJlcZ55d2RkLpmYb2cKcv0WM4WwfdgmBzldIwd77MglexCz27
   LDnXUb4ds2NXty1J/vfea4ESjNS+8paQI6jf1Snyaix34o9RitxhkrZcN
   x6DyC4yVTKAFw0Kf8NzXNXuhrwZA2eporUdVWEkjrop8QHduyfnw3f7VS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="310995576"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="310995576"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2023 00:11:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="694198065"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="694198065"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 29 Jan 2023 00:11:52 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 29 Jan 2023 00:11:51 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 29 Jan 2023 00:11:51 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 29 Jan 2023 00:11:51 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 29 Jan 2023 00:11:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COdmmv4+WFMUvdHpEWKmmbSI7Em9MzmRHEJMc3VRa55LXuehLbzz1gZ/BZRtVNqE3T7ROAbOIwkUH1DE32DnTPOgZkjxTGDvjDjh792f70KJwFHmzjLPV66lF1EaxBaKAs2gzN0TeW+5yO0ENagbmtUQDc3/BI4e9mCkt3j1h/XIKdB44VJpFjg53MVPepfFQyFljy++qxI87nUEKvXnbuJEVfkeFOxAq5MCNhKgKOwn7NWqf0BLfrcDbLYi8htEqKxOgkqyS5ogrC4VYZ/VyPdpA/IUoU5bpRFj6gtg3kTCQhZstCTa2NQJjrp9bbtPqIDjcyBZy8Pj+aysbvuXeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLyQLDur+d/2k9oShru//yHdPdelVvVagoPAfjuf/Hc=;
 b=hbSkkOX4Nd4uHcMnK0ts7le9H6TyxvBUk6+7edntkeGMLCincQarG1HT2TZNqdsXNAKNM8MUYDo1Lxdk3hMgg1P5JH02MXMmW503afsJqjeQPWKvp64dL8OVGFdAALVfBdY7DO/xOjS6aIDy6B4nBHxg2QeJq5JgBG3Au7BahlFRYqR6y7amPoHOywoJEa2/BFbb1KdVEC4ohhomoEd7RV9LCpOTHNe9pNQ7XiR1KOBqkGn0QLx481Flzi0ClsGvQTO5hX/Pj04s08EBo8r7n8/FrVzD2Fw6X2RDWEAO9UuWzMZsd/HKa5CBFy7b/TgbD5hVCux7KUTNDrBOhvUD2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5280.namprd11.prod.outlook.com (2603:10b6:5:38b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Sun, 29 Jan
 2023 08:11:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 08:11:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
CC:     Nicolin Chen <nicolinc@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "agross@kernel.org" <agross@kernel.org>,
        "andersson@kernel.org" <andersson@kernel.org>,
        "konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/4] iommu: Add a broken_unmanaged_domain flag in
 iommu_ops
Thread-Topic: [PATCH 1/4] iommu: Add a broken_unmanaged_domain flag in
 iommu_ops
Thread-Index: AQHZMoqzsVwORV4fDkqb25GPYvi+2K6yz/kAgAAgNYCAAhsCEA==
Date:   Sun, 29 Jan 2023 08:11:48 +0000
Message-ID: <BN9PR11MB5276C9BDCCA7FB295C25BC738CD29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1674849118.git.nicolinc@nvidia.com>
 <0875479d24a53670e17db8a11945664a6bb4a25b.1674849118.git.nicolinc@nvidia.com>
 <dfad6d75-6f4d-99ef-1c6a-4bf397dcaa13@arm.com> <Y9RkG2dejdXptUTB@nvidia.com>
In-Reply-To: <Y9RkG2dejdXptUTB@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB5280:EE_
x-ms-office365-filtering-correlation-id: 7b34692e-28e1-4195-c9fa-08db01d07861
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eEFdMtYdQSITrTnoWYv0TaArLcHhDhQ0/nlwP+8H6qaIqITuSg3rt8TLKQpwGk7hsDCLTXTghn4YGUt9m7aTdPEs1wnw6V/8dhaiP7bHvODTTCxaPzJbAQBFN8WLSim6KSZPHtW4KKA1gqtAUmSey1TT0qQ+YdKcOcf9qGKEQbM4lBe03c3MfaMUN3yFN/BPJj1v9utKC1M+FJAMOjUg3nAvdiWqutjDmUmbRDYOBajijI+PqXauzGiBqgj8smyV2LjgiFIyrVoY52fSP4kHt9qYqK3MaJ9KyCHc3gaWYAtVZx+VQ+qnHmM/bNjzVuIyWFTAZqVMxYL/KcR5nQ7qW/QWiDs6b+tRCt+O8R9YAZoDWB6RAP2KSiI+BPTjEvCCyFpLD3XW+jfCUg1pf7ea8dvLVogrp8FlIvS9xUOypAPR/BJnlh/sWy1jP/aKnTdKrvNml1TczCc9DvGovME/ZlzJEk1/JSVu2vdM6VYYAOoGMpfdeGlrrZd0l202eA9VtD3W8MmjJms8TMoQ2NJ642UoROwujbnWkEX8039KZootUCL6XnRRJDTYlto5+CChJMdGQy1lJH9fhwODJw1V1VYj8q0dacAlmZZMxjagzE8oc/SXtRHnadajNEObG3U9Wpp3li8ziLbKGX18+jzhFJnTjRaPFvvHt2619p57924/hL6rMXRu8JHEdfnvJ/76qcTcdPZANEGZlKiptfloHV2OvCZqnVI5Ng6kjUF/Q5M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39850400004)(376002)(366004)(136003)(346002)(396003)(451199018)(6506007)(478600001)(9686003)(26005)(186003)(7696005)(966005)(66446008)(76116006)(4326008)(64756008)(66476007)(66556008)(82960400001)(66946007)(71200400001)(83380400001)(41300700001)(8936002)(8676002)(86362001)(52536014)(38100700002)(122000001)(55016003)(2906002)(33656002)(316002)(5660300002)(110136005)(54906003)(38070700005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JQu0wno+5+ML6Nh5b9YbiBOMxfyaA5/Ev7zR6eA5LH0sMFqVJOy3iobIPmqi?=
 =?us-ascii?Q?Fw6Gaq7HjacOwbSi5chtM91LeT+NecugLZ1YGQ0s5GsCva3OUVyHYSAQds0b?=
 =?us-ascii?Q?4AWn4ioENX7ewxNkSTtZ4Hczr4NFx9wB6SL5AhRMGHI3hX3kiR3jTxHTEMU+?=
 =?us-ascii?Q?FMybjtPcA084M5zlv2pDzTtsdaBL+Y01f8xa3dmHxaUQGXc6ej7nHH+5gACG?=
 =?us-ascii?Q?TGYsOprYF4Q1ASkXVYxBCnXd88KX8fxmLFWhGQ4tVbtlVjxqBtFUCzmZ0y84?=
 =?us-ascii?Q?HJuaPzeHNFZpQcltvjBrv57Xgy7ugn/794fA7UGJ7YDZKAPPJLDlBtjfqTbh?=
 =?us-ascii?Q?/pQdn6yDRnbtQGjHXzv/G4ersbA57rMtRP5HvygQpFeHohRBSLRzNGO6y1+A?=
 =?us-ascii?Q?/9RmpmPlU6WAShYK5ibMLBIivcWYJUrhhWuWnynlOUfez3Q/c3Wx/d4+gWf3?=
 =?us-ascii?Q?Ttr87LHAUo3sQNz1jjCFF+bEeIyu68xFRh1LzIQiE/0mBk6yN2Bzo/Ni5LnX?=
 =?us-ascii?Q?N/WNPM35UZrnzCxG4go9VK4oYTOfDCJArNBAtCR7lc/FG2ggdKrMVJV3UyVR?=
 =?us-ascii?Q?ATbJyngMNaOILRZ8dhFfyn8XEKDomGKw9NatH2T475vtB5j3COkq6jqxWmxS?=
 =?us-ascii?Q?3v5PGPd04m9j0w+zMUnV20Q5jMdoKq8nOKquyjjPo8fEoWiyBMPuKUkYta78?=
 =?us-ascii?Q?9ii/DfCKfTxwaZkelK53pCBAVZghlpDa6d0cGnaWDOEVA/V+H8wYxV0MrmP4?=
 =?us-ascii?Q?BxcJad0RKJSmoBTuLuWlppXVfdArZNxJyL9tozHJodiSdpPmwRqV6WdyC9Pm?=
 =?us-ascii?Q?+mN9SLT1FwhmGXMpg2OWQJSMuE8dIMMQQ+0bgDqNWnu40YD6Xr9IhucMPg+Z?=
 =?us-ascii?Q?bcLKoOsQ6zNgSC+jnqUkd6rlbg2dAld3TcGS58WdO3S7eCbxWiegI0K6dJDo?=
 =?us-ascii?Q?vHkZZbx6ZnUYsLa70KLDstOe/qlrttTGrd6Su4gmbCsOQbDG1RHJ1Bu24Vjf?=
 =?us-ascii?Q?xug2SMttKWri4TKys3fb4DyNeMFl0+0CbathI+hNWc5wAQ8tY4JDeF87EPig?=
 =?us-ascii?Q?DPwlKuDoNEv92LWG+nCmGiNfbpMwgyJHPBUpytzUt3YrrpgOXS0TxWhy5zy9?=
 =?us-ascii?Q?sydMByg3gAspCGOFTrpsvaoBV8cR9OA/6MIMwsAcwjVTwyalb5T3qBZU+fDa?=
 =?us-ascii?Q?oJGoxUsqzy1I3/HCLoUXhUwoW7ngL0hfNGQGLw1QEyaIBt8QSHJbfRYiLz8G?=
 =?us-ascii?Q?dL5oIT2wc+sstnQdSD/iamU5VUYJSQMe5kCACpyBQTTGEdGtmmAGV7xQQiz0?=
 =?us-ascii?Q?q6IRcCb6zQrE8cFYubmwraN9Zm++fqlOFZZNoeUeciuwdcInt/gtSkH01HEK?=
 =?us-ascii?Q?VBE+ognL1P0ESYGiFPO4kYsT7pCXPvduweY2UosEQx3IoaOAeLKiUunyMnRB?=
 =?us-ascii?Q?Pl6MHHtfnj1/cgOZmoE6LmANa3V3DBeTYy1g2blLjhmrE3O94C/2JR2N4Qaz?=
 =?us-ascii?Q?YHDAR3p2kn0oUqtt7uItn2Ani5CL+ryjkrK6uCXxveiT49V4pdBXpFQnN4aB?=
 =?us-ascii?Q?RF9GZaMXx/FiAJWbAt70vMKrmiokXUzPPwSwTFIT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b34692e-28e1-4195-c9fa-08db01d07861
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 08:11:48.6932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PBMcSZIpkqHY5fdtW2R4ipWWRKtwr2At3wczOS97f2AtXHVw3uPYJyv66WmavN3E9qZW7fUgCUtSTiCCZ1n8rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5280
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, January 28, 2023 7:54 AM
>=20
> On Fri, Jan 27, 2023 at 09:58:46PM +0000, Robin Murphy wrote:
>=20
> > Please just add IOMMU_CAP_IOMMUFD to represent whatever the
> nebulous
> > requirements of IOMMUFD actually are (frankly it's no less informative
> than
> > calling domains "broken"), handle that in the drivers you care about
> > and
>=20
> I don't want to tie this to iommufd, that isn't the point.
>=20
> We clearly have drivers that don't implement the iommu kernel API
> properly, because their only use is between the iommu driver and some
> other same-SOC driver.
>=20
> As a user of the iommu API iommufd and VFIO want to avoid these
> drivers.
>=20
> We have that acknowledgment already via the IOMMU_DOMAIN_DMA stuff
> protecting the dma_iommu.c from those same drivers.
>=20
> So, how about this below instead. Imagine it is followed by something alo=
ng
> the lines of my other sketch:
>=20
> https://lore.kernel.org/linux-iommu/Y4%2FLsZKmR3iWFphU@nvidia.com/
>=20
> And we completely delete IOMMU_DOMAIN_DMA/_FQ and get dma-
> iommu.c
> mostly out of driver code.
>=20
> iommufd/vfio would refuse to work with drivers that don't indicate
> they support dma_iommu.c, that is good enough.

this is a good idea. Just one doubt. Robin mentioned that sprd-iommu
might have a broken unmanaged domains:

" I'd also question sprd-iommu, which hardly has a generally-useful
domain size, and has only just recently gained the ability to unmap
anything successfully."

Want to understand why that restriction is not a problem for DMA API.

what Jason proposed here assumes that existing driver support for
DMA API can be safely applied to vfio/iommufd. But above looks
warning certain exception?

> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 59df7e42fd533c..bb34d3f641f17b 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4165,8 +4165,6 @@ static struct iommu_domain
> *intel_iommu_domain_alloc(unsigned type)
>  	switch (type) {
>  	case IOMMU_DOMAIN_BLOCKED:
>  		return &blocking_domain;
> -	case IOMMU_DOMAIN_DMA:
> -	case IOMMU_DOMAIN_DMA_FQ:
>  	case IOMMU_DOMAIN_UNMANAGED:
>  		dmar_domain =3D alloc_domain(type);
>  		if (!dmar_domain) {
> @@ -4761,6 +4759,7 @@ static void intel_iommu_remove_dev_pasid(struct
> device *dev, ioasid_t pasid)
>  }
>=20
>  const struct iommu_ops intel_iommu_ops =3D {
> +	.use_dma_iommu		=3D true,

missed:
+	.allow_dma_fq			=3D true,
