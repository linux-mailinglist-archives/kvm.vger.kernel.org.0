Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1197CD248
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 04:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344182AbjJRC3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 22:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjJRC3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 22:29:23 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E36AB;
        Tue, 17 Oct 2023 19:29:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9rIP5BbP5hWWIZBSTm4Jlzx1IUMRhqa0edVRUhXV8D9zcH3AFP1U1Utmo5mV1xryglVK7a9how/ARGl+Y6u0auWbczuNFS4ecdbNyvJC5gAr+TT6ihFWy1g575Lw/a6f/eG6X9ByLQs6QkxFxGBldUiYwUwlAoZPh24Mx9O8vzZwOKF44m81mVhZ0RVdT8++IwspL960f315lexQxnBFIDkM7I32bPfHTDChQuCGUj1uuR8QsquJuhQ0WCalCFwfl+KSxmChULmHlC9um9TyjxAuBDOXOfyxAQgs8cCfBLw8BmUTlvbXoDbItZyVT/WTokkqC4wFdooJdiaESqJrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdunNkpg1VSqiYJ/aevxDaNiul6VMkZa9I8gV6/jsnE=;
 b=lHIe+oncHLapMKs/Wn0E2Pu/7L+UpNxTqMDgUANGUzRazcmuJNh2v1ydQX+Hn2Xy0cWR0Y1CFG8gwgHq0SaR4HBbKoh7Q3gq07VHy9SUVIHuMi1Y58yEezkZmWSzaSqV/zybgxyDu3htxv9cyAhf0+OgUciXL/EDuFctS+1wHEmiOlumDRkO3PHPWyZoIKDD1+jQfVxgdAOOm+zWC65Tr2Ca+oKW5OGaKrWetNqRNaWF9Fl0W8uXerCAGxYPJUcCF/eb9Y5846GimjFYHBJHKuxu/fzJqdSeE4trI8rG0DMc/JcGRSn6m7hVV5Fg7TST95swjYhx1/Z6cQoBpdgYSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdunNkpg1VSqiYJ/aevxDaNiul6VMkZa9I8gV6/jsnE=;
 b=lCjJAKmRXMxr+4dy8czH1G4oPaPnPvUxvPBI1XTYP6ZG5WD7rMErvL6Sa2j39qxkOrN3Uxs3+W3TMmpi5GpcBDIT5vAwQyMXD4z3+avse1XIWg3WBJIsP/ZdDOPDToEhbNUAH0jSXXfeDufr+Yf+up8QRHcDIBxvzqMKTUi5KZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by BN9PR12MB5292.namprd12.prod.outlook.com (2603:10b6:408:105::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Wed, 18 Oct
 2023 02:29:18 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a%3]) with mapi id 15.20.6863.043; Wed, 18 Oct 2023
 02:29:18 +0000
Message-ID: <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
Date:   Wed, 18 Oct 2023 13:28:50 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Dionna Amalie Glaze <dionnaglaze@google.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com>
 <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZS614OSoritrE1d2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0006.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:208::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|BN9PR12MB5292:EE_
