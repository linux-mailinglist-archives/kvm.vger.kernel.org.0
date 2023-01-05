Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E94A65F7A6
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 00:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbjAEXhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 18:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbjAEXhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 18:37:32 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8558113DF4;
        Thu,  5 Jan 2023 15:37:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bqb8lwVIBhTTarGBTfszu9AvMMGqYQRHrydJSV/EQocCLUoBz7Ip09cM5sm3GukMYlNm9r8bf7OWTydHXJthSkpDxlM7WET2hRzc5EhFcJIyDIuqdbZK75Ir3I8bCZlZieQ7kV/rVNFlh4X2DR5BYg/1yqw6tH22QR1sLXEQE4fWuTPLv77juvE9YoJ+cJY9u+SRy8KbhFy89Xfg9OMKuJVgvPSoIS+gCEGtAXkF1azQiet6i4LkVRf6/bysZUlXkoFw8DGdN2OTRCMLC3UvrOPqp1kVjkSXkLKyj1WRRmzbcrdnZMfFOXwfVGiI3wJX9V2WqzLOxMQDTudk8w+kfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z1QMWYDo/8DtopMDdvSQ0n00WEaJe/JO3JW86UV+kkU=;
 b=NYl8R9LKWr3/fLYA46+aQV62GxhEEH3HbRIUJu4z0OeOVfHJJG1gkOPosCl2lfjflZL7sD7o+wt7n0eIQyLWlRiU6y58ldB9DFBjUJu6eAknak/bk8uakSEHWQ4r4LXH917DIp76poe1LfHsHLZLgkHQuGlhkBTiE1nC96p9hKapmbmHDO9mDNYlAuUTKyVe2wWCxOsxFSMsQ1GePH/XvDgaGqT9WD5+PErfwE4hzhMMgYkIB3xUSis3zHQSKVrbFUcHl4yBWSs3lxlyN8WGEjH7degCU9xvxh8d0LP+CHIUN3/8aWtQ+wEroUMjx4zFWnWodfAwwGYqAvylyYvSxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1QMWYDo/8DtopMDdvSQ0n00WEaJe/JO3JW86UV+kkU=;
 b=kQ0RYe3MhdPXIGVmaJdx6zynNI8c/aTFDSqIhSxX8T6ErcAEsB5CWaboPOOLwGAjUFixNH7hXyCOvOkEbcXaAGHThpgJejUDv4GcVeKbpliOUDnGzbE5m8oXlfW2+mHAisFbi7CcWp/FJjg1PGOHnlyiAHGAm9qmDNwYdFvb//M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB5328.namprd12.prod.outlook.com (2603:10b6:5:39f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 23:37:28 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 23:37:27 +0000
