Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE3775C256
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 11:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjGUJBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 05:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjGUJBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 05:01:36 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E5A2D4B;
        Fri, 21 Jul 2023 02:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689930095; x=1721466095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pREx1/fBS/r0vl5pRhqETy0r5/HsSvBcZo7/BuIMQ/w=;
  b=UtTRDWvOTi9xl/l3YaJFDekKLzUsKbBpa+OCnNAGw4U8/+wS6bbidk5u
   GaW40fsFZcJmQOuu3vnm9Dz85xjoV7YBmoUF64vxuPIkD2GaKpGyjVXRG
   2ypo3mnulJhcqSFvgQNzWl4n+ItDAqank+4OTqo/Pnrx8wRKHKBzzXhvy
   JsaCQNAcmB5l+ELMNEAPyQM2HamuKEF+JuzeMCQbUDceux2kmJJKg/wfX
   08RjmCBJn0oeGbctfNMaWpVR2okZzYpniGyjYF+91Jryobx3pnXr4nu6a
   GHkq6xDA7VNbpUyrSybEU31J/E7pDh77pGsmF/3hdxRETvxBTKu5HivS2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="364439928"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="364439928"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2023 02:01:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="759882157"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="759882157"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 21 Jul 2023 02:01:34 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 21 Jul 2023 02:01:33 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 21 Jul 2023 02:01:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 21 Jul 2023 02:01:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 21 Jul 2023 02:01:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmncEhq9qcnlkdyrEitf7DVevKB3TaKC+vQ3x8MXuvOxj/CZ9lLXC7YrcQkwzVKe3KGnZd7mYgnPUrUAMDlz5veYc8xlxY/r8v8GsgRl8WUqXB1Bc3dPeU6aDFSSMCFaVooPW5xuJk6mX3eiKis+61oKpNolju0GsDJj3cC5wqpn9FtYIdYaEPwogHCt14FCBy7Y/xhIyEy7rScYIgwEKN0hDz2S6xrOr37IoQbWW/Vcp3g1qEEhNSl45oboedZoCm1jNg9a516GlRwfSNEDGvrxYjKz8JoopTtQH9PCB5IrKXtfP6UtYKxw9Go+WiS+wTUZfPWy3AhBGGZcMe72ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkL/wOJG70kpgOY9/qYctPQSq4X1ExzYRgEcDrmKinQ=;
 b=K4wtBGboa9/HVNwQX0VK2xWWILU+HPvsmWFini/kJuJIOL1tYnCk7kYsvl6bywJHMU5PNxh+PktkCL5QYDY9UHnIRBwgDGe7vNJ/aWZVE0K/qMIGWCpsMaPoAcpJDiZ71WHLWTd9+mukoqroJWYItqFT3LS8SY0hdMPtcxPhpkcx0d40rO2kcK+h2Yc2Jv1t8bKH7jL1P9QcfIj1OZV0jH7aK4IXI3u7fseblKtVxhxG8UO/Ib0s7iBzIADpBxgiA95ZodJrr0NDZ/08iBMBmVEJ6QnqYrTCaOxIBgXONg1IWfP1XVhAHPNsZmpF0XN074tEtwD2u7MwRedDKw6z3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Fri, 21 Jul
 2023 09:01:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159%4]) with mapi id 15.20.6609.026; Fri, 21 Jul 2023
 09:01:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v12 vfio 3/7] vfio/pds: register with the pds_core PF
