Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C2D7C9418
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 12:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbjJNKQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Oct 2023 06:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbjJNKQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Oct 2023 06:16:33 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDF0A2;
        Sat, 14 Oct 2023 03:16:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGzvjCNfKqt0eDxZlq2f65QOG7loYaRu+st410SWC/nqDw0o7KNSStCsmNFPeTroHhrIbaz8+1iHJHPHxcmY/Ue16h2GmxK4ysyQ87/rS5HJjmOo9OyIKc4n8kM1DB7TLYS1CFNZo2jQRbEzHZQ8pLg6fcQ3s0GwLGyvfenQjKgxhC+xGh5Pe57CYFO750zgEFpvQicWjXSXADDtrOXlgRGJmDeSZ53yInA+PJ5DaPVpZhSATsSjApZFfiCzLQT6zBA6/yDV7FjfRt3ur/4Ze6ajPdTdEWj3IHuEPjrIHm6CzZwImIuiWT204jnIde3YkJxH9+2FCuC74ES8rVNPjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFzqBN1PmWvfpGZqkAGpCO4dDdWre+DnRsFf5bsAKWI=;
 b=NEVzBATC+lWNquMOE7LLbAayGE4HBoGlBDz9DMTBSzTt3/muKZ6LFAadPXjWBp5v5ls1PzQFA6XETQ+bvZw3ZDYfU1FZo7YfdGmG3Bv4OEFlvUJxFj8NyF/dyEFRzkAjRxn4HAsTr8GOCTY8i+7UHM6Tx1IjU6C4ZjzMHCYfvB/Hi11+amugZskcBETjwng+XIDlFyamluENDWoIybymmkq3p4Q6GGIZ4AVM5Gs0UM+xKqlZNbnymDSgilwFTcHfMu8zIjgOL1hXfmOiB86RWpXJ5AiWyqZapo3c04rIPUjSY7O0SB7lmcChdNk8RIkYm6Zf8+JbO4skAyCC/Gj8FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFzqBN1PmWvfpGZqkAGpCO4dDdWre+DnRsFf5bsAKWI=;
 b=DpiWQpxj6prCKSCRWQ//Z+nVXcMdqDCE6hCTyBuWXnUpeXIo8mfMHOPV0iG/P+razFL9DGNOFdkpkaKYJZ78F+CAnhQRGVRjpQG+rXnhS4POSOUwhPTCwWpRTjH2d++WPu1XzGusbpnL1tYfYHtlZubmTEU/mEWt8/1w5ZieqWg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by SN7PR12MB7883.namprd12.prod.outlook.com (2603:10b6:806:32b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44; Sat, 14 Oct
 2023 10:16:27 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::8da7:5c21:c023:f0cc]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::8da7:5c21:c023:f0cc%7]) with mapi id 15.20.6863.043; Sat, 14 Oct 2023
 10:16:27 +0000
Message-ID: <a18658e5-3788-b3f3-db0d-1ab29ea89f88@amd.com>
Date:   Sat, 14 Oct 2023 15:46:14 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: SVM: Don't intercept IRET when injecting NMI and
 vNMI is enabled
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20231009212919.221810-1-seanjc@google.com>
 <e348e75dac85efce9186b6b10a6da1c6532a3378.camel@redhat.com>
 <ZSVju-lerDbxwamL@google.com>
