Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E1A40100C
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 15:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhIEN7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 09:59:48 -0400
Received: from mail-bn8nam11on2049.outbound.protection.outlook.com ([40.107.236.49]:44001
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229566AbhIEN7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 09:59:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkiRL0ngO1DkDf+OspAoi4ydjvwGxvUISPeuF7H4kxnAHOxFxWscdzp95lDr+SItoX0j8efvsGKElGwos0CCqAIJIBMe+SVyBP7lQNMhaQN4JMHha4Aof5OBmOMdFrG0WPDiQiBL8WMkluwb1nbPf6kBZxj17tIJWoMMH27hQmJRIRDBSDMIZbPrQ4inEPr8Kdx8R1i3e/6fs3skt+CBAYhhCEwmgBkLs7gw4d23JujyiMV6Sed78BJncbHXDk4BoYHfhiGU8fHxhjEftMrLDOjdVTG5tFjX8RXbtkRQzgypBWLL4gjzvYV8XvCNDGz5AXOD7gIZiitg/uOJuAxUvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=DaWnIFD86hlgdgd5pH41vCD6n2b7wCX0NE+ZjDK3j98=;
 b=IXyI3Tl2iKH2Bp++r1oTJ2NvtRnM0Qm2gQovLE+Yn1qwao7W5IbtSssu7BBAmNnBk6wHvIdQERSUB0dw+3n2A4BdRAF3/F0lkFvs6FvV3L8lA00lz1QaCApXQFxC2jr0J5xwqhGj6R+t24zWofmkFNd6glHIWsTLayqrAjBpYuDzmYcZ56C2ijBu+fNAGrQT7G0uUKprk2edJo8nZOcpfKQrB50M+UrED9lQA/Z0caj5WD45K65TiYcsnYHvbvXnpw+thUl0bkhnhta1Jx2BryOSSqLa0Ag5TYpqOGT7uAnyimdbjC20wNKX89hGUJP89w4Q6yVWZvCdXBU5qNE6KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaWnIFD86hlgdgd5pH41vCD6n2b7wCX0NE+ZjDK3j98=;
 b=Lh0koeVl5lVQrA0kbmPcyLRIacyxsIArwSoLzdx7NVrDMncGXiFu0ADY0JamJ55YwTlYfFlM5jGdZoOPqCKScLefmu4xS8o3S89OtKrwz7qx4gULe87Aw6RhilAr33PH73h+gVSdqM6l++aGFdZk1ZyHgu1y+9/WwoxFTi7s3bc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Sun, 5 Sep
 2021 13:58:40 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4478.025; Sun, 5 Sep 2021
 13:58:40 +0000
Subject: Re: [RFC PATCH v2 04/12] i386/sev: initialize SNP context
To:     Dov Murik <dovmurik@linux.ibm.com>,
        Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-5-michael.roth@amd.com>
 <48bcd5d9-c5da-1ae3-4943-4c3bd9a91c7b@linux.ibm.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <c930872e-8c13-55af-f431-1c99dd277f12@amd.com>
Date:   Sun, 5 Sep 2021 08:58:38 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
In-Reply-To: <48bcd5d9-c5da-1ae3-4943-4c3bd9a91c7b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0501CA0020.namprd05.prod.outlook.com
 (2603:10b6:803:40::33) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0501CA0020.namprd05.prod.outlook.com (2603:10b6:803:40::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.8 via Frontend Transport; Sun, 5 Sep 2021 13:58:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c848001-e39e-4df8-eb03-08d9707543c9
X-MS-TrafficTypeDiagnostic: SN6PR12MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2717E2B3639CD584117DB139E5D19@SN6PR12MB2717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C2tYX2Zo3FtNPmzcW3fQLK9Dy/aM6yFvFoWHBdT6WSY5YhpsYAG1WRBxXbbHIfr6+ewC2PM+5hyBHvHAtzgsI5mBUDkFbssN6i5GGibLCgShqtvEL3NuOSk7amxVQtOxhdqDrjvsMS8QS6SYmYyHTlDe3AxaS61lIp1W92Gz+hcXlmauUO48ZkvhrGDzED/3XjpCd2J6/QaaKHgt5q1YC1BwCTflZ4azErc4wJRQe9aI0zD+R+Tj/3K9Bc/b8uT0AMe4DRWJ/FGRObyTDdErpnT9k9sOJao5XMiMr7fni5sgnTGcfSBd7zzqGHiFlN/H30PuliQy0r08eB6QRaGOcq9lah8ywffnzcCvfH+dpWhy54w7Q1KN+wJUlh568E/631s9wYy6T1UhyB72mfymCcNE52KF4dyhhl7dDqatg9KhNvk7hbNPH6y5z+jK1dmND7I1LQKIbfeZk0684S8AsLL5w2BHXRLIs3keS0jNCsiaZ2KVOOj+g9pCy+aLtzpGm1jER+KA3ApG20BBJH/jgJr2sOKoVqJwz29YzMuAHYXkJLPCB8zyRBvHhvFNxDTotMtOlkMqKXGIOu6oeFt6SD3nkR+ROdq4zoI51MTcZXsW9lsIAVYexJtuzH9FByb6tjJmPwewOG8pgDe6X4+Pfq4dNYrC+f+eT/MPl1Av8w6lWZQ2Ld/d5gw13EbmOiBN9oh/NqFkCNmKemh5v4whTDl0+zAFbX8n2ZB8haAO9vg86eXl3t5XD78x2Uf+q61CP61VuWJNUiU5lbMPG1Ui9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(956004)(2616005)(44832011)(54906003)(36756003)(186003)(6512007)(110136005)(316002)(31686004)(38350700002)(7416002)(8936002)(6486002)(86362001)(2906002)(38100700002)(66946007)(26005)(66556008)(6506007)(66476007)(31696002)(8676002)(478600001)(53546011)(52116002)(5660300002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHczUXRLNGFYTG9wcXNwUWgwYlY0Q3JyZWQ5YVdXSEFZdmdKcE1MYm1zUTlH?=
 =?utf-8?B?Y2ZSZ3I4ZnlucFRSYTllbzBhVzZ1WXI5WFJLeHlEVENucW9BMlppbUYwWWZT?=
 =?utf-8?B?TGJZQ0wwbm16alAyM3psQnZZUnJXdWtpeEpGb01lNGlOK2h5Mk1IaG5aZ1M2?=
 =?utf-8?B?eDdqbjBWeEZFTFNFelVDWnJIMTdGZW1YYndzVjdiZVB4c3FXdHVSajR0aEty?=
 =?utf-8?B?ZVkxSWFYb1UwMk1FUnpjYWdzSnNwcFRnL1pSNkxVOWhkVU9kakt0UlJFVjVM?=
 =?utf-8?B?NXBZMnJ3SHNPTnNsSEd6aDh3ZUxWdWtKRjlFTDZlMmwyb2Y1cW56S1BWTkUz?=
 =?utf-8?B?c1NzN0dZUWJFN29lNE40aE83Um5Ja3RXK0pPaG1zM0MyL0dzWVY2MkpuVDZi?=
 =?utf-8?B?VURmR2pTekE0NGl0N1pMVW0yWjJXUklncGJHZ3FkZlUvN0xCZ3lWR3R6S3Jm?=
 =?utf-8?B?RFI5UWRGMWVkMytkM2h2enlQU0VyZmhjVGhBWTVyVThUc1oyMzlWa1dZMlNI?=
 =?utf-8?B?Z3c0QXNYQzRvNlJxck13ZGZ5WmY4ZDRLY1dCZk1ubzJyVjJoWlh5R3NJQS9W?=
 =?utf-8?B?dDQvYmVHWlg1SU9McWFzOXZoNk5SbTFuenlJTU1oVVFDVXN0ZlhqSndzZW1v?=
 =?utf-8?B?ZTBXRjZ4K1ZpaXphZDlMZHU1QXI5djNHZ2xLbnVaTDZ6REtyTE5DVjhsVjJj?=
 =?utf-8?B?WmliZ1Fjd3dYSVY4SVJpdFhZaFNSdUZLdENhRS9jcy9iMVcvRWdsV0hRL056?=
 =?utf-8?B?ekY3Y0JWZ3Q5MGFRSGFBak85ejN3L2pUelFUVXlBU3RqUTd6dEJzNkIyKzFW?=
 =?utf-8?B?elZKeU1nQ1FqbkV5elRuMDZRUHdub2ZmRTVKenhjdm5hS3B0cmU5VjJ6dHR0?=
 =?utf-8?B?ZjdUbWNkR1R6TTBnajhUUUNKMkZieWhBTUZlZXFGKzcwZStjZTU2WHdTeDdG?=
 =?utf-8?B?RWFxUUExcEtQRUVNK1FiZ0RPbjAwUzFUcFVGZzY3UkViMS9meG4vQjFYTmxI?=
 =?utf-8?B?MmVoTUdQSWlOdnZNdWxxbm9vS1F4WWY0S1hhU0ZFZnNCMVlxcWRucVpOQzls?=
 =?utf-8?B?ejFSdndxckJYQzJXTEZaMVhtNVgrKzE1SVBNbmFXWlptVkVyNEFjL1A4SGh2?=
 =?utf-8?B?eU4rODkyZDZaTm5yYTgwcG5BT2toTHBvUmZPcys5R2dtaGtmblo4TXpvMVRv?=
 =?utf-8?B?Q2ZLRzUyWUVzQW1JSWJRcmNiVHRBVGJ6cERKUHJ3cTltN1pVMGtKNVZrOG91?=
 =?utf-8?B?U2k1cjlhYkxRRXQxY0I4TDVrWWtZMm81L1NFRGxLZ2ZBdmRmQklTNHpJam1z?=
 =?utf-8?B?UnZ5Uy9aMEtwSE1lZ3I5UzhHczBEdDlmV1FoeXBvRXQ4MnAzRHV2VFNBUlJw?=
 =?utf-8?B?MU1DZE9EVHBmNE5ORnhIZW5jR2lyck9sUldBS1lraVQwSkJhRDBnSFNCbTdi?=
 =?utf-8?B?OERVMUVJR3dHVFVYalpDZWw0NzZRdkdQcWJiUE90Y2kvNlprRWQ1OTEyWGo2?=
 =?utf-8?B?VTdlV3JTNzRiTExDWUZ4T0pmZ1F4SllKRmgzV3BlQU9GWWYrOHRObDZmYjlm?=
 =?utf-8?B?WVc1N2tvbkhZNTltMEVpU2U2RFNOMEV1KzVEYzhMVWlBdjlVNnloRThoRGFm?=
 =?utf-8?B?V1FwUWIxNFBwV2ZmelptYzdzY0toRkpEbUZ3RDZIU2FaQmxoMzlLZGRFR2px?=
 =?utf-8?B?UVpyMTZTaU83S1RBUlpIRVd3dDh0NVVuV0ZKNUVTSG9XZWtMY2E4dTd4ZkdX?=
 =?utf-8?Q?RdxdS2PdwFacDyNAbYs2I09aW8EyHa9Vvwc59Ti?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c848001-e39e-4df8-eb03-08d9707543c9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2021 13:58:40.3065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EW1VMAxrRFHyynhRmlYbjSDTt5oANLh98FKEmZ5p8D9k5kKifFx890ZeoLfyL1Vxew5HHF7ZFMJ2pJUCXV4ZjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dov,

On 9/5/21 2:07 AM, Dov Murik wrote:
...
>
>>  
>>  uint64_t
>> @@ -1074,6 +1083,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>>      uint32_t ebx;
>>      uint32_t host_cbitpos;
>>      struct sev_user_data_status status = {};
>> +    void *init_args = NULL;
>>  
>>      if (!sev_common) {
>>          return 0;
>> @@ -1126,7 +1136,18 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>>      sev_common->api_major = status.api_major;
>>      sev_common->api_minor = status.api_minor;
> Not visible here in the context: the code here is using the
> SEV_PLATFORM_STATUS command to get the build_id, api_major, and api_minor.
>
> I see that SNP has a new command SNP_PLATFORM_STATUS, which fills a
> struct sev_data_snp_platform_status (hmmm, I can't find the struct's
> definition; I assume it should look like Table 38 in 8.3.2 in SNP FW ABI
> document).

The API version can be queries either through the SNP_PLATFORM_STATUS or
SEV_PLATFORM_STATUS and they both report the same info. As the
definition of the sev_data_platform_status is concerned it should be
defined in the kernel include/linux/psp-sev.h.


> My questions are:
>
> 1. Is it OK to call the "legacy" SEV_PLATFORM_STATUS when about to init
> an SNP guest?

Yes, the legacy platform status command can be called on the SNP
initialized host.

I choose not to new command because we only care about the verison
string and that is available through either of these commands (SNP or
SEV platform status).

> 2. Do we want to save some info like installed TCB version and reported
> TCB version, and maybe other fields from SNP platform status?

If we decide to add a new QMP (query-sev-snp) then it makes sense to
export those fields so that a hypervisor console can give additional
information; But note that for the guest, all these are available in the
attestation report.


> 3. Should we check the state field in the platform status?
>
>
Good point, we could use the SNP platform status. I don't expect the
state to be different between the SNP platform_status and SEV
platform_status.


>>  
>> -    if (sev_es_enabled()) {
>> +    if (sev_snp_enabled()) {
>> +        SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(sev_common);
>> +        if (!kvm_kernel_irqchip_allowed()) {
>> +            error_report("%s: SEV-SNP guests require in-kernel irqchip support",
>> +                         __func__);
> Most errors in this function use error_setg(errp, ...).  This should follow.
>
>
>> +            goto err;
>> +        }
>> +
>> +        cmd = KVM_SEV_SNP_INIT;
>> +        init_args = (void *)&sev_snp_guest->kvm_init_conf;
>> +
>> +    } else if (sev_es_enabled()) {
>>          if (!kvm_kernel_irqchip_allowed()) {
>>              error_report("%s: SEV-ES guests require in-kernel irqchip support",
>>                           __func__);
> Not part of this patch, but this error_report (and another one in the
> SEV-ES case) should be converted to error_setg similarly.  Maybe add a
> separate patch for fixing this for SEV-ES.
>
>
>
>> @@ -1145,7 +1166,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>>      }
>>  
>>      trace_kvm_sev_init();
> Suggestions:
>
> 1. log the guest type (SEV / SEV-ES / SEV-SNP)
> 2. log the SNP init flags value when initializing an SNP guest

Noted.

thanks
