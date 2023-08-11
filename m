Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893AB778944
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 10:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbjHKIxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 04:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbjHKIxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 04:53:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD6C9B;
        Fri, 11 Aug 2023 01:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691743981; x=1723279981;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gun4iSHHQkh2rLc/lY/yer1uEBIM9N4H06s1O5ecC0w=;
  b=NKop7aaGS8ZXRtLDzfkECzF6Z9Jt41iZBYDFPuG/Nk7Pwno9r7HyCkHh
   CN1+qZK3iwxrAlHh12awIk1Zxg73k4u3ocNk2T7cxp0yGVSJcKtEfLCDd
   g6tMPA5e9BUcaUSuwX3OUYXGpO5FHwFVFX6z3fUAAlAudEID9q38N+oGN
   lXcW7ATCiJivKjtpv6Sp3vYDQ9h5vQSc/mLD2sNAkyRzYMAntDdtO87+H
   kQKwVonzoB3qIweVlGDm8OBG5hdIcFnR/Sa1WQV92UYQAd3A5kDEA61Tr
   83pAAW+NsFuEh0vqYUzxxCx6WXa4oAR7DISbx3Wk9km2MzG4lIsUu+fSi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="369102804"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="369102804"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2023 01:52:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="846730790"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="846730790"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 11 Aug 2023 01:52:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 01:52:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 01:52:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 11 Aug 2023 01:52:54 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 11 Aug 2023 01:52:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9BQGTH3Btupl/QDp38CSiVswR2YvZKbPCe4jIWBQtnl7kXrt1I6XnsR3nxyMXHe4jhemODdtWvMBBrN5WEreFTU500FimPXCFllc/ap6EoAhiWUVV/tPv9sMKR7ymMe2a+A9fr1sXoKz6BwgUacR6ISCZmdQYKOcwNCyg11S+TczL1fbVJpop3w6w+Nx7YhNEk4emLEBZ4vEyjZZgIHXLN8wJ9NaQRX7WnDgeMM7XZB/aisvgtTj6RK4d6ojCR7/01X/XPqhiA9iA3riU72OeVvJsvLLS8Ov0pIwDwX3vSBVezOBsdBqvXNakfU0alzxKhaorgdoAqGobQVfkl6YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=we65FcLei8heo6z8n0UnesaRun3zS7K/Y8UZEJt5jQQ=;
 b=XQyBRb7ZFJzlVbRgBFvJJJSNMeos9tnkZ6TJbwUbk8tPTsu3MHUtC6WLQQCqafg5OdD2/3YBeQscLY9Qvkia2yvnUadELMiKnCeSwWz0Mj4nxr+jIZsHAq2x7GY0+D1WYkufsHOBb71yXSTwqnWbh9nFJDOMi76WpLMrFnGETclgspqU7sRVoVcPfWOfknMT8+LlHRJTIf7t2cheAmSQeHZAZ4JJ0xDvlRxMWasqsUTEecHgXgbo0hy3b9Vf9yGTEx27dTit1DJE4YnUGDgu8GMlsRqSP17gBZn8If840OzVb78AHO0+kEEOoR6cqkt/DA2oD9wACRrzS5bNleUgTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5687.namprd11.prod.outlook.com (2603:10b6:8:22::7) by
 SJ0PR11MB5134.namprd11.prod.outlook.com (2603:10b6:a03:2de::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Fri, 11 Aug
 2023 08:52:53 +0000
Received: from DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::c59:de67:a3c6:2958]) by DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::c59:de67:a3c6:2958%4]) with mapi id 15.20.6652.029; Fri, 11 Aug 2023
 08:52:53 +0000
From:   "Wan, Siming" <siming.wan@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Pankratov, Svyatoslav" <svyatoslav.pankratov@intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>
Subject: RE: [RFC 1/5] crypto: qat - add bank save/restore and RP drain
Thread-Topic: [RFC 1/5] crypto: qat - add bank save/restore and RP drain
Thread-Index: AQHZq1VdWVubNLeKgkyuvdLzirFqR6/Z+ikAgAqm6LA=
Date:   Fri, 11 Aug 2023 08:52:52 +0000
Message-ID: <DM8PR11MB5687538BD91AF2DBF0A441C38E10A@DM8PR11MB5687.namprd11.prod.outlook.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
 <20230630131304.64243-2-xin.zeng@intel.com>
 <BN9PR11MB527649234A93384F1EB11F478C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527649234A93384F1EB11F478C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5687:EE_|SJ0PR11MB5134:EE_
