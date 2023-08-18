Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDA0781452
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 22:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379987AbjHRUdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 16:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379972AbjHRUcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 16:32:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99A33C21;
        Fri, 18 Aug 2023 13:32:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJ1s+kADkR+3EBDS+lk59Fx+qzDkn9eEthmnzyK1m6A1qyWgpmnt0iMHiTsbrIoNSzhIQEM7qXkS5PtjcGECufPAbYuM5Oh35NS6beqFgVH8j/5MH+EBF4uAWzBTggwMV+lPcfnEbVue9NE/wms+F1mRGUDwwojd9SaBlf9JSiHrlIoGHO1zqUwf/sSrn280DUVV4/o0Ej0zQTneZfWCt5KyS5OKCjvzkMskhGKrgEXRz7xCvTMIbbhX+8lf69U0yy2P+hZWKoeezSqhXOIYzwq7+T0YozalimAlcv81d3Qrv0PmE5cv+5RwpgYcsDD01V4896iosuopC7l+sEYlpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/4WKRBhCl2iJtOXBTndHKY52QvV/EU73iWyOjPk7mTs=;
 b=nZs/cWSf9og30Jxv7jXb0bQ2hPs5Sj0Jm7gcyZBuJameoQXFWsprqHnqGuK05Xuym4omdRHx+EpGaVVo9GSMO8S/+qWIH+amm/a3gk+hlOuOtJ/2r5o82/93PSgwartnjWta3alEpwC1Qs3EuJSvkgH3s6zNK9ZQW8ifzcTXppmKeI685gNsXQSFkclmFaZSnrhPtM7Mb0zIeeC0iNIocWmjXYaF6zL1a85cNd0O7nVRlLgnPtU8t6MInuV/f8yysdcKkQt7+yL9bKTkGZpmGLP43oUMkRbeW2UsYB8EO6mIqrRP/4sOHYkDe952LHErJFS+/jHcyD29NVuMki+rHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4WKRBhCl2iJtOXBTndHKY52QvV/EU73iWyOjPk7mTs=;
 b=LkahU5BxEFsfmghDsUt+A3RZ2c0OItcErUnB0m//A23oX6HFrTwWVcJwcfmNLThM6U4/wnYsS46Oa5YPL0dHjXrARdf2+AwiMkQpj/T22ykCx1E8pezNVkQWBzzwqis72x/60vu3vSFjT3+VSghU5EVgZr52TJjTZ29ERiK8t5o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DS0PR12MB6464.namprd12.prod.outlook.com (2603:10b6:8:c4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.31; Fri, 18 Aug 2023 20:32:37 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::af15:9d:25ab:206b]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::af15:9d:25ab:206b%3]) with mapi id 15.20.6678.031; Fri, 18 Aug 2023
 20:32:37 +0000
Message-ID: <52c6a8a6-3a0a-83ba-173d-0833e16b64fd@amd.com>
Date:   Fri, 18 Aug 2023 15:32:34 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 4/8] KVM: gmem: protect kvm_mmu_invalidate_end()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
References: <cover.1692119201.git.isaku.yamahata@intel.com>
 <b37fb13a9aeb8683d5fdd5351cdc5034639eb2bb.1692119201.git.isaku.yamahata@intel.com>
 <ZN+whX3/lSBcZKUj@google.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ZN+whX3/lSBcZKUj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::14) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DS0PR12MB6464:EE_
