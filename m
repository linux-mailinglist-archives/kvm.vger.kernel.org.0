Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7C73F6B92
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 00:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238716AbhHXWLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 18:11:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53826 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238734AbhHXWLO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 18:11:14 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OLbBZe015031;
        Tue, 24 Aug 2021 22:10:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+8KUNJlY3hhpJxiVsMil9ZHjhHtYQnlBOvwP1u5ZVbM=;
 b=A3kWBClzmimYm/qCNFpmhkodCpDayV+1lYcRmC8aLjyvUbntWfyQWeBsPQCZN1ONnIe1
 iG3xPjPnTzTtWvmbBZDekDVdi6IQ1We+I5N7ELO14IuLKFofy1uvdxdytu6tlOfYGHHl
 NX4pzre3HAeiQfD7zKlWKlxO7y3IeYbCM8RtFhidU2TCG578hHFrywGciAVJQ8QgtU88
 ebClFGT8cz7fB2HZuGw1zhXg6zWP5iV275d3KzA1VqSEXr2N212fQNya+d5KCFQ1NBaF
 KSHWRM1sKnigF2qVTSm0Bqx3ITc5sj/jRnsr3F2I/p0nBFxbjPyg27VKmL6bi4anZUBY 4w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+8KUNJlY3hhpJxiVsMil9ZHjhHtYQnlBOvwP1u5ZVbM=;
 b=rvQqCtccaqXIVdqF2WJZylDI6BFQReaJLwWKPCsJFBEyb2gQkwO91mXSepgKFv1mUU/n
 2XUyXl5ugS5DDvZ8iFszdSfNUl+FLpnixFIjvQfETHe9a4djVJ0gaArXzAdJj50Il9d3
 Xw1Drfhpf/CIVHUcniv/eZ7TgVrj1sQiqqt5I4FIsPgvdz2ggcEsRAYL+fDJOTRkGP3I
 9EhpxQ5hecDtX5mEn4ucHOjrCMTVAM7YSF2uhRVS7YIG3KY5m2P7v3LJIfQavHVrlftg
 fpoJeE3mN8HbKPUDZEf08px9hh4krxjTtjf660BhDWCqHrUtSAfwg0zyfdJZ4W4hVqbD dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amwh6hwf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 22:10:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OM5GBO134902;
        Tue, 24 Aug 2021 22:10:12 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by aserp3020.oracle.com with ESMTP id 3ajsa62g2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 22:10:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8HPWag19yB3ZqMYmd6Fmxb/QSAdsURElh2W82wQ691HHAuyE0irW8JWQb3UfcRZ0HJx8GMwhTSg5m6Y7cWYLAyRs90w/tIGTkfY0Ft7EOCnqBBvl/oWtMTI+/WskNDEIIOL0rv7pbkLm5z00N9lAwvgaLEDpQr1e3AqY8AVbf3SxiEGoVzF053sS24KgOQ1sdh1+TPBSqHA0Ya/WSA4HCs78ZUA7pePrvZe8JJMr/jrYSXQYvyCQgKWX+3oSiViZzCaM1jDTatv/rN3vnb68l7ePrqEK8ES7bQZ4Z2WX8/lXbUp4gRJ+XqHkdTGqa9mVWzOYN69RIffwwjf5FlAQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8KUNJlY3hhpJxiVsMil9ZHjhHtYQnlBOvwP1u5ZVbM=;
 b=d9hegwu5xepx3aIEtr3s5XW8B15uAvDMS/dWRRhgAu7xCWrig1se3gLDGXb0v+xlU6yfeMFNLJUSsckf/ZPVSmxmr7Df39OxJkBaIQnHKsC3Pt+Xczmrs6MHAKJo5P0yPWDOl7Qk51sL2fSsKXKy7MhT+CkFWAxakIfLIJNXY7H9FbakFf/Om99WjLqWDyBCFvRzNVSu++8y1QGSjYEkylOHm8qZuPjj792DOcmf7+ZPw4juvQVyxhKI/mAww6e01MrKr152hopZITqdIathYF3MQcCyZMRsd3hkmrcIRmpRVKCG8PdJiumwneqlE4D71PvRr8Dfed7BwqtAHDRxJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8KUNJlY3hhpJxiVsMil9ZHjhHtYQnlBOvwP1u5ZVbM=;
 b=j+edcmUQ+/GYmuMHGqxQeeFe/8TTSdlsr8WOstAREdeDOXGEY6i4ZYUijlQKN/LjTcXYYYSv01goipHYSsElU0LkLlj2UYRcuZsErcxdw3YAnR5P2C9OQ6+4hp3uhdy3bV530AqX9X31bGidT0srBuvYpUb7TNWa7q5pRZA1dYo=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM6PR10MB4281.namprd10.prod.outlook.com (2603:10b6:5:216::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Tue, 24 Aug 2021 22:10:10 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::f9b8:94dd:1c44:cb2b]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::f9b8:94dd:1c44:cb2b%7]) with mapi id 15.20.4415.023; Tue, 24 Aug 2021
 22:10:10 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/6] x86: efi_main: Get EFI memory map
 and exit boot services
