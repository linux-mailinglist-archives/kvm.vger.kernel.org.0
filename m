Return-Path: <kvm+bounces-10821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C007B870A95
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 20:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E38D81C217E8
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 19:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C721279DC1;
	Mon,  4 Mar 2024 19:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RFitaaG7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE0979924;
	Mon,  4 Mar 2024 19:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709580020; cv=fail; b=mxUUrc5uQmHi2XBPrxK7JJZUqSg8CuoyRSpFnEWrCT1i13CkQdqQ8OQvxMjVhQYm+Tqrhmk2qFr09SHsCexk3ZzI/EVeQLFzCQw4zP/YP+i4Y8XSzQZnKe3dqR6nNNoIsSTV+jIdkRPStUCLSKm9sJJ+7c01OSgu2Ab95oV53aU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709580020; c=relaxed/simple;
	bh=EggEs5LslEx0ZtgmkFuTXH/3ohlxDU54V59sn4uvv30=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SHfiFDk7/6nCweCwnXJ9qKJilycJsFp+7d6vl31BS3++mNjKkm9LIMwgkGAAwfP2km9A6RnjG+v0/tPYVxFkn79D3AV9tlYAbtM/tUo6dgsyls9B5ROtU0Xn+HWE5fcd51ICrUIWIMSdQaKlFSlobqp/XB495gZ2EmgpYxw+NlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RFitaaG7; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709580017; x=1741116017;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EggEs5LslEx0ZtgmkFuTXH/3ohlxDU54V59sn4uvv30=;
  b=RFitaaG7SH5AcpncD8EKByWfo9y6KWJW/ZADRN2DGMO69+OPd+wiCzbr
   S0wMJQtweHIJs/b/0Sc/sTItB4GB64lRr0o0o732Jsvy3MlQkPhzSguZX
   Gx229KJM3zGtm0TabHeLmsjB5drb57hgNhS3lbZlAV4Lmp20IEe1o743P
   2wPVxSHOni5TQfSNXOWLmmnBdYqfkN9oN9rhwkvQ+J3KAGCk9ZGKLfQ7n
   3g1X7jWSt3QmKhqT+IlE416xbhNVkXQD92cPdX9dJ++XBsmMqE7XHjSNx
   BljPgtLoj6jBUVpVk1XU+cKZaWwwE26y7gaT3UqgztYLHDpje/1V9mlLY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="21630266"
X-IronPort-AV: E=Sophos;i="6.06,204,1705392000"; 
   d="scan'208";a="21630266"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 11:20:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,204,1705392000"; 
   d="scan'208";a="32276717"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2024 11:20:16 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Mar 2024 11:20:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Mar 2024 11:20:16 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 4 Mar 2024 11:20:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnZ00DNmMCl+uad/pVTa8OIMwPAFEyKixdoyLNdvr2C/i2xFlb/wc4Do5YBkqQNsXiRUyCwGO1dzp42FZ+DsX9YJUdPbWgIx2VhMwMMX9MV0SV3ozMRfHSotrMMG5CEK+HTHNxcpWvoLoysGUCesGdRZ9ZrfZNphiWNbnbjPYw5cHGEPiTkEvRVbk5oHnpjLQ8OwM8/XzOpzHNs3CjumwOanPha+NtBoyAtv3bZK7TVNrg6DrpQ6a4EesqxPj64pj6pr2C8njakQ4hQPc3whi8i6DysM1LleUl/3her6DJ2HgDmsrCaFKd8vGacRS5jLxQ60CFG5kmZEB2Cp0tUjAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fj/x1JIcT3K6ZG1KP2B9e6xvXYVfpDyWdr2ivnc2UqY=;
 b=iHbkCHQdlenqIV+CTlWKO/kAcE4C5xNGRjLazFenrSvpypnqNYQ26Zdp8p1wgR89c9lKgfWjjtHLIzU8hdApNYdGy6vRkR46ksH7bkGFWmzOPQ7sx6wfxX/7ye6Mu4vCG0v/1dCw2ZgYnIkf/Wo/TVGsRztcSq0bvMS31oodRsVTpH3bC82c8FhGp8hOwg56xAgNqJj5wT4qpRtsUH4FJuNX/TJxthnZ+LzSVSvnAdwuc02ExHA3crSp56678VulVajCHorS1klBbGUJav+Kfx6eLHUez2mOO//0mizp21y4TfAPcSRj7tFI/dhdItUs+YssSCFmAkIqMvo594RTig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB7183.namprd11.prod.outlook.com (2603:10b6:8:111::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Mon, 4 Mar
 2024 19:20:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Mon, 4 Mar 2024
 19:19:54 +0000
