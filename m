Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BF735733F
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 19:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354880AbhDGRfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 13:35:15 -0400
Received: from mail-bn8nam11on2088.outbound.protection.outlook.com ([40.107.236.88]:1633
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232356AbhDGRfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 13:35:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Puywi4zQl8RuNLKBt2qlbbsjw+cSj3DHdxmiqidInhQWmlh9R6dws2TO+sMKwYNlrKefLNKJV/BPfiDU0+xSNmmXg1qpq1QwWeGaP35Aw5rB2JgIfyzpklprG5we23vkBkJjur07cU34q+RDDZyvU7FRQWrcRABNV12ZZ8s7/qQ+mCc8IxJdFGBswEifBFwTKdpcyTGYtDQo+Je+46hmATy11WUsrpnKMIEcOvRXjEM+axu31KuH8Hl/1uAEwXUug+x6aeZvhLIMCdPk7hNKsGytlvqRPpCS9WBoFxKgh26kg9GpFjvb+u8N2eNjirFXjjVXwJsOVm45TWGCuUYtaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OCpHBOrlF8w+/LhjtumUIw+Kz8ym8G8WIufrTbeKA0=;
 b=ADhjd5549z7Ky7KtxotIwfdvL/h95Jxu0FMUYmFQw5vq+6Bg03KrSYWsGUd6IWNx6vQGwVq5plM8AcuetTBeP6zl8+q87MjJPfscN1DUOMbf1frmta/cXAcup3N8aKFr4YmSfD2BtHxhV23vaJBuwQd3scuDAYmBrpydcI21M5IvjusGdlwa6Z75gf6ca7yjnzsZxlQtyk5nNtFK1lxbEw7H0SjXZCgyiS/uFjf0nbyGL0Q6xwPUOzRc8cAdFumjVKT7G9tHHbjevCU+7CNEsszIUhg8zqCddifYAsDYSkbRAGd2ntGljQSYIS84IijTivkmqb8YaPagRumYkkwXVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OCpHBOrlF8w+/LhjtumUIw+Kz8ym8G8WIufrTbeKA0=;
 b=nj5xHmliNoNuZv57W3hRtlEPZpHqulgs23vPhycao62dRfPSxjIOTO5Z/L9uXsZH1zO1fiah8lBcAUai6LALbPbPpOL+2H2ZsNTNYaACpQPrToMSBrMK/KixosUsHCAPzkHuey0wW9uQwfjet02p5daosFqypAHWmF81+5ytJiY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4672.namprd12.prod.outlook.com (2603:10b6:805:12::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Wed, 7 Apr
 2021 17:35:02 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.017; Wed, 7 Apr 2021
 17:35:02 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 07/13] x86/compressed: register GHCB memory when
 SNP is active
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-8-brijesh.singh@amd.com>
 <20210407115959.GC25319@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <2453bacb-dce3-a9c2-f506-7dae7796ab7e@amd.com>
Date:   Wed, 7 Apr 2021 12:34:59 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210407115959.GC25319@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR11CA0091.namprd11.prod.outlook.com
 (2603:10b6:806:d1::6) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0091.namprd11.prod.outlook.com (2603:10b6:806:d1::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 17:35:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afef49a1-a264-4dcf-4d4b-08d8f9eb791d
X-MS-TrafficTypeDiagnostic: SN6PR12MB4672:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB46722E793120A4D99FE2D26FE5759@SN6PR12MB4672.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5y0CQnbs9RUkCrpfQMIT5KIxf8z1DRwwCCbnilljxKMmijdsumDvIF+L8srxNHYgkLiWy0m6NduXWw4Nue3ljYThdWOVUqOoK2Eis8T6kJ+sszHkDvSYwh7Gm6VODw0G3LQXbae9c67AnARZ0o+d6ZylJhzwyBWoAkkmDZVrggNTy5hyGKo/nvrYvJ9OShuCH/gfx2xdP0tkOKsAYlM5ljZnswwPgtsbxrRvdl0Dr+rw0e9bJ9UZRVqgdb7l4UJFUQB14YlZQjWsiKni2nywEXtMr1ixeOMqsLemTc9g4Adly4jSNNZeYhxOn5LmFsY33aHRUB5Zf6DzV4ocbcKbr0RQ+Gh/AK7Tc9qAuTuq1ZH77U8WTjfXqvfIQXwPWdOaxfsTMKBUK4HrmmgD+whsV/SJq7+kGzXTVBq/sjQCewALp14xXDCWhjh8N2QqTY6ORDb3dzO09TkiHiXMNsTfUtmRs2+CQFIdnKLlzb3s3g41OOXZBNZa1X6pz6aoU/543AJtIO+swQaBKuJ9loEDWmsCsLooFOlvJfds7Ep/ReKDQOXgC1w9aTExNhJop7tPl6ep7a+VK0CzBcjcmWEJY284i8YO0JkqKpGHYI5qOgEgaE2wvr00Qlm+onbC3bHej0D8Mcm8gmt8BJ+gmyuGNNnD2BgIp9tB4bezuuApXCoaN7/FlSS0EoJCSjIRqVw+uR3hzZ+tNDP5MtaItx8PeaFGkEFe4x+jBM9RFLfTC8hrBew90wz0OIDL2Z1Wu6WG2y7MgW4QZ+OZHseo1mh34tEbstZTxG4ts5GLkj2TU49eKNExCcJC8zHYAsoQvMw7ev7Nmwga02It4Q/olMA+Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(38350700001)(956004)(2616005)(83380400001)(8676002)(966005)(45080400002)(4326008)(8936002)(52116002)(478600001)(31686004)(5660300002)(53546011)(54906003)(316002)(186003)(16526019)(6486002)(36756003)(38100700001)(2906002)(26005)(86362001)(6916009)(66476007)(6512007)(7416002)(31696002)(66946007)(44832011)(66556008)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RWhRMHY5U0c1R0N5bXAzMDJNTi82elYzVFFOeWhpck9pRzFzZFowV29jQTgw?=
 =?utf-8?B?NHhzZUx6ekV6Y2dtM01GU2IzN2o4VXpaVFhTYzFOMGUyaFlKbXh0QW5zZWI2?=
 =?utf-8?B?RDNFZTh2YmEyTEJZdWVabGE4N2NyL2UrNmdNZ2JNeTJ0TitPUi8vMkJFbXUy?=
 =?utf-8?B?N0VxcTAwcWFPOFZ6Q2ZCa2JObVI2WmxRY205VlNnbHQ3Sm1IczB3ODBzWTVS?=
 =?utf-8?B?b1ZWTkUwK3FOcjMwS0xPRHhnN3hXSUJiZ01MQmRFckM3SmJLS1RiRDljdStY?=
 =?utf-8?B?dVhmbXdwMGtJbmxqZXRSdmJGK0IzZWxiUnhmMk1mWEhSWHVrVUFxcmxDYjZP?=
 =?utf-8?B?eEVBODg5WS9IdEgrUkxBUFVNWC90ckE5TTc1bnBtZ2thaHQ1d0NRczExYkV1?=
 =?utf-8?B?K2NFcFVyYVZkL0JWRmF1R3B5Mm5mMGFXa1pXWmI3ZFYxUFVmMDc4cVV6cDhI?=
 =?utf-8?B?WVV6S1FiWlMrRGRjRm5JVHhTU0pSSUpHa2paVld1RmFMSzNaUW8vWEl2KzVk?=
 =?utf-8?B?ZnlpQzZWSFdkSzIyenhnTWx2Rm93VEJXZmJmQ0JMTCtEb0JNeGZGMVZtMDND?=
 =?utf-8?B?WE1razBlMWxlb0Q1ZCttTnh4WlpvZXdMSEtEbzdJYm1VeTB3RUhXV3AxTmdh?=
 =?utf-8?B?RC9uMTNOSXVuamowWDhJNEVXS3dKVTM4UjQ5SnBOMnBNVjlpdU5IbjlnUnkv?=
 =?utf-8?B?YzZycDJWN0pHQWVPaXAvS3QvQ3BXaTFySjd5MGFmYUlTbm5WK0xHV1FnVEM5?=
 =?utf-8?B?RXB0L0dUMUdsWFBqRy9NT05wMXRUWEVacHJOdzJPc1ViOFdsQnhTSGxoaVJE?=
 =?utf-8?B?MGhUTUZacG9ObllvSUFwQ3kwZGwvTy9VNE1neVNQOGVkZURYWEFLQy94UnEz?=
 =?utf-8?B?d2QxMk05cTBzd1pyQmkxT0tDeFErMlVxTEgxVWJvcXpIQytCRGVwWU9vZ0Fk?=
 =?utf-8?B?Um0vU1pNR20xemFzemQ3MXYzdTNzYUFKeHl6Ymh5eFRUMEVKeTFLTFQxa0lx?=
 =?utf-8?B?K1pVMFllWWRDcEh0RncvYm5qM2d4eko4WHlYajdSSElKUkJXTUlBdXBHYWdu?=
 =?utf-8?B?WWt1ZzNtZlpTZ0FTbkpHdTV5WHlBaU0rNlpxNzhDeVpZc2wyM3ZUR0ZOeFRK?=
 =?utf-8?B?S1RrUk5hWW44ZlBES3dsdHpUUS9vdnRNSFczQUV3aGxMUENPLzhlWEhZREJh?=
 =?utf-8?B?WGdFVVlKaEF5ZCt3dHYvQWdtZjFPVklhalArdDRlTTdlMWlETVFuMnZ0VU1N?=
 =?utf-8?B?RjZnQmNlRFpZanhTamE1Q0NQS0ZEQUU2WlgwYm9Ja0dqanhDSk9VeTBjWGxu?=
 =?utf-8?B?djFqVkU1cWY3VGdOSldhbVRWTGZaeUFhbzUrY2ZIT2wrR1FibEZzK0lyT2sx?=
 =?utf-8?B?NXlyZUJmVVdEYlMyRmZONXNEV0MwN2xEeXc3N2txNnQ0SU1vbCttV3d6MUdC?=
 =?utf-8?B?alFvbWFwVko0R3ZlbmhPMGpXUHRRQ0JHZFpKM2FIOG5iOHNNUVVKOUVMLzdo?=
 =?utf-8?B?TGo2WWpzeTNtazI0T0tZSTl3L01SSU0reVBJbWlhSzVRN2xFNE5oRjhpUEs2?=
 =?utf-8?B?VGVKdHlBTUg4VUZDbTVSVnBsYWw5WitxSG5kS1BlNk9JZnpZSkc3Z2d3YjE1?=
 =?utf-8?B?Ymg5UERCMDlSdkMvaHgzOFI4M3BPZ09NN1VLakNnTEN1NmRtTmNUWWFOZ05x?=
 =?utf-8?B?SXZpNUxCaDNMelJNcC9ERHEvZGZCMFAxcjVEUkJFK2lwdjBxNkMzSDNuMHNh?=
 =?utf-8?Q?xgbD/LYVeytURS2ucggfvwzPuG4E9K0rOKyAaxr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afef49a1-a264-4dcf-4d4b-08d8f9eb791d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 17:35:01.9588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjCmFLSsb9ys/DF+2fW6tNI+HRBQLs+F5S7Ij0QwVhf6LEb6uxYnQhmkeXYgeSIQTE1A4JsDLpuQkAH3B+04JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4672
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/7/21 6:59 AM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 11:44:18AM -0500, Brijesh Singh wrote:
>> The SEV-SNP guest is required to perform GHCB GPA registration. This is
> Why does it need to do that? Some additional security so as to not allow
> changing the GHCB once it is established?
>
> I'm guessing that's enforced by the SNP fw and we cannot do that
> retroactively for SEV...? Because it sounds like a nice little thing we
> could do additionally.

The feature is part of the GHCB version 2 and is enforced by the
hypervisor. I guess it can be extended for the ES. Since this feature
was not available in GHCB version 1 (base ES) so it should be presented
as an optional for the ES ?


>
>> because the hypervisor may prefer that a guest use a consistent and/or
>> specific GPA for the GHCB associated with a vCPU. For more information,
>> see the GHCB specification section 2.5.2.
> I think you mean
>
> "2.3.2 GHCB GPA Registration"
>
> Please use the section name too because that doc changes from time to
> time.
>
> Also, you probably should update it here:
>
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7Ce8ae7574ecc742be6c1a08d8f9bcac94%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637533936070042328%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=NaHJ5R9Dfo%2FPnci%2B%2B6xK9ecpV0%2F%2FYbsdGl25%2BFj3TaU%3D&amp;reserved=0
>

Yes, the section may have changed since I wrote the description. Noted.
I will refer the section name.


>> diff --git a/arch/x86/boot/compressed/sev-snp.c b/arch/x86/boot/compressed/sev-snp.c
>> index 5c25103b0df1..a4c5e85699a7 100644
>> --- a/arch/x86/boot/compressed/sev-snp.c
>> +++ b/arch/x86/boot/compressed/sev-snp.c
>> @@ -113,3 +113,29 @@ void sev_snp_set_page_shared(unsigned long paddr)
>>  {
>>  	sev_snp_set_page_private_shared(paddr, SNP_PAGE_STATE_SHARED);
>>  }
>> +
>> +void sev_snp_register_ghcb(unsigned long paddr)
> Right and let's prefix SNP-specific functions with "snp_" only so that
> it is clear which is wcich when looking at the code.
>
>> +{
>> +	u64 pfn = paddr >> PAGE_SHIFT;
>> +	u64 old, val;
>> +
>> +	if (!sev_snp_enabled())
>> +		return;
>> +
>> +	/* save the old GHCB MSR */
>> +	old = sev_es_rd_ghcb_msr();
>> +
>> +	/* Issue VMGEXIT */
> No need for that comment.
>
>> +	sev_es_wr_ghcb_msr(GHCB_REGISTER_GPA_REQ_VAL(pfn));
>> +	VMGEXIT();
>> +
>> +	val = sev_es_rd_ghcb_msr();
>> +
>> +	/* If the response GPA is not ours then abort the guest */
>> +	if ((GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_REGISTER_GPA_RESP) ||
>> +	    (GHCB_REGISTER_GPA_RESP_VAL(val) != pfn))
>> +		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
> Yet another example where using a specific termination reason could help
> with debugging guests. Looking at the GHCB spec, I hope GHCBData[23:16]
> is big enough for all reasons. I'm sure it can be extended ofc ...


Maybe we can request the GHCB version 3 to add the extended error code.


> :-)
>
>> +	/* Restore the GHCB MSR value */
>> +	sev_es_wr_ghcb_msr(old);
>> +}
>> diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
>> index f514dad276f2..0523eb21abd7 100644
>> --- a/arch/x86/include/asm/sev-snp.h
>> +++ b/arch/x86/include/asm/sev-snp.h
>> @@ -56,6 +56,13 @@ struct __packed snp_page_state_change {
>>  	struct snp_page_state_entry entry[SNP_PAGE_STATE_CHANGE_MAX_ENTRY];
>>  };
>>  
>> +/* GHCB GPA register */
>> +#define GHCB_REGISTER_GPA_REQ	0x012UL
>> +#define		GHCB_REGISTER_GPA_REQ_VAL(v)		(GHCB_REGISTER_GPA_REQ | ((v) << 12))
>> +
>> +#define GHCB_REGISTER_GPA_RESP	0x013UL
> Let's append "UL" to the other request numbers for consistency.
>
> Thx.
>
