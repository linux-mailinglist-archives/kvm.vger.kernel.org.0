Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAEE7BBFA4
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 21:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbjJFTPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 15:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjJFTP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 15:15:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCEE83;
        Fri,  6 Oct 2023 12:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696619724; x=1728155724;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6kTkDjmUs95JUZZvjE9nSrNmnIaweUp/UvO956WBMVw=;
  b=QH8XumAe7ADSf61uekHhVfTM56KmdRYLv80GYeOUnFTRtPb9tfFesbGJ
   4gp6zgq3YNHirEQ3S/cuK9Ma70p7nBYcT2QOYxqX6aT/IHtiMcM/10jxi
   lKoP73Re1T8WeNdndxsDn4vKcqwLn6124cHzZ4dvBAP0rTI9tFAmxjBKu
   l4R0F4xYAyK6PY8gGWeraQV6swnTtBoy0nCxsrZzJcSjKEy94WjxNeeCl
   +HnL3rx/r7g5DKQo2f2XENQ60Yj1dqk3SSSKKrI6uodz+nUKPrPr4zjE4
   qs2CgmRfphye9W8bqJhkdFEjSxgzMQguQkg98jaqMSbt8L6hl55KfJL/Q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="382681035"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="382681035"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 12:15:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="752283814"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="752283814"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Oct 2023 12:15:23 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 6 Oct 2023 12:15:23 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 6 Oct 2023 12:15:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 6 Oct 2023 12:15:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 6 Oct 2023 12:15:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TArxPudIKNDKjMkhWwHTX+ffPc894vkbjxQsXbtg94PRqEWZT2EHBHeDW2GewhBo3LcdCBHp2qVVLTj3ZA+HCzJ2Ayx+JcnNaTvNim8FqbhCU1RsKfCNhkzBaeeVJDvRdqe7GhpVj9uBreUcMavRyZLDYJF9CSLE5RXJTshEGY3vs6VidlZiWMd4BzmF3zyWQKqQlNi8HHiUb3onaCrHekXNAXCZwcxvosmgWZ/FN/tAljJHY+QAycfKdA3bRPSu/ZxE2rEsOLb1Pmgt5yuK3thlT3gcoBrSkewUmGemgH4+OplQU4vz59d/Q4t+JL67quFE1yCD51EYjL7FTfDVdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcKyCTe9/LsTEe7b0uJdHVXuYp7vUXGx/YB4h4FOz18=;
 b=GiKVVj8tu6kiO3MwggatuB3lvQttM1EmskUaNkWQCJMuRjR1ZSt1YR7P1Aj/g31elDqY4AT5acs3HyV9+rpbz6FeCZdi4wkB7Bl5escmDU3GZMS/VGlDeg4h5XTmwjWjWo3UMFNE8buR7qQN+k5Py1AaOwTFycAgL0HiHfXjD1WR/1GmbbUJKcUQKYhXfnjw3PLr/rjZluTgzJiVJQRq1LiM7aj5FTi53fOGtXuePScbvAGHu0g8qgco3h6O61X1RU1h9NuZyZLHY7Yj0eAQsT/2OtRWnLaNEbKwe8iHu81/mtySoEh7UAXNeUkUYvqd2lg/nF4KbDqfuLKcyc52Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB8341.namprd11.prod.outlook.com (2603:10b6:610:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Fri, 6 Oct
 2023 19:15:19 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992%5]) with mapi id 15.20.6838.033; Fri, 6 Oct 2023
 19:15:19 +0000
Date:   Fri, 6 Oct 2023 12:15:13 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Lukas Wunner <lukas@wunner.de>, Bjorn Helgaas <helgaas@kernel.org>,
        "David Howells" <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Wilfred Mallawa" <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: RE: [PATCH 03/12] X.509: Move certificate length retrieval into new
 helper
