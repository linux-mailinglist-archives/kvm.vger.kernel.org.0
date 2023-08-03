Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6563376E3F2
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 11:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbjHCJHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 05:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbjHCJHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 05:07:35 -0400
Received: from mgamail.intel.com (unknown [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51E8E53;
        Thu,  3 Aug 2023 02:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691053653; x=1722589653;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JePaTM/2T9+vi/NL7kZ8Jns0c6ylYA7WR+mapvf8j+w=;
  b=ZpADdwORwKfwZcrcSX2tFmE7Gy/gEIKbH7PsfOz4koE++jC5/2IzkcUC
   ZCwREswIAFsq3mCYVaRN7h07qdIgDm3PVdTMqNMiSJOgyaBmxR+xJYUjV
   8vGsNxPrq8BP/iIZqRpGkves5cNz+hn0nfJPWQjQthr8aXUZPLyQsjPaL
   JjUrsmF2wQrRODLslyVIKTwqyQCwtm+ldF2l/NEKU6X+IPYyZCrWJUpeL
   t54kJ+7ksLuZd3gNUFdfLBhLI4O2lcRI7qrr88HSprlQVAWqIyO0KJTCs
   KNk0Ou6HsypVadW9/HWb+nsivkpKFJS4rOqI6koMmx8A9lW9sRgegxWJG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="456197516"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="456197516"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 02:07:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="799476223"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="799476223"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 03 Aug 2023 02:07:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 02:07:32 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 02:07:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 02:07:31 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 02:07:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5UHP+Nu6YWp3z+SqQEDjBM0IIXa2aHGNrV9rb267675fsgduIqJ66UVnIkkapBhyqC2iV2gjbBXhMZv7gKtH8VGUwrVSR9OWscVymCDioOibIdf+BVRyoVpzLvsNwhVCGeW8ZyF1oUttI9b1FL4c7CE/s5ote/U2y3iorbIzrfNEMkWtPBgXCqQDP/8CWqAsZkO1WOxlFkYRCbOpXtT34BdLWTHgXTlZ7hjMav6gxaNgqxGSZcMVjGbhU/b/OIBYQnIZ3FZMWDZ+mPU2MWqVxaYiXCRhAjzhzVnAIgqjEOJhURLpNRq1tBfT3fWJk3Rfzey9EDnyxTS72dBwL2DqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JePaTM/2T9+vi/NL7kZ8Jns0c6ylYA7WR+mapvf8j+w=;
 b=BPX1iKydao0tgsR+LXWj4DGmrzPOjiO7qpTfyPJwm/eHeRMOKwjfzi4DSqbf4ykqlFSdFVL2jnao/Ep+Z/GW3MdLwvKcYZXogCSBHgKwLEIoJ61x4EwmUvD5XBIqOOHuB6fFm87JGL3An9iX0WdzOWOWFKRCQ4zEv5i4xilMQk5hZXfRq+wJesVfg/hqXr7ieBGq3ykow7FTcbl7MElm0vWYC5Cd4pmxRIElMeaIstmcboPctM26h4z17ZIix1WyCU/lfOkXrBXlAyvMPQjDeZFKuCH7vZu2eAxuSrWgYhLiFe90krtcnal4q48+sXN8uDS2sYLdT9XXUtqUEhSfVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CY8PR11MB7847.namprd11.prod.outlook.com (2603:10b6:930:7c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Thu, 3 Aug
 2023 09:07:30 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6631.046; Thu, 3 Aug 2023
 09:07:29 +0000
Date:   Thu, 3 Aug 2023 17:07:19 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 07/19] KVM:x86: Add fault checks for guest CR4.CET
 setting
Message-ID: <ZMtuRx+rM5v9eWEh@chao-email>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-8-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230803042732.88515-8-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2PR03CA0117.apcprd03.prod.outlook.com
 (2603:1096:4:91::21) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CY8PR11MB7847:EE_
X-MS-Office365-Filtering-Correlation-Id: abbd5c84-54a2-4224-9da3-08db94011082
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k5pHgSV+1iaDMrSDtzdjs2ekDkJSbzYZ7z5Fe7IR5os1zQJuJ06QzdDf6DSeVG6fYndyoU1nZxJaf5Bmo38Y3HExwmoZWmhAMT6t3GcSzHZGOXSIDCcvsSQp7CcuxcisrKglzxjDvzaHfyAsTUCk6ImP8NikjU1WOX6CndTzj0cN8wJjoCmcKx3DieT6VF99wOhIyW+6RYktD5EkagYi+Je2/mLi2vp6szNVDO9waPEQnverSgjuNV/6SIQXT518U2yV9FtR3matN651UEI6AWIbBuOShfAWQ1vjftZw+sHUa0aK9bNxL8rA7rKVrgrGFZ+3FKtCCaVhHzZdE8gzFXAx0QeNc0Kmt18sL3R/hQDDjLZ6z0xAZ/91FX5WqVkXynSOIs1D64dxsFNhYLZ+cTcKaEtTnsQ2r89Ho3nxXQt4pd4YEL3aXcA6TfXr3QJy44xlPKSu9qZ8fWGb9wUwICTn8moKXuzwqI9XdayscssvzdzMv5Qtp/lcqahUvaxFy1DT/vTy3sDVsTGDdil2Grh2L/3Zy7dozuBSbciiSGj3LPYYlccNP/Xg7IaJqLzJTZ/bw4hBGG2VgVPHBOKKs83x3EqEbIFH8bBtBpo8H8g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(366004)(136003)(39860400002)(346002)(451199021)(6506007)(26005)(186003)(41300700001)(4744005)(2906002)(66946007)(4326008)(66476007)(66556008)(6636002)(5660300002)(316002)(44832011)(8676002)(8936002)(6666004)(6486002)(6862004)(6512007)(9686003)(478600001)(38100700002)(82960400001)(33716001)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iyz9DeWBPdrbthT4BDHME7c4pfiB9b9OdkKQvjxo6FrenxM7XEyhFMF2XjO8?=
 =?us-ascii?Q?LTCUlR6jdc3IWPerqda0s/0qlp0+RHIwP+TVqvVxM/zU+wudLXgJm4T0FTQ6?=
 =?us-ascii?Q?LuoY43Aaapl4Bdp3WmT4K4MOsHhQe9vjmlgFpHqCzQjfsbnvQKwo9P+M7De9?=
 =?us-ascii?Q?/vXsA7xB3ESnav/pWgga5TYJQegu20bt06aa+7TMLOgQ+LwGv5j7dYS3TX0T?=
 =?us-ascii?Q?LHNk8A+AL39NwnqnG67H0H3NYMA8CIu3FW0kBdo71ti30JW0aammNVRpU1K1?=
 =?us-ascii?Q?gQFs0IebWr8dmyTbx+fSRNgc8P/m4mQDnUl8kA6H38BbpyjGsgURI4gDVqyn?=
 =?us-ascii?Q?Bs8siuLObxWLNeFmPZM701d48c8Vd8VOmaZYwKc2JmePuwSo8Ig+7iVkdF7E?=
 =?us-ascii?Q?Ep3PTWdU8FP43q7dKwW43Hna3a4eolq2B8GW0t5/wJ5NbgWzvBzEAMBP0493?=
 =?us-ascii?Q?BrqCIOo9nLXA+ka9i81YuIGH0J29ZKFbVe1GcQ40D0E2DkrUV0IC1yMDqFU+?=
 =?us-ascii?Q?YpWMjep9ABLEn4WwYrlAfto6qqiER/0hfKilJYNvkE48I4clIve7+wCXj6Ve?=
 =?us-ascii?Q?nRijMvg/OGQRJisN8/z8uWYecxnkWsLUC4SoUiKpn969cXVqYVmdt7dcwwIb?=
 =?us-ascii?Q?zWphwQG0Zm7BHa2jhKdpjJMYCjyTCrDKwBm4js7u9QJore99fevM1KgO+YaF?=
 =?us-ascii?Q?SPI7HL1SIHGreOlavgkm3cuaH3AF3NYtCM5q9bYbnUqUqjmKTs4zf16z3HRy?=
 =?us-ascii?Q?W9X+9lgHH2cdc+ntdhUgNCnmPAOwckEDrjLXwTGaaL0cR0B1CtSv8/+5ZaHS?=
 =?us-ascii?Q?ghknWf+1Ntw1ix0KGyWdst8zz5shaTFmucxYKG+Vi19/Jr35T7hLWTlzxRu4?=
 =?us-ascii?Q?aNoK/ce9QkC64fA1BZF/7welM5nGmrbrkIN6FA2u1+fr5r+2PTsOoN4K5Yw4?=
 =?us-ascii?Q?Ku1DERi1xTbYUIxJ9wkW9g2xjhg5jSjbaFTglV8+FwHE06t3svOD8ZzoeEvp?=
 =?us-ascii?Q?ftLeFfMK+P0GIV8JPyQe9AE6aqPDKMA2DoTXJlJwQDgWCGnpowm/wmS9EEIB?=
 =?us-ascii?Q?lLp1N/Ej/W+PUjQ8zzSd7s1RjlUEMDJRisAQVUEnsinPkt8CeIPlPmCqrJmQ?=
 =?us-ascii?Q?Xt+fvsKTx/nyD9lGSybu92pCJsPtM6D0vTt723Zym9OENiP2KBGfBXHaUBCC?=
 =?us-ascii?Q?ROVx2I21d2Zj60pBzBwgeIB9fJGQGnPEYKMxiEQzYb5X4u6l6ln2rqD8EjhN?=
 =?us-ascii?Q?6zd44VlpJuCiu6iHniUW5OfUeN4rBRlseok8mE0sPBedLUsi+iSQu+1LTJuf?=
 =?us-ascii?Q?J1ggAWjXOi83JTl5dA15eXd6HqsdAuTRlc5kxAkBnIbHVMPhgWnQyI+FkLww?=
 =?us-ascii?Q?GzY6TT1uk/eFF1W5Uszdzrd8h9XjpubCBfVrHA2J1adyz/ROPGD9Scg18iPq?=
 =?us-ascii?Q?7Uttlt71xyVUV75aEgX+pdPsaliMqnJlIPUcuUuaETCuj9NArLg8xHba3Xpl?=
 =?us-ascii?Q?w7ElLPSizNXdJFIdC1nk2bTl5Hll/ATX67z2QlNrSD+qij/ikveL5f1AGmbw?=
 =?us-ascii?Q?cSsfYVP8AcXUWXGmdCGHxR+CappOR1BbZL6m3t/R?=
X-MS-Exchange-CrossTenant-Network-Message-Id: abbd5c84-54a2-4224-9da3-08db94011082
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2023 09:07:29.7077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3N8aaYrW+3/ms0rh7/J4dlg6+yzy6lLawvmBqEbAJ0cyjemquQUW0CV5cXxJtLLJZYg1upwF7NlWgwF4k4O/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7847
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nit: add a space betwen "KVM:" and "x86:" in the short changelog.

On Thu, Aug 03, 2023 at 12:27:20AM -0400, Yang Weijiang wrote:
>Check potential faults for CR4.CET setting per Intel SDM.
>CET can be enabled if and only if CR0.WP==1, i.e. setting
>CR4.CET=1 faults if CR0.WP==0 and setting CR0.WP=0 fails
>if CR4.CET==1.
>
>Co-developed-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>
