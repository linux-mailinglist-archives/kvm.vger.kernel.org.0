Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96453C8B4B
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 20:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhGNSzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 14:55:49 -0400
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:46785
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229491AbhGNSzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 14:55:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvJBD/W8/oVknnD0aa4q21nCcSOqqqlGd5Gu2gCSNezP3K9D8Dd2tkb6piz6jUXiq8ZSDLgI0O5DzGaalS6NgwysNR4Otx4PXaUZFfWuUp6J3l95NzzF4yO3Fk3m7qe73ZB2aFwq3blo4ahtRCTagg4zTYT0vlPO5LTi/LJpoRZpfyt8vF14oSweSvgClfGy2xC9swfclcmfsQLeLSqz3zeR0wgVC7aMoY5hOt3WCJ4qp1KsBjIlnRIe27X4Dk74kOgf0Rao3Sd1bcMkj2epPXUQk4Y5AQmfRvcLSMLK1I+CebSsCFdtnIX/OEc2gQVdwYOgjjY3NLqgur2c3t4DtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVeSbYIdiKPTIBdHDoDIm/0mmuUOfgrzv1H+UP+RrmA=;
 b=elrFdk5K24V5m2eHtcN7PrBjGDMvvTMHp01YeOPV7UKQpQ+wzBGT05CNkI5UsQ2BWR871vrIQT+Lkwu11iCxFzmXROoebcih4gMayT0kGElkqCGxst+uTvjdaHsUsfvT+J/t7go68FwUrsGczjuCzwZFOGqzCpCXc46NnUMFplAKeeB1ztnLWNigqCf4OjH76Gl6G0xBmKzh0kGbLN+JCR0DE6ovYiqzfAeLAZiCnIV2qKU2zNsWBljFp/9mBVvWmVdYcrdjpSAHNFTeVpStruPHuLMybvNZV3us04YvNqQWOx6nYB10HXOmq6Eoh4rtoMqHSsHEH1PUumjUlhlO8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVeSbYIdiKPTIBdHDoDIm/0mmuUOfgrzv1H+UP+RrmA=;
 b=2J1m4I+A2TC1dVYqGa13+lMWf27MFj7piYMXofWs419CoCt6IaLbYPdWqrQXwjZ1FWg/Tj+t9Hr96UYCjhi90JOd0fErA9YuQ8qluOupOrrL/WsEeRU5oKee7emmGkjgUO55cMnT/IjK4YFFxBl/Ahpny0HTp17IE0qeEOHngF4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Wed, 14 Jul
 2021 18:52:55 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 18:52:55 +0000
Cc:     brijesh.singh@amd.com,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 5/6] i386/sev: add support to encrypt BIOS when
 SEV-SNP is enabled
To:     Connor Kuehl <ckuehl@redhat.com>, qemu-devel@nongnu.org
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-6-brijesh.singh@amd.com>
 <3976829d-770e-b9fd-ffa8-2c2f79f3c503@redhat.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <866c2a6b-8693-a943-fb06-45adf2cdcb92@amd.com>
