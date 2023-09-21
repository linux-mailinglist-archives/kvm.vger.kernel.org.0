Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7E67A9047
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 02:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjIUA4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 20:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjIUA4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 20:56:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D1DDD;
        Wed, 20 Sep 2023 17:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695257770; x=1726793770;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/D0lFM8kQdDd9o/1+wKS7QK9HiXH2n4fIJSZV9xwLGM=;
  b=Yk06evGvJHfH29u8jKr9w7ZCBs9G/Z5Zlfc/rPqb8SimxBua54H/IkVZ
   S/vlOi+Nf7Vw89g8rqyooR0LLGWPfgzo6D/OxtAATGXsPS27C8bY+ALv7
   fZgt2ODtm1TBSN+1JxATlCTaEUTFTTblHc4zMWJY2esnXcOjRHxy7u9ig
   muK4OujiI6GFU804K4BFobigsR8WdMg5raFAeLA06xStQPeeF+EVMidCc
   HBDWEyyDqeCV4jjzQLW8tbK7kTVKK5/sSXq4ltwFlMYiM40+MtxFmS+8h
   gekUC9L9y1gaU4VnEJY3/2HiVG92UUVkICfoq6a5GSJ+ATsXXfT6LR34H
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="360633526"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="360633526"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 17:56:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="812397400"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="812397400"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Sep 2023 17:56:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 17:56:09 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 17:56:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 20 Sep 2023 17:56:09 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 20 Sep 2023 17:56:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frh1mHBeQ9vrarxvTcs0xG9HfxMjLkANATzyDW6XYivr9hSYX0Pb0rrtwG7Ra8pE3k99KatDSlhxuGyfMv+fpFdjcy3i7uWOV4ND1oUItgtnPDu2hTsUm+A3raTUtlNzh74FBF1fRs7efskbdz+LA0vylEPw/EZtRIFTwfq+BuyeSl6ipJfcIfXJv5bL2Zn5qkYEXWBMk8mI4xVmG7jhAsvkeOqKbOfcVbwg7WC0ep3jbCgaq3RfI6NzXJLX/8pT/hP6DMVfjmH5rYrRBnjEaLsZgSwaGhZO256n0atGFCzCjsg/WK4fC1BOMdr9TZ18MsQGXwCLY3InQ1NdjdHYdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HENFQ52H1PmojFK9Si0h53ciQE4ED2TPeyBotUjyYFk=;
 b=Kllj5GSv9D76CkVj4WD2q+8dcpxOXYnAYIIjhgatANtLTFeHECigfCT4ScaViDhqn6nxjJI85Oe6FWPj/tMqsrARhpRduPs5wsY4gVPKU3TPEi+MGlAyK52T5hs1fEvTpgHWP0sgODh5HduroQNcwuiIdQU4XYTsMsajF+zfmMkaxnq6yJ6RikGl+iR4B7EBNxyyI5Vj4FgcM1piOn4o/Nu7mjKx2S1x5HmdvWTfE0CmTPTJOW++n2/byJ4kUw48ChcgdDg/pgQCS7GlzzSHMRYQzI3p2UMuDtVfOos68CXsZ1OKpwvFoNQuYo6xnSqLFSMIQuYNDeQXcDtsYQCgPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by PH0PR11MB7586.namprd11.prod.outlook.com (2603:10b6:510:26e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37; Thu, 21 Sep
 2023 00:56:06 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a9c7:a04e:633d:cfad]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a9c7:a04e:633d:cfad%2]) with mapi id 15.20.6792.024; Thu, 21 Sep 2023
 00:56:06 +0000
Date:   Thu, 21 Sep 2023 09:15:33 +0000
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2023.09.20 - No Topic (Office Hours)
Message-ID: <ZQwJtbXrXH/wPxpd@jiechen-ubuntu-dev>
References: <20230919234951.3163581-1-seanjc@google.com>
 <SA1PR11MB5923CE0CA793FF8B63DFDAEBBFF9A@SA1PR11MB5923.namprd11.prod.outlook.com>
 <ZQrsdOTPtSEhXpFT@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZQrsdOTPtSEhXpFT@google.com>
