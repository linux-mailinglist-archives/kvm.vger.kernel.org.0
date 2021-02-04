Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE55130F776
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 17:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbhBDQQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 11:16:04 -0500
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:50785
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237697AbhBDQPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 11:15:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQirYsNc1AuTcdKgFLiBjjsRMMiQGRKOQnVv1+j9xYz5eoBttodx70KCuBflhBQgmnWwo9p7kogFCmOpDYt7wCEmAtfk/jmrduaVCAd4DwcmIagWQGoZK2nkih3kphockDC3Nfdu1P4tqXyoxXoxM60ORdqRwLKrfAYU16zBt6sx/kNMm9PnJSM6y6dxk4HRHXkw6rw7on2keswrK0zVGO89jQ43TS1VzIX+jNXEiGIh4kNAzMXX2M5csPHyKCjc+pK3c5zpbsNBYiMF+JVnY8Asg720tqCc/y5669528jNWBSSo+4UtqhHkIyV8Jqh5OvL5gkGOFhTnilSq7ZLXsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBSKXyJMcyAPCRBPxakjXuwq0xkWxTKOYEVl1m7o6zc=;
 b=HhjKDbsOLOb1FyUShpjLIrkSikaR6UqYbCqpMtsJ5jYOO0FEx7aQkZk1bWgrZ/0VZl+Qpzi9JcfljgKEbQYKUPkM59Pzg/IPYQGGNNfrsVhL6ZAlxIw4y2GzTnELQYwCU/1TJEPOa/PDKgf+Hs/lGNRzlO4LSaXPOjsZOayYD2DU4g6YE7o9zYFOkSDQg6cc1wXXlwf2HMNowdziM5DRt9dWLEsyiQr5LtabLgePjVtvEYeu/gUkCbCC0XMYIUSodhcA1UJ7pvtfMBH5M3SXGSsZwNJRY/suFt+ry27J97mThe3DEWoX0NTWQ4SRz/XnS/++Y1486rVGRs240RAlxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBSKXyJMcyAPCRBPxakjXuwq0xkWxTKOYEVl1m7o6zc=;
 b=mi0OwhBv1Kzu5abP16AqXezz5fAFR0Vhn6Mzdmj1aqIoxrQvdyMdIOnJUiPWoAjNSia9Z6UBJ8XYWIOLPKMElIp2pnIIRA/Vhv6JRQVUuj8iYhKfgQZleHs3DFOJqUhOvtjUD1kS41IxmK/JbHEVLGHF8qX9iwxCxPyU0pKgvS0=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4355.namprd12.prod.outlook.com (2603:10b6:5:2a3::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.19; Thu, 4 Feb 2021 16:14:39 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3825.023; Thu, 4 Feb 2021
 16:14:39 +0000
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6cb9bd69-6217-9923-3161-b4163646c1e2@amd.com>
Date:   Thu, 4 Feb 2021 10:14:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR11CA0015.namprd11.prod.outlook.com
 (2603:10b6:806:6e::20) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR11CA0015.namprd11.prod.outlook.com (2603:10b6:806:6e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23 via Frontend Transport; Thu, 4 Feb 2021 16:14:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aec8a63b-9894-47f1-ca94-08d8c927f931
X-MS-TrafficTypeDiagnostic: DM6PR12MB4355:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB43551A9E57927E8DBC0EB07BECB39@DM6PR12MB4355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IpRuehdGREfrWOPgM8Faic+v4Zam8jAAsMHKASS6TOyvb8oUorI/3Hu/n/ffLqUKIrjNz89jzCpmHR+oMK5x2sEQCNj+v17qvg2IAXIUHdwtizlz0QebrBmHcW7uSkwNvfwfwB2MV5OQ1YMUT+yF0dxQsiBUNKZJ4apNhTEUX+mEuH0DROyUxSAKsMPrwOw8ipMEaJ/GZJg4HC/5/IiVL34fMX+mgG5Hqr4f3y+Cz9q/FQHjWfzIy0QBt/asXdLTgk8P8MaZq6krtm3E34zPvbJM3RXjdKRo8I4DuCE3aLpDAZY6oRlixc5dbBE4+jSI4wxGqdzHrj0CcWo1YsQ8BxKMqRqwfCBEOZb14nRZfHiPEg0KNsfDzzX5pILUXICAQb9xmHOFmP7Uvlzclls6C4HHiJfG8K9lpbfVpfsDv8aHeoFDuRvu0D5gE7MnYvCOUSPJXKa91DcJWMv8RuUhQbXYXRMdQ1zmQIOm9kdD43fGy+uZdSvCivTbIGSAJzENRfILifx3xEb+gR/3TVBnvb9jAgIB/QaM5JC9cTMCpyWbZU7xFnMVn1HKS5wv7F0fdlobGBvZiawfByOOP77QN10y+2akkdhJN0Yj3bRjusM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(316002)(186003)(6512007)(26005)(6486002)(7416002)(16526019)(36756003)(31696002)(31686004)(83380400001)(53546011)(5660300002)(8676002)(66946007)(86362001)(66476007)(2616005)(478600001)(2906002)(6506007)(4326008)(956004)(52116002)(66556008)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SzZCYnkyZ3FKZHY2RXFzRDNKZnlQdFlpNXlVZndWdlgwbDlNVTZZNWIzUW9K?=
 =?utf-8?B?dHNMSWJkS002amJNM0hCUDg5eTdIRWIrclJXaldkZEIwNXhDNG9DTkFtNDBH?=
 =?utf-8?B?Y1BIL1RLV1JuVkN2UkJiMjJ6bHNKZ25jUzNtRU0wak9mdm9OREF5NTlnV2My?=
 =?utf-8?B?ZHd0dTVFS3poTE9iQnlRWGJDL2NPanF3THhQRjY3NmJySVdrL3JyZ2tUUWNv?=
 =?utf-8?B?NTA0dmFQcDNzSUphN3prT05INmlGQjhaamhZRzExdnJWS0RwM1Bha2NtZDVR?=
 =?utf-8?B?d0EyaGpJK2gyc21pRFFESFFhTFpTVUtpUVRSQ0d0U0VQbFUydC9jekVqSGE0?=
 =?utf-8?B?aXp5Y2c4K29TY3dYbHo2U0tKS3JBQ05iOW9MdXMyMDh3Q2hGbjRhMGx1T2hi?=
 =?utf-8?B?TGwydEtBMkVDRHZ2cUI0ZTFYSTBaWGlaRGM3clQ1YXFTSEFubjBqcEhjVTZy?=
 =?utf-8?B?czBMek04VHVtejA4RzcvV2I2Ui83bnZNY2gycVc0YnZHNmlQblBJR1ZzaUF5?=
 =?utf-8?B?Mk9ONDNOOE9CUEZLbXV4VGF1MDZ1TldEU2MrYVBrcjU3elExVktxbnRHV2g4?=
 =?utf-8?B?RjF4UUJ5emgwSms4N1JuRkdQTWEyVHBSZVE1YXVPZmh3Z1E2RVJSYkJJWmYz?=
 =?utf-8?B?RURQWlRxVzk2VDhhSGdtNDV2K2YzT2FVV1huS0V2dzY1R2FTM0pxbk9jTDBH?=
 =?utf-8?B?MEZ3RCtQWnVMaFlUOC9rU1BMVjZsTGExRTB4ZEtld1FuSFozOUtRb2REaEhz?=
 =?utf-8?B?OWdqRTNVVzNpUUZwWk1JL0N4T1V5c080amd1MS95ankwVjE3Q1p0eTZYRVly?=
 =?utf-8?B?VDcybGE5R0xLaGRxbzBqUUp1cWlaWWxyOHRXemc1WCs5Q254KzVJR0N2VWFF?=
 =?utf-8?B?MGRuQnVtL2tzVitxei9zVVUxRVBSdXFDQjQyY0hjd3dVTVQ1Wkc2VFNDT1dI?=
 =?utf-8?B?UXF5bWI1UUJUQjRoT1VzRkJIVWlmVXVNUmdmN09BTk80QUZseE52UVphU2V5?=
 =?utf-8?B?S1ROaHovQVF5ZmpWWTF1d3RWL2FKOXR1WXJRcHF4NHNYV3Mva2FwV3VnTEN0?=
 =?utf-8?B?MGhtaUpabUxrODRzY2lXK3gzY3dYTUZYSURWL2dMMnFTWHZJM1VHNWN5bzdX?=
 =?utf-8?B?U0hhRU5CZ2xuam1VYUlEL0NCeW9nemZqYzIweHBvekN3V1lKSUlucytVN3V5?=
 =?utf-8?B?UUlxam5oMDdhT0YrM3UxYWRpMFZYZGZaQi9SeEdKKy9YOGlQRUNObGU1Z3li?=
 =?utf-8?B?bzhMK3RHeWp2VjlnUmNNMEpTOHJMTDdNcWJPN0RCMUllNEprbm9ydVVPd0NL?=
 =?utf-8?B?NHlsdEdSemNSRkh6elJib3FJdWtnb08rUTNybHBiQmhESkVabFlPSXBVZEJ1?=
 =?utf-8?B?cWNFd09ZcUl3cUU4QXdKQUk5R3kwL1JHbmFxb3U0MXk4cEtHMmlsYlluaWNQ?=
 =?utf-8?Q?cM8UmjP3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aec8a63b-9894-47f1-ca94-08d8c927f931
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 16:14:39.7621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PjdHZyP8r/ZEiZ7xjG7MEYT3P/ulCGsQ4GVRq5kuokegJfpmEOV69OjERz6oVhXu5vWv1qCnHpksshupz7kKHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4355
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/21 6:39 PM, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The ioctl is used to retrieve a guest's shared pages list.
> 

...

>   
> +int svm_get_shared_pages_list(struct kvm *kvm,
> +			      struct kvm_shared_pages_list *list)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct shared_region_array_entry *array;
> +	struct shared_region *pos;
> +	int ret, nents = 0;
> +	unsigned long sz;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (!list->size)
> +		return -EINVAL;
> +
> +	if (!sev->shared_pages_list_count)
> +		return put_user(0, list->pnents);
> +
> +	sz = sev->shared_pages_list_count * sizeof(struct shared_region_array_entry);
> +	if (sz > list->size)
> +		return -E2BIG;
> +
> +	array = kmalloc(sz, GFP_KERNEL);
> +	if (!array)
> +		return -ENOMEM;
> +
> +	mutex_lock(&kvm->lock);

I think this lock needs to be taken before the memory size is calculated. 
If the list is expanded after obtaining the size and before taking the 
lock, you will run off the end of the array.

Thanks,
Tom

> +	list_for_each_entry(pos, &sev->shared_pages_list, list) {
> +		array[nents].gfn_start = pos->gfn_start;
> +		array[nents++].gfn_end = pos->gfn_end;
> +	}
> +	mutex_unlock(&kvm->lock);
> +
> +	ret = -EFAULT;
> +	if (copy_to_user(list->buffer, array, sz))
> +		goto out;
> +	if (put_user(nents, list->pnents))
> +		goto out;
> +	ret = 0;
> +out:
> +	kfree(array);
> +	return ret;
> +}
> +
