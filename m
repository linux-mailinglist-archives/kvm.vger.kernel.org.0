Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5041C76FB65
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 09:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbjHDHvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 03:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbjHDHvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 03:51:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5114481;
        Fri,  4 Aug 2023 00:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691135471; x=1722671471;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yXVygbS/f6W2DLewAl0Omg4k7e0mQDG1S4CHcF5mNmc=;
  b=LHcwFi42pBpMDrSPlMBpdRLWyqFuc9FPepNBPqCqoI6yt8Vo481YDirg
   ZNZFs4RLpiKi9mtZJJ0zLPvRblB5pV/z+WQw8kALnrklvgSBI5y8+Cujt
   QyzvZRCEsH3vrKPZkdaEY76Zkday5NFFv+s2asC00mSaQ2i0Pj9evJIHO
   d0nYSk9/LrRq1M93YqCWG0YxiucABZJHGnR7b/gES6lCjwDCI0vJY+cei
   e8QKXPk06eYYs5UWVF953Zf0JXrGunl5BEyUWu8AURYY8vdWj9XGINmqY
   OIK1gKZz4DolrnpJ53ZD/hrNH/i27vrsND+u1fAgimmNr0ZOzlmohnigL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="372842357"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="372842357"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 00:51:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="679820415"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="679820415"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 04 Aug 2023 00:51:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 00:51:10 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 00:51:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 4 Aug 2023 00:51:10 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 4 Aug 2023 00:51:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6qiWaUDAAagl1yExP/6M5I7JRAZilpAfQ+aWxmGNNRfhb8isr2YQ45Z2s8Ea14Uqunj3v5yuj8/fu00S7Siu6u31WREuASl7/SNlrgspTlhyrl+6S0dhmgRHPVzEk15Yg7bvQBFpdQk2fdoX/MgGEd/TprCgmtmoeWUXa6by5X74CwoP8PrQnWU2OUnbrWh+3jcaQbavIM58KNbAL7lv+hejFSdJUmsZHsyRXcTScuXaFnk6Z6DZZUDS+TauklpsrSEw+azVIKcBKvHJrtF55c1PDjS0ojmO6Kc35sTMYuN38oSaYePGzpg99k3oMTB+l8i6l2gt0hsWT5UhsRjCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KsQCzKqnf+K35tSw6AGAoYz+/AbG7DqTDPdgyuh+fUc=;
 b=mCWwnFlGLV1Vbv8T/qpdt8zZ/wi9FAxmOf39Ztub3dqVlNbuyePTDlA5ACqbsQDNaEBlLppEE3976XX7OgDHLCFXtdqc0RWq7EKaBKRpUa1dHlfk2IxxF+z6NB6tnvtsNi6Y+G/uOd6TqKYD59XjwieWuoGLrpWX8K9aV6+8bkHLcURvqGgJ+TcH5QZ4+VK71yyBoTeSvOxhF2/0Y7uzlPdZaAZGHqRnkuFRnSQXbKj2gZ4l+hEIqPVcyePrE3SBnqabm98LOa8qdR8bl+T1IMz+58Nuhq4tN/hIO6IOV5MNyO4ntOcAus5lqRKgBxC/vQlcg2Swk9jRtTuQKy9x4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB5178.namprd11.prod.outlook.com (2603:10b6:806:fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 07:51:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Fri, 4 Aug 2023
 07:51:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Zeng, Xin" <xin.zeng@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Wan, Siming" <siming.wan@intel.com>,
        "Pankratov, Svyatoslav" <svyatoslav.pankratov@intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>
Subject: RE: [RFC 1/5] crypto: qat - add bank save/restore and RP drain
Thread-Topic: [RFC 1/5] crypto: qat - add bank save/restore and RP drain
Thread-Index: AQHZq1V9FF//PigGpEGUWVqBePzt76/Z+HEA
Date:   Fri, 4 Aug 2023 07:51:02 +0000
Message-ID: <BN9PR11MB527649234A93384F1EB11F478C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
 <20230630131304.64243-2-xin.zeng@intel.com>
In-Reply-To: <20230630131304.64243-2-xin.zeng@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB5178:EE_
x-ms-office365-filtering-correlation-id: 17ed9b1f-e914-4333-8b25-08db94bf8cc5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: II1STeTPr+ZiYB8LFARhieQfxUaXlcMFZiC+fhX33UU8dMlLMoWN7B1ftwJINXm/oEo4lv/fA+gL87gz9Nk21TLZjI2MRPTN83ARKMcssOAW7H3d2E+RNFCoQ/H34VGFbUp2JcBY7YDgqtXujrMWj8kEUTCtbgbNmUjCs8SAWQ0dei63pPip8P0VwPoz+I1s/6wyhCv2tAJYnMP7C3DWUG7FNe/Mgz58PFzuZ9eEzuA15LAciwURhQSDAzNKPYd+YIksWsdNAZwQCXxVDK9DVq1ZzaYOfull8VUafCNovKuJCDnDCu4YAqoyLIiGeU+dD7J+v1yaPkWmzObABu1Zq+Ts7L0s9hjJ4yuFqUZaF/JRHqdzUNtlc8p/skieWLhnIpGnVquCDUyK0/jzPEngAWIBNbKettDzLfFNysnVJ7+SZD6zrzrmMLUu+3CNBICx9O/5ge6Gj82+MpW1xCrjRzxJDudHY8uebI2BA/rRfmIOVfQR752DGehCqKrBIBhvF5vy5c2fntl0FsS01/pqMhArNVNYGnwFMxmxjoLeNRcCBAeCXOJefeJ2M3itmR9WXvvbAuwaygnnnqPLKC/wjipCktLmbsEgeU62m7dVV/4WtimTlNEpqMsfqEXBWaC7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199021)(1800799003)(186006)(38070700005)(33656002)(86362001)(110136005)(54906003)(478600001)(55016003)(38100700002)(82960400001)(122000001)(83380400001)(6506007)(26005)(41300700001)(8936002)(8676002)(9686003)(15650500001)(7696005)(52536014)(4326008)(71200400001)(66476007)(66556008)(66446008)(316002)(64756008)(5660300002)(66946007)(2906002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PrTWOA9/k2qqW1gxvw0J6QoUo1alr3O0l8tyADeqfugYcb+clVaXk+YdWhR6?=
 =?us-ascii?Q?oJm8HYHvmmx9nWznrMGx7djqurehGXcUNzJtNn4+GjPjnOg7XXxo7pG+esMh?=
 =?us-ascii?Q?ugRXa9TMdPJ51KazJip1JqhPXf+S68wUey3jk4WGGxf49Mu6bVAdAiobNCEE?=
 =?us-ascii?Q?r2Z7KtXv1ymzyyKLMdgrnx9Fbop7l9i1C26U+ABM6Dy1yeZwOlUWrUaaQxNT?=
 =?us-ascii?Q?VsLwCICmPii/lCR4co7KJcqYt8yLmjyMUD7/4yEFzhfw7QOwrosjyijojdh6?=
 =?us-ascii?Q?md2GHEoV28UQsRGJgzVd+4H4iOWWrpYQEH4SzAHYh34aOEmrI27w8NKgRv1E?=
 =?us-ascii?Q?6MRl7ugowHsog71AsOd2Iubbwi0OgT4Am+HX9UIQcyumeC1fl0e7RZt3y8O/?=
 =?us-ascii?Q?wGlD2edw8IBXgk2DcPnYoq4QHfR+Eq9vou1yke8XE8eUnSH6plnvKW/dQl23?=
 =?us-ascii?Q?E6elGIbfbvQEjZaiNSDyr80kJ56hhDcuaamqEt9noBS6/jS4RgBBc1+JGHdl?=
 =?us-ascii?Q?njzqahap25xs8GwCdYjhA3FaqggUERdIbr6U6EpIRfOuhgppaXh/yNfEC22w?=
 =?us-ascii?Q?JZGg7q9VsLgizaZr6PVJBs69unJMcMZqN3fOBW7IxAIjurOveLaMzT4W9tfb?=
 =?us-ascii?Q?TNhD+auYjIeE4kNooRppsnyj5GDjQSgJCGmPxOpk82FujtUamp+LIgxebctW?=
 =?us-ascii?Q?q2S8K5/QpZq/PE/8Ng9ifBq9rjxP6cn/sHIu73wk9EQpaagUkbNGuWNKSIk/?=
 =?us-ascii?Q?6mFbuV8pkn1TSNDaHZdVEref7GkS3JOSyM6r6sLikVBB+8s5ugaA/1nVYAwe?=
 =?us-ascii?Q?sqIOYJfz/NgSluhmRa2o6nX9Th2siISUKgHRCF2who+O6cXI5AbzTX8QCX1r?=
 =?us-ascii?Q?3ek+i9o10Vl8SQhp5Bb0tnuR8iK06XysaVOK6H4AihaK6S+JHNiFdBPW6DH3?=
 =?us-ascii?Q?JS1dxs8QcZs6wQNVXYa327rECWAddi3TfgkcdeJZ8oxnKDjbV5JC2WZtUjsI?=
 =?us-ascii?Q?XNT3JwCakXg7aRdwO9or77H6jYI/sAne+pgQOrjm+ZykCRIEfp2ZnxkJVW1U?=
 =?us-ascii?Q?Ut+IKt6A5GxgsJQTycfz4+jsv1jltlz3ydW4LYVoiUMUIJl0MOLxjr/CPH3f?=
 =?us-ascii?Q?H9PbwvpYv+tspcBVXzb9soNsHJWYg9xohz2itk4z6lFzp+HETfFbuPNdPyz7?=
 =?us-ascii?Q?aQlA44MS6smbxvIjd3Mh8zr8235qW2WPmxHaZ5/MVN7co+JeluHUutIRPntx?=
 =?us-ascii?Q?4+tKbNdI1iAwnjrdbl3dxmpQ6mvENBenxcyfY18/y7XS/FMctpKGk+gv3EoX?=
 =?us-ascii?Q?s3rfnc40SfVKc52c770Ihb0pt4JhUiqnIBh09zaAXLKOc+co5cipWn9J8n4T?=
 =?us-ascii?Q?JKyziU2nE5FfryYx3cPnVvVM8Mb0DSXVjRe7XIFk9A5fgFMk3pa9XTv6lZnM?=
 =?us-ascii?Q?MicETNZUizu4/AxzRQzOT0pHzIJHtiHsdQNX6HKOBetxrg+ZKwtiRVObuV49?=
 =?us-ascii?Q?S8hFYWYSUTg/TwnJ7CEH1uV869QWIjbhVZlnlRdTIajiQRZm9TH/Quo+uSx4?=
 =?us-ascii?Q?D3k4IMMbyDRAT+JwTuXp52GXUOF9wTOlEN/tvI9d?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ed9b1f-e914-4333-8b25-08db94bf8cc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2023 07:51:02.4122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b5kS8OiBVWVSu8rCx13+t3wCZTmfeD6OGnECANisHWJN3PsWqKOyFMlJ0aIlINulEnQntkvNAY0meIqQgvavnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5178
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

one is moving from hw_data->csr_ops to hw_data->csr_info. apply to
all qat drivers.

the 2nd is adding new csr_ops.

the last one then covers bank save/restore.

> +
> +#define ADF_RP_INT_SRC_SEL_F_RISE_MASK BIT(2)
> +#define ADF_RP_INT_SRC_SEL_F_FALL_MASK GENMASK(2, 0)
> +static int gen4_bank_state_restore(void __iomem *csr, u32 bank_number,
> +				   struct bank_state *state, u32 num_rings,
> +				   int tx_rx_gap)
> +{

restore is the most tricky part. it's worth of some comments to help
understand the flow, e.g. what is rx/tx layout, why there are multiple
ring tails writes, etc.=20

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