Date:   Wed, 14 Jul 2021 13:52:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <3976829d-770e-b9fd-ffa8-2c2f79f3c503@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0801CA0024.namprd08.prod.outlook.com
 (2603:10b6:803:29::34) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0801CA0024.namprd08.prod.outlook.com (2603:10b6:803:29::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Wed, 14 Jul 2021 18:52:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4638780a-1273-412f-a9bc-08d946f89747
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509500C2C004C745B0D9AB3E5139@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dKM3TSz8sz4//ZHQWegz+VETeioIXlU9Mii8GgtJftnnuEZLhT0sOyFvtRMuEvK48j4ORF/RwECz5Wz65KRhbGCW+500CCm7EDSPXAf++NsvrWlM4oDrLpbhHbElkaXWWQd88nC+DQ5QDxAroPPfmaT20lCKE6SWZcKkHD05oEExGMYDONVx51d+kCKAvztLFVFHwNP/EluoycH9qcBGNd+8rqTH4oyr8gr7cDET1GGJqZFx2Cf1BPCnemk2XvFWCEmEpHGjcREY6E5+DoIEP+Bp0wQNx8XdQr14BuiDx3013Ez0Wk+eqOeUQi1JkrWBg25n8QWX9exIieU6nQ1v+8hRTZ4kP0XoePg9DAOGsBArYriYUqg+FST1QvSc2dqECkes5e780R5W8XFSAhVs7O61PaFZ6+YjTDyavDjH5SeeCHundW236WvlwiJyzGzutMhBC+4KtAfJMI6949XCs6QYgBz5FtNCa2K7uqvbb1owtu+/3SOKunTwxr4lIR/TqyZOR8/l4oD2/hvAKJP6Z3FH2KIncCYBkS61WHnFDIco4Qq/Sm6vOTf4TfeHeLy8VBhEF1x2oOsIYtxQl6RPZcYanYYURXeScV6sewtyQcokZ8CPfDAb3nyweZibjaNtLPQLJExz9INhtTcbqnALa8d7t7/W13MGlTcpTjQvxUzwhKYeMdSy1sWVQrnulOpAr8mqmlqpTje74BcP09XWbqpGKUOd1tllLA2oIjY+u2iJItjc7q6V2h/kWJ0yFDNdFKVQs800JCiwl5JpAH0dNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(54906003)(478600001)(66946007)(26005)(31686004)(66476007)(186003)(2616005)(316002)(5660300002)(956004)(8676002)(44832011)(6486002)(4326008)(38350700002)(31696002)(83380400001)(2906002)(36756003)(8936002)(7416002)(52116002)(53546011)(38100700002)(86362001)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWttK2xnMlVLS1h0VVkyWldkV21mSjdBcVBYbVVQQXlLQi8zNEtEVmtDb21q?=
 =?utf-8?B?T0RmcUVTWHM1N1NUcEVUN3BMY0FIZUhETE54TWlGa0duUlE4RXJyczRkZ09t?=
 =?utf-8?B?SWlDVUl1WGdCQUJSOTY3ME45R1ZuejBlSFFCSjdoOGFwSWlqWWMwY1dQUGp4?=
 =?utf-8?B?elhrZU9YUys2Z2FTdElDbWpwc0lsR3Q5eXhadENxdmx5aFdieTQvM3l1MU05?=
 =?utf-8?B?V05uQ0pPaWh5Wmo2cnZPTEZlS05XZlVyZUxPQTZuNzBoZWlIcXhML0t2b2Ir?=
 =?utf-8?B?OUZ6VHE0R3VUSzBCbi9HaXI0M25BZ3ZMYWF2Z2pJNEwvMTBuQk1Sd0I0RW16?=
 =?utf-8?B?c1I1QkpUbDdyQmZaRXJkZ2RZdG8rY05oQXIySjhsVlRXdDlCMW9Uc2RnM1hs?=
 =?utf-8?B?QWMrMEhtTy9hSm1URHB5dUxJQkdGb0dlMVhIcCtuUExBWmRsaDJMc09lRmdj?=
 =?utf-8?B?ckZ2dnlTR1hSd0JWeTRFOHh1OGM3d00ySi95eVhNK0dUcnI2N2VZWEJtY3gr?=
 =?utf-8?B?NmpOVUdDdS9SNW9iRmgxZThtZFp3WEYrMk5JK2hRZEJwZkhPM2VuNlpTY0Z0?=
 =?utf-8?B?RFoyMnlPdDl5K0NHQmxGU2NQQ21qMjEyMDZWd2NkUFdjZHIzSFl2eHo4SEt0?=
 =?utf-8?B?WDR6STl1WE5WdU5VTUJTRnhaNytCa3ZzT2lRRVYyT3l3b2dsSHdOeFJHSHB4?=
 =?utf-8?B?dFNURDUvc0l4M29ITTVud3A3NnFibEVvTnFqY0w4SjR5dnRicVA2NkJOdzVP?=
 =?utf-8?B?SlRQQ2ZwNW1XQU5uVnRTMHMvYUMybjFqTURqZU53V1pPMWgvcXp6d3hTSER1?=
 =?utf-8?B?M3NDZHNPSjQyNVVhVzYybmFBOFhheGx5Q252U01zZWJ5OHY0YTdRSGs4K0g5?=
 =?utf-8?B?T3FmN1ZPTWVsa3YwWmNicmFrRElCamszakQrbG11OVlFbHNtTEs5L3JLWTRX?=
 =?utf-8?B?TWpQVzdXUzY4MWdlZ3RVNTJkeUYwa3NnWWtFVDRjK1ZOZnBJenUwcTFpWFFJ?=
 =?utf-8?B?MTdCYXNuNFVlVnE1eVVOK2M3SUo2OVVQcFZLbkZLaTJvSDBGY0I2OHlFeFZz?=
 =?utf-8?B?Q0puK0w3MHd3aTZoSjBjVllKT2ZkZU0wd24vNVcvTkVEdS9pc2FIWHZNbXRz?=
 =?utf-8?B?blYxc3R5SUhIRlVBUUpKVk9pUlhqWFNZRmlsS2Ezc0ZRQWdVcnVlR05JMHJE?=
 =?utf-8?B?UzF3WVJhdGxmNDJreGZhUCtFNFo1YUwxUjhoMzFvTFY3K1hYcnhCR2tycWpU?=
 =?utf-8?B?blp1NExjWDlKVWU4SnJ0RFpPZTJYaFFORmtlT1lpYVJrZERJaHhuREhxams2?=
 =?utf-8?B?OGVhQWdaVHorNGhQTnlvcVd2Vng2NWtVVlZCb2F0a05WRm04b1FaOXlyaDda?=
 =?utf-8?B?aWRySUh1dk9lRjV3bTlQWWd4eGp6YnVYNlJvTngxczdES1FpcUlXQ083aHFJ?=
 =?utf-8?B?VUFjeS9MRzJVVTF0VWNwUnB3WU9id3hXQjBsZUlzOXV6c1RtcnhuZ0JVQUl6?=
 =?utf-8?B?azhYVnF6dytBd2FVVWl4VzBRakNYRW1oVkRmZ2hpTWZkRG9ubDlpNVdaWW5B?=
 =?utf-8?B?UUlSREppR2ZzMTE3SGxnczJKUlZhOEdKR3pJSmJuVzV6TlZNR2RvQy85YlRS?=
 =?utf-8?B?MDVHNmR6dlROZGZVcnlZMjlObGphVGRnaFpMZDNzV2g0ejBhSUtVRmxLdThx?=
 =?utf-8?B?TnU3VWpVOG8wVWJmdC8rOTJBMXFEbTRxOVNmQnNkWnFaTDVzbDJmQW4wL0hz?=
 =?utf-8?Q?N6R++Xf3OzXTRsawyKQpjQfRL3PO8wgbwiSpEIR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4638780a-1273-412f-a9bc-08d946f89747
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 18:52:55.4645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhRUGISRJ/gXOsYFbfVb8oRHII5VcAhSbFMFeFV3vjFuaGAT4ZDBhsRMIh2I1lqLANjEartHK5KKJhRM6SpH6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/14/21 12:08 PM, Connor Kuehl wrote:
> On 7/9/21 3:55 PM, Brijesh Singh wrote:
>> The KVM_SEV_SNP_LAUNCH_UPDATE command is used for encrypting the bios
>> image used for booting the SEV-SNP guest.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   target/i386/sev.c        | 33 ++++++++++++++++++++++++++++++++-
>>   target/i386/trace-events |  1 +
>>   2 files changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>> index 259408a8f1..41dcb084d1 100644
>> --- a/target/i386/sev.c
>> +++ b/target/i386/sev.c
>> @@ -883,6 +883,30 @@ out:
>>       return ret;
>>   }
>>   
>> +static int
>> +sev_snp_launch_update(SevGuestState *sev, uint8_t *addr, uint64_t len, int type)
>> +{
>> +    int ret, fw_error;
>> +    struct kvm_sev_snp_launch_update update = {};
>> +
>> +    if (!addr || !len) {
>> +        return 1;
> 
> Should this be a -1? It looks like the caller checks if this function
> returns < 0, but doesn't check for res == 1.

Ah, it should be -1.

> 
> Alternatively, invoking error_report might provide more useful
> information that the preconditions to this function were violated.
> 

Sure, I will add error_report.

thanks