Message-ID: <fd23ee51-ec47-717d-7cce-1d79db8b6bd3@amd.com>
Date:   Thu, 5 Jan 2023 17:37:20 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 37/64] KVM: SVM: Add KVM_SNP_INIT command
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Pavan Kumar Paluri <papaluri@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-38-michael.roth@amd.com> <Y7BG6pSuoZsBQYrx@kernel.org>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y7BG6pSuoZsBQYrx@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0053.prod.exchangelabs.com (2603:10b6:208:23f::22)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM4PR12MB5328:EE_
X-MS-Office365-Filtering-Correlation-Id: 85267bdd-0bdf-4333-40fc-08daef75ce03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oUD4KhbUt0nUkDXCZoPjTIZGcN5JqT+dM+frVG8nVZAxrkfXnl5+c37H8fWU0/ddJdbyuj23lVkacZ5FN9BJ2vXMt2SZtiKy0fSN4qW1lOsJa5v4Hdu2nwIVvWUeiWH29e/y0qlzNaqOPelwF88Qgt4gUVfD24SP5cp98niBZ/daxGsaNboQx9gu8ECWHwqELvnT8vp2Ct/T4gm1YpzQkqkEHedVOfz+5LAdOS/6xy41NqNfzLcSeprxIeMKxkBlgXvslcR8Ky7jwzIzgUePD7hKLHaH6bZ7yUvQZjid7+8o0cS/eBfXgIaTRp/kmVCMt2BjG0DDF/Wv1CZA82Dm38Kl3AgoFV6Ie7x1MzSyrF+siGGF7W5XF/LhHAwc6l1hM89OgHEMcwmZP/1syhWhJx790d5l4xIz967sCVEMVZhZslRU7thf8arURWExl6EdqRe/TbUb9yZyrPa0Z7ItMncAcD1zJt/5FHCjPZhzUtX/HtRzliNi36jhTcq6k6Oe7EB6yP4YG5aQ/u0Cn4eHDw0e9P6YmFnhd/HhEAfuMG39ivD9zJAh/lpifnYyEQDpcsir1Ki1zIb44wjVqp1NA0D4Bpy6eCEmzl1KXxHR4Aff/T8fO3dyDz6OJyZGbVvVNrZKJFxiPhi5f4fJXRhsolz8odCLahocqDW/0f6PVmgcs0ee90nzWlnupjXpQwnVS0F147wnZ6X3BMSeUkeOLZFO4nL1m6wpegoijHVgST0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199015)(6486002)(38100700002)(2906002)(31686004)(2616005)(6636002)(54906003)(316002)(53546011)(41300700001)(66556008)(6666004)(66946007)(5660300002)(4326008)(26005)(66476007)(8676002)(83380400001)(7406005)(7416002)(186003)(6512007)(6506007)(8936002)(110136005)(478600001)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWkza25QdzJYWXA0UTJySUdyZDN2RTRSM01VdldxN28reW5oaGtFREdoQkpH?=
 =?utf-8?B?ZjhKb2hhK3BscHR5d0lvT3EyMmU3b0lwbVd3YVVsSFAzTDNWVnhsbzdudy94?=
 =?utf-8?B?OVNoQ2x6RUFmYXRBWUVoRWx5cWRad0g2OWlqY1dqZC9RR3QzeVpmc2RDQVNX?=
 =?utf-8?B?eFNPS25ESFEzRXZYVjVMUTZ3S3FGMzA1OVl4ckQ3QXhXQi9yZzJ0VWRDd2Fm?=
 =?utf-8?B?b1Vib2xWZjdxSVFqT3NjOE1ZUXpIOGZRY3dQemJmOVF1RmJCTVlnd1RHMURi?=
 =?utf-8?B?aURSS2c3VGphVEYvcjZPekR2MWlDb2ZXSmY0eUc2UkhMd0MrOHA4WVQycjUz?=
 =?utf-8?B?Z0VlalhnTE5TeXJVQjVONkhHYStXNTd6SFRrSVVLZUZ1QzB3NTQzWUhHbGZo?=
 =?utf-8?B?NktmZDVzdXE5NThIMnFyU1N1VXM2N2MrKzgydjdGSmhod2xEY2VYZ2JvQUpO?=
 =?utf-8?B?U1I0VkhONjVrd3N1QzExK0FHRUZRMUdTaWozT0Y0WCszMEFmTFhDclBSbUVG?=
 =?utf-8?B?K0VqZFJzSkhOU2ZDTW9TRU1EWEJRcS90Q2RwM2NUZ0sxVEdBWXJlajNaL3Yx?=
 =?utf-8?B?ZEptWU50NmFvY1R0WjJCL0FUc2U2ZHRubXFXVW8rR0pYa2FhdzVuVmtZa3lo?=
 =?utf-8?B?QWQyQzZOdGtnc3B1RWZZMndkdVFzc3UvczFEKzBrZVRkV25NRjl2WG13eXFC?=
 =?utf-8?B?OFhrUHI4NWtsdmZSOHpRQWZkSlUvR2tOeUNOK0p5VXpZS3U1YmMvMXRnSTY2?=
 =?utf-8?B?aTlKYkNGQzAzeXZZSDljUzE4bjltdDBZeE5hdlZFUXEyS25zNzVCYXRJSUta?=
 =?utf-8?B?eW5kdzQ3RHlvUzRSMXQvQ1pVbStBZFBQa3llMUJweWg1akN4RkdVY3ljaWFV?=
 =?utf-8?B?NGxVVCt4TDRvbkREYnl1QUYwZ2loMTdlaFlvMmpkVXBmeGJJRXFXdXh2T3k3?=
 =?utf-8?B?aDFXUUxDSUtVN3R1K1lyZFhJWU9xYlBkcTNSUjlseDVIejJDT2tiSVp5a21U?=
 =?utf-8?B?WnJLeVdMOFVaNnV0Sy9sZTE0OWdTamhMalU5NDZwRVNCSnpXWDczSGRVR0NL?=
 =?utf-8?B?c0tOb05OUXczdWRWL2piVUVibTZtTE5GMlowTE83RUN3dmxGL3ZlanUyYlZ4?=
 =?utf-8?B?L3lFQnpKZGJCRlB2UnljQjJpS2w4eENlZmdtdmNuN3NYUEpEVHh1RU4vb05r?=
 =?utf-8?B?UEpDL29IRERzK0xLQlUyL01MMGJUWGFFd1drMkwydS8rd1J6anlGNDZmYjFZ?=
 =?utf-8?B?bklMQVRGK0c0OHVrT01JbURJQVhwVzFmZTgyWnJJdk5BUUxZZEtxTkowaHM0?=
 =?utf-8?B?dE5sOUFOQVovTUZaQmlaaDdPamxJS0RVVk5WRWowcU4zTi83RkxFZmQvSXhM?=
 =?utf-8?B?YWN2N0lDWWVtYWhyY0NFN1A1RXd2dnNXVUZYR0UwWHd3K0RGbklrdU1LOEZ5?=
 =?utf-8?B?TWZSWldwSEl1L0VkTlRjM005ZW5OQUw5a1lhZmJIbWtLOE5aNGdCbTRRelpQ?=
 =?utf-8?B?OE5ETytleTI0RFI5cE1hVFczdlVQdW1vcW1HUmlJWk12eHJBQlNsSndsRnpn?=
 =?utf-8?B?VXFpRmd3d0o4QlRpRVVXbVBLYm1JdkR3Q2VJSXREWDdIUWwrU2hIR01UcTAr?=
 =?utf-8?B?MHZRSTlILy9BQktLcFNGczhPL3NkbURIUlpGOFhzRTFRRFRqY2FGYkFmWkJj?=
 =?utf-8?B?aFFWZWNSZkQ4SkdYN1Q5MDk4Z1MydkNWVDVreGlhd29HZjl4ajN5N2pRRnlW?=
 =?utf-8?B?Zml4cmJDVCs2VmswYmpaNXNQcDgzeDlIaGZoUXZ6MGtyb0tSeFNlUDcxYXEy?=
 =?utf-8?B?NmdDTitPTVNadkhlRExIM3BDUXdUSGlyeGU3aWxwbFAwNUUyc2wzOUF6VFVk?=
 =?utf-8?B?ekFRNFR4eDdNL3BNT09zbjZyWUtMSHpLK3NnSi9nYldoMFREUTRtRWZlNGhh?=
 =?utf-8?B?Zm0yZjhNYWRJSFVvcXdMWUJVMEpSZzFJbGxSOEpJMkJtVnE4NFJrRXBhQ2Zi?=
 =?utf-8?B?d3QydVN3S09DSkZsZkZ3TjBLZ0RkWDVwbjlvMUcxRFZPYUQvOXlVcUFja0Vy?=
 =?utf-8?B?OTBXTXhjM0Y4WmQ1b1p0bzdObGRvdnQ1aGZCaVZVZzQwZit5Z2lzUVRxMkp6?=
 =?utf-8?Q?wNXKwkXVaUwAJE2TZrbjDcvIv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85267bdd-0bdf-4333-40fc-08daef75ce03
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 23:37:27.4909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DdbeNcS+0iUuIkkfJ1HpQ2Vpi5eQ9mKfnbAFAVCe8Ab9kef7yBm+/03OsfX4qjBQ78C5nn2eo8uV3BKO3kodRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5328
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Jarkko,