To:     Varad Gautam <varadgautam@gmail.com>,
        Zixuan Wang <zixuanwang@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        Hyunwook Baek <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>
References: <20210819113400.26516-1-varad.gautam@suse.com>
 <20210819113400.26516-4-varad.gautam@suse.com>
Message-ID: <6bca2840-467f-ca90-0409-f36f4801bb4f@oracle.com>
Date:   Tue, 24 Aug 2021 15:10:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210819113400.26516-4-varad.gautam@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SJ0PR05CA0135.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::20) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SJ0PR05CA0135.namprd05.prod.outlook.com (2603:10b6:a03:33d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 22:10:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1ded38b-0654-4d08-2d05-08d9674bf01b
X-MS-TrafficTypeDiagnostic: DM6PR10MB4281:
X-Microsoft-Antispam-PRVS: <DM6PR10MB42816B902BA9753A8B65FE5581C59@DM6PR10MB4281.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7rOUSZJmOW5Yu2vEJn+RvMuhVIQLuWPWvcUAUYKrMBksWaKvm8TTjoSUKmEIZoMWXWjGmfomHevYWQ++0NUZVaJ7bk/jb+gBnZBbMMpFwadDj0YFlc9IKNR9UCi1emwW2+fGeMRJcuzA9k3MogVGe30trahl57kSbIXoVig8YOQl0UsCofyUIucYXqPicIyDmaf7Vr71ZQPCPTYMRlCfY5+6XuTtU8zTeYP+A3PzB6pQxDzKAIyQ5/H24i8Gx8lu6mOi96/LQGnL0Y++lg1F5q/bTt6QXOuUHYxsOrudcOI9iAZb9brAWyWnDQu5RG03dV9BdgqoRyLKJWNJrZPHIb4dN4vVi3IuLOS82CEWZJKBhM8uQvZygYla7Yx5vTUjitgt/9HwY+HvrlC3QnesyvWy8coKkS9ksqCBxA6EQtyPFVIy9dFjYB+almAvttn0/6CYNqq2JxZM0H3eo2G0PR4xlaUsBtln2CKWuoOTXJyl7TLcXqqI+1jAmUychc+Vntg4htM63uXAvguXuFjCPtUOjqcb17eJTNlacPHu1NTsxd9jUygguGcbFEzx21EHT8XMEMy2l7TKR/0KvvXf/HX736cTDjZPqUhQnP6jb60Imp78+/SEFrNwj2Odey8hB9V18jgDGTkyEiZdCtTu/EPZBMYy99AEkQfc3x/F/xQU5wASEBZcEfBJEPjizXqEBVQxDQ5b93+h7SxCxrcQ5QETclAps1jkxXQZ94YvP/vJeRNA8s3+eTS6IkuTyKpa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(39860400002)(396003)(110136005)(316002)(6512007)(2616005)(66476007)(478600001)(66946007)(66556008)(44832011)(53546011)(186003)(6506007)(6486002)(7416002)(31696002)(2906002)(86362001)(31686004)(8676002)(36756003)(5660300002)(8936002)(4326008)(921005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXpjbjNQMkxOTVNTdjBQSTkyTFBqV0p0d09lMy9pSEV0WU5mRzZoWU84MDh3?=
 =?utf-8?B?YzdWOVJySXdOTFlnWFkwLzNSTzZzVGN6VlE5azlrRzUxYjAvRGlISjFrbXZH?=
 =?utf-8?B?RUpIdU0yb25pODBJRVkrRGhZNVJZSG5VNy9jdGxHQXdXUXFVc0FZbFB6ek1o?=
 =?utf-8?B?WHByY3dkSzFTK1pXOGVvOHFITHdSQmlsWGhpYU0yZW42YWtOMVY3R285UDBB?=
 =?utf-8?B?dGNSU1lEcHVnejZjekNyZSt3WnJQTUhjalFFNmdzMXc0NHllRVB0OUJNQlJR?=
 =?utf-8?B?M1RkK3dKNGpiSGJPejJ0aXl2MUYwR1I5NkExbDBCQm5DemtBTW1LL3VaeUM3?=
 =?utf-8?B?S2VuV25BOEJkOENxNEMwY3A5ZjkxbXZnclJPbEE3Uk93aHdRcFVUZUxQcEJ6?=
 =?utf-8?B?ZjRHWGMxNkdzNmpzbXM3L0huRGtiRk0rN0k3bjVpSXJKaTZNQmlOTGV6OWFp?=
 =?utf-8?B?U1lSUk1WdEhNRGRWd3BmZmI3aHcvRmV1OXJkVVZlNzhyUG5OS0oydklZdGxt?=
 =?utf-8?B?OHdObzE1UVdQeTdORmRBc3hadWRxT1hWY3pYTkR3ZEg5dVJBTStoTFFwVng3?=
 =?utf-8?B?UVlUTWVndWxROS9rc3hDRUY4V2xlaXJadXJ6RWJ2ODFSWHlPNDIvZ3ZQaVE4?=
 =?utf-8?B?NXBlWXlMSUVicndZbEdJTEZRZjdpY3hMd24vOS9za0dxekhBNTVCdGNBQnVk?=
 =?utf-8?B?V1FYSGtIM0ZjQThKYTdPM053bm9zT21Pc3JGTm5HOHM0dkFmZEpSOUtpMnRk?=
 =?utf-8?B?enBFKzFaUlFaUm4rYXhwVG5tVm5kVjlvYUQ2N2RXamVqbW5HWDBFc1hOWGFl?=
 =?utf-8?B?ZTRaUGsxMlNZZkxQaFdEQzV5ZlEzOU5GbVZvQmlxQWtFaVVtNUdQdzJQVTJD?=
 =?utf-8?B?a09Gd2plWFNSOXhWVmNHU3V5USsvcjBYVWtHNkJMZkVYNDJNaVlWRld5WHVO?=
 =?utf-8?B?OWl5V1g4T3ozU3FZQVovcHNwNHRHVjE1MXVGeGtYblc0eFFaWGZvWC9qMHhH?=
 =?utf-8?B?Ujdnc2ZnanJ2THY0R2QzRHlmYzlhWWpjU09aMFVLcXlFUStXcisyclhCN0Ri?=
 =?utf-8?B?YTdQWGdTSmJKYkpWbTYwQjBFTGpQQ1VSY1lOUzVtL0tuVlBmQ0NCcXFqR0FR?=
 =?utf-8?B?NWlvVzNiY1dzWElkelF5U3BQZHhDWC9FelppN2N4WTRKVEY2WDZJOHRZOEpa?=
 =?utf-8?B?SEV3YzYzS3Y2c0JHODdCRmk2WXcvQXByY3g1S2JLeDdEZlFqRWVRVXdsVHh0?=
 =?utf-8?B?bTlpbmYzbS9vMy9keHJna09BTUVjUHNxWS9HMkl6dGUzdm82M0twd3NBSk9Q?=
 =?utf-8?B?NVZ1UjRmd2tUQmVsY0lTRW9BVEwrZ3oxV2xjcUpZMjdRdzRJQll6eFVvODhJ?=
 =?utf-8?B?WFIyL09xZkRuOUhjbGpSWVpreGdOK1lqM3VZL3dJTXpTbnR3Yi85Z0xqd0tm?=
 =?utf-8?B?Y1F3SXFKalMyTUJ3ZVczYmRKV0hHSjI2aDNaeVhieVRYZjFzYUtaODhqcHpE?=
 =?utf-8?B?OHlaWGZiM0ZhRFFLMlRSc3oxU1pYcEVFRlRXYjRHeHhiU050T2JDRmpRS0Fk?=
 =?utf-8?B?NFNDZXVGYmZFb21VZHJ1dHh6akh6cVZQM1MzSzkxZjNsUjdnb0FvSERnUnE0?=
 =?utf-8?B?S255ZlVVaEVJcm0wN29SNTNhSTd5MEQ2NTlsVXROL2l1ZDMwNWtGSVRPQWh1?=
 =?utf-8?B?d3JFM2piVkdBWGlXaGVrNHF3MndEeHlaQytsVDZyOHdTSlZ3S3pQdmx0ZFMx?=
 =?utf-8?B?OEgxSzlYUkZNVllnVVB0YndWMUdiTC95S2tiajdPUDQ1RTZGbU1qYzNUT1ZE?=
 =?utf-8?B?RWFQazQ0OHR0Y21SSUhPUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ded38b-0654-4d08-2d05-08d9674bf01b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:10:09.9845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y9qBdnpXtoAy19nuM6LvlIWwRIiL3ySZcEsOji44bCDY6tQZND6IwWRxmizpZord7d7q2JfBHaME87grHzsQeZ64Nv5bCgAJ6q1bT/B50uc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4281
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108240138
X-Proofpoint-ORIG-GUID: DNCNeB99mpCXfWOtt1D7wiP89N75mveQ
X-Proofpoint-GUID: DNCNeB99mpCXfWOtt1D7wiP89N75mveQ
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/19/21 4:33 AM, Varad Gautam wrote:
> The largest EFI_CONVENTIONAL_MEMORY chunk is passed over to
> alloc_phys for the testcase.
>
> Signed-off-by: Varad Gautam<varad.gautam@suse.com>
> ---
>   x86/efi_main.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 92 insertions(+)
>
> diff --git a/x86/efi_main.c b/x86/efi_main.c
> index 00e7086..237d4e7 100644
> --- a/x86/efi_main.c
> +++ b/x86/efi_main.c
> @@ -1,11 +1,103 @@
> +#include <alloc_phys.h>
>   #include <linux/uefi.h>
>   
>   unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
>   efi_system_table_t *efi_system_table = NULL;
>   
> +static void efi_free_pool(void *ptr)
> +{
> +	efi_bs_call(free_pool, ptr);
> +}
> +
> +static efi_status_t efi_get_memory_map(struct efi_boot_memmap *map)
> +{
> +	efi_memory_desc_t *m = NULL;
> +	efi_status_t status;
> +	unsigned long key = 0, map_size = 0, desc_size = 0;
> +
> +	status = efi_bs_call(get_memory_map, &map_size,
> +			     NULL, &key, &desc_size, NULL);
> +	if (status != EFI_BUFFER_TOO_SMALL || map_size == 0)
> +		goto out;
> +
> +	/* Pad map_size with additional descriptors so we don't need to
> +	 * retry. */
> +	map_size += 4 * desc_size;
> +	*map->buff_size = map_size;
> +	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA,
> +			     map_size, (void **)&m);
> +	if (status != EFI_SUCCESS)
> +		goto out;
> +
> +	/* Get the map. */
> +	status = efi_bs_call(get_memory_map, &map_size,
> +			     m, &key, &desc_size, NULL);
> +	if (status != EFI_SUCCESS) {
> +		efi_free_pool(m);
> +		goto out;
> +	}
> +
> +	*map->desc_size = desc_size;
> +	*map->map_size = map_size;
> +	*map->key_ptr = key;
> +out:
> +	*map->map = m;
> +	return status;
> +}
> +
> +static efi_status_t efi_exit_boot_services(void *handle,
> +					   struct efi_boot_memmap *map)
> +{
> +	return efi_bs_call(exit_boot_services, handle, *map->key_ptr);
> +}
> +
> +static efi_status_t exit_efi(void *handle)


Based on the naming pattern, we should call it 'efi_exit' ?

> +{
> +	unsigned long map_size = 0, key = 0, desc_size = 0, buff_size;
> +	efi_memory_desc_t *mem_map, *md, *conventional = NULL;
> +	efi_status_t status;
> +	unsigned num_ents, i;
> +	unsigned long pages = 0;
> +	struct efi_boot_memmap map;
> +
> +	map.map = &mem_map;
> +	map.map_size = &map_size;
> +	map.desc_size = &desc_size;
> +	map.desc_ver = NULL;
> +	map.key_ptr = &key;
> +	map.buff_size = &buff_size;
> +
> +	status = efi_get_memory_map(&map);
> +	if (status != EFI_SUCCESS)
> +		return status;
> +
> +	status = efi_exit_boot_services(handle, &map);
> +	if (status != EFI_SUCCESS) {
> +		efi_free_pool(mem_map);
> +		return status;
> +	}


The kernel calls efi_get_memory_map() inside of 
efi_exit_boot_services(). May be we should stick to the same call-chain 
pattern to minimize deviation ?

May be, we should add a check for EFI table signature like the following 
kernel check ?

     if (efi_system_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
                 efi_exit(handle, EFI_INVALID_PARAMETER);

> +
> +	/* Use the largest EFI_CONVENTIONAL_MEMORY range for phys_alloc_init. */
> +	num_ents = map_size / desc_size;
> +	for (i = 0; i < num_ents; i++) {
> +		md = (efi_memory_desc_t *) (((u8 *) mem_map) + i * (desc_size));
> +
> +		if (md->type == EFI_CONVENTIONAL_MEMORY && md->num_pages > pages) {
> +			conventional = md;
> +			pages = md->num_pages;
> +		}
> +	}
> +	phys_alloc_init(conventional->phys_addr,
> +			conventional->num_pages << EFI_PAGE_SHIFT);
> +
> +	return EFI_SUCCESS;
> +}
> +
>   unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>   {
>   	efi_system_table = sys_tab;
>   
> +	exit_efi(handle);
> +
>   	return 0;
>   }