Date: Mon, 4 Mar 2024 11:19:51 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Lukas Wunner <lukas@wunner.de>, Dan Williams <dan.j.williams@intel.com>
CC: Bjorn Helgaas <helgaas@kernel.org>, David Howells <dhowells@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Alex
 Williamson" <alex.williamson@redhat.com>, <linux-pci@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	<linuxarm@huawei.com>, David Box <david.e.box@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, "Li, Ming" <ming4.li@intel.com>, Zhi Wang
	<zhi.a.wang@intel.com>, Alistair Francis <alistair.francis@wdc.com>, "Wilfred
 Mallawa" <wilfred.mallawa@wdc.com>, Alexey Kardashevskiy <aik@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Sean Christopherson <seanjc@google.com>,
	Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 03/12] X.509: Move certificate length retrieval into new
 helper
Message-ID: <65e61ed753250_b62b29431@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1695921656.git.lukas@wunner.de>
 <16c06528d13b2c0081229a45cacd4b1b9cdff738.1695921657.git.lukas@wunner.de>
 <65205cc1c1f40_ae7e72949d@dwillia2-xfh.jf.intel.com.notmuch>
 <20240304065703.GA24373@wunner.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240304065703.GA24373@wunner.de>
X-ClientProxiedBy: MW4PR03CA0177.namprd03.prod.outlook.com
 (2603:10b6:303:8d::32) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB7183:EE_
X-MS-Office365-Filtering-Correlation-Id: d7c643ff-0057-433d-70d5-08dc3c8012a6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yh4WOHxIG4ynR5TNFVApwQ39dlgYjjSSsRs9Si6AYcyeFwz87RtxcYySqIN2nil7gicBn5pLgZziO1BP/b89YTfkJRHorEoZ41YwzRBAhcwGBirMi130+YEzK9BTsDIzX8mv2O8fDCk7YYtQSLur9yzUN4e2GdTEhjIYQ2pa+CaTW2+0vTwTaGWadR+6sNQ3h4KlcKS436OCffy2/JwVwPQTJgPVCeYgLM0B0UEgKpP54dBTKX1WLOKv8LFj0ON/sf0gS28M+9SK/pPQ9qgOu8T5Xk041vy8wpFcdtX1Lm8jn5rFQkoShbTBtWHBI8+2R9nAVMrb9+YEbIiwzF04xso+CT0ce8YQ7qgt8ZaumEsFnAFKMy95F6umW/bNIPzAqQ4wfKZ6GBaMJjKTAxvCAcFyFi0241HKLX4MzlrzuOxkuVyo8kEICYN6BJ2ZS+Qn74MGaCEY4ZwjHtClAOvn2EKVh95oYHM0Bp/zk9b3PEhWXwDB8ATmhfmx9JkC9Mo6DfYsZOMUqb+4npNzelv+JBn2VCtEKcaCQQ4ttwKGMu1CAmVvuCfcgAkQcuiCFMiuX1KsLJmjN4NnI90C/X6470M/XOIpT6KjR+/VU5pgBuw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sW5Wpu1lHzabUAkOGsppr6PYmJVmWoi5otZKYMCdXaWGZeLmw2IHq8ubEs5u?=
 =?us-ascii?Q?+4VHAdjl49KjBw94+eLE2vVvgD4ms/y55OIJSMTbcsnKyDCuLTkFmszvX9I8?=
 =?us-ascii?Q?VdGnFu+qFEfsyLEtJT8fJLzp/++xY3XYqy8Ahn0UdXOOubutdlRFJhPy5TlP?=
 =?us-ascii?Q?4r3y5TFPpEno/478hFU5y8qp+bQ3iGU4m1He/86rQaQOYq8tPcX9Kt9faql+?=
 =?us-ascii?Q?xWEKdmWpCx3dSn7qmcmWU6uiVQNgXrB925XPHr8zF550WNPckYSKb+N/mn0W?=
 =?us-ascii?Q?8gi2TxwYBK1eKqyJ2yc8MO0rW3l0nNWJk5WeYwiZ84u7Q7YZx+U8eSDziwdq?=
 =?us-ascii?Q?IwbSps65aravFP54Yf5/xUY88sunGccFrD1oc6RNN2T35MCCELE5r259pC7z?=
 =?us-ascii?Q?84c0/k7DmdbhWXAqv1xeIB1aAhIrVeLCG747Un9/QR+nopwR4M77KgQdlsq/?=
 =?us-ascii?Q?H8DyOjrXZYcE3hKd2LcV+0ihohfGQhaYUbD3VaNVuUp1fv8FP1yMvkj5QEaQ?=
 =?us-ascii?Q?aozhEv8x+YAaDFqNOoF8p5AVtpClwdtjMByfDGDqLkK1gF55YkncydEHNT4I?=
 =?us-ascii?Q?o5pgIM829KJ8kc3lDwujLmamWzvq6stO72cK/QanLOagoRf/LASf8iDLREwL?=
 =?us-ascii?Q?JfjS6w3KGuSnGK/dgNrjVYmjDdteE/pP3L5c7kVFaUJspQb/oV01jEjo0ZBX?=
 =?us-ascii?Q?V5S6/zoHz/g8Q4yGMNzZBYRA5yAXg7M05mGS+HJCoVJQSwvduFQ7HLp5XJgJ?=
 =?us-ascii?Q?jYyxxgOfqPHzIpVqVDv67aGj/CCYkQyPLFG4UH9FjYtkQeRv9R3K/D2chfOE?=
 =?us-ascii?Q?GEkQes3n22Q4ut7Hv5yK1Q0tDI+nnZUOC5hEA7qTSDZiK1ZMdj3y99gxdN7+?=
 =?us-ascii?Q?6DEJfGJo8vXKzls9MHNlqLtRvZictMkcAOeK5h2EzpFdKi1ksPyPSIQLZ0bm?=
 =?us-ascii?Q?iaFTaiguZNYtdCj/thb5lIR46+Gpe6Lyf6pHTjhuUmFcVIab69ADq2vUSaqB?=
 =?us-ascii?Q?aQZNO4O+ukR5QK/g7ijH/qZAMnS/s8LA4WCe6t4GZiOqNRY4XDViOPMMdxWu?=
 =?us-ascii?Q?od+FcARZ4JTMQ+qhBrRDcqcf2OPCJyYx+X22Ps0FHZaQ6QTnzmgG9c3X77iV?=
 =?us-ascii?Q?PtnX3iisztoDzIp0chlJRxxMdgIhSm5TR8oLqsgMjKD2ha882v//UrB3SnWq?=
 =?us-ascii?Q?p2dq/Dyf8eGD27MWOYc6bAFETLGHdcq3zPtjW8gbAPwhXiMfbXoCpgGWNx4t?=
 =?us-ascii?Q?bsJjOatt6arqiFHX3Gn5cd/H9s1lC2k8M9u60WqxI6AyIy59o+c+nLsOjLxa?=
 =?us-ascii?Q?viGEqZl9VvupFv2q7fqBs8hw3oN8r9eU0Ps7HsGbQRcExLo9T8dvhq/X6pu+?=
 =?us-ascii?Q?PNdV28BuaBFLNHhhO77O/HSKaa6ISN7biuGidRtJvUXxaIPguhGP/stPRzcq?=
 =?us-ascii?Q?vEelF/3J339w11uHM2pbKT/JeGqeHkjvrC4VUTyi1zkQxmvUVSFE8GB3elwL?=
 =?us-ascii?Q?QEOISV0sPRj03S+R1Z3/HadWdBFARFJExo59AE9G/Lj+ArgxlzBxAe8LCGrc?=
 =?us-ascii?Q?b+t8NiwFoOFkrPR1R38Dd/TNTDMrTuckYnN6MMFHzCE7aoRSzZCk0afESzBS?=
 =?us-ascii?Q?JQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c643ff-0057-433d-70d5-08dc3c8012a6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 19:19:54.8112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xU9nXzXh59JfcjGhkMXSc1qsIbi+KWxRU+geuGQvGiOWwW5B+zG6nrVx6SMepDcKhF7rn6xribb5Izm5kUzObcQx+tURVvchmJCbFUa4vCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7183
