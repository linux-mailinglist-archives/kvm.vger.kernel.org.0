Return-Path: <kvm+bounces-63330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 50A21C625A8
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 05:55:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 50FC3361944
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 04:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17FA5313264;
	Mon, 17 Nov 2025 04:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GXfloESe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45606225A35;
	Mon, 17 Nov 2025 04:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763355132; cv=fail; b=qwQ7xH2zQBhcEm/eGvlo46C9Gq0y/w2rtZfAviVgHbX8+Y3ppNpSip/yoLNxkzejvqJnp0KigQ5emh06WMY8z/jMCnnO4cn4Ic6o931JiSseSDoP1ivu9hSEvPQs9S36UXEoLG16JXNccTpbM8KklE8YfcXiDbVyoFT/Z6zSew0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763355132; c=relaxed/simple;
	bh=qXrhoLJfnfZJvqQ8dt6qx0+MhIUMIqKU6coJQ2Npdx4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NmJRx9Mn1mFpMyXJvjzm2c6eHM3l/yr4QDNZ5PQP5itxCdNajAquxQw+KdMx3T2V1Mc955PLwz/doK6CmJAhVKnUz4Sl8XZWZdgNZAki7dnd9wIDijLFZZvtPpP7xjZjntrEeZXCViSGDOYyA+Dmk7NHhhrq0gmLUEQSS+RLq0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GXfloESe; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763355130; x=1794891130;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qXrhoLJfnfZJvqQ8dt6qx0+MhIUMIqKU6coJQ2Npdx4=;
  b=GXfloESeE6qmgbXkBb8qHRpEDJmOQqU8VqEc/fsCjsnwB2LIukd8lbYk
   TLbvaWEqXWR5jrUTPRmpXpZ5LY03X3bD7dLN0WYUVQ4h0/bdKQ+h5X5vk
   tnG7S0WG0tQ3Mfd2FCg3Iqu2RtRwFeLqZj0VuKZ78h2u5e8qak8G7hPrL
   hYPIqFAc5j5eBt1DtS8/rlWwK9l1J6evVL7dy4ksw4trW80FywaBS1pAC
   eWGuk520uPFWEhoOEUGqD2zGmHtWcDWzUsIQDhDiAJpaQdl8Vwi/EVZ98
   PM7Bzol1nYSLyFiqmkv0CxWDboljmlPwitqh/RNjBY1DILO9Y8i4nwIbZ
   g==;
X-CSE-ConnectionGUID: APBjX5SMS2Ctm/2mDAMJSA==
X-CSE-MsgGUID: pGlovVrkSE2jonQvib4iuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="65059118"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="65059118"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 20:52:09 -0800
X-CSE-ConnectionGUID: +VBuYxSbQvOqolhiD8mRKA==
X-CSE-MsgGUID: 11THVQssRE+Gn+07bZuEPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="213746540"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 20:52:09 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 20:52:09 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 16 Nov 2025 20:52:09 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.43)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 20:52:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q64utWFopU/OiZlLcYMHdYYhGIqHAAXilitk9gVhQnavGPQkpHhPRopDpdkqlTDZygZ7hhVOEtAycpFNhh88x9O4aOaIAcEm7ai29T4sPtrSm1AGgBkH4ASZm5oql/U/1WnUPmnecubxQzwnNSefOYLARlDdOoepVc4ycUxWKJIj6FmGyTEqtM9sTUWqoBZxjLYx53l82I089BgQoqXBlXXnHdZWffwP+c0s2wMMKrH4xLc52GY8FOX/ufe7qcsJSIKPvYMFvawSQshS/VZPm1NVmyByJWqjr9O5wXOtVUJ90xpeTHdsIUqSpZyKBBqCMvJhtVl3AfWUfK69fYUUDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVpjkvIAFujTzLdeNxagXAYEIc+p8n8AOSzHKs7Xx/U=;
 b=IGw8MPbFKZabfIOMbXnw+hwHWkdAB/8OWReM9h9q/8eauUFG05LbWSV4x2UjLkYi/slXRAgSTY2NBCtre6/gD9v2yOWBbJc8ppwupHCGhT+738/DdEi8Tpw+a8w3PdQ4I97RRy7I8N8DQ6V89NXAy5ojVjdGxQeHvcSJE2bkkMLshKSPHjkSPvBpRqq1lJ7gMf7pxdejN/Qy8GvRG0cLgeQhF0h6jtlhbcGRDjku7KZzI009CE1xCB3sYLgBQ8V23xmwGzUEyW6p+u7dqqd0uZNpcg7YxFyoX3p6p5B//ClRGEtjzMCfTcY6j33xBmZle2W7pNl8a9a+E3WC9a8gyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM3PPFF3DEC9799.namprd11.prod.outlook.com (2603:10b6:f:fc00::f61) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 04:52:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9320.013; Mon, 17 Nov 2025
 04:52:05 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "afael@kernel.org"
	<afael@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"alex@shazbot.org" <alex@shazbot.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Jaroszynski, Piotr"
	<pjaroszynski@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>, "etzhao1900@gmail.com"
	<etzhao1900@gmail.com>