x-ms-office365-filtering-correlation-id: ab05d18c-be14-4528-22bf-08db9a48594c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U1J4qtOIkH6k4v2LxGa71IZ9CtaZDo2WJle4vypna6VqO0dQUqLgzAxW0RBVB2dvheGCblC3eKY0e73t6QqJstXSlEr0pOInKUCluwczzxXfSN8lyixl4yAn2iGZRo6uPWx48LXtVdlWYM61NUlrWqnEaF00M9UpUT7R0uQYyd1QecK5VPg2cbCnj/fFeBI8xoj8n1gQPgAiS7daW4beBtHZnLg0GsGPgkSi0yctB5QdWj2cNKtX4PTxElsdH7ZyItcDC26nNZIAAB6aopDFWW9EJj7VZy4tWlV526x67mDn0gVKcfHBvwRvgTpbRRM1/FU8SUUmIpWEhw6kKkQblY4ucMMvca5xp2XaKrmOff0uSFmXuw4QDPerrHvVGo5XLB9/m5t6M46/bRw2PCWJVgx0MRDx/BzTps3iti6wDcJQ1beqOGf5ucszF7Ozj684FBDcFjCbmYF75fXFGYhL+m14EVFSsG15B9+h2yX9Tv162iGhWAQq5iCPQ8AG6gr7BRFjWVSkpKRaGqBjdjh5SCJWg3+nEI3YggZ9RxbSYCOcVIU28Ec3hpczA+3pSxC0QqR8b17N1NppSuzIip2ARG8uP3qaIRuTl7HRt+jF93yKpmns+6xI14JzJbXOOrzk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5687.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(396003)(376002)(1800799006)(186006)(451199021)(478600001)(7696005)(76116006)(4326008)(66556008)(64756008)(66446008)(66476007)(9686003)(66946007)(5660300002)(52536014)(316002)(54906003)(71200400001)(110136005)(41300700001)(8676002)(8936002)(6506007)(53546011)(26005)(86362001)(38070700005)(55016003)(33656002)(38100700002)(82960400001)(122000001)(83380400001)(2906002)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VU3LR3Jc2XXC2oFB9BU6vbvxbbQWvK2a1Lvr9UYFkGqYCcqpahNPj1p2o7VF?=
 =?us-ascii?Q?Ia1j680wvevFtsJw0yXkiGFOY65fIy2Vd8mCVS+Q7Ms1w3h+BFShNgT5e6lA?=
 =?us-ascii?Q?iSH46JurQD1jnSsoBiom62yoc1/NcSC+6xfSV2UhBpvts+lGSLQqPd+h/1rd?=
 =?us-ascii?Q?bPB0I04BW8fnwpR9IK28mPPpKkTSrKzCd+8xSTkIDCFSnSVR36DvS7mVDTmp?=
 =?us-ascii?Q?IKat83cLGSniKsXcbVCek3LdKpdx9rRdZPCDlT7mdGNcVqi8IoRMvakuKfrC?=
 =?us-ascii?Q?zkZ6XsoxQdxIGowAlrAHCe+hRGeeLloSd6Vz543EZ7TOzk9SuuU9P5BGyXKU?=
 =?us-ascii?Q?nB3Mu4+4tQLJWxonCS2CTUxBu4DEdp36S2UV0ahB5PAX1YjNxVVoIwYUEvzL?=
 =?us-ascii?Q?AaG5I50nHTYZkDJyFFZ68GV+gMXzdeZ2yYSRnBoYP2b2NbIoXh2E5GwR+TNR?=
 =?us-ascii?Q?N09L/Sf05sIcjjMSndJ1cYFRZ5MTJUEvod1n3A2TAiDBZvOd9UGL6qbZpdMk?=
 =?us-ascii?Q?LGS8E8CJWus0HzgAIbclmt3xGdkl4dQfTESNzHiMnzPqtPqp6RqJ43lXoAnr?=
 =?us-ascii?Q?4wtoxWgtauzVG22le/kCJYTjCOrn0RzOPF34W57+nU1MzFLCK7FUDpKVDkQq?=
 =?us-ascii?Q?feJ3Xh+xaNpBLAdZvGGCeFPDJr4joPuvwn+5DCQZzsx0bmsil6NklYAFXQk8?=
 =?us-ascii?Q?fXEzaPhz7DL1f1nIfY/67Xy/2z06SA5aagqe7WK4dcSuB1fgLRQ+YW0ugC7v?=
 =?us-ascii?Q?C58298O0kf0DrgSHFFuvCOGR2KFCPxTlQ+AIHvOyn2L9Xd4s5+pOXuCCVMbP?=
 =?us-ascii?Q?7y9S3BEla7dEg+RdDcBUZDaRjfjxvzI1Hlm8sskhMCv6Ylz8sNo0a8y7dKA3?=
 =?us-ascii?Q?n9pBSzn5F+oUh08fW/mm66vVXKMf7GFJsv+/U8en2SY0Z0HiPSF331+nL3Rh?=
 =?us-ascii?Q?tVTPcc7TNZalTyycSYe7bFouj1mt1qZHDJYC11AnPckOsxZoeVdzMH0iRNNM?=
 =?us-ascii?Q?eouXQITAoo2vjKncx/JxvbV8712hS7sA1U6X37z6i5wIrj6ORqGy3QTiIZa8?=
 =?us-ascii?Q?2ggksbNWXxi5ka9pxqSptWWwjrbZBi3Q+/1Mjv/MwWPPeiWSmqfKzYGFUhsy?=
 =?us-ascii?Q?n8rYaz0NKEUMIKV94ZNKG8o8k9XJcOsYz5g4iLQGpQFNUQKQ6izYcqf/6yRc?=
 =?us-ascii?Q?XbHk/+l/PhSm32ztP05mAXEMuihTPMNlqsge8gn2sIO2zoMKbxd+wdkh/HJX?=
 =?us-ascii?Q?LgbJdgh5hvp4fs639Y18DUuGjFUQ7nkJy8rNXR93TOWjYJII0iWkOOB9X7mM?=
 =?us-ascii?Q?Q45LqdNjPzB5KXNNNNB04YWQWsVJuGfqTdpjuJYIagzXumQ8/1DGrrT8rL1Y?=
 =?us-ascii?Q?FKRGvuHagev9rh36CXtw9Bxle3u1+0ERwE/hYA0hKwlWOM6/UBXNLLQU5gNl?=
 =?us-ascii?Q?JeQvCFHB91qojsz0sE9KOw5MCC/LJT2kJIHVGheXdmrm2U/xdqCm1BvpfGeH?=
 =?us-ascii?Q?sN2RDEbZT+lbY5Y41TNww9lUMARvB945C0su1EpBLaDKMDHbK60QPn4OpCHm?=
 =?us-ascii?Q?7cpVgJFVDjr8OjHlp4TK19v5rjs8//IPuwedFFXS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5687.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab05d18c-be14-4528-22bf-08db9a48594c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2023 08:52:52.9319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mAa0RRWtD0ZOwxdEHkxnXuEOAtEVGlFj2RK8BvjM9LAvc9WVKBGrFSxkXSNRcpTYFCBQZKfkxU9wK9s77Ov1SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5134
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-----Original Message-----
From: Tian, Kevin <kevin.tian@intel.com>=20
Sent: Friday, August 4, 2023 3:51 PM
To: Zeng, Xin <xin.zeng@intel.com>; linux-crypto@vger.kernel.org; kvm@vger.=
kernel.org
Cc: Cabiddu, Giovanni <giovanni.cabiddu@intel.com>; andriy.shevchenko@linux=
.intel.com; Wan, Siming <siming.wan@intel.com>; Pankratov, Svyatoslav <svya=
toslav.pankratov@intel.com>; Zeng, Xin <xin.zeng@intel.com>
Subject: RE: [RFC 1/5] crypto: qat - add bank save/restore and RP drain