X-OriginatorOrg: intel.com

Lukas Wunner wrote:
> On Fri, Oct 06, 2023 at 12:15:13PM -0700, Dan Williams wrote:
> > Lukas Wunner wrote:
> > > The upcoming in-kernel SPDM library (Security Protocol and Data Model,
> > > https://www.dmtf.org/dsp/DSP0274) needs to retrieve the length from
> > > ASN.1 DER-encoded X.509 certificates.
> > > 
> > > Such code already exists in x509_load_certificate_list(), so move it
> > > into a new helper for reuse by SPDM.
> [...]
> > > +EXPORT_SYMBOL_GPL(x509_get_certificate_length);
> > 
> > Given CONFIG_PCI is a bool, is the export needed? Maybe save this export
> > until the modular consumer arrives, or identify the modular consumer in the
> > changelog?
> 
> The x509_get_certificate_length() helper introduced by this patch
> isn't needed directly by the PCI core, but by the SPDM library.
> 
> The SPDM library is tristate and is selected by CONFIG_PCI_CMA,
> which is indeed bool.
> 
> However SCSI and ATA (both tristate) have explicitly expressed an
> interest to use the SPDM library.
> 
> If I drop the export, I'd have to declare the SPDM library bool.
> 
> I'm leaning towards keeping the SPDM library tristate (and keep the
> export) to accommodate SCSI, ATA and possibly others.
> 
> Please let me know if you disagree.

Oh, missed that the SPDM library is the first modular consumer. Looks
good to me.

