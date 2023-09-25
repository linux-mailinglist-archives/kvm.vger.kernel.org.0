Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E32E7AD0A0
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 08:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjIYGvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 02:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjIYGvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 02:51:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698FAFB;
        Sun, 24 Sep 2023 23:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695624665; x=1727160665;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mY2AseihjcjWNh0L3qNJrirpuYYUbteEZD26G/AEHt0=;
  b=YUlKiFrv/2uOHjgHC3v2sMzv9xKUHqATvvR/hPdVYmDWyqxmHQdsVufK
   gH2WXKSB+eU0fcQb1fQQMWB2M4oflMJ3w2t6HygIlSkl9dszX7+diAwjr
   8PZxZ/auqovPteZ9NUyjtxy1r07JoULMqfisLtSu3ZWyKpx9MRRMwb+7q
   NkZz+Vy7PGqlVbzoyubdjpMl9NdlP7bQxqshopOZZ4AnWUw/icdPB1lIF
   bVXC3pyZhLhvtICRkPhlCx9QFgqAl+xcFg13pPfd2YmUnyU4N3nYgczYx
   F6uyU4ot0cwgmd83mzQKWHJfTs8x7RELG7xhlG6oLgsRdFiKOqcfEgbFP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="371501177"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="371501177"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 23:50:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="863754598"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="863754598"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Sep 2023 23:50:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 24 Sep 2023 23:50:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 24 Sep 2023 23:50:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 24 Sep 2023 23:50:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 24 Sep 2023 23:50:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8JdhDcQiiuO4w0wRETVph2gfuHdcZx5asz5rq8b70TQVWZABliujk3jXbmHsI8z0m6DU5JgDMsQXN33BFDZh8Mx70UeJ/pMPsSDfNoKcH52GzOl8wVrs1n9Wi+/czWkZs0BCsCrXmAs2CHmZuX2oqvlR9FW3LZQxfXNPScUckEzvfXzQ2Nc/mQCGFP7CMRbONH8Uvl8s8S3mjIFQnh1f82od2/odvxO2KXc9okNl/LCJi2pB0czihfEQ+8t+FiriDVjkZ2ip/wDyFUiSTNBewKbXP88PMbgLwb1DPAjkTdV/L3+yZvqAb3E2ifTSvjnkVjtOpIMB8RuEwa+CL19tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mY2AseihjcjWNh0L3qNJrirpuYYUbteEZD26G/AEHt0=;
 b=UXNbMqV/0VsZJqI8dU0Z0hacsofVrgnPzPAkx41v+kOya1AdONjuWelr2NH301XZaUBIT7LCps6m5VJiQvMLuvEVt2ApbjPRto8ExxcPgTuAYB3QvZ+lw60LzIVVgYSR6OJ98TXW8CkR2retw+xIvwy24PmwmKl565mO2mpjyEjTiN35DcxlziT9kv+9Kr49cqRRlalyZxDCprIu2jaC3YOQs67BHCHtxUbAhs3Z1BcKHSPlm3MblDjElTc4JPrjhR4IpEf2yk09N+fqSgaeubQkgRCznPDxDkDFNiFn9mMSusqabUur75rJlQGczE46z4IW/kUx96UC//AnP6ppSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5556.namprd11.prod.outlook.com (2603:10b6:208:314::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Mon, 25 Sep
 2023 06:49:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d%4]) with mapi id 15.20.6813.017; Mon, 25 Sep 2023
 06:49:58 +0000
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
Subject: RE: [PATCH v5 10/12] iommu: Separate SVA and IOPF
Thread-Topic: [PATCH v5 10/12] iommu: Separate SVA and IOPF
Thread-Index: AQHZ5un1XJNlLNJrvkG1/i98S+9w3bArKvUg
Date:   Mon, 25 Sep 2023 06:49:58 +0000
Message-ID: <BN9PR11MB5276122347A9FB1AC3EEF7EA8CFCA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
 <20230914085638.17307-11-baolu.lu@linux.intel.com>
