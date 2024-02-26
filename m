Return-Path: <kvm+bounces-9996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D43BE8681FE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:39:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89B6D28EC23
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80C4130E39;
	Mon, 26 Feb 2024 20:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JoSwcdz9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB3712C55D;
	Mon, 26 Feb 2024 20:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708979952; cv=fail; b=CxMYAmMS2p/NfbgeuZDUMhRucPElB1FwGGdZt787IcnnEub05R5pKnjESO97FndxjKLTVWDDuy/nmR7/bWRYNbfdfP+uMovxtv3dWw6l4LqFCPm0W+2R13Ro62Y1xZAUPeTc+FzRTd4eSfuFdIIYCyJm3G6LOo2FsN2HEnllWgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708979952; c=relaxed/simple;
	bh=tLyyQnGlSGNWsqz8G2K2bJxrJpFj8+pElUd/lCehEyE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iZ5nnDDGpSytKm6eUDbm+lWx2hjgIA+WyENJgii/BMB2ZUwiOsSboJSHlbKkX79+AWxQEcq5XpC3NIl8C0lePqsgo2gvTH89obDPTegKYix9HYyIle2c1R+ep+EH2DxWhdMhsyPPetc2cwSomhVvQZG3ynpbMKz3I/57HTels44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JoSwcdz9; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708979951; x=1740515951;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tLyyQnGlSGNWsqz8G2K2bJxrJpFj8+pElUd/lCehEyE=;
  b=JoSwcdz9IZAux3TBgOjMRXY+R2dOaCCQCPhzqEWU5Dj/SWjM5wCRcSOr
   sWroBVMhJuL6ZcLQ5tEmzbH7GGm3Vbi7fpf594WzYz+lQXgH2yWU27ZWA
   K9sN5bghCSPN1fd2C8RRhJPmzzn/vrp6wEsCo6pUraslDmBD8IQZEIQYo
   Bhe6jFjsncn6Ye/dmFEDvrQZGPvJC7jxmLkaeXLPPKfZp7veGAdX+9oK/
   0uT6VKH7rBLloN8cxvJNlmThhciHMPmbcmdkQI4vs3BoVAAN7AOQl7ecU
   9v6mxJoJouHRwk1qgJlawb3ASXxlKpqzqAQhynmSF9w6E3H0zwAVFY9H2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="25761093"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="25761093"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 12:39:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="7014625"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Feb 2024 12:37:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 26 Feb 2024 12:37:26 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 26 Feb 2024 12:37:26 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 26 Feb 2024 12:37:26 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 26 Feb 2024 12:37:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJAMuE2Vo0p1L0/xQUCdDwHJjRDbxOg+R8qCuhTydH2bw7oHbY9whnsmq2DNFoYmHPs8baS8cG17NiT5PvpwhkRgehArJ+JJfc9ow0X89muFSJSkZPu/ER88adHr3SE0gA84xg+VL1yzar4dHzu9TMlWw6RNTnY7m85W1RHmS2TJVBTRwJMx2FuE8vP6ribig0egczQG4Hg1QrtvmiXvaWoSVzTj9vOb9/Aw8vQABuARNeQZ5zNIVuR1+n28P+rl7zGlwFf/9PIyeLNskgp1ABW2F1BArHyYpnE3bsjtDK49A3UW8gSzxTkqBfyLBLmRxAiosw3eWLQGfAfVdnkB0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvn80HNqyUBIOvGaPnJPWqtQfd2XaOMul9yKqutB2k4=;
 b=ns0c+zHZJBQEY6LJKeKaJy1KABktwlYLmNi+MWcDWSZ9QgCr6U2w3s/E8b73MabsYy4sQZHMHK1RxoWjU90GsT3bjpRwzDuR1rO+eq9CzBslK6DzR9aRT5AdLhA9adVMsyAObdM16Y6w5FOYj3Lfu0GQbPsHhGrKhEdVnLdSQ52NMLaP3557S879upqjxyOhIX2tyLBTB91XXQ9Fyg1b6CNj643+KEiNE1d+AxTpHQz1nqCROH/h32nbgVHlgjT4bVshKfgPm2pMUHcHeKffXE9xr0kdWDsz+4EWAfJWpFXFNG3+A8hn2y5lGA6ZQvr65dwm7QONpYAWSNG46JHwbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM4PR11MB5246.namprd11.prod.outlook.com (2603:10b6:5:389::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.25; Mon, 26 Feb
 2024 20:37:22 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::90e5:7578:2fbf:b7c4]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::90e5:7578:2fbf:b7c4%4]) with mapi id 15.20.7339.009; Mon, 26 Feb 2024
 20:37:22 +0000
