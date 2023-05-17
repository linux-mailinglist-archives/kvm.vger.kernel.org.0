Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A48B705CE7
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 04:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbjEQCNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 22:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjEQCNB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 22:13:01 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA6159C0;
        Tue, 16 May 2023 19:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684289580; x=1715825580;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T9s2CKzrFGaND3vp/Vh1i168HVtTRkYFB39NwDTejZE=;
  b=a/QpV/VXVjSGc+BRaPl0jKxc3eV/eqavn+og0MToy6QNhDzLRrHcZ+80
   pYN7y1wOp4jYgb2CszXZMyuAFTPPguCi3BnLHoULMl5RoUszJQ5Kp/dBZ
   K3fjLXX5MPG2UuEvUYwwldmr3vVx2uae2eXjyz0YoBce5DGkQo8aUV6+G
   bWRsR8s71byz1omSz+TlMIQg175OZv6+7lNEtFjqzyqT1OCks1cKk8IOF
   Qiu45Hu0D8jrbJ5v/mrCgHuqNwowUg59vJJR9oxv6zaZDzRQB4NDDE3VQ
   4QbXPE8WDtcjGPzQ1T+EE3U7jEer4+Wa40bU3GM2+doAO7Itlq1ZcyIc/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="379830195"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="379830195"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 19:13:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="1031517399"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="1031517399"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 16 May 2023 19:12:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 19:12:59 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 19:12:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 19:12:58 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 19:12:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsRtMsjwXrZwvrOp2bGc1MSpPJwbetbPOj6ABCnPdFhVRBqB46tlmGjFljreE3VUCpSe2+8vZnLCtVhxLPQ/OR1zyRiOlPi82c4MMMpcpQETcdXGGIhAX0g27eJBZ1gceFDZUAn2RnmlRly/+K4YU5HnvK2N+dC32zUiIa28UVMeRpNFqxzOCw9P+YfTrSEXDxHhGLuxdNpwysVrlswL/X/oHPUobwSpL0cwYqX/y82oPV+reeC0fx0324G9vT4S90cmnuh+p+Bgb/zsuX27LT5Q8pI6vBXxeqUQ1drnNfd0i8fbwFlENJA0VD7D2x5RGeptd58yABAJkmLwDM/c9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9s2CKzrFGaND3vp/Vh1i168HVtTRkYFB39NwDTejZE=;
 b=gDNRHFVZlRwMEzEELN+9ZN8NDkh4D1ZGr5m98l2d8hC01vMmlbkdCPG3jmh3N+C8AXdKQOqPMm48AK0uY1O/+rCzz6eOVaYcEv4GXP5L6O0Vzy/bjpqlac0EFNp/0DboP/O0mG1aOGwA9r+36WwYGnsBnTBeNhDnL+GP+sRrQJkaQEWFoBF7QKEK+Mv/LPRCO5tCGpqtm8khleSOg+Kqg42TRTdikaW5xWQaagnNt/6v7tTZd4vxPHat4rhFwCiBsvu5iEhPuM7aLJUjM+xnyQWTiPRe6yPCVHD6eQSrUdjHW4M1N1QA044yxK7vfwThDl3MAWxZ3najKTTpHNUHGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7568.namprd11.prod.outlook.com (2603:10b6:806:34e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.29; Wed, 17 May
 2023 02:12:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 02:12:51 +0000
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
Subject: RE: [PATCH V5 07/11] vfio/pci: Update stale comment
Thread-Topic: [PATCH V5 07/11] vfio/pci: Update stale comment
Thread-Index: AQHZhB+NF7QUuDWNCUWqHikFOzgle69dwddw
Date:   Wed, 17 May 2023 02:12:51 +0000
Message-ID: <BN9PR11MB5276790EF2737179BBF800F38C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
 <5b605ce7dcdab5a5dfef19cec4d73ae2fdad3ae1.1683740667.git.reinette.chatre@intel.com>
In-Reply-To: <5b605ce7dcdab5a5dfef19cec4d73ae2fdad3ae1.1683740667.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7568:EE_
x-ms-office365-filtering-correlation-id: 0d5c7164-5d52-4d0b-0c0d-08db567c37f7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e7k2SWa0YVRg4lURC08SVeWx4MNsYZD/LZn4dS0bavUrRE8r+EAgoU3I9NhqnoKNLqEC33HSOLCUpCUBYB0t+CIHTUdiOhgTL7yg5c/i1EsJ93hOANqpeKpnkusJfPdlbFUebj7z3K9zzroOaPbCz0NbbUXQRj2z1eOyVRKHlk/PbQSKFBhyRhGS41HgiqhQLtCuan9T4lofgct/g+RNZkl4Nnq1wCExK++NATTa4dhjLZCYHxBFMSAK1X9MzNdwYwOpGJDigbZJ+vGMShBfdQsbgJBwqXLvaGELL58ikR1g4GrvkE714VBRpAT3Fh3ipzqs2npJSMu4m4gDjl6ZivX+8+VcAPeIpeBJfyvcaIs0ECIoluR/AorB5sKFzZLYQUt43ZwENdTHD2xU7lPEQV3tRn4LPgpFPbKjY2IbhieESW6WG5uK+ZKiJ/ko/JQ+VxTBSykeqAQhmYqlcT5n3gWAF2R5jYrStfLhfRmrnRKgQJcBDSaH1YWsVq7tr2y1pSLOf1pozO0nm5ATNUMKGfDd7sgNIRnPVhVBq/VFLUadDLxhd9tKa+oxiP2W2S54gt7rJdUHtGuq6rX9fFXk2CQeWoASQoipEeYe/xOjb6U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(33656002)(966005)(316002)(86362001)(54906003)(110136005)(66946007)(76116006)(66446008)(66556008)(66476007)(4326008)(478600001)(64756008)(7696005)(55016003)(52536014)(8676002)(2906002)(5660300002)(8936002)(15650500001)(38070700005)(82960400001)(4744005)(38100700002)(41300700001)(122000001)(6506007)(186003)(9686003)(83380400001)(26005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H3iBNGlClJ5qHZYg40ApoDQ8LBZQnRVu9A5hKqmwVllZ6mpccEARi8Ltih8w?=
 =?us-ascii?Q?m21bzER6iRsQ2fjsxwXdOQefjF01s1IxYnd/7bmiB5BrzYS3ACBVg+Rfn5j3?=
 =?us-ascii?Q?yd7NnC7aDQg2sD82weC2z0VzHARWuSJFHgimiTnGj0rHeZ1e1lR0i8/kqxk8?=
 =?us-ascii?Q?NOE1tVvhV8SkK4U5BYBC8DiIgKCkOhK2ZFP8jQaqm/1TXUbYPJ9XWxFk9Vy+?=
 =?us-ascii?Q?cFcdRJHAksrGL3yc2VXlmpE5pI2X9KtHJ7r2ZMI53fJ4JFLtYlBkDJFDTLsW?=
 =?us-ascii?Q?pfs8xNQE5cM9FU2umr8A9jfBJppqA1qMlcrg74ltC1i8bkxGjomZ2WQJlUtf?=
 =?us-ascii?Q?LkcDyClLEuyo+OvAs8RIyTKIjTuK4gvQRpgdOOl8p+4kyvIxM7sU/UlVkpJ/?=
 =?us-ascii?Q?P2C/Ystk+Czm1F4BhoDriyfKGzhsmBgXlakbFuWF5TEVRW23PDIOHNN9uWna?=
 =?us-ascii?Q?0Y/czOe9W46ykgFeKC6ogHZK9YNBbzi2ETSBZ8vaK8RcGNNr+Ryotku32lRS?=
 =?us-ascii?Q?ulClYedJr4NUhsoBPpCRgcm/SHGwx/ddydWsJa44Ggf6r92ujT3wG4HJheGz?=
 =?us-ascii?Q?+VkJyPdAmfle4QjBcoGoAR9uUXyoHmbhGexpkmebCwCHl9NLxwVPAQ4PMDor?=
 =?us-ascii?Q?PksVJ2Y/A7GsRH6qZd6il/pjFkZDziOIHFlJ7q+etu4y7/Gd2yUn+rbGto/+?=
 =?us-ascii?Q?oTH3cGkd5ANq1Mcs0uluH6WaAbacBqoOZpfpYsftzy8m7ODAkS17CgKdUOGf?=
 =?us-ascii?Q?oXQuJFybQJ1GffadWU+rp/vUA0l/pXhK6Hmnkkyo1QxSBYw4U49zfFQEZaA5?=
 =?us-ascii?Q?5opd4PTBWtim9up1W9mlZ/2CyZzEpLRh0+jlWyDdp8MLfKzTBnFw/YGTczfR?=
 =?us-ascii?Q?MovGtSu+LLegjN8vMXUBhOD9e1xRfxjjva7u2SXJhfv2Ea6EjOHkv4ny6srX?=
 =?us-ascii?Q?RsVVZELq+zKgl28PRCaQgshrn1QpccHuYvPwcVYoTpPNYtJz0jWjC7qce5AS?=
 =?us-ascii?Q?pE9FfXg9XDRHirUhdpLkzDk13vxY5l6XLDhCxyh5tSRTBpt5ILVmnEopznW+?=
 =?us-ascii?Q?CzjiZHzfmE7FLGFxeaHXBtXK4uatIYGczP9TSQekDmzcr2h412mHbdfJgYTK?=
 =?us-ascii?Q?rkWxf3IK9lhlkxTdTMQxPeRR86FgoevbO4wiS5cACrYi9u3kS93S32d0MNcc?=
 =?us-ascii?Q?2gYKhyd8j/eHMnYLldGSmubsp4WK3qm/KQz0X1y7UOqcD//9v2+dRVMpc97P?=
 =?us-ascii?Q?1GATczz2CZZ0ya6UUChW3/bDC48sBT+1v9ChuZJYJsbZ4KlVhAAeFrmGHMve?=
 =?us-ascii?Q?lM3tS8E4DJC10719WPE7IMaQPEJEmMnQC+AlOlnC0anay4MqWNXkRSew5Wcd?=
 =?us-ascii?Q?h+O4tXedvgpGijIh4d+gLbrYdgHUOhipZuTxCrqXh+toRcZXNvwAj7dlcPe5?=
 =?us-ascii?Q?2Utgj07BMzTNBHhzxJ1ZJ6eeqr50Ud3PtkSl+XCfg3awyx5054ThpL0xEFvm?=
 =?us-ascii?Q?KZiTIP6DVYtlz7N1GGI9yOIfoO7fYql4nyLEksUFJLxp+uSiCoy8OOWD6yiZ?=
 =?us-ascii?Q?01P2sLmY0BCGwNGs+kJBRJoucDqfkGFi/ow2BXLb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d5c7164-5d52-4d0b-0c0d-08db567c37f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 02:12:51.7332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yPbWxPPQWd6Olc27oOb8wfH3q7m989EGhwkvcR2p00JAjVw+0ek6qXVkvK3d9vF22KaXxzA9aagHoyUvBeFufA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7568
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Thursday, May 11, 2023 11:45 PM
>=20
> In preparation for surrounding code change it is helpful to
> ensure that existing comments are accurate.
>=20
> Remove inaccurate comment about direct access and update
> the rest of the comment to reflect the purpose of writing
> the cached MSI message to the device.
>=20
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Link:
> https://lore.kernel.org/lkml/20230330164050.0069e2a5.alex.williamson@re
> dhat.com/
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
