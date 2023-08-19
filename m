Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9F5781B63
	for <lists+kvm@lfdr.de>; Sun, 20 Aug 2023 02:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjHTAIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Aug 2023 20:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjHTAIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Aug 2023 20:08:31 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45097186680;
        Sat, 19 Aug 2023 11:15:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfodHgUv7rf0Wz1f2zxdnKNsix21ki5iDBTxT3mXuEzHBA3XsQG0jBmA3YgCb/D7v61EbFV8TU6ncWHyq99hPpJl5CIKYkqsvqBh+NvBx8pbxu4v2kr8vY7xM/Iq2LRwoCWf34IxO+ETu6jrfDdioCk8g3ajiRrgtKX1APYE/nIYv/Xn7wFy4urXefyN2K7DiEwqTnBmYDZ1ZD5QA9J54qpzTGM/doxv6xUqmWdBnZNeCFPwPblALEVsKpl+l/FkPMgMxN3ukS/v1rFPfxunnTAnROVinbIHeylnHfd0Z9CjJ873+VX/XOnC1153Ce0HRAeQPlEQboCXMlpCaHWjrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wc6WWaiCUVtog9hhqGN/ny41/iYjjh3fuHK1Rc+sF/E=;
 b=TkBdWf9wEqZrArld5XqmbZj6NjJT+mxxR7wVF1Pltb02Vp2NZdqDrJtAKSy+cu+sTdgt/d0vfnt6GXToAcI4YwSacREPqNOK8RoK4sfcV7nMne+Qg7/gMPYm3TmBmSqSLm18D5OD0efFQJdJN+EOt3vvoFJF28EvDYl4A42F1kXGT6Bc33tB2VgfTo7LQUDQr6jXde2G4VbePWuiJcg/10DtMmZ3uFWgqPzRORfBc4xLkabDgUksGhBFsulwhWpoOMQdUL5U+kPMs+p6lVIGK1Fynzyju9xw5SlZCZqmzz9ktuswLPQOnqxfRCtmgJppNYqASm4huPS1SldXCVi4gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wc6WWaiCUVtog9hhqGN/ny41/iYjjh3fuHK1Rc+sF/E=;
 b=AmMhc/43MhtYseg/kZUAQ6bFwZ/ezfaOYCqKfaBUTvJj+bYeILsdZHoZhKG/HPXeLqc62FqJAbY/Bg9RDaar+6f/8DJgXdbHl4VwcAuzr7E68OeIlghdJfyHmhcUxOdkNnuzyCWW3T+WQmsOY6y6tniq8NA402XB4oo/VMw8A08=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB7597.namprd12.prod.outlook.com (2603:10b6:8:10b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20; Sat, 19 Aug
 2023 18:15:05 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6699.020; Sat, 19 Aug 2023
 18:15:04 +0000
Message-ID: <46efd108-8c3b-220f-1fa7-2f6a36f9c9cb@amd.com>
Date:   Sat, 19 Aug 2023 11:15:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH -next] vfio/pds: fix return value in
 pds_vfio_get_lm_file()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     brett.creeley@amd.com, jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com, horms@kernel.org,
        shannon.nelson@amd.com