X-MS-Office365-Filtering-Correlation-Id: aca489fc-b572-4a17-7ac1-08dbcf82075c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LbmdoO3EzPKqoaRcScNp5kqXmcbqUH6XxayKGhGlhUYOoUcaddZrXDd3mrLx6mWxRKs1+0nEznGDz+xBH3qb3ivKTxrorI/j+TBlBhO7yPy+TIfZTjEqeRZIpd3zRg2dUxd0dY7Xf/qfdKQatOaA7IXbJSNyfrkFii/0aLTYVXpkIKRYW5rHVHX5JdfV6pb2Y/TuZGFHCoS2hZN6Z85iPJJ4TqJ9hrIlP7AtGsCX5xYiWd5WhQrE0/3NdrsSfpOVzIKKYEX+3Vv7GfA4MDXRb7gKDwLwSCaWCeL+RsPcgA7Q6y7RfjZfctpRXXKMdh5iEe8B5j3T53SWRhebJxr1SectWXjgQs4w4EtflsjZgirhtUKE2KUas5ZoIovwH8UAjXewx59QdREjcFxizltau+1UIv+VJFW2m6HkxE7EfTfcrhG7096UAkCindfv6L5cqE8okGHhICnOyI59UPQFlSthZs7jS0gisnpFMkDXOzR9kxWkEc85miULYzj4lnkuerwnZ2BdxaAFTGX+aIlzSgNeJLLmBvJWyHe7pUr/BWlMNASidcb2RQnIkso2MK2g81b16ZXJARjy6v43mOw/CzWc/Yigvfi2ANHY8uQZFDeYnQi84Zk30xbPu6HJZXy1b6Ml1XOiufW2h+VRLOmA6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(39860400002)(376002)(136003)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(36756003)(31686004)(66476007)(66946007)(110136005)(54906003)(66556008)(38100700002)(31696002)(53546011)(83380400001)(6666004)(2616005)(26005)(6506007)(6512007)(8936002)(316002)(2906002)(478600001)(6486002)(7416002)(7406005)(5660300002)(8676002)(4326008)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vm5OM08rNkFBR0RZYytSRE13UEhlUlM1K0FJMFNNN3pvZm94eHRJZ0g2SnR1?=
 =?utf-8?B?UlZUeWo3SWd1MXozL2w0QndPQ0g4T1VPazYxUmRrZS9ndjhhQ25RaSs4dWdH?=
 =?utf-8?B?dmx5RXRTbDBIWTZEUFI2bFJCR1dXblE3UHkxcnV2NStRak94cjRsL0VCRUpu?=
 =?utf-8?B?S0daRmxUT09XVThRRm1RTWtaR1pucitqNXVneThobGlZaXdwMzk5N1F1Vk5r?=
 =?utf-8?B?MzQ5d1ZaN1RMOVByUGlxVFEzQjNoMDk0ZzgxU3BCeHJmYWU3Z0NOSTFGOWtZ?=
 =?utf-8?B?UlZ6VjNRMlViYUtkdHNHWDVHZVlRVHFqWVErdEdLOWhsRkU2WGtyUWZxZXc5?=
 =?utf-8?B?RUlrM3lmVm1BR1I1amFoOHoyam9aQVNhaG1FeDZtSG1JbHRCeFNpUTgwekdE?=
 =?utf-8?B?R3pZeGtXYWU3WldYVGVOQ0s1cTI0bElXQ3hJWVo3QWRwNHQ4OW1PYng1WStM?=
 =?utf-8?B?UW9pUjZ5MkQ0TGtySEROdzhXV0NVWUt5aUxSclFBZ3BGU1VCeWs5NTlWQnIx?=
 =?utf-8?B?Tml1blhudUJkbkRZV0FLS242dk9yYzFyWk1sWHRaRWdnMUxiRVZMbk1taVRn?=
 =?utf-8?B?YTZYTm5kY012Z0NIVkRJelJYYUFOdHRjUkVTallYN2o3U3hqdDRBSWJxcXM2?=
 =?utf-8?B?MzVIaUx2OWVJN3NYOUVSVEtwd253RU5TdlhwYUVadHl1dm1qKzh4OWFCN2ZW?=
 =?utf-8?B?ZnEwblRzWG5UdzVUSkpTN3I2MXAyTUNIMHQwMHZ3NFdZUjVpUVhiMHUxNUtD?=
 =?utf-8?B?Um1wVTZqME1zL1lEWXdqRDM4UWNsTDJkSU8veDJ2ZzAwUlV1ZnhaaVBmTFZF?=
 =?utf-8?B?dFpLaEhzd1UvTjRxSG03ZXhPSUEyUVRENktQVTByL2ZZYjk4SUoxMGhNSERD?=
 =?utf-8?B?QkZaYVF5VGVpbmxqYlJjUE5aaVMveDlHK1dITWN2UHo2SW1tNmhXcnJaY2pT?=
 =?utf-8?B?dWJIbUR1NXU3MmpoVm1IZmFBYW9kb1lnZ2trRzc0aU1rbDRvZXBWaTlzNTQr?=
 =?utf-8?B?citydFpuK29yVUttMnRKMWxPZkdudTUzMEJ5b1BBbStsNnpvVFpqOXZGZ3lU?=
 =?utf-8?B?V0w5dEhWd3R0T25KSU9XSFRDRnBRdWhWdFdSVEVveDZ4MnRLTjYyNTZQWWll?=
 =?utf-8?B?WHRnaDRnUTY3R2ZFM1FSOGVtRmlzRWhwNzNZeUNqbkhhVHhhZlROREVXMUFp?=
 =?utf-8?B?NVpSTVo5SElBYXlQRW1RTlZQbVA1bHg1ZXJnQ2ZWUXdZd1Rabk5NVTEyamN1?=
 =?utf-8?B?MkVXaTYxdXhhLzNSS0JzQ1p4RjRDNllKbDcvbE5uVDZCZFZBajdFQjRZZUEw?=
 =?utf-8?B?UDQ0c210aHQxeUJoRDJ0c1RnU0pmbXRNTll0L3BoWkVMUitIU245cjRyT2I2?=
 =?utf-8?B?dTBQWDErR01NSnNLZUlBTDg3TzVTMkMyQWMrdVR4SkhnYU1mdmRjZDlETkI0?=
 =?utf-8?B?eFNjWU05Y2NGSnZzZU4zbytyVzY2TWtUTEo0QklhY29TRm9QQnNNUS9HTlI3?=
 =?utf-8?B?N2dBS0F0T3d6U2xWbXJhT0Nveld2RG5aRHdJKy9Ob0srQjhQSDZuS00xNkRY?=
 =?utf-8?B?S3FORzU4djBWZDNmVkxxS2V6UURLem5pZ09IRlRoWHo5YXFGR1pCbW9ITGlG?=
 =?utf-8?B?S3BnSWVwOW51TG8xS3ZCTzhwa1Z1NFNvUDBTNmhwRFpwWThEaXVLZlVZTmpm?=
 =?utf-8?B?Q2Y5SVVZcEt1Y3AvSmVieE5pUmpJeiszOGpaNUt2aTRGWHFYejFIK1R2QkFi?=
 =?utf-8?B?RnlSM0ZLRzJsMmJMeGFVNnZFeWFpSXZmeWxYWUJrQStWNTFFS21GVkM5OEZJ?=
 =?utf-8?B?MUY0a2JNNUduM3FtVmlhOFZoYkM0ZnJyaGtvMEZQTG9TZGd3YXh3Rk9SZnd0?=
 =?utf-8?B?cTdaaDlmNlVaT0VkSmtJc2x0cGx1UnNnYVI3elAxR2MwTWdseUViK3ltUG9v?=
 =?utf-8?B?NW4zMnd0K0pBOERtamxJNnl6cmcvQkJWVm93STZMcHRTUUZzWjdlOWFPWWJP?=
 =?utf-8?B?a3IvOTJBYmpiQzQrODRaL25IUkhvSUpEQTRRS1RJb3ZpcXhtRHhxT29pYngv?=
 =?utf-8?B?TkllY3lFeEhwUWxQaTJ3UVg5bEUxNmN5Z3VxSnRHQ29UOE4wQTZydWNNckxB?=
 =?utf-8?Q?m1PYd3hdcOg68yb74h9LZ4X6t?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca489fc-b572-4a17-7ac1-08dbcf82075c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 02:29:18.2565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qhtNQlgh8nOAm1RVarS+kyNvIFvEraSvZW1T7W59XmKoE6qH1KHZm6sph9gfhglEjghbDrmWWMsKSEEqQaRUZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5292
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 18/10/23 03:27, Sean Christopherson wrote:
> On Mon, Oct 16, 2023, Dionna Amalie Glaze wrote:
>>> +
>>> +       /*
>>> +        * If a VMM-specific certificate blob hasn't been provided, grab the
>>> +        * host-wide one.
>>> +        */
>>> +       snp_certs = sev_snp_certs_get(sev->snp_certs);
>>> +       if (!snp_certs)
>>> +               snp_certs = sev_snp_global_certs_get();
>>> +
>>
>> This is where the generation I suggested adding would get checked. If
>> the instance certs' generation is not the global generation, then I
>> think we need a way to return to the VMM to make that right before
>> continuing to provide outdated certificates.
>> This might be an unreasonable request, but the fact that the certs and
>> reported_tcb can be set while a VM is running makes this an issue.
> 
> Before we get that far, the changelogs need to explain why the kernel is storing
> userspace blobs in the first place.  The whole thing is a bit of a mess.
> 
> sev_snp_global_certs_get() has data races that could lead to variations of TOCTOU
> bugs: sev_ioctl_snp_set_config() can overwrite psp_master->sev_data->snp_certs
> while sev_snp_global_certs_get() is running.  If the compiler reloads snp_certs
> between bumping the refcount and grabbing the pointer, KVM will end up leaking a
> refcount and consuming a pointer without a refcount.
> 
> 	if (!kref_get_unless_zero(&certs->kref))
> 		return NULL;
> 
> 	return certs;