On 12/31/2022 8:27 AM, Jarkko Sakkinen wrote:
> On Wed, Dec 14, 2022 at 01:40:29PM -0600, Michael Roth wrote:
>>   static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   {
>>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> @@ -260,13 +279,23 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   		return ret;
>>   
>>   	sev->active = true;
>> -	sev->es_active = argp->id == KVM_SEV_ES_INIT;
>> +	sev->es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
>> +	sev->snp_active = argp->id == KVM_SEV_SNP_INIT;
>>   	asid = sev_asid_new(sev);
>>   	if (asid < 0)
>>   		goto e_no_asid;
>>   	sev->asid = asid;
>>   
>> -	ret = sev_platform_init(&argp->error);
>> +	if (sev->snp_active) {
>> +		ret = verify_snp_init_flags(kvm, argp);
>> +		if (ret)
>> +			goto e_free;
>> +
>> +		ret = sev_snp_init(&argp->error, false);
>> +	} else {
>> +		ret = sev_platform_init(&argp->error);
>> +	}
> 
> Couldn't sev_snp_init() and sev_platform_init() be called unconditionally
> in order?
> 
> Since there is a hardware constraint that SNP init needs to always happen
> before platform init, shouldn't SNP init happen as part of
> __sev_platform_init_locked() instead?
> 

On Genoa there is currently an issue that if we do an SNP_INIT before an 
SEV_INIT and then attempt to launch a SEV guest that may fail, so we 
need to keep SNP INIT and SEV INIT separate.

We need to provide a way to run (existing) SEV guests on a system that 
supports SNP without doing an SNP_INIT at all.

This is done using psp_init_on_probe parameter of the CCP module to 
avoid doing either SNP/SEV firmware initialization during module load 
and then defer the firmware initialization till someone launches a guest 
of one flavor or the other.

And then sev_guest_init() does either SNP or SEV firmware init depending 
on the type of the guest being launched.

> I found these call sites for __sev_platform_init_locked(), none of which
> follow the correct call order:
> 
> * sev_guest_init()

As explained above, this call site is important for deferring the 
firmware initialization to an actual guest launch.

> * sev_ioctl_do_pek_csr
> * sev_ioctl_do_pdh_export()
> * sev_ioctl_do_pek_import()
> * sev_ioctl_do_pek_pdh_gen()
> * sev_pci_init()
> 
> For me it looks like a bit flakky API use to have sev_snp_init() as an API
> call.
> 
> I would suggest to make SNP init internal to the ccp driver and take care
> of the correct orchestration over there.
>

Due to Genoa issue, we may still need SNP init and SEV init to be 
invoked separately outside the CCP driver.

> Also, how it currently works in this patch set, if the firmware did not
> load correctly, SNP init halts the whole system. The version check needs
> to be in all call paths.
> 

Yes, i agree with that.

Thanks,
Ashish