Subject: RE: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Thread-Topic: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Thread-Index: AQHcUsnzy6x4f36ohkm++SV8i6qV3LTx7zWggACMYQCAA9kXgA==
Date: Mon, 17 Nov 2025 04:52:05 +0000
Message-ID: <BN9PR11MB52761B6B1751BF64AEAA3F948CC9A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
 <BN9PR11MB52762516D6259BBD8C3740518CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRduRi8zBHdUe4KO@Asurada-Nvidia>
In-Reply-To: <aRduRi8zBHdUe4KO@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM3PPFF3DEC9799:EE_
x-ms-office365-filtering-correlation-id: cd279431-86af-41f4-2753-08de25950e7e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?acs19deDGZ0o+xzvlfbCa0QURXOMU6SXDNsqDXjuvZQNTgWFayYrIU9m+FjK?=
 =?us-ascii?Q?9NDGqgPjijCyJh90F42USkI7Xor4FD1HMkUaeXucHnAE/J2ymnldCb/nG8po?=
 =?us-ascii?Q?e/owjQQgDO48YBnuYVTSDEZgIRueBUSWS1VjSj9IG8ogesStL6FVZ/CuyrK1?=
 =?us-ascii?Q?q2o5PnkqN+WweQ1gvKgJbE+719PsrgXYIp9QYaTD2d7CItphdgbJKebarnoJ?=
 =?us-ascii?Q?Q7cKC1ygVOCAn8yUw8riqP2d+nD7LDhMKmY19BCVQNzmNHt/KHRGK92VoX/H?=
 =?us-ascii?Q?b2uJEGzBhVAawX5pDfa6Gs0UGdZqrsp05xrDYZ6NgftBG3D6FoveHuF4tyOV?=
 =?us-ascii?Q?CPzZE6zw7Uv3JCH4fyxjrjgcKRr7L32i7RWQhXd2P7rtOZe8uAWeQXFw7E4x?=
 =?us-ascii?Q?uYWHoAxbAZDqqK3FnEjI/9NjYm2h8kbCFJI8LeyQpGums2AyDstHXnfQha1P?=
 =?us-ascii?Q?LSK0l6Easg2vFALLL/1Xx/huq/Sc5+UCwHHTMbQ+NEqLIsb3JBzlC3NdgN24?=
 =?us-ascii?Q?wuflY6+dEbNQhpCeTq4dCIEr4nV4E8A6ZAU69FqHy/l/B+zVJnH/gI6r0GqK?=
 =?us-ascii?Q?xHCWfKLqXEcRfNGroGNm8iYKCHWtf0cM5rWhyNBO0oMDiD/+TLkfEFV0T564?=
 =?us-ascii?Q?FWWacfPdWB4x8MuWZKWU+naJVUu6va2Ns1kqpbVVxK5gWb6Cyb7fTZevVDc3?=
 =?us-ascii?Q?XRyc7f9UyKP2z8b4aXTDneNzYQvJQCRCaWfOnYFIgZV3HRyipLPHFWWFTLxD?=
 =?us-ascii?Q?xbDPlzf/++lnc+huE3HLzqi+9QDfIrr6Z0bvlraRFqpCLfOg90IOobYz8UEp?=
 =?us-ascii?Q?Bz1k69hq5o0GBrrjjggsMq0E1EvGrFujL6pycjvFLnlKAqPqR2X5KenKHsU8?=
 =?us-ascii?Q?4Ye6TpWVvq7bBrE1M3NZAZV0u2VmcFr4LTji7XK8LDU0KBJ99MTTauEW2d5D?=
 =?us-ascii?Q?ZQc74FilP3gK/z6EOZ8zcjinq5Y8J4eEn6pmmKBM+uNEabY+ivwNm5maPYu6?=
 =?us-ascii?Q?MzwidRPgeCZKCbYj4zN2Q9UyEAGwKcID7GiLc5CH6UzLWPWxQ2RGYzs/B8kk?=
 =?us-ascii?Q?Zq4tBJIokJqhk51eoNF0G/U5unUzuD1BUxPmXivHnkTozPHOByitpl/4GIZG?=
 =?us-ascii?Q?k4UauWSChtyxfP1F/tlfeZHnbiSt+jUO0mrwDhDQnY8gV+9hO4lqYuKUWFKQ?=
 =?us-ascii?Q?u5NSTYy4OMOYk92qqRgfxS3CM+V8q+VWivnWRNMLQDyV6AfhCZhdLm6ZcvDD?=
 =?us-ascii?Q?U+11fZN5Nw5sw8ZHi6IiW5hJOPv4Pt6nN42uSxjp++ElGBLM9q4dWuwLfF/v?=
 =?us-ascii?Q?vG4TPj4GNPUsjsHB1xetbcVmy+JoVYAlxXiJUSZx2NzSVuvHzmUjIq2SIm0F?=
 =?us-ascii?Q?DXBcPcAFPaVquGyMbvKHD7QdSkPisgslu8tG8B5XgMhtIVOcvcvQRIChbHel?=
 =?us-ascii?Q?BUB+I/xOgoZOSBn1kup4QoP3RHjvc2OO8ziV03XP99ng3QYsXBrQ51IXTIPx?=
 =?us-ascii?Q?L9Rc/NpFUP+PugwTuHSs9fgtgx5VqaofSok5?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PjOPmYip5B9u5u3Zor0GoCLmrfigVh50WMNkL+kzmVHiy9JzbRU50x/eNjfI?=
 =?us-ascii?Q?ZmHOiVu1+x2JuzxQor6Rj77qtInEB2npENSXjp6YgcaeY9Hl3Ea/rhDFSAsK?=
 =?us-ascii?Q?i92ExGuu/yiRtDOIB8zlPyE+hVBugTPuSTV7DuPns+8y3DOKbQAe5eLlo5BT?=
 =?us-ascii?Q?7D+Yenyp0/P0qIZBhId6meYOfPiFmzuzD+0WFPluhlPPg4Ls8fTebo0W0NXa?=
 =?us-ascii?Q?rjtynTNJRApFPD9wyjANyUytzuT0CybYXTmgchFA9zGkzY/K/hc8SGrJX1vs?=
 =?us-ascii?Q?IZHz0UR0TGGVDK+JZrxHIYzW5nyKTq1hG/m17I3T85mrLSaVCe4hYlHB2Pjm?=
 =?us-ascii?Q?LYBBf8Mgd5zWnBm3pR9gnnIDGpg0W49e3/nVoOFeGmU9UsAUlFZb9E5SH/pf?=
 =?us-ascii?Q?Ynp6yHBg6RcFBl463ss2LpWqz/mmXiFrvtadNiOGP4O/1gJciYA5JLlHf10T?=
 =?us-ascii?Q?aZPGSt3golJNybXARs9TCieRZ+pXTxY7tOzC/ZikirFjQW5TgigQjG4kRQV6?=
 =?us-ascii?Q?ZFOQAiWzV6ZtmT5WAHWxOijS64Ip8nO0ksTtWqr4wf3D+A7LFq9se6OtFI7u?=
 =?us-ascii?Q?DvkThluvaznAJMMJCLMnkUzocNRMsP3hPvNe7w8eWBtlmi8GoMZc2mf4tOHq?=
 =?us-ascii?Q?Yp6UaXPxwaw6TQiOh3fIjG5U6uvWPhy3bF3MQSwB22NYRhCDBHBcOqaXJvVm?=
 =?us-ascii?Q?ZFX0B9j8S0sDYUzpVe8aUILEKYjZYW1QG8jjF9rFmya3s3sU4D4LhLO3Ue3d?=
 =?us-ascii?Q?smjHfOVI6oiySWAiAnouUqUOhXsNxdV9x2yhsY9e64CQqkIIXi6FY8+7o1oz?=
 =?us-ascii?Q?kaAloQSscbcVefJkabEk9Ib8AMmXo8TQ8152TOY0zgdAEE6Q5xrsyTpGlxL/?=
 =?us-ascii?Q?F3VmW2Amd3YE1X8F0OBgsRUAyZMixOdmJwlkj8/YygxjcOSV+NPQW4kdBdwy?=
 =?us-ascii?Q?O3JDZub2+b8AAVJkY6YHnYh4GHuU1qosb/xqYGum5O3j+9vwcXaQXGrxaQUO?=
 =?us-ascii?Q?9xut8DvdWuLfeBJGeZ6j5ubXYsjy9kuxJdK9YoWkJkRNAGRCfXVnB9Xz+cDW?=
 =?us-ascii?Q?I/uzLrDea/lxIhWgtUSVByWC2ZX0DydWkGzL/CJTvaH/02KEbCZtvnSsunBf?=
 =?us-ascii?Q?McGYmn4nLWzaMggce72aBZrvJxiUYjR35QXbrxvEjFYycIZDNvnFC4YwH7oc?=
 =?us-ascii?Q?Z+lOhHQtsHBZreziJLvt9avajeptPly8+Ez1l+JMu9OVDMfwyiS7Cc9nLURH?=
 =?us-ascii?Q?GwwYti8GDn4NWcF2WZ1Avn6XPpQNTQgTvkorVS5yvqLtLxaalmEOppygIRiR?=
 =?us-ascii?Q?LLUXsmo07kefp+fFsdUAs1zu5y4/LTk91aL4wCtNqs7XM6o3ZUjsyw1+nPfo?=
 =?us-ascii?Q?PCxfziR9abzd8TUETJr+99tBgB/ILr9GC64htnDGiNcPIrlUFUWI5VH+Cmol?=
 =?us-ascii?Q?WhNd+5dwTNXaU9zLSQ0d8mLSBYeZEqzEOf87ZlJ9KRk6JkfL7gCVfCj9xicg?=
 =?us-ascii?Q?ITf/Hbmee4HED4G7889a/jBQvGmaobraQf07DfzaMV9rHuPwuQVPwo2JUWpm?=
 =?us-ascii?Q?m4e4vSolP8b6QkHSjVwcftXC1ookBwzGAwIM+f1g?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cd279431-86af-41f4-2753-08de25950e7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 04:52:05.6342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /xM5ZZeOM5w+vIR5c0bPqIuRK4BOA/WNJN6ZcO663z0tkSEQisI9pZ/PnOf7DrbfVSkIswI7l5alLonaPHNSVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFF3DEC9799
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Saturday, November 15, 2025 2:01 AM
>=20
> On Fri, Nov 14, 2025 at 09:45:31AM +0000, Tian, Kevin wrote:
> > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > Sent: Tuesday, November 11, 2025 1:13 PM
> > >
> > > +/*
> > > + * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software disables
> ATS
> > > before
> > > + * initiating a reset. Notify the iommu driver that enabled ATS.
> > > + */
> > > +int pci_reset_iommu_prepare(struct pci_dev *dev)
> > > +{
> > > +	if (pci_ats_supported(dev))
> > > +		return iommu_dev_reset_prepare(&dev->dev);
> > > +	return 0;
> > > +}
> >
> > the comment says "driver that enabled ATS", but the code checks
> > whether ATS is supported.
> >
> > which one is desired?
>=20
> The comments says "the iommu driver that enabled ATS". It doesn't
> conflict with what the PCI core checks here?

actually this is sent to all IOMMU drivers. there is no check on whether
a specific driver has enabled ATS in this path.

>=20
> > > +	/* Have to call it after waiting for pending DMA transaction */
> > > +	ret =3D pci_reset_iommu_prepare(dev);
> > > +	if (ret) {
> > > +		pci_err(dev, "failed to stop IOMMU\n");
> >
> > the error message could be more informative.
>=20
> OK. Perhaps print the ret value.
>=20

and mention that it's for PCI reset.

