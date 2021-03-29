Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A516034D122
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 15:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhC2NaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 09:30:01 -0400
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:31489
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231219AbhC2N3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 09:29:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzqoqRLa5LkFcUV6uv3fGlS+/foSAGw3G8aEB0pRQ4ACZrMGuEQ9FC1eIZvAbgEA4A/pi6ro4vOTzO2KXroWzrRaICiKc2WErHLYLfIJjFSV+g0zJm2iezZ1kPoQggUoY0UkQQYjfky8ArFVEr1KV6Pdhxdl1smc1f8wTfrSfAwOjT9Y6d2VCTDnK2uSueGl8zbP+YwmGN4ZxW50WDSBROjltnHP7LVTWEyy/AH2PsZeanRFsTF/2B2P5CB4s1zSnHSxX2AhfAKX6y3lXIw3/+q0m/zYH55YWDLNQMaLZf09u8jPU8goEjI97eOGfWhLX9DWkFfsa0KQ7ftNqI9wfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=729qrDSQ9IEErNxVk5ewoli8SlnFr5eZUF7zON8xjyI=;
 b=ofQV84pIc+qhc0CZCbkSOjKneEFQQjayLaoRxUGjrX7g7/2KiWQyWWj6xwOidxP1S9Jg9UOnReTA4xwcvRWC7HgJ7luXEhsvfKxvIzhvMIBjRS3hFkoXsAGmynHgGG35nV1gOvozbVzAzY7I09orC/RjbUMS6TmoK2myTDreuuFUQ4/9ol3R2FQIaqcUwjOFfM8C5l3AzstBy/ejXBE5Zr2QBJ8n01TPFb6PtY8repzG5TlaepobJHioJr/a3rFR2/SH1AOdHReSnammXtz7+IoZ/QB7SW14Mxg1T+Br75rXMJ0V3uKj54G+EtHw8dcUDekwrLM0fC1Av8SQ/UsqEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=729qrDSQ9IEErNxVk5ewoli8SlnFr5eZUF7zON8xjyI=;
 b=VSc0h2Bfbz5jCVrPyZLZWwgyg3dDFYA6J0AlLm/CzXLkr4zD1ZT+Rt1/V0SbCziRhSyBmmZqdtC6TSL6tD0EvtuM7rlNPIri/t/1VHEy19vcjvaXFkzuUIFeQC2GA5FSgJ5Ax2BUxXCYT0VibhvOIfMIFzayc1pJgzT/pD257xyVW+UIoqVYI+AdVQRofe/aUVicXifHoAivnVynduBsUJL6CIxwP878pz5zoBc+7kpTo0XlWssDNDDYBj2eoIdwgSOUpmiAtDHwysKoxWjCVl13ocHfc+I6El88nSmon9n+PUdHnhi9jWF+WuwFNjMDoEW3VthhFMNgeh30rHBJSA==