References: <20230819023716.3469037-1-yangyingliang@huawei.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230819023716.3469037-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0203.namprd04.prod.outlook.com
 (2603:10b6:303:86::28) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB7597:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a390496-0f28-42b5-79b1-08dba0e0363e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4fRUuHFEkZ2Pm+BK615e9k2qIY71vklMuOIja+/06fMZeS4p5YQu8JD1ajTc8+wCelyWIhuWnmY0z4V3kRhPXaD1LEiCOs4OaAGaaNFgjUvfEyqOvfktGcwQ9pv56ZnW8Kwvbs18CytW9Zjc74Uo9F0kXGvjbCMXPkx/ZqqSJXlUPLj7OfhJdJQ3OJZqA9BcCIooCzu76m97pIsV8EXFN/UAyN8SivC5CwNBu3wsJnJ9ZjvEQ2RQMzmiQsWlNucYcmpCY6ebx3DMJPmaRdchX7g9WFUBd+tCGOG9uNTRvoHpkosx2LigZuFVfFCvZiCg2REmXp5nx9cZ8cocPoNPGDKcvnghKrXuAylkvI/6WoCXCxN5I7nfBomhG4rNdPZ5i9X86eLKVX37Gq/oxK7nRvlLDZlCpLEm0g4nQly4K9E6k1ABSXH/5dRfApB+4Fvf7barkvZQTKDbasQkAdYhjgxhm/4+1DrcG5F6TMn5Rfjv6pL7McxsGB8SBPxpoKy8RCxjb3InUtdHEA1d/zvdOmPrXFywAtMZLgxtkNh566LUP3Y5VmAAn81FHWJbvV6LSoIqxEU+Rm21RUnDlydm84WOI7GKFaPjlvCWzDql9wefLQ/Q3QOPCdPhS0unFIHykQt9bquw5nTBfps6xoWiUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(136003)(396003)(366004)(346002)(186009)(1800799009)(451199024)(2616005)(26005)(6512007)(38100700002)(31696002)(36756003)(83380400001)(316002)(8936002)(8676002)(41300700001)(66476007)(66556008)(66946007)(2906002)(4326008)(478600001)(6506007)(31686004)(6486002)(6666004)(53546011)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlFKS2lpdG9ka2UzcDFiMy9BZ0tyRlFodDdnZG1Eem1OZ2U2QTk4UGJsK2Jz?=
 =?utf-8?B?aUZZemtaUjFhNTBZTlBOUG5wTERicnh6V1VtZ2tVN0RCVlhXZUI5UFpiT2J6?=
 =?utf-8?B?THlhSXNqK2xrTm52TUJidGhEcnBuZXlJOVJ2a091NWFOQUN1a2QvakJkZWpE?=
 =?utf-8?B?Z0NOT29FRzBXWHNkcUUrbzVlN0ZKcHpxbTBmNWpsZUJMYW9DaWppdExFQlVs?=
 =?utf-8?B?KzJsREdqNHNQR0lZVGxtNFQ5MldoWXN1cDJHKzFwa1NKZWp0Yit4VFEzclZl?=
 =?utf-8?B?WTJDZUVibkFjcVFqRlVFY1FvRDVacDZuWVpOS3lrcTBaS1UxZjczOWJrNi9x?=
 =?utf-8?B?RUJYNzdieG5GQm80NytHRGYvdlpCSjZoZGh0TE9UejBoRXIzR1ZlOEtDYlR3?=
 =?utf-8?B?bTdyM21aTjhLRWpsdVlZQ2ovREMvTEN2MzdGaGdUUEczeHNMSzN0aXUyVUxn?=
 =?utf-8?B?dC84K3RNZllsSFo4bGRYeDduL1YvQzh3Rk1KNUF1Smd1Z0cyK3BiS2dhODBi?=
 =?utf-8?B?UXNKT0YxOTNHQ2NvbkwxQWovMXQ2bGtTNGRSdy96QUwxVCtOZ0h3ZUVWWm9h?=
 =?utf-8?B?YlUyZUp5SC84bE1tWW8yNXpBMG9YSkhjUmlwemxkVEVNL2FHZG5tSjdPR0V0?=
 =?utf-8?B?Y0xINTBFODM4SmpwMjFuQVdtQlRPY2hSdXJuckNuQWJ2VHVvbTArRWhzSXpS?=
 =?utf-8?B?eWFldG9hTGtHRVpVSEYwSVdmRGMzU1dHWVBES1NEK2dDcGpsbUFpcytpTmFt?=
 =?utf-8?B?UWR6RU5vMUI5aVNuSkhZMGttWG15dm1zL0dKamVIWFgxNGNRV2E5ek1KSEs4?=
 =?utf-8?B?S3JpY3hpeDBqY1ErSndHRnVXeldQOU0yNnM1S3VCVkNpUHNrdUtpK0dRdUVu?=
 =?utf-8?B?RWkwbkEyUm9xbEp2SGFkdnUvOXE1d01xTUdkUG5Id0pXOUtwdS84ODZWWUFV?=
 =?utf-8?B?MWR0MW1Oc3AvaFFQU24rNHNqYmVxS3pPNWpIcU96eGV4MDJwczJkQncwdTdY?=
 =?utf-8?B?UmZTVnUvdTVNclVkZkVkN0xIUGdMNSs0cWFrRDVzYTFxZjRTdmlBcVhNSmFq?=
 =?utf-8?B?akRBY3BITURQM0pyTkhnbUZJU202S1VJVXBab0RnRkxnajU4cHlsQStkdDhY?=
 =?utf-8?B?cmdFcUx4Nk8xMFBkRjlMKzNCY24vc2xDQVBKdXlYWkNhZGx3UGtDN3BMSmdm?=
 =?utf-8?B?L1FWWnFSdGRBb1NGWVRPRDBoMy9Rb0p6YUlZTEVCNWhTQklzbk9oQU8yVE16?=
 =?utf-8?B?VVRoSitTRm1TUyttNkVPTWYvL0R4ZlQ4UHZCWlhyRFE2L016dEV5N1ptbmY5?=
 =?utf-8?B?OHFSZnF2UW5FNzF5ejRSWDl3MW9DeVV5a3dEajYyRDcvUkg3U1NaaUtLcm9r?=
 =?utf-8?B?cXZuUWcxNE53K29KUVQyRC95NDRrSWZYVFRCQ0VVNXJGUEgxYjdUYlp6TEhO?=
 =?utf-8?B?aDJDdE15SVI4aHI3MVhnZzlmd1hkdHV5cGJnOXN6SERXanRydFVodXRyTWxH?=
 =?utf-8?B?bGh1Q0F1clNIc3N2MUo1NldCTHJHanQ2b01VT1FycEJOaFlzOVJrREhqMDdX?=
 =?utf-8?B?VmNjSmZFNTJaa3ZqbjV5d0VTSWpzYzhOWHo0clUxc01ZeXRaYlVoVXlZZVQy?=
 =?utf-8?B?SE5FR3lKamFnanFIYktHL1NjWEdGVlNCeXBPTlh0L3djeUYxWEg4dklWSloz?=
 =?utf-8?B?WmFldVhzVkFPTG1lLzVMbVNkbjM4ajlKMXpKUVowc0paSVB2b256UGE0ejdG?=
 =?utf-8?B?VCtkdHJBcWpsZmlTV05Vbkp5R01JV0lnUHdCd2YwbTdNY1JqSjA4d1kxVmVy?=
 =?utf-8?B?RGM4am5kTTdZY2szYXV0TGJBYkJtdnB4a2E0NENLaUtLaW53RDFrVCtzVWJU?=
 =?utf-8?B?bVd3QUJ0UE1wSHBpa3YvVWVIUFhwc29xWkZwNitNR1dmVmxoYURKU0FWSjFh?=
 =?utf-8?B?QXV6dUlsTmJudzE3REZIQ3dxbkhiUzh6bGR6YkpvZ0ZYS1pOaWVDOEZ0NldS?=
 =?utf-8?B?V2hqU0grcW01aVozQUNKeFRMVXhwUmV4dDNqYlVWMFdDcE9iWUlYcGNxVWtm?=
 =?utf-8?B?UXBCazQrSlhlMmhrdWxWU1FERTU1aUx2Q3BFK2t2ZVFYOHUyVkNmQnhNWDM4?=
 =?utf-8?Q?EB2140oGK5xItpOFS/6G5SSH/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a390496-0f28-42b5-79b1-08dba0e0363e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2023 18:15:04.8160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MwJph4Z81I+vp/kaZdW4bYA6kkpSWtJs1JEcl38W2ieDZiBuMnQKXulVgSdE0b7IT0/kX0UEsArX2yOpAOuMrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7597
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/2023 7:37 PM, Yang Yingliang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> anon_inode_getfile() never returns NULL pointer, it will return
> ERR_PTR() when it fails, so replace the check with IS_ERR().
> 
> Fixes: bb500dbe2ac6 ("vfio/pds: Add VFIO live migration support")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   drivers/vfio/pci/pds/lm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
> index aec75574cab3..79fe2e66bb49 100644
> --- a/drivers/vfio/pci/pds/lm.c
> +++ b/drivers/vfio/pci/pds/lm.c
> @@ -31,7 +31,7 @@ pds_vfio_get_lm_file(const struct file_operations *fops, int flags, u64 size)
>          /* Create file */
>          lm_file->filep =
>                  anon_inode_getfile("pds_vfio_lm", fops, lm_file, flags);
> -       if (!lm_file->filep)
> +       if (IS_ERR(lm_file->filep))
>                  goto out_free_file;

LGTM! Thanks for fixing this.

Reviewed-by: Brett Creeley <brett.creeley@amd.com>

> 
>          stream_open(lm_file->filep->f_inode, lm_file->filep);
> --
> 2.25.1
> 
