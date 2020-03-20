Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D9618D98E
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 21:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgCTUiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 16:38:11 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:6050
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727175AbgCTUiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 16:38:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxXiIBMkcZjYyWeRLjGXbwaTDceYRHhPUI0UJofaHhmo7qUzXKNYfuHrdZ8HhHZfV9VCYjIjY/Mc5JDVJTXA45FB4RmJURehY2Tw7asyZCAHwTbxCu2eCIEQCpMEa9D+q7RNtx89lKKfpjZum00A7K3C15HRpvaSSiFbYoJQkUkFFsR92drIJ+QZkNbDs85JgqrEmI0KI8Y/T3xw5AAcOIZKtjqGsbTg9cdzm8ekuk4Uox9Cah6d60rm42lb3XW0zf6K3zIpNpwEzn6LzS+UwUgeatp1nlj70/kQj34nnPsNm0Ex1BtJzqmilPNTLJLmHu74zv5J+U2BguFqCxAsZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wn5YV1jI25T53rRibzoAe1TnCJWzBHMekEj8MPt0Ieo=;
 b=k0vT9VZvZqpfKNvbOngkISOJuQfx7iOKXLU97HyldYcj2BZdH60JL+5zH2nJL2bIKhVMIXVvbvsu12uHTGoXqHSReCGVChiOLY7XJuPOvp5zH2/TrU+m2F+2bdHwiHcwp01k/42oe9rv6xw3nvUiNXyzyDJ/XUCoN70rRVmVskc79VF23cJX5SQuyfOcLOxMeHxVcfCzwxXi/u52MbPs8qAsTRKaCpMp5a1jBfl8tXt3ezQIVlbpVTijkfGhwuo7rk3KGI39MJ37Qkwmtbv0pOfVqdQYvYk1y2MZNlIA+QHHHk3mfYsrNRil2FHWsY4jMW6bi4IMAgDzu6qHVWDD5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wn5YV1jI25T53rRibzoAe1TnCJWzBHMekEj8MPt0Ieo=;
 b=p5GIWO9Yz86nicEe+fWLqFFvJK6laGydClYcoTuB5+3axXFv3k20jjEN2g2PH52zPfHnHfeTz00GugOMnNDwzo/fgLmwnkJUQjBfF6vktKUE+5/3aAsmUDqNFt+3dPmmJFUDaOh4+0kURxfo3UmT0nVoOsMlx1Ba0Y1pmZcUJ0o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB3116.namprd12.prod.outlook.com (2603:10b6:5:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Fri, 20 Mar
 2020 20:37:28 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2814.025; Fri, 20 Mar 2020
 20:37:28 +0000
Subject: Re: [PATCH] KVM: SVM: Issue WBINVD after deactivating an SEV guest
To:     David Rientjes <rientjes@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <c8bf9087ca3711c5770bdeaafa3e45b717dc5ef4.1584720426.git.thomas.lendacky@amd.com>
 <alpine.DEB.2.21.2003201333510.205664@chino.kir.corp.google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <7b8d0c8c-d685-627b-676c-01c3d194fc82@amd.com>
Date:   Fri, 20 Mar 2020 15:37:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <alpine.DEB.2.21.2003201333510.205664@chino.kir.corp.google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0081.namprd04.prod.outlook.com
 (2603:10b6:805:f2::22) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (165.204.84.11) by SN6PR04CA0081.namprd04.prod.outlook.com (2603:10b6:805:f2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Fri, 20 Mar 2020 20:37:26 +0000
X-Originating-IP: [165.204.84.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a34b4a7a-8357-4bef-8e9d-08d7cd0e8134
X-MS-TrafficTypeDiagnostic: DM6PR12MB3116:|DM6PR12MB3116:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB311603DBB0B1B1C8B4286056ECF50@DM6PR12MB3116.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(199004)(956004)(6506007)(53546011)(6486002)(31686004)(66556008)(52116002)(6916009)(66476007)(8936002)(6512007)(54906003)(8676002)(81156014)(81166006)(31696002)(86362001)(66946007)(316002)(6666004)(16526019)(2616005)(4326008)(36756003)(26005)(186003)(5660300002)(478600001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3116;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ETK06Uu3FDraM9mNPKdvMltmd3Dl3OeqhngR5ole2BYc15HWru8KGlBzJuYLDJ81KMSeBzxJNLt9B8RjDDIWA+X4xWgbc2GVGldHr8ITBC6o0keeqqcLjt9wfjPP6yBzgsw6rjH3t56+JXHUtXwztRI5mMOUO3aqn7Gtx4sZGr091T7TCpB4oLJkXlXJ09FA9V6GFP3m7NrIoncDYQ/7ELJ62jpKHZa++SwcYLuT0Sj76WfyBQp7B2yplrE7T1Nbm43+56aeUS5jWPHb1lVlS1cGzTlmR9jtgrtbss7qA2y8cIuqYo08/gkIMXYuWN/iAODpvR9ATDhTQkf153UzWURLNnkE2Y8Hnf1t1joVeaJZ7lERgjnMovk+14qxVTiPnAhknnLj9LBpTxMIixx9wVAsSd1hA3WQ/9YIqW5PLO8XZHLdDQHezCUMFS4Zf42u
X-MS-Exchange-AntiSpam-MessageData: 3cp48oa6c7gtzaJRMpVTL+gihGeLkmyawm4lbUrkuoF9p8VRYE15rAGE7AgNBUAvGbXrKiTmmSHoBFBVOlI4vwvlyMbw0lLooRBjSev+dePApATLq4LC65nhnQSp2SfEDE2aEm69jMaANCcHKuvl1Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a34b4a7a-8357-4bef-8e9d-08d7cd0e8134
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:37:27.9114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O9Zjm0spBHQFIHdJPounKENJWhVcinjeWoUAW1Zu1lc3SMKFNACwsWfdNp7WLFwBP7NtwtwwctgbDC/nhaGDtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/20/20 3:34 PM, David Rientjes wrote:
> On Fri, 20 Mar 2020, Tom Lendacky wrote:
> 
>> Currently, CLFLUSH is used to flush SEV guest memory before the guest is
>> terminated (or a memory hotplug region is removed). However, CLFLUSH is
>> not enough to ensure that SEV guest tagged data is flushed from the cache.
>>
>> With 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations"), the
>> original WBINVD was removed. This then exposed crashes at random times
>> because of a cache flush race with a page that had both a hypervisor and
>> a guest tag in the cache.
>>
>> Restore the WBINVD when destroying an SEV guest and add a WBINVD to the
>> svm_unregister_enc_region() function to ensure hotplug memory is flushed
>> when removed. The DF_FLUSH can still be avoided at this point.
>>
>> Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> Should this be marked for stable?

The Fixes tag should take care of that.

Thanks,
Tom

> 
> Cc: stable@vger.kernel.org # 5.5+
> 
>> ---
>>   arch/x86/kvm/svm.c | 22 ++++++++++++++--------
>>   1 file changed, 14 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 08568ae9f7a1..d54cdca9c140 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -1980,14 +1980,6 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>>   static void __unregister_enc_region_locked(struct kvm *kvm,
>>   					   struct enc_region *region)
>>   {
>> -	/*
>> -	 * The guest may change the memory encryption attribute from C=0 -> C=1
>> -	 * or vice versa for this memory range. Lets make sure caches are
>> -	 * flushed to ensure that guest data gets written into memory with
>> -	 * correct C-bit.
>> -	 */
>> -	sev_clflush_pages(region->pages, region->npages);
>> -
>>   	sev_unpin_memory(kvm, region->pages, region->npages);
>>   	list_del(&region->list);
>>   	kfree(region);
>> @@ -2004,6 +1996,13 @@ static void sev_vm_destroy(struct kvm *kvm)
>>   
>>   	mutex_lock(&kvm->lock);
>>   
>> +	/*
>> +	 * Ensure that all guest tagged cache entries are flushed before
>> +	 * releasing the pages back to the system for use. CLFLUSH will
>> +	 * not do this, so issue a WBINVD.
>> +	 */
>> +	wbinvd_on_all_cpus();
>> +
>>   	/*
>>   	 * if userspace was terminated before unregistering the memory regions
>>   	 * then lets unpin all the registered memory.
>> @@ -7247,6 +7246,13 @@ static int svm_unregister_enc_region(struct kvm *kvm,
>>   		goto failed;
>>   	}
>>   
>> +	/*
>> +	 * Ensure that all guest tagged cache entries are flushed before
>> +	 * releasing the pages back to the system for use. CLFLUSH will
>> +	 * not do this, so issue a WBINVD.
>> +	 */
>> +	wbinvd_on_all_cpus();
>> +
>>   	__unregister_enc_region_locked(kvm, region);
>>   
>>   	mutex_unlock(&kvm->lock);
>> -- 
>> 2.17.1
>>
>>