Authentication-Results: ffwll.ch; dkim=none (message not signed)
 header.d=none;ffwll.ch; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3514.namprd12.prod.outlook.com (2603:10b6:5:183::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Mon, 29 Mar
 2021 13:29:42 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 13:29:42 +0000
Date:   Mon, 29 Mar 2021 10:29:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] mm: Add unsafe_follow_pfn
Message-ID: <20210329132939.GA1168773@nvidia.com>
References: <20210316153303.3216674-1-daniel.vetter@ffwll.ch>
 <20210316153303.3216674-2-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210316153303.3216674-2-daniel.vetter@ffwll.ch>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0081.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0081.namprd13.prod.outlook.com (2603:10b6:208:2b8::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.16 via Frontend Transport; Mon, 29 Mar 2021 13:29:41 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lQrxb-004u4f-U4; Mon, 29 Mar 2021 10:29:39 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e84875c-1522-4706-6b60-08d8f2b6b578
X-MS-TrafficTypeDiagnostic: DM6PR12MB3514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3514105C66A9516B629D6A24C27E9@DM6PR12MB3514.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6I89oTpVCFgoeCQdG6nQu7k8Y1TitSzTwFzUD03mWssD5Vd0/AnQRPp4vtZjT3cPuEyPNMD0bB93FtpiGRkbrR6ViqYmNMnXNGxCJBqilZtTUT6z/QFOmjGs3vogFqlSIqmkbclKhZS2LL3wqoBpOk1G20szal4illaTkD25JOerAxRz6TERce3EmaBvYwHpvDeZMwNqe+ZaKoZGhknbPg80Up7VZdyliIBrFBn1QT3G9mGizOO7dBSsKmqozfto9AbU2stzubo0LIn97mZ7xMXkJRKca/Nzo+vRVGUXun01cMmc/IJT5Mwq61MlnWQxyMb1VmAU85//khozhti6Ww/M9NkYiBUXl/9+eqqpkgxuC/38MNTzZlT3aL48BhLXLnzlNP+iSf4EviPWj8sEu1GLuF5zEqZAP/5RHcOnFToSvXUp++ytimUY8FDLmm+LSh0YU7/nVlGyJvE1VAvDwx8zWTlh36TUF0ggikJAwStWS1bnLYypOVQom3K2eFT/K/EOEkb1CyRZ6UXagS6dUjt+X4S8II4J2GOhJ7ofvyKdPXSjyH0lCpUNkO1kjANtEf7gywnVTSPRwr7mPzJTjQRT1axci/yB6O0GdV2DstFLq2VRutLx3aBIALMGM1LSMjljvcDKFxfLicG6NwX4ciYR+nEEFwtdggufB1i5zK8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(4326008)(33656002)(7416002)(54906003)(2906002)(38100700001)(26005)(478600001)(6916009)(36756003)(83380400001)(8676002)(66574015)(316002)(8936002)(9786002)(9746002)(5660300002)(86362001)(66556008)(66476007)(2616005)(186003)(426003)(1076003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZnlFc3lNQTVPUEdlbFBnZ1N1Vzg4dmMwM2o3TUwvOVcvaEh3Tml3ek1HSlFR?=
 =?utf-8?B?dDBSQzJKS3lxaVgydHVIRzJkaUd1T011QzlLYjlmaUhoVStCTTg4aHM0bmtO?=
 =?utf-8?B?L0FWTlZoN0NsOU1INDByZlEvQk0vcyt5Z2ZhTmFpNWRtUFJtMDY5QzgweWtX?=
 =?utf-8?B?UUNua0luODIrT29kVVN5cEVpRFg4SzdGNVZHekp1VytVRTZraVlZM1pxd3FD?=
 =?utf-8?B?ZDNaeThDdzY4M1RYcmJROFhuNWZmc2YySlJ0c1ZEME13TXJSOGF2UVVqTTNG?=
 =?utf-8?B?K1M5c1B0bmtTTThodmM0Sm0rRDVKTXJUQWlwTUlLeWQ3MFF2VStxeFl2S3FR?=
 =?utf-8?B?MnYxR2xDUXl2UFdJT0Z2aVFzSE1xNE54S1Y4aFBIUU10SHk4dkJyTzI4aGND?=
 =?utf-8?B?eUt1R0h5QnhlcE9HbUM3SDloWVdqMHZyakwyZC9YZnpqTDVuaFMrQU84YU1J?=
 =?utf-8?B?UnYvTFdjZ0NKejMzSHpSUmNIRk4wTjB4NEk4VDdLcEE3L2I0VHQ5ZmpXTFJQ?=
 =?utf-8?B?ZFlldGI3dDJlMWdCM2FOZzcvWm80VkduYjZvbVhDUW9DbFBiaFN4MU9Rdld4?=
 =?utf-8?B?RHhmbHJCLzVQdlU2akRYQS9FSkpEVDdsMVc5SXpRMWpUUm9pcjl0SDFNR3Bp?=
 =?utf-8?B?TWxld3EwbnIyTjhkZ3hBSXRteDBxRlFiSVRwVllnUngxczFHcEVta0g3NHF2?=
 =?utf-8?B?Y0I5aFFid28wOHI3RWRTUnNCVWxtdCt6aWpQVHdWSTV6WkNBS0lNT1l0SlRY?=
 =?utf-8?B?YjVQU25XSjJIamwveS9EQmFZWUN0eG0rbFVDa0dCb0tPUmhHdnZNNFNROEU5?=
 =?utf-8?B?VStqejRMVkhIVzVkSkdtcmFhN2pTMHg1UGRXa1dUTmxhekFiOE5QQ3lpSnN1?=
 =?utf-8?B?NWZNQXliNGU5SzdoUWt1MXlXY0xIb2tkMndaT2dxS0lOUVU2eC90NXhIMzBI?=
 =?utf-8?B?aDdnNDFqd0haeWR2YUkyeHdNWm1GeWJmU2FyK2NsMEoxYVZDSXhvaUdlUGo2?=
 =?utf-8?B?T3N3ZnBaY1RhdWpmRlRUVzB6di9Gck5Uci9LOFZJQ1lpQ2s1TFVVR2EyTmFK?=
 =?utf-8?B?NkNoOThZMm44U2RQdUd2NGl5bnFabitmdHhVTkR2OERTTFBEeDhEZk5GNW5D?=
 =?utf-8?B?K044Z01rSUY0Sk91T3YwMitBQm5tYVlmbEs3SFRCUEpKVldTTlhtWTd0bHVB?=
 =?utf-8?B?a3dxUndmZkpkNmZkK3pWZ3hhY1c1em9keU5WU0V6azBsZ0x2a3I4ektWM1F4?=
 =?utf-8?B?YmEwVkU0VExydEplV0dyOExjNVBwWkJnRU10YzZoZ3RTMm0ydE5nSHVMaGw4?=
 =?utf-8?B?eEtIR1lBd1VKRmVSVDVaVWR3Y3AyR01ENFk1R3RwR1FhUTVlMGVTZUF3Zzcw?=
 =?utf-8?B?WDhBTEpKUFZ3SEdramhVM2tYaVBselB2L2FubTRybVpIQS9tK050Q3h6My9K?=
 =?utf-8?B?YktaOVJDUkJBVi9YdklXVTRHQnRnbTZYS3lmNUhHQzRaSFAyNXp1T0t3Y1NC?=
 =?utf-8?B?Y0IzUUo5TlJiSU0vNXBTL29rRGZjTGRlTHVVTlJmcXFiNFdYbzlweHdrb3Y3?=
 =?utf-8?B?VDVXYkdaeDQ2cE45TzN4bkVNVkg2MTZjbEdwdDlKUGpqc1llMldoWmo4bG9m?=
 =?utf-8?B?ODMzZ1pCWnVlQTdqUS9FYVo5eE05QVBxZVIvaUFSZU0za0ZHajlabjlhUzc2?=
 =?utf-8?B?aWhLN1NkVU5yajZaY0t5TWMyalNKbktRVGY0dVJNOUlIaCtzaDRlbkdSblNw?=
 =?utf-8?Q?UQXiITZZYz6tU8FZl4AlgxGueCpz3WtS/HUHmoS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e84875c-1522-4706-6b60-08d8f2b6b578
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 13:29:42.0809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IsG1ZgaZN4VriPnotgDifhDjwtODr+Sv2l3nKXn58smn2UpLfJ5mjA5PAodrSIko
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3514
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 04:33:01PM +0100, Daniel Vetter wrote:
> Way back it was a reasonable assumptions that iomem mappings never
> change the pfn range they point at. But this has changed:
> 
> - gpu drivers dynamically manage their memory nowadays, invalidating
> ptes with unmap_mapping_range when buffers get moved
> 
> - contiguous dma allocations have moved from dedicated carvetouts to
> cma regions. This means if we miss the unmap the pfn might contain
> pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> 
> - even /dev/mem now invalidates mappings when the kernel requests that
> iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> ("/dev/mem: Revoke mappings when a driver claims the region")
> 
> Accessing pfns obtained from ptes without holding all the locks is
> therefore no longer a good idea.
> 
> Unfortunately there's some users where this is not fixable (like v4l
> userptr of iomem mappings) or involves a pile of work (vfio type1
> iommu). For now annotate these as unsafe and splat appropriately.
> 
> This patch adds an unsafe_follow_pfn, which later patches will then
> roll out to all appropriate places.
> 
> Also mark up follow_pfn as EXPORT_SYMBOL_GPL. The only safe way to use
> that by drivers/modules is together with an mmu_notifier, and that's
> all _GPL stuff.
> 
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> --
> v5: Suggestions from Christoph
> - reindent for less weirdness
> - use IS_ENABLED instead of #ifdef
> - same checks for nommu, for consistency
> - EXPORT_SYMBOL_GPL for follow_pfn.
> - kerneldoc was already updated in previous versions to explain when
>   follow_pfn can be used safely
> ---
>  include/linux/mm.h |  2 ++
>  mm/memory.c        | 34 ++++++++++++++++++++++++++++++++--
>  mm/nommu.c         | 27 ++++++++++++++++++++++++++-
>  security/Kconfig   | 13 +++++++++++++
>  4 files changed, 73 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