Message-ID: <65205cc1c1f40_ae7e72949d@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1695921656.git.lukas@wunner.de>
 <16c06528d13b2c0081229a45cacd4b1b9cdff738.1695921657.git.lukas@wunner.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <16c06528d13b2c0081229a45cacd4b1b9cdff738.1695921657.git.lukas@wunner.de>
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB8341:EE_
X-MS-Office365-Filtering-Correlation-Id: 43a062e0-b42c-4e6d-6add-08dbc6a094b8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TqXnXyUcQksuTQgcHHLdRLa+JEmi6iOQwUI7HTFrIi/k3nu0a7HIUdy0RfROBHYiwwntf4oqnhQHKVsa3PWyFE00kfiP+SxsNDiUuSk9WcpnUdm+b/mcjwrP0q4VNRKwT0ji4uGhPIP23S+Sqou/DXDjDFUJT5VG17/WQPnslbUZyp3ycN8R+KfDS+VkP2EFBjxYwenWO5Oy2MQ9SKYwbWavcEf7TbBlRLaixc01USx6Tax1u2sLjkJrsVgkRlbJPuAQ7SPd034sC1jC0tTWq0dJSZme+Hc7H3J2ENQhYhzfjLiZC7tk5gugohNSKT6Hzu2x+bHQbjMQ+Dbni2hZ+LTHp6sIqvbQX4J/SGlfXxWVm4utqQx7H/lCsqyIhpYo3hr2caA1+KbzS8kf5GWTx3BLgVIZAhMzzunTtXgPrwg0Of+DkjWDJQnDut+M1q+BLDzhM4nwAY1DIW5g3Dvu8/T82yaqpIxAMrlc4ngkKKtsAyTmOelHEOETqTpussjwrMtyPe6XE48+Xw8ecXKW4U/2THfUhF0UFDWlCrk45MZxCT1UlV1eCFt8psoLtZwoa1FM/hKIUY1Hi27ZVfHmPl5lDvdtvK8svVibgse1pz8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(396003)(346002)(136003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(2906002)(83380400001)(26005)(38100700002)(82960400001)(86362001)(921005)(6666004)(316002)(41300700001)(8676002)(8936002)(4326008)(966005)(6486002)(5660300002)(110136005)(66946007)(7416002)(54906003)(66476007)(66556008)(478600001)(9686003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U5tG5jtgezDgejBJZB6ex1yumkhE+t7cH5w4Iir/0/paU3ZFsccDFxVXD9jG?=
 =?us-ascii?Q?6z9iy0vh9RPAjeWWGGpiec6Pmrsjh2mTW118oF4JJ4zZ74ntpWHbCIYot7QQ?=
 =?us-ascii?Q?VldSt98vSwgU6sEBO2oN+CmVrNX6nb5epUEBXospiQonmxadG4wWXYR9LnU9?=
 =?us-ascii?Q?muFjxtyrg1qXg/PSdlzUQFXxssf59WOoOVetbkhQjvRPVN9XLD4WeiF8/2DL?=
 =?us-ascii?Q?G/UthE7ZES8tQapYuxt/VBxL+jwD/zzhIbQOcdZY3HUz4JaUFIKBCeQJzrGK?=
 =?us-ascii?Q?QsWgXcSd+fsMcsKYfTf2RJw+mFCqRcTOmF90V4qSBKYOz6fB89et82RuOC0e?=
 =?us-ascii?Q?15jQd4A3blmGQdgpM7xqOMAdtSsnMBCjgByNbmI2464KUt+yPwcI/U6ZMhE0?=
 =?us-ascii?Q?mOcQMts2ns/GRlTV0q4qJyT+tYbMz+RFD9iiGhEWyEfZzoEfVdJJbx87akxG?=
 =?us-ascii?Q?kV2wtfNYXqMM+yeK0HtIGYC8xgCDL8LCXZTQ40PlW+h9szk6xkTcVqmRmHwg?=
 =?us-ascii?Q?VJ/egfPhOVzosyzZxc7zzAJdFUej9FjpENMbmY4XdYpoDrN0wQNr5ZInWB6y?=
 =?us-ascii?Q?vsaL7/8X/JW6q8CO5wCGq59lgpB5XigO2GM1dzwU+W2RCW/QVTSWPjvdPc05?=
 =?us-ascii?Q?NUJ55G1xpSf8pwInfOuaexyCqJ3JtOvflgzzU7CcmmpSAteZiVYonkW5WQuy?=
 =?us-ascii?Q?fjPkF4ij+uWpc6o8jCUzKJcwmOpe2p2OrdBvSubh2AZMKBGoejWTcd5tjk50?=
 =?us-ascii?Q?yGQnU7hk0/78Se14nZ+PbOdMdx5blHpMSqNlIJSAw7E8uJ2XcHQiG9ZbsfHl?=
 =?us-ascii?Q?CJ67qKdH/zfmkydFGhLbUTBG51PnSAYPp1ZMMaXS8Ey0LEg4myBWyZYLo7hD?=
 =?us-ascii?Q?zkCpJCG2KN1wK0wclQa64eCr7M7P/BGCP4xe9tipjJ1z1gDGqQ73YmL5Fb0B?=
 =?us-ascii?Q?fY6C8znGt++pZ5U4FS+wFU/C5ohJ9c4qPfCVAl7dnGlbft1oHVnvvzWtpmOG?=
 =?us-ascii?Q?WhwIYaxa/MEilOdUZD3B6VnU5zyybkWbF2XaPQDtY/sSDqgA50aA+B2euBzH?=
 =?us-ascii?Q?3eZoki44hn968YJ6izkBh9Xqj+ng+RLWH3l7Ou9mqHkmIhti6Epw34FIPBCK?=
 =?us-ascii?Q?Rh7N3h7YPyMVsgQiQXEeVTgE0s/Pqa7orOV3t7xLrEwrBrj9t1UiCKfmycKs?=
 =?us-ascii?Q?/Ql21kaBlNaJPgsUlUnln0XixHhfsi8hPmD9n+uHOPXImkF3nE9wt1HqSntt?=
 =?us-ascii?Q?PJJ2+aBNThLVII0pSJgfjpaap8aRt1coS0N9AzsBFnmkqNpHq+vUj308k28C?=
 =?us-ascii?Q?zN+JxpZhJHHNj88rkwbi9K0hAPORuk9DeCE8G8Rkxj+dj33C0PO4Oi6jIRQA?=
 =?us-ascii?Q?PYv/IzeWAqhV8AwqIkF3X6jST7DZNqylRftxHCkhEveyygtTRP7kAsqT0BFR?=
 =?us-ascii?Q?co3TeHycC8z2BHOhvCM8rc/Krbc7NYAE3Cqse+N/VeeVBKOBJWvBFnPP7nPW?=
 =?us-ascii?Q?zzavxwkDI0bBdH2NovTw97wA/hovr1I06KfFijTKBOiqMheolmUojxiczEbX?=
 =?us-ascii?Q?lmN4MF9d1PHcWdGv9fyjYqZ3XDCAprB2HFZPsVS1ck9lL4mP9x9PbM9uRi/l?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a062e0-b42c-4e6d-6add-08dbc6a094b8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2023 19:15:19.6656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GL7QzQ+k8EqidABpoPBX8WX3w+fP7BvbWKcnVyrrGqQtKPWxfuc68AgN7CpBEePscU0jEKCgSZMOI1RtG7JOoR5Zc+8zDFnkYb6ebw9KODs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8341
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lukas Wunner wrote:
> The upcoming in-kernel SPDM library (Security Protocol and Data Model,
> https://www.dmtf.org/dsp/DSP0274) needs to retrieve the length from
> ASN.1 DER-encoded X.509 certificates.
> 
> Such code already exists in x509_load_certificate_list(), so move it
> into a new helper for reuse by SPDM.
> 
> No functional change intended.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  crypto/asymmetric_keys/x509_loader.c | 38 +++++++++++++++++++---------
>  include/keys/asymmetric-type.h       |  2 ++
>  2 files changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/x509_loader.c b/crypto/asymmetric_keys/x509_loader.c
> index a41741326998..121460a0de46 100644
> --- a/crypto/asymmetric_keys/x509_loader.c
> +++ b/crypto/asymmetric_keys/x509_loader.c
> @@ -4,28 +4,42 @@
>  #include <linux/key.h>
>  #include <keys/asymmetric-type.h>
>  
> +int x509_get_certificate_length(const u8 *p, unsigned long buflen)
> +{
> +	int plen;
> +
> +	/* Each cert begins with an ASN.1 SEQUENCE tag and must be more
> +	 * than 256 bytes in size.
> +	 */
> +	if (buflen < 4)
> +		return -EINVAL;
> +
> +	if (p[0] != 0x30 &&
> +	    p[1] != 0x82)
> +		return -EINVAL;
> +
> +	plen = (p[2] << 8) | p[3];
> +	plen += 4;
> +	if (plen > buflen)
> +		return -EINVAL;
> +
> +	return plen;
> +}
> +EXPORT_SYMBOL_GPL(x509_get_certificate_length);

Given CONFIG_PCI is a bool, is the export needed? Maybe save this export
until the modular consumer arrives, or identify the modular consumer in the
changelog?

Other than that:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
