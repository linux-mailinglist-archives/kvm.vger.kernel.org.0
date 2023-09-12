Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEB479D6E2
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 18:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbjILQxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 12:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237115AbjILQxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 12:53:48 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2086.outbound.protection.outlook.com [40.107.96.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17D3115;
        Tue, 12 Sep 2023 09:53:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrTjc1FFq6Ikzsqkzchjdeyp/7ynBba7KFU2p1KbYMGWpHUMkfSKMn7yqNUfmx6l+V5yRbhu3O5XC3klVsac86IWCjcLeKVatIRdQxRl/Xcy0YBmi4j/k3oKACprRaOF3vYGkR7KHf1giEsSDxeNb7T/IWWId3ExhlDJ2ET8pf7GlhAAtvuMCkBEMKLLyg/HkYoPl1dpIC+IS/JkEcLHa9Da5t6svp1BFW9z76ijn2+eiJtDnhW8T+Tulc0r8mysLJMDGhzaQi0Nwhq4mhlUxJwjnvB4bqrqjASpjq39GetjbQLyl/W0eO5UBe+Rf3gYGMV30/kqdAI778DBOlGMDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwY7U95yNI3tulsoI5UVXmH/FgeVYiGGzFerU/YjC4g=;
 b=QJ9GShwb1EcojaM4O9P64JAJXGuty3v1h++VkMABs8hPaLvUFUisFE+K1fB1II2izI+pNs87s4Lc4OMAxNrNtWk5nsMrpC4dfjLi0FZ58IJRufCEnBVRTOdZzN+aL7HzNld6BSRQDlk1eVxh8EmALFNSLCAZ/qaPwRLAYW2d1567XnqxtvSpJNHWjVfJdaKKb7jCVP2GFbrDvelkIHriMapnmHIMYZCkItZpCSg+A2HQZyjJtiwepWaJD5mqvO+JcijmrfI7cXscDv2Da1uispPEObauBt0sWbjJWWi85M+i0BMZivjOUJSH+Prt9e7/q6Nk1/lDeiueFn+AHrCXsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwY7U95yNI3tulsoI5UVXmH/FgeVYiGGzFerU/YjC4g=;
 b=tlWq8SDYPy/WBVJpYQ/myhBdrF23uC+i1JeAd1JA+7YsYiUYqspMN0IUU783zX4V4U0X24NSN7jou1GvryCsB4gmYQapdOXJ8ZhdsC6dVBizdIhp7+0Gm3eSFCH1je66XdWVqIx0j3YHrAkiHV4lSUziO4/BHQeAlSL1QjWTymk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB6208.namprd12.prod.outlook.com (2603:10b6:8:a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Tue, 12 Sep
 2023 16:53:42 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6768.029; Tue, 12 Sep 2023
 16:53:42 +0000
Message-ID: <56e5da1b-bed2-f935-d8c4-9c3013897621@amd.com>
Date:   Tue, 12 Sep 2023 09:53:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] KVM: x86: Fix lapic timer interrupt lost after loading a
 snapshot.
Content-Language: en-US
To:     Haitao Shan <hshan@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230912161518.199484-1-hshan@google.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230912161518.199484-1-hshan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0254.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::19) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB6208:EE_
X-MS-Office365-Filtering-Correlation-Id: ba4b1977-1aee-4f8d-d1cf-08dbb3b0d1f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +BkqGisqdb0RfKjv9VXtksd+ArvxJKDvzBtZ0n399axpjbPXlP53fBmks9U3fdW70jUegc11kS6SaRCsiKB2NrEV2joNG5ib7Kh4AmJ3/AAV1uF0Ca1Hcm+PLZyseSnErNFjyefTpYt3ElkjBzUr213zyOpAdjOQhTEedQgfM/i29gVK5zK06nWhy+bVrDsIasaxkpSKEiUFqkVkXMROcuctueU8yiUEiUw8f5eitUH80pJUkwvghf71ubW4l6/0brGEAvNIAxK3/lBhptet+CNsCpZjjaaeuq2DCLS9dISf8Z7+1spkUouSMKMPvCQ4uLj4pltmcZenWQrOHITgko8F2fywtiWs52PR03XBm3waOpKdOKehEP5MZfaTDQDNpKqEAmhnBMnGX/av95RtDSVGHMBHUZiRMei4vVlyle/eVZUX6LoLjTEIyKCzGLN3onpEn/J/GhWnZ1D305xIjqtvQ1VWiBJb9ypNWQrcWg5sxDQB4WnDz/mAC14IHu0olt3ADq6nD/5L8Zk+4SU++Ct67AU1lcvClYplSkHhckwM4oBBQArUBYAlNfQeDuQdwf3aWbRg3RqFfJgvr8f4Xf6etxsaJkoYVcGMxNHpzKvmVMX3v+JgHI5ESL75o9Ox2b7uBXdYWjlySmGRCX44Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(346002)(136003)(39860400002)(1800799009)(451199024)(186009)(6666004)(26005)(478600001)(6486002)(2616005)(31686004)(110136005)(83380400001)(38100700002)(66556008)(54906003)(66476007)(6506007)(53546011)(66946007)(6512007)(7416002)(316002)(8936002)(8676002)(41300700001)(2906002)(31696002)(4326008)(5660300002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlJreU9tdm5PaUp6M2xaRXlER3h1TzJmM1N5U09CdHZOZW9GZ1J0bmRBaE1q?=
 =?utf-8?B?ZnRjZmk5Q1NNZnNoaU9QRnpNTmJyLzdJR1N1TUdJbzJpdzFZNGMwbTRDTzRL?=
 =?utf-8?B?VVdJK2hGZTZFWDNzQTB2d3o4WUxJNjNDVzViVnNQdFgrYVI5TW1DOTJsWGk2?=
 =?utf-8?B?aWVGVlNQVkJrWWVCZG1yR0VBMGYzeWdwZTFUZVVyT2hreXdHc3RKZHJFME9F?=
 =?utf-8?B?V2xlamFkUzZwWmdNeUZRS1Ayai91djk1di9DazN5WlNiaStHNitlaXFmYi9G?=
 =?utf-8?B?S1FHbUJZQkdMcnhjNE9obzhXKzJoOEZjZWVKT2t6eGNaSGdOS2lhV1Z0c1l3?=
 =?utf-8?B?RHl6QXZtNVFYY1hNdCtDb0NwNHN0b2NSVGR5emNSNHpnRllZeVhkQVY3dGR6?=
 =?utf-8?B?QTVYbnBMZWRsdjJUbjZmbjNrdlVmNVIydnN4YTJncm01eXhvdzU4RHVmeDhU?=
 =?utf-8?B?VWpPbUxENmVSZE9FbzBEZG13SEhiK2kzSWl6VEROaWx4UXJSMmZNT1A3a3FI?=
 =?utf-8?B?NnBXMXkvc0F3TDJDTnRPdGQrcmU4bTBQWTNtNmx1eVlGd0daT2E2NTRRM25V?=
 =?utf-8?B?L0NSMGZESFpzM3dQYmRKZTBkRm5hTDFoZnhoc01GcmVhRGk1Wk1iV2pidEg4?=
 =?utf-8?B?RVVRcFJWamlZY2Fxcm1xcTJXZ2V1TnRiQ2lSMUxXcWhkOHlzSWJmRk5IcVdC?=
 =?utf-8?B?YnNRSVlKYjgzTkxJd0RSWkJndDFTT09HeGhNMFJwYXgwSklEMEV6Z3VjejA3?=
 =?utf-8?B?ZVBTN05qRmxGWXY1T2JLcFV5UXB3azlLYWNkUjE4ckpxdXdPQjVKd2JMWGFo?=
 =?utf-8?B?QzlweTUyNUxkL1VseUNjQnZpOUY0N1ZnMnF6cjdJR0NjNEtKbTYrWU5aN1Ux?=
 =?utf-8?B?dG9DekdWOGh5cjhtbUU2d0FEOEl3S2Q3dmpCanNpb0VPcWZkTnlxNlMrMXNT?=
 =?utf-8?B?UWJDZ2hjUVA5ZW5Hais2OEYzd1dyRlRhWG8vTnd0czVXRUVNNEdXUW1BMDlW?=
 =?utf-8?B?Sy9UVGFsOUY3TWVkdy9BMzZnWndhaTFYTjA2N0FRL3lFTmQ1TnlpVlNOZW1F?=
 =?utf-8?B?VXhFVFRyMWt2Z2o4T0Jac3kydzI4aUV3U0tzSDBXWkVzQTJzeDNJREtRMkxq?=
 =?utf-8?B?UFBrdUxvU2xFWHNsNHRLR3FqSUpGR1g4VTl6R2pxd3krTFFWUHYzWmhNWCsw?=
 =?utf-8?B?OFh1VndMbnRHRVdZVDBIZ1ZCSDBpTFBZbXhkd0g5QWhqTU1yS3Z2cldKYVR4?=
 =?utf-8?B?NU80NFJxRVo4YnpWdFVXckhONWEzT3dMVE8vNVhMWGRrb1VEakw5V1hxNTIz?=
 =?utf-8?B?Vjd2NnE4UlhRL0xDUzkwbFg1QlpVdlY2Z2k4TU1VQUkwaDZOaHB6NnlTKzNt?=
 =?utf-8?B?aGZCNVhyMUIxUHZBVGYwTkRNVVhyR2p5OFViMjJraUM1RVlpUjhKc25YRkpZ?=
 =?utf-8?B?Uk1UNlhreWJGWDFhRHFrRUdrdlhKRzBFY2JqWmdqeGlDWXZ6cmtQU3AvSEVX?=
 =?utf-8?B?YzhpM2U4WVRwb2pjOFFEbUZycmZPTWc5ak5YcXZnMVBRaFpzTW00ZUw1RGs3?=
 =?utf-8?B?U2lkK3VVelpFQXdBQk50dmlJREF0K1hncnNsRnR1bHhHUTc3TWVOK2xEOUhw?=
 =?utf-8?B?VkZsWmplb1FWN3VQSzZjUCt2OXlqNWEyb285YjcycS95MTQxbDdxN3lpemJ0?=
 =?utf-8?B?cklJZmxQd1dXbUwxRFVxd0pyQ3RIS0w4QnpjNnpBRm16NzA3T0R6REdZTXAx?=
 =?utf-8?B?c3doNW9CRkxSTDY4SkQvTjJHeDROS1Rqc0xYVmJpdlZzZFR6V2NLYlRRT2x6?=
 =?utf-8?B?K3ltZnZMMTVWOFUxQUxDRzYraDZzd2hnN1FIM21GTjhlSithREZSL24rMndI?=
 =?utf-8?B?U3F3NVZjNXJ1TGtmNTlraGl3OTljWDVmcTJPaHF1STY3VGFYc25DTTFpczlh?=
 =?utf-8?B?em1ucVcvN2YrRXk4NWxCU1VlNkdYUS9uY2d3NEh5MS84bXNKcXNiNzd3TWtU?=
 =?utf-8?B?N1hLSGNZUE5yQlVHeEk4MTErT2dtdkgvbjh3MFRtKzFrbHFHZ09WMjRqaE8y?=
 =?utf-8?B?aThFSWJsNUhyOWpLQ0srZjU0TEFJeGYrc015U1hraHg0djJyT1VBa0c1Y1c1?=
 =?utf-8?Q?X8RfXQYVdnmIfKNUN5/QmY4bO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4b1977-1aee-4f8d-d1cf-08dbb3b0d1f9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 16:53:42.2627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w7q0V9e7OrrD+XV1ACbYhiU7RwK3OsVqtEhenLS+IVfVrWTGwJENqrVjFg6+muwzgijHqUoQTz6T3oT+rTjtVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6208
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/12/2023 9:15 AM, Haitao Shan wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> This issue exists in kernel version 6.3-rc1 or above. The issue is
> introduced by the commit 8e6ed96cdd50 ("KVM: x86: fire timer when it is
> migrated and expired, and in oneshot mode"). The issue occurs on Intel
> platform which APIC virtualization and posted interrupt processing.
> 
> The issue is first discovered when running the Android Emulator which
> is based on QEMU 2.12. I can reproduce the issue with QEMU 8.0.4 in
> Debian 12.
> 
> With the above commit, the timer gets fired immediately inside the
> KVM_SET_LAPIC call when loading the snapshot. On such Intel platforms,
> this eventually leads to setting the corresponding PIR bit. However,
> the whole PIR bits get cleared later in the same KVM_SET_LAPIC call.
> Missing lapic timer interrupt freeze the guest kernel.
> 

Should there be a "Fixes" tag here with the problematic commit?

Thanks,

Brett

> Signed-off-by: Haitao Shan <hshan@google.com>
> ---
>   arch/x86/kvm/lapic.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index a983a16163b1..6f73406b875a 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2977,14 +2977,14 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>          apic_update_lvtt(apic);
>          apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>          update_divide_count(apic);
> -       __start_apic_timer(apic, APIC_TMCCT);
> -       kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
>          kvm_apic_update_apicv(vcpu);
>          if (apic->apicv_active) {
>                  static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
>                  static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
>                  static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
>          }
> +       __start_apic_timer(apic, APIC_TMCCT);
> +       kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
>          kvm_make_request(KVM_REQ_EVENT, vcpu);
>          if (ioapic_in_kernel(vcpu->kvm))
>                  kvm_rtc_eoi_tracking_restore_one(vcpu);
> --
> 2.42.0.283.g2d96d420d3-goog
> 
