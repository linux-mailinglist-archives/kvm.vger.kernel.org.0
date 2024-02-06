Return-Path: <kvm+bounces-8160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A4E784BF74
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 22:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DE501C22467
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC1371BF3D;
	Tue,  6 Feb 2024 21:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d1c62/5V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D44E1BF2F;
	Tue,  6 Feb 2024 21:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707256004; cv=fail; b=KWjHhQ9K3sLa+0dzHQFePlu+CSW/6E7gJVK4IgXrbCqz9riLfrxpSHSs21XbuP64TfxDP5TFqo02VjufGbiec/ET1fnFOu2MhxUnmy1ADc33fHc+goymd0tcPdaFdo0fI959Lievu9R/1THJezwVe3O2sT4ZVBMesiEGRH+5zoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707256004; c=relaxed/simple;
	bh=J/ME8i2UX5SamgaeaLRDvkjKSSP2UTdlgOncARRyH/0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kb8CDVa0xC1dyufpCAQ9ofhTxvQB37QscLbIXM8v9PvQWQ9W1u5CpH/MThkzINmoANt7DV27eDubdgbQ7GkGY5slR7pxAgkx2u9E2aHDgkyX+GOggBTIdPaaDR2kA4a1kZLN3evIU+LamnxVFCA313Ux3HtmuY0DucMyWQ8uNTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d1c62/5V; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707256003; x=1738792003;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J/ME8i2UX5SamgaeaLRDvkjKSSP2UTdlgOncARRyH/0=;
  b=d1c62/5VTcat//lEiKVVvqPXKC1Tb1BXRUCKJ/12OCf5OxFgZrTz9j1a
   K7gDBJUkF+WTnHaML8TF12ZxBaN8UT/17Wi2mDt2yltX/0kpnVjN009gG
   qGN47Ae6nYzLcKE3L68A8U1wBSrsaaAAjCb6yWV9IrPAsWZH7wTtVXH1/
   VLHkrTqStFNbBjlR7hc9SYkYT7OAZI0VR8SiaG38C2OMnMGHcXzpv5kIO
   BeAGz6Q0NxR26PPv1Wgym3FL1WDmmvgRT/tquzQM+ptYEoYkcV7fULFIC
   PNQA4HFipvNlMb4/kKAOP7y/yMHvjERYa8uPF68CJ7q76o5AzmTUSiXwl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="760859"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="760859"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 13:46:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1486445"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 13:46:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 13:46:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 13:46:40 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 13:46:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JdqRB43Wyk0jZQnDCWWz6dCrJaXLpqs44g7NTTj7yIUbPEVraXQnPMhVbHy4avmS2ATqsAXHl2N7d3oNJ7gnEnfm0W+MzVsfvxdHdrDtEL6SK7naj41j2YxdS9bxrvh3v1DLuA1hITuctsIP+a9omFk7U3/xbuAcGUdIc9RBaf1I6uQtHy9H2GMQdq6SA8zQj9TPoqJyb9llUPtatyPUB36XaTZVvxYzYbWb6UE9WqRfsbudj1h8xt0/BMYjM7hqgkQhi2y4xjC7ffj6Z19vHUKFC8IWrR1Ry4ydsdNs2hNezwj8bSugyilVb/Ku5d4EWVJzlbbp+jzu3mUlA/LVEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rimesGS7MoHumt8RIbHX0QzG4eodnhqS+leLfqb9bCA=;
 b=n8yqWSfQkF6I3cIW9x24QGVWByunit72QVq+qeE4qa2lKBr2KmKH7pBTJd03bsSAG1iE/3TgwjQp2CT6QvFjnkg+F2yOYIo3LYOgE2de+KclK99sOS9jKCqBzL6ohoCc7Eg03LwAoYxw9Gsj1UtZ76eqISAgbQHQ2+qExPnKc7zlaxj4wsOFfQDGVWlyVbzMN9xyOsiU3xkcYp7EwWtHVu/spsCYTo8bJkzaTAR+E5XYpZTvHRpA8+75xuD7sjKR2eWFvEeRJtAlb+R6B8c8jtZQa/sLZHJxmXPWvDGp04PoZ2hnI7gFGzTtkNRfcDch5Rl24DxfxnCPBUOKNBvcvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7073.namprd11.prod.outlook.com (2603:10b6:510:20c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.33; Tue, 6 Feb
 2024 21:46:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa%7]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 21:46:38 +0000
Message-ID: <5784cc9b-697a-40fa-99b0-b75530f51214@intel.com>
Date: Tue, 6 Feb 2024 13:46:37 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt types
 use same signature
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1706849424.git.reinette.chatre@intel.com>
 <bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
 <20240205153542.0883e2ff.alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240205153542.0883e2ff.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0021.namprd16.prod.outlook.com (2603:10b6:907::34)
 To SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7073:EE_