I'm missing something here. The @certs pointer is on the stack, if it is 
being released elsewhere - kref_get_unless_zero() is going to fail and 
return NULL. How can this @certs not have the refcount incremented?


> If allocating memory for the certs fails, the kernel will have set the config
> but not store the corresponding certs.


Ah true.

> 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> 		if (ret)
> 			goto e_free;
> 
> 		memcpy(&sev->snp_config, &config, sizeof(config));
> 	}
> 
> 	/*
> 	 * If the new certs are passed then cache it else free the old certs.
> 	 */
> 	if (input.certs_len) {
> 		snp_certs = sev_snp_certs_new(certs, input.certs_len);
> 		if (!snp_certs) {
> 			ret = -ENOMEM;
> 			goto e_free;
> 		}
> 	}
> 
> Reasoning about ordering is also difficult, e.g. what is KVM's contract with
> userspace in terms of recognizing new global certs?
 >
> I don't understand why the kernel needs to manage the certs.  AFAICT the so called
> global certs aren't an input to SEV_CMD_SNP_CONFIG, i.e. SNP_SET_EXT_CONFIG is
> purely a software defined thing.
> > The easiest solution I can think of is to have KVM provide a chunk of 
memory in
> kvm_sev_info for SNP guests that userspace can mmap(), a la vcpu->run.
> 
> 	struct sev_snp_certs {
> 		u8 data[KVM_MAX_SEV_SNP_CERT_SIZE];
> 		u32 size;
> 		u8 pad[<size to make the struct page aligned>];
> 	};
> 
> When the guest requests the certs, KVM does something like:
> 
> 	certs_size = READ_ONCE(sev->snp_certs->size);
> 	if (certs_size > sizeof(sev->snp_certs->data) ||
> 	    !IS_ALIGNED(certs_size, PAGE_SIZE))
> 		certs_size = 0;
> 
> 	if (certs_size && (data_npages << PAGE_SHIFT) < certs_size) {
> 		vcpu->arch.regs[VCPU_REGS_RBX] = certs_size >> PAGE_SHIFT;
> 		exitcode = SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN);
> 		goto cleanup;
> 	}
> 
> 	...
> 
> 	if (certs_size &&
> 	    kvm_write_guest(kvm, data_gpa, sev->snp_certs->data, certs_size))
> 		exitcode = SEV_RET_INVALID_ADDRESS;
> 
> If userspace wants to provide garbage to the guest, so be it, not KVM's problem.
> That way, whether the VM gets the global cert or a per-VM cert is purely a userspace
> concern.

The global cert lives in CCP (/dev/sev), the per VM cert lives in 
kvmvm_fd. "A la vcpu->run" is fine for the latter but for the former we 
need something else. And there is scenario when one global certs blob is 
what is needed and copying it over multiple VMs seems suboptimal.

> If userspace needs to *stall* cert requests, e.g. while the certs are being updated,

afaik it does not need to.

> then that's a different issue entirely.  If the GHCB allows telling the guest to
> retry the request, then it should be trivially easy to solve, e.g. add a flag in
> sev_snp_certs.  If KVM must "immediately" handle the request, then we'll need more
> elaborate uAPI.


-- 
Alexey