Thread-Topic: [PATCH v12 vfio 3/7] vfio/pds: register with the pds_core PF
Thread-Index: AQHZupFmZY6E6FxIHE6HGVktZmL1O6/D7H6w
Date:   Fri, 21 Jul 2023 09:01:31 +0000
Message-ID: <BN9PR11MB527656A2E28090DDA4ED07728C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-4-brett.creeley@amd.com>
In-Reply-To: <20230719223527.12795-4-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5214:EE_
x-ms-office365-filtering-correlation-id: e4058357-f462-4ae3-8452-08db89c913c3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VuqJd75ugqHnJYYrQFaMENEe2IIlAICnFK0IIPs4Gm1x8O3qMlFJTzuNQtMuEshp5ollX2yY4FDI8P1KJJgRXJfwMq32pdNpOJ6GEPhgWW9ETMko7nmzTyzenA88d61P8XfUvOgupfxPlAWFeCRMTMUPJfX5k2yHAHkeAMRP+W0VZ0APKM+EwpBt0rUPgJdZqKESAJ9CR0XikBK2zEec+XW5cHq2Z9f2hRfiKzIr6yeUdEsl3IHXJBBd7oIPw8UEJg5vWviLtUAvL99oom6+VY0IVcHHIkpbYLSp6sVGpfodPlXPjhZf9DAUvvM7XtUgoODxahNoWnX5yucqwt51BgSa0HR4FWBXIrsRt7TR0M+r2lYoUKMQhaFKKA3SgXrykix0sK8MGswf9wiV//y0uLRJ19Mt2LGfMEcXK5x1rc/sXDuzeGGFBdOd8QkynqaiReoRa7BV8WsGToU/izcuzL/SidGfCnIZVrQP30ya0ltqSodb1ZHeAslch/S/0PelgiqDyhhJc+/0Y0gIgUAwF2rnZeuc5k3SOXlnd1kFCgcdEphRl3cwe1kOyMBjQolOpvr4uusRSf0goq3TX1ueqGyFxLh1I/d9zeDOUv+ch7pymUgqC+lw8DXhjJ7vRJrb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199021)(86362001)(33656002)(38070700005)(2906002)(55016003)(186003)(6506007)(26005)(38100700002)(9686003)(7696005)(82960400001)(122000001)(110136005)(71200400001)(76116006)(66476007)(66946007)(8936002)(8676002)(4326008)(478600001)(66556008)(316002)(41300700001)(64756008)(5660300002)(66446008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V+6kqvBiwQEyFyF1WD1YsZP44Alm+g1F0+xue7pqgsUzqw0mUL+PUVr0m1rI?=
 =?us-ascii?Q?csWKwkei8QwAwfXzD1CbNfOoZXsfRy2hUfMts+A+rzTie48ITSa34nfGPcAe?=
 =?us-ascii?Q?pTqPFmGiDUmOptz/puH23aL9R6cbDCrkyBHB5rvD9BlqWrC0X4qNpTRvptGC?=
 =?us-ascii?Q?eUTVEezVENGEQvPhN84jMsVC43CK21jLEjo1/wswVhS5sWKj8Awzv8sy6q6Y?=
 =?us-ascii?Q?YD7arU/A9E+L5uL8l90OyO1G1w3IytD+ZoWJwUnLU1addDlFz7cXc9XIvCvn?=
 =?us-ascii?Q?CnTprOvw4t+jJF/ibal/VC8PlEDMdRmCRzm8Qs2llAoibLY4mlFw54sR4yWU?=
 =?us-ascii?Q?b9YJPCl1phFSapu+QhSA2u5RW2pYozbo9DwSCUEmPx5HZi2aPsrcZPc2ZK06?=
 =?us-ascii?Q?qsSQDaYsMWmLQOpQ41Zd7IF2famtqckV+CTpUGIg/mqSik1H20XZkfyV/uSW?=
 =?us-ascii?Q?bANhrlLuesU0LmFr67hGR0NWZCACgBbVOm2RxELbnaKN8ivIH99O/5c9355s?=
 =?us-ascii?Q?GPUedzfxwyjasqgL6/8paR4fGYbWs7zrMgau6lEFqPZzMPSXe33iqneQnsAH?=
 =?us-ascii?Q?ZMUlZYnZL4aI9wHa80iPmuvnA3pqoxDREnOuSuHOwsuDmbs2qSeiSSBuvBVx?=
 =?us-ascii?Q?0cftynidUk98gZHH72ho4J5oWVR5CmbSEb+B2rDdM9daOFXpIgtvraK6J7ha?=
 =?us-ascii?Q?qriYzMSOEyIHmXK0VXfk3wz6lIQf7sZ4MGERqsM0nuszOwJvpOdu0L53UtLL?=
 =?us-ascii?Q?EL6I+fcSwDEiXGeem4MQa84lA8oR2/5ec+EI7Tr6X36Xpr9o7xmV0uIudLzP?=
 =?us-ascii?Q?iJcAtewHLRYtF0qR+hhWbfTmMWtBB/WJpiOT7OvxLAs51Ciq3sYCTOoxBcHK?=
 =?us-ascii?Q?cjmZZEjxFbx1SqzB8bAp/XVtsFD1SjnnoClsa9HrQQEHUlSFDg3BXpglm2XJ?=
 =?us-ascii?Q?Sly/M4nCq7EpiGnns0MGa/pbAC4/EWF/jOjOVjUCjuizGyfdKzk7Q2y5BBfj?=
 =?us-ascii?Q?2fUIxZ8W4K9NCMFxS8Va/Cpti5ioe5S5d6erVK6eWeu5TQkQZzcil/oA4Jm6?=
 =?us-ascii?Q?t2WyvXrW4iPxw4aI0HjG1ja7FwGG2a0GqlvNA9tRQVku5kQ8nJxS+VCFAlvB?=
 =?us-ascii?Q?/lI1rdBjt026D6DtHn5+q2QJoxFDLtCL8HHgcMHZK9pNp5afQFw6KPLNNVJX?=
 =?us-ascii?Q?EF8P1wKjiZ5zUSwz20QTcIShx+OOFLCR06rdXuaOD/pVMyo2vscliPoZ1Yk9?=
 =?us-ascii?Q?kQC8LeTQkhlVLIojeUc/4du0334BuMna5nwPJqU9f7tejBAx3Mtkir3JbXNe?=
 =?us-ascii?Q?yVT0QMOruouidIBCwf+/7GXV0CCIioiS1Sk4xYaFV3baGUa6cxLTu3LpS7rc?=
 =?us-ascii?Q?QnPix54BoVjFIODDMsvDhMKbGlsV9uJfxvst0qQigv3TTDKH8HQYLeFne1Ci?=
 =?us-ascii?Q?r0sbr7E7X1EuEeOzpAwTs5Hpc+VfDBsLzHox5Tlch/vuRmc07nbv1Fsmgn4B?=
 =?us-ascii?Q?cGp580gALpELSq85xWeRSB6F26L7Hk1S+wy7UBZeWk62ohwqGizluqbR9jK1?=
 =?us-ascii?Q?dLhxm9YZQnt0irKDtHG3nO7TeSLrhvdhDhMNPx5g?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4058357-f462-4ae3-8452-08db89c913c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2023 09:01:31.6049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hBbZ38WxeGb3eR+7rc5s2mB2FISHOJjNoGr32Oory/1DtqAP7QksevxwIlXNRtsoxXta55SdwKeFz20lH852Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5214
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Thursday, July 20, 2023 6:35 AM
>=20
> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio=
)
> +{
> +	struct pci_dev *pdev =3D pds_vfio_to_pci_dev(pds_vfio);
> +	int err;
> +
> +	err =3D pds_client_unregister(pci_physfn(pdev), pds_vfio->client_id);
> +	if (err)
> +		dev_err(&pdev->dev, "unregister from DSC failed: %pe\n",
> +			ERR_PTR(err));

Why using ERR_PTR() here? it looks a common pattern used cross
this series.

> @@ -34,12 +34,13 @@ enum pds_core_vif_types {
>=20
>  #define PDS_DEV_TYPE_CORE_STR	"Core"
>  #define PDS_DEV_TYPE_VDPA_STR	"vDPA"
> -#define PDS_DEV_TYPE_VFIO_STR	"VFio"
> +#define PDS_DEV_TYPE_VFIO_STR	"vfio"
>  #define PDS_DEV_TYPE_ETH_STR	"Eth"
>  #define PDS_DEV_TYPE_RDMA_STR	"RDMA"
>  #define PDS_DEV_TYPE_LM_STR	"LM"
>=20
>  #define PDS_VDPA_DEV_NAME	 "."
> PDS_DEV_TYPE_VDPA_STR
> +#define PDS_LM_DEV_NAME		PDS_CORE_DRV_NAME "."
> PDS_DEV_TYPE_LM_STR "." PDS_DEV_TYPE_VFIO_STR
>=20

then should the name be changed to PDS_VFIO_LM_DEV_NAME?

Or is mentioning *LM* important? what would be the problem to just
use "pds_core.vfio"?
