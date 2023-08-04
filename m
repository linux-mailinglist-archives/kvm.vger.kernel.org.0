Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0547276FB6D
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 09:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbjHDHxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 03:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjHDHxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 03:53:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26645B9;
        Fri,  4 Aug 2023 00:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691135582; x=1722671582;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ERlC59yM2pRDg/TQRhWSgf7iIgVkUj3dvNF18qZ3nz4=;
  b=R7wT05R+ao3YPbf31E+2O91+iGn+hlNCYgPrHb4fABkiA+H55vPFe2U8
   w77GOpOLVkyPXTZIXjaCBoFP2LWK/MM2fplbv50yCRBwCfWV7Nqfd9c4e
   tvWeNe70jYeP1IMiS+5Ek3ICCCwWGXwf8wPFplQZ7k1Y0D8qMkXBlJaCe
   8uhZPZhuWlUMG7jRvy/VSlOt6ziuzbOaZEmV54M4a3M3JYaRBjjfjfW1P
   LUYl5EDjmn9/CO4+Jx2A8w7jaDwdLEB7ZmBp9ea3+gAyBlGNJaUl6FYzi
   XWyHM4PC8/xsjbn4/ZSxO9IgFWNcL/nbX4ZMvFRC77tFUIiwj9Qej+xLy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="350397263"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="350397263"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 00:52:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="723546365"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="723546365"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 04 Aug 2023 00:52:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 00:52:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 00:52:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 4 Aug 2023 00:52:57 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 4 Aug 2023 00:52:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rl9c+OQoT1vDIWTjUwcEMxHYw+ix5j4dKF803/J4c9dMfoZmRXr3JH8DCpmZ3tzB1F7oJmYQbhm83cVrtj3qZDfOJApVWexLGfD9XifPzKQd7aAKWOwf4+CA0wBmGDo8Z4Ffj+4w6CB3yzoJSvqIzyLz67zi4pI9IKcNLD+RbI2fsTSwHZNnUAzkCdANkd0lkSUgTuLegZq9GJhYkdtMbpV8CDZwSi8kcy97ljwZumpd0PoBh2K7NoHKDpFPk9pbqz0hR4vq/Frjf8RHbqfjSf6+V1T4OoeVPMGtTs+vArYGOKdxs1Ekf0vAZuL4DTBpfCHAqD/733IWjEbhg3L25g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lu9rAOdAfJMtANEXWdL+kQbOKpCOyn/NLsKJEhVZuoY=;
 b=dT6C+phJrrDFL500wtALT59abGZZefkiT+hlIbUW2aCfe3akM9q8MdrNvTwSoC5qyOw/Pm4SRFjfkVrcsgIesbZfDMhrToCQfRCCxrFRddBJsTsMXusxjK/NLHfWL8wHXUn2QOfso9vwu0Y6GRwH6FOrRgJ59/s74WjsPDz5on+uK0ZkgN6C/Ytgq7maBfzi9A/KMi10zUfrrnMi+UnAsUQ56jKNCA2ibVQ9Rdtl1Z0FIIDbVfwIiwzVFF2V0QQ5bSPggz32P9BDqgEnXOKfh/AUZG+YxFCyeLmaxXhOqOMktQNQSHgiYhClxDBj/fQz+tZJPBvSFF2pRvM73mRvAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB5178.namprd11.prod.outlook.com (2603:10b6:806:fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 07:52:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Fri, 4 Aug 2023
 07:52:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Zeng, Xin" <xin.zeng@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
        "Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [RFC 2/5] crypto: qat - add interface for live migration
Thread-Topic: [RFC 2/5] crypto: qat - add interface for live migration
Thread-Index: AQHZq1V9pdto9yweQEqSLMMZrjB62q/Z+jDQ
Date:   Fri, 4 Aug 2023 07:52:54 +0000
Message-ID: <BN9PR11MB527644B92CE171ABA202E6AE8C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
 <20230630131304.64243-3-xin.zeng@intel.com>
In-Reply-To: <20230630131304.64243-3-xin.zeng@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB5178:EE_
x-ms-office365-filtering-correlation-id: 57f4f578-7c26-44da-73f3-08db94bfcf54
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KvK3WYYeHtXnh/wCiXrDlSN2w3asSMeUv/hozAjB/iCnwGswztZfnl/znCtGkNemJovIR+Eue9M/HDRCxoFvkYkB6DVqVWgjD/+jXVrEhoknT/Rm0lcHTI1EK/yifw/amPvLitOx5YTo30ysWjcKKbeaH6+NvqSRxj/rmVg+QFKACQhTokFIbmEf+UCO3iZiLjjqkO3+y4D4hXe2eUSn0JxT4OYvL2lRnlW2T7g+Oz54qVA171vQYxuMDFRuJlFR6FKJeUC7v+jqNPsg9Bw5XHuw4C9Rvyju+2/DtI0ElJ4r700pHd3R3W1sMF1mAvk1WvlRYJ4B3eFPVCCgaH8lp2Zx2ofJrWegrImWBEJLiD+ddPTqnL2okaDkzzp+ELXes68urrcRfrJ75w7DBIxA2ciRooWKnWTh0r3PVR07AtRHWx3b5p6BBDJhp6BsvYTlfQeNgiaxVUqfJET4Fkm/I5KgW9PGPEkJFE60eUuxsD9w6DymTlYjZo7KDvk0olpB7GIC2dgdLULG6uCp/Y8CJxQxQxch/ogBNfIIuakFTsJDHa+OVC+Fg9ehc0d6BOi3NWrElhDWYQqv85+DoILwqsVPLObHD46jT9ePl5wdz8E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199021)(1800799003)(186006)(38070700005)(33656002)(86362001)(110136005)(54906003)(478600001)(55016003)(38100700002)(82960400001)(122000001)(83380400001)(6506007)(26005)(41300700001)(8936002)(8676002)(9686003)(7696005)(52536014)(4326008)(71200400001)(66476007)(4744005)(66556008)(66446008)(316002)(64756008)(5660300002)(66946007)(2906002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gxXxHprSvqMcicaUntn26t93TPGy2UbmYcRdxR2VCGh/SYbobToT9T3eOQtf?=
 =?us-ascii?Q?Bd9BD5ccOxvYXq/NzzV3tP+aFZ7gPG3mjH+7JycYhb6plRghEeGs9igtvkbw?=
 =?us-ascii?Q?qayCHKe+ASVOU8eDx4r7sIatPxYzI7suLG1XP4ZVD7PELhFejngRZcIuqV84?=
 =?us-ascii?Q?wWKIl4XRgGCQFlan+BDUafdcQE1k0KuU3GnH/RFljULWAG1kHsJXEczZPstL?=
 =?us-ascii?Q?qhjDazY0oAh+53+AIljg0YH5sbxLDVpxX/vwt4TN4zlxbRX+ZxvFDfQlo6LP?=
 =?us-ascii?Q?YkKNiFO0DQ9p/xwf4Lc6cJPfVxIfIz+oJew06240ZpKnrnW3OroNuF039fzC?=
 =?us-ascii?Q?xJvZBzzKMKTUzi8zEUMLg3LORxIT43zbeA+f3+JM/45aZksPHxjfJ+8LnTHY?=
 =?us-ascii?Q?eJghY+8cvHlraqExDd5MXP23J0H/AnyjzTQvv3ehLaQYdJl/3eF7ktqMGhFA?=
 =?us-ascii?Q?oRxzBRiNDE17mGEG1Wgyp0rWUuAq4lue12oUEbogDHRZWSx3P9SGU7dYQGXf?=
 =?us-ascii?Q?DqShvOMNi80yfezlUjuT68o75CQBw1xBHlS305E+RvYeGnTy8dmyYwGNhhgH?=
 =?us-ascii?Q?Df+GLDdtJ2fTotJzoZCHDmGxKfjhqVRlA6ofBPfuyNzyx07oMjXSXJC1T0Vl?=
 =?us-ascii?Q?ZbFFdTaH9bsc7WtXAPcakj5A5wzRjZ1LBTQwNdBbjhmCDq5kpV1HiP6hO8de?=
 =?us-ascii?Q?uUP/cOiR7f0jTpOj7d4SoH3/LyCOH4cZ0qBY9XI41aktenBut/tK9IJ0yLpa?=
 =?us-ascii?Q?p7uM4ZYEOocZcfoXHeZ7L954IJxXklzUB0AvPR8K5QwgZsjtnvsp35snKUOF?=
 =?us-ascii?Q?Cmka6R3qkcXd7uOwljwrbgz5cRCOHJyceC5XPIdkaP1EQ7uXOg+0H/QN5/bH?=
 =?us-ascii?Q?QTa2npE/39BIWOAYGf5ZU2eiEpj+VIaje5fmt3KNMD2yTK7ZzmZM2LR9PPTq?=
 =?us-ascii?Q?CpuNMlVeu8fnUuyLpieTFbVm+ohHG7yyOZh0Fkq3r5zPb6K+CZUBmN9qd2DJ?=
 =?us-ascii?Q?T1WvODn3u2w8M9yp4RmPLw0rjkT6ljbzoehtxedsVeIPPbqlnzuLt63TQUhn?=
 =?us-ascii?Q?dGtEv5cZAJMxD+YWCx2DHE3phj9E++G0I+NN9RUSVBNmYYnM10VtUe88KBJF?=
 =?us-ascii?Q?TPjA+iO2Uwdye8lHFpEPjua+U+QcuauAMBUhdZZmTrM0TyteV3vWs3hr6p3F?=
 =?us-ascii?Q?OyHce7I5Sge0RzmQWYQUoxl7H0HBnhmDtIXBvHr1wkDfvKbrhNN9pQiPb6la?=
 =?us-ascii?Q?XegDJmD6ZtmWrXZYH077DDdGgTGzpBETfEQAM/0hHGcoxf/G0eycvLD2CJ0Z?=
 =?us-ascii?Q?JjclMveZx0ReFH70mvwSd6hke1pF7NMuuEjw/yXrQzyV4sUZIoUJmy4OIIbj?=
 =?us-ascii?Q?QHFdTyoQPVZ+DVSvVvWmhiWj7dvkcj+nvKI0hVY8xqLoUbQefnrbqf9hU9F6?=
 =?us-ascii?Q?V2xvBUq8Ye3Y9rv5NeZx0bKlZOrrA72lkZbZLvy3aJQ/yGHQMozAS2FWPq5t?=
 =?us-ascii?Q?2QPPgxUaz1vLfvF14P3O/y7TRag603PUhEUfKqE9AbgKjKYRdWIizJWeXRzd?=
 =?us-ascii?Q?2v0g4/zHsPoZQTSqgXeT5WH6liujyYc8c7kUUloN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f4f578-7c26-44da-73f3-08db94bfcf54
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2023 07:52:54.0592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0cgOGfyioBkohhNWhVOoklOzxoL6H4DK7qb5lbkDgONKGW7k5Gf3JtIt96NPVUq/sse7xUw2TMWSHFvS1MjhxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5178
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

> From: Xin Zeng <xin.zeng@intel.com>
> Sent: Friday, June 30, 2023 9:13 PM
> +
> +int qat_vfmig_suspend_device(struct pci_dev *pdev, u32 vf_nr)
> +{
> +	struct adf_accel_dev *accel_dev =3D
> adf_devmgr_pci_to_accel_dev(pdev);
> +
> +	if (!accel_dev) {
> +		dev_err(&pdev->dev, "Failed to find accel_dev\n");
> +		return -ENODEV;
> +	}
> +
> +	if (WARN_ON(!GET_VFMIG_OPS(accel_dev)->suspend_device))
> +		return -EINVAL;

this and other warns should be done one-off at device registration point
instead of letting it triggerable by every user ioctl.