In-Reply-To: <20230914085638.17307-11-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5556:EE_
x-ms-office365-filtering-correlation-id: c94ae25d-a5a4-459e-6b19-08dbbd93a283
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x69YdugVR/A7y6EBhKvWuve6YamxO0EJcDBkmWA4b0bIRAeFUgo4G3GOfRcrA821p3OngrxgvLVRN0rsCfbRIqJIPETrrVz19Etfa4QA8sW2MS6K9/zxvR6USJQPRI7lFSm2CDaZ6jAe69yCc1gI/PpcZbWnriY9vngwJottkB1OPDGnxkxM1mr84yA8wiHpUK+9J1hl+2HAwKzJw85EB/+ftRDxgC50mLwCyfZnFAkb4QLlfn9ofMDs8gK6z9Xf1Zv3HKJGFkuJOYedYnhkw0eDhpyZV+t4DIVenM6yAQandAHof/D3l+Qm4tvaJJwC3O5HjLk/s852lKqxgYfBV3auneBdaIDGvueKkhxv1rjbiB++lbCe+YTB+hDhttzvbQSvn7d5fQ1+EQh/MwBlcmi0gx6vNyuxUwAShndaSzfeuMi7xANfcwr2LwCA0R/WSkuCpVdpbO6RvRLbwys4Rn08iVIvb1tClRy+Oxb5NDbn40xRr+EhFqN7xHld+B/LEM2p5HBRqZS3QceDICZlgEFpQFDFjN1IqI0LHwkbCszhwg/oZDT6rp/jSyJat9trpWmmElDSWblUzqnB3VoIaHmVeIZZ49Ni3nDHhT95wXtTfBfEvbLbMNb2Uncl4p3x
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(376002)(136003)(230922051799003)(1800799009)(186009)(451199024)(9686003)(7696005)(6506007)(71200400001)(82960400001)(122000001)(33656002)(86362001)(38100700002)(38070700005)(26005)(55016003)(4744005)(52536014)(2906002)(110136005)(8936002)(8676002)(4326008)(41300700001)(7416002)(66556008)(66446008)(64756008)(54906003)(66946007)(76116006)(316002)(66476007)(5660300002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9b8GNfp35oTEnsTmZA74uiwzXPsQjeRfNlu5Vb30xmex0bERXAPt4uhJS3t/?=
 =?us-ascii?Q?+NvuDNi/zzTElFMNZB2deuWT56EMc260TuzsyVnP/GAKRPcAdx1lI6Hzrbdi?=
 =?us-ascii?Q?3jcVC8cRdoa9bicedPlMD0ktgwP658CQEQoZQLgmbpvSs2UBuVEZ/kJXJYUH?=
 =?us-ascii?Q?suI61sk4N5XFp7lzHUP9IIMOgwuon19Qu4B3tsLO4fpW60asfiPiBcTq8RQ7?=
 =?us-ascii?Q?UAVOUj4aP/QqqMCWa1ZZu/XXOkm9NnWhpBtp9veeXdu6FNU4FwmlnjdCkRhs?=
 =?us-ascii?Q?FIZg+Y/3mVLZrBrTXWS8sv1beWciO7LGwHVmbbwpAAhI30w/9Jb5Bwdj1VEh?=
 =?us-ascii?Q?T+86ekFQ06LxxHDoJEqf8SfhrvewpOHtIkio8iwpioPYmRoSPweyNvS301Or?=
 =?us-ascii?Q?BtTzUcOvy72uX8MwOTgSufSWFvF94QSWzjlsT+xUbaXN6AEKhJ9Kkph9jNMc?=
 =?us-ascii?Q?AeXuHpmQemURwltPgT2B7otrvyDrKunLRH0LLaJ6ZCoaOXsHL2IYOqVeBqcS?=
 =?us-ascii?Q?P2pwquHV3Sw4dhWiPY8oU2d4eOeqgPw/wjaO0MX6pPBx/A60v8tQpWnK93CM?=
 =?us-ascii?Q?mTci/lf4KN1RI7i7Q18R738vLBqWQcBAIpQuXdycAl/1dYpXq2n+Xqkobfcv?=
 =?us-ascii?Q?RftTXktDjeVhhzMjnNfHFg1E9XJKvBN67hapnGuqpSoCV8NphC0sP5dFF7VS?=
 =?us-ascii?Q?UTbyeIuvwLFVnnEHfTHS4VIBHR1OGEwZo6AoIWkLor3PwGboUn2xVy4qY0Cm?=
 =?us-ascii?Q?j+dVqSaLdl4R5V0hqyKm/QW4JQcNufeiNzIZ6Si9b8Pq7fW7HXhEJ6pgpnXF?=
 =?us-ascii?Q?/wLOE9wG67s57LC872EayXM0JuA+8psbJug6OnTUFVkLe+F7E87XS2xKz9bX?=
 =?us-ascii?Q?wEWQro5+xBzJF1UsilY9QwPpwDyIgcd1mnB4ie2E7+K3kvR5+kGe9ClMX66e?=
 =?us-ascii?Q?rugljmQvf6DZDOVmV1RV8rFthS2cAiOCvrOwSUuovAh5hMZHSchF5ldO/UOT?=
 =?us-ascii?Q?Fsv5XfiQ1jLiyjEGlLwsIUq/2foWFxA9NUhQeXW7rj63tS8K0+ezvlPC1RI2?=
 =?us-ascii?Q?06jxULRugjicdD9fTB98Aved56qyzU54E8NNHAzY5SS9BQINODVl3FzthGLs?=
 =?us-ascii?Q?9dR/nZpRbtpfpGqYezj1nXRJE2mdtDK/ocEfsUM7gX/s8CwqJ3HbakGVUIQ3?=
 =?us-ascii?Q?h8iOH5ejh/QwNpxZkl4piEKS/nCAks5D+ds/1lOiSag2RRjjF522fpRjcswC?=
 =?us-ascii?Q?S0EBPZnhrFuJgWRV+vzaLvs0S4VrZTMFiw59JJg6+WtZdNeyKkVPnFhFXBRO?=
 =?us-ascii?Q?KNmMrHELzlKAPAdKj9tNZWfvbPVoECDCSFXly+phEtkIk0aXSrTPg7pPLzMu?=
 =?us-ascii?Q?jdvl5ZlikPm0taI7N25QyWtOGiHud2SEoCmrANBf4GsG1cphfottk8AK8yf2?=
 =?us-ascii?Q?HKUXyfNrMchltG5Tz9cGVf9bKbA1UsnPRu1KcPY1WcaZE0EUwB+GSOSrR+Gm?=
 =?us-ascii?Q?oigvYUPloB9MYgOkgCpuzrI5g6ZU5dPk5EhoO7IU0dhQYlC3Lie2tkciVfMU?=
 =?us-ascii?Q?iH16EM1hzp+MkVYznZ0/SrXbJFjpZVJdb2RV9l9+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c94ae25d-a5a4-459e-6b19-08dbbd93a283
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2023 06:49:58.7222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e0S1IjcXwJIW+Yj2oHnwoAknGdym2GeH/Ms1PVWhS2MPpiuEUveumiL7/tgolgmUm9NoE9yCqqoY9tdC3Qpdnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5556
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

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, September 14, 2023 4:57 PM
>=20
> Add CONFIG_IOMMU_IOPF for page fault handling framework and select it
> from its real consumer. Move iopf function declaration from iommu-sva.h
> to iommu.h and remove iommu-sva.h as it's empty now.
>=20
> Consolidate all SVA related code into iommu-sva.c:
> - Move iommu_sva_domain_alloc() from iommu.c to iommu-sva.c.
> - Move sva iopf handling code from io-pgfault.c to iommu-sva.c.
>=20
> Consolidate iommu_report_device_fault() and iommu_page_response() into
> io-pgfault.c.
>=20
> Export iopf_free_group() for iopf handlers implemented in modules. Some
> functions are renamed with more meaningful names. No other intentional
> functionality changes.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
