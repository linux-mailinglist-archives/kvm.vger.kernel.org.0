Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F8278814E
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 09:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241338AbjHYHyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 03:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243293AbjHYHxq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 03:53:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5712FCF1;
        Fri, 25 Aug 2023 00:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692950024; x=1724486024;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qWL6bQpYtkr7Hn3bvHmKtLvFwFzfbQewojMkGrh4Z40=;
  b=cDUp7Go26D/h+qJfgGZBhJ+z2MLanFQ5kYjK3Kk2jR1dM7WkTLc6OhTy
   Yp+97F80nZGOPkUDRPDPGsdGWo2cwfqNiNzcgbdY941Sn8UI5Yrk6DlXU
   6TJz17qlaUN9zWakmW4uc1iU9vwsSCWnhYOUhGErZZju9TM0hGgsNpZMj
   VqfSzsctfvc9Lz5Pn1dfE1Wc1yokpxFsgvIAX9j0U11VyZpBATfMn8afc
   LJ0+Sp6fU2K4X3yLCRP2Fb2bJpgPAwumlPG2vWZPs+RGEavHvtSnuM+dS
   0z744bbvi9HerWr+3ID/Nawame6txaavkBN6KLB0qchlL1EacozedVlUO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="354186359"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="354186359"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 00:53:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="984015049"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="984015049"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 25 Aug 2023 00:53:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 00:53:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 00:53:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 25 Aug 2023 00:53:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 25 Aug 2023 00:53:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nN6z/kh1Jf3F4vyt+jgFgtPE5pYp5Lf0tpl216+jy5Qbl1u6gBv3eZZNatOz1bffEa7sa8vAVDk482Nvy+4WGxVIpVuPlY2FMb8bMOIlvwQoGa8IT64tpo3iuax0IJvgJHRY6DPBGsOoPygexlMSByigXb1sdRmGGyTHxKAmW4e3QsKsApkVA9kZUeT7jrrAXF928CcS+5Ckz+2Hi60lGJ384QUClkybu0oZ7slRQ5ilW4KDoZvhIaZdVtGAJx89StSKSPKXZLfcUHDYZvp6iXdRrRaQ9I2LwpvottlY/IPo1tmU2H0K1y8IR/z2rPBWI+i+ZlD+WvAWYAZyy5+y8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWL6bQpYtkr7Hn3bvHmKtLvFwFzfbQewojMkGrh4Z40=;
 b=exYd02xharzI+P58zyL4feMIZttquU8fq0WTSzNFjlCzzTpl033fiPT3JmEylReNveBkeuKzfKGqc2MKhelGf/ltvFPVjYGDfoDtevHS26dHdvff2imGk1pRrEVC6L9GDbo6DWAhUPvfuUc6ZpVXXzt4K6Sa8cmCug4oya1rP2zFiIr1JufXxtCwa+gUtfPmQTjtdXnz+zFCKOBM5FCUBL1MSnIaRHuwLZgNRe4tsQ8eMQjDhUZq+v80/VpM/RQTGbmI5Aaoa8JmQ5DEE61IwDFTEM+OBu6wIGqGwQ3CZqO0e4cHqEUKp5lkQrvtbYdN+lGYTfGekkIAjpALYj5dXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV8PR11MB8700.namprd11.prod.outlook.com (2603:10b6:408:201::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 07:53:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 07:53:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>
Subject: RE: [PATCH v4 03/10] iommu: Remove unrecoverable fault data
Thread-Topic: [PATCH v4 03/10] iommu: Remove unrecoverable fault data
Thread-Index: AQHZ1vyS9EHzu1Dwtk+oZkZglEIqx6/6pIDg
Date:   Fri, 25 Aug 2023 07:53:40 +0000
Message-ID: <BN9PR11MB5276921E23BF1F9CB7E23E1D8CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-4-baolu.lu@linux.intel.com>
In-Reply-To: <20230825023026.132919-4-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV8PR11MB8700:EE_
x-ms-office365-filtering-correlation-id: 40949cc7-99cd-43ab-84e7-08dba54065a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qMPi23UBSL3cTGPkRdoptWYSZQTegUxAhG2dMcpGZsh1ntVUiTm0u4Jmjisna9lnSnOiNB4Gk9RFD6a03hASEG8uOKV3s1hyULu0iMcmaGSSu/rWawyMAwu3vzYiRoBEL+VmWKJtfBzRPWjBYawaHSBzNF3BhhlwbKuh5tsSf+YH+glJhCmya+gKf71U/MgLJM6Ps4K3Fi/8Ov4++gXWz9VQSnCZIZduzGqOL3h2m1vftnl6tnhU4HeobfnszVy93pBkCHxaZ6s2sZOv6xURBcZs4YYALu9wpKlnIvgsbELzuMcZako0vbnMtE71JsuX6Rhm41ott3GdT0xNN5ySLiW3XfhtnuFVK8ZUDsN6aBE2ltcVmf0s62iUQ7yfGt2bnjcgZsoK4Qo6Qe4Gg3I78ZFTOnTSehYayfXxhUfDqusgzcW2QEPbN1l1YabACXSI1Rnj3Dp4J3HErdQroGDULfNLV0qDfMC3GU66FMoZul+17ZGiaxAHCrVLYHlPUvmv8BAXPhWG7dRwRHwoNxlGUvYfaNsf1TQCfRkJuL5OWJY52dDY1pRRNmNOjDgzH5Jq7btArI1UUpbIBRX2ATNnGDxEdJ0JVmPklX7JXQTkr8PeegypF8c/tbQtvXoimvEL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(366004)(396003)(136003)(346002)(186009)(451199024)(1800799009)(66946007)(9686003)(41300700001)(7416002)(66556008)(66446008)(66476007)(54906003)(316002)(76116006)(2906002)(5660300002)(4326008)(52536014)(8936002)(8676002)(110136005)(478600001)(6506007)(71200400001)(7696005)(55016003)(26005)(64756008)(558084003)(82960400001)(33656002)(122000001)(86362001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KfCSv46uGGSKZmPI1N9rzSIBUj3C/xg06CujoCW4iPuS4JdovhzMkD18Tf2s?=
 =?us-ascii?Q?QlK7xJ8673B6Z6l76G7OD31Ig+dlMKunsSQdmim9aI8zQYoWcQlBsdbZz4yC?=
 =?us-ascii?Q?+4cx8+TovgYbuWc/veVSzBPHPk3pXP2cVg9n2/3Oi5kxtZOWl7OXJqJwvGa3?=
 =?us-ascii?Q?ljaaNAJfpGP30eBysJ39QCafs6g/zzbrGYIvEq2BH0WQ69z7IETK/SwXW/Ys?=
 =?us-ascii?Q?x+P2w7Jth0HAz2ZjolZA3Y3HIuL3BONclIH9e6J/olN+0zrxmepVJCyPlVfs?=
 =?us-ascii?Q?HypKjOVXkdEhZrtGaTSJVXOGIae3Ci5jpY2vpenzapHPoxAduqYDudRQjUsF?=
 =?us-ascii?Q?zM0yqbBCqinfRFjFTWGwxT/VAV52ooE+VTld5mPzHko5Km6Dh2XJmlNMpKyC?=
 =?us-ascii?Q?mHkVhnV1CEwLznG6RLd5rV79KTwk8tiIn5NUZ6TLjBKFicgOTjsmPV9gCEPB?=
 =?us-ascii?Q?0QGZDTho/ph7bias+93+Vu9mb1hdMLw87xYK8mN/YFjpV0FBlvD1fGsRWqht?=
 =?us-ascii?Q?8CZ95WviAZq2kEhI91PNW0N7B452WmGVy2NoOskfuzZImn2Ouu1br7Zd/GSl?=
 =?us-ascii?Q?+SL5D+9xzJCPEj+bO4UGEk3iNQLr8qPccecwXS5OD1Z4UX8z+PqB6BFr6E6y?=
 =?us-ascii?Q?aG1B7PUy3NGisRf9T+tGwySYy+pb86JAvy+jUm8WSnc18PNVxc3bSJrVCVvb?=
 =?us-ascii?Q?TMvb4QHbRzJCgR8OUdYo5BonjIP/EdBR92J9zXOebl+qeqWbKjlK9JS8xnOI?=
 =?us-ascii?Q?kV7rxriCTSLL6VobEJmu70JkJsi52uBF0SjEwLYKiED+0dWTSKzxewhZoF/D?=
 =?us-ascii?Q?8i9kQF/JH+Qf0GrI8dZgMoL/Y4mhzFM6dqFeyTem7lrKUdwqUxILq8sk4pxA?=
 =?us-ascii?Q?rcNyAnBH3q7wfPCbgZdBSzyj8fwAqgRbWmAmMZFpb6CMDUhzIV4ZzYx09kjl?=
 =?us-ascii?Q?1RMfbqMv0gXygTjYUR2yMIw+CmiyBTZWavB8vMjLYfOajD5hXiFs65ICgwFh?=
 =?us-ascii?Q?sOFrBpxlQA1Z8EfANRd8lBxO8ip2OBSzgdfkCjiMu0wbMngaI1PYHvCgiTIy?=
 =?us-ascii?Q?d6MvdPcuhUB66AkDr7xFvX2AKBtVcGBVkzv4K5p6aeOfeAQt5MQDSjUcSIPf?=
 =?us-ascii?Q?eVywiudkkIEFTy/TgM0kVGPWSerUBx8PV1QWBNG+v1j+C665xdIe31iEErMb?=
 =?us-ascii?Q?kE3Cb1MGvv0EJJSvGBs7NlLIpGR6cMfIHo/nG/YL9DJDb9fSRNvelO+u8OGZ?=
 =?us-ascii?Q?9fg0Ggbdmo8oXtoSHMCsUjf4MMdrD4K/wM+f6UbpkecpY2QsJZVqF68S44o2?=
 =?us-ascii?Q?VRLYyyYn7zQTgAJI63KtCY+dsPlfMcUjIsayQRK95eRoxJ/Gz6zltUvojRB6?=
 =?us-ascii?Q?ZUzbYfnyQlOMw8xrR+O8CWx9qQ6pETGtZ7riDXB/VLPNyKw4n86AUWkeNoRD?=
 =?us-ascii?Q?ZHA0O8AvXoY4ayTCb/UmXUHe/5AYlXxiET5PMhgzuLwe2O5+M6mjE1FTbvJn?=
 =?us-ascii?Q?qWQRO/XIOeH0qq+i4keZS1x9XlpbqjneVSxhXWvbv6rM0KqyYPkVvCnGYu7s?=
 =?us-ascii?Q?O7dpByTLYscDSJyvfPR93n+Jcjxgvii2Z7V48Eo9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40949cc7-99cd-43ab-84e7-08dba54065a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2023 07:53:40.4682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: prAaX1HOgYDF/+Z4UKXshVzssjNmTpRpivYrUAHbgBx7vZVULtXpsuXKDRutjMJKRdY09LywqpBOb8JJQg290w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8700
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Friday, August 25, 2023 10:30 AM
>=20
> The unrecoverable fault data is not used anywhere. Remove it to avoid
> dead code.
>=20
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