X-MS-Office365-Filtering-Correlation-Id: a434dcb1-5668-4530-702b-08dba02a42f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nux2QKSxnYypoXBKVJ9BoYCW1/cecBZ1tW5XK8XrLEuRAUBAjTyX+oGKO5w7jjKlPA0exq4yuMFm5+oYdwZGsU7Lmh7a66RzrA8+bezUaFWNfx/7lYgA4Qm+Oas3wXxyKjJ16wh6AH7fVVjsWFyLWoBBt9/R3XphvC0759e3mJUcAx6AGtakQUoyO8/vPLGqeWu9W3ZgBrbNQbu7MQs9J3ma8TcALN9dcE6i2rYhouBH2eiqMg1hAZ1QZHzCmt6UPBUZzSIdBLhRqNVze1A1NLBwObrcMHDcf41c5IhpCQxoNW+z0IRvWzrzMwK1xb/SL6MGjGDBVkKdzEU/iALZzOVAPOjkgaXSGYDF4DFcyENJmZEM9WsypVC4oxrFt1a0PzuC5IVKd/COUgh4pmfc+o3410rjo0aqg8lSBxp1PmxWsCQYTFkvXISwiJnDCVumtfsrj0PcOhWlig5cIOGuo6ej/3dWEXiD6YU1tSnVTq1sdvyVZVVELXJ/+yztQLzZX4ThUTr2fDBmVRXDlmj2LIiw96ErAPqQxQtyktDRwR5PJaphLGgzfB6MB2Db5KOmYGHF7zZdAOP2jfxTihEgFnM3ShUOwIPoZteCV943w3Q3J+Q6xXO8NCt3lffVLZQfDoesUI2vh3WdKE9Trv33RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199024)(1800799009)(186009)(31686004)(86362001)(36756003)(31696002)(38100700002)(5660300002)(2616005)(6506007)(66946007)(66476007)(478600001)(6486002)(316002)(66556008)(53546011)(6666004)(26005)(54906003)(8936002)(6512007)(8676002)(4326008)(41300700001)(83380400001)(7416002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWNJL3E0OEN3cVkyQ285aVRycDQ2U0h0MlJQeU9tOXFvcytUaXpVeXR2VTMv?=
 =?utf-8?B?cFNIZjA5amFFeGJYbmtMZzl4cGxDTUdVZlp3L1BRWTdZUFphZXdFOVV1aHEz?=
 =?utf-8?B?Y1JtWGtBZ2hkbHo0ZGEvdzZyK1lYeERIK2xxWlVHLzF4N0dJQTdySW1WYSt4?=
 =?utf-8?B?SUZ6L2VZUWpTeHlDb2Zwb0s3T0ZXZlFZbThMWGtRbnp4Z2Fxd1BuUXJPdEF3?=
 =?utf-8?B?ckh4Nk96UU5QNE55dlVrdVFDajNrYWd6MVF2RXJGTVdaVXN0d293QlpxWDN1?=
 =?utf-8?B?SloyeVJCazFkbitIaHZOSlRqNC9qbWUyc1RYaUhpWTg4aVlPY0oySTM3cktV?=
 =?utf-8?B?RC9OdS9ha1JRMFpKVTZ4ZnExWVNpTFIxSkFPL2xVOHhvM0FzUnZrRWRDam1o?=
 =?utf-8?B?UXBYWFF2dm1TYWJlaWhBNUwzbC9KQkdHOTNiVXdiVmNVOE9tTHVablEzWmg4?=
 =?utf-8?B?NlQ2TWFxZW51VEpJeWx0NE9ZV0pHNEdwd1ZjVUNFc1FIaE9LRFRlMGI2QmM0?=
 =?utf-8?B?dFdZMDVPR2VFeEFyVUo3MkdTK0J0WHVqYjRwK0V6ekNEVXltZVVFZ1VvRWZs?=
 =?utf-8?B?KzhQVmN0K2VjcTBGTDZWL3IzdzFXRm5vTHBybzZqMVRkT1VBK3RBMXU3MUFk?=
 =?utf-8?B?R2pkWC9kM2RVRVFoYkd1MkxqdTNHbVQ3UWdPM3JqclB0T2RZa2lIZWgvaURx?=
 =?utf-8?B?blFYY2lDYm5sbGQwbitkZzZLS3dLTi90QWphNDRtbVAraVo3SXI2eGdIbE5U?=
 =?utf-8?B?eDAyZGdnWVord24wRDR0WVBISHZPWHpPSE82SUZUdXBYV2hDUnBhc3lTVFFh?=
 =?utf-8?B?SllRWENTL1k4SnNndjh4WGdMVi9TVWxDbCtkbEFDWW8vU1ZFbnFNL1NlWG4z?=
 =?utf-8?B?VVlGWUtSaFZyb0xxbStVYVMzcHU5MmYxSmwvY0YyUVhnMG9LZHhTUXZZaDIx?=
 =?utf-8?B?T1Y5YnJVQVBMdUZkQTIweU1kc2FwOS9WUEN2RUowVVZZbHhjWldKaEhselo1?=
 =?utf-8?B?d29JYmlFQWdzcVI2bTJwKzFXUzVMUDVqNVVjcG9tSVJ1SE9mUlh4NTZ5UXhj?=
 =?utf-8?B?b1lNWTBybE9EVkw5Vm0rM01hNmJvQWR3SUl5TVh2c3poRFEvZ2dHRDkwakF3?=
 =?utf-8?B?NkVWVHNVVUtBQnJGb3J4bFRYSEJQS1RtaTQvSG5tZGhjYURPTmFIZDQzZEFQ?=
 =?utf-8?B?cFYxWDFlSW5BQXoxblVSWGp4SXYycDdITHlSWFYydU8vK25MNWR2WWVQNlZ4?=
 =?utf-8?B?aXMrenNFMUNJclpWUU5EQUZLYmpnaEtLc1Y1TTc0YkNDVEtBMFJPVzc5NEV6?=
 =?utf-8?B?dHg4RUt6a1dMRUJ6OVFFMGg5T051clpacTFTdVdybHNoRkg5cStXd2l5WkRx?=
 =?utf-8?B?K29oVVVlakNldnBZSm9nNnpoY0xMYytENEVJTE02VEp1djRocWhoMzMwVita?=
 =?utf-8?B?ZEphcjVnNnZNUUV1elFCd2tkWHlrcU1Md1pPWkdua0JUb0dTalgvdlIzZGEw?=
 =?utf-8?B?ZzlxaG1ZOUczT0owaXovdkFoSGpjWDlVakFMRnRLaXRTekgycFpNdWwzRzd3?=
 =?utf-8?B?ck1DM1VpcFMrazRZWEdEaUFkSWdnV3V5QlFkS1M5eDFxVXJJRkRZd21SeFpJ?=
 =?utf-8?B?Y1FMSTVyR05JSDNhcnFzZjJkZmlkQzdYQkljY29zRXhlUkpLd21Ub01Oc3VI?=
 =?utf-8?B?UU50bGQ1bDliYldmOG1WZG1pLzVnajRuYkprSVZ4VFJCZlhzOExwcW11YktN?=
 =?utf-8?B?N3lObjd3eWVZK3QvQjhrOThOVHg4QlkyWWx5TTRLeTIzRHZ2alV4MDlUbXRq?=
 =?utf-8?B?Rms0NXJLQzJiejFYM2tyNkE0Ym5md0dHT2FIZkZIMGJFMGFLMGxaRGxIVzUz?=
 =?utf-8?B?VHhxd0xxa2lkcUJsSkdMeGNtN3liaGZhOFgwRWh2VkVYYXlMUWlzUUtXMjl5?=
 =?utf-8?B?MDl5dVplWFNzRDhzRHdyeFVLemtXSS9lb1pURlVXZEhCTXEvMTlzMkxRYXFr?=
 =?utf-8?B?K0NrR09LeHBpRjJvTzE1aVRPa2pCS2liQzR2ZTg0OVFjd1FlNFhOWU4zWUx2?=
 =?utf-8?B?Y1dBZ1JtUCtjVkgzNm1PZDJRR01XaW5nQ21qZG5BemJyYmF2MzV6Rm4yYjhR?=
 =?utf-8?Q?VrZ0amPiFn5IGZ67LiXW0ge9O?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a434dcb1-5668-4530-702b-08dba02a42f6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2023 20:32:37.6636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bujt/hoV4vbyqn4iH044SAi9X1JdQSeroQ8tmcT9yF8BEoE+i5R3eaR6NN3VDg/QchVbHQQgqB+WO9UY0ImV0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6464
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/18/2023 12:55 PM, Sean Christopherson wrote:
> On Tue, Aug 15, 2023, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> kvm_mmu_invalidate_end() updates struct kvm::mmu_invalidate_in_progress
>> and it's protected by kvm::mmu_lock.  call kvm_mmu_invalidate_end() before
>> unlocking it. Not after the unlock.
>>
>> Fixes: 8e9009ca6d14 ("KVM: Introduce per-page memory attributes")
> 
> This fixes is wrong.  It won't matter in the long run, but it makes my life that
> much harder.
> 
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>>   virt/kvm/kvm_main.c | 15 ++++++++++++++-
>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 8bfeb615fc4d..49380cd62367 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -535,6 +535,7 @@ struct kvm_mmu_notifier_range {
>>   	} arg;
>>   	gfn_handler_t handler;
>>   	on_lock_fn_t on_lock;
>> +	on_unlock_fn_t before_unlock;
>>   	on_unlock_fn_t on_unlock;
> 
> Ugh, shame on my past me.  Having on_lock and on_unlock be asymmetrical with respect
> to the lock is nasty.
> 
> I would much rather we either (a) be explicit, e.g. before_(un)lock and after_(un)lock,
> or (b) have just on_(un)lock, make them symetrical, and handle the SEV mess a
> different way.
> 
> The SEV hook doesn't actually care about running immediately after unlock, it just
> wants to know if there was an overlapping memslot.  It can run after SRCU is dropped,
> because even if we make the behavior more precise (right now it blasts WBINVD),
> just having a reference to memslots isn't sufficient, the code needs to guarantee
> memslots are *stable*.  And that is already guaranteed by the notifier code, i.e.
> the SEV code could just reacquire SRCU.

On a separate note here, the SEV hook blasting WBINVD is still causing 
serious performance degradation issues with SNP triggered via 
AutoNUMA/numad/KSM, etc. With reference to previous discussions related 
to it, we have plans to replace WBINVD with CLFLUSHOPT.

Pasting your previous thoughts on the same:

For SNP guests, KVM should use CLFLUSHOPT and not WBINVD.
That will slow down the SNP guest itself, but it should eliminate the 
noisy neighbor problems.

In theory, KVM could do the same for SEV/SEV-ES guests, but that's 
subtly quite difficult, because in order to use CLFLUSHOPT, the kernel 
needs a valid VA=>PA mapping.
Because mmu_notifier_invalidate_range_start() calls aren't fully 
serialized, KVM would encounter situations where there is no valid 
mapping for the userspace VA.
KVM could ignore those, but IIRC when Mingwei and I last looked at this, 
we weren't super confident that KVM wouldn't miss edge cases.

Using KVM's SPTEs to get the PA isn't a great option, as that would 
require KVM to flush whenever a leaf SPTE were zapped, i.e. even when 
_KVM_ initiates the zap.

UPM is supposed to make this easier because the notifier should be able 
to provide the PFN(s) being unmapped and the use the direct map to 
flush.  I don't think the proposed series actually provides the PFN, but 
it should not be difficult to add.

Thanks,
Ashish