Content-Language: en-US
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <ZSVju-lerDbxwamL@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::10) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|SN7PR12MB7883:EE_
X-MS-Office365-Filtering-Correlation-Id: 2154c900-491b-4a0a-de83-08dbcc9e9fc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xs59iElKjGx3ckoDw4F5GzQd9FDwGeHNC762j2xdxlSIWu28aKazjmTL9kyo5Nq3WVs7Zt4p/t/YDkwDlNZoPGXZHtDRSNTxjra8PbhVhXWA7Z6kejfExyP0rNhzg+/Ek8gC9q0pUpXam3fcRpdmwBEnVWWQnHHKWmRlonXEY+xYrgRQGFo/vW7utaxSQSPPFIxu7xxp3o3PCJpN82an39c/mnKBmzZb9/EZDBq/qrUHuvzZcd0LRddTZ1qGGCA4KGYahRVzdVS3vsW+47GAy5y78WN8BrIuXWSMaHRM/LaoNLvc1GcRmK0XJN6iu9lbEgglDsj3XZrbEotRIogvVAIZ1Gr6//Mf3fiNZOWRlcuTjRuC6Tzc/M/DkwHr6xmwAtMSqvc9fTQZRSP8O2MJhdbTwaQxDkbdtJvGr5HbEKiQH70ul4s+LeDgK/fqXNA/JfdaoyhdL8y+i2u5uVQMjvZ4gO64Pxe2z6PPBBKvIvbqaX3pqhoctF8sUGv78cu9nLQMRMi1enjBkGnFC9K3cSzE4ehXDNHj4HdtmIt7Raywn19kXUePudN3h+NlaaKsbR1Xdn4pFtJgTk3uXrgz0x2SRxfV4fdMMHRHvQInCfHyEiVP1aFzdiN1OGulALOcTLnmXNhgwQL6g2eJ6sbrcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(230922051799003)(451199024)(186009)(1800799009)(8936002)(44832011)(8676002)(4326008)(66946007)(5660300002)(66476007)(66556008)(36756003)(2906002)(31696002)(86362001)(6506007)(83380400001)(6512007)(31686004)(6666004)(53546011)(2616005)(26005)(38100700002)(508600001)(6486002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFdOdjRTMkJZdWMzZVljLzdPMC9tWnpjdk1tb000cTNMaDZ3cjh0TCtUM1FM?=
 =?utf-8?B?bEJlL2hnaFNYNllOa0VNbDkzbGZQVnpzTDUwa1lraGJ1NEtxMENkS1JCRzYz?=
 =?utf-8?B?Zkh6MjB3bllIM2FNOU5DVCtySlA3eUM5MzlHY3M2ZXJua0p6TmpoOGtvcm9s?=
 =?utf-8?B?UW9XS1dUR1NxNmhTUDlST2FjUmJQakI0ZGZQVDNhS1FjaDJubkp0YVY1cC9H?=
 =?utf-8?B?MEZhVUpjZGVqMjJLaTJMbWNEdE4zR1U4T1B1MVFBQ1FNclJCWi93OGNSYllx?=
 =?utf-8?B?YkxRUmFiN2FhN2t4NWJvNy8rUlJqRzZpNVZrYlVrSmxlK1lUYkRCVVRjb1NI?=
 =?utf-8?B?UzZWd1QzZk01RnUwRkxQK24xeVpKWjJkQWpSekJudVI1TExITm1CUkpxbTdD?=
 =?utf-8?B?UDJNUGgrVUNBWVQ5Q2FUemlaQmpvM1l2R2N5TE1HVjh1VWhMam54N2lyTEo5?=
 =?utf-8?B?eVBXZTB6c2hnM25MaFZYUm5wK1NXUEpXdWVuT0RmYnhUNjh1NGs3NVQ2ak01?=
 =?utf-8?B?enhNb0ZsUW5aSVZFUHUwcDFETkNINjlNcWsvaG9CQkZsVCs2RFAwR1llNi92?=
 =?utf-8?B?eHM1a2JTUWtOQVRzMU1hMGJYckpXaU1ic3RQR0hDbUluUGcyWG1MbkZXcVE0?=
 =?utf-8?B?NEN0VzI0Tk9hc29SSmppdzZObXhib2hNRUxUd3RwcTNuQWJKbXpuOVZjSVFy?=
 =?utf-8?B?UU44WlNuZ05ueC9Dd2VYMmxzU3M0bnlqL3YzNHdGTlhjUnROc201MExVSHRt?=
 =?utf-8?B?c25iUER3cC9JZDdCMFFvaHhVN1FsM09HN29wZjBPMyt6WU51Q3M0RmRTeGd4?=
 =?utf-8?B?aWt3dloxOW42ZGdDZ043M0VuSktSSFNoRUM1Y3RaSWdSak4xT0lEUXZoSUFE?=
 =?utf-8?B?LzR2QVlPdUt1K1FobU5rVG9abDJZZUZIQ0ZTaFZwcktmT3hBN3hRb1Ztd0Qy?=
 =?utf-8?B?ZU16NktZVTdpaWpQOVlhQmxtUmExcmI3MDhPMUJheDR0UHpVNlZraW9pYjZa?=
 =?utf-8?B?aU1FdUtrNHFlSkUrWktYTVUxWUpDbExwTzBwK1FyMGZuOTR6ejFzZXFCWG9I?=
 =?utf-8?B?Q3RJaDQ4YWFWbU0yWXdXNnM1Lys3QzEyZE1YYjF2VEJnZXlyMm5wWjcvcmh2?=
 =?utf-8?B?QzRaRyt6QlFPM2RkaWdya2lpYllGS0FlTXZ0TU1rTkhVUVR2WTRUQWt2dW5B?=
 =?utf-8?B?QVB2TXBsWm1mRGF6T2JReWNDYTAyK0RGRERhUFgwS2MxUjRPYTVuZ2t3ZkM1?=
 =?utf-8?B?NnpzWlBYdFpNZW1OZVE4QzI3NUovbmk4WEhWTnJUOU1VaFRtemp0Z1F1azhm?=
 =?utf-8?B?SiszdVQ1Wk9qekdtRGl6ajZaRDhYTzZUdlNDTnRDK1VIZ2huZ3B1M1BoZGxN?=
 =?utf-8?B?WkJpM0lNekNrN296aFptZlJyWFdrWUhrWlRkbmpjbU4rYUh4cVJZNG81UXdB?=
 =?utf-8?B?eXMvL3Y1V3krbUoxNWdJb1g1YjQ4cEwvWDFmMjM4WTdLc1FwSHcvdzhBZXBz?=
 =?utf-8?B?dC9YVjlpVXZYMGRFYU9aM0h1QVR6UjU5UUVaTE9FVS9abGg1ZS9rem9rWEFU?=
 =?utf-8?B?aGZmOTVqb0M5UEFXWThNalh3c2loWkwyeDZPbkJXM2g5SkxOUzU2NmZDbTU4?=
 =?utf-8?B?ME1EVUNWai9LcFFENXpFc3d5YlNndnF0SCszM3dzS3R4bTJaWlIzK215N0NL?=
 =?utf-8?B?M0FTTlgyK2V2Tmh6a205OUVKQ3BrL3Q3a3I5S3lZWS9iVzBFajhlOGlONmRJ?=
 =?utf-8?B?dy95UEVXT3ROa2Y0ZzZVM3QwWUttOW1zQmxjR3FOOWJ5K2JXTDVxako1ZFNH?=
 =?utf-8?B?RGRHUGhDVDg1Uk15NHRpQ2NiYml5cEpzZmdXaTlzZ3VVa3cvbTRzeDNhc0s2?=
 =?utf-8?B?L0NRYjhFWE8wQmhINVJFY1grN21XbHZQc01BclF2VUI1V3RpWGIzVXp2WGNP?=
 =?utf-8?B?aFdvZ3A5RGxqR2t5VmRPY0JBeVczM3Z3ZHlBMWFRT015RklRT2hTd1dtZnhm?=
 =?utf-8?B?a1JGZUtocStqWUozOFBJdllHdDVjc0Fhd2lvZUlNSzJvMkswZWw0ekM5WGty?=
 =?utf-8?B?R2tEb1ZLM053RkVueXYzZU8yNFFCRWhHdzR3VWFoa01hMUpFK3hNMTZQTDBQ?=
 =?utf-8?Q?lV2EcrezZ8oLaxXloEkV9rHQG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2154c900-491b-4a0a-de83-08dbcc9e9fc7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2023 10:16:27.3031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrd0zAdcsovD74F7kmwYsuHw1+hCVJHdrrxtqO/geVH2NvMXmTTq7KS4gphYiHuj2Pbi8xd0SSSs8AG+7awsyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7883
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/10/2023 8:16 PM, Sean Christopherson wrote:
> On Tue, Oct 10, 2023, Maxim Levitsky wrote:
>> У пн, 2023-10-09 у 14:29 -0700, Sean Christopherson пише:
>>> Note, per the APM, hardware sets the BLOCKING flag when software directly
>>> directly injects an NMI:
>>>
>>>   If Event Injection is used to inject an NMI when NMI Virtualization is
>>>   enabled, VMRUN sets V_NMI_MASK in the guest state.
>>
>> I think that this comment is not needed in the commit message. It describes
>> a different unrelated concern and can be put somewhere in the code but
>> not in the commit message.
> 
> I strongly disagree, this blurb in the APM directly affects the patch.  If hardware
> didn't set V_NMI_MASK, then the patch would need to be at least this:
> 
> --
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b7472ad183b9..d34ee3b8293e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3569,8 +3569,12 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>  	if (svm->nmi_l1_to_l2)
>  		return;
>  
> -	svm->nmi_masked = true;
> -	svm_set_iret_intercept(svm);
> +	if (is_vnmi_enabled(svm)) {
> +		svm->vmcb->control.int_ctl |= V_NMI_BLOCKING_MASK;
> +	} else {
> +		svm->nmi_masked = true;
> +		svm_set_iret_intercept(svm);
> +	}
>  	++vcpu->stat.nmi_injections;
>  }
>  
>

quick testing worked fine, KUT test ran fine and tested for non-nested mode so far.
Will do more nested testing and share the feedback.

Thanks,
Santosh

> base-commit: 86701e115030e020a052216baa942e8547e0b487