Date: Mon, 26 Feb 2024 20:25:00 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Xin Zeng <xin.zeng@intel.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>, <qat-linux@intel.com>,
	Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <ZdzznEkWExQXYj1k@gcabiddu-mobl.ger.corp.intel.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
 <20240221155008.960369-11-xin.zeng@intel.com>
 <20240226115556.3f494157.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240226115556.3f494157.alex.williamson@redhat.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DBBPR09CA0036.eurprd09.prod.outlook.com
 (2603:10a6:10:d4::24) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM4PR11MB5246:EE_
X-MS-Office365-Filtering-Correlation-Id: 94e7f714-e319-4a08-5578-08dc370abbf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IgTo/94Mki4Gqlnil2n59Hh6AJW8S3edJFZo0WhJg6iQRMDwrITd1RRE4FMg0sm1knJP7EWhj0hIUfp8TELHUx/OCTgoVH2Zs1U1W5CA1fY8n03VAmy2Icc1PCMtN+8Icg2SIPMJH8GOs/U2HlhWJMJn+gY8bA8TcrN+2Xch5XOT2yWAI08M/1hN+k2LsUhzaKUgPmt7XGYZhjuQBbLSYOV73b9/usXb8GbW29bifEdrWJPfvIKTRSSA7RTIcjlW8SziPd6csLAXsdOAknqNxryhuu7P/pE5L3fmx4vQYQT7p/jZ/y5QZRjl08ecoWgyoHr9HoLBIJnumt13BGXQRpa+vbZVINWga6JJDcYgUkRtwkSKQcfQXPQU3cHsVlToYYrxEni/UDzWxFglQkODK7vlDKYSuoONHqlK+R9r0CdCcLbMW8Da4b97ZveNvNC0DINuhmzl4WOhPI0RTyHJ0FTisyGAwYZX+LRPL1UOFitnN1P1vG1xSfk79Q48w6mspXaCsGRWiM+CpyYzXKmEah6DhH3SAlTCCuX99bZHcU/Di2e/CnMlegRIp1wzkA5cs6iRKcFZyYwAhfnrP2uwAsPmV51KlIpIwY3CE5qXtdR0+P6O6yegvImikzh+PjnT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TDTQC9Eusd5H28JuhmNyDcC76CwW+Avtwel9xwK7unOmOJrEyv+nu5R65M1d?=
 =?us-ascii?Q?/VKJyRg/ECS8Hk4LpyaXCkJqVxaRy3RxQOA01I3MfI/OFcdZrxnCKmmSuVna?=
 =?us-ascii?Q?JrdtT2Q3Q7gEUdU3B8m9yYXXXV71pLbqvrUkLaxBq8HXXmMp/VqG45fzO8KT?=
 =?us-ascii?Q?Y5ajYYkr1tKRpNBJ/uKgpgh2/GCZlryTWKofu8K5cjSmUQvqqQ//eMfM0Eh4?=
 =?us-ascii?Q?4d6AX0i6iHPwfO7z4Ci/mUP2g6QpXupno/Mgc+70m3g7+8lyNNdY40c6VFmf?=
 =?us-ascii?Q?dw30SEyaBT21+7h4TxkXdpSznh6VdSyDTPWzpWKsAe1KIbAoUK1iaxq+rJNB?=
 =?us-ascii?Q?sdgJwjN0MxSOtVqxC8KQxwIONGanar1bL/m2v1Tnimi02imSCBc99IKxkYnj?=
 =?us-ascii?Q?PnTQFH/jqDp3xKH5uBawwQkW/zWhFwy0rUr/DR9SZ3eZzTvV1qZvlH+q62Gj?=
 =?us-ascii?Q?uLAAqNrk/qAk2C8fsIZvLoNaxS91SRIz0Bxg0563LYfr1z6e193JnPMOlWgo?=
 =?us-ascii?Q?HsU8g+tEJMBkyMyyEcZILw/jr5X20NICcyR18J+556OSWJT++1cxKBw9HXwU?=
 =?us-ascii?Q?Q4W34PycmWpZ18mbGupTb64A/XkdsvNVMOgJ+4+0ibufsEC2WITzpYajYIsI?=
 =?us-ascii?Q?CqWHvT7S6995QiAWDw3zdV78NBbbpz6e6oyE+GnkXvMA9OMvoanjuRIP7ysG?=
 =?us-ascii?Q?a/WiNDgjpdiz+suHT03NlNhmo7FX+ki8fhWU5z+V4Iokjeb5Imh04bkdGDE5?=
 =?us-ascii?Q?ebmpesh2IYWZUS1vzMlcZFWHAkDdxzeLZ3Z+fqhEA+rOHH9BajJxxF6QvlXg?=
 =?us-ascii?Q?6o5FLnTiOjA5AGGrMgrfwPreJhRG9Pl+UtzVK0Om2Lk7D0ry9PI1HCJqtW+0?=
 =?us-ascii?Q?LisjHrGklooQUrRSKpPpMlLbaBRYX5/qS0AlIv4BkvGK6y4EcKd6kywlfWfa?=
 =?us-ascii?Q?4rCHZwMbqzA37vLQ3kTyOz/obY0L1G0DqbZB6X3LGzSHNsDHEFaIo1h359zD?=
 =?us-ascii?Q?3V5vVfXmckiOusd9SMQ28al1eTCSTeDtIJktAee8w2J1Yd6IuYrpU5+kOsGw?=
 =?us-ascii?Q?VAHE3pyCUE9RNstU+EHzlb/QFcekAlOIdHmdlObXMBfgqA252Y82mfBAXosN?=
 =?us-ascii?Q?gr3ZYzFkd/KSB4Dz/fGSskxoFxeqf7FijmxdVS0EKn70CVARD+ID94rM03oS?=
 =?us-ascii?Q?aQka4SxJtXCyNCSwM8bpC4OrQO82NbKRBuwNwuuW1zWN9fYbFnHvyqH6561c?=
 =?us-ascii?Q?DhgcoES7tDH7GUeKJ8OpM959zh5hyGh8Ni/W52KkwSCzUYsOKxvoRmumkECr?=
 =?us-ascii?Q?dNA4atKfGaO3kokjECWtuR0p4nfSKYOH8qx8oUh3OYr4c4ajI/PQb2I/yd+o?=
 =?us-ascii?Q?3o19WsQSWzZw3Hm/C24kc74P6DKMARNzDjtSyq40Omdc1NfNAXObhnKcIuPD?=
 =?us-ascii?Q?bk/OESGHqNYCegkyMvpqYTxJI4ETKNxg/TPKrexULfFcxRUmt+vegSoMcZhV?=
 =?us-ascii?Q?x+DUxZoTRg98KGZ2MTib6SjT2ZDqACDqkUhDWzZxP4LWAk+kymAqaXFmf4RH?=
 =?us-ascii?Q?UD2iATqXfISmU4XpFaWqb+/HFUG6x14zPA1ZHSxt2X3CLcXvgezfMZLBwOgK?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e7f714-e319-4a08-5578-08dc370abbf4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 20:37:22.4851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4y+NIEPMbRHfRByDuzjql2VSrEgowNyu1dVVj+NjzNHjctVZXmV1P+x4R3qwWzxSAUI3IvPYU5bNxONznjbuCtAHIYxP1SK7nFrHMv3hTpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5246
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 11:55:56AM -0700, Alex Williamson wrote:
> On Wed, 21 Feb 2024 23:50:08 +0800
> Xin Zeng <xin.zeng@intel.com> wrote:
> > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > index 18c397df566d..329d25c53274 100644
> > --- a/drivers/vfio/pci/Kconfig
> > +++ b/drivers/vfio/pci/Kconfig
> > @@ -67,4 +67,6 @@ source "drivers/vfio/pci/pds/Kconfig"
> >  
> >  source "drivers/vfio/pci/virtio/Kconfig"
> >  
> > +source "drivers/vfio/pci/intel/qat/Kconfig"
> 
> This will be the first intel vfio-pci variant driver, I don't think we
> need an intel sub-directory just yet.
I made that suggestion since there is another vfio-pci variant driver
for an Intel device in development that will be sent soon. I wanted to
avoid patch that moves paths.
Anyway, we can move this driver to a subdirectory whenever the new driver
will be sent out or keep both driver in the main directory, driver/vfio/pci.

Regards,

-- 
Giovanni