X-ClientProxiedBy: SI1PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::9) To SA1PR11MB5923.namprd11.prod.outlook.com
 (2603:10b6:806:23a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB5923:EE_|PH0PR11MB7586:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fffcfe6-b1fe-4e3e-2909-08dbba3d895f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wh+Ns09pjJusmYnU3G25d042+dm4XrqoSlpjlCL3nY1a/jAo2dzjdaMsuCuHQH3fiU1g0jONSOcDt0S8uusLvbwTm5rRI8x8/GnabRnfdmjrnRWR3poUh6/NoO4LVOJTOmFe7pv4C7AmFbxbWFnTOekK0sZxVQ9n2p6hXmlvyjy+dMzSYPuHKzY7PLZ9Ch9G0i2AcaJiVS/nZ9HPVoN3VVCdbY0qU8IoO7yPn2fYVxjbjyF07UFNOCGHeb3uRTn71iWwfrPmekZO2faRw7hcSpZqQo01DClpdnZycnHVgOHSatMHdUBNgnV3bdge363nbJdb4rOATS2uJOzZmtjUisrFPQbE0DCN3yZdGQQEfVvuFnUs6M3kRLomGkEkXmQGYQMpq+W5dT2bs920pb1LFAr7ZpCE+AcYi6UGFwjVRI2lD0wk0VH50znTUr5sRvd4biMI16Q+GKZ80GvALot8d3Cl/7NgmHIMkBV3Ed0Ax/18/YNjZLtmWgxyCPWXKycxuprzqIvZ1KCordBDIXwWlzU05XbZdmt9vMgJ0UlD5Df9gVKgwdaDBbP+sbBpCs8R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(39860400002)(366004)(346002)(376002)(136003)(1800799009)(451199024)(186009)(26005)(4326008)(5660300002)(8676002)(8936002)(9686003)(6506007)(6666004)(82960400001)(6486002)(6512007)(478600001)(6916009)(41300700001)(316002)(54906003)(66556008)(66946007)(66476007)(4744005)(86362001)(2906002)(38100700002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mk6H4diSKifITu2jrjV+HYT3s/A1DxmkrIrCtJvhto9DGSbygrb6rYKHNU7h?=
 =?us-ascii?Q?s8pNVEzr0tPCB0UeaM2OmpwAnNVFyTm8U+wGL9OX1nynWei8PSUbgKw5X8/r?=
 =?us-ascii?Q?bp/uSe3ZvJLFNrP4JoijU5biZuU2o6D2GsrIvRzwUZSuP36PyZqXlqHtPm15?=
 =?us-ascii?Q?rU45enI6feTdY+xBfTON/TrojCDcaEKRyMk/RO5J5NCn4c0XmSccVC2qqMWM?=
 =?us-ascii?Q?HCeMokzs/UI809fwIS0f+TADIFjRrbr2TGmh7JEFXjzLuCc3Wl/vJPuosK1E?=
 =?us-ascii?Q?Jy7xQuXUwm9exh+6DrKHA0AWtSmUsV6sDsFRK0JJknmrv1kLj3EJh842JKZo?=
 =?us-ascii?Q?c8a4MSgT7xBlxFnxd8/KVxAROarFO37DCKBTkurkGR/pf4Sp+elsy8uLoeAc?=
 =?us-ascii?Q?+ZuD/W3zLGIuV699/OYANzdNCfY1kVpTnlbDleqhA14jBOw1BlYV5fkYR4hh?=
 =?us-ascii?Q?PYKaqsKd0693WdNZQTPAFm1g7W65prIrQcNN3FX2zRHjZBx1qJJUDM+1D7Ld?=
 =?us-ascii?Q?rDfLzWVgTrov4g5o3QQlRSgIfl7G/B2HjWV5pQOCyFavIs0Ol5IPZC7nybFj?=
 =?us-ascii?Q?rZD4UiXwvEqdTJ8Acxl3p+GRkzmWpGjEF8BY+oz1qnICKg7nEg0tCdxqRyau?=
 =?us-ascii?Q?nfc1LN/eaNObC6aQ/cSL/bqHSxhoZxDHsBFXs6fO9tf7TT6vk1bmtpn9ZUBS?=
 =?us-ascii?Q?6VAUGt0SzDtII8w2nBjr00FoF2mzdKOO6gqhes3dd1xG0KV0Lh0TypIgwlfE?=
 =?us-ascii?Q?XEJ8lHntlfwiJwH/nCLNm0r050+kU10RvIm4DwKmr9L29rNPZFd+R/iuPIXa?=
 =?us-ascii?Q?TqbdIjt40GXKNeQ1bUpDQ4R/hX6dGlujgCsJowa0Pd5xAj/jEoa+Xvm40jmC?=
 =?us-ascii?Q?NieKaSm1Y89MKReWW7cEE/crOyGTkVsnSxVxCGU25Xr5hEZ9Fv4R2o/tn+p0?=
 =?us-ascii?Q?tvn+1wHoHgvkFdJNe+9yog+RM5kAsB54BIzu6OTsJRFDTaeOtqaeSg78eQdc?=
 =?us-ascii?Q?YxgIlPyaeWaPJrQ0yXtOS0L95ZdScvLjwCTIBWeRn5n7J8ADfiMZ4VsGUSkL?=
 =?us-ascii?Q?H5bW5qM+ezNbGogfk5rIRWg1iYC9rNYKDLi4xtr3B6drqUW1ojKctc/Hd73Z?=
 =?us-ascii?Q?VnDwraEYFmqKoLxkQTSrUmX6dHRT02Di8/xMNbqVcd/e5SekPyCYuXTzaFgf?=
 =?us-ascii?Q?t7JxBTkEuCZH3bon0SHO4mrLg7tGbIXPqfqn2pRl13N+vNmriuWgq+O7Cy5l?=
 =?us-ascii?Q?MDdImF/WhFEpxmU831YwzoRDiyfjRo+krm8pQcAPwEG71B1ecaWIYpdqOvHA?=
 =?us-ascii?Q?A4lvb5YoIMPPBAe4QIsdm58URdnHOvZDMxShKPEm4phfdBHBmDfjh+5W7NNS?=
 =?us-ascii?Q?Zxbka3/4fXnnLUJiDPfA/gJszqynEhS/o+2EfOQLK0svZY9QPqPO4lfBtDt5?=
 =?us-ascii?Q?ZgEf/7IeKXb+En89UQO2LNS/n4brg3cf2dWjO0Q2hQZQpa+5okLeYQzNFla6?=
 =?us-ascii?Q?dDH59RDQMp1C8DqLz3Av6niV2DcheXVABP0+rFfn73dQNJxbD0RXsj6+DQnd?=
 =?us-ascii?Q?tfa6/OVsYo7aq3aGRKeh4LegcNJXz3GbF7q8CpLk3I9WK8Uq/7xkwSAazDv9?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fffcfe6-b1fe-4e3e-2909-08dbba3d895f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5923.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 00:56:06.5442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7o47bGyuDfN2DouYbRtmm3Wn0Fku0jPWtWdWYk/7n93FW6wmv/mEIUbRe+igiHUJfIqMIrOmUBisIcs9l3Bpqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7586
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 20, 2023 at 12:59:11PM +0000, Sean Christopherson wrote:
> On Wed, Sep 20, 2023, Chen, Jason CJ wrote:
> > Hi, Sean,
> > 
> > Do you think we can have a quick sync about the re-assess for pKVM on x86?
> 
> Yes, any topic is fair game.

thanks, Sean! Then if possible, could we do the quick sync next week?

-- 