X-MS-Office365-Filtering-Correlation-Id: 68f3fd4a-a19e-4918-febb-08dc275d18f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IAmvTcsDyOPpslxGKBtUsG6SaB6yaytDaqUICj+ucZTYCR/9jRdbRL74SglGTEpHa1A34AWGWVtdlgSbXuERmhFsV42fIQxb8KG1tFHfV8tKj0sEKtUvI5WnqVo6gXIlarebTkKLDGi+aPR6su7SACTD2uot18jdjPWqlTpCwnforMKxrApYjd5O+d4JuMYgydTC+uYTOpMyWgB5ySbdthMK32VvRzY61ggWm3m9b7fE1OsgcjyE83VXOeQUgHysNsn36wDJSjaB1QYYzcqbvBi3zlwVpXpd4CKmiBEjqk1ALOpJIKBW6uCTkRSN2k672JFfF53o3O3PbpY31BJO3vBpxzqqY8HIAryq8p6wDmOrPvQXZ4M5jf8hI5MMpeNyVaL4VNVpe2H1EoPoocMTE5BV9LjS3kFqkSR3wy2Ui4513CAq6bjz99q5RDKicmYRPJ1Gd73IkFREwlUdt4EOVxLHKTD3oVtuTnou+XHN83zwEJGqvhY77zgXnJmUdQuTwxh9Vc3fBTEzI+B34UpMzehweryyvTdKV2kdoYncQLDsHKZT11B3SKWdh1t73UU96RzHOkO/A0CNaHTe4dyE2gvaILrHeSU++DxvTg+7foLXY/MY26bXMuuNwsdow7FyJIaREOds3xcMwxJPNIpsVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(136003)(346002)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(36756003)(44832011)(5660300002)(2906002)(41300700001)(6486002)(86362001)(2616005)(6512007)(83380400001)(26005)(31696002)(53546011)(478600001)(6506007)(82960400001)(38100700002)(31686004)(66476007)(66946007)(66556008)(8936002)(6916009)(4326008)(316002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WExTSzhtMFBxbjd5dFUydTdzaXQwc0Q3a3BXWkVuR2N1S3E5RkI1VjNxOCsz?=
 =?utf-8?B?QlA2ZGJDV2c5RGg5a1cxcWIwY2ptTURqcTdhMFJuZ2UzLzVrdjBkUGx4bXRz?=
 =?utf-8?B?TTNnMmkzZ2tTM1R3NXNtQ2hWUjVmazFQTi9SQzU5L1Z1NnJxTnZ3MmZWZFM2?=
 =?utf-8?B?UFpKMnQvb1FtYWVyWU5lQmh4RWVDN0V5TkpLQzJTRXVDR2p2MTNhSkYzUTlk?=
 =?utf-8?B?cERsb3FMc0hFdGNsOE5nQTZIcDVQODBQNGtXVHFUd2JhUnI1VGk3cmZCYWJQ?=
 =?utf-8?B?MHAvTzhNN3JPQm1JODNieC85OXNLVVFMM2x4dUhmRWphL0E0YklOcXBETkZl?=
 =?utf-8?B?cFltWUdDcjY3SGk5cnlCS2lDbC9OODJSWDVtSFRoV3pMU25UdWxnQnVKUmx2?=
 =?utf-8?B?TlZsbmJxVmxYS1VxMXA0ZlNuSlV6NTFYSmsrNHVPV2o3eUl6bGxud1VhR1Fn?=
 =?utf-8?B?dDFYMTBaVFlPQnAwWGtodUFRTXcxY2FYUHlvamdWVFZOVjNWRXlvSGgxUnNS?=
 =?utf-8?B?ZU1TcE5XQWdFRHozVFZFVU8ySXU0ZmVGSjFoRk5BSVJHRklSemZuNWJsS1k4?=
 =?utf-8?B?RGtJUDNUYUxKNWJUSWhQYzVjNmlCRzEvTlhETGd5TktDSXNuV1I5Y2VjOGF2?=
 =?utf-8?B?dUdUTTBBb1ltKy85WUhOYTYwK1BFNnFYZFcxaDY1ZmR5OCtUbGg4YVRxSTJq?=
 =?utf-8?B?UzVVSjhJbFVJWXJRYW5henlDZ3dBSWk4YklCSXBTcUEvYm40ZGhEVEszKzds?=
 =?utf-8?B?ZlNRZFNxTVlXWExBK3FhdG5YaHFGaTNjQzNGVW96WHhDRExXUlVmbXIwUE9p?=
 =?utf-8?B?VDg5NTNnc3MzQTkxZGNiVWNJMXNib2J4U1hVajFENlk2VGZqMlhTSGNFTDQ3?=
 =?utf-8?B?eFhiL09FRU5abkc1RG9TdE1SWXMxZ3h3dUwzdXNwRUZiWm9ReE5PNC82YzZO?=
 =?utf-8?B?ckpkR01HV1FHQ0VqNkh6cEUyQllhM1YxVUxjTzRqa2s4bU9ZaUI1cXhSYUZa?=
 =?utf-8?B?ckxnaHVjL0MrN2FzMjk3SHppSGROYjM0aTNXK2kxVWt1Z0lHeVREZ2xicFZj?=
 =?utf-8?B?UGp5VmNuUXRUL2JBNTdCdE9sM3pzYWNmZ0VGQjk3cFdjZWJWMkw2UjQzVUFI?=
 =?utf-8?B?SnNvNDRmNCtGR1BKUGFKNG16cnFBS2tHYmUrYkIzY2w2eDFBU0ZJbElWV1RC?=
 =?utf-8?B?Z0YwRHV6YlluOS9vZ1VncFZSRmxFaDFWTHlzQ0t2TThtc1JSWmI4UEt2d1FT?=
 =?utf-8?B?NVV0ZDBGS3dBTHB6TDZzRmg3SmhxZXRianl0ZEtBSGp2RzdmOFJFTmVNUklo?=
 =?utf-8?B?RDNkcG43cTVPcFhIWlVSZzlzYzFJbXZjVXFXVFFHMFU5RVc2Rk1ZNkxMYzI3?=
 =?utf-8?B?RTJIYVBxaXcyL0dkVTdSZlorQ1A1YkhtK3RBNnh5VHpET2dCbk54R2xEZ1N2?=
 =?utf-8?B?UVJDY2w2c0hYakNxd3dqbXlSdmJZT3VMT3RPdzFwR1EyVlhDL1p0N3NaTVBu?=
 =?utf-8?B?bXVxWDVUUm56Rm9HK2crUkFSblEzSUV6OHhqTW1uQ2hkb2ExZHp0YVBFcTZz?=
 =?utf-8?B?QVk4Rm5xTENZcXE1V1BYWUh6Zi9IUUdSWklCaFV0UGJmRnRLdXdWdTNKT0x2?=
 =?utf-8?B?Y1czUjRIR3F5WDRhcThWMEluajFvVFJzNmFGMzhmNWZZMDlIWktNdFAvQWIx?=
 =?utf-8?B?REJZQ0JPbDBZdDZrY3NVSHJRQlo2clVTZTVmVWxnR1h6bGNOQVhNNGFmMTRR?=
 =?utf-8?B?MWdwZDRrUUd3MlR4S0RLNXhQc2ZVNFVyL3dUUStaenlLK3ZvSlJEbHY1NTFN?=
 =?utf-8?B?dFN4RWFTdy9haStPS01nK3QzVXEzbWRUQmU2VlJucnF2WHY3QzVrZ3FLNVEx?=
 =?utf-8?B?Vmp5aERnQzM0S0YzYkErMGVZZTFCRXZYRzYyVW5WMEJuemp6TjI4MWE5b1Fj?=
 =?utf-8?B?VjVnQ2RYdHU3NjJhamJOYW9hTGh2OERDaHBaUHllbDZyU20ycWEyeFB6TUhj?=
 =?utf-8?B?QnVkNGZPYUxiOXVWNlNXME1lYkxYUzlHS0tleGxqejA1REhpRFIxN01uVlBF?=
 =?utf-8?B?QmFyc2dmMFRSbXRvdlpaaWplUzVBbk1zSkZ4dmtZZW5pVmR3KzZVUzhJZjFL?=
 =?utf-8?B?aVZidTl3VWF2M1MrMWhYM2lENzNTZ2RDUXY4Nm5Kb1BEelVuaXRWcm9xdXdS?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f3fd4a-a19e-4918-febb-08dc275d18f9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 21:46:38.5438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UoZ9xo5VeHWY+ULROUhfM7NlPclpbSrMIb/lR2+d1se52xlImQynEs79ekybfE0zekwdXxP04pWBc/g2/rUXcaKHdDjOhdub1kyugdhuTn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7073
X-OriginatorOrg: intel.com

Hi Alex,

On 2/5/2024 2:35 PM, Alex Williamson wrote:
> On Thu,  1 Feb 2024 20:57:09 -0800
> Reinette Chatre <reinette.chatre@intel.com> wrote:

...

>> @@ -715,13 +724,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>>  		if (is_intx(vdev))
>>  			return vfio_irq_set_block(vdev, start, count, fds, index);
>>  
>> -		ret = vfio_intx_enable(vdev);
>> +		ret = vfio_intx_enable(vdev, start, count, index);
> 
> Please trace what happens when a user calls SET_IRQS to setup a trigger
> eventfd with start = 0, count = 1, followed by any other combination of
> start and count values once is_intx() is true.  vfio_intx_enable()
> cannot be the only place we bounds check the user, all of the INTx
> callbacks should be an error or nop if vector != 0.  Thanks,
> 

Thank you very much for catching this. I plan to add the vector
check to the device_name() and request_interrupt() callbacks. I do
not think it is necessary to add the vector check to disable() since
it does not operate on a range and from what I can tell it depends on
a successful enable() that already contains the vector check. Similar,
free_interrupt() requires a successful request_interrupt() (that will
have vector check in next version).
send_eventfd() requires a valid interrupt context that is only
possible if enable() or request_interrupt() succeeded.

If user space creates an eventfd with start = 0 and count = 1
and then attempts to trigger the eventfd using another combination then
the changes in this series will result in a nop while the current
implementation will result in -EINVAL. Is this acceptable?

Reinette