> From: Xin Zeng <xin.zeng@intel.com>
> Sent: Friday, June 30, 2023 9:13 PM
> ---
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   5 +-
>  .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |   2 +-
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   2 +-
>  .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |   2 +-
>  .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c |   2 +-
>  .../intel/qat/qat_common/adf_accel_devices.h  |  60 ++-
>  .../intel/qat/qat_common/adf_gen2_hw_data.c   |  17 +-
>  .../intel/qat/qat_common/adf_gen2_hw_data.h   |  10 +-
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   | 362 +++++++++++++++++-
>  .../intel/qat/qat_common/adf_gen4_hw_data.h   | 131 ++++++-
>  .../intel/qat/qat_common/adf_transport.c      |  11 +-
>  .../crypto/intel/qat/qat_common/adf_vf_isr.c  |   2 +-
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   2 +-
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   2 +-
>  14 files changed, 584 insertions(+), 26 deletions(-)

this could be split into 3 patches.

one is moving from hw_data->csr_ops to hw_data->csr_info. apply to all qat =
drivers.

the 2nd is adding new csr_ops.

the last one then covers bank save/restore.
->Will split it, thanks.

> +
> +#define ADF_RP_INT_SRC_SEL_F_RISE_MASK BIT(2) #define=20
> +ADF_RP_INT_SRC_SEL_F_FALL_MASK GENMASK(2, 0) static int=20
> +gen4_bank_state_restore(void __iomem *csr, u32 bank_number,
> +				   struct bank_state *state, u32 num_rings,
> +				   int tx_rx_gap)
> +{

restore is the most tricky part. it's worth of some comments to help unders=
tand the flow, e.g. what is rx/tx layout, why there are multiple ring tails=
 writes, etc.=20
->Will add some comments to explain.

> +	u32 val, tmp_val, i;
> +
> +	write_csr_ring_srv_arb_en(csr, bank_number, 0);
> +
> +	for (i =3D 0; i < num_rings; i++)
> +		write_csr_ring_base(csr, bank_number, i, state-
> >rings[i].base);
> +
> +	for (i =3D 0; i < num_rings; i++)
> +		write_csr_ring_config(csr, bank_number, i, state-
> >rings[i].config);
> +
> +	for (i =3D 0; i < num_rings / 2; i++) {
> +		int tx =3D i * (tx_rx_gap + 1);
> +		int rx =3D tx + tx_rx_gap;
> +		u32 tx_idx =3D tx / ADF_RINGS_PER_INT_SRCSEL;
> +		u32 rx_idx =3D rx / ADF_RINGS_PER_INT_SRCSEL;
> +
> +		write_csr_ring_head(csr, bank_number, tx, state-
> >rings[tx].head);
> +
> +		write_csr_ring_tail(csr, bank_number, tx, state->rings[tx].tail);
> +
> +		if (state->ringestat & (BIT(tx))) {
> +			val =3D read_csr_int_srcsel(csr, bank_number, tx_idx);
> +			val |=3D (ADF_RP_INT_SRC_SEL_F_RISE_MASK << (8 *
> tx));
> +			write_csr_int_srcsel(csr, bank_number, tx_idx, val);
> +			write_csr_ring_head(csr, bank_number, tx, state-
> >rings[tx].head);
> +		}
> +
> +		write_csr_ring_tail(csr, bank_number, rx, state-
> >rings[rx].tail);
> +
> +		val =3D read_csr_int_srcsel(csr, bank_number, rx_idx);
> +		val |=3D (ADF_RP_INT_SRC_SEL_F_RISE_MASK << (8 * rx));
> +		write_csr_int_srcsel(csr, bank_number, rx_idx, val);
> +
> +		write_csr_ring_head(csr, bank_number, rx, state-
> >rings[rx].head);
> +
> +		val =3D read_csr_int_srcsel(csr, bank_number, rx_idx);
> +		val |=3D (ADF_RP_INT_SRC_SEL_F_FALL_MASK << (8 * rx));
> +		write_csr_int_srcsel(csr, bank_number, rx_idx, val);
> +
> +		if (state->ringfstat & BIT(rx))
> +			write_csr_ring_tail(csr, bank_number, rx, state-
> >rings[rx].tail);
> +	}
> +
> +	write_csr_int_flag_and_col(csr, bank_number, state-
> >iaintflagandcolen);
> +	write_csr_int_en(csr, bank_number, state->iaintflagen);
> +	write_csr_int_col_en(csr, bank_number, state->iaintcolen);
> +	write_csr_int_srcsel(csr, bank_number, 0, state->iaintflagsrcsel0);
> +	write_csr_exp_int_en(csr, bank_number, state->ringexpintenable);
> +	write_csr_int_col_ctl(csr, bank_number, state->iaintcolctl);
> +
> +	/* Check that all ring statuses are restored into a saved state. */
> +	tmp_val =3D read_csr_stat(csr, bank_number);
> +	val =3D state->ringstat0;
> +	if (tmp_val !=3D val) {
> +		pr_err("Fail to restore ringstat register. Expected 0x%x, but
> actual is 0x%x\n",
> +		       tmp_val, val);
> +		return -EINVAL;
> +	}
> +
> +	tmp_val =3D read_csr_e_stat(csr, bank_number);
> +	val =3D state->ringestat;
> +	if (tmp_val !=3D val) {
> +		pr_err("Fail to restore ringestat register. Expected 0x%x, but
> actual is 0x%x\n",
> +		       tmp_val, val);
> +		return -EINVAL;
> +	}
> +
> +	tmp_val =3D read_csr_ne_stat(csr, bank_number);
> +	val =3D state->ringnestat;
> +	if (tmp_val !=3D val) {
> +		pr_err("Fail to restore ringnestat register. Expected 0x%x, but
> actual is 0x%x\n",
> +		       tmp_val, val);
> +		return -EINVAL;
> +	}
> +
> +	tmp_val =3D read_csr_nf_stat(csr, bank_number);
> +	val =3D state->ringnfstat;
> +	if (tmp_val !=3D val) {
> +		pr_err("Fail to restore ringnfstat register. Expected 0x%x, but
> actual is 0x%x\n",
> +		       tmp_val, val);
> +		return -EINVAL;
> +	}
> +
> +	tmp_val =3D read_csr_f_stat(csr, bank_number);
> +	val =3D state->ringfstat;
> +	if (tmp_val !=3D val) {
> +		pr_err("Fail to restore ringfstat register. Expected 0x%x, but
> actual is 0x%x\n",
> +		       tmp_val, val);
> +		return -EINVAL;
> +	}
> +
> +	tmp_val =3D read_csr_c_stat(csr, bank_number);
> +	val =3D state->ringcstat0;
> +	if (tmp_val !=3D val) {
> +		pr_err("Fail to restore ringcstat register. Expected 0x%x, but
> actual is 0x%x\n",
> +		       tmp_val, val);
> +		return -EINVAL;
> +	}
> +
> +	tmp_val =3D read_csr_exp_stat(csr, bank_number);
> +	val =3D state->ringexpstat;
> +	if (tmp_val && !val) {
> +		pr_err("Bank was restored with exception: 0x%x\n", val);
> +		return -EINVAL;
> +	}

above checks could be wrapped in macros.
->If define macro as below, checkpatch.pl will appear warning-> WARNING: Ma=
cros with flow control statements should be avoided.
So do we still need to change?
#define CHECK_STAT(expect, actual, csr_name)    \
do { \
    u32 _expect =3D expect;                                \
    u32 _actual =3D actual;                                \
    char *_csr_name =3D csr_name;                            \
    if (_expect !=3D _actual) {                            \
        pr_err("Fail to restore %s register. Expected 0x%x, but actual is 0=
x%x\n", \
            _csr_name, _expect, _actual);                    \
        return -EINVAL;                                \
    }                                        \
} while (0)

